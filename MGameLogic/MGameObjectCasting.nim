import 
  MGameObjects.MGameObjectType,
  MGameObjects.MProtagonistType,
  MGameObjects.MGameFieldType,
  MGameObjects.MTilesType


proc toGameObject*(this: TProtagonist): TGameObject = cast[TGameObject](this)
proc asProtagonist*(this: TGameObject): TProtagonist = cast[TProtagonist](this)

proc toGameObject*(this: TGameField): TGameObject = cast[TGameObject](this)
proc asGameField*(this: TGameObject): TGameField = cast[TGameField](this)

proc toGameObject*(this: TTile): TGameObject = cast[TGameObject](this)
proc asTile*(this: TGameObject): TTile = cast[TTile](this)
