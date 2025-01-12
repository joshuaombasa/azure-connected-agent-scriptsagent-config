# Function to check if the agent is installed
function Check-AgentInstalled {
    $serviceName = "himds"
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service) {
        Write-Output "Azure Connected Machine Agent is installed."
        return $true
    } else {
        Write-Output "Azure Connected Machine Agent is not installed."
        return $false
    }
}

# Function to check if the agent is running
function Check-AgentRunning {
    $serviceName = "himds"
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service.Status -eq "Running") {
        Write-Output "Azure Connected Machine Agent is running."
    } else {
        Write-Output "Azure Connected Machine Agent is not running. Starting the service..."
        Start-Service -Name $serviceName
        if ($?) {
            Write-Output "Azure Connected Machine Agent started successfully."
        } else {
            Write-Output "Failed to start Azure Connected Machine Agent."
        }
    }
}

# Function to enable the agent to start on boot
function Enable-AgentStartup {
    $serviceName = "himds"
    Set-Service -Name $serviceName -StartupType Automatic
    Write-Output "Azure Connected Machine Agent is now set to start on boot."
}

# Function to install the agent (optional)
function Install-Agent {
    Write-Output "Installing the Azure Connected Machine Agent..."
    Invoke-WebRequest -Uri "https://aka.ms/azure-connectedmachine-agent" -OutFile "InstallAgent.ps1"
    .\InstallAgent.ps1
    Remove-Item -Path "InstallAgent.ps1" -Force
    Write-Output "Installation complete."
}

# Main script logic
Write-Output "Checking Azure Connected Machine Agent status..."
if (Check-AgentInstalled) {
    Check-AgentRunning
    Enable-AgentStartup
} else {
    $response = Read-Host "Azure Connected Machine Agent is not installed. Would you like to install it? (yes/no)"
    if ($response -eq "yes") {
        Install-Agent
        Enable-AgentStartup
    } else {
        Write-Output "Exiting without installation."
    }
}
