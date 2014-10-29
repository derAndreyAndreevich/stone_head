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
    .setKind(tpSighting.ord)
    .setCoords((0, 0))
    .setSize((SCALE, SCALE))
    .setDirection(dirBottom.ord)
    .setTexture(application.getTexture("sighting"))
    .setSleep(80)

  return this

proc update*(this: TSighting) =
  if this.isMoving:
    this.coords += this.delta

    case this.direction
    of dirTop.ord, dirLeft.ord:
      if this.coords + this.delta > this.offsetStop:
        this.endMove
    of dirBottom.ord, dirRight.ord:
      if this.coords + this.delta < this.offsetStop:
        this.endMove
    else: discard

proc draw*(this: TSighting) =
  cast[TCattyGameObject](this).draw

proc onUserEvent*(this: TSighting, e: PUserEvent) =
  case e.code
  of eventSightingActivate.ord: 
    var event = e.data1.asEventActivate

    this
      .setCoords(event.coords)
      .activate.show

  of eventSightingDeactivate.ord:
    var event = e.data1.asEventDeactivate

    this.deactivate.hide

  of eventSightingStartMove.ord:
    var event = e.data1.asEventStartMove

    this
      .setOffsetStop(event.offsetStop)
      .setDelta(event.delta)
      .setDirection(event.direction)
      .setMoving(true)

  else: discard