import sdl

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils

import
  MGameLogic.MGlobal,
  MTilesType

part TileRed:
  draw:
    this.fillColor.glColor()
    glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)
