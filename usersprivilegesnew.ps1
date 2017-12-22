
$cn=hostname
$users=Get-WmiObject -Class Win32_UserAccount -Filter  "LocalAccount='True'" | Out-String
$users

$privi=whoami /priv
$privi


<#foreach($userprv in $users)
{
    $usersprv+=$indItem;
}#>
#Invoke-Expression -Command C:\Users\rajashekarbadigerp\Desktop\powershell\email.ps1