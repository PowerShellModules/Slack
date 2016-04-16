function Send-SlackMessage {
[CmdletBinding()]
    param (
    [Parameter(Mandatory=$true)][string]$channel,
    [Parameter(Mandatory=$true)][string]$text,
    [Parameter(Mandatory=$false)][string]$token
    )
    
    $text = [System.Uri]::EscapeDataString($text)
    
    Invoke-WebRequest -uri "https://slack.com/api/chat.postMessage?token=$token&channel=$channel&text=$text&as_user=true&pretty=1"
    }

    
function Get-SlackMembers {
    [CmdletBinding()]
    param (
          [Parameter(Mandatory=$false)][string]$token
     )

$users = Invoke-WebRequest -uri "https://slack.com/api/users.list?token=$token&pretty=1"
$members = ($users.Content | ConvertFrom-Json).members

$members
} 
