const app = require('./app')
require('./connection');

async function init() {
    await app.listen(80);
    console.log('Servidor en Localhost:80')
}

init();