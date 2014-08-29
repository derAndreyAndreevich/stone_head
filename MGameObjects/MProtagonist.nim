import sdl

import 
  catty.core.graphics,
  catty.core.utils

var event: TEvent
import
  MGameLogic.MGlobal

part Protagonist:
  var
    x*, y*: int
    fillColor*: string
  draw: 
    this.fillColor.glColor()

    glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)

  keydown up, w: this.y -= 1
  keydown down, s: this.y += 1
  keydown left, a: this.x -= 1
  keydown right, d: this.x += 1
  keydown lctrl + space: this.x += 3