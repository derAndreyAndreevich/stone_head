import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal


proc show*(this: TSighting) = this.isDraw = true
proc hide*(this: TSighting) = this.isDraw = false
proc toggleDraw*(this: TSighting) = this.isDraw = not this.isDraw

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

proc draw*(this: TSighting) =
  cast[TCattyGameObject](this).draw
