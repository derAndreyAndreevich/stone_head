import 
  opengl, sdl,
  catty.core, catty.gameobjects as MCattyGameObjects,
  MGameLogic.MMaps,
  MGameLogic.MCast,
  MGameLogic.MGlobal,
  MGameObject,
  MTiles


# catty.gameobjects,
# MGameLogic.MMaps,
# MGameLogic.MCast,
# MGameLogic.MGlobal,
# MTiles

proc initialization*(this: TGameField): TGameField {.discardable.} = 
  cast[TCattyGameObject](this).initialization()

  this.tiles = @[]

  for i in countup(0, 10):
    for j in countup(0, 19):
      let 
        symbol = level3[i][j]
        x = j * SCALE
        y = i * SCALE
        w = SCALE
        h = SCALE
        lx = j
        ly = i

      case symbol
      of "w": this.tiles.add(
        TTile(kind: TYPE_TILE_WALL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization.toCattyGameObject
      )
      of "t": this.tiles.add(
        TTile(kind: TYPE_TILE, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization.toCattyGameObject
      )
      else: this.tiles.add(
        TTile(x: x, y: y, lx: lx, ly: ly).initialization.toCattyGameObject
      )

  this.kind = TYPE_GAMEFIELD

  return this

proc draw*(this: TGameField) =
  cast[TCattyGameObject](this).draw()
  # for tile in this.tiles:
  #   tile.asTile.draw




  # this.draw()
  # glBindTexture(GL_TEXTURE_2D, this.texture)
  # glRectTexture(this.x, this.y, this.x + this.w, this.y + this.h)

proc update*(this: TGameField) = discard
proc onKeyDown*(this: TGameField, key: sdl.TKey) = discard
proc onKeyUp*(this: TGameField, key: sdl.TKey) = discard
