###
GLOBAL UTIL
###

PNGCanvas = cq()
@getPNG = (canvas, coords, width, height) ->
  if !coords then coords = []
  selectionX = coords[0] ?= 0
  selectionY = coords[1] ?= 0
  # have to make sure not to overwrite 0s
  selectionWidth = coords[2] = if coords[2]? then coords[2] else canvas.width
  selectionHeight = coords[3] = if coords[3]? then coords[3] else canvas.height

  console.log selectionWidth, selectionHeight

  width ?= selectionWidth
  height ?= selectionHeight

  PNGCanvas.canvas.width = width
  PNGCanvas.canvas.height = height

  # make resizeds show pixel edges
  PNGCanvas.context.mozImageSmoothingEnabled =
  PNGCanvas.context.webkitImageSmoothingEnabled =
  PNGCanvas.context.msImageSmoothingEnabled =
  PNGCanvas.context.imageSmoothingEnabled = false

  imgResizeFactor = Math.min(PNGCanvas.canvas.height/selectionHeight, PNGCanvas.canvas.width/selectionWidth)

  PNGCanvas
  .clear()

  .save()
  .translate((PNGCanvas.canvas.width-selectionWidth*imgResizeFactor)/2, (PNGCanvas.canvas.height-selectionHeight*imgResizeFactor)/2)
  .drawImage(canvas, 0,0, selectionWidth * imgResizeFactor, selectionHeight * imgResizeFactor, 0,0, selectionWidth * imgResizeFactor, selectionHeight * imgResizeFactor)
  # .drawImage(canvas, 0,0, selectionWidth * imgResizeFactor, selectionHeight)
  .restore()



  # .drawImage(canvas, coords[0],coords[1],coords[2],coords[3], 0,0,width,height)
  PNGCanvas.canvas.toDataURL()