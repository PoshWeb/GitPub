<#
.SYNOPSIS
    Gets GitPub Publishers
.DESCRIPTION
    Gets the commands that are considered GitPub publishers.

    A command is considered a GitPub publisher if it :

    * Has `GitPub` in the name
    * Starts with `Publish`
    * Followed by an optional dot or dash
    * Followed by GitPub
    * Followed by any other characters until the end.
#>
foreach ($command in $this.Commands -match '^Publish[\.\-]?GitPub.+?$') {
    if ($command.pstypenames -notcontains 'GitPub.Publisher') {
        $command.pstypenames.add('GitPub.Publisher')
    }
    $command
}