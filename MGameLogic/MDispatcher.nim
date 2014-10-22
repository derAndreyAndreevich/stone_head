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
    if tile.kind in {TYPE_ATOP, TYPE_ABOTTOM, TYPE_ALEFT, TYPE_ARIGHT, TYPE_AVERTICAL, TYPE_AHORIZONTAL, TYPE_AALL} and tile.isActive:
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
    this.sighting.x = if this.active == ACTIVE_PROTAGONIST: this.protagonist.x else: this.tile.x
    this.sighting.y = if this.active == ACTIVE_PROTAGONIST: this.protagonist.y else: this.tile.y

  of ACTIVE_TILE:
    this.sighting.hide
    this.tile.isActive = false
    this.gameField.getTile(x, y).isActive = true

  else: discard

  this.active = activateType

proc getTile(this: TGameField, x, y: int = 0): TTile =
  for tile in this.tiles:
    if tile.x == x and tile.y == y and tile.kind > 0:
      return tile

  return TTile(x: x, y: y).initialization


proc getRespawnPoint(this: TGameField): TTile = 
  result = TTile(x: 0, y: 0).initialization

  for tile in this.tiles:
    if tile.kind in {TYPE_RESPAWN}:
      result = tile
      break


proc getOffsetArrow(this: TGameDispatcher, direction: uint32, arrow: TTile): int = 
  result = -1


  while true:
    case direction
    of DIRECTION_LEFT:
      if arrow.kind notin {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}:
        result = arrow.x
        break

      if result == -1:
        result = arrow.x - SCALE

      if this.gameField.getTile(result, arrow.y).kind notin {TYPE_NIL}:
        result += SCALE
        break
      else:
        result -= SCALE

    of DIRECTION_RIGHT:
      if arrow.kind notin {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}:
        result = arrow.x
        break

      if result == -1:
        result = arrow.x + SCALE

      if this.gameField.getTile(result, arrow.y).kind notin {TYPE_NIL}:
        result -= SCALE
        break
      else:
        result += SCALE

    of DIRECTION_TOP:
      if arrow.kind notin {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}:
        result = arrow.y
        break

      if result == -1:
        result = arrow.y - SCALE

      if this.gameField.getTile(arrow.x, result).kind notin {TYPE_NIL}:
        result += SCALE
        break
      else:
        result -= SCALE

    of DIRECTION_BOTTOM:
      if arrow.kind notin {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}:
        result = arrow.y
        break

      if result == -1:
        result = arrow.y + SCALE

      if this.gameField.getTile(arrow.x, result).kind notin {TYPE_NIL}:
        result -= SCALE
        break
      else:
        result += SCALE

    else: discard


proc isCollision(this: TGameDispatcher, gameObjectType: uint32 = TYPE_PROTAGONIST, x, y: int = 0): bool = 
  if gameObjectType in {TYPE_PROTAGONIST}:
    result = this.gameField.getTile(x, y).kind in {TYPE_NIL, TYPE_TILE_WALL}


proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var 
    self = this.protagonist
    offset = 0
    stepTile = this.gameField.getTile(self.x, self.y)


  proc protagonistMove(direction: uint32, offset: int, isAnim: bool = false) = 
    if isAnim:
      case direction
      of DIRECTION_TOP: self.playAnim(ANIM_PROTAGONIST_TOP)
      of DIRECTION_BOTTOM: self.playAnim(ANIM_PROTAGONIST_BOTTOM)
      of DIRECTION_LEFT: self.playAnim(ANIM_PROTAGONIST_LEFT)
      of DIRECTION_RIGHT: self.playAnim(ANIM_PROTAGONIST_RIGHT)
      else: discard

    self.isMoving = true
    self.direction = direction
    self.offsetStop = offset
    self.dy = SCALE div (if isAnim: ANIM_OFFSET_PROTAGONIST else: ANIM_OFFSET_SIGHTING)
    self.dx = SCALE div (if isAnim: ANIM_OFFSET_PROTAGONIST else: ANIM_OFFSET_SIGHTING)

  proc arrowMove(direction: uint32, offset: int) = 
    stepTile.isMoving = true
    stepTile.direction = direction
    stepTile.offsetStop = offset
    stepTile.dx = SCALE div ANIM_OFFSET_SIGHTING
    stepTile.dy = SCALE div ANIM_OFFSET_SIGHTING

  if not self.isMoving:

    case key
    of K_UP, K_W:
      offset = self.y - SCALE

      let isntCollision = self.y > 0 and not this.isCollision(TYPE_PROTAGONIST, self.x, offset)

      if stepTile.kind in {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}:

        protagonistMove(DIRECTION_TOP, this.getOffsetArrow(DIRECTION_TOP, stepTile))
        arrowMove(DIRECTION_TOP, this.getOffsetArrow(DIRECTION_TOP, stepTile))

        if isntCollision: 
          protagonistMove(DIRECTION_TOP, offset, true)

      elif isntCollision: 
        protagonistMove(DIRECTION_TOP, offset, true)

    of K_DOWN, K_S:
      offset = self.y + SCALE

      let isntCollision = self.y < SCREEN_HEIGHT - SCALE and not this.isCollision(TYPE_PROTAGONIST, self.x, offset)

        
      if stepTile.kind in {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}:
        protagonistMove(DIRECTION_BOTTOM, this.getOffsetArrow(DIRECTION_BOTTOM, stepTile))
        arrowMove(DIRECTION_BOTTOM, this.getOffsetArrow(DIRECTION_BOTTOM, stepTile))

        if isntCollision: protagonistMove(DIRECTION_BOTTOM, offset, true)

      elif isntCollision: protagonistMove(DIRECTION_BOTTOM, offset, true)

    of K_LEFT, K_A:
      offset = self.x - SCALE

      let isntCollision = self.x > 0 and not this.isCollision(TYPE_PROTAGONIST, offset, self.y)


      if stepTile.kind in {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}:

        protagonistMove(DIRECTION_LEFT, this.getOffsetArrow(DIRECTION_LEFT, stepTile))
        arrowMove(DIRECTION_LEFT, this.getOffsetArrow(DIRECTION_LEFT, stepTile))

        if isntCollision: protagonistMove(DIRECTION_LEFT, offset, true)

      elif isntCollision: protagonistMove(DIRECTION_LEFT, offset, true)

    of K_RIGHT, K_D:
      offset = self.x + SCALE

      let isntCollision = self.x < SCREEN_WIDTH - SCALE and not this.isCollision(TYPE_PROTAGONIST, offset, self.y)


      if stepTile.kind in {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}:

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
      if this.active in {ACTIVE_PROTAGONIST, ACTIVE_TILE}:
        this.activate(ACTIVE_SIGHTING)

      elif this.active in {ACTIVE_SIGHTING} and this.gameField.getTile(this.sighting.x, this.sighting.y).kind in {TYPE_ALEFT, TYPE_ARIGHT, TYPE_ATOP, TYPE_ABOTTOM, TYPE_AHORIZONTAL, TYPE_AVERTICAL, TYPE_AALL}:

        if this.protagonist.x == this.sighting.x and this.protagonist.y == this.sighting.y:
          this.active = ACTIVE_PROTAGONIST
          this.sighting.isDraw = false

        elif this.tile == nil:
          this.active = ACTIVE_TILE
          this.gameField.getTile(this.sighting.x, this.sighting.y).isActive = true
          this.sighting.isDraw = false

        elif this.tile != nil:
          this.tile.isActive = false

          this.active = ACTIVE_TILE
          this.gameField.getTile(this.sighting.x, this.sighting.y).isActive = true
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