type
  TGameObjectType* = enum 
    gtNil
    gtDispatcher
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

  TDirection* = enum
    tdTop
    tdBottom
    tdLeft
    tdRight

  TGameObject* = ref object of TObject
    kind*: TGameObjectType
    x*, y*, lx*, ly*, dx*, dy*, ldx*, ldy*: int
    w*, h*, lw*, lh*, dw*, dh*, ldw*, ldh*: int

  TGameObjectTexture* = ref object of TGameObject
    texture: string

  TGameObjectAnim* = ref object of TGameObject
    cfn*, ticks*: int
    anim*: string
    isPlay*: bool
    anims*: seq[tuple[name: string, ticks: int, textures: seq[string]]]

  TProtagonist* = ref object of TGameObject
    dx*, dy*: int
    direction*: TDirection
    currentFrameNumber*: int
    currentTextureName*: string
    isMoved*: bool
    ticks*: int