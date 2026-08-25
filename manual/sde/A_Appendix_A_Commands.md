# APPENDIX A Commands

*This appendix describes the Scheme commands, functions, and extensions supported in Sentaurus Structure Editor.*

## Presentation of Commands

Each Scheme command, function, or extension accepts zero or more arguments, and can return a value. The type of arguments and the return type are written in uppercase.

If a Scheme list of a certain data type is used, then it is indicated as `<DATATYPE> LIST`, for example, `STRING LIST` or `ENTITY LIST`.

See Chapter 9 on page 263 for an explanation of the data types used in Sentaurus Structure Editor.

## Renamed Commands and Obsolete Commands

The following Scheme commands were renamed to follow a more consistent Scheme naming convention. The old command names still work but are replaced internally with the new command name. The argument lists are the same, and there are no compatibility issues.

> **NOTE** It is best practice to discontinue the use of old command names in command files.

<table>
  <thead>
    <tr>
        <th>Old Scheme command name</th>
        <th>New Scheme command name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dnce</td>
        <td>sdegeo:dnce</td>
    </tr>
    <tr>
        <td>sde:selected-refinements</td>
        <td>sde:selected-refeval-windows</td>
    </tr>
    <tr>
        <td>sdeaxisaligned:set-parameters</td>
        <td>sdesnmesh:axisaligned</td>
    </tr>
    <tr>
        <td>sdedelaunizer:set-parameters</td>
        <td>sdesnmesh:delaunizer</td>
    </tr>
    <tr>
        <td>sdedelaunizer:set-tolerance</td>
        <td>sdesnmesh:delaunizer-tolerance</td>
    </tr>
    <tr>
        <td>sdedr:define-refinement-window</td>
        <td>sdedr:define-refeval-window</td>
    </tr>
    <tr>
        <td>sdedr:delete-refinement-window</td>
        <td>sdedr:delete-refeval-window</td>
    </tr>
    <tr>
        <td>sdedr:redefine-refinement-window</td>
        <td>sdedr:redefine-refeval-window</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>295</page_number>

# A: Commands

Presentation of Commands

<table>
  <thead>
    <tr>
        <th>Old Scheme command name</th>
        <th>New Scheme command name</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>sdefloops:begin</td>
        <td>sdesp:begin</td>
    </tr>
    <tr>
        <td>sdefloops:define-step</td>
        <td>sdesp:define-step</td>
    </tr>
    <tr>
        <td>sdefloops:finalize</td>
        <td>sdesp:finalize</td>
    </tr>
    <tr>
        <td>sdefloops:restore-state</td>
        <td>sdesp:restore-state</td>
    </tr>
    <tr>
        <td>sdefloops:tag-initial</td>
        <td>sdesp:tag-initial</td>
    </tr>
    <tr>
        <td>sdegeo:define-2d-contact</td>
        <td>sdegeo:set-contact</td>
    </tr>
    <tr>
        <td>sdegeo:define-3d-contact</td>
        <td>sdegeo:set-contact</td>
    </tr>
    <tr>
        <td>sdegeo:fillet-edges</td>
        <td>sdegeo:fillet</td>
    </tr>
    <tr>
        <td>sdegeo:split-solid</td>
        <td>sde:split-solid</td>
    </tr>
    <tr>
        <td>sdeinterpolate:set-parameters</td>
        <td>sdesnmesh:interpolate</td>
    </tr>
    <tr>
        <td>sdeio:read_dfise_mask</td>
        <td>sdeio:read-dfise-mask</td>
    </tr>
    <tr>
        <td>sdenoffset:create-noffset-block</td>
        <td>sdedr:offset-block</td>
    </tr>
    <tr>
        <td>sdenoffset:create-noffset-interface</td>
        <td>sdedr:offset-interface</td>
    </tr>
    <tr>
        <td>sdesnmesh:replace-tensor-block</td>
        <td>sdesnmesh:tensor</td>
    </tr>
    <tr>
        <td>sdesnmesh:replace-tools-block</td>
        <td>sdesnmesh:tools</td>
    </tr>
    <tr>
        <td>sdesnmesh:set-iocontrols</td>
        <td>sdesnmesh:iocontrols</td>
    </tr>
  </tbody>
</table>

The following Scheme commands are obsolete and no longer supported. There are no replacements for these commands. If you execute a script containing any of these commands, then the script execution terminates, and an error message is written to the `.log` and `.log.err` files.

**NOTE** Remove these obsolete commands from scripts.

<table>
  <thead>
    <tr>
        <th>Obsolete Scheme command</th>
        <th>Obsolete Scheme command</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>sdedr:offset-isoline</td>
        <td>sdenoffset:create-global</td>
    </tr>
    <tr>
        <td>sdenoffset:create-boundary</td>
        <td>sdenoffset:create-isoline</td>
    </tr>
  </tbody>
</table>

<page_number>296</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
afm-smooth-layers

# afm-smooth-layers

Creates a layered structure from imported comma-separated value (CSV) data.

## Syntax

`(afm-smooth-layers fname z0 zplanar layerregion layermaterial layerthickness)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>fname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>z0</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>zplanar</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>layerregion</td>
        <td>STRING LIST</td>
    </tr>
    <tr>
        <td>layermaterial</td>
        <td>DATEXMAT LIST</td>
    </tr>
    <tr>
        <td>layerthickness</td>
        <td>REAL LIST</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension creates a layered lens structure with a texture map. The texture map is defined in a CSV file. `fname` is the name of the input file, `z0` is the bottom z-coordinate, and `zplanar` is the top planar z-coordinate. `layerregion` is a list of region names, and `layermaterial` is a DATEX material list. `layerthickness` specifies the thickness of each layer.

## Examples

```scheme
(define n 10)
(define a (* 2 PI))
(define oport (open-output-file "xx.csv"))
(display ", " oport)
(do ((i 0 (+ i 1))) ((> i n))
  (display (/ (* i a) n) oport)
  (display ", " oport)
)
(display "\n" oport)
(do ((i 0 (+ i 1))) ((> i n))
  (display (/ (* i a) n) oport)
  (display ", " oport)
  (do ((j 0 (+ j 1))) ((> j n))
```

Sentaurus™ Structure Editor User Guide <page_number>297</page_number>
S-2021.06

# A: Commands

afm-smooth-layers

```scheme
    (define yp (* (sin (* j (/ a n))) (cos (* i (/ a n)))))
    (display yp oport)
    (if (not (equal? j n))
      (display ", " oport))
    )
    (display "\n" oport)
  )
(close-output-port oport)

(sde:clear)
(define layermaterial (list "TCO" "Copper" "PolySi"))
(define layerregion (list "tco" "copper" "polysi"))
(define layerthickness (list 2 2 2))
(sdegeo:create-cuboid (position 0 0 0) (position (* 2 PI) (* 2 PI) 4)
  "Silicon" "xx")
