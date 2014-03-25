jade --watch *.jade &
coffee -w -j js/index.js -c js/coffee/util.coffee js/coffee/init.coffee js/coffee/foundation.coffee js/coffee/controller.coffee &
stylus -w css/ && fg