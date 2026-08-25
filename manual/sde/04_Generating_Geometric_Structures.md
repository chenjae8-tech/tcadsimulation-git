# CHAPTER 4 Generating Geometric Structures

*This chapter provides details about creating a variety of structures and presents examples that illustrate various commands.*

## Modeling Unit and Modeling Range

The geometry operations in Sentaurus Structure Editor are based on the ACIS geometry kernel. Most geometric calculations are performed using finite-precision arithmetic and tolerances. You must be aware of two tolerance values because they determine the suggested modeling unit:

*   **resabs** (default value 1e-6) is the tolerance used when comparing two positions in the 3D model space. If two positions are within `resabs` of each other, they can be considered in the same position.

*   **resnor** (default value 1e-10) is the tolerance used when comparing the directions of two vectors. If the directions of two vectors are within `resnor` of each other, the vectors can be considered to be parallel.

Basically, the modeling range is the ratio of these two values (`resabs`/`resnor`).

Geometry modeling in Sentaurus Structure Editor is unitless. This means that you can choose any unit for model representation. However, the modeling range and the smallest representable feature will depend on the selected modeling unit.

For example, if you want to use micrometer as the modeling unit and a modeling range that is 100 μm, then the smallest representable feature will be resnor × 100 = 10<sup>-8</sup> μm, which is 10<sup>-5</sup> nm. If the modeling unit and the modeling range are selected to be 1 m, then the smallest representable feature will be 10<sup>-10</sup> m, which is 10 nm. From this example, it is clear that it would not be practical to select meter as the modeling unit, since the TCAD devices could not be represented in Sentaurus Structure Editor based on the tolerance values that are used for the geometric calculations. Selecting micrometer as the modeling unit would be a better choice for TCAD devices. This means that, in this case, the smallest representable geometric feature is approximately 10<sup>-5</sup> nm.

Based on experience in nanodevice modeling, it is suggested that you use nanometer as the modeling unit when such devices are being modeled. This will result in a smaller modeling range but a larger precision, which might be preferable. It is the best to select the modeling unit in such a way that it will provide the largest precision within the necessary modeling range.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>41</page_number>

# 4: Generating Geometric Structures

Creating a New Structure

If there is a modeling unit mismatch between the different TCAD tools, then an additional scaling can be applied to the tessellated boundary file created by Sentaurus Structure Editor and to the mesh command file. This operation does not introduce any modeling error, since scaling is performed directly on the files, and no additional geometric operations are applied to the model.

# Creating a New Structure

Before creating a new structure, it is good practice to reset Sentaurus Structure Editor.

To reset Sentaurus Structure Editor:

*   Choose **File** > **New** or press Ctrl+N.

The corresponding Scheme command is:

```
(sde:clear)
```

> **NOTE** This command restores the default settings of the graphical user interface (GUI), clears and reinitializes the geometry database, and clears all doping-related and refinement-related data. It is recommended as good practice to start each Scheme script with this command.

# Setting Interactive Work Preferences

This section discusses the interactive work preferences that you can set.

## Exact Coordinates

In Sentaurus Structure Editor, geometric objects can be drawn free hand. However, for most applications, it is convenient (and sometimes necessary) to specify explicitly the coordinates of the object, for example, to allow for precise alignment of different regions.

To activate exact coordinates:

*   Choose **Draw** > **Exact Coordinates**, or click the corresponding toolbar button (see Table 7 on page 12).

In Exact Coordinates mode, after drawing any 2D shape, or after adding or moving vertices, a dialog box is displayed that shows the vertex coordinates of the new shape. The dialog box allows you to edit these values.

<page_number>42</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures
Setting Interactive Work Preferences

# Snapping

Snapping can be used as an alternative or a convenient augmentation of the Exact Coordinates mode for creating 2D regions (rectangles circles, ellipses, and so on). The different snapping modes are activated interactively when drawing shapes by pressing the following keys (or click the corresponding toolbar buttons):

*   **Grid Snapping:** To activate grid snapping, press the G key or click the corresponding toolbar button (see Table 10 on page 12). The pointer jumps from grid point to grid point. (To visualize the grid, choose **View > Grid**.)

*   **Vertex Snapping:** To snap the pointer to the nearest vertex of an existing shape, press the V key or click the corresponding toolbar button (see Table 10). When the pointer is moved, it jumps from vertex to vertex. A click will insert the new vertex to be exactly on a vertex.

*   **Edge Snapping:** To snap the pointer to the nearest edge of an existing shape (it will slide along this edge), press the E key or click the corresponding toolbar button (see Table 10). A click will insert the new vertex to be exactly on the edge.

*   **Free Drawing:** To return to the default free-drawing mode, press the F key or click the corresponding toolbar button (see Table 10).

**NOTE** You can use the Exact Coordinates mode concurrently with all snapping options.

# Active Material

To select the active material to be used for subsequent actions, use the Material list.

Material list: select active material for all subsequent actions

Figure 13 Material list: select active material for all subsequent actions

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>43</page_number>

# 4: Generating Geometric Structures

Setting Interactive Work Preferences

> **NOTE** The `datexcodes.txt` file controls the material list. The default location is `$STROOT/tcad/$STRELEASE/lib/datexcodes.txt`. New materials can be defined by creating a local version of this file in the current working directory.

## Naming Regions

When creating a new region, Sentaurus Structure Editor automatically assigns a default region name. The default region names follow the sequence `region_1`, `region_2`, `region_3`, and so on. To be prompted for a custom region name after creating a new region interactively, deactivate the automatic region-naming feature.

To switch automatic region-naming on or off, choose **Draw > Auto Region Naming**.

Region names can be changed later (see Changing the Name of a Region on page 109). Within Sentaurus Structure Editor, multiple geometric objects can share the same region name. However, when saving the final boundary, disjoint regions must have different region names. If the region-naming does not satisfy this criterion, Sentaurus Structure Editor automatically modifies the region names by adding the suffix `_lump%N` to each disjoint region (where `N` is a lump counter). Choose **Edit > Separate Lumps** to explicitly force this region-renaming step.

## Overlap Behavior

In most applications, a device consists of multiple regions. When creating a device with multiple regions in Sentaurus Structure Editor, later-added regions might intersect existing regions. If this occurs, a predefined scheme is used to resolve the overlapping of regions.

To select the overlap resolution behavior, choose **Draw > Overlap Behavior**, or click the corresponding toolbar button (see Table 12 on page 13).

The types of overlap resolution behavior available in Sentaurus Structure Editor are:

### Merge

Old and new structures merge, and all boundary lines between them are dissolved. The resulting merged structure takes on the region name and material of the last-drawn structure. The corresponding Scheme command is:

```
(sdegeo:set-default-boolean "AB")
```

<page_number>44</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Setting Interactive Work Preferences

### New Replaces Old

The new structure is created as drawn, and the old structure is adapted. The part of the old structure that overlaps with the new one is deleted, and its boundary is replaced by the boundary of the new structure. Two separate regions remain. The corresponding Scheme command is:

```
(sdegeo:set-default-boolean "ABA")
```

### Old Replaces New

The new structure is created, but it is adapted so that the old one remains unchanged. The part of the new structure that overlaps with the old one is deleted, and its boundary is replaced by the boundary of the old structure. Two separate regions remain. The corresponding Scheme command is:

```
(sdegeo:set-default-boolean "BAB")
```

### New Overlaps Old

The new structure is created as drawn, and the old structure is adapted. The part of the old structure that overlaps with the new structure is deleted. However, the boundary edges of the old structure do not dissolve. Three regions result: original, new, and overlap, where the overlap region is named `region_1region_2`, that is, the concatenation of the original and new region names. The corresponding Scheme command is:

```
(sdegeo:set-default-boolean "ABiA")
```

### Old Overlaps New

The new structure is created, but it is adapted so that the old one remains unchanged. The part of the new structure that overlaps the old one is deleted. However, the boundary edges of the new structure do not dissolve. Three regions result: original, new, and overlap, where the overlap region is named `region1region2`, that is, the concatenation of the original and new region names. The corresponding Scheme command is:

```
(sdegeo:set-default-boolean "ABiB")
```

### Unresolved Overlaps

An additional option `"XX"` is available. The `(sdegeo:set-default-boolean "XX")` command switches off the automatic overlap region handling, thereby allowing the creation of overlapping regions. This option should be used only by experienced users. The overlaps must be resolved manually later; otherwise, the exported final boundary will contain an invalid topology. This option is not available from the GUI.

### Current Overlap Behavior

The Scheme command `(sdegeo:get-default-boolean)` returns information about the currently active overlap resolution behavior.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

45
</page_number>

# 4: Generating Geometric Structures

Drawing Basic 2D Shapes

### Removing Overlaps

If the model contains overlapping regions, the overlaps can be removed by using either explicit Boolean operations (`sdegeo:bool-intersect`, `sdegeo:bool-subtract`, `sdegeo:bool-unite`), or the remove-body-ABA or remove-body-BAB command.

**NOTE** Some geometric operations might create overlaps, which can be difficult to detect, especially for larger 3D models. The overlaps must be removed from the model before the tessellated boundary file is saved for meshing. The `sdegeo:check-overlap` function can be used to find the possible overlaps automatically.

# Drawing Basic 2D Shapes

This section discusses how to draw basic 2D shapes.

## Drawing Rectangles

To draw a rectangle:

1. Choose **Draw** > **2D Create Tools** > **Rectangular Region**, or click the corresponding toolbar button (see Table 9 on page 12).

2. Drag to draw the diagonal of the rectangle in the view window.

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the first vertex and second vertex of the diagonal.

The corresponding Scheme command is sdegeo:create-rectangle on page 617. For example:

```scheme
(sdegeo:create-rectangle (position 0 0 0) (position 2 1 0) "Silicon"
"R.Substrate")
```

## Drawing Regular Polygons

To draw a regular polygon:

1. Choose **Draw** > **2D Create Tools** > **Regular Polygonal Region**, or click the corresponding toolbar button (see Table 9 on page 12).

2. Drag to draw the radius of the regular polygon in the view window. By default, a ten-sided polygon is created.

<page_number>46</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures

Drawing Basic 2D Shapes

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the center point, the radius, the number of sides, as well as the starting angle.

The corresponding Scheme command is sdegeo:create-reg-polygon on page 618. For example:

```scheme
(sdegeo:create-reg-polygon (position 0 0 0) 1.0 3 30 "Nitride"
  "R.TriangleSpacer")
```

# Drawing Polygons

To draw a general polygon:

1. Choose **Draw** > **2D Create Tools** > **Polygonal Region**, or click the corresponding toolbar button (see Table 9 on page 12).

2. Click at each vertex of the polygon in the view window. To finish drawing the polygon, click the middle mouse button. (Press both buttons when using a two-button mouse.) The polygon closes automatically.

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates for each vertex.

The corresponding Scheme command is sdegeo:create-polygon on page 612. For example:

```scheme
(sdegeo:create-polygon (list (position 0 0 0) (position 0.5 -1 0)
  (position 1 -1 0) (position 1.5 0 0) (position 0 0 0))
  "PolySilicon" "R.TaperedPoly")
```

# Drawing Circles

To draw a circle:

1. Choose **Draw** > **2D Create Tools** > **Circular Region**, or click the corresponding toolbar button (see Table 9 on page 12).

2. Drag to draw the radius of the circle in the view window.

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the center point and the radius.

The corresponding Scheme command is sdegeo:create-circle on page 598. For example:

```scheme
(sdegeo:create-circle (position 0 0 0) 0.01 "Silicon" "R.Nanowire")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>47</page_number>

# 4: Generating Geometric Structures

Drawing Basic 2D Shapes

## Drawing Ellipses

To draw an ellipse:

1. Choose **Draw** > **2D Create Tools** > **Elliptical Region**, or click the corresponding toolbar button (see Table 9 on page 12).

2. Drag to draw the major axis in the view window. Then, release the mouse button and move the pointer to select the width of the ellipse.

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the center point, the endpoint of the major axis, as well as the ratio between the major and the minor axes.

The corresponding Scheme command is sdegeo:create-ellipse on page 604. For example:

```
(sdegeo:create-ellipse (position 0 0 0) (position 1 0 0) 0.5 "Silicon"
 "R.Ellipse")
```

**NOTE** The ratio can be greater than 1, in which case, the minor axis will actually be larger than the other axis (which was referred to above as the major axis).

## Drawing Ruled Regions

A ruled region is a shape that is defined by two edges. The region is created by connecting the endpoints of the two edges.

To draw a ruled region:

1. From the Selection Level list, select **Select Edge**.

2. Choose **Draw** > **2D Create Tools** > **Ruled Region**.

3. Select the edge and hold the Shift key to select the second edge.

The corresponding Scheme command is sdegeo:create-ruled-region on page 619. For example:

```
(sdegeo:create-rectangle (position -1.0 0.0 0) (position 1.0 1.0 0) "Silicon"
 "R.Substrate")
(sdegeo:create-rectangle (position -0.5 0.0 0) (position 0.5 -0.05 0) "Oxide"
 "R.Gox")
(sdegeo:create-rectangle (position -0.1 -0.5 0) (position 0.1 -0.7 0)
 "Aluminum" "R.GateCont")
(sdegeo:insert-vertex (position -0.2 -0.05 0))
(sdegeo:insert-vertex (position 0.2 -0.05 0))
```

<page_number>48</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Drawing Basic 2D Shapes

```
(sdegeo:create-ruled-region (list
  (car (find-edge-id (position 0.0 -0.5 0)))
  (car (find-edge-id (position 0.0 -0.05 0)))) "PolySilicon" "R.PolyGate")
(sdegeo:create-ruled-region (list
  (car (find-edge-id (position -0.15 -0.275 0)))
  (car (find-edge-id (position -0.35 -0.05 0)))) "Nitride" "R.SpacerL")
(sdegeo:create-ruled-region (list
  (car (find-edge-id (position 0.15 -0.275 0)))
  (car (find-edge-id (position 0.35 -0.05 0)))) "Nitride" "R.SpacerR")
```

Diagram showing three stages of generating ruled regions for a transistor gate structure

Figure 14 Generating ruled regions using linear edges: (*left*) original structure, (*middle*) after adding the first ruled region, and (*right*) after adding the remaining two ruled regions

Ruled regions can be created only for 2D models. The edges that are used for creating the ruled region do not have to be linear. Figure 15 shows such a case. The inserted ruled region (ruled region I) was created between two circular edges, which were created by a filleting operation.

Diagram illustrating the generation of ruled regions using curved edges with labels for Selected Edges and Generated Ruled Regions

Figure 15 Generating a ruled region using curved edges

Sentaurus™ Structure Editor User Guide

<page_number>49</page_number>

S-2021.06

# 4: Generating Geometric Structures

Editing 2D Shapes

## Drawing Other Basic 2D Shapes

Other basic 2D shapes are available using Scheme extensions such as `sdegeo:create-triangle`.

See Index of Scheme Extensions on page 861 for details.

# Editing 2D Shapes

This section describes various editing operations on 2D shapes.

## Adding a Vertex

To add a vertex:

1. Choose **Edit > 2D Edit Tools > Add Vertex**, or click the corresponding toolbar button (see Table 8 on page 12).

2. Click a position on an edge where the vertex is to be placed.

The corresponding Scheme command is:

```scheme
(sdegeo:insert-vertex position)
```

For example:

```scheme
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "region_1")
(sdegeo:insert-vertex (position 0.5 1.0 0.0))
```

Vertices are added to existing 2D regions in such a way that model conformity is maintained. For regions sharing a common edge or an edge segment, the vertex is inserted onto both edges, splitting the edges. Added vertices always are inserted onto the closest edge, by projecting the inserted vertex to the nearest edge.

**NOTE** This operation is available only for 2D regions. Use the Wireframe mode to visualize the new vertex (see Table 5 on page 11). The Exact Coordinates mode can be used to precisely control the new location; however, snapping is not supported.

<page_number>50</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 2D Shapes

# Moving a Vertex

To move a vertex:

1. Choose **Edit** > **2D Edit Tools** > **Move Vertex**, or click the corresponding toolbar button (see Table 8 on page 12).

2. Drag the vertex to the required position.

The corresponding Scheme command is:

```
(sdegeo:move-vertex vertex position)
```

For example:

```
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon"
 "region_1")
