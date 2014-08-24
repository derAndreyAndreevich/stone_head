import sdl

type EDireciton* = enum
  drNil, drNorth, drEast, drSouth, drWest

# template applicaton.variable*[T](t: expr, v: T): expr = 