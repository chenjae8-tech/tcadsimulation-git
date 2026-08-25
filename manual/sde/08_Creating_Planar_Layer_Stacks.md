# CHAPTER 8 Creating Planar Layer Stacks

*This chapter discusses how to create planar layer stacks efficiently including doping profiles, mole fraction profiles, and refinements.*

## Using the sdeepi:create-layerstack Scheme Extension

The `sdeepi:create-layerstack` Scheme extension is useful for simulating compound semiconductor devices based on epitaxial layer stacks. Such structures are typically grown using epitaxial growth techniques such as metal-organic chemical vapor deposition or molecular beam epitaxy. This Scheme extension facilitates structure generation for epitaxial layer stacks.

A typical epitaxial structure consists of a stack of planar layers. The straightforward approach to generate such a structure in Sentaurus Structure Editor requires approximately 10 to 15 commands to set up the geometry, doping, mole-fraction profiles, and refinements for each layer. This makes structure generation unnecessarily complex. Using `sdeepi:create-layerstack`, the layer stack description can be greatly simplified by using a single line to define all layer properties for each layer.

To facilitate working with and organizing material parameters, the MatPar utility is available (for details, see [[1]]([1])).

The `sdeepi:create-layerstack` Scheme extension has the following features:

* All settings and layer properties of the layer stack are specified in a comma-separated value (CSV) file that can be edited easily in a text editor or a spreadsheet application.

* All layer properties are defined efficiently with a single line in the CSV file.

* Based on the CSV file, `sdeepi:create-layerstack` generates the geometric representation of the layer stack itself as well as doping, mole profile definitions, and refinements.

* Automatic creation of top and bottom contacts.

* Both two-dimensional and three-dimensional layer stacks can be created.

* Both the unified coordinate system (UCS) and the DF–ISE coordinate system are supported.

* The epitaxial layers can have constant or graded doping and mole-fraction profiles.

* The layerwise mesh refinement strategy can be specified in the CSV file.

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>243</page_number>

8: Creating Planar Layer Stacks

Command File

The `sdeepi:create-layerstack` Scheme extension creates a planar layer stack from the user-defined description specified in the command file `sde_epi.csv`, which consists of the following major sections:

*   The *global section* where any global settings such as the lateral stack dimensions, global refinement, and the top and bottom contact names can be defined.

*   The *layers section* that defines for each layer its properties such as region name, material, thickness, mole fraction, and refinement in a single row.

*   An additional *parameter file section* where the generation of parameter files performed with MatPar can be controlled in more detail [1].

The command file `sde_epi.csv` can be edited easily by right-clicking the Sentaurus Structure Editor icon in the tool row and choosing **Edit Input > CSV Data File**.

# Command File

The command file `sde_epi.csv` contains all the information needed to create the layer stack. The file is preprocessed before execution as usual; therefore, it can include any common preprocessing and Tcl preprocessing statements.

The entire file is structured as a comma-separated value (CSV) file. Therefore, it consists of fields (columns) separated by commas. Each column is handled as a separate entity, for example, the name of the layer or the thickness of the layer. Any trailing commas are ignored.

