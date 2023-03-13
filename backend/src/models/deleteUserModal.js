const { Schema, model } = require('mongoose');

const deleteUserModal = new Schema({
    name: String,
    lastname: String,
    phone: String,
    email: String,
    role: String,
    deleteReason: String
});

module.exports = model('DeleteUser', deleteUserModal)