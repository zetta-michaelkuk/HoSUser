module.exports = (jwt)->

    acl =
        admin: "*"
        user:
            User:
                login: ["POST", "DELETE"]
        guest:
            User:
                login: ["POST"]

    isAuthorized = (role, service, task, method)->
        switch role
            when "admin" then return true
            else
                try
                    return acl[role][service][task].indexOf(method) != -1
                catch error
                    return false

    handleMessage: (msg)->
        appId = msg.properties.appId.split('.')

        if appId[0] != "Api"
            return msg.accept()

        service = msg.fields.routingKey
        headers = msg.properties.headers

        if !headers.authorization
            if isAuthorized('guest', service, headers.task, headers.method)
                return msg.accept()
            else
                return msg.reject("Unauthorized", 401)

        token = headers.authorization.split(' ')
        if token[0].toLowerCase() != 'bearer'
             return msg.reject("Unauthorized", 401)
        else
            jwt.verify(token[1]).then (payload)=>
                if isAuthorized(payload.asd, service, headers.task, headers.method)
                    msg.accept()
                    return
                else
                    msg.reject("Unauthorized", 401)
                    return
            .catch (err)->
                msg.reject("Unauthorized", 401)
                return
