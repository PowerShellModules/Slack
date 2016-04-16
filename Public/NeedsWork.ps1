function Get-SlackMembersAddDL {
    [CmdletBinding()]
    param (
          [Parameter(Mandatory=$true)][string]$ExistingXML,
          [Parameter(Mandatory=$false)][string]$token,
          [Parameter(Mandatory=$true)][PSCredential]$EXOcredential
     )
Connect-EXOSession -EXOCredential $EXOcredential
$oldFullmembers = Import-Clixml -Path $ExistingXML
$users = Invoke-WebRequest -uri "https://slack.com/api/users.list?token=$token&pretty=1"
$members = ($users.Content | ConvertFrom-Json).members

$fullmembers = New-Object System.Collections.Arraylist

foreach ($member in $members) 
    { If ($member.profile.real_name)
        { $fullmembers.Add($member) | Out-Null } }


foreach ($fullmember in $fullmembers) 
    { If (!$oldfullmembers.profile.real_name.Contains($fullmember.profile.real_name))
        {
        New-MailContact -LastName $fullmember.profile.last_name `
                        -DisplayName $fullmember.profile.real_name `
                        -Name $fullmember.profile.real_name `
                        -ExternalEmailAddress $fullmember.profile.email `
                        -FirstName $fullmember.profile.first_name ; Add-DistributionGroupMember -Identity PSConfEUOrganisers -Member $fullmember.profile.email 
        } 
    }
    Write "There are $($members.Count) members in total"
    Write "There are $($fullmembers.Count) members with full info"
    Export-Clixml -InputObject $fullmembers -Path $ExistingXML
    Remove-PSSession -Name EXOSession
} 


function Request-SlackMembersToUpdateProfile {
<#
    .Synopsis
    Sends a message to all members of a Slack Team that haven't got their Profile Details set out requesting them to do so.
    
    .Description
    As Synopsis

    .Example
    Request-SlackMembersToUpdateProfile -token $env:SlackTeamToken -message 'WHO ARE YOU??? Please fill in your Name & a profile photo - Many thanks'
#>
[CmdletBinding()]
param(
        [String]$token,
        [String]$message
     )
$members = Get-SlackMembers -token $token;
$idstomIM = foreach ($member in $members) { if (!$member.profile.real_name) {$member.id} } ; 
foreach ($idtomIM in $idstomIM) { Send-SlackMessage -channel $idtomIM -text $message -token $token}
}

