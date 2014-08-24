import sdl, MBase, dynobj

import 
  catty.core.application, 
  catty.core.graphics, 
  catty.core.utils

type TProtagonist* = ref object of TObject
  currentDirection: EDireciton
  isMoving: bool
  moveDistantion: int 
  startTicks: int

  x*, y*: int
  fillColor*: string
  possibleDirection*: seq[EDireciton]

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

  if this.currentDirection == drNorth and this.y > 0: 
    dec this.y
  elif this.currentDirection == drEast and this.x < v["N"].asInt - 1: 
    inc this.x
  elif this.currentDirection == drSouth and this.y < v["M"].asInt - 1: 
    inc this.y
  elif this.currentDirection == drWest and this.x > 0: 
    dec this.x

  this.currentDirection = drNil

proc draw*(this: TProtagonist) =
  this.fillColor.glColor()

  glRect(
    this.x * v["SCALE"].asInt, 
    this.y * v["SCALE"].asInt + 1, 
    (this.x + 1) * v["SCALE"].asInt - 1, 
    (this.y + 1) * v["SCALE"].asInt
  )
