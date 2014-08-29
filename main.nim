{.checks: off.}

import sdl, opengl, dynobj

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils
 
import
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameLogic.MGlobal

var 
  gameField = TGameField(fillColor: "#205B7B")
  protagonist = TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")

application.init(SCREEN_WIDTH, SCREEN_HEIGHT)
application.setWindowCaption("SH")

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
            RCTRL = true
          of K_LCTRL:
            LCTRL = true
          of K_RALT:
            RCTRL = true
          of K_LALT:
            LCTRL = true
          else: discard
        of KEYUP:
          case evKeyboard(addr event).keysym.sym
          of K_RCTRL:
            RCTRL = false
          of K_LCTRL:
            LCTRL = false
          of K_RALT:
            RCTRL = false
          of K_LALT:
            LCTRL = false
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

application.quit()