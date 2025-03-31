require('dotenv').config();
const fs = require('fs');

// Read the settings.json template
let settings = JSON.parse(fs.readFileSync('settings.json', 'utf-8'));

// Override values with environment variables
settings.address = process.env.ADDRESS || settings.address;
settings.coin = process.env.COIN || settings.coin;
settings.symbol = process.env.SYMBOL || settings.symbol;

settings.dbsettings.user = process.env.DBUSER || settings.dbsettings.user;
settings.dbsettings.password = process.env.DBPASSWORD || settings.dbsettings.password;
settings.dbsettings.database = process.env.DATABASE || settings.dbsettings.database;

settings.wallet.username = process.env.RPCUSER || settings.wallet.username;
settings.wallet.password = process.env.RPCPASSWORD || settings.wallet.password;
settings.wallet.port = process.env.RPCPORT || settings.wallet.port;

// Save the new settings.json (optional step)
fs.writeFileSync('settings.json', JSON.stringify(settings, null, 2));

console.log('Settings updated successfully.');