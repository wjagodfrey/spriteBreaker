app.controller 'appCtrl', [
  '$scope'
  '$timeout'
  '$interval'
  (scope, $timeout, $interval) ->

    ###
    INIT
    ###

    navigatorCanvas[0].width = navigatorCanvas.parent().width()
    navigatorCanvas[0].height = 200
    selectorCanvas[0].width = selectorCanvas.parent().width()
    selectorCanvas[0].height = 250


    scope.selectedFrame =
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
          name    : 'roboto'
          actions : [
            {
              name         : 'walk_up'
              $sb_currentFrame : 0
              frames       : [
                [1,30, 6,26]
                [1,59, 6,26]
                [1,88, 6,26]
                [1,117, 6,26]
              ]
            }
          ]
        }
      ]

    ###
    LISTENERS
    ###

    # keep output string updated
    scope.$watch 'sprites', (sprites) ->
      scope.output = JSON.stringify(sprites)
    , true

    # when you leave the window or tab
    $(window).on 'blur', ->
      mouseOverNavigator = false

    # elements with the click-select class will be selected on focus
    $('body').on 'focus', '.click-select', (e) ->
      $timeout ->
        $(e.target).select()

    # remove context menu from canvases
    $('canvas').on 'contextmenu', (e) ->
      e.preventDefault()

    # listen for mouse over
    navigatorCanvas.on 'mouseover', (e) ->
      mouseOverNavigator = true
    # listen for mouse out
    navigatorCanvas.on 'mouseout', (e) ->
      mouseOverNavigator = false

    # zoom navigator selection cursor on navigator canvas scroll
    navigatorCanvas.on 'mousewheel', (e) ->
      e.preventDefault()
      if e.deltaY
        navigatorCursor.zoom += zoomSpeed*(if e.deltaY < 1 then 1 else -1)
        if navigatorCursor.zoom < 0.1 then navigatorCursor.zoom = 0.1
        if navigatorCursor.zoom > 1 then navigatorCursor.zoom = 1

    # zoom navigator selection selection canvas on scroll
    selectorCanvas.on 'mousewheel', (e) ->
      e.preventDefault()
      if e.deltaY and navigatorSelection.x? and navigatorSelection.y?
        zoomCache = navigatorSelection.zoom
        navigatorCursor.zoom = navigatorSelection.zoom += zoomSpeed*(if e.deltaY < 1 then 1 else -1)
        if navigatorSelection.zoom < 0.1 then navigatorSelection.zoom = 0.1
        if navigatorSelection.zoom > 1 then navigatorSelection.zoom = 1
        if navigatorCursor.zoom < 0.1 then navigatorCursor.zoom = 0.1
        if navigatorCursor.zoom > 1 then navigatorCursor.zoom = 1
        xPercentage = selectorMouseCoords.x / selectorCanvas.width()
        yPercentage = selectorMouseCoords.y / selectorCanvas.height()
        if zoomDifference = zoomCache - navigatorSelection.zoom
          navigatorSelection.x      = (navigatorSelection.x + (selectorCq.canvas.width * zoomDifference) * xPercentage)
          navigatorSelection.y      = (navigatorSelection.y + (selectorCq.canvas.height * zoomDifference) * yPercentage)

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
    scope.getSelected = ->
      r = scope.selectedFrame
      scope.sprites[r.sprite]?.actions[r.action]?.frames[r.frame]
    scope.setSelected = (sprite, action, frame) ->
      scope.selectedFrame =
        sprite : sprite
        action : action
        frame  : frame
    scope.isSelected = (sprite, action, frame) ->
      s = scope.selectedFrame
      s.frame is frame and s.action is action and s.frame is frame

    scope.getFrameImage = (dimensions, width, height) ->
      result = getPNG img, dimensions, width, height
      result

    scope.addSprite = ->
      scope.sprites.push
        name    : 'sprite'
        actions : []
      # select new input
      $timeout ->
        $('.sprite_header input')
        .eq(scope.sprites.length - 1)
        .select()
    scope.removeSprite = (spriteIndex) ->
      scope.sprites.splice(spriteIndex, 1)

    # change action animation frame
    $interval( =>
      for sprite in scope.sprites
        for action in sprite.actions
          action.$sb_currentFrame++
          if action.$sb_currentFrame >= action.frames.length
            action.$sb_currentFrame = 0
    , 200)

    scope.addAction = (spriteIndex) ->
      scope.sprites[spriteIndex].actions.push self =
        name         : 'action'
        frames       : []
        $sb_currentFrame : 0
      # select new input
      $timeout ->
        $('.sprite')
        .eq(spriteIndex)
        .find('.action_header input')
        .eq(scope.sprites[spriteIndex].actions.length - 1)
        .select()
    scope.removeAction = (spriteIndex, actionIndex) ->
      scope.sprites[spriteIndex].actions.splice(actionIndex, 1)

    scope.addFrame = (spriteIndex,actionIndex) ->
      scope.sprites[spriteIndex].actions[actionIndex].frames.push []
      scope.setSelected spriteIndex, actionIndex, scope.sprites[spriteIndex].actions[actionIndex].frames.length-1
    scope.removeFrame = (spriteIndex, actionIndex, frameIndex) ->
      scope.sprites[spriteIndex].actions[actionIndex].frames.splice(frameIndex, 1)


    ###
    IMAGE NAVIGATOR FRAMEWORK
    ###
    navigatorCq = cq(navigatorCanvas[0]).framework
      onmouseup: ->
        navigatorSelection.zoom = navigatorCursor.zoom
        navigatorSelection.x    = navigatorCursor.x
        navigatorSelection.y    = navigatorCursor.y

      onmousemove: (x, y) ->
        navigatorMouseCoords =
          x : x
          y : y
      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled    =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled     =
        @context.imageSmoothingEnabled       = false

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

          if mouseOverNavigator
            # draw view selector
            @save()
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
    SELECTOR FRAMEWORK
    ###
    horizontalEdgeAdjustment = 0
    verticalEdgeAdjustment   = 0
    selectorCq = cq(selectorCanvas[0]).framework
      onmousemove: (x, y) ->
        selectorMouseCoords =
          x: x
          y: y

      onmousedown: (x,y,btn)->

        s = scope.getSelected()
        if s
          # remap x and y to match position on spritesheet file
          x = Math.floor((x - horizontalEdgeAdjustment / navigatorSelection.zoom + navigatorSelection.x / navigatorSelection.zoom + 0.5) * navigatorSelection.zoom)
          y = Math.floor((y - verticalEdgeAdjustment / navigatorSelection.zoom + navigatorSelection.y / navigatorSelection.zoom + 0.5) * navigatorSelection.zoom)
          # left mouse button, set top left frame pos
          if btn is 0
            scope.$apply ->
              # adjust bottom right point
              if s[0]? and s[1]? and s[2]? and s[3]?
                s[2] = (s[0] + s[2]) - x
                s[3] = (s[1] + s[3]) - y
              s[0] = x
              s[1] = y
          # right or middle mouse button, set bottom right frame pos
          if btn in [1,2]
            scope.$apply ->
              if s[0]? and s[1]?
                s[2] = x - s[0]
                s[3] = y - s[1]

      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled =
        @context.imageSmoothingEnabled = false


        @clear()
        drawBackgroundTiles @, navigatorSelection.zoom

        horizontalEdgeAdjustment = (navigatorCanvas.width() - img.width * imgResizeFactor) / 2 / imgResizeFactor
        verticalEdgeAdjustment = (navigatorCanvas.height() - img.height * imgResizeFactor) / 2 / imgResizeFactor

        if navigatorSelection.x? and navigatorSelection.y?
          @drawImage(
            # source
            img,
            # from coords and widths
            navigatorSelection.x - horizontalEdgeAdjustment,
            navigatorSelection.y - verticalEdgeAdjustment,
            (selectorCanvas.width() * navigatorSelection.zoom) / imgResizeFactor,
            (selectorCanvas.height() * navigatorSelection.zoom) / imgResizeFactor,
            # to coords and widths
            0,
            0,
            @canvas.width,
            @canvas.height
          )

          # draw sprite selections
          for spriteIndex, sprite of scope.sprites
            if !sprite.hidden
              for actionIndex, action of sprite.actions
                if !action.hidden
                  for frameIndex, frame of action.frames
                    if !frame.hidden

                      if frame[0]? and frame[1]?

                        spriteIndex = parseInt spriteIndex
                        actionIndex = parseInt actionIndex
                        frameIndex = parseInt frameIndex

                        frameX      = (frame[0] - navigatorSelection.x + horizontalEdgeAdjustment) / navigatorSelection.zoom
                        frameY      = (frame[1] - navigatorSelection.y + verticalEdgeAdjustment) / navigatorSelection.zoom
                        frameWidth  = frame[2] / navigatorSelection.zoom
                        frameHeight = frame[3] / navigatorSelection.zoom

                        selected  = scope.selectedFrame.sprite is spriteIndex and scope.selectedFrame.action is actionIndex and scope.selectedFrame.frame is frameIndex
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

                        # draw top left and bottom right boxes if selected
                        if selected
                          @fillStyle('#fea00e')
                          @fillRect(frameX-2,frameY-2, 4,4)
                          if frame[2]? and frame[3]?
                            @fillStyle('#24ffae')
                            @fillRect(frameX+frameWidth-2,frameY+frameHeight-2, 4,4)





    #DEV
    scope.imagedata = fakeImageData


]