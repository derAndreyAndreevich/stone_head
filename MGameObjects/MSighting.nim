import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal



cattySetters(TSighting)
gameObjectSetters(TSighting)


proc endMove(this: TSighting) = 

  this.stopAnim
  this.stop.setCoords(this.offsetStop).coords.fireSightingEndMove

proc initialization*(this: TSighting): TSighting {.discardable.} = 

  cast[TCattyGameObject](this).initialization

  this
    .setKind(TYPE_SIGHTING)
    .setCoords((0, 0))
    .setSize((SCALE, SCALE))
    .setDirection(DIRECTION_BOTTOM)
    .setTexture(application.getTexture("sighting"))
    .setSleep(80)

  return this

proc update*(this: TSighting) =
  if this.isMoving:
    this.coords += this.delta

    case this.direction
    of DIRECTION_TOP, DIRECTION_LEFT:
      if this.coords + this.delta > this.offsetStop:
        this.endMove
    of DIRECTION_BOTTOM, DIRECTION_RIGHT:
      if this.coords + this.delta < this.offsetStop:
        this.endMove
    else: discard

proc draw*(this: TSighting) =
  cast[TCattyGameObject](this).draw

proc onUserEvent*(this: TSighting, e: PUserEvent) =
  case e.code
  of EVENT_SIGHTING_ACTIVATE: 
    var event = e.data1.asEventActivate

    this
      .setCoords(event.coords)
      .activate.show

  of EVENT_SIGHTING_DEACTIVATE:
    var event = e.data1.asEventDeactivate

    this.deactivate.hide

  of EVENT_SIGHTING_START_MOVE:
    var event = e.data1.asEventStartMove

    this
      .setOffsetStop(event.offsetStop)
      .setDelta(event.delta)
      .setDirection(event.direction)
      .setMoving(true)

  else: discard