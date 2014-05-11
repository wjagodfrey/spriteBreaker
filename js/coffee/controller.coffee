app.controller 'appCtrl', [
  '$scope'
  '$timeout'
  '$interval'
  (scope, $timeout, $interval) ->

    ###
    INIT
    ###

    if localStorage? and not localStorage.spritesheets
      localStorage.spritesheets = '{"1397171491141":{"id":1397171491141,"sprites":[{"name":"roboto","actions":[{"name":"walk_up","$sb_currentFrame":3,"frames":[[1,30,6,26],[1,59,6,26],[1,88,6,26],[1,117,6,26]],"$$hashKey":"006"},{"name":"walk_left","frames":[[8,30,6,26],[8,59,6,26],[8,88,6,26],[8,117,6,26]],"$sb_currentFrame":3,"$$hashKey":"01E"}],"$$hashKey":"004","$sb_currentFrame":0,"$sb_currentAction":1,"$sb_listOpen":true},{"name":"skull","actions":[{"name":"stand","frames":[[33,37,7,9]],"$sb_currentFrame":0,"$$hashKey":"00L"}],"$$hashKey":"00J","$sb_currentFrame":0,"$sb_currentAction":0},{"name":"cactus_med","actions":[{"name":"stand","frames":[[31,1,9,33]],"$sb_currentFrame":0,"$$hashKey":"00R"}],"$$hashKey":"00P","$sb_currentFrame":0,"$sb_currentAction":0},{"name":"cactus_lrg","actions":[{"name":"stand","frames":[[41,1,9,43]],"$sb_currentFrame":0,"$$hashKey":"00X"}],"$$hashKey":"00V","$sb_currentFrame":0,"$sb_currentAction":0}],"image":"data:image/png;base64,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","options":{"output":{"frame":"array","naming":"object"}}}}'


    navigatorCanvas[0].width = navigatorCanvas.parent().width()
    navigatorCanvas[0].height = 200
    selectorCanvas[0].width = selectorCanvas.parent().width()
    selectorCanvas[0].height = 250

    reset()
    scope.spritesheetID = undefined
    scope.sprites = []

    scope.options =
      output:
        frame: 'array'
        naming: 'object'

    scope.selectedFrame =
      sprite : 0
      action : 0
      frame  : 0

    # if the user is new, show them a welcome message
    scope.modalTemplate = if !localStorage?.dontShowWelcomeMessage then './includes/welcome_modal.html' else false

    #DEV
    # $timeout ->
      # load '1397171491141'

    ###
    LISTENERS
    ###

    # keep output string updated
    scope.$watch '[sprites, options, imagedata]', ([sprites, options, imagedata]) ->
      if imagedata
        $timeout ->
          # return
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
    scope.$watch 'imagedata', (imagedata) ->
      if imagedata?
        img.src = imagedata

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

    # load updated image on file change
    fileSelect.on 'change', (e) ->
      loadNewSpritesheet e.target.files[0]


    ###
    UTIL
    ###

    fileLoadType = 'new'
    scope.newSpritesheet = ->
      fileLoadType = 'new'
      fileSelect.click()
      true
    scope.updateSpritesheet = ->
      fileLoadType = 'update'
      if !fileSelect[0].files.length
        fileSelect.click()
      else
        loadNewSpritesheet fileSelect[0].files[0]
      true

    loadNewSpritesheet = (selectedFile) ->
      if selectedFile?
        reader = new FileReader()
        reader.onload = (e) ->
          scope.$apply ->
            scope.imagedata = e.target.result
            if fileLoadType is 'new'
              reset()
              scope.spritesheetID = new Date().getTime()
              scope.sprites = []
      reader.readAsDataURL selectedFile

    # scroll to element in list
    scrollToListElement = (spriteIndex, actionIndex, frameIndex) ->
      scrollTop = listElement.scrollTop()
      element = {}
      if spriteIndex?
        element = sprite = $('.sprite').eq(spriteIndex)
        if !actionIndex? and !frameIndex?
          scrollTop += sprite.position().top
        else if actionIndex?
          element = action = sprite.find('.action').eq(actionIndex)
          if !frameIndex?
            scrollTop += action.position().top
          else if frameIndex?
            element = frame = action.find('.frame').eq(frameIndex)
            scrollTop += frame.position().top
      listElement.scrollTop scrollTop - listElement.height()/2 + element.height()/2

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
      s.sprite is sprite and s.action is action and s.frame is frame

    scope.getFrameImage = (dimensions, width, height) ->
      getPixelData 'png', img, dimensions, width, height

    scope.addSprite = ->
      if scope.imagedata
        scope.sprites.push
          name    : 'sprite'
          actions : []
          $sb_currentAction : 0
          $sb_currentFrame : 0
          $sb_listOpen : true
        # select new input
        $timeout ->

          spriteIndex = scope.sprites.length - 1
          $('.sprite_header input')
          .eq(scope.sprites.length - 1)
          .select()
          scrollToListElement spriteIndex
    scope.removeSprite = (spriteIndex) ->
      scope.sprites.splice(spriteIndex, 1)

    # animate animation previewers
    $interval( =>

      for sprite in scope.sprites
        sprite.$sb_currentAction ?= 0
        sprite.$sb_currentFrame ?= 0
        sprite.$sb_currentFrame++
        if sprite.$sb_currentFrame >= sprite.actions[sprite.$sb_currentAction]?.frames.length
          sprite.$sb_currentFrame = 0
          sprite.$sb_currentAction++
          if sprite.$sb_currentAction >= sprite.actions.length
            sprite.$sb_currentAction = 0

        for action in sprite.actions
          action.$sb_currentFrame ?= 0
          action.$sb_currentFrame++
          if action.$sb_currentFrame >= action.frames.length
            action.$sb_currentFrame = 0
    , 200)

    scope.addAction = (spriteIndex) ->
      scope.sprites[spriteIndex].actions.push self =
        name         : 'action'
        frames       : []
        $sb_currentFrame : 0
        $sb_listOpen : true
      scope.sprites[spriteIndex].$sb_listOpen = true
      # select new input
      $timeout ->
        actionIndex = scope.sprites[spriteIndex].actions.length - 1
        $('.sprite')
        .eq(spriteIndex)
        .find('.action_header input')
        .eq(actionIndex)
        .select()
        scrollToListElement spriteIndex, actionIndex
    scope.removeAction = (spriteIndex, actionIndex) ->
      scope.sprites[spriteIndex].actions.splice(actionIndex, 1)

    scope.addFrame = (spriteIndex, actionIndex) ->
      if scope.sprites[spriteIndex]?.actions[actionIndex]?
        scope.sprites[spriteIndex].actions[actionIndex].frames.push []
        frameIndex = scope.sprites[spriteIndex].actions[actionIndex].frames.length-1
        scope.setSelected spriteIndex, actionIndex, frameIndex
        scope.sprites[spriteIndex].$sb_listOpen = true
        scope.sprites[spriteIndex].actions[actionIndex].$sb_listOpen = true
        $timeout ->
          $timeout ->
            scrollToListElement spriteIndex, actionIndex, frameIndex
    scope.removeFrame = (spriteIndex, actionIndex, frameIndex) ->
      scope.sprites[spriteIndex].actions[actionIndex].frames.splice(frameIndex, 1)
      if frameIndex is scope.selectedFrame.frame
        scope.selectedFrame.frame = -1
      else if frameIndex < scope.selectedFrame.frame
        scope.selectedFrame.frame--

    save = scope.save = ->
      if localStorage?
        localSpritesheets = JSON.parse(localStorage.spritesheets)
        spritesheet =
          id: scope.spritesheetID
          sprites: scope.sprites
          image: img.src
          options: scope.options
        localSpritesheets[spritesheet.id] = spritesheet
        localStorage.spritesheets = JSON.stringify( localSpritesheets )

    load = scope.load = (id) ->
      if localStorage?
        spritesheets = JSON.parse(localStorage.spritesheets)
        sheet = spritesheets[id]
        if sheet?
          parentScope = scope
          parentScope.spritesheetID = id
          parentScope.imagedata     = sheet.image
          parentScope.sprites       = sheet.sprites
          parentScope.options       = sheet.options
          parentScope.modalTemplate      = false
          # make sure reloading doesn't load in the previous spritesheet
          fileSelect[0].value = ''

    ###
    CONTROLLERS
    ###
    scope.optionsModalCtrl = [
      '$scope'
      (scope) ->
        scope.optionsCache = $.extend true, {}, scope.$parent.$parent.options
        scope.save = ->
          $.extend scope.$parent.$parent.options, scope.optionsCache
          scope.$parent.$parent.$parent.modalTemplate = false
    ]
    scope.welcomeModalCtrl = [
      '$scope'
      (scope) ->
        localStorage?.dontShowWelcomeMessage = 'true'
        scope.loadDemo = ->
          load '1397171491141'
          scope.$parent.$parent.$parent.modalTemplate = false
    ]
    scope.loadModalCtrl = [
      '$scope'
      (scope) ->
        scope.spritesheets = {}
        if localStorage? then scope.spritesheets = JSON.parse(localStorage.spritesheets)
        scope.$watch 'spritesheets', ->
          scope.noSheets = !(for k of scope.spritesheets then do -> return true).length
        , true

        scope.delete = (id) ->
          scope.spritesheets[id] = undefined
          delete scope.spritesheets[id]
          localStorage.spritesheets = JSON.stringify( scope.spritesheets )
          if scope.selected is id then scope.selected = false

        scope.load = (id) ->
          load id
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
            # make sure points never pass each other
            if s[2]? and s[3]?
              if x >= s[0] + s[2] then x = s[0] + s[2] - 1
              if y >= s[1] + s[3] then y = s[1] + s[3] - 1
            # adjust bottom right point
            if s[0]? and s[1]? and s[2]? and s[3]?
              s[2] = (s[0] + s[2]) - x
              s[3] = (s[1] + s[3]) - y
            s[0] = x
            s[1] = y
        # right or middle mouse button, set bottom right frame pos
        if btn in [1,2]
          scope.$apply ->
            # make sure points never pass each other
            if s[0]? and s[1]?
              if x <= s[0] then x = s[0] + 1
              if y <= s[1] then y = s[1] + 1
            if s[0]? and s[1]?
              s[2] = x - s[0]
              s[3] = y - s[1]

    selectorCq = cq(selectorCanvas[0]).framework

      onkeyup: (key) ->
        if !$('input:focus, textarea:focus').length
          if key is 'f'
            scope.addFrame scope.selectedFrame.sprite, scope.selectedFrame.action

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

            transX = if drawX < 0 then Math.abs(drawX) / navigatorSelection.zoom * imgResizeFactor else 0
            transY = if drawY < 0 then Math.abs(drawY) / navigatorSelection.zoom * imgResizeFactor else 0

            @save()
            .translate(transX, transY)
            .drawImage(
              # source
              img,
              # FROM coords and widths
              if transX then 0 else drawX,
              if transY then 0 else drawY,
              (selectorCanvas.width() * navigatorSelection.zoom) / imgResizeFactor,
              (selectorCanvas.height() * navigatorSelection.zoom) / imgResizeFactor,
              # TO coords and widths
              0,
              0,
              @canvas.width,
              @canvas.height
            )
            .restore()

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


]


angular.bootstrap window_.document.body, ["app"]