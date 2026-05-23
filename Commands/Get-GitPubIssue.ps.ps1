function Get-GitPubIssue
{
    <#
    .SYNOPSIS
        Gets GitHub Issues as Posts
    .DESCRIPTION
        Gets GitHub Issues as Posts.
        
        By default, will get closed issues with the label 'post'.
    .EXAMPLE
        Get-GitPubIssue -UserName StartAutomating -Repository PipeScript
    #>
    [Reflection.AssemblyMetaData("GitPub.Source",$true)]        
    param(
    # The GitHub Username or Organization.          
    [Alias('Owner')]
    [string]
    $UserName,

    # The repository
    [Parameter(Mandatory)]
    [Alias('Repo')]
    [string]
    $Repository,

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
    $GitHubAccessToken
    )

    process {
        $invokeSplat = @{
            Headers = @{}            
        }

        if (-not $GitHubAccessToken -and $env:GITHUB_TOKEN) {
            $GitHubAccessToken = $env:GITHUB_TOKEN
        }

        if ($GitHubAccessToken) {
            $invokeSplat.Headers.Authentication = "Bearer $gitHubAccessToken"
        }

        if ($Repository -like '*/*' -and -not $UserName) {
            $UserName, $Repository = $Repository -split '\/', 2
        }

        if (-not $UserName) {
            Write-Error "Must Provide -UserName or provide -Repository in the form username / repository"
            return
        }

        $queryString = @(
            if ($IssueState) {
                "state=$($issueState.ToLower())"
            }
            if ($IssueLabel) {
                "labels=$($IssueLabel -join ',')"
            }
            'per_page=100'            
        ) -join '&'

        $issues =
            https://api.github.com/repos/$UserName/$repository/issues?$queryString @invokeSplat

        foreach ($iss in $issues) {
            $tags = 
                @(foreach ($label in $iss.Labels) {
                    if ($label.name -notin $IssueLabel) {
                        $label.name
                    }
                })
            $iss | Add-Member NoteProperty PostTag $tags
            [decorate('GitPub.Post.Issue',Clear)]$iss
            [decorate('GitPub.Post',PassThru)]$iss            
        }
    }
}
