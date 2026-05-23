#requires -Module HelpOut

Import-Module ../GitPub.psd1

Save-MarkdownHelp -Module GitPub -PassThru -OutputPath (
    $PSScriptRoot | Split-Path
)

