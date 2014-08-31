import MGameObjects.MGameField

const
  N* = 20
  M* = 11
  SCALE* = 25
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

type
  TCattyGameObjectType* = enum gtGameField, gtProtagonist

  TCattyGameObject* = ref object of TObject
    kind*: TGameObjectType
    node*: ptr TObject

  TCattyKeyIsDown* = enum kdRControl, kdLControl, kdRAlt, kdLAlt

var
  cattyKeyIsDown*: seq[TKeyIsDown] = @[]
