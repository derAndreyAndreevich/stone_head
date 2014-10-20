import sdl, opengl
import 
  catty.core as MCattyCore,
  catty.gameobjects as MCattyGameObjects

import
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameObjects.MSighting,
  MGameLogic.MCast,
  MGameLogic.MGlobal,
  MGameLogic.MDispatcher

application.initialization()

var 
  event: sdl.TEvent
  dispatcher = TGameDispatcher().initialization

gameObjects.add(@[
  TGameField().initialization.toCattyGameObject,
  TProtagonist().initialization.toCattyGameObject,
  TSighting().initialization.toCattyGameObject
])


block gameLoopBlock:
  while true:
    block gameCheckEventBlock:
      while sdl.pollEvent(addr event) > 0:
        application.checkEvent(addr event)

        case event.kind
        of sdl.KEYDOWN:

          dispatcher.onKeyDown(evKeyboard(addr event).keysym.sym)

        of sdl.KEYUP: 

          dispatcher.onKeyUp(evKeyboard(addr event).keysym.sym)

        else: discard

    block gameUpdateBlock:

      for gameObject in gameObjects:
        case gameObject.kind
        of TYPE_GAMEFIELD: gameObject.asGameField.update()
        of TYPE_PROTAGONIST: gameObject.asProtagonist.update()
        of TYPE_SIGHTING: gameObject.asSighting.update()
        else: discard

    block gameDraw:

      opengl.glClear(opengl.GL_COLOR_BUFFER_BIT or opengl.GL_DEPTH_BUFFER_BIT)

      for gameObject in gameObjects:
        case gameObject.kind
        of TYPE_GAMEFIELD: gameObject.asGameField.draw()
        of TYPE_PROTAGONIST: gameObject.asProtagonist.draw()
        of TYPE_SIGHTING: gameObject.asSighting.draw()
        else: discard

      glFlush()
      sdl.GL_SwapBuffers()

    if application.isQuit == true:
      break gameLoopBlock

    sdl.delay(40)

application.quit()