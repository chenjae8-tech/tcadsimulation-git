# CHAPTER 2 Specifying Physical Devices

*This chapter describes how to specify physical devices.*

Before performing a simulation, Sentaurus Device needs to know which device will actually be simulated. This chapter describes what Sentaurus Device needs to know and how to specify it. This includes obvious information, such as the size and shape of the device, the materials of which the device is made, and the doping profiles. It also includes less obvious aspects such as which physical effects must be taken into account, and by which models and model parameters this should be performed.

# Reading a Structure

A device is defined by its shape, material composition, and doping. This information is defined on a grid and contained in a TDR file that you specify with the keyword `Grid` in the `File` section of the command file. For example:

```
File {
  Grid = "mosfet.tdr"
  ...
}
```

The following keywords affect the interpretation of the geometry in the `Grid` file:

*   `CoordinateSystem` in the global `Math` section specifies the coordinate system that is used for explicit coordinates in the Sentaurus Device command file. Many features such as current plot statements (see Tracking Additional Data in the Current File on page 116) or `LatticeParameters` in the parameter file (see Crystal and Simulation Coordinate Systems on page 836) use explicit coordinates, and they are based on an implicit assumption regarding the orientation of the device. You can indicate the required orientation of the device by specifying the following keyword:

```
Math {
  CoordinateSystem { <option> }
}
```

If the coordinate system of the device is incompatible with the specification in the `Math` section, then Sentaurus Device automatically transforms the device into the required coordinate system.

Reading a Structure

Table 1 Options of the CoordinateSystem keyword

| Option | Description |
| --- | --- |
| AsIs | (Default) This option specifies that the coordinate system of the device is compatible with the explicit coordinates used in the Sentaurus Device command file. No transformation is applied to the structure. |
| DFISE | In two dimensions, the x-axis points across the surface, and the y-axis points down into the device. In 3D, the x-axis and y-axis span the surface of the device, and the z-axis points upwards away from the device. |
| UCS | The unified coordinate system (UCS) uses the convention of the simulation coordinate system as established by Sentaurus Process. The x-axis always points down into the device. In 2D, the y-axis runs across the surface of the device. In 3D, the z-axis is added to obtain a right-handed coordinate system. |

*   `AreaFactor` in the global `Physics` section specifies a multiplier for currents and charges. For 1D or 2D simulations, it typically specifies the extension of the device in the remaining one or two dimensions. In simulations that exploit the symmetry of the device, it can also be used to account for the reduction of the simulated device compared to the real device. `AreaFactor` is also available in the `Electrode` and `Thermode` sections, with the same meaning; if both `AreaFactors` are present, Sentaurus Device multiplies them.

TDR units are taken into account when loading from a `.tdr` file. Thereby, the units read from files are converted to the appropriate units used in Sentaurus Device. The TDR unit is ignored in the case of a conversion failure. Use the keyword `IgnoreTdrUnits` in the `Math` section to disregard TDR units during loading. This applies not only to the `Grid` file, but also to other loaded files (see Save and Load Statements on page 163).

# Cylindrical Coordinate System

The cylindrical coordinate system models the radial (ρ) and height (z) dependency of 3D devices with cylindrical symmetry, or models devices or problems with circular cross-sections. The device behavior is assumed to be identical for all values of the azimuthal angle (φ). Therefore, a 3D device can be described in a 2D coordinate system.

Sentaurus Device assumes that the 2D structure is rotated completely about the cylindrical z-axis through an angle of 2π radians. As a result, a 2D mesh can be used to simulate a 3D cylindrical device, and the simulation results are equivalent to a 3D simulation. Therefore, the unit of the terminal current is ampere (A) *not* A/μm, which is the unit of the terminal current for 2D device structures.

**2: Specifying Physical Devices**

Reading a Structure

You activate cylindrical coordinates by specifying the keyword `Cylindrical` in the global `Math` section (only applies to 2D meshes):

```
Math {
  Cylindrical( xAxis=<float> )    # or yAxis=<float>
}
```

You can define where the cylindrical z-axis is located by using the option `xAxis=<float>` or `yAxis=<float>`. Figure 4 explains the usage of these options and pertains to DF–ISE coordinates. In the case of the UCS, the x-axis is the vertical axis, and the y-axis is the horizontal axis. Therefore, you need to set the options `xAxis` and `yAxis` carefully to define their cylindrical z-axis.

> **NOTE** No contacts should be aligned to the cylindrical z-axis. Otherwise, an error will terminate the simulation.

Diagram showing how the cylindrical z-axis can be shifted using xAxis or yAxis options in a coordinate system.

Figure 4 Cylindrical z-axis can be shifted along the axis of definition with the xAxis or yAxis option

# Abrupt and Graded Heterojunctions

Sentaurus Device supports both abrupt and graded heterojunctions, with an arbitrary mole fraction distribution. In the case of abrupt heterojunctions, Sentaurus Device treats discontinuous datasets properly by introducing double points at the heterointerfaces.

This option is switched on automatically when thermionic emission (see Thermionic Emission Current on page 819) is selected, or when the keyword `HeteroInterface` is specified in the `Physics` section of a selected heterointerface. By default, this double points option is switched off.

> **NOTE** The keyword `HeteroInterface` provides equilibrium conditions (continuous quasi-Fermi potentials) for the double points. It does not provide realistic physics at the interface for high-current regimes. Using the `HeteroInterface` option without thermionic emission or a tunneling model is discouraged.

Specifying Doping Species

To illustrate the double points option, Figure 5 shows the conduction band near an abrupt heterointerface. The wide line shows a case without double points, which requires a very fine mesh to avoid a large barrier error ($ \delta E_{C} $).

| Mesh Nodes | Energy Level |
| --- | --- |
| 1 | EC1 |
| 2 |  |
| 3 |  |
| 4 | DC |
| 5 |  |
| 6 |  |
| 7 |  |
| 8 |  |
| 9 | EC2 |
| 10 |  |

Figure 5 Band edge at a heterointerface with and without double points

---

# Specifying Doping Species

Sentaurus Device relies on the `Variables` section of the file `datexcodes.txt` to determine its doping species. A variable is identified as a doping species by a `doping` field that shows whether it is an acceptor or a donor. Chemical concentrations are linked to their corresponding active concentrations by an `active` field. Similarly, ionized concentrations are specified by an `ionized` field. A typical declaration would be:

```
BoronConcentration, BoronChemicalConcentration {
  doping = acceptor (
    active = BoronActiveConcentration
    ionized = BoronMinusConcentration
  )
  ...
}

BoronActiveConcentration { ... }

BoronMinusConcentration { ... }
```

You can also limit the doping species to certain substrate materials. For example, to restrict `SiliconConcentration` as a donor for GaN substrates only, specify the following:

```
SiliconConcentration, SiliconChemicalConcentration {
  doping = donor (
    active = SiliconActiveConcentration
    ionized = SiliconPlusConcentration
    material = GaN
  )
}
```

**2: Specifying Physical Devices**
Specifying Doping Species

The TCAD Sentaurus tool suite provides a default `datexcodes.txt` file in the directory `$STROOT_LIB` (or `$STROOT/tcad/$STRELEASE/lib`). Many common doping species are already predefined in this file. To add user-defined doping species or to modify an existing specification, you can use a `datexcodes.txt` file in the local directory. The local `datexcodes.txt` file only needs to contain the variables that you want to add or modify.

