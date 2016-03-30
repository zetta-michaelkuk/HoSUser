module.exports = (Promise, mongoose, bcrypt, jwt)->

    emailRegex = /^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$/

    schemaOpts =
        collection: 'users'
        autoIndex: false

    invToken =
        token:
            type: String
            required: true
        expires:
            type: Date
            required: true
            index: true

    bucketSchema =
        bucketId:
            type: mongoose.Schema.Types.ObjectId
            required: true
            index: true

        permissions:
            type: String
            required: true
            enum: ['R','W','A']

        relativePath:
            type: String
            required: true

    userSchema =
        email:
            type: String
            required: true
            index:
                unique: true
            validate:
                validator: (value)->
                    emailRegex.test(value)
                message: '{VALUE} is not a valid email address'

        password:
            type: String
            required: true

        role:
            type: String
            required: true,
            enum: ['admin', 'user']

        buckets:
            type: [bucketSchema]
            default: ()-> return []

        quota:
            type: Number
            required: true
            default: 2000000000
            min: 0

        invalidTokens:
            type: [invToken]
            default: ()-> return []



    schema = new mongoose.Schema(userSchema, schemaOpts)

    schema.pre 'save', (next)->
        return next() unless @isModified('password')

        bcrypt.genSalt 12, (err, salt)=>
            return next(err) if err

            bcrypt.hash @password, salt, (err, hash)=>
                return next(err) if err

                @password = hash
                next()

    schema.methods.comparePassword = (candidatePassword)->
        return new Promise (resolve, reject)=>
            bcrypt.compare candidatePassword, @password, (err, match)=>
                if err
                    err.code = 500
                    return reject(err)

                if !match
                    err = new Error('Invalid credentials')
                    err.code = 401
                    return reject(err)

                return resolve(@)

    schema.methods.createToken = ()->
        return jwt.sign(@_id, @role)

    schema.statics.login = (credentials)->
        return @findOne({email: credentials.email}).exec()
        .then (candidate)->
            throw new Error 'Invalid credentials' unless candidate
            return candidate.comparePassword(credentials.password)

    schema.statics.logout = (userId, token)->
        return @findOne({_id: userId}).exec().then (user)=>
            user.invalidTokens.push({token: token, expires: new Date(jwt.parse(token).payload.exp)})
            return user.save()

    schema.statics.getUsers = (query={})->
        query.limit ?= 1000
        query.page ?= 0
        
        return @find()
        .select('-password -invalidTokens')
        .skip(query.limit * query.page)
        .limit(query.limit)
        .exec()


    return mongoose.model("User", schema)
