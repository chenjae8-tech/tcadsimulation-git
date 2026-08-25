# CHAPTER 7 Generating Mesh and Doping Profiles

*This chapter presents the meshing operations available in Sentaurus Structure Editor.*

## Overview of Meshing Operations

In addition to defining the geometry of a structure, doping profiles and refinement parameters can be defined for different parts of the structure. The placement of these profiles and refinements as well as the areas to which the use of these profiles and refinements are restricted can be specified by user-defined refinement/evaluation (Ref/Eval) windows.

Ref/Eval windows are implemented as geometric objects and can be manipulated in a similar manner as other geometric objects. The difference between a regular geometric body and a Ref/Eval window is that material and region properties are attached to a regular geometric body, while a Ref/Eval window name is attached to a Ref/Eval window. Certain operations affect only regular geometric bodies. For example, only regular geometric bodies can be written to a tessellated boundary file. Some query functions, such as `(get-body-list)`, handle only regular geometric bodies. On the other hand, only Ref/Eval windows can be used in refinement and doping specifications as evaluation windows, for example. Ref/Eval windows have their own query functions, such as `(get-drs-list)`, which returns the entity IDs of all defined Ref/Eval windows.

In some cases, doping profiles and refinements can also be restricted to a specific region or material (materialwise and regionwise refinements and dopings).

Unlike regular geometric objects, Ref/Eval windows can overlap. For example, the refinement in a given area of the device can be determined by the tightest requirements among several refinement placements active in that area. For overlapping doping placements, the resulting profile is the sum of all profiles.

Sentaurus Structure Editor allows the full flexibility of definitions and placements available in the input syntax of Sentaurus Mesh. Profiles and refinements are first defined by specifying all the necessary parameters, but their use is not restricted to a specific location or an area. In a second step, profiles and refinements are placed. The placement step links a given profile or refinement definition with an area of validity, which can be a Ref/Eval window, a region name, or a material.

Sentaurus™ Structure Editor User Guide

<page_number>195</page_number>

S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Areas for Mesh Refinement or Doping

Both profile and refinement definitions as well as Ref/Eval windows can be reused in various placements for maximum flexibility.

# Defining Areas for Mesh Refinement or Doping

Ref/Eval windows are areas in which a certain mesh refinement or doping profile is applied. These reference areas can take the form of a line segment, a rectangle, a polygon, a cuboid, or a polygon automatically extracted from a face.

## Line-Segment Ref/Eval Windows

Line-segment Ref/Eval windows are used as reference edges for placing implant-like doping profiles in two dimensions.

To define a line-segment Ref/Eval window:

1. Choose **Mesh** > **Define Ref/Eval Window** > **Line**, or click the corresponding toolbar button (see Table 14 on page 13).

2. Click the starting point and the endpoint of the line segment in the view window.

The corresponding Scheme command is:

```scheme
(sdedr:define-refeval-window RefEval-name "Line" position position)
```

For example:

```scheme
(sdedr:define-refeval-window "RefEvalWin_1" "Line"
  (position 0.0 0.0 0) (position 1.0 0.0 0))
```

## Rectangular and Polygonal Ref/Eval Windows

Rectangular and polygonal Ref/Eval windows are used to place mesh refinement or constant profiles in two dimensions, and are used as reference faces to place implantation-like doping profiles in three dimensions.

To define a rectangular or polygonal Ref/Eval window:

1. Choose **Mesh** > **Define Ref/Eval Window** > **Rectangle** (or **Polygon**), or click the corresponding toolbar button (see Table 14 on page 13).

2. For a rectangle, drag to draw the diagonal of the rectangle in the view window.

<page_number>196</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

# 7: Generating Mesh and Doping Profiles
Defining Areas for Mesh Refinement or Doping

For a polygon, click at each vertex of the polygon in the view window. To finish drawing the polygon, click the middle mouse button. (Press both buttons when using a two-button mouse.) The polygon is closed automatically.

**NOTE** Ref/Eval windows are oriented. The face normals of rectangular Ref/Eval windows point in the positive third-axis direction (right-hand rule). For polygonal Ref/Eval windows, if the vertex position list is counterclockwise, then the normals point in the positive third-axis direction. The orientation is important when Ref/Eval windows are used in `sdedr:define-analytical-profile-placement` for reference. The "Positive" and "Negative" arguments of this Scheme extension must be adjusted to the Ref/Eval window normal direction.

The corresponding Scheme commands are:

```
(sdedr:define-refeval-window RefEval-name "Rectangle" position position)
(sdedr:define-refeval-window RefEval-name "Polygon" position-list)
```

For example:

```
(sdedr:define-refeval-window "RefEvalWin_2" "Rectangle"
  (position 0.0 0.5 0) (position 1.0 1.5 0))

(sdedr:define-refeval-window "RefEvalWin_3" "Polygon"
  (list (position 0 0 0) (position 0.5 -1 0)
  (position 1 -1 0) (position 1.5 0 0) (position 0 0 0)))
```

Rectangles and polygons defined by using the graphical user interface (GUI) are placed in the current work plane.

To create Ref/Eval windows in areas outside the current work plane, change the work plane first as discussed in Work Planes on page 117.

In the 2D GUI mode, a rectangular Ref/Eval window can also be defined from certain dialog boxes by choosing, for example:

*   **Mesh > Refinement Placement**

*   **Mesh > Multibox Placement**

*   **Device > Constant Profile Placement**

*   **Device > Analytical Profile Placement**

*   **Device > External Profile Placement**

**NOTE** When you use the GUI to define Ref/Eval windows, the name of the Ref/Eval window is assigned automatically and cannot be changed later.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>197</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Areas for Mesh Refinement or Doping

## Cuboidal Ref/Eval Windows

Cuboidal Ref/Eval windows are used to place mesh refinement or constant profiles in three dimensions.

To define a cuboidal Ref/Eval window:

1. Choose **Mesh > Define Ref/Eval Window > Cuboid**.

The Cuboid Coordinates dialog box is displayed.

2. Enter the coordinates of the start corner and the end corner.

**NOTE** The face normals of cuboidal Ref/Eval windows point outwards.

3. Click **OK**.

The corresponding Scheme command is:

```scheme
(sdedr:define-refeval-window RefEval-name "Cuboid" position position)
```

For example:

```scheme
(sdedr:define-refeval-window "RefEvalWin_4" "Cuboid"
  (position 0 0 0) (position 1 1 1))
```

In the 3D GUI mode, a cuboidal Ref/Eval window can also be defined from certain dialog boxes by choosing, for example:

* **Mesh > Refinement Placement**

* **Mesh > Multibox Placement**

* **Device > Constant Profile Placement**

* **Device > Analytical Profile Placement**

* **Device > External Profile Placement**

**NOTE** When you use the GUI to define Ref/Eval windows, the name of the Ref/Eval window is assigned automatically and cannot be changed later.

## Extracting Ref/Eval Window From Face

You can create a Ref/Eval window that coincides with one or more faces of a 2D body for placing mesh refinement or constant profiles, or faces of a 3D body for placing implant-like doping profiles in three dimensions.

<page_number>198</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

7: Generating Mesh and Doping Profiles

Defining Areas for Mesh Refinement or Doping

To extract a Ref/Eval window from faces:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Face**.

3. Select a face and hold the Shift key to select additional faces, or drag a box around a set of faces.

4. Choose **Mesh** > **Define Ref/Eval Window** > **From Face**, or click the corresponding toolbar button (see Table 14 on page 13).

The corresponding Scheme command is:

```scheme
(extract-refwindow face | face-list RefEval-name)
```

For example:

```scheme
(sdegeo:create-cuboid (position 0 0 0) (position 1 1 1) "Silicon" "region_1")
(extract-refwindow (find-face-id (position 0.5 0.5 1.0)) "RefEval_TopFace")
```

# Extracting Ref/Eval Window From Body Interface

You can use the Scheme extension `sdedr:define-body-interface-refwin` to define a refinement window between the interfaces of the specified geometric bodies (see sdedr:define-body-interface-refwin on page 526):

```scheme
(sdedr:define-body-interface-refwin body-list ref-eval-window)
```

For example:

```scheme
(sde:clear)
(define mb1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 4)
  "Silicon" "x1"))
(define mb2 (sdegeo:create-cuboid (position 2 2 3) (position 8 8 5)
  "PolySilicon" "x2"))
(sdedr:define-body-interface-refwin (list mb1 mb2) "RW")
(sdedr:define-refinement-size "RDef_1" 1 1 1 0.1 0.1 0.1)
(sdedr:define-refinement-placement "RPl_1" "RDef_1" "RW")
(sdedr:write-cmd-file "rwext.cmd")
```

# Extracting Ref/Eval Window From 3D Solid Body

You can use the Scheme extension `extract-refpolyhedron` to convert a 3D geometric body to a polyhedral refinement window. The ACIS surface mesher of Sentaurus Structure Editor,

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>199</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Areas for Mesh Refinement or Doping

which saves the tessellated polyhedral boundary for meshing, converts the 3D geometric body (possibly with nonplanar faces) to a polyhedral Ref/Eval window.

For example:

```scheme
(sde:clear)
(define mb (sdegeo:create-cuboid (position 0 0 0) (position 1 1 1)
  "Silicon" "x1"))
(extract-refpolyhedron mb "ref1")
```

or:

