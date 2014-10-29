import sdl, catty.core, catty.gameobjects, strutils

type
  TTypeEnum* = enum
    tpNil, tpDispatcher, tpGameField, tpProtagonist, tpTile, tpTileWall, tpATop, tpABottom
    tpALeft, tpARight, tpAVertical, tpAHorizontal, tpAAll, tpSighting, tpRespawn, tpExit

  TDirectionEnum* = enum
    dirNil, dirTop, dirBottom, dirLeft, dirRight


  TAnimsEnum* = enum
    animNil, animProtagonistTop, animProtagonistBottom, animProtagonistLeft, animProtagonistRight

  TEventEnum* = enum
    eventNil, eventProtagonistActivate, eventProtagonistDeactivate, eventProtagonistStartMove, eventProtagonistEndMove
    eventTileArrowActivate, eventTileArrowDeactivate, eventTileArrowStartMove, eventTileArrowEndMove
    eventSightingActivate, eventSightingDeactivate, eventSightingStartMove, eventSightingEndMove

  TTile* = ref object of TCattyGameObject
    direction*: int
    offsetStop*: TCattyCoords
    isMoving*, isActive*: bool

  TTileList* = seq[TTile]

  TGameField* = ref object of TCattyGameObject
    direction*: int
    offsetStop*: TCattyCoords
    isMoving*, isActive*: bool
    tiles*: TTileList
    movingTile*: TTile
    map*: int

  TProtagonist* = ref object of TCattyGameObject
    direction*, stepArrowType*: int
    offsetStop*: TCattyCoords
    isMoving*, isActive*, isStepArrow*: bool

  TSighting* = ref object of TCattyGameObject
    direction*: int
    offsetStop*: TCattyCoords
    isActive*, isMoving*: bool

  TEventStartMove* = ref object
    direction*: int
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

proc toPEvent(this: var TUserEvent): PEvent = cast[PEvent](addr this)

proc toGameEvent*(this: TEventStartMove): pointer = cast[pointer](this)
proc toGameEvent*(this: TEventEndMove): pointer = cast[pointer](this)
proc toGameEvent*(this: TEventActivate): pointer = cast[pointer](this)
proc toGameEvent*(this: TEventDeactivate): pointer = cast[pointer](this)

proc asEventStartMove*(this: pointer): TEventStartMove = cast[TEventStartMove](this)
proc asEventEndMove*(this: pointer): TEventEndMove = cast[TEventEndMove](this)
proc asEventActivate*(this: pointer): TEventActivate = cast[TEventActivate](this)
proc asEventDeactivate*(this: pointer): TEventDeactivate = cast[TEventDeactivate](this)

proc fireProtagonistActivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventProtagonistActivate.ord, data1: TEventActivate(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireSightingActivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventSightingActivate.ord, data1: TEventActivate(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireTileArrowActivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventTileArrowActivate.ord, data1: TEventActivate(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireProtagonistDeactivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventProtagonistDeactivate.ord, data1: TEventDeactivate(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireSightingDeactivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventSightingDeactivate.ord, data1: TEventDeactivate(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireTileArrowDeactivate*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventTileArrowDeactivate.ord, data1: TEventDeactivate(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireProtagonistStartMove*(direction: int, coords, offsetStop, delta: TCattyCoords) = 
  var event = TUserEvent(kind: USEREVENT, code: eventProtagonistStartMove.ord, data1: TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  ).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireSightingStartMove*(direction: int, coords, offsetStop, delta: TCattyCoords) = 
  var event = TUserEvent(kind: USEREVENT, code: eventSightingStartMove.ord, data1: TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  ).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireTileArrowStartMove*(direction: int, coords, offsetStop, delta: TCattyCoords) = 
  var event = TUserEvent(kind: USEREVENT, code: eventTileArrowStartMove.ord, data1: TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  ).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireProtagonistEndMove*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventProtagonistEndMove.ord, data1: TEventEndMove(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireSightingEndMove*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventSightingEndMove.ord, data1: TEventEndMove(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent

proc fireTileArrowEndMove*(coords: TCattyCoords = (0, 0)) = 
  var event = TUserEvent(kind: USEREVENT, code: eventTileArrowEndMove.ord, data1: TEventEndMove(coords: coords).toGameEvent)
  discard event.toPEvent.pushEvent


template gameObjectSetters*(t: typeDesc): stmt {.immediate.} =
  proc setDirection(this: t, value: int): t {.discardable.} = 
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
