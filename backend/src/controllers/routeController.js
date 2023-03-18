const express = require('express');
const router = express.Router();

const Price = require('../models/priceModal');

router.get('/prices', async(req, res) => {
    try {
        const prices = await Price.find();
        res.json(prices);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error al buscar precios');
    }
});



module.exports = router;