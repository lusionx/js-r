_         = require 'lodash'
async     = require 'async'
request   = require 'request'
fs        = require 'fs'
waterFall = require 'water-fall'

listUrl = 'http://js.ntwikis.com/rest/cancollezh/charactorquery'

getList = (callback) ->
  par =
    method: 'POST'
    url: listUrl
    form: ismobile: 1
  request par, (err, resp, body) ->
    return callback err if err
    ls = body.split '<li '
    r = /detailid=(\d+)/
    callback err, _.map ls, (e) ->
      ID: m[1] if m = r.exec e

iterGet = (m, callback) ->
  par =
    method: 'POST'
    url: 'http://js.ntwikis.com/rest/cancollezh/charactordetail'
    form:
      detailid: m.ID
      language: 'zh'
  request par, (err, resp, body) ->
    return callback err if err
    callback err, JSON.parse body


main = () ->
  wf = waterFall.create()
  wf.push (hooks, next) ->
    getList (err, ls) ->
      return next err if err
      hooks.list = _.compact ls
      next err
  wf.push (hooks, next) ->
    console.log 'list.length', hooks.list.length
    async.mapLimit hooks.list, 10, iterGet, (err, mms) ->
      hooks.list = mms
      next err
  wf.push (hooks, next) ->
    fs.writeFile 'chuan.json', JSON.stringify(hooks.list, null, 2), next
  wf.exec (err, hooks) ->
    return console.log err if err

do main
