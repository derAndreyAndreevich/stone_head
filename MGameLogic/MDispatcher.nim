import sdl
import catty.core, catty.gameobjects as MCattyGameObjects
import 
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameObjects.MTiles,
  MCast,
  MGlobal as global

const
  ACTIVE_PROTAGONIST = 1
  ACTIVE_TILE = 2
  ACTIVE_SIGHTING = 3

type
  TGameDispatcher* = ref object of TCattyGameObject
    active*: uint32

proc getTile(this: TGameField, x, y: int = 0): TCattyGameObject =
  for tile in this.tiles:
    if tile.x == x and tile.y == y:
      return tile

# proc isCollision(this: TProtagonist): bool = this.gameField.getTile(x, y).kind in {gtNil, gtWall}

# proc activeType(this: TGameDispatcher): TActiveType = this.__activeType
# proc `activeType=`(this: TGameDispatcher, value: TActiveType) = this.__activeType = value

proc protagonist(this: TGameDispatcher): TProtagonist = 
  for gameObject in global.gameObjects:
    case gameObject.kind
    of TYPE_PROTAGONIST: return gameObject.asProtagonist
    else: discard


proc gameField(this: TGameDispatcher): TGameField =
  for go in global.gameObjects:
    case go.kind
    of TYPE_GAMEFIELD: return go.asGameField
    else: discard


proc tile(this: TGameDispatcher): TTile = 
    for go in global.gameObjects:
      case go.kind
      of TYPE_ATOP, TYPE_ABOTTOM, TYPE_ALEFT, TYPE_ARIGHT, TYPE_AVERTICAL, TYPE_AHORIZONTAL:
        if go.asTile.isActive: return go.asTile
      else: discard

proc sighting(this: TGameDispatcher): TSighting =
  for go in global.gameObjects:
    case go.kind
    of TYPE_SIGHTING: return go.asSighting
    else: discard

proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var self = this.protagonist

  case key
  of K_UP, K_W:
    self.playAnim("top")
    self.direction = DIRECTION_TOP
  of K_DOWN, K_S:
    self.playAnim("bottom")
    self.direction = DIRECTION_BOTTOM
  of K_LEFT, K_A:
    self.playAnim("left")
    self.direction = DIRECTION_LEFT
  of K_RIGHT, K_D:
    self.playAnim("rigth")
    self.direction = DIRECTION_RIGHT
  of K_SPACE:
    self.stopAnim()
  else: discard

  self.texture = application.getTexture("protagonist-" + self.direction + "-0")

proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) = discard

proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) =
  var self = this.sighting

  case key
  of K_UP, K_W:
    self.playAnim("top")
    self.direction = DIRECTION_TOP
  of K_DOWN, K_S:
    self.playAnim("bottom")
    self.direction = DIRECTION_BOTTOM
  of K_LEFT, K_A:
    self.playAnim("left")
    self.direction = DIRECTION_LEFT
  of K_RIGHT, K_D:
    self.playAnim("rigth")
    self.direction = DIRECTION_RIGHT
  of K_SPACE:
    self.stopAnim()
  else: discard

proc initialization*(this: TGameDispatcher): TGameDispatcher {.discardable.} = 
  this.active = ACTIVE_PROTAGONIST
  return this

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  echo "TGameDispatcher: onKeyDown"
  # case this.active
  # of ACTIVE_PROTAGONIST: echo "TGameDispatcher: ACTIVE_PROTAGONIST"
  # of ACTIVE_TILE: echo "TGameDispatcher: ACTIVE_TILE"
  # of ACTIVE_SIGHTING: echo "TGameDispatcher: ACTIVE_SIGHTING"
  # else: discard

proc toCattyGameObject*(this: TGameDispatcher): TCattyGameObject = cast[TCattyGameObject](this)
proc asGameDispatcher*(this: TCattyGameObject): TGameDispatcher = cast[TGameDispatcher](this)
