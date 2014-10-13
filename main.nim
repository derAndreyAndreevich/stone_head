import sdl, sdl_image, opengl, dynobj

import catty.core

import
  MGameObjects.MGameFieldType, MGameObjects.MGameFieldBody,
  MGameObjects.MProtagonistType, MGameObjects.MProtagonistBody,
  MGameLogic.MGlobal

var 
  event: sdl.TEvent
  gameField = TGameField(fillColor: "#318BBB")



application.initialization()


application.loadTexture("texture2.tif")


block gameLoopBlock:
  while true:
    block gameCheckEventBlock:
      while sdl.pollEvent(addr event) > 0:
        application.checkEvent(addr event)
    block gameUpdateBlock:
      discard
    block gameDraw:
      opengl.glClear(opengl.GL_COLOR_BUFFER_BIT or opengl.GL_DEPTH_BUFFER_BIT)
      gameField.draw()
      sdl.GL_SwapBuffers()

    if application.isQuit == true:
      break gameLoopBlock

    sdl.delay(10)

application.quit()

# application:
#   settings: 
#     screenWidth = SCREEN_WIDTH
#     screenHeight = SCREEN_HEIGHT
#   game_objects:
#     TGameField(fillColor: "#205B7B")
#     TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")
