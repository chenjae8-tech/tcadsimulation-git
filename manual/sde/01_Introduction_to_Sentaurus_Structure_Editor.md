# CHAPTER 1 Introduction to Sentaurus Structure Editor

*This chapter introduces Sentaurus Structure Editor and describes its basic operations.*

# Functionality of Sentaurus Structure Editor

Sentaurus Structure Editor can be used as a two-dimensional (2D) or three-dimensional (3D) structure editor, and a 3D process emulator to create TCAD devices.

In Sentaurus Structure Editor, structures are generated or edited interactively using the graphical user interface (GUI). Doping profiles and meshing strategies can also be defined interactively. Sentaurus Structure Editor features an interface to configure and call the Synopsys meshing engines. In addition, it generates the necessary input files (the TDR boundary file and mesh command file) for the meshing engines, which generate the TDR grid and data file for the device structure.

Alternatively, devices can be generated in batch mode using scripts. Scripting is based on the Scheme scripting language. This option is useful, for example, for creating parameterized device structures. Sentaurus Structure Editor records interactive actions in the form of script commands (journaling). Therefore, it is easy to generate a script from recorded interactive operations. These scripts can be parameterized afterwards.

Command-Line Window on page 16 provides information regarding the Scheme scripting language. When a GUI action is performed, Sentaurus Structure Editor prints the corresponding Scheme command in the command-line window. This facilitates another convenient way to generate and work with scripts. Open a text editor and use cut-and-paste operations to transfer the Scheme commands, which Sentaurus Structure Editor prints in the command-line window, to a script file. In the text editor, the commands can be edited as needed and pasted back into the command window for execution.

In addition, Scheme resources are listed in Basic Scheme Programming for Users of Sentaurus Structure Editor on page 264.

Device structures are defined by using geometric operations such as:

*   Generation of 2D and 3D primitives (rectangles, circles, cuboids, cylinders)

*   Filleting, chamfering, 3D vertex and edge blending, face-tapering operations

Sentaurus™ Structure Editor User Guide

<page_number>1</page_number>

S-2021.06

# 1: Introduction to Sentaurus Structure Editor

Functionality of Sentaurus Structure Editor

* Boolean operations between bodies

* General extrusion, sweep, and skinning and lofting operations

In addition, device structures can be defined using emulated process steps such as:

* Import or define mask layouts

* Substrate generation

* Patterning

* Isotropic and anisotropic etching and deposition, with or without shadowing and directional effects

* Polishing and fill operations

* Implantation

Sentaurus Structure Editor can be used in three different ways or modes:

* Two-dimensional device editor

* Three-dimensional device editor

* Three-dimensional process emulator (Procem)

The common characteristics of these modes are:

* The use of a state-of-the-art geometry modeling kernel (ACIS, from Dassault Systèmes S.A.) that provides a robust and reliable base for model generation

* A high-quality rendering engine and GUI

* A scripting interface, which is based on the Scheme scripting language

* All modes share a common kernel that provides TDR file input and output, conformal model tessellation for the 2D and 3D Synopsys meshing engines, a link to the meshing engines (with an appropriate user interface to the selected engine), refinement control for tessellated curved boundaries, and other support functionalities

The 2D and 3D device editors provide a GUI and scripting support to:

* Generate the model geometry

* Define contact regions

* Add constant, analytic, and externally generated doping profiles to the model

* Define local refinements

* Include external submeshes

* Interface to the Synopsys meshing engines

The process emulator provides additional scripting functions to emulate TCAD process steps.

<page_number>2</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

1: Introduction to Sentaurus Structure Editor

Starting Sentaurus Structure Editor

All three modes share the same software infrastructure and internal data representation, and can be combined freely. A 2D model can be extruded or swept along a curve to generate a 3D model. Afterwards, process steps (for example, a deposition step) can be performed on the generated 3D model. Similarly, a 2D slice can be generated from a 3D model and can be saved in a 2D boundary file.

## ACIS Geometry Kernel

The geometry operations in Sentaurus Structure Editor are based on the ACIS geometry kernel. The ACIS 3D geometric modeler (ACIS) is an object-oriented 3D geometric modeling engine from Spatial Corp.

ACIS is based on boundary representation. An ACIS boundary representation (B-rep) of a model is a hierarchical decomposition of the topology of the model into lower-level topological objects. A typical body contains lumps, shells, faces, loops, wires, coedges, edges, and vertices.

The Topology Browser in Sentaurus Structure Editor can be used to explore the relationship between these objects. When Sentaurus Structure Editor generates a new body or performs a Boolean operation or any other action that affects the geometry, the ACIS data representation always provides a valid model.

Since the geometry representation is always three dimensional, there is a seamless transition from 2D models to 3D models (using extrusion, sweep operations, and so on). When only 2D objects are present, the TDR output will be two dimensional. For 3D objects, the TDR file is three dimensional.

An entity is the most basic ACIS object. The selection tool and `(sde:selected-entities)` always return the ACIS entity IDs for the selected entities. These entity IDs are used to refer to specific entities.

