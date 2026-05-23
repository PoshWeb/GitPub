@{
    "runs-on" = "ubuntu-latest"    
    if = '${{ success() }}'
    steps = @(
        @{
            name = 'Check out repository'
            uses = 'actions/checkout@main'
        }, 
        @{    
            name = 'Use PSSVG Action'
            uses = 'StartAutomating/PSSVG@main'
            id = 'PSSVG'
        },        
        'RunPipeScript',
        'RunEZOut',       
        'RunHelpOut',
        @{
            name = 'Use GitPub Action'
            uses = './'
            id  = 'GitPub'
            with = @{
                PublishParameters = @"
{
    "Get-GitPubIssue": {
        "Repository": '`${{github.repository}}'
    },
    "Get-GitPubRelease": {
        "Repository": '`${{github.repository}}'        
    }
}
"@
            }
        }
    )
}