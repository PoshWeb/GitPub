function Get-GitPubRelease {

    <#
    .SYNOPSIS
        Gets GitHub Releases as Posts
    .DESCRIPTION
        Gets GitHub Releases as Posts.

        The release content will be considered the body of the post.
    #>
    [Reflection.AssemblyMetaData("GitPub.Source",$true)]        
    param(    
    # The repository    
    [Alias('Repo')]
    [string]
    $Repository = $(
        # If we are running in a GitHub workflow
        # $end:GITHUB_REPOSITORY should be the workflow
        if ($env:GITHUB_REPOSITORY) {
            $env:GITHUB_REPOSITORY
        } elseif (
            # Otherwise, if we have the github cli
            $ExecutionContext.SessionState.InvokeCommand.GetCommand('gh', 'Application')
        ) {
            # we can try to use repo view to view the current repo
            try {
                gh repo view --json nameWithOwner | 
                    ConvertFrom-Json | 
                    Select-Object -ExpandProperty nameWithOwner
            } catch {
                throw $_
            }
        }
    ),

    # The GitHub Username or Organization.          
    [Alias('Owner')]
    [string]
    $UserName,    

    # One or more tags used for releases.
    # By default, `release`.
    [string[]]
    $ReleaseTag = 'release',

    # The GitHub Access token.
    # If this is not provided, $env:GITHUB_TOKEN is present, $env:GITHUB_TOKEN will be used.
    [Alias('PersonalAccessToken','GitHubPat', 'PAT')]
    [string]
    $GitHubAccessToken,

    # If set, will refresh cached results
    [Alias('RefreshCache')]
    [switch]
    $Force
    )

    process {
        #region Prepare headers
        $invokeSplat = @{Headers = @{}}

        if (-not $GitHubAccessToken -and $env:GITHUB_TOKEN) {
            $GitHubAccessToken = $env:GITHUB_TOKEN
        }

        if ($GitHubAccessToken) {
            $invokeSplat.Headers.Authentication = "Bearer $gitHubAccessToken"
        }
        #endregion Prepare headers

        #region Prepare url

        #region owner repo format flexibility 
        
        # Accept owner/repo format (in all potential forms)

        # If the username is like `*/*`
        if ($userName -like '*/*' -and -not $Repository) {
            # set the repo
            $null, $repository = $UserName -split '/', 2
        }
        
        # If the repo is like `*/*` 
        if ($Repository -like '*/*' -and -not $userName) {
            # set the username.
            $userName, $null = $Repository -split '/', 2
        }

        # If the repo is like `*/*`
        if ($Repository -like '*/*'){
            # fix it
            $null, $Repository = $Repository -split '/', 2
        }

        # IF the username is like `*/*`
        if ($userName -like '*/*'){ 
            # fix it
            $userName, $null = $UserName -split '/', 2
        }

        # If there is no repository,
        if (-not $Repository) {
            # error out.
            Write-Error "No -Repository provided"
            return
        }

        if (-not $UserName) {
            Write-Error "Must Provide -UserName or provide -Repository in the form username/repository"
            return
        }


        $releasesUrl = 
            'https://api.github.com/repos/',
                $UserName,'/',$repository,
                    '/releases',
                        '?per_page=100' -join ''
        #endregion Prepare url
        
        #region Cache Query and Output
        # Create a cache if it does not exist
        if (-not $script:Cache) {$script:Cache = [Ordered]@{}}
        
        # If -Force is set, remove the gists url from the cache
        if ($Force) { $script:Cache.Remove($releasesUrl)}

        if (-not $script:Cache[$releasesUrl]) {
            $script:Cache[$releasesUrl] = Invoke-RestMethod $releasesUrl @invokeSplat
            foreach ($release in $script:Cache[$releasesUrl]) {
                $release | Add-Member NoteProperty 'Tags' @($ReleaseTag) -Force
                $release.pstypenames.clear()
                $release.pstypenames.add('GitPub.Post.Release')
                $release.pstypenames.add('GitPub.Post')
                $release
            }
        }
        $script:Cache[$releasesUrl]
        #endregion Cache Query and Output
    }
}

