window_ = @

app = angular.module 'app', []

# DEV
# fakeImageData = 'data:image/png;base64,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'
# fakeImageData = 'data:image/png;base64,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'
dev_frame = 0

zoomSpeed = 0.03

imgResizeFactor = 0
navigatorCursor = {}
navigatorSelection = {}
mouseOverNavigator = false
navigatorMouseCoords = {}
navigatorMouseDown = false
selectorMouseCoords = {}
selectorMouseDown = false
img = new Image()

navigatorCanvas = $('canvas#navigator')
selectorCanvas = $('canvas#selector')

listElement = $('#list')

fileSelect = $('#filepath')
jsonoutput = $('#output')


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
    x: 10
    y: 10

  navigatorMouseCoords =
    x: navigatorCanvas.innerWidth/2
    y: navigatorCanvas.innerHeight/2
  selectorMouseCoords =
    x: 0
    y: 0

angular.bootstrap root.document.body, ["app"]