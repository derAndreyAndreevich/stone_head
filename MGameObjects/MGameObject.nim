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
  TYPE_AALL* = 12
  TYPE_SIGHTING* = 13
  TYPE_RESPAWN* = 14
  TYPE_EXIT* = 15

  DIRECTION_NIL* = 0
  DIRECTION_TOP* = 1
  DIRECTION_BOTTOM* = 2
  DIRECTION_LEFT* = 3
  DIRECTION_RIGHT* = 4

  ANIM_PROTAGONIST_TOP* = 1
  ANIM_PROTAGONIST_BOTTOM* = 2
  ANIM_PROTAGONIST_LEFT* = 3
  ANIM_PROTAGONIST_RIGHT* = 4

type
  TTile* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: int
    isMoving*, isActive*: bool

  TGameField* = ref object of TCattyGameObject
    tiles*: seq[TTile]

  TProtagonist* = ref object of TCattyGameObject
    direction*, stepArrowType*: uint32
    offsetStop*: int
    isMoving*, isActive*, isStepArrow*: bool

  TSighting* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: int
    isActive*, isMoving*: bool
