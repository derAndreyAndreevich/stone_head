import 
  opengl,
  catty.core, catty.gameobjects as MCattyGameObjects,
  MGameObjects.MGameObject

const
  N* = 20
  M* = 11
  SCALE* = 64
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

type
  TGameObjects = seq[TCattyGameObject]

var
  application* = TCattyApplication(screenWidth: SCREEN_WIDTH, screenHeight: screenHeight, clearColor: "#000000")
  gameObjects*: TGameObjects = @[]