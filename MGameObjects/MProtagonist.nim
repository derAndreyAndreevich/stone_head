import sdl

import 
  catty.core.graphics,
  catty.core.utils


import
  MGameLogic.MGlobal

part Protagonist:
  var
    x*, y*: int
    fillColor*: string
    isCollision: bool

  draw: 
    this.fillColor.glColor()
    glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)

  keydown up, w: 
    if this.y > 0: dec this.y 

  keydown down, s: 
    if this.y < M - 1: inc this.y

  keydown left, a:
    if this.x > 0: dec this.x

  keydown right, d: 
    if this.x < N - 1: inc this.x

  