Apart from the Sentaurus Structure Editor documentation, a useful resource to learn the basics of ACIS and Scheme is:

* J. Corney and T. Lim, *3D Modeling with ACIS*, Stirling, UK: Saxe-Coburg Publications, 2001.

## Starting Sentaurus Structure Editor

You can start Sentaurus Structure Editor by typing at the command prompt:

`sde [<options>]`

Sentaurus™ Structure Editor User Guide

<page_number>3</page_number>

S-2021.06

# 1: Introduction to Sentaurus Structure Editor

Starting Sentaurus Structure Editor

where `[<options>]` are the command-line options listed in Table 1.

> **NOTE** The geometry engine of Sentaurus Structure Editor is three dimensional. Even if the operating mode is 2D, the underlying geometry representation of the model is three dimensional. The 2D operating mode can be switched to 3D at any time. The Scheme interface is not affected by the 2D GUI mode or 3D GUI mode.

Table 1 Command-line options

<table>
  <thead>
    <tr>
        <th>Option</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>-2D</td>
        <td>Starts the graphical user interface (GUI) in a simplified 2D mode (see GUI Modes on page 10). Choose <strong>View</strong> &gt; <strong>GUI Mode</strong> &gt; <strong>3D Mode</strong> to switch to the default 3D mode. In 2D mode, the menu bar is simplified and only 2D-related operations and commands are available. In 3D mode, the menu bar is extended and all features are available.</td>
    </tr>
    <tr>
        <td>-action <em>option</em></td>
        <td>Sets the default GUI action to the specified action from the following options:<br/>\* draw-polygon<br/>\* draw-rectangle<br/>\* orbit (default)<br/>\* pan<br/>\* select<br/>\* zoom</td>
    </tr>
    <tr>
        <td>-defaultGUI</td>
        <td>Resets GUI parameters to their defaults. The settings include toolbar positions, DATEX color scheme, and parameters for the command-line window.<br/>Does not restore the GUI settings from previous session.</td>
    </tr>
    <tr>
        <td>-e</td>
        <td>Runs in batch mode (see Batch Mode on page 5), that is, without the GUI.<br/>Use with `-l` to run a script in batch mode.</td>
    </tr>
    <tr>
        <td>-h <em>heapsize</em></td>
        <td>Heap size in kilobytes. By default, Sentaurus Structure Editor uses 1600 MB of heap space. See Heap Size on page 5.</td>
    </tr>
    <tr>
        <td>-help</td>
        <td>Prints the help message.</td>
    </tr>
    <tr>
        <td>-l <em>scriptname</em></td>
        <td>Loads and executes the script file called <em>scriptname</em>.</td>
    </tr>
    <tr>
        <td>-noloadCmd</td>
        <td>When loading a boundary file, this option suppresses the loading of the corresponding mesh command file (see Loading Boundary and Mesh Command Files at Startup on page 7).</td>
    </tr>
    <tr>
        <td>-noLogfile</td>
        <td>Do not create a `.log` file during the execution of a Scheme script.</td>
    </tr>
    <tr>
        <td>-noopenGL</td>
        <td>Explicitly suppresses the use of OpenGL. Note that Sentaurus Structure Editor automatically switches to the `noopenGL` mode if OpenGL is not available.</td>
    </tr>
    <tr>
        <td>-noSyntaxCheck</td>
        <td>Do not run the Scheme syntax checker.</td>
    </tr>
    <tr>
        <td>-nowait</td>
        <td>Do not wait for license to become available.</td>
    </tr>
    <tr>
        <td>-r</td>
        <td>Loads and executes script commands from standard input. Use Ctrl+D to revert to the default GUI mode, or Ctrl+\ to quit Sentaurus Structure Editor.</td>
    </tr>
  </tbody>
</table>

<page_number>4</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

1: Introduction to Sentaurus Structure Editor

Starting Sentaurus Structure Editor

Table 1 Command-line options (Continued)

<table>
  <thead>
    <tr>
        <th>Option</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>-S scriptname</td>
        <td>Tests the Scheme syntax only; it implies -e, that is, no GUI. See Scheme Script Syntax-Checking on page 5.</td>
    </tr>
    <tr>
        <td>-Sl scriptname</td>
        <td>Tests the Scheme syntax, and then executes as -l if it passes the syntax check. See Scheme Script Syntax-Checking on page 5.</td>
    </tr>
    <tr>
        <td>-v</td>
        <td>Prints information about the tool version.</td>
    </tr>
    <tr>
        <td>-var var=value</td>
        <td>Defines and loads additional Scheme variables. These variables can be used to parameterize a Scheme script.</td>
    </tr>
  </tbody>
</table>

## Batch Mode

To run a Scheme script file, for example `MyScript.scm`, in batch mode, start Sentaurus Structure Editor with the `-e` option (this disables the graphical display), and use the `-l` option to give the script to be run:

```
sde -e -l MyScript.scm
```

If the `-e` option is not used, the GUI is launched after the specified script `-l MyScript.scm` is executed.

