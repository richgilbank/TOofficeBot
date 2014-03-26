ShitDanSays = require './lib/shit_dan_says'
schedule    = require 'node-schedule'
express     = require 'express'
_           = require 'underscore'
_.mixin require('underscore.deferred')


shitDanSays = new ShitDanSays()

# Scheduled
rule = new schedule.RecurrenceRule()
rule.hour = 16 # heroku runs at EST+4

# Run it!
schedule.scheduleJob rule, shitDanSays.tweetOnce

# Web interface
app = express()
app.get '/random', (req, res) ->
  res.send shitDanSays.pickRandom()
app.listen 3000

