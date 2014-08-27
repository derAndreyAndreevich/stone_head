import sdl, macros, strutils

const
  N* = 30
  M* = 20
  SCALE* = 25
  SCREEN_WIDTH* = N * SCALE
  SCREEN_HEIGHT* = M * SCALE
  APPLICATON_DELAY* = 100

type
  TDirectionType* = enum drNil, drNorth, drEast, drSouth, drWest
  TTileType* = enum tlNil, tlMain, tlWall, tlLeftArrow
  TGameObjectType* = enum gtNil, gtGameField, gtProtagonist


type 
  TGameObjectType* = enum
    gtNil, gtGameField, gtProtagonist, gtMainTile, gtWallTile, gtLeftArrowTile, gtRightArrowTile, gtTopArrowTile, gtBottomArrowTile, gtHorizontalArrowTile, gtVerticalArrowTile, gtFullArrowTile

  EDireciton* = enum
    drNil, drNorth, drEast, drSouth, drWest

  ETile* = enum 
    tlNil, tlMain, tlWall, tlLeftArrow, tlRightArrow, tlTopArrow, tlBottomArrow, tlHorizontalArrow, tlVerticalArrow, tlFullArrow

  TGameObject = ref object of TObject
    kind: TGameObjectType
    obj: ptr TObject

  TGameObjects* = ref object of TObject
    gameObjects: seq[TGameObject]

var
  currentMap*: seq[tuple[x, y: int, tileType: ETile]] = @[]
  gameObjects* = TGameObjects(gameObjects: @[])

proc getMapElement*(x, y: int): tuple[x, y: int, tileType: ETile] = 
  for element in currentMap:
    if element.x == x and element.y == y:
      return element


# import
#   MGameObjects.MGameField,
#   MGameObjects.MProtagonist,
#   MGameObjects.MTiles


template to_concrete_game_object*(name: expr) {.immediate.} =
  proc `to name`(this: TGameObject): `T name` = cast[`T name`](this.obj)

template to_game_object*(name: string) {.immediate.} =
  proc toGameObject(this: `T name`): TGameObject = TGameObject(kind: `gt name`, obj: cast[ptr TObject](this))

# GameObjectTo GameField
# GameObjectTo Protagonist

# GameObjectAs GameField
# GameObjectAs Protagonist

macro part*(head: expr, body: stmt): stmt =
  echo head



proc add*(this: TGameObjects, o: TGameField|TProtagonist): TGameObjects {.discardable.} =
  if o is TGameField:
    this.gameObjects.add(o.asGameField)
  elif o is TProtagonist:
    this.gameObjects.add(o.asProtagonist)

  return gameObjects

proc draw*(this: TGameObjects) =
  or 
  for gameObject in this.gameObjects:

    if gameObject.kind == gtGameField:
      gameObject.toGameField.draw()
    elif gameObject.kind == gtProtagonist:
      gameObject.toProtagonist.draw()

proc update*(this: TGameObjects) =
  for gameObject in this.gameObjects:
    if gameObject.kind == gtGameField:
      gameObject.toGameField.update()
    elif gameObject.kind == gtProtagonist:
      gameObject.toProtagonist.update()

import macros, strutils, sdl

