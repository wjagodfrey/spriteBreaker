# handle background tiles
backgroundTile = undefined
tileImg = new Image()
tileImg.onload = ->
  backgroundTile = cq().context.createPattern(tileImg,'repeat')
tileImg.src = './img/tile.png'
drawBackgroundTiles = (ctx) ->
  if backgroundTile?
    ctx
    .rect(0,0, ctx.canvas.width,ctx.canvas.height)
    .fillStyle(backgroundTile)
    .fill()

reset = ->
  navigatorCursor =
    color : '#de683c'
    zoom  : 1
  navigatorSelection =
    color: '#29a4d3'

  navigatorMouseCoords =
    x: navigatorCanvas.innerWidth/2
    y: navigatorCanvas.innerHeight/2
  selectorMouseCoords =
    x: 0
    y: 0

