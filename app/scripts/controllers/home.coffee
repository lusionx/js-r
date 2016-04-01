app = angular.module 'app'

app.controller 'appHomeCtrl', ($scope, global, $state, $log) ->
  $log.log 'appHomeCtrl'
