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

  AALL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_ATOP, TYPE_ABOTTOM, TYPE_AHORIZONTAL, TYPE_AVERTICAL, TYPE_AVERTICAL}
  AHORIZONTAL_SET = {TYPE_ALEFT, TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}
  AVERTICAL_SET = {TYPE_ATOP, TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}
  ARIGHT_SET = {TYPE_ARIGHT, TYPE_AHORIZONTAL, TYPE_AALL}
  ALEFT_SET = {TYPE_ALEFT, TYPE_AHORIZONTAL, TYPE_AALL}
  ATOP_SET = {TYPE_ATOP, TYPE_AVERTICAL, TYPE_AALL}
  ABOTTOM_SET = {TYPE_ABOTTOM, TYPE_AVERTICAL, TYPE_AALL}

  CPROTAGONIST_SET = {TYPE_NIL, TYPE_TILE_WALL}
  CARROW_SET = AALL_SET + {TYPE_TILE_WALL, TYPE_TILE}

  # EVENT_PROTAGONIST_START_MOVE* = 1
  # EVENT_PROTAGONIST_END_MOVE* = 2
  # EVENT_PROTAGONIST_ACTIVATE* = 3
  # EVENT_PROTAGONIST_DEACTIVATE* = 4

  # EVENT_SIGHTING_START_MOVE* = 5
  # EVENT_SIGHTING_END_MOVE* = 6
  # EVENT_SIGHTING_ACTIVATE* = 7
  # EVENT_SIGHTING_DEACTIVATE* = 8

  # EVENT_TILE_ARROW_START_MOVE* = 9
  # EVENT_TILE_ARROW_END_MOVE* = 10
  # EVENT_TILE_ARROW_ACTIVATE* = 11
  # EVENT_TILE_ARROW_DEACTIVATE* = 12



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


proc ON_EVENT_PROTAGONIST_START_MOVE(this: TGameDispatcher, direction: uint32, coords, offsetStop, delta: TCattyCoords): sdl.TUserEvent =
  return sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))


proc ON_EVENT_TILE_ARROW_START_MOVE(this: TGameDispatcher, direction: uint32, coords, offsetStop, delta: TCattyCoords): sdl.TUserEvent =
  return sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_TILE_ARROW_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))

proc ON_EVENT_SIGHTING_START_MOVE(this: TGameDispatcher, direction: uint32, coords, offsetStop, delta: TCattyCoords): sdl.TUserEvent =
  return sdl.TUserEvent(kind: sdl.USEREVENT, code: EVENT_SIGHTING_START_MOVE, data1: cast[ptr TEventStartMove](TEventStartMove(
    direction: direction,
    coords: coords,
    offsetStop: offsetStop,
    delta: delta
  )))

proc ON_EVENT_PROTAGONIST_ACTIVATE(this: TGameDispatcher): TUserEvent = TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_ACTIVATE)
proc ON_EVENT_PROTAGONIST_DEACTIVATE(this: TGameDispatcher): TUserEvent = TUserEvent(kind: sdl.USEREVENT, code: EVENT_PROTAGONIST_DEACTIVATE)
proc ON_EVENT_SIGHTING_ACTIVATE(this: TGameDispatcher): TUserEvent = TUserEvent(kind: sdl.USEREVENT, code: EVENT_SIGHTING_ACTIVATE)
proc ON_EVENT_SIGHTING_DEACTIVATE(this: TGameDispatcher): TUserEvent = TUserEvent(kind: sdl.USEREVENT, code: EVENT_SIGHTING_DEACTIVATE)
proc ON_EVENT_TILE_ARROW_ACTIVATE(this: TGameDispatcher, coords: TCattyCoords): TUserEvent = TUserEvent(kind: sdl.USEREVENT, code: EVENT_TILE_ARROW_ACTIVATE, data1: cast[ptr TEventActivate](TEventActivate(x: coords.x, y: coords.y)))
proc ON_EVENT_TILE_ARROW_DEACTIVATE(this: TGameDispatcher, coords: TCattyCoords): TUserEvent = TUserEvent(kind: sdl.USEREVENT, code: EVENT_TILE_ARROW_DEACTIVATE, data1: cast[ptr TEventDeactivate](TEventDeactivate(x: coords.x, y: coords.y)))

