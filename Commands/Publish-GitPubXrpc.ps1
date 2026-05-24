function Publish-GitPubXrpc {
    <#
    .SYNOPSIS
        Publishes from GitPub to Xrpc
    .DESCRIPTION
        Publishes content from GitPub to xrpc
    #>
    [CmdletBinding(
        PositionalBinding=$false,
        SupportsShouldProcess
    )]
    param(
    # Any unbound arguments
    [Parameter(ValueFromRemainingArguments)]
    [PSObject[]]
    $ArgumentList,

    # The input object
    [Parameter(ValueFromPipeline)]
    [PSObject[]]
    $InputObject,

    # The path used to store xrpc
    # This will be a child path of the current directory or the -OutputPath.
    [string]
    $XrpcPath = "xrpc",

    # The output path.  If not provided, this will be the current directory.
    [string]
    $OutputPath,

    <#
    
    A lookup table containing:
    * A TypeName
    * A Namespace Identifier
    #> 
    [Collections.IDictionary]
    $XrpcTypes = $([Ordered]@{
        'GitPub.Post.Issue' = 'com.github.api.repo.issues'
        'GitPub.Post.Release' = 'com.github.api.repo.releases'
        'GitPub.Post.Gist' = 'com.github.api.user.gists'
    })
    )
    
    # Collect all of our piped input
    $allInput = @($input)
    # If input was not piped
    if (-not $allInput) {
        # use the named parameter
        $allInput = $inputObject
    }

    $allInput = @($allInput | . { process { $_ }})

    # Create a dictionary to store our xrpc
    $xrpcBuckets = [Collections.Generic.Dictionary[
        string, [Collections.Generic.List[Object]]
    ]]::new([StringComparer]::InvariantCultureIgnoreCase)
    
    # Go over each input
    foreach ($in in $allInput) {
        # and each typename of that input.
        foreach ($typeName in $in.pstypenames) {
            # if we do not have an xrpc type for that typename
            if (-not $XrpcTypes[$typeName]) {
                continue # keep moving.
            }

            # Otherwise, get the nsid
            $nsid = $XrpcTypes[$typeName]
            # and create a new bucket if needed.
            if (-not $xrpcBuckets[$nsid]) {
                $xrpcBuckets[$nsid] = [Collections.Generic.List[Object]]::new()
            }
            # Then put our input into the right bucket.
            $null = $xrpcBuckets[$nsid].Add($in)            
        }
    }

    # Now that we've got the right buckets, time to save them.

    # Let's determine our xrpc path
    $xrpcPath = 
        if ($OutputPath) {
            Join-Path $OutputPath $XrpcPath
        } else {
            Join-Path $pwd $XrpcPath
        }

    # Each bucket will go in it's own folder beneath this path
    foreach ($nsid in $xrpcBuckets.Keys) {
        # in a file named `$xrpcPath/$nsid/index.json`
        $nsidPath = Join-Path $XrpcPath $nsid |
            Join-Path -ChildPath "index.json"
        
        # and construct parameters to `New-Item`
        $newFile = [Ordered]@{
            Path = "$nsidPath"
            ItemType = 'File'
            Value = ConvertTo-Json -InputObject $xrpcBuckets[$nsid] -Depth 10
            Force = $true
        }
        # If `-WhatIf` was passed
        if ($WhatIfPreference) {
            # output the parameters
            $newFile
            continue 
        }
        # otherwise, confirm if needed
        if ($psCmdlet.ShouldProcess("Create $nsidPath")) {
            # and write the file, explicitly confirming false
            # (since we just confirmed)
            New-Item @newFile -Confirm:$false
        }
    }
}