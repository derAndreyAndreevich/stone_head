import sdl, opengl, dynobj

import 
  catty.core.application
 
import
  MGameLogic.MGlobal,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist

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