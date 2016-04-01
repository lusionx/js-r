app = angular.module 'app'


app.filter 'moment', () ->
  ff =
    fmt: (v) ->
      v.format 'YYYY-MM-DD HH:mm'
    time: (v) ->
      v.format 'HH:mm:ss'
    day: (v) ->
      v.format 'YYYY-MM-DD'
  (input, fmt, to) ->
    if fmt and not to # 2 argvs
      to = fmt
      fmt = null
    m = moment input, fmt
    m.utcOffset 8
    return m if not to
    ff[to] m
