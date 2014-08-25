import sdl, opengl, dynobj
import macros

import 
  catty.core.application, 
  catty.core.graphics, 
  catty.core.utils
 
import
  MGlobal,
  MGameObjects.MBase,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameObjects.MTiles

var
  gameField = TGameField(lineColor: "#54B154")
  protagonist = TProtagonist(x: 2, y: 2, fillColor: "#3D6072", possibleDirection: @[drEast, drWest])

application.init(SCREEN_WIDTH, SCREEN_HEIGHT)
application.setWindowCaption("SH")

gameField.init()

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

        protagonist.checkEvent(event)

    block update:
      protagonist.update()

    block draw:
      glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

      gameField.draw()
      protagonist.draw()

      sdl.GL_SwapBuffers()
    sdl.delay(APPLICATON_DELAY)

application.quit()