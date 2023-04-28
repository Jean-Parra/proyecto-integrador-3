const { Router } = require('express')
const router = Router();
const Solicitud = require('../models/requestModal');
const Viaje = require('../models/tripModal');
const userShema = require('../models/userModal');



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

router.get('/solicitudes/aceptadas', async (req, res) => {
    try {
    const viajesAceptados = await Viaje.find();
    res.status(200).json(viajesAceptados);
    } catch (error) {
    console.log(error);
    res.status(500).json({ message: 'Error al obtener las solicitudes aceptadas', error });
    }
});

router.post('/usuarios/edits/:email', async (req, res) => {
    try {
        const { email } = req.params;
        const { name, lastname, phone } = req.body;

        // Buscar el usuario por correo electrónico
        const usuario = await userShema.findOne({ email });

        if (!usuario) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        // Actualizar los datos del usuario
        usuario.name = name || usuario.name;
        usuario.lastname = lastname || usuario.lastname;
        usuario.phone = phone || usuario.phone;

        // Guardar los cambios en la base de datos
        await usuario.save();

        res.status(200).json({ message: 'Usuario actualizado correctamente', usuario });
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: 'Error al actualizar el usuario', error });
    }
});






module.exports = router;