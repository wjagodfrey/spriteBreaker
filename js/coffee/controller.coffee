app.controller 'appCtrl', [
  '$scope'
  (scope) ->
    scope.sprites = []





    # image navigator framework
    imageCq = cq(imageCanvas[0]).framework
      onmouseup: ->
        imageSelection.zoom   = imageSelector.zoom
        imageSelection.x      = imageSelector.x
        imageSelection.y      = imageSelector.y

      onmousemove: (x, y) ->
        imageMouseCoords =
          x : x
          y : y
      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled =
        @context.imageSmoothingEnabled = false

        @clear()
        drawBackgroundTiles @
        if img.src


          imgResizeFactor = Math.min(@canvas.height/img.height, @canvas.width/img.width)

          imageSelector.width  = zoomedCq.canvas.width*imageSelector.zoom
          imageSelector.height = zoomedCq.canvas.height*imageSelector.zoom
          imageSelector.x      = imageMouseCoords.x-imageSelector.width/2
          imageSelector.y      = imageMouseCoords.y-imageSelector.height/2

          @save()
          .translate((@canvas.width-img.width*imgResizeFactor)/2, (@canvas.height-img.height*imgResizeFactor)/2)
          .drawImage(img, 0, 0, img.width * imgResizeFactor, img.height * imgResizeFactor)
          .restore()

          # draw view selector
          .save()
          .translate(imageSelector.x,imageSelector.y)
          .save()
          .globalAlpha(0.3)
          .fillStyle(imageSelector.color)
          .fillRect(0,0, imageSelector.width,imageSelector.height)
          .restore()
          .strokeStyle(imageSelector.color)
          .strokeRect(0,0, imageSelector.width,imageSelector.height)
          .restore()

          # draw view selection
          if imageSelection.zoom?
            @save()
            .translate(imageSelection.x,imageSelection.y)
            .save()
            .globalAlpha(0.3)
            .fillStyle(imageSelection.color)
            .fillRect(0,0, zoomedCanvas.width()*imageSelection.zoom,zoomedCanvas.height()*imageSelection.zoom)
            .restore()
            .strokeStyle(imageSelection.color)
            .strokeRect(0,0, zoomedCanvas.width()*imageSelection.zoom,zoomedCanvas.height()*imageSelection.zoom)
            .restore()



    # zoomed view framework
    zoomedCq = cq(zoomedCanvas[0]).framework
      onmousemove: (x, y) ->
        zoomedMouseCoords =
          x: x
          y: y

      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled =
        @context.imageSmoothingEnabled = false


        @clear()
        drawBackgroundTiles @

        if imageSelection.zoom?
          @drawImage(
            # source
            img,
            # from coords and widths
            ((imageSelection.x-(imageCanvas.width()-img.width*imgResizeFactor)/2) / imgResizeFactor),
            ((imageSelection.y-(imageCanvas.height()-img.height*imgResizeFactor)/2) / imgResizeFactor),
            (zoomedCanvas.width() * imageSelection.zoom) / imgResizeFactor,
            (zoomedCanvas.height() * imageSelection.zoom) / imgResizeFactor,
            # to coords and widths
            0,
            0,
            @canvas.width,
            @canvas.height
          )



          if frame < 10 and img.width
            frame++
            # console.log imageSelection.width, imageSelection.height, @canvas.width, @canvas.height

    scope.imagedata = fakeImageData
    scope.output = 'JSON\nhere'
    # imagedata.trigger 'change'


]