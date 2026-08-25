# CHAPTER 2 Graphical User Interface

*This chapter describes the graphical user interface of Sentaurus Structure Editor.*

## Introduction to Graphical User Interface

The graphical user interface (GUI) of Sentaurus Structure Editor has three main areas (see Figure 1). The menu bar, toolbars, and list boxes are located in the upper part of the main window, the view window is in the center, and the command-line window is in the lower part.

Screenshot of the Sentaurus Structure Editor main window showing the Menu Bar, Toolbars, Material List, Work Plane List, Contact List, Selection Level List, View Window, and Command-Line Window.

Figure 1 Main window of Sentaurus Structure Editor

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>9</page_number>

# 2: Graphical User Interface

Introduction to Graphical User Interface

## GUI Modes

Sentaurus Structure Editor offers different GUI modes: 3D (default mode) and 2D. To set the GUI mode:

*   Choose **View** > **GUI Mode** > **2D Mode**.

*   Choose **View** > **GUI Mode** > **3D Mode**.

The only difference between the 3D GUI mode and the 2D GUI mode is that in the 2D GUI mode, some toolbars and GUI operations are unavailable. In this way, a more streamlined and simplified GUI is provided for 2D applications.

The dialog boxes related to doping, refinement, and external submeshes are the same in both the 2D GUI mode and 3D GUI mode. However, when defining refinement/evaluation (Ref/Eval) windows directly from these dialog boxes, in 2D GUI mode, rectangular Ref/Eval windows are created and, in 3D GUI mode, cuboidal Ref/Eval windows are created.

## Menu Bar

Table 2 lists the menus that are available from the GUI of Sentaurus Structure Editor.

Table 2 Menus

<table>
  <thead>
    <tr>
        <th>Menu</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>File</td>
        <td>Load, save, and print functions</td>
    </tr>
    <tr>
        <td>Edit</td>
        <td>Change existing geometric objects</td>
    </tr>
    <tr>
        <td>View</td>
        <td>Visualization preferences and auxiliary views</td>
    </tr>
    <tr>
        <td>Draw</td>
        <td>Drawing and basic object creation, preferences</td>
    </tr>
    <tr>
        <td>Mesh</td>
        <td>Define a meshing strategy, call the meshing engine, visualize the generated mesh and data fields</td>
    </tr>
    <tr>
        <td>Device</td>
        <td>Define doping profiles</td>
    </tr>
    <tr>
        <td>Contacts</td>
        <td>Define and edit contacts and contact sets</td>
    </tr>
    <tr>
        <td>Help</td>
        <td>Version information</td>
    </tr>
  </tbody>
</table>

<page_number>10</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

2: Graphical User Interface

Introduction to Graphical User Interface

# Toolbars

Each toolbar contains a set of predefined shortcuts and icons, which are shown in the following tables.

Table 3 File toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Shortcut keys</th>
        <th>Description</th>
        <th>Button</th>
        <th>Shortcut keys</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>New file icon</td>
        <td>Ctrl+N</td>
        <td>Create new file</td>
        <td>Save model icon</td>
        <td>Ctrl+S</td>
        <td>Save model</td>
    </tr>
    <tr>
        <td>Open model icon</td>
        <td>Ctrl+O</td>
        <td>Open model</td>
        <td> </td>
        <td>Ctrl+P</td>
        <td>Print</td>
    </tr>
  </tbody>
</table>

Table 4 Edit toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Shortcut keys</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Undo icon</td>
        <td>Ctrl+Z</td>
        <td>Undo last operation</td>
    </tr>
    <tr>
        <td>Redo icon</td>
        <td>Ctrl+Y</td>
        <td>Redo last operation</td>
    </tr>
  </tbody>
</table>

