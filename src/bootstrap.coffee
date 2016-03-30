# Require Modules
HoSAuth          = require('hos-auth')
HoSCom           = require('hos-com')
serviceContract  = require('./Contract')
acl              = require('./Acl')

# Instantiate HoSAuth
authenticationService = new HoSAuth()
authenticationService.connect()

# Register message handler
authenticationService.on 'message', (msg)->
    acl.handleMessage(msg)


c1 = JSON.parse JSON.stringify serviceContract

c1.serviceDoc.basePath = '/cunik'

HoSService = new HoSCom(serviceContract)

HoSService.connect().then ()->
    pub = new HoSCom(c1)
    pub.connect().then ()->
        pubFunc = ()->
            pub.sendMessage({foo: "1"} , "/user", {task: '/users', method: 'get'})
            .then (reply)->
                console.log reply
            .catch (err)->
                console.log err

        # setInterval pubFunc, 2000
        pubFunc()

msgCount = 0

HoSService.on '/users.get', (msg)->
    msgCount++
    # console.log 'received'
    msg.reply({fake: msgCount})




module.exports = HoSAuth
