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

  AALL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_ATOP, TYPE_ABOTTOM, TYPE_AHORIZONTAL, TYPE_AVERTICAL, TYPE_AVERTICAL, TYPE_AALL}
  AHORIZONTAL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}
  AVERTICAL_SET = {TYPE_ATOP, TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}
  ARIGHT_SET = {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}
  ALEFT_SET = {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}
  ATOP_SET = {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}
  ABOTTOM_SET = {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}

  CPROTAGONIST_SET = {TYPE_NIL, TYPE_TILE_WALL}
  CARROW_SET = AALL_SET + {TYPE_TILE_WALL, TYPE_TILE}

type
  TGameDispatcher* = ref object of TCattyGameObject
    active*: uint32

proc protagonist(this: TGameDispatcher): TProtagonist = 
  for g in gameObjects: 
    if g.kind in {TYPE_PROTAGONIST}:
      return g.asProtagonist

proc gameField(this: TGameDispatcher): TGameField = 
  for g in gameObjects:
    if g.kind in {TYPE_GAMEFIELD}:
      return g.asGameField

proc tile(this: TGameDispatcher): TTile =
  for tile in this.gameField.tiles:
    if tile.kind in AALL_SET and tile.isActive:
      return tile

proc sighting(this: TGameDispatcher): TSighting = 
  for g in gameObjects:
    if g.kind in {TYPE_SIGHTING}:
      return g.asSighting

proc getOffsetArrow(this: TGameDispatcher, direction: uint32, arrow: TTile): TCattyCoords = 
  result = arrow.coords

  while true:
    case direction
    of DIRECTION_LEFT:
      if arrow.kind notin ALEFT_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x - SCALE, arrow.coords.y]): break
        result = (arrow.coords.x - SCALE, arrow.coords.y)
      else:
        if arrow.isCollision(this.gameField.tiles[result - (SCALE, 0)]): break
        result -= (SCALE, 0)

    of DIRECTION_RIGHT:
      if arrow.kind notin ARIGHT_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x + SCALE, arrow.coords.y]): break
        result = (arrow.coords.x + SCALE, arrow.coords.y)
      else:
        if arrow.isCollision(this.gameField.tiles[result + (SCALE, 0)]): break
        result += (SCALE, 0)

    of DIRECTION_TOP:
      if arrow.kind notin ATOP_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[arrow.coords.x, arrow.coords.y - SCALE]): break
        result = (arrow.coords.x, arrow.coords.y - SCALE)
      else:
        if arrow.isCollision(this.gameField.tiles[result - (0, SCALE)]): break
        result -= (0, SCALE)

    of DIRECTION_BOTTOM:
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

    echo "K_UP"
    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ATOP_SET:
      echo "K_UP isStepArrow"
      echo DIRECTION_TOP, this.gameField.tiles[this.protagonist.coords].coords
      var
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_TOP, this.gameField.tiles[this.protagonist.coords])
        d = (0, -1 * DELTA_SIGHTING)


      fireProtagonistStartMove(DIRECTION_TOP, c, o, d)
      fireTileArrowStartMove(DIRECTION_TOP, c, o, d)

    elif not isCollision:
      echo "K_UP isntCollision"
      this.protagonist.isStepArrow = false

      var 
        c = this.protagonist.coords
        o = this.protagonist.coords - (0, SCALE)
        d = (0, -1 * DELTA_PROTAGONIST)

      fireProtagonistStartMove(DIRECTION_TOP, c, o, d)


  elif key in {K_DOWN, K_S}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (0, SCALE)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ABOTTOM_SET:
      var
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_BOTTOM, this.gameField.tiles[this.protagonist.coords])
        d = (0, DELTA_SIGHTING)

      fireProtagonistStartMove(DIRECTION_BOTTOM, c, o, d)
      fireTileArrowStartMove(DIRECTION_BOTTOM, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords + (0, SCALE)
        d = (0, DELTA_PROTAGONIST)

      fireProtagonistStartMove(DIRECTION_BOTTOM, c, o, d)

  elif key in {K_LEFT, K_A}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (SCALE, 0)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ALEFT_SET:
      var 
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_LEFT, this.gameField.tiles[this.protagonist.coords])
        d = (-1 * DELTA_SIGHTING, 0)

      fireProtagonistStartMove(DIRECTION_LEFT, c, o, d)
      fireTileArrowStartMove(DIRECTION_LEFT, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords - (SCALE, 0)
        d = (-1 * DELTA_PROTAGONIST, 0)

      fireProtagonistStartMove(DIRECTION_LEFT, c, o, d)

  elif key in {K_RIGHT, K_D}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (SCALE, 0)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ARIGHT_SET:
      var 
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_RIGHT, this.gameField.tiles[this.protagonist.coords])
        d = (DELTA_SIGHTING, 0)

      fireProtagonistStartMove(DIRECTION_RIGHT, c, o, d)
      fireTileArrowStartMove(DIRECTION_RIGHT, c, o, d)

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords + (SCALE, 0)
        d = (DELTA_PROTAGONIST, 0)

      fireProtagonistStartMove(DIRECTION_RIGHT, c, o, d)

  else: discard

proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) =
  var
    c, o, d: TCattyCoords

  if key in {K_UP, K_W}:
    c = this.tile.coords
    o = this.getOffsetArrow(DIRECTION_TOP, this.tile)
    d = (0, -1 * DELTA_SIGHTING)

    DIRECTION_TOP.fireTileArrowStartMove(c, o, d)

  elif key in {K_DOWN, K_S}:
    c = this.tile.coords
    o = this.getOffsetArrow(DIRECTION_BOTTOM, this.tile)
    d = (0, DELTA_SIGHTING)

    DIRECTION_BOTTOM.fireTileArrowStartMove(c, o, d)

  elif key in {K_LEFT, K_A}:
    c = this.tile.coords
    o = this.getOffsetArrow(DIRECTION_LEFT, this.tile)
    d = (-1 * DELTA_SIGHTING, 0)

    DIRECTION_LEFT.fireTileArrowStartMove(c, o, d)

  elif key in {K_RIGHT, K_D}:
    c = this.tile.coords
    o = this.getOffsetArrow(DIRECTION_RIGHT, this.tile)
    d = (DELTA_SIGHTING, 0)

    DIRECTION_RIGHT.fireTileArrowStartMove(c, o, d)


proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) =
  var
    c, o, d: TCattyCoords

  if key in {K_UP, K_W} and (this.sighting.coords - (0, SCALE)).y >= 0:
    c = this.sighting.coords
    o = this.sighting.coords - (0, SCALE)
    d = (0, -1 * DELTA_SIGHTING)

    DIRECTION_TOP.fireSightingStartMove(c, o, d)

  elif key in {K_DOWN, K_S} and (this.sighting.coords + (0, SCALE)).y <= SCREEN_HEIGHT:
    c = this.sighting.coords
    o = this.sighting.coords + (0, SCALE)
    d = (0, DELTA_SIGHTING)

    DIRECTION_BOTTOM.fireSightingStartMove(c, o, d)

  elif key in {K_LEFT, K_A} and (this.sighting.coords - (SCALE, 0)).x >= 0:
    c = this.sighting.coords
    o = this.sighting.coords - (SCALE, 0)
    d = (-1 * DELTA_SIGHTING, 0)

    DIRECTION_LEFT.fireSightingStartMove(c, o, d)

  elif key in {K_RIGHT, K_D} and (this.sighting.coords + (SCALE, 0)).x <= SCREEN_WIDTH:
    c = this.sighting.coords
    o = this.sighting.coords + (SCALE, 0)
    d = (DELTA_SIGHTING, 0)

    DIRECTION_RIGHT.fireSightingStartMove(c, o, d)



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

  of EVENT_PROTAGONIST_ACTIVATE: discard
  of EVENT_PROTAGONIST_DEACTIVATE: discard
  of EVENT_PROTAGONIST_START_MOVE: discard
  of EVENT_PROTAGONIST_END_MOVE:

    var 
      event = cast[TEventEndMove](e.data1)
      tile = this.gameField.tiles[event.coords]

    if tile.kind in AALL_SET:
      event.coords.fireTileArrowActivate()

    elif tile.kind in {TYPE_EXIT}:
      this.gameField.nextMap
      this.protagonist.activate.coords = this.gameField.respawnTile.coords


  of EVENT_SIGHTING_ACTIVATE: discard
  of EVENT_SIGHTING_DEACTIVATE: discard
  of EVENT_SIGHTING_START_MOVE: discard
  of EVENT_SIGHTING_END_MOVE: discard

  of EVENT_TILE_ARROW_ACTIVATE: discard
  of EVENT_TILE_ARROW_DEACTIVATE: discard
  of EVENT_TILE_ARROW_START_MOVE: discard
  of EVENT_TILE_ARROW_END_MOVE: discard

  else: discard