Table 5 Rendering mode toolbar buttons (for 3D)

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Facets icon</td>
        <td>Facets</td>
        <td>Gouraud Shaded icon</td>
        <td>Gouraud Shaded</td>
    </tr>
    <tr>
        <td>Wireframe icon</td>
        <td>Wireframe</td>
        <td>Hidden Line icon</td>
        <td>Hidden Line</td>
    </tr>
    <tr>
        <td>Flat Shaded icon</td>
        <td>Flat Shaded</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Table 6 Standard views toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Isometric View icon</td>
        <td>Isometric View</td>
        <td>YZ Plane icon</td>
        <td>YZ Plane</td>
    </tr>
    <tr>
        <td>XY Plane icon</td>
        <td>XY Plane</td>
        <td>X-Y Plane icon</td>
        <td>X-Y Plane (y-axis pointing<br/>downwards)</td>
    </tr>
    <tr>
        <td>XZ Plane icon</td>
        <td>XZ Plane</td>
        <td>Zoom to Extents icon</td>
        <td>Zoom to Extents (reset zoom)</td>
    </tr>
    <tr>
        <td>Isometric View (Sentaurus Process up direction) icon</td>
        <td>Isometric View (Sentaurus Process up<br/>direction)</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide

<page_number>11</page_number>

S-2021.06

# 2: Graphical User Interface

Introduction to Graphical User Interface

Table 7 GUI actions toolbar buttons (zoom and move)

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Select icon</td>
        <td>Select (selects a single object or objects in a window drawn with mouse)</td>
        <td>Zoom icon</td>
        <td>Zoom (zooming controlled by mouse)</td>
    </tr>
    <tr>
        <td>Zoom to Window icon</td>
        <td>Zoom to Window (zooms to window drawn with mouse)</td>
        <td>Pan icon</td>
        <td>Pan (move device with mouse)</td>
    </tr>
    <tr>
        <td>Orbit icon</td>
        <td>Orbit (3D rotation)</td>
        <td>Cut Plane icon</td>
        <td>Cut Plane (shows a cross section of the structure)</td>
    </tr>
  </tbody>
</table>

Table 8 GUI actions toolbar buttons (2D edit tools)

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Polygonal Region Split icon</td>
        <td>Polygonal Region Split</td>
        <td>Move Region icon</td>
        <td>Move Region</td>
    </tr>
    <tr>
        <td>Add Vertex icon</td>
        <td>Add Vertex</td>
        <td>Vertex-Vertex Distance icon</td>
        <td>Vertex-Vertex Distance</td>
    </tr>
    <tr>
        <td>Move Vertex icon</td>
        <td>Move Vertex or Move Vertices</td>
        <td>2D Cut icon</td>
        <td>2D Cut</td>
    </tr>
    <tr>
        <td>Move Edge icon</td>
        <td>Move Edge</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Table 9 GUI actions toolbar buttons (2D create tools)

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Create Polyline Wire icon</td>
        <td>Create Polyline Wire</td>
        <td>Create Spline Wire icon</td>
        <td>Create Spline Wire</td>
    </tr>
    <tr>
        <td>Create Rectangle icon</td>
        <td>Create Rectangle</td>
        <td>Create Regular Polygon icon</td>
        <td>Create Regular Polygon (needs Exact Coordinates mode to set parameters)</td>
    </tr>
    <tr>
        <td>Create Polygon icon</td>
        <td>Create Polygon (end polygon with middle mouse button)</td>
        <td>Create Ruled Region icon</td>
        <td>Create Ruled Region</td>
    </tr>
    <tr>
        <td>Create Circular Region icon</td>
        <td>Create Circular Region</td>
        <td>Create Elliptical Region icon</td>
        <td>Create Elliptical Region</td>
    </tr>
  </tbody>
</table>

Table 10 Snapping actions toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>No Snapping icon</td>
        <td>No Snapping</td>
        <td>Snap to Edge icon</td>
        <td>Snap to Edge</td>
    </tr>
    <tr>
        <td>Snap to Vertex icon</td>
        <td>Snap to Vertex</td>
        <td>Snap to Grid icon</td>
        <td>Snap to Grid</td>
    </tr>
    <tr>
        <td>Toggle gravity snapping icon</td>
        <td>Toggle gravity snapping</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

<page_number>12</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**2: Graphical User Interface**

Introduction to Graphical User Interface

