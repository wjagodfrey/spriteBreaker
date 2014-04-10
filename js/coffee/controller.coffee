app.controller 'appCtrl', [
  '$scope'
  '$timeout'
  '$interval'
  (scope, $timeout, $interval) ->

    ###
    INIT
    ###

    if localStorage? and not localStorage.spritesheets
      localStorage.spritesheets = '{}'


    navigatorCanvas[0].width = navigatorCanvas.parent().width()
    navigatorCanvas[0].height = 200
    selectorCanvas[0].width = selectorCanvas.parent().width()
    selectorCanvas[0].height = 250

    spritesheetID = undefined

    scope.options =
      output:
        frame: 'array'
        naming: 'object'

    scope.selectedFrame =
      sprite : 0
      action : 0
      frame  : 0

    ###
    LISTENERS
    ###

    # keep output string updated
    scope.$watch '[sprites, options]', ([sprites, options]) ->
      opt = options.output
      #begin output
      output = if opt.naming is 'object' then '{' else '['
      ###
      sprite loop
      ###
      for si, sprite of scope.sprites
        si = parseInt si
        # begin sprite
        output += if opt.naming is 'object' then "'#{sprite.name}':{'actions':{" else "{'name':'#{sprite.name}','actions':["
        ###
        action loop
        ###
        for ai, action of sprite.actions
          ai = parseInt ai
          # begin action
          output += if opt.naming is 'object' then "'#{action.name}':{'frames':[" else "{'name':'#{action.name}','frames':["
          ###
          frame loop
          ###
          for fi, frame of action.frames
            fi = parseInt fi
            # frame
            output += (
              if opt.frame is 'array'
                "#{JSON.stringify frame}"
              else if opt.frame is 'object'
                "{'x':#{frame[0]},'y':#{frame[1]},'width':#{frame[2]},'height':#{frame[3]}}"
              else if opt.frame is 'png'
                "'#{getPixelData 'png', img, frame}'"
              else if opt.frame is 'image'
                "#{JSON.stringify getPixelData('img', img, frame)}"
            )
            if fi isnt action.frames.length-1 then output += ','
          # close action
          output += if opt.naming is 'object' then ']}' else ']}'
          if ai isnt sprite.actions.length-1 then output += ','
        # close sprite
        output += if opt.naming is 'object' then '}}' else ']}'
        if si isnt scope.sprites.length-1 then output += ','
      # close output
      output += if opt.naming is 'object' then '}' else ']'
      scope.output = output.replace /\'/g, '"'
    , true

    # watch imagedata input for new imagedata
    scope.$watch 'imagedata', (imgData) ->
      reset()
      scope.sprites = []
      img.src = imgData
      #DEV
      # scope.infoOpen = true
      scope.sprites = [
        {
          name    : 'roboto'
          actions : [
            {
              name             : 'walk_up'
              $sb_currentFrame : 0
              frames           : [
                [1,30, 6,26]
                [1,59, 6,26]
                [1,88, 6,26]
                [1,117, 6,26]
              ]
            }
          ]
        }
      ]

    # when you leave the window or tab
    $(window).on 'blur', ->
      mouseOverNavigator = false
      navigatorMouseDown = false
      selectorMouseDown = false

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
      if not navigatorMouseDown
        if e.deltaY
          navigatorCursor.zoom += zoomSpeed*(if e.deltaY < 1 then 1 else -1)
          if navigatorCursor.zoom < 0.1 then navigatorCursor.zoom = 0.1
          if navigatorCursor.zoom > 1 then navigatorCursor.zoom = 1
          # if navigatorMouseDown
          #   navigatorSelection.zoom = navigatorCursor.zoom

    #     if navigatorCursor.zoom > 1 then navigatorCursor.zoom = 1

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
      result = getPixelData 'png', img, dimensions, width, height
      result

    scope.addSprite = ->
      if scope.imagedata
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

    save = scope.save = ->
      if localStorage?

        localSpritesheets = JSON.parse(localStorage.spritesheets)

        spritesheet =
          id: spritesheetID or spritesheetID = (new Date().getTime())
          sprites: scope.sprites
          image: img.src
          options: scope.options

        localSpritesheets[spritesheet.id] = spritesheet
        
        localStorage.spritesheets = JSON.stringify( localSpritesheets )


    ###
    CONTROLLERS
    ###
    scope.outputOptionsCtrl = [
      '$scope'
      (scope) ->
        scope.optionsCache = $.extend true, {}, scope.$parent.$parent.options
        scope.save = ->
          $.extend scope.$parent.$parent.options, scope.optionsCache
          scope.$parent.$parent.optionsOpen = false
    ]
    scope.infoModalCtrl = [
      '$scope'
      (scope) ->
        scope.optionsCache = $.extend true, {}, scope.$parent.$parent.options
        scope.save = ->
          $.extend scope.$parent.$parent.options, scope.optionsCache
          scope.$parent.$parent.optionsOpen = false
    ]
    scope.loadModalCtrl = [
      '$scope'
      (scope) ->
        scope.spritesheets = {}
        if localStorage? then scope.spritesheets = JSON.parse(localStorage.spritesheets)

        scope.$watch 'spritesheets', ->
          scope.noSheets = !(for k of scope.spritesheets then do -> return true).length
          console.log scope.noSheets, scope.spritesheets
        , true

        scope.delete = (id) ->
          scope.spritesheets[id] = undefined
          delete scope.spritesheets[id]
          localStorage.spritesheets = JSON.stringify( scope.spritesheets )
          if scope.selected is id then scope.selected = false

        scope.load = (id) ->
          sheet         = scope.spritesheets[id]
          spritesheetID = id
          img.src       = sheet.image
          scope.$parent.$parent.$parent.sprites  = sheet.sprites
          scope.$parent.$parent.$parent.options  = sheet.options
          scope.$parent.$parent.$parent.loadOpen = false
    ]

    ###
    IMAGE NAVIGATOR FRAMEWORK
    ###
    adjustNavigatorSelection = (x, y) ->
      navigatorSelection.zoom = navigatorCursor.zoom
      navigatorSelection.x    = (Math.floor(x) - horizontalEdgeAdjustment) / imgResizeFactor
      navigatorSelection.y    = (Math.floor(y) - verticalEdgeAdjustment) / imgResizeFactor

    horizontalEdgeAdjustment = 0
    verticalEdgeAdjustment   = 0
    navigatorSelectionWidth  = 0
    navigatorSelectionHeight  = 0
    navigatorCq = cq(navigatorCanvas[0]).framework


      onmousedown: (x, y) ->
        navigatorMouseDown = true
        console.log 
        adjustNavigatorSelection(x, y)
      onmouseup: (x, y) ->
        navigatorMouseDown = false

      onmousemove: (x, y) ->
        navigatorMouseCoords =
          x : x
          y : y
        if navigatorMouseDown then adjustNavigatorSelection(x, y)

      onrender: (delta, time) ->

        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled    =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled     =
        @context.imageSmoothingEnabled       = false

        @clear()
        drawBackgroundTiles @, 1

        if scope.imagedata
          if img.src

            horizontalEdgeAdjustment = (navigatorCanvas.width() - img.width * imgResizeFactor) / 2
            verticalEdgeAdjustment   = (navigatorCanvas.height() - img.height * imgResizeFactor) / 2
            navigatorSelectionWidth  = selectorCanvas.width() * navigatorSelection.zoom
            navigatorSelectionHeight = selectorCanvas.height() * navigatorSelection.zoom

            imgResizeFactor = Math.min(@canvas.height / img.height, @canvas.width / img.width)

            @save()
            .translate(horizontalEdgeAdjustment, verticalEdgeAdjustment)
            .drawImage(img, 0, 0, img.width * imgResizeFactor, img.height * imgResizeFactor)
            .restore()

            if mouseOverNavigator and not navigatorMouseDown
              navigatorCursorWidth  = selectorCanvas.width() * navigatorCursor.zoom
              navigatorCursorHeight = selectorCanvas.height() * navigatorCursor.zoom
              navigatorCursor.x      = navigatorMouseCoords.x - navigatorCursorWidth / 2
              navigatorCursor.y      = navigatorMouseCoords.y - navigatorCursorHeight / 2

              # draw view selector
              @save()
              .translate(
                navigatorCursor.x
                navigatorCursor.y
                )
              .save()
              .globalAlpha(0.3)
              .fillStyle(navigatorCursor.color)
              .fillRect(0,0, navigatorCursorWidth,navigatorCursorHeight)
              .restore()
              .strokeStyle(navigatorCursor.color)
              .strokeRect(0,0, navigatorCursorWidth,navigatorCursorHeight)
              .restore()

            # draw view selection
            if navigatorSelection.x? and navigatorSelection.y?


              @save()
              .translate(
                navigatorSelection.x * imgResizeFactor - (navigatorSelectionWidth / 2) + horizontalEdgeAdjustment
                navigatorSelection.y * imgResizeFactor - (navigatorSelectionHeight / 2) + verticalEdgeAdjustment
              )
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
    selectorBtnCache = ''
    adjustSelectorSelection = (x, y, btn) ->
      if btn? then selectorBtnCache = btn
      btn = selectorBtnCache
      # adjust selected frame coordinates
      s = scope.getSelected()
      if s
        imgX = (navigatorSelection.x * imgResizeFactor - navigatorSelectionWidth / 2) / navigatorSelection.zoom
        imgY = (navigatorSelection.y * imgResizeFactor - navigatorSelectionHeight / 2) / navigatorSelection.zoom
        x = Math.floor((x + imgX) / imgResizeFactor * navigatorSelection.zoom)
        y = Math.floor((y + imgY) / imgResizeFactor * navigatorSelection.zoom)
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

    selectorCq = cq(selectorCanvas[0]).framework
      onmousemove: (x, y) ->
        selectorMouseCoords =
          x: x
          y: y
        if navigatorMouseDown then adjustSelectorSelection(x, y)

      onmousedown: (x, y, btn) ->
        navigatorMouseDown = true
        adjustSelectorSelection(x, y, btn)
      onmouseup: (x, y) ->
        navigatorMouseDown = false



      onrender: (delta, time) ->
        # make resizeds show pixel edges
        @context.mozImageSmoothingEnabled =
        @context.webkitImageSmoothingEnabled =
        @context.msImageSmoothingEnabled =
        @context.imageSmoothingEnabled = false


        @clear()
        drawBackgroundTiles @, navigatorSelection.zoom

        if scope.imagedata

          if navigatorSelection.x? and navigatorSelection.y?

            drawX = navigatorSelection.x - (navigatorSelectionWidth / imgResizeFactor / 2)
            drawY = navigatorSelection.y - (navigatorSelectionHeight / imgResizeFactor / 2)

            @drawImage(
              # source
              img,
              # FROM coords and widths
              drawX,
              drawY,
              (selectorCanvas.width() * navigatorSelection.zoom) / imgResizeFactor,
              (selectorCanvas.height() * navigatorSelection.zoom) / imgResizeFactor,
              # TO coords and widths
              0,
              0,
              @canvas.width,
              @canvas.height
            )

            # draw sprite selections
            # return
            for spriteIndex, sprite of scope.sprites
              if !sprite.hidden
                for actionIndex, action of sprite.actions
                  if !action.hidden
                    for frameIndex, frame of action.frames
                      if !frame.hidden

                        if frame[0]? and frame[1]?

                          spriteIndex = parseInt spriteIndex
                          actionIndex = parseInt actionIndex
                          frameIndex  = parseInt frameIndex

                          frmX      = frame[0]
                          frmY      = frame[1]
                          frmWidth  = frame[2]
                          frmHeight = frame[3]

                          frmX      = (frmX - drawX) * imgResizeFactor / navigatorSelection.zoom
                          frmY      = (frmY - drawY) * imgResizeFactor / navigatorSelection.zoom
                          frmWidth  = frmWidth * imgResizeFactor / navigatorSelection.zoom
                          frmHeight = frmHeight * imgResizeFactor / navigatorSelection.zoom

                          selected  = scope.selectedFrame.sprite is spriteIndex and
                          scope.selectedFrame.action is actionIndex and
                          scope.selectedFrame.frame is frameIndex
                          frameColor = if selected then '#c80819' else '#21d4cc'

                          @save()
                          .translate(frmX,frmY)

                          .save()
                          .globalAlpha(0.3)
                          .fillStyle(frameColor)
                          .fillRect(0,0, frmWidth,frmHeight)
                          .restore()

                          .strokeStyle(frameColor)
                          .strokeRect(0,0, frmWidth,frmHeight)
                          .restore()

                          # draw top left and bottom right boxes if selected
                          if selected
                            @fillStyle('#fea00e')
                            @fillRect(frmX-2,frmY-2, 4,4)
                            if frame[2]? and frame[3]?
                              @fillStyle('#24ffae')
                              @fillRect(frmX+frmWidth-2,frmY+frmHeight-2, 4,4)





    #DEV
    scope.imagedata = fakeImageData


]