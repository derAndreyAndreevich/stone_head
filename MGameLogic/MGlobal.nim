# import catty.mcore.mapplication
import opengl
import catty.core

import 
  MGameObjects.MGameFieldType, 
  MGameObjects.MProtagonistType

const
  N* = 20
  M* = 11
  SCALE* = 64
  SCREEN_WIDTH* = SCALE * N
  SCREEN_HEIGHT* = SCALE * M

var
  application* = TCattyApplication(screenWidth: SCREEN_WIDTH, screenHeight: screenHeight, clearColor: "#7C8899")
  texture*: uint32