Table 11 GUI actions toolbar buttons (3D create tools)

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Create Cuboid icon</td>
        <td>Create Cuboid</td>
        <td>Create Cylinder icon</td>
        <td>Create Cylinder</td>
    </tr>
    <tr>
        <td>Create Sphere icon</td>
        <td>Create Sphere</td>
        <td>Create Ellipsoid icon</td>
        <td>Create Ellipsoid</td>
    </tr>
    <tr>
        <td>Create Cross Section icon</td>
        <td>Create Cross Section</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Table 12 Default Boolean toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Merge icon</td>
        <td>Merge (new and existing objects are merged; new material and region names are assigned)</td>
        <td>New object replaces old in overlapping regions, overlap separate icon</td>
        <td>New object replaces old in overlapping regions, but the overlap becomes a separate region</td>
    </tr>
    <tr>
        <td>New object replaces old icon</td>
        <td>New object replaces old in overlapping regions</td>
        <td>Old object replaces new in overlapping regions, overlap separate icon</td>
        <td>Old object replaces new in overlapping regions, but the overlap becomes a separate region</td>
    </tr>
    <tr>
        <td>Old object replaces new icon</td>
        <td>Old object replaces new in overlapping regions</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Table 13 Shortcut toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Switch editor/viewer icon</td>
        <td>Switch between geometry editor and grid and data viewer</td>
        <td>Exact coordinates icon</td>
        <td>Switch on or off exact coordinates</td>
    </tr>
    <tr>
        <td>Grid visualization icon</td>
        <td>Grid visualization switch</td>
        <td>Ruler visualization icon</td>
        <td>Ruler visualization switch</td>
    </tr>
    <tr>
        <td>Auto stretch icon</td>
        <td>Auto stretch scene</td>
        <td> </td>
        <td> </td>
    </tr>
  </tbody>
</table>

Table 14 DRS (doping, refinement, submesh) toolbar buttons

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Reference line icon</td>
        <td>Reference line<br/>(Ref/Eval window)</td>
        <td>Reference rectangle icon</td>
        <td>Reference rectangle<br/>(Ref/Eval window)</td>
    </tr>
    <tr>
        <td>Reference polygon icon</td>
        <td>Reference polygon<br/>(Ref/Eval window)</td>
        <td>Reference element icon</td>
        <td>Reference element extracted from a geometric face (Ref/Eval window)</td>
    </tr>
    <tr>
        <td>Refinement placement icon</td>
        <td>Refinement placement</td>
        <td>Multibox placement icon</td>
        <td>Multibox placement</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

13
</page_number>

# 2: Graphical User Interface

Introduction to Graphical User Interface

Table 14 DRS (doping, refinement, submesh) toolbar buttons (Continued)

<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Constant profile placement icon</td>
        <td>Constant profile placement</td>
    </tr>
    <tr>
        <td>External profile placement icon</td>
        <td>External profile placement</td>
    </tr>
  </tbody>
</table>
<table>
  <thead>
    <tr>
        <th>Button</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Analytic profile placement icon</td>
        <td>Analytic profile placement</td>
    </tr>
    <tr>
        <td>Particle profile placement icon</td>
        <td>Particle profile placement</td>
    </tr>
  </tbody>
</table>

## Restoring GUI Settings From Previous Session

Some GUI information is saved automatically in your local home directory. On Linux operating systems, this information is stored in the file `~/.config/Synopsys/Sentaurus Structure Editor.conf`.

The stored parameters are toolbar positions, the setting of the DATEX color scheme, and the parameters for the command-line window.

To reset these GUI parameters to their defaults, begin an interactive session by using the `-defaultGUI` command-line option. This starts the session with the default GUI parameters and replaces any personalized parameters with these defaults when exiting.

## Manipulating the View

Additional shortcut key combinations are available to manipulate the view.

Table 15 Shortcut keys for manipulating the view

<table>
  <thead>
    <tr>
        <th>Shortcut keys</th>
        <th>Action</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Up Arrow</td>
        <td>View window: Zoom out<br/>Command-line window: Scroll up command history</td>
    </tr>
    <tr>
        <td>Down Arrow</td>
        <td>View window: Zoom in<br/>Command-line window: Scroll down command history</td>
    </tr>
    <tr>
        <td>Left Arrow</td>
        <td>View window: Pan to the left<br/>Command-line window: Position curser for editing echoed Scheme command</td>
    </tr>
    <tr>
        <td>Right Arrow</td>
        <td>View window: Pan to the right<br/>Command-line window: Position curser for editing echoed Scheme command</td>
    </tr>
    <tr>
        <td>Ctrl+Left Arrow</td>
        <td>View window: Pan downwards</td>
    </tr>
    <tr>
        <td>Ctrl+Right Arrow</td>
        <td>View window: Pan upwards</td>
    </tr>
    <tr>
        <td>Ctrl+Z</td>
        <td>(roll)</td>
    </tr>
    <tr>
        <td>Ctrl+Y</td>
        <td>(roll 1)</td>
    </tr>
  </tbody>
