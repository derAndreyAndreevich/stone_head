import 
  catty.core.application as app, 
  catty.core.utils, 
  MGameObjects.MGameFieldType, 
  MGameObjects.MProtagonistType

const
  N* = 20
  M* = 11
  SCALE* = 25
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

type 
  TCattyGameObjectType* = enum gtNil, gtGameField, gtProtagonist
  # TCattyKeyType* = enum kdRControl, kdLControl, kdRAlt, kdLAlt
  TMapTileType* = enum mttNil, mttWall

  TCattyGameObject* = ref object of TObject
    kind*: TCattyGameObjectType
    node*: ptr TObject

var 
  cattyGameObjects*: seq[TCattyGameObject] = @[]
  # cattyKeyIsDown*: seq[TCattyKeyType] = @[]
  application* = TCattyApplication(screenWidth: 800, screenHeight: 600, clearColor: "#7C8899")