(sdegeo:move-vertex (car (find-vertex-id (position 0 0 0)))
 (position 0.25 0.25 0))
```

To move several vertices:

1. Choose **Edit** > **2D Edit Tools** > **Move Vertices**, or click the corresponding toolbar button (see Table 8 on page 12).

2. Select the vertices.

3. When finished, drag any of the selected vertices to move all of them to the required position.

The corresponding Scheme command is:

```
(sdegeo:move-vertex vertex-list gvector)
```

For example:

```
(define BODY (sdegeo:create-reg-polygon (position 0 0 0) 1 10 0 "Silicon"
 "region_1"))
(sdegeo:move-vertex (sde:window-select-2d 0 -1.1 1.1 1.1 BODY "vertex")
 (gvector 1 0 0))
```

**NOTE** This operation is available only for 2D regions. Only vertices that connect linear line segments can be moved. Vertices on curved edges cannot be moved. The Exact Coordinates mode can be used to precisely control the new location; however, snapping is not supported.

The function can be used to move the vertices of some 2D DRS Ref/ Eval windows (line, rectangle, polygon).

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

51
</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

Moving a vertex is allowed only to such an extent that the expected operation results in a topologically correct 2D region, that is, crossing edges are not allowed. If a vertex belongs to multiple regions, all regions are modified accordingly.

## Moving Region Edges

To move a region edge:

1. Choose **Edit** > **2D Edit Tools** > **Move Edge**, or click the corresponding toolbar button (see Table 8 on page 12).

2. Select a linear edge, and drag the edge to the required position.

The corresponding Scheme command is:

```
(sdegeo:move-edge edgeid gvector)
```

For example:

```
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon"
 "region_1")
(sdegeo:move-edge (car (find-edge-id (position 1 0.5 0))) (gvector 0.5 0.5 0))
```

> **NOTE** This operation is available only for 2D regions. Only linear edges can be moved and only when all connecting edges are linear as well. The edges are moved like rigid bodies (that is, all connecting edges are moved as well). The Exact Coordinates mode can be used to precisely control the new location.

If the new location of the moved region is such that it overlaps other regions, the overlaps are removed automatically following the active Boolean overlap control rule.

## Moving Regions

To move one or more regions:

1. Choose **Edit** > **2D Edit Tools** > **Move Region**, or click the corresponding toolbar button (see Table 8 on page 12).

2. Select one region (or more regions by holding the **Ctrl** key). Release the **Ctrl** key, and drag the regions to the required position.

The corresponding Scheme command is:

```
(sdegeo:move-2d-regions body | body-list gvector)
```

<page_number>52</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures

Editing 2D Shapes

For example:

```scheme
(define mb1 (sdegeo:create-rectangle (position 0 0 0) (position 1 1 0)
  "Silicon" "region_1"))
(sdegeo:move-2d-regions mb1 (gvector 1 1 0)
```

**NOTE** This operation is available only for 2D regions. The Exact Coordinates mode can be used to precisely control the new location.

If the new locations of the moved regions are such that they overlap other regions, then the overlaps are removed automatically following the active Boolean overlap control rule.

# Deleting Vertices

To delete one or more vertices:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Vertex**.

3. Select the vertex and hold the Shift key to select additional vertices, or drag a box around a set of vertices.

4. Choose **Edit > 2D Edit Tools > Delete Vertex**, or press the Delete key.

The corresponding Scheme command is:

```scheme
(sdegeo:delete-vertices vertex-list)
```

Example 1 with an explicit vertex selection:

```scheme
(sdegeo:create-reg-polygon (position 0 0 0) 1 6 0 "Silicon" "region_1")
(sdegeo:delete-vertices (list
  (car (find-vertex-id (position -1.0 0 0)))
  (car (find-vertex-id (position 1.0 0 0)))))
```

Example 2 with a window vertex selection:

```scheme
(sdegeo:create-polygon (list
  (position 0.0 0.0 0) (position 1.0 0.0 0) (position 1.0 1.0 0)
  (position 0.8 1.1 0) (position 0.6 0.9 0) (position 0.4 1.1 0)
  (position 0.2 0.9 0) (position 0.0 1.0 0) (position 0.0 0.0 0))
  "Silicon" "region_1")
(define VERTICES (sde:window-select-2d 0.1 0.8 0.9 1.2 "all" "vertex"))
(sdegeo:delete-vertices VERTICES)
```

**NOTE** This operation is available only for 2D regions.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>53</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

---

## Rounding

To round one or more corners of a 2D region:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Vertex**.

3. Select the vertex and hold the Shift key to select additional vertices, or drag a box around a set of vertices.

4. Choose **Edit > 2D Edit Tools > Fillet**.

5. Enter a fillet radius in the dialog box.

If the parameter `fillet-radius` was set before performing this operation (choosing **Edit > Parameters**), then this dialog box is suppressed, and the given value of `fillet-radius` is used instead.

The corresponding Scheme command is:

```
(sdegeo:fillet-2d vertex-list radius)
```

For example:

```
(sdegeo:create-rectangle (position 0 0 0.0) (position 1 1 0.0) "Silicon"
  "region_1")
(sdegeo:fillet-2d (list
  (car (find-vertex-id (position 1 0 0)))
  (car (find-vertex-id (position 0 0 0)))) 0.4)
```

**NOTE** If `fillet-radius` is too large such that two adjacent fillets overlap, the operation will fail.

Diagram showing a square on the left and a rounded rectangle on the right with various fillet-radius labels (0.2 and 0.4) indicating the curvature of the corners.

Figure 16 Two-dimensional vertex rounding: (*left*) rectangle (1 x 1) and (*right*) rounded rectangle

<page_number>54</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures
Editing 2D Shapes

# Chamfering

To chamfer one or more corners of a 2D region:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Vertex**.

3. Select the vertex and hold the Shift key to select additional vertices, or drag a box around a set of vertices.

4. Choose **Edit** > **2D Edit Tools** > **Chamfer**.

5. Enter a chamfer distance in the dialog box.

If the parameter `chamfer-dist` was set before performing this operation (choosing **Edit** > **Parameters**), then this dialog box is suppressed, and the given value of `chamfer-dist` is used instead.

The corresponding Scheme command is:

```
(sdegeo:chamfer-2d vertex-list chamfer-dist)
```

For example:

```
(sdegeo:create-rectangle (position 0 0 0.0) (position 1 1 0.0) "Silicon"
  "region_1")
(sdegeo:chamfer-2d (list
  (car (find-vertex-id (position 1 0 0)))
  (car (find-vertex-id (position 0 0 0)))) 0.4)
```

Rectangle (1 x 1)

Chamfered rectangle with annotations: chamfer-distance = 0.2, chamfer-distance = 0.4, chamfer-distance = 0.2

Figure 17 Two-dimensional vertex chamfering: (*left*) rectangle (1 x 1) and (*right*) chamfered rectangle

**NOTE** The `chamfer-dist` cannot be larger than the smallest edge length of the adjacent edges of the selected vertices. For multiple vertices sharing the same edge, the distance must be smaller than half the length of the smallest such edge. Otherwise, the operation will fail.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

55
</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

## Cutting

To cut out a rectangular part from a 2D structure:

1. Choose **Edit > 2D Edit Tools > 2D Cut**.

2. Drag to draw the diagonal of the rectangle in the view window.

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the first vertex and second vertex of the diagonal.

The corresponding Scheme command is:

```
(sdegeo:2d-cut position position)
```

The argument list contains the two corner positions of the rectangular area. All regions outside of this rectangle are removed from the model.

For example:

```
(sdegeo:create-circle (position 0 0 0) 1 "Silicon" "region_1")
(sdegeo:2D-cut (position 0 -1.1 0.0) (position 0.8 1.1 0.0))
```

## Creating a Convex Hull

The Scheme extension `sdegeo:chull2d` can be used to compute the 2D convex hull of the specified position list. The position list of the computed convex hull is returned.

Creating a 2D convex hull: (left) original point set and (right) created convex hull

Figure 18 Creating a 2D convex hull: (*left*) original point set and (*right*) created convex hull

<page_number>56</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures
Editing 2D Shapes

# Splitting Structures

To split one or more 2D regions by a polygonal line:

1. Choose **Edit** > **2D Edit Tools** > **Polygonal Region Split**, or click the corresponding toolbar button (see Table 8 on page 12).

2. Click at each vertex of the polygonal line. To finish drawing the polygonal line, click the middle mouse button. (Press both buttons when using a two-button mouse.)

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates for each vertex.

The first vertex and last vertex of the defined polygonal line snap to the closest edge or vertex of the existing model. Unique region names are given to the split-off parts of the original bodies.

The corresponding Scheme command is:

```
(sdegeo:polygonal-split position-list)
```

For example:

```
(sdegeo:create-rectangle (position -1.0 0.0 0.0) (position 1.0 1.0 0.0)
 "Silicon" "region_1")
(sdegeo:create-rectangle (position -1.0 -0.1 0.0) (position 1.0 0.0 0.0)
 "SiO2" "region_2")
(sdegeo:create-rectangle (position -1.0 -0.1 0.0) (position 1.0 -0.7 0.0)
 "PolySi" "region_3")
(sdegeo:polygonal-split (list
 (position -0.25 -1 0) (position -0.25 0.1 0) (position 0 0.2 0)
 (position 0.25 0.1 0) (position 0.25 -1 0)))
```

original structure

after the split operation

Figure 19 Splitting a device using a polygonal line segment: (*left*) original structure and (*right*) after the split operation

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

57
</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

---

## Simplifying 2D Structures

Sentaurus Structure Editor has a set of functions to simplify 2D structures. Such boundary simplification is sometimes advantageous for structures generated by other tools such as Sentaurus Process. Examples of such simplifications are aligning vertices, removing collinear edges, and breaking nonaxis-aligned edges into axis-aligned *staircases*. In general, the subsequent meshing tool will generate grids with fewer nodes if the boundary has fewer points and if most edges are axis aligned.

### Aligning Vertices

To align vertices to an axis horizontally (or vertically):

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Vertex**.

3. Select the vertex and hold the Shift key to select additional vertices, or drag a box around a set of vertices.

4. Choose **Edit > 2D Edit Tools > Align Vertices to Horizontal** (or **Align Vertices to Vertical**).

5. Click to select the horizontal (or vertical) alignment level.

The corresponding Scheme commands are:

```
(sdegeo:align-horizontal vertex-list yalign)
(sdegeo:align-vertical   vertex-list xalign)
```

For example:

```
(sdegeo:create-polygon (list
  (position 0.0  1.0 0) (position 1.0  1.0 0) (position 1.0  0.0 0)
  (position 0.8  0.1 0) (position 0.6 -0.1 0) (position 0.4  0.1 0)
  (position 0.2 -0.1 0) (position 0.0  0.0 0) (position 0.0  1.0 0))
  "Silicon" "region_1")
(define VERTICES (sde:window-select-2d -0.1 -0.2 1.1 0.2 "all" "vertex"))
(sdegeo:align-horizontal VERTICES 0.0)
```

<page_number>58</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

# 4: Generating Geometric Structures

Editing 2D Shapes

Aligning vertices horizontally: (left) original structure and (right) after alignment. For better viewing, the structure is shown as a wireframe.

Figure 20 Aligning vertices horizontally: (left) original structure and (right) after alignment. For better viewing, the structure is shown as a wireframe.

To automatically align the selected vertices to the average y-position (or x-position):

*   Choose **Edit** > **2D Edit Tools** > **Aut. Align Vertices to Horizontal** (or **Aut. Align Vertices to Vertical**).

The corresponding Scheme commands are:

```scheme
(sdegeo:align-horizontal-aut vertex-list)
(sdegeo:align-vertical-aut   vertex-list)
```

To align the selected vertices to an arbitrary line:

*   Choose **Edit** > **2D Edit Tools** > **Align Vertices to a Line**.

To define the line, click at the starting point and drag to the endpoint.

The corresponding Scheme command is:

```scheme
(sdegeo:align-to-line vertex-list starting-position end-position)
```

For example:

```scheme
(sdegeo:create-polygon (list
  (position 0.0 0.0 0) (position 1.0 0.0 0) (position 1.0 1.0 0)
  (position 0.8 1.1 0) (position 0.6 0.9 0) (position 0.4 1.1 0)
  (position 0.2 0.9 0) (position 0.0 1.0 0) (position 0.0 0.0 0))
  "Silicon" "region_1")
(define VERTICES (sde:window-select-2d -0.1 0.8 1.1 1.2 "all" "vertex"))
(sdegeo:align-to-line VERTICES (position 0.0 0.7 0) (position 1.0 1.3 0))
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>59</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

> **NOTE** The command moves the vertices along the normal to the specified line. Therefore, both the x-coordinates and y-coordinates can be altered by this operation.

When the vertices have been aligned, the now redundant vertices can be removed by using either vertex deletion (see Deleting Vertices on page 53) or edge removal (see Merging Collinear Edges on page 61).

Diagram showing two-dimensional boundary simplification: original shape, selected vertices, vertically aligned vertices, and final shape with short edges removed.

Figure 21 Two-dimensional boundary simplification, vertical alignment of vertices, and removal of short edges

Sequence of diagrams showing boundary simplification: selected vertices on a jagged edge, vertices aligned to a straight line, and the final result after redundant vertices are deleted. Vertices Aligned to a Line After Vertices Deleted

Figure 22 Two-dimensional boundary simplification, align to line, and vertex removal

<page_number>60</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 2D Shapes

# Merging Collinear Edges

To merge collinear edges:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Edge**.

3. Select the edge and hold the Shift key to select additional edges, or drag a box around a set of edges.

4. Choose **Edit > 2D Edit Tools > Delete Collinear Edges**.

The corresponding Scheme command is:

```
(sdegeo:delete-collinear-edges edge-list)
```

For example:

```
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0) "Silicon"
 "region_1")
(sdegeo:insert-vertex (position 0.3 0.0 0))
(sdegeo:insert-vertex (position 0.0 0.3 0))
(sdegeo:insert-vertex (position 0.0 0.6 0))
(define EDGES (sde:window-select-2d -0.1 -0.1 1.1 0.8 "all" "edge"))
(sdegeo:delete-collinear-edges EDGES)
```

This command removes edges only if they are exactly collinear. For ‘noisy’ boundaries:

1. Choose **Edit > 2D Edit Tools > Delete Nearly Collinear Edges**.

2. In the dialog box, enter a threshold distance.

Two edges (Edge 1 and Edge 2) are considered to be collinear if the distance *D*, defined as shown in Figure 23, is less than the specified distance.

Distance definition for nearly collinear edges diagram

Figure 23 Distance definition for nearly collinear edges

The corresponding Scheme command is:

```
(sdegeo:delete-nearly-collinear-edges edge-list distance)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>61</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

For example:

```scheme
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0) "Silicon"
  "region_1")
(sdegeo:insert-vertex (position 0.25 0.0 0))
(sdegeo:insert-vertex (position 0.50 0.0 0))
(sdegeo:insert-vertex (position 0.75 0.0 0))
(sdegeo:move-vertex (find-vertex-id (position 0.5 0.0 0))
  (position 0.5 0.1 0))
(define EDGES (sde:window-select-2d -0.1 -0.1 1.1 0.2 "all" "edge"))
(sdegeo:delete-nearly-collinear-edges EDGES 0.2)
```

To remove all edges shorter than a given length by merging them with adjacent edges:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Edge**.

3. Select the edge and hold the Shift key to select additional edges, or drag a box around a set of edges.

4. Choose **Edit > 2D Edit Tools > Delete Short Linear Edges**.

5. Enter the minimal-allowed edge length in the dialog box.

The corresponding Scheme command is:

```scheme
(sdegeo:delete-short-edges edge-list minimal-edge-length)
```

For example:

```scheme
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0) "Silicon"
  "region_1")
