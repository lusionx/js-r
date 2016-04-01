app = angular.module 'app'

app.factory 'localStorage', () ->
  sss = localStorage
  obj =
    get: (key) ->
      sss.getItem key
    set: (key, val) ->
      sss.setItem key, val
      val
    drop: (key) ->
      sss.removeItem key

app.factory 'sessionStorage', () ->
  sss = sessionStorage
  obj =
    get: (key) ->
      sss.getItem key
    set: (key, val) ->
      sss.setItem key, val
      val
    drop: (key) ->
      sss.removeItem key
