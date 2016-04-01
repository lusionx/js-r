app = angular.module 'app'

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
      '战列巡洋舰': 9
      '战列舰': 30
      '正规航母': 30
    d.exp = if v = TYPE[m.TYPE] then v else 0

    $scope.target = d
