#requires -Module HelpOut

Import-Module (
    $PSScriptRoot | 
    Split-Path | 
    Join-Path -ChildPath 'GitPub.psd1'
)

Save-MarkdownHelp -Module GitPub -PassThru -OutputPath (
    $PSScriptRoot | Split-Path
)

