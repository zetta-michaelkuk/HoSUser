module.exports = (mongoose)->
    mongoUrl = if process.env.MONGO_URL then process.env.MONGO_URL else 'mongodb://localhost/authservice'

    mongoose.connect(mongoUrl);