</table>

<page_number>14</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**2: Graphical User Interface**
Introduction to Graphical User Interface

Table 15 Shortcut keys for manipulating the view (Continued)

<table>
  <thead>
    <tr>
        <th>Shortcut keys</th>
        <th>Action</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Shift+Orbit</td>
        <td>Rotate about x-axis (horizontal view) or<br/>Pan (when (sde:use-camera-manipulator #t) is used)</td>
    </tr>
    <tr>
        <td>Ctrl+Orbit</td>
        <td>Rotate about y-axis (vertical view) or<br/>Zoom in and out (when (sde:use-camera-manipulator #t) is used)</td>
    </tr>
    <tr>
        <td>Ctrl+Shift+Orbit</td>
        <td>Rotate about z-axis (perpendicular to view)</td>
    </tr>
    <tr>
        <td>Ctrl+N</td>
        <td>Create new file</td>
    </tr>
    <tr>
        <td>Ctrl+O</td>
        <td>Open model</td>
    </tr>
    <tr>
        <td>Ctrl+S</td>
        <td>Save model</td>
    </tr>
    <tr>
        <td>Ctrl+P</td>
        <td>Print</td>
    </tr>
    <tr>
        <td>Ctrl+Q</td>
        <td>Exit</td>
    </tr>
  </tbody>
</table>

# Lists

The main window of Sentaurus Structure Editor contains the following lists:

* Material list – Selects the material to be assigned to new objects.

* Work Plane list – Sets the work plane for 3D editing.

* Contact list – Selects the contact name to be used in the next set contact region, or face, or edge operations.

* Selection Level list – Selects which type of object can be selected.

# View Window

The current device is displayed in the view window. The result of all interactive operations is reflected immediately in the view window.

Right-click in this area to open the following shortcut menus:

* **Selection Level** controls which type of object can be selected by clicking (Select mode). Options are **Auto Select**, **Body**, **Face**, **Edge**, **Vertex**, and **Ref/Eval Window**.

* **Toggle Visibility** activates or deactivates a light source for shading 3D objects.

Placing the cross-hair cursor over an object and right-clicking selects the object corresponding to the current selection level and opens these shortcut menus.

Sentaurus™ Structure Editor User Guide <page_number>15</page_number>
S-2021.06

# 2: Graphical User Interface

Introduction to Graphical User Interface

The following additional menus and options become available, where appropriate, in the context of the selection made:

*   **Contacts**: If the selection level is set to **Edge** or **Face**, contacts are assigned to the selected objects. It also allows for the creation of new contact sets.

*   **Delete**: In many contexts, the object can be deleted by selected this option.

*   **Properties**: Displays a window with information about the selected object. In some contexts, for example, Ref/Eval windows, properties of the object are editable.

    For Ref/Eval windows, the bounding vertex coordinates are displayed for rectangular and cuboidal Ref/Eval windows. For these types, the vertex coordinates are editable and can be changed. In this case, all doping/refinement/submesh (DRS) objects that use the given Ref/Eval window are redefined using the new vertex coordinates.

*   **Hide**: If the selection level is set to **Body** or **Ref/Eval Window**, the selected entities are hidden.

*   **Show All**: All the previously hidden bodies and Ref/Eval windows are displayed again.

---

## Command-Line Window

Most GUI operations have an associated Scheme command. After a GUI operation, the corresponding Scheme command is echoed in the command-line window.

Use the Up Arrow and Down Arrow keys to scroll through echoed Scheme commands. Echoed commands can be edited (use the Left Arrow and Right Arrow keys to position the cursor, and the Delete key or Backspace key to delete parts of the command, type in new parts of the command) and reexecuted by pressing the Enter key.

Use cut-and-paste operations to save echoed Scheme commands into a text editor to interactively build a Scheme script. Individual Scheme commands or groups of Scheme commands can be pasted back into the command-line window as needed, for example, to test a section of a Scheme script. Scheme commands can also be entered directly at the command-line prompt.

Activate journaling to automatically save the echoed Scheme command to a journal file, for later editing and replaying (see Recording Actions to a File on page 19).

The following basic rules apply to the Scheme scripting language (see Chapter 9 on page 263):

*   Comment lines start with a semicolon. In each line, a comment proceeds from the first inserted semicolon.

    New variables are defined using the keyword `define`. Defined variables can be reassigned a value by using the `set!` keyword.

<page_number>16</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

2: Graphical User Interface

Opening and Saving Operations

For example:

```scheme
(define width 5)    ; defines the variable width and sets its value to 5
(define height 10)
(set! width 3)      ; now width is 3
```

* Scheme has all the conventional data types such as character, string, list, array, Boolean, number, function, and symbol.

* All data types are equal. Any variable can hold any type of data. Data initialization, memory allocation, and memory cleanup (garbage collection) are performed automatically.

**NOTE** A few keywords (such as `length`) are reserved keywords used by Scheme and they define a Scheme function or operator. These keywords must not be redefined by a user-initiated `define` command.

# Opening and Saving Operations

The next sections describe basic opening and saving operations.

## Opening Models

A model consists of a structure saved in the native ACIS format (`filename.sat`) and an auxiliary Scheme script file (`filename.scm`), which contain parameter settings, contact definitions, refinement/evaluation (Ref/Eval) windows, surface refinement settings, as well as work plane and view settings (some of these definitions are also part of the `.sat` file). Refinement-related and doping-related information is stored in a third file (`filename.cmd`).

To open a model:

* Choose **File** > **Open Model** or press **Ctrl+O**.

The corresponding Scheme command is:

```scheme
(sde:open-model "filename")
```

## Saving Models

To save a model, you can do one of the following:

* Choose **File** > **Save Model** or press **Ctrl+S**.

* Choose **File** > **Save Model As**.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

17
</page_number>

# 2: Graphical User Interface

Opening and Saving Operations

The corresponding Scheme command is:

```scheme
(sde:save-model "filename")
```

This command saves the following:

*   Model geometry and Ref/Eval windows in native ACIS format (`filename.sat`)

*   Scheme file (`filename.scm`) with various parameter settings

*   Mesh command file (`filename_msh.cmd`) with refinement-related and doping-related information

*   Boundary file in TDR format (`filename_bnd.tdr`)

## Saving Boundaries

To save only the boundary (and not the entire model) in TDR format, you can do one of the following:

*   Choose **File** > **Save Boundary**.

*   Choose **File** > **Save Boundary As**.

## Importing Files

To import a file:

*   Choose **File** > **Import**.

Table 16 Supported file formats for loading into Sentaurus Structure Editor and corresponding Scheme commands

<table>
  <thead>
    <tr>
        <th>File format</th>
        <th>Scheme command</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>ACIS SAB file (*.sab)</td>
        <td>(part:load "filename.sab" #f)</td>
        <td>Native ACIS format (binary) to<br/>store the complete model</td>
    </tr>
    <tr>
        <td>ACIS SAT file (*.sat)</td>
        <td>(part:load "filename.sat" #t)</td>
        <td>Native ACIS format (ASCII) to<br/>store the complete model</td>
    </tr>
    <tr>
        <td>Mesh doping and<br/>refinement file (*.cmd)</td>
        <td>(sdedr:read-cmd-file "filename.cmd")</td>
        <td>Command file for the Synopsys<br/>mesh generator</td>
    </tr>
    <tr>
        <td>Layout file (*.lyt)</td>
        <td>(sdeio:read-dfise-mask "filename.lyt")</td>
        <td>Layout file in deprecated DF–ISE<br/>format</td>
    </tr>
    <tr>
        <td>Scheme script file<br/>(*.scm, *.cmd)</td>
        <td>(load "filename.scm")</td>
        <td>Scheme command file that is<br/>loaded and executed</td>
    </tr>
    <tr>
        <td>TDR file (*.tdr)</td>
        <td>(sdeio:read-tdr-bnd "filename.tdr")</td>
        <td>Boundary file in TDR format</td>
    </tr>
  </tbody>
</table>

<page_number>18</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

2: Graphical User Interface
Recording Actions to a File

**NOTE** When importing a .sat file, the Scheme command `part:load` is used. This command works well when importing a structure into an empty database (no geometric objects defined). In this case, the saved structure is restored correctly.

When importing a structure to a non-empty database (with preexisting geometric objects), overlapping regions might be generated since `part:load` *does not respect* the active Boolean settings for overlap handling.

You can use the `sde:load-sat` function (not accessible from the GUI) to load a native .sat file with correct overlap handling. The function is the same as `part:load`, except that it observes the active Boolean setting for overlap control (that is, overlapping regions will not be present in the model and the overlaps will be removed based on the active Boolean setting).

# Recording Actions to a File

Operations performed using the GUI or command-line window can be recorded in a journal file for replaying or editing later.

To activate, suspend, and deactivate the journal feature:

1. Choose **File > Journal > On**.

2. Enter the name of the journal file in which all further actions should be recorded.

3. Choose **File > Journal > Pause** to suspend the recording of actions.

4. Choose **File > Journal > Resume** to resume recording actions.

5. Choose **File > Journal > Off** to end recording actions.

To replay a journal file:

1. Choose **File > Journal > Load**.

2. Enter the name of the journal file.

To execute the journal file step-by-step, open the journal file in a text editor and enter the Scheme command `(journal:step #t)` at the point in the script where the stepping mode should start.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

19
</page_number>

# 2: Graphical User Interface

Undoing and Redoing Actions

> **NOTE** In stepping mode, the Enter key must be pressed twice for each single line of the Scheme script, including blank lines and comments. To revert to continuous execution, enter the command `(journal:step #f)`.

To save the current journal to a file:

1. Choose **File** > **Journal** > **Save**.

2. In the dialog box, save the file as required.

Table 17 Corresponding Scheme commands for journal features

<table>
  <thead>
    <tr>
        <th>Scheme command</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>(journal:clean "filename.jrl")</td>
        <td>Cleans the specified journal file. (Removes all nonexecutable content from the file to simplify debugging and parameterization.)</td>
    </tr>
    <tr>
        <td>(journal:load "filename.jrl")</td>
        <td>Loads a journal file and runs each command contained in that file. Each line is journaled if journaling is switched on.</td>
    </tr>
    <tr>
        <td>(journal:off)</td>
        <td>Closes the current journal file and switches off journaling.</td>
    </tr>
    <tr>
        <td>(journal:on "filename.jrl")</td>
        <td>Switches on journal recording. All future commands are journaled to the file.</td>
    </tr>
    <tr>
        <td>(journal:pause)</td>
        <td>Pauses recording.</td>
    </tr>
    <tr>
        <td>(journal:resume)</td>
        <td>Resumes recording.</td>
    </tr>
    <tr>
        <td>(journal:save "filename.jrl")</td>
        <td>Saves the current journal to a file, but leaves the journal session open.</td>
    </tr>
  </tbody>
</table>

# Undoing and Redoing Actions

To undo an action:

* Choose **Edit** > **Undo** or press Ctrl+Z.

The corresponding Scheme command is:

`(roll)`

To redo an action:

* Choose **Edit** > **Redo** or press Ctrl+Y.

The corresponding Scheme command is:

`(roll+1)`

<page_number>20</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

2: Graphical User Interface
Customization

**NOTE** Undo and redo operations work in multiple steps as well. For example, `(roll -n)` rolls back the modeler by n steps, and `(roll n)` rolls forward the history stream of the modeler by n steps. `(roll)` is a shortcut to `(roll -1)`.

Undo and redo operations work with actions supported directly by the ACIS modeling engine, including operations that create and change Ref/Eval windows. Operations that involve creating or changing placements cannot be undone by using the `(roll)` feature. However, placements can be edited, deleted, and recreated.

# Customization

Some parts of the GUI can be customized.

## Configuring the Command-Line Window

You can configure the command-line window by choosing **View** > **Script Win Prefs**, which displays the Script Window Preferences dialog box, where you select the font family, font style, font size, and height of the command-line window.

Script Window Preferences dialog box

Figure 2 Script Window Preferences dialog box

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>21</page_number>

# 2: Graphical User Interface

Customization

Alternatively, you can use Scheme extensions (see Table 18).

Table 18 Scheme extensions for configuring the command-line window

<table>
  <thead>
    <tr>
        <th>Scheme extension</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>(sde:scmwin-get-font-families)</td>
        <td>Returns all available font families.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-get-font-family)</td>
        <td>Returns the currently selected font family.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-get-font-size)</td>
        <td>Returns the active font size.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-get-font-style)</td>
        <td>Returns the font style.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-get-window-height)</td>
        <td>Returns the height of the command-line window.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-select-font)</td>
        <td>Displays the Select Font dialog box.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-set-font-family font-type)</td>
        <td>Sets the font family.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-set-font-size font-size)</td>
        <td>Sets the font size.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-set-prefs)</td>
        <td>Can be used to configure the command-line window, using one single function.</td>
    </tr>
    <tr>
        <td>(sde:scmwin-set-window-height height)</td>
        <td>Sets the height of the command-line window in terms of number of lines.</td>
    </tr>
  </tbody>
