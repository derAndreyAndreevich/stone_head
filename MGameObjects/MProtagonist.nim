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

  keydown ctrl + up, w: 
    if event.kind == KEYDOWN and (RCTRL and evKeyboard(addr event).keysym.sym == K_UP):
      this.y -= 1
  keydown down, s: this.y += 1
  keydown left, a: this.x -= 1
  keydown right, d: this.x += 1

