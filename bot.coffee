Twit = require 'twit'
_ = require 'underscore'
_.mixin require('underscore.deferred')
config = require('./config.js')

twit = new Twit config
words = []

twitOptions =
  owner_screen_name:  config.owner_screen_name
  slug:               config.slug
  include_rts:        true

twit.get 'lists/statuses', twitOptions, (error, tweets) ->

  for tweet in tweets
    tweet = tweet.text.replace /[^a-zA-Z ]/g, ''
    tweetWords = tweet.split ' '

    for oneWord in tweetWords
      if shouldInclude(oneWord)

        wordObj = _.findWhere words,
          word: oneWord
        if not _.isEmpty(wordObj)
          wordObj.count += 1
        else
          words.push
            word: oneWord,
            count: 1

  console.log 'sorted words: ', _.sortBy(words, (w) ->
    w.count
  )

# Whether or not a word is eligible for use
shouldInclude = (word) ->
  word = word.toLowerCase()
  shallInclude = true

  # Filter out links
  if word.substring(0,3) is 'http'
    shallInclude = false

  shallInclude

