app = angular.module 'app'
_   = require 'lodash'

app.controller 'appHomeCtrl', ($scope, global, dChuan, $state, $log) ->
  $scope.data =
    q: ''

  dChuan.query (list) ->
    $scope.list = list

  $scope.setTarget = (m) ->
    d =
      NAME: m.NAME
      ID: m.ID
      huoli: m.ATTACK_MAX - m.ATTACK
      zhuangjia: m.DEFENCE_MAX - m.DEFENCE
      yulei: m.ROCKETS_MAX - m.ROCKETS
      duikong: m.DUI_KONG_MAX - m.DUI_KONG
    TYPE =
      '驱逐舰': 10
      '轻巡洋舰': 15
      '重巡洋舰': 20
      '轻型航母': 20
      '战列巡洋舰': 25
      '战列舰': 30
      '正规航母': 30
    d.exp = if v = TYPE[m.TYPE] then v else 3
    GAI =
      '驱逐舰': 2
      '轻巡洋舰': 3
      '正规航母': 6
    if d.NAME.indexOf '\u6539\u2460' > 0 # 改造
      d.exp += if v = GAI[m.TYPE] then v else 0
    $scope.target = d

  $scope.sourceTotal = () ->
    d = {}
    d.exp = {}
    d.sell = all: 0
    d.xp = {}
    _.each $scope.source, (r) ->
      _.each r.exp, (v, k) ->
        d.exp[k] = 0 if _.isUndefined d.exp[k]
        d.exp[k] += v * r.cc
      _.each r.sell, (v, k) ->
        d.sell[k] = 0 if _.isUndefined d.sell[k]
        d.sell[k] += v * r.cc
        d.sell.all += v * r.cc
    tt = $scope.target
    _.each ['huoli', 'zhuangjia', 'yulei', 'duikong'], (k) ->
      d.xp[k] = d.exp[k] - tt[k] * tt.exp if $scope.source and tt
    d

  $scope.add = (m) ->
    $scope.source = [] if not $scope.source
    d = _.find $scope.source, (e) -> e.ID is m.ID
    return if d
    rr = m.EXP.split '/'
    d =
      NAME: m.NAME
      ID: m.ID
      cc: 1
      exp:
        huoli: +rr[0]
        yulei: +rr[1]
        zhuangjia: +rr[2]
        duikong: +rr[3]
    rr = m.SELL.split '/'
    d.sell =
      you: +rr[0]
      dan: +rr[1]
      gang: +rr[2]
      lv: +rr[3]
    $scope.source.push d

  $scope.remove = (m) ->
    _.remove $scope.source, (e) -> e.ID is m.ID

