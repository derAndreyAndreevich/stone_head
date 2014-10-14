import sdl, sequtils, opengl, strutils

import catty.core

import
  MGameLogic.MGlobal,
  MProtagonistType

proc getCurrentTextureName(this: TProtagonist): string = 
  let direction = $this.direction

  result = "protagonist-" + direction[2..direction.len()].toLower() + "-" + this.currentFrameNumber

# proc getX(this: TProtagonist): int


proc onKeyDown*(this: TProtagonist, key: sdl.TKey) =
  if not this.isMoved:
    case key
    of k_up, k_w: 
      if this.y > 0: 
        this.direction = pdTop
        this.isMoved = true
    of k_down, k_s: 
      if this.y < M - 1: 
        this.direction = pdBottom
        this.isMoved = true
    of k_left, k_a: 
      if this.x > 0: 
        this.direction = pdLeft
        this.isMoved = true
    of k_right, k_d: 
      if this.x < N - 1: 
        this.direction = pdRight
        this.isMoved = true
    else: discard

proc onKeyUp*(this: TProtagonist, key: sdl.TKey) = discard
proc onKeyIsPressed(this: TProtagonist, key: sdl.TKey) = discard

proc draw*(this: TProtagonist) =
  let
    dx = if this.direction in {pdRight, pdLeft}: this.currentFrameNumber * (64 div 6) else: 0
    dy = if this.direction in {pdTop, pdBottom}: this.currentFrameNumber * (64 div 6) else: 0
    x1 = (this.x * SCALE) + (if this.direction == pdLeft: -1 * dx else: dx)
    y1 = (this.y * SCALE) + (if this.direction == pdTop: -1 * dy else: dy)
    x2 = ((this.x + 1) * SCALE) + (if this.direction == pdLeft: -1 * dx else: dx)
    y2 = ((this.y + 1) * SCALE) + (if this.direction == pdTop: -1 * dy else: dy)

  glBindTexture(GL_TEXTURE_2D, application.getTexture(this.getCurrentTextureName()))
  glRectTexture(x1, y1, x2, y2)

proc update*(this: TProtagonist) =
  if this.isMoved and getTicks() - this.ticks > 80:
    inc this.currentFrameNumber
    this.ticks = getTicks()

    case this.direction
    of pdLeft: this.dx = this.currentFrameNumber * (64 div 6) * -1
    of pdRight: this.dx = this.currentFrameNumber * (64 div 6)
    of pdTop: this.dy = this.currentFrameNumber *  (64 div 6) * -1
    of pdBottom: this.dy = this.currentFrameNumber * (64 div 6)
  if this.currentFrameNumber > 5:
    this.currentFrameNumber = 0
    this.isMoved = false

    case this.direction
    of pdLeft: dec this.x
    of pdRight: inc this.x
    of pdTop: dec this.y
    of pdBottom: inc this.y