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

# Initialize HoS
HoSService = new HoSCom(serviceContract)

# Connect HoS to RabbitMQ
HoSService.connect()

# Log Sucessfull Connection
.then ()->
    console.log 'Listening'

# Log Connection Error and Exit the Process
.catch (err)->
    console.error "Failed to initilize HoS, exiting."
    process.exit()

module.exports = HoSAuth