(sdegeo:insert-vertex (position 0.1 0.0 0))
(sdegeo:insert-vertex (position 0.0 0.1 0))
(sdegeo:insert-vertex (position 0.0 0.2 0))
(define EDGES (sde:window-select-2d -0.1 -0.1 1.1 0.3 "all" "edge"))
(sdegeo:delete-short-edges EDGES 0.2)
```

**NOTE** This command preserves vertices at which the angle between two edges is 90° or more (ridges). At rounded corners, this command might result in the unintended removal of the entire corner.

To remove edges based on an angular cut-off:

1. Choose **Edit > 2D Edit Tools > Delete Linear Edges**.

2. Enter the cut-off angle (angular tolerance) in the dialog box.

If the angle between two edges at a vertex is larger than the cut-off angle, the edges are removed.

<page_number>62</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures

Editing 2D Shapes

**NOTE** The angle between collinear edges is 180° . To protect corners, use an angle greater than 90° .

The corresponding Scheme command is:

```scheme
(sdegeo:delete-short-edges edge-list [edge-angular-cut-off])
```

The default value for `edge-angular-cut-off` is 90° .

For example:

```scheme
(sdegeo:create-polygon (list
    (position 0.0 0.0 0) (position 1.0 0.0 0) (position 1.0 1.0 0)
    (position 0.8 1.02 0) (position 0.6 0.98 0) (position 0.4 1.02 0)
    (position 0.2 0.98 0) (position 0.0 1.0 0) (position 0.0 0.0 0))
    "Silicon" "region_1")
(define EDGES (sde:window-select-2d -0.1 0.9 1.1 1.1 "all" "edge"))
(sdegeo:delete-short-edges EDGES 150)
```

The alternative command:

```scheme
(merge-collinear-edges-2d body-list [normal-angular-cut-off])
```

works similarly to `sdegeo:delete-short-edges`, but it automatically selects all edges from all bodies selected, and it uses a different definition for the cut-off angle. Here, the edge is removed if the angle between the face normals is smaller than the given cut-off angle. For example, an `edge-angular-cut-off` of 120° corresponds to a `normal-angular-cut-off` of 30° .

An additional variance:

```scheme
(sdegeo:prune-vertices body-list normal-angular-cut-off)
```

works with vertices instead of edges, but it uses the same algorithm for the selected edges to be removed. The command:

```scheme
(sdegeo:dnce normal-angular-cut-off)
```

automatically calls `sdegeo:prune-vertices` for all bodies.

A further variant of the edge removal command allows you to specify an edge length as well as a cut-off angle. This command operates on a list of bodies, instead of an edge list, and is not available from the GUI.

The Scheme command is:

```scheme
(sdegeo:del-short-edges body-list edge-list minimal-edge-length
    normal-angular-cut-off)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>63</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

For example:

```scheme
(define BODY (sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0)
  "Silicon" "R.Substrate"))
(sdegeo:insert-vertex (position 0.1 0.0 0))
(sdegeo:insert-vertex (position 0.0 0.1 0))
(sdegeo:insert-vertex (position 0.0 0.2 0))
(sdegeo:move-vertex (find-vertex-id (position 0 0 0)) (position 0.03 0.03 0))
(sdegeo:del-short-edges BODY 0.2 10)
```

Original Model engineering drawing

**Original Model**
(length (entity: vertices (get-body-list)))
; --> 355 vertices

Engineering drawing showing merge-collinear-edges-2d "all"

(merge-collinear-edges-2d "all")
; --> 244 vertices

Engineering drawing showing merge-collinear-edges-2d "all" 10

(merge-collinear-edges-2d "all" 10)
; --> 57 vertices

Engineering drawing showing merge-collinear-edges-2d "all" 20

(merge-collinear-edges-2d "all" 20)
; --> 39 vertices

Figure 24 Merging collinear edges: (*upper left*) original model and examples of different merges of collinear edges

<page_number>64</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 2D Shapes

Mask layout showing edge reduction from 3723 to 230 edges

Figure 25 Mask layout: (*left*) before deleting nearly collinear edges and (*right*) after by deleting nearly collinear edges

## Breaking Nearly Axis-Aligned Edges

To break up nearly axis-aligned edges into a staircase of axis-aligned edges:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Edge**.

3. Select the edge and hold the Shift key to select additional edges, or drag a box around a set of edges.

4. Choose **Edit > 2D Edit Tools > Break Nearly Axis-Aligned Edges**.

5. Enter a cut-off angle in the dialog box.

All edges that form an angle smaller than the cut-off angle with either the x-axis or y-axis are converted to a staircase-like set of edges.

The corresponding Scheme command is:

```
(sdegeo:break-nearly-axis-aligned-edges edge-list angular-cut-off)
```

For example:

```
(sdegeo:create-polygon (list
 (position 0 0 0) (position 0.7 0.1 -0) (position 0.8 0.6 -0)
 (position 0.1 0.7 -0) (position -0.2 0.4 -0) (position 0 0 0))
 "Silicon" "region_1")
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

65
</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

```scheme
(define EDGES (sde:window-select-2d -0.5 -0.5 1.5 1.5 "all" "edge"))
(sdegeo:break-nearly-axis-aligned-edges EDGES 15)
```

Breaking nearly axis-aligned edges into staircases: (left) original structure and (right) after the edge-breaking operation

Figure 26 Breaking nearly axis-aligned edges into staircases: (*left*) original structure and (*right*) after the edge-breaking operation

**NOTE** Previously, slightly off-axis edges resulted in very small and unwanted mesh elements near interfaces. This is no longer the case for Sentaurus Mesh, which has improved support for nonaxis-aligned boundaries. This reduces the need for this kind of boundary simplification.

<table>
  <thead>
    <tr>
        <th colspan="3">Boundary Simplification Thresholds</th>
    </tr>
    <tr>
        <th>Axis-aligned corner</th>
        <th>45 degree threshold</th>
        <th>20 degree threshold</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Original boundary</td>
        <td>Axis-aligned boundary</td>
        <td> </td>
    </tr>
  </tbody>
</table>

Figure 27 Breaking nearly axis-aligned edges to axis-aligned edges

<page_number>66</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**
Editing 2D Shapes

# Two-Dimensional Boundary Smoothing

The `sdegeo:vsmooth` Scheme extension performs 2D boundary smoothing. It uses a least squares fit of a small set of consecutive data points (vertices) to a polynomial and takes the calculated central point of the fitted polynomial curve as the new smoothed data point (vertex). The fitted polynomial can be either quadratic or cubic. The polynomial order (2 or 3) is the first argument of the function. The second argument is the vertex list that will be smoothed.

You can call the `sdegeo:vsmooth` Scheme extension multiple times to perform the boundary-smoothing operation successively.

You can specify all the vertices of the model as input by using the command `(entity:vertices (get-body-list))`. The global Scheme variable `bsmooth-ac` specifies an angular criterion (in degrees) for shape preservation (preserving ridges). The default value is 100. The following figures show different boundaries before and after vertex smoothing.

Vertex smoothing comparison: left shows a jagged boundary before smoothing, right shows a smoother boundary after applying sdegeo:vsmooth.

Figure 28 Vertex smoothing using sdegeo:vsmooth: *(left)* before and *(right)* after

Sequence of three shapes showing multiple vertex-smoothing steps. The leftmost shape has a jagged boundary, the middle shape is partially smoothed, and the rightmost shape is fully smoothed while preserving the sharp 90-degree ridge.

Figure 29 Multiple vertex-smoothing steps using sdegeo:vsmooth, showing ridge preservation

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>67</page_number>

# 4: Generating Geometric Structures

Editing 2D Shapes

Vertex smoothing, using sdegeo:vsmooth: (left) before and (right) after

Figure 30 Vertex smoothing, using sdegeo:vsmooth: (left) before and (right) after

## Edge Length Queries

Edge length query functions help to determine which edges can be considered as too short and, therefore, can be removed. The Scheme commands for edge length queries are:

```scheme
(sdegeo:max-edge-length edge-list)
(sdegeo:min-edge-length edge-list)
(sdegeo:average-edge-length edge-list)
```

For example:

```scheme
(sdegeo:create-polygon (list
  (position 0.0 0.0 0) (position 1.0 0.0 0) (position 1.0 1.0 0)
  (position 0.8 1.02 0) (position 0.6 0.98 0) (position 0.4 1.02 0)
  (position 0.2 0.98 0) (position 0.0 1.0 0) (position 0.0 0.0 0))
  "Silicon" "region_1")
(define EDGES (sde:window-select-2d -0.1 -0.1 1.1 1.1 "all" "edge"))
(sdegeo:max-edge-length EDGES)
--> 1
(sdegeo:min-edge-length EDGES)
--> 0.200997512422418
(sdegeo:average-edge-length EDGES)
--> 0.501734670809496
```

Table 20 lists the boundary-simplifying Scheme functions that are also available from the GUI.

Table 20 Scheme functions for 2D boundary simplification

<table>
  <thead>
    <tr>
        <th>Scheme function</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>merge-collinear-edges-2d</td>
        <td>Merges the collinear edges of the specified bodies.</td>
    </tr>
    <tr>
        <td>sde:window-select-2d</td>
        <td>Selects different entity types in a 2D window.</td>
    </tr>
    <tr>
        <td>sdegeo:align-horizontal</td>
        <td>Aligns points horizontally to a specified position.</td>
    </tr>
    <tr>
        <td>sdegeo:align-horizontal-aut</td>
        <td>Aligns points horizontally to the average position.</td>
    </tr>
  </tbody>
</table>

<page_number>68</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Drawing Basic 3D Shapes

Table 20 Scheme functions for 2D boundary simplification (Continued)

<table>
  <thead>
    <tr>
        <th>Scheme function</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>sdegeo:align-to-line</td>
        <td>Snaps the specified points to a predefined straight line.</td>
    </tr>
    <tr>
        <td>sdegeo:align-vertical</td>
        <td>Aligns points vertically to a specified position.</td>
    </tr>
    <tr>
        <td>sdegeo:align-vertical-aut</td>
        <td>Aligns points vertically to the average position.</td>
    </tr>
    <tr>
        <td>sdegeo:average-edge-length</td>
        <td>Computes the average edge length (for an edge list).</td>
    </tr>
    <tr>
        <td>sdegeo:break-nearly-axis-aligned-edges</td>
        <td>Breaks nearly axis-aligned edges into horizontal or vertical components.</td>
    </tr>
    <tr>
        <td>sdegeo:delete-collinear-edges</td>
        <td>Deletes collinear edges.</td>
    </tr>
    <tr>
        <td>sdegeo:delete-edges</td>
        <td>Deletes specified edges.</td>
    </tr>
    <tr>
        <td>sdegeo:delete-nearly-collinear-edges</td>
        <td>Deletes nearly collinear edges.</td>
    </tr>
    <tr>
        <td>sdegeo:delete-short-edges</td>
        <td>Deletes all edges from an edge list that are shorter than the specified value.</td>
    </tr>
    <tr>
        <td>sdegeo:delete-vertices</td>
        <td>Deletes specified list of vertices.</td>
    </tr>
    <tr>
        <td>sdegeo:del-short-edges</td>
        <td>Deletes short edges.</td>
    </tr>
    <tr>
        <td>sdegeo:max-edge-length</td>
        <td>Computes the longest edge length (for an edge list).</td>
    </tr>
    <tr>
        <td>sdegeo:min-edge-length</td>
        <td>Computes the shortest edge length (for an edge list).</td>
    </tr>
    <tr>
        <td>sdegeo:prune-vertices, sdegeo:dnce</td>
        <td>Deletes nearly collinear points.</td>
    </tr>
    <tr>
        <td>sdegeo:vsmooth</td>
        <td>Vertex smoothing in two dimensions.</td>
    </tr>
  </tbody>
</table>

**NOTE** Both `sdegeo:del-short-edges` and `sdegeo:prune-vertices` are very fast and robust. Use them to clean up 2D boundaries.

---

# Drawing Basic 3D Shapes

This section discusses how to draw basic three-dimensional shapes.

---

## Drawing Cuboids

To draw a cuboid:

1. Choose **Draw** > **3D Create Tools** > **Create Cuboid**, or click the corresponding toolbar button (see Table 11 on page 13).

2. Drag to draw the diagonal of the xy rectangle in the view window.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>69</page_number>

# 4: Generating Geometric Structures

Drawing Basic 3D Shapes

3. Release the mouse button and move the pointer to the top z-coordinate of the cuboid and click.

4. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the first vertex and second vertex of the space diagonal.

The corresponding Scheme command is:

```
(sdegeo:create-cuboid position position material-name region-name)
```

For example:

```
(sdegeo:create-cuboid (position 0 0 0) (position 1 2 3) "Silicon"
"R.Substrate")
```

> **NOTE** In interactive mode, the base rectangle is always drawn in the z = 0 xy plane. To start on a different plane, change the work plane as discussed in Work Planes on page 117. Use the isometric view to visualize all GUI operations (see Table 6 on page 11). Snapping is not supported in three dimensions.

---

# Drawing Cylinders

To draw a cylinder:

1. Choose **Draw** > **3D Create Tools** > **Create Cylinder**, or click the corresponding toolbar button (see Table 11 on page 13).

2. Drag to draw the radius of the base xy circle in the view window.

3. Release the mouse button and move the pointer to the top z-coordinate of the cylinder and click.

4. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the first vertex and second vertex of the center axis as well as the radius.

The corresponding Scheme command is sdegeo:create-cylinder on page 602. For example:

```
(sdegeo:create-cylinder (position 0 0 0) (position 0 0 1) 2 "Silicon"
"region_1")
```

> **NOTE** In interactive mode, the base circle is always drawn in the z = 0 xy plane. To start on a different plane, change the work plane as discussed in Work Planes on page 117. Use the isometric view to visualize all GUI operations (see Table 6 on page 11).

<page_number>70</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures

Drawing Basic 3D Shapes

# Drawing Spheres

To draw a sphere:

1. Choose **Draw** > **3D Create Tools** > **Create Sphere**, or click the corresponding toolbar button (see Table 11 on page 13).

2. Drag to draw the radius of the base xy circle in the view window.

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the center of the sphere as well as the radius.

The corresponding Scheme command is sdegeo:create-sphere on page 620. For example:

```
(sdegeo:create-sphere (position 0 0 2) 2 "Silicon" "region_1")
```

**NOTE** In interactive mode, the base circle is always drawn in the XY plane at Z = 0. To start on a different plane, change the work plane as discussed in Work Planes on page 117.

# Drawing Ellipsoids

To draw an ellipsoid:

1. Choose **Draw** > **3D Create Tools** > **Create Ellipsoid**, or click the corresponding toolbar button (see Table 11 on page 13).

2. Drag to draw the main axis of the ellipsoid in the xy plane in the view window.

3. Release the mouse button and move the pointer to define the secondary axis of the ellipsoid and click.

4. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates of the center of the ellipsoid, the endpoint of the major axis, as well as the ratio between the major and the minor axes. (The two minor axes are degenerate.)

The corresponding Scheme command is sdegeo:create-ellipsoid on page 605. For example:

```
(sdegeo:create-ellipsoid (position 1 2 3) (position 1 2 5) 2 "Silicon"
 "region_1")
