# import catty.mcore.mapplication
import catty.core

import 
  MGameObjects.MGameFieldType, 
  MGameObjects.MProtagonistType

const
  N* = 20
  M* = 11
  SCALE* = 25
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

var
  application* = TCattyApplication(screenWidth: 800, screenHeight: 600, clearColor: "#7C8899")