If the incomplete ionization model is activated (see Chapter 13 on page 293), the model parameters of the user-defined species must be specified in the `Ionization` section of the material parameter file.

Sentaurus Device loads doping distributions from the `Grid` file specified in the `File` section (see Reading a Structure on page 9) and reads the following datasets:

*   Net doping (`DopingConcentration` in the `Grid` file)

*   Total doping (`TotalConcentration` in the Grid file)

*   Concentrations of individual species

Sentaurus Device supports the following rules of doping specification:

*   Sentaurus Device takes the net doping dataset from the file if this dataset is present. Otherwise, net doping is recomputed from the concentrations of the separate species. To force the recomputation of the net doping based on individual species, use the keyword `ComputeDopingConcentration` in the global `Math` section.

*   The same rule applies to the total doping dataset.

> **NOTE** Total concentration, which originates from process simulators such as Sentaurus Process, is the sum of the chemical concentrations of dopants. However, if the total concentration is recomputed inside Sentaurus Device, active concentrations are used.

*   Sentaurus Device takes the active concentration of a dopant if it is in the `Grid` file (for example, `BoronActiveConcentration`). Otherwise, the chemical dopant concentration is used (for example, `BoronConcentration`).

To perform any simulation, Sentaurus Device must prepare the following major doping arrays:

*   Net doping concentration, $N_{net} = N_{D,0} - N_{A,0}$

*   Donor and acceptor concentrations, $N_{D,0}$ and $N_{A,0}$

*   Total doping concentration, $N_{tot} = N_{D,0} + N_{A,0}$

**2: Specifying Physical Devices**
Specifying Materials

After loading the doping file, Sentaurus Device uses the following scheme to compute the doping arrays:

1. If the `Grid` file does not have any species, $N_{\text{net}}$ is initialized from `DopingConcentration`, $N_{\text{tot}}$ is initialized from `TotalConcentration` or $|N_{\text{net}}|$ if `TotalConcentration` was not read, $N_{\text{D},0} = (N_{\text{tot}} + N_{\text{net}})/2$ , and $N_{\text{A},0} = (N_{\text{tot}} - N_{\text{net}})/2$ .

2. If the `Grid` file has individual species, $N_{\text{A},0}$ and $N_{\text{D},0}$ are computed as the sum of individual donor and acceptor concentrations, $N_{\text{net}}$ is initialized from `DopingConcentration` or $N_{\text{D},0} - N_{\text{A},0}$ if `DopingConcentration` was not read, and $N_{\text{tot}}$ is initialized from `TotalConcentration` or $N_{\text{A},0} + N_{\text{D},0}$ if `TotalConcentration` was not read.

3. Doping concentration is also affected if the `Physics` section includes trap specifications with the `Add2TotalDoping` or `Add2TotalDoping(ChargedTraps)` option (see Options to Include Traps in Doping on page 498 for a description of these options).

# Specifying Materials

Sentaurus Device supports all materials that are declared in the `datexcodes.txt` file (see Utilities User Guide, Chapter 1 on page 1). The following search strategy is observed to locate the `datexcodes.txt` file:

* `$STROOT_LIB/datexcodes.txt` or `$STROOT/tcad/$STRELEASE/lib/datexcodes.txt` if the environment variable `STROOT_LIB` is not defined (lowest priority)

* `$HOME/datexcodes.txt` (medium priority)

* `datexcodes.txt` in local directory (highest priority)

Definitions in later files replace or add to the definitions in the earlier files. In this way, the local file only needs to contain materials or variables that you want to add or modify.

## User-Defined Materials

New materials can be defined in a local `datexcodes.txt` file. To add a new material, add its description to the `Materials` section of `datexcodes.txt`:

```
Materials {
  Silicon {
    label = "Silicon"
    group = Semiconductor
    color = #ffb6c1
  }
  Oxide {
    label = "SiO2"
    group = Insulator
```

**2: Specifying Physical Devices**

Specifying Materials

```
      color = #7d0505
    }
    ...
  }
```

The `label` value is used as a legend in visualization tools.

The `group` value identifies the type of the new material. The available options are `All`, `Conductor`, `Insulator`, or `Semiconductor`.

The field `color` defines the color of the material in visualization tools and must have the following syntax:

`color = #rrggbb`

Here, `rr`, `gg`, and `bb` denote hexadecimal numbers representing the intensity of red, green, and blue, respectively. The values of `rr`, `gg`, and `bb` must be in the range `00` to `ff`.

Table 2 Sample values for color

| Color code | Color | Color code | Color |
| --- | --- | --- | --- |
| #000000 | Black | #ffffff | White |
| #ff0000 | Red | #40e0d0 | Turquoise |
| #00ff00 | Green | #7fff00 | Chartreuse |
| #0000ff | Blue | #b03060 | Maroon |
| #ffff00 | Yellow | #ff7f50 | Coral |
| #ff00ff | Magenta | #da70d6 | Orchid |
| #00ffff | Cyan | #e6e6fa | Lavender |

# Mole-Fraction Materials

Sentaurus Device reads the `Molefraction.txt` file to determine mole fraction–dependent materials. The following search strategy is used to locate this file:

1. Sentaurus Device looks for `Molefraction.txt` in the current working directory.

2. If the environment variables `STROOT` and `STRELEASE` are defined, Sentaurus Device tries to read the `$STROOT/tcad/$STRELEASE/lib/Molefraction.txt` file.

3. If these previous strategies are unsuccessful, Sentaurus Device uses the built-in defaults that follow.

Specifying Materials

The following example shows the default `Molefraction.txt` file (but you are urged to check `$STROOT/tcad/$STRELEASE/lib/Molefraction.txt` for the latest version of this file):

```
# Ge(x)Si(1-x)
SiliconGermanium (x=0) = Silicon
SiliconGermanium (x=1) = Germanium

# Al(x)Ga(1-x)As
AlGaAs (x=0) = GaAs
AlGaAs (x=1) = AlAs

# In(1-x)Al(x)As
InAlAs (x=0) = InAs
InAlAs (x=1) = AlAs

# In(1-x)Ga(x)As
InGaAs (x=0) = InAs
InGaAs (x=1) = GaAs

# Ga(x)In(1-x)P
GaInP (x=0) = InP
GaInP (x=1) = GaP

# InAs(x)P(1-x)
InAsP (x=0) = InP
InAsP (x=1) = InAs

# GaAs(x)P(1-x)
GaAsP (x=0) = GaP
GaAsP (x=1) = GaAs

# Hg(1-x)Cd(x)Te
HgCdTe (x=0) = HgTe
HgCdTe (x=1) = CdTe

# In(1-x)Ga(x)As(y)P(1-y)
InGaAsP (x=0, y=0) = InP
InGaAsP (x=1, y=0) = GaP
InGaAsP (x=1, y=1) = GaAs
InGaAsP (x=0, y=1) = InAs
```

To add a new mole fraction–dependent material, the material (and its side and corner materials) must first be added to `datexcodes.txt`. Afterwards, `Molefraction.txt` can be updated.

