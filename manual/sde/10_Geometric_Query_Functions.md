# CHAPTER 10 Geometric Query Functions

*This chapter describes the boundary representation method on which Sentaurus Structure Editor is based and introduces several support functions to query and debug the model.*

## Entity IDs and Attributes

Geometry-related operations in Sentaurus Structure Editor are based on ACIS, which is a boundary representation geometry kernel. Boundary representation uses a complex data structure describing the geometry. The data structure of a geometric model can be accessed through a topology graph, which contains the building entities (such as edges, faces, and shells) of the device, and shows the relationships and connections between these entities. A typical 3D body is described with respect to a lump list (disjoint parts of the body). Each lump contains a shell list and each shell is described with respect to a face list. Each 3D body is composed of faces. A shell is a connected face list. For example, a cube is defined with respect to six planar faces, and the six faces define one shell. Similarly, a cube with an internal void is composed of two shells and each shell is defined by a face list.

Faces are described with respect to a loop and an edge list. A face is described with respect to its boundary edges. For example, a rectangle is defined by four linear edges. A circular sheet body is defined by a circular edge. A connected edge list is called a *loop*. Simply connected faces have one loop. Faces with internal holes have multiple loops. For example, a circular sheet with an internal rectangular hole is composed of two loops. The outer loop contains one circular edge, while the internal loop contains four linear edges. A linear edge is defined by two vertices.

It is usually not necessary to consider the topological representation of defined bodies when using typical GUI operations or the Scheme interface. For certain geometric operations, however, for example, rounding a set of edges of a 3D body, it is necessary to refer to entities from the underlying topology representation. These edges must be identified by using either the GUI or Scheme interface.

Each generated device is a collection of several different bodies. In two dimensions, these bodies are solid bodies with zero volume (*non-manifold solid bodies*). In three dimensions, these bodies have a finite, positive volume (*manifold solid bodies*). When the geometric model is generated using either the GUI actions or `sdegeo` Scheme functions, Sentaurus Structure Editor assigns several different attributes to these bodies. Two important attributes are the ‘material’ attribute and the ‘region’ attribute.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>275</page_number>

10: Geometric Query Functions
Topological Entity Types

An attribute is a general-purpose data entity that attaches to other entities to record user-defined or some other (internal) information. Attribute objects are saved and restored as part of the model when the model is saved in the native ACIS .sat or .sab format. If the geometric model is exported to the TDR boundary format, only the TCAD-specific attributes (contacts, and material and region names) are saved to the boundary file.

The material attribute is a DATEX material (one of the materials defined in the `datexcodes.txt` file). The region attribute is a string that identifies a region to which a particular body belongs. Each body within a region must have the same ‘material’ attribute.

The boundary file description contains some other restrictions to the use of the region attribute (that is, disjoint bodies cannot have the same region name). Since Sentaurus Structure Editor can generate bodies with multiple lumps, these lumps are separated automatically when exporting the structure to the boundary file in TDR format. In addition, **Edit > Separate Lumps** or the Scheme extension `sde:separate-lumps` can be used to separate lumps explicitly.

Under typical circumstances, when the automatic region-naming feature is switched on, the geometry generation and editing actions accessible from the GUI ensure that region-naming is consistent with the requirements of the boundary format. When using direct Scheme extensions to generate the geometry, you can generate structures in which the region and material properties of bodies are inconsistent with these additional restrictions imposed by the TDR boundary format. In this case, you must set region names and material properties explicitly to resolve any inconsistencies.

During model generation, the geometry engine assigns a unique entity number to each generated body. When a Scheme function needs an entity ID or a list of entity IDs, refer to these automatically assigned entity IDs.

# Topological Entity Types

The valid entity types are:

* **body**: A body is a topological entity of the highest level. It can be a wire body, solid body, or mixed body. Wire bodies contain wires, coedges, edges, and vertices. Solid bodies contain lumps, shells, subshells, faces, loops, coedges, edges, and vertices. Mixed (solid and wire) bodies contain lumps, shells, subshells, faces, loops, coedges, edges, vertices, and wires. All body objects are saved and restored as a part of the model.

<page_number>276</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

**10: Geometric Query Functions**
Topological Entity Types

edge An edge is a topological entity associated with a curve. It is bound by one or more vertices, and has one vertex at each end. If the reference at one or both ends is `NULL`, the edge is unbound in that direction. Each edge contains a record of its sense (FORWARD or REVERSED) relative to its underlying curve. All edge objects are saved and restored as part of the model.

