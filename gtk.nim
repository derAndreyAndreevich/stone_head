import gdk2, glib2, gtk2, macros, strutils

proc on[T](this: T, name: string, callback: proc): T {.discardable.} =
  discard this.`object`.signalConnect(name, signalFunc(callback), nil)
  return this


proc add[T, W](this: T, widget: W): T {.discardable.} = 
  this.container.add(widget)
  return this

proc add[T, W](this: T, widgets: varargs[W]): T {.discardable.} =
  for w in widgets: this.add(w)
  return this

proc setBorderWidth[T](this: T, width: guint = 5): T {.discardable.} =
  this.container.setBorderWidth(width)
  return this

proc setDefaultSize[T](this: T, width: gint = 800, height: gint = 400): T {.discardable.} = 
  gtk2.setDefaultSize(this, width, height)
  return this

proc showAll[T](this: T): T {.discardable.} =
  this.widget.showAll()
  return this

proc packStart[T](this: T; child: PWidget; expand, fill: gboolean = false; padding: guint = 0): T {.discardable.} =
  this.pbox.packStart(child, expand, fill, padding)
  return this

proc setSizeRequest[T](this: T, width: gint = 85; height: gint = 28): T = 
  this.widget.setSizeRequest(width, height)
  return this

proc windowNew(thetype: gtk2.TWindowType = gtk2.WINDOW_TOPLEVEL): gtk2.PWindow = gtk2.windowNew(thetype)
proc vboxNew(homogeneous: gboolean = false, spacing: gint = 5): gtk2.PVBox = gtk2.vboxNew(homogeneous, spacing)
proc hboxNew(homogeneous: gboolean = false, spacing: gint = 5): gtk2.PHBox = gtk2.hboxNew(homogeneous, spacing)
proc alignmentNew(xalign, yalign, xscale, yscale: gfloat = 0.0): gtk2.PAlignment = gtk2.alignmentNew(xalign, yalign, xscale, yscale)

gtk2.nimrodInit()


windowNew()
.setDefaultSize
.setBorderWidth
.on("destroy", proc () = gtk2.mainQuit())
.add(
  vboxNew()
  .add(alignmentNew(yalign = 1.0))
  .packStart(
    alignmentNew(xalign = 1.0)
    .add(
      hboxNew()
      .add(
        buttonNew("OK").setSizeRequest.on("clicked", proc () = 
          gtk2.mainQuit()
        )
      ).add(
        buttonNew("Cancel").setSizeRequest.on("clicked", proc () =
          windowNew()
          .setDefaultSize
          .setBorderWidth
          .on("destroy", proc () = gtk2.mainQuit())
          .add(
            vboxNew()
            .add(alignmentNew(yalign = 1.0))
            .packStart(
              alignmentNew(xalign = 1.0)
              .add(
                hboxNew()
                .add(
                  buttonNew("OK").setSizeRequest.on("clicked", proc () = 
                    gtk2.mainQuit()
                  )
                ).add(
                  buttonNew("Cancel").setSizeRequest.on("clicked", proc () =
                    gtk2.mainQuit()
                  )
                )
              )
            )
          ).showAll
        )
      )
    )
  )
).showAll

gtk2.main()
