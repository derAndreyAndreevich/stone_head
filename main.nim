import sdl, sdl_image, opengl, dynobj

import catty.core

import
  MGameObjects.MGameFieldType, MGameObjects.MGameFieldBody,
  MGameObjects.MProtagonistType, MGameObjects.MProtagonistBody,
  MGameLogic.MGlobal

var 
  event: sdl.TEvent
  gameField = TGameField(fillColor: "#FFA5A5")
  sTexture = imgLoad("/home/andreysh/Projects/nimrod/stone_head/build/texture2.png")


if sTexture == nil:
  echo "nil"
  echo GetError()
else:
  echo "not nil"


application.initialization()

# glGenTextures(1, addr texture)
# glBindTexture(GL_TEXTURE_2D, texture)
# glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, sTexture.w, sTexture.h, 0, GL_RGBA, GL_UNSIGNED_BYTE, sTexture.pixels)
# glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR)
# glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR)
# freeSurface(sTexture)

application.loadTexture("texture2.tga")
application.loadTexture("wall.png")


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