Quaternary alloys are specified by their corner materials in the file `Molefraction.txt`. For example, the 2:2 III–V quaternary alloy In<sub>1–x</sub>Ga<sub>x</sub>As<sub>y</sub>P<sub>1–y</sub> is given by:

```
InGaAsP (x=0, y=0) = InP
InGaAsP (x=1, y=0) = GaP
InGaAsP (x=1, y=1) = GaAs
InGaAsP (x=0, y=1) = InAs
```

**2: Specifying Physical Devices**
Mole-Fraction Specification

The 3:1 III–V quaternary alloy Al<sub>x</sub>In<sub>y</sub>Ga<sub>1–x–y</sub>As is defined by:

```
AlInGaAs (x=0, y=0) = GaAs
AlInGaAs (x=1, y=0) = AlAs
AlInGaAs (x=0, y=1) = InAs
```

When the corner materials of an alloy have been specified, Sentaurus Device determines the corresponding side materials automatically. In the case of In<sub>1–x</sub>Ga<sub>x</sub>As<sub>y</sub>P<sub>1–y</sub> , the four side materials are InAs<sub>x</sub>P<sub>1–x</sub> , GaAs<sub>x</sub>P<sub>1–x</sub> , Ga<sub>x</sub>In<sub>1–x</sub>P, and In<sub>1–x</sub>Ga<sub>x</sub>As. Similarly, for Al<sub>x</sub>In<sub>y</sub>Ga<sub>1–x–y</sub>As, the three side materials are In<sub>1–x</sub>Al<sub>x</sub>As, Al<sub>x</sub>Ga<sub>1–x</sub>As, and In<sub>1–x</sub>Ga<sub>x</sub>As.

**NOTE** All side and corner materials must appear in the `datexcodes.txt` file, and their mole dependencies must be specified in `Molefraction.txt` (see Specifying Materials on page 14).

If it cannot parse the `Molefraction.txt` file, Sentaurus Device reverts to the defaults shown previously. This might lead to unexpected simulation results.

# Mole-Fraction Specification

In Sentaurus Device, the mole fraction of a compound semiconductor or insulator is defined in the following ways:

*   In the `Grid` file (`<name>.tdr`) of the device structure

*   Internally, in the `Physics` section of the command file

If the mole fraction is loaded from the `.tdr` file and an internal mole fraction specification is also applied, the loaded mole fraction values are overwritten in the regions specified in the `MoleFraction` sections of the command file.

The internal mole fraction distribution is described in the `MoleFraction` statement inside the `Physics` section:

```
Physics { ...
  MoleFraction(<MoleFraction parameters>)
}
```

The parameters for the mole fraction specification and grading options are described in Table 310 on page 1604.

The specification of an `xFraction` is mandatory in the `MoleFraction` statement for binary or ternary compounds; a `yFraction` is also mandatory for quaternary materials. If the `MoleFraction` statement is inside a default `Physics` section, the `RegionName` must be specified. If it is inside a region-specific `Physics` section, by default, it is applied only to that

Physical Models and the Hierarchy of Their Specification

region. If a `MoleFraction` statement is inside a material-specific `Physics` section and the `RegionName` is not specified, this composition is applied to all regions containing the specified material. If `RegionName` is specified inside a region-specific and material-specific `Physics` section, this specification is used instead of the default regions.

> **NOTE** Similar to all statements, only one `MoleFraction` statement is allowed inside each `Physics` section. By default, grading is not included.

An example of a mole fraction specification is:

```
Physics {
  MoleFraction(RegionName = ["Region.3" "Region.4"]
    xFraction=0.8
    yFraction=0.7
    Grading(
        (xFraction=0.3 GrDistance=1
         RegionInterface=("Region.0" "Region.3"))
        (xFraction=0.2 yFraction=0.1 GrDistance=1
         RegionInterface=("Region.0" "Region.5"))
        (yFraction=0.4 GrDistance=1
         RegionInterface=("Region.0" "Region.3"))
    )
  )
}
Physics (Region = "Region.6") {
  MoleFraction(xFraction=0.1 yFraction=0.7 GrDistance=0.01)
}
```

# Physical Models and the Hierarchy of Their Specification

The `Physics` section is used to select the models that are used to simulate a device. Table 231 on page 1547 lists the keywords that are available, and Part II discusses the models in detail. Physical models can be specified globally, per region or material, per interface, or per electrode.

Some models (for example, the hydrodynamic transport model) can only be activated for the whole device. Regionwise or materialwise specifications are syntactically possible, but Sentaurus Device silently ignores them. Likewise, some specifications are syntactically possible for all locations, but they are semantically valid only for interfaces or bulk regions. In the tables in Appendix G on page 1507, the validity of specifications is indicated in the description column by characters in parentheses. For example, (g) denotes models that can be activated only for the entire device, but not for individual parts of it.

Some specifications are syntactically possible everywhere, but are valid for certain materials only. For example, `Mobility` is only valid in semiconductors.

**2: Specifying Physical Devices**
Physical Models and the Hierarchy of Their Specification

# Region-Specific and Material-Specific Models

In Sentaurus Device, different physical models for different regions and materials within a device structure can be specified. The syntax for this feature is:

```
Physics (material="material") {
  <physics-body>
}
```

or:

```
Physics (region="region-name") {
  <physics-body>
}
```

This feature is also available for the `Math` section:

```
Math (material="material") {
  <math-body>
}
```

or:

```
Math (region="region-name") {
  <math-body>
}
```

A `Physics` section without any region or material specifications is considered the default section.

> **NOTE** You can edit region names in Sentaurus Structure Editor (see Sentaurus™ Structure Editor User Guide, Changing the Name of a Region on page 109).

The `Physics` and `Math` sections for different locations are related as follows:

* Physical models defined in the global `Physics` section (that is, in the section without any region or material specifications) are applied in all regions of the device.

* Physical models defined in a material-specific `Physics` section are added to the default models for all regions containing the specified material.

* The same applies to the physical models defined in a region-specific `Physics` section: all regionwise defined models are added to the models defined in the default section.

Physical Models and the Hierarchy of Their Specification

> **NOTE** If for a region, both a region-specific `Physics` section and a material-specific `Physics` section for the material of the region are present, the region-specific declaration overrides the material-specific declaration, that is, the region-specific `Physics` section will not inherit any models from the material-specific section.

For example:

```
Physics {<Default models>}
Physics (Material="GaAs") {<GaAs models>}
Physics (Region="Emitter"){<Emitter models>}
```

If the "Emitter" region is made of GaAs, the models in this region are `<Default models>` and `<Emitter models>`, that is, whatever `<GaAs models>` contains is ignored in region "Emitter".

For some models, the model specification and numeric values of the parameters are defined in the `Physics` sections. Examples of such models are `Traps` and the `MoleFraction` specifications.

For these models, the specifications in region or material `Physics` sections overwrite previously defined values of the corresponding parameters.

If in the default `Physics` section, `MoleFraction` is defined for a given region and, afterward, is defined for the same region again, in a region or material `Physics` section, then the default definition is overwritten. The hierarchy of the parameter specification is the same as discussed previously.

## Interface-Specific Models

A special set of models can be activated at the interface between two different materials or two different regions. In Table 231 on page 1547, pure interface models are flagged with ‘(i)’ in the description column.

