###
GLOBAL UTIL
###

PNGCanvas = cq()
@getPNG = (canvas, coords) ->
  if !coords then coords = []
  coords[0] ?= 0
  coords[1] ?= 0
  coords[2] ?= canvas.width
  coords[3] ?= canvas.height


  PNGCanvas.canvas.width = coords[2]
  PNGCanvas.canvas.height = coords[3]
  PNGCanvas
  .clear()
  .drawImage(canvas, coords[0],coords[1],coords[2],coords[3], 0,0,coords[2],coords[3])
  PNGCanvas.canvas.toDataURL()