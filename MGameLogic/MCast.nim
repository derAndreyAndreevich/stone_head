import 
  catty.gameobjects,  
  MGameObjects.MGameObject

proc toCattyGameObject*(this: TProtagonist): TCattyGameObject = cast[TCattyGameObject](this)
proc asProtagonist*(this: TCattyGameObject): TProtagonist = cast[TProtagonist](this)

proc toCattyGameObject*(this: TGameField): TCattyGameObject = cast[TCattyGameObject](this)
proc asGameField*(this: TCattyGameObject): TGameField = cast[TGameField](this)

proc toCattyGameObject*(this: TTile): TCattyGameObject = cast[TCattyGameObject](this)
proc asTile*(this: TCattyGameObject): TTile = cast[TTile](this)
