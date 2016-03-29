describe 'Module: Jwt', ()->

    beforeEach ()->
        @jwtFactory = require('./../src/Jwt/Jwt')

        @Promise = require('bluebird')
        @jwtMock =
            sign: ()->
                return
            verify: ()->
                return
        @mockKey = ''
        @mockCert = ''

        @instance = @jwtFactory(@Promise, @jwtMock, @mockKey, @mockCert)

    describe 'Factory', ()->
        it 'should return an object', ()->
            expect(typeof @instance).toBe('object')

        it 'returned object should have method "sign"', ()->
            expect(typeof @instance.sign).toBe('function')

        it 'returned object should have method "verify"', ()->
            expect(typeof @instance.verify).toBe('function')

    describe 'Method: verify', ()->
        it 'should return a promise', ()->
            expect(@instance.verify() instanceof @Promise).toBe(true)

        it 'should call "jsonwebtoken.verify"', ()->
            spyOn(@jwtMock, 'verify')
            @instance.verify()
            expect(@jwtMock.verify).toHaveBeenCalled()

        it 'should reject the promise if verification fails', (done)->
            spyOn(@jwtMock, 'verify').and.callFake (token, cert, callback)->
                callback(new Error('Error'))

            @instance.verify().catch (err)->
                done()

        it 'should resolve the promise if verification is successful', (done)->
            spyOn(@jwtMock, 'verify').and.callFake (token, cert, callback)->
                callback(null, {})

            @instance.verify().then (p)->
                done()

        it 'should pass token to "jsonwebtoken.verify"', (done)->
            @mockToken = 'tokentoken'
            spyOn(@jwtMock, 'verify').and.callFake (token, cert, callback)=>
                expect(token).toBe(@mockToken)
                done()

            @instance.verify(@mockToken)

    describe 'Method: sign', ()->
        it 'should return a promise', ()->
            expect(@instance.sign() instanceof @Promise).toBe(true)

        it 'should call "jsonwebtoken.sign"', ()->
            spyOn(@jwtMock, 'sign')
            @instance.sign()
            expect(@jwtMock.sign).toHaveBeenCalled()

        it 'should resolve the promise with signed token', (done)->
            @mockUser = 'Admin1234'
            @mockRole = 'admin'

            spyOn(@jwtMock, 'sign').and.callFake (payload, key, signOptions, callback)=>
                expect(payload.sub).toBe(@mockUser)
                expect(payload.asd).toBe(@mockRole)
                callback('ok')

            @instance.sign(@mockUser, @mockRole).then (token)->
                expect(token).toBe('ok')
                done()
