import sdl

import catty.core

import
  MGameLogic.MGlobal,
  MTilesType

# proc draw*(this: TTile) =
#   let
#     x1 = this.x * SCALE
#     y1 = this.y * SCALE
#     x2 = (this.x + 1) * SCALE
#     y2 = (this.x + 1) * SCALE

#   case this.tileType
#   of ttWall: glBindTexture(GL_TEXTURE_2D, application.getTexture("wall"))
#   of tt
#   else: discard