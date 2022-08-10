param(
   [Parameter(Mandatory=$False)] $Username,
   [switch]$Domain,
   [switch]$SMBCheck
 )

function SMBCheck() {
   $SMBv1Enabled = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol | Select-Object State

   if ($SMBv1Enabled.State -eq "Enabled") {
      Write-Host "[ + ] SMBv1 Enabled."
      Write-Host "[ + ] Disabling SMBv1..."
      # Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
      Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force
   }

   # Check to make sure SMBv1 was properly disabled, and not automatically restarted by a rogue service/process
   # $SMBv1Enabled = Get-WindowsOptionalFeature -Online -FeatureName SMB1Protocol | Select-Object State
   $SMBv1Enabled = Get-Item HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters | ForEach-Object {Get-ItemProperty $_.pspath} | Select SMB1.SMB1

   if ($SMBv1Enabled.State -eq "Enabled") {
      Write-Host "[ - ] Unable to disable SMBv1. Check host for rogue services or processes that may be restarting it automatically."
   }
   else {
      Write-Host "[ + ] SMBv1 is disabled. Rebooting machine..."
      shutdown /r /t 0 
   }
}

 function DeleteLocalUsers() {
   $MatchedUsers = Get-LocalUser | Where-Object {$_.Name -like "*$Username*"} | Select-Object Name

   foreach($User in $MatchedUsers.Name){
      Write-Host "Deleting $User"
      Remove-LocalUser -Name $User
   }
 }

 function DeleteDomainUsers() {
   $MatchedADUsers = Get-ADUser -Filter "Name -like '*$Username*'" | Select-Object Name
 
   foreach($User in $MatchedADUsers.Name){
      Write-Host "Deleting $User"
      Remove-ADUser -Confirm:$false -Identity $User
   }
 }

 function PurgeService() {
   $MatchedService = Get-Service | Where-Obect {$_.Name -like "*$Service*"}
   
   foreach($Service in $MatchedService.Name) {
      Stop-Service -Force -Confirm -NoWait -Name $Service
      
   }
 }

 if ($SMBCheck -eq $True){
   SMBCheck
 }
 elseif ($Domain -ne $True) {
   Write-Host "Deleting local users..."
   DeleteLocalUsers
 }
 elseif ($Domain -eq $True) {
   Write-Host "Deleting domain users..."
   DeleteDomainUsers
 }

 Write-Host "Script completed."