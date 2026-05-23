## GitPub 0.1.5:

* Publish-GitPubJekyll:
  * Adding RSS Feed (Fixes #57)
  * Fixing Summaries (Fixes #56)

---

## GitPub 0.1.4

* Publish-GitPub: Improved publishing error behavior (Fixes #48)
* Get-GitPubIssue/Get-GitPubRelease:  Linking issues (Fixes #47)
* Publish-GitPubJekyll:
  * Improving Date Handling (Fixes #51)
  * Allowing more filenames (Fixes #52)
* Providing RunGitPub Job Definition (Fixes #53)

---


## GitPub 0.1.3

* Publish-GitPubJekyll will generate summary pages unless -NoSummary is passed.
* GitPub's GitHub Page Now Uses Permalink: pretty

---


## GitPub 0.1.2

* Fixing GitHub Action Issues:
  * Will not push to TargetBranch when not on a branch (#33)
* Get-GitPubIssue/Get-GitPubRelease:
  * UserName is now optional (#32)
* Publish-GitPubJekyll:
  * Including SourceURL in front matter (#34)

---

## GitPub 0.1.1

* Fixing GitHub Action Issues:
  * TargetBranch was not pushing upstream (#21)
  * Action Required Different Name from Repo (#22)
* Publish-GitPub fixes:
  * Publish parameters now correctly mapped (#20)
* Publish-GitPubJekyll:
  * Inlcuding .PostTitle in FrontMatter (#18)
* Selfhosting Action (#19)

---

## GitPub 0.1

Introducing GitPub: Easily Automate Publishing from GitHub

See [https://gitpub.start-automating.com/2022/10/09/Introducing-GitPub.html](the first post)


GitPub provides a flexible way to publish content in a GitHub workflow.

GitPub can be extended with Sources and Publishers.

### GitPub Sources

A source is a function that provides content to post.  GitPub comes with three sources:

|Source|Function|Description|
|-|-|-|
|Gist       | Get-GitPubGist         | Turns gists into posts      |
|Issue     | Get-GitPubIssue       | Turns issues into posts    |
|Release | Get-GitPubRelease   | Turns releases into posts |

~~~PowerShell
Get-GitPub |
    Select-Object -ExpandProperty Sources
~~~

### GitPub Publishers

A publisher is a function that finalizes content and publishes it.  GitPub comes with one publisher:

|Source|Function|Description|
|-|-|-|
|Jeykll    | Publish-GitPubJeykll | Publishes content to _posts directories    |

---
