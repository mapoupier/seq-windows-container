# entrypoint.ps1

# Check if SEQ is already installed
$seqInstalled = Test-Path "C:\Program Files\Seq\Seq.exe"

if (-Not $seqInstalled) {
    Write-Host "SEQ not found, running installation script."
    & C:\install-seq.ps1
} else {
    Write-Host "SEQ is already installed, skipping installation."
}

# Start SEQ service
& "C:\Program Files\Seq\Seq.exe" run --storage="$env:SEQ_DATA_PATH"