As physical phenomena at an interface are not the same as in the bulk of a device, not all models are allowed inside interface-specific `Physics` sections. For example, it is not possible to define any mobility models or bandgap narrowing at interfaces.

> **NOTE** Although the `Recombination(surfaceSRH)` statement and the `GateCurrent` statement describe pure interface phenomena, they can be defined in a region-specific `Physics` section. In this case, the models are applied to all interfaces between this region and all adjacent insulator regions. If specified in the global `Physics` section, these models are applied to all semiconductor–insulator interfaces.

**2: Specifying Physical Devices**

Physical Models and the Hierarchy of Their Specification

Interface models are specified in interface-specific `Physics` sections. Their respective parameters are accessible in the parameter file. The syntax for specification of an interface model is:

```
Physics (MaterialInterface="material-name1/material-name2") {
  <physics-body>
}
```

or:

```
Physics (RegionInterface="region-name1/region-name2") {
  <physics-body>
}
```

The following is an example illustrating the specification of fixed charges at the interface between the materials oxide and aluminum gallium arsenide (AlGaAs):

```
Physics(MaterialInterface="Oxide/AlGaAs") {
  Traps(Conc=-1.e12 FixedCharge)
}
```

If no region interface `Physics` section is present for a given region interface, the material interface section is used if present. If the material interface `Physics` section is missing as well, built-in defaults are used. Similar to what holds for regions and materials, if a region interface section is present, it is used for the region interface, ignoring material interface settings completely, even when a material interface `Physics` section is present. However, other than for regions and materials, the global `Physics` section is not used automatically to determine interface `Physics` settings.

# Electrode-Specific Models

Electrode-specific `Physics` sections can be defined. For example:

```
Physics(Electrode="Gate"){
  Schottky
  eRecVel = <float>
  hRecVel = <float>
  Workfunction = <float>
}
```

2: Specifying Physical Devices
Physical Model Parameters

# Physical Model Parameters

Most physical models depend on parameters that can be adjusted in a file given by `Parameter` in the `File` section:

```
File {
  Parameter = <string>
  ...
}
```

The name of the parameter file conventionally has the extension `.par`.

Model parameters are split into sets, where a particular set corresponds to a particular physical model. The available parameter sets and the individual parameters they contain are described along with the description of the related model (see Part II).

Parameters can be specified globally, materialwise, regionwise, material interface–wise, region interface–wise, and electrode-wise. The following example shows each of these possibilities:

```
LatticeHeatCapacity {
  cv = 1.1
}
Material = "Silicon" {
  LatticeHeatCapacity {
    cv = 1.63
  }
}
Region = "Oxide" {
  LatticeHeatCapacity {
    cv = 1.67
  }
}
MaterialInterface = "Silicon/Oxide" {
  LatticeHeatCapacity {
    cv = -1
  }
}
RegionInterface = "Oxide/Bulk" {
  LatticeHeatCapacity {
    cv = -2
  }
}
Electrode = "gate" {
  LatticeHeatCapacity {
    cv = -3
  }
}
```

**2: Specifying Physical Devices**

Physical Model Parameters

As for the models themselves, not all parameters are valid in all locations, even though it is syntactically possible to specify them. For example, the heat capacity is not used for interfaces and electrodes. Therefore, it does not matter that the values provided in the example above are nonsensical.

To specify parameters for multiple parameter sets for the same location, put all these specifications together into one section for that location, as in the following example for dielectric permittivity and heat capacity:

```
Material = "Silicon" {
  Epsilon{
    epsilon= 11.6
  }
  LatticeHeatCapacity {
    cv = 1.63
  }
}
```

Parameter files support an `Insert` statement to insert other parameter files. Inserted files themselves can use `Insert`. You can change parameters after an `Insert` statement. This is useful to provide standard values through the inserted file and to make the changes to those standards explicit. `Insert` is used as in the following example:

```
Material = "Silicon" { Insert = "Silicon.par" }
```

# Search Strategy for Parameter Files

Sentaurus Device uses the following strategy to search for inserted files, from highest to lowest priority as follows:

1. Local directory.

2. The `ParameterPath` variable in the `File` section can specify a list of releases. For example:

```
File {
  ParameterPath = "2019.12 2020.09 2021.06"
}
```

In this case, the following directories are added to the search path:

```
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/2019.12
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/2020.09
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/2021.06
```

Physical Model Parameters

3. Sentaurus Device checks whether the environment variable `SDEVICEDB` is defined. This variable must contain a directory or a list of directories separated by white space or colons. For example:

```
SDEVICEDB="/home/usr/lib /home/tcad/lib"
```

Sentaurus Device scans the directories in the given order until the inserted file is found.

**NOTE** The environment variable `SDEVICEDB` also is used for the insert directive in Sentaurus Device command files (see Inserting Files on page 139).

4. The default library directory:

```
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB
```

In all cases, Sentaurus Device prints the path to the actual file and displays an error message if it cannot be found.

**NOTE** The insert directive is also available for command files (see Inserting Files on page 139).

# Parameters for Composition-Dependent Materials

The following parameter sets provide mole fraction dependencies. All models are available for compound semiconductors only, except where otherwise noted:

*   `Epsilon` (also available for compound insulators)

*   `LatticeHeatCapacity` (also available for compound insulators)

*   `Kappa` (lattice thermal conductivity, also available for compound insulators)

*   `EnergyRelaxationTime`

*   `Bandgap`

*   `Bennett` (bandgap narrowing)

*   `delAlamo` (bandgap narrowing)

*   `OldSlotboom` (bandgap narrowing)

*   `Slotboom` (bandgap narrowing)

*   `JainRoulston` (bandgap narrowing)

*   `eDOSMass`

*   `hDOSMass`

*   `ConstantMobility`

*   `DopingDependence` (mobility model)

*   `HighFieldDependence` (mobility model)

2: Specifying Physical Devices
Physical Model Parameters

*   TransferredElectronEffect2 (mobility model)

*   Enormal (mobility model)

*   ToCurrentEnormal (mobility model)

*   PhuMob (mobility model)

*   `ThinLayerMobility`

*   StressMobility (hSixBand model parameters)

*   vanOverstraetendeMan (impact ionization model)

*   `MLDAQMModel`

*   `SchroedingerParameters`

*   `Band2BandTunneling`

*   `DirectTunneling` (for semiconductor–insulator interfaces only)

*   `AbsorptionCoefficient`

*   `QWStrain` (see Electronic Band Structure for Wurtzite Crystals on page 1033 and Syntax for Quantum-Well Strain on page 1043)

*   `RefractiveIndex` (also available for compound insulators)

*   Radiative recombination

*   Shockley–Read–Hall recombination

*   Auger recombination

*   Piezoelectric polarization

*   `QuantumPotentialParameters`

*   Deformation potential (elasticity modulus, the parameters for the electron band: `xis`, `dbs`, `xiu`, `xid` and, for hole band: `adp`, `bdp`, `ddp`, `dso`)

*   `SHEDistribution`

*   `ComplexRefractiveIndex`

*   `BandstructureParameters` (see Electronic Band Structure for Wurtzite Crystals on page 1033)

*   `FEPolarization`

