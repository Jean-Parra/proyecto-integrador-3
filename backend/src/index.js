const app = require('./app')
require('./connection');

const PORT = 80;

async function init() {
    await app.listen(PORT, '0.0.0.0');
    console.log(`Servidor corriendo en http://upbcar.bucaramanga.upb.edu.co:${PORT}`);
}

init();