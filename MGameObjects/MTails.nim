import sdl, dynobj, MBase

import 
  catty.core.application, 
  catty.core.graphics, 
  catty.core.utils

type TMainTile* = ref object of TObject
  x*, y*: int

proc checkEvent*(this: TMainTile, event: var sdl.TEvent) = 
  case event.kind
  of KEYDOWN:
    case evKeyboard(addr event).keysym.sym
    of K_UP: 
      echo "MainTail keydown: <UP>"
    of K_RIGHT:
      echo "MainTail keydown: <RIGHT>"
    of K_DOWN:
      echo "MainTail keydown: <DOWN>"
    of K_LEFT:
      echo "MainTail keydown: <LEFT>"
    else: discard
  else: discard

proc update*(this: TMainTile) = 
  discard

proc draw*(this: TMainTile) = 
  # this.fillColor.glColor()
  "#292967".glColor()
  
  glRect(
    this.x * v["SCALE"].asInt, 
    this.y * v["SCALE"].asInt + 1, 
    (this.x + 1) * v["SCALE"].asInt - 1, 
    (this.y + 1) * v["SCALE"].asInt
  )


type TWallTile* = ref object of TObject
  x*, y*: int

proc checkEvent*(this: TWallTile, event: var sdl.TEvent) = 
  case event.kind
  of KEYDOWN:
    case evKeyboard(addr event).keysym.sym
    of K_UP: 
      echo "MainTail keydown: <UP>"
    of K_RIGHT:
      echo "MainTail keydown: <RIGHT>"
    of K_DOWN:
      echo "MainTail keydown: <DOWN>"
    of K_LEFT:
      echo "MainTail keydown: <LEFT>"
    else: discard
  else: discard

proc update*(this: TWallTile) = 
  discard

proc draw*(this: TWallTile) = 
  # this.fillColor.glColor()
  "#292967".glColor()
  
  glRect(
    this.x * v["SCALE"].asInt, 
    this.y * v["SCALE"].asInt + 1, 
    (this.x + 1) * v["SCALE"].asInt - 1, 
    (this.y + 1) * v["SCALE"].asInt
  )