face A face is a topological entity that represents a portion of a geometric surface. One or more loops of edges bound a face, which can be open or closed. A face with no loops occupies the entire surface, finite or infinite, on which the face lies. Therefore, a face can represent an infinite plane or a complete sphere. Each face records its sense relative to its underlying surface (same sense or opposite sense). All face objects are saved and restored as part of the model.

loop A loop is a topological entity that represents a connected portion of the boundary of a face. Loops can be open or closed. A loop can comprise a group of coedges connected in a branched arrangement or in a simple, open chain. A loop can be a coedge shrunk to a single vertex. All loop objects are saved and restored as a part of the model.

lump A lump is a topological entity that represents a connected 3D (solid) or 2D (sheet) region. A body can contain zero or more lumps. Each lump represents a disjoint set of points. One lump is completely enclosed inside the void of another solid lump. Each lump must have at least one shell. All lump objects are saved and restored as a part of the model.

shell A shell is a topological entity consisting of a set of connected faces. All faces are connected along edges or vertices. A shell represents a sheet region or bounds a solid region or both. A shell that bounds a solid region is entirely peripheral or void or neither. All shell objects are saved and restored as a part of the model.

vertex A vertex is a topological entity representing the end of one or more edges. *Vertex* refers to a point object in space and to the edges that it bounds. Other edges are found by following pointers through coedges. All vertex objects are saved and restored as a part of the model.

wire A wire is a topological entity that is a collection of edges and vertices. Wires typically represent profiles, construction lines, and center lines of swept shapes. Wires can also represent wireframes that form shells when surfaced. All wire objects are saved and restored as a part of the model.

wire body A wire body is a topological entity that is a body consisting of wires (as opposed to lumps). Wire bodies contain wires, loops, coedges, edges, and vertices. All wire-body objects are saved and restored as a part of the model.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>277</page_number>

10: Geometric Query Functions

Selecting Geometric Objects

# Selecting Geometric Objects

This section describes how to select geometric objects.

## Graphic-Supported Object Selection

Several different operations require the identification of geometric objects (entities). Either the GUI or direct Scheme functions can be used to identify entities. The GUI toolbar buttons (the Select button) can be used for interactive entity selection (see Selecting Entities on page 24). The default entity that can be selected is **body**. The selection criteria can be set to a different entity type by right-clicking in the view window and setting the selection to the required type, or by selecting the corresponding level in the Selection Level list.

The corresponding Scheme command is

```
(sde:set-selection-level "body"|"face"|"edge"|"vertex"|"other")
```

The function `(sde:selected-entities)` returns a list of the selected (highlighted) entity IDs. Note that this Scheme function always returns a list, even if only a single entity is selected. For example, this Scheme function can return:

```
(sde:selected-entities) ; -> (#[vertex 8 1])
```

**NOTE** This list contains only a single entry.

Use `(car (sde:selected-entities))` to return only the first (and, here, the only) item on this list:

```
(car (sde:selected-entities)) ; -> #[vertex 8 1]
```

The Topology Browser can also be used to find entity IDs (see Visualizing the Internal Entity Representation on page 38).

## Script-Based Object Selection

To select all geometric bodies in the structures, use the Scheme command:

```
(part:entities (filter:type "solid?"))
```

This function returns refinement/evaluation (Ref/Eval) windows as well. To distinguish between the true geometric bodies and the Ref/Eval windows, use the following Scheme functions.

<page_number>278</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**10: Geometric Query Functions**

Selecting Geometric Objects

For all true geometric bodies, use:

```scheme
(get-body-list)
```

For all Ref/Eval windows, use:

```scheme
(get-drs-list)
```

For example:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1)
  "Silicon" "region_1")
; -> #[body 5 1]
(sdegeo:create-cuboid (position 0.3 -0.2 0.0) (position 0.7 0.0 1)
  "SiO2" "region_2")
; -> #[body 6 1]
(sdedr:define-refeval-window "RefEvalWin_1" "Cuboid"
  (position 0.3 0.0 0) (position 0.7 0.2 1))
; -> #[body 7 1]
(sdedr:define-refeval-window "RefEvalWin_2" "Rectangle"
  (position -0.2 0.0 0) (position 0.3 0.0 1))
; -> #[body 8 1]

