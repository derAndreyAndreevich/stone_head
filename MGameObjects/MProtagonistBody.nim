import sdl, sequtils, opengl

import catty.core

import
  MGameLogic.MGlobal,
  MProtagonistType

proc onKeyDown*(this: TProtagonist, key: sdl.TKey) =
  case key
  of k_up, k_w: 
    if this.y > 0: dec this.y
  of k_down, k_s: 
    if this.y < M - 1: inc this.y
  of k_left, k_a: 
    if this.x > 0: dec this.x
  of k_right, k_d: 
    if this.x < N - 1: inc this.x
  else: discard

proc onKeyUp*(this: TProtagonist, key: sdl.TKey) = discard
proc onKeyIsPressed(this: TProtagonist, key: sdl.TKey) = discard

proc draw*(this: TProtagonist) =
  glBindTexture(GL_TEXTURE_2D, application.getTexture("protagonist-left-1"))
  glRectTexture(this.x * SCALE, this.y * SCALE, (this.x + 1) * SCALE, (this.y + 1) * SCALE)
  # this.fillColor.glColor()
  # glRect(this.x * SCALE, this.y * SCALE + 1, (this.x + 1) * SCALE - 1, (this.y + 1) * SCALE)

proc update(this: TProtagonist) = discard