Sentaurus Device supports the suppression of the mole fraction dependence of a given model and the use of a fixed (mole fraction–independent) parameter set instead. To suppress mole fraction dependency, specify the (fixed) values for the parameter (for example, `Eg0=1.53`) and omit all other coefficients associated with the interpolation over the mole fraction (for example, `Eg0(1)`, `B(Eg0(1))`, and `C(Eg0(1))`) from this section of the parameter file. It is not necessary to set them to zero individually.

> **NOTE** When specifying a fixed value for one parameter of a given model, all other parameters for the same model must be fixed.

Physical Model Parameters

In summary, if the mole fraction dependence of a given model is suppressed, the parameter specification for this model is performed in exactly the same manner as for mole fraction–independent material.

## Ternary Semiconductor Composition

To illustrate a calculation of mole fraction–dependent parameter values for ternary materials, consider one mole interval from $x_{i-1}$ to $x_i$. For mole fraction value ($x$) of this interval, to compute the parameter value ($P$), Sentaurus Device uses the expression:

$$
\begin{aligned}
P &= P_{i-1} + A \cdot \Delta x + B_i \cdot \Delta x^2 + C_i \cdot \Delta x^3 \\
A &= \frac{\Delta P_i}{\Delta x_i} - B_i \cdot \Delta x_i - C_i \cdot \Delta x_i^2 \\
\Delta P_i &= P_i - P_{i-1} \\
\Delta x_i &= x_i - x_{i-1} \\
\Delta x &= x - x_{i-1}
\end{aligned}
\eqno(1)
$$

where $P_i$, $B_i$, $C_i$, $x_i$ are values defined in the parameter file for each mole fraction interval, $x_0 = 0$, $P_0$ is the parameter value (at $x = 0$) specified using the same manner as for mole fraction–independent material (for example, `Eg0=1.53`). As in the formulas above, you are not required to specify coefficient $A$ of the polynomial because it is easily recomputed inside Sentaurus Device.

In the case of undefined parameters (these can be listed by printing the parameter file), Sentaurus Device uses linear interpolation using two parameter values of side materials (for $x = 0$ and $x = 1$):

$$
P = (1 - x)P_{x0} + xP_{x1} \eqno(2)
$$

| Mole Fraction | Parameter Value |
| --- | --- |
| 0 |  |
| x_{i-1} | P_{i-1} |
| x_i | P_i |
| 1 |  |

Figure 6 Parameter value as a function of mole fraction

2: Specifying Physical Devices
Physical Model Parameters

# Example 1: Specifying Electric Permittivity

This example provides the specification of dielectric permittivity for Al<sub>x</sub>Ga<sub>1–x</sub>As:

```
Epsilon
{ * Ratio of the permittivities of material and vacuum
        epsilon = 13.18       # [1]
  * Mole fraction dependent model.
  * The linear interpolation is used on interval [0,1].
        epsilon(1) = 10.06    # [1]
}
```

A linear interpolation is used for the dielectric permittivity, where epsilon specifies the value for the mole fraction $x = 0$, and epsilon(1) specifies the value for $x = 1$.

# Example 2: Specifying Band Gap

This example provides a specification of the bandgap parameters for Al<sub>x</sub>Ga<sub>1–x</sub>As. A polynomial approximation, up to the third degree, describes the mole fraction–dependent band parameters on every mole fraction interval. In the following example, two intervals are used, namely, [Xmax(0), Xmax(1)] and [Xmax(1), Xmax(2)]. The parameters Eg0, Chi0, ... correspond to the values for $X = Xmax(0)$; while the parameters Eg0(1), Chi0(1), ... correspond to the values for $X = Xmax(1)$ and, finally, Eg0(2), Chi0(2), ... correspond to the values for $X = Xmax(2)$.

The coefficients $A$ and $F$ of the following polynomial are determined from the values at both ends of the intervals:

$$ F + A(X - Xmin(I)) + B(X - Xmin(I))^2 + C(X - Xmin(I))^3 \eqno(3) $$

The coefficients $B$ and $C$ must be specified explicitly. You can introduce additional intervals:

```
Bandgap *temperature dependent*
{ * Eg = Eg0 - alpha T^2 / (beta + T) + alpha Tpar^2 / (beta + Tpar)
  * Eg0 can be overwritten in below bandgap narrowing models,
  * if any of the BGN model is chosen in physics section.
  * Parameter 'Tpar' specifies the value of lattice
  * temperature, at which parameters below are defined.
        Eg0 = 1.42248          # [eV]
        Chi0 = 4.11826         # [eV]
        alpha = 5.4050e-04     # [eV K^-1]
        beta = 2.0400e+02      # [K]
        Tpar = 3.0000e+02      # [K]
  * Mole fraction dependent model.
  * The following interpolation polynomial can be used on interval
  [Xmin(I),Xmax(I)]:
  * F(X) = F(I-1)+A(I)*(X-Xmin(I))+B(I)*(X-Xmin(I))^2+C(I)*(X-Xmin(I))^3,
```

Physical Model Parameters

```
 * where Xmax(I), F(I), B(I), C(I) are defined below for each interval.
 * A(I) is calculated for a boundary condition F(Xmax(I)) = F(I).
 * Above parameters define values at the following mole fraction:
        Xmax(0) = 0.0000e+00      # [1]
 * Definition of mole fraction intervals, parameters, and coefficients:
        Xmax(1) = 0.45            # [1]
        Eg0(1) = 1.98515          # [eV]
        B(Eg0(1)) = 0.0000e+00    # [eV]
        C(Eg0(1)) = 0.0000e+00    # [eV]
        Chi0(1) = 3.575           # [eV]
        B(Chi0(1)) = 0.0000e+00   # [eV]
        C(Chi0(1)) = 0.0000e+00   # [eV]
        alpha(1) = 4.7727e-04     # [eV K^-1]
        B(alpha(1)) = 0.0000e+00  # [eV K^-1]
        C(alpha(1)) = 0.0000e+00  # [eV K^-1]
        beta(1) = 1.1220e+02      # [K]
        B(beta(1)) = 0.0000e+00   # [K]
        C(beta(1)) = 0.0000e+00   # [K]
        Xmax(2) = 1               # [1]
        Eg0(2) = 2.23             # [eV]
        B(Eg0(2)) = 0.143         # [eV]
        C(Eg0(2)) = 0.0000e+00    # [eV]
        Chi0(2) = 3.5             # [eV]
        B(Chi0(2)) = 0.0000e+00   # [eV]
        C(Chi0(2)) = 0.0000e+00   # [eV]
        alpha(2) = 4.0000e-04     # [eV K^-1]
        B(alpha(2)) = 0.0000e+00  # [eV K^-1]
        C(alpha(2)) = 0.0000e+00  # [eV K^-1]
        beta(2) = 0.0000e+00      # [K]
        B(beta(2)) = 0.0000e+00   # [K]
        C(beta(2)) = 0.0000e+00   # [K]
}
```

# Quaternary Semiconductor Composition

Sentaurus Device supports 1:3, 2:2, and 3:1 III–V quaternary alloys. A 1:3 III–V quaternary alloy is given by:

$$ AB_x C_y D_z $$ (4)

where *A* is a group III element, and *B*, *C*, and *D* are group V elements (usually listed according to increasing atomic number). Conversely, a 3:1 III–V quaternary alloy can be described as:

