module.exports = (Promise, jsonwebtoken, key, cert)->
    signOptions =
        expiresIn: '30d',
        algorithm: 'RS256',
        issuer: 'HoSAuth'

    jwt =
        sign: (subject, role='guest')->
            return new Promise (resolve, reject)=>
                jsonwebtoken.sign {sub: subject, asd: role}, key, signOptions, (token)->
                    resolve(token)


        verify: (token)->
            return new Promise (resolve, reject)=>
                jsonwebtoken.verify token, cert, (err, decoded)->
                    if err
                        err.code = 401
                        return reject(err)
                    return resolve(decoded)

        parse: (token)->
            parsedToken = {}

            parts = token.split('.')
            parsedToken.headers = JSON.parse((new Buffer(parts[0], 'base64')).toString())
            parsedToken.payload = JSON.parse((new Buffer(parts[1], 'base64')).toString())
            return parsedToken

    return jwt
