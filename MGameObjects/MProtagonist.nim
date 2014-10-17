import sdl
import catty.core, catty.gameobjects as MCattyGameObjects

import
  MGameObject,
  MGameLogic.MGlobal

proc initialization*(this: TProtagonist): TProtagonist {.discardable.} = 

  cast[TCattyGameObject](this).initialization


  this.kind = TYPE_PROTAGONIST

  this.isDraw = true
  this.isUpdate = true
  this.isActive = true

  this.x = 6
  this.y = 6
  this.w = SCALE
  this.h = SCALE
  this.direction = DIRECTION_BOTTOM
  this.texture = application.getTexture("protagonist-" + this.direction + "-0")
  this.sleep = 80

  this.anims.add(@[
    ("top", @[
      application.getTexture("protagonist-1-0"),
      application.getTexture("protagonist-1-1"),
      application.getTexture("protagonist-1-2"),
      application.getTexture("protagonist-1-3"),
      application.getTexture("protagonist-1-4"),
      application.getTexture("protagonist-1-5"),
    ], 0),
    ("bottom", @[
      application.getTexture("protagonist-2-0"),
      application.getTexture("protagonist-2-1"),
      application.getTexture("protagonist-2-2"),
      application.getTexture("protagonist-2-3"),
      application.getTexture("protagonist-2-4"),
      application.getTexture("protagonist-2-5"),
    ], 0),
    ("left", @[
      application.getTexture("protagonist-3-0"),
      application.getTexture("protagonist-3-1"),
      application.getTexture("protagonist-3-2"),
      application.getTexture("protagonist-3-3"),
      application.getTexture("protagonist-3-4"),
      application.getTexture("protagonist-3-5"),
    ], 0),
    ("rigth", @[
      application.getTexture("protagonist-4-0"),
      application.getTexture("protagonist-4-1"),
      application.getTexture("protagonist-4-2"),
      application.getTexture("protagonist-4-3"),
      application.getTexture("protagonist-4-4"),
      application.getTexture("protagonist-4-5"),
    ], 0)
  ])

  return this

proc draw*(this: TProtagonist) =
  cast[TCattyGameObject](this).draw