(afm-smooth-layers "xx.csv" 0 4 layerregion layermaterial layerthickness)
```

<page_number>298</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
bbox

# bbox

Returns a bounding box of an entity.

## Syntax

`(bbox entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`POSITION LIST`

## Description

This Scheme extension returns the minimum and maximum values corresponding to a diagonal across the bounding box of a body, relative to the active coordinate system.

The argument `entity-list` comprises an entity or a list of entities. Each entity or list of entities can be a body, a wire-body, a face, or an edge.

This Scheme extension returns a pair comprising `(min-pt . max-pt)`. The returned bounding box is not necessarily tight (not exact).

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>299</page_number>

A: Commands

bbox-exact

# bbox-exact

Returns a tight bounding box of an entity.

## Syntax

`(bbox-exact entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

POSTION LIST

## Description

This Scheme extension returns the exact minimum and maximum values corresponding to a diagonal across the tight bounding box of a body, relative to the active coordinate system.

The argument `entity-list` comprises an entity or a list of entities. Each entity or list of entities can be a body, a wire, a face, or an edge.

This Scheme extension returns a pair comprising `(min-pt . max-pt)`. The returned bounding box is tight (exact).

<page_number>

300
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
body?

# body?

Determines if a Scheme object is a body.

## Syntax

```scheme
(body? object)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns #t if the object is a body; otherwise, it returns #f. The `object` specifies the Scheme object to be queried.

## Examples

```scheme
(define myrect (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
   "Silicon" "Region_1"))
(body? myrect)
;; #t
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

301
</page_number>

**A: Commands**
build-csv-lens

# build-csv-lens

Imports capability for AFM data.

## Syntax

`(build-csv-lens fname bottom-z material-name [region-name])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>fname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>bottom-z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>material-name</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY ID (body)`

## Description

This Scheme extension can be used to create a solid body from user-defined data.

The input data file is a CSV file, which defines the user data over a tensor grid, in the following format ($n \times m$ grid):

```
,x1, x2, ..., xn
y1, f11, f12, ..., f1n
y2, f21, f22, ..., f2n
...
ym, fm1, fm2, ..., fmn
```

The `x1`, `x2`, ..., `xn` values define the x-coordinates of the tensor grid.

The `y1`, `y2`, ..., `ym` values define the y-coordinates of the tensor grid.

The `fij` values define the function values at the given (`xj`, `yi`) tensor-grid points. The base of the created solid body is placed in the xy plane at z = `bottom-z`, and the tensor-grid points define the top surface in the +z-direction.

<page_number>302</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
color:rgb

# color:rgb

Creates a red-green-blue (RGB) color object.

## Syntax

`(color:rgb red green blue)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>red</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>green</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>blue</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

COLOR

## Description

This Scheme extension specifies the red, green, and blue color components with normalized real numbers, ranging from 0 to 1.

Some colors are predefined as follows:

```scheme
(define rgb:red (color:rgb 1 0 0))
(define rgb:green (color:rgb 0 1 0))
(define rgb:blue (color:rgb 0 0 1))
(define rgb:yellow (color:rgb 1 1 0))
(define rgb:magenta (color:rgb 1 0 1))
(define rgb:cyan (color:rgb 0 1 1))
(define rgb:black (color:rgb 0 0 0))
(define rgb:white (color:rgb 1 1 1))
```

Therefore, `rgb:red`, `rgb:green`, and so on can also be used as `color:rgb` values.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>303</page_number>

A: Commands

complete-edge-list

# complete-edge-list

Appends an edge list with all neighboring linear edges.

## Syntax

```scheme
(complete-edge-list edge-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge-list</td>
        <td>EDGE LIST</td>
    </tr>
  </tbody>
</table>

## Returns

LIST

## Description

This Scheme extension appends the specified edge list, `edge-list`, with all neighboring linear edges. If some 2D boundary simplification algorithms are used, which require an edge list as input, it is recommended to extend the edge list with all neighboring linear edges. This will ensure that the boundary simplification algorithm does not leave gaps or does not create overlaps between neighboring bodies.

## Examples

```scheme
(sde:clear)
(define mb1 (sdegeo:create-rectangle (position 0 0 0) (position 10 10 0)
  "Silicon" "x1"))
(define mb2 (sdegeo:create-rectangle (position 5 5 0) (position 15 15 0)
  "PolySilicon" "x2"))
(define elist (entity:edges mb1))
(length elist)
;; 6
(define elistc (complete-edge-list elist))
(length elistc)
;; 8
```

<page_number>304</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
convert-to-degree

# convert-to-degree

Converts an angle from radian to degree.

## Syntax

`(convert-to-degree angle)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>angle</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

# convert-to-radian

Converts an angle from degree to radian.

## Syntax

`(convert-to-radian angle)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>angle</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

305
</page_number>

**A: Commands**

edge?

# edge?

Determines if a Scheme object is an edge.

## Syntax

`(edge? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns `#t` if a Scheme object is an edge. The argument `object` specifies the Scheme object to be queried.

<page_number>306</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
edge:circular

# edge:circular

Creates an arc with the specified center position and radius.

## Syntax

`(edge:circular center-position radius [start-angle=0 [end-angle=360]])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>center-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>start-angle</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>end-angle</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (EDGE)

## Description

For this Scheme function:

*   The argument `center-position` specifies the center position of the arc.

*   `radius` is an implicit line between the center position and the edge of the arc.

*   `start-angle` specifies the starting point of the arc in degrees.

*   `end-angle` specifies the end angle of the arc in degrees.

The start and end of the angle are measured counterclockwise from the x-axis of the active coordinate system. The start and end locations must be in the current xy construction plane.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>307</page_number>

A: Commands

edge:circular?

# edge:circular?

Determines if a Scheme object is a circular edge.

## Syntax

```scheme
(edge:circular? object)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns `#t` if a Scheme object is a circular edge. The argument `object` specifies the Scheme object to be queried.

# edge:elliptical?

Determines if a Scheme object is an elliptical edge.

## Syntax

```scheme
(edge:elliptical? object)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns `#t` if a Scheme object is an elliptical edge. The argument `object` specifies the Scheme object to be queried.

<page_number>308</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
edge:end

# edge:end

Returns the end position of an edge.

## Syntax

`(edge:end edge)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge</td>
        <td>EDGE</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION

## Description

For this Scheme function, the argument `edge` is an input edge.

# edge:length

Returns the length of an edge.

## Syntax

`(edge:length edge)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge</td>
        <td>EDGE</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

For this Scheme function, the argument `edge` is an input entity.

Sentaurus™ Structure Editor User Guide <page_number>309</page_number>
S-2021.06

A: Commands

edge:linear

# edge:linear

Creates a linear edge between two locations.

## Syntax

(edge:linear position position)

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (EDGE)

## Description

This Scheme function specifies locations as positions. The first position argument specifies the start location of the line. The second position argument specifies the end location of the line.

## Examples

```scheme
; Scheme function
; edge:linear
; Create two linear edges given two positions.
(define edge1 (edge:linear (position 0 0 0) (position 30 30 0)))
```

<page_number>310</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
edge:linear?

# edge:linear?

Determines if a Scheme object is a linear edge.

## Syntax

`(edge:linear? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns #t if a Scheme object is a linear edge. The argument `object` specifies the Scheme object to be queried.

## Examples

```scheme
(define myrect (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "Region_1"))
(define myedges (entity:edges myrect))
(edge:linear? (list-ref myedges 0))
;; #t
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>311</page_number>

A: Commands

edge:mid-point

# edge:mid-point

Returns the midpoint position of an edge.

## Syntax

`(edge:mid-point edge [approximation=#t])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge</td>
        <td>EDGE</td>
    </tr>
    <tr>
        <td>approximation</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION

## Description

For this Scheme function, when the argument `approximation` is set to `TRUE`, it returns the exact geometric midpoint of the edge, while `FALSE` returns the midpoint in parameter space. The default is `TRUE`. The argument `edge` is an input entity.

# edge:start

Returns the starting position of the edge.

## Syntax

`(edge:start edge)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge</td>
        <td>EDGE</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION

<page_number>

312
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
edge:type

# edge:type

Determines the type of an edge.

## Syntax

`(edge:type edge)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge</td>
        <td>EDGE</td>
    </tr>
  </tbody>
</table>

## Returns

STRING

## Description

For this Scheme function, the argument edge specifies an edge.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

313
</page_number>

A: Commands
entity:box

# entity:box

Returns the extrema box of an entity.

## Syntax

`(entity:box entity-list [create-box])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
    <tr>
        <td>create-box</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION LIST

## Description

This Scheme function returns the minimum and maximum values corresponding to a diagonal across the bounding box of a body, relative to the active coordinate system.

The argument `entity-list` comprises an entity or a list of entities. Each entity or list of entities can be a body, a wire, a face, or an edge.

This Scheme function returns a pair comprising `(min-pt . max-pt)`. If the Boolean argument `create-box` is given, a solid box is returned.

<page_number>314</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
entity:copy

# entity:copy

Copies any entity (such as solid, face, edge) and all entities attached to it.

## Syntax

`(entity:copy entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY | ENTITY LIST

## Description

For this Scheme function, the argument `entity-list` specifies an entity or entity list to be copied.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

315
</page_number>

A: Commands
entity:debug

# entity:debug

Prints information about the data structure of an entity.

## Syntax

`(entity:debug entity [level])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>level</td>
        <td>INTEGER (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

STRING

## Description

For this Scheme function, the argument `entity` specifies the entity to be queried.

The optional argument `level` controls the amount of debug information generated, where:

*   0 writes no output and only returns the entity type.

*   1 writes only data specific to the given entity.

*   2 writes additional information for some entity types.

    For example, if the entity is an edge, the coordinates of the endpoints and the curve data also are written. This Scheme function writes only data specific to the given entity.

*   3 writes the size of the entity and all associated entities.

*   4 writes the full information for the entity and all associated entities.

<page_number>316</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
entity:deep-copy

# entity:deep-copy

Deep copies an entity (solid, face, edge, and so on) as well as all attached entities.

## Syntax

`(entity:deep-copy entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY | ENTITY LIST

## Description

The difference between the Scheme functions `entity:deep-copy` and `entity:copy` is that `entity:deep-copy` makes a copy of `splf_splf`; whereas, `entity:copy` creates a pointer to `splf_splf`.

The deep-copy functionality is used instead of the regular copy when it is required that no links exist with shared information between the original and deep copies.

Sentaurus™ Structure Editor User Guide <page_number>317</page_number>

S-2021.06

A: Commands

entity:delete

# entity:delete

Deletes an entity or a list of entities, and any attributes attached to those entities.

## Syntax

`(entity:delete entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

For this Scheme function, the argument `entity-list` specifies an entity or entity list to be deleted.

<page_number>

318
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
entity:dist

# entity:dist

Obtains the minimum distance between two entities, or an entity and a position.

## Syntax

`(entity:dist part1 part2 [acis-opts])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>part1</td>
        <td>ENTITY | POSITION</td>
    </tr>
    <tr>
        <td>part2</td>
        <td>ENTITY | POSITION</td>
    </tr>
    <tr>
        <td>acis-opts</td>
        <td>ACIS OPTIONS (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`(REAL POSITION (ENTITY | ENTITY LIST . STRING))`

## Description

Using the two input entities, this Scheme function finds a position on each entity such that the distance between the two is the minimum distance. Supported entities include VERTEX, EDGE, LOOP, FACE, WIRE, SHELL, LUMP, and BODY.

This Scheme function also can find the minimum distance using an entity and a position. The optional argument `acis-opts` helps to switch on journaling and versioning options.

## Limitations

If `part1` is defined as a position, then `part2` must be an entity.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

319
</page_number>

A: Commands

entity:edges

# entity:edges

Returns a list of all edge entities of an entity or a list of entities.

## Syntax

`(entity:edges entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

EDGE | EDGE LIST

## Description

This Scheme function returns a list of the edges for the input `entity-list`. It returns an empty list when no edges are found.

<page_number>320</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
entity:erase

# entity:erase

Erases, but does not remove, the specified entity or list of entities.

## Syntax

`(entity:erase entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

Input `entity-list`.

## Description

For this Scheme function, the argument `entity-list` is an entity or a list of entities to be erased from the display. The entities remain available for later redisplay. To redisplay an erased entity or a list of entities, use the Scheme function `render:rebuild`.

# entity:faces

Returns a list of all face entities of an entity or a list of entities.

## Syntax

`(entity:faces entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`FACE | FACE LIST`

## Description

This Scheme function returns an empty list when no faces are found. The input argument is an `entity-list` from which a list of all faces is to be obtained.

Sentaurus™ Structure Editor User Guide
<page_number>321</page_number>
S-2021.06

**A: Commands**

entity:loops

# entity:loops

Returns a list of all loops of an entity or a list of entities.

## Syntax

`(entity:loops entity-list [include-pat])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
    <tr>
        <td>include-pat</td>
        <td>INTEGER (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`LOOP | LOOP LIST`

## Description

This Scheme function returns a list of all the loops of an entity. If no loops are found, this Scheme function returns an empty list. The argument `entity-list` specifies an entity or entity list to be queried.

The optional argument `include-pat` determines how this function deals with patterned objects. By default, patterned objects are included in the list of entities. You can specify any one of the following through this argument:

*   0 – Patterned objects are created if they do not already exist and are included in the list.

*   1 – Only those patterned objects that already exist are included in the list.

*   2 – No patterned objects, except seed pattern objects, are included in the list.

<page_number>322</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
entity:lumps

# entity:lumps

Obtains a list of all lumps of an entity or a list of entities.

## Syntax

`(entity:lumps entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`LUMP | LUMP LIST`

## Description

This Scheme function returns a list of all the lumps of an entity. If no lumps are found, then this Scheme function returns an empty list. The argument `entity-list` specifies an entity or entity list to be queried.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

323
</page_number>

A: Commands
entity:set-color

# entity:set-color

Sets the display color for an entity or a list of entities.

## Syntax

```scheme
(entity:set-color entity-list color)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
    <tr>
        <td>color</td>
        <td>COLOR</td>
    </tr>
  </tbody>
</table>

## Returns

Previous color of entity.

## Description

For this Scheme function, the argument `entity-list` specifies an entity or a list of entities to be assigned a color.

The argument `color` can accept an integer or a `color:rgb` value, and specifies a new color to be assigned to specified entities. The predefined color values include:

*   BLACK = 0 = #[color 0 0 0]

*   BLUE = 3 = #[color 0 0 1]

*   CYAN = 4 = #[color 0 1 1]

*   GREEN = 2 = #[color 0 1 0]

*   MAGENTA = 6 = #[color 1 0 1]

*   RED = 1 = #[color 1 0 0]

*   WHITE = 7 = #[color 1 1 1]

*   YELLOW = 5 = #[color 1 1 0]

These color variable names are already defined in the Sentaurus Structure Editor Scheme interpreter and can be used instead of the numeric values.

<page_number>324</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
entity:set-color

# Examples

**Example 1**

```scheme
(sde:clear)
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silver" "region_1")
(sdegeo:create-sphere (position 1 1 1) 0.5 "SiliconCarbide" "region_2")
(entity:set-color (find-face-id (position 0.1 0.1 1)) RED)
```

**Example 2**

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silicon" "xx")
(entity:set-color (find-face-id (position 0.5 0.5 1)) 3)
(entity:set-color (find-face-id (position 1 0.5 0.5)) rgb:yellow)
(entity:set-color (find-face-id (position 0.5 1 0.5)) CYAN)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>325</page_number>

A: Commands
entity:shells

# entity:shells

Returns a list of shell entities from a topological entity or a list of entities.

## Syntax

`(entity:shells entity-list [include-pat])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
    <tr>
        <td>include-pat</td>
        <td>INTEGER (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`SHELL | SHELL LIST`

## Description

This Scheme function returns a list of the shells of an entity. If no shell entities are found, this Scheme function returns an empty list.

The argument `entity-list` specifies a topological entity or an entity list.

The optional argument `include-pat` determines how this function deals with patterned objects. By default, patterned objects are included in the list of entities. You can specify any one of the following through this argument:

*   0 – Patterned objects are created if they do not already exist and are included in the list.

*   1 – Only those patterned objects that already exist are included in the list.

*   2 – No patterned objects, except seed pattern objects, are included in the list.

<page_number>326</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
entity:vertices

# entity:vertices

Returns a list of all vertices in an entity or a list of entities.

## Syntax

`(entity:vertices entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

VERTEX | VERTEX LIST

## Description

This Scheme function returns a list of the vertices for the input `entity-list`. It returns an empty list if no vertices are found.

Sentaurus™ Structure Editor User Guide
<page_number>327</page_number>

S-2021.06

A: Commands
env:set-tolerance

# env:set-tolerance

Sets the following system tolerances: `resabs`, `resnor`, `resfit`, and `resmch`.

## Syntax

`(env:set-tolerance resabs resnor resfit resmch)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>resabs</td>
        <td>REAL (default=1e-6)</td>
    </tr>
    <tr>
        <td>resfit</td>
        <td>REAL (default=1e-3)</td>
    </tr>
    <tr>
        <td>resmch</td>
        <td>REAL (default=1e-11)</td>
    </tr>
    <tr>
        <td>resnor</td>
        <td>REAL (default=1e-10)</td>
    </tr>
  </tbody>
</table>

## Returns

The set tolerance values: `(REAL REAL REAL REAL)`.

## Description

This Scheme function sets the modeling tolerances. The system tolerances are set in the following order: `resabs`, `resnor`, `resfit`, and `resmch`. The ratio of `resabs` to `resnor` is the largest number that can be represented, that is, the modeling range must be within this ratio.

The arguments are:

*   `resabs` determines whether two positions in space are equal. This tolerance defines the smallest distance between two distinct points.

*   `resnor` checks a number for equality with 0. This tolerance checks components of numbers that are 0 to determine whether vectors are parallel or perpendicular, or to check for zero lengths.

*   `resfit` fits interpolation curves when intersecting surfaces.

*   `resmch` is used by the spline functions for purposes similar to `resnor`.

For each element argument, `REAL` sets the value, `BOOLEAN #f` leaves the value unchanged, and `BOOLEAN #t` sets the value to the default.

<page_number>328</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
env:tolerance

# env:tolerance

Returns the system tolerances in a list.

## Syntax

`(env:tolerance)`

## Returns

The set tolerance values: `(REAL REAL REAL REAL)`.

## Description

This Scheme function returns the system tolerances in the following order: resabs, resnor, resfit, resmch. The Scheme function `env:set-tolerance` explains each tolerance value.

## See Also

env:set-tolerance on page 328

# erf

Returns the error function (erf) value of the input.

## Syntax

`(erf value)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>value</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

Sentaurus™ Structure Editor User Guide
<page_number>329</page_number>
S-2021.06

A: Commands

erfc

# erfc

Returns the complementary error function (erfc) value of the input.

## Syntax

`(erfc value)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>value</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

# exists-empty-mask-name

Checks whether the specified empty mask exists.

## Syntax

`(exists-empty-mask-name maskname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>maskname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

<page_number>330</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**

exists-mask-name

# exists-mask-name

Checks whether the specified mask exists.

## Syntax

`(exists-mask-name maskname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>maskname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

Sentaurus™ Structure Editor User Guide

<page_number>331</page_number>

S-2021.06

**A: Commands**

extract-interface-normal-offset-refwindow

# extract-interface-normal-offset-refwindow

Creates a doping/refinement/submesh (DRS) body by offsetting, in the normal direction, the non-regularized intersection of the two input bodies.

## Syntax

```
(extract-interface-normal-offset-refwindow body1 body2 offset-distance
  refwindowname)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body1</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>body2</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>offset-distance</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>refwindowname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY ID of the created Ref/Eval window.

## Description

This command generates the non-regularized intersection between two bodies, and creates a 3D offset body from the non-regularized intersection, by offsetting the faces of the interface body in the normal direction, and assigns it as a DRS body.

## Examples

```
(sde:clear)
(define mb1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 4)
  "Silicon" "x1"))
(define mb2 (sdegeo:create-cylinder (position 5 5 4) (position 5 5 8)
  2 "PolySilicon" "x2"))
(extract-interface-normal-offset-refwindow mb1 mb2 1 "rw1")
```

<page_number>332</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
extract-interface-offset-refwindow

# extract-interface-offset-refwindow

Creates a DRS body by offsetting the non-regularized intersection of the two input bodies.

## Syntax

`(extract-interface-offset-refwindow body1 body2 offset-distance refwindowname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body1</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>body2</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>offset-distance</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>refwindowname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY ID of the created Ref/Eval window.

## Description

This command generates the non-regularized intersection between two bodies, and creates a 3D offset body from the non-regularized intersection and assigns it as a DRS body.

## Examples

```scheme
(sde:clear)
(define mb1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 4)
  "Silicon" "x1"))
(define mb2 (sdegeo:create-cylinder (position 5 5 4) (position 5 5 8)
  2 "PolySilicon" "x2"))
(extract-interface-offset-refwindow mb1 mb2 1 "rw1")
```

Sentaurus™ Structure Editor User Guide

S-2021.06
<page_number>

333
</page_number>

**A: Commands**

extract-refpolyhedron

# extract-refpolyhedron

Defines a refinement window, matching the specified 3D solid body.

## Syntax

`(extract-refpolyhedron bodyid refwindowname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>bodyid</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>refwindowname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY

## Description

This Scheme extension converts a 3D geometric body to a polyhedral refinement window. The ACIS surface mesher of Sentaurus Structure Editor, which saves the tessellated polyhedral boundary for meshing, converts the 3D geometric body (possibly with nonplanar faces) to a polyhedral refinement window.

## Examples

**Example 1**

```scheme
(sde:clear)
(define mb (sdegeo:create-cuboid (position 0 0 0) (position 1 1 1)
  "Silicon" "x1"))
(extract-refpolyhedron mb "ref1")
```

**Example 2**

```scheme
(sde:clear)
(define mb (sdegeo:create-cylinder (position 0 0 0) (position 0 0 1)
  0.1 "Silicon" "x1"))
(extract-refpolyhedron mb "ref1")
(sdedr:define-refinement-size "RD_1" .2 .2 .1 .1)
(sdedr:define-refinement-placement "RP_1" "RD_1" "ref1")
(sdedr:write-cmd-file "xx.cmd")
```

<page_number>334</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
extract-refwindow

# extract-refwindow

Defines refinement windows, matching the specified geometry face or faces.

## Syntax

`(extract-refwindow faceid refwindowname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>faceid</td>
        <td>FACE | FACE LIST | EDGE</td>
    </tr>
    <tr>
        <td>refwindowname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension goes through the specified face list (or the specified single face list), extracts the vertex list for each face, and defines a separate polygonal refinement window for each face. Planar faces will have the corresponding refinement polygon defined as one single refinement polygon. However, for curved faces, the geometric face will be triangulated first and a separate refinement polygon (triangle) will be defined for each triangle. The coplanar triangular faces of the extracted refinement body are merged by default. Merging the coplanar triangular faces can be disabled by setting the `merge-extracted-drs-faces` global variable to `#f`. (It is set to `#t` by default).

The `extract-refwindow` Scheme extension also supports converting linear geometric edges to Ref/Eval windows (line elements). The argument list is unchanged; however, in this case, the first argument must be a linear edge.

## Examples

**Example 1**
```scheme
(sde:clear)
(define mypyramid (sdegeo:create-pyramid (position 0 0 0) 20 40 40 6 12
  "PolySilicon" "r1"))
(define myface (list-ref (entity:faces mypyramid) 2))
(extract-refwindow myface "refinement1")
```

Sentaurus™ Structure Editor User Guide

<page_number>335</page_number>

S-2021.06

**A: Commands**

face:area

**Example 2**

```scheme
(sde:clear)
(define mycube (sdegeo:create-cuboid (position 0 0 0) (position 10 10 10)
  "Silicon" "r1"))
(define myedge (car (find-edge-id (position 10 5 10))))
(sdegeo:fillet myedge 4)
(define mflist (entity:faces mycube))
(extract-refwindow (list-ref mflist 2) "refwin1")
(extract-refwindow (list-ref mflist 5) "refwin2")
(extract-refwindow (list-ref mflist 0) "refwin3")
```

**Example 3**

```scheme
(sde:clear)
(define mb (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "xx"))
(extract-refwindow (car (entity:edges mb)) "rw1")
```

---

# face:area

Calculates the area of a specified face.

### Syntax

```scheme
(face:area face)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>face</td>
        <td>FACE</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

### Description

The accuracy of the calculation is fixed at 0.001 for an area of geometry that cannot be determined analytically. The argument `face` is an input face.

<page_number>336</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
face:conical?

# face:conical?

Determines if a Scheme object is a conical face.

## Syntax

`(face:conical? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns #t if the object is a conical face; otherwise, it returns #f. The argument object specifies the Scheme object to be queried.

# face:cylindrical?

Determines if a Scheme object is a cylindrical face.

## Syntax

`(face:cylindrical? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

In this Scheme function, the returned Boolean specifies whether the supplied entity input is a cylindrical face. The input argument is a cylindrical face and *not* a solid cylinder. The argument object specifies the Scheme object to be queried.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>337</page_number>

A: Commands
face:planar?

# face:planar?

Determines if a Scheme object is a planar face.

## Syntax

`(face:planar? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

`BOOLEAN`

## Description

This Scheme function returns `#t` if the specified object is a planar face. The argument `object` specifies the Scheme object to be queried.

# face:plane-normal

Returns the face normal of the specified planar face.

## Syntax

`(face:plane-normal face)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>face</td>
        <td>ENTITY FACE</td>
    </tr>
  </tbody>
</table>

## Returns

`GVECTOR`

<page_number>338</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

face:spherical?

# face:spherical?

Determines if a Scheme object is a spherical face.

## Syntax

`(face:spherical? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns `#t` if the specified object is a spherical face. The argument `object` specifies the Scheme object to be queried.

# face:spline?

Determines if a Scheme object is a face–spline.

## Syntax

`(face:spline? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

For this Scheme function, the argument `object` specifies the Scheme object to be queried.

Sentaurus™ Structure Editor User Guide

<page_number>339</page_number>

S-2021.06

A: Commands

face:toroidal?

# face:toroidal?

Determines if a Scheme object is a toroidal face.

## Syntax

`(face:toroidal? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

For this Scheme function, the argument `object` specifies the Scheme object to be queried.

<page_number>340</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
filter:type

# filter:type

Creates a filter entity that selects a type of entity.

## Syntax

```scheme
(filter:type type-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>type-name</td>
        <td>STRING<br/>{"body?" | "edge?" | "edge:circular?" | "edge:curve?" |<br/>"edge:elliptical?" | "edge:linear?" | "edge:spline?" | "face?" |<br/>"face:conical?" | "face:cylindrical?" | "face:planar?" |<br/>"face:spherical?" | "face:spline?" | "face:toroidal?" | "mixed-body?" |<br/>"point?" | "solid?" | "text?" | "vertex?" | "wcs?" | "wire?" |<br/>"wire-body?"}</td>
    </tr>
  </tbody>
</table>

## Returns

FILTER

## Description

This Scheme function creates the specified `type-name` as a filter, which specifies the type of entity to be used in another filter operation. If a new type filter is created, then it replaces the previously defined type.

Use this Scheme function to display the list of available filter types. The argument `type-name` specifies the `entity-filter` to be created, from the possible values.

## Examples

```scheme
(filter:type "edge:linear?")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>341</page_number>

A: Commands
find-body-id

# find-body-id

Finds the entity numbers of a body.

## Syntax

`(find-body-id position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

BODY LIST

## Description

This Scheme extension goes through all bodies, `(get-body-list)`, and returns the ACIS entity IDs of all bodies that contain the specified position. The position can be lying on a boundary face or vertex, or can be an internal point.

# find-body-id-drs

Finds the entity numbers of a body for a refinement/evaluation (Ref/Eval) window body.

## Syntax

`(find-body-id-drs position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

BODY LIST

## Description

This Scheme extension goes through the body list of all defined Ref/Eval window bodies and returns the ACIS entity IDs of all bodies that contain the specified position. The position can be lying on a boundary face or can be an internal point.

<page_number>342</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
find-drs-id

# find-drs-id

Returns the entity numbers of a Ref/Eval window body.

## Syntax

`(find-drs-id DRSname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>DRSname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BODY

## Description

This Scheme extension goes through all defined Ref/Eval window bodies and returns the ACIS entity IDs of the Ref/Eval window body that matches the specified DRS name. (The DRS name is a unique identifier of each Ref/Eval window body.)

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>343</page_number>

A: Commands
find-edge-id

# find-edge-id

Finds the entity numbers of an edge.

## Syntax

```
(find-edge-id position body)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>body</td>
        <td>BODY | BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

EDGE LIST

## Description

This Scheme extension goes through the edge list of all defined bodies, `(entity:edges (get-body-list))`, and returns the ACIS entity IDs of all edges that contain the specified position. The position can be either an end vertex position of the edge or an internal position. This Scheme extension provides an additional filter for selecting bodies.

## Examples

```
(sde:clear)
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silicon" "x1")
(sdegeo:create-cuboid (position 1 0 0) (position 2 1 1) "PolySilicon" "x2")
(define chamferedges (find-edge-id (position 1 0.5 1)
  (find-material-id "Silicon")))
(sdegeo:chamfer chamferedges 0.2)
```

<page_number>344</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
find-edge-id-drs

# find-edge-id-drs

Finds the entity numbers of an edge for a Ref/Eval window body.

## Syntax

`(find-edge-id-drs position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

EDGE LIST

## Description

This Scheme extension goes through the edge list of all defined Ref/Eval window bodies and returns the ACIS entity IDs of all edges that contain the specified position. The position can be either an end vertex position of the edge or an internal position.

Sentaurus™ Structure Editor User Guide <page_number>345</page_number>

S-2021.06

A: Commands
find-face-id

# find-face-id

Finds the entity numbers of a face.

## Syntax

`(find-face-id position | gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

FACE LIST

## Description

This Scheme extension goes through the face list of all defined bodies, `(entity:faces (get-body-list))`, and returns the ACIS entity IDs of all faces that contain the specified position. The position can be either a position lying on a boundary edge or an internal position. Alternatively, the input argument can be a gvector, in which case, all the planar faces with the specified face normal are returned.

<page_number>346</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
find-face-id-drs

# find-face-id-drs

Finds the entity numbers of a face for a Ref/Eval window body.

## Syntax

`(find-face-id-drs position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

FACE LIST

## Description

This Scheme extension goes through the face list of all defined Ref/Eval window bodies and returns the ACIS entity IDs of all faces that contain the specified position. The position can be either a position lying on a boundary edge or an internal position.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>347</page_number>

A: Commands
find-material-id

# find-material-id

Finds and returns all entities that have the given material attribute.

## Syntax

`(find-material-id material-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>material-name</td>
        <td>DATEXMAT</td>
    </tr>
  </tbody>
</table>

## Returns

`BODY | BODY LIST`

## Description

This Scheme extension goes through every region in the model and selects all regions that have the specified `material-name` as the material attribute. If only one body is found with the specified `material-name` as the material attribute, the entity ID of the material is returned. If more than one region has the `material-name` as the material attribute, a list of all entities is returned. If no entity is found, an empty list is returned.

<page_number>348</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
find-region

# find-region

Returns the entity IDs for a specific region name.

## Syntax

```scheme
(find-region region-name [partial-match])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>partial-match</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`BODY | BODY LIST`

## Description

This Scheme extension examines every region in the model and selects all regions that have the specified `region-name` as the region attribute.

If only one body is found with the specified `region-name` as the region attribute, the entity ID of the region is returned. If more than one region has the `region-name` as the region attribute, a list of all entities is returned. If no entity is found, an empty list is returned.

If the optional Boolean argument `partial-match` is used, the Scheme extension returns the partially matched region names as well, as long as the partial match criterion is incremental (that is, it is satisfied from the beginning of the string).

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>349</page_number>

A: Commands

find-region-id

# find-region-id

Returns the entity IDs for a specific region name.

## Syntax

`(find-region-id region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BODY | BODY LIST

## Description

This Scheme extension goes through every region in the model and selects all regions that have the specified `region-name` as the region attribute. If only one body is found with the specified `region-name` as the region attribute, the entity ID of the region is returned. If more than one region has the `region-name` as the region attribute, a list of all entities is returned. If no entity is found, an empty list is returned.

<page_number>

350
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
find-vertex-id

# find-vertex-id

Finds the entity numbers of a vertex.

## Syntax

`(find-vertex-id position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

VERTEX LIST

## Description

This Scheme extension goes through the vertex list of all defined bodies, `(entity:vertices (get-body-list))`, and returns the ACIS entity IDs of all vertices that are placed at the specified position.

# find-vertex-id-drs

Finds the entity numbers of a vertex for a Ref/Eval window body.

## Syntax

`(find-vertex-id-drs position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

VERTEX LIST

## Description

This Scheme extension goes through the vertex list of all defined Ref/Eval window bodies and returns the ACIS entity IDs of all vertices that contain the specified position.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>351</page_number>

A: Commands

get-body-list

# get-body-list

Returns a list of all 2D and 3D bodies that are defined in the model.

### Syntax

```scheme
(get-body-list)
```

### Returns

BODY LIST

### Description

This Scheme extension returns a list of all 2D and 3D bodies that are defined in the model, except the mask bodies and the doping-related or refinement-related Ref/Eval windows. Since mask bodies and Ref/Eval windows are also sheet bodies, `(part:entities (filter:type "solid?"))` also returns these entities.

Since most of the geometric operations are performed only on 2D and 3D bodies, and not on masks and Ref/Eval windows, this Scheme extension is used to distinguish easily between masks, Ref/Eval windows, and regular bodies.

# get-drs-list

Returns a list of all 2D and 3D Ref/Eval windows that are defined in the model.

### Syntax

```scheme
(get-drs-list)
```

### Returns

BODY LIST

<page_number>352</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
get-empty-mask-list

# get-empty-mask-list

Returns a list of all defined empty masks.

### Syntax

```scheme
(get-empty-mask-list)
```

### Returns

LIST

### Description

If no empty mask is defined, then an empty list is returned.

# get-mask-list

Returns a list of all defined (geometric) masks.

### Syntax

```scheme
(get-mask-list)
```

### Returns

LIST

### Description

If no mask is defined, then an empty list is returned.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

353
</page_number>

A: Commands
gvector

# gvector

Creates a new gvector with the specified x-, y-, and z-coordinates.

## Syntax

`(gvector x y z [space=model])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>space</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

## Description

For this Scheme function, relative to the active coordinate system, the argument x defines the x-coordinate, y defines the y-coordinate, and z defines the z-coordinate.

The optional argument `space` defaults to `WCS` for the active (working) coordinate system. If no active work plane exists, `space` defaults to `model`. The other optional `space` arguments return a gvector in the new coordinate system:

* The value `model` means that the x-, y-, and z-values are represented with respect to the model. If the model has an origin other than the active work plane, this returns the position relative to the active coordinate system in rectangular Cartesian coordinates.

* The value `polar` or `cylindrical` means that the x-, y-, and z-values are interpreted as the radial distance from the z-axis, the polar angle in degrees measured from the xz plane (using the right-hand rule), and the z-coordinate, respectively. This returns the x-, y-, and z-terms with respect to the active coordinate system.

* The value `spherical` means that the provided x-, y-, and z-values are the radial distance from the origin, the angle of declination from the z-axis in degrees, and the polar angle measured from the xz plane in degrees, respectively. This returns the x-, y-, and z-terms relative to the active coordinate system.

<page_number>354</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
gvector?

# gvector?

Determines if a Scheme object is a gvector.

## Syntax

`(gvector? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

# gvector:+

Adds two gvectors.

## Syntax

```scheme
(gvector:+ gvector1 gvector2)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector1</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>gvector2</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

## Description

This Scheme function returns the result of (gvector1 + gvector2) as a gvector. The argument gvector1 defines the first gvector, and the argument gvector2 defines the second gvector.

## Examples

```scheme
(gvector:+ (gvector 1 3 2) (gvector 2 2 2))
```

Sentaurus™ Structure Editor User Guide
<page_number>355</page_number>
S-2021.06

**A: Commands**

gvector:-

# gvector:-

Subtracts two gvectors.

## Syntax

```scheme
(gvector:- gvector1 gvector2)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector1</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>gvector2</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

## Description

This Scheme function returns the result of (gvector1 – gvector2) as a gvector. The argument gvector1 defines the start location, and the argument gvector2 defines the end location for both gvectors.

## Examples

```scheme
(gvector:- (gvector 1 3 2) (gvector 2 2 2))
```

<page_number>356</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

gvector:copy

# gvector:copy

Creates a gvector by copying an existing gvector.

## Syntax

```scheme
(gvector:copy gvector)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

## Examples

```scheme
(define gvcopy (gvector:copy (gvector 6 5 2)))
```

---

# gvector:cross

Returns the cross product of two gvectors.

## Syntax

```scheme
(gvector:cross gvector1 gvector2)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector1</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>gvector2</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

Sentaurus™ Structure Editor User Guide

<page_number>357</page_number>

S-2021.06

**A: Commands**

gvector:dot

# gvector:dot

Returns the dot product of two gvectors.

**Syntax**

`(gvector:dot gvector1 gvector2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector1</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>gvector2</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

**Returns**

REAL

# gvector:from-to

Returns the gvector between two positions, position1 and position2.

**Syntax**

`(gvector:from-to position1 position2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

**Returns**

GVECTOR

<page_number>358</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

gvector:length

# gvector:length

Returns the length of a gvector as a real value.

### Syntax

`(gvector:length gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

# gvector:parallel?

Determines if two gvectors are parallel.

### Syntax

`(gvector:parallel? gvector1 gvector2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector1</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>gvector2</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

### Returns

BOOLEAN

### Description

This Scheme function returns #t if gvector1 and gvector2 are parallel; otherwise, it returns #f. A zero gvector is not parallel to anything including itself, so it causes the Scheme function to return #t.

Sentaurus™ Structure Editor User Guide

<page_number>359</page_number>

S-2021.06

**A: Commands**

gvector:perpendicular?

---

# gvector:perpendicular?

Determines if two gvectors are perpendicular.

## Syntax

`(gvector:perpendicular? gvector1 gvector2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector1</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>gvector2</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns #t if the gvectors are perpendicular; otherwise, it returns #f. A zero gvector is perpendicular to all gvectors including itself, and it causes the Scheme function to return #f.

---

# gvector:reverse

Reverses the direction of a gvector.

## Syntax

`(gvector:reverse gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

<page_number>360</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
gvector:scale

# gvector:scale

Multiplies a gvector by a scalar number to produce a new gvector.

## Syntax

`(gvector:scale gvector scale)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>scale</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

## Description

Using this Scheme function, the resulting gvector is the original gvector scaled by the number.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>361</page_number>

A: Commands

gvector:set!

# gvector:set!

Sets the direction of a gvector given the components of x, y, and z.

## Syntax

```scheme
(gvector:set! gvector {x y z})
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

## Description

For this Scheme function, the coordinates are computed relative to the active coordinate system. The argument `gvector` specifies the original x-, y-, and z-components:

* x specifies the value to replace the original x-value specified in `gvector`.

* y specifies the value to replace the original y-value specified in `gvector`.

* z specifies the value to replace the original z-value specified in `gvector`.

<page_number>362</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

gvector:set-x!

# gvector:set-x!

Sets the x-direction component of a gvector.

## Syntax

```scheme
(gvector:set-x! gvector x)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>x</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

Using this Scheme function, the coordinates are computed relative to the active coordinate system. This Scheme function returns the x-value as a real:

* gvector specifies the original x-, y-, and z-values.

* x specifies the value to replace the original x-value specified in gvector.

## Examples

```scheme
(gvector:set-x! vector1 3)
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>363</page_number>

A: Commands

gvector:set-y!

# gvector:set-y!

Sets the y-direction component of a gvector.

## Syntax

```scheme
(gvector:set-y! gvector y)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>y</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

The coordinates are computed relative to the active coordinate system. This Scheme function returns the y-value as a real:

* gvector specifies the original x-, y-, and z-values.

* y specifies the value to replace the original y-value specified in gvector.

## Examples

```scheme
(gvector:set-y! vector1 3)
```

<page_number>

364
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands

gvector:set-z!

# gvector:set-z!

Sets the z-direction component of a gvector.

## Syntax

```scheme
(gvector:set-z! gvector z)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>z</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

The coordinates are computed relative to the active coordinate system. This Scheme function returns the z-value as a real.

The argument `gvector` specifies the original x-, y-, and z-values, and the argument `z` specifies the value to replace the original z-value specified in `gvector`.

## Examples

```scheme
(gvector:set-z! vector1 3)
```

Sentaurus™ Structure Editor User Guide

<page_number>365</page_number>

S-2021.06

A: Commands

gvector:transform

# gvector:transform

Applies a transform to a gvector.

## Syntax

`(gvector:transform gvector transform)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>transform</td>
        <td>TRANSFORM</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

# gvector:unitize

Creates a new gvector as a unit vector in the same direction as the specified gvector.

## Syntax

`(gvector:unitize gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

GVECTOR

<page_number>366</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
gvector:x

# gvector:x

Returns the x-component of a gvector relative to the active coordinate system.

## Syntax

`(gvector:x gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme function returns the x-coordinate of the gvector, transformed to the active work plane.

# gvector:y

Returns the y-component of a gvector relative to the active coordinate system.

## Syntax

`(gvector:y gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme function returns the y-coordinate of the gvector, transformed to the active work plane.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

367
</page_number>

A: Commands

gvector:z

# gvector:z

Returns the z-component of a gvector relative to the active coordinate system.

## Syntax

`(gvector:z gvector)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>gvector</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme function returns the z-coordinate of the gvector, transformed to the active work plane.

# journal:abort

Terminates the journal single-stepping process.

## Syntax

`(journal:abort)`

## Returns

None

## Description

When stepping, this Scheme function terminates the current load without executing the rest of the commands in the file.

<page_number>

368
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
journal:append

# journal:append

Opens a journal file and appends additional journal data to the end of the file.

## Syntax

```scheme
(journal:append [filename])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme function opens the optional file `filename` if it exists, where all future commands are journaled to the file. The time and date of the append to the file are indicated in the journal.

If the argument `filename` is not specified, a unique name is created after reading the current directory. The unique name is sequenced numerically from the last journal file created or named `j(last number+1).jrl`.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>369</page_number>

A: Commands
journal:clean

# journal:clean

Cleans the journal file.

**Syntax**

`(journal:clean jname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>jname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

**Returns**

None

**Description**

This Scheme function removes all nonexecutable content (comments, return values, and so on) from the specified script file. Only the executable Scheme commands remain; therefore, parameterizing and debugging the journal file are easier if the saved journal file is cleaned up first.

<page_number>

370
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
journal:load

# journal:load

Loads a journal file, one line at a time, journaling each command as it is executed.

## Syntax

`(journal:load filename)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme function loads a journal file and runs each command contained in that file. Each line is journaled if journaling is switched on. This Scheme function works like the load primitive, except that the file is evaluated one line at a time instead of all lines simultaneously with the Scheme load primitive.

Encountered errors do not abort the load operation and are reported in the command-line window. This Scheme function is useful for debugging Scheme files and for rerunning the commands given in another Scheme session.

An error in the loaded file does not abort the evaluation. This Scheme function permits single-stepping through a loaded file, one line at a time. The Scheme function `(journal:step #t)` switches it on and should be run before loading the journal file.

In addition, `(option:set "timing" #t)` can be used to show the execution time for each command in the command-line window. Before loading, the directory where the load file is found is added to the global variable `part-load-path`.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>371</page_number>

**A: Commands**

journal:off

# journal:off

Closes the current journal file and switches off journaling.

## Syntax

`(journal:off)`

## Returns

None

## Description

Using this Scheme function, all Scheme extensions executed after journaling has been switched off are not retained in the journal file.

<page_number>

372
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
journal:on

# journal:on

Closes the current journal file and opens a new journal file.

## Syntax

```
(journal:on [filename])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme function opens the optional file `filename` if it exists, and all future commands are journaled to this file. If `filename` is not specified, the Scheme function creates a unique name after reading the current directory. The unique name is sequenced numerically from the last journal file created or named `j(last number+1).jrl`. If the file exists, it is truncated to zero length.

## Examples

```
; Scheme function journal:on
; Close the current journal file and open a new journal file called new_jrl.
(journal:on "new_jrl")
;; "new_jrl"
; Create solid cuboid.
(sdegeo:create-cuboid (position 0 0 0) (position 10 10 10) "Silicon"
   "region_1")
; Turn journaling off
(journal:off)
;; ()
; Save the resulting journal.
(journal:save "new_jrl")
;; "new_jrl" ; Clear the part.
(sde:clear)
;; #t
; Load the journal file to recreate and redisplay the solid cube.
(journal:load "new_jrl")
;; "new_jrl"
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>373</page_number>

**A: Commands**

journal:pause

# journal:pause

Deactivates journaling temporarily but leaves the journal file open.

## Syntax

```scheme
(journal:pause)
```

## Returns

None

## Description

This Scheme function does not record in the journal file any procedure evaluated while the journal file is paused.

# journal:resume

Resumes journaling in the journal file after a pause.

## Syntax

```scheme
(journal:resume)
```

## Returns

None

## Description

This Scheme function resumes journaling in the journal file after a pause.

<page_number>

374
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
journal:save

# journal:save

Saves the current journal to a file.

## Syntax

`(journal:save filename)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The `filename` specifies the name of the file in which the journal is saved. This Scheme function is ignored if journaling is not active. An error is generated if `filename` is the same as the current journal file.

## See Also

journal:on on page 373

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>375</page_number>

**A: Commands**
journal:step

# journal:step

Switches on or off single-stepping of journal file.

## Syntax

```scheme
(journal:step value)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>value</td>
        <td>BOOLEAN</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme function sets a flag to control stepping through the journal file. When stepping is switched on, the system waits for input after printing, but before executing each line. A single return causes the line to be executed. Anything else is evaluated and the system waits for more input. This allows you to set up demonstrations and to debug Scheme scripts one line at a time.

To run a demonstration, enter `(journal:step #f)`, but include `(journal:step #t)` at points in the script where you want to interact with the graphical user interface (GUI) or enter commands in the command-line window. Otherwise, press the Return key a few times to step through it slowly. Use `(journal:step #f)` to return to the free-running mode.

<page_number>376</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
loop?

# loop?

Determines if a Scheme object is a loop.

## Syntax

`(loop? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns `#t` if the object is a loop; otherwise, it returns `#f`. The argument `object` specifies the Scheme object to be queried.

# loop:external?

Determines if a loop is internal or external.

## Syntax

`(loop:external? loop)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>LOOP</td>
        <td>LOOP</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Errors

Returns an error if the argument `loop` is not a loop.

Sentaurus™ Structure Editor User Guide <page_number>377</page_number>
S-2021.06

A: Commands
lump?

# lump?

Determines if a Scheme object is a lump.

## Syntax

`(lump? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme function returns `#t` if the object is a lump; otherwise it returns `#f`. The argument `object` specifies the Scheme object to be queried.

<page_number>

378
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
mask-refevalwin-extract-2d

# mask-refevalwin-extract-2d

Converts a mask to a 2D Ref/Eval window.

## Syntax

`(mask-refevalwin-extract-2d rwname maskname polarity)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rwname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>maskname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>polarity</td>
        <td>STRING {"light" | "dark"}</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY IDs of the created Ref/Eval windows.

## Description

This Scheme extension extracts a 2D Ref/Eval window from the specified mask. The argument `rwname` is the name of the extracted mask, `maskname` is the name (and not the entity ID) of the used mask, and `polarity` is the polarity that is used for the extraction. The default mask polarity is `"light"`.

The Scheme extension assumes that the domain boundary was set previously. (This information is needed for "dark" mask extraction.) If the mask consists of several disjoint lumps, a separate Ref/Eval window is extracted from each disjoint lump. In this case, the specified `rwname` is appended with a counter `_N` where `N` is the lump counter (from 1 onwards).

> **NOTE** The domain boundary must be set before this Scheme extension is called.

## Examples

```
(sde:clear)
(sdepe:define-pe-domain 0 0 40 30)
(sdepe:generate-mask "M1" (list (list 0 0 10 10) (list 20 0 30 0 30 10 25
  15 20 10))))
(mask-refevalwin-extract-2d "RW1" "M1" "light")
(mask-refevalwin-extract-2d "RW2" "M1" "dark")
```

Sentaurus™ Structure Editor User Guide <page_number>379</page_number>
S-2021.06

**A: Commands**
mask-refevalwin-extract-3d

# mask-refevalwin-extract-3d

Converts a mask to a 3D Ref/Eval window.

## Syntax

`(mask-refevalwin-extract-3d rwname maskname polarity minz maxz)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rwname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>maskname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>polarity</td>
        <td>STRING {"light" | "dark"}</td>
    </tr>
    <tr>
        <td>minz</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>maxz</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY IDs of the created Ref/Eval windows.

## Description

This Scheme extension extracts a 3D Ref/Eval window from the specified mask. The argument `rwname` is the name of the extracted mask, `maskname` is the name (and not the entity ID) of the used mask, and `polarity` is the polarity that is used for the extraction. The default mask polarity is `"light"`.

The Scheme extension assumes that the domain boundary was set previously. (This information is needed for `"dark"` mask extraction.) The 3D Ref/Eval window is placed between `minz` and `maxz` in the 3D space. If the mask consists of several disjoint lumps, a separate Ref/Eval window is extracted from each disjoint lump. In this case, the specified `rwname` is appended with a counter `_N` where `N` is the lump counter (from 1 onwards).

> **NOTE** The domain boundary must be set before this Scheme extension is called.

<page_number>380</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

member?

### Examples

```scheme
(sde:clear)
(sdepe:define-pe-domain 0 0 40 30)
(sdepe:generate-mask "M1" (list (list 0 0 10 10) (list 20 0 30 0 30 10 25
  15 20 10))))
(mask-refevalwin-extract-3d "RW1" "M1" "light" -0.1 0.5)
(mask-refevalwin-extract-3d "RW2" "M1" "dark" -0.1 0.5)
```

# member?

Checks whether the specified element is part of the specified list.

### Syntax

`(member? element list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>element</td>
        <td>VARIABLE (INTEGER | REAL | STRING | ...)</td>
    </tr>
    <tr>
        <td>list</td>
        <td>LIST (Scheme list)</td>
    </tr>
  </tbody>
</table>

### Returns

BOOLEAN

### Description

This Scheme extension returns #t if the specified element is part of the specified list and, if not, #f is returned.

### Examples

```scheme
(member? 2 (list 1 2 3 4))
#t

(member? 0 (list 1 2 3 4))
#f

(member? "apple" (list 1 2 "apple" 3 4))
#t
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>381</page_number>

A: Commands
merge-collinear-edges-2d

# merge-collinear-edges-2d

Merges all collinear edges of the specified bodies.

> **NOTE** This Scheme extension applies to 2D models only.

## Syntax

`(merge-collinear-edges-2d body-list [angular-tolerance])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
    <tr>
        <td>angular-tolerance</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

An optional `angular-tolerance` value can be specified. In that case, besides the perfectly collinear edges, the edges that close an angle, which is larger than the specified threshold, will also merge (that is, the two edges will be replaced by one edge, connecting the other endpoints).

<page_number>382</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
part:entities

# part:entities

Obtains a list of all top-level entities in a part.

## Syntax

```scheme
(part:entities [filter=NULL])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filter</td>
        <td>FILTER (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY LIST

## Description

The optional argument `filter` controls the types of entity that are returned by this Scheme function. This argument is an `entity-filter`, which is a procedural object that selects entities from an `entity-list`.

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silver" "region_3")
(part:entities)
(part:entities (filter:type "solid?"))
```

Sentaurus™ Structure Editor User Guide

<page_number>383</page_number>

S-2021.06

A: Commands
part:load

# part:load

Loads a part from a file into the active part.

## Syntax

`(part:load filename [textmode=#t] [part=active] [with-history=#f])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>textmode</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>part</td>
        <td>PART (optional)</td>
    </tr>
    <tr>
        <td>with-history</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY LIST

## Description

This Scheme function is a merge function, which means that the restore does not replace entities; it adds them to the current working session. A list of entities is returned.

The argument `filename` specifies a file name in the current working directory or the path that includes the file name. If the optional argument `part` is not specified, the entities in the part file merge into the active part; otherwise, they merge into the specified part.

The argument `textmode` describes the type of file to be loaded. If `textmode` is specified as `#t`, the data in `filename` is saved in text mode as a .sat file. If `textmode` is `#f`, `filename` is loaded as a binary file. If `textmode` is not specified, the mode is determined by the extension of the `filename`. If the `filename` string ends in .sab or .SAB, the file is saved in binary mode; otherwise, the file is saved in text mode.

After specifying the text mode, a second Boolean argument indicates whether to restore the rollback history data. History data can only be restored into an empty part. The default, `#f`, does not restore the history.

If the global variable `part-load-path` is set to a list of strings, the strings are interpreted as directories to be searched for the part file: `part-load-path` is to `part-load` as `load-path` is to `load`. Set `part-load-path` in an initialization file. When a part is saved using `part:save` and a `filename`, the `filename` becomes the new name for the part.

<page_number>384</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
part:save

# part:save

Saves all entities in a part to a file.

## Syntax

```scheme
(part:save [filename=partname.sat] [textmode=#t] [part=active]
 [with-history=#f] [mainline-only=#f])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING (optional)</td>
    </tr>
    <tr>
        <td>textmode</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>part</td>
        <td>PART (optional)</td>
    </tr>
    <tr>
        <td>with-history</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>mainline-only</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

The optional argument `filename` specifies a file name to be saved in the current working directory or specifies the path that includes the file name to be saved to a directory. If no `filename` is specified, this Scheme function uses the name given to the part with the `part:set-name` function.

The optional argument `part` specifies the part to save; the default is the active part. If `textmode` is `#t`, the data is saved in text mode. If `textmode` is not specified, the mode is determined by the extension of the `filename`. If the `filename` string ends in `.sab` or `.SAB`, the file is saved in binary mode; otherwise, the file is saved in text mode.

After setting `textmode`, a second Boolean (`with-history`) specifies whether to save entity-specific rolled back history data (that is, history attached to the entity through an attribute). The default, `#f`, does not save the history. A third Boolean (`mainline-only`) specifies whether to save rolled back branches. The default, `#f`, for this argument indicates the entire history should be saved. The saved file can be restored at any time.

When a part is saved using `part:save` and a `filename`, the `filename` becomes the new name for the part. Part files can be saved in the format of an earlier version by setting the global option `save_version`.

Sentaurus™ Structure Editor User Guide <page_number>385</page_number>
S-2021.06

A: Commands
part:save-selection

# part:save-selection

Saves a list of entities to a file.

## Syntax

```scheme
(part:save-selection ent-list filename [textmode=#f] [with-history=#f])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>ent-list</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
    <tr>
        <td>filename</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>textmode</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>with-history</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

The argument `filename` specifies a file name to be saved in the current working directory or specifies the path that includes the file name to be saved to a directory. The `ent-list` is the list of entities to be saved in the output file. If `textmode` is `#t`, the data is saved in text mode. If `textmode` is not specified, the mode is determined by the extension of `filename`. If the `filename` string ends in `.sab` or `.SAB`, the file is saved in binary mode; otherwise, the file is saved in text mode. The saved file can be restored at any time.

Part files can be saved in the format of an earlier version by setting the global option `save_version`. The `with-history` argument allows you to save entity-specific history (that is, history attached to the entity through an attribute).

<page_number>386</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
part:set-name

# part:set-name

Sets the name of a part.

## Syntax

```scheme
(part:set-name [name] [part=active])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>name</td>
        <td>STRING (optional)</td>
    </tr>
    <tr>
        <td>part</td>
        <td>PART (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme function assigns a name to the specified part, or to the active part if `part` is omitted. If the part is saved without specifying a file name, the `part:save` extension uses the identification name assigned to the part as the saved part file name. If `name` is omitted, the name of the part is cleared.

The optional argument `name` specifies the required string identification of the part.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

387
</page_number>

A: Commands
position

# position

Creates a new position with x-, y-, and z-coordinates.

## Syntax

`(position x y z [space="models"])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>space</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`POSITION`

## Description

Relative to the active coordinate system, the argument x defines the x-coordinate, y defines the y-coordinate, and z defines the z-coordinate. If the model has an origin other than the active work plane, this returns the position relative to the active coordinate system in rectangular Cartesian coordinates.

The value `polar` or `cylindrical` means that the x-, y-, and z-values are interpreted as the radial distance from the z-axis, the polar angle in degrees measured from the xz plane (using the right-hand rule), and the z-coordinate, respectively. This returns the x-, y-, and z-terms with respect to the active coordinate system.

The value `spherical` means that the provided x-, y-, and z-values are the radial distance from the origin, the angle of declination from the z-axis in degrees, and the polar angle measured from the xz plane in degrees, respectively. This returns the x, y, and z terms relative to the active coordinate system.

A position is not saved with the part, but it is used to help define geometry. Positions are not displayed in Scheme.

A point is an entity and is different from a vertex in that it has no edge associations. Use `env:set-point-size` and `env:set-point-style` to change its appearance.

<page_number>388</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
position?

# position?

Determines if a Scheme object is a position.

## Syntax

`(position? object)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>object</td>
        <td>SCHEME OBJECT</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

For this Scheme function, the argument `object` specifies the Scheme object to be queried.

# position:+

Adds a position or gvector to a position or gvector, and returns the sum as a position.

## Syntax

`(position:+ arg1 arg2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>arg1</td>
        <td>POSITION | GVECTOR</td>
    </tr>
    <tr>
        <td>arg2</td>
        <td>POSITION | GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>389</page_number>

**A: Commands**

position:-

---

# position:-

Subtracts a position or gvector from a position or gvector, and returns the result as a position.

## Syntax

```
(position:- arg1 arg2)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>arg1</td>
        <td>POSITION | GVECTOR</td>
    </tr>
    <tr>
        <td>arg2</td>
        <td>POSITION | GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION

---

# position:distance

Returns the distance between two positions.

## Syntax

```
(position:distance position1 {position2 | ray})
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>ray</td>
        <td>RAY</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

The argument `position1` defines the start location, `position2` defines the end location, and `ray` defines the ray to calculate the distance.

<page_number>390</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
position:set!

# position:set!

Sets the x-, y-, and z-components of a position.

## Syntax

`(position:set! position1 {x y z} | {position2})`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION

## Description

The argument `position1` specifies the position to be set. If the x-, y-, and z-values are specified, they are copied into `position1`. If `position2` is specified, its position value is copied into `position1`.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>391</page_number>

A: Commands

position:set-x!

# position:set-x!

Sets the x-component of a position.

## Syntax

`(position:set-x! position x)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>x</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

The coordinates are computed relative to the active coordinate system. This Scheme function returns the x-coordinate as a real value:

*   `position` identifies the original y- and z-values.

*   `x` specifies the value to replace the original x-value specified in `position`.

<page_number>392</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
position:set-y!

# position:set-y!

Sets the y-component of a position.

## Syntax

```scheme
(position:set-y! position y)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>y</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

The coordinates are computed relative to the active coordinate system. This Scheme function returns the y-coordinate as a real value:

* `position` identifies the original x- and z-values.

* `y` specifies the value to replace the original y-value specified in `position`.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>393</page_number>

**A: Commands**

position:set-z!

# position:set-z!

Sets the z-component of a position.

### Syntax

```scheme
(position:set-z! position z)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>z</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

### Description

The coordinates are computed relative to the active coordinate system. This Scheme function returns the z-coordinate as a real value:

* `position` identifies the original x- and y-values.

* `z` specifies the value to replace the original z-value specified in `position`.

<page_number>394</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
position:x

# position:x

Returns the x-component of a position relative to the active coordinate system.

## Syntax

`(position:x position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

For this Scheme function, the argument `position` specifies a position.

# position:y

Returns the y-component of a position relative to the active coordinate system.

## Syntax

`(position:y position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

For this Scheme function, the argument `position` specifies a position.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>395</page_number>

A: Commands

position:z

# position:z

Returns the z-component of a position relative to the active coordinate system.

## Syntax

`(position:z position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

For this Scheme function, the argument `position` specifies a position.

<page_number>

396
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
protect-all-contacts

# protect-all-contacts

Protects all 2D and 3D contacts against merging and deleting.

## Syntax

```scheme
(protect-all-contacts)
```

## Returns

BOOLEAN

## Description

This Scheme function protects all 2D and 3D contacts against merging and deleting. If contacts are assigned to edges and faces using any of the `sdegeo` contact assignment commands, these contacts are protected. The 2D boundary simplification commands do not remove or merge contact edges, and also the 3D boundary regularization command `sde:bool-regularise` does not merge coplanar contact faces with adjoining faces.

If an application defines the edge or face contacts directly, by attaching the `"2d-contact"` or `"3d-contact"` attributes to the contact edges or faces, these contacts are not protected. In this case, the `(protect-all-contacts)` command can be used to add the necessary *no merge* attribute to the contact edges or faces.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>397</page_number>

A: Commands
random-sd

# random-sd

Returns a seeded random number.

## Syntax

`(random-sd [initial-seed])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>initial-seed</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

REAL random number, (normalized in [0-1])

## Description

This Scheme function returns a random number. The seeded random number generator always generates the same random number sequence (normalized in [0-1]). This Scheme function uses a hard-coded, fixed seed. A different seed can be set by adding the initial seed to the function argument, for example, `(random-sd 987654321)`. However, this must be done only once.

The next random number, which uses this seed, is generated by `(random-sd)`. If you specify the seed, for example `(random-sd 987654321)`, this always resets the random number sequence to the first value, which is generated by the given seed.

## Examples

`(random-sd)`

<page_number>398</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
remove-body-ABA

# remove-body-ABA

Subtracts the input body from all the other existing bodies.

## Syntax

`(remove-body-ABA rbody)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rbody</td>
        <td>ENTITY</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension subtracts the specified input body from all the other existing bodies if there is an overlap between the input body and the other bodies.

The result is similar to the case where the input body is created when the “new replaces old” ("ABA") automatic overlap removal rule is used. Overlapping bodies are not allowed in the final tessellated model. If overlaps are created, the overlaps must be removed manually.

Overlapping bodies can be created only if the automatic overlap handling is disabled or if some direct geometry manipulation is used, which is not detected by the automatic overlap removal procedure.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

399
</page_number>

A: Commands
remove-body-BAB

# remove-body-BAB

Subtracts all other bodies from the input body.

## Syntax

`(remove-body-BAB rbody)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rbody</td>
        <td>ENTITY</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension subtracts all the other existing bodies from the specified input body if there is an overlap between the input body and the other bodies.

The result is similar to the case where the input body is created when the “old replaces new” ("BAB") automatic overlap removal rule is used. Overlapping bodies are not allowed in the final tessellated model. If overlaps are created, the overlaps must be removed manually.

Overlapping bodies can be created only if the automatic overlap handling is disabled or if some direct geometry manipulation is used, which is not detected by the automatic overlap removal procedure.

<page_number>400</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
render:rebuild

# render:rebuild

Refreshes the display list for a view.

## Syntax

`(render:rebuild [clear])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>clear</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

Use this Scheme function after changing viewing parameters.

If the optional argument `clear` is #t or not present, the view window is cleared and the wire frame is redisplayed from the display list contents.

If the argument `clear` is #f, the view window is not cleared before redisplaying the display list (that is, no ‘new page’ is written to the file).

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>401</page_number>

A: Commands

roll

# roll

Rolls to a previous or later state.

## Syntax

```scheme
(roll [num])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>num</td>
        <td>INTEGER (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

INTEGER (number of steps rolled)

## Description

This Scheme function can undo or redo geometry-related and doping-related, or refinement-related operations. The optional argument `num` specifies the number of states the model can roll. A negative number means to roll to a previous state, and a positive number means to roll to a later state.

<page_number>

402
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:add-material

# sde:add-material

Assigns the specified material and region attributes to a body.

## Syntax

`(sde:add-material body material-name region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>ACIS ENTITY</td>
    </tr>
    <tr>
        <td>material-name</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension assigns the material and region attributes to a body. The body is defined by the first argument.

The argument `material-name` must be a valid DATEX name, which is defined in the `datexcodes.txt` file. The argument `material-name` is assigned as a material attribute to the body. When the tessellated boundary output is generated, the material attribute will be the material of the region. The `region-name` attribute defines the region name in the tessellated boundary output.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

403
</page_number>

A: Commands
sde:back-coord

# sde:back-coord

Returns the back coordinate of the device.

## Syntax

`(sde:back-coord body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme extension returns the back coordinate of the specified `body` or `body-list`. The back coordinate depends on the coordinate system used:

* For the unified coordinate system (UCS), the back coordinate is the minimum z-coordinate.

* For the DF–ISE coordinate system, the back coordinate is the minimum x-coordinate.

<page_number>404</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:bg-image-transparency

# sde:bg-image-transparency

Sets the transparency of the loaded image.

## Syntax

`(sde:bg-image-transparency transparency-value)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>transparency-value</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

For this Scheme extension, the `transparency-value` argument must be between 0 and 1.

# sde:bool-regularise

Merges the coplanar faces of 3D bodies.

## Syntax

`(sde:bool-regularise body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme function merges the coplanar faces of the specified bodies in `body-list`. After `sde:bool-regularise` is applied, it is recommended to call `(sde:fix-imprint)` to ensure a conformal model.

Sentaurus™ Structure Editor User Guide <page_number>405</page_number>
S-2021.06

A: Commands

sde:bottom-coord

# sde:bottom-coord

Returns the bottom coordinate of the device.

## Syntax

`(sde:bottom-coord body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme extension returns the bottom coordinate of the specified `body` or `body-list`. The bottom coordinate depends on the coordinate system used:

*   For the UCS, the bottom coordinate is the maximum x-coordinate.

*   For the DF–ISE coordinate system, the bottom coordinate is the minimum z-coordinate.

<page_number>

406
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
sde:build-mesh

# sde:build-mesh

Generates a tessellated TDR boundary output and a mesh command file, and calls Sentaurus Mesh.

## Syntax

`(sde:build-mesh file-basename)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-basename</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

Prints a message showing a successful or failed meshing. Returns #t or #f to indicate success or failure, respectively.

## Description

This Scheme extension generates a 2D or 3D TDR tessellated boundary output and a mesh command file, and calls Sentaurus Mesh using a system command call. Sentaurus Structure Editor then waits for the meshing to be completed. No further interaction is possible during this time, until the meshing is completed.

The input argument string `file-basename` is first stripped from the file extension (if it is part of the input argument string). Then, if the stripped `file-basename` ends with `_msh`, that is removed as well. The TDR boundary file will be saved as `file-basename_bnd.tdr` and the mesh command file will be saved as `file-basename_msh.cmd`.

**NOTE** The default name of the TDR boundary file is `file-basename_bnd.tdr`. The default name of the mesh command file is `file-basename_msh.cmd`.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>407</page_number>

A: Commands
sde:change-datex-color-scheme

# sde:change-datex-color-scheme

Changes the DATEX color scheme used for rendering.

## Syntax

```scheme
(sde:change-datex-color-scheme color-scheme)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>color-scheme</td>
        <td>Vivid | "Classic"</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension changes the DATEX color scheme used in Sentaurus Structure Editor. The `datexcodes.txt` file contains two different color schemes for each DATEX material.

## Examples

Change to the Vivid color scheme:

```scheme
(sde:change-datex-color-scheme "Vivid")
```

Change to the Classic color scheme:

```scheme
(sde:change-datex-color-scheme "Classic")
```

## See Also

Selecting the DATEX Color Scheme on page 32

<page_number>408</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:check-3d-license-status

# sde:check-3d-license-status

Checks the status of the 3D license.

## Syntax

`(sde:check-3d-license-status)`

## Returns

BOOLEAN

## Description

This Scheme extension returns #t or #f depending on whether a 3D license is checked out.

# sde:check-model

Performs a detailed model check.

## Syntax

`(sde:check-model [filename])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BODY LIST

## Description

This Scheme extension checks a model for possible problems that are reported in a report file including:

* Mixed dimensional models

* Overlaps

* Multiple region names

* Entity check problems

The default file name is `sde-model-debug.log`.

Sentaurus™ Structure Editor User Guide

<page_number>409</page_number>

S-2021.06

**A: Commands**
sde:checkout-3d-license

---

# sde:checkout-3d-license

Checks out a 3D license.

### Syntax

```
(sde:checkout-3d-license)
```

### Returns

BOOLEAN

### Description

This Scheme extension checks out a 3D license explicitly. By default, Sentaurus Structure Editor starts with a 2D license and only checks out (automatically) a 3D license when it is needed (for 3D solid creation, 2D to 3D operations, process emulation operations, and so on).

---

# sde:clear

Clears the modeler.

### Syntax

```
(sde:clear)
```

### Returns

None

### Description

This Scheme extension clears the database of Sentaurus Structure Editor and restores all settings to their initial values, and it should always be used as the first call when a new script is executed that requires a clean database. This Scheme extension also restores the view window to its initial settings.

### Limitations

This Scheme extension does not clear the Scheme interpreter. If global Scheme variables are used, they are still initialized and valid after an `(sde:clear)` call.

<page_number>410</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:create-bg-image

# sde:create-bg-image

Loads an image file (in GIF) into Sentaurus Structure Editor.

## Syntax

`(sde:create-bg-image filename horizontal-size vertical-size)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filename</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>horizontal-size</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>vertical-size</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension loads an image file (in GIF) into Sentaurus Structure Editor. The image is not shown automatically; this Scheme extension must be called to show the image.

The `horizontal-size` and `vertical-size` arguments define the GUI size of the image.

> **NOTE** The image loader supports only images in the older GIF format, GIF87a. Most current graphic programs use the GIF format GIF89a. See Background Image Loader on page 289 for more information.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>411</page_number>

A: Commands
sde:create-dialog

# sde:create-dialog

Creates a dialog box.

## Syntax

`(sde:create-dialog dlg-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dlg-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

Dialog ID.

## Description

This Scheme extension creates and registers a dialog object, and returns the dialog entity ID. (The dialog box is handled as a Scheme object.)

All subsequent `sde:dialog` functions use this dialog ID to add input fields, a bitmap image, and an **OK** button to the dialog box.

## Examples

`(define dlg (sde:create-dialog "2D MOSFET DEVICE"))`

<page_number>

412
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:define-parameter

# sde:define-parameter

Defines a Scheme parameter.

## Syntax

`(sde:define-parameter parameter-name value [min-value max-value])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>parameter-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>value</td>
        <td>REAL | STRING</td>
    </tr>
    <tr>
        <td>min-value</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>max-value</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

The defined parameter can be used later in any Scheme command. The parameter value can be accessed by typing `parameter-name`. The parameter can hold any Scheme type variable. Typically, it is a `REAL` or `STRING` type. For `REAL` values, two optional values also can be added: `min-value` and `max-value`. This might be useful when you write a parametric script, where a given parameter can be used and modified only within a certain range.

If `parameter-name` is `width`, for example, `width_min` will contain `min-value` and `width_max` will contain `max-value`. A Scheme variable also can be defined using the Scheme command `define`.

The difference is that the Scheme extension `sde:save-parameters` saves only those Scheme variables that were defined using the Scheme extension `sde:define-parameter`.

Sentaurus™ Structure Editor User Guide

<page_number>413</page_number>

S-2021.06

**A: Commands**
sde:delay-graphics-update

# sde:delay-graphics-update

Switches on and off the view window update.

## Syntax

`(sde:delay-graphics-update flag)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>flag</td>
        <td>BOOLEAN</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension switches on or off the refreshing or updating of the view window. By default, automatic refreshing of the view window is switched on. When a new body is created or the model is changed in any way that affects the graphical representation of the model, the view window is refreshed automatically.

In this way, the display always reflects the actual state of the database of the modeler. This behavior can be changed and the graphical update can be suppressed using this Scheme extension. By switching on the update option, the buffer is flushed and the screen is updated.

# sde:delay-graphics-update?

Returns the status of the `sde:delay-graphics-update` Scheme extension.

## Syntax

`(sde:delay-graphics-update?)`

## Returns

BOOLEAN

<page_number>

414
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sde:delete-bg-image

# sde:delete-bg-image

Removes the previously loaded image from memory.

## Syntax

```scheme
(sde:delete-bg-image)
```

## Returns

None

# sde:delete-materials

Deletes the geometric bodies with the specified DATEX material.

## Syntax

```scheme
(sde:delete-materials materials)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>materials</td>
        <td>DATEXMAT | DATEXMAT LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>415</page_number>

**A: Commands**

sde:delete-parameter

# sde:delete-parameter

Deletes a previously defined parameter.

## Syntax

`(sde:delete-parameter parameter-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>parameter-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

The parameter must be previously defined using `sde:define-parameter`.

## See Also

sde:define-parameter on page 413

<page_number>416</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:dialog-add-input

# sde:dialog-add-input

Adds an input field to a dialog box.

## Syntax

`(sde:dialog-add-input dlgid varname inputstrfield inputtype [default-value])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dlgid</td>
        <td>STRING DIALOG TYPE (object returned by<br/>sde:create-dialog)</td>
    </tr>
    <tr>
        <td>varname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>inputstrfield</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>inputtype</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>default-value</td>
        <td>VALUE (optional; according to inputtype)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension adds an input field to a dialog box. The argument `varname` is the Scheme variable name that is passed to the executed Scheme script. The argument `inputstrfield` is displayed in the input dialog box, and the argument `inputtype` is the type of input (STRING, INTEGER, REAL).

## Limitations

No default value can be assigned to the input fields and variables.

## Examples

```scheme
(sde:dialog-add-input dlg "width1" "Base Width" "real")
```

## See Also

sde:create-dialog on page 412

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>417</page_number>

A: Commands
sde:dialog-add-pixmap

# sde:dialog-add-pixmap

Adds a bitmap image to a dialog box.

## Syntax

`(sde:dialog-add-pixmap dlgid bmpfilename)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dlgid</td>
        <td>STRING DIALOG TYPE (object returned by sde:create-dialog)</td>
    </tr>
    <tr>
        <td>bmpfilename</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension adds a predefined bitmap image to a dialog box. The bitmap image must be scaled to the proper size before it is added to the dialog box.

## Examples

`(sde:dialog-add-pixmap dlg "mosfet2d.bmp")`

## See Also

sde:create-dialog on page 412

<page_number>

418
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:dialog-delete

# sde:dialog-delete

Removes a predefined dialog box from the memory.

## Syntax

`(sde:dialog-delete dlgid)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dlgid</td>
        <td>STRING DIALOG TYPE (object returned by sde:create-dialog)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

`(sde:dialog-delete dlg)`

## See Also

sde:create-dialog on page 412

Sentaurus™ Structure Editor User Guide 419

S-2021.06

A: Commands
sde:dialog-ok-command

# sde:dialog-ok-command

Binds the **OK** button of a dialog box to a predefined Scheme function.

## Syntax

`(sde:dialog-ok-command dlgid schemefnname argument-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dlgid</td>
        <td>STRING DIALOG TYPE (object returned by sde:create-dialog)</td>
    </tr>
    <tr>
        <td>schemefnname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>argument-list</td>
        <td>STRING LIST (in double quotation marks)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

When the **OK** button of the dialog box is clicked, this Scheme extension is called with the supplied argument list.

## Examples

```scheme
(sde:dialog-ok-command dlg "create-2d-mosfet" "width1 width2 width3
   height1 height2 height3")
```

## See Also

sde:create-dialog on page 412

<page_number>

420
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:dialog-show

# sde:dialog-show

Displays a predefined dialog box.

## Syntax

`(sde:dialog-show dlgid)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>dlgid</td>
        <td>STRING DIALOG TYPE (object returned by sde:create-dialog)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

`(sde:dialog-show dlg)`

## See Also

sde:create-dialog on page 412

Sentaurus™ Structure Editor User Guide <page_number>421</page_number>
S-2021.06

A: Commands

sde:display

# sde:display

Displays a string in the command-line window.

## Syntax

`(sde:display string)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>string</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension displays the specified string in the command-line window. A new line character is required to send the contents of the `sde:display` buffer to the command-line window.

This Scheme extension is useful if you write your own Scheme scripts and the function needs to display some information.

<page_number>

422
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sde:display-err

# sde:display-err

Writes a string in a terminal window.

## Syntax

`(sde:display-err string)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>string</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension writes the specified string in a terminal window. A new line character is added to the argument string.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>423</page_number>

A: Commands
sde:display-std

# sde:display-std

Writes a string in a terminal window.

## Syntax

`(sde:display-std string)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>string</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension writes the specified string in a terminal window. A new line character is added to the argument string.

For the design-of-experiments (DoE) parameter extraction of Sentaurus Workbench, this Scheme extension must be used to send the information to Sentaurus Workbench. (Sentaurus Workbench collects the DoE-marked output from standard output.)

## Examples

For the DoE parameter extraction, the output string must contain the `DOE:` string, followed by the variable name and the value of the variable:

```
(sde:display-std "DOE: VARNAME VARVALUE")
```

For example:

```
(sde:display-std "DOE: width 2.5")
(sde:display-std "DOE: doping @value@")
```

**NOTE** You must initialize the `VARNAME` variable in the Sentaurus Workbench script to avoid preprocessing errors. For example:

```
#set width 0
#set doping 0
```

<page_number>

424
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:draw-ruler

# sde:draw-ruler

Draws a user-defined ruler that can be displayed in the GUI.

## Syntax

```scheme
(sde:draw-ruler "startpos" startpos "alength" alength "adir" adir
 "startval" startval "endval" endval ["numdiv" numdiv] ["numdiv2" numdiv2]
 ["npos" npos] ["acolor" acolor] ["tcolor" tcolor])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>startpos</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>alength</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>adir</td>
        <td>INTEGER (0 | 1 | 2)</td>
    </tr>
    <tr>
        <td>startval</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>endval</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>numdiv</td>
        <td>INTEGER (default is 5) (optional)</td>
    </tr>
    <tr>
        <td>numdiv2</td>
        <td>INTEGER (default is 2) (optional)</td>
    </tr>
    <tr>
        <td>npos</td>
        <td>INTEGER (0 | 1) (default is 1) (optional)</td>
    </tr>
    <tr>
        <td>acolor</td>
        <td>COLOR (optional)</td>
    </tr>
    <tr>
        <td>tcolor</td>
        <td>COLOR (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension draws a user-defined ruler that can be displayed in the GUI.

The argument `"startpos"` defines the starting position of the ruler in 3D space. The argument `"alength"` specifies the length of the ruler.

The ruler direction is specified by the `"adir"` argument, where:

* `"adir" 0` specifies the global x-axis direction.

* `"adir" 1` specifies the y-axis direction.

* `"adir" 2` specifies the z-axis direction.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>425</page_number>

# A: Commands

sde:draw-ruler

The arguments `"startval"` and `"endval"` define the start and end values of the coordinate axes.

The optional `"numdiv"` and `"numdiv2"` arguments specify the number of main tick divisions and the number of subdivisions in each main division, respectively, where the ruler will draw the subdivision ticks.

The optional `"npos"` argument specifies the position of the displayed numbers:

* For an x-axis ruler (`"adir"` 0):

    - `"npos" 1` specifies that the numbers are drawn below the axis.

    - `"npos" 0` specifies that the numbers are drawn above the axis.

* For a y-axis ruler (`"adir"` 1):

    - `"npos" 1` indicates the right y-axis.

    - `"npos" 0` indicates the left y-axis.

The `"acolor"` argument is the axis color and takes a `color:rgb` value. This color can also be set by specifying `BLACK`, `BLUE`, `CYAN`, `GREEN`, `MAGENTA`, `RED`, `WHITE`, or `YELLOW`.

The `"tcolor"` argument is the text color and takes a `color:rgb` value. This color can also be set by specifying `BLACK`, `BLUE`, `CYAN`, `GREEN`, `MAGENTA`, `RED`, `WHITE`, or `YELLOW`.

You can hide user-defined rulers in the GUI using the `sde:hide-ruler` Scheme extension.

> **NOTE** If you change the parameters of a user-defined ruler, you must use the `sde:hide-ruler` Scheme extension *first* to erase the previously defined ruler. After this step, the ruler can be redrawn with the new parameters using the `sde:draw-ruler` Scheme extension.

## Examples

```
(sde:clear)
(sdegeo:create-cuboid (position 0 0 0)(position 5 4 2) "Silicon" "xx")
(sde:draw-ruler "startpos" (position 0 4 0) "alength" 6 "adir" 0 "startval" 0
      "endval" 6 "numdiv" 6 "numdiv2" 5 "npos" 1 "acolor" GREEN "tcolor" BLUE)
(sde:draw-ruler "startpos" (position 5 0 0) "alength" 5 "adir" 1 "startval" 0
      "endval" 5 "numdiv" 5 "numdiv2" 5 "npos" 1 "acolor" GREEN "tcolor" BLUE)
(sde:draw-ruler "startpos" (position 5 4 0) "alength" 3 "adir" 2 "startval" 0
      "endval" 3 "numdiv" 3 "numdiv2" 5 "npos" 1 "acolor" GREEN "tcolor" BLUE)
```

## See Also

sde:hide-ruler on page 444

<page_number>426</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sde:dump-non-default-options

# sde:dump-non-default-options

Saves all nondefault ACIS options to a text file.

## Syntax

`(sde:dump-non-default-options fname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>fname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension saves a text file containing all the ACIS options that are set to nondefault values. This helps to debug and report problems because, in some cases, nondefault option settings can cause problems or can trigger a different behavior than expected.

The argument `fname` specifies the file name.

# sde:exact-coords?

Checks the status of the Exact Coordinates mode.

## Syntax

`(sde:exact-coords?)`

## Returns

BOOLEAN

## Description

If exact coordinates are used, this Scheme extension returns #t.

If the Exact Coordinates mode is switched off, it returns #f.

Sentaurus™ Structure Editor User Guide <page_number>427</page_number>
S-2021.06

A: Commands
sde:extract-tdr-boundary

# sde:extract-tdr-boundary

Extracts the boundary from a TDR grid file.

## Syntax

`(sde:extract-tdr-boundary fname [file-name])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>fname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>file-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension extracts the boundary and saves it in a TDR boundary file from a TDR grid file. This Scheme extension uses Sentaurus Mesh through a system call to extract the boundary. An optional `file-name` argument can also be specified for the extracted TDR boundary.

<page_number>428</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:fix-imprint

# sde:fix-imprint

Generates a conformal model by imprinting the model edges and faces to neighboring bodies.

## Syntax

```scheme
(sde:fix-imprint)
```

## Returns

None

## Description

The generated model must be tessellated before meshing, and several different conformity requirements must be satisfied. One of the most important requirements is that neighboring bodies share the boundary edges (in two dimensions) and the boundary faces (in three dimensions). Before the tessellated model is generated, Sentaurus Structure Editor automatically imprints the edges and faces of the neighboring bodies to each other. During model generation, the modeler tries to create a conformal model in each modeling step, but several operations can destroy model conformity by merging collinear edges and coplanar faces. In this case, the sde:fix-imprint Scheme extension restores model conformity.

# sde:fix-orientation

Modifies the orientation of 3D bodies.

## Syntax

```scheme
(sde:fix-orientation)
```

## Returns

None

## Description

This Scheme extension fixes the orientation of 3D regions, with surface normals pointing ‘inside’ the body. Mainly native ACIS models, generated by other CAD tools and imported as .sat files, might have this problem. Direct-geometry generation functions in Sentaurus Structure Editor always generate 3D bodies with positive volume and surface normals pointing outside.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

429
</page_number>

A: Commands

sde:front-coord

# sde:front-coord

Returns the front coordinate of the device.

## Syntax

`(sde:front-coord body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme extension returns the front coordinate of the specified body or body-list. The front coordinate depends on the coordinate system used:

* For the UCS, the front coordinate is the maximum z-coordinate.

* For the DF–ISE coordinate system, the front coordinate is the maximum x-coordinate.

<page_number>

430
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:ft_scalar

# sde:ft_scalar

Writes a string or string–value pair in a terminal window.

## Syntax

```scheme
(sde:ft_scalar string [value])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>string</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>value</td>
        <td>STRING | REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension writes the specified string or string–value pair in a terminal window. A new line character is added to the argument string.

For the design-of-experiments (DoE) parameter extraction of Sentaurus Workbench, this Scheme extension must be used to send the information to Sentaurus Workbench. (Sentaurus Workbench collects the DoE-marked output from standard output.)

## Examples

```scheme
(sde:ft_scalar "aval 3")
(sde:ft_scalar "aval" 3)
```

Sentaurus™ Structure Editor User Guide

<page_number>431</page_number>

S-2021.06

**A: Commands**
sde:get-backwards-compatibility

# sde:get-backwards-compatibility

Returns the value of the given backward-compatibility parameter.

## Syntax

`(sde:get-backwards-compatibility backcompat-param)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>backcompat-param</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

Value of the given backward-compatibility parameter `backcompat-param`; otherwise, returns `#f` if the given `backcompat-param` does not exist.

## Description

This Scheme extension returns the value of the given backward-compatibility parameter. Backward-compatibility parameters are specific, internally defined, parameters that are used to reproduce certain defined functionality from previous releases of Sentaurus Structure Editor.

For the available backward-compatibility parameters, see sde:set-backwards-compatibility on page 475.

# sde:get-datex-color-scheme

Returns the current setting of the DATEX color scheme.

## Syntax

`(sde:get-datex-color-scheme)`

## Returns

"Vivid" or "Classic"

<page_number>432</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:get-default-material

# sde:get-default-material

Returns the active DATEX material.

## Syntax

```scheme
(sde:get-default-material)
```

## Returns

None

## Description

This Scheme extension returns the selected DATEX material in a string. The DATEX material can be selected from the GUI using the material list or the Scheme extension `sde:set-default-material`.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>433</page_number>

**A: Commands**

sde:get-view-params

# sde:get-view-params

Records the current GUI settings (rotation, zoom, and so on).

## Syntax

```scheme
(sde:get-view-params)
```

## Returns

A list containing:

```
eye position        POSITION
target position     POSITION
up-vector           GVECTOR
width               REAL
height              REAL
projection          STRING
```

## Description

This Scheme extension takes no arguments and returns a list, which contains all the necessary data to restore the GUI view to the recorded state.

The Scheme extension `sde:set-view-params` can be used to restore the settings.

## Examples

```scheme
(define myview (sde:get-view-params))
(sde:set-view-params myview)
```

## See Also

sde:set-view-params on page 484

<page_number>434</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:gui-get-integer

# sde:gui-get-integer

Displays a dialog box to define an integer variable.

**NOTE** This Scheme extension can be used in GUI mode only.

## Syntax

`(sde:gui-get-integer variable-name default-value [dialog-name])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>variable-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>default-value</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>dialog-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

INTEGER or #f

## Description

This Scheme extension displays a dialog box that can be used to enter an integer variable. The `variable-name` is displayed.

The argument `default-value` is used as a default value of the variable. When the **OK** button is clicked, the function returns the entered integer, or #f if incorrect input was given or the **Cancel** button was clicked. The optional argument `dialog-name` can be used to define the name of the input dialog box.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>435</page_number>

A: Commands
sde:gui-get-real

# sde:gui-get-real

Displays a dialog box to define a real variable.

**NOTE** This Scheme extension can be used in GUI mode only.

## Syntax

`(sde:gui-get-real variable-name default-value [dialog-name])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>variable-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>default-value</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>dialog-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

REAL or #f

## Description

This Scheme extension displays a dialog box that can be used to enter a real variable. The `variable-name` is displayed.

The argument `default-value` is used as a default value of the variable. When the **OK** button is clicked, the function returns the entered integer, or #f if incorrect input was given, or the **Cancel** button was clicked. The optional argument `dialog-name` can be used to define the name of the input dialog box.

<page_number>436</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:gui-get-string

# sde:gui-get-string

Displays a dialog box to define a string variable.

**NOTE** This Scheme extension can be used in GUI mode only.

## Syntax

`(sde:gui-get-string variable-name default-value [dialog-name])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>variable-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>default-value</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>dialog-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

STRING or #f

## Description

This Scheme extension displays a dialog box that can be used to enter a string variable. The `variable-name` is displayed.

The argument `default-value` is used as a default value of the variable. When the **OK** button is clicked, the function returns the entered string value, or #f if incorrect input was given or the **Cancel** button was clicked. The optional argument `dialog-name` can be used to define the name of the input dialog box.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

437
</page_number>

A: Commands

sde:hide

# sde:hide

Removes the specified entity or entities from the view window.

## Syntax

```scheme
(sde:hide entity | entity-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension removes the specified entities from the view window, and the view window is refreshed. If the entities are already removed from the view window, there is no change in the view window.

## Examples

```scheme
(sde:clear)
(define r1 (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Photoresist" "r_1"))
(define r2 (sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "r_2"))
(define r3 (sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist"
  "r_3"))
(define r4 (sdegeo:create-rectangle (position 6 0 0) (position 7 1 0)
  "PolySilicon" "r_4"))
(sde:hide r1)
(sde:hide (list r3 r4))
```

<page_number>438</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:hide-bg-image

# sde:hide-bg-image

Hides the previously loaded image.

## Syntax

```scheme
(sde:hide-bg-image)
```

## Returns

None

# sde:hide-contact

Removes from the view window all the regions that have the specified contact attributes.

## Syntax

```scheme
(sde:hide-contact contact-name | contact-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>contact-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>contact-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension removes from the view window all regions that have contacts defined with the specified contact attributes. Contacts are identified with the attribute name `contact`. In two dimensions, contacts are edges and, in three dimensions, contacts are faces.

Sentaurus™ Structure Editor User Guide
439
S-2021.06

A: Commands
sde:hide-interface

# sde:hide-interface

Removes from the view the specified interfaces.

## Syntax

```scheme
(sde:hide-interface interface-name | interface-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>interface-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>interface-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension removes from the view all regions that have interfaces defined with the specified interface attributes. Interfaces are identified with the attribute name `interface`. In two dimensions, interfaces are edges between neighboring regions and, in three dimensions, interfaces are faces between neighboring regions.

<page_number>440</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:hide-mask

# sde:hide-mask

Removes the specified masks from the view window.

## Syntax

`(sde:hide-mask mask-name | mask-name-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>mask-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>mask-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension removes the specified masks from the view window. Masks are planar wire bodies that have the specified `mask-names` as ‘mask name’ attributes.

Sentaurus™ Structure Editor User Guide <page_number>441</page_number>
S-2021.06

# A: Commands

sde:hide-material

---

# sde:hide-material

Removes the entities with the specified materials from the view window.

## Syntax

```scheme
(sde:hide-material datex-material | datex-material-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>datex-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>datex-material-list</td>
        <td>DATEXMAT LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension removes regions that have the specified material names as material attributes from the view window. The region is removed from the view window, and the view window is refreshed.

If the region is already removed from the view window, there is no change in the view window. The argument is either a DATEX material or a list of DATEX materials.

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Photoresist"
  "region_1")
(sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "region_2")
(sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist" "region_3")
(sdegeo:create-rectangle (position 6 0 0) (position 7 1 0) "PolySilicon"
  "region_4")
(sde:hide-material "Silicon")
```

<page_number>442</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:hide-region

# sde:hide-region

Removes the specified entity or entities from the view window.

## Syntax

```scheme
(sde:hide-region region-name | region-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region-name</td>
        <td>STRING (existing region name)</td>
    </tr>
    <tr>
        <td>region-name-list</td>
        <td>STRING LIST (existing region names)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension removes the specified regions from the view window. The bodies that have the specified region names as region attributes are removed from the view window, and the view window is refreshed.

If the region is already removed from the view window, there is no change in the view window.

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Photoresist"
  "region_1")
(sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "region_2")
(sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist" "region_3")
(sdegeo:create-rectangle (position 6 0 0) (position 7 1 0) "PolySilicon"
  "region_4")
(sde:hide-region "region_1")
(sde:hide-region (list "region_3" "region_4"))
```

Sentaurus™ Structure Editor User Guide <page_number>443</page_number>
S-2021.06

**A: Commands**

sde:hide-ruler

# sde:hide-ruler

Hides all user-defined rulers in the GUI.

## Syntax

```
(sde:hide-ruler)
```

## Returns

BOOLEAN

## Examples

```
(sde:hide-ruler)
```

## See Also

sde:draw-ruler on page 425

# sde:info

Returns the attributes of Sentaurus Structure Editor attached to the specified bodies.

## Syntax

`(sde:info entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

STRING

## Description

This Scheme extension displays the entity number, and material and region attributes that are attached to the body.

<page_number>444</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:left-coord

# sde:left-coord

Returns the left coordinate of the device.

## Syntax

`(sde:left-coord body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Description

This Scheme extension returns the left coordinate of the specified `body` or `body-list`. The left coordinate is the minimum y-coordinate.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>445</page_number>

A: Commands
sde:load-sat

# sde:load-sat

Loads a native ACIS .sat file into Sentaurus Structure Editor, with correct overlap handling.

## Syntax

`(sde:load-sat file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The difference between `part:load` and `sde:load-sat` is that the latter handles overlapping regions correctly, according to the active Boolean setting. If a .sat file is loaded into the modeler, which already has some bodies defined, the overlaps are resolved according to the Boolean setting.

<page_number>446</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:material-type

# sde:material-type

Returns the group type for the specified material.

## Syntax

`(sde:material-type material-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>material-name</td>
        <td>DATEXMAT</td>
    </tr>
  </tbody>
</table>

## Returns

group-name or an empty string if the specified material is not found in the `datexcodes.txt` file

## Description

This Scheme extension returns the group type from the `datexcodes.txt` file for the given material. The group type can be `Semiconductor`, or `Conductor`, or `Insulator`.

# sde:max-x

Returns the maximum x-dimension of the specified `body` or `body-list`.

## Syntax

`(sde:max-x body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

Sentaurus™ Structure Editor User Guide

<page_number>447</page_number>

S-2021.06

A: Commands

sde:max-y

# sde:max-y

Returns the maximum y-dimension of the specified body or body-list.

### Syntax

`(sde:max-y body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

# sde:max-z

Returns the maximum z-dimension of the specified body or body-list.

### Syntax

`(sde:max-z body | body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

<page_number>448</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sde:merge-materials

# sde:merge-materials

Merges the geometric bodies with the specified DATEX material.

## Syntax

`(sde:merge-materials materials newmaterial)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>materials</td>
        <td>DATEXMAT | DATEXMAT LIST</td>
    </tr>
    <tr>
        <td>newmaterial</td>
        <td>DATEXMAT</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension merges (unites) a copy of the geometric bodies with the specified DATEX `materials`, and the `newmaterial` DATEX material is assigned to the new united body.

**NOTE** The new united body will overlap with the original bodies. The `entity:delete` command must be used to delete the original bodies, or the overlaps must be removed by other operations before the tessellated boundary file is created.

Sentaurus™ Structure Editor User Guide

<page_number>449</page_number>

S-2021.06

A: Commands

sde:min-x

# sde:min-x

Returns the smallest x-dimension of the specified body or body-list.

## Syntax

```scheme
(sde:min-x body | body-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

# sde:min-y

Returns the smallest y-dimension of the specified body or body-list.

## Syntax

```scheme
(sde:min-y body | body-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

<page_number>450</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sde:min-z

# sde:min-z

Returns the smallest z-dimension of the specified `body` or `body-list`.

## Syntax

```scheme
(sde:min-z body | body-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

# sde:new-region-name

Returns an automatically generated region name.

## Syntax

```scheme
(sde:new-region-name)
```

## Returns

STRING

## Description

This Scheme extension returns a region name `region_%N`, where `%N` is the actual region counter. If the region counter is set correctly, this Scheme extension always returns a unique region name.

Sentaurus™ Structure Editor User Guide

<page_number>451</page_number>

S-2021.06

A: Commands

sde:off-lights

# sde:off-lights

Switches off the lights in the view window.

## Syntax

```
(sde:off-lights)
```

## Returns

None

# sde:offset-mask

Offsets (or biases) the specified mask.

## Syntax

`(sde:offset-mask mask-name offset-distance)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>mask-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>offset-distance</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

# sde:on-lights

Switches on the lights in the view window.

## Syntax

```
(sde:on-lights)
```

## Returns

None

<page_number>452</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:open-model

# sde:open-model

Loads a complete Sentaurus Structure Editor model.

## Syntax

`(sde:open-model file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is the counterpart of `sde:save-model`. It restores the complete state of the modeler. First, `filename.sat` is loaded if it exists. It is a native ACIS .sat file that contains the geometric description of the model, including Ref/Eval windows, with all the attributes and contacts of Sentaurus Structure Editor that are attached.

The .sat file is loaded using the `sde:part-load` command, so the automatic overlap resolution works the same way as for the `sde:part-load` command. Check the usage of the global Boolean variable `aut-overlap-control` in `sde:part-load` on page 454.

If the working directory does not include a `filename.sat` file, the loader checks for the existence of a TDR boundary file, `filename_bnd.tdr` (or if it is not found, the loader checks for `filename.tdr`). If a TDR boundary file is found, this file is imported into Sentaurus Structure Editor.

A `filename.scm` file also is loaded if it exists. This file contains all of the defined parameters. Finally, a mesh command file, `filename_msh.cmd`, is loaded if it exists. If this file does not exist, the loader checks for `filename.cmd` and loads it if it is found. This file contains all refinement-related and doping-related information.

## See Also

Sentaurus™ Mesh User Guide, Chapter 2 on page 5

Sentaurus™ Structure Editor User Guide <page_number>453</page_number>
S-2021.06

A: Commands

sde:part-load

# sde:part-load

Loads a native ACIS .sat file into Sentaurus Structure Editor, with correct overlap handling.

## Syntax

`(sde:part-load file-name [loadoption])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>loadoption</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used for automatic overlap control of loaded .sat files.

A global Boolean variable, `aut-overlap-control`, determines whether to load .sat files with automatic overlap control. If it is `#f` (default value), the newly loaded .sat file is loaded without checking for overlaps. If it is set to `#t`, the newly loaded .sat file is loaded in such a way that the default Boolean overlap setting will be taken into consideration and the overlaps will be resolved.

> **NOTE** Use `(sdegeo:get-default-boolean)` to check the current status of the automatic overlap-handling setting.

Since the automatic overlap control slows down model loading considerably, it is helpful to use the default `#f` value for `aut-overlap-control` if it is known that the loaded files contain only conformal, non-overlapping regions.

When `aut-overlap-control #t` is set, the overlaps are checked and resolved within the loaded model.

## See Also

sdegeo:get-default-boolean on page 658

<page_number>

454
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:pick-point-on-wp

# sde:pick-point-on-wp

Selects a point on the view window.

## Syntax

```scheme
(sde:pick-point-on-wp)
```

## Returns

POSITION

## Description

This Scheme extension is used to select a point on the view window. The global xyz coordinates of the selected point are returned as a position entity. The point is always selected in the active work plane. (This Scheme extension draws a cross-hair cursor on the screen, and a horizontal line and vertical line also help the positioning.) In addition, the exact coordinates and snap-to-grid options can be used together with this Scheme extension.

# sde:pick-two-points-on-wp

Selects two points on the view window.

## Syntax

```scheme
(sde:pick-two-points-on-wp)
```

## Returns

POSITION LIST

## Description

This Scheme extension is used to select two points on the view window. The global xyz coordinates of the selected points are returned as a list of two position entities. The points are always selected in the active work plane. (This Scheme extension draws a cross-hair cursor on the screen, and a horizontal and vertical line also help the positioning.)

In addition, the exact coordinates and snap-to-grid options can be used together with this Scheme extension. The first point is selected by pressing the mouse button; drag to draw a line from the first point. When the mouse button is released, the two positions are returned.

Sentaurus™ Structure Editor User Guide

S-2021.06
<page_number>

455
</page_number>

A: Commands

sde:post-message

# sde:post-message

Displays a dialog box with a message.

## Syntax

`(sde:post-message message)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>message</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension displays a message in a dialog box. The **OK** button of the dialog box must be clicked to cancel the message.

## Examples

`(sde:post-message "Hello World")`

<page_number>

456
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:project-name

# sde:project-name

Returns the project name.

## Syntax

```scheme
(sde:project-name)
```

## Returns

STRING

## Description

This Scheme extension returns the project name, which is used in the Build Mesh dialog box to save the created mesh file. The project name can be set using the `sde:set-project-name` command.

## See Also

sde:set-project-name on page 479

Sentaurus™ Structure Editor User Guide

S-2021.06
<page_number>

457
</page_number>

A: Commands
sde:refresh

# sde:refresh

Refreshes and rebuilds the view window.

## Syntax

`(sde:refresh)`

## Returns

None

## Description

This Scheme extension discards the existing entity display list and regenerates it from the entity data. This is useful when the view zooms in on entities, because the display might appear jagged.

This Scheme extension destroys the existing display list, regenerates it from the entities at the new zoom level, and redisplays the entities in all views associated with the part.

If only GUI actions are used to manipulate the view and modeler, the view is always updated and there is no need to call `(sde:refresh)`.

<page_number>458</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:rename-regions

# sde:rename-regions

Automatically renames regions based on spatial criteria.

## Syntax

`(sde:rename-regions entity-list direction)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
    <tr>
        <td>direction</td>
        <td>+x | "-x" | "+y" | "-y" | "+z" | "-z"</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension renames the specified geometric bodies.

The geometric bodies are ordered, based on the specified direction, and a region name sequence is attached to the bodies.

For example, if the direction is "+x", the bodies are ordered based on their minimal bounding box x-coordinates. Then, a "region_RC" region name is attached to each body, where RC is a numeric region counter, starting from 0. The "region_0" region name is attached to the body with the smallest minimal bounding box x-coordinate, "region_1" is the body with the second minimal bounding box x-coordinate, and so on.

When the direction is "-x", the largest bounding box x-coordinates are ordered in a decreasing sequence. Similar rules apply to "+y", "-y", "+z", and "-z".

Sentaurus™ Structure Editor User Guide
<page_number>459</page_number>
S-2021.06

A: Commands
sde:restore-cursor

---

# sde:restore-cursor

Reverts the pointer to the default pointer.

### Syntax

```scheme
(sde:restore-cursor)
```

### Returns

None

---

# sde:right-coord

Returns the right coordinate of the device.

### Syntax

```scheme
(sde:right-coord body | body-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

### Description

This Scheme extension returns the right coordinate of the specified `body` or `body-list`. The right coordinate is the maximum y-coordinate.

<page_number>460</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:save-model

# sde:save-model

Saves all information about a model.

## Syntax

`(sde:save-model file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension performs a complex task. It calls several other functions to save the complete model. The Scheme extension `sde:open-model` is the counterpart of this Scheme extension that loads the model and restores the original model completely. It saves a native ACIS .sat file to store the model geometry and Ref/Eval windows. The .sat file stores the curved boundaries and all the attributes of Sentaurus Structure Editor that are attached to the model.

This Scheme extension also saves a mesh command file that contains all refinement-related and doping-related information. A Scheme file also is saved containing all of the defined parameters.

These three files are sufficient to save and restore the complete state of the modeler. In addition, a TDR boundary file is saved. This file contains a tessellated model, so it cannot be used to restore the complete geometric model if curved boundaries are present.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

461
</page_number>

**A: Commands**

sde:save-parameters

# sde:save-parameters

Saves the defined parameters to a `.scm` file.

## Syntax

`(sde:save-parameters file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension saves all defined parameters (Scheme variables) that were created using `sde:define-parameter`. The saved Scheme file can be edited and used for later sessions to restore the complete previous state of the modeler. Some information about the GUI (such as size and background color) is recorded as well.

<page_number>462</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:save-tcl-parameters

# sde:save-tcl-parameters

Saves the defined contact colors to a Tcl file.

## Syntax

```scheme
(sde:save-tcl-parameters file-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension saves the defined contact colors to a Tcl file, using the contact color assignment syntax of Sentaurus Visual. The saved Tcl file can be loaded into Sentaurus Visual, after a TDR file is loaded. The contacts of the TDR file will have the same colors in Sentaurus Visual as in Sentaurus Structure Editor.

## Examples

### Example 1:

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "x1")
(sdegeo:create-rectangle (position 0.3 1 0) (position 0.7 1.5 0)
  "PolySilicon" "x2")
(sdegeo:define-contact-set "red"   4 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "green" 4 (color:rgb 0 1 0) "##")
(sdegeo:define-contact-set "blue"  4 (color:rgb 0 0 1) "##")
(sdegeo:define-contact-set "black" 4 (color:rgb 0 0 0) "##")

(sdegeo:set-contact (list (car (find-edge-id (position 0.1 1 0)))) "red")
(sdegeo:set-contact (list (car (find-edge-id (position 0.5 1.5 0)))) "green")
(sdegeo:set-contact (list (car (find-edge-id (position 0.9 1 0)))) "blue")
(sdegeo:set-contact (list (car (find-edge-id (position 0.1 0 0)))) "black")

(sdeio:save-tdr-bnd (get-body-list) "xx2d.tdr")
(sde:save-tcl-parameters "xx2d.tcl")
```

Sentaurus™ Structure Editor User Guide

<page_number>463</page_number>

S-2021.06

# A: Commands

sde:save-tcl-parameters

The file `xx2d.tcl` contains the following:

```tcl
set_region_prop {red}   -color #FF0000
set_region_prop {green} -color #00FF00
set_region_prop {blue}  -color #0000FF
set_region_prop {black} -color #000000
```

Example 2:

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0   0 0)   (position 1   1 0.4)
 "Silicon" "x1")
(sdegeo:create-cuboid (position 0.3 0 0.4) (position 0.7 1 0.6)
 "PolySilicon" "x2")
(sdegeo:define-contact-set "red"   4 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "green" 4 (color:rgb 0 1 0) "##")
(sdegeo:define-contact-set "blue"  4 (color:rgb 0 0 1) "##")
(sdegeo:define-contact-set "black" 4 (color:rgb 0 0 0) "##")

(sdegeo:set-contact (list (car (find-face-id (position 0.1 0.1 0.4)))) "red")
(sdegeo:set-contact (list (car (find-face-id (position 0.5 0.1 0.6))))
 "green")
(sdegeo:set-contact (list (car (find-face-id (position 0.9 0.1 0.4)))) "blue")
(sdegeo:set-contact (list (car (find-face-id (position 0.1 0.1 0)))) "black")

(sdeio:save-tdr-bnd (get-body-list) "xx3d.tdr")
(sde:save-tcl-parameters "xx3d.tcl")
```

The file `xx3d.tcl` is the same as `xx2d.tcl`.

<page_number>464</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sde:scale-scene

# sde:scale-scene

Scales the model in the view window.

## Syntax

`(sde:scale-scene xs ys zs)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>xs</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>ys</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>zs</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension scales the model in the view window. This is only a view scale. The model coordinates do not change. The operation can be used to magnify, for example, thin layers.

To return to the original view, use:

```
(sde:scale-scene 1 1 1)
```

Sentaurus™ Structure Editor User Guide

<page_number>465</page_number>

S-2021.06

**A: Commands**

sde:scmwin-get-font-families

# sde:scmwin-get-font-families

Returns the available font types that are used in the command-line window.

**Syntax**

```scheme
(sde:scmwin-get-font-families)
```

**Returns**

STRING

# sde:scmwin-get-font-family

Returns the font type used in the command-line window.

**Syntax**

```scheme
(sde:scmwin-get-font-family)
```

**Returns**

STRING

# sde:scmwin-get-font-size

Returns the font size used in the command-line window.

**Syntax**

```scheme
(sde:scmwin-get-font-size)
```

**Returns**

INTEGER

<page_number>466</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands

sde:scmwin-get-font-style

# sde:scmwin-get-font-style

Returns the font style used in the command-line window.

## Syntax

```scheme
(sde:scmwin-get-font-style)
```

## Returns

PAIR

## Description

This Scheme extension returns a pair:

*   The first value is 0 (Normal), or 1 (Italic), or 2 (Oblique).

*   The second value is either #t (Bold) or #f.

# sde:scmwin-get-window-height

Returns the height of the command-line window in terms of number of lines (or rows).

## Syntax

```scheme
(sde:scmwin-get-window-height)
```

## Returns

INTEGER

# sde:scmwin-select-font

Displays the Select Font dialog box, which is used to select the font, the font style, and the size of the command-line window.

## Syntax

```scheme
(sde:scmwin-select-font)
```

## Returns

BOOLEAN

Sentaurus™ Structure Editor User Guide

S-2021.06
<page_number>

467
</page_number>

A: Commands

sde:scmwin-set-font-family

# sde:scmwin-set-font-family

Sets the font type to be used in the command-line window.

**Syntax**

`(sde:scmwin-set-font-family font-type)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>font-type</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

**Returns**

BOOLEAN

# sde:scmwin-set-font-size

Sets the font size to be used in the command-line window.

**Syntax**

`(sde:scmwin-set-font-size font-size)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>font-size</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

**Returns**

BOOLEAN

<page_number>468</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:scmwin-set-prefs

# sde:scmwin-set-prefs

Sets the preferences of the command-line window.

## Syntax

`(sde:scmwin-set-prefs font-type font-style font-size cmdwin-height)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>font-type</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>font-style</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>font-size</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>cmdwin-height</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension sets the preferences of the command-line window. The argument `font-type` specifies the command-line window font. Use `sde:scmwin-get-font-families` for the available fonts and `sde:scmwin-get-font-family` for the active setting. The argument `font-style` can be used to set the actual font style.

The Scheme extension `sde:scmwin-select-font` displays the Select Font dialog box, which can be used to change font styles. The argument `font-size` is used to set the required font size, and `cmdwin-height` specifies the height of the command-line window.

Sentaurus™ Structure Editor User Guide <page_number>469</page_number>
S-2021.06

A: Commands
sde:scmwin-set-window-height

# sde:scmwin-set-window-height

Sets the height (in pixels) of the command line window.

**Syntax**

`(sde:scmwin-set-window-height height)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>height</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

**Returns**

BOOLEAN

# sde:scmwin-suppress-output

Displays or hides messages in the command-line window.

**Syntax**

`(sde:scmwin-suppress-output bool)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>bool</td>
        <td>BOOLEAN</td>
    </tr>
  </tbody>
</table>

**Returns**

None

<page_number>470</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:selected-entities

# sde:selected-entities

Returns the currently active selected entities in a Scheme list.

## Syntax

`(sde:selected-entities)`

## Returns

ENTITY LIST

## Description

This Scheme extension returns the currently active selected entities in a Scheme list. The selection tools of the GUI (Select mode) can be used to select geometric entities (body, face, edge, vertex). The selected entities are highlighted.

# sde:selected-refeval-windows

Returns the names of the currently selected Ref/Eval windows in a Scheme list.

## Syntax

`(sde:selected-refeval-windows)`

## Returns

ENTITY LIST

## Description

The selection tools of the GUI (Select mode) can be used to select previously defined Ref/Eval windows. The selected Ref/Eval windows are highlighted.

Sentaurus™ Structure Editor User Guide

<page_number>471</page_number>

S-2021.06

A: Commands
sde:separate-lumps

# sde:separate-lumps

Separates the lumps in a body.

## Syntax

```scheme
(sde:separate-lumps [NULL | body | body-list])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY LIST`

## Description

Geometric operations can result in models with bodies that have multiple lumps (disjoint parts of a body). Since each body has a unique region-name attribute, these separate lumps in a body will have the same region name. As the Synopsys meshing engines require a unique region name for each disjoint region, bodies with multiple lumps must be separated before a TDR boundary file is generated.

This Scheme extension separates lumps and is also called automatically before a TDR boundary file is generated. For example, if the original region name was `region_1` and it has three lumps before `sde:separate-lumps` is called, this Scheme extension 'breaks' the body into three parts and assigns a unique region name to each. A `_lump_N` string is added to each lump, where `N` is the lump counter, starting from 1. Therefore, three new bodies are generated with the region names `region_1_lump_1`, `region_1_lump_2`, and `region_1_lump_3`.

If the argument list is empty, all geometric bodies are separated. Alternatively, either a single body or a body list can be specified in the argument list, in which case, only the specified entities are separated.

This Scheme extension returns the newly created body list (which contains the entity IDs of the separated lumps).

<page_number>472</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sde:separate-lumps

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 10 3 0) "Silver"
  "region_1")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-rectangle (position 4 -1 0) (position 6 4 0) "Silicon"
  "region_2")
; region_1 will have two lumps !
(get-body-list)
; returns the entity ids of the two bodies
(sde:separate-lumps)
(get-body-list)
; returns the entity ids of the three bodies
; region_1 was separated into two bodies, with region names
; region_1_lump_1 and region_1_lump_2
```

Sentaurus™ Structure Editor User Guide

<page_number>473</page_number>

S-2021.06

A: Commands

sde:set-background-color

# sde:set-background-color

Sets the background color of the main window of the GUI.

## Syntax

`(sde:set-background-color rtop gtop btop rbottom gbottom bbottom)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rtop</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>gtop</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>btop</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>rbottom</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>gbottom</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>bbottom</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The RGB colors for the top and bottom must be specified (0–255). If the top and bottom colors differ, a graded background will be used. If the top and bottom RGB colors match, the background will be uniform.

<page_number>474</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:set-backwards-compatibility

# sde:set-backwards-compatibility

Sets the value of the overall backward compatibility or the given backward-compatibility parameter.

## Syntax

```scheme
(sde:set-backwards-compatibility { backcompat-release | backcompat-param
  backcompat-release [ backcompat-param2 backcompat-release2 ... ] })
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>backcompat-release</td>
        <td>STRING corresponding to release version. For example:<br/>"R-2020.09"</td>
    </tr>
    <tr>
        <td>backcompat-param</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

Returns `#t` upon successful setting of overall backward compatibility or backward-compatibility parameters.

## Description

This Scheme extension, if called with one parameter, sets the general backward compatibility to the given release string. If one or more pairs of parameters are given, the corresponding backward-compatibility parameters are set to the corresponding release values.

Backward-compatibility parameters are specific, internally defined, parameters that are used to reproduce certain defined functionality from previous releases of Sentaurus Structure Editor. The available backward-compatibility parameters are:

<table>
  <thead>
    <tr>
        <th>Parameter</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Save Part at End</td>
        <td>Defaults to #t, such that when saving the model, the .sat file is saved after changes to the structure are made, which are needed to save the .cmd file and the .scm file. This parameter is #f for compatibility with releases E-2010.12 and earlier, where the .sat file is saved first, before the model is modified for saving the .cmd file and the .scm file.</td>
    </tr>
    <tr>
        <td>Z Align Polygons</td>
        <td>Defaults to #f. This parameter is #t in Version E-2010.12 and earlier, leading to the automatic reversal of polygon direction for coplanar polygons whose face normal is not parallel to the z-axis in the active coordinate system.</td>
    </tr>
  </tbody>
</table>

## See Also

sde:get-backwards-compatibility on page 432

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>475</page_number>

A: Commands
sde:set-default-material

# sde:set-default-material

Sets the active DATEX material to the specified value.

## Syntax

```scheme
(sde:set-default-material datex-material)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>datex-material</td>
        <td>DATEXMAT</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to change the active DATEX material. The argument `datex-material` is a string that corresponds to one of the DATEX colors, specified in the `datexcodes.txt` file.

This Scheme extension also changes the selected DATEX material in the DATEX list.

<page_number>476</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sde:set-menubar-font-size

# sde:set-menubar-font-size

Changes the font size of the menu bar of the GUI.

## Syntax

`(sde:set-menubar-font-size font-size)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>font-size</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension changes the font size of the menu bar of the GUI. The `font-size` argument (suggested value `[10-14]`) specifies the font size.

The menu command **View > GUI Font Size** also can be used to change the font size.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>477</page_number>

**A: Commands**
sde:set-process-up-direction

# sde:set-process-up-direction

Specifies the up-direction convention to be used during process emulation.

## Syntax

```scheme
(sde:set-process-up-direction up-direction)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>up-direction</td>
        <td>-x | "+z"</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension is used to specify which coordinate system convention is used during process emulation. It needs one input argument:

*   If you specify "-x", the up direction changes to -x (default).

*   If you specify "+z", the up direction is set to +z.

If the Sentaurus Process–Sentaurus Structure Editor interface is used to perform process emulation, the Scheme script generated by Sentaurus Process will contain instructions to select the correct coordinate system convention automatically.

## Examples

```scheme
(sde:set-process-up-direction "-x")
```

<page_number>478</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:set-project-name

# sde:set-project-name

Sets the project name, which is used in the Build Mesh dialog box as the name of the saved mesh.

## Syntax

`(sde:set-project-name project-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>project-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

STRING

# sde:set-rendering-mode

Sets the rendering mode.

## Syntax

`(sde:set-rendering-mode rendering-mode)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rendering-mode</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

Previous setting (STRING)

## Description

The rendering mode can be `facet`, `wire`, `flat`, `gouraud` (or alternatively, `smooth`), and `hidden`.

Sentaurus™ Structure Editor User Guide <page_number>479</page_number>
S-2021.06

**A: Commands**
sde:set-selection-level

# sde:set-selection-level

Sets the selection filter to the specified type.

## Syntax

`(sde:set-selection-level filter-type)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>filter-type</td>
        <td>{"body" | "face" | "edge" | "vertex" | "other"}</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension sets the selection filter to the specified value. All subsequent selection operations will use the specified filter to select only those entities that correspond to the specified type.

## Examples

`(sde:set-selection-level "edge")`

<page_number>

480
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:set-translucency

# sde:set-translucency

Sets the translucency of the main window of the GUI.

## Syntax

`(sde:set-translucency body(list) tflag)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body(list)</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
    <tr>
        <td>tflag</td>
        <td>BOOLEAN</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension takes two arguments where the first is either an entity or a list of entities, and the second argument `tflag` is a Boolean: `true` means make translucent and `false` means make opaque.

Sentaurus™ Structure Editor User Guide <page_number>481</page_number>
S-2021.06

A: Commands
sde:set-view-mode

# sde:set-view-mode

Sets the view.

## Syntax

```scheme
(sde:set-view-mode view-mode)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>view-mode</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension sets the view to the specified value, and it also performs a zoom extent operation.

The argument `view-mode` can be one of the following:

* ISO specifies the isometric view.
* XY sets the view to the xy plane.
* XZ sets the view to the xz plane.
* YZ sets the view to the yz plane.
* X-Y sets the view window in such a way that the x-axis points horizontally and the y-axis points downwards.

<page_number>482</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:set-view-operator

# sde:set-view-operator

Sets the view operator to the specified value.

## Syntax

`(sde:set-view-operator op-mode)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>op-mode</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

Previous setting (STRING)

## Description

This Scheme extension manipulates the toolbar, by setting the active actions to the specified mode. The available `op-mode` options are `orbit`, `zoom`, `pan`, and `select`.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>483</page_number>

A: Commands
sde:set-view-params

# sde:set-view-params

Sets the GUI view (rotation, zoom, and so on).

## Syntax

`(sde:set-view-params view-params)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>view-params</td>
        <td>Contains the following parameters:<br/>eye position POSITION<br/>target position POSITION<br/>up-vector GVECTOR (optional)<br/>width REAL (optional)<br/>height REAL (optional)<br/>projection STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension sets the GUI view to a previously recorded state.

The argument `view-params` is a list containing the same parameters that are returned by `sde:get-view-params`, but with some less rigid constraints.

The parameters `up-vector`, `width`, `height`, and `projection` are optional. The order is not significant, but `eye` must precede `target` and, if given, `width` must precede `height`. Existing settings are extracted from the current camera position if the optional values are not given.

## Examples

```scheme
(define myview (sde:get-view-params))
(sde:set-view-params myview)
```

<page_number>

484
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:set-window-position

# sde:set-window-position

Positions the main window of the GUI.

## Syntax

`(sde:set-window-position xpos ypos)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>xpos</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>ypos</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The arguments `xpos` and `ypos` specify the horizontal and the vertical placements of the GUI, respectively.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>485</page_number>

A: Commands
sde:set-window-size

# sde:set-window-size

Resizes the main window of the GUI.

## Syntax

`(sde:set-window-size xsize ysize)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>xsize</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>ysize</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The arguments `xsize` and `ysize` specify the horizontal and the vertical sizes (in pixels) of the GUI, respectively.

# sde:set-window-style

Sets the GUI style.

## Syntax

`(sde:set-window-style wstyle)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>wstyle</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The available styles are Windows, Motif, Cleanlooks, Plastique, and CDE.

<page_number>486</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:setrefprops

# sde:setrefprops

Sets the refinement properties for the internal faceter.

> **NOTE** This Scheme extension is deprecated and will be removed in a future release. Instead, use the "aspect ratio", "max edge length", "normal tolerance", and "surface tolerance" arguments of the `sdeio:save-tdr-bnd` Scheme extension to control the properties of the faceter (see sdeio:save-tdr-bnd on page 751).

## Syntax

```scheme
(sde:setrefprops surface-tolerance normal-tolerance
  [aspect-ratio max-edge-length])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>surface-tolerance</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>normal-tolerance</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>aspect-ratio</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>max-edge-length</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension controls the properties of the internal faceter of Sentaurus Structure Editor, which is an important link between Sentaurus Structure Editor and other Synopsys tools. When Sentaurus Structure Editor contains a model with curved boundaries, this internal curved representation must be tessellated before a TDR boundary file is generated. The following arguments control this tessellation:

* `surface-tolerance` is an absolute number. It is the allowable maximum distance between the original model and tessellated output. By specifying a smaller value, the tessellated model deviates less from the original model.

* `normal-tolerance` is the allowable maximum difference between the surface normals of the original and tessellated models. Both values are global and apply to the complete model. In the case of a thin, curved channel, the refinement based on `surface-tolerance` is not recommended. It is better to control the `normal-tolerance`.

Sentaurus™ Structure Editor User Guide <page_number>487</page_number>
S-2021.06

# A: Commands

sde:setrefprops

*   **aspect-ratio** (optional) controls the maximum aspect ratio of the triangles in the tessellated boundary. Using an aspect ratio control can prevent the creation of sliver faces (triangles with a close to zero angle). The recommended aspect ratio value is [2–4].

*   **max-edge-length** (optional) controls the maximum-allowable edge length in the tessellated boundary. In some cases, a more regular tessellation can be created using `max-edge-length`, which helps meshing. A small `max-edge-length` value might cause unnecessary overrefinement.

<page_number>488</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sde:setup-grid

# sde:setup-grid

Sets the basic grid parameters.

## Syntax

`(sde:setup-grid x-spacing y-spacing edge-weight edge-pattern)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>x-spacing</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y-spacing</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>edge-weight</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>edge-pattern</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension sets the basic parameters for the grid. The arguments `x-spacing` and `y-spacing` specify the horizontal and vertical grid size. The argument `edge-weight` specifies the line thickness, and `edge-pattern` specifies the line pattern that is used for drawing the grid. The possible values for `edge-pattern` are pattern strings:

*   A solid line: `"---"`

*   A simple dashed line: `"- -"`

*   A dotted line: `"..."`

*   Dash and dot alternating: `"-.-."`

*   Dash and two dots alternating: `"-..-.."`

*   Dash and three dots alternating: `"-...-..."`

*   Long dashes: `"---- ----"`

*   Very long dash and short dash alternating: `"center"`

*   Very long dash and two short dashes alternating: `"phantom"`

## Examples

```
(sde:setup-grid 1 1 2 "...")
(sde:show-grid #t)
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

489
</page_number>

A: Commands

sde:show

# sde:show

Adds the specified entity or entities to the view window.

## Syntax

```scheme
(sde:show entity | entity-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to show the specified entity or entities in the view window. The bodies are added to the view window, and the view window is refreshed. If the entity is already visible, there is no change in the view window.

## Examples

```scheme
(sde:clear)
(define r1 (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Photoresist" "r_1"))
(define r2 (sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "r_2"))
(define r3 (sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist"
  "r_3"))
(define r4 (sdegeo:create-rectangle (position 6 0 0) (position 7 1 0)
  "PolySilicon" "r_4"))
(sde:xshow-material "")
(sde:show r1)
(sde:show (list r3 r4))
```

<page_number>490</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:showattribs

# sde:showattribs

Shows the attributes of Sentaurus Structure Editor attached to a body or bodies.

## Syntax

```scheme
(sde:showattribs entity-list | "all")
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension shows the attached attributes for the specified `entity-list`. Instead of an `entity-list`, the keyword `all` also can be specified, in which case, all ACIS bodies are shown. This Scheme extension can display the ACIS part number, and the material and region attributes of Sentaurus Structure Editor that are attached to the bodies.

# sde:show-bg-image

Displays the previously loaded image.

## Syntax

```scheme
(sde:show-bg-image)
```

## Returns

None

Sentaurus™ Structure Editor User Guide <page_number>491</page_number>
S-2021.06

A: Commands

sde:show-contact

# sde:show-contact

Adds to the view all the regions that have the specified contact attributes.

## Syntax

```scheme
(sde:show-contact contact-name | contact-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>contact-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>contact-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension adds to the view all regions that have contacts defined with the specified contact attributes. Contacts are identified with the attribute name `contact`. In two dimensions, contacts are edges and, in three dimensions, contacts are faces.

# sde:show-grid

Switches on and off visualization of the grid in the view window.

## Syntax

```scheme
(sde:show-grid on-off)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>on-off</td>
        <td>BOOLEAN</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

<page_number>492</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:show-interface

# sde:show-interface

Adds the specified interfaces to the view window.

## Syntax

```scheme
(sde:show-interface interface-name | interface-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>interface-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>interface-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension adds to the view window all regions that have interfaces defined with the specified interface attributes. Interfaces are identified with the attribute name `interface`.

In two dimensions, interfaces are edges between neighboring regions. In three dimensions, interfaces are faces between neighboring regions.

Sentaurus™ Structure Editor User Guide

S-2021.06
<page_number>

493
</page_number>

A: Commands
sde:show-mask

# sde:show-mask

Adds the specified masks to the view window.

## Syntax

`(sde:show-mask mask-name | mask-name-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>mask-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>mask-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension adds the specified masks to the view window. Masks are planar wire bodies that have the specified `mask-names` as ‘mask name’ attributes.

<page_number>

494
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:show-material

# sde:show-material

Adds the entities with the specified materials to the view window.

## Syntax

```scheme
(sde:show-material datex-material | datex-material-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>datex-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>datex-material-list</td>
        <td>DATEXMAT LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to show the regions that have the specified material names as material attributes. The regions are added to the view window, and the view window is refreshed. If a region is already visible, there is no change in the view window. The argument is either a DATEX material or a list of DATEX materials.

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Photoresist"
  "region_1")
(sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "region_2")
(sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist" "region_3")
(sdegeo:create-rectangle (position 6 0 0) (position 7 1 0) "PolySilicon"
  "region_4")
(sde:xshow-material "")
(sde:show-material "Silicon")
```

Sentaurus™ Structure Editor User Guide <page_number>495</page_number>
S-2021.06

A: Commands
sde:show-pcurves

# sde:show-pcurves

Shows the parameter curves.

## Syntax

`(sde:show-pcurves rendering-flag [u-params [v-params]])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rendering-flag</td>
        <td>BOOLEAN</td>
    </tr>
    <tr>
        <td>u-params</td>
        <td>INTEGER (optional)</td>
    </tr>
    <tr>
        <td>v-params</td>
        <td>INTEGER (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to visualize the parametric curves for each entity, defined in the database. The Boolean argument `rendering-flag` is used to switch on or off the parameter line visualization. If the optional arguments `u-params` and `v-params` are not specified, the default value of 5 is used.

## Limitations

Only the wire frame view is affected by this Scheme extension, by rendering the parameter lines.

<page_number>

496
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:show-region

# sde:show-region

Adds the specified entity or entities to the view window.

## Syntax

```
(sde:show-region region-name | region-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region-name</td>
        <td>STRING (existing region name)</td>
    </tr>
    <tr>
        <td>region-name-list</td>
        <td>STRING LIST (existing region names)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to show the specified regions in the view window. The bodies that have the specified region name as a region attribute are added to the view window, and the view window is refreshed. If the region is already visible, there is no change in the view window.

## Examples

```
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Photoresist"
  "region_1")
(sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "region_2")
(sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist" "region_3")
(sdegeo:create-rectangle (position 6 0 0) (position 7 1 0) "PolySilicon"
  "region_4")
(sde:xshow-material "")
(sde:show-region "region_1")
(sde:show-region (list "region_3" "region_4"))
```

Sentaurus™ Structure Editor User Guide <page_number>497</page_number>
S-2021.06

A: Commands
sde:split-solid

# sde:split-solid

Splits the specified solid (2D and 3D) into separate bodies.

## Syntax

`(sde:split-solid solid-body base-position plane-normal)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>solid-body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>base-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>plane-normal</td>
        <td>GVECTOR</td>
    </tr>
  </tbody>
</table>

## Returns

`BODY LIST`

## Description

The new split bodies can be treated as high-level entities. They can be deleted, new material and region properties can be assigned to them, and any geometry operations can be applied to them that can be applied to high-level entities only. The argument list contains `solid-body`, which will be split. The cut plane is defined by a `base-position` (that is, a position variable) and a normal vector (`plane-normal`), that is, a gvector variable.

> **NOTE** After a solid entity is split into parts, the region names will no longer be unique. All split parts will have the same region name, therefore, renaming of these parts might be necessary.

## Examples

```scheme
(sde:clear)
(define my_cube (sdegeo:create-cuboid (position -1 -1 -1) (position 1 1 1)
  "Silver" "xx"))
(sde:split-solid my_cube (position 0 0 0) (gvector 1 1 0))
(sde:split-solid my_cube (position 0 0 0) (gvector 1 -1 0))
```

<page_number>498</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:stripextension

# sde:stripextension

Deletes the file extension from a string.

## Syntax

`(sde:stripextension name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

STRING

## Description

This Scheme extension locates the last dot (.) in the specified string and removes all characters that follow. The stripped string is returned. If the input string does not have a dot, the input string is returned.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

499
</page_number>

A: Commands
sde:substring

# sde:substring

Returns a substring.

## Syntax

`(sde:substring string min max)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>string</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>min</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>max</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

STRING

## Description

This Scheme extension returns a substring of the input `string`.

The `min` number denotes the first character position (starting from zero), and the `max` number denotes the last character position. If the length of the input string is smaller than `max`, an empty string is returned. (The `string-length` command returns the length of a string.)

<page_number>500</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:test-entity

# sde:test-entity

Returns the entity types.

## Syntax

`(sde:test-entity entities)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entities</td>
        <td>ENTITY | ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

The possible return values are:

* **"unknown"**
* **"solid"**: Solid with a positive volume (manifold).
* **"non-manifold"**: Solid with zero volume (non-manifold).
* **"mask"**: Mask (same conditions as for "non-manifold", but also the `maskname` attribute is defined).

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

501
</page_number>

**A: Commands**

sde:toggle-lights

---

# sde:toggle-lights

Switches on or off the lights of the view window, that is, this Scheme extension behaves like a light switch.

### Syntax

```scheme
(sde:toggle-lights)
```

### Returns

None

---

# sde:top-coord

Returns the top coordinate of the device.

### Syntax

```scheme
(sde:top-coord body | body-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body</td>
        <td>BODY</td>
    </tr>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

### Returns

REAL

### Description

This Scheme extension returns the top coordinate of the specified `body` or `body-list`. The top coordinate depends on the coordinate system used:

* For the UCS, the top coordinate is the minimum x-coordinate.

* For the DF–ISE coordinate system, the top coordinate is the maximum z-coordinate.

<page_number>502</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:tr-get

# sde:tr-get

Returns the transformation used to place the 3D cut on the xy plane, using `sdegeo:3d-cut`.

## Syntax

```scheme
(sde:tr-get)
```

## Returns

LIST

## Description

This Scheme extension returns the transformation that was used to place the 3D cut on the xy plane, using `sdegeo:3d-cut`. The transformation is composed of a rotation component ($3 \times 3$ matrix) and a translation component (3D vector). The extension returns 12 real numbers in a list. The first nine numbers represent the $3 \times 3$ rotation matrix (A) and the last three numbers (T) represent the xyz part of the translation component. The new position of any point in the cut can be calculated by $P_{cut} = P_{original} \times A + T$.

# sde:view-filter-reset

Resets the view window to the default value. All regions and contacts are shown, and interfaces are hidden.

## Syntax

```scheme
(sde:view-filter-reset)
```

## Returns

None

Sentaurus™ Structure Editor User Guide
<page_number>503</page_number>
S-2021.06

**A: Commands**
sde:view-set-light-intensity

# sde:view-set-light-intensity

Sets the light intensity of the GUI view window.

## Syntax

```scheme
(sde:view-set-light-intensity lintensity)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>lintensity</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The light intensity can be changed to a value between 0 and 1.

<page_number>504</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sde:view-set-visible-area

# sde:view-set-visible-area

Sets the visible screen area.

## Syntax

`(sde:view-set-visible-area xmin xmax ymin ymax)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>xmin</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>xmax</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>ymin</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>ymax</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension resizes the GUI drawing area explicitly. If the bounding box of the created device is known, it might be convenient to preset the view area to that size.

# sde:wait-cursor

Changes the pointer to an hourglass pointer.

## Syntax

`(sde:wait-cursor)`

## Returns

None

Sentaurus™ Structure Editor User Guide

<page_number>505</page_number>

S-2021.06

A: Commands
sde:window-select-2d

# sde:window-select-2d

Returns a list containing all vertex, edge, or body entities that are inside the specified 2D window.

**NOTE** This Scheme extension applies to 2D models only.

A similar Scheme extension `sde:window-select-3d` applies to 3D models.

## Syntax

`(sde:window-select-2d x-left y-left x-right y-right elist stype)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>x-left</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y-left</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>x-right</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y-right</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>elist</td>
        <td>{BODY LIST | "all"}</td>
    </tr>
    <tr>
        <td>stype</td>
        <td>{"vertex" | "edge" | "body"}</td>
    </tr>
  </tbody>
</table>

## Returns

LIST

## Description

This Scheme extension selects all entities (of the specified type, `stype`) lying in the specified 2D window. The first four arguments `x-left`, `y-left`, `x-right`, and `y-right` define the rectangular window that will be used during the selection.

The `elist` argument can be either `"all"`, in which case, all entities in the model will be used for the selection, or it can be a body list.

The last argument `stype` is the selection criterion. If `stype` is `"vertex"`, a vertex list is returned. If it is `"edge"`, an edge list is returned. If `stype` is `"body"`, a body list is returned. If no entity is found, an empty list is returned.

<page_number>506</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sde:window-select-2d

**Examples**

```scheme
(sde:clear)
(sdegeo:set-default-boolean "AB")
(sdegeo:create-rectangle (position 0 0 0) (position 2 2 0) "Silicon"
  "region_1")
(sdegeo:create-circle (position 1 2 0) 1 "Silicon" "region_2")
(define vlist (sde:window-select-2d -1 -1 3 4 "all" "vertex"))
(define elist (sde:window-select-2d -1 -1 3 4 "all" "edge"))
(define blist (sde:window-select-2d -1 -1 3 4 "all" "body"))
```

Sentaurus™ Structure Editor User Guide

<page_number>507</page_number>

S-2021.06

A: Commands
sde:window-select-3d

# sde:window-select-3d

Returns a list containing all vertex, edge, or face entities that are inside the specified 3D window.

**NOTE** This Scheme extension applies to 3D models only.

A similar Scheme extension `sde:window-select-2d` applies to 2D models.

## Syntax

`(sde:window-select-3d pmin pmax elist stype)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>pmin</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>pmax</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>elist</td>
        <td>{BODY LIST | "all"}</td>
    </tr>
    <tr>
        <td>stype</td>
        <td>{"vertex" | "edge" | face" | "body"}</td>
    </tr>
  </tbody>
</table>

## Returns

LIST

## Description

This Scheme extension selects all entities (of the specified type, `stype`) lying in the specified 3D window. The first two arguments `pmin` and `pmax` define the 3D window (cuboid) that will be used during the selection.

The `elist` argument can be either `"all"`, in which case, all entities in the model will be used for the selection or it can be a body list.

The last argument `stype` is the selection criterion. If `stype` is `"vertex"`, a vertex list is returned. If it is `"edge"`, an edge list is returned. If it is `"face"`, a face list is returned. If it is `"body"`, a body list is returned. If no entity is found, an empty list is returned.

<page_number>508</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sde:xshow

# sde:xshow

Adds the specified entity or entities to the view window and hides all other entities.

## Syntax

```scheme
(sde:xshow entity | entity-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to show the specified entities exclusively in the view window. The entities are added to the view window. All other entities are removed from the view window, and the view window is refreshed.

## Examples

```scheme
(sde:clear)
(define r1 (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Photoresist" "r_1"))
(define r2 (sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "r_2"))
(define r3 (sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist"
  "r_3"))
(define r4 (sdegeo:create-rectangle (position 6 0 0) (position 7 1 0)
  "PolySilicon" "r_4"))
(sde:xshow r1)
(sde:xshow (list r3 r4))
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>509</page_number>

A: Commands
sde:xshow-contact

# sde:xshow-contact

Adds all the regions to the view that have the specified contact attributes, and removes all other regions.

## Syntax

`(sde:xshow-contact contact-name | contact-name-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>contact-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>contact-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension exclusively adds all regions to the view that have contacts defined with the specified contact attributes. Contacts are identified with the attribute name `contact`. In two dimensions, contacts are edges and, in three dimensions, contacts are faces.

<page_number>510</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:xshow-interface

# sde:xshow-interface

Adds the specified interfaces to the view window, and removes all other interfaces.

## Syntax

```scheme
(sde:xshow-interface interface-name | interface-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>interface-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>interface-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension exclusively adds all regions to the view window, which have interfaces defined, with the specified interface attributes. Interfaces are identified with the attribute name `interface`. In two dimensions, interfaces are edges between neighboring regions and, in three dimensions, interfaces are faces between neighboring regions.

Sentaurus™ Structure Editor User Guide 511

S-2021.06

A: Commands
sde:xshow-mask

# sde:xshow-mask

Adds the specified masks to the view window, and removes all other masks.

## Syntax

`(sde:xshow-mask mask-name | mask-name-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>mask-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>mask-name-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension exclusively adds the specified masks to the view window, that is, the specified masks are added and all other masks are removed. Masks are planar wire bodies that have the specified mask-names as ‘mask name’ attributes.

<page_number>512</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:xshow-material

# sde:xshow-material

Adds the entities with the specified materials to the view window, and hides all other entities.

## Syntax

```scheme
(sde:xshow-material datex-material | datex-material-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>datex-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>datex-material-list</td>
        <td>DATEXMAT LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to show exclusively the regions that have the specified material names as material attributes. The region is added to the view window, all other regions are removed from the view window, and the view window is refreshed. The argument is either a DATEX material or a list of DATEX materials.

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Photoresist"
  "region_1")
(sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "region_2")
(sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist" "region_3")
(sdegeo:create-rectangle (position 6 0 0) (position 7 1 0) "PolySilicon"
  "region_4")
(sde:xshow-material "Silicon")
```

Sentaurus™ Structure Editor User Guide
<page_number>513</page_number>
S-2021.06

**A: Commands**

sde:xshow-region

# sde:xshow-region

Adds the specified entity or entities to the view window, and hides all other entities.

## Syntax

```scheme
(sde:xshow-region region-name | region-name-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region-name</td>
        <td>STRING (existing region name)</td>
    </tr>
    <tr>
        <td>region-name-list</td>
        <td>STRING LIST (existing region names)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension is used to show the specified regions exclusively in the view window. The bodies, which have the specified region names as region attributes, are added to the view window. All other bodies are removed from the view window, and the view window is refreshed.

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Photoresist"
  "region_1")
(sdegeo:create-rectangle (position 2 0 0) (position 3 1 0) "Silicon"
  "region_2")
(sdegeo:create-rectangle (position 4 0 0) (position 5 1 0) "Resist" "region_3")
(sdegeo:create-rectangle (position 6 0 0) (position 7 1 0) "PolySilicon"
  "region_4")
(sde:xshow-region "region_1")
(sde:xshow-region (list "region_3" "region_4"))
```

<page_number>514</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sde:zoom-all

# sde:zoom-all

Fits the model to the view window.

## Syntax

```scheme
(sde:zoom-all)
```

## Returns

None

# sdedr:append-cmd-file

Appends a text file to a mesh command file.

## Syntax

```scheme
(sdedr:append-cmd-file file-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension appends a text file to the end of a mesh command file. The mesh command file is not created by this Scheme extension.

You must call `sdedr:write-cmd-file` after `sdedr:append-cmd-file` to create the mesh command file.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>515</page_number>

A: Commands

sdedr:clear

# sdedr:clear

Clears the doping and refinement container class.

## Syntax

`(sdedr:clear)`

## Returns

None

## Description

This Scheme extension clears all doping-related and refinement-related data from Sentaurus Structure Editor. A subsequent `sdedr:write-cmd-file` call creates an empty command file. (Choose **Mesh** > **Clear All** > **Profiles and Definitions**.)

# sdedr:clear-multibox-definitions

Deletes all multibox definition–related data.

## Syntax

`(sdedr:clear-multibox-definitions)`

## Returns

None

## Description

This Scheme extension deletes all multibox definition–related data from the doping and refinement container. (Choose **Mesh** > **Clear All** > **Multibox Definitions**.)

<page_number>516</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands

sdedr:clear-multibox-placements

# sdedr:clear-multibox-placements

Deletes all multibox placement–related data from the doping and refinement container. (Choose **Mesh** > **Clear All** > **Multibox Placements**.)

## Syntax

`(sdedr:clear-multibox-placements)`

## Returns

None

# sdedr:clear-profile-definitions

Deletes all profile definition–related data from the doping and refinement container. (Choose **Mesh** > **Clear All** > **Profile Definitions**.)

## Syntax

`(sdedr:clear-profile-definitions)`

## Returns

None

# sdedr:clear-profile-placements

Deletes all profile placement–related data from the doping and refinement container. (Choose **Mesh** > **Clear All** > **Profile Placements**.)

## Syntax

`(sdedr:clear-profile-placements)`

## Returns

None

Sentaurus™ Structure Editor User Guide

<page_number>517</page_number>

S-2021.06

A: Commands

sdedr:clear-ref-windows

# sdedr:clear-ref-windows

Deletes all previously defined Ref/Eval windows from the database. (Choose **Mesh** > **Clear All** > **Ref/Eval Windows**.)

## Syntax

```scheme
(sdedr:clear-ref-windows)
```

## Returns

None

# sdedr:clear-refinement-definitions

Deletes all refinement definition–related data.

## Syntax

```scheme
(sdedr:clear-refinement-definitions)
```

## Returns

None

## Description

This Scheme extension deletes all refinement definition–related data from the doping and refinement container. The mesh command files contain all refinement-related data. The command file includes two data sections that are related to doping and refinement: Definitions and Placements.

The Definitions section contains the definitions of the refinement entities (definition name, refinement size information), and the Placements section contains the named placements for refinements (associated refinement windows). This Scheme extension deletes all refinement-related data *only* from the Definitions section. (Choose **Mesh** > **Clear All** > **Refinement Definitions**.)

<page_number>

518
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdedr:clear-refinement-placements

# sdedr:clear-refinement-placements

Deletes all refinement placement–related data.

## Syntax

`(sdedr:clear-refinement-placements)`

## Returns

None

## Description

This Scheme extension deletes all refinement placement–related data from the doping and refinement container. The mesh command files contain all refinement-related data. The command file includes two data sections that are related to doping and refinement: Definitions and Placements.

The Definitions section contains the definitions of the refinement entities (definition name, refinement size information), and the Placements section contains the named placements for refinements (associated refinement windows). This Scheme extension deletes all refinement-related data *only* from the Placements section. (Choose **Mesh** > **Clear All** > **Refinement Placements**.)

Sentaurus™ Structure Editor User Guide
519
S-2021.06
<page_number>519</page_number>

A: Commands
sdedr:clear-submesh-placement-transform

# sdedr:clear-submesh-placement-transform

Clears the list of all transform operations applied to the named external profile placement.

## Syntax

```scheme
(sdedr:clear-submesh-placement-transform placement-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension clears all transform operations (Reflect, Rotation, and ShiftVector) as defined for the named external profile placement through the Scheme extension sdedr:transform-submesh-placement.

## See Also

sdedr:transform-submesh-placement on page 569

<page_number>520</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:convert-mask-to-drs-body

# sdedr:convert-mask-to-drs-body

Converts the specified mask into a Ref/Eval window.

## Syntax

`(sdedr:convert-mask-to-drs-body maskname refwindowname)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>maskname</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>refwindowname</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

`BOOLEAN`

## Description

If the mask is not found, then this Scheme extension returns `#f`. If the conversion is successful, then it returns `#t`.

Sentaurus™ Structure Editor User Guide

<page_number>521</page_number>

S-2021.06

A: Commands

sdedr:define-1d-external-profile

# sdedr:define-1d-external-profile

Creates a 1D external profile in the mesh command file.

## Syntax

```
(sdedr:define-1d-external-profile name filename "Scale" scale
  "DataScale" data-scale ["Range" range-from range-to] [lateral-function])
```

where the optional `lateral-function` is one of the following, depending on the chosen lateral function, "Erf", "Gauss", or "Eval":

```
"Erf" {"Factor" lateral-factor | "Length" length}
```

or:

```
"Gauss" {"Factor" lateral-factor | "Length" length |
  "StdDev" standard-deviation}
```

or:

```
"Eval" eval-init eval-function
```

<table>
  <thead>
    <tr>
      <th>Argument</th>
      <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>name</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>filename</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>scale</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>data-scale</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>range-from</td>
      <td>REAL (optional)</td>
    </tr>
    <tr>
      <td>range-to</td>
      <td>REAL (optional)</td>
    </tr>
    <tr>
      <td>lateral-factor</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>length</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>standard-deviation</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>eval-init</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>eval-function</td>
      <td>STRING</td>
    </tr>
  </tbody>
</table>

<page_number>522</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sdedr:define-1d-external-profile

### Returns

None

### Description

For this Scheme extension, the default unit is micrometer. The lateral profile can be given as a Gaussian function or an error function. The "Range" keyword with its parameters `range-from` and `range-to` is optional.

### See Also

Sentaurus™ Mesh User Guide, Defining Analytic Profiles on page 10 for detailed descriptions of parameters

Sentaurus™ Structure Editor User Guide

<page_number>523</page_number>

S-2021.06

A: Commands

sdedr:define-analytical-profile

# sdedr:define-analytical-profile

Creates a user-defined analytic function that describes doping in the mesh command file.

## Syntax

```scheme
(sdedr:define-analytical-profile name species initialization function
  start-value analytical-type [ lateral-type-gauss-erf lateral-parameter
  lateral-value | "Eval" lateral-eval-init lateral-eval-func ])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>species</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>initialization</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>function</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>start-value</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>analytical-type</td>
        <td>STRING = "General" | "Eval"</td>
    </tr>
    <tr>
        <td>lateral-type-gauss-erf</td>
        <td>STRING = "Gauss" | "Erf" (optional)</td>
    </tr>
    <tr>
        <td>lateral-parameter</td>
        <td>STRING = "factor" | "stddev" | "length" (optional)</td>
    </tr>
    <tr>
        <td>lateral-value</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>lateral-eval-init</td>
        <td>STRING (optional)</td>
    </tr>
    <tr>
        <td>lateral-eval-func</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

For this Scheme extension, the optional definition of lateral diffusion is not available if the definition in the primary direction is the analytic type "General". The "General" type includes both the primary and lateral distributions in its definition and, therefore, it is not intended to have a separate lateral diffusion.

## See Also

Sentaurus™ Mesh User Guide, Defining Analytic Profiles on page 10 for descriptions of parameters

<page_number>524</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sdedr:define-analytical-profile-placement

# sdedr:define-analytical-profile-placement

Creates a placement for an analytic profile definition in the mesh command file.

## Syntax

```
(sdedr:define-analytical-profile-placement placement-name definition-name
    ref-eval-window symmetry replacement evaluation eval-window decay-length
    [ "Gauss" ] eval-window-type)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>ref-eval-window</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>symmetry</td>
        <td>{"Both" | "Positive" | "Negative"}</td>
    </tr>
    <tr>
        <td>replacement</td>
        <td>{"Replace" | "NoReplace" | "LocalReplace"}</td>
    </tr>
    <tr>
        <td>evaluation</td>
        <td>{"Eval" | "NoEval"}</td>
    </tr>
    <tr>
        <td>eval-window</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>decay-length</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>eval-window-type</td>
        <td>{"region" | "material" | "evalwin"}</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The argument `decay-length` corresponds to the mesh command file parameter "DecayLength" unless the optional string "Gauss" is additionally present, in which case, `decay-length` is interpreted instead as corresponding to the "GaussDecayLength" parameter of the mesh command file.

Specifying the "NoEval" option causes Sentaurus Structure Editor to write the "notevalline" keyword to the `AnalyticalProfile` statement of the `Placements` section of the Sentaurus Mesh command file. The `AnalyticalProfile` statement instructs Sentaurus Mesh not to include the base line or base polygons in the evaluation of the analytic doping profiles.

Sentaurus™ Structure Editor User Guide <page_number>525</page_number>
S-2021.06

**A: Commands**

sdedr:define-body-interface-refwin

### See Also

Sentaurus™ Mesh User Guide, Placing Analytic Profiles on page 26 for descriptions of parameters

# sdedr:define-body-interface-refwin

Defines a refinement window between the interfaces of the specified geometric bodies.

### Syntax

`(sdedr:define-body-interface-refwin body-list ref-eval-window)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY (LIST)</td>
    </tr>
    <tr>
        <td>ref-eval-window</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

### Returns

BOOLEAN

### Description

For this Scheme extension, input arguments are a body list and the name of a refinement window.

If the refinement window is already defined, then the extension returns #f. If there is an interface between the input bodies, then a refinement window is created, which conforms to the interface.

> **NOTE** The interface between bodies can be a geometric object that is not supported in the mesh command file and that is not supported by the other `sdedr` Scheme extensions. For example, if the interface is a polygon (wire body in two dimensions), this entity type is not supported by other `sdedr` extensions. In this case, the wire body is converted to an edge list, and a refinement window is created from each edge. If the original refinement window name is, for example, "rw", the "_edge_EN" string is appended to the name, where EN is an edge counter (rw_edge_1, rw_edge_2, and so on). Similarly, if the interface is a face list (3D), each face is converted to a polygon and the mesh command file includes these polygons if the interface refinement window is used to define doping/refinement. The refinement window name will have the "_lump_FN" string appended, where FN is a face number counter.

<page_number>526</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sdedr:define-constant-profile

# sdedr:define-constant-profile

Creates a definition for a constant doping profile in the mesh command file.

## Syntax

`(sdedr:define-constant-profile definition-name species concentration)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>species</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>concentration</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## See Also

Sentaurus™ Mesh User Guide, Defining Constant Profiles on page 14 for descriptions of parameters

Sentaurus™ Structure Editor User Guide

<page_number>527</page_number>

S-2021.06

**A: Commands**
sdedr:define-constant-profile-material

# sdedr:define-constant-profile-material

Creates a constant doping profile placement based on a material in the mesh command file.

## Syntax

```scheme
(sdedr:define-constant-profile-material placement-name definition-name
  material [decay-length ["Gauss"]] [replace])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>decay-length</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>replace</td>
        <td>Replace | "LocalReplace" (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

For this Scheme extension, the argument `decay-length` corresponds to the mesh command file parameter "DecayLength" unless the optional string "Gauss" is additionally present, in which case, `decay-length` is interpreted instead as corresponding to the "GaussDecayLength" parameter of the mesh command file.

## See Also

Sentaurus™ Mesh User Guide, Defining Constant Profiles on page 14 for descriptions of parameters

<page_number>528</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:define-constant-profile-placement

# sdedr:define-constant-profile-placement

Creates a Ref/Eval window placement of a constant doping profile definition in the mesh command file.

## Syntax

```scheme
(sdedr:define-constant-profile-placement placement-name definition-name
    ref-win-name [decay-length ["Gauss"]] [replace])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>ref-win-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>decay-length</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>replace</td>
        <td>Replace | "LocalReplace" (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The argument `decay-length` corresponds to the mesh command file parameter "DecayLength" unless the optional string "Gauss" is additionally present, in which case, `decay-length` is interpreted instead as corresponding to the "GaussDecayLength" parameter of the mesh command file.

## See Also

Sentaurus™ Mesh User Guide, Defining Constant Profiles on page 14 for descriptions of parameters

Sentaurus™ Structure Editor User Guide

<page_number>529</page_number>

S-2021.06

**A: Commands**

sdedr:define-constant-profile-region

# sdedr:define-constant-profile-region

Creates a constant doping profile placement based on a region in the mesh command file.

## Syntax

```scheme
(sdedr:define-constant-profile-region placement-name definition-name
    region-name [decay-length ["Gauss"]] [replace])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>decay-length</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>replace</td>
        <td>Replace | "LocalReplace" (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The argument `decay-length` corresponds to the mesh command file parameter "DecayLength" unless the optional string "Gauss" is additionally present, in which case, `decay-length` is interpreted instead as corresponding to the "GaussDecayLength" parameter of the mesh command file.

## See Also

Sentaurus™ Mesh User Guide, Defining Constant Profiles on page 14 for descriptions of parameters

<page_number>

530
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdedr:define-erf-profile

# sdedr:define-erf-profile

Creates a definition of an error-function doping profile in the mesh command file.

**Syntax**

```scheme
(sdedr:define-erf-profile definition-name species "SymPos" symmetry-position
  "MaxVal" max-value | "Dose" dose "Junction" junction
  "ValueAtDepth" value-at-depth "Depth" depth "Length" length
  "StdDev" standard-deviation [lateral-function])
```

where the optional lateral-function is one of the following, depending on the chosen lateral function, "Erf", "Gauss", or "Eval":

```scheme
"Erf" {"Factor" lateral-factor | "Length" length}
```

or:

```scheme
"Gauss" {"Factor" lateral-factor | "Length" length |
         "StdDev" standard-deviation}
```

or:

```scheme
"Eval" eval-init eval-function
```

<table>
  <thead>
    <tr>
      <th>Argument</th>
      <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>definition-name</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>species</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>symmetry-position</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>max-value</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>dose</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>junction</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>value-at-depth</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>depth</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>length</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>standard-deviation</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>lateral-factor</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>eval-init</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>eval-function</td>
      <td>STRING</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

531
</page_number>

# A: Commands

sdedr:define-erf-profile

## Returns

None

## See Also

Sentaurus™ Mesh User Guide, Defining Constant Profiles on page 14 for descriptions of parameters

<page_number>532</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdedr:define-gaussian-profile

# sdedr:define-gaussian-profile

Creates a definition of a Gaussian-function doping profile in the mesh command file.

## Syntax

```
(sdedr:define-gaussian-profile definition-name species
  "PeakPos" peak-position {"PeakVal" peak-concentration | "Dose" dose}
  {"ValueAtDepth" concentration-at-depth "Depth" depth |
  "Length" diffusion-length | "StdDev" standard-deviation}
  [lateral-function])
```

where the optional lateral-function is one of the following, depending on the chosen lateral function, "Erf", "Gauss", or "Eval":

```
"Erf" {"Factor" lateral-factor | "Length" length}
```

or:

```
"Gauss" {"Factor" lateral-factor | "Length" length |
   "StdDev" standard-deviation}
```

or:

```
"Eval" eval-init eval-function
```

<table>
  <thead>
    <tr>
      <th>Argument</th>
      <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>definition-name</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>species</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>peak-position</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>peak-concentration</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>dose</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>concentration-at-depth</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>depth</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>diffusion-length</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>standard-deviation</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>lateral-factor</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>length</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>eval-init</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>eval-function</td>
      <td>STRING</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>533</page_number>

**A: Commands**

sdedr:define-multibox-placement

### Returns

None

### See Also

Sentaurus™ Mesh User Guide, Defining Analytic Profiles on page 10 for descriptions of parameters

---

# sdedr:define-multibox-placement

Defines the placements part of a multibox definition.

### Syntax

```scheme
(sdedr:define-multibox-placement placement-name definition-name
    refwindow-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>refwindow-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

### Returns

None

### Examples

```scheme
(sdedr:define-multibox-placement "p1" "d1" "refwindow1")
```

<page_number>534</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:define-multibox-size

# sdedr:define-multibox-size

Defines the definitions part of a multibox definition.

## Syntax

(sdedr:define-multibox-size mbox-name max-x max-y [max-z] min-x min-y [min-z] ratio-x ratio-y [ratio-z])

<table>
  <thead>
    <tr>
      <th>Argument</th>
      <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>mbox-name</td>
      <td>STRING</td>
    </tr>
    <tr>
      <td>max-x</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>max-y</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>max-z</td>
      <td>REAL (optional)</td>
    </tr>
    <tr>
      <td>min-x</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>min-y</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>min-z</td>
      <td>REAL (optional)</td>
    </tr>
    <tr>
      <td>ratio-x</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>ratio-y</td>
      <td>REAL</td>
    </tr>
    <tr>
      <td>ratio-z</td>
      <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```scheme
(sdedr:define-multibox-size "multibox-2d" 10 10 1 1 2 2)
(sdedr:define-multibox-size "multibox-3d" 10 10 10 1 1 1 2 2 2)
```

Sentaurus™ Structure Editor User Guide

<page_number>535</page_number>

S-2021.06

**A: Commands**

sdedr:define-particle-profile

---

# sdedr:define-particle-profile

Creates a particle doping profile in the mesh command file.

## Syntax

```
(sdedr:define-particle-profile name file
  ["AutoScreeningFactor" auto-screening-factor]
  ["BoundaryExtension" boundary-extension] ["Divisions" divisions]
  ["DopingAssignment" doping-assignment] ["Normalization" normalization]
  ["NumberOfThreads" number-of-threads] ["ScreeningFactor" screening-factor]
  ["ScreeningScalingFactor" screening-scaling-factor] ["Species" species])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>file</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>auto-screening-factor</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>boundary-extension</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>divisions</td>
        <td>INTEGER (optional)</td>
    </tr>
    <tr>
        <td>doping-assignment</td>
        <td>STRING (optional)<br/>"CIC" | "NGP" | "Sano"</td>
    </tr>
    <tr>
        <td>normalization</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>number-of-threads</td>
        <td>INTEGER (optional)</td>
    </tr>
    <tr>
        <td>screening-factor</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>screening-scaling-factor</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>species</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## See Also

Sentaurus™ Mesh User Guide, Defining Particle Profiles on page 15 for descriptions of parameters

<page_number>536</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdedr:define-particle-profile-placement

# sdedr:define-particle-profile-placement

Creates a placement for a particle profile definition in the mesh command file.

## Syntax

```scheme
(sdedr:define-particle-profile-placement placement-name definition-name
  "EvalWindow" eval-window eval-window-type
  ["Replace" replace | "LocalReplace" local-replace])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>eval-window</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>eval-window-type</td>
        <td>{"region" | "material" | "evalwin"}</td>
    </tr>
    <tr>
        <td>replace</td>
        <td>BOOLEAN (optional)</td>
    </tr>
    <tr>
        <td>local-replace</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

BOOLEAN

## Description

This Scheme extension creates a particle profile placement.

**NOTE** Only "Replace" or "LocalReplace" can be set to true at the same time.

## See Also

Sentaurus™ Mesh User Guide, Placing Particle Profiles on page 29 for descriptions of parameters

Sentaurus™ Structure Editor User Guide
537
S-2021.06
<page_number>537</page_number>

A: Commands
sdedr:define-refeval-window

# sdedr:define-refeval-window

Defines a geometric region that can be used as a Ref/Eval window.

## Syntax

`(sdedr:define-refeval-window rfwin-name { single-shape | multi-shape })`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rfwin-name</td>
        <td>STRING (name of Ref/Eval window)</td>
    </tr>
    <tr>
        <td>multi-shape</td>
        <td>(list single-shape1 single-shape2 ...<br/>single-shapen)</td>
    </tr>
    <tr>
        <td>single-shape</td>
        <td>rfwin-type data<br/><br/>where rfwin-type can be:<br/>{"Point" | "Line" | "Rectangle" | "Polygon" |<br/>"Cuboid" | "ComplexPolygon" | "Polyhedron"}<br/><br/>where data can be:<br/>POSITION | POSITION LIST</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY of the ACIS body Ref/Eval window if it was successfully created; otherwise, #f if the operation failed.

## Description

For `rfwin-type`:

* In the case of "Point", the data argument is a position.

* In the case of "Line", "Rectangle", or "Cuboid", the data argument is POSITION POSITION (the two opposite corners). The keywords "Rectangle" and "Cuboid" are axis aligned.

* In the case of "Polygon", the data argument is a position list (the first and last positions must be the same).

* "ComplexPolygon" is for multiconnected polygons, that is, polygons with internal doughnut holes. In this case, the data argument is a list of polygon shapes where the first polygon given is the outer perimeter, and the subsequent polygon shapes in the list represent internal holes.

* In the case of "Polyhedron", the data argument is a list of polygon definitions creating a closed polyhedral solid from the union of the polygon faces.

* The `rfwin-type` object is not case sensitive.

<page_number>538</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sdedr:define-refeval-window

Multiple body shapes are created by listing multiple single shapes with the `(list ...)` construct. (Choose **Mesh** > **Define Ref/Eval Window**.)

The faces of the defined Ref/Eval windows are oriented. The face normal direction follows the right-hand rule (for polygonal Ref/Eval windows, the vertex list must be counterclockwise). In this case, the Ref/Eval windows are used in the `sdedr:define-analytical-profile-placement` Scheme extension for reference. The "Positive" and "Negative" arguments in this Scheme extension must be adjusted to the Ref/Eval window normal direction.

## Examples

```scheme
; Line
(sdedr:define-refeval-window "rfwin1" "Line" (position 0 0 0) (position 1 0 0))

; Rectangle
(sdedr:define-refeval-window "rfwin2" "Rectangle" (position 0 -2 0)
 (position 1 -1 0))

; Polygon
(sdedr:define-refeval-window "rfwin3" "Polygon" (list (position 1 2 0.0)
 (position 0.75 2 0.0) (position 1 2.5 0.0) (position 1.25 3 0.0)
 (position 1.5 3.5 0.0) (position 1.75 4 0.0) (position 2 4.25 0.0)
 (position 2.25 4.5 0.0) (position 2.5 2 0.0) (position 1.5 2 0.0)
 (position 1 2 0.0)))

; Cuboid
(sdedr:define-refeval-window "rfwin4" "Cuboid" (position 0 0 0)
 (position 1 2 3))

; Multiconnected Polygon = ComplexPolygon
(sdedr:define-refeval-window "polygon-multiconnected" "ComplexPolygon"
 (list
 (list (position 0 0 0) (position 0 3 0) (position 3 3 0) (position 3 0 0))
 (list (position 1 1 0) (position 1 2 0) (position 2 2 0) (position 2 1 0))))

; Polyhedron
(sdedr:define-refeval-window "polyhedron_shape" "Polyhedron" (list
 (list (position 0 0 0) (position 0 3 0) (position 3 3 0) (position 3 0 0))
 (list (position 0 0 3) (position 0 3 3) (position 3 3 3) (position 3 0 3))
 (list (position 0 0 0) (position 0 0 3) (position 3 0 3) (position 3 0 0))
 (list (position 0 3 0) (position 0 3 3) (position 3 3 3) (position 3 3 0))
 (list (position 0 0 0) (position 0 3 0) (position 0 3 3) (position 0 0 3))
 (list (position 3 0 0) (position 3 3 0) (position 3 3 3) (position 3 0 3))))
```

Sentaurus™ Structure Editor User Guide

<page_number>539</page_number>

S-2021.06

# A: Commands

sdedr:define-refeval-window

```scheme
; Multiple body
(sdedr:define-refeval-window "multiple_body" (list
  (list "Point" (position 0.15 0.25 0))
  (list "Rectangle" (position 0.1 0.2 0) (position 0.3 0.4 0))
  (list "Line" (position 1.5 1.6 0) (position 1.7 1.8 0))
  (list "Polygon" (list (position 0 0 0) (position 0.1 0.3 0)
  (position 0.2 0.4 0) (position 0.3 0.2 0) (position 0.2 0.0 0)
  (position 0.1 -0.1 0) (position 0 0 0)))
  (list "Cuboid" (position 3.1 3.2 3.3) (position 3.4 3.5 3.6))))
```

<page_number>540</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:define-refinement-function

# sdedr:define-refinement-function

Adds a refinement function to the specified refinement.

## Syntax

```scheme
(sdedr:define-refinement-function definition-name function-name
  { "MaxLenInt" mat-reg mat-reg value [factor] ["DoubleSide"]
      ["UseRegionNames"] |
    "MaxInterval" "Variable" dopant-name "Cmin" cmin "Cmax" cmax
      ["Scaling" scaling] ["TargetLength" targetLength] ["Rolloff"] |
    "MaxGradient" value | "MaxTransDiff" value })
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>function-name</td>
        <td>STRING (name of function to be used for refinement)</td>
    </tr>
    <tr>
        <td>value</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>factor</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>mat-reg</td>
        <td>STRING (material or region names defining the interface)</td>
    </tr>
    <tr>
        <td>dopant-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>cmin</td>
        <td>REAL | REAL LIST</td>
    </tr>
    <tr>
        <td>cmax</td>
        <td>REAL | REAL LIST</td>
    </tr>
    <tr>
        <td>scaling</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>targetLength</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## See Also

Sentaurus™ Mesh User Guide, Defining Refinement Regions on page 18 for descriptions of parameters

Sentaurus™ Structure Editor User Guide

<page_number>541</page_number>

S-2021.06

A: Commands

sdedr:define-refinement-material

# sdedr:define-refinement-material

Defines the placements information for a ‘materialwise’ refinement.

## Syntax

```scheme
(sdedr:define-refinement-material placement-name definition-name
 material-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>material-name</td>
        <td>DATEXMAT</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```scheme
(sdedr:define-refinement-material "p1" "d1" "Silicon")
```

<page_number>

542
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
sdedr:define-refinement-placement

# sdedr:define-refinement-placement

Creates a refinement placement in the mesh command file.

## Syntax

```
(sdedr:define-refinement-placement refinement-name definition-name
  ref-eval-window)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>refinement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>ref-eval-window</td>
        <td>STRING | LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The `ref-eval-window` argument can be either a simple string (the name of the defined refinement window) or a list of Ref/Eval windows, materials, and regions in the form:

```
(list "window" "refevalwin1" "window" "refevalwindow2" ... "material"
"material1" ... "region" "region1" ...)
```

If a list is specified, the refinement is performed at the intersection of all the criteria.

## See Also

Sentaurus™ Mesh User Guide, Defining Refinement Regions on page 18 for descriptions of parameters

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>543</page_number>

**A: Commands**

sdedr:define-refinement-region

# sdedr:define-refinement-region

Defines the placements information for a ‘regionwise’ refinement.

## Syntax

`(sdedr:define-refinement-region placement-name definition-name region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

`(sdedr:define-refinement-region "p1" "d1" "Region_1")`

<page_number>544</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sdedr:define-refinement-size

# sdedr:define-refinement-size

Creates a refinement size definition in the mesh command file.

## Syntax

```scheme
(sdedr:define-refinement-size definition-name max-x max-y max-z min-x min-y
min-z)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>max-x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>max-y</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>max-z</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>min-x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>min-y</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>min-z</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## See Also

Sentaurus™ Mesh User Guide, Defining Refinement Regions on page 18 for descriptions of parameters

Sentaurus™ Structure Editor User Guide

<page_number>545</page_number>

S-2021.06

**A: Commands**
sdedr:define-submesh

# sdedr:define-submesh

Creates a 1D external profile in the mesh command file.

## Syntax

```
(sdedr:define-submesh definition-name geofile-name file1 mode1 file2 mode2 ...
 filen moden [ (list field1 field2 fieldn) ])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>geofile-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>file[1...n]</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>mode[1...n]</td>
        <td>{"r" | "i" | "o" | "w" | "w=outfile-name"}</td>
    </tr>
    <tr>
        <td>field[1...n]</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## See Also

Sentaurus™ Mesh User Guide, Defining Submeshes on page 22 for descriptions of parameters

<page_number>546</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:define-submesh-placement

# sdedr:define-submesh-placement

Creates a submesh placement in the mesh command file.

## Syntax

```scheme
(sdedr:define-submesh-placement placement-name definition-name
    evaluation-window ["PlacementType" eval-window-type]
    ["DecayLength" decay-length | "GaussDecayLength" gauss-decay-length]
    ["Replace" | "NoReplace" | "LocalReplace"]
    ["IgnoreMat"] ["MatchMaterialType"])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>decay-length</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>definition-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>eval-window-type</td>
        <td>region | "material" | "evalwin"</td>
    </tr>
    <tr>
        <td>evaluation-window</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>gauss-decay-length</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The evaluation-window can name a region, material, or Ref/Eval window, depending on the eval-window-type. The default eval-window-type is "evalwin".

To rotate, shift, or reflect submesh placements, use the sdedr:transform-submesh-placement Scheme extension.

## See Also

Sentaurus™ Mesh User Guide, Placements Section on page 23 for descriptions of parameters

Sentaurus™ Structure Editor User Guide

<page_number>547</page_number>

S-2021.06

# A: Commands

sdedr:del-selected-drentity

---

# sdedr:del-selected-drentity

Deletes a specified entity or list of entities.

## Syntax

`(sdedr:del-selected-drentity entity | entity-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>entity</td>
        <td>ENTITY</td>
    </tr>
    <tr>
        <td>entity-list</td>
        <td>ENTITY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

---

# sdedr:delete-multibox-placement

Deletes the specified multibox placement from the placements part of the command file.

## Syntax

`(sdedr:delete-multibox-placement placement-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

`(sdedr:delete-multibox-placement "multibox_1")`

<page_number>548</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdedr:delete-profile-placement

# sdedr:delete-profile-placement

Deletes the specified placement.

## Syntax

`(sdedr:delete-profile-placement placement-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

Sentaurus™ Structure Editor User Guide <page_number>549</page_number>
S-2021.06

A: Commands
sdedr:delete-refeval-window

# sdedr:delete-refeval-window

Deletes a Ref/Eval window or list of Ref/Eval windows.

## Syntax

`(sdedr:delete-refeval-window bodies)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>bodies</td>
        <td>BODY | BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```scheme
(sdedr:define-refeval-window "rw1" "Rectangle" (position 0 0 0)
   (position 1 1 0))
(sdedr:define-refeval-window "rw2" "Rectangle" (position 1 0 0)
   (position 2 1 0))
(sdedr:define-refeval-window "rw3" "Rectangle" (position 2 0 0)
   (position 3 1 0))
(sdedr:delete-refeval-window "rw1") ; or equivalently
(sdedr:delete-refeval-window (list "rw1"))
(sdedr:delete-refeval-window (list "rw2" "rw3"))
; refinement/evaluation windows can also be deleted, by selecting them,
; and using (sde:selected-refeval-windows)
(sdedr:delete-refeval-window (sde:selected-refeval-windows))
```

<page_number>550</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:delete-refinement-placement

# sdedr:delete-refinement-placement

Deletes the specified refinement placement from the placements part of the command file.

## Syntax

`(sdedr:delete-refinement-placement placement-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

`(sdedr:delete-refinement-placement "refinement_1")`

# sdedr:delete-submesh-placement

Deletes the specified placement.

## Syntax

`(sdedr:delete-submesh-placement placement-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

Sentaurus™ Structure Editor User Guide

<page_number>551</page_number>

S-2021.06

**A: Commands**

sdedr:get-cmdprecision

# sdedr:get-cmdprecision

Returns the precision value of the mesh command file. The default value is 12.

### Syntax

```scheme
(sdedr:get-cmdprecision)
```

### Returns

INTEGER

---

# sdedr:get-definition-list

Returns a list of definition names of one of the placement types.

### Syntax

```scheme
(sdedr:get-definition-list "multibox" | "profile" | "refinement")
```

### Returns

STRING LIST

---

# sdedr:get-placement-list

Returns a list of placement names of one of the placement types.

### Syntax

```scheme
(sdedr:get-placement-list "multibox" | "profile" | "refinement")
```

### Returns

STRING LIST

<page_number>552</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdedr:hide-mbox

# sdedr:hide-mbox

Hides the specified multiboxes.

## Syntax

`(sdedr:hide-mbox mbox-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>mbox-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

# sdedr:hide-profile

Hides the specified analytic doping profiles.

## Syntax

`(sdedr:hide-profile profile-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>profile-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>553</page_number>

A: Commands

sdedr:hide-refinement

# sdedr:hide-refinement

Hides the specified refinements.

## Syntax

`(sdedr:hide-refinement refinement-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>refinement-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 10 10 0) "Silicon"
   "region_1")
(sdegeo:create-rectangle (position 4 10 0) (position 6 12 0) "PolySilicon"
   "region_2")
(sdedr:define-refinement-size "ref1" 2 2 2 1 1 1)
(sdedr:define-refinement-region "ref1" "ref1" "region_1")
(sdedr:show-refinement "ref1")
(sdedr:hide-refinement "ref1")
```

<page_number>554</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdedr:hide-rewin

# sdedr:hide-rewin

Hides the specified Ref/Eval window or windows.

## Syntax

`(sdedr:hide-rewin rewin-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rewin-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```
(sdedr:define-refeval-window "N1" "Rectangle" (position 0 0 0)
   (position 1 1 0))
(sdedr:define-refeval-window "N2" "Rectangle" (position 2 0 0)
   (position 3 1 0))
(sdedr:define-refeval-window "N3" "Rectangle" (position 4 0 0)
   (position 5 1 0))
(sdedr:define-refeval-window "N4" "Rectangle" (position 0 2 0)
   (position 1 3 0))
(sdedr:define-refeval-window "N5" "Rectangle" (position 2 2 0)
   (position 3 3 0))
(sdedr:define-refeval-window "N6" "Rectangle" (position 4 2 0)
   (position 5 3 0))
(sdedr:define-refeval-window "N7" "Rectangle" (position 0 4 0)
   (position 1 5 0))
(sdedr:define-refeval-window "N8" "Rectangle" (position 2 4 0)
   (position 3 5 0))
(sdedr:define-refeval-window "N9" "Rectangle" (position 4 4 0)
   position 5 5 0))
(sdedr:hide-rewin (list "N1" "N2" "N3" "N4" "N5" "N6" "N7" "N8" "N9"))
(sdedr:show-rewin "N1")
(sdedr:show-rewin (list "N2" "N3" "N4"))
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

555
</page_number>

**A: Commands**

sdedr:offset-block

# sdedr:offset-block

Generates a new offsetting block inside the Offsetting section of the mesh command file.

## Syntax

```scheme
(sdedr:offset-block "region" region "maxlevel" maxlevel)
(sdedr:offset-block "material" material "maxlevel" maxlevel)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>maxlevel</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

<page_number>556</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdedr:offset-interface

# sdedr:offset-interface

Generates a new offsetting interface block inside the `Offsetting` section of the mesh command file.

## Syntax

```scheme
(sdedr:offset-interface "region" region1 region2
  "hlocal" hlocal "factor" factor
  "window" x1 y1 z1 x2 y2 z2)

(sdedr:offset-interface "material" material1 material2
  "hlocal" hlocal "factor" factor
  "window" x1 y1 z1 x2 y2 z2)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>hlocal</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>factor</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>x1 y1 z1 x2 y2 z2</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>557</page_number>

A: Commands
sdedr:read-cmd-file

# sdedr:read-cmd-file

Loads a mesh command file.

## Syntax

`(sdedr:read-cmd-file cmd-file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>cmd-file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension parses a specified mesh command file and initializes the doping-related and refinement-related data structures in Sentaurus Structure Editor. The command file entities can be visualized using the Placements Viewer.

The command file entities can be manipulated by using the `sdedr` Scheme extensions or the Sentaurus Structure Editor GUI menus.

<page_number>

558
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:redefine-refeval-window

# sdedr:redefine-refeval-window

Redefines a previously defined geometric Ref/Eval window.

## Syntax

`(sdedr:redefine-refeval-window rfwin-name new-rfwin-name rfwin-type data)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rfwin-name</td>
        <td>STRING (name of Ref/Eval window)</td>
    </tr>
    <tr>
        <td>new-rfwin-name</td>
        <td>STRING (new name of Ref/Eval window)</td>
    </tr>
    <tr>
        <td>rfwin-type</td>
        <td>{"Point" | "Line" | "Rectangle" | "Polygon" | "Cuboid"}</td>
    </tr>
    <tr>
        <td>data</td>
        <td>POSITION | POSITION LIST</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY ID of the redefined ACIS body Ref/Eval window; otherwise, #f if the operation fails

## Description

For the argument `rfwin-type`:

* In the case of `"Point"`, the data argument is a position.

* In the case of `"Line"` or `"Rectangle"` or `"Cuboid"`, the data argument is `POSITION POSITION` (the two opposite corners).

* In the case of `"Polygon"`, the data argument is a position list (the first and last positions must be the same).

This Scheme extension is used mainly in renaming existing Ref/Eval windows.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>559</page_number>

A: Commands
sdedr:refine-box

# sdedr:refine-box

Defines a refinement window–style refinement box.

## Syntax

```scheme
(sdedr:refine-box refinement_name pos_min pos_max spacing)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>refinement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>pos_min</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>pos_max</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>spacing</td>
        <td>REAL | REAL REAL REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension defines a refinement window–style refinement box, where:

* `refinement-name` is the name of the refinement box.

* `pos_min` is the minimum coordinate of the box.

* `pos_max` is the maximum coordinate of the box.

* `spacing` is either a single value, which denotes the mesh spacing in all directions, or a list of three values for spacing in each direction.

The Scheme extension defines a refinement rectangle in two dimensions and a refinement cuboid in three dimensions.

<page_number>560</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdedr:refine-doping

# sdedr:refine-doping

Adds a refinement based on doping (`field:DopingConcentration`) in an entire region or material.

## Syntax

```scheme
(sdedr:refine-doping spacing | sx sy sz ["MaxTransDiff" asinhdiff]
    ["material" "m" | "region" "r"])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>spacing</td>
        <td>REAL | REAL REAL REAL</td>
    </tr>
    <tr>
        <td>sx sy sz</td>
        <td>REAL REAL REAL</td>
    </tr>
    <tr>
        <td>MaxTransDiff</td>
        <td>KEYWORD (optional)</td>
    </tr>
    <tr>
        <td>asinhdiff</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>material</td>
        <td>KEYWORD (optional)</td>
    </tr>
    <tr>
        <td>m</td>
        <td>STRING (optional)</td>
    </tr>
    <tr>
        <td>region</td>
        <td>KEYWORD (optional)</td>
    </tr>
    <tr>
        <td>r</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension adds a refinement based on doping (`field:DopingConcentration`) in an entire region or material:

* `spacing` is either a single value, which denotes the mesh spacing in all directions, or a list of three values for spacing in each direction.

* `asinhdiff` is the value for `MaxTransDiff`. If you do not specify any value, 1.0 is used.

* `"material"` or `"region"` is the material name or the region name in which the refinement is performed. If you do not specify any value, `material = "Silicon"` is used.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>561</page_number>

A: Commands

sdedr:refine-interface

# sdedr:refine-interface

Creates a refined mesh at an interface.

## Syntax

```scheme
(sdedr:refine-interface "region" r1 r2 | "material" m1 m2
    "hlocal" spacing ["factor" factor] ["window" x1 y1 z1 x2 y2 z2])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>region</td>
        <td>KEYWORD</td>
    </tr>
    <tr>
        <td>r1</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>r2</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>material</td>
        <td>KEYWORD</td>
    </tr>
    <tr>
        <td>m1</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>m2</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>hlocal</td>
        <td>KEYWORD</td>
    </tr>
    <tr>
        <td>spacing</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>factor</td>
        <td>KEYWORD (optional)</td>
    </tr>
    <tr>
        <td>factor</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>window</td>
        <td>KEYWORD (optional)</td>
    </tr>
    <tr>
        <td>x1 y1 z1 x2 y2 z2</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension creates a refined mesh at an interface:

*   The `"region"` or `"material"` keyword identifies the interface type.

*   `r1` or `m1` denotes the first region or material.

*   `r2` or `m2` denotes the second region or material.

*   `spacing` is the initial normal spacing at the interface (scalar).

<page_number>

562
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**

sdedr:refine-interface

*   `factor` determines how fast the spacing increases (optional; it defaults to 2.0).

*   `x1 y1 z1 x2 y2 z2` define the window corners if the placement will be restricted to a window (optional, the default is no window; placement in `r1` or `m1`).

Following the convention used in Sentaurus Structure Editor and Sentaurus Mesh, but unlike Sentaurus Process, the refinement is placed only in region `r1` or material `m1`, unless users specify a window, in which case, the placement is performed in the entire window.

Sentaurus™ Structure Editor User Guide

<page_number>563</page_number>

S-2021.06

A: Commands
sdedr:set-cmdprecision

# sdedr:set-cmdprecision

Sets the precision value of the mesh command file.

## Syntax

`(sdedr:set-cmdprecision cmdprecision)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>cmdprecision</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension sets the precision value of the mesh command file. The number of digits that is written in the mesh command file for Ref/Eval window coordinates can be controlled. The vertex coordinates of the Ref/Eval windows that are written to the mesh command file can be chopped and rounded.

Rounding the vertex coordinates of the Ref/Eval objects might be needed, for example, when a rigid body rotation is performed on a Ref/Eval window, which will introduce some rounding errors.

The default value is 12.

<page_number>

564
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdedr:set-title

# sdedr:set-title

Sets the title of the command file.

## Syntax

```scheme
(sdedr:set-title cmd-file-title)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>cmd-file-title</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

Information is written to the `Title` section of the command file. If this Scheme extension is not called explicitly, then the title of the command file is set to `Untitled`.

# sdedr:show-mbox

Displays the specified multiboxes.

## Syntax

```scheme
(sdedr:show-mbox mbox-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>mbox-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

Sentaurus™ Structure Editor User Guide
<page_number>565</page_number>
S-2021.06

A: Commands

sdedr:show-profile

# sdedr:show-profile

Displays the specified analytic doping profiles.

## Syntax

```scheme
(sdedr:show-profile profile-list)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>profile-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

<page_number>

566
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
sdedr:show-refinement

# sdedr:show-refinement

Displays the specified refinements.

## Syntax

`(sdedr:show-refinement refinement-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>refinement-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 10 10 0) "Silicon"
  "region_1")
(sdegeo:create-rectangle (position 4 10 0) (position 6 12 0) "PolySilicon"
  "region_2")
(sdedr:define-refinement-size "ref1" 2 2 2 1 1 1)
(sdedr:define-refinement-region "ref1" "ref1" "region_1")
(sdedr:show-refinement "ref1")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>567</page_number>

A: Commands
sdedr:show-rewin

# sdedr:show-rewin

Displays the specified Ref/Eval window or windows.

## Syntax

`(sdedr:show-rewin rewin-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>rewin-list</td>
        <td>STRING LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Examples

```scheme
(sdedr:define-refeval-window "N1" "Rectangle" (position 0 0 0)
  (position 1 1 0))
(sdedr:define-refeval-window "N2" "Rectangle" (position 2 0 0)
  (position 3 1 0))
(sdedr:define-refeval-window "N3" "Rectangle" (position 4 0 0)
  (position 5 1 0))
(sdedr:define-refeval-window "N4" "Rectangle" (position 0 2 0)
  (position 1 3 0))
(sdedr:define-refeval-window "N5" "Rectangle" (position 2 2 0)
  (position 3 3 0))
(sdedr:define-refeval-window "N6" "Rectangle" (position 4 2 0)
  (position 5 3 0))
(sdedr:define-refeval-window "N7" "Rectangle" (position 0 4 0)
  (position 1 5 0))
(sdedr:define-refeval-window "N8" "Rectangle" (position 2 4 0)
  (position 3 5 0))
(sdedr:define-refeval-window "N9" "Rectangle" (position 4 4 0)
  (position 5 5 0))
(sdedr:hide-rewin (list "N1" "N2" "N3" "N4" "N5" "N6" "N7" "N8" "N9"))
(sdedr:show-rewin "N1")
(sdedr:show-rewin (list "N2" "N3" "N4"))
```

<page_number>568</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdedr:transform-submesh-placement

# sdedr:transform-submesh-placement

Defines transform operations applied to the named external profile placement.

## Syntax

```scheme
(sdedr:transform-submesh-placement placement-name
  [<transform1> <transform2> ... <transformN>])
```

where `<transformX>` is any one of these transforms:

*   "Reflect" axis

*   "Rotation" angle axis

*   "ShiftVector" (gvector x y z)

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>placement-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>axis</td>
        <td>X | "Y" | "Z"</td>
    </tr>
    <tr>
        <td>angle</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>x, y, z</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension defines a transform operation, or a series of transform operations, applied to the named external profile placement. The operation or series of operations is appended to any existing series of operations already applied to the placement.

Any number of operations can be given by users in this Scheme extension, and it can be called any number of times. Operations are performed in the order of calls to this extension and in the order listed within each call.

The Scheme extension `sdedr:clear-submesh-placement-transform` is used to clear the list of transformation operations for a given external profile placement.

Sentaurus™ Structure Editor User Guide

<page_number>569</page_number>

S-2021.06

A: Commands
sdedr:write-cmd-file

# sdedr:write-cmd-file

Writes a mesh command file.

## Syntax

`(sdedr:write-cmd-file cmd-file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>cmd-file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension writes all doping-related and refinement-related data to the specified command file. The command file can be used during a subsequent meshing action, together with the generated boundary file. By using a command file, you can control, for example, local mesh refinements during meshing.

570 Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>570</page_number>

A: Commands
sdedr:write-scaled-cmd-file

# sdedr:write-scaled-cmd-file

Writes a mesh command file (after scaling some dimensions).

## Syntax

`(sdedr:write-scaled-cmd-file cmd-file-name scaling-factor)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>cmd-file-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>scaling-factor</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension writes all doping-related and refinement-related data to the specified command file, which can be used during a subsequent meshing action, together with the generated boundary file. By using a command file, you can control, for example, local mesh refinements, during meshing.

All position and length parameters are multiplied by `scaling-factor`. All gradient parameters are divided by `scaling-factor`.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

571
</page_number>

**A: Commands**

sdeepi:create-layerstack

# sdeepi:create-layerstack

Creates a planar layer stack structure from the CSV input data.

## Syntax

`(sdeepi:create-layerstack file-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

If the global Scheme variable `sdeepi:use-global-vars` is set to `#t` (default is `#f`), then the global and layer variables of the sdeepi Scheme extensions also are initialized as global Scheme variables and can be used for subsequent computations.

<page_number>

572
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands

sdeepi:publish-global-vars

# sdeepi:publish-global-vars

Defines the epi layer stack variables as global Scheme variables.

## Syntax

`(sdeepi:publish-global-vars make-global-vars)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>make-global-vars</td>
        <td>BOOLEAN</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

The `sdeepi:publish-global-vars` Scheme extension defines the global and layer variables of the `sdeepi` Scheme extensions as global Scheme variables.

If the `sdeepi:publish-global-vars` Scheme extension is called with a `#t` argument, all the published global and layer variables will be available as global Scheme variables after the epi layers are created using the `sdeepi:create-layerstack` Scheme extension. By default, to avoid overwriting existing Scheme variables, no layer stack variables are retained after the stack creation.

Sentaurus™ Structure Editor User Guide

<page_number>573</page_number>

S-2021.06

A: Commands
sdeepi:scm

# sdeepi:scm

Generates a Scheme script for creating a planar layer stack structure from CSV input data.

## Syntax

```scheme
(sdeepi:scm file-name [output-file-name])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>output-file-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension generates a Scheme script for creating a planar layer stack structure from CSV input data. This can be useful to investigate the layer stack creation in more detail. The Scheme script will be named like `file-name` but with `.scm` as the file extension unless it is specified explicitly using the optional `output-file-name` argument.

<page_number>574</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdeepi:tcl

# sdeepi:tcl

Generates a Tcl script that contains all layer stack data from the CSV input file defined as Tcl variables.

## Syntax

`(sdeepi:tcl file-name [output-file-name])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>file-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>output-file-name</td>
        <td>STRING (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension creates a Tcl script that contains all layer stack–specific data from the CSV input file in the form of Tcl variables. This file can be easily sourced in Tcl preprocessing blocks or any other Tcl interpreter such as Sentaurus Visual or Inspect to access layer data (see Global Section on page 245 for an example).

The Tcl file will be named like `file-name` but with `.tcl` as the file extension unless it is specified explicitly using the optional `output-file-name` argument.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>575</page_number>

A: Commands

sdegeo:2d-cut

# sdegeo:2d-cut

Extracts a 2D cut from a 2D device.

## Syntax

`(sdegeo:2d-cut p1 p2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>p1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>p2</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension extracts a 2D rectangular part from a 2D device. The rectangle is specified by the two opposite corners of the rectangle (`p1` and `p2`).

<page_number>576</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**A: Commands**
sdegeo:3d-cut

# sdegeo:3d-cut

Extracts a 2D slice from a 3D device.

## Syntax

```scheme
(sdegeo:3d-cut base-position normal-vector [tr-xy] [tr-record]
   [tr-axisaligned])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>base-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>normal-vector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>tr-xy</td>
        <td>BOOLEAN (optional), default value is #f</td>
    </tr>
    <tr>
        <td>tr-record</td>
        <td>BOOLEAN (optional), default value is #f</td>
    </tr>
    <tr>
        <td>tr-axisaligned</td>
        <td>BOOLEAN (optional), default value is #f</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension cuts a 2D slice from a 3D device. The cut plane is defined by a base point (`base-position`) and a normal vector to the cut plane (`normal-vector`). This Scheme extension transfers 3D face contacts to 2D edge contacts.

The optional `tr-xy` argument is used to transform the 2D cut to the xy plane. This is needed when the 2D cut is to be meshed.

The optional `tr-record` argument is used to record the transform (rotation and translation) that transforms the 2D cut on the xy plane. The `sde:tr-get` Scheme extension can be used to return the rotation ($3 \times 3$ matrix) and translation (vector) components of the transform (see sde:tr-get on page 503).

The `sdegeo:3d-cut` Scheme extension always creates a well-defined 2D model. If the original 3D model contains multiple touching faces at the cut position in the cut plane (material/region interfaces), then the direction of the normal vector (which is specified in the argument list of the `sdegeo:3d-cut` command) defines which regions to keep in the 2D model.

The 2D cut will contain only those faces that are visible from the normal plane direction in the 3D model. In this way, the outcome of the `sdegeo:3d-cut` operation is always well defined,

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>577</page_number>

A: Commands

sdegeo:3d-cut

and the 2D cut will not contain overlapping faces. If the 2D sheet bodies in the 2D cut contain multiple faces, then these faces are merged to one face.

The `tr-axisaligned` argument is used to trigger new transformation rules for axis-aligned cuts. If the new transformation rule is applied, then the positioning of the 2D cut can be explicitly calculated following the simple rules in Table 41.

Table 41 Transformation rules for axis-aligned cuts

<table>
  <thead>
    <tr>
        <th>Cut plane normal</th>
        <th>New 2D coordinate axes (x, y) with respect to global coordinate system</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>( 1, 0, 0 )</td>
        <td>(0,1,0) (0,0,1)</td>
    </tr>
    <tr>
        <td>(-1, 0, 0 )</td>
        <td>(0,1,0) (0,0,1)</td>
    </tr>
    <tr>
        <td>( 0, 1, 0 )</td>
        <td>(1,0,0) (0,0,1)</td>
    </tr>
    <tr>
        <td>( 0, -1, 0 )</td>
        <td>(1,0,0) (0,0,1)</td>
    </tr>
    <tr>
        <td>( 0, 0, 1 )</td>
        <td>(1,0,0) (0,1,0)</td>
    </tr>
    <tr>
        <td>( 0, 0, -1 )</td>
        <td>(1,0,0) (0,1,0)</td>
    </tr>
  </tbody>
</table>

**NOTE** The + and – face normal directions are not distinguished, so the (1,0,0) cut plane normal will generate the same result as the (-1,0,0) normal.

The model is placed such that the minimum bounding box position (lower-left corner) will be the same as the minimum bounding box position of the 3D model at the cut plane position. The axis-aligned transformation rule determines which coordinates to use for xmin and ymin for the 2D cut from the global x,y,z bounding box minimum.

The transformation rules for axis-aligned cuts are:

* If the gvector is parallel to the x-axis, the 2D cut x-axis would be the global y-axis, and the 2D cut y-axis would be the global z-axis. The global bounding box minimum coordinates `bbymin` and `bbzmin` would be the minimum coordinates of the 2D cut: xmin = `bbymin`, ymin = `bbzmin`.

* If the gvector is parallel to the y-axis, the 2D cut x-axis would be the global x-axis, and the 2D cut y-axis would be the global z-axis. The global bounding box minimum coordinates `bbxmin` and `bbzmin` would be the minimum coordinates of the 2D cut: xmin = `bbxmin`, ymin = `bbzmin`.

* If the gvector is parallel to the z-axis, the 2D cut x-axis would be the global x-axis, and the 2D cut y-axis would be the global y-axis. The global bounding box minimum coordinates `bbxmin` and `bbymin` would be the minimum coordinates of the 2D cut: xmin = `bbxmin`, ymin = `bbymin`.

<page_number>578</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdegeo:3d-cut

## Examples

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position 10 10 0) "Silicon"
"region_1")
(sdegeo:define-contact-set "cstop" 4 (color:rgb 1 0 0) "##")
(sdegeo:define-contact-set "csbottom-middle" 4 (color:rgb 1 1 0) "||")
(sdegeo:set-contact (find-edge-id (position 5 10 0)) "cstop")
(sdegeo:insert-vertex (position 3 0 0))
(sdegeo:insert-vertex (position 7 0 0))
(sdegeo:set-current-contact-set "csbottom-middle")
(sdegeo:set-contact (find-edge-id (position 5 0 0)) "csbottom-middle")
; 2D model containing edge contacts
(sdegeo:extrude (find-face-id (position 5 5 0)) 6)
; 3D model containing face contacts
(sdegeo:3d-cut (position 5 0 2) (gvector 0 0 1))
; 2D model containing edge contacts
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>579</page_number>

A: Commands
sdegeo:align-horizontal

# sdegeo:align-horizontal

Aligns points horizontally to a specified position.

**NOTE** This Scheme extension applies to 2D models only.

## Syntax

`(sdegeo:align-horizontal vertex-list align-position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>VERTEX LIST</td>
    </tr>
    <tr>
        <td>align-position</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension aligns the specified vertices to a horizontal line. The argument `vertex-list` contains the list of vertices, and `align-position` defines the position (y-coordinate) of the line.

<page_number>

580
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:align-horizontal-aut

# sdegeo:align-horizontal-aut

Aligns points horizontally to the average position.

**NOTE** This Scheme extension applies to 2D models only.

## Syntax

`(sdegeo:align-horizontal-aut vertex-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>VERTEX LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension aligns the specified vertices to a horizontal line. The argument `vertex-list` contains the list of vertices. The align position (y-coordinate) of the line is defined using the average y-coordinate of the specified vertices, which is calculated automatically.

Sentaurus™ Structure Editor User Guide

<page_number>581</page_number>

S-2021.06

A: Commands
sdegeo:align-to-line

# sdegeo:align-to-line

Aligns vertices to a line.

**NOTE** This Scheme extension applies to 2D models only.

## Syntax

`(sdegeo:align-to-line vertex-list pos1 pos2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>VERTEX LIST</td>
    </tr>
    <tr>
        <td>pos1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>pos2</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension aligns the specified vertices (given by a vertex list `vertex-list`) to a line. The line is specified by two points (`pos1` and `pos2`). The points must lie on the same work plane as the `vertex-list` vertices. The vertices are projected to the specified line.

<page_number>

582
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:align-vertical

# sdegeo:align-vertical

Aligns points vertically to a specified position.

**NOTE** This Scheme extension applies to 2D models only.

## Syntax

`(sdegeo:align-vertical vertex-list align-position)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>VERTEX LIST</td>
    </tr>
    <tr>
        <td>align-position</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension aligns the specified vertices to a vertical line. The argument `vertex-list` contains the list of vertices and `align-position` defines the new position (x-coordinate) of the line.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

583
</page_number>

A: Commands
sdegeo:align-vertical-aut

# sdegeo:align-vertical-aut

Aligns points vertically to the average position.

**NOTE** This Scheme extension applies to 2D models only.

## Syntax

`(sdegeo:align-vertical-aut vertex-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>VERTEX LIST</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension aligns the specified vertices to a vertical line. The argument `vertex-list` contains the list of vertices. The align position (x-coordinate) of the line is defined using the average x-coordinate of the specified vertices, which is calculated automatically.

<page_number>

584
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:average-edge-length

# sdegeo:average-edge-length

Computes the length of each edge in `edge-list`, and returns the average edge length.

## Syntax

(sdegeo:average-edge-length edge-list)

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge-list</td>
        <td>EDGE LIST</td>
    </tr>
  </tbody>
</table>

## Returns

REAL

## Examples

```scheme
(sde:clear)
(sdegeo:set-default-boolean "AB")
(sdegeo:create-rectangle (position 0 0 0) (position 2 2 0) "Silicon"
  "region_1")
(sdegeo:create-circle (position 1 2 0) 1 "Silicon" "region_2")
(define elist (entity:edges (get-body-list)))
(sdegeo:average-edge-length elist)
```

Sentaurus™ Structure Editor User Guide

<page_number>585</page_number>

S-2021.06

A: Commands

sdegeo:body-trim

# sdegeo:body-trim

Trims the model to the specified box. All parts of the geometric bodies that lie outside of the specified box are removed.

**Syntax**

`(sdegeo:body-trim x0 y0 z0 x1 y1 z1)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>x0</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y0</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z0</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>x1</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y1</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z1</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

**Returns**

None

**Examples**

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0 0 5) (position 10 10 10) "Silicon" "x1")
(sdegeo:create-cuboid (position 0 0 10) (position 10 10 11) "PolySilicon" "x2")
(sdegeo:create-cuboid (position 2 2 11) (position 8 8 14) "Copper" "x3")
(sdegeo:create-cylinder (position 5 5 14) (position 5 5 18) 3 "Silver" "x4")
(sdegeo:body-trim 5 5 5 20 20 20)
```

<page_number>

586
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sdegeo:bool-intersect

# sdegeo:bool-intersect

Performs a Boolean intersection operation.

## Syntax

`(sdegeo:bool-intersect body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY | BOOLEAN`

## Description

This Scheme extension intersects the first body from the specified body list with the rest of the bodies from the list. The resulting body inherits the DATEX material attribute from the first body. Similarly, the region-name attribute is inherited from the first entity in the body list.

This Scheme extension applies to both 2D and 3D bodies.

If the specified `body-list` contains empty bodies, the Scheme extension returns `#f`.

If the result of the Boolean operation is an empty body, the empty body is removed from the entity list, and `#t` is returned.

## Examples

```scheme
(sde:clear)
(sdegeo:set-default-boolean "XX")
(define b1 (sdegeo:create-rectangle (position 0 0 0) (position 10 10 0)
  "Silicon" "region_1"))
(define b2 (sdegeo:create-rectangle (position 5 5 0) (position 12 12 0)
  "PolySilicon" "region_2"))
(sdegeo:bool-intersect (list b2 b1))
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>587</page_number>

A: Commands
sdegeo:bool-subtract

# sdegeo:bool-subtract

Performs a Boolean subtraction operation.

## Syntax

`(sdegeo:bool-subtract body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY | BOOLEAN`

## Description

This Scheme extension subtracts the first body from the specified body list with the rest of the bodies from the list. The resulting body inherits the DATEX material attribute of the first body. Similarly, the region-name attribute is inherited from the first entity in the body list.

This Scheme extension applies to both 2D and 3D bodies.

If the specified `body-list` contains empty bodies, the Scheme extension returns #f.

If the result of the Boolean operation is an empty body, the empty body is removed from the entity list, and #t is returned.

## Examples

```scheme
(sde:clear)
(sdegeo:set-default-boolean "XX")
(define b1 (sdegeo:create-rectangle (position 0 0 0) (position 10 10 0)
  "Silicon" "region_1"))
(define b2 (sdegeo:create-rectangle (position 5 5 0) (position 12 12 0)
  "Silicon" "region_2"))
(sdegeo:bool-subtract (list b2 b1))
```

<page_number>588</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:bool-unite

# sdegeo:bool-unite

Unites the specified bodies.

## Syntax

`(sdegeo:bool-unite body-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY | BOOLEAN`

## Description

This Scheme extension performs a Boolean unite operation on the specified body list. The newly ‘united’ body inherits the DATEX material attribute of the first body from the specified list of bodies. Similarly, the region-name attribute is inherited from the first entity in the body list.

This Scheme extension applies to both 2D and 3D bodies.

If the specified `body-list` contains empty bodies, the Scheme extension returns #f.

If the result of the Boolean operation is an empty body, the empty body is removed from the entity list, and #t is returned.

## Examples

```scheme
(sde:clear)
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-rectangle (position -10 -8 0) (position -5 -3 0) "Silicon"
    "region_1")
(sdegeo:create-rectangle (position -6 -7 0) (position 1 -4 0) "Silicon"
    "region_2")
(sdegeo:create-rectangle (position -1 -9 0) (position 3 -3 0) "PolySilicon"
    "region_3")
(sdegeo:create-polygon (list (position 1 -7 0) (position 5 -9 0)
    (position 10 -9 0) (position 11 -4 0) (position 3 -1 0) (position 1 -7 0))
    "Silver" "region_4")
(sdegeo:bool-unite (get-body-list))
```

Sentaurus™ Structure Editor User Guide <page_number>589</page_number>
S-2021.06

A: Commands

sdegeo:break-nearly-axis-aligned-edges

# sdegeo:break-nearly-axis-aligned-edges

Breaks nearly axis-aligned linear edges into horizontal or vertical components.

## Syntax

`(sdegeo:break-nearly-axis-aligned-edges edge-list [angular-tolerance])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge-list</td>
        <td>EDGE LIST</td>
    </tr>
    <tr>
        <td>angular-tolerance</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension changes the nearly axis-aligned edges to axis-aligned edges by inserting additional vertices and staircase edges to the model. This step might be needed before meshing because some meshing algorithms (typically, quadtree-based meshing engines) might have difficulties handling nearly axis-aligned edges.

The optional argument `angular-tolerance` specifies the minimal angle in degrees that is permitted between model edges and between the x-axis and y-axis of the model. If the angle between the edge and the horizontal and vertical direction is smaller than `angular-tolerance`, the edge will be split into a horizontal and vertical component. If `angular-tolerance` is not specified, the default value (5°) is used.

## Limitations

This Scheme extension applies to 2D models only.

<page_number>

590
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:chamfer

# sdegeo:chamfer

Performs a 3D edge or vertex chamfering operation.

## Syntax

`(sdegeo:chamfer edge | vertex-list chamfer-dist [adaptive-chamfering])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge | vertex-list</td>
        <td>EDGE LIST | VERTEX LIST</td>
    </tr>
    <tr>
        <td>chamfer-dist</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>adaptive-chamfering</td>
        <td>BOOLEAN (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension performs edge or vertex chamferings for 3D bodies.

The edge | vertex-list contains a list of edges or vertices to be chamfered. The argument chamfer-dist is the chamfering distance used for the operation.

The GUI can be used to select the edges to be operated on, or some other method can be used to find the edge entity IDs. For example, `find-edge-id` can be used to find the edge IDs.

Chamfering is a complex operation and can fail for several reasons. A common problem is the use of an incorrect chamfer distance, which is usually too large. The chamfer distance must be selected so that the resulting model (after performing the chamfering operation) is physically (topologically) correct. Another typical problem is the incorrect selection of the edges to be chamfered. The edge | vertex-list must contain all tangent continuous edges; otherwise, the operation might fail.

Chamfering changes the model topology; new faces (and edges) are created, and old faces (edges) are removed from the model. When chamfering is performed in several steps, the order of performing the `sdegeo:chamfer` operation can be important.

If a vertex list is specified in edge | vertex-list, all the edges that are connected in the specified vertices will be chamfered.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>591</page_number>

# A: Commands

sdegeo:chamfer

The optional adaptive-chamfering Boolean argument can be used to perform adaptive chamfering. If this option is used and the argument is set to #t, then if the chamfering operation fails using the original chamfer-dist value, the operation is repeated with a sequence of chamfering operations, using an adaptive approach, to set the chamfer distance to smaller values until the operation succeeds.

**Examples**

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0 0 0) (position 10 10 10) "Silver" "region_1")
(define edge1 (find-edge-id (position 5 0 0)))
(sdegeo:chamfer edge1 2)
(define face1 (find-face-id (position 5 5 10)))
(sdegeo:chamfer (entity:edges face1) 1)
(define face1 (find-face-id (position 5 0 5)))
(sdegeo:chamfer (entity:edges face1) 3)
```

<page_number>592</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdegeo:chamfer-2d

# sdegeo:chamfer-2d

Performs a 2D vertex chamfering operation.

## Syntax

`(sdegeo:chamfer-2d vertex(s) chamfer-dist)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex(s)</td>
        <td>VERTEX | VERTEX LIST</td>
    </tr>
    <tr>
        <td>chamfer-dist</td>
        <td>REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension performs a chamfering operation on a specified vertex or list of vertices. When you use the GUI, this operation is applied to the selected entities. (`(sde:selected-entities)` returns the selected entity list.) (Choose **Edit > Edit 2D > Chamfer**.)

**NOTE** When the chamfering is to be performed on a vertex (or vertices) that is shared by neighboring regions, all vertices must be added to the argument list.

## Limitations

The chamfering distance, `chamfer-dist`, must be selected so that the operation does not result in an invalid geometry.

## Examples

```scheme
(sdegeo:create-rectangle (position 0 0 0) (position 10 10 0) "Silicon"
  "region_1")
(define mybody (car (reverse (part:entities))))
(define myvertices (entity:vertices mybody))
(sdegeo:chamfer-2d (list (list-ref myvertices 0) (list-ref myvertices 1)) 3)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>593</page_number>

A: Commands
sdegeo:check-overlap

# sdegeo:check-overlap

Performs an overlap check between bodies.

## Syntax

`(sdegeo:check-overlap body-list [use-bbox-check])`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body-list</td>
        <td>BODY LIST</td>
    </tr>
    <tr>
        <td>use-bbox-check</td>
        <td>BOOLEAN (default is #t)</td>
    </tr>
  </tbody>
</table>

## Returns

BODY LIST

## Description

This Scheme extension checks for possible overlaps between geometric bodies. The argument is a body list. If the body list is specified by using the `(get-body-list)` command, the entire model is checked for overlaps. The default overlap check looks only for a possible bounding box overlap. This operation is very fast but can report false overlaps. To provide a more reliable result, the optional `use-bbox-check` argument must be set to `#f`.

If no overlap is found, the Scheme extension returns null (an empty list). If overlaps are found, it returns a list with all overlapping body pairs. If overlaps are found, these overlaps must be removed manually before the tessellated boundary output is generated; otherwise, meshing will not work correctly.

This Scheme extension applies to both 2D and 3D models.

**NOTE** The argument list should contain only geometric bodies. The DRS entities (Ref/Eval windows) are ignored, since Ref/Eval windows can overlap. Existing overlaps are not reported for these entities.

<page_number>

594
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:chop-domain

# sdegeo:chop-domain

Performs a 3D domain boundary cut.

## Syntax

`(sdegeo:chop-domain point-pairs)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>point-pairs</td>
        <td>REAL REAL</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

If the base of the device is placed at the xy plane, then the device can be cut off to cover only the specified polygonal base. The argument is a list of x, y point pairs.

## Limitations

The device must be placed at the –y-plane, and the cut is performed in the z-direction.

## Examples

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0 0 5) (position 10 10 10) "Silicon" "x1")
(sdegeo:create-cuboid (position 0 0 10) (position 10 10 11) "PolySilicon" "x2")
(sdegeo:create-cuboid (position 2 2 11) (position 8 8 14) "Copper" "x3")
(sdegeo:create-cylinder (position 5 5 14) (position 5 5 18) 3 "Silver" "x4")
(sdegeo:chop-domain (list 0 0 2 2 6 0 10 4 3 10 0 4))
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>595</page_number>

A: Commands
sdegeo:chull2d

# sdegeo:chull2d

Computes the 2D convex hull of the specified points (position list).

## Syntax

`(sdegeo:chull2d position-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position-list</td>
        <td>POSITION LIST</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION LIST

## Description

This Scheme extension computes the 2D convex hull of the specified position list. The 2D convex hull is returned in a POSITION LIST.

## Limitations

The input position list must be defined at the xy plane, and the z-coordinate must be 0.

## Examples

```scheme
(sde:clear)
(define pl1 (list
  (position 8 4 0) (position 0 0 0) (position 5 -4 0) (position 7 -1 0)
  (position 10 0 0) (position 10 5 0) (position 2 1 0) (position 4 1 0)
  (position 4 3 0) (position 8 3 0) (position 9 4 0) (position 9 3 0)
  (position 8.5 3.5 0) (position 2 3 0) (position 0 5 0) (position 5 -2 0)))
(sdegeo:create-polygon (sdegeo:chull2d pl1) "Silicon" "xx")
```

<page_number>596</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdegeo:contact-sets

# sdegeo:contact-sets

Returns the names of all the defined contact sets.

## Syntax

```scheme
(sdegeo:contact-sets)
```

## Returns

A Scheme list that contains the names of the defined contact sets

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

597
</page_number>

A: Commands

sdegeo:create-circle

# sdegeo:create-circle

Creates a 2D circular region.

## Syntax

```scheme
(sdegeo:create-circle center-pos radius region-material region-name
 [start-angle end-angle])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>center-pos</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>start-angle</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>end-angle</td>
        <td>REAL (optional)</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY (BODY)`

## Description

This Scheme extension adds a 2D circular region to the model. The circle is defined by specifying the center position and the radius. If the generated polygon overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted region and the overlapping regions. The material attribute is set to region-material and the region attribute is set to region-name.

When the optional arguments start-angle and end-angle are specified, a circular arch is generated.

## Examples

```scheme
; Scheme Extension
(sdegeo:create-circle (position 0 0 0) 10 "Silicon" "Region_1")
```

<page_number>598</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdegeo:create-cone

# sdegeo:create-cone

Creates a circular cone.

## Syntax

```
(sdegeo:create-cone {{start-axis end-axis} | {start-axis-x start-axis-y
    start-axis-z end-axis-x end-axis-y end-axis-z}} base-radius top-radius
    [ratio=1 [position3 | {x3 y3 z3}]] region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>start-axis</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>end-axis</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>start-axis-x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>start-axis-y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>start-axis-z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>end-axis-x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>end-axis-y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>end-axis-z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>base-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>top-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>ratio</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>position3</td>
        <td>POSITION (optional)</td>
    </tr>
    <tr>
        <td>x3</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>y3</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>z3</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

Sentaurus™ Structure Editor User Guide <page_number>599</page_number>
S-2021.06

**A: Commands**

sdegeo:create-cone

## Description

The argument `start-axis` specifies the start axis position or base of the cone. The argument `end-axis` specifies the end axis position or top of the cone. Two syntax formats are available for defining these positional arguments:

*   The first (original) syntax format defines all positional arguments by placing them in ‘position’ statements enclosed in parentheses.

*   The second syntax format defines positional arguments without using the ‘position’ statement or the additional set of parentheses.

Otherwise, the two formats are identical. The format selected must be used for all three positional arguments.

The argument `base-radius` specifies the radius at `start-axis` (must be greater than zero). The argument `top-radius` specifies the radius at `end-axis` (which can be zero).

If the optional arguments `ratio` and `position3` are specified, an elliptical cone is created. If `ratio` is specified, the ratio between the major and minor axes of the ellipse is used.

If `position3` (or `x3`, `y3`, and `z3`) is specified, the vector from the projection of `position3` (or `x3`, `y3`, and `z3`) onto the axis of the cone to `position3` (or `x3`, `y3`, and `z3`) specifies the major axis. If `position3` (or `x3`, `y3`, and `z3`) is not specified, the major axis is defined by the projection of the x-axis of the active coordinate system onto the plane that is defined by `start-axis` and the vector from `start-axis` to `end-axis`.

> **NOTE** The argument `position3` cannot lie on the axis of the cone; otherwise, an error occurs.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

## Examples

```scheme
(sdegeo:create-cone (position -20 -5 -9) (position 15 20 10) 10 2 "Gold" "")
(sdegeo:create-cone -20 -5 -9 5 15 7.5 10 2 3 "Silver" "")
(sdegeo:create-cone -2 -5 -9 15 20 10 10 2 3 17 22 12 "Copper" "")
```

<page_number>600</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:create-cuboid

# sdegeo:create-cuboid

Creates a solid block.

## Syntax

`(sdegeo:create-cuboid diagonal1 diagonal2 region-material region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>diagonal1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>diagonal2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY (BODY)`

## Description

The argument `diagonal1` specifies the first diagonal corner and `diagonal2` specifies the second diagonal corner. The block is oriented with respect to the current work plane. If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

## Examples

```
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1)
  (sde:get-default-material) "r1")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>601</page_number>

**A: Commands**

sdegeo:create-cylinder

---

# sdegeo:create-cylinder

Creates a cylinder.

## Syntax

```
(sdegeo:create-cylinder {{start-pos end-pos} | {x-start y-start z-start
    x-end y-end z-end}} radius [ratio=1 {position3 | {x3 y3 z3}}]
    region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>start-pos</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>end-pos</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>x-start</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y-start</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z-start</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>x-end</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>y-end</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>z-end</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>ratio</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>position3</td>
        <td>POSITION (optional)</td>
    </tr>
    <tr>
        <td>x3</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>y3</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>z3</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

<page_number>602</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:create-cylinder

## Description

The argument `start-pos` (or `x-start`, `y-start`, and `z-start`) specifies the start position of the cylinder. The argument `end-pos` (or `x-end`, `y-end`, and `z-end`) specifies the end position of the cylinder. Two syntax formats are available for defining the start and end positions for creating a cylinder:

*   The first (original) syntax format defines the positional arguments by placing them in ‘position’ statements enclosed in parentheses.

*   The second syntax format defines the positional arguments without using the ‘position’ statement or the additional set of parentheses.

Otherwise, the two formats are identical. The format selected must be used for all three positional arguments.

The argument `radius` specifies the radii for the base and top. If the optional arguments `ratio` and `position3` (or `x3`, `y3`, and `z3`) are specified, an elliptical cylinder is created. If `ratio` is specified, the ratio between the major and minor axes of the ellipse is used.

If `position3` (or `x3`, `y3`, and `z3`) is specified, the vector from the projection of `position3` (or `x3`, `y3`, and `z3`) on to the axis of the cylinder to `position3` (or `x3`, `y3`, and `z3`) specifies the major axis. If `position3` (or `x3`, `y3`, and `z3`) is not specified, the major axis is defined by the projection of the x-axis of the active coordinate system onto the plane that is defined by `position1` and the vector from `position1` to `position2`.

> **NOTE** The argument `position3` cannot lie on the axis of the cylinder; otherwise, an error occurs.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

## Examples

```
(sde:clear)
(sdegeo:create-cylinder (position 0 0 0) (position 25 25 0) 30 "Gold" "")
(sdegeo:create-cylinder 2 2 2 -20 -20 0 15 3 "Gold" "")
(sdegeo:create-cylinder 2 2 2 -20 -20 0 15 3 -5 -5 0 "Gold" "")
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>603</page_number>

**A: Commands**
sdegeo:create-ellipse

---

# sdegeo:create-ellipse

Creates a 2D ellipse.

## Syntax

(sdegeo:create-ellipse position1 position2 ratio lmat lreg)

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>ratio</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>lmat</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>lreg</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

```
ENTITY (BODY)
```

## Description

This Scheme extension creates a 2D elliptical region (ellipse). The first argument `position1` is the center position of the ellipse, and `position2` is the endpoint of the major axis. The argument `ratio` is the ratio of the major and minor axes. (The `ratio` value can be greater than 1, in which case, the minor axis becomes the major axis.) The argument `lmat` is the DATEX material and `lreg` is the region name.

The Scheme extension generates the ellipse on the active work plane, using the active coordinate system. The default Boolean setting is respected by the Scheme extension.

## Examples

```scheme
; Scheme Extension
(sde:clear)
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-ellipse (position 0 0 0) (position 10 0 0) 0.5 "PolySi" "x1")
(sdegeo:create-ellipse (position 0 0 0) (position 3 0 0) 3 "Silver" "x2")
(sdegeo:create-ellipse (position 0 0 0) (position 8 8 0) 0.2 "Oxide" "x3")
```

<page_number>604</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:create-ellipsoid

# sdegeo:create-ellipsoid

Creates a 3D ellipsoid.

## Syntax

`(sdegeo:create-ellipsoid position1 position2 ratio lmat lreg)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>ratio</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>lmat</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>lreg</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY (BODY)`

## Description

The first argument `position1` is the center position of the ellipse, and `position2` is the endpoint of the major axis. The argument `ratio` is the ratio of the major and minor axes. (The ratio value can be greater than 1, in which case, the minor axis becomes the major axis.) The argument `lmat` is the DATEX material and `lreg` is the region name.

The Scheme extension generates the ellipse on the active work plane, using the active coordinate system. The default Boolean setting is respected by the Scheme extension.

## Examples

```
(sde:clear)
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-ellipsoid (position 0 0 0) (position 10 0 0) 0.5 "PolySi" "x1")
(sdegeo:create-ellipsoid (position 0 0 0) (position 3 0 0) 3 "Silver" "x2")
(sdegeo:create-ellipsoid (position 0 0 0) (position 8 8 0) 0.2 "Oxide" "x3")
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>605</page_number>

A: Commands
sdegeo:create-ellipsoid-d

# sdegeo:create-ellipsoid-d

Creates a polyhedral ellipsoid with triangular faces.

## Syntax

`(sdegeo:create-ellipsoid-d position1 position2 ratio lmat lreg nseg1 nseg2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>ratio</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>lmat</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>lreg</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>nseg1</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>nseg2</td>
        <td>INTEGER</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY (BODY)`

## Description

The first argument `position1` is the center position of the ellipse, and `position2` is the endpoint of the major axis. The argument `ratio` is the ratio of the major and minor axes. (The ratio value can be greater than 1, in which case, the minor axis becomes the major axis.) The argument `lmat` is the DATEX material and `lreg` is the region name. The `nseg1` argument is the number of segments (planar faces) along the major axis and `nseg2` is the number of segments about the major axis.

The Scheme extension generates the triangulated ellipsoid on the active work plane, using the active coordinate system. The default Boolean setting is respected by the Scheme extension.

## Examples

```scheme
(sde:clear)
(sdegeo:create-ellipsoid-d (position 0 0 0) (position 10 0 0) 0.25
  "Silicon" "xx" 10 20)
```

<page_number>606</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:create-linear-edge

# sdegeo:create-linear-edge

Creates a linear edge.

## Syntax

`(sdegeo:create-linear-edge position1 position2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>position1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>position2</td>
        <td>POSITION</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (EDGE)

## Description

The arguments `position1` and `position2` specify the end positions.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

607
</page_number>

A: Commands
sdegeo:create-ot-ellipsoid

# sdegeo:create-ot-ellipsoid

Creates an oriented and truncated (ot) ellipsoid.

## Syntax

```
(sdegeo:create-ot-ellipsoid center-position major-axis-position ratio
    truncate-angle-1 truncate-angle-2 region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>center-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>major-axis-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>ratio</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>truncate-angle-1</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>truncate-angle-2</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

The `center-position` argument specifies the center position of the ellipsoid. The argument `major-axis-position` specifies the endpoint of the major axis of the untruncated ellipsoid. The argument `ratio` is the ratio of the major and minor axes. The `truncate-angle-1` and `truncate-angle-2` arguments determine the cut-off angles where the ellipsoidal top and bottom are replaced by a flat top and bottom.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

<page_number>608</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:create-ot-ellipsoid

## Examples

```scheme
(sde:clear)
(define mb
  (sdegeo:create-polygon (list (position 0 3 0) (position 1 3 0)
    (position 2 2 0) (position 3 2 0) (position 4 3 0) (position 5 3 0)
    (position 5 0 0) (position 0 0 0)) "Silicon" "xx"))
(sdegeo:extrude (list mb) 2)
(do ((i 0 (+ i 1))) ((>= i 5))
  (define mf (caar (sdegeo:ray-test mb (ray (position (+ i 0.5) 5 1.0)
    (gvector 0 -1 0)) 0.01)))
  (define mp (cdar (sdegeo:ray-test mb (ray (position (+ i 0.5) 5 1.0)
    (gvector 0 -1 0)) 0.01)))
  (define mn (face:plane-normal mf))
  (define sf 0.5)
  (define mp1 (position (+ (position:x mp) (* sf (gvector:x mn)))
    (+ (position:y mp) (* sf (gvector:y mn)))
    (+ (position:z mp) (* sf (gvector:z mn)))))
  (define sf 1.2)
  (define mp2 (position (+ (position:x mp) (* sf (gvector:x mn)))
    (+ (position:y mp) (* sf (gvector:y mn)))
    (+ (position:z mp) (* sf (gvector:z mn)))))
  (sdegeo:create-ot-ellipsoid mp1 mp2 0.5 20 80 "Gold" "xx")
)
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>609</page_number>

**A: Commands**

sdegeo:create-ot-sphere

# sdegeo:create-ot-sphere

Creates an oriented and truncated (ot) sphere.

## Syntax

```
(sdegeo:create-ot-sphere center-position orientation radius
    truncate-angle-1 truncate-angle-2 region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>center-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>orientation</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>truncate-angle-1</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>truncate-angle-2</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

The `center-position` argument specifies the center position of the sphere.

The `orientation` vector specifies the normal vector of the truncated top and bottom. The sphere is oriented in such a way that the poles of the sphere are placed in the orientation direction. The argument `radius` determines the size of the sphere. The `truncate-angle-1` and `truncate-angle-2` arguments determine the cut-off angle where the spherical top and bottom are replaced by a flat top and bottom.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

<page_number>610</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**
sdegeo:create-ot-sphere

# Examples

```scheme
(sde:clear)
(sdegeo:create-ot-sphere (position 0 0 0) (gvector 1 0 0) 1 65 65 "Silicon"
  "x1")
(sdegeo:create-ot-sphere (position 0 0 3) (gvector 1 1 0) 1 50 50
  "PolySilicon" "x2")
(sdegeo:create-ot-sphere (position 0 0 6) (gvector 0 1 0) 1 40 40 "Copper"
  "x3")
(sdegeo:create-ot-sphere (position 0 0 9) (gvector -1 1 0) 1 30 30 "Oxide"
  "x4")
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

611
</page_number>

A: Commands
sdegeo:create-polygon

# sdegeo:create-polygon

Creates a 2D polygonal region.

## Syntax

`(sdegeo:create-polygon vertex-list region-material region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>POSITION LIST</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

This Scheme extension adds a closed 2D polygonal region to the model. The polygon is defined by specifying the vertex list of the polygon (either closed or not closed). If the last vertex is different from the first vertex, the first vertex closes the polygon. If the generated polygon overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted region and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

<page_number>612</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:create-polyline-wire

# sdegeo:create-polyline-wire

Creates a polyline wire.

## Syntax

`(sdegeo:create-polyline-wire vertex-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>POSITION LIST</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

This Scheme extension defines a wire body consisting of linear edges only. The vertex positions of the wire are specified in the argument list as a position list. The wire body does not have an attached material or region-name attribute and is not written to the output boundary file. The wire body can be used, for example, during a sweep operation when the sweep along a wire option is used.

Sentaurus™ Structure Editor User Guide

<page_number>613</page_number>

S-2021.06

A: Commands

sdegeo:create-prism

# sdegeo:create-prism

Creates a solid prism.

## Syntax

```scheme
(sdegeo:create-prism centerposition height major-radius minor-radius nsides
                     region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>centerposition</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>height</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>major-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>minor-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>nsides</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

This Scheme extension creates an `nsides`-sided prism where `n` is greater than or equal to three. The prism is centered about the center position with its height along the z-axis, the major-radius along the x-axis, and the minor-radius along the y-axis. If `height` is zero, the resulting body consists of only one polygonal-sided sheet face, lying in the xy plane.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

## Examples

```scheme
(sdegeo:create-prism (position 0 0 0) 20 40 40 6 "PolySilicon" "")
```

<page_number>

614
</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

A: Commands
sdegeo:create-pyramid

# sdegeo:create-pyramid

Creates a solid pyramid.

## Syntax

```
(sdegeo:create-pyramid centerposition height major-radius minor-radius nsides
    top region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>centerposition</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>height</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>major-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>minor-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>nsides</td>
        <td>INTEGER</td>
    </tr>
    <tr>
        <td>top</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

The number of sides (`nsides`) must be greater than or equal to three. The pyramid is centered about the origin:

*   If the up direction is set to "-x" (UCS), then its `height` is along the x-axis, the `major-radius` is along the z-axis, and the `minor-radius` is along the y-axis.

*   If the up direction is set to "+z", then its `height` is along the z-axis, the `major-radius` is along the x-axis, and the `minor-radius` is along the y-axis.

The argument `top` specifies the major axis length at the top of the pyramid. If `height` is zero, then the resulting body consists of only one polygonal-sided sheet face, lying in the xy plane.

If the generated body overlaps already existing regions, then the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

615
</page_number>

**A: Commands**

sdegeo:create-pyramid

### Examples

```scheme
(sde:clear)
(sde:set-process-up-direction "+z")
(sdegeo:create-pyramid (position 0 0 0) 20 40 40 6 12 "PolySilicon" "region_1")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-pyramid (position 0 0 0) 30 30 20 5 5 "Gold" "region_2")

(sde:clear)
(sde:set-process-up-direction "-x")
(sdegeo:create-pyramid (position 0 0 0) 20 40 40 6 12 "PolySilicon" "region_1")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-pyramid (position 0 0 0) 30 30 20 5 5 "Gold" "region_2")
```

<page_number>616</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:create-rectangle

# sdegeo:create-rectangle

Creates a 2D rectangular region.

## Syntax

`(sdegeo:create-rectangle v1 v2 material-name region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>v1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>v2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>material-name</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY (BODY)`

## Description

This Scheme extension adds a 2D rectangle to the model. The rectangle is defined by specifying two opposite corner vertices.

If the generated rectangle overlaps with already existing regions, the default Boolean behavior determines the topology of the newly inserted region and the overlapping regions. The material attribute is set to region-material and the region attribute is set to region-name.

## Examples

```scheme
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0))
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon" "sir")
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

617
</page_number>

A: Commands

sdegeo:create-reg-polygon

# sdegeo:create-reg-polygon

Creates a 2D regular polygonal region.

## Syntax

```scheme
(sdegeo:create-reg-polygon v1 rad [nsides] [angle] region-material
        region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>v1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>rad</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>nsides</td>
        <td>INTEGER (optional)</td>
    </tr>
    <tr>
        <td>angle</td>
        <td>REAL (optional)</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

This Scheme extension adds a regular 2D polygonal region to the model. The regular polygon is defined by specifying the center position of the polygon, the radius, and the number of segments.

If the generated polygon overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted region and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

The following arguments must be specified:

* v1: Center of the regular polygon.

* rad: Radius of the circle that defines the vertex points.

The following arguments are optional:

* nsides: Number of sides.

* angle: Angle [degree], counterclockwise from the x-axis, which defines the ‘rotation’ of the regular polygon.

<page_number>618</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sdegeo:create-ruled-region

### Examples

```scheme
; Scheme Extension
(sdegeo:create-reg-polygon (position 0 0 0) 1 10 0 "Silicon" "region_1")
```

# sdegeo:create-ruled-region

Creates a 2D ruled region.

### Syntax

`(sdegeo:create-ruled-region edge1 edge2 region-material region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge1</td>
        <td>EDGE</td>
    </tr>
    <tr>
        <td>edge2</td>
        <td>EDGE</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

### Returns

ENTITY (BODY)

### Description

This Scheme extension adds a 2D ruled region to the model. The ruled region is defined by specifying two existing edges. Edge orientation is not important, since the ruled region is always created in such a way that a simply connected region is created. The selected edges cannot intersect each other.

If the ruled region overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted region and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

Sentaurus™ Structure Editor User Guide

<page_number>619</page_number>

S-2021.06

A: Commands
sdegeo:create-sphere

# sdegeo:create-sphere

Creates a sphere that is centered at a specified position.

**Syntax**

```scheme
(sdegeo:create-sphere {center-position | {center-x center-y center-z}}
 radius region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>center-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>center-x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>center-y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>center-z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

**Returns**

ENTITY (BODY)

**Description**

The argument `center-position` specifies the center position of the sphere. Two syntax formats are available for defining `center-position`:

*   The first (original) syntax format defines the `center-position` by placing the xyz coordinates in a ‘position’ statement enclosed in parentheses (as shown in the example creating sphere1).

*   The second syntax format defines the center position xyz coordinates without using the ‘position’ statement or the additional set of parentheses (as shown in the example defining sphere2 and sphere3).

Otherwise, the two formats are identical.

The argument `radius` determines the size of the sphere.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

<page_number>620</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:create-spline-wire

### Examples

```scheme
(sde:clear)
(define sphere1 (sdegeo:create-sphere (position -4 -4 0) 1.5 "Gold" ""))
(define sphere2 (sdegeo:create-sphere -30 0 0 15 "Silver" ""))
(define sphere3 (sdegeo:create-sphere 10 10 10 5 "Copper" ""))
```

# sdegeo:create-spline-wire

Creates a spline wire.

### Syntax

`(sdegeo:create-spline-wire vertex-list)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>vertex-list</td>
        <td>POSITION LIST</td>
    </tr>
  </tbody>
</table>

### Returns

ENTITY (BODY)

### Description

This Scheme extension defines a spline wire body. The vertex positions of the wire are specified in the argument list as a position list. The wire body does not have an attached material or region-name attribute, and is not written to the output boundary file. The wire body can be used, for example, during a sweep operation when the sweep along a wire option is used.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>621</page_number>

A: Commands
sdegeo:create-torus

# sdegeo:create-torus

Creates a solid torus.

## Syntax

```scheme
(sdegeo:create-torus {center-position | {center-x center-y center-z}}
 major-radius minor-radius region-material region-name)
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>center-position</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>center-x</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>center-y</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>center-z</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>major-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>minor-radius</td>
        <td>REAL</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

ENTITY (BODY)

## Description

This Scheme extension creates a solid torus of given radii centered at the origin. The torus is defined in the xy plane of the active coordinate system and is oriented using the normal gvector of the active coordinate system.

The argument `center-position` specifies the center location of the torus. Two syntax formats are available for this argument:

*   The first (original) syntax format defines `center-position` by placing it in a ‘position’ statement enclosed in parentheses.

*   The second format defines the xyz coordinates of the center position without using the ‘position’ statement or the additional set of parentheses.

Otherwise, the two formats are identical.

The argument `major-radius` specifies the distance from the center to the spine curve lying in this plane. It is specified around a circle having the minor axis and is swept to define the torus.

<page_number>622</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**A: Commands**

sdegeo:create-torus

Three shapes of tori can be specified (donut, apple, or lemon) depending on the relative magnitudes of the major and minor radii:

*   If `major-radius` is greater than `minor-radius`, the torus is a donut.

*   If `major-radius` is positive, but smaller than `minor-radius`, the torus is an apple.

*   If `major-radius` is negative, the torus is a lemon.

If the generated body overlaps already existing regions, the default Boolean behavior determines the topology of the newly inserted body and the overlapping regions. The material attribute is set to `region-material` and the region attribute is set to `region-name`.

## Examples

```
(sde:clear)
(sdegeo:create-torus (position -10 -5 -10) 7 3 "Gold" "")
(sdegeo:create-torus 10 15 20 10 5 "Gold" "")
```

Sentaurus™ Structure Editor User Guide

<page_number>623</page_number>

S-2021.06

A: Commands
sdegeo:create-triangle

# sdegeo:create-triangle

Creates a 2D triangular region.

## Syntax

`(sdegeo:create-triangle v1 v2 v3 region-material region-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>v1</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>v2</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>v3</td>
        <td>POSITION</td>
    </tr>
    <tr>
        <td>region-material</td>
        <td>DATEXMAT</td>
    </tr>
    <tr>
        <td>region-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

`ENTITY (BODY)`

## Description

This Scheme extension adds a 2D triangle to the model. The triangle is defined by specifying three vertices.

If the generated triangle overlaps with existing regions, the default Boolean behavior determines the topology of the newly inserted region and the overlapping regions. The material attribute is set to region-material and the region attribute is set to region-name.

## Examples

```scheme
(sdegeo:create-triangle (position 0 0 0) (position 1 0 0) (position 0.5 1 0)
    "Silicon" "sir")
```

<page_number>624</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands

sdegeo:curve-intersect

# sdegeo:curve-intersect

Returns the intersection positions between the specified curves.

## Syntax

`(sdegeo:curve-intersect edge1 edge2)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>edge1</td>
        <td>EDGE</td>
    </tr>
    <tr>
        <td>edge2</td>
        <td>EDGE</td>
    </tr>
  </tbody>
</table>

## Returns

POSITION LIST

## Examples

```scheme
(define e1 (edge:linear (position 0 0 0) (position 10 10 0)))
(define e2 (edge:linear (position 0 10 0) (position 10 0 0)))
(sdegeo:curve-intersect e1 e2)
; (#[position 5 5 0])
(define e3 (edge:circular (position 5 5 0) 3))
(sdegeo:curve-intersect e1 e3)
; (#[position 7.12132034355964 7.12132034355964 0]
#[position 2.87867965644036 2.87867965644036 0])
```

Sentaurus™ Structure Editor User Guide

<page_number>625</page_number>

S-2021.06

**A: Commands**
sdegeo:define-3d-contact-by-polygon

# sdegeo:define-3d-contact-by-polygon

Defines a 3D face contact by a polygon.

## Syntax

`(sdegeo:define-3d-contact-by-polygon pos-list dir-vector contact-name)`

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>pos-list</td>
        <td>POSITION LIST</td>
    </tr>
    <tr>
        <td>dir-vector</td>
        <td>GVECTOR</td>
    </tr>
    <tr>
        <td>contact-name</td>
        <td>STRING</td>
    </tr>
  </tbody>
</table>

## Returns

None

## Description

This Scheme extension imprints a general polygon wire to an existing body. The imprinted wire splits the faces of the body. This Scheme extension can be used to define a polygonal contact area. The imprint functions split faces to surface patches. After the face split, the newly created face segments to be marked as contacts must be identified. During the assignment of contacts, these face ID numbers can be used explicitly. The argument `pos-list` contains the vertices of the imprinted polygon. The polygon must be closed to imprint it, so the first position must be repeated as the last position.

The argument `dir-vector` specifies the direction in which the polygon is projected for the imprint step. The argument `contact-name` specifies the name of the contact set.

## Examples

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0 0 0) (position 10 10 10) "Silicon"
  "region_1")
(sdegeo:define-contact-set "demo" 4 (color:rgb 1 0 0) "##")
(sdegeo:set-current-contact-set "demo")
(sdegeo:define-3d-contact-by-polygon (list (position 1 1 10) (position 5 1 10)
  (position 5 5 10) (position 3 2 10) (position 1 5 10) (position 1 1 10))
  (gvector 0 0 -1) "demo")
```

<page_number>626</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

A: Commands
sdegeo:define-contact-set

# sdegeo:define-contact-set

Defines a contact set name and initializes the supporting data.

## Syntax

```
(sdegeo:define-contact-set name [edgeThickness Color] | [Color facePattern])
```

<table>
  <thead>
    <tr>
        <th>Argument</th>
        <th>Argument type</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>name</td>
        <td>STRING</td>
    </tr>
    <tr>
        <td>edgeThickness</td>
        <td>INTEGER (optional) (default is 4.0)</td>
    </tr>
    <tr>
        <td>Color</td>
        <td>COLOR (optional) Default is (color:rgb 1.0 0.0 0.0)</td>
    </tr>
    <tr>
        <td>facePattern</td>
        <td>STRING (optional) Can be one of:<br/>"solid", "##", "||", "==", "//", "::", "&lt;&gt;&lt;&gt;", "[] []"<br/>(default is "##")</td>
    </tr>
  </tbody>
</table>

## Returns

Unspecified
