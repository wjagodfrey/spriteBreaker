app.controller 'appCtrl', [
  '$scope'
  '$timeout'
  (scope, timeout) ->

    ###
    INIT
    ###
    scope.listSelection =
      sprite : 0
      action : 0
      frame  : 0


    # watch imagedata input for new imagedata
    scope.$watch 'imagedata', (imgData) ->
      reset()
      scope.sprites = []
      img.src = imgData

      #DEV
      scope.sprites = [
        {
          name: 'mario'
          actions: [
            {
              name: 'walk'
              frames: [
                [10,10,20,35]
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


    # keep output string updated
    scope.$watch 'sprites', (sprites) ->
      scope.output = JSON.stringify(sprites)
    , true

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
    scope.getFrameImage = (dimensions, width, height) ->
      result = getPNG img, dimensions, width, height
      result

    scope.addSprite = ->
      scope.sprites.push
        name: 'new sprite'
        actions: []
      # select new input
      timeout ->
        $('.sprite_header input')
        .eq(scope.sprites.length - 1)
        .select()
    scope.removeSprite = (spriteIndex) ->
      scope.sprites.splice(spriteIndex, 1)

    scope.addAction = (spriteIndex) ->
      scope.sprites[spriteIndex].actions.push
        name: 'new action'
        frames: []
      # select new input
      timeout ->
        $('.sprite')
        .eq(spriteIndex)
        .find('.action_header input')
        .eq(scope.sprites[spriteIndex].actions.length - 1)
        .select()
    scope.removeAction = (spriteIndex, actionIndex) ->
      scope.sprites[spriteIndex].actions.splice(actionIndex, 1)

    scope.addFrame = (spriteIndex,actionIndex) ->
      scope.sprites[spriteIndex].actions[actionIndex].frames.push [0,0,1,10]
    scope.removeFrame = (spriteIndex, actionIndex, frameIndex) ->
      scope.sprites[spriteIndex].actions[actionIndex].frames.splice(frameIndex, 1)


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


          imgResizeFactor = Math.min(@canvas.height / img.height, @canvas.width / img.width)

          navigatorCursor.width  = selectorCq.canvas.width * navigatorCursor.zoom
          navigatorCursor.height = selectorCq.canvas.height * navigatorCursor.zoom
          navigatorCursor.x      = navigatorMouseCoords.x - navigatorCursor.width / 2
          navigatorCursor.y      = navigatorMouseCoords.y - navigatorCursor.height / 2

          @save()
          .translate((@canvas.width - img.width * imgResizeFactor) / 2, (@canvas.height - img.height * imgResizeFactor) / 2)
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
            .fillRect(0,0, selectorCanvas.width() * navigatorSelection.zoom,selectorCanvas.height() * navigatorSelection.zoom)
            .restore()
            .strokeStyle(navigatorSelection.color)
            .strokeRect(0,0, selectorCanvas.width() * navigatorSelection.zoom,selectorCanvas.height() * navigatorSelection.zoom)
            .restore()


    ###
    ZOOMED VIEW FRAMEWORK
    ###
    selectorCq = cq(selectorCanvas[0]).framework
      onmousemove: (x, y) ->
        selectorMouseCoords =
          x: x
          y: y

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
            (navigatorSelection.x - (navigatorCanvas.width() - img.width * imgResizeFactor) / 2) / imgResizeFactor,
            (navigatorSelection.y - (navigatorCanvas.height() - img.height * imgResizeFactor) / 2) / imgResizeFactor,
            (selectorCanvas.width() * navigatorSelection.zoom) / imgResizeFactor,
            (selectorCanvas.height() * navigatorSelection.zoom) / imgResizeFactor,
            # to coords and widths
            0,
            0,
            @canvas.width,
            @canvas.height
          )


          for spriteIndex, sprite of scope.sprites
            for actionIndex, action of sprite.actions
              for frameIndex, frame of action.frames

                spriteIndex = parseInt spriteIndex
                actionIndex = parseInt actionIndex
                frameIndex = parseInt frameIndex

                frameX = (frame[0]) / navigatorSelection.zoom
                frameY = (frame[1]) / navigatorSelection.zoom
                frameWidth = frame[2] / navigatorSelection.zoom
                frameHeight = frame[3] / navigatorSelection.zoom

                selected  = scope.listSelection.sprite is spriteIndex and scope.listSelection.action is actionIndex and scope.listSelection.frame is frameIndex
                frameColor = if selected then '#c80819' else '#21d4cc'

                @save()
                .translate(frameX,frameY)

                .save()
                .globalAlpha(0.3)
                .fillStyle(frameColor)
                .fillRect(0,0, frameWidth,frameHeight)
                .restore()

                .strokeStyle(frameColor)
                .strokeRect(0,0, frameWidth,frameHeight)
                .restore()





    #DEV
    scope.imagedata = fakeImageData


]