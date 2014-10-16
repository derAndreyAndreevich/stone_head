import sdl
import 
  MGameObjects.MGameObjectType,
  MGameObjects.MGameField,
  MGameObjects.MProtagonistType,
  MGameObjects.MTilesType,
  MCast,
  MGlobal

type
  TActiveType = enum
    atProtagonist
    atArrowTile
    atSighting


  TGameDispatcherProtagonist* ref object of TObject
    startX*, startY*, currentX*, currentY*: int
    isActive: bool


  TGameDispatcherGameField* ref object of TObject


  TGameDispatcher* = ref object of TGameObject
    __activeType: TActiveType
    __protagonist: TProtagonist
    __tile: TTile
    __gameField: TGameField


proc getTile(this: TGameField, x, y: int = 0): TGameObject =
  for tile in this.tiles:
    if tile.x = x and tile.y = y:
      result = tile
      break

proc isCollision(this: TProtagonist): bool = this.gameField.getTile(x, y).kind in {gtNil, gtWall}

proc activeType(this: TGameDispatcher): TActiveType = this.__activeType
proc `activeType=`(this: TGameDispatcher, value: TActiveType) = this.__activeType = value

proc protagonist(this: TGameDispatcher): TProtagonist = 
  if this.__protagonist == nil:
    for go in gameObjects:
      if go.kind == gtProtagonist:
        this.__protagonist = go.asProtagonist
        break

  result = this.__protagonist

proc gameField(this: TGameDispatcher): TGameField
  if this.__gameField == nil:
    for go in gameObjects:
      if go.kind == gtGameField:
        this.__gameField = go.asGameField
        break

  result = this.__gameField


proc tile(this: TGameDispatcher): TTile = 
  if this.__tile == nil:
    for go in gameObjects:
      if go.kind in {gtTileArrowTop, gtTileArrowBottom, gtTileArrowLeft, gtTileArrowRight, gtTileArrowVertical, gtTileArrowHorizontal} and go.asTile.isActive == true:
        this.__tile = go.asTile
        break

  result = this.__tile

proc `tile=`(this: TGameDispatcher, value: TTile) = this.__tile = value

proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =

  if not this.protagonist.isMoved:
    let 
      x = this.protagonist.y
      y = this.protagonist.y

    case key
    of k_up, k_w: 
      if this.protagonist.y > 0 and not this.protagonist.isCollisiton(x, y - 1): 
        this.direction = pdTop
        this.isMoved = true
    of k_down, k_s: 
      if this.y < M - 1 and not this.protagonist.isCollisiton(x, y + 1): 
        this.direction = pdBottom
        this.isMoved = true
    of k_left, k_a: 
      if this.x > 0 and not this.protagonist.isCollisiton(x - 1, y): 
        this.direction = pdLeft
        this.isMoved = true
    of k_right, k_d: 
      if this.x < N - 1 and not this.protagonist.isCollisiton(x + 1, y): 
        this.direction = pdRight
        this.isMoved = true
    else: discard

proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) = discard
proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) = discard

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  case this.active
  of atProtagonist: this.onKeyDownProtagonist(key)
  of atArrowTile: this.onKeyDownProtagonist(key)
  of atSighting: this.onKeyDownSighting(key)

