# install-seq.ps1

# Define the MSI installer URL and destination
$seqInstallerUrl = "https://dl.datalust.co/2024.3.12250/win-x64/Seq-2024.3.12250.msi"
$installerPath = "C:\seq_installer.msi"

# Download SEQ MSI Installer
Write-Host "Downloading SEQ version $env:SEQ_VERSION from $seqInstallerUrl"
# Invoke-WebRequest -Uri $seqInstallerUrl -OutFile $installerPath

# Install SEQ silently
Write-Host "Installing SEQ"
Start-Process msiexec.exe -ArgumentList "/i", $installerPath, "/quiet", "/qn", "/norestart", "/log", "C:\seq_install.log" -Wait

# Set up SEQ data path
Write-Host "Setting up SEQ data directory at $env:SEQ_DATA_PATH"
if (!(Test-Path -Path $env:SEQ_DATA_PATH)) {
    New-Item -ItemType Directory -Path $env:SEQ_DATA_PATH
}

Start-Process "C:\Program Files\Seq\Seq.exe" -ArgumentList "config", "create"

# Configure SEQ admin user and password
Write-Host "Creating SEQ config"
cd "\Program Files\Seq"
& .\Seq.exe config create --storage="$env:SEQ_DATA_PATH"
& .\Seq.exe config set --key="api.webServer" --value="Kestrel" --storage="$env:SEQ_DATA_PATH"
Write-Host "Configuring SEQ with admin user $env:SEQ_ADMIN_USER"
& .\Seq.exe config set --key="firstRun.adminUsername" --value="admin" --storage="$env:SEQ_DATA_PATH"
& .\Seq.exe config set --key="firstRun.adminPassword" --value="$env:SEQ_ADMIN_PASS" --storage="$env:SEQ_DATA_PATH"
