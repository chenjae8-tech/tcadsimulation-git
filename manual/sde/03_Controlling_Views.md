CHAPTER 3 Controlling Views

*This chapter describes the various options to control views available in Sentaurus Structure Editor.*

# Zooming, Panning, and Orbiting With Mouse Operations

To access the different modes of mouse operations:

* Choose **View** > **Interactive Mode**, or click the corresponding toolbar button (see Figure 5).

Toolbar buttons for zooming, panning, and orbiting with mouse operations

Figure 5 Toolbar buttons for zooming, panning, and orbiting with mouse operations

The options are:

**Zoom to Extents**

Resets the zoom factor so that the entire structure is displayed.

**Zoom to Window**

Drag to define a zoom window. The view is updated such that the defined zoom window is displayed as large as possible. (If the aspect ratio of the selected zoom window differs from the current view window aspect ratio, the zooming might appear to be less than expected.)

**Orbit**

In this mode, dragging adjusts the camera position in a way that simulates orbiting around the drawn structure. Both the position and path of the pointer during the dragging operation provide an intuitive mechanism for rotation about different axes. Dragging left or right along the middle of the view window rotates the structure about the vertical axis. Similarly, dragging up or down along the center of the view window rotates the structure about the

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>29</page_number>

# 3: Controlling Views

Interactive Cutting Plane Viewer

horizontal axis. Dragging up, down, left, or right near any edge of the view window rotates the structure about the axis perpendicular to the view window. Combinations of the movements are designed to give you control over the viewing angle of the drawn structure.

While the Orbit mode is active, different shortcut keys can be used to rotate the model about the imaginary coordinate axes of the screen (in the view window). Hold the key or keys when in Orbit mode:

* Rotate about x-axis (horizontal view) Shift+Orbit
* Rotate about y-axis (vertical view) Ctrl+Orbit
* Rotate about z-axis (perpendicular to view) Ctrl+Shift+Orbit

The `(sde:use-camera-manipulator #t)` function can be used to change these key functionalities to another type of behavior. (The `(sde:use-camera-manipulator #f)` command can be used to change it back.)

After the `(sde:use-camera-manipulator #t)` command is executed when in Orbit mode, the Ctrl key can be used to zoom and the Shift key can be used to pan (while pressing the left mouse button).

**Zoom**

In this mode, dragging upwards zooms in on the structure, and dragging downwards zooms out.

**Pan**

In this mode, dragging moves the structure around the view window.

# Interactive Cutting Plane Viewer

To access the interactive cutting plane viewer:

1. Choose **View** > **Interactive Mode** > **Cutting Plane**, or click the corresponding toolbar button.

2. Select either **Rotate X**, **Drag Y**, or **Rotate Z** to control the location of the cut plane. Enter the rotation or drag amount in the respective field or operate the dials with the mouse.

Alternatively, the cut plane can be manipulated directly in the view window by clicking the respective handles for rotating and dragging.

3. To suppress the display of the cut plane, either select **Remove Cut Plane on Close** and click **Close**, or toggle the Cutting Plane toolbar button.

<page_number>30</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**3: Controlling Views**

Perspective and Orthographic Views in Three Dimensions

Interactive cutting plane viewer: structure with cut plane (left) and Cut Plane Controller dialog box (right)

Figure 6 Interactive cutting plane viewer: structure with cut plane (*left*) and Cut Plane Controller dialog box (*right*)

---

# Perspective and Orthographic Views in Three Dimensions

Three-dimensional objects are displayed using either orthographic projection (more distant objects are drawn with their true height and width as closer objects) or perspective (the height and width of more distant objects are reduced according to their distance from the viewer).

To switch between the perspective and orthographic views when displaying 3D objects:

* Choose **View** > **Perspective**.

> **NOTE** Some GUI-supported operations such as 3D object creation (cube, cylinder, sphere) will change the view automatically to orthographic view.

Perspective view (left) and orthographic view (right)

Figure 7 (*Left*) Perspective view and (*right*) orthographic view

Sentaurus™ Structure Editor User Guide

<page_number>31</page_number>

S-2021.06

# 3: Controlling Views
Selecting the DATEX Color Scheme

# Selecting the DATEX Color Scheme

The `datexcodes.txt` file contains different color schemes for each DATEX material: Vivid and Classic.

By default, Sentaurus Structure Editor uses the Vivid color scheme to assign the color for each DATEX material for rendering. This means the **View > Vivid Colors (DATEX)** command is selected by default, indicated by a check mark.

To change to the Classic color scheme, choose **View > Vivid Colors (DATEX)**, so there is no check mark.

The selected color scheme is saved in the Sentaurus Structure Editor `.qt` configuration file. Therefore, when you exit and start a new session of Sentaurus Structure Editor, the color setting is synchronized automatically with the configuration file setting.

You can use the `-defaultGUI` command-line option to restore the DATEX color setting to the Vivid color scheme (see Table 1 on page 4).

