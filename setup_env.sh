#!/bin/bash

# Function to prompt user for input and save it
get_input() {
    read -p "$1: " value
    echo "$2=$value" >> .env
}

# Create a new .env file or clear the existing one
> .env

echo "Enter values for the .env file:"

# General settings
get_input "Enter ADDRESS" "ADDRESS"
get_input "Enter COIN name" "COIN"
get_input "Enter SYMBOL" "SYMBOL"

# Database credentials
echo -e "\n# Database Credential" >> .env
get_input "Enter Database Username (DBUSER)" "DBUSER"
get_input "Enter Database Password (DBPASSWORD)" "DBPASSWORD"
get_input "Enter Database Name (DATABASE)" "DATABASE"

# RPC credentials
echo -e "\n# RPC Credential" >> .env
get_input "Enter RPC Username (RPCUSER)" "RPCUSER"
get_input "Enter RPC Password (RPCPASSWORD)" "RPCPASSWORD"
get_input "Enter RPC Port (RPCPORT)" "RPCPORT"

echo "✅ .env file has been created successfully!"
