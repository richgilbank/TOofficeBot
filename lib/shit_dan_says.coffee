config            = require '../config.js'
Twit              = require 'twit'
GoogleSpreadsheet = require './google_spreadsheet'
schedule          = require 'node-schedule'
_                 = require 'underscore'
_.mixin require('underscore.deferred')

class ShitDanSays
  key = "0An83nE2S7sImdExNVVhENWxyNG1oN29rWWRWSUNiU3c"

  constructor: ->
    @twit = new Twit config.twit
    @spreadsheetData = []
    @spreadsheet = new GoogleSpreadsheet().load(key).done (data) => @spreadsheetData = data
    @scheduleRefresh()

  scheduleRefresh: ->
    rule = new schedule.RecurrenceRule()
    rule.hour = 15
    schedule.scheduleJob rule, =>
      spreadsheet = new GoogleSpreadsheet().load(key).done (data) => @spreadsheetData = data

  sendTweet: (tweet) =>
    try
      @twit.post 'statuses/update', {status: tweet}, (err, reply) ->
        console.log "Tweeting error: ", err
        console.log "Tweet reply: ", reply
    catch e
      console.log "ERROR: ", e

  tweetOnce: =>
    tweet = "Shit Dan says: #{@pickRandom()}"
    @sendTweet tweet

  pickRandom: =>
    @spreadsheetData[Math.round(Math.random() * @spreadsheetData.length)]

module.exports = ShitDanSays