```scheme
(sde:clear)
(define mb (sdegeo:create-cylinder (position 0 0 0) (position 0 0 1)
  0.1 "Silicon" "x1"))
(extract-refpolyhedron mb "ref1")
(sdedr:define-refinement-size "RD_1" .2 .2 .1 .1)
(sdedr:define-refinement-placement "RP_1" "RD_1" "ref1")
(sdedr:write-cmd-file "xx.cmd")
```

## Extracting Ref/Eval Windows From 3D Solid Body Interfaces

You can use the Scheme extensions `extract-interface-offset-refwindow` and `extract-interface-normal-offset-refwindow` to extract the *non-regularized* intersection between two solid bodies, and to create a 3D offset body from the non-regularized intersection and to assign it as a doping/refinement/submesh (DRS) body. The `extract-interface-normal-offset-refwindow` extension offsets the faces of the interface body in the normal direction.

The following example creates the extracted DRS body shown in Figure 111 on page 201:

```scheme
(sde:clear)
(define mb1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 4)
  "Silicon" "x1"))
(define mb2 (sdegeo:create-cylinder (position 5 5 4) (position 5 5 8)
  2 "PolySilicon" "x2"))
(extract-interface-offset-refwindow mb1 mb2 1 "rw1")
```

<page_number>200</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**7: Generating Mesh and Doping Profiles**

Defining Areas for Mesh Refinement or Doping

Extraction of interface offset body: initial model and extracted DRS body

Figure 111 Extraction of interface offset body using extract-interface-offset-refwindow: (*left*) initial model and (*right*) extracted DRS body

The following example creates the extracted DRS body shown in Figure 112:

```
(sde:clear)
(define mb1 (sdegeo:create-cuboid (position 0 0 0) (position 10 10 4)
  "Silicon" "x1"))
(define mb2 (sdegeo:create-cylinder (position 5 5 4) (position 5 5 8)
  2 "PolySilicon" "x2"))
(extract-interface-normal-offset-refwindow mb1 mb2 1 "rw1")
```

Extraction of interface offset body: initial model and extracted DRS body

Figure 112 Extraction of interface offset body using extract-interface-normal-offset-refwindow: (*left*) initial model and (*right*) extracted DRS body

---

# Deleting Ref/Eval Windows

To delete a Ref/Eval window:

1. Click the Select button (see Table 7 on page 12).

2. From the Selection Level list, select **Ref/Eval Window**.

Alternatively, right-click in the view window and choose **Ref/Eval Window**.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>201</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Mesh Refinements

3. Click inside the Ref/Eval window to be deleted or drag a box around it.

4. Choose **Mesh** > **Delete Ref/Eval Window**.

The corresponding Scheme command is:

```scheme
(sdedr:delete-refeval-window RefEval-name)
```

For example:

```scheme
(sdedr:define-refeval-window "RefEvalWin_1" "Line"
  (position 0.0 0.0 0) (position 1.0 0.0 0))
(sdedr:delete-refeval-window "RefEvalWin_1")
```

# Defining Mesh Refinements

This section describes how to define mesh refinements.

## Regular Mesh Refinement Boxes

A mesh refinement box allows you to request from the mesher that, in the specified area, the mesh spacing should not exceed a given value and that mesh refinement should stop if the mesh size becomes smaller than a given value. Further, you can instruct the mesher to refine the mesh in areas of steep doping gradients or near interfaces. The mesher can create mesh spacings that are smaller than the requested minimum if needed to satisfy other constraints such as the resolution at an interface or to fulfill the Delaunay mesh quality criterion.

Sentaurus Mesh uses regular mesh refinement boxes.

To create a regular mesh refinement box:

1. Choose **Mesh** > **Refinement Placement**, or click the corresponding toolbar button (see Table 14 on page 13).

The Refinement Specification dialog box is displayed.

2. Edit the **Placement Name** field as needed (`RefinementPlacement_<index>` is the default name), or select the name of a previously defined refinement specification for editing.

3. Under Placement Type, select from the following:

- a) To place the mesh refinement into a previously defined Ref/Eval window, select the required Ref/Eval window from the **Ref/Eval Window** list.

- b) To place the mesh refinement into all regions with a given material, select a material name from the **Materials** list.

<page_number>202</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

# 7: Generating Mesh and Doping Profiles
## Defining Mesh Refinements

c) To place the mesh refinement into a specific region, select a region name from the **Regions** list.

d) Select **Define Ref/Eval Window** if a required Ref/Eval window has not yet been defined. Enter the coordinates of the start corner and end corner of the Ref/Eval window, and click **Create**.

The name of the new Ref/Eval window is assigned automatically, and the new Ref/Eval window is selected automatically in the **Ref/Eval Window** field.

A cuboidal Ref/Eval window is created if the 3D GUI mode is set (choose **View > GUI Mode > 3D Mode**). In 2D GUI mode, a rectangular Ref/Eval window is created. See GUI Modes on page 10.

e) To edit a previously defined Ref/Eval window, select the Ref/Eval window from the **Ref/Eval Window** field.

Select **Define Ref/Eval Window** and edit the window coordinates as needed. Click **Modify**. (Only Ref/Eval windows consistent with the current GUI mode can be edited from this dialog box.)

4. Under Refinement Definition, edit the **Name** field as needed (the default name is `RefinementDefinition_<index>`).

You can link an existing mesh refinement definition to the current refinement placement by selecting it from the corresponding list.

5. Enter values for the required maximum and minimum element sizes in each axis direction. (Omit this step when reusing an existing refinement definition.)

6. Optionally, add refinement functions to the refinement definition by clicking **More**. In the expanded dialog box, under Refinement Functions, do any of the following:

* To add automatic doping refinement based on the value difference or gradient of a doping profile, select **Value Difference** or **Gradient**, and select the required doping profile from the corresponding list.

Change the **Value** field to control the sensitivity of the automatic refinement if needed. Click **Add** to append the new function to the current list of refinement functions associated with the current refinement definition.

* To add automatic refinement at selected interfaces, select **Interface Length** and select the material in which the refinement should be applied from the first material list. Enter the material on the other side of the interface in the second material list.

Enter the first requested mesh spacing at the interface in the **Value** field and the ratio between the second and the first requested mesh spacing in the **Factor** field. Select **DoubleSide** to apply the interface refinement to both sides of the interface.

Select **UseRegionNames** to interpret the interface as a regionwise specification.

Sentaurus™ Structure Editor User Guide
<page_number>203</page_number>
S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Mesh Refinements

Click **Add** to append the new function to the current list of refinement functions associated with the current refinement definition.

Screenshot of the Refinement Specification dialog box in Sentaurus Structure Editor, showing options for Placement Name, Placement Type, Refinement Definition, and Refinement Functions. A pink arrow points to the "<< Less" button with a caption: "When you click More, the button changes to Less."

* To add automatic refinement based on profile values with a certain interval, select **Interval** and select the profile from the list.

Enter values for **Scaling**, **Cmin**, **Cmax**, and **TargetLength**. Optionally, select **Rolloff** for the interval refinement of Sentaurus Mesh.

**NOTE** You can add vector and tensor values for **Cmin** and **Cmax** by entering a space-separated list of the component values.

<page_number>204</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 7: Generating Mesh and Doping Profiles

## Defining Mesh Refinements

* To remove a refinement function, select it and click **Delete**.

7. When you have completed the refinement specification, click **Create Refinement**.

After a refinement is created, the **Create Refinement** button changes to **Change Refinement**, and the **Delete Refinement** button becomes available.

See Sentaurus™ Mesh User Guide, Defining Refinement Regions on page 18 as well as Sentaurus™ Mesh User Guide, Placing Refinement Regions on page 30 for details about refinement functions.

The related Scheme commands for creating Ref/Eval windows are:

```scheme
(sdedr:define-refeval-window RefEval-name "Line"|"Rectangle"|"Cuboid"
  position position)
(sdedr:define-refeval-window RefEval-name "Polygon" position-list)
```

The corresponding Scheme command for creating a refinement definition is:

```scheme
(sdedr:define-refinement-size RefDef-name dxmax dymax [dzmax]
  dxmin dymin [dzmin])
```

where dxmax, dymax, and dzmax are the maximum required mesh spacings, and dxmin, dymin, and dzmin are the minimum required mesh spacings.

The corresponding Scheme commands for adding adaptive refinement functions are:

```scheme
(sdedr:define-refinement-function RefDef-name dopant-name
  "MaxTransDiff"|"MaxGradient" value)
(sdedr:define-refinement-function "RefDef-name"
  "MaxLenInt" material-1 material-2 first-step ratio)
(sdedr:define-refinement-function "RefDef-name"
  "MaxInterval" "Variable" dopant-name "Cmin" cmin "Cmax" cmax
  "Scaling" scaling "TargetLength" targetLength "Rolloff")
```

The corresponding Scheme commands for linking a refinement definition to a Ref/Eval window, a region, or a material are:

```scheme
(sdedr:define-refinement-placement RefPlace-name RefDef-name RefEval-name)
(sdedr:define-refinement-region    RefPlace-name RefDef-name region-name)
(sdedr:define-refinement-material RefPlace-name RefDef-name material-name)
```

For example:

```scheme
(sdegeo:create-rectangle (position -0.5 0.0 0) (position 0.5 0.5 0)
  "Silicon" "region_1")
(sdedr:define-refeval-window "RefEvalWin.Channel" "Rectangle"
  (position -0.025 0.00 0) (position 0.025 0.01 0))
```

