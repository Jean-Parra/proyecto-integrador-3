const { Schema, model } = require('mongoose');

const RequestSchema = new Schema({
    email: String,
    origin: String,
    destination: String,
    distance: Number,
    price: Number,
    selectedOption: String,
    enable: { type: Boolean, default: true }
});

module.exports = model('Request', RequestSchema);