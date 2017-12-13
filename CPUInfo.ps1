#region Description
##############################################################################################################
#This script demonstrates the following Tasks#
#1. Fetch the CPU information, Physical Memory and free space on disks on a computeras an report#
#2. Send the report to the given Email#
#############################################################################################################
#endregion

param (        	[string]$email = $(read-host "Enter a recipient email"),	[string]$subject = $(read-host "Enter the subject header"), 
    [string]$body = $(read-host "Enter the email text (optional)")
)


#region Step1 

#Declare the Computer name, this code works only for the local computers and not an Remote one
$private:computer = "IKEADEV"
'Processing ' + $private:computer + '...'

# Declare main data hash to be populated later
$data = @{}
$data.'Computer Name' = $private:computer

# Try an ICMP ping the only way Powershell knows how...
$private:ping = Test-Connection -quiet -count 1 $private:computer
$data.Ping = $(if ($private:ping) { 'Yes' } else { 'No' })

# Do a DNS lookup with a .NET class method. Suppress error messages.
$ErrorActionPreference = 'SilentlyContinue'
if ( $private:ips = [System.Net.Dns]::GetHostAddresses($private:computer) | foreach { $_.IPAddressToString } ) {
    
    $data.'IP Address(es) from DNS' = ($private:ips -join ', ')
    
}

else {
    
    $data.'IP Address from DNS' = 'Could not resolve'
    
}
# Make errors visible again
$ErrorActionPreference = 'Continue'

# We'll assume no ping reply means it's dead. Try this anyway if -IgnorePing is specified
if ($private:ping -or $private:ignorePing) {
    
    $data.'WMI Data Collection Attempt' = 'Yes (ping reply or -IgnorePing)'
    
    # Get various info from the ComputerSystem WMI class
    if ($private:wmi = Get-WmiObject -Computer $private:computer -Class Win32_ComputerSystem -ErrorAction SilentlyContinue) {
        
        $data.'Computer Hardware Manufacturer' = $private:wmi.Manufacturer
        $data.'Computer Hardware Model'        = $private:wmi.Model
        $data.'Physical Memory in MB'          = ($private:wmi.TotalPhysicalMemory/1MB).ToString('N')
        
    }
    
    $private:wmi = $null
    
    # Get the free/total disk space from local disks (DriveType 3)
    if ($private:wmi = Get-WmiObject -Computer $private:computer -Class Win32_LogicalDisk -Filter 'DriveType=3' -ErrorAction SilentlyContinue) {
        
        $private:wmi | Select 'DeviceID', 'Size', 'FreeSpace' | Foreach {
            
            $data."Local disk $($_.DeviceID)" = ('' + ($_.FreeSpace/1MB).ToString('N') + ' MB free of ' + ($_.Size/1MB).ToString('N') + ' MB total space' )
            
        }
        
    }
    
    $private:wmi = $null
    
    
    # Get CPU information with WMI
    if ($private:wmi = Get-WmiObject -Computer $private:computer -Class Win32_Processor -ErrorAction SilentlyContinue) {
        
        $private:wmi | Foreach {
            
            $private:maxClockSpeed     =  $_.MaxClockSpeed
            $private:numberOfCores     += $_.NumberOfCores
            $private:description       =  $_.Description
            $private:numberOfLogProc   += $_.NumberOfLogicalProcessors
            $private:socketDesignation =  $_.SocketDesignation
            $private:status            =  $_.Status
            $private:manufacturer      =  $_.Manufacturer
            $private:name              =  $_.Name
            
        }
        
        $data.'CPU Clock Speed'        = $private:maxClockSpeed
        $data.'CPU Cores'              = $private:numberOfCores
        $data.'CPU Description'        = $private:description
        $data.'CPU Logical Processors' = $private:numberOfLogProc
        $data.'CPU Socket'             = $private:socketDesignation
        $data.'CPU Status'             = $private:status
        $data.'CPU Manufacturer'       = $private:manufacturer
        $data.'CPU Name'               = $private:name -replace '\s+', ' '
        
    }
   
    
    $private:wmi = $null
    
    # Get operating system info from WMI
    if ($private:wmi = Get-WmiObject -Computer $private:computer -Class Win32_OperatingSystem -ErrorAction SilentlyContinue) {
        
        $data.'OS Boot Time'     = $private:wmi.ConvertToDateTime($private:wmi.LastBootUpTime)
        $data.'OS System Drive'  = $private:wmi.SystemDrive
        $data.'OS System Device' = $private:wmi.SystemDevice
        $data.'OS Language     ' = $private:wmi.OSLanguage
        $data.'OS Version'       = $private:wmi.Version
        $data.'OS Windows dir'   = $private:wmi.WindowsDirectory
        $data.'OS Name'          = $private:wmi.Caption
        $data.'OS Install Date'  = $private:wmi.ConvertToDateTime($private:wmi.InstallDate)
        $data.'OS Service Pack'  = [string]$private:wmi.ServicePackMajorVersion + '.' + $private:wmi.ServicePackMinorVersion
        
    }
    
    
}

else {
    
    $data.'WMI Data Collected' = 'No (no ping reply and -IgnorePing not specified)'
    
}

# Output data
$data.GetEnumerator() | Sort-Object 'Name' | Format-Table -AutoSize
$data.GetEnumerator() | Sort-Object 'Name' | Out-GridView -Title "$private:computer Information"
$data.GetEnumerator() | Sort-Object 'Name' | Out-File 'C:\Test\Test.txt'

send-Email

#endregion

#region Step2
function Send-Email
(
	[string]$recipientEmail = $(Throw "At least one recipient email is required!"), 
    [string]$subject = $(Throw "An email subject header is required!"), 
    [string]$body
)
{
    $outlook = New-Object -comObject  Outlook.Application 
    $mail = $outlook.CreateItem(0) 
    $mail.Recipients.Add($recipientEmail) 
    $mail.Subject = $subject 
    $mail.Body = $body
    
    # For HTML encoded emails 
    # $mail.HTMLBody = "<HTML><HEAD>Text<B>BOLD</B>  <span style='color:#E36C0A'>Color Text</span></HEAD></HTML>"
    
    # To send an attachment 
    $mail.Attachments.Add("C:\Test\Test.txt") 
    
    $mail.Send() 
    Write-Host "Email sent!"
}



# ==========================================================================
#	Main Script Body
# ==========================================================================


Write-Host "Starting Send-MailViaOutlook Script."

# Send email using Outlook
Send-Email -recipientEmail $email -subject $subject -body $body


Write-Host "Closing Send-MailViaOutlook Script."

# ==========================================================================
#	End of Script Body
# ==========================================================================


#endregion