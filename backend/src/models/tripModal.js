const { Schema, model } = require('mongoose');

const TripSchema = new Schema({
    user: { type: Object, required: true },
    diver: { type: Object, required: true },
    origin: { type: String, required: true },
    destination: { type: String, required: true },
    distance: { type: Number, required: true },
    price: { type: Number, required: true },
    selectedOption: { type: String, required: true },
});

module.exports = model('Trip', TripSchema);