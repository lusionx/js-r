app = angular.module 'app'

app.directive 'adSelectAll', ($parse, $log) ->
  restrict: 'A'
  link: (scope, ele, attr) ->
    ele.on 'click', (e) -> e.target.select()


app.directive 'adPager', ($parse, $log) ->
  restrict: 'A'
  require: 'ngModel'
  templateUrl: 'views/directives/ad-pager.html'
  scope:
    size: '=adPagerSize'
    total: '=adPagerTotal'
    index: '=adPagerIndex'
  link: (scope, ele, attr, model) ->
    model.$render = () ->
      return if not scope.total
      j = Math.ceil scope.total/scope.size
      scope.list = _.range 1, j + 1
      scope.curr = 0 if _.isUndefined scope.curr

    scope.change = (i) ->
      o =
        size: scope.size
        index: i
        skip: i * scope.size
      model.$setViewValue o
      scope.curr = i
    scope.$watch 'size', (v) ->
      #$log.debug 'size ' + v
      model.$render()
    scope.$watch 'total', (v) ->
      #$log.debug 'total ' + v
      model.$render()
