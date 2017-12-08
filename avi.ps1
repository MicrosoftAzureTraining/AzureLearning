
#Param($computer="localhost")
#Param($ComputerName="INL-GFLXWF2.groupinfra.com")
Param($computer = "10.155.28.84" )

[CmdletBinding(DefaultParameterSetName='SinglePoint')]
    Param
    (
        [Parameter(Mandatory=$true, Position=0, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName="SinglePoint")]
        [Alias('CName')][String[]]$ComputerName,
        [Parameter(Mandatory=$true, Position=0, ParameterSetName="MultiplePoint")]
        [Alias('CNPath')][String]$ComputerFilePath
    )
    
    If($ComputerName)
    {
        Foreach($CN in $ComputerName)
        {
            #test compter connectivity
            $PingResult = Test-Connection -ComputerName $CN -Count 1 -Quiet
            If($PingResult)
            {
                FindInstalledApplicationInfo -ComputerName $CN
            }
            Else
            {
                Write-Warning "Failed to connect to computer '$ComputerName'."
            }
        }
    }

    If($ComputerFilePath)
    {
        $ComputerName = (Import-Csv -Path $ComputerFilePath).ComputerName

        Foreach($CN in $ComputerName)
        {
            FindInstalledApplicationInfo -ComputerName $CN
        }
    }
}

Function FindInstalledApplicationInfo($ComputerName)
{
    $Objs = @()
    $RegKey = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    
    $InstalledAppsInfos = Get-ItemProperty -Path $RegKey

    Foreach($InstalledAppsInfo in $InstalledAppsInfos)
    {
        $Obj = [PSCustomObject]@{Computer=$ComputerName;
                                 DisplayName = $InstalledAppsInfo.DisplayName;
                                 DisplayVersion = $InstalledAppsInfo.DisplayVersion;
                                 Publisher = $InstalledAppsInfo.Publisher}
        $Objs += $Obj
    }
    $Objs | Where-Object { $_.DisplayName } 