_     = require 'lodash'



EL_SHIP = '舰船蓝图'
EL_TONG = '快速修理'

# 资源权重, 默认 铝*3
right = [1, 1, 1, 3]

avg = () ->
  x = _.map @res, (v, i) -> v * right[i]
  s = _.sum x
  Math.round s * 60 / @time

conf =
  '1-2':
    name: '长距离航海训练'
    res: [0, 30, 30, 0]
    time: 30
    el: EL_TONG
    avg: avg
  '2-1':
    name: '海上护卫'
    res: [150, 175, 20, 20]
    time: 120
    el: EL_SHIP
    avg: avg
  '2-4':
    name: '观舰仪式'
    res: [50, 100, 50, 50]
    time: 180
    el: EL_TONG
    avg: avg
    req: '12lv,4;1CA'
  '3-3':
    name: '铝材运输'
    res: [0, 0, 0, 250]
    time: 300
    el: 'NO'
    avg: avg
  '3-4':
    name: '铝材运输'
    res: [50, 250, 200, 50]
    time: 480
    el: EL_SHIP
    avg: avg
  '4-3':
    name: '支援机动部队'
    res: [0, 0, 300, 400]
    time: 12 * 60
    el: EL_SHIP
    avg: avg
    req: '20lv,6;2CL'


main = () ->
  _.each conf, (v, k) ->
    console.log k
    e = _.clone v
    e.avg = v.avg()
    console.log '%j', e

do main