(part:entities (filter:type "solid?"))
; -> (#[body 5 1] #[body 6 1] #[body 7 1] #[body 8 1]))
(get-body-list)
; -> (#[body 5 1] #[body 6 1])
(get-drs-list)
; -> (#[body 7 1] #[body 8 1])
```

**NOTE** To export the boundary in TDR format use the Scheme command:

```scheme
(sdeio:save-tdr-bnd (get-body-list) "filename.tdr")
```

To find the ID of an entity of a given type at a given location, use the Scheme commands:

```scheme
(find-body-id position)
(find-face-id position)
(find-edge-id position)
(find-vertex-id position)
(find-material-id material)
(find-region-id region-name)
```

Each of these commands returns an entity list containing the entity IDs of all entities that satisfy the search criteria. If no entity is found, an empty list is returned. The `find` functions require a specification of the exact position for the required entity.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

279
</page_number>

# 10: Geometric Query Functions

Selecting Geometric Objects

For example:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1)
  "Silicon" "region_1")
(find-body-id (position 0.5 0.5 0.5)) ; -> (#[body 5 1])
(find-face-id (position 0 0 0.5)))    ; -> (#[face 29 1] #[face 28 1])
(find-edge-id (position 0 0 0))) ; -> (#[edge 14 1] #[edge 12 1] #[edge 11 1])
(find-vertex-id (position 1 1 1)))    ; -> (#[vertex 19 1])
(find-material-id "Silicon")          ; -> (#[body 5 1])
(find-region-id "region_1")           ; -> (#[body 5 1])
```

These Scheme commands always return a list, even if the list contains only a single entry. Some Scheme commands, however, expect a single entity as an argument, not a list. Use the Scheme function `car` to return only the first element of the list. For example:

```scheme
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "region_1")
(sdegeo:move-vertex (car (find-vertex-id (position 0 0 0)))
  (position -1 -1 0))
```

The function `find-material-id` can be used to find the entity numbers of all bodies having the specified DATEX material as the material attribute.

The function `find-region-id` can be used to find the entity numbers of all bodies having the specified region as the region attribute.

If the exact location is not known use the `sdegeo:find-closest` Scheme commands:

```scheme
(sdegeo:find-closest-face position)
(sdegeo:find-closest-edge position)
(sdegeo:find-closest-vertex position)
```

For example:

```scheme
(sdegeo:create-cuboid (position 0.1 -0.1 0.1) (position 1.1 0.9 0.9)
  "Silicon" "region_1")
(sdegeo:find-closest-face (position 0 0 0)))   ; -> (#[face 6 1] . 0.1414)
(sdegeo:find-closest-edge (position 0 0 0.5))) ; -> (#[edge 7 1] . 0.1414)
(sdegeo:find-closest-vertex (position 1 1 1))) ; -> (#[vertex 8 1] . 0.1732)
```

<page_number>280</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**10: Geometric Query Functions**

Finding Region Names and Material Properties

# Finding Region Names and Material Properties

When the ID of a certain topological entity is identified, the entity can be further investigated. As previously mentioned, each body has several different attributes attached. The function `generic:get` can be used to query the attributes. For example, the function `(generic:get entity_id "material")` returns the DATEX material of the selected body. The function `(generic:get entity_id "region")` returns the attached region name:

```
(define BODY (sdegeo:create-cuboid (position 0 0 0) (position 1 1 1)
  "Silicon" "region_1"))
(generic:get BODY "material") ; -> "Silicon"
(generic:get BODY "region")   ; -> "region_1"
```

Several functions of Sentaurus Structure Editor support entity debugging. The function `sde:info` lists the entity IDs, and material and region names. The argument list of `sde:info` is an entity, a list of entities, or ‘all.’ For example:

```
(sde:info "all")

Entity Id;   Material name;   Region name;
#[body 5 1]  Silicon          region_1
```

# Automatic Region-Naming

Each body that is to be written to a TDR boundary file must have two attached attributes: the material attribute and region attribute. If the automatic region-naming option (choose **Draw > Auto Region Naming**) is switched on, each newly created region is automatically assigned a unique region name. If the `sdegeo` Scheme extensions are used, the region names must be specified in the argument list.

The automatic region-naming option can also be set from Scheme. The function `(sdegeo:get-auto-region-naming)` can be used to obtain the status of the option. This function returns either `#t` or `#f`.

The function `(sdegeo:set-auto-region-naming #t|#f)` can be used to switch on or off the feature. When an explicit `sdegeo` call is made to generate a new body, the region counter must be set automatically to the next available region number for a further GUI body generation.

The automatic region-naming option assigns the following region name to created bodies:

```
"region_" + the region counter
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>281</page_number>

# 10: Geometric Query Functions

Finding Region Names and Material Properties

The region counter starts from 1 and increases automatically. The `sde:set-region-counter` Scheme extension can be used to set the region counter explicitly. For example, to set the counter to 12:

```
(sdegeo:get-region-counter)        ; -> 1
(sdegeo:set-region-counter 12)
```

When a TDR boundary file is loaded and regions follow the abovementioned naming convention, the counter is set automatically to the next available integer.

Regions with multiple lumps are separated and renamed automatically by default before the TDR boundary output is created. For example, if the original body has a region attribute "region_1" and the region has three lumps, the original region will be separated into three bodies with the region names "region_1_lump_1", "region_1_lump_2", and "region_1_lump_3".

To switch off automatic region-renaming, set the `use-unique-region-names` global Scheme variable to `#f`.

Choose **Edit** > **Separate Lumps** to invoke the lump separation explicitly.

The corresponding Scheme command is:

```
(sde:separate-lumps)
```

# List of Supported Materials

Sentaurus Structure Editor uses the default `datexcodes.txt` file to load a list containing the allowable materials. This DATEX material list shows all of the defined DATEX materials and always shows the active DATEX material. If a GUI action needs a DATEX material as input and the action does not contain a method to select it, it will always use the active DATEX material shown in the DATEX material list.

The Scheme extension `(sde:get-default-material)` returns the active DATEX material and the Scheme extension `sde:set-default-material` can be used to change the active DATEX material.

For example, to change the active material to PolySilicon:

```
(sde:set-default-material "PolySilicon")
```

**NOTE** To introduce custom materials to Sentaurus Structure Editor, create a modified copy of the `datexcodes.txt` file in the current working directory (see Utilities User Guide, Chapter 1 on page 1).

<page_number>282</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

10: Geometric Query Functions
Finding Vertex Positions

# Finding Vertex Positions

When the entity ID of a vertex (`vertex_id`) is found (`vertex:position vertex_id`), it can be used to return the position of a vertex.

For example:

```scheme
(define BODY (sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0)
  "Silicon" "region_1"))
(define i 1)
(for-each
  (lambda (VERTEX)
    (begin
      (display " [") (display i) (display "]: ")
      (display " X=") (display (position:x (vertex:position VERTEX)))
      (display ",Y=") (display (position:y (vertex:position VERTEX)))
      (set! i (+ i 1))
    )
  ) (entity:vertices BODY)
)
(newline)
; -> [1]: X=0,Y=0 [2]: X=1,Y=0 [3]: X=1,Y=1 [4]: X=0,Y=1
```

# Vertex–Vertex Distance

To determine the distance between two vertices:

1. Choose **Edit** > **2D Edit Tools** > **Vertex-to-Vertex Distance**, or click the corresponding toolbar button.

2. Select the first vertex and then the second vertex in the view window.

The corresponding distance is displayed in the command-line window.

The corresponding Scheme command is:

```scheme
(sdegeo:distance (list vertex vertex))
```

For example:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1.0)
  "Silicon" "region_1")))
