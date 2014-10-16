import sdl, strutils, opengl
import catty.core
import
  MGameFieldType,
  MGameObjectType,
  MTilesType, MTilesBody,
  MGameLogic.MGlobal,
  MGameLogic.MCast,
  MGameLogic.MMaps

proc initialization*(this: TGameField): TGameField =
  var
    x1, y1, x2, y2: int
    symbol: string

  this.tiles = @[]

  for i in countup(0, 10):
    for j in countup(0, 19):
      symbol = level1[i][j]

      case symbol
      of "w": this.tiles.add(TTile(kind: gtTileWall, x: j, y: i).initialization.toGameObject)
      of "t": this.tiles.add(TTile(kind: gtTile, x: j, y: i).initialization.toGameObject)
      else: this.tiles.add(TGameObject(kind: gtNil, x: j, y: i))

  return this

proc draw*(this: TGameField) =
  for t in this.tiles if t.kind == gtTile:
    t.asTile.draw()