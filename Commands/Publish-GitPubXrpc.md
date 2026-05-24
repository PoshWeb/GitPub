Publish-GitPubXrpc
------------------

### Synopsis
Publishes from GitPub to Xrpc

---

### Description

Publishes content from GitPub to xrpc

---

### Parameters
#### **ArgumentList**
Any unbound arguments

|Type          |Required|Position|PipelineInput|
|--------------|--------|--------|-------------|
|`[PSObject[]]`|false   |named   |false        |

#### **InputObject**
The input object

|Type          |Required|Position|PipelineInput |
|--------------|--------|--------|--------------|
|`[PSObject[]]`|false   |named   |true (ByValue)|

#### **XrpcPath**
The path used to store xrpc
This will be a child path of the current directory or the -OutputPath.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **OutputPath**
The output path.  If not provided, this will be the current directory.

|Type      |Required|Position|PipelineInput|
|----------|--------|--------|-------------|
|`[String]`|false   |named   |false        |

#### **XrpcTypes**
A lookup table containing:
* A TypeName
* A Namespace Identifier

|Type           |Required|Position|PipelineInput|
|---------------|--------|--------|-------------|
|`[IDictionary]`|false   |named   |false        |

#### **WhatIf**
-WhatIf is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-WhatIf is used to see what would happen, or return operations without executing them
#### **Confirm**
-Confirm is an automatic variable that is created when a command has ```[CmdletBinding(SupportsShouldProcess)]```.
-Confirm is used to -Confirm each operation.

If you pass ```-Confirm:$false``` you will not be prompted.

If the command sets a ```[ConfirmImpact("Medium")]``` which is lower than ```$confirmImpactPreference```, you will not be prompted unless -Confirm is passed.

---

### Syntax
```PowerShell
Publish-GitPubXrpc [-ArgumentList <PSObject[]>] [-InputObject <PSObject[]>] [-XrpcPath <String>] [-OutputPath <String>] [-XrpcTypes <IDictionary>] [-WhatIf] [-Confirm] [<CommonParameters>]
```
