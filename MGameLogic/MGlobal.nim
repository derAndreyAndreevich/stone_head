import MGameObjects.MGameField

const
  N* = 30
  M* = 20
  SCALE* = 25
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

type
  TGameObjectType* = enum gtGameField, gtProtagonist

  TGameObject* = ref object of TObject
    kind*: TGameObjectType
    node*: ptr TObject

