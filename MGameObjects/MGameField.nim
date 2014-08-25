import sdl, dynobj, strutils

import 
  catty.core.application,
  catty.core.graphics,
  catty.core.utils

import
  MGlobal,
  MGameObjects.MBase,
  MGameObjects.MTiles

type TGameField* = ref object of TObject
  lineColor*: string
  currentMap: string
  mapArray: seq[tuple[x, y: int, tileType: ETile]]

proc init*(this: TGameField) =

  this.currentMap = """
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
    # . . . P P P P P L P P P P P P P P P P . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . # . # . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . # . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # . . . . . . . . . . . . . . . . . . . . . . . . . . . . #
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
  """

  for i in 0..M:
    for j in 0..N:
      case this.currentMap.split("\n")[i].split()[j]
      of "#":
        currentMap.add((x: j, y: i, tileType: tlWall))
      of ".":
        currentMap.add((x: j, y: i, tileType: tlMain))
      of "L":
        currentMap.add((x: j, y: i, tileType: tlLeftArrow))
      else:
        currentMap.add((x: 0, y: 0, tileType: tlNil))

proc draw*(this: TGameField) =
  for tile in currentMap:
    case tile.tileType
    of tlWall:
      TWallTile(x: tile.x, y: tile.y).draw()
    of tlMain:
      TMainTile(x: tile.x, y: tile.y).draw()
    of tlLeftArrow:
      TLeftArrow(x: tile.x, y: tile.y).draw()
    else:
      discard
