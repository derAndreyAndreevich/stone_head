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

  EVENT_PROTAGONIST_START_MOVE* = 1
  EVENT_PROTAGONIST_END_MOVE* = 2
  EVENT_PROTAGONIST_ACTIVATE* = 3
  EVENT_PROTAGONIST_DEACTIVATE* = 4

  EVENT_SIGHTING_START_MOVE* = 5
  EVENT_SIGHTING_END_MOVE* = 6
  EVENT_SIGHTING_ACTIVATE* = 7
  EVENT_SIGHTING_DEACTIVATE* = 8

  EVENT_TILE_ARROW_START_MOVE* = 9
  EVENT_TILE_ARROW_END_MOVE* = 10
  EVENT_TILE_ARROW_ACTIVATE* = 11
  EVENT_TILE_ARROW_DEACTIVATE* = 12

  EVENT_NAMES* = @[
    "EVENT_PROTAGONIST_END_MOVE", "EVENT_SIGHTING_END_MOVE", "EVENT_TILE_ARROW_END_MOVE",
    "EVENT_PROTAGONIST_START_MOVE", "EVENT_SIGHTING_START_MOVE", "EVENT_TILE_ARROW_START_MOVE"
  ]


type
  TTile* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: TCattyCoords
    isMoving*, isActive*: bool

  TTileList* = seq[TTile]

  TGameField* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: TCattyCoords
    isMoving*, isActive*: bool
    tiles*: TTileList
    movingTile*: TTile
    map*: int

  TProtagonist* = ref object of TCattyGameObject
    direction*, stepArrowType*: uint32
    offsetStop*: TCattyCoords
    isMoving*, isActive*, isStepArrow*: bool

  TSighting* = ref object of TCattyGameObject
    direction*: uint32
    offsetStop*: TCattyCoords
    isActive*, isMoving*: bool

  TEventStartMove* = ref object
    direction*: uint32
    coords*, offsetStop*, delta*: TCattyCoords

  TEventEndMove* = ref object
    coords*: TCattyCoords

  TEventActivate* = ref object
    coords*: TCattyCoords

  TEventDeactivate* = ref object
    coords*: TCattyCoords

  PEventStartMove* = ptr TEventStartMove
  PEventEndMove* = ptr TEventEndMove
  PEventActivate* = ptr TEventActivate
  PEventDeactivate* = ptr TEventDeactivate

proc toGameEvent(this: TEventStartMove): PEventStartMove = cast[PEventStartMove](this)
proc toGameEvent(this: TEventEndMove): PEventEndMove = cast[PEventEndMove](this)
proc toGameEvent(this: TEventActivate): PEventActivate = cast[PEventActivate](this)
proc toGameEvent(this: TEventDeactivate): PEventDeactivate = cast[PEventDeactivate](this)

proc asGameEventStartMove(this: PEventStartMove): TEventStartMove = cast[TEventStartMove](this)
proc asGameEventEndMove(this: PEventEndMove): TEventEndMove = cast[TEventEndMove](this)
proc asGameEventActivate(this: PEventActivate): TEventActivate = cast[TEventActivate](this)
proc asGameEventDeactivate(this: PEventDeactivate): TEventDeactivate = cast[TEventDeactivate](this)



proc fireProtagonistActivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_PROTAGONIST_ACTIVATE, data1: TEventActivate(coords: coords).toGameEvent)
  discard pushEvent(cast[PEvent](addr event))

proc fireSightingActivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_SIGHTING_ACTIVATE, data1: TEventActivate(coords: coords).toGameEvent)
  discard pushEvent(cast[PEvent](addr event))

proc fireTileArrowActivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_TILE_ARROW_ACTIVATE, data1: TEventActivate(coords: coords).toGameEvent)
  discard pushEvent(cast[PEvent](addr event))

proc fireProtagonistDeactivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_PROTAGONIST_DEACTIVATE, data1: cast[PEventDeactivate](TEventDeactivate(coords: coords)))
  discard pushEvent(cast[PEvent](addr event))

proc fireSightingDeactivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_SIGHTING_DEACTIVATE, data1: cast[PEventDeactivate](TEventDeactivate(coords: coords)))
  discard pushEvent(cast[PEvent](addr event))

proc fireTileArrowDeactivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_TILE_ARROW_DEACTIVATE, data1: cast[PEventDeactivate](TEventDeactivate(coords: coords)))
  discard pushEvent(cast[PEvent](addr event))

proc fireProtagonistStartMove*(direction: uint32, coords, offsetStop, delta: TCattyCoords) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[PEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))
  discard pushEvent(cast[PEvent](addr event))

proc fireSightingStartMove*(direction: uint32, coords, offsetStop, delta: TCattyCoords) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_SIGHTING_START_MOVE, data1: cast[PEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))
  discard pushEvent(cast[PEvent](addr event))

proc fireTileArrowStartMove*(direction: uint32, coords, offsetStop, delta: TCattyCoords) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_TILE_ARROW_START_MOVE, data1: cast[PEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))
  discard pushEvent(cast[PEvent](addr event))

proc fireProtagonistEndMove*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_PROTAGONIST_END_MOVE, data1: cast[PEventEndMove](TEventEndMove(coords: coords)))
  discard pushEvent(cast[PEvent](addr event))

proc fireSightingEndMove*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_SIGHTING_END_MOVE, data1: cast[PEventEndMove](TEventEndMove(coords: coords)))
  discard pushEvent(cast[PEvent](addr event))

proc fireTileArrowEndMove*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: EVENT_TILE_ARROW_END_MOVE, data1: cast[PEventEndMove](TEventEndMove(coords: coords)))
  discard pushEvent(cast[PEvent](addr event))


template gameObjectSetters*(t: typeDesc): stmt {.immediate.} =
  proc setDirection(this: t, value: uint32): t {.discardable.} = 
    this.direction = value
    return this

  proc setOffsetStop(this: t, value: TCattyCoords): t {.discardable.} = 
    this.offsetStop = value
    return this

  proc setActive(this: t, value: bool): t {.discardable.} = 
    this.isActive = value
    return this

  proc setMoving(this: t, value: bool): t {.discardable.} = 
    this.isMoving = value
    return this

  proc activate*(this: t): t {.discardable.} =
    this.isActive = true
    return this

  proc deactivate*(this: t): t {.discardable.} =
    this.isActive = false
    return this

  proc move*(this: t): t {.discardable.} =
    this.isMoving = true
    return this

  proc stop*(this: t): t {.discardable.} =
    this.isMoving = false
    return this

proc computeDirection*(start, stop: TCattyCoords): uint32 =
  if start.x > stop.x:
    return DIRECTION_LEFT
  elif start.x < stop.x:
    return DIRECTION_RIGHT
  elif start.y > stop.y:
    return DIRECTION_TOP
  elif start.y < stop.y:
    return DIRECTION_BOTTOM

proc `$`*(this: TTile): string = "TTile(direction: $1, offsetStop: $2, isMoving: $3, isActive: $4)" % [DIRECTION_NAMES[cast[int](this.direction)], $this.offsetStop, $this.isMoving, $this.isActive]

proc `$`*(this: TEventEndMove): string = "TEventEndMove(coords: $1)" % [$this.coords]

proc `$`*(this: TEventStartMove): string = "TEventStartMove(coords: $1, offsetStop: $2, delta: $3, isStepArrow: $4)" % [$this.coords, $this.offsetStop, $this.delta]