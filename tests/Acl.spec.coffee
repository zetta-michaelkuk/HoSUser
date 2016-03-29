describe 'Module: Acl', ()->

    beforeEach ()->
        @aclFactory = require('./../src/Acl/Acl')
        @jwtMock =
            sign: ()->
                return
            verify: ()->
                return

        @mockPromise =
            then: (callback)->
                @okCallback = callback
                return @
            catch: (callback)->
                @errorCallback = callback
                return @

        @msgMock =
            accept: ()->
                return
            reject: ()->
                return
            fields:
                routingKey: 'User'
            properties:
                appId: 'Api.12345'
                headers:
                    task: 'users'
                    method: "GET"
                    authorization: 'Bearer 1234567890abcdef'

        @acl = @aclFactory(@jwtMock)

    describe 'Factory', ()->
        it 'should return an object', ()->
            expect(typeof @acl).toBe('object')

        it 'returned object should have "handleMessage" method', ()->
            expect(typeof @acl.handleMessage).toBe('function')

    describe 'Method: handleMessage', ()->
        it 'should accept the message if not published by the API', ()->
            spyOn(@msgMock, 'accept')
            spyOn(@msgMock, 'reject')
            @msgMock.properties.appId = "User.12345"
            @acl.handleMessage(@msgMock)
            expect(@msgMock.accept).toHaveBeenCalled()
            expect(@msgMock.reject).not.toHaveBeenCalled()

        it 'should accept login attempt without authorization header', ()->
            @msgMock.properties.headers =
                task: 'login'
                method: 'POST'

            spyOn(@msgMock, 'accept')

            @acl.handleMessage(@msgMock)

            expect(@msgMock.accept).toHaveBeenCalled()

        it 'should call jwt.verify method if authorizaton header is present', ()->
            spyOn(@jwtMock, 'verify').and.returnValue(@mockPromise)

            @acl.handleMessage(@msgMock)
            expect(@jwtMock.verify).toHaveBeenCalled()

        it 'should accept any message from admin', ()->
            @msgMock.fields.routingKey = 'MockServiceThatDoesNotExist'
            spyOn(@jwtMock, 'verify').and.returnValue(@mockPromise)
            spyOn(@msgMock, 'accept')
            spyOn(@msgMock, 'reject')
            @acl.handleMessage(@msgMock)
            expect(@msgMock.reject).not.toHaveBeenCalled()
            @mockPromise.okCallback({asd: 'admin'})
            expect(@msgMock.accept).toHaveBeenCalled()

        it 'should implicitly deny access to guest role', ()->
            delete @msgMock.properties.headers.authorization

            spyOn(@jwtMock, 'verify').and.returnValue(@mockPromise)
            spyOn(@msgMock, 'accept')
            spyOn(@msgMock, 'reject')

            @acl.handleMessage(@msgMock)

            expect(@msgMock.accept).not.toHaveBeenCalled()
            expect(@msgMock.reject).toHaveBeenCalled()

        it 'should implicitly deny access to user role', ()->
            @msgMock.fields.routingKey = 'MockServiceThatDoesNotExist'
            spyOn(@jwtMock, 'verify').and.returnValue(@mockPromise)
            spyOn(@msgMock, 'accept')
            spyOn(@msgMock, 'reject')
            @acl.handleMessage(@msgMock)
            @mockPromise.okCallback({asd: 'user'})
            expect(@msgMock.reject).toHaveBeenCalled()

        it 'should deny access to method not in allowed array', ()->
            @msgMock.fields.routingKey = 'User'
            @msgMock.properties.headers.method = "PUT"
            @msgMock.properties.headers.task = "login"
            spyOn(@jwtMock, 'verify').and.returnValue(@mockPromise)
            spyOn(@msgMock, 'accept')
            spyOn(@msgMock, 'reject')
            @acl.handleMessage(@msgMock)
            @mockPromise.okCallback({asd: 'user'})
            expect(@msgMock.accept).not.toHaveBeenCalled()
            expect(@msgMock.reject).toHaveBeenCalled()