</table>

**NOTE** The height, font family, font size, and font style of the command-line window are stored in your local home directory when exiting Sentaurus Structure Editor, making these parameters persistent from session to session. For information about how to restore default values, see Restoring GUI Settings From Previous Session on page 14.

# Changing GUI Attributes

The following GUI attributes are saved by the `sde:save-model` command and restored by the `sde:open-model` command.

## Background Color

To change the background color of the view window:

* Choose **View > Background Color**.

The corresponding Scheme command is:

```
(sde:set-background-color r_top g_top b_top r_bot g_bot b_bot)
```

<page_number>22</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

2: Graphical User Interface

Customization

RGB colors for the top and bottom of the view window must be specified as integers in the range 0–255. For example, to create a graded background with red on top and blue at the bottom, specify:

```
(sde:set-background-color 255 0 0 0 0 255)
```

## GUI Style

To change the GUI style:

*   Choose **View > GUI Style**.

The available GUI styles are Windows, Motif, Cleanlooks, Plastique, and CDE. See sde:set-window-style on page 486.

## Font Size of Menu Bar of Main Window

To change the font size of the menu bar of the main window, use:

```
(sde:set-menubar-font-size font-size)
```

For example:

```
(sde:set-menubar-font-size 10)
```

## Size of Main Window

