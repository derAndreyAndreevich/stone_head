import sdl, MBase, dynobj, strutils

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils

import MTails

var currentMap = """
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # . . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
  # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
"""

var i, j = 0
var M = v["M"]
var N = v["N"]


type TGameField* = ref object of TObject
  lineColor*: string

proc draw*(this: TGameField) =
  # this.lineColor.glColor()

  # for i in 0...v["N"].asInt: 
  #   glLine(i * v["SCALE"].asInt, 0, i * v["SCALE"].asInt, v["SCREEN_HEIGHT"].asInt)
  # for i in 0...v["M"].asInt: 
  #   glLine(0, i * v["SCALE"].asInt, v["SCREEN_WIDTH"].asInt, i * v["SCALE"].asInt)

  # echo "lines: " & $currentMap.split("\n").len & " cols of line: " & $currentMap.split("\n").split.len
  # echo currentMap.split("\n").len #[0].split.len
  # echo v["N"], " : ", v["M"]


  while i < v["M"].asInt:
  for i in 0..currentMap.split("\n").len:
    for j in 0..currentMap.split("\n")[i].split.len:
      # echo "i: " & $i & " j: " & $j
      # var element = currentMap.split("\n")[j].split()[i]

      # if element == "#":
      #   TWallTile(x: i + 1, y: j + 1).draw()
      # elif element == ".":
      #   TMainTile(x: i + 1, y: j + 1).draw()

  # echo currentMap