Sentaurus™ Structure Editor User Guide <page_number>205</page_number>
S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Mesh Refinements

```scheme
(sdedr:define-refinement-size "RefDef.Channel" 5e-3 2e-3 2e-3 1e-3)
(sdedr:define-refinement-function "RefDef.Channel" "MaxLenInt"
  "Silicon" "Oxide" 1e-4 1.2)
(sdedr:define-refinement-function "RefDef.Channel" "MaxInterval"
  "Variable" "DopingConcentration" "Cmin" 1e-4 "Cmax" 1.2 "Scaling" 2
  "TargetLength" 1e-3 "Rolloff")
(sdedr:define-refinement-function "RefDef.Channel" "DopingConcentration"
  "MaxTransDiff" 1)
(sdedr:define-refinement-placement "RefPlace.Channel" "RefDef.Channel"
  "RefEvalWin.Channel")
```

**NOTE** When using interface refinement from a Scheme command, you can set the materials to "All", or to an empty string to refer to all materials, or to the ambient. This option is not available from the GUI.

Interface refinement is specified in a similar way to the refinement on analytic functions. To perform interface refinement, define a `RefineFunction` of type `MaxLengthInterface` and specify the pair of materials defining the interface, the initial thickness, and a factor used to define how this thickness should grow into the material.

The following examples illustrate the use of this function:

* Refine silicon at the oxide interface, starting with a layer of 0.02 μm and gradually increasing the thickness by 1.4 times:

```scheme
(sdedr:define-refinement-function "RefinementDefinition_1" "MaxLenInt"
  "Silicon" "Oxide" 0.02 1.4)
```

* Refine all interfaces, creating a single layer of 0.01 μm:

```scheme
(sdedr:define-refinement-function "RefinementDefinition_1" "MaxLenInt"
  "All" "All" 0.01)
```

* Refine all contacts in the mesh:

```scheme
(sdedr:define-refinement-function "RefinementDefinition_1" "MaxLenInt"
  "All" "Contact" 0.01)
```

* Refine around a single contact:

```scheme
(sdedr:define-refinement-function "RefinementDefinition_1" "MaxLenInt"
  "All" "Gate" 0.01 "UseRegionNames")
```

By default, interface refinement is performed only on the first material of the specified pair of materials describing the interface. To refine on both sides of the interface, specify the "DoubleSide" keyword:

```scheme
(sdedr:define-refinement-function "RefinementDefinition_1" "MaxLenInt"
  "Silicon" "Oxide" 0.02 1.4 "DoubleSide")
```

<page_number>206</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles
Defining Mesh Refinements

# Multibox Refinements

Multibox refinements are similar to regular mesh refinement boxes, but the requested minimum mesh spacing can be graded. It starts with the minimum value given at a specified side of the refinement window and is expanded by a given factor from one mesh line to the next until the given maximum is reached. Sentaurus Mesh uses multibox refinement boxes.

**NOTE** Consider using interface refinement in Sentaurus Mesh as a more flexible alternative to multibox refinement.

Multibox refinement applies only to rectangular (2D) and cuboidal (3D) Ref/Eval windows. Polygonal Ref/Eval windows and regionwise or materialwise placements are not supported. Moreover, refinement functions cannot be added to multibox refinements. Use additional regular mesh refinement boxes to obtain, for example, refinement at doping gradients in addition to multibox refinement.

To define a multibox refinement:

1. Choose **Mesh > Multibox Placement**, or click the corresponding toolbar button (see Table 14 on page 13).

The Multibox Specification dialog box is displayed.

2. Edit the **Placement Name** field as needed (`MultiboxPlacement_<index>` is the default name), or select the name of an existing multibox refinement specification for editing.

3. Under Placement Type, select a Ref/Eval window.

To define a new Ref/Eval window or to edit an existing Ref/Eval window, proceed as discussed in Regular Mesh Refinement Boxes on page 202 in Steps 3d and 3e.

4. Under Multibox Definition, edit the **Name** field as needed (the default name is `MultiboxDefinition_<index>`).

You can link an existing refinement definition to the current multibox placement by selecting it from the corresponding list.

5. Under Multibox Definition, enter values for the required maximum and minimum element sizes in each axis direction as well as for the expansion ratio:

* Use a positive expansion ratio to apply the minimum element size at the respective boundary with the lower coordinate value, that is, the left, front, or bottom side.

* Use a negative expansion ratio to apply the minimum element size at the respective boundary with the higher coordinate value, that is, the right, back, or top side.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>207</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Mesh Refinements

* A ratio of 1 means the minimum element size is used throughout the multibox.

* A ratio of 0 deactivates refinement along the corresponding axis.

Omit this step when reusing an existing refinement definition.

Multibox Specification dialog box

6. When you have completed the specification, click **Add Placement**.

After the new specification is added, the **Add Placement** button changes to **Change Placement**, and the **Delete Placement** button becomes available.

See Sentaurus™ Mesh User Guide, Defining Multibox Regions on page 15 as well as Sentaurus™ Mesh User Guide, Placing Multibox Regions on page 29.

The Scheme extensions for creating a multibox refinement are:

```scheme
(sdedr:define-refeval-window rfwin-name "Rectangle" | "Cuboid"
  position position)
(sdedr:define-multibox-size mbox-name max-x max-y max-z min-x min-y min-z
  ratio-x ratio-y ratio-z)
```

<page_number>208</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Mesh Refinements

For example:

```lisp
(sdegeo:create-cuboid (position 1 3 5) (position 2 4 6) "Silicon" "region_1")
(sdedr:define-refeval-window "RefEvalWin_1" "Cuboid"
 (position 1 3 5) (position 2 4 6))
(sdedr:define-multibox-size "MultiboxDefinition_1"
 0.25 0.25 0.25
 0.05 0.05 0.05
 -2 0 1)
(sdedr:define-multibox-placement "MultiboxPlacement_1" "MultiboxDefinition_1"
 "RefEvalWin_1")
```

# Offsetting Refinements

The main algorithm in Sentaurus Mesh produces meshes that are mostly axis aligned. Even when refining curved interfaces, an adapted axis-aligned mesh is used by default. Sentaurus Mesh also provides an offsetting algorithm that resolves interfaces by introducing mesh layers truly parallel to the curved surfaces.

For devices where the main surfaces are nonaxis-aligned or curved (for example, a MOS-type structure where the channel is nonplanar), the offsetting algorithm is an attractive alternative to purely axis-aligned meshing.

To define offsetting refinements globally or for a region, a material, or an interface:

1. Choose **Mesh** > **Offsetting Parameters**.

The Offsetting Parameters dialog box is displayed.

Offsetting Parameters dialog box

2. Click **New** to add a new offsetting refinement parameter, or select a defined parameter from the list and click **Edit**.

Sentaurus™ Structure Editor User Guide

<page_number>209</page_number>

S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Mesh Refinements

The Offsetting Parameter dialog box is displayed.

Offsetting Parameter dialog box - Interface Layering tab

Offsetting Parameter dialog box - Interface Block tab

3. Specify the fields on the required tabs, and then click **Save**.

4. (Optional) Select **includeExterior** to include the exterior material or region.

5. (Optional) Select **normalSmoothing** to reorient the surface normals around high curvature areas to avoid tangled surfaces during the construction of analytic layers..

6. Click **Close**.

The corresponding Scheme extensions are:

```scheme
(sdedr:offset-block {"region" region | "material" material}
  "maxlevel" maxlevel)

(sdedr:offset-interface
  {"region" region1 region2 | "material" material1 material2}
  "hlocal" hlocal "factor" factor "window" x1 y1 z1 x2 y2 z2)

(sdesnmesh:offsetting ["includeExterior" includeExterior]
 ["normalSmoothing" normalSmoothing])
```

For example:

```scheme
(sdedr:offset-block "region" "R.SiEpi" "maxlevel" 10)

(sdedr:offset-interface "region" "R.SiEpi" "R.Oxide"
  "hlocal" 2e-4 "factor" 1.5 "window" 0.0 0.0 0.0 0.1 0.2 0.5)

(sdesnmesh:offsetting "includeExterior" #t "normalSmoothing" #t)
```

<page_number>210</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles
Defining Doping Profiles

# Defining Doping Profiles

This section describes how to define doping profiles.

## Defining Constant Doping Profiles

To define a constant doping profile:

1. Choose **Device** > **Constant Profile Placement**, or click the corresponding toolbar button (see Table 14 on page 13).

The Constant Profile Placement dialog box is displayed.

2. Edit the **Placement Name** field as needed (ConstantProfilePlacement_\<index\> is the default name), or select the name of a previously defined constant profile for editing.

Constant Profile Placement dialog box

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

211
</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

3. Under Placement Type, select a Ref/Eval window as discussed in Step 3 of Regular Mesh Refinement Boxes on page 202.

4. Under Constant Profile Definition, edit the **Name** field as needed (the default name is `ConstantProfileDefinition_<index>`).

You can link an existing constant profile definition to the current constant profile placement by selecting it from the corresponding list.

5. Select a species from the list, which contains the most common dopant species. Select **Other** to access the complete list of DATEX variables. Enter a value for the concentration of the dopant.

6. To activate smoothing of the otherwise abrupt doping profile at Ref/Eval boundaries, enter a nonzero decay length in the **Decay Length** field and select **On**.

