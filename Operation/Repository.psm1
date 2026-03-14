# Version 1.0.0

<#
    .Synopsis
        Ensures that the links in Markdown files are using the permalink to raw image and pages links.

    .Notes
        - This is required for the images to be shown in the ReadMe when viewed on NuGet as it does not resolve relative paths.
        - Modified files are added to the commit.
#>
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

<#
    .Synopsis
        Ensures that the .svg files are fresh and reflect the content of the source .puml files.

    .Notes
        - Modified files are added to the commit.
#>
Function Assert-DiagramFreshness
{
    Get-ChildItem -File -Recurse (Join-Path $PSScriptRoot '..\*.puml') | ForEach-Object {
        $source = $_
        $targetPath = [System.IO.Path]::ChangeExtension($source.FullName, 'svg')
        $target = Get-Item $targetPath -ErrorAction Ignore
        If (($Null -Eq $target) -Or ($target.LastWriteTime -Lt $source.LastWriteTime)) {
            ('Generating diagram {0}' -f $targetPath)
            & plantumlc -tsvg $source.FullName
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
