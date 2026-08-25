# CHAPTER 40 Tcl Interfaces

*This chapter discusses the Tcl interfaces that can be used to customize device simulations in Sentaurus Device.*

## Overview

You can use Tcl scripts to control various aspects of a Sentaurus Device simulation. Tcl scripts can be used in the following circumstances:

*   Use the Tcl interpreter to execute a command file (see Tcl Command File on page 165).

*   Tcl expressions are recognized in the context of enhanced spectrum control to compute optical generation (see Enhanced Spectrum Control on page 598).

*   Use a Tcl formula to add data to the current plot file (see Tcl Formulas on page 121).

*   The Tcl current plot interface (see Current Plot File on page 1458) represents an alternative to the current plot PMI described in Current Plot File on page 1404.

Mesh-based Tcl interfaces, such as the current plot interface, need access to Sentaurus Device mesh and data. This runtime support is described in Mesh-Based Runtime Support.

## Mesh-Based Runtime Support

The Tcl runtime environment is accessed through a Tcl pointer `tcl_cp_adr`:

```tcl
upvar #1 tcl_cp_adr tcl_cp_adr
```

When the Tcl pointer `tcl_cp_adr` to the runtime environment has been obtained, you can perform the following operations:

*   Read a parameter from the command file:

```tcl
$tcl_cp_adr InitParameter $name $defaultvalue
```

*   Read a string parameter from the command file:

```tcl
$tcl_cp_adr InitStringParameter $name $defaultvalue
```

*   Read the time in seconds during transient simulations:

```tcl
$tcl_cp_adr ReadTime
```

Mesh-Based Runtime Support

* Read the step size in seconds during transient simulations:

  `$tcl_cp_adr ReadTransientStepSize`

* Read the step type during transient simulations:

  `$tcl_cp_adr ReadTransientStepType`

  Returns either `$::PMI_UndefStepType`, `$::PMI_TR`, `$::PMI_BDF`, or `$::PMI_BE`.

* Read pointer to the Sentaurus Device mesh (see Device Mesh on page 1452):

  `set mesh [$tcl_cp_adr Mesh]`

* Read pointer to the Sentaurus Device data (see Device Data on page 1457):

  `set data [$tcl_cp_adr Data]`

# Device Mesh

Use a pointer to the Sentaurus Device mesh, like `set mesh [$tcl_cp_adr Mesh]`, for the following operations:

* Dimension of mesh:

  `$mesh dim`

* Read element ($i, j$) of reference coordinate system, where $0 \le i, j < \text{dim}$:

  `$mesh ref_coordinates $i $j`

* Number of vertices:

  `$mesh size_vertex`

* Number of element vertices:

  `$mesh size_element_vertex`

* Read pointer to vertex $i$:

  `set vertex [$mesh vertex $i]`

* Number of edges:

  `$mesh size_edge`

* Read pointer to edge $i$:

  `set edge [$mesh edge $i]`

* Number of elements:

  `$mesh size_element`

* Read pointer to element $i$:

  `set element [$mesh element $i]`

**40: Tcl Interfaces**

Mesh-Based Runtime Support

*   Number of regions:

```
$mesh size_region
```

*   Read pointer to region *i* :

```
set region [$mesh region $i]
```

*   Number of region interfaces:

```
$mesh size_regioninterface
```

*   Read pointer to region interface *i* :

```
set regioninterface [$mesh regioninterface $i]
```

# Vertex

Use a pointer to a vertex for the following operations:

*   Read index to access vertex data:

```
$vertex index
```

*   Read index to access element–vertex data:

```
$vertex element_vertex_index $element
```

*   Read coordinates:

```
$vertex coord $d
```

The value of *d* determines the component, 0 ≤ *d* < *dim* .

*   Determine whether this vertex has the same coordinates as vertex *v* :

```
$vertex equal_coord $v
```

*   Number of edges connected to this vertex:

```
$vertex size_edge
```

*   Read pointer to edge *i* :

```
set edge [$vertex edge $i]
```

*   Number of elements connected to this vertex:

```
$vertex size_element
```

*   Read pointer to element *i* :

```
set element [$vertex element $i]
```

*   Number of regions connected to this vertex:

```
$vertex size_region
```

*   Read pointer to region *i* :

```
set region [$vertex region $i]
```

Mesh-Based Runtime Support

*   Number of region interfaces connected to this vertex:

    ```tcl
    $vertex size_regioninterface
    ```

*   Read pointer to region interface *i*:

    ```tcl
    set regioninterface [$vertex regioninterface $i]
    ```

## Edge

Use a pointer to an edge for the following operations:

*   Read index to access edge data:

    ```tcl
    $edge index
    ```

*   Read pointer to first vertex of edge:

    ```tcl
    set vertex [$edge start]
    ```

*   Read pointer to second vertex of edge:

    ```tcl
    set vertex [$edge end]
    ```

*   Number of elements connected to this edge:

    ```tcl
    $edge size_element
    ```

*   Read pointer to element *i*:

    ```tcl
    set element [$edge element $i]
    ```

*   Number of regions containing edge:

    ```tcl
    $edge size_region
    ```

*   Read pointer to region *i*:

    ```tcl
    set region [$edge region $i]
    ```

## Element

Use a pointer to an element for the following operations:

*   Read index to access element data:

    ```tcl
    $element index
    ```

*   Read type of element:

    ```tcl
    $element type
    ```

    Returns one of the following values:

    ```tcl
    $::des_element_point
    $::des_element_line
    $::des_element_triangle
    $::des_element_rectangle
    ```

**40: Tcl Interfaces**

Mesh-Based Runtime Support

```tcl
$::des_element_tetrahedron
$::des_element_pyramid
$::des_element_prism
$::des_element_cuboid
$::des_element_tetrabrick
```

*   Number of vertices in element:

    `$element size_vertex`

*   Read pointer to vertex *i* :

    `set vertex [$element vertex $i]`

*   Number of edges connected to this element:

    `$element size_edge`

*   Read pointer to edge *i* :

    `set edge [$element edge $i]`

*   Read pointer to bulk region containing element:

    `set bulk [$element bulk]`

*   Start index for element–vertex data in element:

    `$element element_vertex_offset`

# Region

Use a pointer to a region for the following operations:

*   Read index:

    `$region index`

*   Read type of region:

    `$region type`

    Returns either `$::des_region_bulk` or `$::des_region_contact`.

*   Read name of region:

    `$region name`

*   Number of vertices in region:

    `$region size_vertex`

*   Read pointer to vertex *i* :

    `set vertex [$region vertex $i]`

Mesh-Based Runtime Support

*   Number of edges in region:

```
$region size_edge
```

*   Read pointer to edge *i* :

```
set edge [$region edge $i]
```

Use the following functions to convert a pointer to a region into a pointer to a bulk region or a contact:

```
set bulk [tcl_cp_region2bulk $region]
set contact [tcl_cp_region2contact $region]
```

A pointer to a bulk region supports the following additional operations:

*   Read material of region:

```
$bulk material
```

*   Number of elements in region:

```
$bulk size_element
```

*   Read pointer to element *i* :

```
set element [$bulk element $i]
```

*   Number of region interfaces in region:

```
$bulk size_regioninterface
```

*   Read pointer to region interface *i* :

```
set regioninterface [$bulk regioninterface $i]
```

## Region Interface

Use a pointer to a region interface for the following operations:

*   Read index:

```
$regioninterface index
```

*   Read pointer to first bulk region connected to region interface:

```
set bulk [$regioninterface bulk1]
```

*   Read pointer to second bulk region connected to region interface:

```
set bulk [$regioninterface bulk2]
```

*   Determine whether this region interface is a heterointerface:

```
$regioninterface is_heterointerface
```

*   Number of vertices in region interface:

```
$regioninterface size_vertex
```

**40: Tcl Interfaces**
Mesh-Based Runtime Support

* Read pointer to vertex $i$:

```tcl
set vertex [$regioninterface vertex $i]
```

* Read index to access data stored on region interface vertex $i$:

```tcl
$regioninterface index $i
```

# Device Data

Use a pointer to the Sentaurus Device data, like `set data [$tcl_cp_adr Data]`, for the following operations:

* Read pointer to box method coefficients (2D array, C++ data type `double**`):

```tcl
set coefficient [$data ReadCoefficient]
```

* Read pointer to box method measures (2D array, C++ data type `double**`):

```tcl
set measure [$data ReadMeasure]
```

* Read pointer to box method surface measures (2D array, C++ data type `double**`):

```tcl
set surfacemeasure [$data ReadSurfaceMeasure]
```

* Read pointer to scalar data (1D array, C++ data type `double*`):

```tcl
set scalar [$data ReadScalar $location $name]
```

* Read pointer to vector data (2D array, C++ data type `double**`):

```tcl
set vector [$data ReadVector $location $name]
```

* Write scalar data (1D array, C++ data type `double*`):

```tcl
$data WriteScalar $location $name $newvalue
```

* Read pointer to gradient (2D array, C++ data type `double**`):

```tcl
set gradient [$data ReadGradient $location $name]
```

* Read pointer to flux (1D array, C++ data type `double*`):

```tcl
set flux [$data ReadFlux $location $name]
```

* Electron distribution from SHE method:

```tcl
$data ReadeSHEDistribution $bulk $vertex $energy
```

* Hole distribution from SHE method:

```tcl
$data ReadhSHEDistribution $bulk $vertex $energy
```

* Electron density-of-states from SHE method:

```tcl
$data ReadeSHETotalDOS $bulk $energy
```

* Hole density-of-states from SHE method:

```tcl
$data ReadhSHETotalDOS $bulk $energy
```

Current Plot File

* Electron group velocity from SHE method:

```
$data ReadeSHETotalGSV $bulk $energy
```

* Hole group velocity from SHE method:

```
$data ReadhSHETotalGSV $bulk $energy
```

The following values are recognized for `$location`:

```
$::des_data_vertex
$::des_data_edge
$::des_data_element
$::des_data_rivertex
$::des_data_element_vertex
```

See Appendix F on page 1479 for the names of scalar and vector data.

## One-Dimensional Arrays

Use the following function to allocate a 1D array (C++ data type `double*`):

```
set v1 [tcl_cp_new_double $size]
```

Use the following function to read an element of a 1D array (C++ data type `double*`):

```
set value [tcl_cp_get_double $v1 $index]
```

Use the following function to write an element of a 1D array (C++ data type `double*`):

```
tcl_cp_set_double $v1 $index $value
```

Use the following function to deallocate a 1D array (C++ data type `double*`):

```
tcl_cp_delete_double $v1
```

## Two-Dimensional Arrays

Use the following function to read an element of a 2D array (C++ data type `double**`):

```
set value [tcl_cp_get_double2 $v2 $index1 $index2]
```

---

# Current Plot File

You can use the current plot Tcl interface to add new entries to the current plot file. It is functionally equivalent to the current plot PMI described in Current Plot File on page 1404.

40: Tcl Interfaces
Current Plot File

The required Tcl code must be specified through a `tcl` statement in the `CurrentPlot` section. For example:

```
CurrentPlot {
  Tcl (tcl = "source CurrentPlot.tcl" par1 = <value> par2 = <value>)
}
```

In this example, the Tcl code is stored in the file `CurrentPlot.tcl`. If necessary, you can specify the model parameters (`par1` and `par2`) as well.

# Tcl Functions

You must define Tcl functions for the following purposes:

*   `tcl_cp_constructor`: Constructor

*   `tcl_cp_destructor`: Destructor (optional)

*   `tcl_cp_Compute_Dataset_Names`: Compute a list of dataset names for the header of the current plot file

*   `tcl_cp_Compute_Function_Names`: Compute a list of function names for the header of the current plot file

*   `tcl_cp_Compute_Plot_Values`: Evaluate the current plot values

These Tcl procedures must implement the same functionality as the corresponding methods of the C++ class `PMI_CurrentPlot` (see Current Plot File on page 1404). The Tcl interpreter also has access to runtime support functions and the entire Sentaurus Device mesh and data fields (see Mesh-Based Runtime Support on page 1451).

## tcl_cp_constructor

The constructor is invoked once at the beginning of each Tcl current plot statement:

```
proc tcl_cp_constructor {} {
  upvar #1 tcl_cp_adr tcl_cp_adr
  ...
}
```

All the current plot Tcl procedures are executed in their own Tcl namespace. This ensures that multiple Tcl current plot statements can be active simultaneously, and they all operate in their own private namespace. Use the Tcl `upvar` command to access variables in this namespace.

Current Plot File

As explained in Mesh-Based Runtime Support on page 1451, the Tcl pointer `tcl_cp_adr` provides access to the Sentaurus Device mesh and data:

```tcl
set mesh [$tcl_cp_adr Mesh]
set data [$tcl_cp_adr Data]
```

The constructor also can be used to precompute data that will be needed later to evaluate the current plot values.

## tcl_cp_destructor

This optional procedure can be used to deallocate data structures, or to print statistical output:

```tcl
proc tcl_cp_destructor {} {
}
```

## tcl_cp_Compute_Dataset_Names

This procedure must return a Tcl list of dataset names. For example:

```tcl
proc tcl_cp_Compute_Dataset_Names {} {
  lappend result "channel eConductivity"
  return $result
}
```

Multiple dataset names are supported.

## tcl_cp_Compute_Function_Names

This procedure must return a Tcl list of function names. For example:

```tcl
proc tcl_cp_Compute_Function_Names {} {
  lappend result "Conductivity"
  return $result
}
```

The number of function names must be identical to the number of dataset names created by `tcl_cp_Compute_Dataset_Names`.

**40: Tcl Interfaces**
Current Plot File

# tcl_cp_Compute_Plot_Values

This procedure must return a Tcl list of current plot values. Use the access functions to the Sentaurus Device mesh and data (see Mesh-Based Runtime Support on page 1451) to compute these values:

```tcl
proc tcl_cp_Compute_Plot_Values {} {
  ...
  lappend result 0.0
  return $result
}
```

The number of result values must be identical to the number of dataset names created by `tcl_cp_Compute_Dataset_Names`.

---

# Example: Average Electron Conductivity

This example computes the average of the electron conductivity $\sigma_n = qn\mu_n$ in a region and is located in the directory `$STROOT/tcad/$STRELEASE/lib/sdevice/src/tcl_currentplot`:

```tcl
proc tcl_cp_constructor {} {
  # link to variables in enclosing namespace
  upvar #1 tcl_cp_adr tcl_cp_adr
  upvar #1 Conductivity_Region Conductivity_Region

  set Conductivity_Region \
    [$tcl_cp_adr InitStringParameter "Conductivity_Region" ""]
}

proc tcl_cp_destructor {} {
}

proc tcl_cp_Compute_Dataset_Names {} {
  upvar #1 Conductivity_Region Conductivity_Region
  lappend result "Tcl_Ave_$Conductivity_Region eConductivity"
  return $result
}

proc tcl_cp_Compute_Function_Names {} {
  lappend result "Conductivity"
  return $result
}

proc tcl_cp_Compute_Plot_Values {} {
  # link to variables in enclosing namespace
  upvar #1 tcl_cp_adr tcl_cp_adr
```

Current Plot File

```tcl
upvar #1 Conductivity_Region Conductivity_Region

set mesh [$tcl_cp_adr Mesh]
set data [$tcl_cp_adr Data]
set measure [$data ReadMeasure]

set q 1.602e-19
set eDensity [$data ReadScalar $::des_data_vertex "eDensity"]
set eMobility [$data ReadScalar $::des_data_vertex "eMobility"]

set sum 0.0
set sum_m 0.0

set size_region [$mesh size_region]
for {set ri 0} {$ri < $size_region} {incr ri} {
  set region [$mesh region $ri]
  if {[$region type] == $::des_region_bulk && \
         [$region name] == $Conductivity_Region} {
   set bulk [tcl_cp_region2bulk $region]
   set size_element [$bulk size_element]
   for {set ei 0} {$ei < $size_element} {incr ei} {
         set element [$bulk element $ei]
         set element_index [$element index]
         set size_vertex [$element size_vertex]
         for {set vi 0} {$vi < $size_vertex} {incr vi} {
            set vertex [$element vertex $vi]
            set vertex_index [$vertex index]

            set n [tcl_cp_get_double $eDensity $vertex_index]
            set mu [tcl_cp_get_double $eMobility $vertex_index]
            set value [expr "$q * $n * $mu"]

            set m [tcl_cp_get_double2 $measure $element_index $vi]
            set sum [expr "$sum + $m * $value"]
            set sum_m [expr "$sum_m + $m"]
         }
   }
  }
 }

 if {$sum_m == 0} {
  set average 0
 } else {
  set average [expr "$sum / $sum_m"]
 }

 lappend result $average
}
```

# Part IV Appendices

---

This part of the ** contains the following appendices:

Appendix A Mathematical Symbols

Appendix B Syntax

Appendix C File-Naming Conventions

Appendix D Command-Line Options

Appendix E Runtime Statistics

Appendix F Data Names and Plot Names

Appendix G Command File Overview

# APPENDIX A Mathematical Symbols

*This appendix contains notational conventions and a list of symbols used in the .*

They are listed alphabetically. Non-Latin characters are sorted according to their English translation.

/ Division, right binding: $a/bc = a/(bc)$

$\hat{a}$ Unit (3D) vector

$\vec{a}$ (3D) vector

$|a|$ Absolute value of a scalar

$|\vec{a}|$ Absolute value of a vector $a = |\vec{a}|$

$a^T$ Transpose of a vector or a matrix

$a^{-1}$ Inverse of function or matrix, reciprocal of a scalar

$\vec{a} \cdot \vec{b}$ Inner (dot) product

$\vec{a} \times \vec{b}$ Vector (cross) product

$\vec{a}\vec{b}$ Dyadic product: $(\vec{a}\vec{b})_{ij} = \vec{a}_i\vec{b}_j$

$\langle abc \bar{} \rangle$ Miller indices. $a$, $b$, and $c$ are digits; a bar over a digit indicates negation applied to that particular digit.

$\chi$ Electron affinity or thermal resistivity

$c_L$ Lattice heat capacity

e Base of natural logarithm

$\vec{E}$ Electric field

$E_{bgn}$ Bandgap narrowing

$E_C$ Conduction band energy

# A: Mathematical Symbols

*   *E<sub>F,n</sub>* Electron quasi-Fermi energy

*   *E<sub>F,p</sub>* Hole quasi-Fermi energy

*   *E<sub>g</sub>* Intrinsic band gap

*   *E<sub>g,eff</sub>* Effective band gap, *E<sub>g,eff</sub>* = *E<sub>g</sub>* – *E<sub>bgn</sub>*

*   *E<sub>V</sub>* Valence band energy

*   ε Absolute dielectric constant of a material

*   ε₀ Dielectric constant of vacuum

*   $\vec{F}$ Electric field

*   *F<sub>α</sub>* Integral of distribution function; for Fermi statistics, Fermi integral of order α

*   *G* Generation rate (does not include recombination)

*   γ<sub>n</sub> Degeneracy factor for electrons

*   γ<sub>p</sub> Degeneracy factor for holes

*   $\hbar$ Planck’s constant divided by 2π

*   *i* Imaginary unit, *i*² = –1

*   Im Imaginary part

*   $\vec{J_D}$ Displacement current density

*   $\vec{J_M}$ Current density in metals

*   $\vec{J_n}$ Electron current density

*   $\vec{J_p}$ Hole current density

*   *k* Boltzmann constant

*   κ<sub>L</sub> Lattice thermal conductivity

*   κ<sub>n</sub> Electron thermal conductivity

*   κ<sub>p</sub> Hole thermal conductivity

A: Mathematical Symbols

$\Lambda_n$ Electron quantum potential

$\Lambda_p$ Hole quantum potential

ln Natural logarithm

$m_0$ Free electron mass

$m_n$ Electron density-of-states mass

$m_p$ Hole density-of-states mass

$\mu_n$ Electron mobility

$\mu_p$ Hole mobility

$n$ Electron density

$\hat{n}$ Unit normal vector

$N_{A,0}$ Chemically active acceptor concentration

$N_A$ Ionized acceptor concentration

$N_C$ Conduction band density-of-states

$N_{D,0}$ Chemically active donor concentration

$N_D$ Ionized donor concentration

$n_i$ Intrinsic density (not accounting for bandgap narrowing)

$n_{i,eff}$ Effective intrinsic density (accounting for bandgap narrowing)

$N_i$ Ionized dopant concentration, $N_i = N_A + N_D$

$n_{se}$ Single exciton density

$N_{tot}$ Total doping concentration, $N_{tot} = N_{A,0} + N_{D,0}$

$N_V$ Valence band density-of-states

$p$ Hole density

$\vec{P}$ Polarization

$P_n$ Electron thermoelectric power

# A: Mathematical Symbols

| $P_p$ | Hole thermoelectric power |
| --- | --- |
| $\Phi_M$ | Metal Fermi potential |
| $\Phi_n$ | Electron quasi-Fermi potential |
| $\Phi_p$ | Hole quasi-Fermi potential |
| $\phi$ | Electrostatic potential |
| $q$ | Elementary charge |
| $r$ | Anisotropy factor |
| $R$ | Recombination rate (does not include generation) |
| $R_{net}$ | Net recombination rate, $R_{net} = R - G$ |
| Re | Real part |
| $\vec{S}_L$ | Lattice heat flux density |
| $\vec{S}_n$ | Electron heat flux density |
| $\vec{S}_p$ | Hole heat flux density |
| $T$ | Lattice temperature |
| $T_n$ | Electron temperature |
| $T_p$ | Hole temperature |
| $\tau_n$ | Electron lifetime |
| $\tau_p$ | Hole lifetime |
| $\Theta$ | Unit step function (0 for negative arguments, 1 for positive arguments) |
| $\vec{v}_n$ | Electron drift velocity |
| $\vec{v}_p$ | Hole drift velocity |
| $\vec{v}_{sat,n}$ | Electron saturation velocity |
| $\vec{v}_{sat,p}$ | Hole saturation velocity |

APPENDIX B

# Syntax

*The syntax of the command file of Sentaurus Device, and the basic syntactical and lexical conventions are described here.*

Sentaurus Device has a hierarchical input syntax. At the lowest level, `device`, `system`, and `solve` information is specified as well as the default and global parameters. Inside each `Device` section, the parameters specific to one device type can be specified.

Inside the `System` section, the real devices are specified or instantiated. Here, parameters can be given that are specific to one instantiation of a device. The command file is a collection of specifications used to establish the simulation environment with actions describing which equations must be solved and how they must be solved. The syntax of the command file contains several entry types. All basic command file entries adhere to the syntactical and lexical rules described in Table 188.

Table 188 Entry types in Sentaurus Device

| Entry type | Description |
| --- | --- |
| Keyword | These are the known names of the command file. They are case insensitive. Therefore, the following keywords are all equivalent: Quasistationary, QuasiStationary, and quasistationary. Most keywords can be abbreviated. This example can also be written as QuasiStat. |
| Integer | These are (possibly) signed decimal numbers. The following integers are valid: 123, -73492, 0. |
| Float | Floating-point numbers are compatible with the C language format for floating-point numbers. The following floating-point numbers are valid: 123, 123.0, 1.23e2, -1.23E2. |
| Vector | Vectors in real space are defined depending on the actual dimension as follows: • In three dimensions, a vector is specified by three floating-point numbers. • In two dimensions, a vector is specified by two floating-point numbers enclosed in parentheses. The floating-point numbers are separated by commas or whitespace. • In one dimension, one floating-point number without parentheses is sufficient. Valid vectors are (1,0,2), (1e-4,-1e-3), and 1. |
| String | Strings are delimited by quotation marks. They are compatible with the C language format for strings. The following strings are valid: "Vdd", "output/diode". |
| Identifier | These are used to name objects such as nodes, devices, or attributes. They are compatible with the C language format for identifiers. The following identifiers are valid: Vdd, diode, bjt_345. |
| Assignment | These are used to set values to keywords. Therefore, the following are valid assignments: Digits=4, Save="output/diode". |

| 1469

B: Syntax

Table 188 Entry types in Sentaurus Device (Continued)

| Entry type | Description |
| --- | --- |
| Signal | Signals are time dependent, piecewise, linear functions (not to be confused with UNIX signals) that are defined as inputs on the contacts of a device. They are specified as follows: (value0 at time0, value1 at time1, ...value_n at time_n). The following signal is valid: (0 at 0, 1 at 10.0e-9, 1 at 20.0e-9). |
| List | Lists are collections of keywords, assignments, and complex entries. They are delimited by "(...)" or "{...}". The following lists are valid: { Number=0 Voltage=0 Voltage=( 0 at 0, 0 at 2e-8 ) } { Method=Super Digits=6 Numerically } ( MinStep=1e-15 InitialStep=1e-10 Digits=3 ) |
| Structured entries | These are parameterized definitions or commands that can have the forms: `<keyword> {<keywords>}`, `<keyword> (<keywords>)`, or `<keyword> (<list>) {<list>}`. |

# APPENDIX C File-Naming Conventions

*This appendix describes the file-naming conventions for TCAD tools relevant to Sentaurus Device.*

## File Extensions

All strings that represent file names containing a dot (.) within their base name are taken literally. Otherwise, Sentaurus Device extends the given strings with the appropriate extension.

Sentaurus Device expands the extensions for output files by its tool extension `_des`, for example, the extension of a saved file is `_des.sav`.

During transient, quasistationary, and continuation simulations, the plot and save files are numbered by a global index.

Table 189 Summary of file extensions used in Sentaurus Device

| File | I/O | Extension |
| --- | --- | --- |
| Command | I | _des.cmd, .cmd |
| Log | O | _des.log |
| Parameter | I | .par |
| Geometry/Doping | I | .tdr |
| Lifetime | I | .tdr |
| Save | O | _des.sav |
| Load | I | _des.sav |
| Device Plot (grid-based) | O | _des.tdr |
| Current Plot | O | _des.plt |
| AC Extraction | O | _ac_des.plt |
| Montecarlo | I/O | Refer to the Sentaurus™ Device Monte Carlo User Guide for more information. |

# C: File-Naming Conventions

File Extensions

 # APPENDIX D Command-Line Options

*This appendix lists the most useful command-line options available in Sentaurus Device.*

## Starting Sentaurus Device

To start Sentaurus Device, enter:

`sdevice [<options>] [<commandfile>]`

Sentaurus Device appends automatically the corresponding extension to the given command file if necessary. If no command file is specified, Sentaurus Device reads from standard input.

## Command-Line Options

Sentaurus Device interprets the following options:

| -d | Prints debug information into the `debug` file. The information printed includes the numeric values of the Jacobian and RHS for each equation at each solution step. |
| --- | --- |
| -h | Lists these options and exits. |
| -i | Prints the initial solution in the `save` file, and print files specified in the `File` section of the command file, and exits without performing further computations. |
| -L | Writes the silicon model parameters into the file `silicon.par` and exits. |
| -L <commandfile> | Writes model parameter files for all the materials, material interfaces, and electrodes used in `<commandfile>` and exits. |
| -L:<Material> | Writes a model parameter file `<Material>.par` for the specified material and exits. |

# D: Command-Line Options

Command-Line Options

| -L:<Material>:<x> | Writes the model parameters for the given material and mole fraction into a file <Material>.par and exits. |
| --- | --- |
| -L:<Material>:<x>:<y> | Writes the model parameters for the given material and mole fractions into a file <Material>.par and exits. |
| -L:<Material>/<Material> | Writes a model parameter file <Material>%<Material>.par for the specified material interface and exits. |
| -L:All | Writes a separate model parameter file for all materials and exits. |
| -M <commandfile> | Writes a parameter file models-M.par for regions with computed mole fraction dependencies. |
| -n | Does not include Newton information in the log file. |
| -P | Writes the silicon model parameters into a file models.par and exits. This file can be modified and reloaded into Sentaurus Device to make customized changes to physical models and parameters. |
| -P <commandfile> | Writes the model parameters for the materials and interfaces used in <commandfile> into a file models.par and exits. |
| -P:<Material> | Writes the model parameters for the given material into a file models.par and exits. |
| -P:<Material>:<x> | Writes the model parameters for the given material and mole fraction into a file models.par and exits. |
| -P:<Material>:<x>:<y> | Writes the model parameters for the given material and mole fractions into a file models.par and exits. |
| -P:<Material>/<Material> | Writes the model parameters for the given material interface into a file models.par and exits. |
| -P:All | Writes the model parameters for all materials into a file models.par and exits. |
| -q | Quiet mode for output. |
| -r | When used with -L or -P, reads parameters from the material library to generate output. |

1474

**D: Command-Line Options**
Command-Line Options

| -S | Writes the SiC model parameters into a `models_SiC.par` file and exits. This file can be modified and reloaded into Sentaurus Device to make customized changes to physical models and parameters. |
| --- | --- |
| -v | Prints header with version number of Sentaurus Device. |
| --compiler-version | Prints the version of the C++ compiler that was used to compile Sentaurus Device. |
| --exit-on-failure | Terminates immediately after a failed solve command. |
| --field-names | Prints fields and their numeric indices for use in the PMI. |
| --max_threads <int> | Limits the maximum number of threads used by the solver and assembly process. |
| --parameter-names | Prints the names of the parameters from the parameter file that can be ramped. If a command file is also supplied, Sentaurus Device prints the parameters from the command file that can be ramped. |
| --tcl | Invokes the Tcl interpreter to evaluate the command file. |
| --threads <int> | Sets the number of solver and assembly threads. |
| --verbose | Prints additional diagnostic messages (alternatively, set the environment variable `SDEVICE_VERBOSITY` to high). |
| --xml | Creates an additional log file with XML tags. The file uses the extension `.xml`. |

# D: Command-Line Options

Command-Line Options

 # APPENDIX E Runtime Statistics

*This appendix presents information about obtaining runtime statistics from Sentaurus Device.*

## Generating Statistics

The command `sdevicestat` displays some statistics of a previous run of Sentaurus Device based on the information found in its `log` file. For example, the command:

```
sdevicestat test_des.log
```

generates the following statistics:

```
Total number of Newton iterations       : 8
Number of restarts                      : 0
Rhs-time                                : 9.19 % ( 38.80 s )
Jacobian-time                           : 1.43 % ( 6.05 s )
Solve-time                              : 88.76 % ( 374.70 s )
Overhead                                : 0.62 % ( 2.61 s )
Total CPU time (sum of above times)     : 422.16 s
```

The `sdevicestat` command recognizes whether the `WallClock` keyword has been specified in the `Math` section of the Sentaurus Device command file (see Parallelization on page 172). In this case, the same simulation on a dual processor machine produces the following output:

```
Total number of Newton iterations       : 8
Number of restarts                      : 0
Rhs-time                                : 8.57 % ( 20.68 s )
Jacobian-time                           : 1.96 % ( 4.73 s )
Solve-time                              : 88.33 % ( 213.07 s )
Overhead                                : 1.14 % ( 2.74 s )
Total wallclock time (sum of above times): 241.22 s
```

# E: Runtime Statistics

## Generating Statistics

 # APPENDIX F Data Names and Plot Names

*This appendix provides information about data and plot names.*

## Overview

Table 190 on page 1480, Table 191 on page 1502, Table 192 on page 1505, and Table 193 on page 1505 list the data names as they appear in the TDR and PLT files, and that are available in the current plot PMI (see Current Plot File on page 1404).

The plot names that are recognized in a `Plot` or `CurrentPlot` section of Sentaurus Device are identical to the data names if not mentioned otherwise (see Device Plots on page 128).

Vector data can be plotted by appending `/Vector` to the corresponding keyword. For example:

```
Plot { ElectricField/Vector }
```

Element-based scalar data can be plotted by appending `/Element` to the corresponding keyword. For example:

```
Plot { eMobility/Element }
```

Special vector data can be plotted by appending `/SpecialVector` to the corresponding keyword. For example:

```
Plot { eSHEDistribution/SpecialVector }
```

Tensor data can be plotted by appending `/Tensor` to the corresponding keyword. For example:

```
Plot { Stress/Tensor }
```

**NOTE** The location *rivertex* refers to region-interface vertices.

For the kinetic Monte Carlo metal–insulator–metal (MIM) transport capability, Table 194 on page 1505 lists the plot name that is recognized in the `Plot` section of a Sentaurus Device command file for saving particle data related to MIM defects.

F: Data Names and Plot Names
Scalar Data

# Scalar Data

Table 190 Scalar data

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| AbsorbedPhotonDensity | vertex | Quantum Yield Models on page 603 | cm–3 s–1 |
| AbsorbedPhotonDensityCoherent (Plot name: AbsorbedPhotonDensity) | vertex | Transfer Matrix Method on page 680 | cm–3 s–1 |
| AbsorbedPhotonDensityFromMonochromaticSource (Plot name: AbsorbedPhotonDensity) | vertex | Quantum Yield Models on page 603 | cm–3 s–1 |
| AbsorbedPhotonDensityFromSpectrum (Plot name: AbsorbedPhotonDensity) | vertex | Quantum Yield Models on page 603 | cm–3 s–1 |
| AbsorbedPhotonDensityIncoherent (Plot name: AbsorbedPhotonDensity) | vertex | Transfer Matrix Method on page 680 | cm–3 s–1 |
| AccepMinusConcentration | vertex | Specifying Doping Species on page 12 | cm–3 |
| AcceptorConcentration | vertex |  | cm–3 |
| ActiveDopingConcentration | vertex | Specifying Doping Species on page 12, Using the Incomplete Ionization Model on page 293 | cm–3 |
| AlphaChargeDensity | vertex | Carrier Generation by Alpha Particles on page 720 | cm–3 |
| AlphaGeneration | vertex | $G^{Alpha}$, Eq. 762, p. 721 | cm–3 s–1 |
| AntimonyActiveConcentration | vertex | Specifying Doping Species on page 12 | cm–3 |
| AntimonyConcentration | vertex | Sb, Specifying Doping Species on page 12 | cm–3 |
| AntimonyPlusConcentration | vertex | Sb+, Chapter 13 | cm–3 |
| ArsenicActiveConcentration | vertex | Specifying Doping Species on page 12 | cm–3 |
| ArsenicConcentration | vertex | As, Specifying Doping Species on page 12 | cm–3 |
| ArsenicPlusConcentration | vertex | As+, Chapter 13 | cm–3 |
| AugerRecombination | vertex | $R^A$, Eq. 430, p. 435 | cm–3 s–1 |
| AutoOrientationSmoothing | vertex | Auto-Orientation Framework on page 38 | 1 |
| AvalFlatElementMax | element | Using Avalanche Generation on page 441 | degree |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| AvalFlatElementMin | element | Using Avalanche Generation on page 441 | degree |
| Band2BandGeneration | vertex | $G_{net}^{bb}$, Band-to-Band Tunneling Models on page 469 | cm–3 s–1 |
| BandGap | vertex | $E_g$, Bandgap and Electron-Affinity Models on page 260 | eV |
| BandgapNarrowing | vertex | $E_{bgn}$, Bandgap and Electron-Affinity Models on page 260 | eV |
| BM_AngleVertex | vertex | Statistics About Non-Delaunay Elements on page 1144 | degree |
| BM_EdgesPerVertex | vertex | 1 |  |
| BM_ElementsPerVertex | vertex | 1 |  |
| BM_ShortestEdge | vertex | μm |  |
| BM_AngleElements | element | degree |  |
| BM_CoeffIntersectionNonDelaunayElements | element | 1 |  |
| BM_ElementsWithCommonObtuseFace | element | 1 |  |
| BM_ElementsWithObtuseFaceOnBoundaryDevice | element | Statistics About Non-Delaunay Elements on page 1144 | 1 |
| BM_ElementVolume | element | μm3 |  |
| BM_IntersectionNonDelaunayElements | element | μm |  |
| BM_VolumeIntersectionNonDelaunayElements | element | μm3 |  |
| BM_wCoeffIntersectionNonDelaunayElements | element | 1 |  |
| BM_wElementsWithCommonObtuseFace | element | 1 |  |
| BM_wElementsWithObtuseFaceOnBoundaryDevice | element | 1 |  |
| BM_wIntersectionNonDelaunayElements | element | μm |  |
| BM_wVolumeIntersectionNonDelaunayElements | element | μm3 |  |
| BoronActiveConcentration | vertex | Specifying Doping Species on page 12 | cm–3 |
| BoronConcentration | vertex | B, Specifying Doping Species on page 12 | cm–3 |
| BoronMinusConcentration | vertex | B–, Chapter 13 | cm–3 |
| BuiltinPotential | vertex | φ0, Eq. 101, p. 212 | V |
| CBBarrierLowering | vertex | Conduction band barrier lowering | eV |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| CBEnergywithLowering | vertex | Conduction band energy modified by barrier lowering | eV |
| CDL1Recombination | vertex | $R_1$, Coupled Defect Level Recombination on page 433 | cm-3 s-1 |
| CDL2Recombination | vertex | $R_2$, Coupled Defect Level Recombination on page 433 | cm-3 s-1 |
| CDLcRecombination | vertex | $R - R_1 - R_2$, Coupled Defect Level Recombination on page 433 | cm-3 s-1 |
| CDLRecombination | vertex | $R$, Coupled Defect Level Recombination on page 433 | cm-3 s-1 |
| ConductionBandEnergy | vertex, element- vertex | $E_C$, Eq. 41, p. 182 | eV |
| ConductionCurrentDensity | vertex | $\vec{J_n} + \vec{J_p}$, Eq. 57, p. 189 or $\|J_M\|$ in metals, Eq. 142, p. 249 | Acm-2 |
| ConversePiezoelectricFieldXX | vertex | Components of converse piezoelectric field tensor | 1 |
| ConversePiezoelectricFieldXY |  |  |  |
| ConversePiezoelectricFieldXZ |  |  |  |
| ConversePiezoelectricFieldYY |  |  |  |
| ConversePiezoelectricFieldYZ |  |  |  |
| ConversePiezoelectricFieldZZ |  |  |  |
| cplxExtCoeff (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| cplxRefIndex (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| CurECImACGreenFunction | vertex | Table 137 on page 764 | 1 |
| CurECReACGreenFunction | vertex | Table 137 on page 764 | 1 |
| CurETImACGreenFunction | vertex | Table 137 on page 764 | V-1 |
| CurETReACGreenFunction | vertex | Table 137 on page 764 | V-1 |
| CurGeoGreenFunction | vertex | Table 137 on page 764 | Acm-3 |
| CurHCImACGreenFunction | vertex | Table 137 on page 764 | 1 |
| CurHCReACGreenFunction | vertex | Table 137 on page 764 | 1 |
| CurHTImACGreenFunction | vertex | Table 137 on page 764 | V-1 |

F: Data Names and Plot Names

Scalar Data

## Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| CurHTReACGreenFunction | vertex | Table 137 on page 764 | V-1 |
| CurLTImACGreenFunction | vertex | Table 137 on page 764 | V-1 |
| CurLTReACGreenFunction | vertex | Table 137 on page 764 | V-1 |
| CurPotImACGreenFunction | vertex | Table 137 on page 764 | s-1 |
| CurPotReACGreenFunction | vertex | Table 137 on page 764 | s-1 |
| CurrentPotential | vertex | W , Current Potential on page 193 | Acm-1 |
| d_k_carr (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| d_k_lambda (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| d_n_carr (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| d_n_gain (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| d_n_lambda (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| d_n_temp (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| DeepLevels | vertex | Energetic and Spatial Distribution of Traps on page 490 | cm-3 |
| DelVorWeight | vertex | Weighted Voronoï Diagram on page 1142 | μm2 |
| DielectricConstant | vertex, element | ε , Eq. 37, p. 179 | 1 |
| DielectricConstantAniso | vertex, element | εaniso , Anisotropic Electrical Permittivity on page 850 | 1 |
| DisplacementCurrentDensity | vertex | $\vec{J_D}$ | Acm-2 |
| DonorConcentration | vertex | Specifying Doping Species on page 12 | cm-3 |
| DonorPlusConcentration | vertex | cm-3 |  |
| DopingConcentration | vertex |  | cm-3 |
| DopingWells | vertex | Indices of doping wells, Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells on page 184 | 1 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| eAlphaAvalanche | vertex | $$ \alpha_n $$, Eq. 443, p. 441 | cm–1 |
| eAugerRecombination | vertex | $$ R_n^A $$, Eq. 430, p. 435 | cm–3 s–1 |
| eBand2BandGeneration | vertex | Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475 | cm–3 s–1 |
| eBarrierTunneling | vertex | Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774 | cm–3 s–1 |
| eCDL1Lifetime | vertex | $$ \tau_{n1} $$, Coupled Defect Level Recombination on page 433 | s |
| eCDL2Lifetime | vertex | $$ \tau_{n2} $$, Coupled Defect Level Recombination on page 433 | s |
| eColHeat | vertex | $$ dW_n / dt \|_{coll} $$, Eq. 76, p. 204 | Wcm–3 |
| eCoulomb2DMobility | element | Chapter 15, p. 341 | cm2 V–1 s–1 |
| eCoulomb3DMobility | element | Chapter 15, p. 341 | cm2 V–1 s–1 |
| eCoulombMobility | element | Chapter 15, p. 341 | cm2 V–1 s–1 |
| eCurrentDensity | vertex | $$ \vec{J}_n $$, Eq. 57, p. 189 | Acm–2 |
| eDeformationPotential | vertex | Using Deformation Potential Model on page 893 | eV |
| eDensity | vertex | $$ n $$, Eq. 57, p. 189 | cm–3 |
| eDifferentialGain | vertex | Stimulated and Spontaneous Emission Coefficients on page 1028 | cm2 |
| eDiffusivityMobility | vertex | $$ \mu_{n, \text{diff}} $$ Non-Einstein Diffusivity on page 401 | cm2 V–1 s–1 |
| eDopingDependentMobility | element | Chapter 15, p. 341 | cm2 V–1 s–1 |
| eDriftVelocity | vertex | Electron drift velocity | cm s–1 |
| eeDiffusionLNS | vertex | Table 137 on page 764 | C2 s–1 cm–1 |
| eEffectiveField | vertex | $$ E_n^{\text{eff}} $$, Eq. 471, p. 455 | Vcm–1 |
| eEffectiveStateDensity | vertex | $$ N_C $$, Effective Masses and Effective Density-of-States on page 272 | cm–3 |
| eEffectiveStress | vertex | Effective Stress on page 940 | MPa |
| eeFlickerGRLNS | vertex | Table 137 on page 764 | C2 s–1 cm–1 |
| eeMonopolarGRLNS | vertex | Table 137 on page 764 | C2 s–1 cm–1 |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| eEnormal | vertex | $F_{\perp}$, Eq. 333, p. 380 or $F_{n, \perp}$, Eq. 334, p. 381 | Vcm–1 |
| eEparallel | vertex | $F_n$, Eq. 355, p. 395 | Vcm–1 |
| eEquilibriumDensity | vertex | $n$, Eq. 57, p. 189 at zero applied voltages (zero currents) | cm–3 |
| EffectiveBandGap | vertex | $E_g - E_{bgn}$, Bandgap and Electron-Affinity Models on page 260 | eV |
| EffectiveIntrinsicDensity | vertex | $n_{i, \text{eff}}$, Eq. 152, p. 259 | cm–3 |
| eGapStatesRecombination | vertex | Chapter 17 | cm–3 s–1 |
| eGradQuasiFermi | vertex | $\|\nabla \Phi_n\|$, Eq. 357, p. 396 | Vcm–1 |
| eHeatFlux | vertex | $\|\vec{S}_n\|$, Eq. 79, p. 204 | Wcm–2 |
| eImpactIonization | vertex | $G_n$, Eq. 443, p. 441 | cm–3 s–1 |
| eInterfaceTrapConcentration | vertex | Chapter 17 | cm–2 |
| eInterfaceTrappedCharge | vertex | Chapter 17 | cm–2 |
| eIonIntegral | vertex | Approximate Breakdown Analysis on page 457 | 1 |
| eJEheat | vertex | $\vec{j}_n \cdot \nabla E_C / q$, Eq. 76, p. 204 | Wcm–3 |
| eJouleHeat | vertex | Table 28 on page 202 | Wcm–3 |
| ElectricField | vertex, element | $F$ | Vcm–1 |
| ElectronAffinity | vertex | $\chi$, Bandgap and Electron-Affinity Models on page 260 | eV |
| ElectrostaticPotential | vertex | $\phi$, Eq. 37, p. 179 | V |
| eLifetime | vertex | $\tau_n$, Eq. 386, p. 419 | s |
| eMLDAQuantumPotential | vertex | Modified Local-Density Approximation Model on page 324 | eV |
| eMobility | vertex, element | $\mu_n$, Chapter 15 | cm2V–1s–1 |
| eMobilityAniso | vertex, element | $\mu_n^{\text{aniso}}$, Anisotropic Mobility on page 842 | cm2V–1s–1 |
| eMobilityAnisoFactor | vertex | $r_e$, Eq. 906, p. 842 | 1 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| eMobilityStressFactorXX | vertex | Returns a component of the mobility stress factor tensor, see Using Piezoresistance Mobility Model on page 929 | 1 |
| eMobilityStressFactorXY | vertex | 1 |  |
| eMobilityStressFactorXZ | vertex | 1 |  |
| eMobilityStressFactorYY | vertex | 1 |  |
| eMobilityStressFactorYZ | vertex | 1 |  |
| eMobilityStressFactorZZ | vertex | 1 |  |
| eMVQMBandgapShift | vertex | Modified Local-Density Approximation Model on page 324 | eV |
| eNLLTunnelingPeltierHeat | vertex | Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774 | Wcm–3 |
| ePhonon2DMobility | element | Chapter 15, p. 341 | cm2V–1s–1 |
| ePhonon3DMobility | element | Chapter 15, p. 341 | cm2V–1s–1 |
| ePhononMobility | element | Chapter 15, p. 341 | cm2V–1s–1 |
| eQDDGamma | vertex | γ for electrons, Density Gradient Model on page 316 | 1 |
| eQuantumPotential | vertex | Λn, Eq. 221, p. 303 | eV |
| eQuasiFermiEnergy | vertex | EF,n, Quasi-Fermi Potential With Boltzmann Statistics on page 181 | eV |
| eQuasiFermiPotential | vertex | Φn, Quasi-Fermi Potential With Boltzmann Statistics on page 181 | V |
| EquilibriumPotential | vertex | φ, Eq. 37, p. 179 at zero applied voltages (zero currents) | V |
| eRecGenHeat | vertex | Hn, Eq. 90, p. 205 | Wcm–3 |
| eRelativeEffectiveMass | vertex | mn, Effective Masses and Effective Density-of-States on page 272 | 1 |
| eSaturationVelocity | vertex | vsat,n, Velocity Saturation Models on page 394 | cm s–1 |
| eSaturationVelocityAniso | vertex | vsat,naniso, Anisotropic Mobility on page 842 | cm s–1 |
| eSchenkBGN | vertex | –Λn, Eq. 221, p. 303 | eV |
| eSchenkTunnel | vertex | Direct Tunneling on page 770 | Acm–2 |
| eSHEAvalancheGeneration | vertex | Gn, SHEii, Spherical Harmonics Expansion Method on page 802 | cm–3s–1 |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| eSHECurrentDensity | vertex | $\vec{J}_{n, \text{ SHE}}$, Spherical Harmonics Expansion Method on page 802 | Acm−2 |
| eSHEDensity | vertex | $n_{\text{SHE}}$, Spherical Harmonics Expansion Method on page 802 | cm−3 |
| eSHEEnergy | vertex | $T_{n, \text{ SHE}}$, Spherical Harmonics Expansion Method on page 802 | K |
| eSHEVelocity | vertex | $\|\vec{v}_{n, \text{ SHE}}\|$, Spherical Harmonics Expansion Method on page 802 | cm s−1 |
| eSRHRecombination | vertex | Dynamic Nonlocal Path Trap-Assisted Tunneling on page 428 | cm−3 s−1 |
| eSurfRoughnessMobility | element | Chapter 15 | cm2V−1s−1 |
| eTBulkPhononMobility | element | Chapter 15 | cm2V−1s−1 |
| eTemperature | vertex | $T_n$, Hydrodynamic Model for Temperatures on page 204 | K |
| eTemperatureRelaxationTime | vertex | $\tau_{e_n}$, Eq. 87, p. 205 | s |
| eTensorMobilityFactorXX | vertex | Chapter 31 | 1 |
| eTensorMobilityFactorYY | vertex | Chapter 31 | 1 |
| eTensorMobilityFactorZZ | vertex | Chapter 31 | 1 |
| eTensorMobilityXX | vertex | Chapter 31 | cm2/(Vs) |
| eTensorMobilityYY | vertex | Chapter 31 | cm2/(Vs) |
| eTensorMobilityZZ | vertex | Chapter 31 | cm2/(Vs) |
| eTFluctuationMobility | element | Chapter 15 | cm2V−1s−1 |
| eThermoElectricPower | vertex | $P_n$, Eq. 1112, p. 982 | V K−1 |
| eTrapConcentration | vertex | Chapter 17 | cm−3 |
| eTrappedCharge | vertex | Chapter 17 | cm−3 |
| eTSurfacePhononMobility | element | Chapter 15 | cm2V−1s−1 |
| eVelocity | vertex | $v_n = \|\vec{J}_n/nq\|$ | cm s−1 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| f1BandOccupancy001 | vertex | Using Intel Mobility Model on page 925 | 1 |
| f1BandOccupancy010 | vertex |  |  |
| f1BandOccupancy100 | vertex |  |  |
| f2BandOccupancy001 | vertex |  |  |
| f2BandOccupancy010 | vertex |  |  |
| f2BandOccupancy100 | vertex |  |  |
| FowlerNordheim | vertex | $j_{FN}$, Eq. 791, p. 769 | Acm-2 |
| Grad2PoECACGreenFunction | vertex | Table 137 on page 764 | V2s2C-2cm-2 |
| Grad2PoHCACGreenFunction | vertex | Table 137 on page 764 | V2s2C-2cm-2 |
| hAlphaAvalanche | vertex | $\alpha_p$, Eq. 443, p. 441 | cm-1 |
| hAugerRecombination | vertex | $R_p^A$, Eq. 430, p. 435 | cm-3s-1 |
| hBand2BandGeneration | vertex | Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475 | cm-3s-1 |
| hBarrierTunneling | vertex | Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774 | cm-3s-1 |
| hCDL1Lifetime | vertex | $\tau_{p1}$, Coupled Defect Level Recombination on page 433 | s |
| hCDL2Lifetime | vertex | $\tau_{p2}$, Coupled Defect Level Recombination on page 433 | s |
| hColHeat | vertex | $dW_p/dt\|_{coll}$, Eq. 77, p. 204 | Wcm-3 |
| hCoulomb2DMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hCoulomb3DMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hCoulombMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hCurrentDensity | vertex | $\vec{J_p}$, Eq. 57, p. 189 | Acm-2 |
| hDeformationPotential | vertex | Using Deformation Potential Model on page 893 | eV |
| hDensity | vertex | $p$, Eq. 57, p. 189 | cm-3 |
| hDifferentialGain | vertex | Stimulated and Spontaneous Emission Coefficients on page 1028 | cm2 |
| hDiffusivityMobility | vertex | $\mu_{p, diff}$, Non-Einstein Diffusivity on page 401 | cm2V-1s-1 |
| hDopingDependentMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| hDriftVelocity | vertex | Hole drift velocity | cm s-1 |
| HeavyIonChargeDensity | vertex | Carrier Generation by Heavy Ions on page 722 | cm-3 |
| HeavyIonGeneration | vertex | $G^{\text{HeavyIon}}$, Eq. 767, p. 723 | cm-3 s-1 |
| hEffectiveField | vertex | $E_{p}^{\text{eff}}$, Eq. 472, p. 456 | Vcm-1 |
| hEffectiveStateDensity | vertex | $N_{V}$, Effective Masses and Effective Density-of-States on page 272 | cm-3 |
| hEffectiveStress | vertex | Effective Stress on page 940 | MPa |
| heiTemperature | vertex | $T_{\text{hei}}$, hot-electron temperature, computed as postprocessing approach (Carrier TempPost), Chapter 25 | K |
| hEnormal | vertex | $F_{\perp}$, Eq. 333, p. 380 or $F_{p, \perp}$, Eq. 334, p. 381 | Vcm-1 |
| hEparallel | vertex | $F_{p}$, Eq. 355, p. 395 | Vcm-1 |
| hEquilibriumDensity | vertex | $p$, Eq. 57, p. 189 at zero applied voltages (zero currents) | cm-3 |
| hGapStatesRecombination | vertex | Chapter 17 | cm-3 s-1 |
| hGradQuasiFermi | vertex | $\|\nabla\Phi_{p}\|$, Eq. 357, p. 396 | Vcm-1 |
| hhDiffusionLNS | vertex | Table 137 on page 764 | C2s-1cm-1 |
| hHeatFlux | vertex | $\|\vec{S}_{p}\|$, Eq. 80, p. 204 | Wcm-2 |
| hhFlickerGRLNS | vertex | Table 137 on page 764 | C2s-1cm-1 |
| hhMonopolarGRLNS | vertex | Table 137 on page 764 | C2s-1cm-1 |
| HighFieldEntranceMask | vertex, element | High-Field Entrance Position and Time on page 466 | 1 |
| HighFieldEntranceTime | vertex, element | High-Field Entrance Position and Time on page 466 | 1 |
| HighFieldEntranceVertex | vertex, element | High-Field Entrance Position and Time on page 466 | 1 |
| hImpactIonization | vertex | $G_{p}$, Eq. 443, p. 441 | cm-3 s-1 |
| hInterfaceTrapConcentration | vertex | Chapter 17 | cm-2 |
| hInterfaceTrappedCharge | vertex | Chapter 17 | cm-2 |
| hIonIntegral | vertex | Approximate Breakdown Analysis on page 457 | 1 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| hJEHeat | vertex | $\vec{J}_p \cdot \nabla E_V / q$, Eq. 77, p. 204 | Wcm-3 |
| hJouleHeat | vertex | Table 28 on page 202 | Wcm-3 |
| hLifetime | vertex | $\tau_p$, Eq. 386, p. 419 | s |
| hMLDAQuantumPotential | vertex | Modified Local-Density Approximation Model on page 324 | eV |
| hMobility | vertex, element | $\mu_p$, Chapter 15 | cm2V-1s-1 |
| hMobilityAniso | vertex, element | $\mu_p^{aniso}$, Anisotropic Mobility on page 842 | cm2V-1s-1 |
| hMobilityAnisoFactor | vertex | $r_h$, Eq. 906, p. 842 | 1 |
| hMobilityStressFactorXX | vertex | Using Piezoresistance Mobility Model on page 929 | 1 |
| hMobilityStressFactorXY | vertex | 1 |  |
| hMobilityStressFactorXZ | vertex | 1 |  |
| hMobilityStressFactorYY | vertex | 1 |  |
| hMobilityStressFactorYZ | vertex | 1 |  |
| hMobilityStressFactorZZ | vertex | 1 |  |
| hMVQMBandgapShift | vertex | Modified Local-Density Approximation Model on page 324 | eV |
| hNLLTunnelingPeltierHeat | vertex | Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774 | Wcm-3 |
| HotElectronInj | vertex | Hot-electron current density $j_{he}$ at interface, Eq. 826, p. 798, Eq. 832, p. 800 | Acm-2 |
| HotHoleInj | vertex | Hot-hole current density $j_{hh}$ at interface, Eq. 826, p. 798, Eq. 832, p. 800 | Acm-2 |
| hPhonon2DMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hPhonon3DMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hPhononMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hQDDGamma | vertex | $\gamma$ for holes, Density Gradient Model on page 316 | 1 |
| hQuantumPotential | vertex | $\Lambda_p$, Eq. 221, p. 303 | eV |

1490

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| hQuasiFermiEnergy | vertex | $E_{F,p}$, Quasi-Fermi Potential With Boltzmann Statistics on page 181 | eV |
| hQuasiFermiPotential | vertex | $\Phi_p$, Quasi-Fermi Potential With Boltzmann Statistics on page 181 | V |
| hRecGenHeat | vertex | $H_p$, Eq. 91, p. 205 | Wcm-3 |
| hRelativeEffectiveMass | vertex | $m_p$, Effective Masses and Effective Density-of-States on page 272 | 1 |
| hSaturationVelocity | vertex | $v_{sat,p}$, Velocity Saturation Models on page 394 | cm s-1 |
| hSaturationVelocityAniso | vertex | $v_{sat,p}^{aniso}$, Anisotropic Mobility on page 842 | cm s-1 |
| hSchenkBGN | vertex | $-\Lambda_p$, Eq. 221, p. 303 | eV |
| hSchenkTunnel | vertex | Direct Tunneling on page 770 | Acm-2 |
| hSHEAvalancheGeneration | vertex | $G_{p, SHE}^{ii}$, Spherical Harmonics Expansion Method on page 802 | cm-3 s-1 |
| hSHECurrentDensity | vertex | $\vec{J}_{p, SHE}$, Spherical Harmonics Expansion Method on page 802 | Acm-2 |
| hSHEDensity | vertex | $p_{SHE}$, Spherical Harmonics Expansion Method on page 802 | cm-3 |
| hSHEEnergy | vertex | $T_{p, SHE}$, Spherical Harmonics Expansion Method on page 802 | K |
| hSHEVelocity | vertex | $\vec{v}_{p, SHE}$, Spherical Harmonics Expansion Method on page 802 | cm s-1 |
| hSRHRecombination | vertex | Dynamic Nonlocal Path Trap-Assisted Tunneling on page 428 | cm-3 s-1 |
| hSurfRoughnessMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hTBulkPhononMobility | element | Chapter 15, p. 341 | cm2V-1s-1 |
| hTemperature | vertex | $T_p$, Hydrodynamic Model for Temperatures on page 204 | K |
| hTemperatureRelaxationTime | vertex | $\tau_{ep}$, Eq. 88, p. 205 | s |
| hTensorMobilityFactorXX | vertex | Chapter 31 | 1 |
| hTensorMobilityFactorYY | vertex | Chapter 31 | 1 |
| hTensorMobilityFactorZZ | vertex | Chapter 31 | 1 |
| hTensorMobilityXX | vertex | Chapter 31 | cm2/(Vs) |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| hTensorMobilityYY | vertex | Chapter 31 | cm2/(Vs) |
| hTensorMobilityZZ | vertex | Chapter 31 | cm2/(Vs) |
| hTFluctuationMobility | element | Chapter 15 | cm2V-1s-1 |
| hThermoElectricPower | vertex | $P_p$, Eq. 1113, p. 982 | V K-1 |
| hTrapConcentration | vertex | Chapter 17 | cm-3 |
| hTrappedCharge | vertex | Chapter 17 | cm-3 |
| hTSurfacePhononMobility | element | Chapter 15 | cm2V-1s-1 |
| hVelocity | vertex | $v_p = \|\vec{J}_p / pq\|$ | cm s-1 |
| HydrogenAtom | vertex | MSC–Hydrogen Transport Degradation Model on page 555 | cm-3 |
| HydrogenIon | vertex | MSC–Hydrogen Transport Degradation Model on page 555 | cm-3 |
| HydrogenMolecule | vertex | MSC–Hydrogen Transport Degradation Model on page 555 | cm-3 |
| ImeDensityResponse | vertex | Im($\tilde{n}$), AC Response on page 1147 | cm-3V-1 |
| ImeeDiffusionLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImeeFlickerGRLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImeeLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImeeMonopolarGRLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImElectrostaticPotentialResponse | vertex | Im($\tilde{\phi}$), AC Response on page 1147 | 1 |
| ImeTemperatureResponse | vertex | Im($\tilde{T}_n$), AC Response on page 1147 | KV-1 |
| ImhDensityResponse | vertex | Im($\tilde{p}$), AC Response on page 1147 | cm-3V-1 |
| ImhhDiffusionLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImhhFlickerGRLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImhhLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImhhMonopolarGRLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ImhTemperatureResponse | vertex | Im($\tilde{T}_p$), AC Response on page 1147 | KV-1 |
| ImLatticeTemperatureResponse | vertex | Im($\tilde{T}$), AC Response on page 1147 | KV-1 |
| ImLNISD | vertex | Table 137 on page 764 | A2scm-3 |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| ImLNVXVSD | vertex | Table 137 on page 764 | V2 scm−3 |
| ImpactIonization | vertex | $G^{II}$, Eq. 443, p. 441 | cm−3s−1 |
| ImTrapLNISD | vertex | Table 137 on page 764 | A2 scm−3 |
| ImTrapLNVSD | vertex | Table 137 on page 764 | V2 scm−3 |
| IndiumActiveConcentration | vertex | Specifying Doping Species on page 12 | cm−3 |
| IndiumConcentration | vertex | In, Specifying Doping Species on page 12 | cm−3 |
| IndiumMinusConcentration | vertex | In−, Chapter 13 | cm−3 |
| InsulatorElectricField | vertex | Electric field $F$ on insulator. | Vcm−1 |
| InterfaceNBTICharge | vertex | Two-Stage NBTI Degradation Model on page 564 | cm−2 |
| InterfaceNBTIState1 | vertex | Two-Stage NBTI Degradation Model on page 564 | cm−2 |
| InterfaceNBTIState2 | vertex | Two-Stage NBTI Degradation Model on page 564 | cm−2 |
| InterfaceNBTIState3 | vertex | Two-Stage NBTI Degradation Model on page 564 | cm−2 |
| InterfaceNBTIState4 | vertex | Two-Stage NBTI Degradation Model on page 564 | cm−2 |
| InterfaceOrientation | vertex | Auto-Orientation Framework on page 38 | 1 |
| IntrinsicDensity | vertex | $n_i$, Eq. 151, p. 259 | cm−3 |
| IonizedDopingConcentration | vertex | Specifying Doping Species on page 12, Using the Incomplete Ionization Model on page 293 | cm−3 |
| JouleHeat | vertex | Table 28 on page 202 | Wcm−3 |
| k_0 (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |
| LatticeHeatCapacity | vertex | $c_L$, Heat Capacity on page 967 | JK−1cm−3 |
| LatticeTemperature | vertex | $T$, Chapter 9 | K |
| LayerThickness | vertex | Extracting Layer Thickness on page 333 | μm |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| LayerThicknessField | vertex | Extracting Layer Thickness on page 333 | μm |
| lColHeat | vertex | $dW_L/dt\|_{coll}$, Eq. 78, p. 204 | Wcm-3 |
| lHeatFlux | vertex | $\|\vec{S}_L\|$, Eq. 81, p. 204 | Wcm-2 |
| lRecGenHeat | vertex | $H_L$, Eq. 92, p. 205 | Wcm-3 |
| MeanIonIntegral | vertex | Approximate Breakdown Analysis on page 457 | 1 |
| MetalConductivity | vertex | σ, Transport in Metals on page 249 | Acm-1V-1 |
| MetalWorkfunction | vertex | Metal Workfunction on page 252 | eV |
| MIMCellPotential | vertex | Concentration Plots on page 1092 | V ??? |
| MIMChargeConc | vertex | Concentration Plots on page 1092 | cm-3 |
| MIMDefect1Conc | vertex | Concentration Plots on page 1092 | cm-3 |
| MIMDefect2Conc | vertex | Concentration Plots on page 1092 | cm-3 |
| MIMDefectConc | vertex | Concentration Plots on page 1092 | cm-3 |
| MIMElectronConc | vertex | Concentration Plots on page 1092 | cm-3 |
| MIMTemperaturePotential | vertex | Concentration Plots on page 1092 | V ??? |
| MobilityAcceptorConcentration | vertex | Mobility Doping File on page 411 or Add2TotalDoping(ChargedTraps), Specifying Doping Species on page 12 | cm-3 |
| MobilityDonorConcentration | vertex | Mobility Doping File on page 411 or Add2TotalDoping(ChargedTraps), Specifying Doping Species on page 12 | cm-3 |
| Mod_eGradQuasiFermi_ElectricField | vertex | $\|\nabla \tilde{\Phi}_n\|$, Interpolation of Driving Forces to Zero Field on page 398 | Vcm-1 |
| Mod_eQuasiFermi_ElectricField_Potential | vertex | $\tilde{\Phi}_n$, Interpolation of Driving Forces to Zero Field on page 398 | V |
| Mod_hGradQuasiFermi_ElectricField | vertex | $\|\nabla \tilde{\Phi}_p\|$, Interpolation of Driving Forces to Zero Field on page 398 | Vcm-1 |
| Mod_hQuasiFermi_ElectricField_Potential | vertex | $\tilde{\Phi}_p$, Interpolation of Driving Forces to Zero Field on page 398 | V |
| n_0 (Plot name: ComplexRefractiveIndex) | vertex | Complex Refractive Index Model on page 640 | 1 |

1494

F: Data Names and Plot Names

Scalar Data

# Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| `NDopantActiveConcentration` | vertex | Specifying Doping Species on page 12 | cm−3 |
| `NDopantConcentration` | vertex | NDopant, Specifying Doping Species on page 12 | cm−3 |
| `NDopantPlusConcentration` | vertex | NDopant+, Chapter 13 | cm−3 |
| `NearestInterfaceOrientation` | vertex | Auto-Orientation Framework on page 38 | 1 |
| `NegInterfaceCharge` | vertex | Mobility Degradation Components due to Coulomb Scattering on page 372 | cm−2 |
| `NitrogenActiveConcentration` | vertex | Specifying Doping Species on page 12 | cm−3 |
| `NitrogenConcentration` | vertex | N, Specifying Doping Species on page 12 | cm−3 |
| `NitrogenPlusConcentration` | vertex | N+, Chapter 13 | cm−3 |
| `OneOverDegradationTime` | vertex | Chapter 19 | s−1 |
| `OpticalAbsorptionHeat` | vertex | Optical Absorption Heat on page 605 | Wcm−3 |
| `OpticalAbsorptionHeat_Bandgap` (Plot name: `OpticalAbsorptionHeat`) | vertex | Optical Absorption Heat on page 605 | Wcm−3 |
| `OpticalAbsorptionHeat_Vacuum` (Plot name: `OpticalAbsorptionHeat`) | vertex | Optical Absorption Heat on page 605 | Wcm−3 |
| `OpticalField` | vertex | Plot optical intensity as well as real and imaginary parts of optical field | W/m−3 V/m |
| `OpticalGeneration` | vertex | $$G_0^{opt}$$, Eq. 738, p. 682 | cm−3 s−1 |
| `OpticalGenerationFromConstant` (Plot name: `OpticalGeneration`) | vertex | Specifying the Type of Optical Generation Computation on page 594 | cm−3 s−1 |
| `OpticalGenerationFromFile` (Plot name: `OpticalGeneration`) | vertex | Specifying the Type of Optical Generation Computation on page 594 | cm−3 s−1 |
| `OpticalGenerationFromMonochromaticSource` (Plot name: `OpticalGeneration`) | vertex | Specifying the Type of Optical Generation Computation on page 594 | cm−3 s−1 |
| `OpticalGenerationFromSpectrum` (Plot name: `OpticalGeneration`) | vertex | Specifying the Type of Optical Generation Computation on page 594 | cm−3 s−1 |
| `OpticalIntensity` | vertex | Solving the Optical Problem on page 613 | Wcm−2 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| OpticalIntensityCoherent (Plot name: OpticalIntensity) | vertex | Transfer Matrix Method on page 680 | Wcm-2 |
| OpticalIntensityIncoherent (Plot name: OpticalIntensity) | vertex | Transfer Matrix Method on page 680 | Wcm-2 |
| ParallelToInterfaceInBoundaryLayerActive | element | Field Correction Close to Interfaces on page 400 | 1 |
| PDopantActiveConcentration | vertex | Specifying Doping Species on page 12 | cm-3 |
| PDopantConcentration | vertex | PDopant, Specifying Doping Species on page 12 | cm-3 |
| PDopantMinusConcentration | vertex | PDopant-, Chapter 13 | cm-3 |
| PE_Charge | vertex | $q_{PE}$, Piezoelectric Datasets on page 955 | cm-3 |
| PeltierHeat | vertex | Table 28 on page 202 | Wcm-3 |
| PhosphorusActiveConcentration | vertex | Specifying Doping Species on page 12 | cm-3 |
| PhosphorusConcentration | vertex | P, Specifying Doping Species on page 12 | cm-3 |
| PhosphorusPlusConcentration | vertex | P+, Chapter 13 | cm-3 |
| PiezoCharge | vertex | $q_{PE}$, Piezoelectric Datasets on page 955 | cm-3 |
| PMIeNonLocalRecombination | vertex | $R_n^{PMI}$, Nonlocal Generation–Recombination on page 1232 | cm-3s-1 |
| PMIHeat | vertex | Heat Generation Rate on page 1303 | Wcm-3 |
| PMIhNonLocalRecombination | vertex | $R_p^{PMI}$, Nonlocal Generation–Recombination on page 1232 | cm-3s-1 |
| PMIRecombination | vertex | $R^{PMI}$, Generation–Recombination on page 1224 | cm-3s-1 |
| PMIUserField0 | vertex | Command File of Sentaurus Device on page 1187 | 1 |
| PMIUserField1 | vertex | 1 |  |
| ... | vertex | 1 |  |
| PMIUserField299 | vertex | 1 |  |
| PoECImACGreenFunction | vertex | Table 137 on page 764 | VsC-1 |

F: Data Names and Plot Names
Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| PoECReACGreenFunction | vertex | Table 137 on page 764 | VsC−1 |
| PoETImACGreenFunction | vertex | Table 137 on page 764 | A−1 |
| PoETReACGreenFunction | vertex | Table 137 on page 764 | A−1 |
| PoGeoGreenFunction | vertex | Table 137 on page 764 | Vcm−3 |
| PoHCImACGreenFunction | vertex | Table 137 on page 764 | VsC−1 |
| PoHCReACGreenFunction | vertex | Table 137 on page 764 | VsC−1 |
| PoHTImACGreenFunction | vertex | Table 137 on page 764 | A−1 |
| PoHTReACGreenFunction | vertex | Table 137 on page 764 | A−1 |
| PoLTImACGreenFunction | vertex | Table 137 on page 764 | A−1 |
| PoLTReACGreenFunction | vertex | Table 137 on page 764 | A−1 |
| PoPotImACGreenFunction | vertex | Table 137 on page 764 | VC−1 |
| PoPotReACGreenFunction | vertex | Table 137 on page 764 | VC−1 |
| Polarization | vertex | $\|\vec{P}\|$, Chapter 29 | Ccm−2 |
| PosInterfaceCharge | vertex | Mobility Degradation Components due to Coulomb Scattering on page 372 | cm−2 |
| QCEffectiveBandGap | vertex | $E_g - E_{bgn} - q(\Lambda_n + \Lambda_n)$ | eV |
| QCEffectiveIntrinsicDensity | vertex | $n_{i, \text{eff}}$ with corrections due to Fermi statistics and quantization effects | cm−3 |
| QuantumYield | vertex | $\eta_G$, Eq. 674, p. 604 | 1 |
| QuantumYieldEffectiveGenerationEnergy (Plot name: `QuantumYield`) | vertex | $E_g$, Eq. 676, p. 605 | eV |
| QuasiFermiPotential | vertex | $\Phi$, Eq. 130, p. 235 | V |
| QW_chEigenEnergy | vertex | Eigenenergies of the crystal-field split-hole bound states, Localized Quantum-Well Model on page 1044 | eV |
| QW_chNumberOfBoundStates | vertex | Actual number of QW bound states for crystal-field split-holes, Localized Quantum-Well Model on page 1044 | 1 |
| QW_chRelativeEffectiveMass | vertex | Relative effective mass of crystal- field split-holes, Localized Quantum- Well Model on page 1044 | 1 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| QW_chStrainBandShift | vertex | Shift in crystal-field split-hole band due to strain effects, Localized Quantum-Well Model on page 1044 | eV |
| QW_eEigenEnergy | vertex | Eigenenergies of the electron bound states, Localized Quantum-Well Model on page 1044 | eV |
| QW_ElectricFieldProjection | vertex | Electric field in the QW, Localized Quantum-Well Model on page 1044 | Vcm-1 |
| QW_eNumberOfBoundStates | vertex | Actual number of QW bound states for electrons, Localized Quantum-Well Model on page 1044 | 1 |
| QW_eRelativeEffectiveMass | vertex | Relative effective mass of electrons, Localized Quantum-Well Model on page 1044 | 1 |
| QW_eStrainBandShift | vertex | Shift in conduction band due to strain effects, Localized Quantum-Well Model on page 1044 | eV |
| QW_hhEigenEnergy | vertex | Eigenenergies of the heavy-hole bound states, Localized Quantum-Well Model on page 1044 | eV |
| QW_hhNumberOfBoundStates | vertex | Actual number of QW bound states for heavy holes, Localized Quantum-Well Model on page 1044 | 1 |
| QW_hhRelativeEffectiveMass | vertex | Relative effective mass of heavy holes, Localized Quantum-Well Model on page 1044 | 1 |
| QW_hhStrainBandShift | vertex | Shift in heavy-hole band due to strain effects, Localized Quantum-Well Model on page 1044 | eV |
| QW_lhEigenEnergy | vertex | Eigenenergies for the light-hole bound states, Localized Quantum-Well Model on page 1044 | eV |
| QW_lhNumberOfBoundStates | vertex | Actual number of QW bound states for light holes, Localized Quantum-Well Model on page 1044 | 1 |
| QW_lhRelativeEffectiveMass | vertex | Relative effective mass of light holes, Localized Quantum-Well Model on page 1044 | 1 |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| QW_lhStrainBandShift | vertex | Shift in light-hole band due to strain effects, Localized Quantum-Well Model on page 1044 | eV |
| QW_OverlapIntegral | vertex | Overlap integrals between electron and hole wavefunctions, Localized Quantum-Well Model on page 1044 | 1 |
| QW_QuantizationDirection | vertex | Quantization direction of the QW, Localized Quantum-Well Model on page 1044 | 1 |
| QW_Width | vertex | Extracted width of the QW, Localized Quantum-Well Model on page 1044 | μm |
| QWeDensity | vertex | $n$, Eq. 1192, p. 1040 | cm-3 |
| QWeQuasiFermi | vertex | $\Phi_n$, Quasi-Fermi Potential With Boltzmann Statistics on page 181 | V |
| QWhDensity | vertex | $p$, Eq. 1193, p. 1040 | cm-3 |
| QWhQuasiFermi | vertex | $\Phi_p$, Quasi-Fermi Potential With Boltzmann Statistics on page 181 | V |
| RadiationGeneration | vertex | $G_r$, Eq. 751, p. 700 | cm-3s-1 |
| RadiativeRecombination | vertex | $R$, Eq. 430, p. 435 | cm-3s-1 |
| RandomizedDoping | vertex | Statistical Impedance Field Method | cm-3 |
| RayTrees | vertex | Using the Raytracer on page 651 | 1 |
| RecombinationHeat | vertex | Table 28 on page 202 | Wcm-3 |
| ReeDensityResponse | vertex | Re($\tilde{n}$), AC Response on page 1147 | cm-3V-1 |
| ReeeDiffusionLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ReeeFlickerGRLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ReeeLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ReeeMonopolarGRLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |
| ReElectrostaticPotentialResponse | vertex | Re($\tilde{\phi}$), AC Response on page 1147 | 1 |
| ReeTemperatureResponse | vertex | Re($\tilde{T}_n$), AC Response on page 1147 | KV-1 |
| RefractiveIndex | vertex, element | $n$, Complex Refractive Index Model on page 640 | 1 |
| RehDensityResponse | vertex | Re($\tilde{p}$), AC Response on page 1147 | cm-3V-1 |
| RehhDiffusionLNVXVSD | vertex | Table 137 on page 764 | V2scm-3 |

# F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| RehhFlickerGRLNVXVSD | vertex | Table 137 on page 764 | V2scm–3 |
| RehhLNVXVSD | vertex | Table 137 on page 764 | V2scm–3 |
| RehhMonopolarGRLNVXVSD | vertex | Table 137 on page 764 | V2scm–3 |
| RehTemperatureResponse | vertex | Re($\tilde{T}_p$), AC Response on page 1147 | KV–1 |
| ReLatticeTemperatureResponse | vertex | Re($\tilde{T}$), AC Response on page 1147 | KV–1 |
| ReLNISD | vertex | Table 137 on page 764 | A2scm–3 |
| ReLNVXVSD | vertex | Table 137 on page 764 | V2scm–3 |
| ReTrapLNISD | vertex | Table 137 on page 764 | A2scm–3 |
| ReTrapLNVSD | vertex | Table 137 on page 764 | V2scm–3 |
| SemiconductorElectricField | vertex | Electric field $F$ on semiconductor | Vcm–1 |
| SpaceCharge | vertex | Eq. 37, p. 179 | cm–3 |
| SpontaneousRecombination | vertex | Spontaneous Recombination Rate on page 1031 | cm–3s–1 |
| srhRecombination | vertex | $R_{net}^{SRH}$, Shockley–Read–Hall Recombination on page 419 | cm–3s–1 |
| StimulatedRecombination | vertex | Stimulated Recombination Rate on page 1030 | cm–3s–1 |
| StrainedDOSeMassFactor | vertex | $\gamma_n^{2/3}$, Strained Electron Effective Mass and DOS on page 895 | 1 |
| StrainedDOShMassFactor | vertex | $\gamma_p^{2/3}$, Strained Hole Effective Mass and DOS on page 897 | 1 |
| Stress | vertex | Stress tensor, Chapter 31 | Pa |
| StressXX | vertex | Components of stress tensor, Chapter 31 | Pa |
| StressXY |  |  |  |
| StressXZ |  |  |  |
| StressYY |  |  |  |
| StressYZ |  |  |  |
| StressZZ |  |  |  |
| SurfaceRecombination | vertex | Surface SRH Recombination Model on page 432 | cm–2s–1 |
| ThermalConductivity | vertex | $\kappa$, Eq. 1079, p. 969 | Wcm–1K–1 |

F: Data Names and Plot Names

Scalar Data

Table 190 Scalar data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| ThermalConductivityAniso | vertex | $\kappa_{aniso}$ , Anisotropic Thermal Conductivity on page 851 | Wcm-1K-1 |
| ThermalizationYield_Bandgap (Plot name: ThermalizationYield) | vertex | Optical Absorption Heat on page 605 | 1 |
| ThermalizationYield_Vacuum (Plot name: ThermalizationYield) | vertex | Optical Absorption Heat on page 605 | 1 |
| ThomsonHeat | vertex | Table 28 on page 202 | Wcm-3 |
| TotalConcentration | vertex | Specifying Doping Species on page 12 | cm-3 |
| TotalCurrentDensity | vertex | $\|\vec{J_n} + \vec{J_p} + \vec{J_D}\|$ | Acm-2 |
| TotalHeat | vertex | Sum of all heat generation terms, Chapter 9, Temperature in Metals on page 254 | Wcm-3 |
| TotalInterfaceTrapConcentration | vertex | Chapter 17 | cm-2 |
| TotalRecombination | vertex | Sum of all generation– recombination terms, Chapter 16 | cm-3 s-1 |
| TotalTrapConcentration | vertex | Chapter 17 | cm-3 |
| TrapConcentration_\* (Plot name: TrapConcPerEntry, Current plot name: TrapConcentrationPerEntry) | vertex | Trap energy level concentrations and integrated trap concentration for each trap entry, Chapter 17 | cm-3 |
| TrapOccupation_\* (Plot name: TrapOccupationPerEntry, Current plot name: TrapOccupationPerEntry) | vertex | Trap energy level occupation for each trap entry, Chapter 17; automatically plotted in TDR file as long as `-PlotLoadable` is not present in Math section | 1 |
| tSRHRecombination | vertex | Dynamic Nonlocal Path Trap-Assisted Tunneling on page 428 | cm-3 s-1 |
| ValenceBandEnergy | vertex, element-vertex | $E_V$ , Eq. 42, p. 182 | eV |
| VBBarrierLowering | vertex | Valence band barrier lowering | eV |
| VBEnergywithLowering | vertex | Valence band energy modified by barrier lowering | eV |
| VertexIndex | vertex | Vertex numbers | 1 |
| xMoleFraction | vertex | Abrupt and Graded Heterojunctions on page 11 | 1 |
| yMoleFraction | vertex |  | 1 |

F: Data Names and Plot Names
Vector Data

# Vector Data

Table 191 Vector data

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| ConductionCurrentDensity | vertex | $\vec{J}_n + \vec{J}_p$, Eq. 57, p. 189 or $\vec{J}_M$ in metals, Eq. 142, p. 249 | Acm–2 |
| ContactSurfaceNormal | vertex | Contact surface normal | 1 |
| DisplacementCurrentDensity | vertex | $\vec{J}_D$ | Acm–2 |
| eCurrentDensity | vertex | $\vec{J}_n$, Eq. 57, p. 189 | Acm–2 |
| eDriftVelocity | vertex | Electron drift velocity. | cm s–1 |
| eGradQuasiFermi | vertex | $-\nabla\Phi_n$, Eq. 39, p. 181 | Vcm–1 |
| eHeatFlux | vertex | $\vec{S}_n$, Eq. 79, p. 204 | Wcm–2 |
| ElectricField | vertex, element | $\vec{F}$ | Vcm–1 |
| EquilibriumElectricField | vertex | $\vec{F}_{eq}$, Eq. 114, p. 219 | Vcm–1 |
| eSHECurrentDensity | vertex | $\vec{J}_{n, \text{SHE}}$, Spherical Harmonics Expansion Method on page 802 | Acm–2 |
| eSHEVelocity | vertex | $\vec{v}_{n, \text{SHE}}$, Spherical Harmonics Expansion Method on page 802 | cm s–1 |
| eVelocity | vertex | $\vec{v}_n = -\vec{J}_n / qn$ | cm s–1 |
| GradPoECImACGreenFunction | vertex | Table 137 on page 764 | VsC–1cm–1 |
| GradPoECReACGreenFunction | vertex | Table 137 on page 764 | VsC–1cm–1 |
| GradPoETImACGreenFunction | vertex | Table 137 on page 764 | A–1cm–1 |
| GradPoETReACGreenFunction | vertex | Table 137 on page 764 | A–1cm–1 |
| GradPoHCImACGreenFunction | vertex | Table 137 on page 764 | VsC–1cm–1 |
| GradPoHCReACGreenFunction | vertex | Table 137 on page 764 | VsC–1cm–1 |
| GradPoHTImACGreenFunction | vertex | Table 137 on page 764 | A–1cm–1 |
| GradPoHTReACGreenFunction | vertex | Table 137 on page 764 | A–1cm–1 |
| hCurrentDensity | vertex | $\vec{J}_p$, Eq. 57, p. 189 | Acm–2 |
| hDriftVelocity | vertex | Hole drift velocity | cm s–1 |
| hGradQuasiFermi | vertex | $-\nabla\Phi_p$, Eq. 357, p. 396 | Vcm–1 |
| hHeatFlux | vertex | $\vec{S}_p$, Eq. 80, p. 204 | Wcm–2 |

F: Data Names and Plot Names

Vector Data

Table 191 Vector data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| HighFieldEntrancePosition | vertex, element | High-Field Entrance Position and Time on page 466 | μm |
| hSHECurrentDensity | vertex | $\vec{J}_{p, \text{ SHE}}$, Spherical Harmonics Expansion Method on page 802 | Acm-2 |
| hSHEVelocity | vertex | $\vec{v}_{p, \text{ SHE}}$, Spherical Harmonics Expansion Method on page 802 | cm s-1 |
| hVelocity | vertex | $\vec{v}_p = \vec{J}_p / qp$ | cm s-1 |
| ImConductionCurrentResponse | vertex | $\text{Im}(\vec{\tilde{J}}_n + \vec{\tilde{J}}_p)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ImDisplacementCurrentResponse | vertex | $\text{Im}(\vec{\tilde{J}}_D)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ImeCurrentResponse | vertex | $\text{Im}(\vec{\tilde{J}}_n)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ImeEnFluxResponse | vertex | $\text{Im}(\vec{\tilde{S}}_n)$, AC Current Density Responses on page 1149 | Wcm-2V-1 |
| ImhCurrentResponse | vertex | $\text{Im}(\vec{\tilde{J}}_p)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ImhEnFluxResponse | vertex | $\text{Im}(\vec{\tilde{S}}_p)$, AC Current Density Responses on page 1149 | Wcm-2V-1 |
| ImlEnFluxResponse | vertex | $\text{Im}(\vec{\tilde{S}}_L)$, AC Current Density Responses on page 1149 | Wcm-2V-1 |
| ImTotalCurrentResponse | vertex | $\text{Im}(\vec{\tilde{J}}_n + \vec{\tilde{J}}_p + \vec{\tilde{J}}_D)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| InsulatorElectricField | vertex | Electric field $\vec{F}$ on insulator. | Vcm-1 |
| lHeatFlux | vertex | $\vec{S}_L$, Eq. 81, p. 204 | Wcm-2 |
| Mod_eGradQuasiFermi_ElectricField | vertex | $\nabla \tilde{\Phi}_n$, Interpolation of Driving Forces to Zero Field on page 398 | Vcm-1 |

# F: Data Names and Plot Names

Vector Data

Table 191 Vector data (Continued)

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| Mod_hGradQuasiFermi_ElectricField | vertex | $\nabla \tilde{\Phi}_p$, Interpolation of Driving Forces to Zero Field on page 398 | Vcm-1 |
| NonLocalBackDirection (Plot name: NonLocal) | vertex | Visualizing Nonlocal Meshes on page 154 | μm |
| NonLocalDirection (Plot name: NonLocal) | vertex |  | μm |
| OpticalField | vertex | Plot optical intensity as well as real and imaginary parts of optical field | W/m-3 V/m |
| PE_Polarization | vertex | $P_{PE}$, Piezoelectric Datasets on page 955 | Ccm-2 |
| Polarization | vertex, element | $\vec{P}$, Chapter 29 | Ccm-2 |
| ReConductionCurrentResponse | vertex | $\text{Re}(\vec{\tilde{J}}_n + \vec{\tilde{J}}_p)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ReDisplacementCurrentResponse | vertex | $\text{Re}(\vec{\tilde{J}}_D)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ReeCurrentResponse | vertex | $\text{Re}(\vec{\tilde{J}}_n)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| ReeEnFluxResponse | vertex | $\text{Re}(\vec{\tilde{S}}_n)$, AC Current Density Responses on page 1149 | Wcm-2V-1 |
| RehCurrentResponse | vertex | $\text{Re}(\vec{\tilde{J}}_p)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| RehEnFluxResponse | vertex | $\text{Re}(\vec{\tilde{S}}_n)$, AC Current Density Responses on page 1149 | Wcm-2V-1 |
| RelEnFluxResponse | vertex | $\text{Re}(\vec{\tilde{S}}_L)$, AC Current Density Responses on page 1149 | Wcm-2V-1 |
| ReTotalCurrentResponse | vertex | $\text{Re}(\vec{\tilde{J}}_n + \vec{\tilde{J}}_p + \vec{\tilde{J}}_D)$, AC Current Density Responses on page 1149 | Acm-2V-1 |
| SemiconductorElectricField | vertex | Electric field $\vec{F}$ on semiconductor | Vcm-1 |
| TotalCurrentDensity | vertex | $\vec{J}_n + \vec{J}_p + \vec{J}_D$ | Acm-2 |

F: Data Names and Plot Names
Special Vector Data

# Special Vector Data

Table 192 Special vector data

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| eSHEDistribution | vertex | Electron energy distribution, SHE Distribution Hot-Carrier Injection on page 801 | 1 |
| hSHEDistribution | vertex | Hole energy distribution, SHE Distribution Hot-Carrier Injection on page 801 | 1 |

# Tensor Data

Table 193 Tensor data

| Data name | Location | Description | Unit |
| --- | --- | --- | --- |
| ConversePiezoelectricField | vertex | Chapter 31 | 1 |
| ElasticStrain | vertex | Strain tensor from TDR file (Sentaurus Process or Sentaurus Interconnect), Strain Tensor on page 888 | 1 |
| Strain | vertex | Strain tensor $\bar{\varepsilon}$, Stress and Strain in Semiconductors on page 885 | 1 |
| Stress | vertex | Stress tensor $\bar{\sigma}$, Stress and Strain in Semiconductors on page 885 | Pa |

# Particle Data

Table 194 Particle data

| Plot name | Location | Description | Unit |
| --- | --- | --- | --- |
| MIMParticle | MIM defect locations | Particles representing MIM defects, Particle Plots on page 1093 | 1 |

# F: Data Names and Plot Names

## Particle Data

 APPENDIX G Command File Overview

*This appendix presents an overview of the command file of Sentaurus Device.*

Top Level of Command File on page 1509 presents the topmost level of the command file. Use this table to obtain a top-down overview of the command file. The remaining sections are ordered alphabetically. Headings of tables, therein, mostly start with a keyword. Use these tables to find details about keywords.

# Organization of Command File Overview

The tables in this appendix have two or three columns, and their rows are ordered alphabetically with respect to the first (and, as far as applicable, the middle) column. Placeholders (cross references, user-supplied values in angle brackets (<>)) precede explicit keywords, irrespective of alphabetic order.

The left column contains keywords that can appear in the command file. In the topmost rows of some tables, the left column references another table. This means that all keywords in the referenced table can appear in the referring table as well. Some keywords are followed by an opening parenthesis or an opening brace to indicate that the keyword expects a selection of options listed in the middle column of the current and the following rows.

The middle column contains options or values to the keyword in the left column, one per row. For a selection of options, the last row indicates the closing parenthesis or the closing brace. For some tables, the middle column would be empty and is omitted.

The right column contains the description of keywords, options, and values of the row. As far as applicable, the right column also provides the following additional information:

*   The default value, which can be:
    

    *   An explicit value. Those values are written in Courier font, as you would type them.
    

    *   + or – to indicate the default (true or false, respectively) for keywords that support the – prefix.
    

    *   *on* or *off* for keywords that set and reset flags, but do not support the – prefix.
    

    *   An asterisk (*) to indicate the default among mutually exclusive alternatives.
    

    *   An exclamation mark (!) if no default exists and you must specify a value.

**G: Command File Overview**

Organization of Command File Overview

*   The unit assumed for the given quantity. In unit specifications, *d* denotes the dimension of the mesh. For dimensionless quantities, no unit is specified.

*   The location for which keywords should be specified, given as characters in parentheses:

    *   (g) stands for global parameters that must not appear in region-specific, interface-specific, or contact-specific sections.

    *   (r) stands for region-specific (or material-specific) parameters that usually do not make sense when specified for interfaces or contacts.

    *   (c) and (i) stand for contact-specific or interface-specific parameters.

Furthermore, the tables use the following conventions:

*   An ellipsis (...) denotes that the preceding item can be repeated an arbitrary number of times.

*   An asterisk (*) followed by an integer, both typeset in Times font, denotes that the preceding item must appear the given number of times.

*   Optional components of specifications are enclosed in brackets, and the brackets are not part of the syntax.

*   Angle brackets (<>) indicate user-supplied values. Table 195 summarizes the common types of specification. More specific notation is explained in the last column of the table where it is used.

Some tables use additional conventions as necessary. They are explained in the text that precedes the respective table.

Table 195 Notation for user-supplied values

| Specification | Description |
| --- | --- |
| <(x,y)> <[x,y]> <(x,y]> <[x,y)> | Range of floating-point numbers from x to y. Parentheses are used when the limits are excluded from the range; brackets are used when they are included. To denote ranges unbound on one side, the corresponding limit is omitted. |
| <carrier> | A carrier type, Electron or Hole. |
| <float> | A floating-point number (integers are special cases thereof). |
| <ident> | An identifier. This is like a string, but is not enclosed in double quotation marks. |
| <int> | An integer. |
| <n..m> | A range of integers, from n to m, inclusively. Either n or m can be omitted, to denote ranges that are unbound on one side. |
| <string> | A sequence of characters (including digits and special characters) included in double quotation marks. Unlike most Sentaurus Device input, strings are case sensitive. |

# G: Command File Overview

Top Level of Command File

Table 195 Notation for user-supplied values (Continued)

| Specification | Description |
| --- | --- |
| <vector> | A sequence of up to three floating-point numbers, enclosed in parentheses, and separated by spaces. For example: (1.0 3 0) |
| <System_Coord> | CrystalSystem or SimulationSystem. |

# Top Level of Command File

Table 196 lists the top level in the command file of Sentaurus Device.

Table 196 Top level of command file

| Table 200 |  | Specification for single devices. |
| --- | --- | --- |
| Device | <string> {Table 200} | Device name and device specifications (mixed mode). Device Section on page 60 |
| OpticalDevice | <string> {Table 200} | Optical device name and device specification (mixed mode and Composite Method on page 711). Device Section on page 60 |
| Solve{ | Table 331} | The problem to be solved. |
| System{ | Table 349} | The circuit (mixed mode). System Section on page 54 |

# CurrentPlot

Table 197 CurrentPlot{} Tracking Additional Data in the Current File on page 116

| <vector> |  | µm Print data at coordinate <vertex>. |
| --- | --- | --- |
| Average( | Table 198) | Print average over given domain. |
| Device | =<string> | Name of the device for which the parameter will be plotted. |
| Integrate( | Table 198) | Print integral over given domain. |
| Material | =<string> | Name of material for which the parameter will be plotted if it has been specified for a particular material. |
| MaterialInterface | =<string> | Name of material interface for which the parameter will be plotted if it has been specified for a particular material interface. |
| Maximum( | Table 198) | Print maximum in given domain. |
| Minimum( | Table 198) | Print minimum in given domain. |

# G: Command File Overview

CurrentPlot

Table 197 CurrentPlot{} Tracking Additional Data in the Current File on page 116

| Model | =<string> | Select a model for printing of parameters. |
| --- | --- | --- |
| ModelParameter | =<string> | Select model parameter for plotting when using unified interface for optical generation computation. Parameter Ramping on page 635 |
| OpticalDevice | =<string> | Name of the optical device for which the parameter will be plotted. |
| Parameter | =<string> | Print parameter <string>. |
| Region | =<string> | Name of the region for which the parameter will be plotted if it has been specified for a particular region. |
| RegionInterface | =<string> | Name of the region interface for which the parameter will be plotted if it has been specified for a particular region interface. |
| Tcl( | Table 199 | Evaluate a Tcl formula. Tcl Formulas on page 121 |

Table 198 Average(), Integrate(), Maximum(), and Minimum() Tracking Additional Data in the Current File on page 116

| Table 356 |  | Sample over location. |
| --- | --- | --- |
| Coordinates |  | Print coordinates where maximum, minimum, or average occurs. |
| DopingWell | <vector> | Sample over well, defined by point in the well. |
| Everywhere |  | Sample over entire device. |
| Insulator |  | Sample over all insulator regions of the device. |
| Name | =<string> | Name for sampled data to be used in output. |
| Semiconductor |  | Sample over all semiconductor regions of the device. |
| Window[ | <vector> <vector>] | Sample over the window, defined by two specified corners. |

Table 199 Tcl() Tcl Formulas on page 121

| <ident> | =<string> \| <float> | User-specific model parameters passed to an external Tcl current plot script. Current Plot File on page 1458 |
| --- | --- | --- |
| Dataset | =<string> | Dataset name that appears in the header section of the current plot file. Dataset Option on page 122 |
| Finish | =<string> | Tcl code executed last for each plot time point. Finish Option on page 124 |
| Formula | =<string> | Tcl code executed on each mesh vertex. Formula Option on page 123 |
| Function | =<string> | Function name that appears in the header section of the current plot file. Function Option on page 123 |

G: Command File Overview
Device

Table 199 Tcl() Tcl Formulas on page 121 (Continued)

| Init | =<string> | Tcl code executed first for each plot time point. Init Option on page 123 |
| --- | --- | --- |
| Operation | =<string> | Sets the operation mode, that is, how the results of each vertex are combined. Operation Option on page 124 |
| Tcl | ="source <ident>" | Tcl code defined in external file for more complex tasks, where <ident> refers to the Tcl script file. Current Plot File on page 1458 |
| Unit | =<string> | Unit of the current plot quantity. Unit Option on page 123 |

# Device

Table 200 Device{}, OpticalDevice{}, or single-device specification Chapter 2, p. 9

| CurrentPlot{ | <ident> | Use current plot PMI. Current Plot File on page 1404 |
| --- | --- | --- |
| PMIModel (Table 318) | Use current plot PMI with parameters. Current Plot File on page 1404 |  |
| Table 190 (Table 197) | Plot scalar data to current file. Tracking Additional Data in the Current File on page 116 |  |
| Table 191/Vector(Table 197) } | Plot vectorial data to current file. Tracking Additional Data in the Current File on page 116 |  |
| Electrode{ | Table 201 } | Electrode specification. Specifying Electrical Boundary Conditions on page 67 |
| eSHEDistributionPlot{ | <vector>...} | Electron-energy distribution plot. Visualizing Spherical Harmonics Expansion Method on page 814 |
| Extraction{ | <ident> [=] <ident>...} | Process parameters. Extraction File on page 132 |
| File{ | Table 202 } | Input and output files. |
| GainPlot{ | Table 203 } | Parameters for gain plot (LED). |
| hSHEDistributionPlot{ | <vector>...} | Hole-energy distribution plot. Visualizing Spherical Harmonics Expansion Method on page 814 |
| HydrogenBoundary{ | Table 204 } | Degradation model. Boundary Conditions on page 557 |
| IFM{ | Table 205 } | Variations, noise models. IFM Section on page 761 |
| Math | ([Table 353) ] | Math specification, potentially restricted to a location. |
| { | Table 206 } |  |
| MonteCarlo{ | <options>} | See the Sentaurus™ Device Monte Carlo User Guide. |
| NoisePlot{ | Table 229 } | Noise output data. Noise Output Data on page 764 |

# G: Command File Overview

Electrode

Table 200 Device{}, OpticalDevice{}, or single-device specification Chapter 2, p. 9

| NonLocalPlot | (<vector>...) {Table 230} | Nonlocal plot. Visualizing Data Defined on Nonlocal Meshes on page 154 |
| --- | --- | --- |
| Physics | ([Table 353) ] | Physical models, potentially restricted to a location. |
| { | Table 231 |  |
| Plot{ | Table 328} | Plot data. Device Plots on page 128 |
| RayTraceBC{ | Table 330} | Raytrace boundary conditions. |
| TensorPlot ( | Table 351 | Tensor plot for beam propagation method. Visualizing Results on Native Tensor Grid on page 710 |
| ComplexRefractiveIndex |  |  |
| OpticalField |  |  |
| OpticalIntensity} |  |  |
| Thermode{ | Table 352} | Thermode specification. Specifying Thermal Boundary Conditions on page 70 |
| TrappedCarDistrPlot{ | <vector> | Trapped carrier charge plot at position <vector>. Visualizing Traps on page 520 |
| Table 356={<vector>...}} | Trapped carrier charge plot restricted to location. |  |

# Electrode

Table 201 Electrode{} Specifying Electrical Boundary Conditions on page 67

| AreaFactor | =<float> | 1 Multiplier for electrode current. Reading a Structure on page 9 |
| --- | --- | --- |
| Barrier | =<float> | V Barrier voltage. |
| Charge | =<float> | C Charge for floating electrode. Voltage must not be specified. Floating Contacts on page 232 |
| =(<float1> At <float2>[,] ...) | C, s Transient charge behavior. A list of pairs of charges <float1> at time <float2>, piecewise linearly interpolated. |  |
| Current | =<float> | A$\mu$m$d-3$ Current boundary condition. Voltage is used as initial guess only. |
| =(<float1> At <float2>[,] ...) | A$\mu$m$d-3$, s Transient current behavior. A list of pairs of currents <float1> at time <float2>, piecewise linearly interpolated. |  |
| CyclicNorm | =<string> | Output of cyclic extrapolation. File stores information about cyclic norm versus number of cyclic cycles and time. |

1512

G: Command File Overview
Electrode

Table 201 Electrode{} Specifying Electrical Boundary Conditions on page 67 (Continued)

| DistResist | =<float> | $\Omega\text{cm}^2$ Distributed resistance. Resistive Contacts on page 223 |
| --- | --- | --- |
| =SchottkyResist | Use Schottky contact resistance model. Resistive Contacts on page 223 |  |
| EqOhmic |  | off Contact is Ohmic with a modified boundary condition. Modified Ohmic Contacts on page 212 |
| eRecVelocity | =<0,)> | $2.573\text{e}6\text{ cms}^{-1}$ Electron recombination velocity. [Schottky Contacts on page 214 |
| Extraction{ | bulk | Specify electrode as bulk for extraction purposes. Extraction File on page 132 |
| drain | Specify electrode as drain for extraction purposes. Extraction File on page 132 |  |
| gate | Specify electrode as gate for extraction purposes. Extraction File on page 132 |  |
| source} | Specify electrode as source for extraction purposes. Extraction File on page 132 |  |
| FGcap=( | value=<float> | $\text{F}\mu\text{m}^{d-3}$ Additional capacitance for floating electrode. Floating Metal Contacts on page 232 |
| name=<string>) | Coupling to electrode `<string>`. Floating Metal Contacts on page 232 |  |
| hRecVelocity | =<0,)> | $1.93\text{e}6\text{ cms}^{-1}$ Hole recombination velocity. [Schottky Contacts on page 214 |
| Material | =<string> | Electrode material. Contacts on Insulators on page 213 |
| =<string> (N=<(0,)>) | $\text{cm}^{-3}$ Electrode material with n-doping. Contacts on Insulators on page 213 |  |
| =<string> (P=<(0,)>) | $\text{cm}^{-3}$ Electrode material with p-doping. Contacts on Insulators on page 213 |  |
| Name | =<string> | Name of electrode. |
| =Regexp(<string>) | Regular expression for matching structure contacts. |  |
| Poisson | =Dirichlet | \* Use Dirichlet-like boundary condition for Poisson equation. |
| =Neumann | Use homogeneous Neumann boundary condition for Poisson equation at Ohmic contacts. |  |
| Resist | =<float> | $\Omega\mu\text{m}^{3-d}$ Contact resistance. Resistive Contacts on page 223 |
| Schottky |  | off Contact is a Schottky contact. Schottky Contacts on page 214 |
| SRDoping |  | Include the image force lowering of the potential energy barrier at Schottky contact. Resistive Contacts on page 223 |

1513

G: Command File Overview
File

Table 201 Electrode{} Specifying Electrical Boundary Conditions on page 67 (Continued)

| Voltage | =<float> | V Contact voltage. |
| --- | --- | --- |
|  | =(<float1> At <float2>[,] ...) | V,s Transient voltage behavior. A list of pairs of voltages <float1> at time <float2>, piecewise linearly interpolated. |
| Workfunction | =<float> | eV Electrode workfunction. Contacts on Insulators on page 213 |

# File

In the description of Table 202, it is indicated whether a file is input or output, as well as the extensions (in `Courier` font) that Sentaurus Device appends to the user-supplied name to obtain the full name. The tags enclosed in at-signs (@) denote the default Sentaurus Workbench variables for the particular file name. (These defaults can be changed in `tooldb.tcl`, see Sentaurus™ Workbench User Guide, Global Configuration Files on page 304). (g) denotes keywords that must be used in global `File` sections only, while (d) denotes keywords that must be used in device-specific `File` sections only.

Table 202 File{}

| ACExtract | =<string> | (g) Small-signal and noise analysis (output, `_ac_des.plt`, @acplot@). Small-Signal AC Analysis on page 101 |
| --- | --- | --- |
| Bandstructure | =<string> | (d) Base name for plotting local band structure data in an LED simulation (output, `_kpbandstruc_vertexX_des.plt`, `_kpeigenfunc_vertexX_des.plt`). |
| CarrierPath | =<string> | Carrier path and spatially interpolated plot variables (output `.tdr`). Save Carrier Paths as 1D Datasets in Separate TDR File on page 468 |
| CMIPath | =<string> | (g) Search path for compact circuit files (extension `.ccf`) and the corresponding shared object files (extension `.so.arch`). The files are parsed and added to the `System` section of the command file. If the environment variable `STROOT_ARCH_OS_LIB` is defined, the directory `$STROOT_ARCH_OS_LIB/sdevice` is automatically added to `CMIPath`. System Section on page 54 |
| Current | =<string> | Device currents, voltages, charges, temperatures, and times (output, `_des.plt`, @plot@). Current File on page 113 |
| DephasingRates | =<string> | Directory for saving dephasing rates using the second Born approximation. |
| DevFields | =<string> | (d) Space distribution for trapped carrier charge density. Must match grid file (input `.tdr`). Energetic and Spatial Distribution of Traps on page 490 |

 G: Command File Overview
File

Table 202 File{} (Continued)

| DevicePath | =<string> | (g) Load all files with the extension .device in the directory path <string>. The directory path has the format dir1:dir2:dir3. The devices found can be used in the System section. They are not overwritten by a definition with the same name in the command file. System Section on page 54 |
| --- | --- | --- |
| EmissionTable | =<string> | Tabulated emission data (output). |
| eSHEDistribution | =<string> | Electron distribution versus kinetic energy (output, _des.plt). Visualizing Spherical Harmonics Expansion Method on page 814 |
| Extraction | =<string> | (d) Extraction file (output, extraction_des.xtr). Extraction File on page 132 |
| Gain | =<string> | (d) Modal stimulated and spontaneous emission spectra (output, _gain_des.plt). |
| Grid | =<string> | (d) Device geometry and mesh (input, .tdr, or @tdr@). |
| hSHEDistribution | =<string> | Hole distribution versus kinetic energy (output, _des.plt). Visualizing Spherical Harmonics Expansion Method on page 814 |
| IlluminationSpectrum | =<string> | Illumination spectrum. Illumination Spectrum on page 596 |
| IonIntegral | =<string> | Breakdown path and spatially interpolated simulation results along the breakdown path (output, _des_ABA.tdr). Visualizing Breakdown Paths on page 461 |
| LifeTime | =<string> | (d) Lifetime profiles (input, .tdr). Lifetime Profiles From Files on page 421 |
| Load | =<string> | Old simulation results (input, .sav). Save and Load Statements on page 163 |
| MesherInput | =<string> | Base name of boundary and command file to be used for calling Sentaurus Mesh. Specifying the Optical Solver on page 614 |
| MIMBand | =<string> | Metal–insulator–metal (MIM) band diagram (output, _mimband_des.tdr). Band Diagram With Traps on page 1093 |
| MIMCurrent | =<string> | MIM steady-state currents (output, _mimcur_des.plt). Special MIM Current File (Currents and Capacitance) on page 1091 on page 1091) |
| MIMSensitivity | =<string> | MIM sensitivity analysis (output, _<volt>_mimsa_des.plt). Sensitivity Analysis on page 1077 |
| MobilityDoping | =<string> | (d) File from which donor and acceptor concentrations for mobility calculations are read. Mobility Doping File on page 411 |
| NewtonPlot | =<string> | Convergence monitoring (output). NewtonPlot on page 160 |
| NonLocalPlot | =<string> | Data defined on nonlocal line meshes (output). Visualizing Data Defined on Nonlocal Meshes on page 154 |
| OpticalGenerationFile | =<string> | Load optical generation from a file. Optical AC Analysis on page 716 |

1515

# G: Command File Overview
File

Table 202 File{} (Continued)

| OpticalGenerationInput | =<string> | File from which optical generation rate is loaded. Loading and Saving Optical Generation From and to Files on page 601 |
| --- | --- | --- |
| OpticalGenerationOutput | =<string> | File to which optical generation rate is written. Loading and Saving Optical Generation From and to Files on page 601 |
| OpticalGenerationOutput (collected) | =<string> | File to which optical generation rate is written. Consecutive plots are written into one file instead of several enumerated files. Loading and Saving Optical Generation From and to Files on page 601 |
| OpticalSolverInput | =<string> | Command file of optical solver. Specifying the Optical Solver on page 614 |
| OpticsOutput | =<string> | (g) Runtime log for optical solvers (output, `_des.log`, `@optlog@`). |
| Output | =<string> | output (g) Runtime log (output, `_des.log`, `@log@`). |
| ParameterPath | =<string> | (d) List of subdirectories in the `$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB` directory that are added to the search path for parameter files. Physical Model Parameters on page 22 |
| Parameters | =<string> | (d) Device parameters (input, `.par`, `@parameter@`). Physical Model Parameters on page 22 |
| Piezo | =<string> | (d) Stress data for piezoelectric model (input). Chapter 31, p. 885 |
| Plot | =<string> | Spatially distributed simulation results (output, `_des.tdr`, `@tdrdat@`). Device Plots on page 128 |
| Plot (collected) | =<string> | Spatially distributed simulation results (output, `_des.tdr`, `@tdrdat@`). Consecutive plots are written into one file instead of several enumerated files. Device Plots on page 128 |
| PMIPath | =<string> | (g) Search path to load shared object files (extension `.so.arch`) for PMI models. Command File of Sentaurus Device on page 1187 |
| PMIUserFields | =<string> | (d) File containing any of the fields `PMIUserField0` to `PMIUserField299`. |
| SpectralPlot | =<string> | Spatially distributed simulation results (output, `_des.tdr`, `@spectralplot@`) for each entry of the illumination spectrum as well as spectral curves (`_des.plt`) for the results of the optical solver. Consecutive plots are written into one file instead of several enumerated files, that is, `SpectralPlot(collected)` is the default. Illumination Spectrum on page 596 |
| SpectralPlot (-collected) | =<string> | Spatially distributed simulation results (output, `_des.tdr`, `@spectralplot@`) for each entry of the illumination spectrum as well as spectral curves (`_des.plt`) for the results of the optical solver. Consecutive plots are written into several enumerated files. Illumination Spectrum on page 596 |
| TensorPlot | =<string> | Base name for saving tensor plot files when using beam propagation method. Visualizing Results on Native Tensor Grid on page 710 |

1516

**G: Command File Overview**
GainPlot

Table 202 File{} (Continued)

| Save | =<string> | Simulation results for retrieval with Load (output, _des.sav). Save and Load Statements on page 163 |
| --- | --- | --- |
| SaveOptField | =<string> | Base name for saving optical field data in an LED simulation. |
| SPICEPath | =<string> | Search path for SPICE circuit files (extension .scf). The files are parsed and added to the System section of the command file. If the environment variable STROOT_LIB is defined, the directory $STROOT_LIB/sdevice/spice is automatically added to SPICEPath. File Section on page 61 |
| TrappedCarPlotFile | =<string> | Trapped carrier charge density, trap occupancy probability, and trap density versus energy (output, _des.plt). Visualizing Traps on page 520 |

# GainPlot

Table 203 GainPlot{}

| Intervals | =<int> | Number of points to plot for each gain curve. |
| --- | --- | --- |
| Range | =(<float>*2) | eV Energy range of the gain plot. |
|  | =Auto | Automatically find the energy range. |

# HydrogenBoundary

Table 204 HydrogenBoundary{} Boundary Conditions on page 557

| HydrogenAtom | =<float> | cm-3 Boundary concentration. |
| --- | --- | --- |
|  | =reflective | Homogeneous Neumann boundary condition |
| HydrogenIon | =<float> | cm-3 Boundary concentration. |
|  | =reflective | Homogeneous Neumann boundary condition. |
| HydrogenMolecule | =<float> | cm-3 Boundary concentration. |
|  | =reflective | Homogeneous Neumann boundary condition. |
| Name | =<string> | Name of the hydrogen contact. |

G: Command File Overview
IFM

# IFM

Table 205 IFM{} IFM Section on page 761

| DeterministicVariation( | Table 284 | (g) Deterministic variations. Deterministic Doping Variations on page 757 |
| --- | --- | --- |
| Noise | [<string>] (Table 313) | (r) Noise sources. Noise Sources on page 734 |
| RandomizedVariation | <string> (Table 319) | (g) Set sIFM models. Statistical Impedance Field Method on page 745 |

# Math

Table 206 Math{}

| Table 213 |  | Transient time-step control. |
| --- | --- | --- |
| AcceptNewtonParameter ( | Table 207) | (g) Relaxed Newton method. Relaxed Newton Method on page 149 |
| ACMethod | =Blocked | \* Use block decomposition solver for ACCoupled. |
| ACSubMethod | =Table 218 | Inner linear solver for Blocked method for ACCoupled. |
| AllowLayerThickness | =Everywhere | (g) Account for LayerThickness in all materials. Extracting Layer Thickness on page 333 |
| =Insulator | (g) Account for LayerThickness in insulators only. |  |
| =Metal | (g) Account for LayerThickness in metals only. |  |
| =Semiconductor | \* (g) Account for LayerThickness in semiconductors only. |  |
| AnisoGradQF_formula | =0 \| 1 | 0 Select formula for driving force. Driving Forces on page 844 |
| AnisoSG |  | off (g) Use anisotropic Scharfetter–Gummel approximation for anisotropic models. Chapter 28, p. 833 |
| AnisoSG_DerivativeMinDen | =<float> | 0.0 cm–3 (g) Lower limit of carrier densities for AnisoSG approximation. Corresponding derivatives are switched off if the node concentration is less than this value. Chapter 28, p. 833 |

G: Command File Overview
Math

Table 206 Math{} (Continued)

| AnisoSG_MinDen | =<float> | 10 cm–3 (g) Stabilization parameter for computation of x* for AnisoSG approximation. Chapter 28, p. 833 |
| --- | --- | --- |
| AutoCNPMinStepFactor |  | 2.0 (g) Multiplier of MinStep for the automatic activation of CNormPrint. Automatic Activation of CNormPrint and NewtonPlot on page 161 |
| AutomaticCircuitContact |  | on Poisson covers the circuit. Additional Equations Available in Mixed Mode on page 147 |
| AutoNPMinStepFactor |  | 2.0 (g) Multiplier of MinStep for the automatic activation of NewtonPlot. Automatic Activation of CNormPrint and NewtonPlot on page 161 |
| AutoOrientation | =(<int>...) | Miller indices for surface orientations supported by AutoOrientation. Changing Orientations Used With Auto-Orientation on page 38 |
| AutoOrientationSmoothing Distance | =<float> | 0.0 μm (r) Auto-orientation smoothing distance. Auto-Orientation Smoothing on page 39 |
| AvalDensGradQF |  | - Alternative driving force. Using Avalanche Generation on page 441 |
| AvalDerivatives |  | + Compute analytic derivatives of avalanche generation. Derivatives on page 146 |
| AvalFlatElementExclusion | =<float> | 0.0 degree (g) Exclude elements from contributing to avalanche generation. Using Avalanche Generation on page 441 |
| AvalPostProcessing |  | off Impact ionization–generated carriers are not included self-consistently in the solution. Approximate Breakdown Analysis With Carriers on page 463 |
| AverageAniso |  | (g) Use average-aniso approximation for anisotropic models. Chapter 28, p. 833 |
| AverageBoxMethod |  | + Use element-oriented element intersection box method algorithm. If disabled, use quadrilateral box method algorithm. Box Method Coefficients in the 3D Case on page 1135 |
| BehavSrcNumericDeriv | =<float> | 0 Compute the numeric Jacobian. |
| BM_ExtendedPrecision |  | + Use “long double” precision to compute box method coefficients and control volumes. Extended Precision on page 1134 |
| BM_StableCalculation |  | + Use improved and more accurate algorithms to compute box method coefficients and control volumes. Improved Accuracy of Box Method Parameters on page 1147 |

# G: Command File Overview

Math

Table 206 Math{} (Continued)

| BoxCoefficientsFromFile | [(GrdNumbering)] | Try to read sections of the geometry file. Saving and Restoring Box Method Coefficients on page 1143 |
| --- | --- | --- |
| BoxMeasureFromFile | [(GrdNumbering)] | Try to read sections of the geometry file. Saving and Restoring Box Method Coefficients on page 1143 |
| BreakAtIonIntegral | (<int> <float>) | 1 1 Terminate the quasistationary simulation when the <int> largest ionization integrals are greater than <float>. Approximate Breakdown Analysis on page 457 |
| BreakCriteria{ | Table 208 | Break criteria. Break Criteria: Conditionally Stopping the Simulation on page 71 |
| BroadeningIntegration( GaussianQuadrature(Order | =<int>)) | Use Gaussian quadrature to integrate the broadening spectrum of an LED simulation. Accelerating Gain Calculations and LED Simulations on page 996 |
| CarrierDensityInAltermatt |  | + Use carrier density in the Altermatt ionization model. Physical Model Parameters on page 296 |
| CDensityMin |  | 0.0 Acm–2 (r) Current limit for parallel electric-field computation. Electric Field Parallel to the Interface on page 396 |
| CheckRhsAfterUpdate |  | – Check whether the RHS can be reduced further after the update error has converged. Convergence and Error Control on page 143 |
| CheckUndefinedModels |  | + (g) Check for undefined physical parameters. Undefined Physical Models on page 34 |
| CNormPrint |  | (g) Convergence monitoring. CNormPrint on page 160 |
| ComputeDopingConcentration |  | – (g) Recompute net doping based on individual doping species. Specifying Doping Species on page 12 |
| ComputeGradQuasiFermiAt Contacts | =UseElectrostaticPotential | \* Use the electrostatic potential to compute the GradQuasiFermi driving force within elements touching a contact. Eq. 358, p. 396 |
| =UseQuasiFermi | Use the quasi-Fermi potential to compute the GradQuasiFermi driving force within elements touching a contact. Eq. 357, p. 396 |  |
| ComputeIonizationIntegrals |  | off Compute ionization integrals using old discretization scheme. Approximate Breakdown Analysis on page 457 |
| (Table 210) |  |  |

**G: Command File Overview**
Math

Table 206 Math{} (Continued)

| ConstRefPot | =<float> | eV Value for $\phi_{\text{ref}}$. Quasi-Fermi Potential With Boltzmann Statistics on page 181 |
| --- | --- | --- |
| CoordinateSystem{ | Table 1 } | (g) Coordinate system of explicit coordinates in command file. Reading a Structure on page 9 |
| cT_Range | =(<float>*2) | 10 80000 K (g) Lower and upper limit for carrier temperature. Numeric Parameters for Temperature Equations on page 208 |
| CurrentPlot ( | Digits=<float> | 6 Number of digits in the names of quantities in the current plot file. CurrentPlot Options on page 120 |
| IntegrationUnit=<string>) | um Length unit for current plot integration. CurrentPlot Options on page 120 |  |
| CurrentWeighting |  | off Compute contact currents using an optimal weighting scheme. Numeric Approaches for Contact Current Computation on page 193 |
| Cylindrical | (<float>) | off Use the 2D mesh to simulate a 3D cylindrical device. The device is assumed to be rotationally symmetric around the vertical axis given by $x = <float>\mu\text{m}$. <float> must be less than or equal to the smallest horizontal device coordinate, and defaults to 0. Reading a Structure on page 9 |
| (xAxis=<float>) | This is same as (<float>). |  |
| (yAxis=<float>) | The device is assumed to be rotationally symmetric around the horizontal axis given by $y = <float>\mu\text{m}$. <float> must be less than or equal to the smallest vertical device coordinate. For UCS coordinates, the x-axis is the vertical axis, so you must specify the cylindrical axis using yAxis. |  |
| DeltaVolumeLimit | =<float> | 1e-4 Limit for DeltaVolume. Region Non-Delaunay Elements on page 1145 |
| DensityIntegral | (<int>) | 30 (g) Defines a number of Gauss–Laguerre quadrature integration points. Using Multivalley Band Structure on page 285 |
| DensLowLimit | =<float> | 1e-100 cm-3 (g) Lower limit for carrier densities. Numeric Parameters for Continuity Equation on page 192 |
| DensLowLimitPower | =<int> | -100 (g) Lower limit power for carrier densities ($10^{\text{DensLowLimitPower}} \text{cm}^{-3}$). Numeric Parameters for Continuity Equation on page 192 |
| Derivatives |  | + Compute analytic derivatives of mobility and avalanche generation. Derivatives on page 146 |

# G: Command File Overview
Math

Table 206 Math{} (Continued)

| Digits | =<float> | 5 Approximate number of digits to which equations must be solved to be considered as converged. Convergence and Error Control on page 143 |
| --- | --- | --- |
| DirectCurrent |  | off Compute contact currents directly, using only contact nodes and their neighbors. Numeric Approaches for Contact Current Computation on page 193 |
| DirectQuantumCorrection |  | off Use the quantum potential directly as the band edge. Notes on the Use of the Density Gradient Model on page 322 |
| DualGridInterpolation | (Method=Conservative) | Use conservative element-based interpolation for dual-grid simulations. Dual-Grid Setup for Raytracing on page 678, Single-Grid Versus Dual-Grid LED Simulation on page 988 |
| (Method=Simple) | Use bilinear vertex-based interpolation for dual-grid simulations. Dual-Grid Setup for Raytracing on page 678, Single-Grid Versus Dual-Grid LED Simulation on page 988 |  |
| eB2BGenWithinSelectedRegions |  | + (g) Restrict nonlocal path band-to-band electron generation to regions where model is active. Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475 |
| eDrForceRefDens | =<0,)> | 0 cm-3 (r) Damping parameter for high-field mobility driving force, alias for `RefDens_eGradQuasiFermi_Zero`. [Interpolation of Driving Forces to Zero Field on page 398 |
| ElementEdgeCurrent |  | – (g) Use an alternative element-edge approximation of the current density compared to the default edge approximation. |
| ElementVolumeAvalanche |  | – (g) Use truncated element-vertex volumes for avalanche generation. Using Avalanche Generation on page 441 |
| eMobilityAveraging | =Element | \* (r) Use element averaged electron mobility. Mobility Averaging on page 410 |
| =ElementEdge | (r) Use element-edge averaged electron mobility. Mobility Averaging on page 410 |  |
| EnormalInterface( | MaterialInterface=[<string>...] | Material interfaces for normal electric field computation. Normal to the Interface on page 380 |
| RegionInterface=[<string>...]) | Region interfaces for normal electric field computation. Normal to the Interface on page 380 |  |

G: Command File Overview
Math

Table 206 Math{} (Continued)

| EparallelToInterface( |  | Options for EparallelToInterface driving force. Electric Field Parallel to the Interface on page 396 |
| --- | --- | --- |
| Direction=<vector> | ! Direction of the current. |  |
| Box=(<vector> <vector>)) | Restrict Direction vector to vertices contained in box. |  |
| eQPBox( | QBoxForBC | Apply the box to select boundary condition on interfaces. |
| Table 211) | Quantum box for eQuantumPotential. Density Gradient Model on page 316 |  |
| EquilibriumSolution( | Table 212) | (g) Parameters for equilibrium solution used in specific models. Equilibrium Solution on page 181 |
| Error | (Table 336)=<float> | Value of $$ \varepsilon_A $$. Convergence and Error Control on page 143 |
| ErrRef | (Table 336)=<float> | Value of $$ x_{ref} $$. Convergence and Error Control on page 143 |
| ExitOnFailure |  | (g) off Terminate the simulation as soon as a Solve command fails. |
| ExitOnUnknownParameterRegion |  | + (g) Exit when unknown region, region interface, or electrode appears in parameter file. |
| -ExitOnUnknownParameterRegion |  | off (g) Print warning message when unknown region, region interface, or electrode appears in parameter file. |
| ExtendedPrecision | ([Table 26) ] | (g) off Use extended precision floating-point arithmetic. Extended Precision on page 174 |
| Extrapolate | (Table 213) | – Use extrapolation to obtain an initial guess for the next solution based on the previous solutions. Extrapolation on page 82, Extrapolation on page 95 |
| FEPolarizationIP | =<float> | 0 Numeric parameter for imposing divergence-free polarization constraint. Chapter 29, p. 855 |
| FEPolarizationSolver2 |  | off Use the improved solver for FEPolarization equation. Solver II on page 867 |
| FermiBandTailStatistics |  | + Use Fermi–Dirac statistics for band tail density. Band Tails on page 279 |
| GeometricDistances |  | + (g) Use enhanced distance and normal to interface computation for mobility and MLDA. Normal to the Interface on page 380 |
| GrainFieldGenerator | (Table 214) | (r) Generate grain field. Creating the Grain Field on page 1062 |

# G: Command File Overview

Math

Table 206 Math{} (Continued)

| HB | {Table 215} | Harmonic Balance on page 106; not device specific. |
| --- | --- | --- |
| hDrForceRefDens | =<0,)> | 0 cm-3 (r) Damping parameter for high-field mobility driving force, alias for RefDens_hGradQuasiFermi_Zero. [Interpolation of Driving Forces to Zero Field on page 398 |
| hMobilityAveraging | =Element | (r) Use element averaged hole mobility. Mobility Averaging on page 410 |
|  | =ElementEdge | \* (r) Use element-edge averaged hole mobility. Mobility Averaging on page 410 |
| hQPBox( | QBoxForBC | Apply the box to select boundary condition on interfaces. |
|  | Table 216) | Quantum box for hQuantumPotential. Density Gradient Model on page 316 |
| IgnoreTdrUnits |  | off (g) Ignore TDR units when loading data from a .tdr file. Reading a Structure on page 9 |
| ILSrc | =<string> | ILS options. Linear Solvers on page 151 |
| ImplicitACSystem |  | - (g) Construct implicit AC system. AC Analysis in Single-Device Mode on page 104 |
| IncompleteNewton |  | - (g) Incomplete Newton. Incomplete Newton Algorithm on page 146 |
| ( | RhsFactor=<float> | 10 Maximum change in RHS to allow old Jacobian to be reused. |
|  | UpdateFactor=<float>) | 0.1 Maximum change in update to allow old Jacobian to be reused. |
| Interrupt | =BreakRequest | Write .tdr or .sav file and terminate actual solve statement after signal INT occurs. Snapshots on page 130 |
|  | =PlotRequest | Write .tdr or .sav file and continue simulation after signal INT occurs. Snapshots on page 130 |
| Iterations | =<0..> | 50 Maximum number of Newton iterations. Convergence and Error Control on page 143 |
| KMC | (Table 217) | KMC metal-insulator-metal (KMC-MIM) transport simulation. Chapter 36, p. 1053 |
| LineSearchDamping | =<(0,1]> | 1 Smallest allowed damping coefficient for line search damping. Damped Newton Iterations on page 145 |

**G: Command File Overview**
Math

Table 206 Math{} (Continued)

| lT_Range | =(<float*2) | 50 5000 K (g) Lower and upper limit for lattice temperature. Numeric Parameters for Temperature Equations on page 208 |
| --- | --- | --- |
| MetalConductivity |  | + Conductivity of metals. The thermal conductivity is simulated in any case. Transport in Metals on page 249 |
| Method | Table 218 | Linear solver for Coupled. |
| =Blocked | \* Use block decomposition solver for Coupled. Linear Solvers on page 151 |  |
| Method ( | =Bitlis | Use equation decomposition solver for electrostatic problems. Bitlis Solver on page 868 |
| Iterations=<int> | 200 Number of iterations between successive restarts. |  |
| Restart=<int> | 100 Maximum number of iterations. |  |
| Tolerance=<float>) | 1e-8 Convergence criterion. |  |
| MGPreconditioner ( |  | Set parameters to control multi-grid algorithm See Bitlis Solver on page 868. |
| MaxCycles=<int> | Controls overall convergence of multi-grid algorithm. |  |
| MaxIterations=<int> | Maximum number of smoother sweeps. |  |
| MaxLevels=<int> | Maximum number of interpolation levels used to build multi-grid hierarchy. |  |
| MinSize=<int> | Minimum size of the coarsest grid. |  |
| RelaxationError=<float> | Controls smoothness of the error. |  |
| SolutionError=<float>) | Controls overall convergence of multi-grid algorithm. |  |
| MixAverageBoxMethod |  | – Use mix average box method algorithm. Box Method Coefficients in the 3D Case on page 1135 |
| MixedModeContactResistance | =<float> | Set a mixed-mode resistance to the circuit node. Ohmic Contacts on page 211 |
| MLDABox({ | Table 219}...) | A box within which the interface is confined for the calculation of the MLDA distance function. Modified Local-Density Approximation Model on page 324 |
| MLDAMinDistanceToContact | =<float> | 75e-8 µm (g) Minimum distance to contact where MLDA model is switched off. Modified Local-Density Approximation Model on page 324 |
| MobEnormalSignDependence |  | – (r) Mobility degradation only for carriers that are pulled to the interface by the electric field. Using Mobility Degradation at Interfaces on page 357 |

## G: Command File Overview

Math

Table 206 Math{} (Continued)

| MobEnormalUniboRegularization Field | =<float> | 0 V/cm (r) Regularization field to improve convergence. University of Bologna Surface Mobility Model on page 370 |
| --- | --- | --- |
| MVMLDAcontrols( | Table 220) | Multivalley MLDA controlling options. Using the MLDA Model on page 328 |
| NaturalBoxMethod |  | – Use edge-oriented element intersection BM algorithm. Box Method Coefficients in the 3D Case on page 1135 |
| NewHBFileNames |  | + Use new output format. Circuit Currents and Voltages on page 110 |
| NewtonPlot ( |  | (g) Convergence monitoring. NewtonPlot on page 160 |
| Error | Write the error of all solution variables. |  |
| MinError | Write file only if error decreases. |  |
| NewtonPlotStep= <float> | Upper limit for step size for which to write files. |  |
| Plot | Write everything specified in the Plot section. Device Plots on page 128 |  |
| Residual | Write the residuals (right-hand sides) of all equations. |  |
| Update) | Write the updates of all solution variables from the previous step. |  |
| NoAutomaticCircuitContact |  | off (g) Poisson excludes the circuit. Additional Equations Available in Mixed Mode on page 147 |
| NonLocal | (Table 221) | (cir) Nonlocal mesh. Nonlocal Meshes on page 152 |
| <string> (Table 221) | (g) Named nonlocal mesh. |  |
| NonLocalLengthLimit | =<float> | 1e-4 cm (g) Limit for nonlocal line length. Nonlocal Meshes on page 152 |
| NonLocalPath | (Table 222) | Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475, Handling Derivatives on page 481 |
| NormalFieldCorrection | =<float> | (r) Normal field correction factor for mobility on interface points. Field Correction on Interface on page 381 |
| NoSRHperPotential |  | off Omit potential derivatives of SRH recombination rate. Using Field Enhancement on page 424 |
| NoSRHperT |  | off Omit temperature derivatives of SRH recombination rate. Using Field Enhancement on page 424 |

G: Command File Overview
Math

Table 206 Math{} (Continued)

| NotDamped | =<0..> | 1000 (g) Number of iterations in each Newton iteration before Bank–Rose damping is activated. Damped Newton Iterations on page 145 |
| --- | --- | --- |
| NumberOfAssemblyThreads | =<int> | 1 (g) Number of threads for assembly. Parallelization on page 172 |
| NumberOfSolverThreads | =<int> | 1 (g) Number of threads for linear solver. Parallelization on page 172 |
| NumberOfThreads | =<int> | 1 (g) Number of threads for linear solver and assembly. Parallelization on page 172 |
| Numerically | ([Table 336...) ] | off (g) Use numeric derivatives. The optional list restricts the numeric computation to specific Jacobian blocks. Derivatives on page 146 |
| ParallelLicense | (Table 25) | (g) Determine the behavior if insufficient parallel licenses are available. |
| ParallelToInterfaceInBoundary Layer ( |  | + (r) Controls the computation of driving forces for mobility and avalanche models along interfaces. Field Correction Close to Interfaces on page 400 |
| ExternalBoundary | + Include the external boundary in the interface for which this feature applies. |  |
| ExternalXPlane | + Include external x-planes in the interface for which this feature implies. |  |
| ExternalYPlane | + Include external y-planes in the interface for which this feature implies. |  |
| ExternalZPlane | + Include external z-planes in the interface for which this feature implies. |  |
| FullLayer | off Apply switch to all elements that touch an interface either by a face, an edge, or a vertex. |  |
| Interface | + Include semiconductor–insulator region interfaces in the interface for which this feature applies. |  |
| PartialLayer) | on Apply switch only to elements that touch an interface by an edge (2D) or a face (in 3D). |  |
| ParameterInheritance | =Flatten | \* Region parameters inherit materialwise parameter settings. Combining Parameter Specifications on page 30 |
| =None | Region parameter settings cause materialwise settings to be ignored. |  |

# G: Command File Overview

Math

Table 206 Math{} (Continued)

| PeriodicBC |  | (g) Periodic boundary conditions (PBCs). Periodic Boundary Conditions on page 237 |
| --- | --- | --- |
| Table 336 | Equation for which to apply PBCs. If omitted, apply to all equations (RPBC only). |  |
| `Coordinates=(<float>*2)` | µm Coordinate of `Direction` axis where the PBCs will be applied. Sentaurus Device replaces coordinates outside the device with coordinates at the outer boundary (RPBC only). |  |
| `Direction=<0..2>` | Direction of periodicity: 0 for x-axis, 1 for y-axis, and 2 for z-axis. |  |
| `Factor=<float>` | 1e8 Tuning parameter α (RPBC only). |  |
| `MortarSide=<side>` | XMin \| YMin \| ZMin Mortar side with `<side>` one of XMin, XMax, YMin, YMax, ZMin, or ZMax (MPBC only). |  |
| `Type=<type>)...)` | RPBC Select PBC mode where `<type>` is one of RPBC or MPBC. |  |
| PlotExplicit |  | - (g) All `Plot` statements write s specified in `Plot` section only. |
| PlotLoadable |  | + (g) All `Plot` statements write additional information required to load a simulation from a .tdr file. |
| PostProcess | `(Transient=<ident> [(Table 358)])` | (g) Use PMI `<ident>` to postprocess data. Postprocessing for Transient Simulations on page 1408 |
| PrintLinearSolver |  | (g) Print additional information regarding the linear solver being used. Linear Solvers on page 151 |
| RandomizedVariation | `<string>` (Table 226) | (g) Use statistical impedance field method. Statistical Impedance Field Method on page 745 |
| RecBoxIntegr | `(<float> <int> <int>)` | (1e-2 10 1000) Maximum relative deviation of covered volume, maximum number of levels, maximum number of total rectangles per box. |
| RecomputeQFP |  | Keep density variables constant, and recompute quasi-Fermi potentials when the electrostatic potential changes and carrier equations are not solved. Introduction to Carrier Transport Models on page 189 |
| RefDens_eParallel_ElectricField | `=<float>` | 0 cm-3 (r) Damping parameter for electron high-field mobility and avalanche driving forces. Interpolation of the Eparallel Driving Force on page 400 and Interpolation of Avalanche Driving Forces on page 455 |

**G: Command File Overview**
Math

Table 206 Math{} (Continued)

| RefDens_eEparallel_ ElectricField_Aval | =<float> | 0 cm-3 (r) Damping parameter for electron avalanche driving force. Interpolation of Avalanche Driving Forces on page 455 |
| --- | --- | --- |
| RefDens_eEparallel_ ElectricField_HFS | =<float> | 0 cm-3 (r) Damping parameter for the electron high-field mobility driving force. Interpolation of the Eparallel Driving Force on page 400 |
| RefDens_eGradQuasiFermi_ ElectricField | =<float> | 0 cm-3 (r) Damping parameter for electron high-field mobility and avalanche driving forces. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_eGradQuasiFermi_ ElectricField_HFS | =<float> | 0 cm-3 (r) Damping parameter for electron high-field mobility driving force. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_eGradQuasiFermi_ EparallelToInterface_HFS | =<float> | 0 cm-3 (r) Damping parameter for electron high-field mobility driving force. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_eGradQuasiFermi_Zero | =<float> | 0 cm-3 (r) Damping parameter for electron high-field mobility driving force, alias for eDrForceRefDens. Interpolation of Driving Forces to Zero Field on page 398 |
| RefDens_Eparallel_ ElectricField | =<float> | 0 cm-3 (r) Damping parameter for electron and hole high-field mobility and avalanche driving forces. Interpolation of the Eparallel Driving Force on page 400 and Interpolation of Avalanche Driving Forces on page 455 |
| RefDens_Eparallel_ ElectricField_Aval | =<float> | 0 cm-3 (r) Damping parameter for electron and hole avalanche driving forces. Interpolation of Avalanche Driving Forces on page 455 |
| RefDens_Eparallel_ ElectricField_HFS | =<float> | 0 cm-3 (r) Damping parameter for the electron and hole high-field mobility driving forces. Interpolation of the Eparallel Driving Force on page 400 |
| RefDens_GradQuasiFermi_ ElectricField | =<float> | 0 cm-3 (r) Damping parameter for electron and hole high-field mobility and avalanche driving forces. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_GradQuasiFermi_ ElectricField_HFS | =<float> | 0 cm-3 (r) Damping parameter for electron and hole high-field mobility driving forces. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_GradQuasiFermi_ EparallelToInterface_HFS | =<float> | 0 cm-3 (r) Damping parameter for electron and hole high-field mobility driving forces. Interpolation of the GradQuasiFermi Driving Force on page 399 |

1529

# G: Command File Overview
Math

Table 206 Math{} (Continued)

| RefDens_GradQuasiFermi_Zero | =<float> | 0 cm-3 (r) Damping parameter for electron and hole high-field mobility driving forces, alias for DrForceRefDens. Interpolation of Driving Forces to Zero Field on page 398 |
| --- | --- | --- |
| RefDens_hEparallel_ElectricField | =<float> | 0 cm-3 (r) Damping parameter for hole high-field mobility and avalanche driving forces. Interpolation of the Eparallel Driving Force on page 400 and Interpolation of Avalanche Driving Forces on page 455 |
| RefDens_hEparallel_ElectricField_Aval | =<float> | 0 cm-3 (r) Damping parameter for hole avalanche driving force. Interpolation of Avalanche Driving Forces on page 455 |
| RefDens_hEparallel_ElectricField_HFS | =<float> | 0 cm-3 (r) Damping parameter for the hole high-field mobility driving force. Interpolation of the Eparallel Driving Force on page 400 |
| RefDens_hGradQuasiFermi_ElectricField | =<float> | 0 cm-3 (r) Damping parameter for hole high-field mobility and avalanche driving forces. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_hGradQuasiFermi_ElectricField_HFS | =<float> | 0 cm-3 (r) Damping parameter for hole high-field mobility driving force. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_hGradQuasiFermi_EparallelToInterface_HFS | =<float> | 0 cm-3 (r) Damping parameter for hole high-field mobility driving force. Interpolation of the GradQuasiFermi Driving Force on page 399 |
| RefDens_hGradQuasiFermi_Zero | =<float> | 0 cm-3 (r) Damping parameter for hole high-field mobility driving force, alias for hDrForceRefDens. Interpolation of Driving Forces to Zero Field on page 398 |
| RefNa_QuantumPotential | =<float> | 1e25 cm-3 Semiconductor acceptor doping density for the application of the homogeneous Neumann boundary condition on semiconductor–insulator interfaces. Using the Density Gradient Model on page 318 |
| RefNd_QuantumPotential | =<float> | 1e25 cm-3 Semiconductor donor doping density for the application of the homogeneous Neumann boundary condition on semiconductor–insulator interfaces. Using the Density Gradient Model on page 318 |
| RelErrControl |  | + Use relative error control. Convergence and Error Control on page 143 |
| RelTermMinDensity | =<(0,)> | 1e3 cm-3 (g) Stabilization parameter for temperature relaxation term. Hydrodynamic Model Parameters on page 207 |

G: Command File Overview
Math

# Table 206 Math{} (Continued)

| RelTermMinZeroDensity | =< (0, ) > | 2e8 cm-3 (g) Stabilization parameter for temperature relaxation term. Hydrodynamic Model Parameters on page 207 |
| --- | --- | --- |
| RhsAndUpdateConvergence |  | – Newton converged if both RHS and update are converged. Convergence and Error Control on page 143 |
| RhsFactor | =< float > | 1e10 Maximum increase of the $L_2$-norm of the RHS between Newton iterations. Convergence and Error Control on page 143 |
| RhsMax | =< float > | 1e15 Maximum of $L_2$-norm of the RHS in each Newton iteration (transient simulations). Convergence and Error Control on page 143 |
| RhsMaxQ | =< float > | 1e100 Maximum of $L_2$-norm of the RHS in each Newton iteration (non-transient simulations). Convergence and Error Control on page 143 |
| RhsMin | =< float > | 1e-5 Minimum of $L_2$-norm of the RHS in each Newton iteration. Convergence and Error Control on page 143 |
| RhsMinFactor | =< float > | 1e-5 Factor for RhsMin affecting convergence. Convergence and Error Control on page 143 |
| SHECutoff | =< 0, ) > | 5.0 (g) Maximum kinetic energy to be plotted in the SHE distribution model. [Using Spherical Harmonics Expansion Method on page 806 |
| SHEIterations | =< 0.. > | 20 (g) Number of iterations in the SHE distribution model. Using Spherical Harmonics Expansion Method on page 806 |
| SHEMethod | =Table 218 | super (g) Linear solver for the SHE distribution model. Using Spherical Harmonics Expansion Method on page 806 |
| SHERefinement | =< 1.. > | 1 (g) Number of energy grid intervals inside the phonon energy spacing in the SHE distribution model. Using Spherical Harmonics Expansion Method on page 806 |
| SHESOR |  | + Use the successive over-relaxation method in the SHE distribution model. Using Spherical Harmonics Expansion Method on page 806 |
| SHESORParameter | =< 1, 2) > | 1.1 (g) Successive over-relaxation parameter in the SHE distribution model. [Using Spherical Harmonics Expansion Method on page 806 |

1531

# G: Command File Overview

Math

Table 206 Math{} (Continued)

| SHETopMargin | =<0,)> | 1.0 (g) Top energy margin in the SHE distribution model. [Using Spherical Harmonics Expansion Method on page 806 |
| --- | --- | --- |
| SimpleBandTailIntegration |  | + Use abrupt distribution function for band tail density. Band Tails on page 279 |
| SimStats |  | off (g) Write simulation statistics to current plot file. Simulation Statistics for Plotting and Output on page 162 |
| (WriteDOE | Write simulation statistics as DOE variables. |  |
| DOE_prefix=<string>) | Use the specified prefix for DOE variables. |  |
| Smooth |  | off Keep mobility and recombination rates from the previous step to obtain better initial conditions for extreme nonlinear iterations. |
| Spice_gmin | =<float> | 1e-12 $\Omega^{-1}$ (g) SPICE minimum conductance. Math Section on page 62 |
| Spice_Temperature | =<float> | 300.15 K (g) Temperature of SPICE circuit. Math Section on page 62 |
| SponEmissionIntegration( GaussianQuadrature(Order | =<int>)) | Use Gaussian quadrature to integrate the spontaneous emission spectrum of an LED simulation. Accelerating Gain Calculations and LED Simulations on page 996 |
| StackSize | =<int> | 1000000 byte (g) Stack size per thread. Parallelization on page 172 |
| StressLimit | =<float> | 1e100 Pa (g) Upper limit on stress values read from files or specified. Values exceeding the limit will be truncated to the limit. Stress Limits on page 889 |
| StressMobilityDependence | =TensorFactor | Stress Tensor Applied to Low-Field Mobility on page 949 |
| StressSG |  | off (g) Use anisotropic Scharfetter–Gummel approximation for piezo mobility models. Chapter 28, p. 833 |
| SubMethod | =Table 218 | (g) Inner linear solver for Blocked method. Linear Solvers on page 151 |
| Surface | <string> (Table 355...) | (g) Define a surface. Mobility Degradation Components due to Coulomb Scattering on page 372, Random Geometric Fluctuations on page 738 |
| TensorGridAniso |  | + (g) Use tensor-grid approximation for anisotropic piezo mobility. Tensor Grid Option on page 948 |

G: Command File Overview
Math

Table 206 Math{} (Continued)

| TensorGridAniso( | Piezo | + (g) Same as TensorGridAniso. |
| --- | --- | --- |
| Aniso) | + (g) Use tensor-grid approximation for anisotropic models. Chapter 28, p. 833 |  |
| ThinLayer( | Mirror=(<mirror>*3)) | (g) Mirror planes for simulation system axes. `<mirror>` is Min, Max, None, or Both. Geometric Parameters of the LayerThickness Command on page 335 |
| TransferredElectronEffect2_ eMinDerivativePerField | =<float> | -1e100 cm2V-1s-1 (r) Lower bound for velocity derivative $\partial v / \partial F_{hfs}$ (electrons only). Transferred Electron Model 2 on page 390 |
| TransferredElectronEffect2_ hMinDerivativePerField | =<float> | -1e100 cm2V-1s-1 (r) Lower bound for velocity derivative $\partial v / \partial F_{hfs}$ (holes only). Transferred Electron Model 2 on page 390 |
| TransferredElectronEffect2_ MinDerivativePerField | =<float> | -1e100 cm2V-1s-1 (r) Lower bound for velocity derivative $\partial v / \partial F_{hfs}$ (electrons and holes). Transferred Electron Model 2 on page 390 |
| Transient | =BE | (g) Backward Euler method. Backward Euler Method on page 1155 |
| =TRBDF | \* (g) TRBDF method. TRBDF Composite Method on page 1156 |  |
| TrapDLN | =<int> | 13 (g) Levels to approximate trap energy distribution. Energetic and Spatial Distribution of Traps on page 490 |
| TrapDLN(PeakSampling) | =<int> | 13 Apply a peak sampling method to Gaussian and exponential distributions in all trap entries. Energetic and Spatial Distribution of Traps on page 490 |
| Traps( | Damping=<0,)> | 10 Damping for traps for the nonlinear Poisson equation. A value of 0 disables damping. [Chapter 17, p. 489 |
| RegionWiseAssembly) | - Apply regionwise assembly for traps. |  |
| UpdateIncrease | =<float> | 1.e100 (g) Maximum-allowed update error increase factor per Newton step. |
| UpdateMax | =<float> | 1.e100 (g) Maximum-allowed update error in Newton algorithm. |
| UpdateQFPinTransientPoisson |  | + (g) Update quasi-Fermi potentials in Transient, critical for Poisson-only solution. Numeric Control of Transient Analysis on page 91 |
| UseSchurSolver |  | - (g) Replace Blocked by specialized MPBC solver. Specialized Linear Solver for MPBC on page 240 |

# G: Command File Overview

Math

Table 206 Math{} (Continued)

| Volume | <string> (Table 354...) | (g) Define a volume. Random Band Edge Fluctuations on page 742 |
| --- | --- | --- |
| Wallclock |  | - (g) Report wallclock times rather than CPU times after each step in the simulation. |
| WeightedVoronoiBox |  | off (g) Compute-weighted coefficients and measure. Weighted Box Method Coefficients on page 1141 |

Table 207 AcceptNewtonParameter() Relaxed Newton Method on page 149

| Digits | =<integer> | Number of relative error digits. |
| --- | --- | --- |
| Error ( | Electron=<float> | Absolute error parameter for electrons. |
| eQuantumPotential=<float> | Absolute error parameter for electron quantum potential. |  |
| eTemperature=<float> | Absolute error parameter for electron temperature. |  |
| Hole=<float> | Absolute error parameter for holes. |  |
| hQuantumPotential=<float> | Absolute error parameter for hole quantum potential. |  |
| hTemperature=<float> | Absolute error parameter for hole temperature. |  |
| Poisson=<float> | Absolute error parameter for potential. |  |
| Temperature=<float>) | Absolute error parameter for lattice temperature. |  |
| ErrRef ( | Electron=<float> | cm-3 Reference error parameter for electrons. |
| eQuantumPotential=<float> | V Reference error parameter for electron quantum potential. |  |
| eTemperature=<float> | K Reference error parameter for electron temperature. |  |
| Hole=<float> | cm-3 Reference error parameter for holes. |  |
| hQuantumPotential=<float>) | V Reference error parameter for hole quantum potential. |  |
| ErrRef ( | hTemperature=<float>) | K Reference error parameter for hole temperature. |
| InvokeAtDivergence |  | - Allow relaxed convergence to be considered for diverged solutions. |
| RelErrControl |  | Use relative error control. |
| RhsAndUpdateConvergence |  | Require both RHS and update error convergence. |

1534

**G: Command File Overview**
Math

Table 207 AcceptNewtonParameter() Relaxed Newton Method on page 149 (Continued)

| RhsMin | =<float> | Minimum of RHS norm. |
| --- | --- | --- |
| UpdateScale | =<float> | Additional factor for the update error. |

Table 208 BreakCriteria{} Break Criteria: Conditionally Stopping the Simulation on page 71

| Current ( | absval=<float> | A $\mu$md-3 Upper limit for absolute current value. |
| --- | --- | --- |
| contact=<string> | ! Name of contact with break criterion. |  |
| DevName=<ident> | Identifier of circuit device name (mixed mode only). |  |
| maxval=<float> | A $\mu$md-3 Upper limit for current. |  |
| minval=<float> | A $\mu$md-3 Lower limit for current. |  |
| Node=<ident>) | Identifier of circuit node name (mixed mode only). |  |
| CurrentDensity ( | DevName=<ident> | Identifier of device (mixed mode only). |
| maxval=<float>) | Acm-2 (r) Maximum current density. |  |
| DevicePower \| OuterDevicePower ( | absval=<float> | W $\mu$md-3 Upper limit for absolute power value. |
| DevName=<ident> | Identifier of circuit device name (mixed mode only). |  |
| maxval=<float> | W $\mu$md-3 Upper limit for power value. |  |
| minval=<float>) | W $\mu$md-3 Lower limit for power value. |  |
| ElectricField ( | DevName=<ident> | Identifier of circuit device name (mixed mode only). |
| maxval=<float>) | Vcm-1 (r) Maximum electric field. |  |
| InnerDevicePower | as DevicePower | W $\mu$md-3 Break criteria based on inner device power. |
| LatticeTemperature ( | DevName=<ident> | Identifier of circuit device name (mixed mode only). |
| maxval=<float>) | K (r) Maximum lattice temperature. |  |
| Voltage | as Current | V Voltage break criteria. |

**G: Command File Overview**

Math

Table 209 ComputeCarrierPath() High-Field Entrance Position and Time on page 466

| PathReflection( | closeToContact=<float> | \* 0.0 µm Path is reflected at device boundary. Path search stops when distance to a contact is smaller than specified value (in µm ). |
| --- | --- | --- |
| SaveEPaths ( |  | Save electron paths. |
| list=(<int>...) | List of path indices to be plotted. |  |
| offset=<int> | 0 Shift first plotted path. |  |
| skip=<int> | 0 Number of paths that are omitted for plotting. |  |
| withPlotData) | + Add interpolated plot variables. |  |
| SaveHPaths ( |  | Save hole paths. |
| list=(<int>...) | List of path indices to be plotted. |  |
| offset=<int> | 0 Shift first plotted path. |  |
| skip=<int> | 0 Number of paths that are omitted for plotting. |  |
| withPlotData) | + Add interpolated plot variables. |  |
| startFrom | ="element" \| "vertex" | vertex Path search starts from either the vertex position or the element center position. |
| thresholdField | =<float> | 5e5 V/cm Minimum value of multiplication region. |

Table 210 ComputeIonizationIntegrals() Approximate Breakdown Analysis on page 457

| ComputeAll |  | All elements are taken into initial element list. |
| --- | --- | --- |
| ComputeAtMaxElectricField |  | Element with maximal electric field is taken into initial element list. |
| ComputeAtMaxElectricField( | delta=<float>) | \* 1e4 V/cm All elements where electric field is higher than maximal electric field minus delta are taken into initial element list. |
| Direction | =<string> | ElectricField Direction field used for the geometric path search. |
| MinElectricField | =<float> | 1 V/cm All elements where electric field is higher than MinElectricField are taken into initial element list. |
| PathReflection | (Table 223) | Specification of path reflection options. Path is reflected at device boundary. |
| PathSearchStopDeltaPotential | =<float><float> | 0 V 0 V Electrostatic potential shifts for the path search stop criterion using the electrostatic potential. |
| PathSearchStopField | =<float> | \* 1000 V/cm Threshold value of the absolute value of the electric field where the path search stops. |
| PeriodicBC | (Table 224) | Specification of periodic boundary conditions. |

G: Command File Overview
Math

Table 210 ComputeIonizationIntegrals() Approximate Breakdown Analysis on page 457

| SaveEIonIntegralPaths | =<int> | Number of paths to be stored based on electron ionization integral. Visualizing Breakdown Paths on page 461 |
| --- | --- | --- |
| SaveHIonIntegralPaths | =<int> | Number of paths to be stored based on hole ionization integral. Visualizing Breakdown Paths on page 461 |
| Window | (Table 228) | Specification of geometric shapes for spatial restriction of initial element list. |
| WriteAll |  | Output information for all computed paths. |

Table 211 eQPBox() Density Gradient Model on page 316

| Attenuation_Length | =<float> | 1e-3 µm Length over which the gamma (γ) parameter is effectively attenuated to zero using error function outside the box. |
| --- | --- | --- |
| MaxX | =<float> | 1e30 µm Maximum x-coordinate for quantum box. |
| MinX | =<float> | -1e30 µm Minimum x-coordinate for quantum box. |
| MaxY | =<float> | 1e30 µm Maximum y-coordinate for quantum box. |
| MinY | =<float> | -1e30 µm Minimum y-coordinate for quantum box. |
| MaxZ | =<float> | 1e30 µm Maximum z-coordinate for quantum box. |
| MinZ | =<float> | -1e30 µm Minimum z-coordinate for quantum box. |

Table 212 EquilibriumSolution() Equilibrium Solution on page 181

| Digits | =<float> | Relative error target. |
| --- | --- | --- |
| Iterations | =<0..> | 50 Maximum number of Newton iterations. Convergence and Error Control on page 143 |
| LineSearchDamping | =<(0,1]> | 1 Smallest allowed damping coefficient for line search damping. Damped Newton Iterations on page 145 |
| NotDamped | =<0..> | 1000 (g) Number of iterations in each Newton iteration before Bank–Rose damping is activated. Damped Newton Iterations on page 145 |
| RelErrControl |  | + Use relative error control. Convergence and Error Control on page 143 |

1537

# G: Command File Overview

Math

Table 213 Extrapolate() in Math{}, Quasistationary(), Transient() Extrapolation on page 82

| Algorithm | =1 \| 2 | 1 Switch Algorithm on page 86. |
| --- | --- | --- |
| Exclude | (Table 336) | Exclude Equations on page 84 |
| LowDensityLimit | =<float> | 1e-100 cm-3 Lower limit for carrier density starting from which the appropriate density is extrapolated. |
| MinStep | =<float> | Minimum Step of Extrapolation on page 85 |
| NumberOfFailures | =<int> | 0 Number of Failed Extrapolations on page 86 |
| Order | =<int> | 1 Order of extrapolation in Quasistationary or Transient command. |

Table 214 GrainFieldGenerator() Creating the Grain Field on page 1062

| AverageGrainSize | =<float> | µm Approximate average grain size in Vreg, or Vbox if padding is used. |
| --- | --- | --- |
| AverageGrainSizeVector | = (<ax>, <ay>, <az>) | µm Allow the grain average size to differ in different directions. |
| GrainLocation | = ((<x1>,<y1>,<z1>), (<x2>,<y2>,<z2>), ...) | µm Set specific locations where grains are placed in the region. |
| GrainLocationSize | = ((<sx1>,<sy1>,<sz1>), (<sx2>,<sy2>,<sz2>), ...) | µm Set elliptic radii of grains whose locations are specified with GrainLocation. There must be a one-to-one correspondence between values specified with GrainLocation and GrainLocationSize. |
| MinimumGrainSize | =<float> | µm Set the smallest-allowed distance between grain centers. |
| NumberOfGrains | =<int> | Number of grain centers located within Vreg. |
| Padding | =<float> | Units of AverageGrainSize. Extend extremities of region by a distance of Padding × $a_{gi}$ on all sides before randomizing the grain centers. |
| PoissonDistribution |  | Use the calculated number of grain centers as the expectation value for a Poisson distribution random number generator. |
| RandomSeed | =<int> | 0 Seed used for the random number generator. Using the same (nonzero) seed in subsequent simulations allows the grain generation to be repeated. The default means a new randomization for each simulation. |
| SingleVertexBoundary |  | + Mark only one vertex of edges that cross a Voronoï boundary with a negative index. To mark both vertices on an edge, specify -SingleVertexBoundary. |
| TwoDimensionalGrains |  | Create grains in two dimensions and extrude in the thinnest region dimension. |
| UniformSpatialDistribution |  | Distribute grain centers randomly. |

G: Command File Overview
Math

Table 215 HB{} Harmonic Balance on page 106

| LogDensity |  | – Use logarithm of scaled densities as solution variable. |
| --- | --- | --- |
| LogTemperature |  | – Use logarithm of scaled temperatures as solution variable. |
| MDFT |  | – Use MDFT mode. |
| RhsScale | (Table 336) =<float> | Scaling of RHS in Newton (MDFT and SDFT modes). |
| sdft_update_norm_R |  | + Use update error norm (compatible with Version R-2020.09). |
| SolveSpectrum( | Name=<string>) | Solve spectrum with (mandatory) name. |
| { | (<int>*n)...} | List of spectrum multi-indices. n is the number of tones. Solve Spectrum on page 108 |
| UpdateScale | (Table 336) =<float> | Scaling of update in Newton (MDFT and SDFT modes). |
| ValueMin | (Table 336) =<float> | Lower bound for quantity in time domain (MDFT mode only). |
| ValueVariation | (Table 336) =<float> | Allowed variation of quantity in time domain (MDFT mode only). |

Table 216 hQPBox() Density Gradient Model on page 316

| Attenuation_Length | =<float> | 1e-3 µm Length over which the gamma (γ) parameter is effectively attenuated to zero using error function outside the box. |
| --- | --- | --- |
| MaxX | =<float> | 1e30 µm Maximum x-coordinate for quantum box. |
| MinX | =<float> | -1e30 µm Minimum x-coordinate for quantum box. |
| MaxY | =<float> | 1e30 µm Maximum y-coordinate for quantum box. |
| MinY | =<float> | -1e30 µm Minimum y-coordinate for quantum box. |
| MaxZ | =<float> | 1e30 µm Maximum z-coordinate for quantum box. |
| MinZ | =<float> | -1e30 µm Minimum z-coordinate for quantum box. |

# G: Command File Overview

Math

Table 217 KMC() KMC Simulation Space and Math Settings on page 1053

| ApproximateBessel |  | Specify approximate Bessel function for calculation of InelasticElectrodeToTrapTunneling, InelasticTrapToElectrodeTunneling, and TrapToTrapTunneling(MultiPhonon) tunneling models. Specifying the Approximate Bessel Function on page 1058 |
| --- | --- | --- |
| CellLength | =<float> | 0.0005 µm KMC cell size (for TDDB only). |
| CurrentCompliance( |  | Use current compliance. |
| Contact=<string> | Name of the contact applying current compliance. Default: empty string. |  |
| MaxVal=<float> | Maximum value accepted; it must be positive. Default: not applied. |  |
| MinVal=<float>) | Minimum value accepted; it must be negative. Default: not applied. |  |
| HalfCellOffset |  | on Shift the KMC simulation space by a half-cell length relative to device structure (for TDDB only). |
| IntegrationPoints | =<int> | Set the number of integration points to use with Gauss–Legendre method. Setting the Integration Points on page 1058 |
| MaxCurrent | =<float> | 0 Use maximum current as criterion to stop TDDB calculation. |
| MaxCurrentRatio | =<float> | 0 Use maximum current ratio as criterion to stop TDDB calculation. The current ratio is defined as I(t)/min(I(t') for t'<t). |
| MaxLocation | =(<float>, <float>, <float>) | µm Define KMC simulation space. KMC Simulation Space on page 1054 |
| MaxTrapNumber | =<int> | 0 Use maximum trap number as criterion to stop TDDB calculation. |
| MaxTrapNumberIncrease | =<int> | 0 Each time step allows a maximum number of particles to increase if UseKMCTimeStep is provided. |
| MIMBackAndForthThreshold | =<int> | 2000 Set number of back-and-forth events that occur before rate is adjusted. Adjusting the Calculated Tunneling Rates on page 1058 |
| MIMEventCountCheckPoint | =<int> | 10000 Specify how often the KMC simulator checks for the need to adjust tunneling rates. Adjusting the Calculated Tunneling Rates on page 1058 |
| MinLocation | =(<float>, <float>, <float>) | µm Define KMC simulation space. KMC Simulation Space on page 1054 |

G: Command File Overview
Math

Table 217 KMC() KMC Simulation Space and Math Settings on page 1053 (Continued)

| MoreFrequentRateResets |  | Reset all MIM tunneling rates after each time step. Resetting the Rate More Frequently on page 1057 |
| --- | --- | --- |
| RandomSeed | =<int> | Set random seed. Specifying the Random Seed on page 1055 |
| ReferenceElectrode | =<string> | Specify electrode to use as a reference for distances. |
| ResetElectronFill |  | Reset the fraction of defects filled with electrons. Resetting the Fraction of Defects Filled With Electrons on page 1057 |
| SkipKMC |  | Omit KMC simulation completely. Omitting the KMC Simulation Completely on page 1056 |
| SkipKMCCurrentCheck | =<float> | Omit further calls to KMC simulator for remainder of Sentaurus Device transient ramp. Omitting KMC Simulations Near Steady State on page 1056 |
| SkipKMCNumber | =<int> | Set number of consecutive Sentaurus Device time-steps before omitting KMC. Omitting KMC Simulations Near Steady State on page 1056 |
| TargetParticle( | Filament{i}) | Particles used to determine the time step, which can include `Filament1` to `Filament3`. |
| Trap2ElecMinDist | =<float> | 0.0003 μm Set minimum-allowed defect-to-electrode distance. Setting the Minimum Defect Distances on page 1055 |
| Trap2TrapMinDist | =<float> | 0.0003 μm Set minimum-allowed defect-to-defect distance. Setting the Minimum Defect Distances on page 1055 |
| UseAllCrossings |  | Sample potential across all crossings. Sampling Potential at All Crossings on page 1057 |
| UseKMCTimeStep |  | – KMC simulator determines the time step for the transient calculation using `MaxTrapNumberIncrease` when the trap increases sufficiently fast. |

# G: Command File Overview
Math

Table 218 Linear solvers (Solvers User Guide)

| ILS |  | Parallel, iterative linear solver. Customizable, high accuracy, and parallel performance for all problems. |
| --- | --- | --- |
| MultipleRHS | – Solve linear systems with multiple right-hand sides (only for AC analysis). |  |
| Set=<int>) | Use ILS options from set <int>. |  |
| ParDiSo |  | Parallel, supernodal direct solver. High accuracy and parallel performance for small and medium problems. |
| IterativeRefinement | – Perform up to two iterative refinement steps to improve the accuracy of the solution. |  |
| MultipleRHS | – Solve linear systems with multiple right-hand sides (only for AC analysis). |  |
| NonsymmetricPermutation | + Compute an initial nonsymmetric matrix permutation and scaling, which places large matrix entries on the diagonal. |  |
| RecomputeNonsymmetricPermutation ) | – Compute a nonsymmetric matrix permutation and scaling before each factorization. |  |
| Super |  | Supernodal direct solver. Best accuracy for small problems, not parallelized. |

Table 219 MLDAbox({}) Modified Local-Density Approximation Model on page 324

| MaxX | =<float> | µm Upper x-coordinate of the box. |
| --- | --- | --- |
| MaxY | =<float> | µm Upper y-coordinate of the box. |
| MaxZ | =<float> | µm Upper z-coordinate of the box. |
| MinX | =<float> | µm Lower x-coordinate of the box. |
| MinY | =<float> | µm Lower y-coordinate of the box. |
| MinZ | =<float> | µm Lower z-coordinate of the box. |

Table 220 MVMLDAcontrols() Using the MLDA Model on page 328

| AveDistanceFactor | =<float> | 0.05 Factor that controls computation of an averaged distance from a vertex to the interface for the multivalley MLDA model. |
| --- | --- | --- |
| Load | =<string> | Name of file from which to load energy-dependent data. |
| LoadWithInterpolation | =<string> | Name of file from which to load energy-dependent data, possibly obtained for different mesh. |

**G: Command File Overview**
Math

Table 220 MVMLDAcontrols() Using the MLDA Model on page 328 (Continued)

| MaxDoping4Majority | =<float> | 1e22 cm-3 Maximum doping concentration where the multivalley MLDA model is applied to majority carriers. |
| --- | --- | --- |
| MaxIntDistance | =<float> | 1e-6 cm Distance from the interface up to which the multivalley MLDA model is applied. |
| Save | =<string> | Name of file where to save energy-dependent data. |

Table 221 Nonlocal() Nonlocal Meshes on page 152

| Table 355 |  | (g) Interface that is part of the reference surface. |
| --- | --- | --- |
| Barrier | (Table 354...) | - (g) Regions that form the tunneling barrier. |
| Digits | =<float> | 2 (cgi) Accuracy for nonlocal tunneling currents. Nonlocal Tunneling Parameters on page 778 |
| Direction | =<vector> | (0 0 0) (cgi) If nonzero, suppress the construction of nonlocal mesh lines with a direction more than MaxAngle degrees different from `<vector>`. |
| Discretization | =<float> | 1e100 cm (cgi) Maximum distance between nonlocal mesh points on a nonlocal line. |
| Electrode | =<string> | (g) Electrode that is part of the reference surface. |
| Endpoint |  | (r) Allow nonlocal lines that end in the region. Default is Endpoint for semiconductors; otherwise, -Endpoint. |
|  | (Table 354...) | (g) Regions where nonlocal lines can or cannot end. |
| EnergyResolution | =<(0,)> | 0.005 eV (cgi) Minimum energy resolution for integrals in computation of nonlocal tunneling current. Nonlocal Tunneling Parameters on page 778 |
| Length | =<float> | cm (cgi) Distance from the interface or contact up to which nonlocal mesh lines are constructed. |
| MaxAngle | =<float> | 180 deg (cgi) Suppress construction of nonlocal mesh lines that enclose an angle of more than `<float>` degrees with the vector specified by Direction. |
| Outside |  | + (cgi) Allow nonlocal mesh lines to leave the device. |
| Permeable |  | + (r) Allow extension of nonlocal lines (as specified by the Permeation parameter) into or across the region. |
|  | (Table 354...) | + (g) Regions into or across which nonlocal lines can or cannot be extended. |
| Permeation | =<float> | 0 cm (cgi) Length by which nonlocal mesh lines are extended across the interface or contact. |

# G: Command File Overview
Math

Table 221 Nonlocal() Nonlocal Meshes on page 152 (Continued)

| Refined |  | + (r) Autorefine nonlocal lines inside the region. |
| --- | --- | --- |
| (Table 354...) | + (g) Regions in which nonlocal lines are or are not autorefined. |  |
| Transparent |  | + (r) Allow nonlocal lines crossing the region. |
| (Table 354...) | + (g) Regions that nonlocal lines can or cannot cross. |  |

Table 222 NonlocalPath() in Math{}, Quasistationary(), and Transient() Handling Derivatives on page 481

| Derivative | =<int> | 0: Without derivative computation (default) 1: With derivative computation Handling Derivatives on page 481 |
| --- | --- | --- |
| Direction | =<vector> | Frozen tunneling direction. |
| MaxStep | <float> | (1.0) Higher boundary for step-size control. |
| MinStep | <float> | (1.0e-6) Lower boundary for step-size control. |
| N | =<int> | (3) Number of Newton iterations where Jacobian entries are collected. |
| Postprocessing |  | – Switch on and off postprocessing mode. |
| Strategy | =<int> | Strategy for filling of system Jacobian: 1: Collect all 2: Collect last N (default) 3: Collect last N with step size control |

Table 223 PathReflection() Approximate Breakdown Analysis on page 457

| CloseToContact | =<float> | 0.1 Path search stops when distance to a contact is smaller than specified value (in µm ). |
| --- | --- | --- |
| ReflectAtMaterial | =<string> | Path is reflected at specified material. |
| ReflectAtRegion | =<string> | Path is reflected at specified region. |

Table 224 PeriodicBC() Approximate Breakdown Analysis on page 457

| Direction | =0 \| 1 \| 2 | Direction of periodicity: 0 for x-axis, 1 for y-axis, and 2 for z-axis. |
| --- | --- | --- |
| Coordinates | =(<float>*2)) | µm Coordinate of left and right periodic boundary plane. |
| MaxReflections | =<int> | 5000 Maximum number of periodic path reflections until the path search stops. |

**G: Command File Overview**
Math

Table 225 RandomField() Spatial Correlations and Random Fields on page 747

| AverageGrainSize | =<vector> | µm Average grain size along main axes. |
| --- | --- | --- |
| CorrelationFunction | =Exponential | Use exponential correlations. |
| =Gaussian | Use Gaussian correlations. |  |
| =Grain | \* Use grain-based correlations. |  |
| Lambda | =<vector> | µm Correlation length for main axes |
| MaxInternalPoints | =<int> | 2147483647 Maximum-allowed number of points for Fourier transform. |
| Resolution | =<vector> | (0.25 0.25 0.25) Spatial resolution of exponential and Gaussian randomization. |

Table 226 RandomizedVariation() in Math{} Statistical Impedance Field Method on page 745

| ExtrudeTo3D |  | – For correlated variations, internally extrude 2D structures to three dimensions. |
| --- | --- | --- |
| NumberOfSamples | =<0..> | ! Number of samples. |
| RandomField( | (Table 225) | (g) Declare random field. Spatial Correlations and Random Fields on page 747 |
| Randomize | =<int> | 0 Seed for random number generator. |

Table 227 Transient time-step control Numeric Control of Transient Analysis on page 91

| CheckTransientError |  | off Error control of transient integration method. |
| --- | --- | --- |
| NoCheckTransientError |  | on No error control of transient integration method. |
| TransientDigits | =<float> | 3 Relative accuracy for time-step control. |
| TransientError | (Table 336) =<float> | Absolute error for time-step control. |
| TransientErrRef | (Table 336) =<float> | Error reference for time-step control. |
| TrStepRejectionFactor | =<float> | Factor $f_{rej}$ . Controlling Transient Simulations on page 1157 |

1545

# G: Command File Overview

NoisePlot

Table 228 Window() Approximate Breakdown Analysis on page 457

| Cuboid( | corner1=<vector> | First corner of cuboid. |
| --- | --- | --- |
| corner2=<vector>) | Diagonally opposite corner of cuboid. |  |
| Cylinder( | center1=<vector> | Center of first circular base of cylinder. |
| center2=<vector> | Center of second circular base of cylinder. |  |
| radius=<float>) | Radius of cylinder. |  |
| Sphere( | center=<vector> | Center of sphere. |
| radius=<float>) | Radius of sphere. |  |

# NoisePlot

Table 229 NoisePlot{} Noise Output Data on page 764

| Table 190 | Scalar plot data. |
| --- | --- |
| Table 191/Vector | Vector plot data. |
| AllLNS | All used local noise sources. |
| AllLNVSD | All used local noise voltage spectral densities. |
| AllLNVXVSD | All use local noise voltage cross-correlation spectral densities. |
| GreenFunctions | All used Green's functions and their gradients. |

# NonLocalPlot

Table 230 NonLocalPlot{} Visualizing Data Defined on Nonlocal Meshes on page 154

| Table 190 |  | Scalar data. |
| --- | --- | --- |
| EigenEnergy( |  | Eigenenergies. 1D Schrödinger Equation on page 305 |
| Electron[(Number=<int>)] | Restrict output to [<int> lowest] electron eigensolutions. |  |
| Hole[(Number=<int>)] | Restrict output to [<int> lowest] hole eigensolutions. |  |
| OverlapIntegral |  | Overlap integrals. 1D Schrödinger Equation on page 305 |

G: Command File Overview
OpticalDevice

Table 230 NonLocalPlot{} Visualizing Data Defined on Nonlocal Meshes on page 154

| WaveFunction( |  | Wavefunctions. 1D Schrödinger Equation on page 305 |
| --- | --- | --- |
| Electron[(Number=<int>)] | Restrict output to [<int> lowest] electron eigensolutions. |  |
| Hole[(Number=<int>)]) | Restrict output to [<int> lowest] hole eigensolutions. |  |

# OpticalDevice

See Table 200 on page 1511.

# Physics

Table 231 Physics{} Part II on page 177

| Active( | Type=QuantumWell) | Activate the localized QW model or the nonlocal QW model to use in conjunction with QWLocal or Schroedinger, respectively. |
| --- | --- | --- |
| Affinity | (<ident> [[(Table 358)]](https://example.com/table358)) | (r) Use PMI model <ident> for electron affinity. Electron Affinity on page 1281 |
| AlphaParticle( | Table 276) | (g) Generation by alpha particles. Carrier Generation by Alpha Particles on page 720 |
| AnalyticTEP |  | (g) Analytic expression for thermoelectric power. Thermoelectric Power on page 981 |
| Aniso( | Table 279) | Anisotropic properties. Chapter 28, p. 833 |
| AreaFactor | =<float> | 1 (g) Multiplier for current and heat flux densities at electrodes and thermodes. Reading a Structure on page 9 |
| BarrierLowering |  | off (c) Use barrier lowering for Schottky contact. Barrier Lowering at Schottky Contacts on page 218 |
| ComplexRefractiveIndex( | Table 282) | off (g) Use complex refractive index model. Complex Refractive Index Model on page 640 |
| CondInsulator |  | (r) Turn an insulator into a conductive insulator. Conductive Insulators on page 254 |
| DefaultParametersFromFile |  | Initialize default parameters from parameter files instead of using built-in values. Default Parameters on page 35 |
| DeterministicVariation( | Table 284) | (g) Deterministic variations. Deterministic Variations on page 757 |

# G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| Dipole( |  | (i) Use dipole interface model. Dipole Layer on page 180 |
| --- | --- | --- |
| Reference=<string>) | ! Reference side <string> (either region or material name). |  |
| Discontinuity |  | Create discontinuous interface(s). Discontinuous Interfaces on page 241 |
| DistResist | =<float> | Ωcm2 (i) Distributed resistance at metal–semiconductor or metal–metal interfaces. Resistive Interfaces on page 229 |
| =SchottkyResist | Emulate a Schottky interface. Resistive Interfaces on page 229 |  |
| eBandTailDOS( | Exponent | off (r) Exponential shape band tails. Band Tails on page 279 |
| Gaussian | off (r) Gaussian shape band tails. Band Tails on page 279 |  |
| GaussianFromOrganic | off (r) Gaussian shape band tails as implemented for organic materials. Band Tails on page 279 |  |
| TwoPopulation) | off (r) Two-population model. Band Tails on page 279 |  |
| eBarrierTunneling | <string> [[(Table 236)]](Table 236) | off (g) Nonlocal tunneling from and to conduction band. Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774 |
| EffectiveIntrinsicDensity | (Table 289) | (r) Band gap and bandgap narrowing. Band Gap and Electron Affinity on page 259 |
| EffectiveMass | (GaussianDOS) | (r) Use simplified Gaussian density-of-states model for organic semiconductors. Gaussian Density-of-States for Organic Semiconductors on page 276 |
| (<ident> [[(Table 358)]](Table 358)) | (r) Use PMI model <ident> for effective mass. Effective Mass on page 1277 |  |
| eMLDA | [()] | – (r) MLDA model for electrons. Modified Local-Density Approximation Model on page 324 |
| ( | LambdaTemp) | + (r) Use temperature-dependent λ for both electrons and holes. |
| eMobility( | Table 272) | (r) Electron mobility model. Chapter 15, p. 341 |
| eMultiValley |  | off (r) Multivalley statistics. Multivalley Band Structure on page 281, Multivalley Band Structure on page 899 |

G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| eMultiValley( | DensityIntegral | off (r) Numeric density computation. Using Multivalley Band Structure on page 285 |
| --- | --- | --- |
| kpDOS | off (r) Two-band k · p models for electron Δ2 valleys. Using Multivalley Band Structure on page 285 |  |
| mcDOS | off (r) Monte Carlo DOS. Using Multivalley Band Structure on page 285, Using the MLDA Model on page 328 |  |
| MLDA | off (r) Multivalley MLDA quantization model. Modified Local-Density Approximation Model on page 324, Using Multivalley Band Structure on page 901, Inversion Layer on page 908 |  |
| MLDA(-Nonparabolicity) | off (r) Exclude band nonparabolicity in MLDA model. Using the MLDA Model on page 328 |  |
| Nonparabolicity | off (r) Band nonparabolicity. Nonparabolic Band Structure on page 282 |  |
| parfile | on (r) With `kpDOS`, it adds the parameter file valleys. Using Multivalley Band Structure on page 285 |  |
| RelativeToDOSMass | off (r) Multivalley effective DOS. Using Multivalley Band Structure on page 285 |  |
| ThinLayer) | off (r) Geometric quantization model. Using Multivalley Band Structure on page 285, Using the MLDA Model on page 328 |  |
| EnergyRelaxationTimes | (<ident> [[(Table 358)]](Table 358)]) | Use PMI model <ident> to compute energy relaxation times. Energy Relaxation Times on page 1418 |
| (constant) | Use constant energy relaxation times. |  |
| (formula) | Use the value of `formula` in the parameter file. |  |
| (irrational) | Use the ratio of two irrational polynomials. Energy-Dependent Energy Relaxation Time on page 825 |  |
| eNMP( | Table 291) | (i) Extended nonradiative multiphonon (eNMP) model. Extended Nonradiative Multiphonon Model on page 569 |
| eQCvanDort |  | off (r) van Dort model for electrons. The van Dort Model on page 304 |
| eQuantumPotential | [[(Table 293)]](Table 293)] | – (r) Activate electron density gradient quantum correction. Density Gradient Model on page 316 |
| eQuasiFermi | =<float> | V (r) Initial quasi-Fermi potential specification for electrons. Regionwise Specification of Initial Quasi-Fermi Potentials on page 185 |
| eRecVelocity | =<0,)> | 2.573e6 cms–1 (i) Electron recombination velocity. [Electric Boundary Conditions for Metals on page 250 |

# G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| eSHEDistribution |  | off (r) Specify the region where the electron SHE distribution is calculated. Using Spherical Harmonics Expansion Method on page 806 |
| --- | --- | --- |
| (Table 294) |  |  |
| eThermionic |  | (i) Thermionic emission model for electrons. Conductive Insulators on page 254, Thermionic Emission Current on page 819 |
| (HCI) | (i) Inject hot electrons locally. Destination of Injected Current on page 794 |  |
| (Organic_Gaussian) | (i) Thermionic-like Gaussian emission model at organic heterointerfaces for electrons. Gaussian Transport Across Organic Heterointerfaces on page 822 |  |
| ExternalBoltzmannSolver | <string> () | (g) Connection to external Boltzmann solver. External Boltzmann Solver on page 314 |
| ExternalSchroedinger | <string> (Table 296) | (g) Connection to external 2D Schrödinger solver. External 2D Schrödinger Solver on page 312 |
| FEPolarization | (Table 151) | Ferroelectric polarization model. Ginzburg–Landau–Khalatnikov Equation on page 860 |
| Fermi |  | off (g) Fermi statistics. Fermi Statistics on page 182 |
| (-WithJoyceDixon) | (g) Fermi statistics with old Wuensche approximation for Fermi integrals. Fermi Statistics on page 182 |  |
| FloatCoef | =<float> | 0 (g) Interpolation coefficient for initial guess in floating wells. Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells on page 184 |
| GateCurrent( | Table 297) | (i) Gate currents (hot-carrier injection, some of the tunneling models). |
| GaussianDOS_full |  | (r) Use Gaussian density-of-states model for organic semiconductors. Gaussian Density-of-States for Organic Semiconductors on page 276 |
| hBandTailDOS( | Exponent | off (r) Exponential shape band tails. Band Tails on page 279 |
| Gaussian | off (r) Gaussian shape band tails. Band Tails on page 279 |  |
| GaussianFromOrganic | off (r) Gaussian shape band tails as implemented for organic materials. Band Tails on page 279 |  |
| TwoPopulation) | off (r) Two-population model. Band Tails on page 279 |  |
| hBarrierTunneling | <string> ([Table 236)] | off (g) Nonlocal tunneling from and to valence band. Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774 |
| HeatCapacity( | Table 302) | (r) Heat capacity. |

G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| HeatPreFactor | =<float> | 1. (r) Scaling factor for lattice heat generation. Scaling of Lattice Heat Generation on page 208 |
| --- | --- | --- |
| HeatSource( | <ident>) | Name of the PMI model. |
| HeavyIon( | Table 277 | off (g) Generation by heavy ions. Carrier Generation by Heavy Ions on page 722 |
| HeteroInterface |  | (i) Double points at interfaces. Abrupt and Graded Heterojunctions on page 11 |
| hMLDA( | [()] | – (r) MLDA model for holes. Modified Local-Density Approximation Model on page 324 |
| LambdaTemp) | + (r) Use temperature-dependent λ for both electrons and holes. |  |
| hMobility( | Table 272 | (r) Hole mobility model. Chapter 15, p. 341 |
| hMultiValley |  | off (r) Multivalley statistics. Multivalley Band Structure on page 281, Multivalley Band Structure on page 899 |
| hMultiValley( | DensityIntegral | off (r) Numeric density computation. Using Multivalley Band Structure on page 285 |
| kpDOS | off (r) Six-band k · p model for hole bands. Multivalley Band Structure on page 281 |  |
| mcDOS | off (r) Monte carlo DOS. Using Multivalley Band Structure on page 285, Using the MLDA Model on page 328 |  |
| MLDA | off (r) Multivalley MLDA quantization model. Modified Local-Density Approximation Model on page 324, Using Multivalley Band Structure on page 901 |  |
| MLDA(-Nonparabolicity) | off (r) Exclude band nonparabolicity in MLDA. Using the MLDA Model on page 328 |  |
| Nonparabolicity | off (r) Band nonparabolicity. Nonparabolic Band Structure on page 282 |  |
| parfile | on (r) With kpDOS, it adds the parameter file valleys. Using Multivalley Band Structure on page 285 |  |
| RelativeToDOSMass | off (r) Multivalley effective DOS. Using Multivalley Band Structure on page 285 |  |
| ThinLayer) | off (r) Geometric quantization model. Using Multivalley Band Structure on page 285, Using the MLDA Model on page 328 |  |
| hQCvanDort |  | off (r) van Dort model for holes. The van Dort Model on page 304 |
| hQuantumPotential | [[Table 293]](Table 293) | – (r) Activate hole density gradient quantum correction. Density Gradient Model on page 316 |

# G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| hQuasiFermi | =<float> | V (r) Initial quasi-Fermi potential specification for holes. Regionwise Specification of Initial Quasi-Fermi Potentials on page 185 |
| --- | --- | --- |
| hRecVelocity | =<0,)> | 1.93e6 cms-1 (i) Hole recombination velocity. [Electric Boundary Conditions for Metals on page 250 |
| hSHEDistribution |  | off (r) Specify the region where the hole SHE distribution is calculated. Using Spherical Harmonics Expansion Method on page 806 |
| (Table 294) |  |  |
| hThermionic |  | (i) Thermionic emission model for holes. Conductive Insulators on page 254, Thermionic Emission Current on page 819 |
| (HCI) | (i) Inject hot holes locally. Destination of Injected Current on page 794 |  |
| (Organic_Gaussian) | (i) Thermionic-like Gaussian emission model at organic heterointerfaces for holes. Gaussian Transport Across Organic Heterointerfaces on page 822 |  |
| Hydrodynamic | [()] | (g) Hydrodynamic model for electrons and holes. Hydrodynamic Model for Current Densities on page 192, Hydrodynamic Model for Temperatures on page 204 |
| (eTemperature) | (g) Hydrodynamic model for electrons only. Hydrodynamic Model for Current Densities on page 192, Hydrodynamic Model for Temperatures on page 204 |  |
| (hTemperature) | (g) Hydrodynamic model for holes only. Hydrodynamic Model for Current Densities on page 192, Hydrodynamic Model for Temperatures on page 204 |  |
| HydrogenDiffusion |  | off (ri) Hydrogen transport model without reaction or hydrogen type specification. Using MSC–Hydrogen Transport Degradation Model on page 562 |
| (Table 304) | off (ri) Hydrogen transport model with reaction or hydrogen type specification. Using MSC–Hydrogen Transport Degradation Model on page 562 |  |
| IncompleteIonization( | Table 306 | Incomplete ionization. Chapter 13, p. 293 |
| KMC_MIM_Transport( | Table 243 | Tunneling processes for KMC-MIM simulations. Tunneling Processes on page 1064 |
| LatticeTemperatureLimit | =<float> | K Maximum lattice temperature. Break Criteria: Conditionally Stopping the Simulation on page 71 |

**G: Command File Overview**
Physics

Table 231 Physics{} Part II on page 177 (Continued)

| LayerThickness ( |  | off Thickness extraction command. Extracting Layer Thickness on page 333 |
| --- | --- | --- |
| ChordWeight=<float> | 0 Weight of chord length. Thickness Extraction on page 336 |  |
| MaxFitWeight=<float> | 0 Thickness Extraction on page 336 |  |
| MinAngle=(<float>*2) | 0 0 Angle constraints. Thickness Extraction on page 336 |  |
| Thickness=<float>) | μm Explicit thickness value. |  |
| LED( | Table 265) | Activate LED framework. |
| MagneticField | =<vector> | T (g) Magnetic field. Chapter 32, p. 965 |
| Mechanics( | Table 307) | (g) Mechanical stress solver. Mechanics Solver on page 957 |
| MetalResistivity( | <ident> ([Table 358)]) | PMI for metal resistivity. Metal Resistivity on page 1395 |
| MetalWorkfunction( | Table 308) | (r) Metal workfunction. Metal Workfunction on page 252 |
| Mobility( | Table 272) | (r) Mobility model. Chapter 15, p. 341 |
| MoleFraction( | Table 310) | Mole fractions. Mole-Fraction Specification on page 17 |
| MSConfigs( | MSConfig (Table 311...)...) | (r) Multistate configurations. Specifying Multistate Configurations on page 529 |
| MSDistResist | =<float> | Ωcm2 (i) Distributed resistance at metal–semiconductor interface. Resistive Contacts on page 223 |
| =SchottkyResist | Emulate a Schottky interface. Resistive Contacts on page 223 |  |
| MSPeltierHeat |  | (i) Peltier heat at metal–semiconductor interfaces or semiconductor contacts. Heating at Contacts, Metal–Semiconductor and Conductive Insulator–Semiconductor Interfaces on page 984 |
| MultiValley |  | off (r) Multivalley statistics. Multivalley Band Structure on page 281, Multivalley Band Structure on page 899 |

1553

# G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| MultiValley( | DensityIntegral | off (r) Numeric density computation. Using Multivalley Band Structure on page 285 |
| --- | --- | --- |
| kpDOS | off (r) k · p model for electrons and holes. Using Multivalley Band Structure on page 285 |  |
| MLDA | off (r) Multivalley MLDA quantization model. Modified Local-Density Approximation Model on page 324, Using Multivalley Band Structure on page 901, Inversion Layer on page 908 |  |
| MLDA(-Nonparabolicity) | off (r) Exclude band nonparabolicity in MLDA. Using the MLDA Model on page 328 |  |
| Nonparabolicity | off (r) Band nonparabolicity. Nonparabolic Band Structure on page 282 |  |
| parfile | on (r) With kpDOS, it adds the parameter file valleys. Using Multivalley Band Structure on page 285 |  |
| RelativeToDOSMass) | off (r) Multivalley effective DOS. Using Multivalley Band Structure on page 285 |  |
| NBTI( | Table 312 | (i) NBTI degradation model. Two-Stage NBTI Degradation Model on page 564 |
| Noise | [<string>] (Table 313) | (r) Noise sources. Noise Sources on page 734 |
| OpticalAbsorptionHeat( | ScalingFactor=<float> | 1 Optical Absorption Heat on page 994 |
| Table 259 | Optical Absorption Heat on page 994 |  |
| Optics( | Table 315 | Specifying the Type of Optical Generation Computation on page 594 |
| Piezo( | Table 317 | (r) Stress and strain models. Using Stress and Strain on page 887 |
| Piezoelectric_Polarization | (<ident> ([Table 358)]) | Use PMI model <ident> to compute piezoelectric polarization. Piezoelectric Polarization on page 1347 |
| (strain) | Use strain model to compute piezoelectric polarization. Strain Model on page 950 |  |
| (stress) | Use stress model to compute piezoelectric polarization. Stress Model on page 951 |  |

G: Command File Overview
Physics

Table 231 Physics{} Part II on page 177 (Continued)

| Polarization |  | off (r) Use ferroelectric model. Chapter 29, p. 855 |
| --- | --- | --- |
| (initialvector=<vector>) | (0,0,0) Initial polarization vector for starting the simulation. Using Ferroelectrics on page 855 |  |
| (Memory=<2..>) | 10 Maximum nesting of minor loops. Using Ferroelectrics on page 855 |  |
| (SurfaceReconstruction) | off (r) Improved algorithm for calculating the directional polarization. Using Ferroelectrics on page 855 |  |
| PostTemperature |  | (g) Use simplified self-heating model. Uniform Self-Heating on page 198 |
| \* Compute dissipated power as integral of Joule heat over entire device. |  |  |
| (IV_diss) | (g) Compute dissipated power as $\sum IV$ over all electrodes. |  |
| (IV_diss(<string>...)) | (g) Compute dissipated power as $\sum IV$ over user-selected electrodes. |  |
| QWLocal( | Table 250 | Localized QW model parameters. Localized Quantum-Well Model on page 1044 |
| Radiation( | Table 278 | Radiation model. Chapter 22, p. 719 |
| RandomizedVariation | <string> (Table 319) | (g) Set sIFM models. Statistical Impedance Field Method on page 745 |
| RayTraceBC( | Table 252 | Physics material or region interface–based definition of boundary conditions. Boundary Condition for Raytracing on page 660 |
| RecGenHeat ( |  | (g) Generation–recombination processes act as heat sources. Hydrodynamic Model for Temperatures on page 204 |
| OptGenOffset=<float> | 0.5 Divide contribution of optical generation rate into energy gain/loss terms $H_n$ and $H_p$. Hydrodynamic Model for Temperatures on page 204 |  |
| OptGenWavelength= <float>) | $\mu$m Wavelength if optical generation is loaded from file. Hydrodynamic Model for Temperatures on page 204 |  |
| Recombination( | Table 232 | Generation–recombination model. Chapter 16, p. 419 |
| Schottky |  | off (i) Use Schottky boundary conditions. Electric Boundary Conditions for Metals on page 250 |
| Schroedinger | (Table 320) | (i) Schrödinger solver. 1D Schrödinger Equation on page 305 |
| <string> (Table 320) | (g) Schrödinger solver on named nonlocal mesh. |  |

# G: Command File Overview

Physics

Table 231 Physics{} Part II on page 177 (Continued)

| SingletExciton ( |  | off (ri) Activate region or interface for singlet exciton equation. |
| --- | --- | --- |
| FluxBC | off (i) Impose a zero flux boundary condition on specified interface. Using the Singlet Exciton Equation on page 247 |  |
| BarrierType(Table 281) | (i) Set the barrier type at organic heterointerface. Using the Singlet Exciton Equation on page 247 |  |
| Recombination(Table 254)) | off (r) Switch on generation and recombination terms in singlet exciton equation. Using the Singlet Exciton Equation on page 247 |  |
| TATNonlocalPathNC | =<float> | cm–3 (i) Room temperature effective density-of-states NC for electron trap-assisted tunneling from Schottky contacts or Schottky metal–semiconductor interfaces. Using the Dynamic Nonlocal Path Trap-Assisted Tunneling Model on page 430 |
| Temperature | =<float> | 300 K (g) Device (lattice) temperature. |
| TEPower | (<string>) | (gr) Use PMI to compute thermoelectric power. Using Thermoelectric Power on page 983 |
| (Analytic) | (gr) Use analytic thermoelectric power. Using Thermoelectric Power on page 983 |  |
| ThermalConductivity( | Table 323) | (r) Thermal conductivity. |
| Thermionic |  | (i) Thermionic emission model for electrons and holes. Conductive Insulators on page 254, Thermionic Emission Current on page 819 |
| (HCI) | (i) Inject hot carriers locally. Destination of Injected Current on page 794 |  |
| (Organic_Gaussian) | (i) Thermionic-like Gaussian emission model at organic heterointerfaces. Gaussian Transport Across Organic Heterointerfaces on page 822 |  |
| Thermodynamic |  | off (g) Thermodynamic transport model. Thermodynamic Model for Current Densities on page 191, Thermodynamic Model for Lattice Temperature on page 201 |
| Traps(( | Table 325)...) | Traps. Chapter 17, p. 489 |
| TTOM( | NumberOfSamples=<int>) | (i) Transient trap occupancy model. Transient Trap Occupancy Model on page 585 |

G: Command File Overview
Physics

# Generation and Recombination

Table 232 Recombination() Chapter 16, p. 419

| <ident> | [ (Table 358) ] | Use PMI model <ident>. Generation–Recombination on page 1224 |
| --- | --- | --- |
| Auger |  | off (r) Auger recombination. Auger Recombination Model on page 436 |
| (WithGeneration) | off (r) Auger recombination and generation. |  |
| Avalanche ( | Table 233) | off (r) Impact ionization. Avalanche Generation on page 441 |
| Band2Band ( | Table 234) | off (r) Band-to-Band Tunneling Models on page 469 |
| CDL ( | Table 258) | off (r) Coupled defect level recombination. Coupled Defect Level Recombination on page 433 |
| ConstantCarrierGeneration | (value=<float>) | off (r) Constant carrier generation. Constant Carrier Generation Model on page 440 |
| eAvalanche ( | Table 233) | off (r) Electron impact ionization. Avalanche Generation on page 441 |
| hAvalanche ( | Table 233) | off (r) Hole impact ionization. Avalanche Generation on page 441 |
| intrinsicRichter |  | off (r) Extended recombination model for silicon, covering Auger and radiative recombination. Intrinsic Recombination Model for Silicon on page 437 |
| Radiative |  | – (r) Radiative recombination. Radiative Recombination Model on page 435 |
| SRH ( | Table 258) | off (r) Shockley–Read–Hall recombination. Shockley–Read–Hall Recombination on page 419 |
| SurfaceSRH |  | off (i) Interface Shockley–Read–Hall recombination. Surface SRH Recombination Model on page 432 |
| TrapAssistedAuger |  | off (r) Trap-assisted Auger recombination. Trap-Assisted Auger Recombination Model on page 431 |

Table 233 Avalanche() Avalanche Generation on page 441

| <ident> [ (Table 358) ] | Use PMI model <ident>. Avalanche Generation on page 1217 |
| --- | --- |
| BandgapDependence | – Include a dependency on the energy bandgap in the avalanche generation models. Using Avalanche Generation on page 441 |

# G: Command File Overview

Physics

Table 233 Avalanche() Avalanche Generation on page 441 (Continued)

| CarrierTempDrive | Use temperature driving force (default for hydrodynamic simulation). Avalanche Generation With Hydrodynamic Transport on page 456 |
| --- | --- |
| ElectricField | Use plain electric field driving force. Approximate Breakdown Analysis on page 457 |
| Eparallel | Use current-parallel electric field driving force. Driving Force on page 455 |
| GradQuasiFermi | \* Use gradient quasi-Fermi potential driving force. For hydrodynamic simulation, default is CarrierTempDrive. Driving Force on page 455 |
| Hatakeyama | Use Hatakeyama model. Hatakeyama Avalanche Model on page 451 |
| Lackner | Use Lackner model. Lackner Model on page 446 |
| Okuto | Use Okuto–Crowell model. Okuto–Crowell Model on page 445 |
| UniBo | Use University of Bologna model. University of Bologna Impact Ionization Model on page 447 |
| UniBo2 | Use new University of Bologna impact ionization model. New University of Bologna Impact Ionization Model on page 449 |
| vanOverstraeten | \* Use van Overstraeten model. van Overstraeten – de Man Model on page 444 |

Table 234 Band2Band() Band-to-Band Tunneling Models on page 469

| DensityCorrection | =Local | Use density correction. Schenk Density Correction on page 472 |
| --- | --- | --- |
| =None | \* Use plain densities. Schenk Density Correction on page 472 |  |
| FranzDispersion |  | – Use Franz dispersion in the direct nonlocal path model. Using the Nonlocal Path Band-to-Band Tunneling Model on page 479 |
| InterfaceReflection |  | + Consider interface reflection in the nonlocal path model. Using Band-to-Band Tunneling on page 469 |
| Model | =E1 | Use simple model with $P = 1$. Simple Band-to-Band Tunneling Models on page 475 |
| =E1_5 | Use simple model with $P = 1.5$. Simple Band-to-Band Tunneling Models on page 475 |  |
| =E2 | Use simple model with $P = 2$. Simple Band-to-Band Tunneling Models on page 475 |  |
| =Hurkx | Use Hurkx model. Hurkx Band-to-Band Tunneling Model on page 473 |  |
| =modifiedHurkx | Use modified Hurkx model. Modified Hurkx Band-to-Band Tunneling Model on page 474 |  |
| =NonlocalPath | Use nonlocal path model. Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475 |  |
| =Schenk | Use Schenk model. Schenk Band-to-Band Tunneling Model on page 471 |  |

**G: Command File Overview**
Physics

Table 234 Band2Band() Band-to-Band Tunneling Models on page 469 (Continued)

| ParameterSetName | =(<string>...) | Named parameter sets to be used. Using Band-to-Band Tunneling on page 469 |
| --- | --- | --- |

Table 235 BPM() Beam Propagation Method on page 702

| Bidirectional( | Error=<float> | ! Relative error used as a break criterion for iterative algorithm in bidirectional beam propagation method. |
| --- | --- | --- |
| Iterations=<int>) | ! Maximum number of iterations used as a break criterion for iterative algorithm in bidirectional beam propagation method. |  |
| Boundary( | GridNodes=<float>*2 | ! Number of PML boundary grid nodes to be inserted at left and right sides. |
| Order=<1..2> | ! Order of spatial variation of complex stretching parameter. |  |
| Side=<string> | ! "X", "Y", or "Z". |  |
| StretchingParameterImag=(<float>*2) | ! Minimum and maximum values of imaginary part of stretching parameter. |  |
| StretchingParameterReal=(<float>*2) | ! Minimum and maximum values of real part of stretching parameter. |  |
| Type="PML" | ! Use PML boundary conditions. |  |
| VacuumGridNodes=(<float>*2)) | ! Number of vacuum grid nodes to be inserted at left and right sides. |  |
| Excitation( | CenterGauss=<vector> | μm Gaussian center. Size of vector is $d - 1$ . |
| SigmaGauss=<vector> | μm Gaussian half width. Size of vector is $d - 1$ . |  |
| TruncationPositionX=(<float>*2) | Left and right truncation positions of plane wave for x-axis. |  |
| TruncationPositionY=(<float>*2) | Left and right truncation positions of plane wave for y-axis. |  |
| TruncationSlope=<vector> | Plane-wave truncation slope. Size of vector is $d - 1$ . |  |
| Type="Gaussian" | Use Gaussian excitation. |  |
| Type="PlaneWave") | Use truncated plane wave excitation. |  |
| GridNodes | =<vector> | ! Number of grid nodes in each spatial dimension. |

1559

# G: Command File Overview

Physics

Table 235 BPM() Beam Propagation Method on page 702 (Continued)

| ReferenceRefractiveIndex | =<float> | ! Value for reference refractive index. General on page 704 |
| --- | --- | --- |
| =average | Use average refractive index in propagation plane as reference refractive index. |  |
| =fieldweighted | Use field-weighted refractive index in propagation plane as reference refractive index. |  |
| =maximum | Use maximum refractive index in propagation plane as reference refractive index. |  |
| ReferenceRefractiveIndexDelta | =<float> | ReferenceRefractiveIndexDelta is added to ReferenceRefractiveIndex in the calculation. To be used for fine-tuning the numerics. General on page 704 |

Table 236 eBarrierTunneling() and hBarrierTunneling() Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774

| Band2Band | =None | \* No band-to-band tunneling. |
| --- | --- | --- |
| =Full | Include band-to-band tunneling with consistent parallel momentum integral with the direct nonlocal path band-to-band tunneling model. |  |
| =Simple | Include band-to-band tunneling with simple parallel momentum integral. |  |
| =UpsideDown | Include band-to-band tunneling with nonphysical parallel momentum integral. |  |
| BandGap |  | – Allow tunneling into the band gap at the interface for which tunneling is specified. Use this option for backward compatibility only. |
| BarrierLowering |  | – Apply a position-dependent barrier lowering for tunneling barrier. |
| Multivalley |  | – Use multivalley band structure. Band-to-Band Contributions to Nonlocal Tunneling Current on page 788 |
| PeltierHeat |  | – Include Peltier heating terms for tunneling carriers. Eq. 820, p. 790 |
| Schroedinger |  | – Schrödinger equation–based model instead of WKB for tunneling probabilities. This option does not work with the TwoBand or Band2Band option. Schrödinger Equation–Based Tunneling Probability on page 784 |
| Transmission |  | – Use additional interface transmission coefficients. Eq. 809, p. 782 |
| TwoBand |  | – Use two-band dispersion relation. Eq. 808, p. 781 |

**G: Command File Overview**
Physics

Table 237 ElectricField() in SRH() and CDL() SRH Field Enhancement on page 424

| DensityCorrection | =Local | (r) Use density correction. Density Correction for the Schenk and Hurkx Trap-Assisted Tunneling Models on page 427 |
| --- | --- | --- |
| =None | \* (r) Use local densities. |  |
| Lifetime | =Constant | \* (r) No field-enhanced lifetime. |
| =Hurkx | (r) Use Hurkx model for lifetime enhancement. Hurkx Trap-Assisted Tunneling Model on page 426 |  |
| =Schenk | (r) Use Schenk model for lifetime enhancement. Schenk Trap-Assisted Tunneling Model on page 425 |  |

Table 238 Farfield(...) in Physics{Optics(OpticalSolver(RayTracing(...)))} Far Field andSensors for Raytracing on page 675

| Origin | =Auto | Automatically compute origin as the center of the device. Auto is the default. |
| --- | --- | --- |
| =<vector> | User-specified origin as a vector in micrometers. |  |
| Discretization | =<int> | Default is 360 for two dimensions, and 36 for three dimensions. |
| ObservationRadius | =<float> | Radius in micrometers. Default is 1e6 μm , that is, 1 m. |
| Sensor( | Table 256 | Specify a sensor detector. |
| SensorSweep( | Table 257 | Specify sensor sweep. |

Table 239 FDTD() Specifying the Optical Solver on page 614

| GenerateMesh | Control of tensor mesh generation using Sentaurus Mesh. |  |
| --- | --- | --- |
| ( | ForEachWavelength | Generate tensor mesh whenever the wavelength changes compared with the previous FDTD solution. |
| Once | Generate tensor mesh once at the beginning of the simulation. |  |
| Wavelength=(<float>*<0..m>) ) | Specify list of strictly monotonically increasing wavelengths between which the tensor mesh is generated only once. |  |

# G: Command File Overview

Physics

Table 240 FromFile() Loading Solution of Optical Problem From Files on page 695 and Controlling Interpolation When Loading Optical Generation Profiles on page 714

| DatasetName | =AbsorbedPhotonDensity \| OpticalGeneration | AbsorbedPhotonDensity Name of dataset to be loaded from file. |
| --- | --- | --- |
| GridInterpolation | =Conservative \| Simple | Interpolation algorithm to be used if source and destination grid are different. |
| IdentifyingParameter | =(<string>...) | ! Name of identifying parameters or parameter paths. |
| ImportDomain( | Table 241) | Specify source and destination regions as well as domain truncation for interpolation. |
| ProfileIndex | =<int> | 0 ID of loaded profiles after sorting with respect to leading IdentifyingParameter. |
| ShiftVector | =<vector> | (0,0,0) Displacement of source grid. |
| SpectralInterpolation | =Linear \| Off \| PiecewiseConstant | Off Type of interpolation between loaded profiles. |
| WeightedAPDIntegrationlayers | =<int> | Default is the number of regions with a limit of 20. However, you can choose a higher number. Accurate Absorbed Photon Density for 1D Optical Solvers on page 637 |
| WeightedAPDIntegrationSetBoundaries | =(<float>...) | Specifies the boundaries of layers measured from the illumination window in propagation direction. |

Table 241 ImportDomain() Controlling Interpolation When Loading Optical Generation Profiles on page 714

| DestinationBoxCorner1 | =<vector> | (-Inf, -Inf, -Inf) Lower-left corner of box in destination grid used to restrict interpolation domain. |
| --- | --- | --- |
| DestinationBoxCorner2 | =<vector> | (Inf, Inf, Inf) Upper-right corner of box in destination grid used to restrict interpolation domain. |
| DestinationRegions | =(<string>...) | Regions in destination grid selected for interpolation. |
| SourceBoxCorner1 | =<vector> | (-Inf, -Inf, -Inf) Lower-left corner of box in source grid used to restrict interpolation domain. |
| SourceBoxCorner2 | =<vector> | (Inf, Inf, Inf) Upper-right corner of box in source grid used to restrict interpolation domain. |
| SourceRegions | =(<string>...) | Regions in source grid selected for interpolation. |

**G: Command File Overview**

Physics

Table 242 KMCDefects() Chapter 37, p. 1107

| Diffusion(Particle{i}( |  | Diffusion event for specified particle. |
| --- | --- | --- |
| Dipole=<float> | Dipole. |  |
| Ea=<float> | Activation energy. |  |
| Frequency=<float>)) | Maximum rate of diffusion. |  |
| Filament{i}( |  | Particles defined by keywords Filament1 to Filament3 are conductive particles and are considered in the conductance equation. |
| Exclude=<float> | List of excluded particles. |  |
| Name=<string> | Name of the particle. |  |
| ShareCapacity=<float> | List of particle sharing capacities. |  |
| FilamentGrowth(Filament{i}( |  | Filament growth of Filament{i} from Particle{j}. |
| Dipole=<float> | Dipole. |  |
| Ea=<float> | Activation energy. |  |
| Frequency=<float> | Maximum rate of diffusion. |  |
| Particle{j})) | Specify particle. |  |
| FilamentRecession(Filament{i}( |  | Filament recession of Filament{i} to Particle{j}. |
| Dipole=<float> | Dipole. |  |
| Ea=<float> | Activation energy. |  |
| Frequency=<float> | Maximum rate of diffusion. |  |
| Particle{j})) | Specify particle. |  |
| FilamentSeeds( |  | Seeds of filament. Filament growth starts at seeds. |
| Filament{i}) | Filament seeds for Filament{iWW}. |  |
| FrenkelPair{i}( |  | Frenkel pair involved in the generation or recombination process. |
| Filament{i}(region=<string>) | Filament in Frenkel pair; region can be specified if at interface. |  |
| Particle{i}(region=<string>) | Particle in Frenkel pair; region can be specified if at interface. |  |
| SameSite) | Two particles are at the same location (for bulk generation or recombination only). |  |

# G: Command File Overview

Physics

Table 242 KMCDefects() Chapter 37, p. 1107 (Continued)

| Generation(FrenkelPair{i}( |  | Generation event for FrenkelPair{i}. |
| --- | --- | --- |
| Dipole=<float> | Dipole. |  |
| Ea=<float> | Activation energy. |  |
| Frequency=<float>)) | Maximum rate of diffusion. |  |
| Particle{i}( |  | Definition of particle type. Sentaurus Device supports three different types of particle and filament. |
| Exclude=<float> | List of excluded particles. |  |
| Name=<string> | Name of the particle. |  |
| ShareCapacity=<float>) | List of particle sharing capacities. |  |
| Recombination(FrenkelPair{i}( |  | Recombination event for FrenkelPair{i}. |
| Dipole=<float> | Dipole. |  |
| Ea=<float> | Activation energy. |  |
| Frequency=<float>)) | Maximum rate of diffusion. |  |

Table 243 KMC_MIM_Transport() Tunneling Processes on page 1064

| AvgOccupancyInMIMCharge |  | Use average occupancy associated with a defect for electron charge. Average Electron Occupancy in the MIM Charge on page 1075 |
| --- | --- | --- |
| ConductanceEquation |  | Switched on only when TDDB specified. Time-Dependent Dielectric Breakdown Simulations on page 1080 |
| ConductivePathCurrent |  | Specify conductive path current (CPC) analysis. Conductive Path Current Analysis on page 1077 |
| ConductiveRadius | =<float> | Influence radius of defects. The conductivity within this radius will have high conductance defined by parameter file. |
| DeltaTrapPotential |  | Use a field-independent capture coefficient $c_0$ in calculations. Inelastic Electrode-to-Trap and Trap-to-Electrode Tunneling on page 1068 |
| DirectTunneling |  | Select direct tunneling. Direct Tunneling on page 1065 |
| ElasticElectrodeToTrapTunneling |  | Select elastic electrode-to-trap tunneling. Elastic Electrode-to-Trap and Trap-to-Electrode Tunneling on page 1067 |
| ElasticTrapToElectrodeTunneling |  | Select elastic trap-to-electrode tunneling. Elastic Electrode-to-Trap and Trap-to-Electrode Tunneling on page 1067 |
| ElasticUsePZeroSZero |  | Use elastic tunneling rates based on inelastic expressions. Option for Elastic Tunneling on page 1068 |

G: Command File Overview

Physics

Table 243 KMC_MIM_Transport() Tunneling Processes on page 1064 (Continued)

| EnergyDependentMass |  | Select to account for energy-dependent mass. Energy-Dependent Mass on page 1073 |
| --- | --- | --- |
| HeatEquation |  | Switched on only when TDDB specified. Time-Dependent Dielectric Breakdown Simulations on page 1080 |
| ImageChargeBarrierLowering |  | Select to account for image charge barrier lowering. Image Charge Barrier Lowering on page 1073 |
| IncludeMIMChargeInPoisson |  | Include defect and electron charge in solution of Poisson equation. Including the MIM Charge in the Poisson Equation on page 1074 |
| InelasticElectrodeToTrapTunneling |  | Select inelastic electrode-to-trap tunneling. Inelastic Electrode-to-Trap and Trap-to-Electrode Tunneling on page 1068 |
| InelasticIgnorePMinus |  | Ignore $p < 0$ terms in inelastic tunneling expressions. Options for Inelastic Tunneling on page 1070 |
| InelasticIncludePZero |  | Include $p = 0$ term in inelastic tunneling expressions. Options for Inelastic Tunneling on page 1070 |
| InelasticPZeroOnly |  | Use only $p = 0$ term in inelastic tunneling expressions. Options for Inelastic Tunneling on page 1070 |
| InelasticTrapToElectrodeTunneling |  | Select inelastic trap-to-electrode tunneling. Inelastic Electrode-to-Trap and Trap-to-Electrode Tunneling on page 1068 |
| KmcReram |  | Trigger KMC calculation. |
| PooleFrenkelEmission |  | Select Poole–Frenkel emission. Poole–Frenkel Emission on page 1066 |
| PrintCPCPaths |  | Print information about paths used in CPC calculation. Conductive Path Current Analysis on page 1077 |
| PrintCPCRates |  | Print information about rate calculations used in CPC calculation. Conductive Path Current Analysis on page 1077 |
| PrintDefectOccupancy |  | Print a defect summary, including occupancy and energy to log file and standard output. Occupancy and Energy on page 1089 |
| PrintMIMEventStatistics |  | Print MIM event statistics to standard output. Event Statistics on page 1089 |
| PrintMIMRates |  | Print calculated tunneling rates to log file and standard output. Tunneling Rates on page 1090 |
| PrintRECRates |  | Print tunnel rates calculated by specifying `RateEquationCurrent`. Rate Equation Current Calculation on page 1076 |

# G: Command File Overview

Physics

Table 243 KMC_MIM_Transport() Tunneling Processes on page 1064 (Continued)

| RateEquationCurrent |  | Invoke solution of rate equations for a system of defects and selected tunneling models. Rate Equation Current Calculation on page 1076 |
| --- | --- | --- |
| SensitivityAnalysis |  | Specify sensitivity analysis. Sensitivity Analysis on page 1077 |
| ( | EtRange= (<float>, <float>, <float>) | eV Specify start, end, and step size for defect energy levels. |
| PlotType=1 \| 2 \| 3 | 1 Set type of plot for Sentaurus Visual to generate. Options are: * 1: Plot absolute energy versus $X_t$ (flat band). * 2: Plot absolute energy versus $X_t$ (bias included). * 3: Plot $E_t$ versus $X_t$. |  |
| Point= (<float>, <float>, <float>) | (0, 0, 0) µm Specify path for defect locations. |  |
| PrintAll | Print leakage values for all ($X_t$, $E_t$) pairs to log file. |  |
| XtRange= (<float>, <float>, <float>)) | µm Specify start, end, and step size for defect locations. |  |
| TDDB |  | Account for time-dependent dielectric breakdown. Time-Dependent Dielectric Breakdown Simulations on page 1080 |
| TrapToTrapTunneling | [(InelasticPhonon) \| (MultiPhonon)] | Select trap-to-trap tunneling model, both elastic and inelastic. Alternatively, select either inelastic phonon or multiphonon trap-to-trap tunneling model. Trap-to-Trap Tunneling on page 1070 |

Table 244 Medium() Transfer Matrix Method on page 680

| ExtinctionCoefficient | =<float> | 1 |
| --- | --- | --- |
| Location | =top | ! Position of medium with respect to extracted layer structure. |
| =bottom | Position of medium with respect to extracted layer structure. |  |
| Material | =<string> | Name of material. |
| RefractiveIndex | =<float> | 1 |

Table 245 NonlocalPath() in SRH() Dynamic Nonlocal Path Trap-Assisted Tunneling on page 428

| Fermi |  | - Use Fermi statistics. |
| --- | --- | --- |
| Lifetime | =Hurkx | \* Use Hurkx model for lifetime enhancement. |
| =Schenk | Use Schenk model for lifetime enhancement. |  |
| TwoBand |  | - Use Two-band dispersion for the transmission coefficient. |

1566

G: Command File Overview

Physics

Table 246 OptBeam(() ... ) Using Optical Beam Absorption Method on page 701

| LayerStackExtraction( | ComplexRefractiveIndexThreshold= <float> | 0 Choose threshold value for layer creation when using ElementWise extraction mode. |
| --- | --- | --- |
| Mode=RegionWise \| ElementWise | RegionWise Specify whether layer stack is created on a per-element or per-region basis. |  |
| Position=(<float>*3) | Specify starting point of extraction line. |  |
| WindowName=<string> | Reference to illumination window in Excitation section. |  |
| WindowPosition=<ident> ) | Center Specify starting point of extraction line in terms of a cardinal direction (North, South, East, West, NorthEast, SouthEast, NorthWest, SouthWest). |  |

Table 247 OpticalGeneration{} Specifying the Type of Optical Generation Computation on page 594 and Controlling Interpolation When Loading Optical Generation Profiles on page 714

| AutomaticUpdate | + Controls whether optical generation is recomputed if quantities on which it depends are not up-to-date. |  |
| --- | --- | --- |
| ComputeFromMonochromaticSource | Optical Generation From Monochromatic Source on page 596 |  |
| ( | Scaling=<float> | 1 |
| TimeDependence(Table 261) |  |  |
| ) |  |  |
| ComputeFromSpectrum | Illumination Spectrum on page 596 |  |
| ( | KeepSpectralData | Keep spectral data (for example, for plotting or to avoid recomputation of optics) when computing the optical generation resulting from an illumination spectrum. |
| RefreshEveryTime | Force recomputation of respective optical generation contribution at every occasion. |  |
| Scaling=<float> | 1 |  |
| Select(Table 255) | Active parameters of multidimensional spectrum file. |  |
| TimeDependence(Table 261) |  |  |
| ) |  |  |
| QuantumYield | =<float> | 1 Quantum Yield Models on page 603 |

# G: Command File Overview

Physics

Table 247 OpticalGeneration{} Specifying the Type of Optical Generation Computation on page 594 and Controlling Interpolation When Loading Optical Generation Profiles on page 714 (Continued)

| QuantumYield( | EffectiveAbsorption | Quantum Yield Models on page 603 |
| --- | --- | --- |
| Factor=<float> | 1 Quantum Yield Models on page 603 |  |
| pmiModel=<string> | Quantum Yield Models on page 603 |  |
| StepFunction(Table 260) | Quantum Yield Models on page 603 |  |
| Unity) | Quantum Yield Models on page 603 |  |
| ReadFromFile ( |  | Loading and Saving Optical Generation From and to Files on page 601 |
| DatasetName= AbsorbedPhotonDensity \| OpticalGeneration |  |  |
| TimeDependence(Table 261) |  |  |
| Scaling=<float> | 1 |  |
| RefreshEveryTime | Force recomputation of respective optical generation contribution at every occasion. |  |
| GridInterpolation= Simple \| Conservative | Interpolation algorithm to be used if source and destination grid are different. |  |
| ShiftVector=<vector> | (0,0,0) Displacement of source grid. |  |
| ImportDomain(Table 241) ) | Specify source and destination regions as well as domain truncation for interpolation. |  |
| Scaling | =<float> | 1 |
| SetConstant ( |  | Constant Optical Generation on page 602 |
| RefreshEveryTime | Force recomputation of respective optical generation contribution at every occasion. |  |
| TimeDependence(Table 261) |  |  |
| Value=<float>) | s-1 cm-3 Value for optical generation rate. |  |
| TimeDependence( | Table 261) | Specification of type of time dependency. |

1568

G: Command File Overview
Physics

Table 248 OpticalTurningPoints() Optical Turning Points on page 612

| Dt | =<float> | Limiting time step for range [$t_0 t_3$] for time-dependence `FromFile` only. The default value is given by the smallest time interval specified in the `OptGenTransientScaling` file defined in the `File` section. For all other types of time dependence, use `Dt` to set `DtRise`, `DtPlateau`, and `DtFall` to the same value instead of setting each keyword separately. If any of these keywords is set, it overwrites the value of `Dt`. |
| --- | --- | --- |
| DtFall | =<float> | 0 s Limiting time step for range [$t_2 t_3$]. Does not apply to time-dependence `FromFile`. |
| DtFallEnd | =<float> | ($t_1 - t_0$)/10 s Limiting time step at $t_3$. |
| DtFallStart | =<float> | ($t_1 - t_0$)/10 s Limiting time step at $t_2$. Does not apply to time-dependence `FromFile`. |
| DtPlateau | =<float> | 0 s Limiting time step for range [$t_1 t_2$]. Does not apply to time-dependence `FromFile`. |
| DtRise | =<float> | 0 s Limiting time step for range [$t_0 t_1$]. Does not apply to time-dependence `FromFile`. |
| DtRiseEnd | =<float> | ($t_1 - t_0$)/10 s Limiting time step at $t_1$. Does not apply to time-dependence `FromFile`. |
| DtRiseStart | =<float> | ($t_1 - t_0$)/10 s Limiting time step at $t_0$. |
| MinAmplitude | =<float> | 0.01 Signal amplitude used to define time points $t_0$ and $t_3$ for analytic signals with asymptotic tails. |

Table 249 Physics(...){ RayTraceBC(TMM(...)) }

| LayerStructure{ | <float> <string>; <float> <string>; ... <float> <string>} | Definition of multilayer structure used for TMM calculation. First column contains thickness of layer in $\mu$m. Second column contains material name of layer. |
| --- | --- | --- |
| MapOptGenToRegions ( | <string> <string> ...) | Set list of regions to which the lumped optical generation of the TMM BC is mapped. |
| QuantumEfficiency | =<float> | Specify the quantum efficiency of the TMM BC optical generation. |
| ReferenceMaterial | =<string> | Definition of `LayerStructure` orientation. The topmost layer in the `LayerStructure` specification is connected to the region with material `ReferenceMaterial`. |
| ReferenceRegion | =<string> | Definition of `LayerStructure` orientation. The topmost layer in the `LayerStructure` specification is connected to the region with name `ReferenceRegion`. |

# G: Command File Overview

Physics

Table 250 QWLocal() Localized Quantum-Well Model on page 1044

| eDensityCorrection |  | - Activate electron quantization model in the quantum well. Quantum-Well Quantization Model on page 332 |
| --- | --- | --- |
| ElectricFieldDep |  | + Switch on electric field dependency for the localized QW model. |
| hDensityCorrection |  | - Activate hole quantization model in the quantum well. Quantum-Well Quantization Model on page 332 |
| MaxElectricField | =<float> | 1e6 V/cm Cutoff value for electric field. |
| NumberOfCrystalFieldSplit HoleSubbands | =<int> | Set the maximum number of crystal-field split-hole subbands. |
| NumberOfElectronSubbands | =<int> | Set the maximum number of electron subbands. |
| NumberOfHeavyHoleSubbands | =<int> | Set the maximum number of heavy-hole subbands. |
| NumberOfLightHoleSubbands | =<int> | Set the maximum number of light-hole subbands. |
| NumberOfValenceBands | =<int> | 2 Set the number of valence bands. |
| Polarization | = TE \| TM \| Mixed | TE Set the polarization used for the computation of the optical transition matrix element. Optical Transition Matrix Element for Wurtzite Crystals on page 1037 |
| PolarizationFactor | =<[0,1]> | 1 Set the polarization factor used for the computation of the optical transition matrix element in mixed polarization simulations. Optical Transition Matrix Element for Wurtzite Crystals on page 1037 |
| WidthExtraction( | Table 264) | Set QW width extraction parameters. |

Table 251 RayDistribution() Distribution Window of Rays on page 657

| Dx | =<float> | Specify discretized x-size for Mode=Equidistant. |
| --- | --- | --- |
| Dy | =<float> | Specify discretized y-size for Mode=Equidistant. |
| Mode | =AutoPopulate | Automatically populate rays within the excitation shape. |
| =Equidistant | Equidistant distribution of rays within the excitation shape. |  |
| =MonteCarlo | Monte Carlo distribution of rays within the excitation shape. |  |
| NumberOfRays | =<int> | Set number of rays for Mode=MonteCarlo or Mode=AutoPopulate. |
| Scaling | =<float> | Multiply the rays in this window by a scaling factor. |
| WindowName | =<string> | Specify name of the ray distribution window. No name sets the RayDistribution section as global. |

G: Command File Overview

Physics

Table 252 RayTraceBC() in Physics material or region interface–based definition of boundary condition

| Fresnel |  | Fresnel boundary condition. |
| --- | --- | --- |
| PMIModel | =<ident> [(Table 358)] | Name of the PMI model associated with this BC contact. |
| Reflectivity | =<[0,1]> | 0 Reflectivity. |
| TMM( | Table 249 | Specification of TMM multilayer structure. |
| Transmittivity | =<[0,1]> | 0 Transmittivity. |

Table 253 RayTracing((...)) in Physics{Optics(OpticalSolver(...))}, unified raytracing interface
Raytracing on page 616

| CompactMemoryOption |  | Activate the compact memory model of raytracing. |
| --- | --- | --- |
| DepthLimit | =<int> | Stop tracing a ray after passing through more than <int> material boundaries. |
| ExternalMaterialCRIFile | =<string> | Include a CRI file to define the external media. External Material in Raytracer on page 670 |
| Farfield( | Table 238 | Activate the far field and sensor feature. Far Field and Sensors for Raytracing on page 675 |
| MinIntensity | =<float> | Stop tracing a ray when its intensity becomes less than <float> times the original intensity. RelativeMinIntensity is an equivalent keyword. |
| MonteCarlo |  | Activate Monte Carlo raytracing. |
| NonSemiconductorAbsorption |  | Include optical generation calculation in nonsemiconductor region or material. |
| OmitReflectedRays |  | Discard all reflected rays from raytracing process. |
| OmitWeakerRays |  | Discard the weaker ray at a material interface. This is chosen by comparing the reflectivity and transmittivity. |
| PlotInterfaceFlux |  | Activate plotting of interface fluxes on all BCs. Plotting Interface Flux on page 673 |
| PolarizationVector | =Random | Default. Automatically choose a random polarization vector that is perpendicular to the starting ray direction. |
| =<vector> | Set a fixed polarization vector for the starting ray. |  |
| Print |  | Create the raytree in the output .tdr file. |

# G: Command File Overview

Physics

Table 253 RayTracing(() ...) in Physics{Optics(OpticalSolver(...))}, unified raytracing interface
Raytracing on page 616 (Continued)

| Print(Skip( | <int>)) | Create a reduced raytree by omitting every user-defined subtree count. |
| --- | --- | --- |
| RayDistribution( | Table 251 | Create a ray distribution to be used in conjunction with the excitation illumination window. |
| RedistributeStoppedRays |  | Distribute the total power accumulated at terminated rays back into the raytree. |
| RetraceCRIchange | =<float> | Fractional change of the complex refractive index to force retracing of rays. |
| UserWindow( | Table 263 | Input a set of starting rays from a file that is specified by the user. User-Defined Window of Rays on page 656 |
| VirtualRegions{ | <string> <string> ...} | Specify virtual regions whereby the raytracer will ignore their existence. |
| WeightedOpticalGeneration |  | Switch on weighted method to distribute optical generation from element to vertices. Weighted Interpolation for Raytrace Optical Generation on page 672 |

Table 254 Recombination() in SingletExciton()

| Bimolecular |  | off (r) Switch on bimolecular recombination in continuity and singlet exciton equations. Singlet Exciton Equation on page 245, Bimolecular Recombination Model on page 484 |
| --- | --- | --- |
| Dissociation |  | off (i) Switch on interface exciton dissociation in continuity and singlet exciton equations. Singlet Exciton Equation on page 245, Exciton Dissociation Model on page 485 |
| eQuenching |  | off (r) Switch on quenching of singlet exciton due to free electrons. Singlet Exciton Equation on page 245 |
| hQuenching |  | off (r) Switch on quenching of singlet exciton due to free holes. Singlet Exciton Equation on page 245 |
| radiative |  | off (r) Switch on directly radiative decay of singlet exciton associated with light emission. |
| trappedradiative |  | off (r) Switch on trap-assisted radiative decay of singlet exciton associated with light emission. |

G: Command File Overview
Physics

Table 255 Select() Enhanced Spectrum Control on page 598

| AllowDuplicates |  | off (g) Control whether duplicate entries of the spectrum are ignored. |
| --- | --- | --- |
| Condition | =<string> | true Define a Boolean Tcl expression to select a subset of a multidimensional spectrum. |
| Parameter | =(<string>...) | Active parameters of multidimensional spectrum file. |
| Var | =<float> | 0 Auxiliary parameter that is used to provide more flexibility when specifying a selection condition for the multidimensional spectrum. |

Table 256 Sensor(...) in unified raytracing far field Far Field and Sensors for Raytracing on page 675

| Angular( | Phi=(<float>*2) | Define the range of $\phi$ for the angular sensor. |
| --- | --- | --- |
| Theta=(<float>*2)) | Define the range of $\theta$ for the angular sensor. |  |
| Line( | Corner1=<vector> | Define first point of line sensor. |
| Corner2=<vector> | Define second point of line sensor. |  |
| UseNormalFlux) | Compute the projected-to-normal flux. |  |
| Name | =<string> | Name of the sensor. |
| Rectangle( | AxisAligned | Take Corner1 and Corner2 as opposing corners of the rectangle sensor. |
| Corner1=<vector> | Define first corner of rectangle sensor. |  |
| Corner2=<vector> | Define second corner of rectangle sensor. |  |
| Corner3=<vector> | Define third corner of rectangle sensor. |  |
| UseNormalFlux) | Compute the projected-to-normal flux. |  |

Table 257 SensorSweep in unified raytracing far field Far Field and Sensors for Raytracing on page 675

| Name | =<string> | Specify name of sensor sweep. |
| --- | --- | --- |
| Ndivisions | =<int> | Set number of subdivisions for the collection ring. |
| Phi | =(<float>*2) | Specify range of $\phi$ for the sensor ring. |
| Theta | =(<float>*2) | Specify range of $\theta$ for the sensor ring. |
| VaryPhi |  | Set the sensor sweep as a latitude ring. |
| VaryTheta |  | Set the sensor sweep as a longitudinal ring. |

# G: Command File Overview

Physics

Table 258 SRH() and CDL() Shockley–Read–Hall Recombination on page 419, Coupled Defect Level Recombination on page 433

| <ident> | [ (Table 358) ] | Use PMI model <ident> to compute lifetimes. Lifetimes on page 1227 |
| --- | --- | --- |
| DopingDependence |  | Doping dependence. SRH Doping Dependence on page 420 |
| ElectricField( | Table 237) | (r) Field enhancement. SRH Field Enhancement on page 424 |
| ExpTempDependence |  | Exponential temperature dependence. SRH Temperature Dependence on page 422 |
| NonlocalPath( | Table 245) | (r) Nonlocal trap-assisted tunneling enhancement. Dynamic Nonlocal Path Trap-Assisted Tunneling on page 428 |
| TempDependence |  | Temperature dependence. SRH Temperature Dependence on page 422 |

Table 259 StepFunction() Optical Absorption Heat on page 994

| Bandgap |  | Use $E_g - E_{bgn}$ as the cutoff energy for interband absorption. |
| --- | --- | --- |
| EffectiveBandgap |  | Use $(E_g - E_{bgn} + 2 \cdot (3/2)kT)$ as the cutoff energy for interband absorption. |
| Energy | =<float> | eV Use specified value as the cutoff energy for interband absorption. |
| Wavelength | =<float> | μm Use specified value as the cutoff energy for interband absorption. |

Table 260 StepFunction() Quantum Yield Models on page 603

| Bandgap |  | Use $E_g$ as the cutoff energy for interband absorption. |
| --- | --- | --- |
| EffectiveBandgap |  | Use $E_g - E_{bgn}$ as the cutoff energy for interband absorption. |
| Energy | =<float> | eV Use specified value as the cutoff energy for interband absorption. |
| Wavelength | =<float> | μm Use specified value as the cutoff energy for interband absorption. |

Table 261 TimeDependence() Specifying Time Dependency for Transient Simulations on page 606

| FromFile |  | off Reads the time dependency as a table from file. |
| --- | --- | --- |
| OpticalTurningPoints( | Table 248) | + (g) Specification of optical turning points. Optical Turning Points on page 612. |
| Scaling | =<float> | 1 Scaling factor for optical generation. |

**G: Command File Overview**

Physics

Table 261 TimeDependence() Specifying Time Dependency for Transient Simulations on page 606 (Continued)

| WavePeriods | =<int> | Number of periods of the periodic signal. |
| --- | --- | --- |
| WaveTime | =(<float>*2) | s Time interval ($t_{min}$, $t_{max}$) when the optical generation rate is constant. |
| WaveTPeriod | =<float> | s Period of periodic signal. |
| WaveTPeriodOffset | =<float> | s Offset of periodic signal (only applies to linear and Gaussian time dependency). |
| WaveTSigma | =<float> | s Standard deviation $\sigma_t$ of the temporal Gaussian distribution that describes the decay of the optical generation rate outside the time interval `WaveTime`. |
| WaveTSlope | =<float> | s$^{-1}$ Slope that characterizes the linear decay of the optical generation rate outside the time interval `WaveTime`. |

Table 262 TMM() Transfer Matrix Method on page 680

| IntensityPattern |  | (r) Choose type of intensity pattern. |
| --- | --- | --- |
| =Envelope | Compute the envelope of the optical intensity instead of the regular optical intensity. |  |
| =StandingWave | \* Compute the regular optical intensity without applying any algorithm that filters out oscillations on the wavelength scale. |  |
| LayerStackExtraction( | ComplexRefractiveIndex Threshold=<float> | 0 Choose threshold value for layer creation when using `ElementWise` extraction mode. |
| Medium(Table 244) | Specification of media surrounding the extracted layer structure. |  |
| Mode=RegionWise \| ElementWise | RegionWise Specify whether layer stack is created on a per-element or per-region basis. |  |
| Position=(<float>*3) | Specify starting point of extraction line. |  |
| WindowName=<string> | Reference to illumination window in Excitation section. |  |
| WindowPosition=<ident>) | Center Specify starting point of extraction line in terms of a cardinal direction (North, South, East, West, NorthEast, SouthEast, NorthWest, SouthWest). |  |
| NodesPerWavelength | =<float> | Number of nodes per wavelength used for computation of optical field. |
| PropagationDirection | =Perpendicular \| Refractive | Refractive Choose interpolation mode for 1D TMM solution. |
| RoughInterface |  | + Flag interfaces as rough, that is, physics of rough interface scattering is applied. |

# G: Command File Overview

Physics

Table 262 TMM() Transfer Matrix Method on page 680 (Continued)

| Scattering( | AngularDiscretization=<int> | 91 Angular discretization of interval [$-\pi/2, \pi/2$] used in scattering solver. |
| --- | --- | --- |
| MaxNumberOfIterations=<int> | 10 Break criterion for iterative scattering solver. |  |
| Tolerance=<float>) | 1e-3 Break criterion for iterative scattering solver. |  |

Table 263 UserWindow in Physics{Optics(OpticalSolver(Raytracing(...)))}, User-Defined Window of Rays on page 656

| NumberOfRays | =<int> | Set number of rays in file. |
| --- | --- | --- |
| PolarizationVector | =Random | Generate random polarization for the user input rays. |
| =ReadFromExcitation | Read the polarization from the Excitation section. |  |
| =ReadFromFile | Read the polarization vectors from the user input ray file. |  |
| RaysFromFile | =<string> | Set file name of the user input rays. |

Table 264 WidthExtraction() Accelerating Gain Calculations and LED Simulations on page 996

| ChordWeight | =<float> | Specify chord weight for width extraction. Thickness Extraction on page 336 |
| --- | --- | --- |
| MinAngle | =(<float>, <float>) | Specify minimum angles for width extraction. Thickness Extraction on page 336 |
| SideMaterial | =("mat1", ..., "matn") | Specify the materials adjoining the QW. |
| SideRegion | =("reg1", ..., "regn") | Specify the regions adjoining the QW. |

**G: Command File Overview**

Physics

# LED

**NOTE** LED simulations present unique challenges that require problem-specific model and numerics setups. Contact TCAD Support for advice if you are interested in simulating LEDs (see Contacting Your Local TCAD Support Team Directly on page xlv).

Table 265 LED() Chapter 34, p. 987

| Bandstructure( | CrystalType=Zincblende \| Wurtzite) | Zincblende Crystal structure of active region. Electronic Band Structure for Wurtzite Crystals on page 1033 |
| --- | --- | --- |
| Broadening( | Table 266) | Activate gain-broadening models or nonlinear gain saturation model. Gain-Broadening Models on page 1031, Simple Quantum-Well Subband Model on page 1039 |
| Optics( | Table 268) | Optics. |
| QWExtension | =AutoDetect | Autodetect width of quantum wells. The quantum-well region must be specified by the keyword `Active`. Radiative Recombination and Gain Coefficients on page 1028 |
| QWTransport |  | Use ‘three-point’ QW model with thermionic emission. Radiative Recombination and Gain Coefficients on page 1028 |
| SplitOff | =<float> | eV Spin-orbit split-off energy. Strain Effects on page 1042 |
| SponEmissionCoeff | (<ident> ([Table 358)]) | Use PMI model `<ident>` for spontaneous emission. Importing Gain and Spontaneous Emission Data With PMI on page 1048 |
| SponIntegration | (<float>,<int>) | eV Energy integration range and number of discretization intervals for numeric integration (for LED simulations only). Spontaneous Emission Rate and Power on page 989 |
| SponScaling | =<float> | Scaling factor for matrix element of spontaneous emission. Radiative Recombination and Gain Coefficients on page 1028 |
| StimEmissionCoeff | (<ident> ([Table 358)]) | Use PMI model `<ident>` for stimulated emission. Importing Gain and Spontaneous Emission Data With PMI on page 1048 |
| StimScaling | =<float> | Scaling factor for matrix element of stimulated emission. Radiative Recombination and Gain Coefficients on page 1028 |
| Strain | (RefLatticeConst=<float>) | m Use strain model for quantum well with given reference lattice constant. Strain parameters are input in the parameter file. Strain Effects on page 1042 |

# G: Command File Overview

Physics

Table 266 Broadening() Gain-Broadening Models on page 1031

| Gamma | =<float> | eV Broadening coefficient Γ . |
| --- | --- | --- |
| Type | =CosHyper | Use hyperbolic-cosine broadening. Hyperbolic-Cosine Broadening on page 1032 |
| =Landsberg | Use Landsberg broadening. Landsberg Broadening on page 1032 |  |
| =Lorentzian | Use Lorentzian broadening. Lorentzian Broadening on page 1031 |  |

Table 267 ClusterActive() in LED(Optics(RayTrace())) Clustering Active Vertices on page 1002

| ClusterQuantity | =Nodes | Clustering by recursive grouping of active vertices. |
| --- | --- | --- |
| =OpticalGridElement | Clustering by grouping active vertices in each active optical element. |  |
| =PlaneArea | Clustering by evenly dividing up QW plane area and grouping active vertices in each area element. |  |
| NumberOfClusters | =<int> | Specify number of clusters, only for Nodes or PlaneArea clustering. |

Table 268 Optics() in LED() LED Optics: Raytracing on page 997

| RayTrace( | Table 271) | Raytracing. |
| --- | --- | --- |

Table 269 OutputLightToolsFarfieldRays() in LED(Optics(RayTrace())) Interfacing Far-Field Rays to LightTools on page 1016

| Filename | =<string> | Base file name of the LightTools® ray data file to be output. |
| --- | --- | --- |
| SaveType | =Ascii | Choose ASCII format for LightTools ray data file. |
| =Binary | Choose binary format for LightTools ray data file. |  |
| WavelengthDiscretization | =<int> | Number of discretization for the spectrum. The span of the spectrum is determined automatically. |

**G: Command File Overview**
Physics

Table 270 OutputLightToolsRays() in LED(Optics(RayTrace(Disable()))) Interfacing LED Starting Rays to LightTools on page 1007

| IsotropyType | =InBuilt | Use the internal geodesic distribution of starting rays from each active emission vertex cluster. |
| --- | --- | --- |
| =Random | Use a random distribution of starting rays. |  |
| =UserRays | Use the user input set of starting rays defined by the keyword SourceRaysFromFile (see Table 271). |  |
| RaysPerCluster | =<int> | Set number of starting rays in each active cluster. |
| SaveType | =Ascii | Choose ASCII format for LightTools ray data file. |
| =Binary | Choose binary format for LightTools ray data file. |  |
| WavelengthDiscretization | =<int> | Number of discretization for the spectrum. The span of the spectrum is determined automatically. |

Table 271 RayTrace() in LED(Optics()) LED Optics: Raytracing on page 997

| ClusterActive( | Table 267) | Activate the clustering option. Clustering Active Vertices on page 1002 |
| --- | --- | --- |
| CompactMemoryOption |  | Activate the compact memory model for LED raytracing. Will not work with the full photon-recycling model. |
| Coordinates | =Cartesian | \* |
| =Cylindrical |  |  |
| DebugLEDRadiation | (<string> <float1> <float2> <float3>) | off Trace the origin of the output rays that are within the angles [<float1>,<float2>] (in degrees) and of minimum intensity specified by the <float3> parameter. In two dimensions, the angle is defined in the regular polar coordinates. In three dimensions, the angles are defined from the z-axis, as in θ in regular spherical coordinates. The results are output to the file specified by <string>. |
| DepthLimit | =<int> | 5 Stop tracing the ray after passing through more than <int> material boundaries. |
| Disable |  | off Disable raytracing but still run LED simulation. |
| Disable(OutputLightToolsRays( | Table 270) | Output starting rays from active vertices to a LightTools ray data file. Interfacing LED Starting Rays to LightTools on page 1007 |

# G: Command File Overview

Physics

Table 271 RayTrace() in LED(Optics()) LED Optics: Raytracing on page 997 (Continued)

| EmissionType | (Anisotropic( Sine(<float>3) Cosine(<float>3))) |  |
| --- | --- | --- |
| (Isotropic) | \* |  |
| ExcludeHorizontalSource | (<float>) | off Omit the source rays that are emitted within the horizontal angular zone specified by the <float> parameter (in degrees). |
| LEDRadiationPara | (<float>, <int>) | µm Observation radius and discretization of the observation circle or sphere. |
| LEDSpectrum | (<float>*2 <int>) | eV Starting and ending energy range, and number of subdivisions in that energy range. |
| MinIntensity | =<float> | 1e-5 Stop tracing the ray when the intensity of a ray becomes less than <float> times the original intensity. |
| MonteCarlo |  | Activate Monte Carlo raytracing. |
| MoveBoundaryStartRays | =<float> | 0 nm Shift the starting ray position at device boundary inwards. Recommended values are 1 to 5 nm. |
| NonActiveAbsorptionOff |  | Do not add nonactive region absorption as generation rate to continuity equation. Nonactive Region Absorption (Photon Recycling) on page 1018 |
| ObservationCenter | =<vector> | Fixed observation center for LED radiation. By default, center of device. |
| OmitReflectedRays |  | Discard all reflected rays in raytracing process. |
| OmitWeakerRays |  | Discard the weaker ray at a material interface. This is decided by comparing the reflectivity and transmittivity. |
| OptGenScaling | =<float> | Set a multiplication factor to the nonactive optical generation computed. |
| OutputLightToolsFarfieldRays( | Table 269 | Output far-field rays with embedded spectrum information into a LightTools ray data file. Interfacing Far-Field Rays to LightTools on page 1016 |
| PolarizationVector | =Random | Default. Automatically choose a random polarization vector that is perpendicular to the starting ray direction. |
| =<vector> | Set a user-defined polarization vector. |  |
| Print |  | off Output all rays to the output .tdr file. |
| (ActiveVertex( <int>)) | off Output only ray paths emitted from this active vertex. |  |
| (Skip(<int>)) | 1 Output every other <int> ray to the output .tdr file. |  |

1580

**G: Command File Overview**
Physics

Table 271 RayTrace() in LED(Optics()) LED Optics: Raytracing on page 997 (Continued)

| PrintRayInfo | (<string>) | off Print all indices and positions of starting rays into the file specified by <string>. |
| --- | --- | --- |
| PrintSourceVertices | (<string>) | off Print the index and coordinates of all active vertices into the file specified by <string>. |
| ProgressMarkers | =<int> | 5 Completion meter for raytracing. |
| RaysPerVertex | =<int> | 10 Number of rays starting from each active source vertex. For 3D, the number of starting rays are constrained by 6, 18, 68, and so on. The number in the sequence is chosen such that RaysPerVertex is slightly larger or equal to it. |
| RaysRandomOffset |  | Randomize the angular shift of the starting rays. |
| (RandomSeed=<int>) | Set a fixed random seed so that repeated simulations will yield the exact pseudorandom results. |  |
| RedistributeStoppedRays |  | Distribute the total accumulated power in terminated rays back into the raytree. |
| RetraceCRIchange | =<float> | Fractional change of the complex refractive index to force retracing of rays. |
| SourceRaysFromFile( | <string>) | Import a set of starting ray directions from the file name specified by <string>. The number of imported rays are specified by RaysPerVertex. |
| Staggered3DFarfieldGrid |  | Use the staggered 3D far-field collection sphere. Staggered 3D Grid LED Radiation Pattern on page 1012 |
| TraceSource | () | Retrace the source of the output rays to produce a map of the source regions that give the strongest ray output. |
| TurnOffTreeNodeCount |  | Disable counting the total number of nodes in the raytree. |
| Wavelength | =<float> | nm Wavelength. |
| =AutoPeak | Take wavelength at the peak of the spontaneous emission rate spectrum. LED Wavelength on page 993 |  |
| =AutoPeakPower | Take wavelength at the peak of the spontaneous emission power spectrum. |  |
| =Effective | Wavelength computed such that total power = total rate x effective photon energy. |  |

1581

G: Command File Overview

Physics

# Mobility

Table 272 Mobility(), eMobility(), hMobility() Chapter 15, p. 341

| BalMob ( |  | off Use ballistic mobility model. Ballistic Mobility Model on page 403 |
| --- | --- | --- |
| Fermi | off Use Fermi–Dirac correction in the ballistic mobility. Using the Ballistic Mobility Model on page 405 |  |
| Frensley | off Use Frensley rule for final mobility. Using the Ballistic Mobility Model on page 405 |  |
| KineticEnergy | off Use kinetic ballistic mobility model. Using the Ballistic Mobility Model on page 405 |  |
| Lch=&lt;float&gt; | 107 nm Use explicit channel length in simple ballistic mobility. Using the Ballistic Mobility Model on page 405 |  |
| TempDep) | off Use temperature dependency in simple ballistic mobility. Using the Ballistic Mobility Model on page 405 |  |
| BTCSMob( | Nonlocal | off Account for scattering by remote traps. General Model for Mobility Degradation by Traps in the Bulk and at Semiconductor Interfaces on page 407 |
| NonlocalLengthLimit= &lt;float&gt;) | 0 cm Distance up to which to account for remote traps, when Nonlocal option is active. |  |
| CarrierCarrierScattering | (BrooksHerring) | off Use Brooks–Herring carrier–carrier scattering model. Carrier–Carrier Scattering on page 351 |
| (ConwellWeisskopf) | off Use Conwell–Weisskopf carrier–carrier scattering model. Carrier–Carrier Scattering on page 351 |  |
| ConstantMobility |  | + Use constant mobility if neither PhuMob nor DopingDependence is specified. Mobility due to Phonon Scattering on page 342 |
| Diffusivity( | Table 273 | off Use non-Einstein diffusivity. Non-Einstein Diffusivity on page 401 |

**G: Command File Overview**

Physics

Table 272 Mobility(), eMobility(), hMobility() Chapter 15, p. 341 (Continued)

| DopingDependence( | <ident> ([Table 358)] | off PMI model <ident>. Doping-Dependent Mobility on page 1237 |
| --- | --- | --- |
| Arora | off Use Arora doping-dependent mobility model. Doping-Dependent Mobility Degradation on page 342 |  |
| BalMob([Lch=<float>]) | off Use low-field ballistic mobility model. Low-Field Ballistic Mobility Models on page 349 |  |
| Masetti | off Use Masetti doping-dependent mobility model. Doping-Dependent Mobility Degradation on page 342 |  |
| PhuMob options on [page 1585] | off Use Philips unified mobility model. Philips Unified Mobility Model on page 353 |  |
| PhuMob2 | off Use an alternative Philips model.241 Using an Alternative Philips Unified Mobility Model on page 354 |  |
| PMIModel(Table 318) | off Use PMI for MSC-dependent mobility. Multistate Configuration–Dependent Bulk Mobility on page 1287 |  |
| UniBo) | off Use University of Bologna doping-dependent mobility model. Doping-Dependent Mobility Degradation on page 342 |  |
| eDiffusivity( | Table 273) | off Use non-Einstein electron diffusivity. Non-Einstein Diffusivity on page 401 |
| eHighFieldSaturation( | Table 273) | off Electron high-field saturation. High-Field Saturation Models on page 387 |

# G: Command File Overview

Physics

Table 272 Mobility(), eMobility(), hMobility() Chapter 15, p. 341 (Continued)

| Enormal( | <ident> ([Table 358) ] | off PMI model <ident>. Mobility Degradation at Interfaces on page 1259 |
| --- | --- | --- |
| Coulomb2D | off ‘Two-dimensional’ ionized impurity mobility degradation. Mobility Degradation Components due to Coulomb Scattering on page 372 |  |
| IALMob (Table 274) | off Inversion and accumulation layer mobility model. Mobility Degradation at Interfaces on page 357 |  |
| InterfaceCharge [ (SurfaceName=<string>)] | off Negative and positive interface charge mobility degradation. Mobility Degradation Components due to Coulomb Scattering on page 372 |  |
| Lombardi (Table 275) | off Enhanced Lombardi model. Mobility Degradation at Interfaces on page 357 |  |
| Lombardi_highk | off Enhanced Lombardi model with high-k degradation. Mobility Degradation at Interfaces on page 357 |  |
| NegInterfaceCharge [(SurfaceName=<string>)] | off Negative interface charge mobility degradation. Mobility Degradation Components due to Coulomb Scattering on page 372 |  |
| PosInterfaceCharge [(SurfaceName=<string>)] | off Positive interface charge mobility degradation. Mobility Degradation Components due to Coulomb Scattering on page 372 |  |
| RCS | off Remote Coulomb scattering mobility degradation. Remote Coulomb Scattering Model on page 376 |  |
| RPS | off Remote phonon scattering mobility degradation. Remote Phonon Scattering Model on page 378 |  |
| UniBo) | off University of Bologna surface mobility model. Mobility Degradation at Interfaces on page 357 |  |
| hDiffusivity( | Table 273) | off Use non-Einstein hole diffusivity. Non-Einstein Diffusivity on page 401 |
| hHighFieldSaturation( | Table 273) | off Hole high-field saturation. High-Field Saturation Models on page 387 |
| HighFieldSaturation( | Table 273) | off High-field saturation. High-Field Saturation Models on page 387 |
| IncompleteIonization |  | off Incomplete ionization-dependent mobility. Incomplete Ionization–Dependent Mobility Models on page 408 |

G: Command File Overview

Physics

Table 272 Mobility(), eMobility(), hMobility() Chapter 15, p. 341 (Continued)

| PhuMob |  | off Philips unified mobility model. Philips Unified Mobility Model on page 353 |
| --- | --- | --- |
| ( | Arsenic | \* Use arsenic parameters. Table 58 on page 357 |
| Phosphorus) | Use phosphorus parameters. Table 58 on page 357 |  |
| ThinLayer |  | off Thin-layer mobility model. Thin-Layer Mobility Model on page 381 |
| ( | ChordWeight=<float> | 0 Weight of chord length. Thickness Extraction on page 336 |
| IALMob (Table 274) | Use the inversion and accumulation layer mobility model with the thin-layer mobility model. Thin-Layer Mobility Model on page 381 |  |
| Lombardi (Table 275) | \* Use the enhanced Lombardi model with the thin-layer mobility model. Thin-Layer Mobility Model on page 381 |  |
| MinAngle=(<float>*2) | 0 0 Angle constraints. Thickness Extraction on page 336 |  |
| Thickness=<float>) | μm Explicit thickness value. |  |
| ToCurrentEnormal | as Enormal | off Dependence on electric field normal to current. Mobility Degradation at Interfaces on page 357 |
| Tunneling |  | – Tunneling correction to mobility. Eq. 236, p. 318 |

Table 273 HighFieldSaturation(), Diffusivity() High-Field Saturation Models on page 387

| <ident> | ([Table 358) ] | PMI model <ident>. High-Field Saturation on page 1246 |
| --- | --- | --- |
| AutoOrientation |  | – Use a parameter set based on the orientation of the nearest interface. Auto-Orientation for the High-Field Saturation Models on page 388 |
| CarrierTempDrive |  | Temperature driving force (default for hydrodynamic simulation). Hydrodynamic Driving Force on page 398 |
| CarrierTempDriveBasic |  | Basic temperature driving force. Basic Model on page 392 |
| CarrierTempDriveME |  | Meinerzhagen–Engl temperature driving force. Meinerzhagen–Engl Model on page 393 |
| CarrierTempDrivePolynomial |  | Energy-dependent mobility model using an irrational polynomial. Energy-Dependent Mobility on page 828 |
| CarrierTempDriveSpline |  | Energy-dependent mobility model using spline interpolation. Spline Interpolation on page 829 |
| CaugheyThomas |  | \* Use Canali–Hänsch model. Extended Canali Model on page 388 |
| ElectricField |  | Electric field. Electric Field on page 398 |

# G: Command File Overview

Physics

Table 273 HighFieldSaturation(), Diffusivity() High-Field Saturation Models on page 387

| Keyword | Parameter/Reference | Description |
| --- | --- | --- |
| Eparallel |  | Use electric field parallel to current as driving force. Electric Field Parallel to the Current on page 395 |
| EparallelToInterface |  | Use electric field parallel to the closest semiconductor–insulator interface as driving force. Electric Field Parallel to the Interface on page 396 |
| GradQuasiFermi |  | \* Use gradient of quasi-Fermi potential as driving force. For hydrodynamic simulations, default is CarrierTempDrive. Gradient of Quasi-Fermi Potential on page 396 |
| ParameterSetName | =<string> | Name of parameter set to use. Named Parameter Sets for the High-Field Saturation Models on page 388 |
| PFMob |  | Use Poole–Frenkel mobility model. Poole–Frenkel Mobility (Organic Material Mobility) on page 409 |
| PMIModel( | Table 318) | PMI model dependent on two fields. High-Field Saturation With Two Driving Forces on page 1255 |
| TransferredElectronEffect |  | Use transferred electron model. Transferred Electron Model on page 390 |
| TransferredElectronEffect2 |  | Use an alternative transferred electron model. Transferred Electron Model 2 on page 390 |

Table 274 IALMob() Mobility Degradation at Interfaces on page 357

| Keyword | Parameter | Description |
| --- | --- | --- |
| AutoOrientation |  | – Use a parameter set based on the orientation of the nearest interface. Auto-Orientation for the IALMob Model on page 370 |
| ClusteringEverywhere |  | – Use clustering formulas for all occurrences of NA and ND. Inversion and Accumulation Layer Mobility Model on page 362 |
| FullPhuMob |  | + Use the full PhuMob mobility expressions. Inversion and Accumulation Layer Mobility Model on page 362 |
| ParameterSetName | =<string> | Name of IALMob parameter set. Named Parameter Sets for the IALMob Model on page 369 |
| PhononCombination | =<0..2> | 1 Selects how 2D and 3D phonon mobility are combined. Inversion and Accumulation Layer Mobility Model on page 362 |

G: Command File Overview
Physics

Table 275 Lombardi() Mobility Degradation at Interfaces on page 357

| AutoOrientation |  | – Use a parameter set based on the orientation of the nearest interface. Auto-Orientation for the Lombardi Model on page 362 |
| --- | --- | --- |
| ParameterSetName | =<string> | Name of EnormalDependence parameter set. Named Parameter Sets for the Lombardi Model on page 361 |

# Radiation Models

Table 276 AlphaParticle() Carrier Generation by Alpha Particles on page 720

| Direction | =<vector> | ! Direction of motion of the particle. |
| --- | --- | --- |
| Energy | =<float> | ! eV Energy of the alpha particle. |
| Location | =<vector> | ! µm Point where the alpha particle enters the device (bidirectional track). |
| StartPoint | =<vector> | ! µm Point where the alpha particle enters the device (one-directional track). |
| Time | =<float> | ! s Time at which the charge generation peaks. |

Table 277 HeavyIon() Carrier Generation by Heavy Ions on page 722

| Direction | =<vector> | Direction of motion of the ion. |
| --- | --- | --- |
| Exponential |  | \* Use exponential shape for the spatial distribution $R(w)$. |
| Gaussian |  | Use Gaussian shape for the spatial distribution $R(w)$. |
| Length | =[<float>...] | Length $l$ where Wt_hi and Let_f are specified (in cm by default or µm if the PicoCoulomb option is selected). |
| LET_f | =[<float>...] | Linear energy transfer (LET) function (in pairs cm-3 by default or pC µm-1 if the PicoCoulomb option is selected). Entries in the list match those in Length. |
| Location | =<vector> | µm Point where the heavy ion enters the device (bidirectional track). |
| PicoCoulomb |  | Switch units for LET_f, Wt_hi, and Length. |
| SpatialShape | =<ident> ([Table 358) ] | PMI for spatial distribution function. Heavy Ion Spatial Distribution on page 1427 |
| StartPoint | =<vector> | µm Point where the heavy ion enters the device (one-directional track). |

# G: Command File Overview

Physics

Table 277 HeavyIon() Carrier Generation by Heavy Ions on page 722 (Continued)

| Time | =<float> | s Time at which the ion penetrates the device. |
| --- | --- | --- |
| Wt_hi | =[<float>...] | Characteristic distance, $w_i(l)$ (in cm by default or $\mu$m if the PicoCoulomb option is selected). Entries in the list match those in Length. |

Table 278 Radiation() Chapter 22, p. 719

| Dose | =<float> | rad Total dose over exposure time. |
| --- | --- | --- |
| DoseRate | =<float> | rads-1 Dose rate. |
| DoseTime | =(<float>*2) | ! s Exposure time. |
| DoseTSigma | =<float> | ! s Standard deviation of rise and fall of dose rate over time. |

## Various

Table 279 Aniso() Chapter 28, p. 833

| Avalanche |  | Use anisotropic avalanche generation. Anisotropic Avalanche Generation on page 848 |
| --- | --- | --- |
| direction | [(<System_Coord>)] | Crystal or simulation system coordinate. |
| =(<float>*3) | Anisotropic direction. Anisotropic Direction in 3D Cases on page 837 |  |
| =xAxis | Equivalent to direction=(1 0 0). |  |
| =yAxis | Equivalent to direction=(0 1 0). |  |
| =zAxis | Equivalent to direction=(0 0 1). |  |
| eAvalanche |  | Use anisotropic electron avalanche generation. Anisotropic Avalanche Generation on page 848 |
| eMobility |  | Use self-consistent anisotropic mobility for electrons. Self-Consistent Anisotropic Mobility on page 846 |
| eMobilityFactor | (Total)=<float> | Total anisotropic mobility factor for electrons. Total Anisotropic Mobility on page 845 |
| eQuantumPotential |  | Use electron anisotropic density-gradient equation with tensor grid approximation. Using the Density Gradient Model on page 318 |
| hAvalanche |  | Use anisotropic hole avalanche generation. Anisotropic Avalanche Generation on page 848 |

**G: Command File Overview**
Physics

Table 279 Aniso() Chapter 28, p. 833 (Continued)

| hMobility |  | Use self-consistent anisotropic mobility for holes. Self-Consistent Anisotropic Mobility on page 846 |
| --- | --- | --- |
| hMobilityFactor | (Total)=<float> | Total anisotropic mobility factor for holes. Total Anisotropic Mobility on page 845 |
| hQuantumPotential |  | Use hole anisotropic density-gradient equation with tensor grid approximation. Using the Density Gradient Model on page 318 |
| MetalResistivityFactor | (Total)=<float> | Total anisotropic metal resistivity factor. Total Anisotropic Metal Resistivity on page 848 |
| Mobility |  | Use self-consistent anisotropic mobility. Self-Consistent Anisotropic Mobility on page 846 |
| Poisson |  | Use anisotropic electrical permittivity. Anisotropic Electrical Permittivity on page 850 |
| Temperature |  | Use anisotropic thermal conductivity. Anisotropic Thermal Conductivity on page 851 |

Table 280 BandEdge() in RandomizedVariation() Band Edge Variations on page 753

| Table 225 |  | Statistical properties of the correlation. |
| --- | --- | --- |
| Table 321 |  | Spatial restriction of variation. |
| Amplitude_Chi | =<float> | eV Amplitude of affinity variation for exponential and Gaussian correlation. |
| Amplitude_Eg | =<float> | eV Amplitude of bandgap variation for exponential and Gaussian correlation. |
| Chi2Eg | =<float> | 0 Correlation between affinity and band gap. |
| ChiComponent | =<0..1> | 0 Named random field component for affinity randomization. |
| EgComponent | =<0..1> | 1 Named random field component for bandgap randomization. |
| GrainChi | =(<float>...) | eV Grain affinity values. |
| GrainEg | =(<float>...) | eV Grain bandgap values. |
| GrainProbability | =(<float>...) | Probability for grain types. |
| Volume | =<string> | Named volume in which to activate the variation. |

# G: Command File Overview

Physics

Table 281 BarrierType() in SingletExciton() Singlet Exciton Equation on page 245

| Bandgap |  | \* (i) Use bandgap difference as barrier. |
| --- | --- | --- |
| CondBand |  | (i) Use conduction band-edge difference as barrier. |
| ValBand |  | (i) Use valence band-edge difference as barrier. |

Table 282 ComplexRefractiveIndex() Complex Refractive Index Model on page 640

| CarrierDep( | imag | Use carrier dependency of extinction coefficient. Carrier Dependency on page 641 |
| --- | --- | --- |
| real) | Use carrier dependency of refractive index. Carrier Dependency on page 641 |  |
| CRIModel( | Name=<string>) | Activate user-defined complex refractive index model. Complex Refractive Index Model Interface on page 1322 |
| GainDep | (real(lin)) | Use linear gain dependency of refractive index. Gain Dependency on page 643 |
| (real(log)) | Use logarithmic gain dependency of refractive index. Gain Dependency on page 643 |  |
| TemperatureDep( | real) | Use temperature dependency of refractive index. Temperature Dependency on page 641 |
| WavelengthDep( | imag | Use wavelength dependency of extinction coefficient. Wavelength Dependency on page 641 |
| real) | Use wavelength dependency of refractive index. Wavelength Dependency on page 641 |  |

Table 283 Conductivity() in RandomizedVariation() Metal Conductivity Variations on page 754

| Table 225 |  | Statistical properties of the correlation. |
| --- | --- | --- |
| Table 321 |  | Spatial restriction of variation. |
| Amplitude | =<float> | A/cmV Amplitude of conductivity variation for exponential and Gaussian correlation. |
| GrainConductivity | =(<float>...) | A/cmV Grain conductivity values. |
| GrainProbability | =(<float>...) | Probability for grain types. |
| Volume | =<string> | Named volume in which to activate the variation. |

G: Command File Overview
Physics

Table 284 DeterministicVariation() Deterministic Variations on page 757

| DopingVariation | <string> (Table 287) | Deterministic Doping Variations on page 757 |
| --- | --- | --- |
| GeometricVariation | <string> (Table 301) | Deterministic Geometric Variations on page 759 |
| ParameterVariation | <string> (Table 316) | Parameter Variations on page 760 |

Table 285 Doping() in Noise() Random Dopant Fluctuations on page 737

| Table 321 |  | Spatial restriction of fluctuations. |
| --- | --- | --- |
| BandgapNarrowing |  | Include effect on bandgap narrowing. |
| Mobility |  | Include effect on mobility. |
| Type | =Acceptor | Only acceptors fluctuate. |
| =Donor | Only donors fluctuate. |  |
| =Doping | \* All dopants fluctuate. |  |

Table 286 Doping() in RandomizedVariation() Doping Variations on page 749

| Table 321 |  | Spatial restriction of variation. |
| --- | --- | --- |
| BandgapNarrowing |  | + Account for doping dependency of bandgap narrowing. |
| Mobility |  | + Account for doping dependency of mobility. |
| Type | =Acceptor | Randomize acceptors only. |
| =Donor | Randomize donors only. |  |
| =Doping | \* Randomize all dopants. |  |

Table 287 DopingVariation() in DeterministicVariation() Deterministic Doping Variations on page 757

| Table 321 |  | Spatial restriction of variation. |
| --- | --- | --- |
| Amplitude | =<vector> | µm Vectorial amplitude for gradient specification. |
| Amplitude_Abs | =<vector> | µm Vectorial amplitude for absolute gradient specification. |
| Amplitude_Iso | =<float> | µm Isotropic amplitude for gradient specification. |
| BandgapNarrowing |  | + Account for doping dependency of bandgap narrowing. |
| Conc | =<float> | cm-3 Normalization concentration. |

# G: Command File Overview

Physics

Table 287 DopingVariation() in DeterministicVariation() Deterministic Doping Variations on page 757 (Continued)

| Factor | =<float> | 1 Multiplier for variation. |
| --- | --- | --- |
| Mobility |  | + Account for doping dependency of mobility. |
| SFactor | =<string> | Dataset name for variation. |
| Type | =Acceptor | Apply variation to acceptor concentration. |
| =Donor | Apply variation to donor concentration. |  |
| =Doping | \* Apply variation according to sign to acceptor or donors. |  |

Table 288 DopingVariation() in RandomizedVariation() Doping Profile Variations on page 756

| Table 225 |  | Statistical properties of the correlation. |
| --- | --- | --- |
| Table 321 |  | Spatial restriction of variation. |
| Amplitude | =<float> | 0 µm Vectorial amplitude. |
| Amplitude_Iso | =<float> | 0 µm Isotropic amplitude. |
| BandgapNarrowing |  | + Account for doping dependency of bandgap narrowing. |
| Conc | =<float> | 0 cm⁻³ Normalization concentration. |
| Mobility |  | + Account for doping dependency of mobility. |
| SFactor | =<string> | ! Dataset name for variation. |
| Type | =Acceptor | Apply variation to acceptor concentration. |
| =Donor | Apply variation to donor concentration. |  |
| =Doping | \* Apply variation according to sign to acceptor or donors. |  |

**G: Command File Overview**
Physics

Table 289 EffectiveIntrinsicDensity() Band Gap and Electron Affinity on page 259

| BandGap | (<ident> [ (Table 358) ]) | Use PMI model <ident> to compute band gap $E_g$. Band Gap on page 1271 |
| --- | --- | --- |
| BandGapNarrowing | (<ident> [ (Table 358) ]) | Use PMI model <ident> for bandgap narrowing. Bandgap Narrowing on page 1274 |
| (BennettWilson) | \* Bennett–Wilson model. |  |
| (delAlamo) | del Alamo model. |  |
| (JainRoulston) | Jain–Roulston model. |  |
| (oldSlotboom) | Old Slotboom model. |  |
| (Slotboom) | Slotboom model. |  |
| (TableBGN) | Table-based model. |  |
| NoBandGapNarrowing |  | No bandgap narrowing. |
| NoFermi |  | off Omit correction Eq. 172, p. 270 even when using Fermi statistics. Bandgap Narrowing With Incomplete Ionization on page 269 |

Table 290 eLucky(), hLucky(), eFiegna(), hFiegna() Effective Field on page 798

| CarrierTempDrive | Use field derived from temperature. |
| --- | --- |
| CarrierTempPost | Use field derived from postprocessed temperature. |
| Eparallel | \* Use field parallel to interface. |

Table 291 eNMP() Extended Nonradiative Multiphonon Model on page 569

| Conc | =<float> | 0 cm-2 Precursor concentration for the eNMP model. |
| --- | --- | --- |
| NumberOfSamples | =<int> | 0 Number of random samples. |
| SFactor | =<ident> [ (Table 358) ] | Name of the PMI model to compute the eNMP precursor concentration. Using the eNMP Model on page 572 and Space Factor on page 1446 |
| =<string> | Dataset for the spatial distribution of the eNMP precursor concentration. Using the eNMP Model on page 572 |  |

1593

# G: Command File Overview

Physics

Table 292 Epsilon() in RandomizedVariation() Dielectric Constant Variations on page 755

| Table 225 |  | Statistical properties of the correlation. |
| --- | --- | --- |
| Table 321 |  | Spatial restriction of variation. |
| Amplitude | =<float> | 1 Amplitude of relative dielectric constant variation for exponential and Gaussian correlation. |
| GrainEpsilon | =(<float>...) | 1 Grain relative dielectric constant values. |
| GrainProbability | =(<float>...) | Probability for grain types. |
| Volume | =<string> | Named volume in which to activate the variation. |

Table 293 eQuantumPotential() and hQuantumPotential() Density Gradient Model on page 316

| AnisoAxes | [(<System_Coord>)] | Crystal or simulation system coordinate. |
| --- | --- | --- |
| ={<vector> <vector>} | Two directions of anisotropy. Anisotropic Direction in 3D Cases on page 837 |  |
| AutoOrientation |  | off Use parameter set based on orientation of nearest interface. Auto-Orientation for the Density Gradient Model on page 322 |
| BoundaryCondition | =Dirichlet | (ci) Enforce homogeneous Dirichlet boundary condition. |
| =HomogeneousNeumann | (ci) Enforce homogeneous Neumann boundary condition on region interfaces. |  |
| =Neumann | (ci) Enforce homogeneous Neumann boundary condition. |  |
| Density |  | - (r) Use Eq. 231, p. 316 instead of Eq. 232, p. 317. |
| direction | [(<System_Coord>)] | Crystal or simulation system coordinate. |
| =(<float>*3) | Anisotropic direction. Anisotropic Direction in 3D Cases on page 837 |  |
| =xAxis | Equivalent to direction=(1 0 0). |  |
| =yAxis | Equivalent to direction=(0 1 0). |  |
| =zAxis | Equivalent to direction=(0 0 1). |  |
| Formula | =<0..1> | 0 (r) Select between formulation with mass before or between differential operators. |
| Gamma ( | EffectiveMass | + Quantization mass is density of states mass. Gamma Factor for Density Gradient Model on page 1422 |
| name=<string> [(Table 358)] | PMI for $\gamma$. Gamma Factor for Density Gradient Model on page 1422 |  |
| Ignore |  | - (r) Compute, but do not apply quantum correction. |

1594

G: Command File Overview
Physics

Table 293 eQuantumPotential() and hQuantumPotential() Density Gradient Model on page 316 (Continued)

| LocalModel | =<ident> [(Table 358) ] | (r) Name of PMI for apparent band-edge shift. Chapter 14, p. 303, Apparent Band-Edge Shift on page 1268 |
| --- | --- | --- |
| =SchenkBGN_elec | (r) Schenk bandgap narrowing model for electrons. Schenk Bandgap Narrowing Model on page 265 |  |
| =SchenkBGN_hole | (r) Schenk bandgap narrowing model for holes. Schenk Bandgap Narrowing Model on page 265 |  |
| LocalModelOnly |  | – (r) Use with the LocalModel specification. Automatically sets γ = 0 in density gradient specification. |
| ParameterSetName | =<string> | Name of QuantumPotentialParameters parameter set. Named Parameter Sets for the Density Gradient Model on page 321 |
| Resolve |  | – (r) Use more accurate discretization of non-heterointerfaces. |

Table 294 eSHEDistributionl(), hSHEDistribution() Spherical Harmonics Expansion Method on page 802

| AdjustImpurityScattering |  | + Use an option to adjust impurity scattering to match the low-field mobility specified in the Physics section. |
| --- | --- | --- |
| FullBand |  | – Use the full band structure with the default band-structure file. |
| =<string> | ! File name of the user-defined band-structure file. |  |
| RTA |  | – Use relaxation time approximation. |

Table 295 ExternalBoltzmannSolver() External Boltzmann Solver on page 314

| Carriers=( | Electron \| Hole) | Use quantum correction for electrons or holes. |
| --- | --- | --- |
| ContactName | =<string> | Name of contact for which Sentaurus Device sends the value of the current to the Subband-BTE solver of Sentaurus Device QTX for outputting current–voltage characteristics. |
| DampingLength | =<float> | 0.005 μm Distance from volume enclosed by slices beyond which quantum correction and effective mobility, if activated, is deactivated. |
| MaxMismatch | =<float> | 1e-4 μm Tolerance in matching of slice meshes and device mesh. |

# G: Command File Overview

Physics

Table 295 ExternalBoltzmannSolver() External Boltzmann Solver on page 314 (Continued)

| Mobility( | <carrier> | Activate extraction of effective mobility by Subband-BTE solver of Sentaurus Device QTX, which is applied to 3D domain enclosed by slices in Sentaurus Device. The specification of exactly one carrier type is mandatory. |
| --- | --- | --- |
| (-DisableInternalMobilityModels)) | Enable Sentaurus Device mobility models so that the effective mobility extracted by the Subband-BTE solver of Sentaurus Device QTX can complement certain mobility models specified in the Sentaurus Device command file. |  |
| NumberOfSlices | =<2..> | \* Number of slices. |
| SBTECommandFile | =<string> | Start the Subband-BTE solver automatically using this command file. |
| Volume | =<string> | Domain in which to restrict quantum corrections and effective mobility, if activated. |

Table 296 ExternalSchroedinger() External 2D Schrödinger Solver on page 312

| Carriers=( | Electron | Use quantum correction for electrons. |
| --- | --- | --- |
| Hole) | Use quantum correction for holes. |  |
| DampingLength | =<float> | 0.005 µm Distance from volume enclosed by slices beyond which quantum correction is disabled. |
| MaxMismatch | =<float> | 1e-4 µm Tolerance in matching of slice meshes and device mesh. |
| NumberOfSlices | =<2..> | \* Number of slices. |
| SBandCommandFile | =<string> | Start Sentaurus Band Structure automatically, using this command file. |
| Volume | =<string> | Domain in which to restrict quantum corrections. |

Table 297 GateCurrent() Chapter 24, p. 767, Chapter 25, p. 793

| <ident>( | <carrier>... [[Table 358]](Table 358)) | (i) Use PMI model <ident> to compute hot-carrier injection. Hot-Carrier Injection on page 1431 |
| --- | --- | --- |
| DirectTunneling |  | (i) Schenk direct tunneling model. Direct Tunneling on page 770 |
| eFiegna | ([Table 290) ] | (i) Fiegna model for electrons. Fiegna Hot-Carrier Injection on page 799 |
| eLucky | ([Table 290) ] | (i) Lucky electron model. Classical Lucky Electron Injection on page 798 |
| eSHEDistribution |  | (i) SHE distribution model for electrons. SHE Distribution Hot-Carrier Injection on page 801 |

**G: Command File Overview**

Physics

Table 297 GateCurrent() Chapter 24, p. 767, Chapter 25, p. 793 (Continued)

| Fowler |  | (i) Fowler–Nordheim tunneling. Fowler–Nordheim Tunneling on page 768 |
| --- | --- | --- |
| (EVB) | (i) Fowler–Nordheim valence band tunneling of electrons. Fowler–Nordheim Tunneling on page 768 |  |
| GateName | =<string> | (i) Electrode for monitoring gate current. Overview of Hot-Carrier Injection Models on page 793 |
| hFiegna | ([Table 290) ] | (i) Fiegna model for holes. Fiegna Hot-Carrier Injection on page 799 |
| hLucky | ([Table 290) ] | (i) Lucky hole model. Classical Lucky Electron Injection on page 798 |
| hSHEDistribution |  | (i) SHE distribution model for holes. SHE Distribution Hot-Carrier Injection on page 801 |
| InjectionRegion | =<string> | Regions to which hot carriers are injected. Destination of Injected Current on page 794 |
| Interface |  | (i) Activate carrier injection with explicitly evaluated boundary conditions for continuity equations during a transient (Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity Equations on page 815) or if not in transient monitor interface current. Overview of Hot-Carrier Injection Models on page 793 |

Table 298 Gaussian() in IntensityDistribution() Spatial Intensity Function Excitation on page 630

| Length | =(<float>,<float>) | Length of Gaussian decay, cannot specify together with Sigma. |
| --- | --- | --- |
| PeakPosition | =(<float>,<float>) | Peak position of the Gaussian profile, in local coordinate of the defined shape function. |
| PeakWidth | =(<float>,<float>) | Width of the plateau of the modified Gaussian profile. |
| Scaling | =<float> | Scaling factor for the Gaussian profile. |
| Sigma | =(<float>,<float>) | Sigma of Gaussian decay, cannot specify together with Length. |

Table 299 Geometric() in RandomizedVariation() Geometric Variations on page 752

| Table 225 |  | Statistical properties of the correlation. |
| --- | --- | --- |
| Table 321 |  | Spatial restriction of variation. |
| Amplitude | =<vector> | 0 μm Vectorial amplitude for displacement. |
| Amplitude_Iso | =<float> | 0 μm Isotropic amplitude for displacement. |
| Options | =<0..1> | 0 Select approximation specific to insulator position variations. |

# G: Command File Overview

Physics

Table 299 Geometric() in RandomizedVariation() Geometric Variations on page 752

| Surface | =<string> | ! Name of varying surface. |
| --- | --- | --- |
| WeightDielectic | =<float> | 0 Interpolation coefficient between two approximations of dielectric term. |
| WeightQuantumPotential | =<float> | 0.5 Interpolation coefficient between two approximations for density-gradient quantum-correction term. |

Table 300 GeometricFluctuations in Noise() Random Geometric Fluctuations on page 738

| Table 321 |  | Spatial restriction of variation. |
| --- | --- | --- |
| Options | =<0..1> | 0 Select approximation specific to insulator position variations. |
| WeightDielectic | =<float> | 0 Interpolation coefficient between two approximations of dielectric term. |
| WeightQuantumPotential | =<float> | 0.5 Interpolation coefficient between two approximations for density-gradient quantum-correction term. |

Table 301 GeometricVariation() in DeterministicVariation() Deterministic Geometric Variations on page 759

| Table 321 |  | Spatial restriction of variation. |
| --- | --- | --- |
| Amplitude | =<vector> | µm Vectorial amplitude for displacement. |
| Amplitude_Iso | =<float> | µm Isotropic amplitude for displacement. |
| Options | =<0..1> | 0 Select approximation specific to insulator position variations. |
| Surface | =<string> | ! Name of varying surface. |
| WeightDielectic | =<float> | 0 Interpolation coefficient between two approximations of dielectric term. |
| WeightQuantumPotential | =<float> | 0.5 Interpolation coefficient between two approximations for density-gradient quantum-correction term. |

Table 302 HeatCapacity() Heat Capacity on page 967

| <ident> | ([Table 358) ] | PMI model <ident> for lattice heat capacity. Heat Capacity on page 1300 |
| --- | --- | --- |
| Constant |  | Constant lattice heat capacity. |
| PMIModel( | Table 318 | Use multistate configuration–dependent model. |
| TempDep |  | \* Temperature-dependent lattice heat capacity. |

**G: Command File Overview**
Physics

Table 303 HydrogenAtom(), HydrogenIon(), HydrogenMolecule() in Hydrogen Transport on page 555

| Alpha | =<ident> | Use PMI model for prefactor of the thermal diffusion term $\alpha_{td}$. |
| --- | --- | --- |
| Diffusivity | =<ident> | Use PMI model for $D_i \exp(-E_{di}/(kT))$. |

Table 304 HydrogenDiffusion() Hydrogen Transport on page 555

| HydrogenAtom( | Table 303) | Hydrogen atom specification. |
| --- | --- | --- |
| HydrogenIon( | Table 303) | Hydrogen ion specification. |
| HydrogenMolecule( | Table 303) | Hydrogen molecule specification. |
| HydrogenReaction( | Table 305) | Reactions Between Mobile Elements on page 557 |

**NOTE** In Table 305, $d$ is 3 for bulk reactions and 2 for interface reactions.

Table 305 HydrogenReaction() Reactions Between Mobile Elements on page 557

| FieldFromMaterial | =<string> | (i) Material where the electric field is obtained. |
| --- | --- | --- |
| FieldFromRegion | =<string> | (i) Region where the electric field is obtained. |
| ForwardReactionCoef | =<float> | 0 /cm$^d$s Forward reaction coefficient. |
| ForwardReactionEnergy | =<float> | 0 eV Forward reaction activation energy. |
| ForwardReactionFieldCoef | =<float> | 0 cm/V Forward reaction field coefficient. |
| LHSCoef ( |  | Define particle numbers to be removed. |
| Electron=<int> | 0 Number of electrons to be removed. |  |
| Hole=<int> | 0 Number of holes to be removed. |  |
| HydrogenAtom=<int> | 0 Number of hydrogen atoms to be removed. |  |
| HydrogenIon=<int> | 0 Number of hydrogen ions to be removed. |  |
| HydrogenMolecule=<int>) | 0 Number of hydrogen molecules to be removed. |  |
| Material | =<string> | (i) Material where the recombination rate enters. |
| Region | =<string> | (i) Region where the recombination rate enters. |
| ReverseReactionCoef | =<float> | 0 /cm$^d$s Reverse reaction coefficient. |
| ReverseReactionEnergy | =<float> | 0 eV Reverse reaction activation energy. |
| ReverseReactionFieldCoef | =<float> | 0 cm/V Reverse reaction field coefficient. |

1599

# G: Command File Overview

Physics

Table 305 HydrogenReaction() Reactions Between Mobile Elements on page 557

| RHSCoef ( |  | Define particle numbers to be created. |
| --- | --- | --- |
| Electron=<int> | 0 Number of electrons to be created. |  |
| Hole=<int> | 0 Number of holes to be created. |  |
| HydrogenAtom=<int> | 0 Number of hydrogen atoms to be created. |  |
| HydrogenIon=<int> | 0 Number of hydrogen ions to be created. |  |
| HydrogenMolecule=<int>) | 0 Number of hydrogen molecules to be created. |  |

Table 306 IncompleteIonization() Chapter 13, p. 293

| Dopants | =<string> | Restrict incomplete ionization to dopants named in <string>. Dopant names are separated by spaces. |
| --- | --- | --- |
| Model( | <ident>(<string> [[Table 358]](table_358))) | Use PMI model <ident> for species named in <string>. Incomplete Ionization on page 1438 |
| Split( | Doping=<string> | Dopant that is redistributed into multiple lattice sites. Multiple Lattice Sites on page 299 |
| Weights=(<float>...) ) | Occupation probabilities of the various lattice sites. Multiple Lattice Sites on page 299 |  |

Table 307 Mechanics() Mechanics Solver on page 957

| binary | =<string> | Name of the Sentaurus Interconnect binary. Mechanics Solver on page 957 |
| --- | --- | --- |
| command | =<string> | Sentaurus Interconnect Tcl commands. Mechanics Solver on page 957 |
| initial_structure | =<string> | Initial structure for first call of Sentaurus Interconnect. Mechanics Solver on page 957 |
| parameter | =<string> | Sentaurus Interconnect parameters. Mechanics Solver on page 957 |

**G: Command File Overview**
Physics

Table 308 MetalWorkfunction() Metal Workfunction on page 252

| Randomize( | AtInsulatorInterface | off (r) Randomize workfunction at metal–insulator vertices only. Metal Workfunction Randomization on page 253 |
| --- | --- | --- |
| AverageGrainSize=<float> | ! (r) Average metal grain size. Metal Workfunction Randomization on page 253 |  |
| GrainProbability= (<float>...) | ! (r) Probabilities that grains will have a certain workfunction value. Metal Workfunction Randomization on page 253 |  |
| GrainWorkfunction= (<float>...) | ! eV (r) Workfunction values corresponding to the above probabilities. Metal Workfunction Randomization on page 253 |  |
| RandomSeed=<int> | Seed for the random number generator. Metal Workfunction Randomization on page 253 |  |
| UniformDistribution) | off (r) Attempt to evenly distribute uniformly sized grains. Metal Workfunction Randomization on page 253 |  |
| SFactor | =<string> | Dataset for the spatial distribution of metal workfunction. Metal Workfunction on page 252 |
| =<ident> [ (Table 358) ] | Name of model to be used by the PMI to compute the spatial distribution of metal workfunction. Space Factor on page 1446 |  |
| [Factor=<float>] | ! Scale factor for normalized SFactor values. Metal Workfunction on page 252 |  |
| [Offset=<float>] | ! Offset for raw or normalized SFactor values. Metal Workfunction on page 252 |  |
| Workfunction | =<float> | eV Metal workfunction. Metal Workfunction on page 252 |
| =(<float> <float>*3)... | eV , µm , µm , µm Metal workfunction–position quadruplets. Metal Workfunction on page 252 |  |

Table 309 Model(), options of stress-dependent models Chapter 31 on page 885

| DeformationPotential ( |  | Linear deformation potential model for computing band structure. Deformation of Band Structure on page 890 |
| --- | --- | --- |
| ekp | k · p method for electron bands to account for shear strain components. Deformation of Band Structure on page 890 |  |
| hkp | 6 × 6 k · p method for hole bands. Deformation of Band Structure on page 890 |  |
| Minimum | Compute conduction and valence band edges using minimum band energies. Deformation of Band Structure on page 890 |  |
| multivalley) | Compute conduction and valance band edges using Multivalley band structure. Using Deformation Potential Model on page 893 |  |

1601

# G: Command File Overview

Physics

Table 309 Model(), options of stress-dependent models Chapter 31 on page 885

| DOS( | eMass | Strained electron effective mass and DOS model. Strained Electron Effective Mass and DOS on page 895 |
| --- | --- | --- |
| hMass | Strained hole effective mass and DOS model. Strained Hole Effective Mass and DOS on page 897 |  |
| hMass(AnalyticLTFit) | Strained hole effective mass and DOS model with analytic lattice temperature fit. Strained Hole Effective Mass and DOS on page 897 |  |
| hMass(NumericalIntegration) ) | Strained hole effective mass and DOS model with numeric integrations. Strained Hole Effective Mass and DOS on page 897 |  |
| Mobility( | eFactor[(Table 322)] | Piezoresistive factor for electrons. Isotropic Factor Models on page 937 |
| eMinorityFactor=<float> | 1.0 Factor to scale stress effect for minority electrons. Stress Mobility Model for Minority Carriers on page 944 |  |
| eMinorityFactor( DopingThreshold=<float>)= <float> | 1.0 Factor to scale stress effect for minority electrons with no doping dependency. Stress Mobility Model for Minority Carriers on page 944 |  |
| eSaturationFactor=<float> | 1.0 Saturation factor for electrons. Dependency of Saturation Velocity on Stress on page 946 |  |
| eSubband(BalMob) | Stress-induced change of the electron ballistic mobility. Multivalley Ballistic Mobility Model on page 918 |  |
| eSubband(Doping) | Strain-induced subband model for electrons with doping dependency. Multivalley Electron Mobility Model on page 903 |  |
| eSubband(EffectiveMass) ) | Stress-induced change of the electron effective mass. Effective Mass on page 906 |  |
| eSubband(EffectiveMass( -Transport)) | Exclude 2D inverse transport mass tensor transformation. Effective Mass on page 906 |  |
| eSubband(EffectiveMass( Transport<vector>)) | Activate 1D inverse transport mass tensor transformation. Effective Mass on page 906 |  |
| eSubband(EqRefMob) | Activate the equilibrium reference mobility computation. Using Multivalley Transferred Carrier Mobility Model on page 921 |  |
| eSubband(Fermi) | Strain-induced subband model for electrons with carrier concentration (Fermi statistics) dependency. Multivalley Electron Mobility Model on page 903 |  |
| eSubband(NoStressInDDmob) | Account for only ballistic mobility. Using Multivalley Ballistic Mobility Model on page 919 |  |

G: Command File Overview

Physics

Table 309 Model(), options of stress-dependent models Chapter 31 on page 885

| Mobility( | eSubband(Scattering) | Strain-induced subband model for electrons with scattering. Intervalley Scattering on page 904 |
| --- | --- | --- |
| eSubband(Scattering(MLDA)) | Strain-induced subband model with interface scattering. Intervalley Scattering on page 904 |  |
| eSubband(-RelChDir110) | Use <100> channel direction in reference mobility. Using Multivalley Electron Mobility Model on page 910 |  |
| eSubband(-AutoOrientation) | Use full tensor reference mobility. Using Multivalley Electron Mobility Model on page 910 |  |
| eTensor[(Table 322)] | Piezoresistive tensor for electrons. Piezoresistance Mobility Model on page 926 |  |
| Factor[(Table 322)] | Piezoresistive factor for electrons and holes. Isotropic Factor Models on page 937 |  |
| hFactor[(Table 322)] | Piezoresistive factor for holes. Isotropic Factor Models on page 937 |  |
| hMinorityFactor=<float> | 1.0 Factor to scale stress effect for minority holes. Stress Mobility Model for Minority Carriers on page 944 |  |
| hMinorityFactor( DopingThreshold=<float>)= <float> | 1.0 Factor to scale stress effect for minority holes with no doping dependency. Stress Mobility Model for Minority Carriers on page 944 |  |
| hSaturationFactor=<float> | 1.0 Saturation factor for holes. Dependency of Saturation Velocity on Stress on page 946 |  |
| hSixband | Intel stress-induced model for holes. Intel Stress-Induced Hole Mobility Model on page 921 |  |
| hSixband(Doping) | Intel stress-induced model for holes with doping dependency. Intel Stress-Induced Hole Mobility Model on page 921 |  |
| hSixband(Fermi ) | Intel stress-induced model for holes with carrier concentration (Fermi statistics) dependency. Intel Stress-Induced Hole Mobility Model on page 921 |  |
| hSubband(BalMob) | Stress-induced change of the hole ballistic mobility. Multivalley Ballistic Mobility Model on page 918 |  |
| hSubband(Doping) | Strain-induced subband model for holes with doping dependency. Multivalley Hole Mobility Model on page 913 |  |
| hSubband(EffectiveMass) | Stress-induced change of the holes effective mass. Effective Mass on page 913 |  |
| hSubband(EffectiveMass( Transport)) | Activate 2D inverse transport mass tensor transformation. Effective Mass on page 913 |  |

# G: Command File Overview

Physics

Table 309 Model(), options of stress-dependent models Chapter 31 on page 885

| Mobility( | hSubband(EffectiveMass( Transport<vector>)) | Activate 1D inverse transport mass tensor transformation. Effective Mass on page 913 |
| --- | --- | --- |
| hSubband(EqRefMob) | Activate the equilibrium reference mobility computation. Using Multivalley Transferred Carrier Mobility Model on page 921 |  |
| hSubband(Fermi) | Strain-induced subband model for holes with carrier concentration (Fermi statistics) dependency. Multivalley Hole Mobility Model on page 913 |  |
| hSubband(NoStressInDDmob) | Account for only ballistic mobility. Using Multivalley Ballistic Mobility Model on page 919 |  |
| hSubband(Scattering) | Strain-induced subband model for holes with bulk scattering. Scattering on page 914 |  |
| hSubband(Scattering(MLDA)) | Strain-induced subband model for holes with interface scattering. Scattering on page 914 |  |
| hSubband(-RelChDir110) | Use <100> channel direction in reference mobility. Using Multivalley Hole Mobility Model on page 916 |  |
| hSubband(-AutoOrientation) | Use full tensor reference mobility. Using Multivalley Hole Mobility Model on page 916 |  |
| hTensor[(Table 322)] | Piezoresistive tensor for holes. Piezoresistance Mobility Model on page 926 |  |
| SaturationFactor=<float> | 1.0 Saturation factor for electrons and holes. Dependency of Saturation Velocity on Stress on page 946 |  |
| Tensor[(Table 322)] ) | Piezoresistive tensor for electrons and holes. Piezoresistance Mobility Model on page 926 |  |

Table 310 MoleFraction() Mole-Fraction Specification on page 17

| Grading(( |  | Alternative way to specify grading; allows a nonzero mole fraction and different distance of grading from different parts of the boundaries. |
| --- | --- | --- |
| GrDistance=<float> | μm Distance in the direction normal to the specified interface, where linear interpolation of mole fractions from the constant value to the specified boundary mole fractions occurs. |  |
| RegionInterface= (<string>*2) | Restrict this grading to the given interface (applied to all interfaces by default). |  |
| xFraction=<[0,1]> | Boundary xMoleFraction. |  |
| yFraction=<[0,1]>)...) | Boundary yMoleFraction. |  |

G: Command File Overview
Physics

## Table 310 MoleFraction() Mole-Fraction Specification on page 17 (Continued)

| GrDistance | =<float> | µm Distance in the direction normal to the boundaries of the specified regions where linear interpolation of mole fractions from the specified constant value to 0 occurs. |
| --- | --- | --- |
| RegionName | =[<string>...] | List of regions where the mole-fraction specification will take effect. |
| =<string> | Regions where the mole-fraction specification will take effect. |  |
| xFraction | =<[0,1]> | Constant value of xMoleFraction. |
| yFraction | =<[0,1]> | Constant value of yMoleFraction. |

## Table 311 MSConfig() Chapter 18, p. 527

| BandEdgeShift( | <ident> [(Table 358)] [<int>]) | Compute band-edge shifts for conduction and valence by PMI model <ident> with optional constructor argument <int>. Apparent Band-Edge Shift on page 537 |
| --- | --- | --- |
| Conc | =<float> | 0 cm-d Concentration of states ($d = 3$ for bulk; $d = 2$ for interface MSCs). |
| eBandEdgeShift( | <ident> [(Table 358)] [<int>]) | Compute band-edge shift for conduction band by PMI model <ident> with optional constructor argument <int>. Apparent Band-Edge Shift on page 537 |
| Elimination |  | + Switch solving algorithm. |
| hBandEdgeShift( | <ident> [(Table 358)] [<int>]) | Compute band-edge shift for valence band by PMI model <ident> with optional constructor argument <int>. Apparent Band-Edge Shift on page 537 |
| Name | =<string> | ! Identifier of MSConfig. |
| State( |  | ! Define a state (at least two required). |
| Charge=<int> | 0 Number of positive elementary charges. |  |
| Hydrogen=<int> | 0 Number of hydrogen atoms. |  |
| Name=<string>) | ! Identifier of state. |  |
| Transition( | Table 324 | ! Define a transition. |

## Table 312 NBTI() Two-Stage NBTI Degradation Model on page 564

| Conc | =<float> | 0 cm-2 Concentration of NBTI traps. |
| --- | --- | --- |
| NumberOfSamples | =<int> | 0 Number of random samples. |
| hSHEDistribution |  | - Use hole-energy distribution function. |

# G: Command File Overview

Physics

Table 313 Noise() Chapter 23, p. 729

| BandEdgeFluctuations | <string> (Table 321) | Band edge fluctuations. Random Band Edge Fluctuations on page 742 |
| --- | --- | --- |
| ConductivityFluctuations | <string> (Table 321) | Metal conductivity fluctuations. Random Metal Conductivity Fluctuations on page 743 |
| DiffusionNoise( | Table 321 | Diffusion noise, spatially restricted Diffusion Noise on page 735 |
| e_h_Temperature | Noise temperatures are the respective carrier temperatures. |  |
| eTemperature | Noise temperature is electron temperature for electrons, lattice temperature for holes. |  |
| hTemperature | Noise temperature is lattice temperature for electrons, hole temperature for holes. |  |
| LatticeTemperature) | \* Noise temperature is lattice temperature. |  |
| Doping( | Table 285) | Random dopant fluctuations |
| EpsilonFluctuations | <string> (Table 321) | Dielectric constant fluctuations. Random Dielectric Constant Fluctuations on page 744 |
| FlickerGRNoise( | Table 321) | Bulk flicker noise. Bulk Flicker Noise on page 736 |
| GeometricFluctuations | <string> (Table 300) | Geometric fluctuations for surface <string>. Random Geometric Fluctuations on page 738 |
| MonopolarGRNoise( | Table 321) | Equivalent monopolar noise. Equivalent Monopolar Generation–Recombination Noise on page 736 |
| TrapConcentration( | Table 321) | Trap concentration fluctuations. Random Trap Concentration Fluctuations on page 741 |
| Traps( | Table 321) | Trapping noise. Trapping Noise on page 736 |
| WorkfunctionFluctuations | <string> (Table 321) | Workfunction fluctuations for surface <string>. Random Workfunction Fluctuations on page 741 |

Table 314 Optics() Transfer Matrix Method on page 680 and Beam Propagation Method on page 702

| Table 268 | Optics standalone. |  |
| --- | --- | --- |
| BPMScalar( | Table 235) | Scalar beam propagation method (BPM) solver. Beam Propagation Method on page 702 |
| TMM( | Table 262) | Transfer matrix method (TMM) solver. Transfer Matrix Method on page 680 |

G: Command File Overview

Physics

Table 315 Optics() Specifying the Type of Optical Generation Computation on page 594

| ComplexRefractiveIndex( | Table 282) | Complex refractive index models. Complex Refractive Index Model on page 640 |  |
| --- | --- | --- | --- |
| Excitation |  | Specification of excitation parameters. Setting the Excitation Parameters on page 620 |  |
| ( | fromBottom \| fromTop | Growth orientation from the bottom or the top of the device structure. Common Illumination Configurations on page 626 |  |
| Intensity=<float> | Wcm-2 |  |  |
| Phi=<float> | 0 deg Angle between projection of propagation direction on xy plane and x-axis. |  |  |
| Polarization=<float> | 0 [0,1] Definition of polarization as in Using Transfer Matrix Method on page 685. |  |  |
| Polarization=<ident> | TM Transverse electric (TE) or transverse magnetic (TM) polarized light. |  |  |
| PolarizationAngle=<float> | 0 deg Angle between H-field and $z \times \hat{k}$ used for vectorial solvers only. |  |  |
| ReferenceSurface= IlluminationWindow \| PropagationDirectionNormal | PropagationDirectionNormal Reference surface with respect to which the intensity is defined (only applies to TMM and OptBeam solvers). Setting the Excitation Parameters on page 620 |  |  |
| Theta=<float> | 0 deg Angle between propagation direction and z-axis. |  |  |
| Wavelength=<float>) | μm |  |  |
| Window (Table 326) |  |  |  |
| OpticalGeneration( | Table 247) | Optical generation models. Specifying the Type of Optical Generation Computation on page 594 |  |
| OpticalSolver |  | Specification of optical solver method. Specifying the Optical Solver on page 614 |  |
| ( | BPM (Table 235) |  |  |
| Composite | Composite Method on page 711 |  |  |
| FDTD (Table 239) |  |  |  |
| FromFile (Table 240) |  |  |  |
| OptBeam (Table 246) |  |  |  |
| RayTracing (Table 253) | Raytracer on page 648 |  |  |
| TMM (Table 262) ) | Note that Excitation section must not be defined in TMM section. Using Transfer Matrix Method on page 685 |  |  |

# G: Command File Overview

Physics

Table 315 Optics() Specifying the Type of Optical Generation Computation on page 594 (Continued)

| Verbosity | =<int> | 1 Verbosity level for optical solver output. A verbosity level of 0 suppresses all optical solver output. |
| --- | --- | --- |

Table 316 ParameterVariation() in DeterministicVariation() Parameter Variations on page 760

| Factor | =<float> | 1 1 Multiplier for original parameter value. |
| --- | --- | --- |
| Material | =<string> | Material location of varied parameter. |
| MaterialInterface | =<string> | Material interface location of varied parameter. |
| Model | =<string> | ! Model to which varied parameter belongs. |
| Parameter | =<string> | ! Name of the varied parameter. |
| Region | =<string> | Region location of varied parameter. |
| RegionInterface | =<string> | Region interface location of varied parameter. |
| Summand= | =<float> | 0 Summand to original parameter value. |
| Value= | =<float> | Modified parameter value. |

Table 317 Piezo() Chapter 31, p. 885

| Model( | Table 309) | Stress-dependent models. Deformation of Band Structure on page 890 to Mobility Modeling on page 902 |
| --- | --- | --- |
| OriKddX | =<vector> | (1 0 0) Miller indices of the stress system relative to the simulation system. |
| OriKddY | =<vector> | (0 1 0) Miller indices of the stress system relative to the simulation system. |
| Strain | =(<float>*6) | Components $xx$, $yy$, $zz$, $yz$, $xz$, $xy$ of strain tensor. |
| =Hooke | Use Hooke’s law to compute strain tensor from stress tensor. Eq. 972, p. 886 |  |
| =LoadFromFile | Load strain from `Piezo` file specified in `File` section. |  |
| Stress | =(<float>*6) | Pa Components $xx$, $yy$, $zz$, $yz$, $xz$, $xy$ of stress tensor. |
| =<ident> ([Table 358)] | Use PMI model <ident> to compute stress. Stress on page 1352 |  |

**G: Command File Overview**
Physics

Table 318 PMIModel() Multistate Configuration–Dependent Bulk Mobility on page 1287, High-Field Saturation With Two Driving Forces on page 1255, Multistate Configuration–Dependent Thermal Conductivity on page 1293, Multistate Configuration–Dependent Heat Capacity on page 1290

| Index | =<int> | 0 Number passed to and interpreted by PMI model. |
| --- | --- | --- |
| MSConfig | =<string> | Name of multistate configuration on which PMI depends. |
| Name | =<string> | ! Name of PMI model. |
| String | =<string> | String passed to and interpreted by PMI model. |
| Table 358 |  | PMI parameters. |

Table 319 RandomizedVariation() in Physics{} Statistical Impedance Field Method on page 745

| BandEdge | <string> (Table 280) | – Band Edge Variations on page 753 |
| --- | --- | --- |
| Conductivity | <string> (Table 283) | – Metal Conductivity Variations on page 754 |
| Doping( | Table 286) | – Doping Variations on page 749 |
| DopingVariation | <string> (Table 288) | – Doping Profile Variations on page 756 |
| Epsilon | <string> (Table 292) | – Dielectric Constant Variations on page 755 |
| Geometric | <string> (Table 299) | – Geometric Variations on page 752 |
| TrapConcentration( | Table 321) | – Trap Concentration Variations on page 750 |
| Workfunction | <string> (Table 327) | – Workfunction Variations on page 751 |

Table 320 Schroedinger() 1D Schrödinger Equation on page 305

| DensityTail | =Extrapolate | \* Use estimate for lowest noncomputed subband energy as $$E_{max, v}$$. Eq. 229, p. 311 |
| --- | --- | --- |
| =MaxEnergy | Use highest computed subband energy as $$E_{max, v}$$. Eq. 229, p. 311 |  |
| eDensityCorrection |  | + Activate electron quantization model in the quantum well. 1D Schrödinger Equation on page 305 |
| Electron |  | – Solve Schrödinger equation for electrons. |
| EnergyInterval | [(<carrier>)]=<float> | 0 eV Highest energy to which eigensolutions are computed, measured from the lowest interior potential point on the nonlocal line on which the Schrödinger equation is solved. When 0, only bound solutions are computed. Using the 1D Schrödinger Equation on page 307 |

# G: Command File Overview

Physics

Table 320 Schroedinger() 1D Schrödinger Equation on page 305 (Continued)

| Error | [(<carrier>)]=<0,)> | 1e-5 eV Precision target for eigenenergies. Using the 1D Schrödinger Equation on page 307 |
| --- | --- | --- |
| hDensityCorrection |  | + Activate hole quantization model in the quantum well. 1D Schrödinger Equation on page 305 |
| Hole |  | - Solve Schrödinger equation for holes. |
| MaxSolutions | [(<carrier>)]=<0..> | 5 Maximum number of eigensolutions computed per ladder. Using the 1D Schrödinger Equation on page 307 |
| Polarization | = TE \| TM \| Mixed | TE Set the polarization used for the computation of the optical transition matrix element. Optical Transition Matrix Element for Wurtzite Crystals on page 1037 |
| PolarizationFactor | =<[0,1]> | 1 Set the polarization factor used for the computation of the optical transition matrix element in mixed polarization simulations. Optical Transition Matrix Element for Wurtzite Crystals on page 1037 |
| Smooth | =<float> | 0 cm Length (measured from end of nonlocal line) over which to blend from classical to quantum density. |

Table 321 Spatial restriction Energetic and Spatial Distribution of Traps on page 490, Options Common to sIFM Variations on page 746

| SpaceMid | =<vector> | (0 0 0) µm Center of spatial distribution. |
| --- | --- | --- |
| SpaceSig | =<vector> | (1e100 1e100 1e100) µm Width of spatial distribution. |
| SpatialShape | =Gaussian | Use Gaussian shape function. |
| =Uniform | \* Use Uniform shape function. |  |

Table 322 Tensor(), eTensor(), hTensor() Piezoresistance Mobility Model on page 926, Factor(), eFactor(), hFactor() Isotropic Factor Models on page 937

| <ident> | [(Table 358)] | Use PMI model <ident> to compute piezoresistive prefactors (first-order piezoresistance tensor model only). Piezoresistive Coefficients on page 1350 |
| --- | --- | --- |
| Use PMI model <ident> to compute a mobility enhancement stress factor (isotropic factor model only). Mobility Stress Factor on page 1339 |  |  |
| ApplyToMobilityComponents |  | - Apply the Factor model enhancement to individual mobility components. Factor Models Applied to Mobility Components on page 943 |

G: Command File Overview
Physics

Table 322 Tensor(), eTensor(), hTensor() Piezoresistance Mobility Model on page 926, Factor(), eFactor(), hFactor() Isotropic Factor Models on page 937 (Continued)

| AutoOrientation |  | off Use parameter set based on orientation of nearest interface. Auto-Orientation for Piezoresistance on page 930 and Isotropic Factor Model Options on page 943 |
| --- | --- | --- |
| ChannelDirection | =<1..3> | 1 Channel direction (Factor models only). Isotropic Factor Models on page 937 |
| EffectiveStressModel |  | Use the effective stress Factor model. Effective Stress Model on page 939 |
| (AxisAlignedNormals) | off Use axis-aligned normals for the effective stress calculation. Effective Stress on page 940 |  |
| Enormal |  | off Use piezoresistive prefactors (first-order piezoresistance tensor model only). Enormal- and MoleFraction-Dependent Piezo Coefficients on page 931 |
| FirstOrder |  | \* Use the first-order piezoresistance model. Piezoresistance Mobility Model on page 926 |
| Kanda |  | off Include temperature and doping dependency. Doping and Temperature Dependency on page 928 |
| ParameterSetName | =<string> | Name of Piezoresistance or EffectiveStressModel parameter set. Named Parameter Sets for Piezoresistance on page 930 and Isotropic Factor Model Options on page 943 |
| SecondOrder |  | Use the second-order piezoresistance model. Piezoresistance Mobility Model on page 926 |
| SFactor | =<string> | Dataset for the spatial distribution of the mobility enhancement factor. SFactor Dataset or PMI Model on page 943 |
| =<ident> [[(Table 358)]](https://example.com/table358) | Name of model to be used by the PMI to compute the spatial distribution of the mobility enhancement factor. SFactor Dataset or PMI Model on page 943 and Space Factor on page 1446 |  |

Table 323 ThermalConductivity() Thermal Conductivity on page 969

| <ident> | [(Table 358) ] | Use PMI model <ident> for thermal conductivity. Thermal Conductivity on page 1311 |
| --- | --- | --- |
| Constant | Conductivity | Use constant conductivity. |
| Resistivity | Use constant resistivity. |  |
| Formula |  | Use the built-in strategy for thermal conductivity. Thermal Conductivity on page 1311 |
| PMIModel( | Table 318 ) | Use multistate configuration–dependent model. |

# G: Command File Overview

Physics

Table 323 ThermalConductivity() Thermal Conductivity on page 969 (Continued)

| TempDep | Conductivity | Use Eq. 1081, p. 969. |
| --- | --- | --- |
|  | Resistivity | Use Eq. 1080, p. 969. |

Table 324 Transition() in MSConfig() Chapter 18, p. 527

| CEModel( | <ident> ([Table 358)] [<int>]) | ! Use PMI_TrapCaptureEmission model <ident> with optional constructor argument <int>. |
| --- | --- | --- |
| FieldFromInsulator |  | – Use the insulator electric field instead of the semiconductor electric field for the MSCs defined at the semiconductor–insulator interface. |
| From | =<string> | ! Interacting state. |
| Name | =<string> | ! Identifier of transitions. |
| Reservoirs( |  | List of reservoirs for particle conservation. |
|  | <string>(Particles= <int>)...) | Reservoir <string> and number of involved particles <int>. |
| To | =<string> | ! Reference state. |

**NOTE** In Table 325, $d = 3$ for bulk traps and $d = 2$ for interface traps.

Table 325 Traps(() ...) Chapter 17, p. 489, Chapter 19, p. 543

| Table 321 |  | Spatial restriction of trap distribution. |
| --- | --- | --- |
| Acceptor |  | Acceptor trap type. Trap Types on page 490 |
| ActEnergy | =<float> | eV Equilibrium activation energy of hydrogen on Si-H bonds, $\varepsilon_A^0$. Chapter 19, p. 543 |
| Add2TotalDoping( |  | Include the trap concentration in the acceptor, donor, and total doping concentrations used to compute mobility, lifetimes, and so on. Specifying Doping Species on page 12 |
|  | ChargedTraps) | Include the charged trap concentration in the acceptor or donor doping concentrations used to compute mobility. Specifying Doping Species on page 12 |
| BarrierTunnelingEnhan | =(<float>*4) | (1 1 1 1) 1, 1, 1, 1 Barrier tunneling enhancement parameters for the Degradation model depassivation constant, $\delta_{BTe}$, $\rho_{BTe}$, $\delta_{BTh}$, and $\rho_{BTh}$. Reaction Enhancement Factors on page 548 |
| BondConc | =<float> | cm−d Total silicon dangling bond concentration $N$. Chapter 19, p. 543 |

G: Command File Overview
Physics

Table 325 Traps(() ...) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| BondConcSFactor | =<ident> ([Table 358)] | Name of model to be used by the PMI to compute the spatial distribution of bond concentration. Space Factor on page 1446 |
| --- | --- | --- |
| =<string> | Dataset for the spatial distribution of bond concentration. Using the Trap Degradation Model on page 549 |  |
| CBRate | =<ident> ([Table 358)] | Use PMI `<ident>` to compute electron capture and emission rate for conduction band. |
| =(<ident> ([Table 358)] <int>) | Use PMI `<ident>` with constructor argument `<int>` to compute electron capture and emission rate for conduction band. Trap Capture and Emission Rates on page 1356 |  |
| Conc | =<float> | cm-d or eV-1cm-d Concentration or the peak density of the trap distribution. For KMC-MIM simulation, sets defect density. Energetic and Spatial Distribution of Traps on page 490, Specifying Defects on page 1060 |
| Coupled | =Off | \* Disable trap coupling. |
| =Tunneling | Couple traps by tunneling. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |  |
| CritConc | =<float> | cm-d Critical concentration Ncrit, default 0.1N. Chapter 19, p. 543 |
| CurrentEnhan | =(<float>*4) | (0 1 0 1) 1, 1, 1, 1 Parameters of the tunneling and hot carrier-dependent terms of the depassivation constant, δTun, ρTun, δHC, and ρHC. Reaction Enhancement Factors on page 548 |
| Cutoff | =BandGap | Truncate trap energy distribution to plain band gap at 300 K. Energetic and Spatial Distribution of Traps on page 490 |
| =EffectiveBandgap | \* Truncate trap energy distribution to effective bandgap at 300 K. |  |
| =None | Do not truncate trap energy distribution. |  |
| =Simple | Use a legacy truncation of trap energy distribution. |  |
| Degradation |  | Use degradation model based on kinetic equation. Chapter 19, p. 543 |
| (PowerLaw) | Use degradation model based on power law. Chapter 19, p. 543 |  |
| DePasCoef | =<float> | s-1 Depassivation coefficient ν0 at the passivation conditions (the equilibrium at the passivation temperature T0). Chapter 19, p. 543 |
| DiffusionEnhan | =(6*<float>) | cm cm2s-1 eV cms-1 cm-3 1 Parameters of hydrogen diffusion in oxide, xP, D0, εH, kP, NH0, and Nox in Eq. 577, p. 546, Chapter 19, p. 543. |

# G: Command File Overview

Physics

Table 325 Traps(() ...) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| DirectTunnelingEnhan | =(<float>*4) | (1 1 1 1) 1, 1, 1, 1 Direct tunneling enhancement parameters for the Degradation model depassivation constant, $\delta_{DTe}$, $\rho_{DTe}$, $\delta_{DTh}$, and $\rho_{DTh}$. Reaction Enhancement Factors on page 548 |
| --- | --- | --- |
| DiscreteTrapT2T |  | Specify trap-to-trap tunneling entry. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 |
| Donor |  | Donor trap type. Trap Types on page 490 |
| eBarrierTunneling( | NonLocal=<string> | Use nonlocal tunneling from the conduction band at reference surface of all connected unnamed, and all listed, connected named nonlocal meshes. Nonlocal Tunneling for Traps on page 517 |
| TwoBand) | Use two-band dispersion. WKB Tunneling Probability on page 781 |  |
| eConstEmissionRate | =<float> | $s^{-1}$ Constant electron emission rate term to the conduction band $e_{const}^n$. Local Capture and Emission Rates on page 501 |
| eGFactor | =<float> | Electron degeneracy factor $g_n$. Trap Occupation Dynamics on page 499 |
| eHCSDegradation ( |  | Use the hot-carrier stress (HCS) degradation model for electrons. Hot-Carrier Stress Degradation Model on page 575 |
| BDEnergyIntervals=<int> | 20 Number of energy intervals to use in the bond dispersion integral. Bond Dispersion on page 579 |  |
| BondDispersion | + Use bond dispersion. Bond Dispersion on page 579 |  |
| SHE) | - Use the carrier distribution function from SHE. Spherical Harmonics Expansion Option on page 578 |  |
| eJFactor | =<float> | Electron J-model factor $g_n^J$. Local Capture and Emission Rates on page 501 |
| ElectricField | [(<carrier>)] | Field-dependent model for cross sections. J-Model for Cross Sections on page 502 |
| EmptyCharge | =<int> | 1 Set the charge state of an empty defect for KMC-MIM simulation. Applies only when `IncludeMIMChargeInPoisson` is specified. Specifying Defects on page 1060, Including the MIM Charge in the Poisson Equation on page 1074 |
| EnergyMid | =<float> | eV Central energy $E_0$ of the trap distribution. Eq. 510, p. 491 |
| EnergyShift | =<ident> ([Table 358)] | Use PMI `<ident>` to compute trap energy shift. |
| =(<ident> ([Table 358)] <int>) | Use PMI `<ident>` with constructor argument `<int>` to compute trap energy shift. Energetic and Spatial Distribution of Traps on page 490, Trap Energy Shift on page 1360 |  |
| EnergySig | =<(0,)> | eV Width $E_S$ of the trap distribution. Eq. 510, p. 491 |

1614

G: Command File Overview

Physics

Table 325 Traps(()…) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| eNeutral |  | Electron trap type. Trap Types on page 490 |
| --- | --- | --- |
| eSHEDistribution | =(<float>*6) | (0 0 0 0 1 1) (cm2A-1)ρSHE, eV, eV, eV, 1, 1 Parameters of the electron energy–dependent terms of the depassivation constant, δSHE, εth, εa, δ⊥, ρ⊥, and ρSHE. Trap Degradation Model on page 544 |
| EtEmpty | =<float> | eV Set the empty trap level measured from the conduction band for KMC-MIM simulation. Specifying Defects on page 1060 |
| EtFill | =<float> | eV Set filled trap level measured from the conduction band for KMC-MIM simulation. Specifying Defects on page 1060 |
| Exponential |  | Exponential energetic distribution. Energetic and Spatial Distribution of Traps on page 490, Eq. 510, p. 491 |
| eXsection | =<0,)> | cm2 Electron capture cross section σn0. [Local Capture and Emission Rates on page 501 |
| FieldEnhan | =(<float>*4) | (0 1 0 1) eVcmρ//V-ρ//, 1, eVcmρ⊥V-ρ⊥, 1 Parameters of the electric field–dependent terms of the Si-H bond energy and the activation energy, δ//, ρ//, δ⊥, and ρ⊥. Chapter 19, p. 543 |
| FillFrac | =<float> | Initial fraction of defects that are filled with electrons in KMC-MIM simulations. Specifying Defects on page 1060 |
| FixedCharge |  | Fixed charge. Trap Types on page 490, Insulator Fixed Charges on page 524 |
| FluenceDependence | =(<float>*3) | (0 0 0) 1 1 1 Activate fluence degradation model with the given parameters βF, fcb, and fvb. Fluence Model on page 554 |
| FowlerNordheimEnhan | =(<float>*4) | (1 1) 1, 1 Fowler–Nordheim tunneling enhancement parameters for the Degradation model depassivation constant, δFN, and ρFN. Reaction Enhancement Factors on page 548 |
| fromCondBand |  | Zero point for E0 is conduction band. Eq. 511, p. 492 |
| fromMidBandGap |  | Zero point for E0 is intrinsic energy. Eq. 511, p. 492 |
| fromValBand |  | Zero point for E0 is valence band. Eq. 511, p. 492 |
| gamma |  | 1 1 Prefactor for elastic tunneling Electron Capture Rate for the Elastic Transition on page 519 |
| Gaussian |  | Gaussian energetic distribution. Energetic and Spatial Distribution of Traps on page 490, Eq. 510, p. 491 |

# G: Command File Overview

Physics

Table 325 Traps(() ...) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| GrainBoundary ( |  | Generate traps on the grain boundary. A prerequisite is that the grain field must be generated with `GrainFieldGenerator` specified in the `Math` section. Specifying Defects on page 1060 |
| --- | --- | --- |
| Density=<float> | cm-2 for 3D device, cm-1 for 2D device Defect density on the grain boundary. The calculated number of defects is then randomized over the insulator volume inside the KMC simulation space. |  |
| EtEmpty=<float> | eV Set the empty grain-boundary trap level measured from the conduction band. |  |
| EtFill=<float> | eV Set the filled grain-boundary trap level measured from the conduction band. |  |
| FillFrac=<float> | Set the initial fraction of defects that are filled with electrons. |  |
| TrapSigma=<float>) | eV Randomizes the grain-boundary trap energy levels by using a Gaussian distribution with this standard deviation. |  |
| hBarrierTunneling( | NonLocal=<string> | Use nonlocal tunneling from the valence band at reference surface of all connected unnamed, and all listed, connected named nonlocal meshes. Nonlocal Tunneling for Traps on page 517 |
| TwoBand) | Use two-band dispersion. WKB Tunneling Probability on page 781 |  |
| hConstEmissionRate | =<float> | s-1 Constant hole emission rate to the valence band $e_{p,const}^p$. Local Capture and Emission Rates on page 501 |
| hGFactor | =<float> | Hole degeneracy factor $g_p$. Trap Occupation Dynamics on page 499 |
| hHCSDegradation ( |  | Use the HCS degradation model for holes. Hot-Carrier Stress Degradation Model on page 575 |
| BDEnergyIntervals=<int> | 20 Number of energy intervals to use in the bond dispersion integral. Bond Dispersion on page 579 |  |
| BondDispersion | + Use bond dispersion. Bond Dispersion on page 579 |  |
| SHE) | - Use the carrier distribution function from SHE. Spherical Harmonics Expansion Option on page 578 |  |
| hJFactor | =<float> | Hole J-model factor $g_p^J$. Local Capture and Emission Rates on page 501 |
| hNeutral |  | Hole trap type. Trap Types on page 490 |
| hSHEDistribution | =(<float>*6) | (0 0 0 0 1 1) (cm2A-1)PSHE, eV, eV, eV, 1, 1 Parameters of the hole energy-dependent terms of the depassivation constant, $\delta_{SHE}$, $\epsilon_{th}$, $\epsilon_a$, $\delta_\perp$, $\rho_\perp$, and $\rho_{SHE}$. Trap Degradation Model on page 544 |

1616

**G: Command File Overview**
Physics

Table 325 Traps(() ...) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| HuangRhys | =<0,)> | Huang–Rhys factor. [Nonlocal Tunneling for Traps on page 517 |
| --- | --- | --- |
| hXsection | =<0,)> | cm2 Hole capture cross section σp0. [Local Capture and Emission Rates on page 501 |
| KmcMim1 \| KmcMim2 |  | Specify KMC-MIM trap type. Specifying Defects on page 1060 |
| Level |  | Trap with single energy level. Energetic and Spatial Distribution of Traps on page 490, Eq. 510, p. 491 |
| Location | =(<vector>...) | μm Locations of traps coupled by tunneling. For KMC-MIM simulations, locations of specifically placed defects. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506), Specifying Defects on page 1060 |
| =(mesh) | Select all vertices in the region for trap-to-trap tunneling. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |  |
| Makram-Ebeid | [(<carrier> <simpleCapt>)] | Use Makram–Ebeid–Lannoo model. Makram-Ebeid–Lannoo Model on page 504 |
| Material | =<string> | (i) Material to which energy specification refers. Energetic and Spatial Distribution of Traps on page 490 |
| Name | =<string> | Identifier for trap. |
| -NormalizeSfactor |  | Switch off normalization of `Sfactor` for `DiscreteTrapT2T`. Default is on. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |
| NumberOfRandomTraps | =<int> | Input number of randomly distributed traps for trap-to-trap tunneling. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |
| OutputT2TPaths | (<string>) | Name of input file to output trap-to-trap tunneling locations and linkages. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |
| PasCoef | =<float> | s-1 Passivation coefficient γ0. By default, computed automatically to provide the equilibrium, ν0Nhb0/(N - Nhb0). Chapter 19, p. 543 |
| PasTemp | =<float> | 300 K Passivation temperature T0. Chapter 19, p. 543 |
| PasVolume | =<float> | 0 cm2\|cm3 Passivation volume Ω. Chapter 19, p. 543 |
| PhononEnergy | =<0,)> | eV Phonon energy for inelastic tunneling. [Nonlocal Tunneling for Traps on page 517 |

# G: Command File Overview

Physics

Table 325 Traps(()...) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| PooleFrenkel |  | Use Poole–Frenkel model for exchange with conduction or valence band, depending on trap type. Poole–Frenkel Model for Cross Sections on page 503 |
| --- | --- | --- |
| (Electron) | Use Poole–Frenkel model for exchange with conduction band, irrespective of trap type. |  |
| (Hole) | Use Poole–Frenkel model for exchange with valence band, irrespective of trap type. |  |
| PowerEnhan | =(<float>*3) | (0 0 0) 1, V-1cm, V-1cm Parameters in the chemical potential for kinetic equation degradation and the power for degradation by power law, $\beta_0$, $\beta_{//}$, and $\beta_{\perp}$. Chapter 19, p. 543 |
| Randomize | [=<int>] | Randomize traps. Trap Randomization on page 495 |
| RandomizeEnergy | [=<int>] | Randomize energy at each vertex for the Uniform, Gaussian, or Table trap energy distributions. Energetic and Spatial Distribution of Traps on page 490 |
| Reference | =BandGap | Refer trap energies to band edges excluding bandgap narrowing. Energetic and Spatial Distribution of Traps on page 490 |
| =EffectiveBandgap | \* Refer trap energies to effective band edges. |  |
| ReferencePoint | =<vector> | Coordinate where to take the data for EnergyShift. |
| Region | =<string> | (i) Region to which energy specification refers. Energetic and Spatial Distribution of Traps on page 490 |
| SFactor | =<string> | Dataset for the spatial distribution of the traps. Energetic and Spatial Distribution of Traps on page 490 |
| =<ident> ([Table 358)] | Name of model to be used by the PMI to compute the spatial trap distribution. Space Factor on page 1446 |  |
| SimpleCapt |  | – Restrict field enhancement of trapping to the emission rates. Local Capture and Emission Rates on page 501 |
| SingleTrap |  | \* Use a single trap. Specifying Single Traps on page 494 |
| (RTN) | Specify as RTN trap. Specifying Single Traps on page 494 |  |
| T2TconcScale | =<float> | 1 Scaling factor for DiscreteTrapT2T concentration. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |
| T2TfixedConc | =<float> | 0 Fix the same concentration at every trap-to-trap vertex in the region. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |
| T2Trecombination |  | \* Switch on T2T recombination. Trap-to-Trap Recombination on page 516 |
| Table | =(<float>*2...) | eV eV-1cm-d Pairs of energy and concentration of a tabular approximation to a trap distribution. Energetic and Spatial Distribution of Traps on page 490, Eq. 510 |

1618

**G: Command File Overview**
Physics

Table 325 Traps(()...) Chapter 17, p. 489, Chapter 19, p. 543 (Continued)

| Transition | = InelasticPhonon \| ModeOscillator | ModeOscillator Choose the tunneling transition for trap-to-trap tunneling. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 |
| --- | --- | --- |
| TrapSigma | =<float> | eV Randomize trap levels using a Gaussian distribution with this standard deviation for KMC-MIM simulation. Specifying Defects on page 1060 |
| TrapVolume | =<0,)> | µm3 Interaction volume for nonlocal tunneling. [Nonlocal Tunneling for Traps on page 517 |
| Tunneling( | Hurkx[(<carrier>)] | Use Hurkx trap-assisted tunneling model. Hurkx Model for Cross Sections on page 503 |
| Uniform |  | Uniform energetic distribution. Energetic and Spatial Distribution of Traps on page 490, Eq. 510, p. 491 |
| VBRate | =<ident> [(Table 358)] | Use PMI <ident> to compute hole capture and emission rate for valence band. |
|  | =(<ident> [(Table 358)] <int>) | Use PMI <ident> with constructor argument <int> to compute hole capture and emission rate for valence band. Trap Capture and Emission Rates on page 1356 |
| Xsection | =<float> | For KMC-MIM simulations, use to calculate defect localization radius used in inelastic electrode-to-trap rate calculations. Specifying Defects on page 1060 |
| XsectionT2T | =<float> | For KMC-MIM simulations, use to calculate defect localization radius used in multiphonon trap-to-trap calculations. Specifying Defects on page 1060 |

Table 326 Window Illumination Window on page 622

| Circle( | Radius=<float>) |  |
| --- | --- | --- |
| IntensityDistribution( | Gaussian(Table 298)) | Specify spatial intensity profile. Spatial Intensity Function Excitation on page 630 |
| Line( | Dx=<float> |  |
|  | X1=<float> |  |
|  | X2=<float> |  |
| Origin | =(<float>*3) | Global location of window origin. |
| OriginAnchor | =<ident> | Center Origin anchor of illumination window in terms of cardinal direction (North, South, East, West, NorthEast, SouthEast, NorthWest, SouthWest). |

# G: Command File Overview

Physics

Table 326 Window Illumination Window on page 622 (Continued)

| Polygon( | (<float>2)n | Specification of simple polygon using several vertices. |
| --- | --- | --- |
| ((<float>2)n)*m ) | Specification of complex polygon using several loops of vertices. |  |
| Rectangle( | Dx=<float> |  |
| Dy=<float> |  |  |
| Corner1=(<float>*2) |  |  |
| Corner2=(<float>*2)) |  |  |
| RotationAngles | =(<float>*3) | Angles specifying global orientation of window coordinate system. |
| WeightedAPDintegration ( |  | - Switch on weighted absorbed photon density (APD) integration. Accurate Absorbed Photon Density for 1D Optical Solvers on page 637 |
| Mode= Auto \| Full | Auto Set integration mode of APD. Options are: Auto: Mixed wireframe and 1D integration. Full: Wireframe integration. |  |
| NumberOfCellsPerLayer=<int> | 100 Set the number of wireframe cells per layer. |  |
| NumberOfTransverseCells PerDirection=<int> | 200 Wireframe discretization parameter of the illumination window plane. |  |
| PrintInfo) | Print detailed information about wireframe integration. |  |
| XDirection | =(<float>*3) | (1, 0, 0) Direction of x-axis. |
| YDirection | =(<float>*3) | (0, 1, 0) Direction of y-axis. |

Table 327 Workfunction() in RandomizedVariation() Workfunction Variations on page 751

| Table 225 |  | Statistical properties of the correlation. |
| --- | --- | --- |
| Table 321 |  | Spatial restriction of variation. |
| Amplitude | =<float> | eV Amplitude of workfunction variation for exponential and Gaussian correlation. |
| GrainProbability | =(<(0,)>...) | Probability for grain orientation. |
| GrainWorkfunction | =(<float>...) | eV Grain workfunctions. |
| Surface | =<string> | ! Surface of variation. Workfunction Variations on page 751 |

G: Command File Overview
Plot

# Plot

Table 328 Plot{} Device Plots on page 128

| Table 190 |  | Scalar plot data. Device Plots on page 128 |
| --- | --- | --- |
| Table 190/Element |  | Scalar plot datasets defined on elements. |
| Table 190/RegionInterface |  | Scalar plot data on region interfaces; supported for just a few datasets. Interface Plots on page 131 |
| Table 190/Tensor |  | Tensorial plot data. Device Plots on page 128 |
| Table 191/Vector |  | Vectorial plot data. Device Plots on page 128 |
| Table 192/SpecialVector |  | Special vectorial plot data; supported for the SHE distribution data. SHE Distribution Hot-Carrier Injection on page 801 |
| Table 194 |  | MIM particle data. Particle Plots on page 1093 |
| Table 329 |  | Occupation rates of `MSConfig` states. Specifying Multistate Configurations on page 529 |
| DatasetsFromGrid |  | Copy datasets from TDR grid file. What to Plot on page 128 |
|  | (<ident>...) | Datasets to be copied. |
| TrappingRates |  | Trap capture and emission rates. Visualizing Traps on page 520 |
| TTOMFraction |  | Fraction of occupied traps. Transient Trap Occupancy Model on page 585 |

Table 329 MSConfig in Plot{} Specifying Multistate Configurations on page 529

| MSConfig |  | All state occupations of all `MSConfig`. |
| --- | --- | --- |
| (<string>) | All state occupations of `MSConfig` <string>. |  |
| (<string1> <string2>) | Occupation of state <string2> of `MSConfig` <string1>. |  |

**G: Command File Overview**

RayTraceBC

# RayTraceBC

Table 330 RayTraceBC{} Boundary Condition for Raytracing on page 660

| Fresnel |  | Fresnel boundary condition. |
| --- | --- | --- |
| Name | =<string> | Name of the reflectivity contact or photon-recycling contact. |
| LayerStructure{ | <float> <string> [; <float> <string>] ...} | Definition of multilayer structure used for TMM calculation. First column contains thickness of layer in µm . Second column contains material name of layer. |
| MapOptGenToRegions( | <string> <string> ...) | Specify list of regions to map the lumped TMM BC optical generation to. |
| PMIModel | =<ident> ([Table 358) ] | Name of the PMI model associated with this BC contact. |
| QuantumEfficiency | =<float> | Define the quantum efficiency of the TMM BC optical generation. |
| ReferenceMaterial | =<string> | Definition of LayerStructure orientation. The topmost layer in the LayerStructure specification is connected to the region with material ReferenceMaterial. |
| ReferenceRegion | =<string> | Definition of LayerStructure orientation. The topmost layer in the LayerStructure specification is connected to the region with name ReferenceRegion. |
| Reflectivity | =<[0,1]> | 0 Reflectivity. |
| {Side | ="X" Periodic} | Define periodic BC at opposing x-surfaces. Periodic Boundary Condition on page 669 |
| ="Y" Periodic} | Define periodic BC at opposing y-surfaces. |  |
| ="Z" Periodic} | Define periodic BC at opposing z-surfaces. |  |
| Transmittivity | =<[0,1]> | 0 Transmittivity. |

1622

S-2021.06

G: Command File Overview
Solve

# Solve

**Table 331 Solve{}**

| Table 344 |  | Solve selected standalone problem. |
| --- | --- | --- |
| Solve selected equation [for instance `<ident>`]. |  |  |
| [`<ident>`.] Table 336 |  |  |
| ACCoupled( | Table 332) | Perform small-signal and noise analysis. Small-Signal AC Analysis on page 101 |
| [`<ident>`.] Table 336...} | Equations to be solved consistently. |  |
| { |  |  |
| Continuation( | Table 333) | Continuation options. |
| Table 331} | Problem to be solved. |  |
| { |  |  |
| Coupled( | Table 334 | Solve coupled equations consistently by Newton iteration. |
| [`<ident>`.] Table 336...} | Equations to be solved. |  |
| { |  |  |
| CurrentPlot | as Load | Control current output. When to Write to the Current File on page 113 |
| HBCoupled( | Table 338 | Perform harmonic balance analysis. Harmonic Balance on page 106 |
| [`<ident>`.] Table 336...} | Equations to be solved. |  |
| { |  |  |
| Load( | Table 339 { | Load and continue with solution stored by Save. [Save and Load Statements on page 163 |
| Circuit | Load circuit. |  |
| `<ident>`...}] | Devices to be loaded. |  |
| NewCurrentPrefix | =`<string>` | Use prefix `<string>` for current file. NewCurrentPrefix Statement on page 116 |
| Plot( | Table 339 | Plot current solution. When to Plot on page 129 |
| [{`<ident>`...}] | Devices to be plotted. |  |
| Plugin( | Table 341 | Solve equations consistently by Gummel iteration. |
| Table 344 | Solve selected standalone problem. |  |
| [`<ident>`.] Table 336... | Solve selected equation (for example, `<ident>`). |  |
| Coupled(Table 334) { [`<ident>`.] Table 336... ...} | Solve coupled equations. |  |
| { |  |  |
| Quasistationary( | Table 342 | Quasistationary simulation options. |
| Table 331} | Problem to be solved. |  |
| { |  |  |

<footer>
</footer>

1623

# G: Command File Overview

Solve

Table 331 Solve{} (Continued)

| Save | as Load | Save current solution for retrieval with Load. Save and Load Statements on page 163 |
| --- | --- | --- |
| Set( | Table 343) | Set status according to Table 343. |
| SpectralPlot( | Table 339) | Plot spectral simulation results of current solution. When to Plot on page 129 and Illumination Spectrum on page 596 |
|  | [{<ident>...}] | Devices to be plotted. |
| System | (<string>) | Execute UNIX command `<string>` (ignore return status). System Command on page 176 |
| +System | (<string>) | Execute UNIX command `<string>`; use its return status to decide whether it was successful. System Command on page 176 |
| Transient( | Table 346) | Transient simulation options. |
| { | Table 331} | Problem to be solved. |
| Unset | (<ident>...) | Unset nodes. Mixed-Mode Electrical Boundary Conditions on page 69 |
|  | (TrapFilling) | Use the standard trap equations. Explicit Trap Occupation on page 496 |

Table 332 ACCoupled() Small-Signal AC Analysis on page 101

| Table 334 |  | Coupled() parameters. |
| --- | --- | --- |
| ACCompute( | Table 339) | Restrict AC or noise analysis to selected points in a Quasistationary command. |
| ACExtract | =<string> | Prefix for the name of the file to which the results of AC analysis are written (overrides the specification from the File section). |
| ACMethod | =Blocked | Use Blocked solver. |
| ACPlot | =<string> | Plot the responses of the solution variables to the AC signals. `<string>` is a prefix for the names of the files to which the responses are written. |
| ACSubMethod | (<ident>)=Table 218 | Super (1D and 2D), ILS (3D) Inner solver for device `<ident>`. |
| CircuitNoise |  | Compute noise from circuit elements. Noise From SPICE Circuit Elements on page 744 |
| Decade |  | Use logarithmic intervals between the frequencies. |
| EndFrequency | =<(0,)> | ! Hz Upper frequency. |
| Exclude | (<ident>...) | Devices that will be removed from the circuit for AC analysis. |
| Extraction{ | Table 20} | List of frequency-dependent extraction curves. Extraction File on page 132 |

1624

G: Command File Overview
Solve

Table 332 ACCoupled() Small-Signal AC Analysis on page 101 (Continued)

| Linear |  | Use linear intervals between the frequencies. |
| --- | --- | --- |
| Node | (<ident>...) | Nodes for which to perform AC analysis. |
| NoisePlot | =<string> | Prefix for a file name. Chapter 23, p. 729 |
| NumberOfPoints | =<0..> | ! Number of frequencies for which to perform the analysis. |
| ObservationNode | (<ident>...) | Nodes for which to perform noise analysis; subset of those in Node. Chapter 23, p. 729 |
| Optical |  | Perform optical AC analysis. Optical AC Analysis on page 105 |
| StartFrequency | =<(0,)> | ! Hz Lower frequency. |
| VoltageGreenFunctions |  | – Compute voltage responses for frequency zero. Analysis at Frequency Zero on page 731 |

Table 333 Continuation() Continuation Command on page 87

| AcceptNewtonParameter |  | Apply relaxed Newton parameters. Relaxed Newton Method on page 149 |
| --- | --- | --- |
| BreakCriteria{ | Table 208} | Break criteria. Break Criteria: Conditionally Stopping the Simulation on page 71 |
| Decrement | =<float> | 1.5 (2.0 with NewArc) Divisor for step size on failure to solve. |
| Iadapt | =<float> | 0.0 A Lower current limit for adaptive algorithm. |
| Increment | =<float> | 2.0 (1.5 with NewArc) Multiplier for step size on successful solve. |
| InitialVstep | =<float> | ! Initial voltage step. |
| IscaleMin | =<float> | 1e-10 A Value added to scale factor for current when using the NewArc option. |
| MaxCurrent | =<float> | ! Upper current limit. |
| MaxIFactor | =<float> | 1e35 Maximum-allowed current relative to previous point as a multiplication factor. |
| MaxIstep | =<float> | 1e35 Maximum-allowed current step. |
| MaxRload | =<float> | 1e14 Ω (1e8 with NewArc) Maximum value for adaptive load resistor. |
| MaxStep | =<float> | 1e35 Maximum step for the internal arc length variable. |
| MaxVoltage | =<float> | ! Upper voltage limit. |
| MaxVstep | =<float> | 1e35 Maximum-allowed voltage step. |
| MinCurrent | =<float> | ! Lower current limit. |
| MinRload | =<float> | 1 Ω Minimum value for adaptive load resistor. |

# G: Command File Overview
Solve

Table 333 Continuation() Continuation Command on page 87 (Continued)

| MinStep | =<float> | 1e-35 Minimum step for the internal arc length variable. |
| --- | --- | --- |
| MinVoltage | =<float> | ! Lower voltage limit. |
| Name | =<ident> | Electrode to bias in continuation. It must be specified. |
| NewArc |  | - Use a new arc length calculation for continuation. |
| NewGdiff |  | - (+ with NewArc) Use a new differential conductance calculation. |
| Rfixed | =<float> | 0.001 Fixed resistor value. |
| RloadAdjust |  | - (+ with NewArc) Adjust the adaptive load resistance at low values of slope. |
| Vadapt | =<float> | 0.0 V Lower voltage limit for adaptive algorithm. |

Table 334 Coupled() Coupled Statement on page 141

| CheckRhsAfterUpdate |  | Check whether the RHS can be reduced further after the update error has converged. If CheckRhsAfterUpdate is specified in the Math section, -CheckRhsAfterUpdate can be used to disable it for this Coupled statement. |
| --- | --- | --- |
| Digits | =<float> | Relative error target. |
| IncompleteNewton ( |  | Incomplete Newton. Incomplete Newton Algorithm on page 146 |
| RhsFactor=<float> | Maximum change in RHS to allow old Jacobian to be reused. |  |
| UpdateFactor=<float> ) | Maximum change in update to allow old Jacobian to be reused. |  |
| Iterations | =<0..> | Maximum number of iterations of the Newton algorithm. |
| LineSearchDamping | =<(0,1]> | Minimal coefficient for line search damping. 1 disables damping. Damped Newton Iterations on page 145 |
| Method | =Table 218 | Linear solver. |
|  | =Blocked | Block decomposition solver. |
| NotDamped | =<0..> | Number of Newton iterations before Bank-Rose damping is applied. Damped Newton Iterations on page 145 |
| PMI_NewtonStep | (<ident>) | Use PMI model <ident> for Newton step computation. Preprocessing for Newton Iterations and Newton Step Control on page 1411 |
| RhsAndUpdateConvergence |  | Require both RHS and update error convergence. |
| RhsMin | =<float> | Upper bound for RHS norm convergence. |
| RhsMinFactor | =<float> | Factor for RhsMin affecting convergence. Convergence and Error Control on page 143 |

1626

**G: Command File Overview**
Solve

Table 334 Coupled() Coupled Statement on page 141 (Continued)

| SubMethod | [(<ident>)]=Table 218 | Super (1D and 2D), ILS (3D) Inner solver (for device <ident>). |
| --- | --- | --- |
| UpdateIncrease | =<float> | Maximum-allowed increase of update error per Newton step. |
| UpdateMax | =<float> | Maximum-allowed update error in Newton algorithm. |

Table 335 Cyclic() Large-Signal Cyclic Analysis on page 97

| Accuracy | =<float> | Tolerance $\epsilon_{cyc}$ . |
| --- | --- | --- |
| CyclicExtrapolationMethod | =<int> | 0 Cyclic extrapolation method. Description of Method on page 98 |
| Extrapolate( | Average | + Use averaged factor $r_{av}^o$ for each object. Factor $r$ is defined separately for each vertex. |
| CMaxVal=<float> | 25 Maximum-allowed value of extrapolation factor ($r_{max}$) for circuit node voltages. |  |
| Factor=<float> | 1 Coefficient $f$ for $r_{av}^o$ estimation. |  |
| Forward | – Proceed as in a standard transient, without cyclic extrapolation. |  |
| MaxVal=<float> | 25 Value of $r_{max}$ . |  |
| MinVal=<float> | 1 Value of $r_{min}$ . |  |
| PMaxVal=<float> | 25 Maximum-allowed value of extrapolation factor ($r_{max}$) for electrostatic potential. |  |
| Print | + Print averaged factors $r_{av}^o$ for each object. |  |
| QFTraps | – Apply extrapolation to ‘trap quasi-Fermi level’ $\Phi_T$ instead of trap occupation probabilities $f_T$ . |  |
| TMaxVal=<float>) | 25 Maximum-allowed value of extrapolation factor ($r_{max}$) for carrier or lattice temperature. |  |
| IgnoreCircuit |  | – Ignore circuit node voltages from extrapolation. |
| IgnoreContact |  | – Ignore contact nodes from extrapolation. |
| IgnoreTemperaturePDE |  | – Exclude carrier temperature from extrapolation. |
| IgnoreDGPDE |  | – Exclude quantum potential from extrapolation. |
| IgnoreElectronPDE |  | – Exclude electron concentration from extrapolation. |
| IgnoreHolePDE |  | – Exclude hole concentration from extrapolation. |
| IgnoreLatticeTemperaturePDE |  | – Exclude lattice temperature from extrapolation. |

G: Command File Overview
Solve

Table 335 Cyclic() Large-Signal Cyclic Analysis on page 97 (Continued)

| IgnorePotentialPDE |  | – Exclude electrostatic potential from extrapolation. |
| --- | --- | --- |
| IgnoreRegion |  | – Ignore a particular region for extrapolation. |
| MaximumCycles | =<int> | 100000 Number of cyclic cycles after which transient simulation methodology is switched on. |
| Period | =<float> | s Period of the cycle. |
| RegionName | =<string> | Name of region to be excluded from extrapolation. |
| RelFactor | =<float> | Relaxation factor ϒ. |
| StartingPeriod | =<2..> | 2 Period from which the extrapolation procedure starts. |

In the description column of Table 336, the default for `ErrRef` (first number; see Table 206 on page 1518) and its unit, and the default for `Error` (second number, see Table 206) are given.

Table 336 Equations

| Charge | 1.602192e-19 C 1e-3 Floating gate charge, available for TransientErrRef and TransientError only. Floating Gates on page 1158 |
| --- | --- |
| Circuit | 0.0258 V 1e-3 Circuit equations. |
| CondInsulator | 0.0258 V 1e-3 Conductive insulator equations. |
| Contact | 0.0258 V 1e-3 Contact equations. |
| Electron | 1e10 cm–3 1e-5 Electron continuity equation. Chapter 8, p. 189 |
| eQuantumPotential | 0.0258 V 1e-3 Electron quantum-potential equation. Density Gradient Model on page 316 |
| eSHEDistribution | 1 V 1e-3 Electron SHE distribution equation. Using Spherical Harmonics Expansion Method on page 806 |
| eTemperature | 300 K 1e-4 Electron temperature equation. Hydrodynamic Model for Temperatures on page 204 |
| FEPolarization | 1e-9 C/cm2 1e-5 Ferroelectric polarization equation. Chapter 29, p. 855 |
| Hole | 1e10 cm–3 1e-5 Hole continuity equation. Chapter 8, p. 189 |
| hQuantumPotential | 0.0258 V 1e-3 Hole quantum potential equation. Density Gradient Model on page 316 |
| hSHEDistribution | 1 V 1e-3 Hole SHE distribution equation. Using Spherical Harmonics Expansion Method on page 806 |
| hTemperature | 300 K 1e-4 Hole temperature equation. Hydrodynamic Model for Temperatures on page 204 |
| HydrogenAtom | 1e10 cm–3 1e-3 Hydrogen atom transport equation. Hydrogen Transport on page 555 |
| HydrogenIon | 1e10 cm–3 1e-3 Hydrogen ion transport equation. Hydrogen Transport on page 555 |
| HydrogenMolecule | 1e10 cm–3 1e-3 Hydrogen molecule transport equation. Hydrogen Transport on page 555 |

G: Command File Overview
Solve

Table 336 Equations (Continued)

| LLG | Landau–Lifshitz–Gilbert equation. Chapter 30, p. 871 |
| --- | --- |
| Mechanics | Mechanical stress equation. Mechanics Solver on page 957 |
| Poisson | 0.0258 V 1e-3 Poisson equation. Electrostatic Potential on page 179 |
| SingletExciton | Singlet exciton equation. Singlet Exciton Equation on page 245 |
| TCircuit | Thermal circuit equations. |
| TContact | Thermal contact equations. |
| Temperature | 300 K 1e-3 Temperature equation. Chapter 9, p. 197 |
| Traps | 1e-5 1 1e-3 Explicit trap equation. Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506 on page 506) |

Table 337 Goal{} Quasistationary Ramps on page 74

| Charge | =<float> | C Target charge for contact. |
| --- | --- | --- |
| Contact | =<string1>.<string2> | Name of instance and contact to be ramped. |
| Current | =<float> | A $\mu$md-3 Target current for contact. |
| Device | =<string> | Name of the device where the parameter will be ramped. |
| DopingWell | (<vector>) | Semiconductor well defined by point <vector> where quasi-Fermi potential will be ramped. |
| DopingWells | (Material=<string>) | Semiconductor wells in material <string> where quasi-Fermi potential will be ramped. |
| (Region=<string>) | Semiconductor wells in the region <string> where quasi-Fermi potential will be ramped. |  |
| (Semiconductor) | All device semiconductor wells where Fermi potential will be ramped. |  |
|  |  |  |
| eQuasiFermi | =<float> | V Target electron quasi-Fermi potential for semiconductor wells. Ramping Quasi-Fermi Potentials in Doping Wells on page 76 |
| hQuasiFermi | =<float> | V Target hole quasi-Fermi potential for semiconductor wells. Ramping Quasi-Fermi Potentials in Doping Wells on page 76 |
| Material | =<string> | Name of material where the parameter will be ramped. |
| MaterialInterface | =<string> | Name of material interface where parameter will be ramped. |
| Model | =<string> | Name of model for which the parameter will be ramped. |
| ModelParameter | =<string> | Parameter path or name of parameter that is ramped when using Parameter Ramping on page 635. |
| Name | =<string> | Name of contact to be ramped. |
| =Regexp(<string>) | Regular expression for matching contacts. |  |

1629

# G: Command File Overview

Solve

Table 337 Goal{} Quasistationary Ramps on page 74 (Continued)

| Node | =<string> | Name of node for which the voltage will be ramped. |
| --- | --- | --- |
| Parameter | =<string> | Name of parameter that will be ramped. |
| =<string1>.<string2> | Name of instance and parameter that will be ramped. This syntax only applies to circuit parameters, but not device parameters. |  |
| Power | =<float> | Target heat for contact. |
| Region | =<string> | Name of region where the parameter will be ramped. |
| RegionInterface | =<string> | Name of region interface where parameter will be ramped. |
| Temperature | =<float> | K Target temperature for contact. |
| Value | =<float> | Target value for parameter. |
| Voltage | =<float> | V Target voltage for node or contact. |
| WellContactName | =<string> | Name of contact defining the well where quasi-Fermi potential will be ramped. |

Table 338 HBCoupled() Harmonic Balance on page 106

| Table 334 |  | Coupled() parameters. |
| --- | --- | --- |
| CNormPrint |  | + Print instance equation errors per Newton step (MDFT and SDFT modes). |
| Derivative |  | - Use complete Jacobian for HB Newton. |
| GMRES ( |  | Use GMRES linear solver; requires Method=ILS. |
| MaxIterations=<int> | 200 Maximal number of iterations. |  |
| Restart=<int> | 20 Size of minimization subspace. |  |
| Tolerance=<float>) | 1e-4 Required residuum reduction. |  |
| Initialize | =DCMode | 0-th harmonic from DC solution; others, zero. |
| =HBMode | All harmonics from previous harmonic balance (HB) solution. |  |
| =MixedMode | 0-th harmonic from DC; others, from previous HB solution. |  |
| Method | =ILS | Required for GMRES. |
| =Pardiso | Use PARDISO to solve linear system (SDFT mode only). |  |
| Name | =<string> | Name component of plot files. Default is Coupled_<number>, where <number> is the global index of all Coupled, ACCoupled, and HBCoupled solve entries. |
| RhsScale | (Table 336)=<float> | Scaling of RHS in Newton (MDFT and SDFT modes). |
| SolveSpectrum | =<string> | Referenced solve spectrum (MDFT mode only). |

1630

G: Command File Overview
Solve

Table 338 HBCoupled() Harmonic Balance on page 106 (Continued)

| Tone |  | Multiple specification for multitone (MDFT mode only). |  |
| --- | --- | --- | --- |
| ( | Frequency=<freqspec> | ! Hz Base frequency. Performing Harmonic Balance Analysis on page 107 |  |
| NumberOfHarmonics=<int> ) | ! Number of harmonics $H$. Eq. 25, p. 106 |  |  |
| UpdateScale | (Table 336)=<float> | Scaling of update in Newton (MDFT and SDFT modes). |  |
| ValueMin | (Table 336)=<float> | Lower bound for quantity in time domain (MDFT mode only). |  |
| ValueVariation | (Table 336)=<float> | Allowed variation of quantity in time domain (MDFT mode only). |  |

Table 339 Load(), Plot(), Save(), SpectralPlot() in Solve{} When to Plot on page 129

| Current | (Difference=<float>) | A Only for Continuation simulations. Write save or plot files when the difference between the actual and previous plotting current values on the continuation contact is greater than the specified Difference. |
| --- | --- | --- |
| (Intervals=<int>) | A Only for Continuation simulations. Divide the range specified with MinCurrent and MaxCurrent of Continuation into <int> intervals, and write save or plot files every time the current enters one of these intervals. When LogCurrent is specified in Continuation section, logarithmic ($\text{asinh}(10^{100} \text{current})$) current range is used. Write save or plot file when the current enters a new logarithmic interval. |  |
| (LogDifference=<(0,)>) | A Only for Continuation simulations. LogCurrent must be specified in Continuation section. Write save or plot files when the difference between the actual and previous logarithmic plotting current values is greater than the specified Difference. |  |
| Explicit |  | – Write datasets specified in Plot section only. Explicit is ignored by SpectralPlot. |
| FilePrefix | =<string> | Prefix of file name. File names consist of the prefix, the instance name, an optional local number (depending on Overwrite and noOverwrite), and an extension. The default file prefix is save<globalsaveindex> for Save and plot<globalplotindex> for Plot. |
| Iterations | =(<int>;...) | (0;1;...) Save or plot at certain Plugin iterations. |
| IterationStep | =<int> | Save or plot all <int> steps of plugins, quasistationaries, continuations, or transients. |
| Loadable |  | + Write additional information required to load a simulation from a .tdr file. Loadable is not supported for SpectralPlot. |
| noOverwrite |  | off Give each new save or plot file a new name by numbering. |

# G: Command File Overview

Solve

Table 339 Load(), Plot(), Save(), SpectralPlot() in Solve{} When to Plot on page 129 (Continued)

| Number | =<int> | Number of the solution to be retrieved by Load. |
| --- | --- | --- |
| Overwrite |  | on Rewrite the same file name at each loop. |
| Time=( | <float> | Time point for plot. When to Plot on page 129 |
| decade | Use logarithmic range subdivision. When to Plot on page 129 |  |
| intervals=<int> | Number of subdivisions. When to Plot on page 129 |  |
| range=(<float>*2);...) | Plotting range. When to Plot on page 129 |  |
| Voltage | (Difference=<float>) | V Only for Continuation simulations. Write save or plot files when the difference between current and previous plotting voltages is greater than the specified Difference. |
| (Intervals=<int>) | Only for Continuation simulations. Divide the range specified with MinVoltage and MaxVoltage of Continuation into <int> intervals, and write save or plot files every time the voltage enters one of these intervals. |  |
| When ( |  | Generate output whenever the target was crossed the between the previous and the current iteration $i, X_{i-1} < X_T \le X_i$ or $X_{i-1} > X_T \ge X_i$. Available for Plot, SpectralPlot, Save, and CurrentPlot inside a Quasistationary, Transient, or Continuation. |
| Contact=[<string>.]<string> | [Instance and] contact name for target. The instance name defaults to " ", appropriate for single-device simulation. |  |
| Current=<float> | A Target current $X_T$. |  |
| Node=<string> | Node name for target. |  |
| Voltage=<float> | V Target voltage $X_T$. |  |

Table 340 MSConfigs() in Set() in Solve{} Manipulating MSCs During Solve on page 539

| Frozen |  | + Freeze MSCs. |
| --- | --- | --- |
| MSConfig ( |  | Set occupations for the specified MSC. |
| Device=<string> | Device instance name to where the MSC belongs. |  |
| Name=<string> | Name of MSC. |  |
| State (Name=<string> Value=<float>)...) | Set occupation of MSC state <string> to given value. |  |

1632

G: Command File Overview
Solve

Table 341 Plugin() Plugin Command on page 151

| BreakOnFailure |  | Stop when an inner Coupled fails. |
| --- | --- | --- |
| Digits | =<float> | Relative precision target. |
| Iterations | =<int> | Maximum number of iterations. 0 is used to perform one loop without error testing. |

Table 342 Quasistationary() Quasistationary Ramps on page 74

| AcceptNewtonParameter ( |  | Apply relaxed Newton parameters. Relaxed Newton Method on page 149 |
| --- | --- | --- |
| ReferenceStep=<float>) | 1.e-9 Apply relaxed Newton parameters for step size < ReferenceStep. |  |
| BreakCriteria{ | Table 208} | Break criteria. Break Criteria: Conditionally Stopping the Simulation on page 71 |
| Decrement | =<float> | 2 Divisor for the step size when last step failed. |
| DoZero |  | +\| - The equations are solved for $t = 0$. |
| Extraction{ | Table 20} | List of voltage-dependent extraction curves. Extraction File on page 132 |
| Extrapolate | (Table 213) | - Use extrapolation. Extrapolation on page 82 |
| Goal{ | Table 337} | Goal for ramping. |
| Increment | =<float> | 2 Multiplier for the step size when last step was successful. |
| InitialStep | =<float> | 0.1 Initial step size. |
| MaxStep | =<float> | 1 Maximum step size. |
| MinStep | =<float> | 0.001 Minimum step size. |
| NewtonPlotStep | =<float> | Upper limit for step size for which to write Newton plot files. NewtonPlot on page 160 |
| NonlocalPath | (Table 222) | Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475, Handling Derivatives on page 481 |
| Plot{ | Intervals=<int> | ! Number of intervals in Range. Saving and Plotting During a Quasistationary on page 82 |
| Range=(<float>*2)} | ! Range of $t$ for which to generate plots. |  |
| PlotBandstructure | as Plot | Plot band structure data in an LED simulation. |
| PlotLEDRadiation | as Plot | Optical far field of LED. |
| PlotGain | as Plot | Plot stimulated and spontaneous emission data in LED simulation. |

1633

# G: Command File Overview
Solve

Table 342 Quasistationary() Quasistationary Ramps on page 74 (Continued)

| ReadExtrapolation |  | + Try to use the extrapolation information from a previous Quasistationary if it is available and compatible. Extrapolation on page 82 |
| --- | --- | --- |
| SaveOptField | as Plot | Save optical field data in an LED simulation. |
| SpectralPlot | as Plot | Plot spectral simulation results. Illumination Spectrum on page 596 |
| StoreExtrapolation |  | + Store the extrapolation information internally at the end of the Quasistationary. Extrapolation on page 82 |

**NOTE** Multiple entries from Table 343 must be specified in multiple `Set()` definitions, because `Set()` only takes a single option.

Table 343 Set() in Solve{}

| <ident> | =<float> | Set node. Mixed-Mode Electrical Boundary Conditions on page 69 |
| --- | --- | --- |
| <ident>.<string> | =<float> | Set parameter <string> of compact circuit instance <ident>. Mixed-Mode Electrical Boundary Conditions on page 69 |
| <ident> | mode Charge | Use charge boundary condition for contact <ident>. Changing Boundary Condition Type During Simulation on page 68 |
| <ident> | mode Current | Use current boundary condition for contact <ident>. Changing Boundary Condition Type During Simulation on page 68 |
| <ident> | mode Voltage | Use voltage boundary condition for contact <ident>. Changing Boundary Condition Type During Simulation on page 68 |
| MSConfigs( | Table 340) | Set MSCs. Manipulating MSCs During Solve on page 539 |
| (PreFactor | =<float> [Device=<string>] [MSConfig=<string>] [Transition=<string>]) | Set MSC transition prefactors for emission, capture, or both using EPreFactor, CPreFactor, or PreFactor, respectively. Manipulating Transition Dynamics on page 541 |
| eSHEDistributions( | Frozen) | Freeze or unfreeze (-Frozen) the electron distribution function. Using Spherical Harmonics Expansion Method on page 806 |
| hSHEDistribution( | Frozen) | Freeze or unfreeze (-Frozen) the hole distribution function. Using Spherical Harmonics Expansion Method on page 806 |
| HydrogenAtom | =<string> | Set the concentration of hydrogen atom. Hydrogen Transport on page 555 |
| HydrogenIon | =<string> | Set the concentration of hydrogen ion. Hydrogen Transport on page 555 |
| HydrogenMolecule | =<string> | Set the concentration of hydrogen molecule. Hydrogen Transport on page 555 |

G: Command File Overview
Solve

Table 343 Set() in Solve{} (Continued)

| TrapFilling | =Table 348 | Set trap filling. Explicit Trap Occupation on page 496 |
| --- | --- | --- |
| Traps( | Table 348) | Set traps. Explicit Trap Occupation on page 496 |

Table 344 Standalone

| Optics | Optical problem. |
| --- | --- |
| Wavelength | Update wavelength according to optical problem. |

Table 345 Time conditions Time-Stepping on page 92, When to Write to the Current File on page 113, When to Plot on page 129

| <float> | s A time point. |
| --- | --- |
| Range=(<float>*2) | Interval on time axis. |
| Range=(<float>2) Intervals=<int> [Decade \| Linear] | Subdivided interval on time axis. Subdivision on logarithmic or linear scale. |

Table 346 Transient() Transient Command on page 90

| Table 213 |  | Time step control. |
| --- | --- | --- |
| AcceptNewtonParameter |  | Apply relaxed Newton parameters. Relaxed Newton Method on page 149 |
| ( | ReferenceStep=<float>) | 1.e-9 s Apply relaxed Newton parameters for step size < ReferenceStep. |
| BreakCriteria{ | Table 208} | Break criteria. Break Criteria: Conditionally Stopping the Simulation on page 71 |
| Cyclic( | Table 335) | Cyclic analysis. Large-Signal Cyclic Analysis on page 97 |
| Decrement | =<float> | 2 Divisor for the step size when last step failed. |
| Extrapolate | (Table 213) | - Use extrapolation. Extrapolation on page 82 |
| FinalTime | =<float> | s Final time. |
| Goal{ | Table 337} | Goal for ramping. |
| Increment | =<float> | 2 Multiplier for the step size when last step was successful. |
| InitialStep | =<float> | 0.1 s Initial step size. |
| InitialTime | =<float> | 0 s Start time. |

1635

G: Command File Overview
Solve

Table 346 Transient() Transient Command on page 90 (Continued)

| MaxStep | =<float> | 1 s Maximum step size. |
| --- | --- | --- |
| MinStep | =<float> | 0.001 s Minimum step size. |
| NewtonPlotStep | =<float> | Upper limit for step size for which to write Newton plot files. NewtonPlot on page 160 |
| NonlocalPath | (Table 222) | Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475, Handling Derivatives on page 481 |
| Plot{ | Intervals=<int> | Number of intervals in Range. |
| Range=(<float>*2)} | s Range of $t$ for which to generate plots. Saving and Plotting During a Quasistationary on page 82 |  |
| ReadExtrapolation |  | + Try to use the extrapolation information from a previous Transient if it is available and compatible. Extrapolation on page 82 |
| SpectralPlot | as Plot | Plot spectral simulation results. Illumination Spectrum on page 596 |
| StoreExtrapolation |  | + Store the extrapolation information internally at the end of the Transient. Extrapolation on page 82 |
| Transient | =BE | Backward Euler method. Backward Euler Method on page 1155 |
| =TRBDF | \* TRBDF method. TRBDF Composite Method on page 1156 |  |
| TurningPoints( | (<float1> <float2>)... | Time point <float1> and associated advancing time-step limit <float2>. |
| (Condition(Time(Table 345 ; [Table 345]...)) Value=<float> Factor=<int>) ... ) | Time point conditions and associated advancing time-step limit Value. Factor controls the precision of the current. |  |

Table 347 TrapFilling= in Set() in Solve {} Explicit Trap Occupation on page 496

| 0 | Set trap occupation to be in equilibrium with zero electron and hole concentration. |
| --- | --- |
| -Degradation | Return trap concentrations to initial values. Device Lifetime and Simulation on page 550 |
|  | (deprecated) Set all traps to empty. |
| Frozen | Keep the current trap occupation unchanged until the next Set or UnSet. |
| Full | (deprecated) Set all traps to fully occupied. |

G: Command File Overview
System

Table 347 TrapFilling= in Set() in Solve {} Explicit Trap Occupation on page 496 (Continued)

| n | (deprecated) Set trap occupation to be in equilibrium with a very high electron and zero hole concentration. |
| --- | --- |
| p | (deprecated) Set trap occupation to be in equilibrium with a very high hole and zero electron concentration. |

Table 348 Traps() in Set() in Solve {} Explicit Trap Occupation on page 496

| [<string1>.]<string2>=<float>... | Set occupation of trap <string2> of device <string1> to specified value. |
| --- | --- |
| [<string1>.]value=<float>... | Set occupation of traps of device <string1> to specified value. |
| Frozen | + Freeze traps. |

# System

Table 349 System{} System Section on page 54

| <ident1> | <ident2> (<string>=<ident3>...) | Create device instance <ident2> from device <ident1> and connect electrode <string> to node <ident3>. |
| --- | --- | --- |
| <ident1> | <ident2>(<ident3>...) { <ident4>=<pvalue>...} | Create instance <ident2> from parameter set <ident1>, connect terminals to nodes <ident3>, and override parameter <ident4> by <pvalue>, the type of which depends on the parameter. |
| <ident1> | <ident2>(OpticalDevice = ["<optdev1>" ...]) {<ident3>=<pvalue>...} | Create instance <ident2> from parameter set <ident1>, connect instance to optical device instances <optdev1>, and override parameter <ident4> by <pvalue>, the type of which depends on the parameter. |
| ACPlot( | Table 350 | Define circuit quantities for AC analysis output. Modifying Plot Output on page 60 |
| Electrical | (<ident>...) | List of electrical nodes. System Section on page 54 |
| HBPlot | [<string>] (Table 350) | Define circuit quantities for HB analysis output. Harmonic Balance on page 106 |
| Hint( | <ident>=<float> | Set node only for the first solve. Initializing Nodes on page 58 |
| Initialize( | <ident>=<float> | Set node until first transient. Initializing Nodes on page 58 |
| Netlist | =<string> | HSPICE netlist file. HSPICE Netlist Files on page 45 |
| Plot | [<string>] (Table 350) | Plot circuit quantities to file named <string>. |

1637

# G: Command File Overview

TensorPlot

Table 349 System{} System Section on page 54 (Continued)

| Set( | <ident>=<float> | Set node. Initializing Nodes on page 58 |
| --- | --- | --- |
| <ident>.<string>=<float> | Set parameter <string> of compact circuit instance <ident>. |  |
| Thermal | (<ident>...) | List of thermal nodes. System Section on page 54 |
| Unset( | <ident>) | Unset node. Initializing Nodes on page 58 |

Table 350 Plot(), ACPlot(), and HBPlot() in System{} Plotting Quantities on page 59, Modifying Plot Output on page 60, Harmonic Balance on page 106

| <ident> |  | Print the voltage at node <ident>. |
| --- | --- | --- |
| freq | () | Print the current AC analysis frequency. |
| h | (<ident1> <ident2>) | Print the heat that exits device <ident1> through node <ident2>. |
| i | (<ident1> <ident2>) | Print the current that exits device <ident1> through node <ident2>. |
| p | (<ident1> <ident2>) | Print attribute <ident2> of circuit element <ident1>. |
| t | (<ident>) | Print the temperature at node <ident>. |
| (<ident1> <ident2>) | Print the temperature difference between two given nodes. |  |
| time | () | Print the current time in transient analysis, or quasistationary t parameter for frequency-domain analysis. |
| v | (<ident>) | Print the voltage at node <ident>. |
| (<ident1> <ident2>) | Print the voltage difference between two given nodes. |  |

# TensorPlot

Table 351 TensorPlot(){} Visualizing Results on Native Tensor Grid on page 710

| Name | =<string> | ! Name of tensor plot. The file name for the TensorPlot given in the File section is appended by this name. |
| --- | --- | --- |
| OutputLevel | =maximum | For bidirectional BPM, tensor plots are generated not only for the final solution, but also after every iteration if maximum is specified. |
| Xconst | =<float> | µm X-coordinate. |
| Xmax | =<float> | µm Maximum x-coordinate. |
| Xmin | =<float> | µm Minimum x-coordinate. |

G: Command File Overview
Thermode

Table 351 TensorPlot(){} Visualizing Results on Native Tensor Grid on page 710 (Continued)

| Yconst | =<float> | µm Y-coordinate. |
| --- | --- | --- |
| Ymax | =<float> | µm Maximum y-coordinate. |
| Ymin | =<float> | µm Minimum y-coordinate. |
| Zconst | =<float> | µm Z-coordinate. |
| Zmax | =<float> | µm Maximum z-coordinate. |
| Zmin | =<float> | µm Minimum z-coordinate. |

# Thermode

Table 352 Thermode{} Boundary Conditions for Lattice Temperature on page 235

| AreaFactor | =<float> | 1 Multiplier for heat fluxes. Reading a Structure on page 9 |
| --- | --- | --- |
| Name | =<string> | Name of thermode. |
|  | =Regexp(<string>) | Regular expression for matching structure contacts. |
| Power | =<float> | Wcm-2 Heat flux boundary condition. |
| SurfaceConductance | =<float> | cm-2K-1W Contact thermal conductance. |
| SurfaceResistance | =<float> | cm2KW-1 Contact thermal resistivity. |
| Temperature | =<float> | K Contact temperature. |

# Various

Table 353 Locations, all

| Table 354 |  | Bulk location. |
| --- | --- | --- |
| Table 355 |  | Interface location. |
| Electrode | =<string> | Name of an electrode that must exist in the device. |

# G: Command File Overview

Various

## Table 354 Locations, bulk (dimension is that of the device)

| Material | =<string> | Name of a material. |
| --- | --- | --- |
| Region | =<string> | Name of a region that must exist in the device. |

## Table 355 Locations, interface (dimension is one less than that of the device)

| MaterialInterface | =<string> | Material interface of the form "<ident1>/<ident2>", with <ident1> and <ident2> as the names of materials. |
| --- | --- | --- |
| RegionInterface | =<string> | Region interface of the form "<ident1>/<ident2>", with <ident1> and <ident2> as the names of regions that must exist in the device and must have a common interface. |

## Table 356 Locations, noncontact

| Table 354 | Bulk location. |
| --- | --- |
| Table 355 | Interface location. |

## Table 357 Optics() in Physics{}

| Table 268 |  | Optics standalone. |
| --- | --- | --- |
| BPMScalar( | Table 235 | Scalar beam propagation method (BPM) solver. Beam Propagation Method on page 702 |
| TMM( | Table 235 | Transfer matrix method (TMM) solver. Transfer Matrix Method on page 680 |

## Table 358 PMI parameters Command File of Sentaurus Device on page 1187

| <ident> | =<float> | Scalar floating-point parameter. |
| --- | --- | --- |
| =<string> | Scalar string parameter. |  |
| =(<float>...) | Vector of floating-point parameters. |  |
| =(<string>...) | Vector of string parameters. |  |