In this case, doping profiles are smoothed using an error function with an inflection length given by the specified decay length. Note that, in this case, the doping value at Ref/Eval boundaries is half of the specified concentration.

For details, see Sentaurus™ Mesh User Guide, Placing Constant Profiles on page 27 and Sentaurus™ Mesh User Guide, Lateral Error Function on page 154.

7. Select the replacement option:

* Select **Replace** to replace all other previously defined profiles with this doping profile.

* Select **LocalReplace** to replace only the doping species being defined.

* Select **NoReplace** to add the new profile to all previously defined profiles.

Omit this step when reusing an existing refinement definition.

8. When you have completed the constant profile specification, click **Add Placement**.

After the specification is added, the **Add Placement** button changes to **Change Placement**, and the **Delete Placement** button becomes available.

The Scheme extensions for creating constant doping profiles are:

```scheme
(sdedr:define-refeval-window rfwin-name "Rectangle" | "Cuboid"
  position position)

(sdedr:define-constant-profile definition-name species concentration)

(sdedr:define-constant-profile-placement placement-name definition-name
  rfwin-name [decay-length] ["Replace" | "LocalReplace"])

(sdedr:define-constant-profile-material placement-name definition-name
  material-name [decay-length] ["Replace" | "LocalReplace"])

(sdedr:define-constant-profile-region placement-name definition-name
  region-name [decay-length] ["Replace" | "LocalReplace"])
```

<page_number>212</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

7: Generating Mesh and Doping Profiles

Defining Doping Profiles

For example:

```
(sdedr:define-constant-profile "Const.BG" "BoronActiveConcentration" 1e7)
(sdedr:define-constant-profile-material "PlaceCD.BG" "Const.BG" "GaAs")

(sdedr:define-constant-profile "Const.GaAsCap"
"ArsenicActiveConcentration" 3e18)
(sdedr:define-constant-profile-region "PlaceCD.GaAsCap" "Const.GaAsCap"
"R.GaAsCap" 2 "Replace")
```

# Defining Analytic Doping Profiles

To define an analytic doping profile:

1. Choose **Device** > **Analytic Profile Placement**, or click the corresponding toolbar button (see Table 14 on page 13).

The Analytical Profiles dialog box is displayed.

2. Edit the **Placement Name** field as needed (`AnalyticalProfilePlacement_<index>` is the default name), or select the name of a previously defined analytic profile for editing.

3. Select a previously defined Ref/Eval window from the **Ref/Eval Window** list.

4. Under Profile Definition, edit the **Name** field as needed (the default name is `AnalyticalProfileDefinition_<index>`).

You can link an existing analytic profile definition to the current analytic profile placement by selecting it from the corresponding list.

5. Under Profile Definition, select a species from the list, which contains the most common dopant species. Select **Other** to access the complete list of DATEX variables.

6. Under Profile Definition, from the **Profile Type** list, select the profile type along the primary direction (orthogonal to the baseline, that is, a Ref/Eval window) from the following options:

* **Gaussian**: Under Primary Direction Profile (Gauss), select **Peak Concentration** or **Dose**, and enter the value of the peak concentration in units of cm<sup>-3</sup> or the dose in units of cm<sup>-2</sup>.

Enter the distance of the peak position to the baseline (Ref/Eval window) in μm.

Define the broadening of the profile by selecting **Standard Deviation** or **Diffusion Length** from the list, and entering the corresponding distance in μm.

Alternatively, define the broadening by selecting **Junction** and entering the concentration at junctions in units of cm<sup>-3</sup> and the requested distance from the peak position to the junction in μm. In this case, the standard deviation of the Gaussian profile is computed automatically.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>213</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

*   **Error Function**: Under Primary Direction Profile (Gauss), select **Max Concentration** or **Dose**, and enter the value of the maximum concentration in units of cm<sup>-3</sup> or the dose in units of cm<sup>-2</sup>.

    Enter the distance of the inflection point to the baseline (Ref/Eval window) in μm.

    Define the broadening of the profile by selecting **Standard Deviation** or **Diffusion Length** from the list, and entering the corresponding distance in μm.

    Alternatively, define the broadening by selecting **Junction** and entering the concentration at junctions in units of cm<sup>-3</sup> and the requested distance from the peak position to the junction in units of μm. In this case, the broadening parameter of the error function profile is computed automatically.

*   **1D Profile**: Enter the relative path and the file name of an external 1D profile in `.plx` format. Click **Browser** to open a file browser.

    You can restrict the external 1D profile to a certain range. Enter the starting 1D coordinate of the external 1D profile in the **From** field and the ending 1D coordinate in the **To** field. In the **Units** field, declare the unit of length in which the external 1D profile coordinates are given. (For example, if the coordinate range in the external 1D profile is -300 nm to 10000 nm, and the baseline should be aligned with a coordinate of 500 nm, and noisy tails beyond 3000 nm should be ignored, enter 500 in the **From** field and 3000 in the **To** field, and select **Nanometer** in the **Units** field.) In the **Data Scale** field, enter the data scaling factor.

    For a 1D profile, the species is read from the `.plx` data file and the selection in the **Species** field is ignored.

*   **Analytic Function**: Enter a formula in the **Function** field. For example: `a*sin(x)*cos(y)`

    Enter the initialization definition of any constants used in the formula in the **Initialization** field. For example: `a=2*10^18`

    Select the coordinate system to use for evaluating the analytic formula. Select **General** if the x-, y-, and z-coordinates of the formula are to be interpreted in the coordinate system of the device. Select **Eval** if x refers to the primary direction, and y and z refer to the lateral directions.

7. Under Lateral Direction Diffusion, select the profile type along the lateral direction (parallel to the baseline, that is, the Ref/Eval window) as **Gaussian** or **Error Function**.

Select from the list how the lateral-broadening parameter is defined:

*   **Factor** computes the lateral-broadening parameter by multiplying the primary-broadening parameter with a given factor.

*   **Standard Deviation** or **Diffusion Length** defines the broadening parameter explicitly. Enter the respective value in the corresponding field.

<page_number>214</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**7: Generating Mesh and Doping Profiles**
Defining Doping Profiles

8. To restrict the evaluation of the analytic profile to only one side of the baseline, under Eval Direction, select **Positive** or **Negative**.

Analytical Profiles dialog box

In two dimensions, for a positive evaluation direction, the profile is evaluated only to the right side of the baseline vector. In three dimensions, the profile is evaluated only along the positive direction of the baseline face normal. Select **Both** to evaluate the profile on both sides.

9. If needed, select the **EvalWindow** option to restrict the evaluation of the analytic profile further to a certain area. Profiles can be restricted to another Ref/Eval window by selecting **Ref/Win** and then the name of the Ref/Eval window, or to a region or a material, by selecting **Region** or **Material**, and selecting the region or material.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>215</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

10. To activate smoothing at Ref/Eval window boundaries, enter a nonzero decay length in the **Decay Length** field. In this case, the doping profiles are smoothed using an error function with an inflection length given by the specified decay length.

Note that, in this case, the doping value at Ref/Eval window boundaries is half of the specified concentration.

For details, see Sentaurus™ Mesh User Guide, Placing Constant Profiles on page 27 and Sentaurus™ Mesh User Guide, Lateral Error Function on page 154.

11. Select the replacement option:

*   Select **Replace** to replace all other previously defined profiles with this doping profile.

*   Select **LocalReplace** to replace only the doping species being defined.

*   Select **NoReplace** to add the new profile to all previously defined profiles.

12. Select **Not Eval** to suppress the evaluation of the analytic profile at the baseline itself. Use this option, for example, to avoid double-counting at region interfaces, where two different analytic profiles of the same species meet.

13. When you have completed the specification, click **Add Placement**.

After the specification is added, the **Add Placement** button changes to **Change Placement**, and the **Delete Placement** button becomes available.

The Scheme extensions for creating analytic doping profiles are as follows.

## Gaussian profile definition:

```scheme
(sdedr:define-gaussian-profile definition-name species "PeakPos" peak-position
  {"PeakVal" peak-concentration | "Dose" dose}
  {"ValueAtDepth" concentration-at-depth "Depth" depth |
  "Length" diffusion-length | "StdDev" standard-deviation}
  ["Gauss"|"Erf" "Factor" factor] | ["Eval" "init-string" "function-string"])
```

## Error function profile definition:

```scheme
(sdedr:define-erf-profile definition-name species
  "SymPos" inflection-point
  {"MaxVal" max-concentration | "Dose" dose}
  {"ValueAtDepth" concentration-at-depth "Depth" depth |
  "Length" diffusion-length | "StdDev" standard-deviation}
  ["Gauss"|"Erf" "Factor" factor] | ["Eval" "init-string" "function-string"])
```

<page_number>216</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles

Defining Doping Profiles

External 1D profile definition:

```
(sdedr:define-1d-external-profile definition-name plx-file-name
 "Scale" coordinate-scaling-factor-to-um
 "DataScale" data-file-scaling-factor "Range" range-start range-end
 ["Gauss" | "Erf" "Factor" factor] | ["Eval" "init-string" "function-string"])
```

Analytic formula definition:

```
(sdedr:define-analytical-profile definition-name species init formula
 default-value ["general"])
```

Placement of the analytic profile:

```
(sdedr:define-analytical-profile-placement placement-name definition-name
 RefEval-name
 {"Both" | "Positive" | "Negative"}
 {"Replace" | "NoReplace" | "LocalReplace"}
 {"Eval" | "NoEval"}
 [RefEval-name decay-length "evalwin" | region-name decay-length "region" |
  material-name decay-length "material"])
```

