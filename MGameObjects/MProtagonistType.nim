type TProtagonistDirection* = enum pdTop, pdBottom, pdLeft, pdRight

type TProtagonist* = ref object of TObject
  x*, y*, dx*, dy*: int
  fillColor*: string
  isCollision: bool
  direction*: TProtagonistDirection
  currentFrameNumber*: int
  currentTextureName*: string
  isMoved*: bool
  ticks*: int