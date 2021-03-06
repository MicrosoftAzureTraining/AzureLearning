#######################################################################################################

  # Vers  Date      Author     OR Ref  Comment
  #====================================================================================================
  # 01    05/12/17  Divya      N/A     Initial version
  # 02    06/12/17  Divya     001     Added User details information
  # 03    07/12/17  Divya     002     Added User privileges details
  # 04    10/12/17  Divya     003     Added mailing to users regarding user and user privileges details

#########################################################################################################


####################################################################################################################################

  #SYNOPSIS  :    Checking users and users privileges in local machine
  
  #PARAMETERS :   ComputerName   - passing local computer details as input
  #               Results        - Number if users list in local compputer as output
  #               Member         - Getting member details like user name, group, computer as input for results parameter 
  #               system         - System details like hostname as input
  #               system_details - calling system parameter to print system details as in formatted output      
  #               user_details   - calling Results parameter to print user details of local computer as output
  #               users_priv     - printing user privileges like username, SID, Group name, type, attributes, privilege name, state 
  
######################################################################################################################################

#---------------------------------------
#Region 1 - Getting System User details
#---------------------------------------


#Getting computer details from a local system
#declaring variables and passing computer name to that variable  

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

 #Getting local computer Host name details to know users 
 
 $system=Hostname

 $system_details=write-host "System Details"  $system

 $system_details

 $user_details =  $Results | Group-Object Name | Select-Object Name,@{name='Group';expression={$_.Group | % {$_.Group}}},@{name='Computer';expression={$Computer}}
 
 }#Region 1 - end of the user details script

 #Printing hostname details of local computer    
 
 $system_details
 
 #Printing local user details along with their Group and name
 
 $user_details
 
 #---------------------------------------------------- 
 #Region 2 - Getting User privileges, Groups, State 
 #----------------------------------------------------  
 
 #Getting user privileges and user group details
 $users_priv=whoami /User /Groups /PRIV
 #Printing user privilegs, Groups and state of the users
 $users_priv
 #Region 2 - end of user privileges script
 
 #----------------------------------------------------------------
 #Region 3 - Send user and user privileges details through e-mails
 #----------------------------------------------------------------
 
 #Getting Sender and receiver details
 #Using HTML formatting text and calling output parameters from region 1 and region 2
 
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
 #Printing all system, user and user privileges details through mail 
  
 #Region 3 - end of sending all details in e-mails 
