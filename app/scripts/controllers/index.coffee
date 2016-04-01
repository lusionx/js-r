app = angular.module 'app'


app.controller 'appCtrl', ($scope, global, $state, $log) ->
  $log.log 'appCtrl'


app.controller 'notFoundCtrl', ($scope) ->