$$ A_x B_y C_z D $$ (5)

where *A*, *B*, and *C* are group III elements, and *D* is a group V element.

**2: Specifying Physical Devices**
Physical Model Parameters

The composition variables $x$, $y$, and $z$ are nonnegative, and they are constrained by:

$$x + y + z = 1 \tag{6}$$

An example would be Al$_x$Ga$_y$In$_{1-x-y}$As, where $1 - x - y$ corresponds to $z$.

Sentaurus Device uses the symmetric interpolation scheme proposed by Williams *et al.* [[1]]([1]) to compute the parameter value $P(A_x B_y C_z D)$ of a 3:1 III–V quaternary alloy as a weighted sum of the corresponding ternary values:

$$P(A_x B_y C_z D) = \frac{xyP(A_{1-u} B_u D) + yzP(B_{1-v} C_v D) + xzP(A_{1-w} C_w D)}{xy + yz + xz} \tag{7}$$

where:

$$u = \frac{1 - x + y}{2}, v = \frac{1 - y + z}{2}, w = \frac{1 - x + z}{2} \tag{8}$$

The parameter values $P(AB_x C_y D_z)$ for 1:3 III–V quaternary alloys are computed similarly. A general 2:2 III–V quaternary alloy is given by:

$$A_x B_{1-x} C_y D_{1-y} \tag{9}$$

where $A$ and $B$ are group III elements, and $C$ and $D$ are group V elements. The composition variables $x$ and $y$ satisfy the inequalities $0 \le x \le 1$ and $0 \le y \le 1$. As an example, the material In$_{1-x}$Ga$_x$As$_y$P$_{1-y}$ is mentioned.

The parameters $P(A_x B_{1-x} C_y D_{1-y})$ of a 2:2 III–V quaternary alloy are determined by interpolation between the four ternary side materials:

$$P(A_x B_{1-x} C_y D_{1-y}) = \frac{x(1 - x)(yP(A_x B_{1-x} C) + (1 - y)P(A_x B_{1-x} D)) + y(1 - y)(xP(A C_y D_{1-y}) + (1 - x)P(B C_y D_{1-y}))}{x(1 - x) + y(1 - y)} \tag{10}$$

The interpolation of model parameters for quaternary alloys is also discussed in the literature [[2]]([2])[[3]]([3])[[4]]([4])[[5]]([5]). A comprehensive survey paper is available [[6]]([6]).

## Default Model Parameters for Compound Semiconductors

It is important to understand how the default values for different physical models in different materials are determined. The approach used in Sentaurus Device is summarized here. For example, consider the material `Material`. Assume that no default parameters are defined for this material and a given physical model `Model`.

29

Physical Model Parameters

In this case, use the command `sdevice -P:Material` to see for which models specific default parameters are predefined in the material `Material`:

1. Silicon parameters are used, by default, in the model `Model` if the material `Material` is mole fraction independent.

2. If `Material` is a compound material and dependent on the mole fraction $x$, the default values of the parameters for the model `Model` are determined by a linear interpolation between the values of the respective parameters of the corresponding ‘pure’ materials (that is, materials corresponding to $x = 0$ and $x = 1$). For example, for Al<sub>x</sub>Ga<sub>1–x</sub>As, values of the parameters of GaAs and AlAs are used in the interpolation formula.

3. If `Material` is a quaternary material and dependent on $x$ and $y$, an interpolation formula, which is based on the values of all corresponding ternary materials, is used. For example, for InGaAsP, the values of four materials (InAsP, GaAsP, GaInP, and InGaAs) are used in the interpolation procedure to obtain the default values of the parameters.

Additional details for each model and specific materials are found in the comments of the parameter file.

## Combining Parameter Specifications

Sentaurus Device has built-in values for many parameters, can read parameters from files in a default location, and can read a user-supplied parameter file that can specify parameters for various locations. This section discusses the rules for combining all these specifications.

Parameter handling is affected by the presence of the flag `DefaultParametersFromFile` (specified in the global `Physics` section) and the value of `ParameterInheritance` (specified in the global `Math` section). By default, `ParameterInheritance=Flatten`; by setting `ParameterInheritance=None`, the rules for combining parameter specifications can be altered.

### Materialwise Parameters

To determine materialwise parameters, follow these steps:

1. The parameters are initialized from built-in values. These values can depend on the material. For many materials, no appropriate built-in values exist, and silicon values are used instead.

2. If the `DefaultParametersFromFile` flag is present, then Sentaurus Device reads the default parameter file for the material. This file can add parameters (for example, add intervals to a mole fraction specification) or overwrite built-in values (for details, see Default Parameters on page 35).

**2: Specifying Physical Devices**
Physical Model Parameters

3. If `ParameterInheritance=Flatten` and specifications outside any location-specific section are present, then they can add or overwrite the parameter values obtained through the previous two steps, and they also contribute to a separate, global, default parameter set.

4. If your parameter file contains a section for the material, then specifications in this section can add to or overwrite the parameter values obtained through the previous three steps. If `ParameterInheritance=None`, specifications outside any location-specific section are handled as if they occurred in a section for the material silicon.

Materialwise specifications in your parameter file are read even when the material is not contained in the structure to be simulated. This is useful, for example, to provide parameters for corner and side materials for materials that are present in the structure.

Apart from corner and side materials, materialwise parameters are rarely used directly; physical bulk models access parameters regionwise, not materialwise. However, materialwise settings can affect regionwise parameters. The next section explains this in detail.

## Regionwise Parameters

When your parameter file does not contain a section for a certain region, the parameter values for this region are the same as for the material of the region. In this case, if `ParameterInheritance=None`, the regionwise parameters are discarded entirely and the material parameters are accessed instead. If `ParameterInheritance=Flatten`, the region parameters are a copy of the material parameters (the subtle distinction of these two cases becomes important only when ramping parameters).

If your parameter file does contain a section for a certain region, the parameters for this region are initialized executing Steps 1 and 2 as for the materialwise parameters, using the material of the region to select the built-in values and the default parameter file. If `ParameterInheritance=Flatten`, and a section for this material is present in your parameter file, Steps 3 and 4 are taken as well. Finally, in any case, the section for the region is evaluated and can add to or overwrite the values previously obtained.

> **NOTE** If `ParameterInheritance=None` and a section for a region is present in your parameter file, then none of the settings for any parameter in the section for the material of the region (if such a section exists) has an effect on the parameters for that region. In other words, if `ParameterInheritance=None`, then the region parameters do not 'inherit' user settings from the material parameters.

Physical Model Parameters

## Material Interface–Wise Parameters

Material interface–wise parameters are handled similarly to materialwise parameters, simply replace the term ‘material’ by ‘material interface’ in the description of the handling of materialwise parameters.

## Region Interface–Wise Parameters

Region interface–wise parameters are handled similarly to regionwise parameters, and the relation between region interface–wise parameters and material interface–wise parameters is analogous to the relation between regionwise and materialwise parameters. As an additional complication, if `ParameterInheritance=None` and neither a section for the region interface nor for its material interface is present in your parameter file, the region interface parameters are discarded, and the parameters for material silicon are accessed instead.

## Electrode-Wise Parameters

