# SStructure Editor User Guide.md 를 "# CHAPTER N" 경계 기준으로 manual/sde/ 에 분할한다.
# (수동으로 챕터 시작 라인을 확인 후 고정한 범위를 사용 — Grep으로 검증한 결과와 일치)

$src = "SStructure Editor User Guide.md"
$outDir = "manual\sde"

$chapters = @(
    @{Num="00"; Title="Front Matter and Table of Contents";                    Start=1;     End=1293}
    @{Num="01"; Title="Introduction to Sentaurus Structure Editor";            Start=1294;  End=1661}
    @{Num="02"; Title="Graphical User Interface";                              Start=1662;  End=3026}
    @{Num="03"; Title="Controlling Views";                                     Start=3027;  End=3434}
    @{Num="04"; Title="Generating Geometric Structures";                       Start=3435;  End=7516}
    @{Num="05"; Title="Structure Generation Using Etching and Deposition";     Start=7517;  End=9983}
    @{Num="06"; Title="Electrical and Thermal Contacts";                       Start=9984;  End=10516}
    @{Num="07"; Title="Generating Mesh and Doping Profiles";                   Start=10517; End=12635}
    @{Num="08"; Title="Creating Planar Layer Stacks";                          Start=12636; End=13941}
    @{Num="09"; Title="Working With Scheme and Scheme Extensions";             Start=13942; End=14685}
    @{Num="10"; Title="Geometric Query Functions";                             Start=14686; End=15410}
    @{Num="11"; Title="Miscellaneous Utilities";                               Start=15411; End=15717}
    @{Num="A";  Title="Appendix A Commands";                                   Start=15718; End=33922}
)

$lines = Get-Content -LiteralPath $src -Encoding UTF8

$manifest = @()
foreach ($ch in $chapters) {
    $safeTitle = ($ch.Title -replace '[^A-Za-z0-9]+', '_').Trim('_')
    $fileName = "$($ch.Num)_$safeTitle.md"
    $slice = $lines[($ch.Start - 1)..($ch.End - 1)]
    $outPath = Join-Path $outDir $fileName
    Set-Content -LiteralPath $outPath -Value $slice -Encoding UTF8
    $lineCount = $ch.End - $ch.Start + 1
    $manifest += [PSCustomObject]@{
        Chapter    = $ch.Num
        Title      = $ch.Title
        File       = $fileName
        StartLine  = $ch.Start
        EndLine    = $ch.End
        LineCount  = $lineCount
    }
    Write-Output "OK $fileName ($lineCount lines)"
}

$manifest | Export-Csv -LiteralPath (Join-Path $outDir "_split_manifest.csv") -NoTypeInformation -Encoding UTF8
Write-Output "manifest written"
