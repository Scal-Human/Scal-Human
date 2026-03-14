$InformationPreference = 'Continue'
Get-ChildItem -File -Recurse (Join-Path $PSScriptRoot '..\*.puml') | ForEach-Object {
    $source = $_
    $targetPath = [System.IO.Path]::ChangeExtension($source.FullName, 'svg')
    $target = Get-Item $targetPath -ErrorAction Ignore
    If (($Null -Eq $target) -Or ($target.LastWriteTime -Lt $source.LastWriteTime)) {
        ('Generating diagram {0}' -f $targetPath)
        plantumlc.exe -tsvg $source.FullName
        If ($LastExitCode -Ne 0) {
            Write-Error ('Error generating PlantUml diagram {0}' -f $targetPath)
            Exit $LastExitCode
        }
        & git add $targetPath
    } Else {
        ('Up-to-date diagram {0}' -f $targetPath)
    }
}
Exit 0
