#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Node.js (>= 8.17.0)
install_nodejs() {
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "Node.js installed: $(node -v)"
}

# Install MongoDB 4.2
install_mongodb() {
    echo "Installing MongoDB 4.2..."
    wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
    sudo apt-get update
    sudo apt-get install -y mongodb-org
    echo "MongoDB installed"
}

# Start MongoDB
start_mongodb() {
    echo "Starting MongoDB..."
    sudo systemctl start mongod
    sudo systemctl enable mongod
    echo "MongoDB started successfully!"
}

# Create MongoDB database and user
create_mongo_user() {
    mongo <<EOF
use $DATABASE
db.createUser({
    user: "$DBUSER",
    pwd: "$DBPASSWORD",
    roles: [{ role: "readWrite", db: "$DATABASE" }]
})
EOF
    
    echo "Database '$DATABASE' and user '$DBUSER' created successfully!"
}

# Function to prompt user for input and save it
get_input() {
    read -p "$1: " value
    echo "$2=$value" >> .env
    export $2="$value"
}

# Main Execution
if ! command_exists node || [[ "$(node -v)" < "v8.17.0" ]]; then
    install_nodejs
else
    echo "Node.js already installed: $(node -v)"
fi

if ! command_exists mongod; then
    install_mongodb
else
    echo "MongoDB already installed"
fi

start_mongodb

# Create a new .env file or clear the existing one
> .env

echo "Enter values for the .env file:"

# Explorer Title 
echo -e "\n# Explorer Title" >> .env
get_input "Enter Explorer Title" "TITLE"

# General settings
echo -e "\n# Genetal settings" >> .env
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

create_mongo_user

echo "✅ Setup complete! .env file has been created successfully!"

# Install dotenv package for settings.js
npm install dotenv

# Run settings.js to generate settings.json
node settings.js

echo "✅ settings.json file has been created successfully!"
