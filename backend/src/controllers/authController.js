const { Router } = require('express')
const router = Router();

const User = require('../models/userModal');
const verifyToken = require('./verifyToken');
const jwt = require('jsonwebtoken');
const config = require('../config');

router.post('/signup', async(req, res) => {
    try {
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

router.get('/ID', verifyToken, (req, res) => {
    res.status(200).send(req.user);
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

router.delete('/usuarios', (req, res) => {
    const email = req.query.email;
    User.findOneAndDelete({ email: email }, (err, result) => {
        if (err) {
            res.sendStatus(500);
        } else if (!result) {
            res.sendStatus(404);
        } else {
            res.sendStatus(200);
        }
    });
});


module.exports = router;