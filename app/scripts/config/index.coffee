app = angular.module 'app'

app.config ($httpProvider) ->
  $httpProvider.interceptors.push ($q, $log, $rootScope, localStorage) ->
    request: (req) ->
      token = localStorage.get 'access_token'
      req.headers['X-Auth-Token'] = token
      req
    response: (res) ->
      res

app.config ($stateProvider, $urlRouterProvider) ->
  home = '/app/home'
  $urlRouterProvider.when '', home
  $urlRouterProvider.when '/', home
  #$urlRouterProvider.otherwise '/notFound'

  $stateProvider.state 'app',
    url: '/app'
    controller: 'appCtrl'
    templateUrl: 'views/app.html'
  $stateProvider.state 'app.home',
    url: '/home'
    controller: 'appHomeCtrl'
    templateUrl: 'views/app/home.html'
