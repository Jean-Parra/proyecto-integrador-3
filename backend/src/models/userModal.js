const { Schema, model } = require('mongoose');
const bcrypt = require('bcrypt');

const userShema = new Schema({
    name: String,
    lastname: String,
    phone: String,
    email: { type: String, index: true },
    password: String,
    role: String
});

userShema.methods.encryptPassword = async(password) => {
    const salt = await bcrypt.genSalt(10);
    return bcrypt.hash(password, salt);
};

userShema.methods.validatePassword = function(password) {
    return bcrypt.compare(password, this.password);
};

module.exports = model('User', userShema)