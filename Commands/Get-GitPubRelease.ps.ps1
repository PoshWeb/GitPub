function Get-GitPubRelease
{
    <#
    .SYNOPSIS
        Gets GitHub Releases as Posts
    .DESCRIPTION
        Gets GitHub Releases as Posts.

        The release content will be considered the body of the post.
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

    # One or more tags used for releases.
    # By default, `release`.
    [string[]]
    $ReleaseTag = 'release',

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
            Write-Error "Must Provide -UserName or provide -Repository in the form username/repository"
            return
        }

        
        $releases =
            https://api.github.com/repos/$UserName/$repository/releases @invokeSplat

        foreach ($rel in $releases) {
            $rel | Add-Member NoteProperty 'Tags' @($ReleaseTag) -Force
            [decorate('GitPub.Post.Release',Clear)]$rel
            [decorate('GitPub.Post',PassThru)]$rel       
        }
    }
}
