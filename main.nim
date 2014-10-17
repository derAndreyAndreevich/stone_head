import sdl, opengl
import 
  catty.core as MCattyCore,
  catty.gameobjects as MCattyGameObjects

import
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameLogic.MCast,
  MGameLogic.MGlobal,
  MGameLogic.MDispatcher

application.initialization()

type e = enum aa, bb, cc

var 
  event: sdl.TEvent
  dispatcher = TGameDispatcher().initialization

gameObjects.add(@[
  TGameField().initialization.toCattyGameObject,
  TProtagonist().initialization.toCattyGameObject
])


block gameLoopBlock:
  while true:
    block gameCheckEventBlock:
      while sdl.pollEvent(addr event) > 0:
        application.checkEvent(addr event)

        case event.kind
        of sdl.KEYDOWN:
          dispatcher.onKeyDown(evKeyboard(addr event).keysym.sym)
          # for gameObject in gameObjects:
          #   case gameObject.kind
          #   of TYPE_GAMEFIELD: gameObject.asGameField.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
          #   of TYPE_PROTAGONIST: gameObject.asProtagonist.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
          #   else: discard

        of sdl.KEYUP: 

          dispatcher.onKeyUp(evKeyboard(addr event).keysym.sym)
          # for gameObject in gameObjects:
          #   case gameObject.kind
          #   of TYPE_GAMEFIELD: gameObject.asGameField.onKeyUp(sdl.evKeyboard(addr event).keysym.sym)
          #   of TYPE_PROTAGONIST: gameObject.asProtagonist.onKeyUp(sdl.evKeyboard(addr event).keysym.sym)
          #   else: discard

        else: discard

    block gameUpdateBlock:

      for gameObject in gameObjects:
        case gameObject.kind
        of TYPE_GAMEFIELD: gameObject.asGameField.update()
        of TYPE_PROTAGONIST: gameObject.asProtagonist.update()
        else: discard

    block gameDraw:

      opengl.glClear(opengl.GL_COLOR_BUFFER_BIT or opengl.GL_DEPTH_BUFFER_BIT)

      for gameObject in gameObjects:
        case gameObject.kind
        of TYPE_GAMEFIELD: gameObject.asGameField.draw()
        of TYPE_PROTAGONIST: gameObject.asProtagonist.draw()
        else: discard

      glFlush()
      sdl.GL_SwapBuffers()

    if application.isQuit == true:
      break gameLoopBlock

    sdl.delay(30)

application.quit()