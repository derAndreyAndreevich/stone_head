import 
  os, json,
  opengl, sdl,
  catty.core, catty.gameobjects as MCattyGameObjects,
  MGameLogic.MMaps,
  MGameLogic.MGlobal,
  MGameObject,
  MTiles

proc `[]`*(this: TTileList, x, y: int): TTile =
  for tile in this:
    if tile.coords == (x, y) and tile.kind > 0:
      return tile

  return TTile(coords: (x, y))

proc `[]`*(this: TTileList, coords: TCattyCoords): TTile = this[coords.x, coords.y]


cattySetters(TGameField)
gameObjectSetters(TGameField)


proc respawnTile*(this: TGameField): TTile = 
  for tile in this.tiles:
    if tile.kind in {TYPE_RESPAWN}:
      return tile


proc loadMap*(this: TGameField) = 
  var mapFile = (os.getAppDir() / "data" / "maps.json").parseFile

  this.tiles = @[]

  for i in countup(0, M - 1):
    for j in countup(0, N - 1):
      var
        symbol = mapFile[this.map][i][j].str
        x = j * SCALE
        y = i * SCALE
        w = SCALE
        h = SCALE
        lx = j
        ly = i

      case symbol
      of "w": this.tiles.add(
        TTile(kind: TYPE_TILE_WALL, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "t": this.tiles.add(
        TTile(kind: TYPE_TILE, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "r": this.tiles.add(
        TTile(kind: TYPE_RESPAWN, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "e": this.tiles.add(
        TTile(kind: TYPE_EXIT, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "al": this.tiles.add(
        TTile(kind: TYPE_ALEFT, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "ar": this.tiles.add(
        TTile(kind: TYPE_ARIGHT, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "at": this.tiles.add(
        TTile(kind: TYPE_ATOP, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "ab": this.tiles.add(
        TTile(kind: TYPE_ABOTTOM, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "ah": this.tiles.add(
        TTile(kind: TYPE_AHORIZONTAL, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "av": this.tiles.add(
        TTile(kind: TYPE_AVERTICAL, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      of "aa": this.tiles.add(
        TTile(kind: TYPE_AALL, isDraw: true, coords: (x, y), size: (w, h)).initialization
      )
      else: this.tiles.add(
        TTile(coords: (x, y), size: (w, h)).initialization
      )

proc nextMap*(this: TGameField) =
  this.map += 1
  this.loadMap

proc initialization*(this: TGameField): TGameField {.discardable.} = 
  this
    .setKind(TYPE_GAMEFIELD)
    .setCoords((0, 0))
    .setSize((20 * SCALE, 11 * SCALE))
    .setTexture(application.getTexture("bg"))
    .show.loadMap

  return this

proc draw*(this: TGameField) =
  cast[TCattyGameObject](this).draw

  for tile in this.tiles:
    tile.draw

proc update*(this: TGameField) =
  cast[TCattyGameObject](this).update

  for tile in this.tiles:
    tile.update


proc onUserEvent*(this: TGameField, e: PUserEvent) = 
  case e.code
  of EVENT_TILE_ARROW_START_MOVE:
    echo "EVENT_TILE_ARROW_START_MOVE: ", e.data1.asEventStartMove.coords
    this.tiles[e.data1.asEventStartMove.coords].onUserEvent(e)
  of EVENT_TILE_ARROW_END_MOVE:
    this.tiles[e.data1.asEventEndMove.coords].onUserEvent(e)
  of EVENT_TILE_ARROW_ACTIVATE:
    this.tiles.each do (tile: var TTile): tile.isActive = false
    echo "EVENT_TILE_ARROW_ACTIVATE: ", e.data1.asEventActivate.coords
    this.tiles[e.data1.asEventActivate.coords].onUserEvent(e)
  of EVENT_TILE_ARROW_DEACTIVATE:
    this.tiles[e.data1.asEventDeactivate.coords].onUserEvent(e)
  else: discard