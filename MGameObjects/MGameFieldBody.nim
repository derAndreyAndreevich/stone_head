import sdl, strutils, opengl

import catty.core

import
  MGameLogic.MGlobal,
  MGameLogic.MMaps,
  MGameFieldType

proc draw*(this: TGameField) =
  for i in countup(0, 10):
    for j in countup(0, 19):
      if level1[i][j] == "w":
        "#F5C2C2".glColor()
        glRect(j * SCALE, i * SCALE + 1, (j + 1) * SCALE - 1, (i + 1) * SCALE)

  this.fillColor.glColor()

  for i in countup(0, SCREEN_HEIGHT, SCALE):
    glLine(0, i, SCREEN_WIDTH, i)

  for i in countup(0, SCREEN_WIDTH, SCALE):
    glLine(i, 0, i, SCREEN_HEIGHT)