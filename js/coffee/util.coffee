###
GLOBAL UTIL
###

PNGCanvas = cq()
@getPixelData = (type, canvas, coords, width, height) ->
  if !coords then coords = []
  selectionX = if coords[0]? then coords[0] else 0
  selectionY = if coords[1]? then coords[1] else 0
  # have to make sure not to overwrite 0s
  selectionWidth = if coords[2]? then coords[2] else 0
  selectionHeight = if coords[3]? then coords[3] else 0

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
  .drawImage(canvas, selectionX,selectionY, selectionWidth, selectionHeight, 0,0, selectionWidth * imgResizeFactor, selectionHeight * imgResizeFactor)
  .restore()

  if type is 'png'
    PNGCanvas.canvas.toDataURL()
  else
    PNGCanvas.context.getImageData 0,0,width,height
