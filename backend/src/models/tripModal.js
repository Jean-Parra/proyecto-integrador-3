const { Schema, model } = require('mongoose');

const TripSchema = new Schema({
    user: { type: String, required: true },
    driver: { type: String, required: true },
    origin: { type: String, required: true },
    destination: { type: String, required: true },
    distance: { type: Number, required: true },
    price: { type: Number, required: true },
    selectedOption: { type: String, required: true },
});

module.exports = model('Trip', TripSchema);