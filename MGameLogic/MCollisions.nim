import
  MGameLogic.MGlobal,

  MGameObjects.MProtagonist

type TCollision = ref object of TObject

# proc update*(this: TCollision) =
#   var protagonist: TProtagonist

#   for gameObject in gameObjects:
#     if gameObject.kind == TProtagonist:
#       protagonist = cast[TProtagonist](gameObject.obj)

#   echo protagonist.x, " ", protagonist.y
