Write-Host "Select 1 for list the current CPU , Memory and Disk space of a machine "
Write-Host "Select 2 for list the services running on machine by segregating them between System services and Application services"
Write-Host "Select 3 for list all the third party softwares installed on a VM and report the software name , version and vendor name"
Write-Host "Select 4 for list the OS and Hardware configuration of a VM and report"
Write-Host "Select 5 for list users and their privileges on a machine"

$select=Read-Host -Prompt "Provide to Run above Information:"


switch($select)
{
    1
        {

              Invoke-Expression C:\Users\rajashekarbadigerp\Desktop\powershell\CPU_details.ps1
              $para=powershell C:\Users\rajashekarbadigerp\Desktop\powershell\CPU_details.ps1
              sendemail($para)   
        }

    2
        {
            Invoke-Expression C:\Users\rajashekarbadigerp\Desktop\powershell\systemservice.ps1
            $para=powershell C:\Users\rajashekarbadigerp\Desktop\powershell\systemservice.ps1
            sendemail($para)

        }
    3
        {
             Invoke-Expression C:\Users\rajashekarbadigerp\Desktop\powershell\softwaredetails.ps1
             $para=powershell C:\Users\rajashekarbadigerp\Desktop\powershell\softwaredetails.ps1
             sendemail($para)
        }
    4
        {
            Invoke-Expression C:\Users\rajashekarbadigerp\Desktop\powershell\OsHardware.ps1
            $para=powershell C:\Users\rajashekarbadigerp\Desktop\powershell\OsHardware.ps1
          <#  foreach($link in $para)
            {
           
            
              $os+=$link; 

              $os

            }

            Write-Host $os#>

              sendemail($para)  
        }
    5
        {
            Invoke-Expression C:\Users\rajashekarbadigerp\Desktop\powershell\usersprivilegesnew.ps1
            $para=powershell C:\Users\rajashekarbadigerp\Desktop\powershell\usersprivilegesnew.ps1
            sendemail($para)
        }
Default
{
    Write-Host -ForegroundColor RED "-No Admin Previliges..cannot execute the script"
    
}

}#endswitch

Function sendemail($para)
{
Write-Host "PAvan"
$From= Read-Host "Enter receipent mail id"
$Pwd=Read-Host -assecurestring "Enter receipent password"
$to=Read-host "Enter To mail id"



$SMTPServer="smtp.gmail.com"
#$SMTPServer="smtp-mail.outlook.com"
$SMTPPort="587"
$Username=$From
$Password=$Pwd
$To=$to
$message=New-Object System.Net.Mail.MailMessage
$message.Subject="System Details"
$message.Body=@($para)
$message.to.add($To)
$message.from=$Username
$smtp=New-Object System.Net.Mail.SmtpClient($SMTPServer,$SMTPPort);
$smtp.EnableSsl=$true
$message.IsBodyHtml=$true
$smtp.Credentials=New-Object System.Net.NetworkCredential($Username,$Password);
$smtp.Send($message);
Write-Host "Mail Sent"

}