import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal


proc eventEndMove(this: TSighting) = 
  this.stopAnim
  this.coords = this.offsetStop
  this.isMoving = false

  var
    data = cast[ptr TEventEndMove](TEventEndMove(x: this.coords.x, y: this.coords.y))
    event = sdl.TUserEvent(
      kind: sdl.USEREVENT, code: EVENT_SIGHTING_END_MOVE, data1: data
    )

  discard sdl.pushEvent(cast[sdl.PEvent](addr event))

proc initialization*(this: TSighting): TSighting {.discardable.} = 

  cast[TCattyGameObject](this).initialization


  this.kind = TYPE_SIGHTING

  this.coords = (0, 0)
  this.size = (SCALE, SCALE)

  this.direction = DIRECTION_BOTTOM
  this.texture = application.getTexture("sighting")
  this.sleep = 80

  return this

proc endUpdate(this: TSighting) =
  this.coords = this.offsetStop
  this.isMoving = false

proc update*(this: TSighting) =
  if this.isMoving:
    this.coords += this.delta

    case this.direction
    of DIRECTION_TOP, DIRECTION_LEFT:
      if this.coords + this.delta > this.offsetStop:
        this.eventEndMove
    of DIRECTION_BOTTOM, DIRECTION_RIGHT:
      if this.coords + this.delta < this.offsetStop:
        this.eventEndMove
    else: discard

proc draw*(this: TSighting) =
  cast[TCattyGameObject](this).draw
