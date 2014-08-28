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

import MGameLogic.MBase

macro part(head: expr, body: expr): stmt {.immediate.} =
  var 
    typeName = !("T" & $head)
    gameObjectType = !("gt" & $head)
    toName = !("to" & $head)
    checkEventStmt = newStmtList()

  result = quote do:

    type `typeName`* = ref object of TObject
      value: bool

    proc draw(this: `typeName`) = discard

    proc update(this: `typeName`) = discard

    proc checkEvent(this: `typeName`, event: var sdl.TEvent) = discard

    proc asGameObject(this: `typeName`): TGameObject = TGameObject(kind: `gameObjectType`, node: cast[ptr TObject](this))
    proc `toName`(this: TGameObject): `typeName` = cast[`typeName`](this.node)
    true

  for node in body.children:
    if node.kind == nnkCall and toLower($node[0]) == "draw":
      result[1][6] = node[1][6]
    elif node.kind == nnkCall and toLower($node[0]) == "update":
      result[2][6] = node[1][6]
    elif node.kind == nnkCommand and toLower($node[0]) == "on":
      echo newIfStmt((infix(
        infix(
          newDotExpr(ident"event", ident"kind"), 
          "==", 
          newDotExpr(ident"sdl", ident"KEYDOWN")), 
        "and",
        infix(
          newDotExpr(
            newDotExpr(
              newCall(ident"evKeyboard", newNimNode(nnkAddr).add(ident"event")),
              ident"keysym"),
            ident"sym"),
          "==",
          newDotExpr(ident"sdl", ident"K_UP")
        )
      ), node[2][6])).treeRepr

      result[3][6] = checkEventStmt

part Hello:
  var
    running: bool
  draw:
    echo "andreysh: draw"
  update:
    echo "andreysh: update"
  on keydown up:
    echo "andreysh: on keydown up"

var hello: THello = THello()
true

hello.draw()
hello.update()