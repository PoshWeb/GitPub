Get-GitPubGist
--------------

### Synopsis
Gets GitHub Gists as Posts

---

### Description

Gets GitHub Gists as Posts.

---

### Examples
> EXAMPLE 1

```PowerShell
Get-GitPubGist -UserName StartAutomating
```

---

### Parameters
#### **UserName**
The GitHub Username or Organization.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|true    |1       |false        |

#### **GitHubAccessToken**
The GitHub Access token.
If this is not provided, $env:GITHUB_TOKEN is present, $env:GITHUB_TOKEN will be used.

|Type      |Required|Position|PipelineInput|Aliases                                  |
|----------|--------|--------|-------------|-----------------------------------------|
|`[String]`|false   |2       |false        |PersonalAccessToken<br/>GitHubPat<br/>PAT|

---

### Syntax
```PowerShell
Get-GitPubGist [-UserName] <String> [[-GitHubAccessToken] <String>] [<CommonParameters>]
```