Electrode-wise parameters are handled similarly to materialwise parameters, simply replace the term ‘material’ by ‘electrode’ in the description of the handling of materialwise parameters.

# Generating a Copy of Parameter File

To redefine a parameter value for a particular material, a copy of the default parameter file must be created. To do this, the command `sdevice -P` prints the parameter file for silicon, with insulator properties. Table 3 lists the principal options for the command `sdevice -P`.

Table 3 Principal options for generating a parameter file

| Option | Description |
| --- | --- |
| -P:All | Prints a copy of the parameter file for all materials. Materials are taken from the file `datexcodes.txt`. |
| -P:Material | Prints model parameters for the specified material. |
| -P:Material:x | Prints model parameters for the specified material for mole fraction x. |
| -P:Material:x:y | Prints model parameters for the specified material for mole fractions x and y. |
| -P filename | Prints model parameters for materials and interfaces used in the command file `filename`. |
| -r | Reads parameters from default locations (see Search Strategy for Parameter Files on page 23) before printing parameters. This is analogous to using the `DefaultParametersFromFile` flag (see Materialwise Parameters on page 30). |

2: Specifying Physical Devices

Physical Model Parameters

For regionwise and materialwise parameter specifications, any model and parameter from the default section is usable, even if it is not printed for the particular material.

For mole fraction–dependent parameters, for people, it is difficult to read a parameter file and to obtain the final values of parameters (for example, the band gap) for a particular composition mole fraction. By using the command `sdevice -M <inputfile.cmd>`, Sentaurus Device creates a `models-M.par` file that will contain regionwise parameters with only constant values (instead of the polynomial coefficients) for regions where the composition mole fraction is constant. For regions where the composition is not a constant, Sentaurus Device prints the default material parameters.

As an alternative to the command `sdevice -P`, Sentaurus Device provides the `sdevice -L` command, which supports the same options in Table 3 on page 32 for `sdevice -P`. However, instead of generating a single file, it creates separate files for each material and each material interface. Typically, these files are edited and used to provide default parameters (see Default Parameters on page 35).

For example, assume the command file `pp1_des.cmd` is for a simple silicon MOSFET with four electrodes, one silicon region, and one oxide region. Using the following command, a parameter file is created in the current directory for each material, material interface, and electrode found in `nmos_mdr.tdr`:

```
sdevice -L pp1_des.cmd
```

In this example, the appropriate files are `Silicon.par`, `Oxide.par`, `Oxide%Silicon.par`, and `Electrode.par`.

In addition, the following `models.par` file is created in the current directory:

```
Region = "Region0" { Insert = "Silicon.par" }
Region = "Region1" { Insert = "Oxide.par" }
RegionInterface = "Region1/Region0" { Insert = "Oxide%Silicon.par" }
Electrode = "gate" { Insert = "Electrode.par" }
Electrode = "source" { Insert = "Electrode.par" }
Electrode = "drain" { Insert = "Electrode.par" }
Electrode = "substrate" { Insert = "Electrode.par" }
```

This `models.par` file can be renamed. It is only used in the simulation if it is specified in the `File` section of the command file of Sentaurus Device:

```
File {...
  Parameter = "models.par"
  ...
```

**2: Specifying Physical Devices**
Physical Model Parameters

# Undefined Physical Models

For a nonsilicon simulation, the default behavior of Sentaurus Device is to use silicon parameters for models that are not defined in a material used in the simulation. It is useful for noncritical models, but it can lead to confusion, for example, if the semiconductor band gap is not defined, and Sentaurus Device uses that of silicon. Therefore, Sentaurus Device has a list of critical models and stops the simulation, with an error message, if these models are not defined.

> **NOTE** The model is defined in a material if it is present in the default parameter file of Sentaurus Device for the material or it is specified in a user-defined parameter file.

Table 4 lists the critical models (with names from the parameter file of Sentaurus Device) with materials where these models are checked.

Table 4 List of critical models

| Model | Insulator | Semiconductor | Conductor |
| --- | --- | --- | --- |
| Auger |  | x |  |
| Bandgap |  | x |  |
| ConstantMobility |  | x |  |
| DopingDependence |  | x |  |
| eDOSmass hDOSmass |  | x |  |
| Epsilon | x | x |  |
| Kappa | x | x | x |
| RadiativeRecombination |  | x |  |
| RefractiveIndex | x | x |  |
| Scharfetter |  | x |  |
| SchroedingerParameters | x | x |  |

The models `Bandgap`, `DOSmass`, and `Epsilon` are checked always. For other models, this check is performed for each region, but only if appropriate models in the `Physics` section and equations in the `Solve` section are activated. The thermal conductivity model `Kappa` is checked only if the lattice temperature equation is included.

Drift-diffusion or hydrodynamic simulations activate the checking mobility models `ConstantMobility` and `DopingDependence` (with appropriate models in the `Physics` section).

2: Specifying Physical Devices

Physical Model Parameters

**NOTE** This checking procedure can be switched off by the keyword `-CheckUndefinedModels` in the `Math` section.

The models `eDOSmass` and `hDOSmass` also must be defined for insulators to support tunneling (see Nonlocal Tunneling Parameters on page 778). Only the following specifications are acceptable for insulators:

```
eDOSmass {
  Formula = 1
  a = 0
  ml = 0
  mm = <effective mass>   # default 0.42
}

hDOSmass {
  Formula = 1
  a = 0
  b = 0
  c = 0
  d = 0
  e = 0
  f = 0
  g = 0
  h = 0
  i = 0
  mm = <effective mass>   # default 1
}
```

**NOTE** In general, the models `eDOSmass` and `hDOSmass` only need to be specified for user-specified insulators. The correct values are predefined for standard insulators.

---

# Default Parameters

Sentaurus Device provides built-in default parameters for many models and materials. However, Sentaurus Device also offers the option to overwrite the built-in values with default parameters from files. This option is activated by `DefaultParametersFromFile` in the global `Physics` section:

```
Physics {
  DefaultParametersFromFile
  ...
}
```

Physical Model Parameters

Table 5 File names that are used to initialize default parameters

| Location of parameters | File name |
| --- | --- |
| Materials | <material>.par, for example, Silicon.par, GaAs.par |
| Material interfaces | <material1>%<material2>.par, for example, InAlAs%AlGaAs.par (Instead of %, a comma or space can also be used.) |
| Contacts | Contact.par or Electrode.par |

Sentaurus Device uses the same search strategy as for inserted files (see Physical Model Parameters on page 22). Sentaurus Device ships with a selection of parameter files in the directory `$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB`. This directory also contains release-specific subdirectories. For example:

```
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/2019.12
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/2020.09
$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/2021.06
```

You can request that the parameter files from a specific release are taken by specifying the `ParameterPath` variable in the `File` section:

```
File {
  ParameterPath = "2021.06"
}
```

If a matching file is not found, then the built-in default parameters are used unaltered. Check the log file of Sentaurus Device to see which files were actually used.

## Named Parameter Sets

Some models in Sentaurus Device support the use of parameter sets that can be named. For example, `EnormalDependence` is the unnamed parameter set used with the Lombardi mobility model. In the parameter file, you can write the following to declare a parameter set for the Lombardi mobility model with the name `myset`:

