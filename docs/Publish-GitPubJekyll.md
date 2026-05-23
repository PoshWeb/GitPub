Publish-GitPubJekyll
--------------------

### Synopsis
Publishes content as Jekyll Posts

---

### Description

Publishes content as Jekyll Posts.

---

### Related Links
* [Get-GitPub](Get-GitPub.md)

* [Publish-GitPub](Publish-GitPub.md)

---

### Examples
> EXAMPLE 1

```PowerShell
Get-GitPubIssue -Repository GitPub -Owner StartAutomating |
    Publish-GitPubJekyll
```

---

### Parameters
#### **PostTitle**
The title of the post.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |1       |true (ByPropertyName)|Title  |

#### **PostBody**
The body of the post.

|Type      |Required|Position|PipelineInput        |Aliases|
|----------|--------|--------|---------------------|-------|
|`[String]`|true    |2       |true (ByPropertyName)|Body   |

#### **PostCreationTime**
The time the post was created.

|Type        |Required|Position|PipelineInput        |Aliases                    |
|------------|--------|--------|---------------------|---------------------------|
|`[DateTime]`|true    |3       |true (ByPropertyName)|Created_At<br/>CreationTime|

#### **PostAuthor**
The author of the post

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |4       |true (ByPropertyName)|

#### **PostTag**
One or more tags used for the post

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |5       |true (ByPropertyName)|Tags   |

#### **PostLayout**
The layout used for a post.

|Type      |Required|Position|PipelineInput        |
|----------|--------|--------|---------------------|
|`[String]`|false   |6       |true (ByPropertyName)|

#### **SourceUrl**
The source URL.  If provided, this will be included in front matter.

|Type      |Required|Position|PipelineInput        |Aliases |
|----------|--------|--------|---------------------|--------|
|`[String]`|false   |7       |true (ByPropertyName)|HTML_url|

#### **NoSummary**
If not set, will summarize all posts in a given year, month, and day.
This will generate a file for each unique year, year/month, day combination
and will give them the appropriate permalinks.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **NoFeed**
If set, will not generate a feed.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[Switch]`|false   |named   |false        |

#### **FeedName**
The name of the RSS feed file to generate.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |8       |false        |

#### **FeedTemplate**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |9       |false        |

#### **YearlySummary**
The content used for a yearly summary

|Type      |Required|Position|PipelineInput|Aliases      |
|----------|--------|--------|-------------|-------------|
|`[String]`|false   |10      |false        |AnnualSummary|

#### **YearlySummaryExtension**

Valid Values:

* md
* html

|Type      |Required|Position|PipelineInput|Aliases                                                               |
|----------|--------|--------|-------------|----------------------------------------------------------------------|
|`[String]`|false   |11      |false        |YearlySummaryFormat<br/>AnnualSummaryFormat<br/>AnnualSummaryExtension|

#### **MonthlySummary**

|Type      |Required|Position|PipelineInput|Aliases     |
|----------|--------|--------|-------------|------------|
|`[String]`|false   |12      |false        |MonthSummary|

#### **MonthlySummaryExtension**

|Type      |Required|Position|PipelineInput|Aliases                                                              |
|----------|--------|--------|-------------|---------------------------------------------------------------------|
|`[String]`|false   |13      |false        |MonthlySummaryFormat<br/>MonthSummaryFormat<br/>MonthSummaryExtension|

#### **DailySummary**

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |14      |false        |

#### **DailySummaryExtension**

|Type      |Required|Position|PipelineInput|Aliases                                                        |
|----------|--------|--------|-------------|---------------------------------------------------------------|
|`[String]`|false   |15      |false        |DailySummaryFormat<br/>DaySummaryFormat<br/>DaySummaryExtension|

#### **OutputPath**
The output path.  If not provided, will output to _posts in the current directory.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |16      |false        |

---

### Syntax
```PowerShell
Publish-GitPubJekyll [-PostTitle] <String> [-PostBody] <String> [-PostCreationTime] <DateTime> [[-PostAuthor] <String>] [[-PostTag] <String[]>] [[-PostLayout] <String>] [[-SourceUrl] <String>] [-NoSummary] [-NoFeed] [[-FeedName] <String>] [[-FeedTemplate] <String>] [[-YearlySummary] <String>] [[-YearlySummaryExtension] <String>] [[-MonthlySummary] <String>] [[-MonthlySummaryExtension] <String>] [[-DailySummary] <String>] [[-DailySummaryExtension] <String>] [[-OutputPath] <String>] [<CommonParameters>]
```
