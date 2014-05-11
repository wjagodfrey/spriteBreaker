// Generated by CoffeeScript 1.7.1

/*
GLOBAL UTIL
 */

(function() {
  var PNGCanvas, app, backgroundTile, dev_frame, drawBackgroundTiles, fileSelect, img, imgResizeFactor, jsonoutput, listElement, mouseOverNavigator, navigatorCanvas, navigatorCursor, navigatorMouseCoords, navigatorMouseDown, navigatorSelection, reset, selectorCanvas, selectorMouseCoords, selectorMouseDown, tileImg, tileSource, window_, zoomSpeed;

  PNGCanvas = cq();

  this.getPixelData = function(type, canvas, coords, width, height) {
    var imgResizeFactor, selectionHeight, selectionWidth, selectionX, selectionY, transX, transY;
    if (!coords) {
      coords = [];
    }
    selectionX = coords[0] != null ? coords[0] : 0;
    selectionY = coords[1] != null ? coords[1] : 0;
    transX = selectionX < 0 ? Math.abs(selectionX) : 0;
    transY = selectionY < 0 ? Math.abs(selectionY) : 0;
    selectionWidth = (coords[2] != null ? coords[2] : 0);
    selectionHeight = coords[3] != null ? coords[3] : 0;
    if (width == null) {
      width = selectionWidth;
    }
    if (height == null) {
      height = selectionHeight;
    }
    PNGCanvas.canvas.width = width;
    PNGCanvas.canvas.height = height;
    PNGCanvas.context.mozImageSmoothingEnabled = PNGCanvas.context.webkitImageSmoothingEnabled = PNGCanvas.context.msImageSmoothingEnabled = PNGCanvas.context.imageSmoothingEnabled = false;
    imgResizeFactor = Math.min(height / selectionHeight, width / selectionWidth);
    PNGCanvas.clear().save().translate((width - selectionWidth * imgResizeFactor) / 2, (height - selectionHeight * imgResizeFactor) / 2).drawImage(canvas, transX ? 0 : selectionX, transY ? 0 : selectionY, selectionWidth - transX, selectionHeight - transY, transX, transY, (selectionWidth - transX) * imgResizeFactor, (selectionHeight - transY) * imgResizeFactor).restore();
    if (type === 'png') {
      return PNGCanvas.canvas.toDataURL();
    } else {
      return PNGCanvas.context.getImageData(0, 0, width, height);
    }
  };

  window_ = this;

  app = angular.module('app', []);

  dev_frame = 0;

  zoomSpeed = 0.03;

  imgResizeFactor = 0;

  navigatorCursor = {};

  navigatorSelection = {};

  mouseOverNavigator = false;

  navigatorMouseCoords = {};

  navigatorMouseDown = false;

  selectorMouseCoords = {};

  selectorMouseDown = false;

  img = new Image();

  navigatorCanvas = $('canvas#navigator');

  selectorCanvas = $('canvas#selector');

  listElement = $('#list');

  fileSelect = $('#filepath');

  jsonoutput = $('#output');

  backgroundTile = void 0;

  tileImg = new Image();

  tileSource = cq();

  tileImg.onload = function() {
    backgroundTile = tileSource.context.createPattern(tileImg, 'repeat');
    return tileSource.rect(0, 0, 500, 500).fillStyle(backgroundTile).fill();
  };

  tileImg.src = './img/tile.png';

  drawBackgroundTiles = function(ctx, zoom) {
    if (backgroundTile != null) {
      return ctx.save().drawImage(tileSource.canvas, 0, 0, ctx.canvas.width * zoom, ctx.canvas.height * zoom, 0, 0, ctx.canvas.width, ctx.canvas.height).restore();
    }
  };

  reset = function() {
    navigatorCursor = {
      color: '#de683c',
      zoom: 0.3
    };
    navigatorSelection = {
      color: '#29a4d3',
      zoom: 0.3,
      x: 10,
      y: 10
    };
    navigatorMouseCoords = {
      x: navigatorCanvas.innerWidth / 2,
      y: navigatorCanvas.innerHeight / 2
    };
    return selectorMouseCoords = {
      x: 0,
      y: 0
    };
  };

  angular.bootstrap(window_.document.body, ["app"]);

  app.controller('appCtrl', [
    '$scope', '$timeout', '$interval', function(scope, $timeout, $interval) {

      /*
      INIT
       */
      var adjustNavigatorSelection, adjustSelectorSelection, fileLoadType, horizontalEdgeAdjustment, load, loadNewSpritesheet, navigatorCq, navigatorSelectionHeight, navigatorSelectionWidth, save, scrollToListElement, selectorBtnCache, selectorCq, verticalEdgeAdjustment;
      if ((typeof localStorage !== "undefined" && localStorage !== null) && !localStorage.spritesheets) {
        localStorage.spritesheets = '{"1397171491141":{"id":1397171491141,"sprites":[{"name":"roboto","actions":[{"name":"walk_up","$sb_currentFrame":3,"frames":[[1,30,6,26],[1,59,6,26],[1,88,6,26],[1,117,6,26]],"$$hashKey":"006"},{"name":"walk_left","frames":[[8,30,6,26],[8,59,6,26],[8,88,6,26],[8,117,6,26]],"$sb_currentFrame":3,"$$hashKey":"01E"}],"$$hashKey":"004","$sb_currentFrame":0,"$sb_currentAction":1,"$sb_listOpen":true},{"name":"skull","actions":[{"name":"stand","frames":[[33,37,7,9]],"$sb_currentFrame":0,"$$hashKey":"00L"}],"$$hashKey":"00J","$sb_currentFrame":0,"$sb_currentAction":0},{"name":"cactus_med","actions":[{"name":"stand","frames":[[31,1,9,33]],"$sb_currentFrame":0,"$$hashKey":"00R"}],"$$hashKey":"00P","$sb_currentFrame":0,"$sb_currentAction":0},{"name":"cactus_lrg","actions":[{"name":"stand","frames":[[41,1,9,43]],"$sb_currentFrame":0,"$$hashKey":"00X"}],"$$hashKey":"00V","$sb_currentFrame":0,"$sb_currentAction":0}],"image":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAYAAACtWK6eAAAACXBIWXMAAAsTAAALEwEAmpwYAAAKT2lDQ1BQaG90b3Nob3AgSUNDIHByb2ZpbGUAAHjanVNnVFPpFj333vRCS4iAlEtvUhUIIFJCi4AUkSYqIQkQSoghodkVUcERRUUEG8igiAOOjoCMFVEsDIoK2AfkIaKOg6OIisr74Xuja9a89+bN/rXXPues852zzwfACAyWSDNRNYAMqUIeEeCDx8TG4eQuQIEKJHAAEAizZCFz/SMBAPh+PDwrIsAHvgABeNMLCADATZvAMByH/w/qQplcAYCEAcB0kThLCIAUAEB6jkKmAEBGAYCdmCZTAKAEAGDLY2LjAFAtAGAnf+bTAICd+Jl7AQBblCEVAaCRACATZYhEAGg7AKzPVopFAFgwABRmS8Q5ANgtADBJV2ZIALC3AMDOEAuyAAgMADBRiIUpAAR7AGDIIyN4AISZABRG8lc88SuuEOcqAAB4mbI8uSQ5RYFbCC1xB1dXLh4ozkkXKxQ2YQJhmkAuwnmZGTKBNA/g88wAAKCRFRHgg/P9eM4Ors7ONo62Dl8t6r8G/yJiYuP+5c+rcEAAAOF0ftH+LC+zGoA7BoBt/qIl7gRoXgugdfeLZrIPQLUAoOnaV/Nw+H48PEWhkLnZ2eXk5NhKxEJbYcpXff5nwl/AV/1s+X48/Pf14L7iJIEyXYFHBPjgwsz0TKUcz5IJhGLc5o9H/LcL//wd0yLESWK5WCoU41EScY5EmozzMqUiiUKSKcUl0v9k4t8s+wM+3zUAsGo+AXuRLahdYwP2SycQWHTA4vcAAPK7b8HUKAgDgGiD4c93/+8//UegJQCAZkmScQAAXkQkLlTKsz/HCAAARKCBKrBBG/TBGCzABhzBBdzBC/xgNoRCJMTCQhBCCmSAHHJgKayCQiiGzbAdKmAv1EAdNMBRaIaTcA4uwlW4Dj1wD/phCJ7BKLyBCQRByAgTYSHaiAFiilgjjggXmYX4IcFIBBKLJCDJiBRRIkuRNUgxUopUIFVIHfI9cgI5h1xGupE7yAAygvyGvEcxlIGyUT3UDLVDuag3GoRGogvQZHQxmo8WoJvQcrQaPYw2oefQq2gP2o8+Q8cwwOgYBzPEbDAuxsNCsTgsCZNjy7EirAyrxhqwVqwDu4n1Y8+xdwQSgUXACTYEd0IgYR5BSFhMWE7YSKggHCQ0EdoJNwkDhFHCJyKTqEu0JroR+cQYYjIxh1hILCPWEo8TLxB7iEPENyQSiUMyJ7mQAkmxpFTSEtJG0m5SI+ksqZs0SBojk8naZGuyBzmULCAryIXkneTD5DPkG+Qh8lsKnWJAcaT4U+IoUspqShnlEOU05QZlmDJBVaOaUt2ooVQRNY9aQq2htlKvUYeoEzR1mjnNgxZJS6WtopXTGmgXaPdpr+h0uhHdlR5Ol9BX0svpR+iX6AP0dwwNhhWDx4hnKBmbGAcYZxl3GK+YTKYZ04sZx1QwNzHrmOeZD5lvVVgqtip8FZHKCpVKlSaVGyovVKmqpqreqgtV81XLVI+pXlN9rkZVM1PjqQnUlqtVqp1Q61MbU2epO6iHqmeob1Q/pH5Z/YkGWcNMw09DpFGgsV/jvMYgC2MZs3gsIWsNq4Z1gTXEJrHN2Xx2KruY/R27iz2qqaE5QzNKM1ezUvOUZj8H45hx+Jx0TgnnKKeX836K3hTvKeIpG6Y0TLkxZVxrqpaXllirSKtRq0frvTau7aedpr1Fu1n7gQ5Bx0onXCdHZ4/OBZ3nU9lT3acKpxZNPTr1ri6qa6UbobtEd79up+6Ynr5egJ5Mb6feeb3n+hx9L/1U/W36p/VHDFgGswwkBtsMzhg8xTVxbzwdL8fb8VFDXcNAQ6VhlWGX4YSRudE8o9VGjUYPjGnGXOMk423GbcajJgYmISZLTepN7ppSTbmmKaY7TDtMx83MzaLN1pk1mz0x1zLnm+eb15vft2BaeFostqi2uGVJsuRaplnutrxuhVo5WaVYVVpds0atna0l1rutu6cRp7lOk06rntZnw7Dxtsm2qbcZsOXYBtuutm22fWFnYhdnt8Wuw+6TvZN9un2N/T0HDYfZDqsdWh1+c7RyFDpWOt6azpzuP33F9JbpL2dYzxDP2DPjthPLKcRpnVOb00dnF2e5c4PziIuJS4LLLpc+Lpsbxt3IveRKdPVxXeF60vWdm7Obwu2o26/uNu5p7ofcn8w0nymeWTNz0MPIQ+BR5dE/C5+VMGvfrH5PQ0+BZ7XnIy9jL5FXrdewt6V3qvdh7xc+9j5yn+M+4zw33jLeWV/MN8C3yLfLT8Nvnl+F30N/I/9k/3r/0QCngCUBZwOJgUGBWwL7+Hp8Ib+OPzrbZfay2e1BjKC5QRVBj4KtguXBrSFoyOyQrSH355jOkc5pDoVQfujW0Adh5mGLw34MJ4WHhVeGP45wiFga0TGXNXfR3ENz30T6RJZE3ptnMU85ry1KNSo+qi5qPNo3ujS6P8YuZlnM1VidWElsSxw5LiquNm5svt/87fOH4p3iC+N7F5gvyF1weaHOwvSFpxapLhIsOpZATIhOOJTwQRAqqBaMJfITdyWOCnnCHcJnIi/RNtGI2ENcKh5O8kgqTXqS7JG8NXkkxTOlLOW5hCepkLxMDUzdmzqeFpp2IG0yPTq9MYOSkZBxQqohTZO2Z+pn5mZ2y6xlhbL+xW6Lty8elQfJa7OQrAVZLQq2QqboVFoo1yoHsmdlV2a/zYnKOZarnivN7cyzytuQN5zvn//tEsIS4ZK2pYZLVy0dWOa9rGo5sjxxedsK4xUFK4ZWBqw8uIq2Km3VT6vtV5eufr0mek1rgV7ByoLBtQFr6wtVCuWFfevc1+1dT1gvWd+1YfqGnRs+FYmKrhTbF5cVf9go3HjlG4dvyr+Z3JS0qavEuWTPZtJm6ebeLZ5bDpaql+aXDm4N2dq0Dd9WtO319kXbL5fNKNu7g7ZDuaO/PLi8ZafJzs07P1SkVPRU+lQ27tLdtWHX+G7R7ht7vPY07NXbW7z3/T7JvttVAVVN1WbVZftJ+7P3P66Jqun4lvttXa1ObXHtxwPSA/0HIw6217nU1R3SPVRSj9Yr60cOxx++/p3vdy0NNg1VjZzG4iNwRHnk6fcJ3/ceDTradox7rOEH0x92HWcdL2pCmvKaRptTmvtbYlu6T8w+0dbq3nr8R9sfD5w0PFl5SvNUyWna6YLTk2fyz4ydlZ19fi753GDborZ752PO32oPb++6EHTh0kX/i+c7vDvOXPK4dPKy2+UTV7hXmq86X23qdOo8/pPTT8e7nLuarrlca7nuer21e2b36RueN87d9L158Rb/1tWeOT3dvfN6b/fF9/XfFt1+cif9zsu72Xcn7q28T7xf9EDtQdlD3YfVP1v+3Njv3H9qwHeg89HcR/cGhYPP/pH1jw9DBY+Zj8uGDYbrnjg+OTniP3L96fynQ89kzyaeF/6i/suuFxYvfvjV69fO0ZjRoZfyl5O/bXyl/erA6xmv28bCxh6+yXgzMV70VvvtwXfcdx3vo98PT+R8IH8o/2j5sfVT0Kf7kxmTk/8EA5jz/GMzLdsAAAAgY0hSTQAAeiUAAICDAAD5/wAAgOkAAHUwAADqYAAAOpgAABdvkl/FRgAADQpJREFUeNrsnUFoHNcdxr8XfFVRg4l9m4ICjiGNDxEzTi6JwOBb0xi0Rj4FUpRbDy4piXK2axpqQ06NwFcr7ILca8Dg5OJmBvvgpmAHKsjcnGBspTr40MDrQfPGb2bfjFaO1tpZ/X5gIs03b2Jr37f/999588lo/bGVZOy7s3IkSaI0TWWub1a0JEkkKai1jQvhzokvnVaapjue13YtgHFxSJLxJrgtDGCSJJE++tL4x92c9bWaXh8nSZWxaZpun1+cM/fOTzp38RWnW//vI0k6/o2R5J8TPO/ayn1eTdhzXggddJXCcePEw1/8P7px4mHrdeYXjtpdXtLy8sHYK0jb0sUtf5JLh8tjaZrKrJ2RP86f+L9aOCH77my53HJmO3X3cOW8+NJpzb3zU9PEL6vD0r2TQ0a6ffMBrxw8tyWWJGlrec7eOFGdpDOrG9panrPS4dIIW8tz1q5uGLN2RnZpXVvLc/bU3VK3kszW8pzSdKO8ptODSyiASV9ibZtg+J18a3kuOMidHxr335t3bcs1AbpXQQ4dnw+KP9+7rUPH5/XVcXfkN576v3JcXXfjHOHxAB1t0kfqkJfWG7WZ1Y2RrjG/cNTOLxzlVYDJriA/37vdONGblllt43bSfG7ffEBfAtNXQQAOfA8yLg2ACgIw7T3IuLTdUtxlN9wgBCpIezMPMDk9yJMrZ3Xq7mFFUVQ5fnX2jraW54KaJKnX09VZ6f3N14MaQKcMshN5nlcPzDZrvmHaNJZVMBU9iL8PS6rsqyrxtTzPK0Zo00ZcVnGPBPa3Bzl197Cb+EaS8b73MW6yBnRTn8ieXtH6/f44/h30JzAeg9Sf/Qiw63fwoSXZL7jWiEsxgPFVkDRNy8rg7aMyfpXwNXe+X1H8cf45M6sbwWUZQCcM0vY8eDHRd318t2N4CAomukmXqp8wua/dUimkuQnf8z62jaJIvV5PeZ4rTdPy3JbG3EjCHDDZSyzHYDCIjTFx6MS65hujrvmVwhgTDwaDuKWHMPMLR/mkCibXICFTuEldTPBKJ2+MifM8bxxnjBnSBoNBYoyJjXnqhds3H5R//OdCWHLBpGCstUqSRFmWVSb04uJi1u/3VUzoimatzQqjDGmSMmtto1aMV5IkldCGkCnmF46awjxOM7Xzyu/nF46a8298xSsKe9+DFEuiLHSCtXZPNb+CtC27XIUB2HeDmOubii+dHhKLlMQ91eI43vEv9SzGuH3zgfQGLyiMwSDxpdOKokiDwcBfYknGWEkmC1WHBq0oE83amCBZEcZmEEk2z/PKu3ue50riWHFgG0eSJFKDJknJdvMR1LIs4xMr6AwvmOubNtvOyR36k330pfZaCy2x1j75Lm77HmDfDKLq/iirWth07XhI04ia9SpQpbosXTiW/enNr5PCHMnShWMjrc74OBieh0HKxrqJttDpnbaq+Ne4ceJh4/l/u/VWJsnUzdHWWzhzcKMRxtaD7Fd4ddNkDzT80q23GiuGu1fCJ1gw1gqyHTT90L3TW/du72fsluHVS+sya2fKcd7zIS6XtxxbM8VQ435t5b7Wjn/T+pc8/+bXTfdFeOIQxm+Q/QyvPnfxFS3dO6mWCFJ7+dZbLKNgf5ZY0mSEV7dUAr9KGPH0IOzHEmu37EV4tSStHf/G7rTEqvUcvGrwfCvIfoZXy/tI+OyR9+yRl14sj3/27WWdu3CMVwn21yD7zT8e/d3qyHty5vjXv//DKwOT34OMS/NZundSOvJeaYzXXn1Zr736siTZ13TefPbt5afLsU++i+dvHa18P+pNRYDOVZBrK/d17uIr+uHHRzry0os68tKL+uHHR5Lkqon942/Pm5O/+0CyVtdWlBljkqULx9K1T75L3HMpAPvSg4xLq/PByqfJ5xc/DN5i/+HHRzop6fI/39btmw+0dOFYdm3lvrm2wosH42ciwqs/v/hh9sHKp4n744zx+z98XD7qu+PTgobbJLD3GGutnlw523Rvwbz9xfc2FF6t7dws25BYYq7O3rGh8Op+v2+KzYrG35e1+pc/B/8Cyx//dcR/iZEst0hgH3qQ5xFePbIRmiHHF55/D+KHVzclJNYDqot9WBXdaWPDWswB4+lBRgmv9r+fWd0wO4VXz6xumNDY3S8CDesmmLwmvZ6/Gzi+07jQubt/l6cywH4bJBRenSTJ0Dt/mqYmlAZfH+conglhgsN0VZB6/q471uv1yk+tiuOmPs7/ZKphDED3DBJFUWNIdfG16ff7RpKtB1b75zqt+K8txpjd/GYpgImsIC6Eup7FG9J6vV5ZEZrGuTzetvBqgIk3yG7DqweDQWt4tf/fuln4kUOXMEWG7tBkLzcCGiNTC6F2wdYhrW2c00J30gEmkUNDE7tiHzMeLaaQQJeWWNc3w6q1MuuP91YD6FIFaTJHkiRKs8xayfibAN2nVP3BYEjzqkSzRugCdHGJVTeHJJn1x6Y+o91+qpDmxmWFFhfhcY6t5TnNWGtUix4FmNgmXeuPrSQTSlg01zf3XJMxSuKYJh0604OYlipiQsdH1erbUpIkkaxl+wl0c4nlUtfrE7iWxh4yhh1B843DsxvQjQoSWgbV3/nbQqdHxeX+AnSugjQlvD/PdHeAiV5ibSexl8etJFMkK1r/qcKt5TlrVzeMWTsju7ReprsXupVkttPdN8pretvmWVpB55r0fU13B5j4CjIJ6e4AE1tBnoW9SncHmPgKss/p7gDTV0EADnwPMi4NgAoCMO09yLg0ACoIwLT3IE+unA3GhhZ31INaFEVSr6ers8ORo1EUqc/PHKalghTLpB23hvgbEfM8V78ftkGRkQUwPT2Iv+EQ4EBWkFC6u0tnbzBHKJTaFIYyDecAdNMgI4RXmxZzVPANdePEw5HHAXSmB/FDqNM0HQqd9oxUMZY/rv47Rnj+HKauSa+bJhRA3RRevdM4gE4ZJIoiZVkW+xGk7l3fP5ZlWVz8WoOh8Oq6MbIsK4+RywudNUh98rqg6SRJSs0PsPaDrevjQuHVbiwmga5BeDVACyOFVy8uLmaS1O/3n/YYhFfDQTGIub4ZTjaxdkjz75Kb65vhoF03jp8vdN0go4RX9xYXh3TCq+FALbHq5pC8gGqvgrQFWxNeDVPXpBNeDdBeQYxXAcps3iRJpI++9LN0n5pKKrWaXtGKilIZm1orsfkROsILbUssB9m8cGArSFMur0Q2LwDZvAA7LbHI5gVoqSBk8wLsokkfBbJ54cBUELJ5Afa4ggAc+B5kXBoAFQRg2nuQcWkAVBCAae9BXDZvPZXk6uydMps3mFhSZPO+v/n6kEQ2L3TOIDuR53n1wGyz5humTQOYih7E34clqTHt3Wl5nitN0/L+SV0D6JxBvM2GLinR+pO7wG0ytAGTlJo7EIgtZW8WdLNJ9wKnmwjqI4zb8RoAE28Q/13f20dl/Erha84Y/rMe/v6r4lkQI21vVwktywA6ZZC2BjqKIlvX3fPkgXEmMF5RFLHEgm5XEDfZa4HT7nd/2F6vVzFE3SR1s7gMXz19UIplFnSvSZfK/NzYGKPFWg5WkbObSIqd1uv11O/3h8ZFUVQJl/PHxnGc8SOHzlWQUKi0C5/2E9rLkmJMnOd567iQFroWwCTzTOHVv1QjvBo6t8R6phDqZ9EAOrfEasjnlbUy64/3VgPokkHawqtljLVnft2wOGvXymsErsmPHTq3xBqayBotoLpNq3PjxEMp2/7ImB89dKJJJ7waoL0HMS1VxISOj6oFl1iW4gEdXWL56e6h42XVGTaGHUGTuJMOXasgoWUQ6e4AXgVpSngn3R0wSAHp7gDhJp10d4C2CkK6O0BLBXkWSHeHA1NBSHcH2OMKAnDge5BxaQBUEIBp70HGpUlPAx8AqCAAHcVYa/Xkytmmm3rm7S++H9KKLSPGRZT6FNE/5ursnaGI0iLxxPBMOkxFBfGXSW2bDX0tz/NK7E9dA5iqHiQEUaJwoCrIzOqGy+E1xdKpYoLi+ZChZETvuZEhrZbublxyPEBnl1ht4dXekqmc6PXnRurHMQVMjUFqebzBZdXM6oaf8F6OqxvLfeHOr6e/A3S6SffNEgqmdl+3hVeHvuZXsEGnDTIYDOJQpq4xJnaa04vU9qFxURSVxnHnN10XYNI55CaythPYK5M+juOsSG8fwguvHhonKRg52nQtgEmlMbx6cXEx6/f7hFcDFaQysetYK9tQEZ5ZA+hykw4AoxjEGCtj1Ov1Kk25r7WNa9QAutaDAABLLAAMAoBBADAIAAYBwCAAGAQAgwBgEADAIAAYBACDAGAQAAwCgEEAMAgABgHAIAAYBAAwCAAGAcAgABgEAIMAYBAADAKAQQAwCABgEAAMAoBBADAIAAYBwCAAGAQAgwBgEAAMAgAYBACDAGAQAAwCgEEAMAgABgHAIAAYBACDAAAGAcAgABgEAIMAYBAADAKAQQCmkv8PAFpnBwvcAdiAAAAAAElFTkSuQmCC","options":{"output":{"frame":"array","naming":"object"}}}}';
      }
      navigatorCanvas[0].width = navigatorCanvas.parent().width();
      navigatorCanvas[0].height = 200;
      selectorCanvas[0].width = selectorCanvas.parent().width();
      selectorCanvas[0].height = 250;
      reset();
      scope.spritesheetID = void 0;
      scope.sprites = [];
      scope.options = {
        output: {
          frame: 'array',
          naming: 'object'
        }
      };
      scope.selectedFrame = {
        sprite: 0,
        action: 0,
        frame: 0
      };
      scope.modalTemplate = !(typeof localStorage !== "undefined" && localStorage !== null ? localStorage.dontShowWelcomeMessage : void 0) ? './includes/welcome_modal.html' : false;

      /*
      LISTENERS
       */
      scope.$watch('[sprites, options, imagedata]', function(_arg) {
        var imagedata, options, sprites;
        sprites = _arg[0], options = _arg[1], imagedata = _arg[2];
        if (imagedata) {
          return $timeout(function() {
            var action, ai, fi, frame, opt, output, si, sprite, _ref, _ref1, _ref2;
            opt = options.output;
            output = opt.naming === 'object' ? '{' : '[';

            /*
            sprite loop
             */
            _ref = scope.sprites;
            for (si in _ref) {
              sprite = _ref[si];
              si = parseInt(si);
              output += opt.naming === 'object' ? "'" + sprite.name + "':{'actions':{" : "{'name':'" + sprite.name + "','actions':[";

              /*
              action loop
               */
              _ref1 = sprite.actions;
              for (ai in _ref1) {
                action = _ref1[ai];
                ai = parseInt(ai);
                output += opt.naming === 'object' ? "'" + action.name + "':{'frames':[" : "{'name':'" + action.name + "','frames':[";

                /*
                frame loop
                 */
                _ref2 = action.frames;
                for (fi in _ref2) {
                  frame = _ref2[fi];
                  fi = parseInt(fi);
                  output += (opt.frame === 'array' ? "" + (JSON.stringify(frame)) : opt.frame === 'object' ? "{'x':" + frame[0] + ",'y':" + frame[1] + ",'width':" + frame[2] + ",'height':" + frame[3] + "}" : opt.frame === 'png' ? "'" + (getPixelData('png', img, frame)) + "'" : opt.frame === 'image' ? "" + (JSON.stringify(getPixelData('img', img, frame))) : void 0);
                  if (fi !== action.frames.length - 1) {
                    output += ',';
                  }
                }
                output += opt.naming === 'object' ? ']}' : ']}';
                if (ai !== sprite.actions.length - 1) {
                  output += ',';
                }
              }
              output += opt.naming === 'object' ? '}}' : ']}';
              if (si !== scope.sprites.length - 1) {
                output += ',';
              }
            }
            output += opt.naming === 'object' ? '}' : ']';
            return scope.output = output.replace(/\'/g, '"');
          });
        }
      }, true);
      scope.$watch('imagedata', function(imagedata) {
        if (imagedata != null) {
          return img.src = imagedata;
        }
      });
      $(window).on('blur', function() {
        mouseOverNavigator = false;
        navigatorMouseDown = false;
        return selectorMouseDown = false;
      });
      $('body').on('focus', '.click-select', function(e) {
        return $timeout(function() {
          return $(e.target).select();
        });
      });
      $('canvas').on('contextmenu', function(e) {
        return e.preventDefault();
      });
      navigatorCanvas.on('mouseover', function(e) {
        return mouseOverNavigator = true;
      });
      navigatorCanvas.on('mouseout', function(e) {
        return mouseOverNavigator = false;
      });
      navigatorCanvas.on('mousewheel', function(e) {
        e.preventDefault();
        if (!navigatorMouseDown) {
          if (e.deltaY) {
            navigatorCursor.zoom += zoomSpeed * (e.deltaY < 1 ? 1 : -1);
            if (navigatorCursor.zoom < 0.1) {
              navigatorCursor.zoom = 0.1;
            }
            if (navigatorCursor.zoom > 1) {
              return navigatorCursor.zoom = 1;
            }
          }
        }
      });
      fileSelect.on('change', function(e) {
        return loadNewSpritesheet(e.target.files[0]);
      });

      /*
      UTIL
       */
      fileLoadType = 'new';
      scope.newSpritesheet = function() {
        fileLoadType = 'new';
        fileSelect.click();
        return true;
      };
      scope.updateSpritesheet = function() {
        fileLoadType = 'update';
        if (!fileSelect[0].files.length) {
          fileSelect.click();
        } else {
          loadNewSpritesheet(fileSelect[0].files[0]);
        }
        return true;
      };
      loadNewSpritesheet = function(selectedFile) {
        var reader;
        if (selectedFile != null) {
          reader = new FileReader();
          reader.onload = function(e) {
            return scope.$apply(function() {
              scope.imagedata = e.target.result;
              if (fileLoadType === 'new') {
                reset();
                scope.spritesheetID = new Date().getTime();
                return scope.sprites = [];
              }
            });
          };
        }
        return reader.readAsDataURL(selectedFile);
      };
      scrollToListElement = function(spriteIndex, actionIndex, frameIndex) {
        var action, element, frame, scrollTop, sprite;
        scrollTop = listElement.scrollTop();
        element = {};
        if (spriteIndex != null) {
          element = sprite = $('.sprite').eq(spriteIndex);
          if ((actionIndex == null) && (frameIndex == null)) {
            scrollTop += sprite.position().top;
          } else if (actionIndex != null) {
            element = action = sprite.find('.action').eq(actionIndex);
            if (frameIndex == null) {
              scrollTop += action.position().top;
            } else if (frameIndex != null) {
              element = frame = action.find('.frame').eq(frameIndex);
              scrollTop += frame.position().top;
            }
          }
        }
        return listElement.scrollTop(scrollTop - listElement.height() / 2 + element.height() / 2);
      };
      scope.getSelected = function() {
        var r, _ref, _ref1;
        r = scope.selectedFrame;
        return (_ref = scope.sprites[r.sprite]) != null ? (_ref1 = _ref.actions[r.action]) != null ? _ref1.frames[r.frame] : void 0 : void 0;
      };
      scope.setSelected = function(sprite, action, frame) {
        return scope.selectedFrame = {
          sprite: sprite,
          action: action,
          frame: frame
        };
      };
      scope.isSelected = function(sprite, action, frame) {
        var s;
        s = scope.selectedFrame;
        return s.sprite === sprite && s.action === action && s.frame === frame;
      };
      scope.getFrameImage = function(dimensions, width, height) {
        return getPixelData('png', img, dimensions, width, height);
      };
      scope.addSprite = function() {
        if (scope.imagedata) {
          scope.sprites.push({
            name: 'sprite',
            actions: [],
            $sb_currentAction: 0,
            $sb_currentFrame: 0,
            $sb_listOpen: true
          });
          return $timeout(function() {
            var spriteIndex;
            spriteIndex = scope.sprites.length - 1;
            $('.sprite_header input').eq(scope.sprites.length - 1).select();
            return scrollToListElement(spriteIndex);
          });
        }
      };
      scope.removeSprite = function(spriteIndex) {
        return scope.sprites.splice(spriteIndex, 1);
      };
      $interval((function(_this) {
        return function() {
          var action, sprite, _i, _len, _ref, _ref1, _results;
          _ref = scope.sprites;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            sprite = _ref[_i];
            if (sprite.$sb_currentAction == null) {
              sprite.$sb_currentAction = 0;
            }
            if (sprite.$sb_currentFrame == null) {
              sprite.$sb_currentFrame = 0;
            }
            sprite.$sb_currentFrame++;
            if (sprite.$sb_currentFrame >= ((_ref1 = sprite.actions[sprite.$sb_currentAction]) != null ? _ref1.frames.length : void 0)) {
              sprite.$sb_currentFrame = 0;
              sprite.$sb_currentAction++;
              if (sprite.$sb_currentAction >= sprite.actions.length) {
                sprite.$sb_currentAction = 0;
              }
            }
            _results.push((function() {
              var _j, _len1, _ref2, _results1;
              _ref2 = sprite.actions;
              _results1 = [];
              for (_j = 0, _len1 = _ref2.length; _j < _len1; _j++) {
                action = _ref2[_j];
                if (action.$sb_currentFrame == null) {
                  action.$sb_currentFrame = 0;
                }
                action.$sb_currentFrame++;
                if (action.$sb_currentFrame >= action.frames.length) {
                  _results1.push(action.$sb_currentFrame = 0);
                } else {
                  _results1.push(void 0);
                }
              }
              return _results1;
            })());
          }
          return _results;
        };
      })(this), 200);
      scope.addAction = function(spriteIndex) {
        var self;
        scope.sprites[spriteIndex].actions.push(self = {
          name: 'action',
          frames: [],
          $sb_currentFrame: 0,
          $sb_listOpen: true
        });
        scope.sprites[spriteIndex].$sb_listOpen = true;
        return $timeout(function() {
          var actionIndex;
          actionIndex = scope.sprites[spriteIndex].actions.length - 1;
          $('.sprite').eq(spriteIndex).find('.action_header input').eq(actionIndex).select();
          return scrollToListElement(spriteIndex, actionIndex);
        });
      };
      scope.removeAction = function(spriteIndex, actionIndex) {
        return scope.sprites[spriteIndex].actions.splice(actionIndex, 1);
      };
      scope.addFrame = function(spriteIndex, actionIndex) {
        var frameIndex, _ref;
        if (((_ref = scope.sprites[spriteIndex]) != null ? _ref.actions[actionIndex] : void 0) != null) {
          scope.sprites[spriteIndex].actions[actionIndex].frames.push([]);
          frameIndex = scope.sprites[spriteIndex].actions[actionIndex].frames.length - 1;
          scope.setSelected(spriteIndex, actionIndex, frameIndex);
          scope.sprites[spriteIndex].$sb_listOpen = true;
          scope.sprites[spriteIndex].actions[actionIndex].$sb_listOpen = true;
          return $timeout(function() {
            return $timeout(function() {
              return scrollToListElement(spriteIndex, actionIndex, frameIndex);
            });
          });
        }
      };
      scope.removeFrame = function(spriteIndex, actionIndex, frameIndex) {
        scope.sprites[spriteIndex].actions[actionIndex].frames.splice(frameIndex, 1);
        if (frameIndex === scope.selectedFrame.frame) {
          return scope.selectedFrame.frame = -1;
        } else if (frameIndex < scope.selectedFrame.frame) {
          return scope.selectedFrame.frame--;
        }
      };
      save = scope.save = function() {
        var localSpritesheets, spritesheet;
        if (typeof localStorage !== "undefined" && localStorage !== null) {
          localSpritesheets = JSON.parse(localStorage.spritesheets);
          spritesheet = {
            id: scope.spritesheetID,
            sprites: scope.sprites,
            image: img.src,
            options: scope.options
          };
          localSpritesheets[spritesheet.id] = spritesheet;
          return localStorage.spritesheets = JSON.stringify(localSpritesheets);
        }
      };
      load = scope.load = function(id) {
        var parentScope, sheet, spritesheets;
        if (typeof localStorage !== "undefined" && localStorage !== null) {
          spritesheets = JSON.parse(localStorage.spritesheets);
          sheet = spritesheets[id];
          if (sheet != null) {
            parentScope = scope;
            parentScope.spritesheetID = id;
            parentScope.imagedata = sheet.image;
            parentScope.sprites = sheet.sprites;
            parentScope.options = sheet.options;
            parentScope.modalTemplate = false;
            return fileSelect[0].value = '';
          }
        }
      };

      /*
      CONTROLLERS
       */
      scope.optionsModalCtrl = [
        '$scope', function(scope) {
          scope.optionsCache = $.extend(true, {}, scope.$parent.$parent.options);
          return scope.save = function() {
            $.extend(scope.$parent.$parent.options, scope.optionsCache);
            return scope.$parent.$parent.$parent.modalTemplate = false;
          };
        }
      ];
      scope.welcomeModalCtrl = [
        '$scope', function(scope) {
          if (typeof localStorage !== "undefined" && localStorage !== null) {
            localStorage.dontShowWelcomeMessage = 'true';
          }
          return scope.loadDemo = function() {
            load('1397171491141');
            return scope.$parent.$parent.$parent.modalTemplate = false;
          };
        }
      ];
      scope.loadModalCtrl = [
        '$scope', function(scope) {
          scope.spritesheets = {};
          if (typeof localStorage !== "undefined" && localStorage !== null) {
            scope.spritesheets = JSON.parse(localStorage.spritesheets);
          }
          scope.$watch('spritesheets', function() {
            var k;
            return scope.noSheets = !((function() {
              var _results;
              _results = [];
              for (k in scope.spritesheets) {
                _results.push((function() {
                  return true;
                })());
              }
              return _results;
            })()).length;
          }, true);
          scope["delete"] = function(id) {
            scope.spritesheets[id] = void 0;
            delete scope.spritesheets[id];
            localStorage.spritesheets = JSON.stringify(scope.spritesheets);
            if (scope.selected === id) {
              return scope.selected = false;
            }
          };
          return scope.load = function(id) {
            return load(id);
          };
        }
      ];

      /*
      IMAGE NAVIGATOR FRAMEWORK
       */
      adjustNavigatorSelection = function(x, y) {
        navigatorSelection.zoom = navigatorCursor.zoom;
        navigatorSelection.x = (Math.floor(x) - horizontalEdgeAdjustment) / imgResizeFactor;
        return navigatorSelection.y = (Math.floor(y) - verticalEdgeAdjustment) / imgResizeFactor;
      };
      horizontalEdgeAdjustment = 0;
      verticalEdgeAdjustment = 0;
      navigatorSelectionWidth = 0;
      navigatorSelectionHeight = 0;
      navigatorCq = cq(navigatorCanvas[0]).framework({
        onmousedown: function(x, y) {
          navigatorMouseDown = true;
          return adjustNavigatorSelection(x, y);
        },
        onmouseup: function(x, y) {
          return navigatorMouseDown = false;
        },
        onmousemove: function(x, y) {
          navigatorMouseCoords = {
            x: x,
            y: y
          };
          if (navigatorMouseDown) {
            return adjustNavigatorSelection(x, y);
          }
        },
        onrender: function(delta, time) {
          var navigatorCursorHeight, navigatorCursorWidth;
          this.context.mozImageSmoothingEnabled = this.context.webkitImageSmoothingEnabled = this.context.msImageSmoothingEnabled = this.context.imageSmoothingEnabled = false;
          this.clear();
          drawBackgroundTiles(this, 1);
          if (scope.imagedata) {
            if (img.src) {
              horizontalEdgeAdjustment = (navigatorCanvas.width() - img.width * imgResizeFactor) / 2;
              verticalEdgeAdjustment = (navigatorCanvas.height() - img.height * imgResizeFactor) / 2;
              navigatorSelectionWidth = selectorCanvas.width() * navigatorSelection.zoom;
              navigatorSelectionHeight = selectorCanvas.height() * navigatorSelection.zoom;
              imgResizeFactor = Math.min(this.canvas.height / img.height, this.canvas.width / img.width);
              this.save().translate(horizontalEdgeAdjustment, verticalEdgeAdjustment).drawImage(img, 0, 0, img.width * imgResizeFactor, img.height * imgResizeFactor).restore();
              if (mouseOverNavigator && !navigatorMouseDown) {
                navigatorCursorWidth = selectorCanvas.width() * navigatorCursor.zoom;
                navigatorCursorHeight = selectorCanvas.height() * navigatorCursor.zoom;
                navigatorCursor.x = navigatorMouseCoords.x - navigatorCursorWidth / 2;
                navigatorCursor.y = navigatorMouseCoords.y - navigatorCursorHeight / 2;
                this.save().translate(navigatorCursor.x, navigatorCursor.y).save().globalAlpha(0.3).fillStyle(navigatorCursor.color).fillRect(0, 0, navigatorCursorWidth, navigatorCursorHeight).restore().strokeStyle(navigatorCursor.color).strokeRect(0, 0, navigatorCursorWidth, navigatorCursorHeight).restore();
              }
              if ((navigatorSelection.x != null) && (navigatorSelection.y != null)) {
                return this.save().translate(navigatorSelection.x * imgResizeFactor - (navigatorSelectionWidth / 2) + horizontalEdgeAdjustment, navigatorSelection.y * imgResizeFactor - (navigatorSelectionHeight / 2) + verticalEdgeAdjustment).save().globalAlpha(0.3).fillStyle(navigatorSelection.color).fillRect(0, 0, selectorCanvas.width() * navigatorSelection.zoom, selectorCanvas.height() * navigatorSelection.zoom).restore().strokeStyle(navigatorSelection.color).strokeRect(0, 0, selectorCanvas.width() * navigatorSelection.zoom, selectorCanvas.height() * navigatorSelection.zoom).restore();
              }
            }
          }
        }
      });

      /*
      SELECTOR FRAMEWORK
       */
      selectorBtnCache = '';
      adjustSelectorSelection = function(x, y, btn) {
        var imgX, imgY, s;
        if (btn != null) {
          selectorBtnCache = btn;
        }
        btn = selectorBtnCache;
        s = scope.getSelected();
        if (s) {
          imgX = (navigatorSelection.x * imgResizeFactor - navigatorSelectionWidth / 2) / navigatorSelection.zoom;
          imgY = (navigatorSelection.y * imgResizeFactor - navigatorSelectionHeight / 2) / navigatorSelection.zoom;
          x = Math.floor((x + imgX) / imgResizeFactor * navigatorSelection.zoom);
          y = Math.floor((y + imgY) / imgResizeFactor * navigatorSelection.zoom);
          if (btn === 0) {
            scope.$apply(function() {
              if ((s[2] != null) && (s[3] != null)) {
                if (x >= s[0] + s[2]) {
                  x = s[0] + s[2] - 1;
                }
                if (y >= s[1] + s[3]) {
                  y = s[1] + s[3] - 1;
                }
              }
              if ((s[0] != null) && (s[1] != null) && (s[2] != null) && (s[3] != null)) {
                s[2] = (s[0] + s[2]) - x;
                s[3] = (s[1] + s[3]) - y;
              }
              s[0] = x;
              return s[1] = y;
            });
          }
          if (btn === 1 || btn === 2) {
            return scope.$apply(function() {
              if ((s[0] != null) && (s[1] != null)) {
                if (x <= s[0]) {
                  x = s[0] + 1;
                }
                if (y <= s[1]) {
                  y = s[1] + 1;
                }
              }
              if ((s[0] != null) && (s[1] != null)) {
                s[2] = x - s[0];
                return s[3] = y - s[1];
              }
            });
          }
        }
      };
      return selectorCq = cq(selectorCanvas[0]).framework({
        onkeyup: function(key) {
          if (!$('input:focus, textarea:focus').length) {
            if (key === 'f') {
              return scope.addFrame(scope.selectedFrame.sprite, scope.selectedFrame.action);
            }
          }
        },
        onmousemove: function(x, y) {
          selectorMouseCoords = {
            x: x,
            y: y
          };
          if (navigatorMouseDown) {
            return adjustSelectorSelection(x, y);
          }
        },
        onmousedown: function(x, y, btn) {
          navigatorMouseDown = true;
          return adjustSelectorSelection(x, y, btn);
        },
        onmouseup: function(x, y) {
          return navigatorMouseDown = false;
        },
        onrender: function(delta, time) {
          var action, actionIndex, drawX, drawY, frame, frameColor, frameIndex, frmHeight, frmWidth, frmX, frmY, selected, sprite, spriteIndex, transX, transY, _ref, _results;
          this.context.mozImageSmoothingEnabled = this.context.webkitImageSmoothingEnabled = this.context.msImageSmoothingEnabled = this.context.imageSmoothingEnabled = false;
          this.clear();
          drawBackgroundTiles(this, navigatorSelection.zoom);
          if (scope.imagedata) {
            if ((navigatorSelection.x != null) && (navigatorSelection.y != null)) {
              drawX = navigatorSelection.x - (navigatorSelectionWidth / imgResizeFactor / 2);
              drawY = navigatorSelection.y - (navigatorSelectionHeight / imgResizeFactor / 2);
              transX = drawX < 0 ? Math.abs(drawX) / navigatorSelection.zoom * imgResizeFactor : 0;
              transY = drawY < 0 ? Math.abs(drawY) / navigatorSelection.zoom * imgResizeFactor : 0;
              this.save().translate(transX, transY).drawImage(img, transX ? 0 : drawX, transY ? 0 : drawY, (selectorCanvas.width() * navigatorSelection.zoom) / imgResizeFactor, (selectorCanvas.height() * navigatorSelection.zoom) / imgResizeFactor, 0, 0, this.canvas.width, this.canvas.height).restore();
              _ref = scope.sprites;
              _results = [];
              for (spriteIndex in _ref) {
                sprite = _ref[spriteIndex];
                if (!sprite.hidden) {
                  _results.push((function() {
                    var _ref1, _results1;
                    _ref1 = sprite.actions;
                    _results1 = [];
                    for (actionIndex in _ref1) {
                      action = _ref1[actionIndex];
                      if (!action.hidden) {
                        _results1.push((function() {
                          var _ref2, _results2;
                          _ref2 = action.frames;
                          _results2 = [];
                          for (frameIndex in _ref2) {
                            frame = _ref2[frameIndex];
                            if (!frame.hidden) {
                              if ((frame[0] != null) && (frame[1] != null)) {
                                spriteIndex = parseInt(spriteIndex);
                                actionIndex = parseInt(actionIndex);
                                frameIndex = parseInt(frameIndex);
                                frmX = frame[0];
                                frmY = frame[1];
                                frmWidth = frame[2];
                                frmHeight = frame[3];
                                frmX = (frmX - drawX) * imgResizeFactor / navigatorSelection.zoom;
                                frmY = (frmY - drawY) * imgResizeFactor / navigatorSelection.zoom;
                                frmWidth = frmWidth * imgResizeFactor / navigatorSelection.zoom;
                                frmHeight = frmHeight * imgResizeFactor / navigatorSelection.zoom;
                                selected = scope.selectedFrame.sprite === spriteIndex && scope.selectedFrame.action === actionIndex && scope.selectedFrame.frame === frameIndex;
                                frameColor = selected ? '#c80819' : '#21d4cc';
                                this.save().translate(frmX, frmY).save().globalAlpha(0.3).fillStyle(frameColor).fillRect(0, 0, frmWidth, frmHeight).restore().strokeStyle(frameColor).strokeRect(0, 0, frmWidth, frmHeight).restore();
                                if (selected) {
                                  this.fillStyle('#fea00e');
                                  this.fillRect(frmX - 2, frmY - 2, 4, 4);
                                  if ((frame[2] != null) && (frame[3] != null)) {
                                    this.fillStyle('#24ffae');
                                    _results2.push(this.fillRect(frmX + frmWidth - 2, frmY + frmHeight - 2, 4, 4));
                                  } else {
                                    _results2.push(void 0);
                                  }
                                } else {
                                  _results2.push(void 0);
                                }
                              } else {
                                _results2.push(void 0);
                              }
                            } else {
                              _results2.push(void 0);
                            }
                          }
                          return _results2;
                        }).call(this));
                      } else {
                        _results1.push(void 0);
                      }
                    }
                    return _results1;
                  }).call(this));
                } else {
                  _results.push(void 0);
                }
              }
              return _results;
            }
          }
        }
      });
    }
  ]);

}).call(this);
