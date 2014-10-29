import
  sdl, opengl,
  catty.core, catty.gameobjects as MCattyGameObjects, 
  MGameLogic.MGlobal,
  MGameObject


cattySetters(TTile)
gameObjectSetters(TTile)

proc isCollision*(this,  tile: TTile): bool = tile.kind != tpNil.ord

proc endMove(this: TTile) = 
  this.stopAnim
  this
    .setCoords(this.offsetStop)
    .stop.coords.fireTileArrowEndMove


proc initialization*(this: TTile): TTile {.discardable.} = 
  cast[TCattyGameObject](this).initialization()

  case this.kind
  of tpTileWall.ord: this.setTexture(application.getTexture("wall"))
  of tpTile.ord: this.texture = application.getTexture("tail-" + rand() mod 5)
  of tpRespawn.ord: this.texture = application.getTexture("respawn")
  of tpExit.ord: this.texture = application.getTexture("exit")
  of tpALeft.ord: this.texture = application.getTexture("arrow-left")
  of tpARight.ord: this.texture = application.getTexture("arrow-right")
  of tpATop.ord: this.texture = application.getTexture("arrow-top")
  of tpABottom.ord: this.texture = application.getTexture("arrow-bottom")
  of tpAHorizontal.ord: this.texture = application.getTexture("arrow-horizontal")
  of tpAVertical.ord: this.texture = application.getTexture("arrow-vertical")
  of tpAAll.ord: this.texture = application.getTexture("arrow-all")
  else: discard

  return this

proc update*(this: TTile) =
  if this.isMoving:

    case this.direction
    of dirTop.ord, dirLeft.ord:
      if this.coords + this.delta < this.offsetStop:
        this.endMove
      else: this.coords += this.delta
    of dirBottom.ord, dirRight.ord:
      if this.coords + this.delta > this.offsetStop:
        this.endMove
      else: this.coords += this.delta
    else: discard


proc onUserEvent*(this: TTile, e: PUserEvent) =
  case e.code
  of eventTileArrowStartMove.ord:
    var event = e.data1.asEventStartMove

    this
      .setOffsetStop(event.offsetStop)
      .setDelta(event.delta)
      .setDirection(event.direction)
      .move

  of eventTileArrowEndMove.ord: discard
  of eventtileArrowActivate.ord: this.activate
  of eventTileArrowDeactivate.ord: this.deactivate
  else: discard