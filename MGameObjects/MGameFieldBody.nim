import sdl, strutils, opengl

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils,
  catty.core.colors

import
  MGameLogic.MGlobal,
  MGameFieldType

var
  map = @[
    @[" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "w", "w", "w", " ", " "],
    @[" ", " ", " ", " ", " ", " ", " ", " ", " ", "w", "w", "w", "w", "w", "w", "w", " ", "w", " ", " "],
    @[" ", " ", " ", " ", " ", " ", " ", "w", "w", "w", " ", " ", " ", " ", " ", " ", " ", "w", " ", " "],
    @[" ", " ", " ", " ", " ", " ", "w", "w", " ", " ", " ", " ", " ", " ", " ", " ", " ", "w", " ", " "],
    @[" ", " ", " ", " ", " ", " ", "w", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", "w", " ", " "],
    @[" ", " ", " ", " ", " ", " ", "w", " ", " ", " ", " ", " ", " ", " ", " ", "w", "w", "w", " ", " "],
    @[" ", " ", " ", " ", " ", " ", "w", " ", " ", " ", " ", " ", " ", " ", "w", "w", " ", " ", " ", " "],
    @[" ", " ", " ", " ", " ", " ", "w", " ", " ", " ", " ", " ", " ", "w", "w", " ", " ", " ", " ", " "],
    @[" ", " ", " ", " ", " ", " ", "w", "w", "w", "w", " ", " ", "w", "w", " ", " ", " ", " ", " ", " "],
    @[" ", " ", " ", " ", " ", " ", " ", " ", " ", "w", "w", "w", "w", " ", " ", " ", " ", " ", " ", " "],
    @[" ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
  ]

part GameField:
  draw:
    for i in 0 .. 11:
      for j in 0 .. 20:
        if map[i][j] == "w":
          "#F5C2C2".glColor()
          glRect(j * SCALE, i * SCALE + 1, (j + 1) * SCALE - 1, (i + 1) * SCALE)

    this.fillColor.glColor()

    for i in countup(0, SCREEN_HEIGHT, SCALE):
      glLine(0, i, SCREEN_WIDTH, i)

    for i in countup(0, SCREEN_WIDTH, SCALE):
      glLine(i, 0, i, SCREEN_HEIGHT)
