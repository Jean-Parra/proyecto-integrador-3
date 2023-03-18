const { Schema, model } = require('mongoose');

const RequestSchema = new Schema({
    user: { type: Object, required: true },
    origin: { type: String, required: true },
    destination: { type: String, required: true },
    distance: { type: Number, required: true },
    price: { type: Number, required: true },
    selectedOption: { type: String, required: true },
    enable: { type: Boolean, default: true }
});

module.exports = model('Request', RequestSchema);