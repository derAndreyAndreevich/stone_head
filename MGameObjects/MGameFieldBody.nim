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
      if symbol == "w":
        x1 = j * SCALE
        y1 = i * SCALE
        x2 = (j + 1) * SCALE
        y2 = (i + 1) * SCALE

        glBindTexture(GL_TEXTURE_2D, application.getTexture("wall"))
        glRectTexture(x1, y1, x2, y2)

      elif symbol == "s":
        glBindTexture(GL_TEXTURE_2D, application.getTexture("texture2"))
        glRectTexture(x1, y1, x2, y2)

  # echo "ha-ha-ha"


  # "#4DC0E2".glColor()

  # for i in countup(0, SCREEN_HEIGHT, SCALE):
  #   glLine(0, i, SCREEN_WIDTH, i)


  # for i in countup(0, SCREEN_WIDTH, SCALE):
  #   glLine(i, 0, i, SCREEN_HEIGHT)
