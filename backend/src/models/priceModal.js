const { Schema, model } = require('mongoose');

const priceSchema = new Schema({
    minimum: Number,
    kilometres: Number
});

module.exports = model('Price', priceSchema)