const { Router } = require('express')
const router = Router();
const Solicitud = require('../models/requestModal');
const Viaje = require('../models/tripModal');


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

router.get('/solicitudes/activas', async(req, res) => {
    try {
        const solicitudes = await Solicitud.find({ enable: true });
        res.status(201).json({ solicitudes });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al obtener las solicitudes activas', error });
    }
});

router.post('/solicitudes/aceptar', async(req, res) => {
    const { user, driver, origin, destination, distance, price, selectedOption } = req.body;
    const viaje = new Viaje({
        user,
        driver,
        origin,
        destination,
        distance,
        price,
        selectedOption
    });
    try {
        const nuevoViaje = await viaje.save();
        res.status(201).json({ message: 'viaje creada exitosamente', vieje: nuevoViaje });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al guardar viaje', error });
    }
});


module.exports = router;