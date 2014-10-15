import sdl

import MGameObjectType

proc initialization*(this: TGameObject) = discard
proc draw*(this: TGameObject) = discard
proc update*(this: TGameObject) = discard
proc onKeyDown*(this: TGameObject, key: sdl.TKey) = discard
proc onKeyUp*(this: TGameObject, key: sdl.TKey) = discard