For example, to place a Gaussian profile:

```
; - Halo implantation
; -- baseline definitions
(sdedr:define-refeval-window "BaseLine.Halo" "Line"
 (position 0.02 0.0 0) (position 0.40 0.0 0))
; -- implant definition
(sdedr:define-gaussian-profile "Impl.Haloprof" "BoronActiveConcentration"
 "PeakPos" 0 "PeakVal" 1.5e18
 "ValueAtDepth" 1.5e17 "Depth" 0.07
 "Gauss" "Factor" 1.0)
; -- implant placement
(sdedr:define-analytical-profile-placement "Impl.Halo" "Impl.Haloprof"
 "BaseLine.Halo" "Positive" "NoReplace" "Eval")
```

For example, to place a profile given by an analytic formula:

```
; Linear mole fraction profile 0.16 at base-col to 0 at base-emitter
(sdedr:define-refeval-window "BaseLine.Mole" "Line"
 (position -0.45 0.5 0.0) (position 1.25 0.5 0.0))
(sdedr:define-analytical-profile "Prof.Mole" "xMoleFraction"
 "a=0.16/0.075" "0.1*a*x" 0.1)
(sdedr:define-analytical-profile-placement "Place.Mole" "Prof.Mole"
 "BaseLine.Mole" "Positive" "NoReplace" "Eval" "RWindow.BC" 0 "evalwin")
```

Sentaurus™ Structure Editor User Guide

<page_number>217</page_number>

S-2021.06

7: Generating Mesh and Doping Profiles
Defining Doping Profiles

# Including External 2D and 3D Doping Profiles

You can include external 2D or 3D doping profiles in a device structure. Such profiles are generated typically by process simulators, such as Sentaurus Process. Often the extent of the external doping profile matches the device geometry, which is the case when Sentaurus Structure Editor is used to simplify and mesh a structure generated by Sentaurus Process before it is passed to Sentaurus Device.

However, external doping profiles do not have to match the device geometry. Sentaurus Mesh extends automatically the doping profile to fill the evaluation window or cuts out the part that lies outside of the evaluation window. The alignment of the external doping profile with the evaluation window can also be specified. Furthermore, profiles can be reflected or rotated.

In addition, if a 2D profile is included in a 3D device structure, then the profile is extended automatically. If the global coordinates of the 2D profile itself lie already in the correct cross section of the 3D device structure, then no user intervention is needed for the profile extension. Otherwise, an appropriate transformation must be applied.

To include an external 2D or 3D doping profile in a device structure:

1. Choose **Device** > **External Profile Placement**, or click the corresponding toolbar button (see Table 14 on page 13).

The External Profile Placement dialog box is displayed.

2. Edit the **Placement Name** field as needed (`ExternalProfilePlacement_<index>` is the default name), or select the name of an existing external profile specification for editing.

3. Under **Evaluation Window Type**, select **Ref/Eval Win**, **Region**, or **Material** as discussed in Step 3 of Regular Mesh Refinement Boxes on page 202.

To place the external profile in the entire device, select **Ref/Eval Win** and leave the field empty.

4. Under **External Profile Definition**, edit the **Name** field as needed (the default name is `ExternalProfileDefinition_<index>`).

You can link an existing external profile definition to the current external profile placement by selecting it from the corresponding list.

5. In the **Geometry File** field, enter the name of the TDR file that contains the required external profile. Click **Browser** to open a file browser.

6. To define an evaluation window, select **Define Evaluation Window**. Enter the coordinates for the opposite vertices of the evaluation window, and click **Define**.

<page_number>218</page_number> Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles
Defining Doping Profiles

7. Under Lateral Decay, to activate smoothing at Ref/Eval window boundaries, define a nonzero decay length in the field provided. Select **Decay Length** to use an error function or **Gauss Decay Length** to use a Gaussian function.

External Profile Placement dialog box

8. Select the replacement option:

*   Select **Replace** to replace all other previously defined profiles with this doping profile.

*   Select **LocalReplace** to replace only the doping species being defined.

*   Select **NoReplace** to add the new profile to all previously defined profiles.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

219
</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

9. Under Shift/Reflect/Rotate, define the geometric transformations of translation, reflection, and rotation:

a) Click **New** to create a transformation operation.

A dialog box is displayed.

b) Select **Shift**, **Reflect**, or **Rotation** and enter the required values to characterize the operation, and then click **Create**.

The new operation appears in the list.

c) To add more operations after, at least, one has been defined, click **Prepend** or **Append**. To place the new operation *within* the list instead of at the beginning or end of the list, select one of the operations in the list, and click **Prepend** or **Append**.

d) To modify an operation, select an operation in the list and click **Edit**.

e) To delete an operation, select an operation in the list and click **Delete**.

f) To reorder the operations in the list, select one operation and drag it to a new location in the list.

**NOTE** Sentaurus Structure Editor respects the order of transformation operations. Operations are passed to Sentaurus Mesh in the order they appear in the list.

10. When you are finished, click **Add Placement**.

After the external profile is added, the **Add Placement** button changes to **Change Placement**, and the **Delete Placement** button becomes available.

The Scheme extensions for defining and placing external profiles are:

```
(sdedr:define-submesh definition-name TDR-file-name)

(sdedr:define-submesh-placement placement-name definition-name rfwin-name
  ["PlacementType" {"region" | "material" | "evalwin"}]
  {["DecayLength" decay-length] | ["GaussDecayLength" gauss-decay-length]}
  ["Replace" | "NoReplace" | "LocalReplace"] ["IgnoreMat"]
  ["MatchMaterialType"])
```

See Sentaurus™ Mesh User Guide, Defining Submeshes on page 22 for details.

In addition, for transformation operations, the following Scheme extension appends transformations to the named submesh placement. Any number of transformations can be appended in one call of this Scheme extension, which can be called as many times as necessary. Transformations are appended and applied in the specified order:

```
(sdedr:transform-submesh-placement placement-name
  [<transform1> <transform2> ... <transformN>])
```

<page_number>220</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles

Defining Doping Profiles

Here, `<transformX>` is any one of these transformations:

*   "Reflect" axis
*   "Rotation" angle axis
*   "ShiftVector" (gvector `<coord>` `<coord>` `<coord>`)

where:

*   axis can be "X", "Y", or "Z".

*   angle, coord are floating-point numbers for the angle and for the x-, y-, and z-coordinates.

# Examples

Clear all transformations defined for the named submesh placement:

```scheme
(sdedr:clear-submesh-placement-transform "SubmeshPlacementName")
```

The following 2D examples use a common set of Scheme extensions to create a simplified device structure and to define a meshing strategy:

```scheme
(sde:clear)
(sdegeo:create-rectangle (position -0.445 0.0 0) (position 0.0 0.5 0)
 "Silicon" "region_L")
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 0.445 0.5 0)
 "Silicon" "region_R")
(sdedr:define-refinement-size "RefinementDefinition_1" 0.25 0.5 0.001 0.001)
(sdedr:define-refinement-material "RefinementPlacement_1"
 "RefinementDefinition_1" "Silicon")
(sdedr:define-refinement-function "RefinementDefinition_1"
 "DopingConcentration" "MaxTransDiff" 1)
```

Starting with the previous Scheme script, the following examples present different variations of including an external doping profile.

Include an external doping profile called `n34_fps.tdr` in the entire device structure:

```scheme
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
 "ExternalProfileDefinition_1" "" "NoReplace")
```

> **NOTE** The empty string before "NoReplace" indicates that the profile will be included in the entire device structure. The profile is extended to regions of the device structure that are not covered by the external profile.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

221
</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

Restrict the inclusion of the external doping profile to a Ref/Eval window and reflect the external profile using a mirror plane that goes through the bounding box center of the external profile and is orthogonal to the x-axis:

```
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle"
  (position 0.0 0.0 0) (position 0.445 0.4 0))
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
  "ExternalProfileDefinition_1" "RefEvalWin_1" "NoReplace")
(sdedr:transform-submesh-placement "ExternalProfilePlacement_1" "Reflect" "X")
```

Shift the external profile by 0.445 μm to the left, and include it in all silicon regions:

```
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
  "ExternalProfileDefinition_1" "Silicon" "PlacementType" "Material"
  "NoReplace")
(sdedr:transform-submesh-placement "ExternalProfileDefinition_1"
  "ShiftVector" (gvector -0.445 0.0 0.0))
```

Reflect and shift the external profile by 0.445 μm to the left, and include it only in a given region:

```
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
  "ExternalProfileDefinition_1" "region_L" "PlacementType" "Region"
  "NoReplace")
(sdedr:transform-submesh-placement "ExternalProfileDefinition_1"
  "ShiftVector" (gvector 0.445 0 0) "Reflect" "X")
```

Include the same profile twice, once at its original location, and once reflected and shifted:

```
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
  "ExternalProfileDefinition_1" "region_R" "PlacementType" "Region")
(sdedr:define-submesh-placement "ExternalProfilePlacement_2"
  "ExternalProfileDefinition_1" "region_L" "PlacementType" "Region"
  "NoReplace")
(sdedr:transform-submesh-placement "ExternalProfilePlacement_2"
  "ShiftVector" (gvector 0.445 0 0) "Reflect" "X")
```

