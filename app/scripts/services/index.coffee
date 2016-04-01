app = angular.module 'app'

app.factory 'dUser', (CONFIG, $resource) ->
  acts =
    query:
      method: 'GET'
      isArray: yes
    get:
      method: 'GET'
      isArray: no
  $resource CONFIG.apiRoot + '/users/:id', {}, acts
