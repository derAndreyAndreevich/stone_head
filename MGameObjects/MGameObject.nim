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
  TYPE_SIGHTING* = 12

  DIRECTION_NIL* = 0
  DIRECTION_TOP* = 1
  DIRECTION_BOTTOM* = 2
  DIRECTION_LEFT* = 3
  DIRECTION_RIGHT* = 4

type
  TTile* = ref object of TCattyGameObject
    isActive*: bool

  TGameField* = ref object of TCattyGameObject
    tiles*: seq[TCattyGameObject]

  TProtagonist* = ref object of TCattyGameObject
    direction*: uint32
    isMoved*: bool
    isActive*: bool

  TSighting* = ref object of TCattyGameObject
    direction*: uint32
    isActive*: bool