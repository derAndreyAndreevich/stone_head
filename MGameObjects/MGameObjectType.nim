type
  TGameObjectType* = enum 
    gtNil
    gtGameField
    gtProtagonist
    gtTile
    gtTileWall
    gtTileArrowTop
    gtTileArrowBottom
    gtTileArrowLeft
    gtTileArrowRight
    gtTileArrowVertical
    gtTileArrowHorizontal

  TGameObject* = ref object of TObject
    kind*: TGameObjectType