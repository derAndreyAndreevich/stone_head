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
  else: discard

  return this
