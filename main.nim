{.checks: off.}

import sdl, opengl, dynobj

import 
  catty.core.application as app,
  catty.core.graphics,
  catty.core.utils,
  catty.core2
 
import
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameLogic.MGlobal

var 
  gameField = TGameField(fillColor: "#205B7B")
  protagonist = TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")

application:
  settings: 
    screenWidth = SCREEN_WIDTH
    screenHeight = SCREEN_HEIGHT
  game_objects:
    TGameField(fillColor: "#205B7B")
    TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")
  test:
    var 
      gameField = TGameField(fillColor: "#205B7B")
      protagonist = TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")
    discard sdl.init(sdl.INIT_TIMER)


game_objects_global:
  GameField
  Protagonist
  # test:
  #   type TGameObjectType = enum gtGameField, gtProtoganist


app.init(SCREEN_WIDTH, SCREEN_HEIGHT)
app.setWindowCaption("SH")

# echo gameField.asGameObject.kind

block gameLoop:
  while true:

    block checkEvent:
      var event: sdl.TEvent

      while sdl.pollEvent(addr event) > 0:
        case event.kind
        of QUITEV:
          break gameLoop
        of KEYDOWN:
          case evKeyboard(addr event).keysym.sym
          of K_ESCAPE:
            break gameLoop
          of K_RCTRL:
            # RCTRL = true
            cattyKeyIsDown.add(kdRControl)
            echo "keydown:  <Right: CTRL>"
          of K_LCTRL:
            # LCTRL = true
            cattyKeyIsDown.add(kdLControl)
            echo "keydown: <Left: CTRL>"
          of K_RALT:
            # RCTRL = true
            cattyKeyIsDown.add(kdRAlt)
            echo "keydown: <Right: ALT>"
          of K_LALT:
            # LALT = true
            cattyKeyIsDown.add(kdLAlt)
            echo "keydown: <Left: ALT>"
          else: discard
        of KEYUP:
          case evKeyboard(addr event).keysym.sym
          of K_RCTRL:
            RCTRL = true
            echo "keyup:  <Right: CTRL>"
          of K_LCTRL:
            echo "keyup: <Left: CTRL>"
            LCTRL = true
          of K_RALT:
            echo "keyup: <Right: ALT>"
            RCTRL = true
          of K_LALT:
            echo "keyup: <Left: ALT>"
            LALT = true
          else: discard
        else: discard

        gameField.checkEvent(event)
        protagonist.checkEvent(event)

    block update:
      gameField.update()
      protagonist.update()

    block draw:
      glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT )
      gameField.draw()
      protagonist.draw()
      sdl.GL_SwapBuffers()

    sdl.delay(10)

app.quit()