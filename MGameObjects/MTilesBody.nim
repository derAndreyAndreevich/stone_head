import sdl, opengl

import catty.core

import
  MTilesType,
  MGameObjectType,
  MGameLogic.MGlobal

proc initialization*(this: TTile): TTile = 
  case this.kind
  of gtTileWall: this.textureName = "wall"
  else: this.textureName = "tail-" + rand() mod 5

  return this

proc draw*(this: TTile) =
  glBindTexture(GL_TEXTURE_2D, application.getTexture(this.textureName))
  glRectTexture(this.x * SCALE, this.y * SCALE, (this.x + 1) * SCALE, (this.y + 1) * SCALE)