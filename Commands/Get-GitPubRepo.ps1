function Get-GitPubRepo {

    <#
    .SYNOPSIS
        Gets GitHub Repositories
    .DESCRIPTION
        Gets a GitHub Repos as a post.
    .EXAMPLE
        # If used interactive and the gh cli is installed
        # gets the current repository
        Get-GitPubRepo 
    .EXAMPLE
        Get-GitPubRepo "PoshWeb/GitPub"
    .EXAMPLE
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
    [Alias('Owner','Org','Organization')]
    [string]
    $UserName,

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
        #endregion owner repo format flexibility         

        $reposUri = 
            'https://api.github.com/repos/',
                $UserName,'/',$repository -join ''
        
        #endregion Prepare url

        #region Cache Query and Output
        # Create a cache if it does not exist
        if (-not $script:Cache) {$script:Cache = [Ordered]@{}}
        
        # If -Force is set, remove the gists url from the cache
        if ($Force) {$script:Cache.Remove($reposUri)}

        if (-not $script:Cache[$reposUri]) {
            $script:Cache[$reposUri] = Invoke-RestMethod $reposUri @invokeSplat

            foreach ($repo in $script:Cache[$reposUri]) {
                $tags = $repo.Topics                    
                $repo | Add-Member NoteProperty PostTag $tags
                $repo.pstypenames.clear()
                $repo.pstypenames.add('GitPub.Post.Repo')
                $repo.pstypenames.add('GitPub.Post')
            }
        }
        
        $script:Cache[$reposUri]
        #endregion Cache Query and Output
    }
}
