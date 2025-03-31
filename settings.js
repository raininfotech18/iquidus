require('dotenv').config();
const fs = require('fs');

// Read the settings.json.template file
const templateFile = 'settings.json.template';
const outputFile = 'settings.json';

if (!fs.existsSync(templateFile)) {
    console.error(`❌ Error: ${templateFile} not found!`);
    process.exit(1);
}

// Function to remove comments from JSON-like files
function removeJsonComments(jsonString) {
    return jsonString
        .replace(/\/\*[\s\S]*?\*\//g, '')  // Remove block comments /* ... */
        .replace(/\/\/.*/g, '')            // Remove line comments //
        .trim();
}

// Read the file and clean it
let rawTemplate = fs.readFileSync(templateFile, 'utf-8');
let cleanJson = removeJsonComments(rawTemplate);

let settings;
try {
    settings = JSON.parse(cleanJson);
} catch (error) {
    console.error(`❌ JSON parsing error: ${error.message}`);
    console.error(`🔍 Check ${templateFile} for invalid JSON.`);
    process.exit(1);
}

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

// Save the new settings.json
fs.writeFileSync(outputFile, JSON.stringify(settings, null, 2));

console.log(`✅ ${outputFile} has been successfully generated from ${templateFile}!`);
