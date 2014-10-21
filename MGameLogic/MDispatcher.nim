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


# proc activeType(this: TGameDispatcher): TActiveType = this.__activeType
# proc `activeType=`(this: TGameDispatcher, value: TActiveType) = this.__activeType = value


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
      if tile.kind in {TYPE_ATOP, TYPE_ABOTTOM, TYPE_ALEFT, TYPE_ARIGHT, TYPE_AVERTICAL, TYPE_AHORIZONTAL} and tile.isActive:
         return tile

proc sighting(this: TGameDispatcher): TSighting =
  for go in global.gameObjects:
    case go.kind
    of TYPE_SIGHTING: return go.asSighting
    else: discard

proc getTile(this: TGameField, x, y: int = 0): TTile =
  result = TTile(x: x, y: y).initialization

  for tile in this.tiles:
    if tile.x == x and tile.y == y:
      result = tile

proc getOffsetArrow(this: TGameDispatcher, arrow: TTile): int = 
  result = -1

  if arrow.kind in {TYPE_ALEFT}:
    while true:
      if result == -1:
        result = arrow.x - SCALE

      if this.gameField.getTile(result, arrow.y).kind notin {TYPE_NIL}:
        result += SCALE
        break
      else:
        result -= SCALE


proc isCollision(this: TGameDispatcher, gameObjectType: uint32 = TYPE_PROTAGONIST, x, y: int = 0): bool = 
  if gameObjectType in {TYPE_PROTAGONIST}:
    result = this.gameField.getTile(x, y).kind in {TYPE_NIL, TYPE_TILE_WALL}

proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var 
    self = this.protagonist
    offset = 0

  let 
    stepTile = this.gameField.getTile(self.x, self.y)

  proc protagonistMove(direction: uint32, offset: int) = 
    case direction
    of DIRECTION_TOP: self.playAnim(ANIM_PROTAGONIST_TOP)
    of DIRECTION_BOTTOM: self.playAnim(ANIM_PROTAGONIST_BOTTOM)
    of DIRECTION_LEFT: self.playAnim(ANIM_PROTAGONIST_LEFT)
    of DIRECTION_RIGHT: self.playAnim(ANIM_PROTAGONIST_RIGHT)
    else: discard

    self.isMoving = true
    self.direction = direction
    self.offsetStop = offset
    self.dy = SCALE div ANIM_OFFSET_PROTAGONIST

  proc arrowMove(direction: uint32, offset: int) = 
    stepTile.isMoving = true
    stepTile.direction = direction
    stepTile.offsetStop = offset
    stepTile.dx = SCALE div ANIM_OFFSET_SIGHTING

  if not self.isMoving:

    case key
    of K_UP, K_W:
      offset = self.y - SCALE

      let protagonistIsCollision = self.y > 0 and not this.isCollision(TYPE_PROTAGONIST, self.x, offset)

      if stepTile.kind in {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}:

        protagonistMove(DIRECTION_TOP, this.getOffsetArrow(stepTile))
        arrowMove(DIRECTION_TOP, this.getOffsetArrow(stepTile))

        if not protagonistIsCollision: protagonistMove(DIRECTION_TOP, offset)

      elif not protagonistIsCollision: protagonistMove(DIRECTION_TOP, offset)

    of K_DOWN, K_S:
      offset = self.y + SCALE

      let protagonistIsCollision = self.y < SCREEN_HEIGHT - SCALE and not this.isCollision(TYPE_PROTAGONIST, self.x, offset)

        
      if stepTile.kind in {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}:
        protagonistMove(DIRECTION_BOTTOM, this.getOffsetArrow(stepTile))
        arrowMove(DIRECTION_BOTTOM, this.getOffsetArrow(stepTile))

        if not protagonistIsCollision: protagonistMove(DIRECTION_BOTTOM, offset)

      elif not protagonistIsCollision: protagonistMove(DIRECTION_BOTTOM, offset)

    of K_LEFT, K_A:
      offset = self.x - SCALE

      let protagonistIsCollision = self.x > 0 and not this.isCollision(TYPE_PROTAGONIST, offset, self.y)


      if stepTile.kind in {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}:

        stepTile.isMoving = true
        stepTile.direction = DIRECTION_LEFT
        stepTile.offsetStop = this.getOffsetArrow(stepTile)
        stepTile.dx = SCALE div ANIM_OFFSET_SIGHTING

        self.offsetStop = stepTile.offsetStop
        self.isMoving = true
        self.direction = DIRECTION_LEFT
        self.dx = SCALE div ANIM_OFFSET_SIGHTING

        if protagonistIsCollision: protagonistToLeft()

      elif protagonistIsCollision: protagonistToLeft()

    of K_RIGHT, K_D:
      offset = self.x + SCALE

      let protagonistIsntCollision = self.x < SCREEN_WIDTH - SCALE and not this.isCollision(TYPE_PROTAGONIST, offset, self.y)

      proc protagonistToRigth() = 
        self.isMoving = true
        self.playAnim(ANIM_PROTAGONIST_RIGHT)
        self.direction = DIRECTION_RIGHT
        self.offsetStop = offset
        self.dx = SCALE div ANIM_OFFSET_PROTAGONIST
        

      if stepTile.kind in {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}:
        stepTile.isMoving = true
        stepTile.direction = DIRECTION_RIGHT
        stepTile.offsetStop = this.getOffsetArrow(stepTile)
        stepTile.dx = SCALE div ANIM_OFFSET_SIGHTING

        self.offsetStop = stepTile.offsetStop
        self.isMoving = true
        self.direction = DIRECTION_RIGHT
        self.dx = SCALE div ANIM_OFFSET_SIGHTING

        if not protagonistIsntCollision: protagonistToRigth()

      elif not protagonistIsntCollision: protagonistToRigth()

    else: discard

    self.texture = application.getTexture("protagonist-" + self.direction + "-0")


proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) = 
  var
    self = this.tile
    offset = 0


  if not self.isMoving:
    if key in {K_LEFT, K_A} and self.kind in {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}:
      offset = this.getOffsetArrow(self)

      if self.x > 0:
        self.isMoving = true
        self.direction = DIRECTION_LEFT
        self.offsetStop = offset
        self.dx = SCALE div ANIM_OFFSET_SIGHTING


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
  return this

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  if not this.protagonist.isMoving and not this.sighting.isMoving:
    if key == K_SPACE:
      if this.active in {ACTIVE_PROTAGONIST, ACTIVE_TILE}:
        this.active = ACTIVE_SIGHTING
        this.sighting.isDraw = true
        this.sighting.x = this.protagonist.x
        this.sighting.y = this.protagonist.y

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