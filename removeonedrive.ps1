# Script purpose: Disable onedrive setup in default user profile
# Define the path to the default user's NTUSER.DAT file
$ntuserPath = "C:\Users\Default\NTUSER.DAT"

# Define the registry key and value to delete
$regKeyPath = "Software\Microsoft\Windows\CurrentVersion\Run"
$regValueName = "OneDriveSetup"

# Load the NTUSER.DAT hive
if (Test-Path $ntuserPath) {
    reg load HKU\TempHive $ntuserPath
    Write-Output "NTUSER.DAT loaded successfully."

    # Delete the specified registry entry
    $regKey = "HKU\TempHive\$regKeyPath"
    $regValue = Get-ItemProperty -Path "Registry::$regKey" -Name $regValueName -ErrorAction SilentlyContinue
    if ($regValue -ne $null -and $regValue.$regValueName -is [string]) {
        Remove-ItemProperty -Path "Registry::$regKey" -Name $regValueName
        Write-Output "Registry entry '$regKeyPath\$regValueName' deleted successfully."
    } else {
        Write-Output "Registry entry '$regKeyPath\$regValueName' not found or not of type REG_SZ."
    }
    
    # Unload the NTUSER.DAT hive
    reg unload HKU\TempHive
    Write-Output "NTUSER.DAT unloaded successfully."
} else {
    Write-Output "NTUSER.DAT file not found at path: $ntuserPath"
}
