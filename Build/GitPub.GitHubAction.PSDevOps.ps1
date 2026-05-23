#requires -Module PSDevOps
#requires -Module GitPub
Import-BuildStep -ModuleName GitPub
New-GitHubAction -Name "usegitpub" -Description 'Easily Automate Publishing from GitHub' -Action GitPubAction -Icon rss  -ActionOutput ([Ordered]@{
    GitPubScriptRuntime = [Ordered]@{
        description = "The time it took the .GitPubScript parameter to run"
        value = '${{steps.GitPubAction.outputs.GitPubScriptRuntime}}'
    }
    GitPubPS1Runtime = [Ordered]@{
        description = "The time it took all .GitPub.ps1 files to run"
        value = '${{steps.GitPubAction.outputs.GitPubPS1Runtime}}'
    }
    GitPubPS1Files = [Ordered]@{
        description = "The .GitPub.ps1 files that were run (separated by semicolons)"
        value = '${{steps.GitPubAction.outputs.GitPubPS1Files}}'
    }
    GitPubPS1Count = [Ordered]@{
        description = "The number of .GitPub.ps1 files that were run"
        value = '${{steps.GitPubAction.outputs.GitPubPS1Count}}'
    }
}) |
    Set-Content .\action.yml -Encoding UTF8 -PassThru
