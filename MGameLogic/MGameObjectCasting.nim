import 
  MGameLogic.MGameObjects,
  MGameObjects.MProtagonistType,
  MGameObjects.MGameFieldType


proc toGameObject*(this: TProtagonist): TGameObject = cast[TGameObject](this)
proc asProtagonist*(this: TGameObject): TProtagonist = cast[TProtagonist](this)

proc toGameObject*(this: TGameField): TGameObject = cast[TGameObject](this)
proc asGameField*(this: TGameObject): TGameField = cast[TGameField](this)