macro class2*(head: expr, body: stmt): stmt {.immediate.} =
  # The macro is immediate so that it doesn't
  # resolve identifiers passed to it

  var typeName, baseName: PNimrodNode
  var tname: string

  if head.kind == NnkIdent:
    # `head` is expression `typeName`
    # echo head.treeRepr
    # --------------------
    # Ident !"Animal"
    typeName = head

  elif head.kind == NnkInfix and $head[0] == "of":
    # `head` is expression `typeName of baseClass`
    # echo head.treeRepr
    # --------------------
    # Infix
    #   Ident !"of"
    #   Ident !"Animal"
    #   Ident !"TObject"
    typeName = head[1]
    baseName = head[2]

  else:
    quit "Invalide node: " & head.lispRepr

  # echo head.treeRepr

  # echo treeRepr(body)
  # --------------------
  # StmtList
  #   VarSection
  #     IdentDefs
  #       Ident !"name"
  #       Ident !"string"
  #       Empty
  #     IdentDefs
  #       Ident !"age"
  #       Ident !"int"
  #       Empty
  #   MethodDef
  #     Ident !"vocalize"
  #     Empty
  #     Empty
  #     FormalParams
  #       Ident !"string"
  #     Empty
  #     Empty
  #     StmtList
  #       StrLit ...
  #   MethodDef
  #     Ident !"age_human_yrs"
  #     Empty
  #     Empty
  #     FormalParams
  #       Ident !"int"
  #     Empty
  #     Empty
  #     StmtList
  #       DotExpr
  #         Ident !"this"
  #         Ident !"age"

  # create a new stmtList for the result
  result = newStmtList()

  # var declarations will be turned into object fields
  var recList = newNimNode(nnkRecList)

  # Iterate over the statements, adding `this: T`
  # to the parameters of functions
  for node in body.children:
    case node.kind:

      of NnkMethodDef, NnkProcDef:
        # inject `this: T` into the arguments
        let p = copyNimTree(node.params)
        p.insert(1, newIdentDefs(ident"this", typeName))
        node.params = p
        result.add(node)

      of NnkVarSection:
        # variables get turned into fields of the type.
        for n in node.children:
          recList.add(n)

      else:
        result.add(node)

  # The following prints out the AST structure:
  #
  # import macros
  # dumptree:
  #   type X = ref object of Y
  #     z: int
  # --------------------
  # TypeSection
  #   TypeDef
  #     Ident !"X"
  #     Empty
  #     RefTy
  #       ObjectTy
  #         Empty
  #         OfInherit
  #           Ident !"Y"
  #         RecList
  #           IdentDefs
  #             Ident !"z"
  #             Ident !"int"
  #             Empty

  result.insert(0,
    if baseName == nil:
      quote do:
        type `typeName` = ref object
    else:
      quote do:
        type `typeName` = ref object of `baseName`
        # type !("C" & typeName) = ref object of !("C" & baseName)
  )
  # echo result.treeRepr
  # Inspect the tree structure:
  #
  # echo result.treeRepr
  # --------------------
  # StmtList
  #   StmtList
  #     TypeSection
  #       TypeDef
  #         Ident !"Animal"
  #         Empty
  #         RefTy
  #           ObjectTy
  #             Empty
  #             OfInherit
  #               Ident !"TObject"
  #             Empty   <= We want to replace this
  #   MethodDef
  #   ...

  result[0][0][0][2][0][2] = recList

  # echo result

  # Lets inspect the human-readable version of the output
  # echo repr(result)
  # Output:
  #  type
  #    Animal = ref object of TObject
  #      name: string
  #      age: int
  #
  #  method vocalize(this: Animal): string =
  #    "..."
  #
  #  method age_human_yrs(this: Animal): int =
  #    this.age


# StmtList
#   StmtList
#     TypeSection
#       TypeDef
#         Ident !"draw"
#         Empty
#         RefTy
#           ObjectTy
#             Empty
#             OfInherit
#               Sym "TObject"
#             Empty
macro part(head: expr, body: expr): stmt {.immediate.} =
  var 
    typeName = !("T" & $head)

  echo head

  # result = newStmtList()
  result = quote do:
    type `typeName`* = ref object of TObject

    proc draw = echo "draw"

    proc update(this: TObject) = echo "update"

    proc check = discard

    case a
    of 1: echo "case 1"
    else: echo "case else"

  # for i in 0 .. < body.len:
  #   echo "---------------------------------------------"
  #   echo body[i].treeRepr
  #   echo "---------------------------------------------"

  result[1][3] = newNimNode(nnkFormalParams).add(newEmptyNode())

  result[3][3] = newNimNode(nnkFormalParams).add(
    newIdentDefs(ident("this"), ident($typeName))
  )
  # result.add(
  #   quote do: proc check = discard
  # )
  echo result.treeRepr



part Hello:
  draw:
    echo "class Hello Draw"
  update:
    echo "class Hello Update"

var nello: THello

# echo 1 is 3