(sdegeo:distance (list
  (car (find-vertex-id (position 0.0 0.0 0.0)))
  (car (find-vertex-id (position 1.0 1.0 1.0)))))
; -> 1.73205
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>283</page_number>

10: Geometric Query Functions
Debugging Topological Entities

# Debugging Topological Entities

When a geometric entity (for example, a body) is generated, a unique entity ID (an integer) is assigned to the body. This unique entity ID can be used to refer to that particular entity in further operations. The command `(part:entities)` lists all defined entities.

Several Scheme functions can be used to debug an entity. The Scheme function `(entity:debug entity [0|1|2|3|4])` can be used for basic debugging. The argument `entity` specifies the entity to be queried where `level` is an optional argument that controls the amount of the debugging information:

<table>
    <tr>
        <td>level 0</td>
        <td>Writes no output and only returns the entity type.</td>
    </tr>
    <tr>
        <td>level 1</td>
        <td>Writes only data specific to the given entity.</td>
    </tr>
    <tr>
        <td>level 2</td>
        <td>Writes additional information for some entity types. For example, if the entity is an `EDGE`, the coordinates of the endpoints and the curve data are also written. This extension writes only data specific to the given entity.</td>
    </tr>
    <tr>
        <td>level 3</td>
        <td>Writes the size of the entity and all associated entities.</td>
    </tr>
    <tr>
        <td>level 4</td>
        <td>Writes full information for the entity and all associated entities.</td>
    </tr>
