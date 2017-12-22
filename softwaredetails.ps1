#Software installed with name skype

#Get-WmiObject -Class Win32_Product

#$soft=@()
$software=Get-WmiObject -Class Win32_Product -Filter {Name Like "%skype%"} | Out-String

$software

#Invoke-Expression -Command C:\Users\rajashekarbadigerp\Desktop\powershell\email.ps1

#$soft=Get-Content $software | Out-String
#$soft




<#$str="IdentifyingNumber"

foreach($software in "IdentifyingNumber")
{
$software.split("'n");
return
}#>

#Get-WmiObject -Class Win32_OperatingSystem –ComputerName localhost |

#Select-Object -Property CSName,LastBootUpTime 

<#$From= Read-Host "Enter receipent mail id"
$Pwd=Read-Host -assecurestring "Enter receipent password"
$to=Read-host "Enter To mail id"

$SMTPServer="smtp.gmail.com"
$SMTPPort="587"
$Username=$From
$Password=$Pwd
$To=$to
$para1=$software
$message=New-Object System.Net.Mail.MailMessage
$message.body=@($para1)
$message.Subject="System Software details"
#$message.Body=$x
$message.to.add($To)
$message.from=$Username
$smtp=New-Object System.Net.Mail.SmtpClient($SMTPServer,$SMTPPort);
$smtp.EnableSsl=$true
$message.IsBodyHtml=$true
$smtp.Credentials=New-Object System.Net.NetworkCredential($Username,$Password);
$smtp.Send($message);
Write-Host "Mail Sent"#>