You can resize the main window at any time using the mouse or by using:

```
(sde:set-window-size x-size y-size)
```

For example:

```
(sde:set-window-size 640 480)
```

## Position of Main Window

You can position the main window on the screen by moving it using the mouse or by using:

```
(sde:set-window-position x y)
```

For example, to place the main window in the upper-left corner of the screen, specify:

```
(sde:set-window-position 0 0)
```

Sentaurus™ Structure Editor User Guide

<page_number>23</page_number>

S-2021.06

2: Graphical User Interface

Selecting Entities

## Restoring GUI Settings

To capture figures for presentations or to compare models visually, the state of the GUI graphical view (translation, zoom, rotation) can be recorded and restored using Scheme functions. The `sde:get-view-params` function returns the actual view parameters. The view parameters are restored using the `sde:set-view-params` function.

For example:

```scheme
(define myview (sde:get-view-params))
; The myview object stores the GUI settings, which can be restored later.
(sde:set-view-params myview)
```

# Selecting Entities

To select an entity:

1. Click the Select button (see Table 7 on page 12).

2. Select the required entity type from the **Selection Level** list.

3. Select an entity and hold the Shift or Ctrl key to select additional entities, or drag a box around a set of entities.

4. Click the (blank) background to clear the selected entity list.

Entity types are **Body**, **Face**, **Edge**, **Vertex**, or **Ref/Eval Window**.

