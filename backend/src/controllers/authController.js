const { Router } = require('express')
const router = Router();

const User = require('../models/userModal');
const DeletedUser = require('../models/deleteUserModal');
const verifyToken = require('./verifyToken');
const jwt = require('jsonwebtoken');
const config = require('../config');
const Trip = require('../models/tripModal');

router.post('/signup', async(req, res) => {
    try {
        const correo = await User.findOne({ email: req.body.email })
        if (correo) {
            return res.status(401).send('El correo ya esta registrado');
        }

        const { name, lastname, phone, email, password, role } = req.body;
        const user = new User({ name, lastname, phone, email, password, role });
        user.password = await user.encryptPassword(password);
        await user.save();

        const token = jwt.sign({ id: user.id }, config.secret, {
            expiresIn: '7d'
        });
        res.status(200).json({ auth: true, user: user, token: token });
    } catch (e) {
        console.log(e);
        res.status(500).send("Error al registrarse");
    }
});

router.post('/signin', async(req, res) => {
    try {
        const user = await User.findOne({ email: req.body.email })
        if (!user) {
            return res.status(404).send('El correo no existe');
        }
        const validPassword = await user.validatePassword(req.body.password, user.password);
        if (!validPassword) {
            return res.status(404).send('La contrasña es incorrecta');
        }
        const token = jwt.sign({ id: user._id }, config.secret, {
            expiresIn: '7d'
        });
        res.status(200).json({ auth: true, user: user, token: token });
    } catch (e) {
        console.log(e);
        res.status(500).send('Error al iniciar');
    }
});

router.get('/logout', function(req, res) {
    res.status(200).send({ auth: false, token: null });
});

router.get('/user', verifyToken, async(req, res) => {
    try {
        const user = await User.findById(req.userId); // busca el usuario por ID
        if (!user) {
            return res.status(404).send({ message: 'Usuario no encontrado' });
        }
        res.status(200).send(user); // envía el objeto de usuario encontrado
    } catch (error) {
        console.error(error);
        res.status(500).send({ message: 'Error al buscar usuario' });
    }
});


router.get('/users', async(req, res) => {
    try {
        const users = await User.find();
        res.status(200).json(users);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error retrieving users' });
    }
});

router.delete('/users/:email', (req, res) => {
    const email = req.params.email;
    const deleteReason = req.body.deleteReason;
    User.findOneAndDelete({ email: email }, (err, result) => {
        if (err) {
            res.sendStatus(500);
        } else if (!result) {
            res.sendStatus(404);
        } else {
            const deletedUser = new DeletedUser({
                name: result.name,
                lastname: result.lastname,
                email: result.email,
                role: result.role,
                deleteReason: deleteReason
            });
            deletedUser.save((err) => {
                if (err) {
                    res.sendStatus(500);
                } else {
                    res.sendStatus(200);
                }
            });
        }
    });
});

router.get('/users/:email', async(req, res) => {
    const email = req.params.email;

    try {
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }

        return res.status(200).json(user);
    } catch (error) {
        console.error(error);
        return res.status(500).json({ message: 'Error al obtener el usuario' });
    }
});

router.put('/users/:password', async(req, res) => {
    const { email, newPassword } = req.body;
    try {
        const user = await User.findOneAndUpdate({ email: email }, { password: newPassword }, { new: true });
        if (!user) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }
        return res.status(200).json({ message: 'Contraseña actualizada correctamente' });
    } catch (error) {
        return res.status(500).json({ message: 'Error al actualizar la contraseña' });
    }
});

router.get('/usuarios', async(req, res) => {
    try {
        const users = await User.find({ role: 'usuario' });
        res.status(200).json(users);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener los usuarios' });
    }
});

router.get('/usuarios/:id', async(req, res) => {
    try {
        const user = await User.findById(req.params.id);
        if (!user) {
            return res.status(404).json({ message: 'Usuario no encontrado' });
        }
        res.status(200).json(user);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener el usuario' });
    }
});



router.get('/conductores', async(req, res) => {
    try {
        const users = await User.find({ role: 'conductor' });
        res.status(200).json(users);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: 'Error al obtener los conductores' });
    }
});


router.get('/trips/:driver', async (req, res) => {
    const driverEmail = req.params.driver;
    try {
    const trips = await Trip.find({ driver: driverEmail });
    res.status(200).json(trips);
    } catch (err) {
    res.status(500).json({ message: err.message });
    }
});

router.get('/trips/user/:email', async (req, res) => {
    const userEmail = req.params.email;
    try {
      const trips = await Trip.find({ user: userEmail });
      res.status(200).json(trips);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  });




module.exports = router;