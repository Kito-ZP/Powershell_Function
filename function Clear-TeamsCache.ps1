function Clear-TeamsCache {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        [Parameter(Mandatory=$true)]
        [string]$Username
    )
    $scriptBlock = {
        param($Username)
        $userProfilePath = (Get-WmiObject -Class Win32_UserProfile | Where-Object { $_.Special -eq $false -and $_.LocalPath -like "*\$Username" }).LocalPath
        if ($null -ne $userProfilePath) {
            $appData = Join-Path $userProfilePath 'AppData\Roaming\Microsoft\Teams'
            $teamsProcess = Get-Process -Name Teams -ErrorAction SilentlyContinue
            if ($null -ne $teamsProcess) {
                $teamsProcess | Stop-Process -Force
            }
            Remove-Item "$appData\*" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -ArgumentList $Username
}

# Usage:
# Clear-TeamsCache -ComputerName 'RemotePCName' -Username 'username'
