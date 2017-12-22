#region Description
##############################################################################################################
#This script demonstrates the following Tasks#
#1. Report the System Services which are running#
#2. Report the Application Services on the local machine#
#############################################################################################################
#endregion

#$cols = @()

#region Report System Service


$cols+='System Services Report'
$SystemService=Get-Service | Where {$_.status –eq 'running'} | Sort-Object 'Name' | Format-Table -AutoSize
#$SystemService

#$pp= $SystemService.Count;
#$pp

Foreach($indItem in $SystemService)
{
    $cols+=$indItem;
}


#endregion 

#region Report Application Service

$cols+='Application Services Report'
$ApplicationService=Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion, Publisher | Sort-Object 'Name'  | Format-Table –AutoSize

foreach($indItem in $ApplicationService)
{
    $cols+=$indItem;
}
#endregion

$cols

#Invoke-Expression -Command C:\Users\rajashekarbadigerp\Desktop\powershell\email.ps1

