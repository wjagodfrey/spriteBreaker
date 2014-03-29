app.controller 'appCtrl', [
  '$scope'
  (scope) ->

    ###
    INIT
    ###
    scope.listSelection =
      sprite : 'mario'
      action : 'walk'
      frame  : 0

    #DEV
    scope.sprites = [
      {
        name: 'mario'
        actions: [
          {
            name: 'walk'
            frames: [
              [0,0,20,35]
            ]
          }
          {
            name: 'jump'
            frames: [
              [0,0,45,35]
            ]
          }
        ]
      }
    ]

    # watch imagedata input for new imagedata
    scope.$watch 'imagedata', (imgData) ->
      reset()
      img.src = imgData

    # keep output string updated
    scope.$watch 'sprites', (sprites) ->
      scope.output = JSON.stringify(sprites)

    # listen for scroll events
    navigatorCanvas.on 'mousewheel', (e) ->
      e.preventDefault()
      if e.deltaY
        navigatorCursor.zoom += zoomSpeed*(if e.deltaY < 1 then 1 else -1)
        if navigatorCursor.zoom < 0.1 then navigatorCursor.zoom = 0.1
        if navigatorCursor.zoom > 1 then navigatorCursor.zoom = 1

    # load new image on file select
    fileSelect.on 'change', (e) ->
      selectedFile = e.target.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        scope.$apply ->
          scope.imagedata = e.target.result
      reader.readAsDataURL selectedFile

    ###
    UTIL
    ###
    scope.getFrameImage = (dimensions) ->
      result = getPNG img, dimensions
      console.log result, dimensions
      result
    scope.addSprite = ->



    ###
    IMAGE NAVIGATOR FRAMEWORK
    ###
    navigatorCq = cq(navigatorCanvas[0]).framework
      onmouseup: ->
        navigatorSelection.zoom   = navigatorCursor.zoom
        navigatorSelection.x      = navigatorCursor.x
        navigatorSelection.y      = navigatorCursor.y

      onmousemove: (x, y) ->
        navigatorMouseCoords =
          x : x
          y : y
      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled =
        @context.imageSmoothingEnabled = false

        @clear()
        drawBackgroundTiles @, 1
        if img.src


          imgResizeFactor = Math.min(@canvas.height/img.height, @canvas.width/img.width)

          navigatorCursor.width  = selectorCq.canvas.width*navigatorCursor.zoom
          navigatorCursor.height = selectorCq.canvas.height*navigatorCursor.zoom
          navigatorCursor.x      = navigatorMouseCoords.x-navigatorCursor.width/2
          navigatorCursor.y      = navigatorMouseCoords.y-navigatorCursor.height/2

          @save()
          .translate((@canvas.width-img.width*imgResizeFactor)/2, (@canvas.height-img.height*imgResizeFactor)/2)
          .drawImage(img, 0, 0, img.width * imgResizeFactor, img.height * imgResizeFactor)
          .restore()

          # draw view selector
          .save()
          .translate(navigatorCursor.x,navigatorCursor.y)
          .save()
          .globalAlpha(0.3)
          .fillStyle(navigatorCursor.color)
          .fillRect(0,0, navigatorCursor.width,navigatorCursor.height)
          .restore()
          .strokeStyle(navigatorCursor.color)
          .strokeRect(0,0, navigatorCursor.width,navigatorCursor.height)
          .restore()

          # draw view selection
          if navigatorSelection.x? and navigatorSelection.y?
            @save()
            .translate(navigatorSelection.x,navigatorSelection.y)
            .save()
            .globalAlpha(0.3)
            .fillStyle(navigatorSelection.color)
            .fillRect(0,0, selectorCanvas.width()*navigatorSelection.zoom,selectorCanvas.height()*navigatorSelection.zoom)
            .restore()
            .strokeStyle(navigatorSelection.color)
            .strokeRect(0,0, selectorCanvas.width()*navigatorSelection.zoom,selectorCanvas.height()*navigatorSelection.zoom)
            .restore()


    ###
    ZOOMED VIEW FRAMEWORK
    ###
    selectorCq = cq(selectorCanvas[0]).framework
      onmousemove: (x, y) ->
        selectorMouseCoords =
          x: x
          y: y

      onmouseon: (x, y) ->
        console.log 'over'

      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled =
        @context.imageSmoothingEnabled = false


        @clear()
        drawBackgroundTiles @, navigatorSelection.zoom

        if navigatorSelection.x? and navigatorSelection.y?
          @drawImage(
            # source
            img,
            # from coords and widths
            ((navigatorSelection.x-(navigatorCanvas.width()-img.width*imgResizeFactor)/2) / imgResizeFactor),
            ((navigatorSelection.y-(navigatorCanvas.height()-img.height*imgResizeFactor)/2) / imgResizeFactor),
            (selectorCanvas.width() * navigatorSelection.zoom) / imgResizeFactor,
            (selectorCanvas.height() * navigatorSelection.zoom) / imgResizeFactor,
            # to coords and widths
            0,
            0,
            @canvas.width,
            @canvas.height
          )


        #DEV
        # if frame < 10
        #   frame++
        #   if frame is 9
        #     console.log getPNG navigatorCq.canvas, [0,0,10,10]


    #DEV
    scope.imagedata = fakeImageData


]