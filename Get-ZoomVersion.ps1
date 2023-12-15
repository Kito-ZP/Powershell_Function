function Get-ZoomVersion {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName
    )

    $scriptBlock = {
        try {
            
            # This path might need to be adjusted based on the Zoom installation
            $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX"

            # Check if the path exists in the registry
            if (Test-Path $regPath) {
                # Get the version from the registry
                $zoomVersion = (Get-ItemProperty -Path $regPath).DisplayVersion
                return $zoomVersion
            } else {
                return "Zoom is not installed."
            }
        } catch {
            return "Error: $_"
        }
    }

    # Execute the script block on the remote computer
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock
}

# Example Usage:
# Get-ZoomVersion -ComputerName "RemotePC123"
