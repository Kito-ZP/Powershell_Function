function Install-DellBIOSUpdate {
    param (
        [string]$computerName,
        [string]$sourceFile，
	# "C:\Update\BiosUpdate\OptiPlex_7010_1.8.0_SEMB.exe",
        [string]$destFolder，
	# "C:\Update\BiosUpdate\",
        [string]$logFolder
	# "C:\BiosUpdateLogs\"
    )

       # Ensure destination and log folders exist on remote computer
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        param($destFolder, $logFolder)
        $destFolder, $logFolder | ForEach-Object {
            if (-not (Test-Path -Path $_)) {
                New-Item -ItemType Directory -Path $_
            }
        }
    } -ArgumentList $destFolder, $logFolder

# Determine the file name of the BIOS update executable
    $fileName = Split-Path -Path $sourceFile -Leaf

    # Copy BIOS update file to remote computer
    $remoteDestPath = "\\$computerName\C$\Update\BiosUpdate\$fileName"
    Copy-Item -Path $sourceFile -Destination $remoteDestPath -Force

    # Execute BIOS update and reboot on remote computer
    Invoke-Command -ComputerName $computerName -ScriptBlock {
        param($fileName, $logFolder)
        $destFile = "C:\Update\BiosUpdate\$fileName"
        $logFile = "$logFolder\$($env:COMPUTERNAME)_BIOSUpdate.log"
        Start-Process -FilePath $destFile -ArgumentList "/s /l=$logFile" -Wait -NoNewWindow
        Restart-Computer -Force
    } -ArgumentList $fileName, $logFolder
}
# Install-DellBIOSUpdate -computerName "PC1" -sourceFile "C:\Update\BiosUpdate\OptiPlex_7010_1.8.0_SEMB.exe" -destFolder "C:\Update\BiosUpdate\" -logFolder "C:\BiosUpdateLogs\"