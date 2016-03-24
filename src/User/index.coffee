Promise     =   require('bluebird')
mongoose    =   require('mongoose')
bcrypt      =   require('bcrypt')
jwt         =   require('./../Jwt')

module.exports = require('./User')(Promise, mongoose, bcrypt, jwt)
