import sdl

const 
  N* = 30
  M* = 20
  SCALE* = 25
  SCREEN_WIDTH* = N * SCALE
  SCREEN_HEIGHT* = M * SCALE
  APPLICATON_DELAY* = 100

type
  TDirectionType* = enum drNil, drNorth, drEast, drSouth, drWest
  TTileType* = enum tlNil, tlMain, tlWall, tlLeftArrow
  TGameObjectType* = enum gtNil, gtGameField, gtProtagonist

type TGameObject* = ref object of TObject
  
proc checkEvent*(this: TGameObject, event: var sdl.TEvent) = 
  case event.kind
  of KEYDOWN:
    case evKeyboard(addr event).keysym.sym
    of K_UP: 
      echo "GameObject keydown: <UP>"
    of K_RIGHT:
      echo "GameObject keydown: <RIGHT>"
    of K_DOWN:
      echo "GameObject keydown: <DOWN>"
    of K_LEFT:
      echo "GameObject keydown: <LEFT>"
    else: discard
  else: discard

proc update*(this: TGameObject) = 
  discard

proc draw*(this: TGameObject) = 
  discard

