Get-GitPubRepo
--------------

### Synopsis
Gets GitHub Repositories

---

### Description

Gets a GitHub Repos as a post.

---

### Examples
If used interactive and the gh cli is installed
gets the current repository

```PowerShell
Get-GitPubRepo
```
> EXAMPLE 2

```PowerShell
Get-GitPubRepo "PoshWeb/GitPub"
```
> EXAMPLE 3

---

### Parameters
#### **Repository**
The repository
If we are running in a GitHub workflow
$end:GITHUB_REPOSITORY should be the workflow
Otherwise, if we have the github cli
we can try to use repo view to view the current repo

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |1       |false        |Repo   |

#### **UserName**
The GitHub Username or Organization.

|Type      |Required|Position|PipelineInput|Aliases                       |
|----------|--------|--------|-------------|------------------------------|
|`[String]`|false   |2       |false        |Owner<br/>Org<br/>Organization|

#### **GitHubAccessToken**
The GitHub Access token.
If this is not provided, $env:GITHUB_TOKEN is present, $env:GITHUB_TOKEN will be used.

|Type      |Required|Position|PipelineInput|Aliases                                  |
|----------|--------|--------|-------------|-----------------------------------------|
|`[String]`|false   |3       |false        |PersonalAccessToken<br/>GitHubPat<br/>PAT|

#### **Force**
If set, will refresh cached results

|Type      |Required|Position|PipelineInput|Aliases     |
|----------|--------|--------|-------------|------------|
|`[Switch]`|false   |named   |false        |RefreshCache|

---

### Syntax
```PowerShell
Get-GitPubRepo [[-Repository] <String>] [[-UserName] <String>] [[-GitHubAccessToken] <String>] [-Force] [<CommonParameters>]
```
