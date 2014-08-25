import 
  MGameObjects.MBase


const
  N* = 30
  M* = 20
  SCALE* = 25
  SCREEN_WIDTH* = N * SCALE
  SCREEN_HEIGHT* = M * SCALE
  APPLICATON_DELAY* = 30


var
  currentMap*: seq[tuple[x, y: int, tileType: ETile]] = @[]


proc getMapElement*(x, y: int): tuple[x, y: int, tileType: ETile] = 
  for element in currentMap:
    if element.x == x and element.y == y:
      return element
