import 
  MGameObjectType

type TGameField* = ref object of TGameObject
  fillColor*: string
  tiles*: seq[TGameObject]
