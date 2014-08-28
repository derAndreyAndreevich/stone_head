# import macros, strutils, sdl
# import MGameLogic.MBase

# macro part(head: expr, body: expr): stmt {.immediate.} =
#   var 
#     typeName = !("T" & $head)
#     gameObjectType = !("gt" & $head)
#     toName = !("to" & $head)
#     checkEventStmt = newStmtList()

#   result = quote do:

#     type `typeName`* = ref object of TObject
#       value: bool

#     proc draw(this: `typeName`) = discard

#     proc update(this: `typeName`) = discard

#     proc checkEvent(this: `typeName`, event: var sdl.TEvent) = discard

#     proc asGameObject(this: `typeName`): TGameObject = TGameObject(kind: `gameObjectType`, node: cast[ptr TObject](this))
#     proc `toName`(this: TGameObject): `typeName` = cast[`typeName`](this.node)
#     true

#   for node in body.children:
#     if node.kind == nnkCall and toLower($node[0]) == "draw":
#       result[1][6] = node[1][6]
#     elif node.kind == nnkCall and toLower($node[0]) == "update":
#       result[2][6] = node[1][6]
#     elif node.kind == nnkCommand and toLower($node[0]) == "on":
#       echo newIfStmt((infix(
#         infix(
#           newDotExpr(ident"event", ident"kind"), 
#           "==", 
#           newDotExpr(ident"sdl", ident"KEYDOWN")), 
#         "and",
#         infix(
#           newDotExpr(
#             newDotExpr(
#               newCall(ident"evKeyboard", newNimNode(nnkAddr).add(ident"event")),
#               ident"keysym"),
#             ident"sym"),
#           "==",
#           newDotExpr(ident"sdl", ident"K_UP")
#         )
#       ), node[2][6])).treeRepr

#       result[3][6] = checkEventStmt

# part Hello:
#   var
#     running: bool
#   draw:
#     echo "andreysh: draw"
#   update:
#     echo "andreysh: update"
#   on keydown up:
#     echo "andreysh: on keydown up"

# var hello: THello = THello()


# hello.draw()
# hello.update()