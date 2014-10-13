import sdl, strutils, opengl

import catty.core

import
  MGameLogic.MGlobal,
  MGameLogic.MMaps,
  MGameFieldType

proc draw*(this: TGameField) =
  var 
    x1, y1, x2, y2: int
    symbol: string

  for i in countup(0, 10):
    for j in countup(0, 19):
      symbol = level1[i][j]

      x1 = j * SCALE
      y1 = i * SCALE
      x2 = (j + 1) * SCALE
      y2 = (i + 1) * SCALE

      if symbol == "w":
        glBindTexture(GL_TEXTURE_2D, application.getTexture("wall"))
        glRectTexture(x1, y1, x2, y2)