proc onKeyDownProtagonist(this: TGameDispatcher, key: sdl.TKey) =
  var 
    isCollision: bool

  if key in {K_UP, K_W}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (0, SCALE)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ATOP_SET:
      var
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_TOP, this.gameField.tiles[this.protagonist.coords])
        d = (0, -1 * DELTA_SIGHTING)

        eventProtagonist = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_TOP, c, o, d)
        eventArrow = this.ON_EVENT_TILE_ARROW_START_MOVE(DIRECTION_TOP, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))
 
    elif not isCollision:
      this.protagonist.isStepArrow = false

      var 
        c = this.protagonist.coords
        o = this.protagonist.coords - (0, SCALE)
        d = (0, -1 * DELTA_PROTAGONIST)
        event = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_TOP, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  elif key in {K_DOWN, K_S}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (0, SCALE)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ABOTTOM_SET:
      var
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_BOTTOM, this.gameField.tiles[this.protagonist.coords])
        d = (0, DELTA_SIGHTING)

        eventProtagonist = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_BOTTOM, c, o, d)
        eventArrow = this.ON_EVENT_TILE_ARROW_START_MOVE(DIRECTION_BOTTOM, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))
    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords + (0, SCALE)
        d = (0, DELTA_PROTAGONIST)

        event = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_BOTTOM, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  elif key in {K_LEFT, K_A}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords - (SCALE, 0)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ALEFT_SET:
      var 
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_LEFT, this.gameField.tiles[this.protagonist.coords])
        d = (-1 * DELTA_SIGHTING, 0)

        eventProtagonist = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_LEFT, c, o, d)
        eventArrow = this.ON_EVENT_TILE_ARROW_START_MOVE(DIRECTION_LEFT, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords - (SCALE, 0)
        d = (-1 * DELTA_PROTAGONIST, 0)

        event = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_LEFT, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  elif key in {K_RIGHT, K_D}:
    isCollision = this.protagonist.isCollision(this.gameField.tiles[this.protagonist.coords + (SCALE, 0)])

    if this.protagonist.isStepArrow and isCollision and this.tile.kind in ARIGHT_SET:
      var 
        c = this.protagonist.coords
        o = this.getOffsetArrow(DIRECTION_RIGHT, this.gameField.tiles[this.protagonist.coords])
        d = (DELTA_SIGHTING, 0)

        eventProtagonist = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_RIGHT, c, o, d)
        eventArrow = this.ON_EVENT_TILE_ARROW_START_MOVE(DIRECTION_RIGHT, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr eventProtagonist))
      discard sdl.pushEvent(cast[sdl.PEvent](addr eventArrow))

    elif not isCollision:
      this.protagonist.isStepArrow = false

      var
        c = this.protagonist.coords
        o = this.protagonist.coords + (SCALE, 0)
        d = (DELTA_PROTAGONIST, 0)

        event = this.ON_EVENT_PROTAGONIST_START_MOVE(DIRECTION_RIGHT, c, o, d)

      discard sdl.pushEvent(cast[sdl.PEvent](addr event))

  else: discard

proc onKeyDownArrowTile(this: TGameDispatcher, key: sdl.TKey) = discard

proc onKeyDownSighting(this: TGameDispatcher, key: sdl.TKey) = discard


proc initialization*(this: TGameDispatcher): TGameDispatcher {.discardable.} = 
  this.active = ACTIVE_PROTAGONIST
  this.protagonist.coords = this.gameField.respawnTile.coords

  return this

proc onKeyDown*(this: TGameDispatcher, key: sdl.TKey) =
  case key
  of K_SPACE:
    if this.protagonist.isActive:
      this.sighting.coords = this.protagonist.coords
      this.protagonist.deactivate
      this.sighting.show.activate
    elif this.tile != nil and this.tile.isActive:
      this.sighting.coords = this.tile.coords
      this.tile.deactivate
      this.sighting.show.activate
    elif this.sighting.isActive:
      if this.sighting.coords == this.protagonist.coords:
        this.protagonist.activate
        this.sighting.hide.deactivate
      elif this.gameField.tiles[this.sighting.coords].kind in AALL_SET:
        if this.tile != nil: this.tile.deactivate
        this.gameField.tiles[this.sighting.coords].activate
        this.sighting.hide.deactivate
  else: discard

  if this.protagonist.isActive: this.onKeyDownProtagonist(key)
  elif this.sighting.isActive: this.onKeyDownSighting(key)


proc onUserEvent*(this: TGameDispatcher, event: PUserEvent) = 
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