<page_number>222</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles

Defining Doping Profiles

Five plots (a-e) showing different 2D external doping profile inclusion options in a semiconductor structure, with X and Y axes in micrometers.

Figure 113 Including external doping profiles using different options: (a) simple inclusion; (b) reflections and Ref/Eval window; (c) shift; (d) reflect, shift, and region restriction; and (e) using the same profile twice

The following example illustrates how to include a 2D external doping profile in a simple 3D structure. Both examples use a common set of Scheme extensions to create a simplified device structure and to define a meshing strategy:

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 0.445 0.445 0.445)
           "Silicon" "region_p1")
(sdedr:define-refinement-size "RefinementDefinition_1"
           0.2 0.2 0.2
           0.004 0.004 0.004)
```

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

223
</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

```
(sdedr:define-refinement-material "RefinementPlacement_1"
 "RefinementDefinition_1" "Silicon")
(sdedr:define-refinement-function "RefinementDefinition_1"
 "DopingConcentration" "MaxTransDiff" 1)
```

Include the profile without any alignment:

```
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
 "ExternalProfileDefinition_1" "Silicon" "PlacementType" "Material"
 "NoReplace")
```

**NOTE** The 2D profile lies in the xy plane. The simple inclusion results in an extrusion of the profile along the z-axis.

Rotate the profile into the xz plane before inclusion:

```
(sdedr:define-submesh "ExternalProfileDefinition_1" "n34_fps.tdr")
(sdedr:define-submesh-placement "ExternalProfilePlacement_1"
 "ExternalProfileDefinition_1" "Silicon" "PlacementType" "Material"
 "NoReplace")
(sdedr:transform-submesh-placement "ExternalProfilePlacement_1"
 "Rotation" -90 "X" "ShiftVector" (gvector 0 0 0.445))
```

3D structure showing external doping profile inclusion in xy plane (left) and xz plane (right)

Figure 114 Including a 2D external doping profile in a 3D structure: (*left*) by default the profile lies in the xy plane and (*right*) using shifts and rotations to place the profile in the xz plane

<page_number>224</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

7: Generating Mesh and Doping Profiles
Defining Doping Profiles

# Defining Particle Doping Profiles

To define a particle doping profile:

1. Choose **Device** > **Particle Profile Placement**, or click the corresponding toolbar button (see Table 14 on page 13).

The Particle Profiles dialog box is displayed.

Particle Profiles dialog box

2. Edit the **Placement Name** field as needed (`ParticleProfilePlacement_<index>` is the default name), or select the name of an existing particle profile specification for editing.

3. Under Evaluate Window, select **Ref/ Win** and a Ref/Eval window as discussed in Step 3 of Regular Mesh Refinement Boxes on page 202.

4. Under Particle Profile Definition, edit the **Name** field as needed (the default name is `ParticleProfileDefinition_<index>`).

You can link an existing particle profile definition to the current particle profile placement by selecting it from the corresponding list.

5. Edit the **ParticleFile** field, or click **Browse** to select the file.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

225
</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Doping Profiles

6. Optionally, from the **Species** list, select a species that contains the most common dopant species:

* Select **Other** to access the complete list of DATEX variables.

* Select **blank** at the end of the list so as not to use **Species**. The **blank** species is the default.

7. Optionally, enter values for **ScreeningFactor**, **ScreeningScalingFactor**, **BoundaryExtension**, and **Divisions**. If required, select **Normalization** and **AutoScreeningFactor**.

For details, see Sentaurus™ Mesh User Guide, Placing Constant Profiles on page 27 and Sentaurus™ Mesh User Guide, Defining Particle Profiles on page 15.

8. Select the replacement option:

* Select **Replace** to replace all other previously defined profiles with this doping profile.

* Select **LocalReplace** to replace only the doping species being defined.

* Select **NoReplace** to add the new profile to all previously defined profiles.

Omit this step when reusing an existing refinement definition.

9. When you have finished, click **Add Placement**.

After the specification is added, the **Add Placement** button changes to **Change Placement**, and the **Delete Placement** button becomes available.

The Scheme extensions for creating particle doping profiles are sdedr:define-particle-profile on page 536, sdedr:define-particle-profile-placement on page 537, and sdedr:define-refeval-window on page 538.

For example:

```
(sdedr:define-refeval-window "RefEvalWin_1" "Rectangle" (position -1 -0.5 0)
  (position -0.5 0 0))
