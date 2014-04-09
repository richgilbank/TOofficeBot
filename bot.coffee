ShitDanSays = require './lib/shit_dan_says'
schedule    = require 'node-schedule'
express     = require 'express'
_           = require 'underscore'
_.mixin require('underscore.deferred')


shitDanSays = new ShitDanSays()

# Scheduled
rule = new schedule.RecurrenceRule()
rule.hour = 21 # heroku runs at EST+4
rule.minute = 17

# Run it!
schedule.scheduleJob rule, shitDanSays.tweetOnce

# Web interface
app = express()
app.get '/random', (req, res) ->
  res.send shitDanSays.pickRandom()
port = process.env.PORT || 3000
app.listen port

