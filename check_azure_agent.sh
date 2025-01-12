#!/bin/bash

# Function to check if the agent is installed
check_agent_installed() {
    if systemctl list-units --type=service | grep -q "himds.service"; then
        echo "Azure Connected Machine Agent is installed."
        return 0
    else
        echo "Azure Connected Machine Agent is not installed."
        return 1
    fi
}

# Function to check if the agent is running
check_agent_running() {
    if systemctl is-active --quiet himds; then
        echo "Azure Connected Machine Agent is running."
    else
        echo "Azure Connected Machine Agent is not running. Starting the service..."
        sudo systemctl start himds
    fi
}

# Function to enable the agent at startup
enable_agent_startup() {
    echo "Ensuring the Azure Connected Machine Agent is enabled at startup..."
    sudo systemctl enable himds
    echo "Azure Connected Machine Agent is now set to start on boot."
}

# Optional: Install the agent if not installed
install_agent() {
    echo "Installing the Azure Connected Machine Agent..."
    curl -fsSL https://aka.ms/azure-connectedmachine-agent | sudo bash
    echo "Installation complete."
}

# Main script logic
echo "Checking Azure Connected Machine Agent status..."
if check_agent_installed; then
    check_agent_running
    enable_agent_startup
else
    echo "Would you like to install the Azure Connected Machine Agent? (yes/no)"
    read -r user_input
    if [[ "$user_input" == "yes" ]]; then
        install_agent
        enable_agent_startup
    else
        echo "Exiting without installation."
    fi
fi
