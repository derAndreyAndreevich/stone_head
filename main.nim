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
  MGameLogic.MDispatcher,
  MGameLogic.MGlobal


application.initialization()

var 
  event: sdl.TEvent
  userEvent: PUserEvent

  dispatcher: TGameDispatcher 

gameObjects.add(@[
  TGameField().initialization.toCattyGameObject,
  TProtagonist().initialization.toCattyGameObject,
  TSighting().initialization.toCattyGameObject
])

dispatcher = TGameDispatcher().initialization


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

        of sdl.USEREVENT:

          userEvent = evUser(addr event)
          dispatcher.onUserEvent(userEvent)

          for gameObject in gameObjects:
            case gameObject.kind
            of tpGameField.ord: gameObject.asGameField.onUserEvent(userEvent)
            of tpProtagonist.ord: gameObject.asProtagonist.onUserEvent(userEvent)
            of tpSighting.ord: gameObject.asSighting.onUserEvent(userEvent)
            else: discard


        else: discard

    block gameUpdateBlock:

      for gameObject in gameObjects:
        case gameObject.kind
        of tpGameField.ord: gameObject.asGameField.update
        of tpProtagonist.ord: gameObject.asProtagonist.update
        of tpSighting.ord: gameObject.asSighting.update
        else: discard

    block gameDraw:

      opengl.glClear(opengl.GL_COLOR_BUFFER_BIT or opengl.GL_DEPTH_BUFFER_BIT)

      for gameObject in gameObjects:
        case gameObject.kind
        of tpGameField.ord: gameObject.asGameField.draw
        of tpProtagonist.ord: gameObject.asProtagonist.draw
        of tpSighting.ord: gameObject.asSighting.draw
        else: discard

      glFlush()
      sdl.GL_SwapBuffers()

    if application.isQuit == true:
      break gameLoopBlock

    sdl.delay(30)

application.quit()