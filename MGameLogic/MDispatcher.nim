import sdl
import catty.core, catty.gameobjects as MCattyGameObjects
import 
  MGlobal as global,
  MGameObjects.MGameObject,
  MGameObjects.MGameField,
  MGameObjects.MTiles,
  MGameObjects.MProtagonist,
  MGameLogic.MCast

const
  ACTIVE_PROTAGONIST = 1
  ACTIVE_TILE = 2
  ACTIVE_SIGHTING = 3

  ANIM_OFFSET_PROTAGONIST = 8
  ANIM_OFFSET_SIGHTING = 4

  AALL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_ATOP, TYPE_ABOTTOM, TYPE_AHORIZONTAL, TYPE_AVERTICAL, TYPE_AVERTICAL}
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
        if arrow.isCollision(this.gameField.tiles[0, arrow.coords.y - SCALE]): break
        result = (0, arrow.coords.y - SCALE)
      else:
        if arrow.isCollision(this.gameField.tiles[result - (0, SCALE)]): break
        result -= (0, SCALE)

    of DIRECTION_BOTTOM:
      if arrow.kind notin ABOTTOM_SET: break

      if result == arrow.coords:
        if arrow.isCollision(this.gameField.tiles[0, arrow.coords.y + SCALE]): break
        result = (0, arrow.coords.y + SCALE)
      else:
        if arrow.isCollision(this.gameField.tiles[result + (0, SCALE)]): break
        result += (0, SCALE)

    else: discard

proc newEventStartMove(this: TGameDispatcher, direction: uint32, coords, offsetStop, delta: TCattyCoords): sdl.TUserEvent =
  return sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))

proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var 
    isCollision: bool

  if key in {K_UP, K_W}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (0, SCALE)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ATOP_SET:
      var 
        eventProtagonist, eventArrow = newEventStartMove(
          DIRECTION_TOP, 
          this.protagonist.coords,
          this.getOffsetArrow(DIRECTION_TOP, this.gameField.tiles[this.protagonist.coords]),
          (0, -1 * SCALE div ANIM_OFFSET_SIGHTING)
        )

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))
 
    elif not isCollision:
      this.protagonist.isStepArrow = false

      var 
        event = newEventStartMove(
          DIRECTION_TOP,
          this.protagonist.coords,
          this.protagonist.coords - (0, SCALE),
          (0, -1 * SCALE div ANIM_OFFSET_PROTAGONIST)
        )

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  elif key in {K_DOWN, K_S}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (0, SCALE)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ABOTTOM_SET:
      var 
        eventProtagonist, eventArrow = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords, 
          offsetStop: this.getOffsetArrow(DIRECTION_BOTTOM, this.gameField.tiles[this.protagonist.coords]), 
          delta: (0, SCALE div ANIM_OFFSET_SIGHTING),
          direction: DIRECTION_BOTTOM
        )))

        eventArrow = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_TILE_ARROW_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords,
          offsetStop: this.getOffsetArrow(DIRECTION_BOTTOM, this.gameField.tiles[this.protagonist.coords]), 
          delta: (0, SCALE div ANIM_OFFSET_SIGHTING),
          direction: DIRECTION_BOTTOM
        )))

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))
    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        event = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords, 
          offsetStop: (this.protagonist.coords.x, this.protagonist.coords.y + SCALE), 
          delta: (0, SCALE div ANIM_OFFSET_PROTAGONIST),
          direction: DIRECTION_BOTTOM
        )))

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  elif key in {K_LEFT, K_A}:
    if this.protagonist.isStepArrow and this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (SCALE, 0)]) and this.tile.kind in ALEFT_SET:
      var 
        eventProtagonist = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords, 
          offsetStop: this.getOffsetArrow(DIRECTION_LEFT, this.gameField.tiles[this.protagonist.coords]), 
          delta: (0, -1 * SCALE div ANIM_OFFSET_SIGHTING),
          direction: DIRECTION_LEFT
        )))

        eventArrow = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_TILE_ARROW_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords,
          offsetStop: this.getOffsetArrow(DIRECTION_LEFT, this.gameField.tiles[this.protagonist.coords]), 
          delta: (0, -1 * SCALE div ANIM_OFFSET_SIGHTING),
          direction: DIRECTION_LEFT
        )))

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))
    elif not this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (SCALE, 0)]):
      this.protagonist.isStepArrow = false

      var
        event = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords, 
          offsetStop: (this.protagonist.coords.x - SCALE, this.protagonist.coords.y), 
          delta: (-1 * SCALE div ANIM_OFFSET_PROTAGONIST, 0),
          direction: DIRECTION_LEFT
        )))

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  elif key in {K_RIGHT, K_D}:
    if this.protagonist.isStepArrow and this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (SCALE, 0)]) and this.tile.kind in ARIGHT_SET:
      discard
    elif not this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (SCALE, 0)]):
      this.protagonist.isStepArrow = false

      var
        event = sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
          coords: this.protagonist.coords, 
          offsetStop: (this.protagonist.coords.x + SCALE, this.protagonist.coords.y), 
          delta: (SCALE div ANIM_OFFSET_PROTAGONIST, 0),
          direction: DIRECTION_RIGHT
        )))

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  else: discard

proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) = discard

proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) = discard


proc initialization*(this: TGameDispatcher): TGameDispatcher {.discardable.} = 
  this.active = ACTIVE_PROTAGONIST
  this.protagonist.coords = this.gameField.respawnTile.coords

  return this

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  
  case this.active:
  of ACTIVE_PROTAGONIST: this.onKeyDownProtagonist(key)
  else: discard


proc onUserEvent*(this: TGameDispatcher, event: TUserEvent) = 
  case event.code
  of EVENT_PROTAGONIST_END_MOVE:

    var 
      data = cast[TEventEndMove](event.data1)
      tile = this.gameField.tiles[data.x, data.y]


    case tile.kind

    of TYPE_ALEFT, TYPE_ARIGHT, TYPE_ABOTTOM, TYPE_ATOP, TYPE_AVERTICAL, TYPE_AHORIZONTAL, TYPE_AALL: 
      this.protagonist.isStepArrow = true

      if this.tile == nil:
        tile.isActive = true
      else:
        this.tile.isActive = false
        tile.isActive = true

    else: 
      this.protagonist.isStepArrow = false

      if this.tile != nil:
        this.tile.isActive = false

  of EVENT_SIGHTING_END_MOVE: discard


  of EVENT_TILE_ARROW_END_MOVE: discard

  else: discard