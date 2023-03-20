const { Router } = require('express')
const router = Router();
const Solicitud = require('../models/requestModal');


router.post('/solicitudes', async(req, res) => {
    const { email, origin, destination, distance, price, selectedOption } = req.body;
    const solicitud = new Solicitud({
        email,
        origin,
        destination,
        distance,
        price,
        selectedOption,
        enable: true,
    });

    try {
        const nuevaSolicitud = await solicitud.save();
        res.status(201).json({ message: 'Solicitud creada exitosamente', solicitud: nuevaSolicitud });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al crear la solicitud', error });
    }
});

module.exports = router;