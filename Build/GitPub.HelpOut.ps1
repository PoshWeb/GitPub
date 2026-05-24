#requires -Module HelpOut

$importedModule = Import-Module (
    $PSScriptRoot | 
    Split-Path | 
    Join-Path -ChildPath 'GitPub.psd1'
) -PassThru

Save-MarkdownHelp -Module GitPub -PassThru -OutputPath (
    $PSScriptRoot | Split-Path
) |
    Foreach-Object {
        $fileInfo = $_
        $relatedCommand = $null
        $RelatedCommand = $importedModule.ExportedCommands[
            $fileInfo.Name -replace '\.md$'
        ]
        
        if ($relatedCommand) {
            $relatedCommandFile =
                if ($relatedCommand.ScriptBlock.File) {
                    $relatedCommand.ScriptBlock.File                 
                } elseif ($relatedCommand.ResolvedCommand.ScriptBlock.File) {
                    $relatedCommand.ResolvedCommand.ScriptBlock.File
                }
            
            if (-not $relatedCommandFile) { return $fileInfo }

            $relatedCommandFile = $relatedCommandFile |
                Split-Path |
                Join-Path -ChildPath $fileInfo.Name

            Move-Item -PassThru -LiteralPath $fileInfo.FullName -Destination $relatedCommandFile
        }        
    }
