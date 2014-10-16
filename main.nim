import sdl, opengl
import 
  catty.core as MCattyCore,
  catty.gameobjects as MCattyGameObjects

import
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameLogic.MCast,
  MGameLogic.MGlobal
# MGameObjects.MTiles,
# MGameObjects.MProtagonist,

application.initialization()

type e = enum aa, bb, cc

var 
  event: sdl.TEvent


gameObjects.add(@[
  TGameField(kind: TYPE_GAMEFIELD, isDraw: true, x: 0, y: 0, w: 19 * SCALE, h: 11 * SCALE, texture: application.getTexture("wall")).initialization.toCattyGameObject
])

# var gameField = 

# TProtagonist(kind: TYPE_PROTAGONIST, x: 7, y: 6).initialization.toGameObject


block gameLoopBlock:
  while true:
    block gameCheckEventBlock:
      while sdl.pollEvent(addr event) > 0:
        application.checkEvent(addr event)

        case event.kind
        of sdl.KEYDOWN:

          for gameObject in gameObjects:
            case gameObject.kind
            of TYPE_GAMEFIELD: gameObject.asGameField.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
            of TYPE_PROTAGONIST: gameObject.asProtagonist.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
            else: discard

        of sdl.KEYUP:

          for gameObject in gameObjects:
            case gameObject.kind
            of TYPE_GAMEFIELD: gameObject.asGameField.onKeyUp(sdl.evKeyboard(addr event).keysym.sym)
            of TYPE_PROTAGONIST: gameObject.asProtagonist.onKeyUp(sdl.evKeyboard(addr event).keysym.sym)
            else: discard

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