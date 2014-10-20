import
  sdl, opengl,
  catty.core, catty.gameobjects as MCattyGameObjects, 
  MGameLogic.MGlobal,
  MGameObject

proc initialization*(this: TTile): TTile {.discardable.} = 
  cast[TCattyGameObject](this).initialization()

  case this.kind
  of TYPE_TILE_WALL: this.texture = application.getTexture("wall")
  of TYPE_TILE: this.texture = application.getTexture("tail-" + rand() mod 5)
  of TYPE_RESPAWN: this.texture = application.getTexture("tail-" + rand() mod 5)
  of TYPE_EXIT: this.texture = application.getTexture("tail-" + rand() mod 5)
  of TYPE_ALEFT: this.texture = application.getTexture("arrow-left")
  of TYPE_ARIGHT: this.texture = application.getTexture("arrow-right")
  of TYPE_ATOP: this.texture = application.getTexture("arrow-top")
  of TYPE_ABOTTOM: this.texture = application.getTexture("arrow-bottom")
  of TYPE_AHORIZONTAL: this.texture = application.getTexture("arrow-horizontal")
  of TYPE_AVERTICAL: this.texture = application.getTexture("arrow-vertical")
  of TYPE_AALL: this.texture = application.getTexture("arrow-all")
  else: discard

  return this

proc update*(this: TTile) =
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

