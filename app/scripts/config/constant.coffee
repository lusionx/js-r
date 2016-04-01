app = angular.module 'app'


app.constant 'CONFIG',
  apiRoot: '/app'


app.constant 'QUERY', do () ->
  qs = {}
  str = location.search.slice 1
  return qs if not str
  _.each str.split('&'), (e) ->
    e = e.split '='
    qs[e[0]] = e[1]
  qs


app.constant 'UA', do () ->
  ua = navigator.userAgent.toLowerCase()
  isWeixin: -1 isnt ua.indexOf 'micromessenger'
  isAndroid: -1 isnt ua.indexOf 'android'
  isIos: (ua.indexOf('iphone') isnt -1) or (ua.indexOf('ipad') isnt -1)