```
EnormalDependence "myset" {
  B = 3.6100e+07 , 1.5100e+07     # [cm/s]
  C = 1.7000e+04 , 4.1800e+03     # [cm^(5/3)/(V^(2/3)s)]
  ...
}
```

Typically, named parameter sets are used to store alternative parameterizations for a model. They can be selected from the command file by specifying the name with `ParameterSetName` as an option to a model that supports this feature.

2: Specifying Physical Devices

Physical Model Parameters

For example:

```
Physics {
  Mobility (
    PhuMob
    Enormal( Lombardi (ParameterSetName="myset") )
    HighFieldSaturation
  )
}
```

If `ParameterSetName` is not specified, the unnamed parameter set associated with the model is used by default.

Table 6 Models that support named parameter sets

| Model name |  | Parameter set (unnamed) |
| --- | --- | --- |
| eQuantumPotential hQuantumPotential |  | QuantumPotentialParameters |
|  |  |  |
| Mobility eMobility hMobility | Enormal(Lombardi) ToCurrentEnormal(Lombardi) | EnormalDependence |
| ThinLayer(Lombardi) | EnormalDependence ThinLayerMobility |  |
| Enormal(IALMob) ToCurrentEnormal(IALMob) | IALMob |  |
| ThinLayer(IALMob) | IALMob ThinLayerMobility |  |
| HighFieldSaturation eHighFieldSaturation hHighFieldSaturation | HighFieldDependence HydroHighFieldDependence |  |
| Diffusivity eDiffusivity hDiffusivity |  |  |
| Piezo(Mobility) | Tensor eTensor hTensor | Piezoresistance |
| Factor eFactor hFactor | Piezoresistance EffectiveStressModel |  |
| Recombination(Band2Band) |  | Band2BandTunneling |

2: Specifying Physical Devices

Physical Model Parameters

# Auto-Orientation Framework

Some models in Sentaurus Device support an auto-orientation framework that automatically switches between different named parameter sets for model evaluation, based on the surface orientation of the nearest interface.

When the `AutoOrientation` option is activated for a model, by default, Sentaurus Device looks for and uses parameter sets named "100", "110", and "111" corresponding to surface orientations of {100}, {110}, and {111}. If the nearest interface orientation is {110}, for example, the model is evaluated using the parameter set "110". For surface orientations that fall between {100}, {110}, and {111}, the named parameter set that most closely corresponds to the actual surface orientation is used.

Models that support the auto-orientation framework include:

*   Density-gradient quantization model (`eQuantumPotential`, `hQuantumPotential`)

*   Lombardi and IALMob mobility models

*   `HighFieldSaturation` and `Diffusivity`

*   `ThinLayer` mobility model

*   Piezoresistance models (`Tensor`, `eTensor`, `hTensor`, `Factor`, `eFactor`, `hFactor`)

*   `EffectiveStressModel` (`Factor`, `eFactor`, `hFactor`)

In the `Plot` section of the command file, the quantities `InterfaceOrientation` and `NearestInterfaceOrientation` can be specified to see the orientation that is used, at each interface face vertex and at every vertex, respectively, when auto-orientation is enabled for a model.

## Changing Orientations Used With Auto-Orientation

The auto-orientation framework can be modified to use surface orientations other than {100}, {110}, and {111}. This is accomplished by providing a definition for `AutoOrientation` in the `Math` section of the command file:

```
Math { AutoOrientation=(ori₁, ori₂, ...) }
```

In the above specification, the ori<sub>i</sub> values are three-digit integers that represent Miller indices for families of equivalent planes (a cubic lattice structure is assumed). For example, to modify `AutoOrientation` to use the surface orientations {100}, {110}, {111}, and {211}, specify:

```
Math { AutoOrientation=(100, 110, 111, 211) }
```

**2: Specifying Physical Devices**
Physical Model Parameters

In this case, models that support `AutoOrientation` will switch between the parameter sets named "100", "110", "111", and "211", depending on the surface orientation of the nearest interface.

## Auto-Orientation Smoothing

By default, the switch from one parameter set to another when using auto-orientation occurs abruptly. To enable a smooth transition between different parameter sets, specify a nonzero value for the auto-orientation smoothing distance in the `Math` section:

```
Math {
    AutoOrientationSmoothingDistance = 0.005    # [micrometers]
}
```

The smoothing distance is an approximate measure of the distance over which the transition between different parameter sets will occur. For convenience, specifying `AutoOrientationSmoothingDistance < 0` uses the average interface vertex spacing as the smoothing distance. In many cases, this is a reasonable choice.

When auto-orientation smoothing is used, weights are calculated at each vertex for each orientation-dependent parameter set based on the proximity to the different supported surface orientations:

$$ w_i(\text{vertex}) = \sum_{j=1}^{N_i} \left( \frac{A_j}{A_{\text{total}}} \right) \exp \left( -\frac{d_j - d_{\min}}{d_{\text{smooth}}} \right), i = 100, 110, \dots $$ (11)

The summation is over all interface vertices associated with orientation $i$:

*   $d_{\min}$ is the minimum distance to the interface.

*   $d_j$ is the distance to the interface vertex $j$.

*   $d_{\text{smooth}}$ is the smoothing distance.

*   $A_j$ is the area associated with the interface vertex $j$.

*   $A_{\text{total}}$ is the total interface area.

At each vertex, very small weights are set to zero, and the remaining weights are normalized so that their sum is equal to one.

During model evaluation, the weights for each orientation at a vertex are used to obtained a weighted average of the quantity being calculated.

In the `Plot` section of the command file, the quantity `AutoOrientationSmoothing` can be specified to see the vertices where auto-orientation smoothing is used and the dominant orientation at those vertices.

2: Specifying Physical Devices
References

# References

[1] C. K. Williams *et al.*, “Energy Bandgap and Lattice Constant Contours of III-V Quaternary Alloys of the Form A<sub>x</sub>B<sub>y</sub>C<sub>z</sub>D or AB<sub>x</sub>C<sub>y</sub>D<sub>z</sub>,” *Journal of Electronic Materials*, vol. 7, no. 5, pp. 639–646, 1978.

[2] T. H. Glisson *et al.*, “Energy Bandgap and Lattice Constant Contours of III-V Quaternary Alloys,” *Journal of Electronic Materials*, vol. 7, no. 1, pp. 1–16, 1978.

[3] M. P. C. M. Krijn, “Heterojunction band offsets and effective masses in III–V quaternary alloys,” *Semiconductor Science and Technology*, vol. 6 , no. 1, pp. 27–31, 1991.

[4] S. Adachi, “Band gaps and refractive indices of AlGaAsSb, GaInAsSb, and InPAsSb: Key properties for a variety of the 2–4-mm optoelectronic device applications,” *Journal of Applied Physics*, vol. 61, no. 10, pp. 4869–4876, 1987.

[5] R. L. Moon, G. A. Antypas, and L. W. James, “Bandgap and Lattice Constant of GaInAsP as a Function of Alloy Composition,” *Journal of Electronic Materials*, vol. 3, no. 3, pp. 635–644, 1974.

[6] I. Vurgaftman, J. R. Meyer, and L. R. Ram-Mohan, “Band parameters for III–V compound semiconductors and their alloys,” *Journal of Applied Physics*, vol. 89, no. 11, pp. 5815–5875, 2001.

