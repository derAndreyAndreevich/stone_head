import sdl, MBase, dynobj

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils

type TGameField* = ref object of TObject
  lineColor*: string

proc draw*(this: TGameField) =
  this.lineColor.glColor()

  for i in 0...v["N"].asInt: 
    glLine(i * v["SCALE"].asInt, 0, i * v["SCALE"].asInt, v["SCREEN_HEIGHT"].asInt)
  for i in 0...v["M"].asInt: 
    glLine(0, i * v["SCALE"].asInt, v["SCREEN_WIDTH"].asInt, i * v["SCALE"].asInt)

