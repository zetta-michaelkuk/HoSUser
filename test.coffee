# jwt = require './src/Jwt'
# signOptions =
#     expiresIn: '7d'
#     algorithm: 'RS256'
#
# payload =
#     service1: 'rw'
#     service2: 'rw'
#     sub: 'Michael'
#     iss: 'AllMighty'
#
# jwt.sign('Michael')
# .then (token)->
#     console.log token
#     return token
# .then jwt.verify
# .then (decoded)->
#     console.log decoded
#
# regex = /^(?=.*?[A-Z])(?=(.*[a-z]){1,})(?=(.*[\d]){1,})(?=(.*[\W]){1,})(?!.*\s).{8,}$/
#
# console.log regex.test 'Michael!2'

require('./src/Database')
User = require('./src/User')

User.login({email: 'admin1@zettabox.com', password: 'Zettabox1234!'})
.then (u)->
    console.log u

    return u.createToken()
.then (t)->
    console.log t