</table>

For example:

```scheme
(define BODY (sdegeo:create-rectangle
  (position 0.0 0.0 0.0) (position 1.0 1.0 0.0)
  "Silicon" "region_1"))
(entity:debug BODY 0)
; -> "solid body"
```

# Finding Edges, Faces, and Other Elements of a Body

Several Scheme functions can be used to find edges, faces, and other elements of a body:

<table>
    <tr>
        <td>`entity:edges`</td>
        <td>Returns the edge list of the specified entity or entities.</td>
    </tr>
    <tr>
        <td>`entity:faces`</td>
        <td>Returns the face list of the specified entity or entities.</td>
    </tr>
    <tr>
        <td>`entity:loops`</td>
        <td>Returns the loop list of the specified entity or entities.</td>
    </tr>
</table>

<page_number>284</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 10: Geometric Query Functions

## Finding Edges, Faces, and Other Elements of a Body

`entity:lumps` Returns the lump list of the specified entity or entities.

`entity:shells` Returns the shell list of the specified entity or entities.

`entity:vertices` Returns the vertex list of the specified entity or entities.

For example:

```scheme
(define BODY (sdegeo:create-cuboid
  (position 0.0 0.0 0.0) (position 1.0 1.0 1.0) "Silicon" "region_1"))))

; All faces of the body:
(define FACES (entity:faces BODY))
; FACES: (#[face 6 1] #[face 7 1] #[face 8 1] #[face 9 1] ...)

; All edges of the first face:
(define EDGES (entity:edges (car FACES)))
; EDGES: (#[edge 12 1] #[edge 13 1] #[edge 14 1] #[edge 15 1])

; All vertices of the first edge of the first face:
(define VERTICES (entity:vertices (car EDGES)))
; VERTICES: (#[vertex 16 1] #[vertex 17 1])

; All vertices of the body:
(define ALL_VERTICES (entity:vertices BODY))
; ALL_VERTICES: (#[vertex 16 1] #[vertex 17 1] #[vertex 18 1] ...)
```

These functions can be used, for example, to round all edges associated with a certain face of an object. Here, a simple cube is created, then the top face is identified using the function `find-face-id` (see Script-Based Object Selection on page 278).

For this face, all edges are identified using the `entity:edges` function, and finally these edges are rounded using the `sdegeo:fillet` function:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 10 10 10)
  "Silicon" "region_1")
(define top_face (find-face-id (position 5 5 10)))
(define top_edges (entity:edges top_face))
(sdegeo:fillet top_edges 2)
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>285</page_number>

# 10: Geometric Query Functions

Bounding Box Query

Example of finding geometric entities showing a cuboid and a rounded cuboid

Figure 123 Example of finding geometric entities

---

# Bounding Box Query

To find the bounding box of an entity or a group of entities, use the Scheme command:

`(entity:box entity|entity-list)`

For example:

```scheme
(define BODY1 (sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1)
 "Silicon" "region_1"))
(define BODY2 (sdegeo:create-cuboid
 (position 0.3 -0.2 0.0) (position 0.7 0.0 1) "SiO2" "region_2"))
(define BODY1BBOX (entity:box BODY1))
; BODY1BOX: (#[ position 0 0 0 ] . #[ position 1 1 1 ])
(define GlobalBBBOX (entity:box (get-body-list)))
; GlobalBBBOX: (#[ position 0 -0.2 0 ] . #[ position 1 1 1 ])
(display " Ymin=") (display (position:y (car GlobalBBBOX)))
(display " Ymax=") (display (position:y (cdr GlobalBBBOX)))
(newline)
; -> Ymin=-0.2 Ymax=1
```

<page_number>286</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

10: Geometric Query Functions

Scheme Functions for Entity Queries

# Scheme Functions for Entity Queries

Table 39 lists the Scheme functions that can be used to query entities and to find the type of the selected entities.

Table 39 Scheme functions for entity queries