## Heap Size

By default, Sentaurus Structure Editor uses 1600 MB of heap space. For most applications, the allocated heap space should be sufficient. If Sentaurus Structure Editor does not have enough heap space during script execution, then the Scheme error file will contain the following error message: `Out of heap space`.

In this case, Sentaurus Structure Editor exits, and the script must be executed again with increased heap space. To increase the heap space, use the `-h` argument. For example:

```
(sde -h 2400000 -e -l myscript.scm)
```

## Scheme Script Syntax-Checking

The `-S scriptname` and `-Sl scriptname` options invoke the Scheme syntax-checking feature.

The `-S` option runs the syntax-checker on the Scheme script `scriptname` and reports on the results without executing the script.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>5</page_number>

# 1: Introduction to Sentaurus Structure Editor

Starting Sentaurus Structure Editor

In contrast, after first running the syntax-checker on the Scheme script *scriptname*, the `-Sl` option will subsequently run the script if it passes the syntax check; otherwise, it will not run the script.

**NOTE** Due to the complexity of the Scheme scripting language, it is possible, in some cases, for the syntax-checker to report a false positive. This means a syntax error might be flagged in complex code even though no syntax error exists. In the case of the `-Sl` option, the script is not run if there is an inaccurate flagging of a nonexistent syntax error. The option `-l` can be used instead to bypass the syntax check and to run the script if it is indeed free of syntax errors. Users are encouraged to report such cases, so that the number of false positives will be reduced in future versions (contact the TCAD Support Team).

---

## Literal Evaluation of Scheme Script

When a Scheme script is executed in batch mode, a log file is created that contains the executed Scheme commands. The log file does not contain the literal evaluation and substitution of the Scheme variables. Therefore, for example, the log file will contain `(position xp yp zp)`, not the actual numeric values of the `xp`, `yp`, and `zp` variables that were used during the script evaluation.

In some cases, you might want to see the actual numeric values that were used during command execution. To facilitate this, an `.eval` file also can be created during script evaluation. The global Scheme variable `evaluate-log-file` can be used to trigger the logging of the evaluated Scheme commands. By default, the log file evaluation is disabled and the value of the `evaluate-log-file` global Scheme variable is set to `#f`. If you want to create the evaluated Scheme file, you must add the `(set! evaluate-log-file #t)` command to the Scheme script.

If the input Scheme script is called `test.scm`, the log file is saved as `test.log` and the evaluated log file is saved as `test.log.eval`. If a script fails for some reason, the evaluated log file can be used to check the failing command, where all user-defined variables contain the actual values that were used during command execution.

The evaluated log file shortens and simplifies debugging and bug reporting, since the variables do not need to be evaluated separately.

<page_number>6</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

1: Introduction to Sentaurus Structure Editor

Exiting Sentaurus Structure Editor

# Interactive Mode

Sentaurus Structure Editor can be used interactively by either using the GUI menu bar and toolbars, or entering the Scheme commands in the command-line window.

To run Sentaurus Structure Editor in interactive mode, type in a command prompt:

`sde`

## Loading Boundary and Mesh Command Files at Startup

To load a boundary (`*_bnd.tdr`) file and a mesh command (`*.cmd`) file when starting Sentaurus Structure Editor, supply the common file name stem as a command-line option. For example:

`sde MyDevice`

This command starts Sentaurus Structure Editor and loads the `MyDevice.cmd` and `MyDevice_bnd.tdr` files.

## Loading an ACIS File at Startup

To load a file in the native ACIS format (`*.sat`) when starting Sentaurus Structure Editor, enter the file name as a command-line option. For example:

`sde MyDevice.sat`

This command starts Sentaurus Structure Editor and loads the `MyDevice.sat` file.

# Exiting Sentaurus Structure Editor

To exit Sentaurus Structure Editor:

* Choose **File** > **Exit** or press **Ctrl+Q**.

The corresponding Scheme command is:

`(exit)`

**NOTE** If the model has changed since the last save operation, Sentaurus Structure Editor displays a warning in the interactive mode.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>7</page_number>

# 1: Introduction to Sentaurus Structure Editor

TCAD Sentaurus Tutorial: Simulation Projects

Press Ctrl+\ to terminate Sentaurus Structure Editor from the command prompt as Ctrl+C is not recognized.

# TCAD Sentaurus Tutorial: Simulation Projects

The TCAD Sentaurus Tutorial provides various projects demonstrating the capabilities of Sentaurus Structure Editor.

To access the TCAD Sentaurus Tutorial:

1. Open Sentaurus Workbench by entering the following on the command line: `swb`

2. From the menu bar of Sentaurus Workbench, choose **Help** > **Training** or click the Training icon toolbar button.

Alternatively, to access the TCAD Sentaurus Tutorial:

1. Go to the following directory:

`$STROOT/tcad/current/Sentaurus_Training`

The `STROOT` environment variable indicates where the Synopsys TCAD distribution has been installed.

2. Open the `index.html` file in your browser.

<page_number>8</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

