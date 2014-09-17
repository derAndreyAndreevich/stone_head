import sdl

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils

import
  MGameLogic.MGlobal,
  MGameFieldType

part GameField:
  draw:
    this.fillColor.glColor()

    for i in countup(0, SCREEN_HEIGHT, SCALE):
      glLine(0, i, SCREEN_WIDTH, i)

    for i in countup(0, SCREEN_WIDTH, SCALE):
      glLine(i, 0, i, SCREEN_HEIGHT)