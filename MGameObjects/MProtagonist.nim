import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal

const
  COLLISION_SET = {TYPE_NIL, TYPE_TILE_WALL}

proc show*(this: TProtagonist): TProtagonist {.discardable.} = 
  this.isDraw = true
  return this

proc hide*(this: TProtagonist): TProtagonist {.discardable.} =
  this.isDraw = false
  return this

proc activate*(this: TProtagonist): TProtagonist {.discardable.} =
  this.isActive = true
  return this

proc deactivate*(this: TProtagonist): TProtagonist {.discardable.} =
  this.isActive = false
  return this


proc isCollision*(this: TProtagonist, tile: TTile): bool = tile.kind in COLLISION_SET

proc initialization*(this: TProtagonist): TProtagonist {.discardable.} = 

  cast[TCattyGameObject](this).initialization


  this.kind = TYPE_PROTAGONIST

  this.isDraw = true
  this.isUpdate = true
  this.isActive = true

  this.coords = (SCALE * 14, SCALE * 2)
  this.size = (SCALE, SCALE)

  this.direction = DIRECTION_BOTTOM
  this.texture = application.getTexture("protagonist-" + this.direction + "-0")
  this.sleep = 80

  this.anims.add(@[
    (ANIM_PROTAGONIST_TOP, @[
      application.getTexture("protagonist-1-0"),
      application.getTexture("protagonist-1-1"),
      application.getTexture("protagonist-1-2"),
      application.getTexture("protagonist-1-3"),
      application.getTexture("protagonist-1-4"),
      application.getTexture("protagonist-1-5"),
    ], 0),
    (ANIM_PROTAGONIST_BOTTOM, @[
      application.getTexture("protagonist-2-0"),
      application.getTexture("protagonist-2-1"),
      application.getTexture("protagonist-2-2"),
      application.getTexture("protagonist-2-3"),
      application.getTexture("protagonist-2-4"),
      application.getTexture("protagonist-2-5"),
    ], 0),
    (ANIM_PROTAGONIST_LEFT, @[
      application.getTexture("protagonist-3-0"),
      application.getTexture("protagonist-3-1"),
      application.getTexture("protagonist-3-2"),
      application.getTexture("protagonist-3-3"),
      application.getTexture("protagonist-3-4"),
      application.getTexture("protagonist-3-5"),
    ], 0),
    (ANIM_PROTAGONIST_RIGHT, @[
      application.getTexture("protagonist-4-0"),
      application.getTexture("protagonist-4-1"),
      application.getTexture("protagonist-4-2"),
      application.getTexture("protagonist-4-3"),
      application.getTexture("protagonist-4-4"),
      application.getTexture("protagonist-4-5"),
    ], 0)
  ])

  return this

proc eventEndMove(this: TProtagonist) = 
  this.stopAnim
  this.coords = this.offsetStop
  this.isMoving = false
  this.isStepArrow = false

  var
    data = cast[ptr TEventEndMove](TEventEndMove(x: this.coords.x, y: this.coords.y))
    event = sdl.TUserEvent(
      kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_END_MOVE, data1: data
    )

  discard sdl.pushEvent(cast[sdl.PEvent](addr event))

proc update*(this: TProtagonist) =
  cast[TCattyGameObject](this).update

  if this.isMoving:
    case this.direction
    of DIRECTION_TOP, DIRECTION_LEFT:
      if this.coords + this.delta < this.offsetStop:
        this.eventEndMove
      else: this.coords += this.delta

    of DIRECTION_BOTTOM, DIRECTION_RIGHT:
      if this.coords + this.delta > this.offsetStop:
        this.eventEndMove
      else: this.coords += this.delta

    else: discard

proc draw*(this: TProtagonist) =
  cast[TCattyGameObject](this).draw

proc onMove(this: TProtagonist, event: TEventStartMove) = 

  this.offsetStop = event.offsetStop
  this.delta = event.delta
  this.isMoving = true
  this.direction = event.direction

  if not this.isStepArrow:
    case this.direction
    of DIRECTION_LEFT: this.playAnim ANIM_PROTAGONIST_LEFT
    of DIRECTION_RIGHT: this.playAnim ANIM_PROTAGONIST_RIGHT
    of DIRECTION_TOP: this.playAnim ANIM_PROTAGONIST_TOP
    of DIRECTION_BOTTOM: this.playAnim ANIM_PROTAGONIST_BOTTOM
    else: discard

proc onUserEvent*(this: TProtagonist, event: PUserEvent) =
  case event.code
  of EVENT_PROTAGONIST_START_MOVE: this.onMove(cast[TEventStartMove](event.data1))
  else: discard