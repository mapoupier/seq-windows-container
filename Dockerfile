# Use a base image with Windows and PowerShell
FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Set environment variables for SEQ configuration
ENV SEQ_VERSION=2024.1.6522 \
    SEQ_DATA_PATH="C:\\seq_data" \
    SEQ_ADMIN_USER="admin" \
    SEQ_ADMIN_PASS="password"

# Create a directory for SEQ data
RUN mkdir %SEQ_DATA_PATH%

COPY Seq-2024.3.12250.msi C:\\seq_installer.msi

# Copy the PowerShell install script into the container
COPY install-seq.ps1 C:\\install-seq.ps1

# Set up the entry point script that runs the install script only on the first start
COPY entrypoint.ps1 C:\\entrypoint.ps1

# Expose SEQ web port
EXPOSE 5341

# Run the entry point script
ENTRYPOINT ["powershell.exe", "-File", "C:\\entrypoint.ps1"]
