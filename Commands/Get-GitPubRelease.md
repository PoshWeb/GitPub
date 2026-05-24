Get-GitPubRelease
-----------------

### Synopsis
Gets GitHub Releases as Posts

---

### Description

Gets GitHub Releases as Posts.

The release content will be considered the body of the post.

---

### Parameters
#### **UserName**
The GitHub Username or Organization.

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|false   |1       |false        |Owner  |

#### **Repository**
The repository

|Type      |Required|Position|PipelineInput|Aliases|
|----------|--------|--------|-------------|-------|
|`[String]`|true    |2       |false        |Repo   |

#### **ReleaseTag**
One or more tags used for releases.
By default, `release`.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |3       |false        |

#### **GitHubAccessToken**
The GitHub Access token.
If this is not provided, $env:GITHUB_TOKEN is present, $env:GITHUB_TOKEN will be used.

|Type      |Required|Position|PipelineInput|Aliases                                  |
|----------|--------|--------|-------------|-----------------------------------------|
|`[String]`|false   |4       |false        |PersonalAccessToken<br/>GitHubPat<br/>PAT|

---

### Syntax
```PowerShell
Get-GitPubRelease [[-UserName] <String>] [-Repository] <String> [[-ReleaseTag] <String[]>] [[-GitHubAccessToken] <String>] [<CommonParameters>]
```
