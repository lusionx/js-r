qiniu   = require 'qiniu'
config  = require './passwd'
_       = require 'lodash'
path    = require 'path'
{exec}  = require 'child_process'
program = require 'commander'

qiniu.conf.ACCESS_KEY = config.qiniu.AK
qiniu.conf.SECRET_KEY = config.qiniu.SK

uploadFile = (key, path, callback) ->
  putPolicy = new qiniu.rs.PutPolicy [config.qiniu.BUCKET_NAME, ':', key].join ''
  token = putPolicy.token()
  extra = new qiniu.io.PutExtra()
  qiniu.io.putFile token, key, path, extra, callback

xx = () ->
  uploadFile key, program.file, (err, ret) ->
    return console.error err if err
    ret.url = config.qiniu.domain + '/' + ret.key
    ret.ssl = config.qiniu.ssl + '/' + ret.key
    console.log ret

main = () ->
  dir = path.dirname __dirname
  exec "find #{dir}/dist", (err, out) ->
    ps = out.split('\n')[1..]
    ps = _.filter ps, (e) -> /\.\w+$/.test e
    ks = _.map ps, (e) -> e[dir.length + '/dist/'.length..]
    console.log ps
    console.log ks



do main if process.argv[1] is __filename