In addition, you can use the `sde:change-datex-color-scheme` Scheme extension to select the DATEX color scheme and the `sde:get-datex-color-scheme` Scheme extension to retrieve the current setting of the color scheme.

# Selecting the Rendering Mode

To access the different rendering modes:

1. Choose **View > Render**.

2. Select a rendering mode, or click the corresponding toolbar button (see Table 5 on page 11).

The available rendering modes are illustrated here using the following example structure:

```
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 0.8 1.0)
  "Silicon" "R.Substrate")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position 0.0 0.0 1.0) (position 0.5 0.8 1.02)
  "Oxide" "R.Gox")
(sdegeo:create-cuboid (position 0.0 0.0 1.02) (position 0.3 0.8 1.5)
  "PolySilicon" "R.Poly")
(sdegeo:set-default-boolean "BAB")
(sdegeo:create-cuboid (position 0.0 0.0 1.02) (position 0.5 0.8 1.4)
  "Nitride" "R.Spacer")
```

<page_number>32</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

3: Controlling Views

Selecting the Rendering Mode

```
(sdegeo:fillet (find-edge-id (position 0.5 0.4 1.4)) 0.18)
(sde:setrefprops 0 30 0 0)
```

## Facets

The faceted model shows a triangulated view in two dimensions and a triangulated surface tessellation in three dimensions. When exporting the boundary file, the 2D faceting algorithm extracts the boundary edges from the tessellated view. In three dimensions, the triangular elements become part of the polyhedral boundary representation. When changing the surface refinement properties, the faceted view always reflects the triangulation that will be used when exporting a boundary file.

## Wireframe

This rendering mode shows the boundary wires only.

## Flat Shaded

A simple shaded mode where the surface normals are taken from the tessellated (triangulated) mode. Each surface element has a uniform color.

## Gouraud Shaded

In this shading method, the surface normals are interpolated (using a simple linear interpolation) between the neighboring surface triangles. In this way, a continuously shaded view is generated.

Rendering modes: (left) flat shaded and (right) Gouraud shaded

Figure 8 Rendering modes: (left) flat shaded and (right) Gouraud shaded

## Hidden Line

This mode generates a 3D view in which nonvisible edges are hidden. Additional silhouette edges are added to the view for the correct visualization.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

33
</page_number>

# 3: Controlling Views

Showing and Hiding Coordinate Axes

### Wireframe or Hidden Line with Face Parameter Lines

To better visualize faces in Wireframe mode or Hidden Line mode, additional face parameter lines can be displayed as well. In this mode, each face is ‘decorated’ with a given number of parametric lines for each orthogonal direction. The default number is 3.

The Scheme commands for displaying face parameter lines are:

```scheme
(view:display-param-lines #t)
                ; Turns on/off parameter lines for visualization
(option:set "u_param" 5) ; Number of parameter lines in the u direction
(option:set "v_param" 5) ; Number of parameter lines in the v direction
(render:rebuild)
```

This option is not available from the GUI.

Rendering modes: (a) facets, (b) wireframe, (c) hidden lines, and (d) hidden lines with face parameter lines

Figure 9 Rendering modes: (a) facets, (b) wirefame, (c) hidden lines, and (d) hidden lines with face parameter lines

**NOTE** Apart from these rendering modes, other Scheme commands for changing the rendering are available:

```scheme
(view:set-point-size 0)   ; Switches on and off the vertex markers.
(render:rebuild)          ; Rebuilds the graphics scene.
```

# Showing and Hiding Coordinate Axes

To switch between the display of the coordinates axes in the lower-right corner of the main window:

* Choose **View** > **Show Axes**.

<page_number>34</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

3: Controlling Views
View Orientation

# View Orientation

The camera position and orientation can be selected interactively. The resulting orientation of the coordinate axes displayed are given as follows:

**Iso** 3D isometric view
**XY** X to the right, Y up
**XZ** X to the right, Z up
**YZ** Z to the left, Y up
**X(-Y)** X to the right, Y down

To select the camera view:

* Choose **View** > **Camera Views**, or click the corresponding toolbar button.

# Displaying Grid Lines

To display the grid lines:

1. Choose **View** > **Grid**, or click the corresponding toolbar button.

2. Enter the grid line spacing along the x axis (**Grid Width**) and along the y axis (**Grid Height**). Optionally, the width of the grid line and the line pattern can be selected.

3. Click **Apply** to activate the changed settings.

4. Click **Show** to display the grid lines, or click **Hide** to suppress the display of the grid lines.

> **NOTE** The grid lines are always shown in the current work plane. Grid lines along the z-axis are not supported.

# Displaying Rulers

To switch between the display of rulers in the xy coordinate directions:

* Choose **View** > **Show Ruler**, or click the corresponding toolbar button.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>35</page_number>

# 3: Controlling Views

Scaling the View

