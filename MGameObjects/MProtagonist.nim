import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal

const
  COLLISION_SET = {TYPE_NIL, TYPE_TILE_WALL}

cattySetters(TProtagonist)
gameObjectSetters(TProtagonist)


proc setStepArrow(this: TProtagonist, value: bool): TProtagonist {.discardable.} =
  this.isStepArrow = value
  return this

proc stepArrow(this: TProtagonist): TProtagonist {.discardable.} =
  this.isStepArrow = true
  return this

proc unstepArrow(this: TProtagonist): TProtagonist {.discardable.} =
  this.isStepArrow = false
  return this

proc isCollision*(this: TProtagonist, tile: TTile): bool = tile.kind in COLLISION_SET

proc initialization*(this: TProtagonist): TProtagonist {.discardable.} = 

  cast[TCattyGameObject](this).initialization


  this
    .setKind(TYPE_PROTAGONIST)
    .setCoords((SCALE * 14, SCALE * 2))
    .setSize((SCALE, SCALE))
    .setSleep(80)
    .setDirection(DIRECTION_BOTTOM)
    .setTexture(application.getTexture("protagonist-" + this.direction + "-0"))
    .show.upgrade.activate


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

proc endMove(this: TProtagonist) =
  this.stopAnim

  this
    .setCoords(this.offsetStop)
    .stepArrow.stop
    .coords.fireProtagonistEndMove

proc update*(this: TProtagonist) =
  cast[TCattyGameObject](this).update

  if this.isMoving:
    case this.direction
    of DIRECTION_TOP, DIRECTION_LEFT:
      if this.coords + this.delta < this.offsetStop:
        this.endMove
      else: this.coords += this.delta

    of DIRECTION_BOTTOM, DIRECTION_RIGHT:
      if this.coords + this.delta > this.offsetStop:
        this.endMove
      else: this.coords += this.delta

    else: discard

proc draw*(this: TProtagonist) =
  cast[TCattyGameObject](this).draw


proc onUserEvent*(this: TProtagonist, e: PUserEvent) =
  case e.code
  of EVENT_PROTAGONIST_ACTIVATE: this.activate
  of EVENT_PROTAGONIST_DEACTIVATE: this.deactivate
  of EVENT_PROTAGONIST_START_MOVE: 
    var event = e.data1.asEventStartMove

    this
      .setOffsetStop(event.offsetStop)
      .setDelta(event.delta)
      .setDirection(event.direction)
      .move

    if not this.isStepArrow:
      case this.direction
      of DIRECTION_LEFT: this.playAnim ANIM_PROTAGONIST_LEFT
      of DIRECTION_RIGHT: this.playAnim ANIM_PROTAGONIST_RIGHT
      of DIRECTION_TOP: this.playAnim ANIM_PROTAGONIST_TOP
      of DIRECTION_BOTTOM: this.playAnim ANIM_PROTAGONIST_BOTTOM
      else: discard

  else: discard