function Get-GitPubGist
{
    <#
    .SYNOPSIS
        Gets GitHub Gists as Posts
    .DESCRIPTION
        Gets GitHub Gists as Posts.            
    .EXAMPLE
        Get-GitPubGist -UserName StartAutomating
    #>
    [Reflection.AssemblyMetaData("GitPub.Source", "true")]
    param(
    # The GitHub Username or Organization.      
    [Parameter(Mandatory)]
    [string]
    $UserName,

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

        $gists =
            if ($userName) {
                https://api.github.com/users/$username/gists @invokeSplat
            } else {
                https://api.github.com/gists @invokeSplat
            }
            
        
        foreach ($g in $gists) {
            [decorate('GitPub.Post.Gist',Clear)]$g
            [decorate('GitPub.Post',PassThru)]$g            
        }
    }
}
