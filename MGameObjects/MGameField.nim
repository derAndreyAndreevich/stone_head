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


proc respawnTile*(this: TGameField): TTile = 
  for tile in this.tiles:
    if tile.kind in {TYPE_RESPAWN}:
      return tile


proc loadMap*(this: TGameField) = 
  var
    settingsFile = os.getAppDir() / "settings.json"
    file = settingsFile.parseFile()
    currentMap = cast[int](file["currentMap"].num)


  this.tiles = @[]

  for i in countup(0, M - 1):
    for j in countup(0, N - 1):
      var
        symbol = file["maps"][currentMap][i][j].str
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

proc initialization*(this: TGameField): TGameField {.discardable.} = 
  this.kind = TYPE_GAMEFIELD
  this.isDraw = true
  this.coords = (0, 0)
  this.size = (20 * SCALE, 11 * SCALE)
  this.texture = application.getTexture("bg")

  this.loadMap

  return this

proc draw*(this: TGameField) =
  cast[TCattyGameObject](this).draw

  for tile in this.tiles:
    tile.draw

proc update*(this: TGameField) =
  cast[TCattyGameObject](this).update

  for tile in this.tiles:
    tile.update

proc onMoveArrow(this: TGameField, event: TEventStartMove) = 
  var movingTile = this.tiles[event.coords]

  movingTile.offsetStop = event.offsetStop
  movingTile.delta = event.delta
  movingTile.isMoving = true
  movingTile.direction = computeDirection(event.coords, event.offsetStop)


proc onUserEvent*(this: TGameField, event: PUserEvent) = 
  case event.code
  of EVENT_TILE_ARROW_START_MOVE: this.onMoveArrow(cast[TEventStartMove](event.data1))
  else: discard
