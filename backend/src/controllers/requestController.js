const { Router } = require('express')
const router = Router();
const Solicitud = require('../models/requestModal');


router.post('/solicitudes', async(req, res) => {
    const { usuario, origen, destino, distancia, precio, tipoPago } = req.body;
    const solicitud = new Solicitud({
        usuario,
        origen,
        destino,
        distancia,
        precio,
        tipoPago,
        disponible: true,
    });
    try {
        const nuevaSolicitud = await solicitud.save();
        res.status(201).json({ message: 'Solicitud creada exitosamente', solicitud: nuevaSolicitud });
    } catch (error) {
        res.status(500).json({ message: 'Error al crear la solicitud', error });
    }
});

module.exports = router;