(sdedr:define-particle-profile "ParticleProfileDefinition_1" "particlefile"
  "Species" "BoronActiveConcentration" "ScreeningFactor" 1
  "BoundaryExtension" 5 "Divisions" 10 "AutoScreeningFactor" #t
  "Normalization" #t "NumberOfThreads" 4 "DopingAssignment" "CIC")
(sdedr:define-particle-profile-placement "ParticleProfilePlacement_1"
  "ParticleProfileDefinition_1""EvalWindow" "RefEvalWin_1" "evalwin"
  "Replace" #t)
```

<page_number>226</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles
Controlling the Boundary Tessellation

# Controlling the Boundary Tessellation

This section discusses boundary tessellation.

## Global Tessellation Settings

Internally, Sentaurus Structure Editor uses a representation of geometric bodies that can include curved boundaries, for example, regions with circular or spline boundary edges in two dimensions, and regions with cylindrical or spherical boundary faces. In addition, certain sweep and revolve operations lead to curved boundaries.

Other TCAD Sentaurus tools, however, work exclusively with polyhedral boundaries. When exporting a device boundary, Sentaurus Structure Editor approximates all boundaries by a sequence of straight line segments (in two dimensions) or by patches of flat triangles (in three dimensions). This process is called *tessellation*. To save the tessellated boundary, use the `sdeio:save-tdr-bnd` Scheme extension (see sdeio:save-tdr-bnd on page 751) or choose **File > Save Boundary As** (or **Save Boundary**).

Converting the curved boundary to a polyhedral patch is not unique, and you can control the tessellation process.

### Available Faceters

Two faceters are available to tessellate the internal (2D or 3D, possibly curved) model geometry. If a TDR boundary is saved using the `sdeio:save-tdr-bnd` Scheme extension, then you can use the `"faceter"` argument to select the faceter from either `"v1"` (default) or `"v2"`.

In some cases, the `"v2"` faceter provides better quality tessellation, especially in three dimensions, when curved spline faces are present in the native model geometry.

The control parameters of *both faceters* can be set by using the `sdeio:save-tdr-bnd` Scheme extension. The faceters are controlled by the following:

*   **Surface tolerance** refers to the allowable maximum deviation (distance, in global coordinates) between the internal curved representation and the tessellated output.

*   **Normal tolerance** is the maximum difference (in degrees) that is allowed between the surface normals of the internal curved representation and the face normals of the tessellated output.

*   **Aspect ratio** is the preferred aspect ratio of the boundary tessellation triangles.

*   **Maximum edge length** is the maximum-allowed edge length in the tessellated output.

Sentaurus™ Structure Editor User Guide
<page_number>227</page_number>
S-2021.06

# 7: Generating Mesh and Doping Profiles

Controlling the Boundary Tessellation

If the exported boundary contains an excessive number of elements and meshing takes a long time, then the values of the surface and normal tolerances might need to be relaxed. However, if important geometric features of the structure are not resolved in the exported boundary, then the surface tolerance and normal tolerance values might need to be decreased.

In addition to controlling the "v1" faceter by using `sdeio:save-tdr-bnd`, you can control the "v1" faceter by a global refinement setting.

To set the parameters for the "v1" faceter:

1. Choose **Mesh** > **Global Refinement**.

The Refinement Control dialog box opens.

Refinement Control dialog box

2. Enter the values for the surface tolerance, the normal tolerance, the aspect ratio, and the maximum edge length.

3. Click **OK**.

The corresponding Scheme extension is:

```
(sde:setrefprops surface-tolerance normal-tolerance
 [aspect-ratio max-edge-length])
```

## Examples

To follow the examples here, activate the facets rendering mode by choosing **View** > **Render** > **Facets** or clicking the corresponding toolbar button (see Table 5 on page 11).

### Effect of Surface Tolerance

The following example illustrates the effect of surface tolerance:

```
(sde:clear)
(sdegeo:create-sphere (position 0.0 0.0 0.0) 1.0 "Silicon" "region_1")
; (a) Default settings:
(sde:setrefprops -1 15 0 0)
; (b) Relax all settings:
(sde:setrefprops 0 90 0 0)
; (c) Tight surface tolerance
(sde:setrefprops 0.001 90 0 0)
```

<page_number>228</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 7: Generating Mesh and Doping Profiles

Controlling the Boundary Tessellation

Sphere with default surface tessellation

Sphere with relaxed surface tessellation

Sphere with tight surface tolerance

Figure 115 Controlling surface tessellation: (*left*) default settings, (*middle*) relaxed settings, and (*right*) tight surface tolerance only

## Effect of Normal Tolerance

This example illustrates the effect of normal tolerance:

```scheme
(sde:clear)
(sdegeo:create-cylinder (position 0.0 0.0 -1.0) (position 0.0 0.0 1.0) 1.0
  "Silicon" "region_2")
; (a) Default settings:
(sde:setrefprops -1 15 0 0)
; (b) Relax all settings:
(sde:setrefprops 0 90 0 0)
; (c) Tight normal tolerance
(sde:setrefprops 0 5 0 0)
```

Cylinder with default normal tolerance

Cylinder with relaxed normal tolerance

Cylinder with tight normal tolerance

Figure 116 Controlling surface tessellation: (*left*) default settings, (*middle*) relaxed settings, and (*right*) tight normal tolerance only

Tighter surface and normal tolerances create more facets. Both parameters work effectively in a similar way, but use a slightly different criterion.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>229</page_number>

# 7: Generating Mesh and Doping Profiles

Controlling the Boundary Tessellation

## Effect of the Aspect Ratio

The following example illustrates the effect of the aspect ratio:

```scheme
(sde:clear)
(sdegeo:create-ellipse (position 0.0 0.0 0.0) (position 1.0 0.0 0.0)
  0.05 "Silicon" "region_1")
; (a) Default settings:
(sde:setrefprops -1 15 0 0)
; (b) Relax all settings:
(sde:setrefprops 0 90 0 0)
; (c) Aspect ratio
(sde:setrefprops 0 90 1.0 0)
```

Visual representation of surface tessellation with different aspect ratio settings

Figure 117 Controlling surface tessellation: (*top*) default settings, (*middle*) relaxed settings, and (*bottom*) tight aspect ratio only

The aspect ratio setting does not create new nodes (2D) or faces (3D). Instead, an aspect ratio setting of 1 favors a tessellation for which the surface triangles are closer to equilateral by flipping internal edges.

## Effect of Maximum Edge Length

This example illustrates the effect of the maximum edge length:

```scheme
(sde:clear)
(sdegeo:create-cuboid (position -1.0 -1.0 -1.0) (position 1.0 1.0 1.0)
  "Silicon" "region_3")
; (a) Default settings:
(sde:setrefprops -1 15 0 0)
; (b) Tight normal tolerance
(sde:setrefprops 0 90 0 0.5)
```

For the specification of the surface tolerance, certain values have a predefined meaning. For example, a value of zero deactivates this refinement criterion. While positive values such as 0.01 refer to an absolute distance in the current units (for example, 0.01 μm), certain negative values define the tolerance distance as a fraction of the bounding box. A negative surface tolerance means that the tolerance depends on the size of the diagonal of the bounding box; the absolute value of the negative number is multiplied by a fraction (1/500) of the diagonal of the bounding box.

<page_number>230</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**7: Generating Mesh and Doping Profiles**

Controlling the Boundary Tessellation

Engineering drawing showing surface tessellation with default settings (left) and maximum edge length only (right)

Figure 118 Controlling surface tessellation: (*left*) default settings and (*right*) maximum edge length only

Table 31 Predefined values to specify the required surface tolerance

<table>
  <thead>
    <tr>
        <th>Surface tolerance value</th>
        <th>Definition</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>0</td>
        <td>Switches off or ignores the surface tolerance refinement criteria</td>
    </tr>
    <tr>
        <td>–0.1</td>
        <td>1/5000th of the box</td>
    </tr>
    <tr>
        <td>–1</td>
        <td>1/500th</td>
    </tr>
    <tr>
        <td>–10</td>
        <td>1/50th</td>
    </tr>
    <tr>
        <td>...</td>
        <td>...</td>
    </tr>
  </tbody>
</table>

# Tessellating Spherical Faces

The default "v1" faceter triangulates spherical faces in such a way that a pole is not visible in the tessellated surface. This minimizes the vertex connectivity at each vertex.

By default, in the `sdeio:save-tdr-bnd` Scheme extension, the argument "grid mode" is set to "AF_GRID_ONE_DIR" (see sdeio:read-tdr-bnd on page 748).

For example:

```scheme
(sde:clear)
(sdegeo:create-cuboid (position -1.0 -1.0 -1.0) (position 1.0 1.0 1.0)
"Silicon" "region_1")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>231</page_number>

# 7: Generating Mesh and Doping Profiles

Controlling the Boundary Tessellation

```scheme
(sdegeo:fillet (list
 (car (find-edge-id (position 0 1 1)))
 (car (find-edge-id (position 1 1 0)))
 (car (find-edge-id (position 1 0 1)))) 0.4)
(sdeio:save-tdr-bnd (get-body-list) "spherical-face-tessellation.tdr")
```

Figure 119 illustrates the effect of the tessellation algorithm.

Tessellation with visible pole using AF_GRID_TO_EDGES

Improved faceting around the pole area using AF_GRID_ONE_DIR

Figure 119 Tessellating spherical faces: visible pole with (*left*) "grid mode" "AF_GRID_TO_EDGES" and (*right*) "grid mode" "AF_GRID_ONE_DIR"

---

# Boundary Tessellation in Three Dimensions

Sentaurus Structure Editor creates the TDR boundary output by using the *faceter component*. During model generation, Sentaurus Structure Editor creates a native model with solid bodies that can have nonplanar faces (for example, procedural faces such as spherical, cylindrical, toroidal, or spline faces). The default faceter component can tessellate these faces (generating a polyhedral approximation of the native model) that is written to the TDR boundary output.

The quality of the tessellation is very important, since the meshing engines use the tessellated boundary to create a volume mesh. If the tessellation quality is not good (sliver faces for example), then the meshing engines might be unable to create a volume mesh.

The tessellated TDR boundary can be saved using the `sdeio:save-tdr-bnd` Scheme extension.

**NOTE** If the `(option:set "hoops_direct_render" #t)` command is used, then the GUI shows the faceted model that will be written to the TDR boundary output. You can use the command `(render:rebuild)`, or right-click and choose **Show All**, to refresh the screen and to show the current faceting.

<page_number>232</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

7: Generating Mesh and Doping Profiles
Defining Command File Sections Specific to Sentaurus Mesh

# Defining Command File Sections Specific to Sentaurus Mesh

This section discusses command file sections specific to Sentaurus Mesh.

## IOControls Section and Interpolate Section

You can define the parameters of the `IOControls` section and the `Interpolate` section by using the GUI or Scheme extensions (see sdesnmesh:iocontrols on page 784 and sdesnmesh:interpolate on page 783).

To define the parameters of the `IOControls` section:

1. Choose **Mesh** > **IOControls and Interpolate Parameters**.

The IOControls Parameters dialog box is displayed.

IOControls Parameters dialog box

2. Under IOControls Section, enter values for **inputFile**, or **outputFile**, or both in the corresponding boxes.

> **NOTE** If you specify **inputFile**, then it overrides the base name of the saved boundary file when you create the mesh by either choosing **Mesh** > **Build Mesh** (see Building the Mesh on page 242) or using the `sde:build-mesh` Scheme extension (see sde:build-mesh on page 407).

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

233
</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Command File Sections Specific to Sentaurus Mesh

See Sentaurus™ Mesh User Guide, IOControls Section on page 6 for descriptions of parameters.

3. Select other options as required.

> **NOTE** By default, **EnableSections** is selected, which means the option `EnableSections` is added to the `IOControls` section of the mesh command file by default.

4. Under Interpolate Section, select options as required.

See Sentaurus™ Mesh User Guide, Interpolate Section on page 33 for descriptions of parameters.

5. Click **Save**.

# AxisAligned Section

By default, the bisectional refinement algorithm of Sentaurus Mesh starts from the bounding box of the entire device structure. After all volume refinement criteria have been satisfied, interfaces are introduced. This can result in mesh spacing near the interface that is less than the requested mesh spacing.

The axis-aligned algorithm used in Sentaurus Mesh can partition the global bounding box into an array of subboxes. The bisectional refinement algorithm then operates independently in each partitioned boxes.

This feature can reduce mesh-induced numeric noise in parametric structures. For example, for the simulation of the threshold voltage roll-off characteristics of a given technology, you need to simulate the electrical characteristics of a set of transistors with different gate lengths, but identical source and drain areas.

Changing the gate length changes the mesh in the channel area. However, by placing partitioning lines between the gate and the source as well as drain areas, you ensure the mesh in the source and drain areas remains the same for all devices.

These partitioning lines (2D) or planes (3D) are defined using the `xCuts`, `yCuts`, and `zCuts` parameters of the `AxisAligned` section.

To define the parameters of the `AxisAligned` section:

1. Choose **Mesh > Axis-Aligned Parameters**.

- The Axis-Aligned Parameters dialog box is displayed.

2. Enter values for parameters, and select options as required.

<page_number>234</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 7: Generating Mesh and Doping Profiles

## Defining Command File Sections Specific to Sentaurus Mesh

See Sentaurus™ Mesh User Guide, AxisAligned Section on page 34 for descriptions of parameters.

### Axis-Aligned Parameters
**Axis-Aligned Parameters**
* **maxAngle**:     
* **maxAspectRatio**:     
* **maxNeighborRatio**:     
* **overscanResolution**:     
* **hintBoxSize**:     
* **maxBoundaryCutRatio**:     
* **smoothing**: [x]
* **imprintCoplanarFacesOnly**: [x]
* **overscan**: [ ]
* **fitInterfaces**: [ ]
* **imprintAccuracy**:     
* **imprintCoplanarityAngle**:     
* **imprintCoplanarityDistance**:     
* **xCuts**:     
* **yCuts**:     
* **zCuts**:     

**BinaryTree**
* **SplitBox min**:
    - **X**:     
    - **Y**:     
    - **Z**:     
* **SplitBox max**:
    - **X**:     
    - **Y**:     
    - **Z**:     
* **SplitFactor**:
    - **X**:     
    - **Y**:     
    - **Z**:     

**Lattice**
* **CellSize**:
    - **X**:     
    - **Y**:     
    - **Z**:     
* **Dimensions**:
    - **X**:     
    - **Y**:     
    - **Z**:     

* **virtualSpacing**: [ ]
* **convexTriangulation**: [ ]
* **skipSameMaterialInterfaces**: [ ]
* **splitDisconnectedRegions**: [ ]
* **spacingMethod**: none (dropdown)

[Save] [Cancel]

3. Click **Save**.

Sentaurus™ Structure Editor User Guide

<page_number>235</page_number>

S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Command File Sections Specific to Sentaurus Mesh

The corresponding Scheme extension is sdesnmesh:axisaligned on page 777. For example:

```scheme
(sdesnmesh:axisaligned "yCuts" (list 0.1 0.5 2.0))
```

## Delaunizer Section

The Delaunizer section controls the behavior of the delaunization algorithms used in Sentaurus Mesh.

To define the parameters of the Delaunizer section:

1. Choose **Mesh** > **Delaunizer Parameters**.

The Delaunizer Parameters dialog box is displayed.

**Delaunizer Parameters**

**Delaunizer Parameters**
* **type**:      (dropdown)
* **edgeProximity**:     
* **faceProximity**:     
* **sliverAngle**:     
* **sliverDistance**:     
* **maxPoints**:     
* **minAngle**:     
* **maxAngle**:     
* [ ] **storeDelaunayWeight**
* **coplanarityDistance**:     
* **coplanarityAngle**:     
* **minEdgeLength**:     
* **delaunayTolerance**:     
* **maxSolidAngle**:     
* **maxNeighborRatio**:     
* **maxConnectivity**:     
* **maxTetQuality**:     
* **sliverRemovalAlgorithm**:     
* **minDihedralAngleAllowed**:     
* **minEdgeLengthAllowed**:     

<table>
    <tr>
        <th>Tolerance</th>
        <th>Location</th>
        <th>Region/Material/Global</th>
        <th>Window</th>
    </tr>
    <tr>
        <td>    </td>
        <td>    </td>
        <td>    </td>
        <td>    </td>
    </tr>
</table>
* [New]
* [Edit]
* [Delete]

[Save] [Cancel]

<page_number>236</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**7: Generating Mesh and Doping Profiles**
Defining Command File Sections Specific to Sentaurus Mesh

2. Enter values for parameters as required.

See Sentaurus™ Mesh User Guide, Delaunizer Section on page 42 for descriptions of parameters.

3. Click **New**.

The Delaunay Tolerance dialog box is displayed.

Delaunay Tolerance dialog box

4. Enter values for parameters, and select options as required.

5. Click **Save** to close the Delaunay Tolerance dialog box.

6. Click **Save**.

The corresponding Scheme extensions are sdesnmesh:delaunizer on page 781 and sdesnmesh:delaunizer-tolerance on page 782. For example:

```
(sdesnmesh:delaunizer-tolerance 1 "boundary" "global")
(sdesnmesh:delaunizer-tolerance 0.0001 "boundary" "material" "Oxide"
    "Silicon")

(sdesnmesh:delaunizer "type" "boxmethod" "maxPoints" 100000
    "coplanarityDistance" 1e-05 "edgeProximity" 0.05 "faceProximity" 0.05
    "sliverAngle" 175 "sliverDistance" 0.01 "maxSolidAngle" 360
    "maxNeighborRatio" 1e+30 "coplanarityAngle" 175 "minEdgeLength" 1e-09
    "delaunayTolerance" 0.0001 "storeDelaunayWeight" #t)
```

Sentaurus™ Structure Editor User Guide <page_number>237</page_number>
S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Command File Sections Specific to Sentaurus Mesh

## Tensor Section

To define tensor mesh refinements:

1. Choose **Mesh** > **Tensor Parameters**.

The Tensor Block Editor is displayed.

2. Edit the Tensor section of the mesh command file as required.

For more information, see Sentaurus™ Mesh User Guide, Tensor Section on page 46.

3. Click **Save**.

The corresponding Scheme extension is:

```
(sdesnmesh:tensor "tensor-block-contents")
```

where "tensor-block-contents" is a string surrounded by double quotation marks that represents the required contents of the Tensor section of the mesh command file.

You must escape double quotation marks with a backslash within "tensor-block-contents". For example:

```
(sdesnmesh:tensor "Box {
  name = \"TensorBox1\"
  material = \"Silicon\"
  startPoint = (0 0 0)
  endPoint = (1.0 1.5 1.5)
  tolerance = 0.25
 }")
```

**NOTE** The previous Tensor section Scheme extensions are deprecated and cannot be used with `sdesnmesh:tensor` at the same time.

## Boundary Section

The Boundary section allows you to control the boundary-processing algorithms available in Sentaurus Mesh.

To define the Boundary section of the mesh command file:

1. Choose **Mesh** > **Boundary Operators**.

The Mesh Boundary Operations dialog box is displayed.

<page_number>238</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**7: Generating Mesh and Doping Profiles**

Defining Command File Sections Specific to Sentaurus Mesh

2. Select the required operations, and specify the parameters for those operations.

See Sentaurus™ Mesh User Guide, Boundary Section on page 57 for descriptions of parameters.

Mesh Boundary Operations dialog box

3. (Optional) Under RegionMismatch, select **Allow Region Mismatch** and enter the value for **minVolume** for the mismatch if you want Sentaurus Mesh to continue when a small region is lost during the meshing process.

4. (Optional) Under Save, enter a file name if you want to save the modified boundary after the operations are performed.

5. Click **Save**.

The corresponding Scheme extension is sdesnmesh:boundary on page 779. For example:

```scheme
(sdesnmesh:boundary "DelPSC" "accuracy" 0.001)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>239</page_number>

# 7: Generating Mesh and Doping Profiles

Defining Command File Sections Specific to Sentaurus Mesh

## Tools Section

To define the Tools section of the mesh command file:

1. Choose **Mesh > Tools Parameters**.

The Tools Block Editor is displayed.

2. Edit the contents of the Tools section of the mesh command file as required.

For more information, see Sentaurus™ Mesh User Guide, Tools Section on page 62.

3. Click **Save**.

The corresponding Scheme extension is:

```
(sdesnmesh:tools "tools-block-contents")
```

where "tools-block-contents" is a string surrounded by double quotation marks that represents the required contents of the Tools section of the mesh command file.

You must escape double quotation marks with a backslash within "tools-block-contents". For example:

```
(sdesnmesh:tools "RandomizeDoping { \
  DopingAssignment = \"Sano\" \
  NumberOfRandomizedProfiles = 1 \
  FileIndex = 1 \
  Material \"Silicon\" { \
    Species \"BoronActiveConcentration\" { \
      ScreeningFactor = 2.5e6 \
      AutoScreeningFactor \
    } \
    Species \"ArsenicActiveConcentration\" { \
      ScreeningFactor = 1.3e7 \
      AutoScreeningFactor \
    } \
  } \
}")
```

## QualityReport Section

You can define the QualityReport section of the mesh command file. This section can have one global block and multiple material and region blocks.

<page_number>240</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 7: Generating Mesh and Doping Profiles

Defining Command File Sections Specific to Sentaurus Mesh

To define the `QualityReport` section:

1. Choose **Mesh** > **Quality Report**.

The Mesh Quality Report dialog box is displayed.

2. Under Domain, select **Global**, **Material**, or **Region**.

3. Select the required items from the **Materials/Regions** list:

* For a **Material** domain, this list contains the DATEX materials of the model.

* For a **Region** domain, the list contains all region names of the model.

4. When the parameters are specified, click **Add**.

The defined block is listed in the lower pane.

5. (Optional) Select a list item and click **Edit** to edit the parameters and redefine the block.

6. (Optional) Select a list item and click **Delete** to remove it.

7. (Optional) Click **Clear** to delete all defined blocks of the `QualityReport` section.

Screenshot of the Mesh Quality Report dialog box showing Domain selection (Global, Material, Region), Materials/Regions list, quality parameters (Max Connectivity, Max NonDelaunay, Min Angle, Min Edge Length, Min Volume), and a table for defined blocks with Add, Edit, Delete, Close, and Clear buttons.

8. Click **Close** to exit the dialog box.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>241</page_number>

# 7: Generating Mesh and Doping Profiles

Building the Mesh

The corresponding Scheme extension is sdesnmesh:qualityreport on page 786.

# Building the Mesh

After all refinement and doping specifications have been created, you can mesh the structure by using Sentaurus Mesh.

To build the mesh:

1. Choose **Mesh** > **Build Mesh**.

The Build Mesh dialog box is displayed.

2. In the **Save Grid to File** field, enter the name of the file where the mesh will be saved, or click **Browser** to navigate to the required file.

Extensions such as .cmd, .Z, and .gz are removed from the file name to form the base name of the mesh command file.

**NOTE** If you specified `inputFile` in the `IOControls` section, then it overrides the base name of the saved boundary file.

Under Mesh Viewer, **SVisual** is selected by default to use Sentaurus Visual to view the created mesh.

Build Mesh dialog box

3. In the **Other options** field, enter command-line options as required.

See Sentaurus™ Mesh User Guide, Command-Line Options on page 3.

4. Click **Save Values** to save the global parameters without executing Sentaurus Mesh.

5. Click **Build Mesh** to create the mesh.

<page_number>242</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

