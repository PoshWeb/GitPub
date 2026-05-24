function Get-GitPubGist {
    <#
    .SYNOPSIS
        Gets GitHub Gists
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

        $gistsUrl = 
            if ($userName) {
                'https://api.github.com/users/',$username,'/gists' -join ''
            } else {
                'https://api.github.com/gists'
            }

        # Create a cache if it does not exist
        if (-not $script:Cache) {$script:Cache = [Ordered]@{}}
        
        # If -Force is set, remove the gists url from the cache
        if ($Force) {$script:Cache.Remove($gistsUrl)}

        # If we do not have a cached result,
        if (-not $script:Cache[$gistsUrl]) {
            # get the url
            $script:Cache[$gistsUrl] = Invoke-RestMethod $gistsUrl @invokeSplat
            # and decorate any returned results.
            foreach ($gist in $script:Cache[$gistsUrl]) {
                $gist.pstypenames.clear()
                $gist.pstypenames.add('GitPub.Post.Gist')
                $gist.pstypenames.add('GitPub.Post')
            }
        }
        
        # Output any cached result for this url.
        $script:Cache[$gistsUrl]
    }
}

