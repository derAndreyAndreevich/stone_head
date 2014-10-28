import
  sdl, opengl,
  catty.core, catty.gameobjects as MCattyGameObjects, 
  MGameLogic.MGlobal,
  MGameObject

const
  COLLISION_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_ATOP, TYPE_ABOTTOM, TYPE_AHORIZONTAL, TYPE_AVERTICAL, TYPE_AVERTICAL, TYPE_TILE_WALL, TYPE_TILE, TYPE_RESPAWN, TYPE_EXIT, TYPE_AALL}

cattySetters(TTile)
gameObjectSetters(TTile)

proc isCollision*(this,  tile: TTile): bool = tile.kind in COLLISION_SET

proc endMove(this: TTile) = 
  this.stopAnim
  this
    .setCoords(this.offsetStop)
    .stop.coords.fireTileArrowEndMove


proc initialization*(this: TTile): TTile {.discardable.} = 
  cast[TCattyGameObject](this).initialization()

  case this.kind
  of TYPE_TILE_WALL: this.setTexture(application.getTexture("wall"))
  of TYPE_TILE: this.texture = application.getTexture("tail-" + rand() mod 5)
  of TYPE_RESPAWN: this.texture = application.getTexture("respawn")
  of TYPE_EXIT: this.texture = application.getTexture("exit")
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


proc onUserEvent*(this: TTile, e: PUserEvent) =
  case e.code
  of EVENT_TILE_ARROW_START_MOVE:
    var event = e.data1.asEventStartMove

    this
      .setOffsetStop(event.offsetStop)
      .setDelta(event.delta)
      .setDirection(event.direction)
      .move

    echo "TTile <EVENT_TILE_ARROW_START_MOVE> ", event.offsetStop, " ", event.direction

  of EVENT_TILE_ARROW_END_MOVE: discard
  of EVENT_TILE_ARROW_ACTIVATE: this.activate
  of EVENT_TILE_ARROW_DEACTIVATE: this.deactivate
  else: discard