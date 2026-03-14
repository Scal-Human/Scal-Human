Import-Module (Join-Path $PSScriptRoot 'Repository.psm1')
Assert-DiagramFreshness
Assert-MarkdownLinkValidity
