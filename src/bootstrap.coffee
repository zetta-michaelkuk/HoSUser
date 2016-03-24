HoSAuth          = require('hos-auth')
HoSCom           = require('hos-com')
serviceContract  = require('./Contract')

c1 = JSON.parse JSON.stringify serviceContract

c1.name = 'prase'

authenticationService = new HoSAuth()
authenticationService.connect()

authenticationService.on 'message', (msg)->
    # console.log JSON.stringify msg, null, 4
    msg.accept()

HoSService = new HoSCom(serviceContract)

HoSService.connect().then ()->
    pub = new HoSCom(c1)
    pub.connect().then ()->
        pubFunc = ()->
            pub.sendMessage({foo: "1"} , "User", {task: 'users', method: 'GET'})
            .then (reply)->
                console.log reply
            .catch (err)->
                console.log 'catched err'

        # setInterval pubFunc, 2000
        pubFunc()

msgCount = 0

HoSService.on 'users.GET', (msg)->
    console.log JSON.stringify msg, null, 4
    msgCount++
    # console.log 'received'
    if msgCount %% 3 isnt 0
        msg.reply({fake: msgCount})
    else
        msg.reject('err')




module.exports = HoSAuth
