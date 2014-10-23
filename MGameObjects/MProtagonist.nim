import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal

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

proc event_endMoveProtagonist(this: TProtagonist) = 

  var
    data = cast[ptr TEndMoveEvent](TEndMoveEvent(x: this.coords.x, y: this.coords.y))
    event = sdl.TUserEvent(
      kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_END_MOVE, data1: data
    )

  discard sdl.pushEvent(cast[sdl.PEvent](addr event))

proc endUpdate(this: TProtagonist) = 
  this.stopAnim
  this.coords = this.offsetStop
  this.isMoving = false
  this.event_endMoveProtagonist
  

proc update*(this: TProtagonist) =
  cast[TCattyGameObject](this).update

  if this.isMoving:
    case this.direction:
    of DIRECTION_TOP: 

      if this.coords - this.delta > this.offsetStop:
        this.coords -= this.delta
      else:
        this.endUpdate

    of DIRECTION_BOTTOM: 

      if this.coords + this.delta < this.offsetStop:
        this.coords += this.delta
      else:
        this.endUpdate

    of DIRECTION_LEFT: 

      if this.coords - this.delta > this.offsetStop:
        this.coords -= this.delta
      else:
        this.endUpdate

    of DIRECTION_RIGHT: 

      if this.coords + this.delta < this.offsetStop:
        this.coords += this.delta
      else:
        this.endUpdate

    else: discard

proc draw*(this: TProtagonist) =
  cast[TCattyGameObject](this).draw
