#Module#Slack#


# Needs to be completed as this was 1 single psm1 file to begin with
<# 
$Here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Scripts = Get-ChildItem "$here\" -Filter '*.ps1' -Recurse | Where-Object {$_.name -NotMatch "Tests.ps1"}

$scripts.foreach
#>