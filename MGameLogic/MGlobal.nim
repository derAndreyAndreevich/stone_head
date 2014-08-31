import MGameObjects.MGameField

const
  N* = 20
  M* = 11
  SCALE* = 25
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

type
  TGameObjectType* = enum gtGameField, gtProtagonist

  TGameObject* = ref object of TObject
    kind*: TGameObjectType
    node*: ptr TObject

var
  RCTRL*: bool
  LCTRL*: bool
  RALT*: bool
  LALT*: bool