shortcut menu showing selection levels 

 Selection Level dropdown list

Figure 3 Set entity selection type: (*left*) shortcut menu and (*right*) Selection Level list

<page_number>24</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

2: Graphical User Interface
Snapping Modes

# Snapping Modes

The default drawing mode is freehand for creating 2D regions (rectangles, circles, ellipses, and so on). Optional features such as snap-to-grid, exact coordinates, and snap-to-existing vertices can also be used. These features can also be accessed interactively during model generation.

Table 19 Keyboard keys for 2D drawing operations

<table>
  <thead>
    <tr>
        <th>Key</th>
        <th>Action</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Esc</td>
        <td>Resets operator</td>
    </tr>
    <tr>
        <td>V</td>
        <td>Snap-to-vertex</td>
    </tr>
    <tr>
        <td>E</td>
        <td>Snap-to-edge (closest point on edge)</td>
    </tr>
    <tr>
        <td>G</td>
        <td>Snap-to-grid</td>
    </tr>
    <tr>
        <td>N</td>
        <td>Disables snapping</td>
    </tr>
  </tbody>
</table>

For example, during a 2D polygonal region generation when the E key is pressed, the pointer will snap to the closest existing edge. When the pointer is moved, it slides along the closest edge. When the V key is pressed, the pointer snaps automatically to the closest vertex. To move back to freehand drawing, press the N key.

