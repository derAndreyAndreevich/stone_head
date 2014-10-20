import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal


proc initialization*(this: TSighting): TSighting {.discardable.} = 

  cast[TCattyGameObject](this).initialization


  this.kind = TYPE_SIGHTING

  this.x = SCALE * 14
  this.y = SCALE * 2
  this.w = SCALE
  this.h = SCALE
  this.direction = DIRECTION_BOTTOM
  this.texture = application.getTexture("sighting")
  this.sleep = 80

  return this

proc update*(this: TSighting) =
  if this.isMoving:
    case this.direction:
    of DIRECTION_TOP: 

      if this.y - this.dy > this.offsetStop:
        this.y -= this.dy
      else:
        this.y = this.offsetStop
        this.isMoving = false

    of DIRECTION_BOTTOM: 

      if this.y + this.dy < this.offsetStop:
        this.y += this.dy
      else:
        this.y = this.offsetStop
        this.isMoving = false

    of DIRECTION_LEFT: 

      if this.x - this.dx > this.offsetStop:
        this.x -= this.dx
      else:
        this.x = this.offsetStop
        this.isMoving = false

    of DIRECTION_RIGHT: 

      if this.x + this.dx < this.offsetStop:
        this.x += this.dx
      else:
        this.x = this.offsetStop
        this.isMoving = false

    else: discard

proc draw*(this: TSighting) =
  cast[TCattyGameObject](this).draw
