import 
  MGameObjectType

type 
  TTile* = ref object of TGameObject
    x*, y*: int
    textureName*: string


