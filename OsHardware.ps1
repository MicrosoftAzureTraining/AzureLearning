#Param($computer="localhost")
#Param($computer="INL-GGKRR72.groupinfra.com")
Param($computer = "192.168.0.105" )


Function Get-Osversion($computer,[ref]$osv)
{

$os=Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer

Switch ($os.version)
{
"5.1.2600" {$osv.Value="xp"}
"5.1.3790" {$osv.Value = "2003"}

"6.0.6001"
    {
        If($os.ProductType -eq 1)
        {
           $osv.Value="Vista"
        }#endif
        else
            {
                $osv.Value="2008";
            }#endelse
     }#end6001

"6.0.7600"
    {
        If($os.ProductType -eq 1)
         {
             $osv.Value="Win7"
         }#endif
         else
             {
                $osv.Value="Windows7"
            }#endelse
    }#end7600

"6.1.7601"
    {
        If($os.ProductType -eq 1)
        { 
            $osv.Value= "Windows7"
            
        }#endif
        else
        {
            $osv.Value="2009R2"
        }#endelse
    }#end7601

Default{"Version not listed"}

}#endswitch
}#end GetOSversion

# *** entry point to script *** 
# OSVersion 
$osv = $null 
Get-OSVersion -computer $computer -osv ([ref]$osv) 
Write-Host OSVersion:$osv 

Write-Host "System Information"

#Computer Name

$cn=(Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).CSName
Write-Host "Computer Name:"$cn -ForegroundColor Cyan



#Install Date#

#$os=Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer | Select-Object InstallDate | ForEach{ $_.InstallDate }
$id=(Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).InstallDate
Write-Host "Install Date:" -ForegroundColor Yellow $id

#Service Pack Version#

#$os=Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer| Select-Object ServicePackMajorVersion | ForEach {$_.ServicePackMajorVersion}
$sp=(Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).ServicePackMajorVersion
Write-Host "Service Pack Version:"-ForegroundColor Green $sp

#RAM Details#

$ram=[Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName $computer).TotalPhysicalMemory/1GB)
Write-host "RAM Details:" $ram "GB" -ForegroundColor Red 

#Operating System#

$op=(Get-WmiObject -Class win32_OperatingSystem -Computer $computer).OSArchitecture
Write-host "System Type:"$op "Operating System" -ForegroundColor Magenta

#Software installed with name skype

#Get-WmiObject -Class Win32_Product -Filter {Name like "%skype%"} 


<#$SMTPServer="smtp.gmail.com"
#$SMTPServer="smtp-mail.outlook.com"
$SMTPPort="587"
$Username="pavanrb5007@gmail.com"
$Password="*1234#pavan"
$To="pavan.rajashekar.badiger@cgi.com"
#$body="hello"
#$header= "Below are the System Information of User <b><Font Color=Red>$To</b></font><br><br>"
$header="<b><font size=3 color=red weight=bold>Below are the System($cn) Information of User($Username)</font></b><br><br>"
$para1= "<b>OSVersion:</b> $osv <br><br>"
$para2= "<b>Install Date:</b> $id <br><br>"
$para3= "<b>Service Pack Version:</b> $sp <br><br>"
$para4= "<b>RAM:</b> $ram<b>GB</b> <br><br>"
$para5= "<b>Operating System:</b> $op <br><br>"
#$para6= "Computer Name:"+$cn
$message=New-Object System.Net.Mail.MailMessage
$message.body=@($header,$para1,$para2,$para3,$para4,$para5)
$message.Subject="System Details"
#$message.Body=$x
$message.to.add($To)
$message.from=$Username
$smtp=New-Object System.Net.Mail.SmtpClient($SMTPServer,$SMTPPort);
$smtp.EnableSsl=$true
$message.IsBodyHtml=$true
$smtp.Credentials=New-Object System.Net.NetworkCredential($Username,$Password);
$smtp.Send($message);
Write-Host "Mail Sent"#>



