function Get-HardWareInfo {
    param(
        [string]$ComputerName
    )

    try {
        $computer = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName -ErrorAction Continue
        $bios = Get-WmiObject -Class Win32_BIOS -ComputerName $ComputerName -ErrorAction Continue
        $ram = Get-WmiObject -Class Win32_PhysicalMemory -ComputerName $ComputerName -ErrorAction Continue
        $drives = Get-WmiObject -Class Win32_LogicalDisk -ComputerName $ComputerName -Filter "DriveType=3" -ErrorAction Continue
        $monitors = Get-WmiObject -Class WmiMonitorID -Namespace root\wmi -ComputerName $ComputerName -ErrorAction Continue
    }
    catch {
        Write-Error $_.Exception.Message
        Continue
    }

    $monitor1 = $null
    $monitor2 = $null
    if ($monitors.Length -gt 1) {
        $monitor1 = [System.Text.Encoding]::ASCII.GetString($monitors[0].UserFriendlyName)
        $monitor1SN = [System.Text.Encoding]::ASCII.GetString($monitors[0].SerialNumberID)
        $monitor2 = [System.Text.Encoding]::ASCII.GetString($monitors[1].UserFriendlyName)
        $monitor2SN = [System.Text.Encoding]::ASCII.GetString($monitors[1].SerialNumberID)
    }
    else {
        $monitor1 = [System.Text.Encoding]::ASCII.GetString($monitors.UserFriendlyName)
        $monitor1SN = [System.Text.Encoding]::ASCII.GetString($monitors.SerialNumberID)
    }
   [pscustomobject]@{
        ComputerName = $computer.Name
        Model = $computer.Model
        SystemSerialNumber = $bios.SerialNumber
        RAM = [math]::Round(($ram.Capacity | Measure-Object -Sum).Sum / 1GB, 2).ToString() + " GB"
        HardDrive = [math]::Round(($drives | Measure-Object -Property Size -Sum).Sum / 1GB, 2).ToString() + " GB"
        FreeSpace = [math]::Round(($drives | Measure-Object -Property FreeSpace -Sum).Sum / 1GB, 2).ToString() + " GB"
        Monitor1 = $monitor1
        Monitor1SerialNumber = $monitor1SN
        Monitor2 = $monitor2
        Monitor2SerialNumber = $monitor2SN
        LaptopSN = $null
        LaptopTag = $null

    }

}
# # Call the function and store the result in a variable
# $info = Get-HardWareInfo -ComputerName "PC1"
# # Export the result to a CSV file
# $info | Export-Csv -Path "C:\Intel\UserAsset.csv" -NoTypeInformation -Append
# $info = Get-HardWareInfo -ComputerName "PC1"
# $info | Export-Csv -Path "C:\Intel\UserAsset.csv" -NoTypeInformation -Append
# $info = Get-HardWareInfo -ComputerName "PC1"
# $info | Export-Csv -Path "C:\Intel\UserAsset.csv" -NoTypeInformation -Append