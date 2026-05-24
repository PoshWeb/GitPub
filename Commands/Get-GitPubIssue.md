Get-GitPubIssue
---------------

### Synopsis
Gets GitHub Issues as Posts

---

### Description

Gets GitHub Issues as Posts.

By default, will get closed issues with the label 'post'.

---

### Examples
> EXAMPLE 1

```PowerShell
Get-GitPubIssue -UserName StartAutomating -Repository PipeScript
```

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

#### **IssueState**
The issue state.  Can be open, closed, or all
Valid Values:

* open
* closed
* all

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |3       |false        |

#### **IssueLabel**
The issue label.

|Type        |Required|Position|PipelineInput|
|------------|--------|--------|-------------|
|`[String[]]`|false   |4       |false        |

#### **GitHubAccessToken**
The GitHub Access token.
If this is not provided, $env:GITHUB_TOKEN is present, $env:GITHUB_TOKEN will be used.

|Type      |Required|Position|PipelineInput|Aliases                                  |
|----------|--------|--------|-------------|-----------------------------------------|
|`[String]`|false   |5       |false        |PersonalAccessToken<br/>GitHubPat<br/>PAT|

---

### Syntax
```PowerShell
Get-GitPubIssue [[-UserName] <String>] [-Repository] <String> [[-IssueState] <String>] [[-IssueLabel] <String[]>] [[-GitHubAccessToken] <String>] [<CommonParameters>]
```