Any line starting with a hash (#) as the first nonspace character is interpreted as a comment and is ignored.

The following example is a CSV file generating a simple 2D p-n GaAs diode:

```
$global coodinateSystem=UCS
$global Ymin=0.0, Ymax=2.0
$global dXmax=0.2
$global topContact=anode, bottomContact=cathode
#Region, Material, ParFile, Thickness, Doping, MoleFrac, Refinement
cap,GaAs,,0.2,-1E+019,,(xref 0.02)
fsf,AlGaAs,AlGaAs.par,0.04,-2E+018,0.8,(xref 0.01)
emitter,GaAs,,0.8,-9E+017,,(mbox 0.05 1.1 both)
base,GaAs,,3.2,1E+017,,(mbox 0.01 1.1 both)
bsf,AlGaAs,AlGaAs.par,0.2,5E+018,0.2,(mbox 0.01 1.2 both)
buffer,GaAs,,0.35,2E+018,,(mbox 0.01 1.2 up)
```

<page_number>244</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

8: Creating Planar Layer Stacks
Command File

# Global Section

The global section of the command file defines variables called *global variables*, which define the properties of the complete layer stack such as stack width, global refinement, and top and bottom contact names. The value of a particular global variable is the same for all layers in the stack.

A line starting with `$global` is used to modify a global variable in the following way:

```
$global variable1=<value>, variable2=<value>, ...
```

**NOTE** The variable names are case sensitive.

An example of a typical global section is:

```
# Simple solar cell structure
$global coordinateSystem=DFISE
$global Xmax=@wtot@
$global dXmin=5, dXmax=5, dYmin=0.5, dYmax=0.5
$global topContact=anode, bottomContact=cathode
```

where:

*   coordinateSystem sets the coordinate system used when saving the TDR file. More precisely, it defines the up direction of the structure:

<table>
  <thead>
    <tr>
        <th>Coordinate system</th>
        <th>Dimension</th>
        <th>Up direction</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>UCS</td>
        <td>2D</td>
        <td>-x</td>
    </tr>
    <tr>
        <td>UCS</td>
        <td>3D</td>
        <td>-x</td>
    </tr>
    <tr>
        <td>DF–ISE</td>
        <td>2D</td>
        <td>-y</td>
    </tr>
    <tr>
        <td>DF–ISE</td>
        <td>3D</td>
        <td>+z</td>
    </tr>
  </tbody>
</table>

*   Xmax sets the width of the layer stack to the Sentaurus Workbench parameter `@wtot@`.

*   dXmin, dXmax, dYmin, and dYmax define some global refinement.

*   topContact and bottomContact define the electrode names at the top and bottom of the structure, respectively.

For a complete list of global variables, see Table 32 on page 246. Details about the variables are described in the following sections.

Sentaurus™ Structure Editor User Guide
<page_number>245</page_number>
S-2021.06

# 8: Creating Planar Layer Stacks

Command File

All global variables can be written to the layer information file `nX_epi.tcl` using the command:

```
(sdeepi:tcl "nX_epi.csv" "nX_epi.tcl")
```

Therefore, all global variables are available as Tcl variables in Tcl preprocessing blocks of any subsequent tools by sourcing this file. For example, to print the minimum y-coordinate of the stack inside a subsequent command file, insert the following:

```
!(
   source "nX_epi.tcl"
   puts min
)!
```

> **NOTE** In Sentaurus Workbench, the preprocessed CSV file `nX_epi.csv` can be access by `@epicsv@`. Similarly, the layer information file `nX_epi.tcl` can be accessed through `@epitcl@`.

Table 32 Structure information in global section of CSV file, listing predefined global variables

<table>
  <thead>
    <tr>
      <th>Predefined global 
variables</th>
      <th>Description</th>
      <th>Settable? Default</th>
      <th>value</th>
      <th>Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="5">Geometric properties of complete layer stack in all three directions</td>
    </tr>
    <tr>
      <td>Xmin</td>
      <td>Minimum extent of the layer stack in the x-direction. Yes</td>
      <td></td>
      <td>0</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>Xmax</td>
      <td>Maximum extent of the layer stack in the x-direction. 
Ignored if set for the UCS.</td>
      <td>(Yes)</td>
      <td>1</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>Ymin</td>
      <td>Minimum extent of the layer stack in the y-direction. Yes</td>
      <td></td>
      <td>0</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>Ymax</td>
      <td>Maximum extent of the layer stack in the y-direction. 
Ignored if set for the DF–ISE coordinate system (two 
dimensions).</td>
      <td>(Yes)</td>
      <td>1</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>Zmin</td>
      <td>Minimum extent of the layer stack in the z-direction. It can 
be set only for UCS (three dimensions); otherwise, it is 
ignored.</td>
      <td>(Yes)</td>
      <td>0</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>Zmax</td>
      <td>Maximum extent of the layer stack in the z-direction.
Ignored if set in two dimensions.</td>
      <td>(Yes)</td>
      <td>1</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>coordinateSystem</td>
      <td>Either UCS (unified coordinate system) or DFISE (DF–ISE 
coordinate system).</td>
      <td>Yes</td>
      <td>UCS</td>
      <td>–</td>
    </tr>
    <tr>
      <td>dimension</td>
      <td>For 2D structures, dimension=2.
For 3D structures, dimension=3.</td>
      <td>Yes</td>
      <td>2</td>
      <td>–</td>
    </tr>
  </tbody>
</table>

<page_number>246</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

8: Creating Planar Layer Stacks
Command File

Table 32 Structure information in global section of CSV file, listing predefined global variables (Continued)

<table>
  <thead>
    <tr>
      <th>Predefined global 
variables</th>
      <th>Description</th>
      <th>Settable? <sup>Default </sup><sub>value</sub></th>
      <th></th>
      <th>Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td colspan="5">Global mesh refinement strategy for entire structure</td>
    </tr>
    <tr>
      <td>dXmin, dYmin, 
dZmin</td>
      <td>Minimum element size in the xyz directions.</td>
      <td>Yes</td>
      <td>9999.0</td>
      <td>μm</td>
    </tr>
    <tr>
      <td>dXmax, dYmax, 
dZmax</td>
      <td>Maximum element size in the xyz directions.</td>
      <td>Yes</td>
      <td>9999.0</td>
      <td>μm</td>
    </tr>
    <tr>
      <td colspan="5">Electrode information</td>
    </tr>
    <tr>
      <td>topContact</td>
      <td>If defined, contains the name of the contact to be created on 
the top of the layer stack.</td>
      <td>Yes</td>
      <td>– –</td>
      <td></td>
    </tr>
    <tr>
      <td>bottomContact</td>
      <td>If defined, contains the name of the contact to be created at 
the bottom of the layer stack.</td>
      <td>Yes</td>
      <td>– –</td>
      <td></td>
    </tr>
    <tr>
      <td colspan="5">Meshing <sup>tool information</sup></td>
    </tr>
    <tr>
      <td>columnNames</td>
      <td>Contains a list of column names. To add user-defined 
columns, use the following syntax:
$global <sup>append columnNames &lt;column1> </sup>
&lt;column2> ...</td>
      <td>Yes</td>
      <td>– –</td>
      <td></td>
    </tr>
    <tr>
      <td>bottomRegionName</td>
      <td>Region name of the bottommost layer.</td>
      <td>No</td>
      <td>– –</td>
      <td></td>
    </tr>
    <tr>
      <td>topRegionName</td>
      <td>Region name of the topmost layer.</td>
      <td>No</td>
      <td>– –</td>
      <td></td>
    </tr>
  </tbody>
</table>

## Size and Position of Structure

The variables `Xmin`, `Xmax`, `Ymin`, `Ymax`, `Zmin`, and `Zmax` describe the extent of the layer stack in all three directions.

Figure 120 on page 248 shows a 2D layer stack created by `sdeepi:create-layerstack` and illustrates both the UCS and the DF–ISE coordinate system. The coordinate system is chosen with the global variable `coordinateSystem`, for example, the default is `coordinateSystem=UCS`. In this case, the top of the layer stack is in the x-direction. The topmost layer in the command file will be created with its top edge at `Xmin`.

Set `coordinateSystem=DFISE` to activate the DF–ISE coordinate system. In this case, for a 2D structure, the top of the layer stack is in the –y-direction and the topmost layer is at `Ymin`.

Each subsequent layer line will be created in the order it appears in the command file, until the last layer is created. The bottom edge of the last layer defines `Xmax` for the UCS (or `Ymax` for the DF–ISE coordinate system for a 2D structure).

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>247</page_number>

# 8: Creating Planar Layer Stacks

Command File

<table>
  <thead>
    <tr>
        <th>Coordinate System</th>
        <th>Vertical Axis</th>
        <th>Horizontal Axis</th>
        <th>Top-Left Corner</th>
        <th>Bottom-Right Corner</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>UCS</td>
        <td>X</td>
        <td>Y</td>
        <td>(Xmin, Ymin)</td>
        <td>(Xmax, Ymax)</td>
    </tr>
    <tr>
        <td>DF-ISE</td>
        <td>Y</td>
        <td>X</td>
        <td>(Xmin, Ymin)</td>
        <td>(Xmax, Ymax)</td>
    </tr>
  </tbody>
</table>

Figure 120 Generated layer stack with: (*left*) UCS and (*right*) DF–ISE coordinate system

By default, `Xmin` = `Ymin` = 0. In addition, as shown in Figure 120, it is required that `Xmin` < `Xmax`. All layers have the same width, which can be defined using `Ymin` and `Ymax` for the UCS, or `Xmin` and `Xmax` for the DF–ISE coordinate system (see Table 32 on page 246).

If the global variable `dimension=3` is specified, a corresponding 3D structure is created as illustrated in Figure 121. The top of the layer stack is in the –x-direction for the UCS and in the +z-direction for the DF–ISE coordinate system. The extent of the layer stack in the third dimension is controlled with the `Zmin` and `Zmax` variables for the UCS, and the `Ymin` and `Ymax` variables for the DF–ISE coordinate system.

The next sections describe the usage of `sdeepi` in the UCS.

Three-dimensional layer stack diagrams showing UCS and DF-ISE coordinate systems

Figure 121 Three-dimensional layer stack with (*left*) UCS and updirection=-x, Ymax=15, and Zmax=10, and (*right*) DF–ISE coordinate system and updirection=+z, Xmax=10, and Ymax=15

<page_number>248</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**8: Creating Planar Layer Stacks**
Command File

## Global Refinement Strategy

In addition to layerwise refinements (see Refinement Column on page 257), `sdeepi:create-layerstack` allows you to define a global refinement that is defined as a refinement window covering the entire layer stack.

`dXmin` and `dXmax` are minimum and maximum element sizes, respectively, for global mesh refinement in the x-direction for the entire structure. `dYmin`, `dYmax`, `dZmin`, and `dZmax` have similar meaning.

If you define `dXmin=0`, or `dYmin=0`, or `dZmin=0`, `sdeepi:create-layerstack` resets this minimum element size to be equal to the corresponding maximum element size. The global refinement window is positioned to cover the entire layer stack.

> **NOTE** The `sdeepi:create-layerstack` Scheme extension generates global refinement commands only if the value of at least one of these variables is modified by users.

## User-Defined Extension Columns

In addition to the predefined layer properties, `sdeepi:create-layerstack` allows you to add user-defined layer properties. This can be useful in cases where some tools need additional layer-specific data. For example, to switch on radiative recombination in Sentaurus Device for particular layers, an additional layer column `Rrad` could be defined with:

```
$global append columnNames Rrad
```

This user-defined column can be filled with values as described in Extension Columns on page 259. The column values are saved with all other properties in the Tcl file `nX_epi.tcl` and can be incorporated in any subsequent Tcl preprocessing block.

> **NOTE** To create multiple extension columns, use the following syntax:

```
$global append columnNames <extensionColumnName1>
          <extensionColumnName2> ...
```

# Layers Section

All layers of the layer stack are defined in the layers section, which consists of one line for each layer to be created. Basically, any line not starting with a hash (#) or a dollar sign ($) is a layer line. Stack generation starts with the first layer line as the topmost layer of the stack and continues from top to bottom until the last layer line is reached.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

249
</page_number>

# 8: Creating Planar Layer Stacks

Command File

Each layer line consists of several comma-separated columns, which `sdeepi:create-layerstack` uses to create the layer stack:

```
<Region>, <Material>, <SourceParFile>, <Thickness>, <Doping>, <MoleFraction>,
<Refinement>, [<Extension1>, <Extension2>, ...]
```

Lines starting with an empty region name are used to create materialwise parameter file definitions for MatPar [1].

Table 33 summarizes the columns used to describe each layer.

Table 33 Columns in layers section of CSV file

<table>
  <thead>
    <tr>
        <th>Column</th>
        <th>Description</th>
        <th>Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>Region</td>
        <td>Region name.</td>
        <td>—</td>
    </tr>
    <tr>
        <td>Material</td>
        <td>Material name.</td>
        <td>—</td>
    </tr>
    <tr>
        <td>SourceParFile</td>
        <td>Name of the source parameter file. Only used if MatPar is used to generate parameter files.</td>
        <td>—</td>
    </tr>
    <tr>
        <td>Thickness</td>
        <td>Layer thickness.</td>
        <td>μm</td>
    </tr>
    <tr>
        <td>Doping</td>
        <td>Doping of each layer. A negative sign indicates p-type doping; a positive sign indicates n-type doping.</td>
        <td>cm<sup>−3</sup></td>
    </tr>
    <tr>
        <td>MoleFraction</td>
        <td>Mole fraction for ternary or quaternary materials.</td>
        <td>[1]</td>
    </tr>
    <tr>
        <td>Refinement</td>
        <td>Regionwise mesh refinement strategy for each layer.</td>
        <td>μm</td>
    </tr>
    <tr>
        <td> </td>
        <td>Additional user-defined extension columns can be added for various purposes.</td>
        <td>—</td>
    </tr>
  </tbody>
</table>

The following is an example of the layers section of the command file of a GaAs single-junction solar cell:

```
# Layers section
# Region, Material, SourceParFile, Thickness, Doping, MoleFraction,
# Refinement
cap,GaAs,,0.5,-5e19,,(xref 0.1)
fsf,AlGaAs,AlGaAs.par,0.03,-4e18,0.8,(xref 0.01)
emitter,GaAs,,0.5,-5e17,,(mbox 0.05 1.1 both)
base,GaAs,,2.5,1e17,,(mbox 0.05 1.1 both)
substrate,Germanium,Ge.par,5.0,1e18,,(mbox 0.05 1.1 both)
```

250

Sentaurus™ Structure Editor User Guide
S-2021.06

8: Creating Planar Layer Stacks
Command File

Table 34 shows how the same listing in a spreadsheet format, underlining the well-arranged representation, compares to the source file listing.

Table 34 Example of layers section and material and interface section of epi_epi.csv

<table>
  <thead>
    <tr>
        <th>Line number</th>
        <th>Region</th>
        <th>Material</th>
        <th>SourceParFile</th>
        <th>Thickness</th>
        <th>Doping</th>
        <th>MoleFraction</th>
        <th>Refinement</th>
    </tr>
    <tr>
        <th colspan="8"># Layers section:</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>1</td>
        <td>cap</td>
        <td>GaAs</td>
        <td> </td>
        <td>0.5</td>
        <td>-5.00e19</td>
        <td> </td>
        <td>(xref 0.1)</td>
    </tr>
    <tr>
        <td>2</td>
        <td>fsf</td>
        <td>AlGaAs</td>
        <td>AlGaAs.par</td>
        <td>0.03</td>
        <td>-4.00e18</td>
        <td>0.8</td>
        <td>(xref 0.01)</td>
    </tr>
    <tr>
        <td>3</td>
        <td>emitter</td>
        <td>GaAs</td>
        <td> </td>
        <td>0.5</td>
        <td>-5.00e17</td>
        <td> </td>
        <td>(mbox 0.05 1.1 both)</td>
    </tr>
    <tr>
        <td>4</td>
        <td>base</td>
        <td>GaAs</td>
        <td> </td>
        <td>2.5</td>
        <td>1.00e17</td>
        <td> </td>
        <td>(mbox 0.05 1.1 both)</td>
    </tr>
    <tr>
        <td>5</td>
        <td>substrate</td>
        <td>Germanium</td>
        <td>Ge.par</td>
        <td>5.0</td>
        <td>1.00e18</td>
        <td> </td>
        <td>(mbox 0.05 1.1 both)</td>
    </tr>
  </tbody>
</table>

**NOTE** If all columns following a particular column are empty in a layer definition, any trailing commas are ignored. Therefore, the following two layer definitions are identical:

`cap,GaAs,GaAs.par,0.5,-5e19,,,`

`cap,GaAs,GaAs.par,0.5,-5e19`

**NOTE** Leading and intermediate commas are important.

## Region Column

The `sdeepi:create-layerstack` Scheme extension creates a region for each layer. The name of the region is specified in the Region column.

## Material Column

For each layer, the names of materials that Sentaurus Device recognizes are specified in the Material column. For example, for a germanium layer, Germanium is specified in the Material column.

To generate a list of all materials that Sentaurus Device recognizes, use:

```
sdevice -L:materials
```

If a particular material is not in the list, it can be made available to all TCAD Sentaurus tools by creating a local `datexcodes.txt` file. For details on how to create new materials, refer to the *Sentaurus™ Device User Guide*.

Sentaurus™ Structure Editor User Guide <page_number>251</page_number>
S-2021.06

# 8: Creating Planar Layer Stacks

Command File

## SourceParFile Column

If MatPar is not used for parameter file generation, the SourceParFile column is ignored and can remain empty.

Otherwise, this column contains the source parameter file to be used for this layer [1].

## Thickness Column

The thickness of each layer in micrometers is specified in the Thickness column. If the Thickness column is empty, or is less than or equal to zero, `sdeepi:create-layerstack` does not create the layer.

## Doping Column

The doping information for each layer is specified in the Doping column. Doping values greater than zero create n-type doping using the dataset `ArsenicActiveConcentration`. Doping values less than zero create p-type doping using the dataset `BoronActiveConcentration`.

One or several constant or analytic doping profiles can be specified using the commands in Table 35 on page 253. These commands create region-based doping profiles for the layer in the y-direction. The following types of doping profile can be defined in the y-direction:

* Constant

* Linear

* Error function

* Gaussian function

* General analytic function $f(x, y, z)$

If multiple doping profiles must be created, the bracket form must be used for profile definition. For example, to specify a constant doping of n=1e15 and p=2e15 in the same layer, use `(1e15)(-2e15)`.

<page_number>252</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

# 8: Creating Planar Layer Stacks
Command File

Table 35 Commands for Doping column

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
        <th>Unit</th>
    </tr>
    <tr>
        <th colspan="3">Constant doping profile</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>&lt;doping&gt;<br/>or:<br/>(&lt;doping&gt; [&lt;options:rnp&gt;])</td>
        <td>Constant doping concentration.</td>
        <td>cm<sup>-3</sup></td>
    </tr>
    <tr>
        <th colspan="3">Linear doping profile</th>
    </tr>
    <tr>
        <td>(lin &lt;Ntop&gt; &lt;Nbot&gt;<br/>[&lt;options:rsnp&gt;])</td>
        <td>Linear doping profile using analytic profile.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;Ntop&gt;</td>
        <td>Value of doping concentration at the top edge of the layer.</td>
        <td>cm<sup>-3</sup></td>
    </tr>
    <tr>
        <td>&lt;Nbot&gt;</td>
        <td>Value of doping concentration at the bottom edge of the layer.</td>
        <td>cm<sup>-3</sup></td>
    </tr>
    <tr>
        <th colspan="3">Error function or Gaussian function doping profile</th>
    </tr>
    <tr>
        <td>(erf|gauss &lt;Nmax&gt; &lt;ymax&gt;<br/>&lt;length&gt; [&lt;options:udrsnp&gt;])</td>
        <td>Error function or Gaussian function doping profile.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;Nmax&gt;</td>
        <td>Maximum concentration/peak concentration.</td>
        <td>cm<sup>-3</sup></td>
    </tr>
    <tr>
        <td>&lt;ymax&gt;</td>
        <td>For erf, this is the symmetry position. For gauss, this is the peak position.</td>
        <td>µm</td>
    </tr>
    <tr>
        <td>&lt;length&gt;</td>
        <td>For gauss, &lt;length&gt; represents the distance between the peak position and a place where the profile value decays by a factor of exp(-1).<br/>For erf, &lt;length&gt; represents the distance between the symmetry position and a place where the profile value decays by a factor of 1/2*(1+erf(1)).</td>
        <td>µm</td>
    </tr>
    <tr>
        <th colspan="3">General analytic function doping profile</th>
    </tr>
    <tr>
        <td>(func &lt;func&gt;<br/>[&lt;options:rsgnp&gt;])</td>
        <td>Contains the general function expression, where the coordinates x,y,z are local to the layer assuming (xmin,ymin,zmin) of the layer as origin. The layer coordinates xmin, ymin, zmin, xmax, ymax, zmax and the layer extents dx, dy, dz also can be used in &lt;func&gt;.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;func&gt;</td>
        <td>Contains the general function expression, where the xyz coordinates are local to the layer assuming (xmin,ymin,zmin) of the layer as origin.</td>
        <td>cm<sup>-3</sup></td>
    </tr>
    <tr>
        <th colspan="3">Options</th>
    </tr>
    <tr>
        <td>u|d</td>
        <td>Controls the edge or face of the layer at which the baseline of the profile is placed:<br/>u = Baseline is placed at the top edge or face (default).<br/>d = Baseline is placed at the bottom edge or face.</td>
        <td> </td>
    </tr>
    <tr>
        <td>r</td>
        <td>If specified, the option Replace is used in the AnalyticalProfile section of the Placement section of the mesh command file. Otherwise, NoReplace is used.</td>
        <td> </td>
    </tr>
    <tr>
        <td>s</td>
        <td>If specified, EvaluateWindow is not defined in the AnalyticalProfile section of the Placement section of the mesh command file.</td>
        <td> </td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide
S-2021.06

253

# 8: Creating Planar Layer Stacks

Command File

Table 35 Commands for Doping column (Continued)

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
        <th>Unit</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>g</td>
        <td>Uses the global instead of the local layer-specific coordinate system for x,y,z of the general function.</td>
        <td> </td>
    </tr>
    <tr>
        <td>n | p</td>
        <td>Ignores the sign of the doping concentration and uses the specified doping type.</td>
        <td> </td>
    </tr>
    <tr>
        <th colspan="3">Default constant value for profiles</th>
    </tr>
    <tr>
        <td>(default &lt;doping&gt;)</td>
        <td>Only used if MatPar is used for parameter file generation. Used in cases where material parameter calculation requires a constant doping value. &lt;doping&gt; defines the constant doping value to be used if required in the material parameter calculation.</td>
        <td>cm<sup>-3</sup></td>
    </tr>
  </tbody>
</table>

For each layer, the doping profiles are created with the following parameters:

■ The `AnalyticalProfile` section of the `Definition` section:

* `Species=ArsenicActiveConcentration | BoronActiveConcentration` (for n-type or p-type doping, respectively)

* `Function=General | Error | Gauss` (for linear or general functions, error, or Gaussian function doping profile, respectively)

* `LateralFunction=Erf(Factor=0)` (for error and Gaussian profiles)

■ The `AnalyticalProfile` section of the `Placements` section:

* The baseline for each layer is the bottom or top edge (2D) or face (3D), depending on the specification of the option `u | d` in the Doping column (see Table 35 on page 253).

* By default, the option `NoReplace` is used. However, if the option `r` is specified in the Doping column (see Table 35), `Replace` is used instead.

* The variable `Direction` is not specified in the `ReferenceElement` section since the function values are computed on both sides of the baseline.

* By default, all analytic doping profiles are placed using the `EvaluateWindow` section. For each layer, the domain for the evaluation of the profile is the layer region and `DecayLength=0`. The `EvaluateWindow` is not defined if the option `s` is specified in the Doping column (see Table 35).

For more details, write out the mesh command file with `sdedr:write-cmd-file`, and refer to the *Sentaurus™ Mesh User Guide*.

Examples of specifying constant doping profiles are given in Table 34 on page 251. Lines 1–3 are defined as p-type doped layers, and lines 4 and 5 are defined as n-type doped layers.

<page_number>254</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

8: Creating Planar Layer Stacks

Command File

An example of an n-type doped layer with a Gaussian doping profile, with a peak concentration of 1e15 cm<sup>–3</sup>, a relative peak position from the top of the layer of 0.2 μm, and a decay length of 0.3 μm is defined with the following line:

```
4dopgauss,GaAs,,1,(gauss 1e15 0.2 0.3)
```

A constant p-type background doping of 2e16 cm<sup>–3</sup> plus an n-type sine-modulated doping using a default value of 1e16 cm<sup>–3</sup> for the material parameter calculation can be defined as follows:

```
6dopfunc,GaAs,,1,(2e16 p)(func 1e15*sin(2*3.1415*x/dx) n)(default -1e16)
```

If MatPar is used, a default value for the reference doping concentration can be defined for layers with doping profiles with the command `default`. A constant doping value could be necessary in some cases, if during material parameter calculation, the specified model cannot handle the doping profile and requires a constant value instead.

## MoleFraction Column

The mole-fraction information of layers consisting of ternary or quaternary compound semiconductor materials is described in the MoleFraction column. The column is empty for elemental or binary semiconductors. A constant mole fraction or a mole-fraction profile very similar to doping profiles can be specified using the commands in Table 36. These commands create region-based mole-fraction profiles for the layer in the y-direction.

A default reference mole-fraction value can be defined for layers with mole-fraction profiles with the command `default`.

A constant mole-fraction value might be necessary in some cases, if during material parameter calculation, the specified model cannot handle the mole-fraction profile and requires a constant mole-fraction value instead.

Table 36 Commands for MoleFraction column

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
        <th>Unit</th>
    </tr>
    <tr>
        <th colspan="3">Constant mole fraction</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>&lt;xMole&gt;<br/>or:<br/>(&lt;xMole&gt; [&lt;options:rxy&gt;])</td>
        <td>Defines a constant x–mole fraction for ternary compound semiconductors.</td>
        <td>1</td>
    </tr>
    <tr>
        <th colspan="3">Linear mole-fraction profile</th>
    </tr>
    <tr>
        <td>(lin &lt;xMoleTop&gt; &lt;xMoleBot&gt;<br/>[&lt;options:rsxy&gt;])</td>
        <td>Linear x–mole fraction profile using analytic profile.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;xMoleTop&gt;</td>
        <td>Mole-fraction value at the top edge of the layer.</td>
        <td>1</td>
    </tr>
    <tr>
        <td>&lt;xMoleBot&gt;</td>
        <td>Mole-fraction value at the bottom edge of the layer.</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide

<page_number>255</page_number>

S-2021.06

# 8: Creating Planar Layer Stacks

Command File

Table 36 Commands for MoleFraction column (Continued)

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
        <th>Unit</th>
    </tr>
    <tr>
        <th colspan="3">Error function or Gaussian function mole-fraction profile</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>(erf|gauss &lt;xMoleMax&gt; &lt;ymax&gt; &lt;length&gt; [&lt;options:udrsxy&gt;])</td>
        <td>Error function or Gaussian function mole-fraction profile.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;xMoleMax&gt;</td>
        <td>Maximum value/peak value.</td>
        <td>1</td>
    </tr>
    <tr>
        <td>&lt;ymax&gt;</td>
        <td>Symmetry position/peak position.</td>
        <td>µm</td>
    </tr>
    <tr>
        <td>&lt;length&gt;</td>
        <td>For gauss, &lt;length&gt; represents the distance between the peak position and a place where the profile value decays by a factor of exp(-1).<br/>For erf, &lt;length&gt; represents the distance between the symmetry position and a place where the profile value decays by a factor of 1/2*(1+erf(1)).</td>
        <td>µm</td>
    </tr>
    <tr>
        <th colspan="3">General analytic function doping profile</th>
    </tr>
    <tr>
        <td>(func &lt;func&gt; [&lt;options:rsgxy&gt;])</td>
        <td>Generates an arbitrary analytic mole-fraction profile using the general function evaluator of Sentaurus Mesh.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;func&gt;</td>
        <td>Contains the general function expression, where the coordinates x,y,z are local to the layer assuming (xmin,ymin,zmin) of the layer as origin. The layer coordinates xmin, ymin, zmin, xmax, ymax, zmax and the layer extents dx, dy, dz also can be used in &lt;func&gt;.</td>
        <td> </td>
    </tr>
    <tr>
        <th colspan="3">Options</th>
    </tr>
    <tr>
        <td>u|d</td>
        <td>Controls the edge or face of the layer at which the baseline of the profile is placed:<br/>u = Baseline is placed at the top edge or face (default).<br/>d = Baseline is placed at the bottom edge or face.</td>
        <td> </td>
    </tr>
    <tr>
        <td>r</td>
        <td>If specified, the option Replace is used in the AnalyticalProfile section of the Placement section of the mesh command file. Otherwise, NoReplace is used.</td>
        <td> </td>
    </tr>
    <tr>
        <td>s</td>
        <td>If specified, EvaluateWindow is not defined in the AnalyticalProfile section of the Placement section of the mesh command file.</td>
        <td> </td>
    </tr>
    <tr>
        <td>g</td>
        <td>Uses the global instead of the local layer-specific coordinate system for x,y,z of the general function.</td>
        <td> </td>
    </tr>
    <tr>
        <td>x|y</td>
        <td>Sets the mole-fraction type explicitly. Default is x.</td>
        <td> </td>
    </tr>
    <tr>
        <th colspan="3">Default constant value for profiles</th>
    </tr>
    <tr>
        <td>(default &lt;xMole&gt; [&lt;yMole&gt;])</td>
        <td>Only used if MatPar is used for parameter file generation. Used in cases where material parameter calculation requires a constant x- or y-mole fraction value.</td>
        <td> </td>
    </tr>
    <tr>
        <td>&lt;xMole&gt;, &lt;yMole&gt;</td>
        <td>Defines the constant x- and y-mole fraction value to be used if required in the material parameter calculation.</td>
        <td>1</td>
    </tr>
  </tbody>
</table>

<page_number>256</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

8: Creating Planar Layer Stacks

Command File

Table 36 Commands for MoleFraction column (Continued)

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
        <th>Unit</th>
    </tr>
    <tr>
        <th colspan="3">Mole-fraction profiles for quaternary materials</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>(y &lt;yMole&gt;|lin|erf|func| gauss ...)</td>
        <td>Creates a y–mole fraction profile very similar to the above definitions for x–mole fraction profiles.</td>
        <td> </td>
    </tr>
    <tr>
        <td>(&lt;xMole&gt; &lt;yMole&gt;)</td>
        <td>Defines a constant x– and y–mole fraction for quaternary compound semiconductors.</td>
        <td>1</td>
    </tr>
    <tr>
        <td>(... x)(... y)</td>
        <td>In general, x– and y–mole fraction profiles can be defined separately using the x and y options. For example:<br/>(lin 0.1 0.2 x)(lin 0.9 0.8 y)</td>
        <td> </td>
    </tr>
  </tbody>
</table>

For example, to create a layer with a constant x–mole fraction profile with a value of 0.1, the following lines are identical:

```
1molconst,AlGaAs,,1,1e15,0.1
2molconst,AlGaAs,,1,1e15,(0.1)
3molconst,AlGaAs,,1,1e15,(0.1 x)
```

The following line creates a linear x–mole fraction profile with a value of 0.3 at the top and 0.4 at the bottom:

```
3mollin,AlGaAs,,1,1e15,(lin 0.3 0.4)
```

To create a constant mole-fraction profile of x=0.2 y=0.3, all of the following expressions are identical:

```
(0.2 0.3), (0.2)(y 0.3), (0.2)(0.3 y), (0.3 y)(0.2 x)
```

## Refinement Column

The Refinement column in the command file offers two different meshing strategies:

* Constant refinement in the xyz directions with the commands `xref`, `yref`, and `zref`.

* Graded refinement, dense at an interface, relaxing towards the bulk, using the command `mbox` (which stands for multibox).

Mesh refinement for a particular layer is performed using the commands `xref` and `mbox` (see Table 37 on page 258). The terminology related to mesh refinement is discussed in the *Sentaurus™ Mesh User Guide*.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>257</page_number>

# 8: Creating Planar Layer Stacks

Command File

Table 37 Commands for Refinement column

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
    </tr>
    <tr>
        <th colspan="2">Uniform regionwise refinement</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>(xref|yref|zref &lt;minelsize&gt; [&lt;maxelsize&gt;])</td>
        <td>Uniform regionwise refinement in the xyz directions.</td>
    </tr>
    <tr>
        <td>&lt;minelsize&gt;</td>
        <td>Specifies the minimum element size (mesh spacing) in the corresponding direction. Default is the layer extent in the corresponding direction.</td>
    </tr>
    <tr>
        <td>&lt;maxelsize&gt;</td>
        <td>Specifies the maximum element size (mesh spacing) in the corresponding direction. By default, it is set equal to the minimum element size.</td>
    </tr>
    <tr>
        <th colspan="2">Multibox regionwise refinement</th>
    </tr>
    <tr>
        <td>(mbox &lt;minelsize&gt; &lt;ratio&gt; &lt;side:udlrfb&gt;)</td>
        <td>Defines a multibox refinement for a layer for the specified sides.</td>
    </tr>
    <tr>
        <td>&lt;minelsize&gt;</td>
        <td>Specifies the minimum element size at the interface.</td>
    </tr>
    <tr>
        <td>&lt;ratio&gt;</td>
        <td>Controls how fast the mesh spacing increases from the minimum value to the maximum value, which is the layer thickness. ratio=1 is equal to a constant meshing with &lt;minelsize&gt;. With ratio=2, the element size is doubled at each step.</td>
    </tr>
    <tr>
        <td>&lt;side:udlrfb&gt;</td>
        <td>Controls the edge (2D) or the face (3D) of the multibox from which the graded mesh will start. Default is ud. Options (described for the UCS case; see Figure 121 on page 248) are:<br/>* u (up): Grading starts from the top (xmin) of the layer.<br/>* d (down): Grading starts from the bottom (xmax) of the layer.<br/>* l (left): Grading starts from the left (ymin) of the layer.<br/>* r (right): Grading starts from the right (ymax) of the layer.<br/>* f (front): For 3D structures, grading starts from the front (zmax) of the layer.<br/>* b (back): For 3D structures, grading starts from the back (zmin) of the layer.<br/>The keywords written in parentheses after each option can be used as synonyms. In addition, the keyword both can be used as a synonym for ud.</td>
    </tr>
    <tr>
        <th colspan="2">MaxLenInt interface refinement</th>
    </tr>
    <tr>
        <td>(int &lt;Value&gt; &lt;Factor&gt; &lt;side:udlrfb&gt;)</td>
        <td>Specifies a MaxLenInt-type interface refinement.</td>
    </tr>
    <tr>
        <td>&lt;Value&gt;</td>
        <td>Specifies the initial thickness.</td>
    </tr>
    <tr>
        <td>&lt;Factor&gt;</td>
        <td>Specifies the factor by which the initial thickness should grow into the material.</td>
    </tr>
  </tbody>
</table>

<page_number>258</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

8: Creating Planar Layer Stacks
Command File

Table 37 Commands for Refinement column (Continued)

<table>
  <thead>
    <tr>
        <th>Command</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>&lt;side:udlrfb&gt;</td>
        <td>Controls the edge (2D) or the face (3D) of the multibox from which the graded mesh will start. Default is ud. Options (described for the UCS case; see Figure 121 on page 248) are:<br/>• u (up): Grading starts from the top (xmin) of the layer.<br/>• d (down): Grading starts from the bottom (xmax) of the layer.<br/>• l (left): Grading starts from the left (ymin) of the layer.<br/>• r (right): Grading starts from the right (ymax) of the layer.<br/>• f (front): For 3D structures, grading starts from the front (zmax) of the layer.<br/>• b (back): For 3D structures, grading starts from the back (zmin) of the layer.<br/>The keywords written in parentheses after each option can be used as synonyms. In addition, the keyword both can be used as a synonym for ud.</td>
    </tr>
  </tbody>
</table>

In addition to the layerwise refinements described here, refinements can be specified either using the global variables dXmin, dXmax, and so on, or using the standard Sentaurus Structure Editor refinement commands.

Looking at Table 34 on page 251, the refinement statement for the region cap in line 1 (xref 0.1) generates an equidistant refinement in the x-direction with a spacing of 0.1 μm. Very similar refinement is generated with the expression (xref 0.01) for the region fsf in line 2 but using a spacing of 0.01 μm. For lines 3–5, each layer is refined in the x-direction with a multibox refinement statement (mbox 0.05 1.1 both), starting with a spacing of 0.05 at both interfaces and gradually increasing the element size by a factor of 1.1 towards the bulk.

## Extension Columns

In addition to the predefined layer properties, `sdeepi:create-layerstack` allows you to add multiple user-defined layer properties that are appended to the layer line as additional columns.

The Extension column can have arbitrary content and can be used by any subsequent Tcl preprocessing blocks. For example, you could introduce an additional layer property or column Rrad to switch on the radiative recombination model in the Sentaurus Device command file for certain layers.

The following lines in the CSV file would define such an additional column, with the value no for the fsf region, and the value yes for the emitter region:

```
$global append columnNames Rrad
fsf,AlGaAs,AlGaAs.par,0.03,-4.00e18,0.8,(xref 0.01),no
emitter,GaAs,,0.5,-5.00e17,,(mbox 0.05 1.1 both),yes
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>259</page_number>

# 8: Creating Planar Layer Stacks

Processing the Layer Stack

With the Scheme command `sdeepi:tcl`, all the layer information including the Extension columns can be written to a Tcl file `@epitcl@` (for example, `n1_epi.tcl`):

```
(sdeepi:tcl "@epicsv@" "@epitcl@")
```

The following is an excerpt from the Tcl file:

```
set epi(region,fsf,region) "fsf"
set epi(region,fsf,Rrad) "no"
set epi(region,emitter,region) "emitter"
set epi(region,emitter,Rrad) "yes"
```

The values of the `Rrad` column then can be accessed and used in the Sentaurus Device command file to decide whether radiative recombination should be switched on or off for a certain layer:

```
!(
    source @epitcl@
    foreach {key region} [array get epi "region,*,region"] {
        if {"$epi(region,$region,Rrad)"=="yes"} {
            puts "Physics (region=\"$region\") {Recombination(Radiative)}"
        }
    }
)!
```

The first line sources all Tcl variables of the layer information file into the Tcl interpreter of the preprocessor. The `foreach` statement loops through all Tcl variables that have the form `epi(region,*,region)`, that is, all layers of the layer stack. The variable `$region` contains the region name of the current layer. Any other column value can be accessed by `$epi(region,$region,<column>)` where `<column>` is replaced by the column name of interest. In this case, you want to access the Extension column `Rrad`, therefore, you use `$epi(region,$region,Rrad)` and, if its content is "yes", a regionwise Physics entry is printed to the command file.

The result of the preprocessed block for this example is:

```
Physics (region="emitter") {Recombination(Radiative)}
```

**NOTE** By default, there is no Extension column.

# Processing the Layer Stack

The `sdeepi:create-layerstack` Scheme extension creates a layer stack as it is produced during any nonstructuring deposition process, for example, molecular beam epitaxy (MBE) or metal organic vapor phase epitaxy (MOVPE). Subsequent commands can be used to reflect any further processing steps of the wafer such as lateral patterning steps.

<page_number>260</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**8: Creating Planar Layer Stacks**
Processing the Layer Stack

Figure 122 illustrates this by a layered GaAs solar cell structure. On the left, the structure created using `sdeepi:create-layerstack` is shown; on the right, the processed solar cell structure is illustrated with a partially removed cap layer on the top, a partially deposited ARC, and contacts.

Engineering drawing of GaAs solar cell structure showing doping concentration profiles for initial layer stack and processed device.

Figure 122 (Left) Layer stack as created by `sdeepi:create-layerstack` and (right) device structure with additional processing steps

For convenience, all global variables as well as geometric variables can be made available to Sentaurus Structure Editor as Scheme variables using:

```
(sdeepi:publish-global-vars #t)
```

By default, to avoid overwriting existing Scheme variables, none of the layer stack variables is retained after the stack creation.

Various device-processing steps such as etching and additional layer deposition require the top and bottom coordinates of a layer. These are available as the Scheme variables `X0_<region>` and `X1_<region>`:

* `X0_<region>` is the x-coordinate of the top edge of the region.

* `X1_<region>` is the x-coordinate of the bottom edge of the region.

To investigate the layer stack creation in more detail and to evaluate the Scheme file step by step in Sentaurus Structure Editor, you can save the used Scheme commands to a file. For example:

```
(sdeepi:scm "@epicsv@" "@episcm@")
```

Sentaurus™ Structure Editor User Guide <page_number>261</page_number>
S-2021.06

8: Creating Planar Layer Stacks

References

# References

[1] *Simulation of 2D Single-Junction GaAs Solar Cell*, available from TCAD Sentaurus Version S-2021.06 installation, go to `Applications_Library/Solar/SolarCell_SingleJunct_GaAs`.

<page_number>

262
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

