#requires -Module PSSVG

$rssSymbol = 
    svg.symbol -Id rss -Content @(
        svg.path -D 'M4 11 a9 9 0 0 1 9 9'
        svg.path -D 'M4 4 a16 16 0 0 1 16 16'
        svg.circle -cx "5" -cy "19" -r "1"
    ) -ViewBox 0,0,24,24 -Width 24 -Height 24

$psChevron = 
    svg.symbol -Id psChevron -Content @(
        svg.polygon -Points (@(
            "40,20"
            "45,20"
            "60,50"
            "35,80"
            "32.5,80"
            "55,50"
        ) -join ' ')
    ) -ViewBox 100, 100 -PreserveAspectRatio $false


$assetsPath = Join-Path (
    $PSScriptRoot | Split-Path
) assets

svg -ViewBox 300, 100 @(
    $psChevron
    $rssSymbol

    svg.use -Href '#psChevron' -Fill '#4488ff' -X 110 -Y 25% -Width 10% -Height 50% 
    svg.use -Href '#rss' -Stroke '#4488ff' -X 160 -Y 45% -Fill transparent -Width 10% -Height 10%
    svg.text -X 50% -Y 50% -TextAnchor 'middle' -DominantBaseline 'middle' -Content @(
        "gitpub"
    ) -FontFamily 'sans-serif' -Fill '#4488ff'
) -OutputPath (
    Join-Path $assetsPath GitPub.svg
)

