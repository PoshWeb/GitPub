#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubWorkflow



New-GitHubWorkflow -Name "Analyze, Test, Tag, and Publish" -On Push, PullRequest, Demand -Job PowerShellStaticAnalysis, TestPowerShellOnLinux, TagReleaseAndPublish, BuildGitPub -Environment @{
    NoCoverage = $true
} -OutputPath (
    $PSScriptRoot |
        Split-Path | 
        Join-Path -ChildPath '.github' |
        Join-Path -ChildPath 'workflows' |
        Join-Path -ChildPath 'TestAndPublish.yml'
)