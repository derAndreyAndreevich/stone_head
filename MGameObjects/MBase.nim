import sdl

type 
  EDireciton* = enum
    drNil, drNorth, drEast, drSouth, drWest

  ETile* = enum
    tNil, tMain, tWall
# template applicaton.variable*[T](t: expr, v: T): expr = 