import macros, strutils

const
  N* = 30
  M* = 20
  SCALE* = 25
  SCREEN_WIDTH* = N * SCALE
  SCREEN_HEIGHT* = M * SCALE
  APPLICATON_DELAY* = 30

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


import 
  MGameObjects.MGameField,
  MGameObjects.MProtagonist,
  MGameObjects.MTiles


template GameObjectTo(name: expr) =
  echo "totot"
  proc `to name`(this: TGameObject): `T name` = cast[`T name`](this.obj)

# template GameObjectAs(name: expr) =
#   echo "aoaoao"
#   proc `as name`(this: `T name`): TGameObject = TGameObject(kind: `gt name`, obj: cast[ptr TObject](this))


GameObjectTo GameField
GameObjectTo Protagonist

# GameObjectAs GameField
# GameObjectAs Protagonist

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
  for gameObject in this.gameObjects:

    # gameObject.to("GameField")

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