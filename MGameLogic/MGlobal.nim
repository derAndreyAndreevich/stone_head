import sdl, macros, strutils

const
  N* = 30
  M* = 20
  SCALE* = 25
  SCREEN_WIDTH* = N * SCALE
  SCREEN_HEIGHT* = M * SCALE
  APPLICATON_DELAY* = 100

type
  TDirectionType* = enum drNil, drNorth, drEast, drSouth, drWest
  TTileType* = enum tlNil, tlMain, tlWall, tlLeftArrow
  TGameObjectType* = enum gtNil, gtGameField, gtProtagonist


type 
  TGameObjectType* = enum
    gtNil, gtGameField, gtProtagonist, gtMainTile, gtWallTile, gtLeftArrowTile, gtRightArrowTile, gtTopArrowTile, gtBottomArrowTile, gtHorizontalArrowTile, gtVerticalArrowTile, gtFullArrowTile

  EDireciton* = enum
    drNil, drNorth, drEast, drSouth, drWest

  ETile* = enum 
    tlNil, tlMain, tlWall, tlLeftArrow, tlRightArrow, tlTopArrow, tlBottomArrow, tlHorizontalArrow, tlVerticalArrow, tlFullArrow

  TGameObject* = ref object of TObject
    kind*: TGameObjectType
    obj*: ptr TObject

  TGameObjects* = ref object of TObject
    gameObjects: seq[TGameObject]

var
  currentMap*: seq[tuple[x, y: int, tileType: ETile]] = @[]
  gameObjects* = TGameObjects(gameObjects: @[])

proc getMapElement*(x, y: int): tuple[x, y: int, tileType: ETile] = 
  for element in currentMap:
    if element.x == x and element.y == y:
      return element


# import
#   MGameObjects.MGameField,
#   MGameObjects.MProtagonist,
#   MGameObjects.MTiles


<<<<<<< HEAD
template GameObjectTo(name: expr) =
  echo "totot"
  proc `to name`(this: TGameObject): `T name` = cast[`T name`](this.obj)

# template GameObjectAs(name: expr) =
#   echo "aoaoao"
#   proc `as name`(this: `T name`): TGameObject = TGameObject(kind: `gt name`, obj: cast[ptr TObject](this))

=======
template to_concrete_game_object*(name: expr) {.immediate.} =
  proc `to name`(this: TGameObject): `T name` = cast[`T name`](this.obj)

template to_game_object*(name: string) {.immediate.} =
  proc toGameObject(this: `T name`): TGameObject = TGameObject(kind: `gt name`, obj: cast[ptr TObject](this))

# GameObjectTo GameField
# GameObjectTo Protagonist
>>>>>>> 22e452b82da3f1cc626ca4ce2c4716fc4a62d8f7

# GameObjectAs GameField
# GameObjectAs Protagonist

<<<<<<< HEAD
# GameObjectAs GameField
# GameObjectAs Protagonist
=======
macro part*(head: expr, body: stmt): stmt =
  echo head

>>>>>>> 22e452b82da3f1cc626ca4ce2c4716fc4a62d8f7

# proc asGameField(this: TGameField): TGameObject = TGameObject(kind: gtGameField, obj: cast[ptr TObject](this))
# proc asProtagonist(this: TProtagonist): TGameObject = TGameObject(kind: gtProtagonist, obj: cast[ptr TObject](this))
proc asGameField*(this: TGameField): TGameObject = TGameObject(kind: gtGameField, obj: cast[ptr TObject](this))

proc add*(this: TGameObjects, o: TGameField|TProtagonist): TGameObjects {.discardable.} =
  if o is TGameField:
    this.gameObjects.add(o.asGameField)
  elif o is TProtagonist:
    this.gameObjects.add(o.asProtagonist)

  return gameObjects

proc draw*(this: TGameObjects) =
  or 
  for gameObject in this.gameObjects:

    if gameObject.kind == gtGameField:
      gameObject.toGameField.draw()
    elif gameObject.kind == gtProtagonist:
      gameObject.toProtagonist.draw()

proc update*(this: TGameObjects) =
  for gameObject in this.gameObjects:
    if gameObject.kind == gtGameField:
      gameObject.toGameField.update()
    elif gameObject.kind == gtProtagonist:
      gameObject.toProtagonist.update()
