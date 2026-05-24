function Get-GitPubIssue {

    <#
    .SYNOPSIS
        Gets GitHub Issues
    .DESCRIPTION
        Gets GitHub Issues as Posts.
        
        By default, will get closed issues with the label 'post'.
    .EXAMPLE
        Get-GitPubIssue -UserName StartAutomating -Repository PipeScript
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

    # The issue state.  Can be open, closed, or all
    [ValidateSet('open','closed','all')]
    [string]
    $IssueState = 'closed',
    
    # The issue label.
    [string[]]
    $IssueLabel = 'post',

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

        $queryString = @(
            if ($IssueState) {
                "state=$($issueState.ToLower())"
            }
            if ($IssueLabel) {
                "labels=$($IssueLabel -join ',')"
            }
            'per_page=100'
        )

        $issuesUrl = 
            'https://api.github.com/repos/',
                $UserName,'/',$repository,
                '/issues?',(
                    $queryString -join '&'
                ) -join ''
        
        #endregion Prepare url

        #region Cache Query and Output
        # Create a cache if it does not exist
        if (-not $script:Cache) {$script:Cache = [Ordered]@{}}
        
        # If -Force is set, remove the gists url from the cache
        if ($Force) {$script:Cache.Remove($issuesUrl)}

        if (-not $script:Cache[$issuesUrl]) {
            $script:Cache[$issuesUrl] = Invoke-RestMethod $issuesUrl @invokeSplat

            foreach ($issue in $script:Cache[$issuesUrl]) {
                $tags = 
                    @(foreach ($label in $issue.Labels) {
                        if ($label.name -notin $IssueLabel) {
                            $label.name
                        }
                    })
                $issue | Add-Member NoteProperty PostTag $tags
                $issue.pstypenames.clear()
                $issue.pstypenames.add('GitPub.Post.Issue')
                $issue.pstypenames.add('GitPub.Post')
            }
        }
        
        $script:Cache[$issuesUrl]
        #endregion Cache Query and Output
    }
}
