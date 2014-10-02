import sdl, sequtils

import 
  catty.core.graphics,
  catty.core.utils

import
  MGameLogic.MGlobal,
  MProtagonistType

# proc update(this: TProtagonist)

proc draw(this: TProtagonist) =
  this.fillColor.glColor()
  glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)



proc onKeyDown(this: TProtagonist, keycode: int) =
  case keycode
  of k_up, k_w:
    if this.y > 0: dec this.y
  of k_down, k_s:
    if this.y < M - 1: inc this.y
  of k_left, k_a:
    if this.y < M - 1: inc this.y
  of k_right, k_d:
    if this.y < M - 1: inc this.y
  else: discard

# proc onKeyUp(this: TProtagonist, keycode: int)
# proc onKeyPress(this: TProtagonist, keycode: int)

# part Protagonist:
#   draw: 
#     this.fillColor.glColor()
#     glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)

#   keydown up, w:
#     if this.y > 0: dec this.y

#   keydown down, s: 
#     if this.y < M - 1: inc this.y

#   keydown left, a:
#     if this.x > 0: dec this.x

#   keydown right, d: 
#     if this.x < N - 1: inc this.x
