import sdl, sdl_image, opengl, dynobj

import catty.core

import
  MGameObjects.MGameFieldType, MGameObjects.MGameFieldBody,
  MGameObjects.MProtagonistType, MGameObjects.MProtagonistBody,
  MGameLogic.MGlobal

var 
  event: sdl.TEvent
  gameField = TGameField(fillColor: "#FFA5A5")
  protagonist = TProtagonist(x: 5, y: 5)

application.initialization()

block gameLoopBlock:
  while true:
    block gameCheckEventBlock:
      while sdl.pollEvent(addr event) > 0:
        application.checkEvent(addr event)

        case event.kind
        of sdl.KEYDOWN:
          protagonist.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
        of sdl.KEYUP: discard
        else: discard

    block gameUpdateBlock:
      protagonist.update()
    block gameDraw:
      opengl.glClear(opengl.GL_COLOR_BUFFER_BIT or opengl.GL_DEPTH_BUFFER_BIT)
      gameField.draw()
      protagonist.draw()

      sdl.GL_SwapBuffers()

    if application.isQuit == true:
      break gameLoopBlock

    sdl.delay(30)

application.quit()