import sdl

import MGameObjectType

proc initialization*(this: TGameObject) = discard
proc draw*(this: TGameObject) = discard
proc update*(this: TGameObject) = discard
proc onKeyDown*(this: TGameObject, key: sdl.TKey) = discard
proc onKeyUp*(this: TGameObject, key: sdl.TKey) = discard

proc draw*(this: TGameObjectTexture) = 
  glBindTexture(GL_TEXTURE_2D, application.getTexture(this.texture))
  glRectTexture(this.x, this.y, this.x + this.w, this.y + this.h)

proc getAnim(this: TGameObjectAnim, name: string): tuple[name: string, ticks: int, textures: seq[string]] =
  for anim in this.anims:
    if anim.name == name:
      return anim

proc playAnim*(this: TGameObjectAnim, name: string, ticks: int = 0) =
  this.anim = name
  this.ticks = if ticks > 0: ticks
  if ticks == 0:
    for anim in this.anims:
      if a.name == name:
        this.ticks = a.ticks

proc update*(this: TGameObjectAnim) =
  if getTicks() - this.ticks > 