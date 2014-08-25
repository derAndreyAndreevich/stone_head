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
  gameField = TGameField(lineColor: "#54B154")
  protagonist = TProtagonist(x: 2, y: 2, fillColor: "#3D6072", possibleDirection: @[drEast, drWest])
#   mainTiles: seq[TMainTile] = @[
#     TMainTile(x: 1, y: 1, fillColor: "#252B7A"),
#     TMainTile(x: 1, y: 2, fillColor: "#252B7A"),
#     TMainTile(x: 1, y: 3, fillColor: "#252B7A"),
#     TMainTile(x: 1, y: 4, fillColor: "#252B7A"),
#     TMainTile(x: 1, y: 5, fillColor: "#252B7A"),
#     TMainTile(x: 2, y: 2, fillColor: "#252B7A"),
#     TMainTile(x: 2, y: 3, fillColor: "#252B7A"),
#     TMainTile(x: 2, y: 4, fillColor: "#252B7A"),
#     TMainTile(x: 3, y: 1, fillColor: "#252B7A"),
#     TMainTile(x: 3, y: 2, fillColor: "#252B7A"),
#     TMainTile(x: 3, y: 3, fillColor: "#252B7A"),
#     TMainTile(x: 3, y: 5, fillColor: "#252B7A"),
#     TMainTile(x: 4, y: 1, fillColor: "#252B7A"),
#     TMainTile(x: 4, y: 3, fillColor: "#252B7A"),
#     TMainTile(x: 4, y: 4, fillColor: "#252B7A"),
#     TMainTile(x: 5, y: 1, fillColor: "#252B7A"),
#     TMainTile(x: 5, y: 2, fillColor: "#252B7A"),
#     TMainTile(x: 5, y: 3, fillColor: "#252B7A"),
#     TMainTile(x: 5, y: 4, fillColor: "#252B7A"),
#     TMainTile(x: 5, y: 5, fillColor: "#252B7A")
#   ]

# echo mainTiles.len


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

        protagonist.checkEvent(event)

    block update:
      protagonist.update()

    block draw:
      glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT)

      gameField.draw()

      # for mainTile in mainTiles:
      #   mainTile.draw()

      protagonist.draw()

      sdl.GL_SwapBuffers()
    sdl.delay(APPLICATON_DELAY)

application.quit()