# Printing

To print the current view of the structure:

1. Choose **File > Print** or press Ctrl+P.

2. Select the printer and set print options such as page orientation, and color or black-and-white mode if available.

3. Select the **Print to file** option, and enter a file name to export the view to a portable document format (PDF) file.

4. Click **Print**.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>25</page_number>

2: Graphical User Interface

Defining Parameters

# Defining Parameters

To define parameters:

1. Choose **Edit** > **Parameters**.

The Parameters dialog box is displayed.

Parameters dialog box

2. Enter the parameter names and values.

3. Click **Set**.

The corresponding Scheme command is:

```
(sde:define-parameter parameter-name value [min-value max-value])
```

See sde:define-parameter on page 413. For example:

```
(sde:define-parameter "myvar1" "banana")
(sde:define-parameter "myvar2" 10)
(sde:define-parameter "myvar3" 10 0 20)
```

To delete parameters, click the **Delete** button of the Parameters dialog box or use the `sde:delete-parameter` function (see sde:delete-parameter on page 416).

**NOTE** Parameter names must be enclosed in double quotation marks when using `sde:define-parameter` or `sde:delete-parameter`.

<page_number>

26
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

2: Graphical User Interface
Parameterizing Dialog Boxes

Scheme variables function as parameters for various operations, such as extrusion and chamfering, and can be used for device parameterization. These variables can be assigned not only a value by choosing **Edit > Parameters**, but also minimum and maximum values. For example, when `myvar1` is defined with Value 10, Min. Value 0, and Max. Value 20, you can enter `myvar1` in the command-line window that will evaluate `myvar1` as 10. The minimum value is stored in a variable called `myvar1_min`, and the maximum value is stored in a variable called `myvar1_max`.

**NOTE** Defined parameters can be used in all subsequent Scheme commands as well as in the fields of the dialog box that expect numeric values.

Parameters can also be defined by the basic Scheme command `(define parameter-name value)`.

# Parameterizing Dialog Boxes

Several dialog boxes can be parameterized. The dialog boxes can accept not only numeric inputs, but also Scheme variables and Scheme expressions. The Scheme variables must be defined and initialized *before* they can be used in a Sentaurus Structure Editor dialog box. For example, in Exact Coordinates mode, the Exact Coordinates dialog box is displayed after a rectangle is drawn. As input data, in addition to numeric values, Scheme variables and Scheme expressions can be used to define the vertex coordinates.

For example, after the two Scheme variables `width` and `height` are defined in the command-line window, using:

```scheme
(define width 10)
(define height 5)
```

and the Exact Coordinates mode is switched on and a rectangle is drawn, the Exact Coordinates dialog box is displayed where you can use Scheme variables and expressions as input data.

Exact Coordinates dialog box screenshot

Figure 4 Exact Coordinates dialog box using Scheme variables and expressions

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>27</page_number>

# 2: Graphical User Interface

Parameterizing Dialog Boxes

This operation generates the following Scheme command:

```scheme
(sdegeo:create-rectangle (position 0 0 0.0)
    (position width (* 0.25 height) 0.0) "Silicon" "region_1")
```

<page_number>28</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

