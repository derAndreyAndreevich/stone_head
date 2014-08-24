import sdl, opengl, dynobj

import 
  catty.core.application, 
  catty.core.graphics, 
  catty.core.utils
 
import 
  MGameObjects.MBase,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameObjects.MTails

const
  APPLICATON_DELAY = 10


v["N"] = 30
v["M"] = 20
v["SCALE"] = 25
v["SCREEN_WIDTH"] = v["N"].asInt * v["SCALE"].asInt
v["SCREEN_HEIGHT"] = v["M"].asInt * v["SCALE"].asInt
v["APPLICATON_DELAY"] = APPLICATON_DELAY

var
  GameField = TGameField(lineColor: "#54B154")
  Protagonist = TProtagonist(x: 2, y: 2, fillColor: "#3D6072", possibleDirection: @[drEast, drWest])
  MainTile = TMainTile(x: 3, y: 3, fillColor: "#287E8A")

application.init(v["SCREEN_WIDTH"].asInt, v["SCREEN_HEIGHT"].asInt)
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

        Protagonist.checkEvent(event)

    block update:
      Protagonist.update()

    block draw:
      glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

      GameField.draw()
      Protagonist.draw()

      sdl.GL_SwapBuffers()
    sdl.delay(APPLICATON_DELAY)

application.quit()