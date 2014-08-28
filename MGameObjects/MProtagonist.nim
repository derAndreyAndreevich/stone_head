import sdl

import 
  catty.core.graphics
  catty.core.utils

import
  MGameLogic.MGlobal

part Protagonist:
  var
    x*, y*: int
    fillColor*: string
  draw: 
    this.fillColor.glColor()

    glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)
  keydown up: this.y -= 1
  keydown down: this.y += 1
  keydown left: this.x -= 1
  keydown right: this.x += 1
    
