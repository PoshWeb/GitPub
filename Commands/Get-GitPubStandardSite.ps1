function Get-GitPubStandardSite {
    [Alias('Get-GitPubSiteStandard')]
    param(
    [Alias('DectralizedIdentifier')]
    [string]
    $Did,

    [Alias('PersonalDataServer')]
    [string]
    $PDS = "https://bsky.social/"
    )

    filter getAt {
        <#
        .SYNOPSIS
            Gets at records
        .DESCRIPTION
            Gets records from the at protocol.
        .EXAMPLE
            Get-OpenPackage at://mrpowershell.com/app.bsky.actor.profile     
        #>
        param(
        # Who [did](https://atproto.com/specs/did) (decentralized identifier)
        [Parameter(Mandatory)]
        [Alias('DectralizedIdentifier')]
        [string]
        $did,

        # What collection or type
        [string]
        $collection = 'site.standard.document',

        # How many items to get in each batch.
        # By default, 100.
        [ValidateRange(1,100)]
        [int]
        $BatchSize = 100,

        # If provided, will only get N items.
        [long]
        $First,

        # If provided, will skip N items.
        [long]
        $Skip,

        # The PDS (Personal Data Server).
        [string]
        $pds = "https://bsky.social/",

        # Any additional headers to pass into a web request. 
        [Alias('Header')]
        [Collections.IDictionary]
        $Headers
        )

        $atPattern = 'at://(?<did>[^/]+)/(?<type>[^/]+)(?:/(?<rkey>.+?$))?'

        $total = [long]0
        $skipped = [long]0
        $cursor = ''
        $progress = [Ordered]@{Id = Get-Random}
        $progress.Status = "Getting records"
        :AtSync do {    
            $xrpcUrl = "$(
                # Be fault tolerant with the pds format
                if ($pds -like 'https://*') {
                    # just trim trailing slashes from https urls
                    $pds -replace '/$'
                } else {
                    # and prefix anything else by https://
                    "https://$pds" -replace '/$'
                }
            )/xrpc/com.atproto.repo.listRecords?repo=$(
                $did
            )&collection=$(
                $collection
            )&limit=$BatchSize&cursor=$Cursor"
            $progress.Activity = "$total "
            Write-Progress @progress
            # Get the page of records
            $results = try {
                if ($Headers) {
                    Invoke-RestMethod -Uri $xrpcUrl -Headers $header
                } else {
                    Invoke-RestMethod $xrpcUrl
                }                
            } catch {
                $_
            }
            if ($results -is [Management.Automation.ErrorRecord]) {
                Write-Verbose "$xrpcUrl - $results"
                continue
            }
            # If we got results and have a cursor to more
            if ($results -and $results.cursor) {
                # set it for the next round.
                $Cursor = $results.cursor
            }                                        

            # Unroll and store each record.
            :nextRecord foreach ($record in $results.records) {

                # Records are sent latest to earliest.
                # We can use -Skip to skip N records
                if ($Skip -and 
                    $skipped -lt $Skip
                ) {
                    $skipped++
                    continue nextRecord
                }

                # If the uri is not an at uri
                if ($record.uri -notmatch $atPattern) {
                    # continue to the next record
                    continue nextRecord
                }
                
                $record
                
                # Increment our total
                $total++
                
                # If we provided -First and our total exceeds our -First, break out
                if ($First -and 
                    $total -ge $First) {
                    break AtSync
                }
            }    
        } while ($results -and $results.cursor)

        $progress.Remove('PercentComplete')
        $progress.Completed = $true
        Write-Progress @progress

    }


    if (-not $script:Cache) { $script:Cache = [Ordered]@{} }

    foreach ($recordType in 
        'site.standard.document', 'site.standard.publication') {
        if (-not $script:Cache["at://$did/$recordType"]) {
            $script:Cache["at://$did/$recordType"] = getAt $did $recordType -pds $PDS
        }
    }

    
    $standardSiteData = [Ordered]@{
        PSTypeName = 'GitPub.StandardSite'
        Documents = $script:Cache["at://$did/site.standard.document"]
        Publications = $script:Cache["at://$did/site.standard.publication"]
    }

    [PSCustomObject]$standardSiteData
}
