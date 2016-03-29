Mongoose    =   require('mongoose').Mongoose
mongoose    =   new Mongoose()
mockgoose   =   require('mockgoose')
mockgoose(mongoose)

describe 'Module: User', ()->

    beforeEach (done)->
        @Promise        =   require('bluebird')
        @bcrypt         =   require('bcrypt')
        @jwt            =   require('./../src/Jwt')
        @userFactory    =   require('./../src/User/User')
        @instance       =   @userFactory(@Promise, mongoose, @bcrypt, @jwt)
        mongoose.connect 'mongodb://localhost/testdb', (err)->
            done(err)

    afterAll (done)->
        mongoose.disconnect ()->
            done()


    describe 'Factory', ()->
        it 'should return Mongoose model', ()->
            # expect(@instance instanceof mongoose.Schema).toBe(true)
