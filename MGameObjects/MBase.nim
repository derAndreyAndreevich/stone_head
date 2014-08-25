import sdl

type 
  EDireciton* = enum
    drNil, drNorth, drEast, drSouth, drWest

  ETile* = enum 
    tlNil, tlMain, tlWall, tlLeftArrow, tlRightArrow, tlTopArrow, tlBottomArrow, tlHorizontalArrow, tlVerticalArrow, tlFullArrow