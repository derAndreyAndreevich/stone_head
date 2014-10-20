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

  this.x = SCALE * 14
  this.y = SCALE * 2
  this.w = SCALE
  this.h = SCALE
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

proc update*(this: TProtagonist) =
  cast[TCattyGameObject](this).update
  if this.isMoving:
    case this.direction:
    of DIRECTION_TOP: 

      if this.y - this.dy > this.offsetStop:
        this.y -= this.dy
      else:
        this.stopAnim
        this.y = this.offsetStop
        this.isMoving = false

    of DIRECTION_BOTTOM: 

      if this.y + this.dy < this.offsetStop:
        this.y += this.dy
      else:
        this.stopAnim
        this.y = this.offsetStop
        this.isMoving = false

    of DIRECTION_LEFT: 

      if this.x - this.dx > this.offsetStop:
        this.x -= this.dx
      else:
        this.stopAnim
        this.x = this.offsetStop
        this.isMoving = false

    of DIRECTION_RIGHT: 

      if this.x + this.dx < this.offsetStop:
        this.x += this.dx
      else:
        this.stopAnim
        this.x = this.offsetStop
        this.isMoving = false

    else: discard

proc draw*(this: TProtagonist) =
  cast[TCattyGameObject](this).draw
