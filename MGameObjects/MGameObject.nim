import sdl, catty.core, catty.gameobjects

const
  TYPE_NIL* = 0
  TYPE_DISPATCHER* = 1
  TYPE_GAMEFIELD* = 2
  TYPE_PROTAGONIST* = 3
  TYPE_TILE* = 4
  TYPE_TILE_WALL* = 5
  TYPE_ATOP* = 6
  TYPE_ABOTTOM* = 7
  TYPE_ALEFT* = 8
  TYPE_ARIGHT* = 9
  TYPE_AVERTICAL* = 10
  TYPE_AHORIZONTAL* = 11

  DIRECTION_NIL* = 0
  DIRECTION_TOP* = 1
  DIRECTION_BOTTOM* = 2
  DIRECTION_LEFT* = 3
  DIRECTION_RIGTH* = 4

type
  TTile* = ref object of TCattyGameObject

  TGameField* = ref object of TCattyGameObject
    tiles*: seq[TCattyGameObject]

  TProtagonist* = ref object of TCattyGameObject
    direction: uint32
    isMoved: bool


# proc initialization*(this: TGameObject): TGameObject {.discardable.} = return this

# proc draw*(this: TGameObject) = 
# proc update*(this: TGameObject) = this.parent.update
# proc onKeyDown*(this: TGameObject, key: sdl.TKey) = this.parent.onKeyDown(key)
# proc onKeyUp*(this: TGameObject, key: sdl.TKey) = this.parent.onKeyUp(key)

