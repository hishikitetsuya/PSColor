function PrintContext(){
    param (
    [Parameter(Mandatory=$True)]
    $display, 
    [Parameter(Mandatory=$True)]
    $filename, 
    [Parameter(Mandatory=$True)]
    $start
    )
    $display | foreach { 
        Write-Host "  ${filename}" -foregroundcolor $global:PSColor.NoMatch.Path.Color -noNewLine
        Write-Host ":" -foregroundcolor $global:PSColor.NoMatch.Default.Color -NoNewline
        Write-Host "$start" -foregroundcolor $global:PSColor.NoMatch.LineNumber.Color -noNewLine
        Write-Host ":" -foregroundcolor $global:PSColor.NoMatch.Default.Color -NoNewline
        write-host "$_" -foregroundcolor $global:PSColor.NoMatch.Line.Color
        $start++ 
    }
}

function MatchInfo {
    param (
        [Parameter(Mandatory=$True,Position=1)]
        $match
    )
    
    if ($match.Context) {PrintContext $match.Context.DisplayPreContext $match.RelativePath($pwd) ($match.LineNumber - $match.Context.DisplayPreContext.Count)}
    Write-Host '> ' -ForegroundColor $global:PSColor.Match.Default.Color -NoNewline
    Write-host $match.RelativePath($pwd) -foregroundcolor $global:PSColor.Match.Path.Color -noNewLine
    Write-host ':' -foregroundcolor $global:PSColor.Match.Default.Color -noNewLine
    Write-host $match.LineNumber -foregroundcolor $global:PSColor.Match.LineNumber.Color -noNewLine
    Write-host ':' -foregroundcolor $global:PSColor.Match.Default.Color -noNewLine
    $ParsedText = $match.Line -split $match.pattern
    Write-host $ParsedText[0] -foregroundcolor $global:PSColor.Match.Line.Color -noNewLine
    for ($i = 1; $i -lt $ParsedText.length; $i += 1) {
        Write-host $match.matches[0].value -foregroundcolor $global:PSColor.Match.MatchedText.Color -noNewLine -BackgroundColor $global:PSColor.Match.Background.Color
        Write-host $ParsedText[$i] -foregroundcolor $global:PSColor.Match.Line.Color -noNewLine
    }
    Write-Host
    if ($match.Context) {PrintContext $match.Context.DisplayPostContext $match.RelativePath($pwd) ($match.LineNumber + 1)}
}