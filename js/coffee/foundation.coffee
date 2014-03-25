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
  imageSelector =
    color : '#de683c'
    zoom  : 1
  imageSelection =
    color: '#29a4d3'

  imageMouseCoords =
    x: imageCanvas.innerWidth/2
    y: imageCanvas.innerHeight/2
  zoomedMouseCoords =
    x: 0
    y: 0

# listen for scroll events
imageCanvas.on 'mousewheel', (e) ->
  e.preventDefault()
  if e.deltaY
    imageSelector.zoom += zoomSpeed*(if e.deltaY < 1 then 1 else -1)
    if imageSelector.zoom < 0.1 then imageSelector.zoom = 0.1
    if imageSelector.zoom > 1 then imageSelector.zoom = 1

# load new image on file select
fileSelect.on 'change', (e) ->
  selectedFile = e.target.files[0]
  reader = new FileReader()
  reader.onload = (e) ->
    scope.$apply ->
      scope.imagedata = e.target.result
  reader.readAsDataURL selectedFile
