import sdl

type
  TGameObjectType* = enum 
    gtNil
    gtGameField
    gtProtagonist
    gtTileWall
    gtTileArrowTop
    gtTileArrowBottom
    gtTileArrowLeft
    gtTileArrowRight
    gtTileArrowVertical
    gtTileArrowHorizontal

  TGameObject* = ref object of TObject
    kind*: TGameObjectType

proc draw*(this: TGameObject) = discard
proc update*(this: TGameObject) = discard
proc onKeyDown*(this: TGameObject, key: sdl.TKey) = discard
proc onKeyUp*(this: TGameObject, key: sdl.TKey) = discard