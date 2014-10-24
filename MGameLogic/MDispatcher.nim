import sdl
import catty.core, catty.gameobjects as MCattyGameObjects
import 
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameObjects.MTiles,
  MCast,
  MGlobal as global

const
  ACTIVE_PROTAGONIST = 1
  ACTIVE_TILE = 2
  ACTIVE_SIGHTING = 3

  ANIM_OFFSET_PROTAGONIST = 8
  ANIM_OFFSET_SIGHTING = 2

  AALL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_ATOP, TYPE_ABOTTOM, TYPE_AHORIZONTAL, TYPE_AVERTICAL, TYPE_AVERTICAL}
  AHORIZONTAL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}
  AVERTICAL_SET = {TYPE_ATOP, TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}
  ARIGHT_SET = {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}
  ALEFT_SET = {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}
  ATOP_SET = {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}
  ABOTTOM_SET = {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}

  CPROTAGONIST_SET = {TYPE_NIL, TYPE_TILE_WALL}


type
  TGameDispatcher* = ref object of TCattyGameObject
    active*: uint32


proc protagonist(this: TGameDispatcher): TProtagonist = 
  for gameObject in global.gameObjects:
    case gameObject.kind
    of TYPE_PROTAGONIST: return gameObject.asProtagonist
    else: discard


proc gameField(this: TGameDispatcher): TGameField =
  for go in global.gameObjects:
    case go.kind
    of TYPE_GAMEFIELD: return go.asGameField
    else: discard


proc tile(this: TGameDispatcher): TTile = 
  for tile in this.gameField.tiles:
    if tile.kind in AALL_SET and tile.isActive:
       return tile


proc sighting(this: TGameDispatcher): TSighting =
  for go in global.gameObjects:
    case go.kind
    of TYPE_SIGHTING: return go.asSighting
    else: discard

proc activate(this: TGameDispatcher, activateType: uint32 = ACTIVE_PROTAGONIST, x, y: int = 0) = 
  case activateType
  of ACTIVE_PROTAGONIST:
    this.sighting.hide

  of ACTIVE_SIGHTING:
    this.sighting.show
    this.sighting.coords = if this.active in {ACTIVE_PROTAGONIST}: this.protagonist.coords else: this.tile.coords

  of ACTIVE_TILE:
    this.sighting.hide
    this.tile.isActive = false
    this.gameField.tiles[x, y].isActive = true

  else: discard

  this.active = activateType

proc getRespawnPoint(this: TGameField): TTile = 
  for tile in this.tiles:
    if tile.kind in {TYPE_RESPAWN}:
      return tile

  return TTile(coords: (0, 0))


proc getOffsetArrow(this: TGameDispatcher, direction: uint32, arrow: TTile): TCattyCoords = 
  result = (-1, -1)

  while true:
    case direction
    of DIRECTION_LEFT:
      if arrow.kind notin ALEFT_SET:
        result = arrow.coords
        break

      if result == (-1, -1):
        result = (arrow.coords.x - SCALE, arrow.coords.y)

      if this.gameField.tiles[result].kind notin {TYPE_NIL}:
        result += (SCALE, 0)
        break
      else:
        result -= (SCALE, 0)

    of DIRECTION_RIGHT:
      if arrow.kind notin ARIGHT_SET:
        result = arrow.coords
        break

      if result == (-1, -1):
        result = (arrow.coords.x + SCALE, arrow.coords.y)

      if this.gameField.tiles[result].kind notin {TYPE_NIL}:
        result -= (SCALE, 0)
        break
      else:
        result += (SCALE, 0)

    of DIRECTION_TOP:
      if arrow.kind notin ATOP_SET:
        result = arrow.coords
        break

      if result == (-1, -1):
        result = (0, arrow.coords.y - SCALE)

      if this.gameField.tiles[result].kind notin {TYPE_NIL}:
        result += (0, SCALE)
        break
      else:
        result -= (0, SCALE)

    of DIRECTION_BOTTOM:
      if arrow.kind notin ABOTTOM_SET:
        result = arrow.coords
        break

      if result == (-1, -1):
        result = (0, arrow.coords.y + SCALE)

      if this.gameField.tiles[result].kind notin {TYPE_NIL}:
        result -= (0, SCALE)
        break
      else:
        result += (0, SCALE)

    else: discard





proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var 
    self = this.protagonist
    offset, offsetArrow = (0, 0)
    stepTile = this.gameField.tiles[self.coords]

  proc protagonistIsCollision(coords: TCattyCoords): bool = this.gameField.tiles[coords].kind in CPROTAGONIST_SET

  proc protagonistMove(offset: TCattyCoords, isAnim: bool = false): TCattyCoords {.discardable.} = 
    if offset.x > self.coords.x:
      self.direction = DIRECTION_RIGHT
      if isAnim: 
        self.playAnim ANIM_PROTAGONIST_RIGHT
        self.delta = (SCALE div ANIM_OFFSET_PROTAGONIST, 0)
      else:
        self.delta = (SCALE div ANIM_OFFSET_SIGHTING, 0)

    elif offset.x < self.coords.x:
      self.direction = DIRECTION_LEFT
      if isAnim: 
        self.playAnim ANIM_PROTAGONIST_LEFT
        self.delta = (-1 * (SCALE div ANIM_OFFSET_PROTAGONIST), 0)
      else:
        self.delta = (-1 * (SCALE div ANIM_OFFSET_SIGHTING), 0)

    elif offset.y > self.coords.y: 
      self.direction = DIRECTION_BOTTOM
      if isAnim: 
        self.playAnim ANIM_PROTAGONIST_BOTTOM
        self.delta = (0, SCALE div ANIM_OFFSET_PROTAGONIST)
      else:
        self.delta = (0, SCALE div ANIM_OFFSET_SIGHTING)

    elif: 
      self.direction = DIRECTION_TOP
      if isAnim: 
        self.playAnim ANIM_PROTAGONIST_TOP
        self.delta = (0, -1 * (SCALE div ANIM_OFFSET_PROTAGONIST))
      else:
        self.delta = (0, -1 * (SCALE div ANIM_OFFSET_SIGHTING))


    self.isMoving = true
    self.offsetStop = offset

    return direction

  proc arrowMove(direction: uint32, offset: TCattyCoords): uint32 {.discardable.} = 
    stepTile.isMoving = true
    stepTile.direction = direction
    stepTile.offsetStop = offset
    # stepTile.dx = SCALE div ANIM_OFFSET_SIGHTING
    # stepTile.dy = SCALE div ANIM_OFFSET_SIGHTING

    return direction


  if not self.isMoving:

    case key
    of K_UP, K_W:
      offset = (self.coords.x, self.coords.y - SCALE)

      let isntCollision = 
        self.coords.y > 0 and not this.protagonistIsCollision(offset)

      if stepTile.kind in ATOP_SET:

        offsetArrow = DIRECTION_TOP.getOffsetArrow(stepTile)
        DIRECTION_TOP.protagonistMove(offsetArrow).arrowMove(offsetArrow)

        if isntCollision: DIRECTION_TOP.protagonistMove(offset, true)

      elif isntCollision: DIRECTION_TOP.protagonistMove(offset, true)

    of K_DOWN, K_S:
      offset = (self.coords.x, self.coords.y + SCALE)

      let isntCollision = 
        self.coords.y < SCREEN_HEIGHT - SCALE and not this.protagonistIsCollision(offset)

      if stepTile.kind in ABOTTOM_SET:
        protagonistMove(DIRECTION_BOTTOM, this.getOffsetArrow(DIRECTION_BOTTOM, stepTile))
        arrowMove(DIRECTION_BOTTOM, this.getOffsetArrow(DIRECTION_BOTTOM, stepTile))

        if isntCollision: protagonistMove(DIRECTION_BOTTOM, offset, true)

      elif isntCollision: protagonistMove(DIRECTION_BOTTOM, offset, true)

    of K_LEFT, K_A:
      offset = (self.coords.x - SCALE, self.coords.y)

      let isntCollision = 
        self.coords.x > 0 and not this.protagonistIsCollision(offset)

      if stepTile.kind in ALEFT_SET:

        protagonistMove(DIRECTION_LEFT, this.getOffsetArrow(DIRECTION_LEFT, stepTile))
        arrowMove(DIRECTION_LEFT, this.getOffsetArrow(DIRECTION_LEFT, stepTile))

        if isntCollision: protagonistMove(DIRECTION_LEFT, offset, true)

      elif isntCollision: protagonistMove(DIRECTION_LEFT, offset, true)

    of K_RIGHT, K_D:
      offset = (self.coords.x + SCALE, self.coords.y)

      let isntCollision = 
        self.coords.x < SCREEN_WIDTH - SCALE and not this.protagonistIsCollision(offset)


      if stepTile.kind in ARIGHT_SET:

        protagonistMove(DIRECTION_RIGHT, this.getOffsetArrow(DIRECTION_RIGHT, stepTile))
        arrowMove(DIRECTION_RIGHT, this.getOffsetArrow(DIRECTION_RIGHT, stepTile))

        if isntCollision: protagonistMove(DIRECTION_RIGHT, offset, true)

      elif isntCollision: protagonistMove(DIRECTION_RIGHT, offset, true)

    else: discard

    self.texture = application.getTexture("protagonist-" + self.direction + "-0")


proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) = 
  var
    self = this.tile
    offset = 0


  if not self.isMoving:
    if key in {K_LEFT, K_A} and self.kind in {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}:
      offset = this.getOffsetArrow(DIRECTION_LEFT, self)

      if self.x > 0:
        self.isMoving = true
        self.direction = DIRECTION_LEFT
        self.offsetStop = offset
        self.dx = SCALE div ANIM_OFFSET_SIGHTING

    elif key in {K_RIGHT, K_D} and self.kind in {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}:
      offset = this.getOffsetArrow(DIRECTION_RIGHT, self)

      if self.x < SCREEN_WIDTH - SCALE:
        self.isMoving = true
        self.direction = DIRECTION_RIGHT
        self.offsetStop = offset
        self.dx = SCALE div ANIM_OFFSET_SIGHTING

    elif key in {K_UP, K_W} and self.kind in {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}:
      offset = this.getOffsetArrow(DIRECTION_TOP, self)

      if self.x < SCREEN_WIDTH - SCALE:
        self.isMoving = true
        self.direction = DIRECTION_TOP
        self.offsetStop = offset
        self.dy = SCALE div ANIM_OFFSET_SIGHTING

    elif key in {K_DOWN, K_S} and self.kind in {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}:
      offset = this.getOffsetArrow(DIRECTION_BOTTOM, self)

      if self.x < SCREEN_WIDTH - SCALE:
        self.isMoving = true
        self.direction = DIRECTION_BOTTOM
        self.offsetStop = offset
        self.dy = SCALE div ANIM_OFFSET_SIGHTING

proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) =
  var 
    self = this.sighting
    offset = 0

  if not self.isMoving:

    case key
    of K_UP, K_W:
      offset = self.y - SCALE

      if self.y > 0:
        self.isMoving = true
        self.direction = DIRECTION_TOP
        self.offsetStop = offset
        self.dy = SCALE div ANIM_OFFSET_SIGHTING

    of K_DOWN, K_S:
      offset = self.y + SCALE

      if self.y < SCREEN_HEIGHT - SCALE:
        self.isMoving = true
        self.direction = DIRECTION_BOTTOM
        self.offsetStop = offset
        self.dy = SCALE div ANIM_OFFSET_SIGHTING

    of K_LEFT, K_A:
      offset = self.x - SCALE

      if self.x > 0:
        self.isMoving = true
        self.direction = DIRECTION_LEFT
        self.offsetStop = offset
        self.dx = SCALE div ANIM_OFFSET_SIGHTING

    of K_RIGHT, K_D:  
      offset = self.x + SCALE

      if self.x < SCREEN_WIDTH - SCALE:
        self.isMoving = true
        self.direction = DIRECTION_RIGHT
        self.offsetStop = offset
        self.dx = SCALE div ANIM_OFFSET_SIGHTING

    else: discard

proc initialization*(this: TGameDispatcher): TGameDispatcher {.discardable.} = 
  this.active = ACTIVE_PROTAGONIST
  this.protagonist.x = this.gameField.getRespawnPoint.x
  this.protagonist.y = this.gameField.getRespawnPoint.y

  return this

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  if not this.protagonist.isMoving and not this.sighting.isMoving:
    if key == K_SPACE:
      var tile = this.gameField.getTile(this.sighting.x, this.sighting.y)

      if this.active in {ACTIVE_PROTAGONIST, ACTIVE_TILE}:
        this.activate(ACTIVE_SIGHTING)

      elif this.active in {ACTIVE_SIGHTING} and tile.kind in AALL_SET:

        if this.protagonist.x == this.sighting.x and this.protagonist.y == this.sighting.y:
          this.active = ACTIVE_PROTAGONIST
          this.sighting.isDraw = false

        elif this.tile == nil:
          this.active = ACTIVE_TILE
          tile.isActive = true
          this.sighting.isDraw = false

        elif this.tile != nil:
          this.tile.isActive = false

          this.active = ACTIVE_TILE
          tile.isActive = true
          this.sighting.isDraw = false

      else:
        this.active = ACTIVE_PROTAGONIST

        this.sighting.isDraw = false

  case this.active
  of ACTIVE_PROTAGONIST: this.onKeyDownProtagonist(key)
  of ACTIVE_SIGHTING: this.onKeyDownSighting(key)
  of ACTIVE_TILE: this.onKeyDownArrowTile(key)
  else: discard

proc onUserEvent*(this: TGameDispatcher, event: TUserEvent) = 
  case event.code
  of EVENT_PROTAGONIST_END_MOVE:

    var 
      data = cast[TEndMoveEvent](event.data1)
      tile = this.gameField.getTile(data.x, data.y)


    case tile.kind

    of TYPE_ALEFT, TYPE_ARIGHT, TYPE_ABOTTOM, TYPE_ATOP, TYPE_AVERTICAL, TYPE_AHORIZONTAL, TYPE_AALL: 
      if this.tile == nil:
        this.active = ACTIVE_TILE
        tile.isActive = true

    else: discard

  of EVENT_SIGHTING_END_MOVE: discard


  of EVENT_TILE_ARROW_END_MOVE: discard

  else: discard