<table>
  <thead>
    <tr>
        <th>Scheme function</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>body?</td>
        <td>Determines if a Scheme object is a body.</td>
    </tr>
    <tr>
        <td>curve:circular?</td>
        <td>Determines if a Scheme object is a curve–circular.</td>
    </tr>
    <tr>
        <td>curve:elliptical?</td>
        <td>Determines if a Scheme object is a curve–elliptical.</td>
    </tr>
    <tr>
        <td>curve:linear?</td>
        <td>Determines if a Scheme object is a linear curve.</td>
    </tr>
    <tr>
        <td>curve?</td>
        <td>Determines if a Scheme object is a curve.</td>
    </tr>
    <tr>
        <td>edge:circular?</td>
        <td>Determines if a Scheme object is a circular edge.</td>
    </tr>
    <tr>
        <td>edge:curve?</td>
        <td>Determines if a Scheme object is a curve–edge.</td>
    </tr>
    <tr>
        <td>edge:elliptical?</td>
        <td>Determines if a Scheme object is an elliptical edge.</td>
    </tr>
    <tr>
        <td>edge:linear?</td>
        <td>Determines if a Scheme object is a linear edge.</td>
    </tr>
    <tr>
        <td>edge:spline?</td>
        <td>Determines if a Scheme object is a spline–edge.</td>
    </tr>
    <tr>
        <td>edge?</td>
        <td>Determines if a Scheme object is an edge.</td>
    </tr>
    <tr>
        <td>entity?</td>
        <td>Determines if a Scheme object is an entity.</td>
    </tr>
    <tr>
        <td>face:conical?</td>
        <td>Determines if a Scheme object is a conical face.</td>
    </tr>
    <tr>
        <td>face:cylindrical?</td>
        <td>Determines if a Scheme object is a cylindrical face.</td>
    </tr>
    <tr>
        <td>face:planar?</td>
        <td>Determines if a Scheme object is a planar face.</td>
    </tr>
    <tr>
        <td>face:spherical?</td>
        <td>Determines if a Scheme object is a spherical face.</td>
    </tr>
    <tr>
        <td>face:spline?</td>
        <td>Determines if a Scheme object is a face–spline.</td>
    </tr>
    <tr>
        <td>face:toroidal?</td>
        <td>Determines if a Scheme object is a toroidal face.</td>
    </tr>
    <tr>
        <td>face?</td>
        <td>Determines if a Scheme object is a face.</td>
    </tr>
    <tr>
        <td>loop:external?</td>
        <td>Determines if a loop is internal or external.</td>
    </tr>
    <tr>
        <td>loop?</td>
        <td>Determines if a Scheme object is a loop.</td>
    </tr>
    <tr>
        <td>lump?</td>
        <td>Determines if a Scheme object is a lump.</td>
    </tr>
    <tr>
        <td>position?</td>
        <td>Determines if a Scheme object is a position.</td>
    </tr>
    <tr>
        <td>shell?</td>
        <td>Determines if a Scheme object is a shell.</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide

<page_number>287</page_number>

S-2021.06

# 10: Geometric Query Functions

Scheme Functions for Entity Queries

Table 39 Scheme functions for entity queries (Continued)

<table>
  <thead>
    <tr>
        <th>Scheme function</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>solid:closed?</td>
        <td>Determines if a Scheme object is a closed solid.</td>
    </tr>
    <tr>
        <td>solid:manifold?</td>
        <td>Determines if a Scheme object has a positive volume.</td>
    </tr>
    <tr>
        <td>solid?</td>
        <td>Determines if a Scheme object is a solid.</td>
    </tr>
    <tr>
        <td>vertex?</td>
        <td>Determines if a Scheme object is a vertex.</td>
    </tr>
    <tr>
        <td>wire:closed?</td>
        <td>Determines if a Scheme object is a closed wire.</td>
    </tr>
    <tr>
        <td>wire:planar?</td>
        <td>Determines if a Scheme object is a planar wire.</td>
    </tr>
    <tr>
        <td>wire?</td>
        <td>Determines if a Scheme object is a wire.</td>
    </tr>
    <tr>
        <td>wire-body?</td>
        <td>Determines if a Scheme object is a wire body.</td>
    </tr>
  </tbody>
</table>

For example:

```scheme
(define BODY (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "region_1"))
(body? BODY)
; -> #t
(face? BODY)
; -> #f
```

<page_number>288</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

