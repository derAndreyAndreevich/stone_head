import sdl, catty.core, catty.gameobjects, strutils

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

  TYPE_NAMES* = @[
    "TYPE_NIL", "TYPE_DISPATCHER", "TYPE_GAMEFIELD", "TYPE_PROTAGONIST", "TYPE_TILE", "TYPE_TILE_WALL", 
    "TYPE_ATOP", "TYPE_ABOTTOM", "TYPE_ALEFT", "TYPE_ARIGHT", "TYPE_AVERTICAL", "TYPE_AHORIZONTAL", "TYPE_AALL",
    "TYPE_SIGHTING", "TYPE_RESPAWN", "TYPE_EXIT"
  ]

  DIRECTION_NIL* = 0
  DIRECTION_TOP* = 1
  DIRECTION_BOTTOM* = 2
  DIRECTION_LEFT* = 3
  DIRECTION_RIGHT* = 4

  DIRECTION_NAMES* = @[
    "DIRECTION_NIL", "DIRECTION_TOP", "DIRECTION_BOTTOM", "DIRECTION_LEFT", "DIRECTION_RIGHT"
  ]

  ANIM_PROTAGONIST_NIL* = 0
  ANIM_PROTAGONIST_TOP* = 1
  ANIM_PROTAGONIST_BOTTOM* = 2
  ANIM_PROTAGONIST_LEFT* = 3
  ANIM_PROTAGONIST_RIGHT* = 4

  ANIM_NAMES* = @[
    "ANIM_PROTAGONIST_NIL", "ANIM_PROTAGONIST_TOP", "ANIM_PROTAGONIST_BOTTOM", "ANIM_PROTAGONIST_LEFT", 
    "ANIM_PROTAGONIST_RIGHT"
  ]

  EVENT_PROTAGONIST_END_MOVE* = 1
  EVENT_SIGHTING_END_MOVE* = 2
  EVENT_TILE_ARROW_END_MOVE* = 3

  EVENT_NAMES* = @[
    "EVENT_PROTAGONIST_END_MOVE", "EVENT_SIGHTING_END_MOVE", "EVENT_TILE_ARROW_END_MOVE"
  ]


type
  TTile* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: int
    isMoving*, isActive*: bool

  TGameField* = ref object of TCattyGameObject
    tiles*: seq[TTile]
    map*: int

  TProtagonist* = ref object of TCattyGameObject
    direction*, stepArrowType*: uint32
    offsetStop*: int
    isMoving*, isActive*, isStepArrow*: bool

  TSighting* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: int
    isActive*, isMoving*: bool

  TEndMoveEvent* = ref object
    x*, y*: int

proc `$`*(this: TTile): string = "TTile(direction: $1, offsetStop: $2, isMoving: $3, isActive: $4)" % [DIRECTION_NAMES[cast[int](this.direction)], $this.offsetStop, $this.isMoving, $this.isActive]

proc `$`*(this: TEndMoveEvent): string = "TEndMoveEvent(x: $1, y: $1)" % [$this.x, $this.y]