```

**NOTE** In interactive mode, the major axis is always drawn in the Z = 0 XY plane. To start on a different plane, change the work plane as discussed in Work Planes on page 117. Use the isometric view to visualize all GUI operations (see Table 6 on page 11).

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>71</page_number>

# 4: Generating Geometric Structures

Drawing Basic 3D Shapes

## Drawing Other Basic 3D Shapes

Other basic 3D shapes are available through the following Scheme extensions:

* `sdegeo:create-cone` (see sdegeo:create-cone on page 599)

* `sdegeo:create-prism` (see sdegeo:create-prism on page 614)

* `sdegeo:create-pyramid` (see sdegeo:create-pyramid on page 615)

* `sdegeo:create-torus` (see sdegeo:create-torus on page 622)

## Import Capability of User-Defined Data

The `build-csv-lens` Scheme extension can be used to create a solid body from user-defined data. The input data file is a comma-separated value (CSV) file, which defines the user data over a tensor grid. The solid body is created from the parsed CSV data by stitching the faces together into a water-tight solid body. Figure 31 shows a solid body created using the extension `build-csv-lens`.

Solid body created using build-csv-lens

Figure 31 Solid body created using build-csv-lens, using the sin(x)*cos(y) analytic function defining the CSV data points on a 20x20 tensor grid

<page_number>72</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**
Drawing Basic 3D Shapes

# Creating a Layered Lens Structure

The `afm-smooth-layers` Scheme extension can create a layered lens structure with a texture map. The texture map is defined in a comma-separated value (CSV) file. Figure 32 shows an example, created using `afm-smooth-layers` and the Scheme code that follows.

Example of a layered structure created using the afm-smooth-layers command

Figure 32 Example of a layered structure created using the afm-smooth-layers command

Scheme example for the usage of `afm-smooth-layers`:

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
    (define yp (* (sin (* j (/ a n))) (cos (* i (/ a n)))))
    (display yp oport)
    (if (not (equal? j n))
        (display ", " oport))
  )
  (display "\n" oport)
)
(close-output-port oport)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>73</page_number>

# 4: Generating Geometric Structures

Drawing Basic 3D Shapes

```scheme
(sde:clear)
(define layermaterial (list "TCO" "Copper" "PolySi"))
(define layerregion (list "tco" "copper" "polysi"))
(define layerthickness (list 2 2 2))
(sdegeo:create-cuboid (position 0 0 0) (position (* 2 PI) (* 2 PI) 4)
  "Silicon" "xx")
(afm-smooth-layers "xx.csv" 0 4 layerregion layermaterial layerthickness)
```

# Creating a Solid Body From Faces

User-defined data (vertex points and a face list) also can be used to define 3D solid bodies. The faces must enclose a watertight volume (no gaps or overlaps are allowed between the faces). The `entity:stitch` Scheme extension can be used to build a solid body from the sheet bodies, which must be created first for each face.

The following script creates a tetrahedron with vertices (0,0,0), (1,0,0), (0,1,0) and (0,0,1):

```scheme
(sde:clear)

;; Define the vertex points
(define p0 (position 0 0 0))
(define p1 (position 1 0 0))
(define p2 (position 0 1 0))
(define p3 (position 0 0 1))

;; Create sheet (2d polygonal) bodies for each face
;; (face orientation does not matter)
(define f0 (sheet:2d (sheet:planar-wire (wire-body:points
  (list p0 p1 p2 p0)))))
(define f1 (sheet:2d (sheet:planar-wire (wire-body:points
  (list p0 p1 p3 p0)))))
(define f2 (sheet:2d (sheet:planar-wire (wire-body:points
  (list p1 p2 p3 p1)))))
(define f3 (sheet:2d (sheet:planar-wire (wire-body:points
  (list p0 p2 p3 p0)))))

;; Stitch the faces together to create a solid body
(define mb (car (entity:stitch (list f0 f1 f2 f3))))
(sde:add-material mb "Copper" "mytetrahedron")

;; If the sheet bodies define a watertight enclosure,
;; the solid body will pass the entity:checker and
;; can be used for additional operations (Booleans and so on)
```

<page_number>74</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 3D Shapes

# Editing 3D Shapes

This section discusses how to edit 3D shapes.

## Chamfering Edges

To chamfer (flatten) the edges of a 3D structure:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Edge** (or **Select Vertex**).

3. Select the edge (or vertex) and hold the Shift key to select additional edges (or vertices), or drag a box around a set of edges (or vertices).

4. Choose **Edit** > **3D Edit Tools** > **Chamfer**.

5. Enter a chamfer distance in the dialog box.

If the parameter `chamfer-dist` was set before performing this operation (choosing **Edit** > **Parameters**), this dialog box is suppressed, and the given value of `chamfer-dist` is used instead.

The optional `adaptive-chamfering` Boolean argument can be used to perform adaptive chamfering. If this option is used and the argument is set to `#t`, then if the chamfering operation fails using the original `chamfer-dist` value, the operation is repeated with a sequence of chamfering operations, using an adaptive approach, to set the chamfer distance to smaller values until the operation succeeds.

The corresponding Scheme command is:

```scheme
(sdegeo:chamfer edge | vertex-list chamfer-dist [adaptive-chamfering])
```

For example:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silicon" "region_1")
(sdegeo:chamfer (list
  (car (find-vertex-id (position 0 0 1)))
  (car (find-vertex-id (position 0 1 1)))
  (car (find-vertex-id (position 1 0 1)))
  (car (find-vertex-id (position 1 1 1)))) 0.2)
```

**NOTE** If `chamfer-dist` is too large such that two adjacent chamfers would overlap, then the operation will fail.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>75</page_number>

# 4: Generating Geometric Structures

Editing 3D Shapes

Three-dimensional chamfering operation showing a cuboid and a chamfered cuboid

Figure 33 Three-dimensional chamfering operation: (*left*) original cuboid (1 x 1 x 1) and (*right*) chamfer-dist=0.2

---

# Rounding Edges

To round the edges of a 3D structure:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Edge** (or **Select Vertex**).

3. Select the edge (or vertex) and hold the Shift key to select additional edges (or vertices), or drag a box around a set of edges (or vertices).

4. Choose **Edit > 3D Edit Tools > Fillet**.

5. Enter a fillet radius in the dialog box.

   If the parameter `fillet-radius` was set before performing this operation (choosing **Edit > Parameters**), this dialog box is suppressed, and the given value of `fillet-radius` is used instead.

The optional `adaptive-filleting` Boolean argument can be used to perform adaptive filleting. If this option is used and the argument is set to `#t`, then if the filleting operation fails using the original `fillet-radius` value, the operation is repeated with a sequence of filleting operations, using an adaptive approach, to set the fillet radius to smaller values until the operation succeeds.

The corresponding Scheme command is:

```scheme
(sdegeo:fillet edge | vertex-list fillet-radius [adaptive-filleting])
```

<page_number>76</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Editing 3D Shapes

For example:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silicon" "region_1")
(sdegeo:fillet (list
   (car (find-vertex-id (position 0 0 1)))
   (car (find-vertex-id (position 0 1 1)))
   (car (find-vertex-id (position 1 0 1)))
   (car (find-vertex-id (position 1 1 1)))) 0.2)
```

and:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silicon" "region_1")
(sdegeo:fillet (list (car (find-edge-id (position 0 0 0.5)))) 0.2)
```

**NOTE** If fillet-radius is too large such that two adjacent fillets overlap, the operation will fail.

Three-dimensional edge filleting diagrams showing a cuboid, a rounded corner, and a rounded edge

Figure 34 Three-dimensional edge filleting: (*left*) original cuboid (1 x 1 x 1), (*middle*) rounded corner, and (*right*) rounded edge with fillet-radius=0.2

---

# Tapering

To taper one or more faces of a 3D structure:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select the face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Edit > 3D Edit Tools > Taper**.

5. Enter the draft plane center, the draft plane normal, and the draft angle in the Taper Faces dialog box (see Figure 35 on page 78).

Sentaurus™ Structure Editor User Guide S-2021.06

<page_number>77</page_number>

# 4: Generating Geometric Structures

Editing 3D Shapes

The Taper Faces dialog box is initialized with the following default values: If only one face is selected, the draft plane center is initialized, using the barycentric coordinates of the selected face.

Taper Faces dialog box

Figure 35 Taper Faces dialog box

If more than one face is selected:

*   The draft plane center point is initialized as 0,0,0.

*   The draft plane normal is initialized as 0,0,1.

*   The draft angle is initialized to 5°.

The corresponding Script command is:

```
(sdegeo:taper-faces face-list point normal angle)
```

The tapering algorithms are discussed using simple examples.

Figure 36 on page 79 (a) shows a cuboid where the side face to be tapered is blue. For reference, the normal vector of this face is also shown.

The tapering is performed with respect to an auxiliary plane, the so-called draft plane. This plane is defined by the draft plane center point and the draft plane normal vector. Figure 36 (b) shows the draft plane in green together with the draft plane normal vector originating from the draft plane center point. In addition, the rotation axis, which is defined as the intersection between the face plane (blue) and the draft plane (green), is shown.

With respect to these planes and axes, now two distinct rotations are performed. Figure 36 (c) shows the new face location after the first rotation (equivalent to tapering with an angle of 0°). The face is rotated around the axis such that the new face is orthogonal to the draft plane.

Figure 36 (d) shows the face after the second rotation, with an angle of 45°. The rotation direction is given by the *right-hand rule*: To determine the direction of the axis, align the thumb

<page_number>78</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures

Editing 3D Shapes

of your right hand with the face plane normal and the index finger with the draft plane normal. Then extend your middle finger orthogonally to both. This finger points now in the direction of the axis vector. Now, point the thumb of your right hand into the axis direction and form a fist with all other fingers. These fingers now curl like a rotation with a positive angle.

Tapering example diagrams showing a cuboid and a draft plane in four stages (a, b, c, d).

Figure 36 Tapering example

The following Scheme commands produced the graphics in Figure 36:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 -0.5) (position 1.0 2.0 0.5) "Silicon"
       "region_1")
(define FACE (find-face-id (position 0.0 0.5 0.0)))
(entity:set-color FACE BLUE)
(define FACE_CENTER (cdr (list-ref (face:prop (car FACE)) 2)))
(define FACE_NORMAL (face:plane-normal (car FACE)))
(wire-body:points
       (list FACE_CENTER (position:offset FACE_CENTER FACE_NORMAL)))
; Figure (a)
(define DRAFT_CENTER (position -1.0 0.0 0.0))
(define DRAFT_NORMAL (gvector -1.0 2.0 0.0))
(wire-body:points
       (list DRAFT_CENTER (position:offset DRAFT_CENTER DRAFT_NORMAL)))
(face:planar-disk DRAFT_CENTER DRAFT_NORMAL 2)
(wire-body:points (list (position 0.0 0.5 -2.0) (position 0.0 0.5 2.0)))
; Figure (b)
```

Sentaurus™ Structure Editor User Guide

<page_number>79</page_number>

S-2021.06

# 4: Generating Geometric Structures

Editing 3D Shapes

```scheme
(sdegeo:taper-faces FACE DRAFT_CENTER DRAFT_NORMAL 0)
; Figure (c)
(sdegeo:taper-faces FACE DRAFT_CENTER DRAFT_NORMAL 45)
; Figure (d)
```

The tapering process, based on two independent rotations, allows you to perform two distinct types of taper operation. The first type of tapering results in truncated pyramid–type shapes, where, for example, all faces are bent inwards. For this kind of tapering, the draft normal vector is orthogonal to the face normal vectors and the rotation angle is nonzero.

**For example:**

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1.0) "Silicon"
 "region_1")
(sdegeo:taper-faces (list
 (car (find-face-id (position 0.5 0.0 0.5)))
 (car (find-face-id (position 1.0 0.5 0.5)))
 (car (find-face-id (position 0.5 1.0 0.5)))
 (car (find-face-id (position 0.0 0.5 0.5))))
 (position 0.5 0.5 0.5) (gvector 0 0 1) 30)
```

Figure 37 shows a unit cube after applying truncated pyramid–type tapering.

Diagram showing a unit cuboid on the left and a truncated pyramid shape on the right after tapering

Figure 37 Truncated pyramid–type tapering: (*left*) original cuboid and (*right*) after truncation

Figure 38 illustrates the effect of the use of different draft plane centers. For the operations, the same draft plane normal and draft angle were used.

Diagram illustrating the effect of different draft plane centers on tapering, showing three squares with different rotation points, labeled with Draft Plane Normal, Draft Angle, and Draft Plane Center

Figure 38 Draft plane center

<page_number>80</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 3D Shapes

The second type of tapering is similar to applying a sheer force to the body. For this kind of tapering, the draft normal vector is not orthogonal to the face normal vectors, but the rotation angle is zero. For example:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1.0) "Silicon"
 "region_1")
(sdegeo:taper-faces (list
 (car (find-face-id (position 0.5 0.0 0.5)))
 (car (find-face-id (position 1.0 0.5 0.5)))
 (car (find-face-id (position 0.5 1.0 0.5)))
 (car (find-face-id (position 0.0 0.5 0.5))))
 (position 0.5 0.5 0.5) (gvector 0.5 0.5 1) 0)
```

Figure 39 shows a unit cube after applying sheer-type tapering.

Sheer-type tapering illustration showing a cuboid before and after the operation

Figure 39 Sheer-type tapering: (*left*) original cuboid and (*right*) after tapering

Even more general tapering can be obtained by mixing both fundamental types.

**NOTE** The taper operation can result in a geometric shape that is no longer closed. In this case, so-called vent faces are added automatically such that the resulting shape is closed.

Vent faces can only be added if there is a face on the original model that shares a vertex with the ‘mergeable’ edge, that does not have the mergeable edge in its boundary, and that will be adjacent to the vent faces after the taper. Vent faces can also be added at tangent edges when one of the two faces that share the edge is being tapered. However, a vent face will only be added if there is no intersection between the surface of the face that is being tapered and the surface of the face that is not being tapered.

Sentaurus™ Structure Editor User Guide

<page_number>81</page_number>

S-2021.06

# 4: Generating Geometric Structures

Editing 3D Shapes

3D models showing topology change during face tapering

Figure 40 Topology change during face tapering

Figure 41 shows a structure generated by the following script:

```scheme
(sdegeo:set-default-boolean "ABA")
(define r1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 10) "Silicon"
 "region_1"))
(define r2 (sdegeo:create-cuboid (position 2 2 8) (position 8 8 12)
 "PolySilicon" "region_2"))
(sdegeo:delete-region (find-body-id (position 5 5 11)))
(define facelist (list (car (find-face-id (position 2 5 9)))
 (car (find-face-id (position 8 5 9)))
 (car (find-face-id (position 5 2 9)))
 (car (find-face-id (position 5 8 9)))))
(sdegeo:taper-faces facelist (position 5 5 9) (gvector 0 0 1) 30)
```

3D models before and after face tapering

Before Face Tapering After Face Tapering

Figure 41 Face tapering

Figure 42 on page 83 shows the structure generated by the following script:

```scheme
; Initial model
(sdegeo:set-default-boolean "ABA")
(define r1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 10) "Silicon"
 "region_1"))
(define r2 (sdegeo:create-cuboid (position 0 0 10) (position 10 10 20)
 "PolySilicon" "region_2"))
; Step 1
```

<page_number>82</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Creating 3D Objects From 1D and 2D Objects

```scheme
(define facelist (list (car (find-face-id (position 0 5 5)))
  (car (find-face-id (position 10 5 5)))))
(sdegeo:taper-faces facelist (position 5 5 5) (gvector 0 0 1) 30)
; Step 2
(define facelist (list (car (find-face-id (position 5 0 5)))
  (car (find-face-id (position 5 10 5)))))
(sdegeo:taper-faces facelist (position 5 5 5) (gvector 0 0 1) 30)
; Step 3
(define facelist (list (car (find-face-id (position 0 5 15)))
  (car (find-face-id (position 10 5 15)))))
(sdegeo:taper-faces facelist (position 5 5 15) (gvector 0 0 1) -30)
; Step 4
(define facelist (list (car (find-face-id (position 5 0 15)))
  (car (find-face-id (position 5 10 15)))))
