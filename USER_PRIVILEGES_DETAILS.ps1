
param (
    [string[]]$ComputerName = 'INL-813GQ12' 
)
foreach ($Computer in $ComputerName) {
    $Results = @()
    ([adsi]"WinNT://$Computer").psbase.Children | ? {$_.SchemaClassName -eq 'Group'} | % {
        foreach ($Member in $($_.psbase.invoke('members'))) {
            $Results += New-Object -TypeName PSCustomObject -Property @{
                name = $Member.GetType().InvokeMember("Name", 'GetProperty', $null, $Member, $null) 
                class = $Member.GetType().InvokeMember("Class", 'GetProperty', $null, $Member, $null) 
                path = $Member.GetType().InvokeMember("ADsPath", 'GetProperty', $null, $Member, $null)
                group = $_.psbase.name
            } | ? {($_.Class -eq 'User') -and ([regex]::Matches($_.Path,'/').Count -eq 4)}
        }
    }
 $system=Hostname
 $system_details=write-host "System Details"  $system
 $system_details
 $user_details =  $Results | Group-Object Name | Select-Object Name,@{name='Group';expression={$_.Group | % {$_.Group}}},@{name='Computer';expression={$Computer}}
}
$system_details
$user_details
$users_priv=whoami /User /Groups /PRIV
$users_priv
<#$SMTPServer="smtp.gmail.com" 
$SMTPPort="587" 
$Username="diviseetharaman@gmail.com" 
$Password="savi@238" 
$To="diviseethaaraman@gmail.com" 
$header="<b><font size=3 color=black weight=bold>System Information</font></b><br><br>" 
$para1= "<b>System details</b> $system_details <br><br>"
$para2= "<b>User details</b> $user_details <br><br>"
$para3= "<b>User Privileges:</b> $users_priv <br><br>" 
$message=New-Object System.Net.Mail.MailMessage 
$message.body=@($header,$para1,$para2,$para3) 
$message.Subject="System Details and User details" 
$message.to.add($To) 
$message.from=$Username 
$smtp=New-Object System.Net.Mail.SmtpClient($SMTPServer,$SMTPPort); 
$smtp.EnableSsl=$true 
$message.IsBodyHtml=$true 
$smtp.Credentials=New-Object System.Net.NetworkCredential($Username,$Password); 
$smtp.Send($message); 
Write-Host "Mail Sent"#> 

