config            = require './config.js'
Twit              = require 'twit'
_                 = require 'underscore'
GoogleSpreadsheet = require './lib/google_spreadsheet'
_.mixin require('underscore.deferred')

twit = new Twit config.twit
words = []
shitDanSaysKey = "0An83nE2S7sImdExNVVhENWxyNG1oN29rWWRWSUNiU3c"

twitOptions =
  owner_screen_name:  config.twitter.owner_screen_name
  slug:               config.twitter.slug
  include_rts:        true

sendTweet = (tweet) ->
  tweet = "Shit Dan says: '#{tweet}'"
  try
    twit.post 'statuses/update', {status: tweet}, (err, reply) ->
      console.log "Tweeting error: ", err
      console.log "Tweet reply: ", reply
  catch e
    console.log "ERROR: ", e

tweetOnce = ()->
  googleSpreadsheet = new GoogleSpreadsheet()
  googleSpreadsheet.load shitDanSaysKey, (result) ->
    tweet = pickRandom(result)
    sendTweet tweet

pickRandom = (obj) ->
  obj[Math.round(Math.random() * obj.length)]


# Run it!
# loadWords()
tweetOnce()
setInterval(tweetOnce, 1000*60*60*12)

