function Publish-GitPub
{
    <#
    .SYNOPSIS
        Publishes content with GitPub
    .DESCRIPTION
        Collects content from all valid sources and publishes it with all valid publishers.
    .LINK
        Get-GitPub        
    .EXAMPLE
        Publish-GitPub 
    #>
    param(
    [Parameter(ValueFromPipelineByPropertyName)]
    [Alias('Parameters')]    
    $Parameter
    )
    
    process {
        $gitPub = Get-GitPub

        if ($env:GITHUB_WORKSPACE) {
            "::group::Publish-GitPub Parameters" | Out-Host
            $Parameter | Format-Custom | Out-Host
            "::endgroup::" | Out-Host                        
        }
        
        $gitPubSourceInfo = 
            foreach ($source in $gitPub.Sources) {
                if (-not $Parameter.($source.Name)) { continue }
                $sourceParamSets = @($Parameter.($source.Name))
                foreach ($sourceParam in $sourceParamSets) {

                    if ($sourceParam -isnot [Collections.IDictionary]) {
                        $sourceParamDict = [Ordered]@{}
                        foreach ($prop in $sourceParam.psobject.properties) {
                            $sourceParamDict[$prop.Name] = $prop.Value
                        }
                        $sourceParam = $sourceParamDict
                    }
                    
                    try {
                        & $source @sourceParam
                    } catch {
                        $err = $_
                        Write-Error "Could not run source '$source': $($err.Message)"
                    }
                }
            }
            
        $wasPublished = $false
        foreach ($publisher in $gitPub.Publishers) {
            if (-not ($Parameter.$($publisher.Name))) { continue }
            $publishParamSets = @($Parameter.($publisher.Name))
            foreach ($publishParam in $publishParamSets) {
                if ($publishParam -isnot [Collections.IDictionary]) {
                    $publishParamDict = [Ordered]@{}
                    foreach ($prop in $publishParam.psobject.properties) {
                        $publishParamDict[$prop.Name] = $prop.Value
                    }
                    $publishParam = $publishParamDict
                }
                $wasPublished = $true
                try {
                    $gitPubSourceInfo | & $publisher @publishParam
                } catch {
                    $err = $_
                    Write-Error "Could not run publisher '$publisher': $($err.Message) @ $($err.ScriptStackTrace)"
                }
            }
        }

        if (-not $wasPublished) {
            Write-Warning "No parameters were provided to publishers"
        }
    }
}
