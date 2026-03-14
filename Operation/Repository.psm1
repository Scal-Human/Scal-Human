
Function Assert-MarkdownLinkValidity
{
    [CmdletBinding()]
    Param (
        [Parameter()]
        [String]
        $GitHubLink = 'https://github.com/'
        ,
        [Parameter()]
        [String]
        $PermaLink = 'https://raw.githubusercontent.com/'
    )
    $repoLink       = (& git config --get remote.origin.url).Replace($GitHubLink, '') -Replace '\.git$', ''
    $branchName     = & git rev-parse --abbrev-ref HEAD
    $directLink     = '{0}{1}/refs/heads/{2}/' -f $PermaLink, $repoLink, $branchName
    Get-ChildItem -File -Recurse (Join-Path $PSScriptRoot '..\*.md') | ForEach-Object {
        $source     = $_
        $changes    = 0
        $changed    = Get-Content $source.FullName | ForEach-Object {
            $line   = $_
            If ($_ -Match '\[.*\]\((?<Link>.*)\)') {
                $link = $Matches.Link
                If ($link.StartsWith('http')) {
                    $line
                } Else {
                    $line = $line.Replace($link, $directLink + $link)
                    Write-Verbose $line
                    $changes ++
                    $line
                }
            } Else {
                $line
            }
        }
        If ($changes -Gt 0) {
            $changed | Out-File -Force $source
            & git add $source
        }
    }
}

Function Assert-DiagramFreshness
{
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
}