(sdegeo:taper-faces facelist (position 5 5 15) (gvector 0 0 1) -30)
```

<table>
  <thead>
    <tr>
        <th>Initial Model</th>
        <th>Step 1</th>
        <th>Step 2</th>
        <th>Step 3</th>
        <th>Step 4</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Initial Model</td>
        <td>Step 1</td>
        <td>Step 2</td>
        <td>Step 3</td>
        <td>Step 4</td>
    </tr>
  </tbody>
</table>

Figure 42 Face tapering

---

# Creating 3D Objects From 1D and 2D Objects

This section describes how to create 3D objects from 1D and 2D objects.

---

## Wires

A wire is a 1D object that is used to define a sweep path or a wire body for skinning.

To draw a piecewise linear wire (polyline):

1. Choose **Draw** > **2D Create Tools** > **Polyline**, or click the corresponding toolbar button (see Table 9 on page 12).

2. Click at each vertex of the polyline. To finish drawing the polyline, click the middle mouse button. (Press both buttons when using a two-button mouse.)

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>83</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

3. In Exact Coordinates mode, a dialog box is displayed where you enter the coordinates for each vertex.

The corresponding Scheme command is:

```scheme
(sdegeo:create-polyline-wire vertex-list)
```

For example:

```scheme
(sdegeo:create-polyline-wire (list
  (position 0.0 0.0 0.0) (position 1.0 0.0 0.0) (position 1.0 1.0 0.0)
  (position 1.0 1.0 1.0) (position 0.0 1.0 1.0) (position 0.0 1.0 0.0)))
```

To draw a spline interpolated wire, choose **Draw** > **2D Create Tools** > **Spline**, or click the corresponding toolbar button (see Table 9 on page 12).

The corresponding Scheme command is:

```scheme
(sdegeo:create-spline-wire vertex-list)
```

For example:

```scheme
(sdegeo:create-spline-wire (list
  (position 0.0 0.0 0.0) (position 1.0 0.0 0.0) (position 1.0 1.0 0.0)
  (position 1.0 1.0 1.0) (position 0.0 1.0 1.0) (position 0.0 1.0 0.0)))
```

# Extruding

To extrude a 2D object or a face of a 3D object:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select the face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Edit** > **3D Edit Tools** > **Extrude**.

5. Enter an extrusion distance in the dialog box.

> If the parameter `hext` was set before performing this operation (choosing **Edit** > **Parameters**), this dialog box is suppressed, and the given value of `hext` is used instead.

<page_number>84</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

Menu for extrusion

Extrusion dialog box

Figure 43 (Left) Menu for extrusion and (right) Extrusion dialog box

The corresponding Scheme command is:

`(sdegeo:extrude entity-list hext)`

For example:

```
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.2 1.0 0)
  "Silicon" "region_1")
(sdegeo:create-rectangle (position 0.4 1.0 0) (position 0.8 1.1 0)
  "Oxide" "region_2")
(sdegeo:create-rectangle (position 0.4 1.1 0) (position 0.8 1.5 0)
  "PolySilicon" "region_3")
(sdegeo:extrude (list (car (find-face-id (position 0.6 0.5 0)))) 0.8)
(sdegeo:extrude (list
  (car (find-face-id (position 0.6 1.05 0)))
  (car (find-face-id (position 0.6 1.2 0)))) 0.4)
```

Different extrusion distances can be used for different regions.

In general, the extrusion direction is given by the face normal. For 2D objects, which are created in the xy plane by default, the face normal is defined to point along the z-axis.

**NOTE** Negative extrusion values, applied to 3D faces, generate an invalid geometry.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>85</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

Figure 44 illustrates the extrusion operation for 2D devices.

Creating an extruded 3D model from a 2D device with different extrusion lengths

Figure 44 Creating an extruded 3D model from a 2D device; the extrusion length can different

Example of face extrusion in a 3D object showing extruded faces

Figure 45 Example of face extrusion in a 3D object

---

## Sweeping a 2D Object

A 3D object can be created by sweeping a 2D object along a path. A 3D object can also be modified by sweeping a set of faces of the 3D object. The sweep path can be defined in several different ways. In the simplest case, only the sweep distance is given and the sweep direction will be normal to the face. The sweep distance and sweep direction can also be defined using a sweep vector. In addition, the sweep path can be defined by a rotation around an axis or explicitly by a wire body.

Sweeping and extruding can also be applied to Ref/Eval windows. If a swept Ref/Eval window is used to place a submesh doping profile, information about the sweep creation is stored in the `.cmd` file, so that the mesh generator can evaluate the swept 2D doping profile in three dimensions.

<page_number>86</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Creating 3D Objects From 1D and 2D Objects

In the case of other doping profile types, the resulting swept Ref/Eval window (without sweep information) is stored in the `.cmd` file, requiring that these elements must be valid reference elements (doping baseline elements) or evaluation windows. The sweep operation transforms the 2D edge contacts to 3D face contacts.

The sweep options allow additional control over the sweeping behavior and enable drafting, twisting, and other advanced behaviors.

Sweeping is a complex operation involving several different types. In the following sections, the supported sweep types are introduced.

## Sweep Distance

The sweep distance operation is similar to extrusion. Faces of 2D bodies or 3D bodies can be swept by a distance. The sweep distance option can be used with various sweep options.

To sweep a 2D object or a face of a 3D object using distance sweeping:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select the face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Edit** > **3D Edit Tools** > **Sweep**.

   The Sweep Operations dialog box is displayed.

5. Click **Select Profiles**. The entity IDs of the selected profiles are displayed in the **Sweep Profiles** field.

6. Click the **Sweep Distance** tab.

7. Select the **Selected Sweep Method** option.

8. Enter a sweep distance.

9. Select sweep options as needed (see Sweep Options on page 96).

10. Click **OK**.

Figure 46 on page 88 shows the Sweep Operations dialog box with the **Selected Sweep Method** option selected. Figure 47 on page 89 shows the effect of a sweep distance operation, together with the use of the draft angle option. When a draft angle is used during a sweep operation, additional faces must be added to the model if the `gap_type` sweep option is ‘extended’ or ‘rounded.’

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>87</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

Sweep Operations dialog box showing Sweep Distance tab

Figure 46 Sweep Operations dialog box showing Sweep Distance tab

The corresponding Scheme command is:

```scheme
(sdegeo:sweep face|face-list distance [sweep-options])
```

The examples in Figure 47 on page 89 are generated using the following Scheme commands:

```scheme
(define FACE (sdegeo:create-reg-polygon (position 0 0 0) 1 6 0 "Oxide"
 "region_1"))
