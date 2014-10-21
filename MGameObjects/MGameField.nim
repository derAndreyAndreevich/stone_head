import 
  os, json,
  opengl, sdl,
  catty.core, catty.gameobjects as MCattyGameObjects,
  MGameLogic.MMaps,
  MGameLogic.MCast,
  MGameLogic.MGlobal,
  MGameObject,
  MTiles

proc loadMap*(this: TGameField, id: int) = 
  let 
    settingsFile = os.getAppDir() / "settings.json"
    currentMap = cast[int](settingsFile.parseFile()["currentMap"].num)
    file = settingsFile.parseFile()


  this.tiles = @[]

  for i in countup(0, 10):
    for j in countup(0, 19):
      let 
        symbol = file["maps"][currentMap][i][j].str
        x = j * SCALE
        y = i * SCALE
        w = SCALE
        h = SCALE
        lx = j
        ly = i

      case symbol
      of "w": this.tiles.add(
        TTile(kind: TYPE_TILE_WALL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "t": this.tiles.add(
        TTile(kind: TYPE_TILE, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "r": this.tiles.add(
        TTile(kind: TYPE_RESPAWN, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "e": this.tiles.add(
        TTile(kind: TYPE_EXIT, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "al": this.tiles.add(
        TTile(kind: TYPE_ALEFT, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "ar": this.tiles.add(
        TTile(kind: TYPE_ARIGHT, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "at": this.tiles.add(
        TTile(kind: TYPE_ATOP, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "ab": this.tiles.add(
        TTile(kind: TYPE_ABOTTOM, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "ah": this.tiles.add(
        TTile(kind: TYPE_AHORIZONTAL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "av": this.tiles.add(
        TTile(kind: TYPE_AVERTICAL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      of "aa": this.tiles.add(
        TTile(kind: TYPE_AALL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
      )
      else: this.tiles.add(
        TTile(x: x, y: y, lx: lx, ly: ly).initialization
      )


  # for key, value in settingsFile.parseFile().pairs():
  #   case key
  #   of "maps":
  #     for index in countup(0, value.len() - 1):
  #       if index == id:
  #         for i in countup(0, 10):
  #           for j in countup(0, 19):
  #             let 
  #               symbol = value[][i][j].str
  #               x = j * SCALE
  #               y = i * SCALE
  #               w = SCALE
  #               h = SCALE
  #               lx = j
  #               ly = i

  #             case symbol
  #             of "w": this.tiles.add(
  #               TTile(kind: TYPE_TILE_WALL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "t": this.tiles.add(
  #               TTile(kind: TYPE_TILE, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "r": this.tiles.add(
  #               TTile(kind: TYPE_RESPAWN, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "e": this.tiles.add(
  #               TTile(kind: TYPE_EXIT, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "al": this.tiles.add(
  #               TTile(kind: TYPE_ALEFT, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "ar": this.tiles.add(
  #               TTile(kind: TYPE_ARIGHT, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "at": this.tiles.add(
  #               TTile(kind: TYPE_ATOP, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "ab": this.tiles.add(
  #               TTile(kind: TYPE_ABOTTOM, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "ah": this.tiles.add(
  #               TTile(kind: TYPE_AHORIZONTAL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "av": this.tiles.add(
  #               TTile(kind: TYPE_AVERTICAL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             of "aa": this.tiles.add(
  #               TTile(kind: TYPE_AALL, x: x, y: y, w: w, h: h, lx: lx, ly: ly, isDraw: true).initialization
  #             )
  #             else: this.tiles.add(
  #               TTile(x: x, y: y, lx: lx, ly: ly).initialization
  #             )

proc initialization*(this: TGameField): TGameField {.discardable.} = 
  cast[TCattyGameObject](this).initialization()

  this.loadMap(0)

  this.kind = TYPE_GAMEFIELD
  this.isDraw = true
  this.x = 0
  this.y = 0
  this.w = 20 * SCALE
  this.h = 11 * SCALE
  this.texture = application.getTexture("bg")
  
  this.loadMap(0)

  return this

proc draw*(this: TGameField) =
  cast[TCattyGameObject](this).draw

  for tile in this.tiles:
    tile.draw

proc update*(this: TGameField) =
  cast[TCattyGameObject](this).update

  for tile in this.tiles:
    tile.update

proc onKeyDown*(this: TGameField, key: sdl.TKey) = discard
proc onKeyUp*(this: TGameField, key: sdl.TKey) = discard
