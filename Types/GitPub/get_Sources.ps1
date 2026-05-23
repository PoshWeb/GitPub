<#
.SYNOPSIS
    Gets GitPub Sources
.DESCRIPTION
    Gets the commands that are considered GitPub sources.

    A command is considered a GitPub source if it :

    * Has `GitPub` in the name
    * Starts with `Get`
    * Followed by an optional dot or dash
    * Followed by GitPub
    * Followed by any other characters until the end.
#>
foreach ($command in $this.Commands -match '^Get[\.\-]?GitPub.+?$') {
    if ($command.pstypenames -notcontains 'GitPub.Source') {
        $command.pstypenames.add('GitPub.Source')        
    }
    $command
}