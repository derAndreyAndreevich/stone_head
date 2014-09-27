import catty.core.utils
import MGameObjects.MGameFieldType
import MGameObjects.MProtagonistType

const
  N* = 20
  M* = 11
  SCALE* = 25
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

type 
  TCattyGameObjectType* = enum gtNil, gtGameField, gtProtagonist
  TCattyKeyType* = enum kdRControl, kdLControl, kdRAlt, kdLAlt
  TMapTileType* = enum mttNil, mttWall

  TCattyGameObject* = ref object of TObject
    kind*: TCattyGameObjectType
    node*: ptr TObject

var 
  cattyGameObjects*: seq[TCattyGameObject] = @[]
  cattyKeyIsDown*: seq[TCattyKeyType] = @[]