import sdl, dynobj

import
  MGameLogic.MGlobal,
  MGameLogic.MCollisions

import 
  catty.core.application,
  catty.core.graphics, 
  catty.core.utils

type TProtagonist* = ref object of TObject
  currentDirection: TDirectionType
  isMoving: bool
  isStepArrow: bool
  moveDistantion: int 
  startTicks: int

  x*, y*: int
  fillColor*: string
  possibleDirection*: seq[TDirectionType]

proc checkEvent*(this: TProtagonist, event: var TEvent) = 
  case event.kind
  of KEYDOWN:
    case evKeyboard(addr event).keysym.sym
    of K_UP: this.currentDirection = drNorth 
    of K_RIGHT: this.currentDirection = drEast
    of K_DOWN: this.currentDirection = drSouth 
    of K_LEFT: this.currentDirection = drWest 
    else: discard
  else: discard

proc update*(this: TProtagonist) =
  # var 
  #   currentTile = getMapElement(this.x, this.y)

  # if 
  #   (not this.isStepArrow and this.currentDirection == drNorth and (this.y == 0 or getMapElement(this.x, this.y - 1).tileType in [tlWall, tlNil])) or
  #   (not this.isStepArrow and this.currentDirection == drEast  and (this.x == N or getMapElement(this.x + 1, this.y).tileType in [tlWall, tlNil])) or 
  #   (not this.isStepArrow and this.currentDirection == drSouth and (this.y == M or getMapElement(this.x, this.y + 1).tileType in [tlWall, tlNil])) or 
  #   (not this.isStepArrow and this.currentDirection == drWest  and (this.x == 0 or getMapElement(this.x - 1, this.y).tileType in [tlWall, tlNil])):

  #   this.currentDirection = drNil
  #   this.isMoving = false
  # elif 
  #   (this.isMoving and this.currentDirection == drNorth and getMapElement(this.x, this.y - 1).tileType == tlMain) or
  #   (this.isMoving and this.currentDirection == drEast  and getMapElement(this.x + 1, this.y).tileType == tlMain) or
  #   (this.isMoving and this.currentDirection == drSouth and getMapElement(this.x, this.y + 1).tileType == tlMain) or
  #   (this.isMoving and this.currentDirection == drWest  and getMapElement(this.x - 1, this.y).tileType == tlMain):

  #   this.isMoving = false
  #   this.currentDirection = drNil

  # elif this.isStepArrow and this.currentDirection == drEast and getMapElement(this.x + 1, this.y).tileType in [tlWall, tlNil]:
  #   this.currentDirection = drNil

  # case this.currentDirection
  # of drNorth: dec this.y
  # of drEast: inc this.x
  # of drSouth: inc this.y
  # of drWest: 
  #   dec this.x
  #   # if this.isMoving:
  #   #   for i in 0 .. < currentMap.len:
  #   #     if currentMap[i].x == this.x and currentMap[i].y == this.y:
  #   #       currentMap[i].x = this.x - 1
  #   #       currentMap[i].y = this.y - 1
  # else:
  #   discard

  # if this.isStepArrow:
  #   if
  #     (this.currentDirection == drNorth and currentTile.tileType in [tlTopArrow, tlVerticalArrow, tlFullArrow]) or
  #     (this.currentDirection == drEast and currentTile.tileType in [tlRightArrow, tlHorizontalArrow, tlFullArrow]) or
  #     (this.currentDirection == drSouth and currentTile.tileType in [tlBottomArrow, tlVerticalArrow, tlFullArrow]) or
  #     (this.currentDirection == drWest and currentTile.tileType in [tlLeftArrow, tlHorizontalArrow, tlFullArrow]):
  #     this.isMoving = true

  # # if not (currentTile.tileType in [tlWall, tlMain]): 
  # #   this.isStepArrow = true
  # # else:
  # #   this.isStepArrow = false

  # if not this.isMoving:
  #   this.currentDirection = drNil


proc draw*(this: TProtagonist) =
  this.fillColor.glColor()

  glRect(
    this.x * SCALE, 
    this.y * SCALE + 1, 
    (this.x + 1) * SCALE - 1, 
    (this.y + 1) * SCALE
  )
