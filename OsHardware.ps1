#Param($computer="localhost")
#Param($computer="INL-GGKRR72.groupinfra.com")

$hardware=@()
$computer=hostname


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

foreach($link in $osv)
{
    $hardware+=$link
}

Write-Host "System Information"

#Computer Name

$cn=(Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).CSName
Write-Host "Computer Name:"$cn -ForegroundColor Cyan

foreach($link in $cn)
{
    $hardware+=$link
}

#Install Date#

#$os=Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer | Select-Object InstallDate | ForEach{ $_.InstallDate }
$id=(Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).InstallDate
Write-Host "Install Date:" -ForegroundColor Yellow $id

foreach($link in $id)
{
    $hardware+=$link
}

#Service Pack Version#

#$os=Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer| Select-Object ServicePackMajorVersion | ForEach {$_.ServicePackMajorVersion}
$sp=(Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computer).ServicePackMajorVersion
Write-Host "Service Pack Version:"-ForegroundColor Green $sp

foreach($link in $sp)
{
    $hardware+=$link
}

#RAM Details#

$ram=[Math]::Round((Get-WmiObject -Class win32_computersystem -ComputerName $computer).TotalPhysicalMemory/1GB)
Write-host "RAM Details:" $ram "GB" -ForegroundColor Red 

foreach($link in $ram)
{
    $hardware+=$link
}

#Operating System#

$op=(Get-WmiObject -Class win32_OperatingSystem -Computer $computer).OSArchitecture
Write-host "System Type:"$op "Operating System" -ForegroundColor Magenta

foreach($link in $op)
{
    $hardware+=$link
}



#Invoke-Expression -Command C:\Users\rajashekarbadigerp\Desktop\powershell\email.ps1



