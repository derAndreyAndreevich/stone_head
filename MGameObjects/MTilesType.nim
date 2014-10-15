type TTileType* = enum 
  ttNil,
  ttWall,
  ttArrowTop,
  ttArrowBottom,
  ttArrowLeft,
  ttArrowRight,
  ttArrowVertical,
  ttArrowHorizontal,
  ttArrowAll

type TTile* = ref object of TObject
  x*, y*: int
  textureName*: string
  tileType*: TTileType
