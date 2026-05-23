function Get-GitPub {

    <#
    .SYNOPSIS
        Gets GitPub        
    .DESCRIPTION
        Gets GitPub.
        
        Returns the version and currently loaded Publishers and Sources.
    .EXAMPLE
        Get-GitPub
    .LINK
        Publish-GitPub
    #>
    param()
    
    [PSCustomObject][Ordered]@{
        PSTypeName = 'GitPub'
        Version    = $MyInvocation.MyCommand.Module.Version
        Commands   = 
            $executionContext.SessionState.InvokeCommand.GetCommands(
                '*GitPub*','Function,Alias',$true
            )
    }
}