# handle background tiles
backgroundTile = undefined
tileImg = new Image()
tileSource = cq()
tileImg.onload = ->
  backgroundTile = tileSource.context.createPattern(tileImg,'repeat')
  tileSource
  .rect(0,0, 500,500)
  .fillStyle(backgroundTile)
  .fill()
tileImg.src = './img/tile.png'
drawBackgroundTiles = (ctx, zoom) ->
  if backgroundTile?
    ctx
    .save()
    .drawImage(tileSource.canvas, 0,0, ctx.canvas.width*zoom,ctx.canvas.height*zoom, 0,0, ctx.canvas.width,ctx.canvas.height)
    .restore()

reset = ->
  navigatorCursor =
    color : '#de683c'
    zoom  : 0.3
  navigatorSelection =
    color: '#29a4d3'
    zoom : 0.3
    #DEV
    x: 0
    y: 0

  navigatorMouseCoords =
    x: navigatorCanvas.innerWidth/2
    y: navigatorCanvas.innerHeight/2
  selectorMouseCoords =
    x: 0
    y: 0