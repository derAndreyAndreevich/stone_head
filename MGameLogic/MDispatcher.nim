import sdl
import catty.core, catty.gameobjects as MCattyGameObjects
import 
  MGlobal as global,
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameObjects.MTiles,
  MGameObjects.MProtagonist,
  MGameObjects.MSighting,
  MGameLogic.MCast

const
  ACTIVE_PROTAGONIST = 1
  ACTIVE_TILE = 2
  ACTIVE_SIGHTING = 3

  ANIM_OFFSET_PROTAGONIST = 8
  ANIM_OFFSET_SIGHTING = 4

  DELTA_PROTAGONIST = SCALE div ANIM_OFFSET_PROTAGONIST
  DELTA_SIGHTING = SCALE div ANIM_OFFSET_SIGHTING

  AALL_SET = {tpALeft.ord, tpARight.ord, tpATop.ord, tpABottom.ord, tpAHorizontal.ord, tpAVertical.ord, tpAAll.ord}
  AHORIZONTAL_SET = {tpALeft.ord, tpARight.ord, tpAHorizontal.ord, tpAAll.ord}
  AVERTICAL_SET = {tpATop.ord, tpABottom.ord, tpAVertical.ord, tpAAll.ord}
  ARIGHT_SET = {tpARight.ord, tpAHorizontal.ord, tpAAll.ord}
  ALEFT_SET = {tpALeft.ord, tpAHorizontal.ord, tpAAll.ord}
  ATOP_SET = {tpATop.ord, tpAVertical.ord, tpAAll.ord}
  ABOTTOM_SET = {tpABottom.ord, tpAVertical.ord, tpAAll.ord}

type
  TGameDispatcher* = ref object of TCattyGameObject
    active*: uint32

proc protagonist(this: TGameDispatcher): TProtagonist = 
  for g in gameObjects: 
    if g.kind in {tpProtagonist.ord}:
      return g.asProtagonist

proc gameField(this: TGameDispatcher): TGameField = 
  for g in gameObjects:
    if g.kind in {tpGameField.ord}:
      return g.asGameField

proc tile(this: TGameDispatcher): TTile =
  for tile in this.gameField.tiles:
    if tile.kind in AALL_SET and tile.isActive:
      return tile

  return TTile()

proc sighting(this: TGameDispatcher): TSighting = 
  for g in gameObjects:
    if g.kind in {tpSighting.ord}:
      return g.asSighting

proc getOffsetArrow(this: TGameDispatcher, direction: uint32, arrow: TTile): TCattyCoords = 
  result = arrow.coords

  while true:
    case direction
    of dirLeft.ord:
      if arrow.kind notin ALEFT_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x - SCALE, arrow.coords.y]): break
        result = (arrow.coords.x - SCALE, arrow.coords.y)
      else:
        if arrow.isCollision(this.gameField.tiles[result - (SCALE, 0)]): break
        result -= (SCALE, 0)

    of dirRight.ord:
      if arrow.kind notin ARIGHT_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x + SCALE, arrow.coords.y]): break
        result = (arrow.coords.x + SCALE, arrow.coords.y)
      else:
        if arrow.isCollision(this.gameField.tiles[result + (SCALE, 0)]): break
        result += (SCALE, 0)

    of dirTop.ord:
      if arrow.kind notin ATOP_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x, arrow.coords.y - SCALE]): break
        result = (arrow.coords.x, arrow.coords.y - SCALE)
      else:
        if arrow.isCollision(this.gameField.tiles[result - (0, SCALE)]): break
        result -= (0, SCALE)

    of dirBottom.ord:
      if arrow.kind notin ABOTTOM_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x, arrow.coords.y + SCALE]): break
        result = (arrow.coords.x, arrow.coords.y + SCALE)
      else:
        if arrow.isCollision(this.gameField.tiles[result + (0, SCALE)]): break
        result += (0, SCALE)

    else: discard


proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var 
    isCollision: bool

  if key in {K_UP, K_W}:
    isCollision = this
      .protagonist.isCollision(
        this.gameField.tiles[this.protagonist.coords - (0, SCALE)]
      )

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ATOP_SET:
      echo dirTop.ord, this.gameField.tiles[this.protagonist.coords].coords
      var
        c = this.protagonist.coords
        o = this.getOffsetArrow(dirTop.ord, this.gameField.tiles[this.protagonist.coords])
        d = (0, -1 * DELTA_SIGHTING)


      fireProtagonistStartMove(dirTop.ord, c, o, d)
      fireTileArrowStartMove(dirTop.ord, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var 
        c = this.protagonist.coords
        o = this.protagonist.coords - (0, SCALE)
        d = (0, -1 * DELTA_PROTAGONIST)

      fireProtagonistStartMove(dirTop.ord, c, o, d)


  elif key in {K_DOWN, K_S}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (0, SCALE)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ABOTTOM_SET:
      var
        c = this.protagonist.coords
        o = this.getOffsetArrow(dirBottom.ord, this.gameField.tiles[this.protagonist.coords])
        d = (0, DELTA_SIGHTING)

      fireProtagonistStartMove(dirBottom.ord, c, o, d)
      fireTileArrowStartMove(dirBottom.ord, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords + (0, SCALE)
        d = (0, DELTA_PROTAGONIST)

      fireProtagonistStartMove(dirBottom.ord, c, o, d)

  elif key in {K_LEFT, K_A}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (SCALE, 0)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ALEFT_SET:
      var 
        c = this.protagonist.coords
        o = this.getOffsetArrow(dirLeft.ord, this.gameField.tiles[this.protagonist.coords])
        d = (-1 * DELTA_SIGHTING, 0)

      fireProtagonistStartMove(dirLeft.ord, c, o, d)
      fireTileArrowStartMove(dirLeft.ord, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords - (SCALE, 0)
        d = (-1 * DELTA_PROTAGONIST, 0)

      fireProtagonistStartMove(dirLeft.ord, c, o, d)

  elif key in {K_RIGHT, K_D}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (SCALE, 0)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ARIGHT_SET:
      var 
        c = this.protagonist.coords
        o = this.getOffsetArrow(dirRight.ord, this.gameField.tiles[this.protagonist.coords])
        d = (DELTA_SIGHTING, 0)

      fireProtagonistStartMove(dirRight.ord, c, o, d)
      fireTileArrowStartMove(dirRight.ord, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords + (SCALE, 0)
        d = (DELTA_PROTAGONIST, 0)

      fireProtagonistStartMove(dirRight.ord, c, o, d)

  else: discard

proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) =
  var
    c, o, d: TCattyCoords

  if key in {K_UP, K_W}:
    c = this.tile.coords
    o = this.getOffsetArrow(dirTop.ord, this.tile)
    d = (0, -1 * DELTA_SIGHTING)

    dirTop.ord.fireTileArrowStartMove(c, o, d)

  elif key in {K_DOWN, K_S}:
    c = this.tile.coords
    o = this.getOffsetArrow(dirBottom.ord, this.tile)
    d = (0, DELTA_SIGHTING)

    dirBottom.ord.fireTileArrowStartMove(c, o, d)

  elif key in {K_LEFT, K_A}:
    c = this.tile.coords
    o = this.getOffsetArrow(dirLeft.ord, this.tile)
    d = (-1 * DELTA_SIGHTING, 0)

    dirLeft.ord.fireTileArrowStartMove(c, o, d)

  elif key in {K_RIGHT, K_D}:
    c = this.tile.coords
    o = this.getOffsetArrow(dirRight.ord, this.tile)
    d = (DELTA_SIGHTING, 0)

    dirRight.ord.fireTileArrowStartMove(c, o, d)


proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) =
  var
    c, o, d: TCattyCoords

  if key in {K_UP, K_W} and (this.sighting.coords - (0, SCALE)).y >= 0:
    c = this.sighting.coords
    o = this.sighting.coords - (0, SCALE)
    d = (0, -1 * DELTA_SIGHTING)

    dirTop.ord.fireSightingStartMove(c, o, d)

  elif key in {K_DOWN, K_S} and (this.sighting.coords + (0, SCALE)).y <= SCREEN_HEIGHT:
    c = this.sighting.coords
    o = this.sighting.coords + (0, SCALE)
    d = (0, DELTA_SIGHTING)

    dirBottom.ord.fireSightingStartMove(c, o, d)

  elif key in {K_LEFT, K_A} and (this.sighting.coords - (SCALE, 0)).x >= 0:
    c = this.sighting.coords
    o = this.sighting.coords - (SCALE, 0)
    d = (-1 * DELTA_SIGHTING, 0)

    dirLeft.ord.fireSightingStartMove(c, o, d)

  elif key in {K_RIGHT, K_D} and (this.sighting.coords + (SCALE, 0)).x <= SCREEN_WIDTH:
    c = this.sighting.coords
    o = this.sighting.coords + (SCALE, 0)
    d = (DELTA_SIGHTING, 0)

    dirRight.ord.fireSightingStartMove(c, o, d)



proc initialization*(this: TGameDispatcher): TGameDispatcher {.discardable.} = 
  this.active = ACTIVE_PROTAGONIST
  this.protagonist.coords = this.gameField.respawnTile.coords

  return this

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  case key
  of K_SPACE:
    if this.protagonist.isActive and not this.protagonist.isMoving:
      fireSightingActivate(this.protagonist.coords)
      fireProtagonistDeactivate(this.protagonist.coords)
      fireTileArrowDeactivate(this.protagonist.coords)
    elif this.sighting.isActive and this.protagonist.coords == this.sighting.coords:
      fireSightingDeactivate()
      fireProtagonistActivate()
      if this.gameField.tiles[this.sighting.coords].kind in AALL_SET:
        this.sighting.coords.fireTileArrowActivate()
    elif this.sighting.isActive and this.gameField.tiles[this.sighting.coords].kind in AALL_SET:
      this.sighting.coords.fireTileArrowActivate()
      fireSightingDeactivate()
    elif this.tile != nil and this.tile.isActive and not this.tile.isMoving:
      fireSightingActivate(this.tile.coords)
      fireTileArrowDeactivate(this.tile.coords)

  else: discard

  if this.protagonist.isActive and not this.protagonist.isMoving: 
    this.onKeyDownProtagonist(key)
  elif this.sighting.isActive and not this.sighting.isMoving: 
    this.onKeyDownSighting(key)
  elif this.tile.isActive and not this.tile.isMoving:
    this.onKeyDownArrowTile(key)


proc onUserEvent*(this: TGameDispatcher, e: PUserEvent) = 
  case e.code

  of eventProtagonistEndMove.ord:

    var 
      event = cast[TEventEndMove](e.data1)
      tile = this.gameField.tiles[event.coords]

    if tile.kind in AALL_SET:
      event.coords.fireTileArrowActivate()

    elif tile.kind in {tpExit.ord}:
      this.gameField.nextMap
      this.protagonist.activate.coords = this.gameField.respawnTile.coords

  else: discard