import sdl, opengl, dynobj

import 
  catty.core.application as app,
  catty.core.graphics,
  catty.core.utils,
  catty.core.colors

import
  MGameObjects.MGameFieldType, MGameObjects.MGameFieldBody,
  MGameObjects.MProtagonistType, MGameObjects.MProtagonistBody,
  MGameLogic.MGlobal

application:
  settings: 
    screenWidth = SCREEN_WIDTH
    screenHeight = SCREEN_HEIGHT
  game_objects:
    TGameField(fillColor: "#205B7B")
    TProtagonist(x: 5, y: 5, fillColor: "#91CFD5")