(sdegeo:translate-selected FACE (transform:translation (gvector 3 2 0)) #t 3)
(sdegeo:sweep (sde:find-reg-region "region_1_t1_r1") 0.6
 (sweep:options "solid" #t "rigid" #f "miter_type" "default"
 "draft_angle" 40.0 "gap_type" "extended"))
(sdegeo:sweep (sde:find-reg-region "region_1_t1_r2") 0.6
 (sweep:options "solid" #t "rigid" #f "miter_type" "default"
 "draft_angle" 40.0 "gap_type" "rounded"))

(sdegeo:sweep (sde:find-reg-region "region_1_t1_r3") 0.6
 (sweep:options "solid" #t "rigid" #f "miter_type" "default"
 "draft_angle" 40.0 "gap_type" "natural"))
```

<page_number>88</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

Draft Angle Initial 2D Body Extended Faces Rounded Faces ‘Natural’ Condition

Figure 47 Sweep distance with a draft angle (40º) using different gap-type options

## Sweep Along a Vector

The sweep along a vector option is similar to the sweep distance option, except that a vector is specified to define the sweep path.

To sweep a 2D object or a face of a 3D object using vector sweeping:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select the face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Edit > 3D Edit Tools > Sweep**.

The Sweep Operations dialog box is displayed.

5. Click **Select Profiles**. The entity IDs of the selected profiles are displayed in the **Sweep Profiles** field.

6. Click the **Sweep Along Vector** tab.

7. Select **Selected Sweep Method**.

8. Enter the x-, y-, and z-coordinates of the sweep vector.

9. Select sweep options as needed (see Sweep Options on page 96).

10. Click **OK**.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>89</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

Sweep Operations dialog box showing Sweep Along Vector tab

Figure 48 Sweep Operations dialog box showing Sweep Along Vector tab

The corresponding Scheme command is:

```scheme
(sdegeo:sweep face|face-list gvector [sweep-options])
```

The examples in Figure 49 on page 91 are generated using the following Scheme commands:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Oxide" "region_1")
(sdegeo:sweep (find-face-id (position 0.5 1 0.5)) (gvector 0.5 0.5 0)
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"))
(sdegeo:sweep (find-face-id (position 1.0 1.5 0.5)) (gvector -0.5 0.5 0)
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"))
```

<page_number>90</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

Sweep along a vector diagram showing selected faces and sweep vectors

Figure 49 Sweep along a vector

## Sweep Around an Axis (Regular and Corner Sweeps)

The sweep around an axis option can be used to sweep a face (2D or 3D) around an axis. The sweep can be regular or such that only the inside edge is swept, while the outside edge forms an axis-aligned corner.

### Regular Sweep

To sweep a 2D object or a face of a 3D object using regular sweeping around an axis:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select the face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Edit > 3D Edit Tools > Sweep**.

The Sweep Operations dialog box is displayed.

5. Click **Select Profiles**.

The entity IDs of the selected profiles are displayed in the Sweep Profiles field.

6. Click the **Sweep Around Axis** tab.

7. Select **Selected Sweep Method**.

8. Define the axis of rotation by entering a point on the axis and a direction vector, or click **Pick Position** and click a point in the view window. In this case, the rotation axis will point into the current view plane.

9. Enter the sweep angle. (Do not select the Sweep Corner option.)

Sentaurus™ Structure Editor User Guide

<page_number>91</page_number>

S-2021.06

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

10. Select sweep options as needed (see Sweep Options on page 96).

11. Click **OK**.

Sweep Operations dialog box showing Sweep Around Axis tab

Figure 50 Sweep Operations dialog box showing Sweep Around Axis tab

The corresponding Scheme command is:

```scheme
(sdegeo:sweep face|face-list position gvector
  (sweep:options "sweep_angle" angle [other-sweep-options]))
```

The examples in Figure 51 on page 93 are generated using the following Scheme commands:

```scheme
(sdegeo:create-rectangle (position 0 0 0.0) (position 1 2 0.0) "Silver"
  "region_1")
(define NEWVERT (sdegeo:insert-vertex (position 0.5 2 0)))
(sdegeo:move-vertex NEWVERT (position 0.5 2.3 0))
(sdegeo:fillet-2d (sde:window-select-2d -0.1 1.9 1.1 2.4 "all" "vertex") 0.2)
(sdegeo:translate-selected (find-body-id (position 0.5 0.5 0))
  (transform:translation (gvector 2 0 0)) #t 2)
(sdegeo:sweep (find-face-id (position 2.5 0.5 0)) (position 2 0 0)
  (gvector 0 1 0)
  (sweep:options "solid" #t "sweep_angle" 60 "rigid" #f "miter_type"
```

<page_number>92</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Creating 3D Objects From 1D and 2D Objects

```scheme
"default"))
(sdegeo:sweep (find-face-id (position 4.5 0.5 0)) (position 3 0 0)
  (gvector 0 1 0)
  (sweep:options "solid" #t "sweep_angle" 40 "rigid" #f "miter_type"
  "default"))
```

Three 3D models illustrating different sweep options: Initial Face, Sweep Around Existing Vertex, and Sweep Around a Position.

Figure 51 Sweeping around an axis using different options

## Corner Sweep

Use this option to design crown moldings, corbels, and so on.

To perform a corner sweep:

1. Follow the procedure in Regular Sweep on page 91.

2. In Step 9, select **Sweep Corner**.

3. Enter or pick a point on the sweep axis.

The axis direction is determined automatically, and the sweep angle for corner sweeps is always 90°.

The sweep is performed in such a way that the resulting shape contains a solid angle.

**NOTE** If the selection of the sweep axis does not allow for the creation of a solid angle, the sweep operation is suppressed.

The corresponding Scheme command is:

```scheme
(sdegeo:sweep-corner face|face-list position gvector)
```

Sentaurus™ Structure Editor User Guide

<page_number>93</page_number>

S-2021.06

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

The example in Figure 52 is generated using the following Scheme commands:

```scheme
(sdegeo:create-rectangle (position 0 0 0.0) (position 1 2 0.0) "Silver"
  "region_1")
(define NEWVERT (sdegeo:insert-vertex (position 0.5 2 0)))
(sdegeo:move-vertex NEWVERT (position 0.5 2.3 0))
(sdegeo:fillet-2d (sde:window-select-2d -0.1 1.9 1.1 2.4 "all" "vertex") 0.2)
(sdegeo:sweep-corner (find-face-id (position 0.5 0.5 0))
  (position -0 4 0) (gvector 1 0 0))
```

Corner sweeping around an axis engineering drawing

Figure 52 Corner sweeping around an axis; the initial profile is the same as in Figure 51

## Sweep Along a Wire

To sweep a profile along a wire, first, the wire body must be generated either manually by using Scheme functions or by using the GUI. To create a wire, see Wires on page 83.

To sweep a profile along a wire:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select the face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Edit > 3D Edit Tools > Sweep**.

    The Sweep Operations dialog box is displayed.

5. Click **Select Profiles**.

    The entity IDs of the selected profiles are displayed in the **Sweep Profiles** field.

6. Click the **Sweep Along Wire** tab.

<page_number>94</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**4: Generating Geometric Structures**
Creating 3D Objects From 1D and 2D Objects

7. Select **Selected Sweep Method**.

8. From the Selection Level list, select **Select Edge**, and select the wire in the view window.

9. Click **Select Path**. The entity IDs of the selected wires are displayed in the **Sweep Path** field.

10. Select sweep options as needed (see Sweep Options on page 96).

11. Click **OK**.

Sweep Operations dialog box showing Sweep Along Wire tab

Figure 53 Sweep Operations dialog box showing Sweep Along Wire tab

The corresponding Scheme command is:

```scheme
(sdegeo:sweep face|face-list position gvector
  (sweep:options "sweep_angle" angle [other-sweep-options]))
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

95
</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

The example in Figure 54 is generated using the following Scheme commands:

```scheme
(define FACE (sdegeo:create-circle (position 0.0 0.0 0.0) 1.0
  "Silicon" "region_1"))
(define WIRE (sdegeo:create-spline-wire (list (position 0.0 0.0 0.0)
  (position 0.0 0.0 5.0) (position 0.0 5.0 5.0) (position 5.0 5.0 5.0))))
(sdegeo:sweep FACE WIRE (sweep:options "solid" #t "rigid" #f "miter_type"
  "default"))
(entity:delete WIRE)
```

Wire sweep: (left) initial profile with sweep wire and (right) final swept body

Figure 54 Wire sweep: (*left*) initial profile with sweep wire and (*right*) final swept body

## Sweep Options

The sweep operation can be performed with different options that affect the outcome of the operation. These options are controlled by the `sweep:options` command. For example, when a profile is swept along a path, the profile can remain parallel to the original profile (rigid sweep) or can follow the path in a more natural way, following the curvature of the path, remaining perpendicular to the path during sweeping. The following sections give an overview of the available sweep options.

## Rigid Sweep

A rigid sweep is one in which the profile that is swept is translated, but not rotated, along the sweep path. It accomplishes a rigid extrusion of a profile along a path. The `rigid` option specifies whether to make the cross sections of a sweep parallel to each other. The default is `FALSE`, which means the cross sections are perpendicular to the sweep path. No checks are made when a rigid sweep is performed; consequently, the resulting surface is self-intersecting if the given path is closed or if the direction of the path changes by more than 180°.

<page_number>96</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**
Creating 3D Objects From 1D and 2D Objects

## Mitering

The miter option determines how a corner miter is created during a sweep operation. The available mitering options are:

**new** Reflects the profile to the other side of the corner up to the discontinuous point. The two sides are then extended and intersected, and new edges are formed as necessary. The ‘ending’ profile is the same as the starting profile. The `new` option is the default mitering.

**old** Intersects the plane that is perpendicular to the path at the half angle of the corner. The resulting profile on the plane is then swept continuously along the path.

**crimp** Reflects the profile to the other side of the corner up to the discontinuous point. The portions of the two sides that do not intersect are connected using a smooth rotation about the discontinuous point.

**bend** Bend mitering requires the specification of a minimum radius to fillet the path. The result is a smooth, curved junction. The minimum radius must be positive.

The `new` setting makes the sweep operation create miters by sweeping each G1 part of the path with a copy of the profile and then filling in the gaps with linear-extended parts that are sliced at the miter planes.

The `crimp` setting creates miters between profiles swept along G1-continuous path segments, filling in gaps by revolving the profile.

*G1 continuity* refers to geometric continuity of the first degree (that is, the direction of the tangent vector is continuous). Two curves are G1-continuous at a given point if the directions of the tangent vectors at their joining point are the same, even though the vector magnitudes might differ (in the case of C1 continuity, the magnitudes are also the same). G1 continuity means that the tangent lines are smoothly connected.

Diagram showing three different mitering options for a corner sweep: 'new'/'old' (left), 'crimp' (middle), and 'bend' (right).

Figure 55 Mitering a corner with different options: (left) ‘new’ and ‘old’ give the same results for the given example, (middle) ‘crimp,’ and (right) ‘bend’

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

97
</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

The examples in Figure 55 on page 97 are created by the following Scheme commands:

```scheme
(define REC (sdegeo:create-rectangle
  (position -1.0 0.0 0.0) (position 1.0 1.0 0.0) "Silicon" "region_1"))
(define WIRE (sdegeo:create-polyline-wire (list (position 0.0 0.5 0.0)
  (position 0.0 0.5 3.0) (position 2.0 2.5 5.0))))

; (a): "new"
(sdegeo:sweep REC WIRE
  (sweep:options "solid" #t "rigid" #f "miter_type" "new"))
; (a): "old"
(roll)
(sdegeo:sweep REC WIRE
  (sweep:options "solid" #t "rigid" #f "miter_type" "old"))
; (b): "crimp"
(roll)
(sdegeo:sweep REC WIRE
  (sweep:options "solid" #t "rigid" #f "miter_type" "crimp"))
; (c) "bend"
(roll)
(sdegeo:sweep REC WIRE
  (sweep:options "solid" #t "rigid" #f "miter_type" "bend" 3.5))
```

## Sweeping Examples

The following example illustrates the creation of a simple MOSFET with a nonaxis-aligned gate stack using different sweep methods.

### Sweep Distance

The substrate with two shallow trench isolations is created by sweeping the 2D cross section a given distance:

```scheme
(define SUB (sdegeo:create-rectangle
  (position -2.0 0.0 0.0) (position 2.0 0.0 -1.0) "Silicon" "R.Sub"))
(sdegeo:set-default-boolean "ABA")
(define STI_L (sdegeo:create-rectangle
  (position -2.0 0.0 0.0) (position -1.6 0.0 -0.5) "Oxide" "R.STI_L"))
(define STI_R (sdegeo:create-rectangle
  (position 1.6 0.0 0.0) (position 2.0 0.0 -0.5) "Oxide" "R.STI_R"))
(sdegeo:sweep (list SUB STI_L STI_R) -4.0
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"))
```

<page_number>98</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

3D substrate with shallow trench isolations created by distance sweeping

Figure 56 Distance sweeping creates 3D substrate with shallow trench isolations

## Sweep Along a Vector

In a first version, the 2D gate-stack cross section is swept along a vector:

```scheme
(define GOX (sdegeo:create-rectangle
  (position -2.0 0.4 0.0) (position -2.0 1.2 0.1) "Oxide" "R.Gox"))
(define POL (sdegeo:create-rectangle
  (position -2.0 0.6 0.1) (position -2.0 1.0 0.5) "PolySilicon" "R.Pol"))
(sdegeo:sweep (list GOX POL) (gvector 4.0 2.4 0.0)
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"))
```

Gate stack profiles before and after vector sweeping

Figure 57 Vector sweeping creates a nonaxis-aligned gate stack: gate stack profiles (*left*) before vector sweeping and (*right*) after vector sweeping

## Sweep Along a Wire

In a second version, the 2D gate-stack cross section is swept along a wire:

```scheme
(roll)
(define WIRE (sdegeo:create-polyline-wire (list
  (position -2.0 0.8 0.5) (position -0.8 0.8 0.5)
  (position 0.8 3.2 0.5) (position 2.0 3.2 0.5))))
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>99</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

```
(sdegeo:sweep (list GOX POL) WIRE
  (sweep:options "solid" #t "rigid" #f "miter_type" "default"))
```

In a third version, the 2D gate-stack cross section is swept along a wire rigidly:

```
(roll)
(sdegeo:sweep (list GOX POL) WIRE
  (sweep:options "solid" #t "rigid" #t "miter_type" "default"))
```

In a final version, crimping is used to round the edges that are created along the sweep path:

```
(roll)
(sdegeo:sweep (list GOX POL) WIRE
  (sweep:options "solid" #t "rigid" #f "miter_type" "crimp"))
(entity:delete WIRE)
```

Three 3D models showing different wire sweeping results: default, rigid sweep, and crimping

Figure 58 Wire sweeping creates a meandering gate stack: (*left*) default, (*middle*) rigid sweep, and (*right*) crimping

## Sweep Around an Axis

The next example discusses the creation of a simple racetrack LDMOS structure using sweeping along a wire for the curved part and distance sweeping to add the straight parts:

```
(define LOCOS (sdegeo:create-polygon (list
  (position -0.6 0 0.0) (position -0.4 0 -0.2) (position 0.1 0 -0.2)
  (position 0.3 0 0.0) (position 0.6 0 0.0) (position 0.6 0 0.1)
  (position 0.3 0 0.1) (position 0.1 0 0.3) (position -0.4 0 0.3)
  (position -0.6 0 0.0)) "Oxide" "R.LOCOS"))
(define POLY (sdegeo:create-polygon (list
  (position -0.2 0 0.3) (position 0.1 0 0.3) (position 0.3 0 0.1)
  (position 0.6 0 0.1) (position 0.6 0 0.3) (position 0.4 0 0.3)
  (position 0.2 0 0.5) (position -0.2 0 0.5) (position -0.2 0 0.3))
  "PolySilicon" "R.Poly"))
(sdegeo:sweep (list LOCOS POLY) (position -1 0 0) (gvector 0 0 1)
  (sweep:options "solid" #t "sweep_angle" 90 "rigid" #f "miter_type"
  "default"))

(sdegeo:set-default-boolean "BAB")
(define SUB (sdegeo:create-cuboid
```

<page_number>100</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

```
    (position -1.0 0.0 0.0) (position 1.0 2.0 -1.0) "Silicon" "R.SUB"))

(sdegeo:sweep (list
    (car (find-face-id (position 0.0 0 -0.9)))
    (car (find-face-id (position 0.0 0 0.0)))
    (car (find-face-id (position 0.0 0 0.4)))) 2.0
    (sweep:options "solid" #t "rigid" #f "miter_type" "default"))
```

Creating a racetrack LDMOS using sweep around an axis

Figure 59 Creating a racetrack LDMOS using sweep around an axis

# Skinning

A skinning operation can be used to create a 3D body that interpolates a series of wires or faces. The given wires or faces define the cross sections to be interpolated by the resulting 3D body. There must be at least two wire bodies or faces to be selected. The wires can be open or closed. The wires are copies, that is, the originals remain. The wires can share endpoints and do not have to be C1 continuous.

## Default Skinning

To skin a set of wire bodies or 2D faces using the default options:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Choose **Edit** > **3D Edit Tools** > **Skin**.
   The Skinning Operations dialog box is displayed.

4. Select the first face or wire in the view window, and click **Get Wires/Faces**.
   The selected profile appears in the Wires list.

5. Repeat for all other wires and faces.

6. Enter additional skinning options as needed (go to [https://doc.spatial.com/](https://doc.spatial.com/) for a list of options).

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

101
</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

7. Select the **Delete Inputs** option if the initial profiles are to be deleted.

8. Click **OK**.

Skinning Operations dialog box

Figure 60 Skinning Operations dialog box

The corresponding Scheme command is:

```
(sdegeo:skin-wire face-list [skin-options])
```

The example in Figure 61 on page 103 (b) is generated using the following Scheme commands:

```
(define FACE_1 (sdegeo:create-ellipse (position 0 2 0) (position 1 2 0)
  0.5 "Silicon" "region_1"))
(sdegeo:set-active-work-plane "wp_yz")
(define FACE_2 (sdegeo:create-circle (position 2 1 2) 0.5
  "Silicon" "region_2"))
(sdegeo:set-active-work-plane "base")
(define FACES (list (car (entity:faces FACE_1)) (car (entity:faces FACE_2))))
(sdegeo:skin-wires FACES)
```

<page_number>102</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**
Creating 3D Objects From 1D and 2D Objects

Skinning option overview diagrams showing different skinning methods (a) through (f)

Figure 61 Skinning option overview: (a) initial faces, with guide used in (e); (b) default skinning; (c) skinning with first normal; (d) skinning with vectors, low magnitude; (e) skinning with vectors, high magnitude; and (f) skinning with guide

## Skinning With Normals

The default options automatically select the sweep tangent vectors at each of the profiles. To select the face normal as the sweep tangent vectors:

1. Select **Skin with Normals** in the Skinning Operations dialog box.

2. Select the face normals to be used as constraints from the list. The options are First_Normal, Last_Normal, Ends_Normal, or All_Normal.

The corresponding Scheme command is:

```scheme
(sdegeo:skin-wires-normal face-list normal-selector [skin-options])
```

The example in Figure 61 (c) is generated using the following Scheme commands:

```scheme
(define FACE_1 (sdegeo:create-ellipse (position 0 2 0) (position 1 2 0)
       0.5 "Silicon" "region_1"))
(sdegeo:set-active-work-plane "wp_yz")
(define FACE_2 (sdegeo:create-circle (position 2 1 2) 0.5
       "Silicon" "region_2"))
(sdegeo:set-active-work-plane "base")
(define FACES (list (car (entity:faces FACE_1)) (car (entity:faces FACE_2))))
(sdegeo:skin-wires-normal FACES "first_normal")
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

103
</page_number>

# 4: Generating Geometric Structures

Creating 3D Objects From 1D and 2D Objects

## Skinning With Vectors

Use the **Skin with Vectors** option to explicitly control sweep tangent vectors. For each vector, a magnitude is given, which controls how quickly the sweep direction can deviate from the given tangent vector away from the profile. For larger values, the sweep direction follows the tangent vector longer than for small values (see Figure 61 on page 103 (d) and (e)).

The corresponding Scheme command is:

```
(sdegeo:skin-wires-vectors faces-list gvector-list magnitude-list
  [skin-options])
```

The example in Figure 61 (d) is generated using the following Scheme commands:

```
(define FACE_1 (sdegeo:create-ellipse (position 0 2 0) (position 1 2 0)
  0.5 "Silicon" "region_1"))
(sdegeo:set-active-work-plane "wp_yz")
(define FACE_2 (sdegeo:create-circle (position 2 1 2) 0.5
  "Silicon" "region_2"))
(sdegeo:set-active-work-plane "base")
(define FACES (list (car (entity:faces FACE_1)) (car (entity:faces FACE_2))))
(sdegeo:skin-wires-vectors FACES
  (list (gvector -0.5 0 1) (gvector 1 0 -0.5))
  (list 2.0000 2.0000))
```

The example in Figure 61 (e) is generated with the same Scheme commands, but uses magnitudes of 10.0 instead of 2.0.

## Skinning With Guides

Similar to sweeping along a wire, a set of profiles can be skinned using a wire as a guide. To use this option:

1. Select **Skin with Guides** in the Skinning Operations dialog box.

2. Select the wire in the view window.

3. Click **Get Guide**.

The corresponding Scheme command is:

```
(sdegeo:skin-wire-guide face-list wire [skin-options])
```

The example in Figure 61 (f) is generated using the following Scheme commands:

```
(define FACE_1 (sdegeo:create-ellipse (position 0 2 0) (position 1 2 0)
  0.5 "Silicon" "region_1"))
(sdegeo:set-active-work-plane "wp_yz")
```

<page_number>104</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**4: Generating Geometric Structures**

Creating 3D Objects From 1D and 2D Objects

```scheme
(define FACE_2 (sdegeo:create-circle (position 2 1 2) 0.5 "Silicon"
  "region_2"))
(sdegeo:set-active-work-plane "base")
(define FACES (list (car (entity:faces FACE_1)) (car (entity:faces FACE_2))))
(define WIRE (sdegeo:create-spline-wire (list
  (position -1.0 2.0 0.0) (position -1.0 2.0 1.0) (position 0.0 1.0 2.0)
  (position 1.0 1.0 2.0) (position 2.0 1.5 1.0))))
  (position 0.8 3.2 0.5) (position 2.0 3.2 0.5))))
(sdegeo:skin-wires-guides FACES WIRE)
```

## Skinning Example

The following example illustrates how to use skinning to emulate line-edge roughness effects in a MOSFET gate stack. First, a set of perturbed wires for the polygate and the gate-oxide cross sections are created (see Figure 62 on page 106). Second, these wires are skinned and the substrate is added.

The example is generated using the following Scheme commands:

```scheme
(define index 0) (define PolWires (list)) (define OxiWires (list))
(define MakeWires (lambda (Xl Xr Yo)
  (define PWname (string-append "PolWire_" (number->string index)))
  (define OWname (string-append "OxiWire_" (number->string index)))
  (define PWname (sdegeo:create-polyline-wire (list
    (position      Xl      Yo 0.1) (position   Xr            Yo 0.1)
    (position (- Xr 0.1) Yo 0.5) (position (+ Xl 0.1) Yo 0.5)
    (position      Xl      Yo 0.1))))
  (define OWname (sdegeo:create-polyline-wire (list
    (position Xl Yo 0.0) (position Xr Yo 0.0) (position Xr Yo 0.1)
    (position Xl Yo 0.1) (position Xl Yo 0.0))))
  (set! index (+ index 1))
  (set! PolWires (append PolWires (list PWname)))
  (set! OxiWires (append OxiWires (list OWname)))
))

(MakeWires -0.20 0.20 0.0)
(MakeWires -0.23 0.18 0.2)
(MakeWires -0.19 0.22 0.4)
(MakeWires -0.16 0.16 0.6)
(MakeWires -0.20 0.20 0.8)

(define POL (sdegeo:skin-wires PolWires))
(sde:add-material POL "PolySilicon" "R.Pol")
(define OXI (sdegeo:skin-wires OxiWires))
(sde:add-material OXI "Oxide" "R.oxi")
(entity:delete PolWires)
(entity:delete OxiWires)
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>105</page_number>

# 4: Generating Geometric Structures

Editing 2D and 3D Structures

```scheme
(sdegeo:create-cuboid (position -0.8 0.0 0.0) (position 0.8 0.8 -1.0)
"Silicon" "R.SUB")
```

Skinning example of MOSFET with line-edge roughness: wire bodies and final structure

Figure 62 Skinning example of MOSFET with line-edge roughness: (*left*) wire bodies and (*right*) final structure

# Editing 2D and 3D Structures

This section discusses how to edit 2D and 3D structures.

## Explicit Boolean Operations

To perform Boolean operations on 3D (or 2D) regions:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Body**.

3. Select the body and hold the Shift key to select additional bodies, or drag a box around a set of bodies.

4. Choose **Edit > 3D Edit Tools** (or **2D Edit Tools**).

5. Select **Unite**, **Intersect**, or **Subtract**.

The following multiregion operations can be performed.

### Unite

Dissolves any internal boundaries that exist in touching or overlapping regions and results in one single region with the name of the first region selected before the unite operation was applied.

<page_number>106</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 2D and 3D Structures

The corresponding Scheme command is:

```scheme
(sdegeo:bool-unite body-list)
```

For example:

```scheme
(define A (sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 2.0 1.0 1.0)
  "Silicon" "region_1"))
(define B (sdegeo:create-cuboid (position 2.0 0.0 0.0) (position 3.0 3.0 1.0)
  "Silicon" "region_2"))
(sdegeo:bool-unite (list A B))
```

### Intersect

This operation is used if the direct ACIS Scheme functions are used to generate parts of the structure or if the automatic overlap resolution is disabled. The corresponding Scheme command is:

```scheme
(sdegeo:bool-intersect body-list)
```

For example:

```scheme
(sdegeo:set-default-boolean "XX")
(define A (sdegeo:create-rectangle (position 0.0 0.0 0) (position 3.0 2.0 0)
  "Silicon" "region_1"))
(define B (sdegeo:create-circle (position 2.5 1.5 0) 1 "Silicon" "region_2"))
(sdegeo:bool-intersect (list A B))
```

Diagram showing a rectangle and a circle overlapping (left) and their intersection (right)

Figure 63 Explicit Boolean intersection: (*left*) original structure and (*right*) after intersection

### Subtract

The first region in the body list is selected as the main region, then subsequent regions are subtracted from the main region. The corresponding Scheme command is:

```scheme
(sdegeo:bool-subtract body-list)
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

107
</page_number>

# 4: Generating Geometric Structures

Editing 2D and 3D Structures

For example:

```scheme
(sdegeo:set-default-boolean "XX")
(define A (sdegeo:create-rectangle (position 0.0 0.0 0) (position 2.0 1.0 0)
  "Silicon" "region_1"))
(define B (sdegeo:create-circle (position 0.5 0.8 0) 0.4
  "Silicon" "region_2"))
(define C (sdegeo:create-circle (position 1.5 0.2 0) 0.4
  "Silicon" "region_2"))
(sdegeo:bool-subtract (list A B C))
```

Explicit Boolean subtraction: (left) original structure and (right) after subtraction

Figure 64 Explicit Boolean subtraction: *(left)* original structure and *(right)* after subtraction

---

# Changing the Material of a Region

To change the material associated with a region or regions:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Body**.

3. Select the body and hold the Shift key to select additional bodies, or drag a box around a set of bodies.

4. Select the required material from the Material list.

5. Choose **Edit > Change Material**.

The corresponding Scheme command is:

```scheme
(sde:add-material [body | body-list] new-material-name region-name)
```

**NOTE** If a list with more than one body is used, all bodies will be assigned the same region name. Upon saving the boundary, the region will be made unique.

<page_number>108</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Editing 2D and 3D Structures

For example, to change the material but preserve the region name:

```scheme
(define A (sdegeo:create-rectangle (position 0.0 0.0 0) (position 3.0 2.0 0)
  "Silicon" "region_1"))
(sde:add-material A "PolySilicon" (generic:get A "region"))
```

# Changing the Name of a Region

To change the name of a region or regions:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Body**.

3. Select a single body.

4. Choose **Edit > Change Region Name**.

5. Type the new name in the dialog box.

The corresponding Scheme command is:

```scheme
(sde:add-material body material-name new-region_name)
```

For example, to change the region name but to preserve the material:

```scheme
(define A (sdegeo:create-rectangle (position 0.0 0.0 0) (position 3.0 2.0 0)
  "Silicon" "region_1"))
(sde:add-material A (generic:get A "material") "region_new")
```

**NOTE** If multiple bodies are selected, only the region name of the first selected body is changed.

No check is performed to ensure that a newly chosen region name is not already in use. If a body is assigned a region name through this method and the region name is also used for another body, the results of region-oriented operations are undefined.

# Deleting Regions

To delete one or more regions:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Body**.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>109</page_number>

# 4: Generating Geometric Structures

Editing 2D and 3D Structures

3. Select the body and hold the Shift key to select additional bodies, or drag a box around a set of bodies.

4. Choose **Edit** > **2D Edit Tools** > **Delete Region**, or press the Delete key or Backspace key, or right-click and choose **Delete**.

The corresponding Scheme command is:

```scheme
(sdegeo:delete-region body-list)
```

For example:

```scheme
(define BODY (sdegeo:create-cuboid (position 0.0 0.0 0.0)
  (position 1.0 1.0 1.0) "Silicon" "region_1"))
(sdegeo:delete-region BODY)
```

**NOTE** Ref/Eval windows can be deleted in a similar way. The selection filter must be set to Ref/Eval windows to select the Ref/Eval window entities.

---

# Separating Lumps

During model generation, Sentaurus Structure Editor *never* allows the generation of overlapping regions (unless `(sdegeo:set-default-boolean "XX")` is used). When the automatic region-naming feature is switched on, a region name is attached automatically to each generated body. As a result of this, bodies with multiple lumps (disjoint 2D or 3D parts) can be created. These disjoint lumps have the same region-name attribute.

Since this could cause a problem during meshing, these lumps must be separated and a unique region name must be assigned to each lump. This is performed automatically when a boundary file is exported.

To call the lump separation explicitly, for example, to refer to individual lumps of a multiple-lump regions in a Scheme script, choose **Edit** > **Separate Lumps**. The same action can be performed by using the Scheme function `(sde:separate-lumps)`.

The following script illustrates how to generate multiple lumps:

```scheme
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-rectangle (position 0 0 0) (position 10 5 0) "Silicon"
  "region_1")
(sdegeo:create-rectangle (position 4 -2 0) (position 6 7 0) "PolySilicon"
  "region_2")
```

As a result, two regions are created (region_1 and region_2). However, region_1 is composed of two disjoint lumps. After `(sde:separate-lumps)`, the region_1 region-name attribute is removed from the silicon region, and region_1_lump_1 is assigned as the region

<page_number>110</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures
Editing 2D and 3D Structures

name to the left lump of the silicon body, and `region_1_lump_2` is assigned to the right lump. The exported boundary file will have three regions with unique region names.

# Two-Dimensional Cuts From a 3D Structure

To generate a 2D cross section from a 3D structure:

1. Choose **Edit** > **3D Edit Tools** > **Slice**.
   The Cut Plane Controller is displayed.

2. Select the required option, and either change the value in the box or rotate the corresponding dial.

3. When you are finished, click **Close**.

The corresponding Scheme extension is:

```scheme
(sdegeo:3d-cut base-position normal-vector [tr-xy] [tr-record]
  [tr-axisaligned])
```

The Scheme extension needs two arguments: a position argument to place the cut plane and a gvector argument to specify the cut plane normal. For example, the following command generates a 2D cut in such a way that the cut plane goes through 0.0 0.0 0.0, and the cut plane is perpendicular to the 1.0 1.0 0.0 vector:

```scheme
(sdegeo:3d-cut (position 0.0 0.0 0.0) (gvector 1.0 1.0 0.0))
```

Three-dimensional structure

2D structure generated after slicing

Figure 65 (Left) Three-dimensional structure and (right) 2D structure generated after slicing

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>111</page_number>

# 4: Generating Geometric Structures

Editing 2D and 3D Structures

Up to three additional (optional) arguments can be used in `sdegeo:3d-cut`:

*   The first optional Boolean argument determines the placement of the newly created 2D structure. If you specify `#f` (default), then the slice remains at its original location. If you specify `#t`, then the slice will move to the xy plane at z=0. In this way, a 2D slice can be saved to a 2D boundary file.

*   The second optional Boolean argument can be used to record the transformation that transforms the 2D cut on the xy plane.

*   The third optional Boolean argument can be used to trigger special transformation rules for axis-aligned cuts. If the new transformation rule is applied, then the position of the 2D cut is calculated explicitly following the simple rules described in sdegeo:3d-cut on page 577.

For example:

```
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.2 0.8 1.0) "Silicon"
 "R.Substrate")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position 0.0 0.5 0.5) (position 1.2 0.8 1.0) "Oxide"
 "R.STI")
(sdegeo:create-cuboid (position 0.4 0.0 1.0) (position 0.8 0.6 1.1) "Oxide"
 "R.Gox")
(sdegeo:create-cuboid (position 0.4 0.0 1.1) (position 0.8 0.6 1.5)
 "PolySilicon" "R.Poly")
(sdegeo:3d-cut (position 0.6 0.0 1.0) (gvector 1.0 0.0 0.0) #t)
```

## Split–Insert Stretching of a Device

For certain applications, such as the computation of the threshold voltage roll-off behavior of a CMOS technology node, it is necessary to create a family of device structures, which are identical in certain regions (here, the source and drain areas) while other regions are stretched (here, the gate area). The split–insert stretching feature conveniently supports this application.

It allows you to split a device at a specified spatial location and to insert a linear segment (with a specified extension length) between the split parts of the original device. The split–insert direction can be specified as well. An optional merge argument can be used to merge the split bodies and inserted bodies.

To use the split–insert stretching feature:

1. Choose **Edit > Device Operations > Split-Insert Device**.

The Split-Insert Device dialog box is displayed.

2. Enter the split position, insert direction, and insert length.

<page_number>112</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 4: Generating Geometric Structures

Editing 2D and 3D Structures

3. Select **Merge Planes** if the inserted regions should be merged with the existing ones.

Screenshot of the Split-Insert Device dialog box showing fields for Split Position, Insert Direction, Insert Length, and a Merge Planes checkbox.

## 4. Click **OK**.

The corresponding Scheme command is:

```
(sdegeo:split-insert-device position gvector insert-length [merge-flag])
```

### For example:

```
(sdegeo:create-cuboid (position -1.0 0.0 0.0) (position 1.0 1.0 -1.0)
 "Silicon" "region_1")
(sdegeo:create-cuboid (position -0.4 0.0 0.0) (position 0.4 1.0 0.1)
 "SiO2" "region_2")
(sdegeo:create-cuboid (position -0.4 0.0 0.1) (position 0.4 1.0 0.5)
 "PolySi" "region_3")
(sdegeo:split-insert-device (position 0 0 0) (gvector 1 0 0) 1 #t)
```

These split–insert operations can be used for both 2D and 3D models.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>113</page_number>

# 4: Generating Geometric Structures

Editing 2D and 3D Structures

2D split-insert operation diagram

3D split-insert operation diagram

`(sdegeo:split-insert-device (position 2 0 0) (gvector 1 0 0) 4 #t)`

Figure 66 Split–insert operations in (*left*) two dimensions and (*right*) three dimensions

---

# Extending a 2D Device

For certain applications, it is necessary to extend the device at one or more boundaries. For example, the default reflecting boundary conditions might be inappropriate for a given application. In such cases, it can be advantageous to simply push out one or more boundaries. This can be achieved conveniently with the extend device feature.

To use the extend device feature:

1. Choose **Edit > Device Operations > Extend Device**.

The Extend Device dialog box is displayed.

2. Select the boundary to be extended, and enter the extension length.

Extend Device dialog box screenshot

<page_number>114</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**
Editing 2D and 3D Structures

3. Click **OK**.

The corresponding Scheme extension is:

```scheme
(sdegeo:extend-device side amount [side amount [side amount [side amount]]])
```

For example:

```scheme
(sdegeo:create-rectangle (position 0.0 0.0 0.0) (position 1.0 1.0 0.0)
  "Silicon" "region_1")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-rectangle (position 0.0 0.0 0.0) (position 0.5 0.5 0.0)
  "SiO2" "region_2")
(sdegeo:create-rectangle (position 0.0 -0.2 0.0) (position 0.7 0.0 0.0)
  "Aluminum" "region_3")
(sdegeo:extend-device "left" 0.5 "bottom" 0.5)
```

The left, right, top, and bottom parts of the device can be extended sequentially or in combination. If the combination contains a corner, the corner area will be filled as well. Individual region names will be assigned to the extended parts, and the material property is inherited from the original regions.

> **NOTE** This operation is available for 2D only. Only the axis-aligned (horizontal or vertical) parts of the model will be extended.

Engineering drawing showing an original 2D device on the left and an extended version on the right.

Figure 67 (Left) Original 2D device and (right) extended device using the `(sdegeo:extend-device "right" 4 "bottom" 2)` command

# Trimming a 3D Structure

A 3D structure can be trimmed such that all parts lying outside of a polygonal base plane are removed. The base plane is restricted to the xy plane. The command is not available from the GUI.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>115</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

The Scheme command is:

```scheme
(sdegeo:chop-domain coordinate-list)
```

The coordinate-list argument is a list of x, y point pairs.

For example:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.2 0.8 1.0)
 "Silicon" "R.Substrate")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position 0.0 0.5 0.5) (position 1.2 0.8 1.0)
 "Oxide" "R.STI")
(sdegeo:create-cuboid (position 0.4 0.0 1.0) (position 0.8 0.6 1.1)
 "Oxide" "R.Gox")
(sdegeo:create-cuboid (position 0.4 0.0 1.1) (position 0.8 0.6 1.5)
 "PolySilicon" "R.Poly")
(sdegeo:chop-domain (list 0.0 0.0 1.2 0.4 1.2 0.6 0.6 0.6 0.6 0.4 0.0 0.4))
```

Trimming a 3D structure: (left) initial structure and (right) trimmed structure

Figure 68 Trimming a 3D structure: (left) initial structure and (right) trimmed structure

---

# Coordinate Systems and Transformations

Sentaurus Structure Editor uses the concept of work planes to define a coordinate system. The name of the work plane refers to the fact that any 2D geometric object is created in the xy plane of the currently used coordinate system. In addition, certain 3D GUI-based geometric operations use the work plane as the plane of reference.

Changing the work plane only affects newly created objects (existing objects can be moved, rotated, and reflected using transformations).

Sentaurus Structure Editor itself makes no assumptions about the unit of length used to define a geometric object. Other TCAD Sentaurus tools, such as Sentaurus Device, however, will

<page_number>116</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

4: Generating Geometric Structures
Coordinate Systems and Transformations

assume that the unit of length is 1 μm. In this indirect sense, the effective default unit of length in Sentaurus Structure Editor is 1 μm.

Sentaurus Structure Editor internally performs geometric operations with finite precision. Therefore, it is recommended to use a length scale in which the typical device dimensions are of the order of 1. For example, it is recommended to use nanometer rather than micrometer for a hypothetical device that measures only a few nanometers in length. In this case, it becomes necessary to scale the device structure upon saving the final boundary and the mesh input file. Sentaurus Structure Editor provides functions for scaling a device structure as well as meshing information before exporting the final boundary and mesh command file.

# Work Planes

To define and activate a new work plane:

1. Choose **Draw** > **Work Planes**.

The Work Planes dialog box is displayed.

2. Enter a name for the new work plane, the coordinates of the new origin, as well as the direction vectors for the x- and y-axis.

3. Click **Set** to define the new work plane.

4. Select the newly created entry from the **Defined Work Planes** list, and click **Activate** to activate the new work plane.

Work Planes dialog box screenshot

Figure 69 Work Planes dialog box

The corresponding Scheme commands are:

```
(sdegeo:define-work-plane wp-name origin-position x-position y-position)
(sdegeo:set-active-work-plane wp-name)
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>117</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

By default, Sentaurus Structure Editor uses the ‘base’ work plane, which is associated with a global coordinate system. The base work plane is defined as the xy plane at z = 0.

There are also two other predefined work planes. The ‘wp_xz’ work plane is defined as the xz plane at y = 0, and the ‘wp_yz’ work plane is defined as the yz plane at x = 0, both with respect to the global coordinate system. When you define and activate a different ‘work plane,’ then for all subsequent geometric operations, all coordinates are interpreted with respect to this new coordinate system.

To activate any work plane that has already been defined, select the required work plane from the **Defined Work Planes** list (see Figure 69 on page 117).

The Work Planes dialog box and the Scheme command use different ways to define the new coordinate system. The dialog box asks for the direction *vectors* for the x- and y-axis. While the Scheme command uses three *positions* to define the work plane.

The two definitions are related using the expression:

$$
\begin{aligned}
p_x &= p_o + e_x \\
p_y &= p_o + e_y
\end{aligned}
\hfill (1)
$$

where $p_o$, $p_x$, and $p_y$ are the positions origin-position, x-position, and y-position used by the Scheme command, respectively, and $e_x$ and $e_y$ are the direction vectors for the x-axis and y-axis used by the dialog box.

If direction vectors do not have unit length, they are normalized. If the y-axis is not orthogonal to the x-axis, only the orthogonal component is considered. The z-axis is defined by the right-hand rule.

The following example shows how to create the six faces of a unit cube by drawing the same unit rectangles in different work planes:

```scheme
(sdegeo:set-active-work-plane "base")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon" "WP.BASE")

(sdegeo:set-active-work-plane "wp_xz")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Oxide" "WP.XZ")

(sdegeo:set-active-work-plane "wp_yz")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "PolySi" "WP.YZ")

(sdegeo:define-work-plane "base_1" (position 0 0 1) (position 1 0 1)
  (position 0 1 1))
(sdegeo:set-active-work-plane "base_1")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon"
  "WP.BASE_1")
```

<page_number>118</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

4: Generating Geometric Structures

Coordinate Systems and Transformations

```scheme
(sdegeo:define-work-plane "wp_xz_1" (position 0 1 0) (position 1 1 0)
    (position 0 1 1))
(sdegeo:set-active-work-plane "wp_xz_1")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Oxide" "WP.XZ_1")

(sdegeo:define-work-plane "wp_yz_1" (position 1 0 0) (position 1 1 0)
    (position 1 0 1))
(sdegeo:set-active-work-plane "wp_yz_1")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "PolySi" "WP.YZ_1")
```

Work planes do not have to be axis aligned. The following script creates a shifted and tilted work plane:

```scheme
(sdegeo:set-active-work-plane "base")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon" "WP.BASE")

(sdegeo:define-work-plane "wp_shiftandtilt" (position 0.5 0.5 0)
    (position 0.5 1.5 0) (position 1.5 0.5 1))
(sdegeo:set-active-work-plane "wp_shiftandtilt")
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Nitride"
    "WP.shiftandtilt")
```

Existing work planes can be deleted using the Work Planes dialog box or the Scheme command:

```scheme
(sdegeo:delete-work-plane wp-name)
```

When interactive drawing tools are used, the operations are always performed in the active work plane. Even when the view is rotated, the pointer always moves in the xy plane of the active work plane.

If a planar face of an existing 3D body is selected, before choosing **Draw** > **Work Planes**, the data that is needed for the work plane definition will be extracted automatically from the selected face, and most fields in the Work Plane dialog box will be already filled. The origin is set to the center of the selected face. The x-axis and y-axis are selected as the principal axes of the selected face. A work plane defined in this way will be the plane in which the selected face lies.

# Local Coordinate Systems

In Sentaurus Structure Editor, the coordinate systems feature offers an alternative way to define work planes. The differences are that:

*   The coordinate systems method defines the new work plane with respect to the currently active work plane, instead of the global coordinate system.

*   This method uses the rotation angle around the current z-axis to define the coordinate system, instead of defining the coordinate axis directly.

Sentaurus™ Structure Editor User Guide

<page_number>119</page_number>

S-2021.06

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

To define the local coordinate system:

1. Choose **Draw** > **Coordinate Systems**.

The Coordinate Systems dialog box is displayed.

2. Enter a name for the local coordinate system, the origin in the current xy plane, and a rotation angle.

3. Click **Set** to define the new work plane.

Coordinate Systems dialog box

4. Select the newly created entry from the **Defined Coordinate Systems** list, and click **Activate** to activate the new work plane.

5. To delete a local coordinate system, select it from the **Defined Coordinate Systems** list, and click **Delete**.

The corresponding Scheme commands are:

```scheme
(sdegeo:define-coord-sys "name" origin_x origin_y angle)
(sdegeo:set-active-coord-sys "name")
(sdegeo:delete-coord-sys "name")
```

# Device Scaling

The Scheme command `sdegeo:scale` is used to scale all of the geometric bodies and Ref/Eval windows. The Scheme command `sdedr:write-scaled-cmd-file` is used to scale all refinement settings while writing the mesh command file.

The corresponding Scheme commands are:

```scheme
(sdegeo:scale entity-list scale-factor-x scale-factor-y [scale-factor-z])
(sdedr:write-scaled-cmd-file file-name scale-factor)
```

<page_number>120</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Coordinate Systems and Transformations

For example, if the device structure and meshing strategy were defined using nanometer as the unit of length, use Scheme commands such as the ones given here to export the device boundary and the mesh command file in micrometers:

```
(define scale-factor 1000)
(sdegeo:scale (part:entities) scale-factor scale-factor)
(sdeio:save-tdr-bnd (get-body-list) "Scaled-to-um_bnd.tdr")
(sdedr:write-scaled-cmd-file "Scaled-to-um_msh.cmd" scale-factor)
(system:command "snmesh Scale-to-um_msh")
```

These commands are not available from the GUI.

**NOTE** Previously, the command `sdedr:write-scaled-cmd-file` scaled Ref/Eval windows. Now, Ref/Eval windows can be scaled together with geometric regions, using the `sdegeo:scale` command. Therefore, `sdegeo:scale` must be called first, before the command `sdedr:write-scaled-cmd-file` is called.

After setting the Scheme variable `global-scaling` to a value other than 1.0 in the command-line window with:

```
(set! global-scaling 2.0)
```

scaled device structures and mesh command files can be saved by choosing **Mesh > Build Mesh**, with Scheme commands such as:

```
(set! global-scaling 1000.0)
(sde:build-mesh "Scaled-to-um_msh")
```

# Entity Transformations: Scaling, Translation, Rotation, and Reflection

Several different Scheme functions and GUI operations can be used to perform basic geometry transformation operations on some or all top-level entities of the device as well as on Ref/Eval windows.

A top-level entity is at the highest level in the entity hierarchy list (that is, no other entity refers to that entity). For example, a face of a solid body (`s_b`) is not a top-level entity, since the solid body contains the face. (The `(entity:faces s_b)` command returns the particular face.) Similarly, a linear edge of a sheet body is not a top-level entity. However, if the edge was generated separately using the `edge:linear` command, for example, then it is a top-level entity.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>121</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

The Transform Operations dialog box is used to perform basic transformations. It is displayed by choosing **Edit > Transform**. It has different tabs for scaling, translation, rotation, and reflection operations.

Each transform mode has a **Target Entities** list, which lists all objects (2D and 3D bodies) to which the transformation can be applied. The target entities can be selected from this list. The selected entities are highlighted. Selection from the GUI is also possible. In that case, the target entities must be selected from the GUI, and the corresponding entity IDs will be highlighted in the **Target Entities** list.

The translation, rotation, and reflection operations create new bodies if the **Transform Copy** option is selected. The newly created bodies will inherit the material property from the parent body. Region names are also inherited, but an additional string will be attached to the region names to provide unique region names.

A counter is associated with each type of transformation. In each transformation, the repeat number is also counted. For example, if the name of the parent entity is `region_1` and the fifth transformation is being performed, the newly created entity will be called `region_1_t5`. If a number is entered in the **Repeat Operation** field and, for example, it is set to 3, the new regions will be called `region_1_t5_r1`, `region_1_t5_r2`, and `region_1_t5_r3`.

## Local Scaling of Entities

To scale one or more entities:

1. Choose **Edit > Transform**.

The Transform Operations dialog box is displayed.

2. Select one or more entities in the **Target Entities** list.

3. Click the **Scale** tab.

4. Select **Selected Method**.

<page_number>122</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

5. Enter a scaling factor for the x-, y-, and z-axis.

Screenshot of the Transform Operations dialog box showing the Scale tab with fields for Scale X, Scale Y, and Scale Z.

## 6. Click **OK**.

The scaling operation can be applied to top-level entities (bodies) only (these are either geometric bodies, which are part of the model geometry, or Ref/Eval windows). Nonuniform scaling is also supported. The scaling factors cannot be zero. To suppress scaling in a given direction, enter a scaling factor of 1.

The corresponding Scheme command is:

```
(sdegeo:scale-selected entity|entity-list
  (transform:scaling x-scale y-scale z-scale))
```

For example, the following Scheme commands scale a sphere to become a flat ellipsoid:

```
(define SPHERE (sdegeo:create-sphere (position 0 0 0) 1 "Silicon" "region_1"))
(sdegeo:scale-selected SPHERE (transform:scaling 0.5 2 4))
```

**NOTE** Scaling is performed about the geometry center of each entity. This means entities that were touching before the scaling will either overlap or be disjoint after the scaling. Therefore, this operation is not intended to scale entire device structures. Use the operations discussed in Device Scaling on page 120 for this purpose.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>123</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

## Difference Between sdegeo:scale and sdegeo:scale-selected

Different scaling operations are available in Sentaurus Structure Editor as follows:

* The `sdegeo:scale-selected` Scheme extension scales each body about its own geometric center (independently from other bodies). In this case, overlaps might be created, which are removed automatically, based on the selected Boolean overlap refinement rule.

* The `sdegeo:scale` Scheme extension multiplies all vertex coordinates with the specified scaling factors. The scaled model will be similar to the original model (therefore, no overlap removal is necessary).

For example:

```scheme
(sde:clear)
(define mb1 (sdegeo:create-rectangle (position 0 0 0) (position 10 5 0)
  "Silicon" "mb1"))
(define mb2 (sdegeo:create-rectangle (position 8 5 0) (position 12 9 0)
  "PolySilicon" "mb2"))
(bbox mb1)
;; (#[ position 0 0 0 ] . #[ position 10 5 0 ])
(bbox mb2)
;; (#[ position 8 5 0 ] . #[ position 12 9 0 ])
(sdegeo:scale (list mb1 mb2) 2 2 1)
(bbox mb1)
;; (#[ position 0 0 0 ] . #[ position 20 10 0 ])
(bbox mb2)
;; (#[ position 16 10 0 ] . #[ position 24 18 0 ])

(roll)
(sdegeo:set-default-boolean "ABA")
(sdegeo:scale-selected (list mb1 mb2) (transform:scaling 2 2 1))

(roll)
(sdegeo:set-default-boolean "BAB")
(sdegeo:scale-selected (list mb1 mb2) (transform:scaling 2 2 1))
;; the sdegeo:scale-selected function scales each body (independently from
each other) about the geometric center of the given body.
```

<page_number>124</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Coordinate Systems and Transformations

Diagram showing the difference between sdegeo:scale and sdegeo:scale-selected with various overlap removal rules.

Figure 70 Difference between sdegeo:scale and sdegeo:scale-selected: (*top*) scaling using sdegeo:scale and (*bottom*) scaled models using sdegeo:scaled-selected

# Translation

The translation operation is always performed with respect to the currently active coordinate system.

To translate one or more entities:

1. Choose **Edit** > **Transform**.
   The Transform Operations dialog box is displayed.

2. Select one or more entities from the Target Entities list.

3. Click the **Translate** tab.

4. Select **Selected Method**.

5. Enter the coordinates of the translation vector, or click **Pick Vector** and click the starting point and endpoint of the translation vector in the view window.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>125</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

6. Select **Transform Copy** if a copy of the original entities should remain at the initial location.

Screenshot of the Transform Operations dialog box in Sentaurus Structure Editor, showing the Translate tab selected with options for Target Entities, Translation Direction (X, Y, Z), Transform Copy checkbox, and Repeat Operation field.

7. If a nonzero **Repeat Operation** value is entered, the translation operation is performed multiple times for the selected entities.

8. Click **OK**.

The corresponding Scheme command is:

```
(sdegeo:scale-selected entity|entity-list (transform:translation gvector)
  copy-flag repeat-counter)
```

For example, the following Scheme commands creates a string of four simple 3D MOSFET structures:

```
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.2 0.8 1.0)
  "Silicon" "R.Substrate")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position 0.0 0.5 0.5) (position 1.2 0.8 1.0)
  "Oxide" "R.STI")
(sdegeo:create-cuboid (position 0.4 0.0 1.0) (position 0.8 0.6 1.1)
  "Oxide" "R.Gox")
(sdegeo:create-cuboid (position 0.4 0.0 1.1) (position 0.8 0.6 1.5)
  "PolySilicon" "R.Poly")
```

<page_number>126</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**4: Generating Geometric Structures**

Coordinate Systems and Transformations

```scheme
(sdegeo:translate-selected (get-body-list)
  (transform:translation (gvector 1.2 0 0)) #t 3)
```

A string of 3D MOSFETs created using Transform Copy

Figure 71 A string of 3D MOSFETs is created using the Transform Copy option and by entering a repeat number value

## Rotation

Rotation operations are always performed with respect to the currently active coordinate system.

To rotate one or more entities:

1. Choose **Edit** > **Transform**.
   The Transform Operations dialog box is displayed.

2. Select one or more entities from the Target Entities list.

3. Click the **Rotate** tab.

4. Select **Selected Method**.

5. Define the axis of rotation by entering a point on the axis and a direction vector, or click **Pick Point/Axis** and click a point in the view window.

   In this case, the rotation axis will point into the current view plane. Enter also the rotation angle.

6. Select **Transform Copy** if a copy of the original entities should remain at the initial location.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>127</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

7. If a nonzero **Repeat Operation** value is entered, the rotation operation is performed multiple times for the selected entities.

Transform Operations dialog box showing Rotate tab with options for Target Entities, Pick Point/Axis, Point on Axis, Axis Direction, Transform Copy, and Repeat Operation.

8. Click **OK**.

The corresponding Scheme command is:

```scheme
(sdegeo:rotate-selected entity|entity-list
  (transform:rotation position gvector angle) copy-flag repeat-counter)
```

For example, the following Scheme commands create a moon sickle:

```scheme
(define CIRCLE (sdegeo:create-circle (position 0 0 0) 1
  "Silicon" "region_1"))
(sdegeo:set-default-boolean "BAB")
(sdegeo:rotate-selected CIRCLE (transform:rotation (position 1 0 0)
  (gvector 0 0 1) -30) #t 0)
(sdegeo:delete-region CIRCLE)
```

<page_number>128</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

## Reflection

To reflect one or more entities:

1. Choose **Edit > Transform**.

The Transform Operations dialog box is displayed.

Screenshot of the Transform Operations dialog box showing the Reflect tab with options for Target Entities, Selected Method, Pick Point/Norm, Point on Plane (X, Y, Z), Plane Normal (X, Y, Z), Transform Copy, and Repeat Operation.

2. Select one or more entities from the Target Entities list.

3. On the **Reflect** tab, select **Selected Method**.

4. Define the reflection plane by entering a point on the plane and a normal vector, or click **Pick Point/Norm** and click a point in the view window.

In this case, the normal vector will point to the right of the current view plane.

5. Select **Transform Copy** if a copy of the original entities should remain at the initial location.

6. Click **OK**.

The corresponding Scheme command is:

```scheme
(sdegeo:mirror-selected entity|entity-list
  (transform:reflection position gvector) copy-flag)
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>129</page_number>

# 4: Generating Geometric Structures

Coordinate Systems and Transformations

For example, the following Scheme commands reflect the half-MOSFET structure to form a full device:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.2 0.8 1.0)
 "Silicon" "R.Substrate")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position 0.0 0.5 0.5) (position 1.2 0.8 1.0)
 "Oxide" "R.STI")
(sdegeo:create-cuboid (position 0.4 0.0 1.0) (position 0.8 0.6 1.1)
 "Oxide" "R.Gox")
(sdegeo:create-cuboid (position 0.4 0.0 1.1) (position 0.8 0.6 1.5)
 "PolySilicon" "R.Poly")

(sdegeo:mirror-selected (get-body-list)
 (transform:reflection (position 0 0 0) (gvector 0 -1 0)) #t)
```

## Scheme Functions for Transformations

Scheme functions are available to perform transformation operations.

Table 21 Scheme functions for transformations

<table>
  <thead>
    <tr>
        <th>Scheme function</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>sdegeo:mirror-selected</td>
        <td>Reflects the specified entities.</td>
    </tr>
    <tr>
        <td>sdegeo:rotate-selected</td>
        <td>Rotates the specified entities.</td>
    </tr>
    <tr>
        <td>sdegeo:scale-selected</td>
        <td>Scales the specified entities.</td>
    </tr>
    <tr>
        <td>sdegeo:translate-selected</td>
        <td>Translates the specified entities.</td>
    </tr>
    <tr>
        <td>transform:reflection</td>
        <td>Creates a transform to mirror an object through an axis.</td>
    </tr>
    <tr>
        <td>transform:rotation</td>
        <td>Creates a transform to rotate an object about an axis.</td>
    </tr>
    <tr>
        <td>transform:scaling</td>
        <td>Creates a scaling transform.</td>
    </tr>
    <tr>
        <td>transform:translation</td>
        <td>Creates a translation transform.</td>
    </tr>
  </tbody>
</table>

<page_number>130</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

