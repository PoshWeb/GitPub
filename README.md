<div align='center'>
<img src='assets/GitPub.svg' />
</div>

# Introducing GitPub

GitPub is a GitHub Action and PowerShell Module that helps Easily Automate Publishing from GitHub.

## What does GitPub do?

GitPub gives you a flexible framework for converting content (primarily from GitHub) into published content.

For example, you can turn GitHub issues that match a certain label into Jeykll posts within a GitHub Page.

You might be reading output from GitPub that way right now.  This post started as [this GitHub issue](https://github.com/StartAutomating/GitPub/issues/1).

Publishing this way makes for a more virtuous cycle when working with GitHub.

If you write high quality issues or release notes, you can share them with the world without breaking a sweat.

## Using GitPub

You can use GitPub as a GitHub Action or as a PowerShell Module.

### Using the GitPub module

You can install GitPub from the PowerShell Gallery, or download a release from [github](https://github.com/StartAutomating/GitPub):

~~~PowerShell
Install-Module GitPub -Scope CurrentUser -Force
Import-Module GitPub -Force -PassThru
~~~

## How GitPub Works

GitPub works using the simple concepts of Sources and Publishers.


### GitPub Sources

Sources can provide content to publish.

GitPub is written so that you can write your own sources easily.

Any function that adds `[Reflection.AssemblyMetadata('GitPub.Source','true')]` will be considered a source.

GitPub ships with the following sources:


|Name                                               |
|---------------------------------------------------|
|[Get-GitPubGist](Commands/Get-GitPubGist.ps1)      |
|[Get-GitPubIssue](Commands/Get-GitPubIssue.ps1)    |
|[Get-GitPubRelease](Commands/Get-GitPubRelease.ps1)|




### GitPub Publishers

Any function that adds `[Reflection.AssemblyMetadata('GitPub.Publisher','true')]` will be considered a publisher.


|Table|
|-----|
||


