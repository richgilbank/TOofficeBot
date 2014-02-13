http = require 'http'
_    = require 'underscore'

# https://github.com/mikeymckay/google-spreadsheet-javascript
class GoogleSpreadsheet
  requestOptions: (key) ->
    host: "spreadsheets.google.com"
    port: 80
    path: "/feeds/cells/#{key}/od6/public/basic?alt=json"

  load: (key, callback) ->
    data = ''
    req = http.request @requestOptions(key), (res) =>
      res.setEncoding('utf8')
      res.on 'data', (chunk) ->
        data += chunk

      res.on 'end', () =>
        callback @parseData(data)

    req.end()

  parseData: (data) ->
    data = JSON.parse data
    _.map data.feed.entry, (e) ->
      e.content.$t

module.exports = GoogleSpreadsheet

