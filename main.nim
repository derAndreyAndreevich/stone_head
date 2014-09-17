import sdl, opengl, dynobj

import 
  catty.core.application as app,
  catty.core.graphics,
  catty.core.utils,
  catty.core.colors,
  catty.core2
 
import
  MGameObjects.MGameFieldType, MGameObjects.MGameFieldBody,
  MGameObjects.MProtagonistType, MGameObjects.MProtagonistBody,
  MGameLogic.MGlobal

# cattyGameObjects.add(TGameField(fillColor: "#205B7B").asGameObject)
# cattyGameObjects.add(TProtagonist(x: 5, y: 5, fillColor: "#91CFD5").asGameObject)

application:
  settings: 
    screenWidth = SCREEN_WIDTH
    screenHeight = SCREEN_HEIGHT
  game_objects:

    TGameField(fillColor: "#205B7B")
    TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")
  test:
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

              for gameObject in cattyGameObjects:
                if gameObject.kind == gtGameField:
                  gameObject.toGameField.checkEvent(event)
                elif gameObject.kind == gtProtagonist:
                  gameObject.toProtagonist.checkEvent(event)

            else: discard


# app.init(SCREEN_WIDTH, SCREEN_HEIGHT)
# app.setWindowCaption("SH")

# # echo gameField.asGameObject.kind

# block gameLoop:
#   while true:

#     block checkEvent:
#       var event: sdl.TEvent

#       while sdl.pollEvent(addr event) > 0:
#         case event.kind
#         of QUITEV:
#           break gameLoop
#         of KEYDOWN:
#           case evKeyboard(addr event).keysym.sym
#           of K_ESCAPE:
#             break gameLoop
#           else: discard
#         else: discard

#         for gameObject in cattyGameObjects:
#           if gameObject.kind == gtGameField:
#             gameObject.toGameField.checkEvent(event)
#           elif gameObject.kind == gtProtagonist:
#             gameObject.toProtagonist.checkEvent(event)

#     block update:
#       for gameObject in cattyGameObjects:
#         if gameObject.kind == gtGameField:
#           gameObject.toGameField.update()
#         elif gameObject.kind == gtProtagonist:
#           gameObject.toProtagonist.update()

#     block draw:
#       glClear( GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT )
#       for gameObject in cattyGameObjects:
#         if gameObject.kind == gtGameField:
#           gameObject.toGameField.draw()
#         elif gameObject.kind == gtProtagonist:
#           gameObject.toProtagonist.draw()
#       sdl.GL_SwapBuffers()

#     sdl.delay(10)

# app.quit()