**NOTE** The rulers displayed in the GUI follow the dimensionality of the model. If only 2D bodies are defined, rulers are drawn in the xy coordinate directions. For 3D models, a ruler is also drawn in the z-axis coordinate direction. In addition to these rulers, you can create rulers using the `sde:draw-ruler` Scheme extension (see sde:draw-ruler on page 425). These user-defined rulers are displayed in the GUI automatically. You can hide user-defined rulers using the `sde:hide-ruler` Scheme extension (see sde:hide-ruler on page 444).

In two dimensions, rulers in the xy coordinate directions are placed such that they cross in the upper-left corner when using the XY view orientation. Using other view orientations might make it difficult to read the tick labels of the rulers (see View Orientation on page 35).

# Scaling the View

You can scale the view (uniform or nonuniform). Scaling the view does not change the model coordinates; it is applied only to the graphical scene.

To scale the view:

1. Choose **View > View Scaling**.

2. Enter a view scaling factor for each of the coordinate axis.

The corresponding Scheme command is:

```
(sde:scale-scene x-factor y-factor z-factor)
```

For example, to scale the view by 2 in the y-direction, use `(sde:scale-scene 1 2 1)`. The command `(sde:scale-scene 1 1 1)` restores the original uniform unscaled model view.

# Visualizing Selected Geometric Objects

To view geometric entities associated with a selected material, or selected regions, masks, contacts:

* Choose **View > Entity Viewer**.

The Entity Viewer is used to switch on and off the display of all different entity types (body, face, edge, vertex, and other), masks, contacts, regions, and materials. Each can be shown or hidden, individually or in groups, using the **Show** and **Hide** buttons. To restrict the display to only the selected entities, click **Exclusive**.

<page_number>36</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

3: Controlling Views

Quick Access to Placements, Refinements, and Doping Profiles

To see through the selected entities, click the **Translucent** button. To switch off translucency for the selected entities, click **Opaque**.

Any additions, changes, and deletions to entities made through GUI actions in the view window or through Scheme commands are reflected immediately in the Entity Viewer.

Two-dimensional or three-dimensional contacts can be visualized as separate objects. To see only a given contact, highlight the contact name in the Entity Viewer and click **Exclusive**.

Related Scheme commands to display, hide, or show exclusively a given contact, respectively, are:

```
(sde:show-contact contactname)
(sde:hide-contact contactname)
(sde:xshow-contact contactname)
```

Screenshot of the Entity Viewer dialog box showing tabs for Materials, Regions, Ref/Eval Windows, Masks, Contacts, and Interfaces, with buttons for Reset, Translucent, Opaque, Show, Hide, Exclusive, and Close at the bottom.

Figure 10 Entity Viewer

# Quick Access to Placements, Refinements, and Doping Profiles

To list and access all currently defined Ref/Eval windows, refinements, and doping profiles:

1. Choose **View > Placements Viewer**.

2. Double-clicking any option opens the corresponding dialog box to view and edit its properties. Additions, changes, and deletions to placements made through GUI actions in the view window or through Scheme commands are reflected immediately in the Placements Viewer.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>37</page_number>

# 3: Controlling Views

Visualizing the Internal Entity Representation

3. To visualize Ref/Eval windows, select one or more Ref/Eval window and click **Show**.

Click **Exclusive** to display the item while suppressing the display of all other items.

Click **Hide** to suppress the display of the selected item. (These two buttons only apply to Ref/Eval windows.)

Placements Viewer dialog box

Figure 11 Placements Viewer

---

# Visualizing the Internal Entity Representation

To view the internal representation of entities:

* Choose **View** > **Topology Browser**.

Sentaurus Structure Editor represents the topology of a structure as a hierarchy of entities. On the top of the hierarchy are the bodies, which consist of lumps, shells, faces, loops, coedges, edges, and finally vertices. When working with Sentaurus Structure Editor, mainly bodies, faces, edges, and vertices are important.

The Topology Browser displays a tree of entities and their relationships, as used internally by Sentaurus Structure Editor. Use this tool to determine entity numbers and relationships. The graphical selection of entities in the main window of Sentaurus Structure Editor results in the highlighting of the corresponding entity in the Topology Browser. Similarly, the selection of an entity in the Topology Browser results in the highlighting of the entity in the main window.

<page_number>38</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**3: Controlling Views**

Visualizing the Internal Entity Representation

The Topology Browser also displays the doping/refinement/submesh (DRS)–related Ref/Eval windows as geometric objects.

Screenshot of the Topology Browser window showing a hierarchical tree of geometric entities (Body, Lump, Shell, Face, Loop, Coedge, Edge, Vertex) and control options like "Enable Edge Highlighting", "Enable Vertex Highlighting", and "Zoom to Selection".

Figure 12 Topology Browser

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>39</page_number>

# 3: Controlling Views

## Visualizing the Internal Entity Representation

<page_number>40</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

