import sdl, dynobj

import
  MGameLogic.MGlobal,
  MGameLogic.MCollisions

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
  "#292967".glColor()
  
  glRect(
    this.x * SCALE, 
    this.y * SCALE + 1, 
    (this.x + 1) * SCALE - 1, 
    (this.y + 1) * SCALE
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
  "#7B5637".glColor()
  
  glRect(
    this.x * SCALE, 
    this.y * SCALE + 1, 
    (this.x + 1) * SCALE - 1, 
    (this.y + 1) * SCALE
  )

type TLeftArrow* = ref object of TObject
  x*, y*: int

proc checkEvent*(this: TLeftArrow, event: var sdl.TEvent) = 
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

proc update*(this: TLeftArrow) = 
  discard

proc draw*(this: TLeftArrow) = 
  "#48B353".glColor()
  
  glRect(
    this.x * SCALE, 
    this.y * SCALE + 1, 
    (this.x + 1) * SCALE - 1, 
    (this.y + 1) * SCALE
  )
