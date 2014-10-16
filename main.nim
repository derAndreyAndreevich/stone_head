import sdl, sdl_image, opengl, dynobj
import catty.core

import
  MGameObjects.MGameObjectType, MGameObjects.MGameObjectBody,
  MGameObjects.MGameFieldType, MGameObjects.MGameFieldBody,
  MGameObjects.MProtagonistType, MGameObjects.MProtagonistBody,
  MGameLogic.MCast,
  MGameLogic.MGlobal


var 
  event: sdl.TEvent

application.initialization()

gameObjects.add(@[
  TGameField(kind: gtGameField, fillColor: "#FFA5A5").initialization.toGameObject, 
  TProtagonist(kind: gtProtagonist, x: 7, y: 5).initialization.toGameObject
])


block gameLoopBlock:
  while true:
    block gameCheckEventBlock:
      while sdl.pollEvent(addr event) > 0:
        application.checkEvent(addr event)

        case event.kind
        of sdl.KEYDOWN:

          for gameObject in gameObjects:
            case gameObject.kind
            of gtGameField: gameObject.asGameField.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
            of gtProtagonist: gameObject.asProtagonist.onKeyDown(sdl.evKeyboard(addr event).keysym.sym)
            else: discard

        of sdl.KEYUP:
          for gameObject in gameObjects:
            case gameObject.kind
            of gtGameField: gameObject.asGameField.onKeyUp(sdl.evKeyboard(addr event).keysym.sym)
            of gtProtagonist: gameObject.asProtagonist.onKeyUp(sdl.evKeyboard(addr event).keysym.sym)
            else: discard

        else: discard

    block gameUpdateBlock:
      for gameObject in gameObjects:
        case gameObject.kind
        of gtGameField: gameObject.asGameField.update()
        of gtProtagonist: gameObject.asProtagonist.update()
        else: discard

    block gameDraw:
      opengl.glClear(opengl.GL_COLOR_BUFFER_BIT or opengl.GL_DEPTH_BUFFER_BIT)

      for gameObject in gameObjects:
        case gameObject.kind
        of gtGameField: gameObject.asGameField.draw()
        of gtProtagonist: gameObject.asProtagonist.draw()
        else: discard

      glFlush()
      sdl.GL_SwapBuffers()

    if application.isQuit == true:
      break gameLoopBlock

    sdl.delay(30)

application.quit()