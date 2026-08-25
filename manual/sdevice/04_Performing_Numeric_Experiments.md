# CHAPTER 4 Performing Numeric Experiments

*This chapter describes how to perform numeric experiments.*

Performing a simulation is the virtual analog to performing an experiment in the real world. This chapter describes how to specify the parameters that constitute such an *experiment*, in particular, bias conditions and their variation. It also describes how to perform important types of experiment that involve periodic signals, such as small-signal analysis. Some experiments described here have no real-world analogy, for example, continuous change of physical parameters and device-internal quantities.

# Specifying Electrical Boundary Conditions

Electrical boundary conditions are specified in the `Electrode` section. Only one `Electrode` section must be defined for each device. Each electrode is defined in a subsection enclosed by braces and must include a name and default voltage. For example, a complete `Electrode` section is:

```
Electrode {
  { name = "source" Voltage = 1.0 Current = 1e-3}
  { name = "drain"  Voltage = 0.0 }
  { name = "gate"   Voltage = 0.0 Material = "PolySi"(P=6.0e19) }
}
```

Table 201 on page 1512 lists all keywords that can be specified for each electrode. Keywords that relate to the physical properties of electrodes are discussed in Electrical Boundary Conditions on page 211.

Contacts in the `Electrode` section can be specified alternatively by a user-defined regular expression instead of a well-defined name. In this case, all the matching contacts in the structure file (TDR file) will be given the properties defined by the contact with the matching pattern. For example, in a device with nine drain contacts named `drain1` ... `drain9`, you can define them simultaneously with:

```
Electrode {
  ...
  { name = regexp("drain[1-9]")  Voltage = 0.0 }
  ...
}
```

Specifying Electrical Boundary Conditions

The regular expressions must be specified following the rules defined by the `boost::regex` library with Perl regular expression syntax enabled [[1]]([1]).

Internally, Sentaurus Device matches the regular expressions defined in the `Electrode` section against the contacts in the structure file as a preprocessing step before the simulation. The list of matched structure contacts is expanded as valid contacts, and the simulation proceeds as usual. When structure contacts are matched by more than a regular expression, the last defined in the `Electrode` section succeeds. When a contact is specified in the standard way using the `Name` keyword and also is matched by a regular expression, the last defined in the `Electrode` section succeeds.

You can specify time-dependent boundary conditions, by providing a list of voltage–time pairs. The following example specifies the voltage at `source` to be 5 V at 0 s, increasing linearly to 10 V at 1 μs:

```
{ name = "source" voltage = (5 at 0, 10 at 1e-6) }
```

In addition, you can specify a separate *static* voltage. For example:

```
{ name = "source" voltage = 0 voltage = (5 at 0, 10 at 1e-6) }
```

This combination is useful where an initial quasistationary command ramps `source` from 0 V to 5 V, before `source` increases to 10 V during a subsequent transient analysis.

The parameters `Charge` and `Current` determine the boundary condition type as well as the value for an electrode. By default, electrodes have a voltage boundary condition type. The keyword `Current` changes the boundary to current type, and the keyword `Charge` changes it to charge type. Note that for current boundary conditions, you still must specify `Voltage`; this value is used as an initial guess when the simulation begins, but it has no impact on the final results. `Charge` and `Current` support time-dependent specifications in the same manner as explained for `Voltage`.

## Changing Boundary Condition Type During Simulation

The `Set` statement in the `Solve` section changes the boundary condition type for an electrode as follows:

*   To change the boundary condition of a current contact `<name>` to voltage type, use:

```
Set(<name> mode voltage)
```

*   To change the boundary condition of a voltage contact `<name>` to current type or charge type, use one of the following:

```
Set(<name> mode current)
Set(<name> mode charge)
```

**4: Performing Numeric Experiments**

Specifying Electrical Boundary Conditions

*   To change the boundary condition of a charge contact `<name>` to voltage type, use:

```
Set(<name> mode voltage)
```

> **NOTE** Changing the boundary condition of a current contact `<name>` directly to charge type or from a charge contact `<name>` directly to current type is not allowed.

The following example changes the boundary condition for the voltage contact `drain` from voltage type to current type:

```
Solve { ...
  Set ("drain" mode current)
  ...
}
```

If the boundary condition for `drain` was of current type before the `Set` statement is executed, nothing happens.

The `Set` statement does not change the value of the voltages and currents at the electrodes. The boundary value for the new boundary condition type results from the solution previously obtained for the bias point at which the `Set` statement appears.

Alternatively, to change the boundary condition type of a contact, use the `Quasistationary` statement (see Quasistationary Ramps on page 74) or the `Transient` statement (see Transient Ramps on page 96). This is usually more convenient. However, a goal value for the boundary condition must be specified; whereas, the `Set` statement allows you to fix the current, charge, or voltage at a contact to a value reached during the simulation, even if this value is not known beforehand.

# Mixed-Mode Electrical Boundary Conditions

In mixed-mode simulations, an additional possibility to specify electrical boundary conditions is to connect electrodes to a circuit (see Electrical and Thermal Netlists on page 56).

The `Set` statement in the `Solve` section can be used to determine the boundary conditions at circuit nodes (see Initializing Nodes on page 58). The `Set` statement takes a list of nodes with optional values as parameters. If a value is given, the node is set to that value. If no value is given, the node is set to its current value. The nodes are set until the end of the Sentaurus Device run or the next `Unset` statement with the specified node.

The `Unset` statement takes a list of nodes and *frees* them (that is, the nodes are floating). In practice, the `Set` statement is used in the `Solve` section to establish a complex system of steps, circuit region by circuit region.

Specifying Thermal Boundary Conditions

The SPICE voltage and current sources use vector parameters to define the properties of various source types. The following example defines a voltage source with an offset v<sub>o</sub> = sine[0] = 0.5 V, an amplitude v<sub>a</sub> = sine[1] = 1 V, a frequency freq = sine[2] = 10 Hz, a delay t<sub>d</sub> = sine[3] = 0 s, a damping factor theta = sine[4] = 0 s<sup>–1</sup>, and a phase shift phi = sine[5] = 0 rad:

```
System {
  Vsource_pset v0 (n1 n0) { sine = (0.5 1 10 0 0 0) }
}
```

Components of such vectors can be set in the `Solve` section.

The following example sets the offset of the sine voltage source `v0` to 0.75 V :

```
Solve { ...
  Set (v0."sine[0]" = 0.75) ...
}
```

# Specifying Thermal Boundary Conditions

The `Thermode` section defines the thermal contacts of a device. The `Thermode` section is defined in the same way as the `Electrode` section. By default, the temperature specified with `Temperature` is the temperature of the thermode. If, in addition, `Power` (in W/cm<sup>2</sup>) is specified in the `Thermode` section, a heat flux boundary condition is imposed instead, and the specified temperature serves as an initial guess only. For example:

```
Thermode {
  { Name = "top"    Temperature = 350 }
  { Name = "bottom" Temperature = 300 Power = 1e6 }
}
```

Thermal contacts in the `Electrode` section can be specified alternatively by a user-defined regular expression instead of a well-defined name. In this case, all the matching thermal contacts in the structure file (TDR file) will be given the properties defined by the thermal contact with the matching pattern. The matching process is similar to that of electrical contacts (see Specifying Electrical Boundary Conditions on page 67).

Time-dependent thermal boundary conditions are specified using the same syntax as for electrical boundary conditions (see Specifying Electrical Boundary Conditions on page 67).

Table 352 on page 1639 lists the keywords available for the `Thermode` section. Thermal Boundary Conditions on page 235 discusses the physical options. In mixed-mode device simulation, an additional possibility to specify thermal boundary conditions is to connect thermodes to a thermal circuit (see Electrical and Thermal Netlists on page 56).

4: Performing Numeric Experiments
Break Criteria: Conditionally Stopping the Simulation

**NOTE** Only thermodes with a thermal resistive boundary condition can be connected to a circuit. Thermodes with a heat flux boundary condition are not available for circuit connections.

Table 16 Various thermode declarations

| Command statement | Description |
| --- | --- |
| { Name = "surface" Temperature = 310 SurfaceResistance = 0.1 } | This is a thermal resistive boundary condition with 0.1 cm2K/W thermal resistance, which is specified at the thermode ‘surface.’ |
| { Name = "body" Temperature = 300 Power = 1e6 } | Heat flux boundary condition. |
| { Name = "bulk" Temperature = 300 Power = 1e5 Power = (1e5 at 0, 1e6 at 1e-4, 1e3 at 2e-4) } | Thermode with time-dependent heat flux boundary condition. |

# Break Criteria: Conditionally Stopping the Simulation

Sentaurus Device prematurely terminates a simulation if certain values exceed a given limit. This feature is useful during a nonisothermal simulation to stop the calculations when the silicon starts to melt or to stop a breakdown simulation when the current through a contact exceeds a predefined value.

The following values can be monitored during a simulation:

* Contact voltage (inner voltage)

* Contact current

* Lattice temperature

* Current density

* Electric field (absolute value of field)

* Device power

It is possible to specify values to a lower bound and an upper bound. Similarly, a bound can be specified on the absolute value. The break criteria can have a global or sweep specification. If the break is in sweep, you can have multiple break criteria in one simulation. The break can be specified in a single device and in mixed mode.

Break Criteria: Conditionally Stopping the Simulation

## Global Contact Break Criteria

The limits for contact voltages and contact currents can be specified in the global `Math` section:

```
Math {
  BreakCriteria {
    Voltage (Contact = "drain" absval = 10)
    Current (Contact = "source" minval = -0.001 maxval = 0.002)
  }
  ...
}
```

In this example, the stopping criterion is met if the absolute value of the inner voltage at the drain exceeds 10 V. In addition, Sentaurus Device terminates the simulation if the source current is less than $-0.001 \text{ A/}\mu\text{m}$ or greater than $0.002 \text{ A/}\mu\text{m}$.

**NOTE** The unit depends on the device dimension. It is $\text{A/}\mu\text{m}^2$ for 1D, $\text{A/}\mu\text{m}$ for 2D, and A for 3D devices.

## Global Device Break Criteria

The device power is equal to $P = \sum_{k} I_k \cdot V_k$, where:

* $k$ is the index of a device contact.

* $I_k$ is the current.

* $V_k$ is the inner or outer voltage at this contact.

Examples of the device power criteria are:

```
Math {
  BreakCriteria { DevicePower( Absval=6e-5) }
  BreakCriteria { OuterDevicePower( Absval=6e-5) }
  BreakCriteria { InnerDevicePower( Absval=2e-6) }
  ...
}
```

The keywords `DevicePower` and `OuterDevicePower` are synonyms. In this example, the stopping criterion is met if the absolute value of the outer power exceeds $6 \times 10^{-5} \text{ W/}\mu\text{m}$ or the inner power exceeds $2 \times 10^{-6} \text{ W/}\mu\text{m}$.

The break criteria for lattice temperature, current density, and electric field can be specified by region and material. If no region or material is given, the stopping criteria apply to all regions.

4: Performing Numeric Experiments

Break Criteria: Conditionally Stopping the Simulation

A sample specification is:

```
Math (material = "Silicon") {
  BreakCriteria {
    LatticeTemperature (maxval = 1000)
    CurrentDensity (maxval = 1e7)
  }
  ...
}
Math (region = "Region.1") {
  BreakCriteria {
    ElectricField (maxval = 1e6)
  }
  ...
}
```

Sentaurus Device terminates the simulation if the lattice temperature in silicon exceeds 1000 K, the current density in silicon exceeds 10<sup>7</sup> A/cm<sup>2</sup>, or the electrical field in the region Region.1 exceeds 10<sup>6</sup> V/cm.

An upper bound for the lattice temperature can also be specified in the Physics section. For example:

```
Physics {
  LatticeTemperatureLimit = 1693 # melting point of Si
  ...
}
```

**NOTE** The break criteria of the lattice temperature are only valid for nonisothermal simulations, that is, the keyword `Temperature` must appear in the corresponding `Solve` section.

---

# Sweep-Specific Break Criteria

Sweep-specific break criteria can be specified as an option of `Quasistationary`, `Transient`, and `Continuation`:

```
solve {
  Quasistationary(
    BreakCriteria {
      Current(Contact = "drain" AbsVal = 1e-8)
      DevicePower(Absval = 1e-5)
    }
    Goal { Name="drain" Voltage = 5 }
  )
  { coupled { poisson electron hole } }
}
```

Quasistationary Ramps

```
Quasistationary(
  BreakCriteria { CurrentDensity( AbsVal = 0.1) }
  Goal { Name = "gate" Voltage = 2 }
)
{ coupled { poisson electron hole } }
...
}
```

This example contains multiple break criteria. As soon as either the drain current or the device power exceeds the limit, Sentaurus Device stops the first Quasistationary computations and switches to the second Quasistationary. As soon as the current density exceeds its limit, Sentaurus Device exits this section and switches to the next section.

## Mixed-Mode Break Criteria

All the previously mentioned break criteria are also available in mixed mode. In this case, the BreakCriteria section must contain the circuit device name (an exception are voltage criteria on circuit nodes). Examples of the break criteria conditions in mixed mode are:

```
Quasistationary(
  BreakCriteria {
    # mixed-mode variables
    Voltage( Node = a MaxVal = 10)
    Current( DevName = resistor Node = b MinVal = -1e-5)

    # device variables
    Voltage(DevName = diode Contact = "anode" MaxVal=10)
    LatticeTemperature(DevName = mos MaxVal=1000)
    ElectricField(DevName = mos MaxVal=1e6)
    DevicePower(DevName = resistor AbsVal=1e-5)
  }
  ...
)
```

# Quasistationary Ramps

The Quasistationary command ramps a device from one solution to another through the modification of its boundary conditions (such as contact voltages) or parameter values.

The simulation continues by iterating between the modification of the boundary conditions or parameter values, and re-solving the device (see Figure 11 on page 75). The command to re-solve the device at each iteration is given with the Quasistationary command.

**4: Performing Numeric Experiments**

Quasistationary Ramps

Step boundary Re-solve device

Figure 11 Quasistationary ramp

# Ramping Boundary Conditions

To ramp boundary conditions, such as voltages on electrodes, the `Quasistationary` command is:

```
Quasistationary ( <parameter-list> ) { <solve-command> }
```

The possibilities for `<parameter-list>` are summarized in Table 342 on page 1633. `<solve-command>` is `Coupled`, `Plugin`, `ACCoupled`, `HBCoupled`, or possibly another `Quasistationary`.

For example, ramping a drain voltage of a device to 5 V is performed by:

```
Quasistationary( Goal {Voltage=5 Name=Drain } ){
  Coupled { Poisson Electron Hole }
}
```

Internally, the `Quasistationary` command works by ramping a variable $t$ from 0.0 to 1.0. The voltage at the contact changes according to the formula $V = V_0 + t(V_1 - V_0)$, where $V_0$ is the initial voltage and $V_1$ is the final voltage, which is specified in the `Goal` statement.

Control of the stepping is expressed in terms of the $t$ variable. The control is not made over contact values because more than one contact can be ramped simultaneously.

The step control parameters are `MaxStep`, `MinStep`, `InitialStep`, `Increment`, and `Decrement` in `<parameter-list>`:

* `MaxStep` and `MinStep` limit the step size.

* `InitialStep` controls the size of the first step of the ramping. The step size is automatically augmented or reduced depending on the rate of success of the inner solve command.

* The rate of increase is controlled by the number of performed Newton iterations and by the factor `Increment`.

Quasistationary Ramps

* The step size is reduced by the factor `Decrement`, when the inner solve fails. The ramping process terminates when the step becomes smaller than `MinStep`.

* If the dynamic nonlocal path band-to-band model is activated, the `NonlocalPath` section can be included (see Handling Derivatives on page 481).

Each contact has a type, which can be voltage, current, or charge. Each `Quasistationary` command has a goal, which can also be voltage, current, or charge. If the goal and contact type do not match, Sentaurus Device changes the contact type to match the goal. However, Sentaurus Device cannot change a contact of charge type to current type, or a contact of current type to charge type.

Contacts in the `Goal` section of each `Quasistationary` can be specified alternatively by a user-defined regular expression instead of a well-defined name. In this case, all the matching valid contacts in the `Electrode` section will be ramped.

For example, the following statement will ramp all contacts named `d1` ... `d9` to 5 V:

```
Quasistationary( Goal {Voltage=5 Name=Regexp("d[1-9]") } ){
  Coupled { Poisson Electron Hole }
}
```

For details about the matching process, see Specifying Electrical Boundary Conditions on page 67.

The initial value (for $t = 0$) is the current or voltage computed for the contact before the `Quasistationary` command starts. Contacts keep their boundary condition type after the `Quasistationary` command finishes. To change the boundary condition type of a contact explicitly, use the `Set` command (see Changing Boundary Condition Type During Simulation on page 68).

If all equations to be solved in a `Quasistationary` also have been solved in the `solve` statement immediately before, Sentaurus Device omits the point $t = 0$, as the solution is already known. Otherwise, this point is computed at the beginning of the `Quasistationary`. You can explicitly force or prevent this point from being computed using `DoZero` or `-DoZero` in the `<parameter-list>`.

## Ramping Quasi-Fermi Potentials in Doping Wells

Electron and hole quasi-Fermi potentials in specified doping wells can also be ramped in a `Quasistationary` statement. This is a quick and robust way to deplete doping wells without having to solve the continuity equation for the carrier to be depleted. Its main application is in CMOS image sensor simulations and charge-coupled device simulations.

4: Performing Numeric Experiments

Quasistationary Ramps

To ramp a quasi-Fermi potential, specify the keyword `WellContactName` or `DopingWell` followed by `eQuasiFermi` or `hQuasiFermi` in the `Goal` section of the `Quasistationary` command:

```
Goal { [ WellContactName=<contact_name> | DopingWell(<point_coordinates>)]
  [eQuasiFermi=<float> | hQuasiFermi=<float>] }
```

The `DopingWell` specification is more general and can be used for both semiconductor wells with or without contacts (buried wells). In this case, the coordinates of a point in the well must be given to select the well (see code above).

When the semiconductor well where the quasi-Fermi potential is ramped is connected to a contact, the `WellContactName` specification can be used. Now, the contact associated with the well must be specified to select the well (see code above).

The starting value of the `Goal` for the quasi-Fermi potential ramping in the specified well is taken as the well averaged value of the quasi-Fermi potential at the end of the previous `Quasistationary` command. This starting value can be changed using a `Set` statement:

```
Solve {
  Set(DopingWell(0.5 0.5) eQuasiFermi=5.0)
  Quasistationary(... Goal {DopingWell(0.5 0.5) eQuasiFermi=10.0})
   ) {Coupled {poisson hole}}
}
```

The `Set` statement has the same options and syntax as the `Goal` statement above.

In mixed-mode simulations, the feature still can be used for each device separately. In this case, the keywords `DopingWell` and `WellContactName` must be prefixed by the device name:

```
System {
  MOSCAP1 "mc1" (
   "gate_contact" = gate1
   "substrate_contact" = sub
  )
  ...
}

Solve {
  Set(mc1.DopingWell(0.5 0.5) eQuasiFermi=5.0)
  Quasistationary(...
   Goal {mc1.DopingWell(0.5 0.5) eQuasiFermi=10.0}
  ) {Coupled {poisson hole circuit}}
}
```

Quasistationary Ramps

In addition, Sentaurus Device supports multiple-well ramping, activated by the keyword `DopingWells` with an option in parentheses. The syntax is:

```
Quasistationary(...
  Goal {DopingWells([Region=<region> | Material=<material> | Semiconductor])
    eQuasiFermi=<float>}
) {Coupled {poisson hole}}
```

As can be seen from this syntax description, wells in a region, wells having the same material, or all semiconductor wells in the device can be ramped to a specified value of the electron or hole quasi-Fermi potential. A well is considered to be in a region if it has one or more vertices in common with the region. A well belongs to a region even if it is not entirely in the region.

For multiple-well ramping, the `Set` command is used to change the quasi-Fermi potential in a group of wells before a `Quasistationary` ramping:

```
Set(DopingWells([Region=<region> | Material=<material> | Semiconductor])
  eQuasiFermi=5.0)
```

In the case of mixed-mode simulations, `DopingWells` must be prefixed with the device instance name and a "." similar to single-well syntax.

You can set the quasi-Fermi potential in a user-defined window as follows:

```
Set (DopingWells [(x y z) (x1 y1 z1) (x2 y2 z2)] eQuasiFermi=5.0)
```

The vector (x y z) is used to locate the doping well to be modified. The other two vectors (x1 y1 z1) and (x2 y2 z2) are the corners of the user-defined window. Only the overlapping area between the selected doping region and the user-defined window will have the quasi-Fermi value defined in the command file.

Furthermore, instead of using the vector (x y z) to locate the doping well, you can use the region name, material name, or material group name to locate the doping well. For example:

```
Set (DopingWells [<region> | <material> | <Semiconductor> (x1 y1 z1) (x2 y2 z2)]
  eQuasiFermi=5.0)
```

With this syntax, the overlapping area between the selected region, material, or semiconductor and the user-defined window will have the quasi-Fermi value defined in the command file.

Electron and hole quasi-Fermi potentials can be simultaneously ramped using multiple `Goal` statements and solving for the Poisson equation only.

When the continuity equation has been solved for a carrier whose quasi-Fermi potential is to be ramped, the initial value of the quasi-Fermi potential for all vertices in the well is computed from the carrier density in the point specified when the well was defined. For multiple-well ramping, the same scheme applies well-wise.

**4: Performing Numeric Experiments**
Quasistationary Ramps

# Ramping Physical Parameter Values

A `Quasistationary` command allows parameters from the parameter file of Sentaurus Device to be ramped. The `Goal` statement has the form:

```
Goal { [ Device = <device> ]
  [ Material = <material> | MaterialInterface = <interface> |
    Region = <region> | RegionInterface = <interface> ]
  Model = <model> Parameter = <parameter> Value = <value> }
```

Specifying the device and location (material, material interface, region, or region interface) is optional. However, the model name and parameter name must always be specified.

A list of model names and parameter names is obtained by using:

```
sdevice --parameter-names
```

This list of parameters corresponds to those in the Sentaurus Device parameter file, which can be obtained by using `sdevice -P` (see Generating a Copy of Parameter File on page 32).

The following command produces a list of model names and parameter names that can be ramped in the command file:

```
sdevice --parameter-names <command_file>
```

Sentaurus Device reads the devices in the command file and reports all parameter names that can be ramped. However, no simulation is performed. The models in Table 17 contain command file parameters that can be ramped.

Table 17 Command file parameters

| Model name | Parameters |
| --- | --- |
| DeviceTemperature | Temperature |
| GalvanicTransport | MagneticFieldx, MagneticFieldy, MagneticFieldz |
| Optics | Wavelength, Intensity, Theta, Phi, Polarization |
| PEPolarization | activation |
| RadiationBeam | Dose, DoseRate, DoseTSigma, DoseTime_end, DoseTime_start |
| Strain | StrainXX, StrainXY, StrainXZ, StrainYY, StrainYZ, StrainZZ |
| Stress | StressXX, StressXY, StressXZ, StressYY, StressYZ, StressZZ |
| Traps(<index>) | Conc, EnergyMid, EnergySig, eGfactor, eJfactor, eXsection, hGfactor, hJfactor, hXsection |

Quasistationary Ramps

**NOTE** Certain models such as traps must be specified with an index. For example:

```
Model="Traps(1)"
```

The index denotes the exact model for which a parameter should be ramped. Usually, Sentaurus Device assigns an increasing index starting with zero for each optical beam, trap, and so on. However, the situation becomes more complex if material and region specifications are present. To confirm the value of the index, using the following command is recommended:

```
sdevice --parameter-names <command file>
```

Mole fraction–dependent parameters can be ramped. For example, if the parameter p is mole fraction–dependent, the parameter names listed in Table 18 can appear in a `Goal` statement.

Table 18 Mole fraction–dependent parameters as Quasistationary Goals

| Parameter in Goal statement | Description |
| --- | --- |
| Parameter=p | Parameter p in non-mole fraction–dependent materials. |
| Parameter="p(0)" Parameter="p(1)" ... | Interpolation value of p at Xmax(0), Xmax(1), ... |
| Parameter="B(p(1))" Parameter="C(p(1))" Parameter="B(p(2))" Parameter="C(p(2))" ... | Quadratic and cubic interpolation coefficients of p in intervals [Xmax(0), Xmax(1)], [Xmax(1), Xmax(2)], ... |

Mole fraction–dependent parameters can be ramped in all materials. In mole fraction–dependent materials, interpolation values p(...) and interpolation coefficients B(p(...)) and C(p(...)) must be ramped. In a non-mole fraction–dependent material, only the parameter p can be ramped.

If a parameter is not found, then Sentaurus Device issues a warning, and the corresponding goal statement is ignored.

Parameters in PMI models can also be ramped.

To ramp optical parameters, see Parameter Ramping on page 635.

# Quasistationary in Mixed Mode

The `Quasistationary` statement is extended in mixed mode to include goals on nodes and circuit model parameters. Table 337 on page 1629 shows the syntax of these goals.

4: Performing Numeric Experiments

Quasistationary Ramps

The goal is usually used on a node that has been fixed with the `Set` or `Initialize` statement in the `System` section. The statement `Goal{Node=<string> Voltage=<float>}` assigns a new target voltage to a specified node. For example, the node `a` is set to 1 V and ramped to 10 V:

```
System {
  Resistor_pset r1(a 0){resistance = 1}
  Set(a=1)
}

Solve {
  Circuit
  Quasistationary( Goal{Node=a Voltage=10} ){ Circuit }
}
```

A goal on circuit model parameters can be used to change the configuration of a system. The statement `Goal{Parameter=<i-name>.<p-name> value=<float>}` assigns a new target value to a specified parameter `p-name` of a device instance `i-name`. Any circuit model parameter can be changed.

For example, the resistor `r1` is ramped from 1 $\Omega$ to 0.1 $\Omega$, and the offset of the sine voltage source is ramped to 1.5 V:

```
System {
  Resistor_pset r1(a 0){resistance = 1}
  Vsource_pset v0 (n1 n0) { sine = (0.5 1 10 0 0 0) }
  Set(a=1)
}

Solve {
  Circuit
  Quasistationary(
    Goal { Parameter = r1."resistance" Value = 0.1 }
    Goal { Parameter = v0."sine[0]"      Value = 1.5 })
    { Circuit }
}
```

**NOTE** When a node is used in a goal, it is set during the quasistationary simulation. At the end of the ramp, the node reverts to its previous *set* status, that is, if it was not set before, it is not set afterward. This can cause unexpected behavior in the `Solve` statement following the `Quasistationary` statement. Therefore, it is better to set the node in the `Quasistationary` statement using the `Set` command.

**4: Performing Numeric Experiments**

Quasistationary Ramps

# Saving and Plotting During a Quasistationary

Data can be saved and plotted during a Quasistationary ramping process by using the `Plot` command. `Plot` is placed with the other `Quasistationary` parameters. For example:

```
Quasistationary(
  Goal {Voltage=5 Name=Drain}
  Plot {Range = (0 1) Intervals=5})
  {Coupled{ Poisson Electron Hole }}
```

In this example, six plot files are saved at five intervals: $t = 0, 0.2, 0.4, 0.6, 0.8$, and $1.0$.

Data can also be saved and plotted when a specific step has passed since last save by using the keyword `MinSpacing` in the `Plot` command. For example:

```
Quasistationary(
  Goal {Voltage=5 Name=Drain}
  Plot {Range = (0 1) MinSpacing=0.2}
)
{Coupled{ Poisson Electron Hole }}
```

In this example, no extra intervals are added into the simulation. Within the range `(0 1)`, those ramping points that are $0.2$ larger than the last saved point are plotted and saved. After `MinSpacing` is defined in the command file, other plot commands will be ignored.

Another way to plot data is with `Plot` in the `Quasistationary` body rather than inside the `Quasistationary` parameters (see When to Plot on page 129). `Plot` is added after the equations to solve, such as:

```
Quasistationary( Goal {Voltage=5 Name=Drain } ){
  Coupled { Poisson Electron Hole }
  Plot ( Time= ( 0.2; 0.4; 0.6; 0.8; 1.0 ) NoOverwrite )
}
```

# Extrapolation

The `Quasistationary` command can use extrapolation to predict the next solution based on the values of the previous solutions. Extrapolation can be switched off (default) or on globally in the `Math` section:

```
Math { -Extrapolate }   # default
```

or:

```
Math { Extrapolate }
```

4: Performing Numeric Experiments

Quasistationary Ramps

Alternatively, you can switch it off or on for a specific `Quasistationary` command only:

```
Quasistationary (
  Goal { ... }
  -Extrapolate
) { Coupled { Poisson Electron Hole } }
```

Sentaurus Device can use extrapolation in the following cases: inside a `Quasistationary` command and between `Quasistationary` commands.

## Inside a Quasistationary Command

The initial guess for a given step is obtained by extrapolation from the solutions of the previous steps (if they exist).

## Between Quasistationary Commands

The extrapolation information is preserved between `Quasistationary` commands, and it also is saved and loaded automatically by the `Save` and `Load` commands. A subsequent `Quasistationary` command uses this extrapolation information if the following conditions are met:

1. The previous and current `Quasistationary` commands have the same number of goals.

2. The previous and current `Quasistationary` commands ramp the same quantities.

3. The previous and current `Quasistationary` commands are contiguous, that is, for all goals, the current initial value is equal to the goal value in the previous command.

4. Multiple goals are ramped at the same rate in the current `Quasistationary` command compared to the previous `Quasistationary` command. As an example, assume that all contact voltages have zero initial values. Then, the following two `Quasistationary` commands satisfy this condition:

```
Quasistationary (
  Goal { Name = "gate"  Voltage = 1 }
  Goal { Name = "drain" Voltage = 2 }
) { Coupled { Poisson Electron Hole } }

Quasistationary (
  Goal { Name = "gate"  Voltage = 3 }
  Goal { Name = "drain" Voltage = 6 }
) { Coupled { Poisson Electron Hole } }
```

On the other hand, the following two `Quasistationary` commands violate this condition:

```
Quasistationary (
  Goal { Name = "gate"  Voltage = 1 }
  Goal { Name = "drain" Voltage = 2 }
```

Quasistationary Ramps

```
) { Coupled { Poisson Electron Hole } }

Quasistationary (
    Goal { Name = "gate"  Voltage = 3 }
    Goal { Name = "drain" Voltage = 10 }
) { Coupled { Poisson Electron Hole } }
```

In the second `Quasistationary` command, the drain voltage is ramped at a higher rate than the gate voltage. Therefore, the extrapolation information from the previous `Quasistationary` command cannot be used.

5. The values of the solution variables have not changed between the two `Quasistationary` commands, for example, by a `Load` command.

If the extrapolation information from a previous `Quasistationary` command can be used successfully, the following message appears in the log file:

```
Reusing extrapolation from a previous quasistationary
```

The options in Table 19 control the handling of extrapolation information between `Quasistationary` commands.

Table 19 Extrapolation options

| Option | Description |
| --- | --- |
| ReadExtrapolation | Tries to use the extrapolation information from a previous command if it is available and compatible. This is the default. |
| -ReadExtrapolation | Do not use the extrapolation information from a previous command. |
| StoreExtrapolation | Stores the extrapolation information internally at the end of the command, so that it will be available for a subsequent command, or can be written to a save or plot file. This is the default. |
| -StoreExtrapolation | Do not store the extrapolation information internally at the end of the command. |

## Parameters of the Extrapolate Statement

### Order Extrapolation

By default, Sentaurus Device uses linear extrapolation, but you can request a higher order extrapolation. For example, to specify quadratic extrapolation, use:

```
Extrapolate (Order = 2)
```

### Exclude Equations

By default, Sentaurus Device uses extrapolation for all equations from a `Coupled` command, but you can exclude some equations from this list.

4: Performing Numeric Experiments

Quasistationary Ramps

For example, to extrapolate only for the Electron equation with second-order extrapolation, use:

```
Quasistationary (
  Goal { Name = "gate" Voltage = 3 }
  Extrapolate(Order=2 Exclude(Poisson Hole))
) { Coupled { Poisson Electron Hole } }
```

## Low Density Limit

If the electron or hole concentration has small values in some vertices, extrapolation in these vertices might be the reason for convergence problems. You can define a low limit for these concentrations starting from which Sentaurus Device will extrapolate the corresponding density.

For example, to extrapolate the carrier density only in vertices in which the corresponding concentration is more than 1e+08, use:

```
Quasistationary (
  Goal { Name = "gate" Voltage = 3 }
  Extrapolate(LowDensityLimit = 1e+8)
) { Coupled { Poisson Electron Hole } }
```

## Minimum Step of Extrapolation

The `Quasistationary` or `Transient` commands contain the options `Initialstep`, `Increment`, `Decrement`, `Maxstep`, and `Minstep`. Sentaurus Device uses the following iterative procedure.

**Procedure 1:**

a) An initial guess for the given step (t2=t1+step) is obtained by extrapolation from the solutions of the previous steps (that is, it is dependent on t0, t1, and step).

b) Sentaurus Device uses the Newton iterative method to obtain the solution for t=t2.

c) **IF** this iterative process converges, **THEN** t0=t1, t1=t2, and step=NewStep (there is a special algorithm for computing NewStep). **GOTO a)**.

d) **ELSE** step=step/Decrement, **IF** step > Minstep (it is a `Quasistationary` parameter). **GOTO a)**.

e) **ELSE** (that is, step < Minstep) **Procedure 1** has not converged. In this case, Sentaurus Device exits from the `Quasistationary` or `Transient` commands.

Sometimes, for small steps, **Procedure 1** has better convergence without extrapolation. For this case, the `Extrapolate` statement has the `MinStep` parameter, which is the minimum step of the extrapolation (default value is 0).

Quasistationary Ramps

### For example:

```
Quasistationary (
   Minstep = 1e-8                    # it is Quasistationary minimum step
   Extrapolate(MinStep = 1e-5)       # it is Extrapolate minimum step
   Goal { Name = "gate" Voltage = 3 }
) { Coupled { Poisson Electron Hole } }
```

Therefore, item a) of **Procedure 1** changes to the following:

### Algorithm=1

a0) **IF** step > Extrapolate.MinStep(1e-5), **THEN** an initial guess for the given step (t2=t1+step) is obtained by extrapolation from the solutions of the previous steps.

a1) **ELSE IF** step > Quasistationary.Minstep(1e-8), **THEN** Sentaurus Device uses the current solution (not extrapolated) as the initial guess.

a2) **ELSE GOTO e)**.

**NOTE** If Extrapolate.MinStep is greater than Quasistationary.Maxstep, then Sentaurus Device does not use extrapolation, that is, this is equivalent to using the Quasistationary command without the Extrapolate statement.

### Number of Failed Extrapolations

In addition to, or as an alternative to MinStep, Sentaurus Device can use the number of successive failures to switch off extrapolation and to use the current solution as the initial guess.

### For example:

```
Extrapolate( NumberOfFailures = 2 )
```

In this case, after **two consecutive** failures with extrapolation, Sentaurus Device uses the current solution (not extrapolated) as the initial guess.

### Switch Algorithm

For example:

```
Extrapolate( MinStep=1e-5 NumberOfFailures=2 Algorithm=<1 | 2> )
```

The default is Algorithm=1, which means **Procedure 1** is used. That is, if Step < MinStep or the number of consecutive failures $\ge$ NumberOfFailures, then Sentaurus Device uses **only** the current solution (not extrapolated) as the initial guess.

**4: Performing Numeric Experiments**

Continuation Command

If `Algorithm=2`, then Sentaurus Device uses extrapolation in any case. **Only if it fails** does Sentaurus Device switch to the not extrapolated solution as the initial guess.

# Continuation Command

The `Continuation` command enables automated tracing of arbitrarily shaped I–V curves. This capability is particularly useful for tracing I–V curves associated with complicated device phenomena such as breakdown or latchup, which can be multivalued with abrupt changes.

The implementation is based on a dynamic load-line technique [2] adapting the boundary conditions along the I–V curve to ensure convergence. The boundary condition consists of an external voltage applied to the end of a variable load resistor connected to the device electrode for which the I–V curve is traced. The program calculates an optimal boundary condition at each point along the I–V curve by adjusting the load line so it is orthogonal to the local tangent of the I–V curve.

The continuation method is activated by specifying the keyword `Continuation` in the `Solve` section. Control parameters that define the setup must be given in parentheses that follow the `Continuation` keyword. For example:

```
Solve {
  Continuation (<Control Parameters>) {
    Coupled { poisson electron hole }
  }
}
```

Table 333 on page 1625 summarizes the control parameters of the `Continuation` command. The method works with both single-device and mixed-mode setups, with only one electrode undergoing continuation at a time.

## Continuation Control Parameters

> **NOTE** Specifying the `NewArc` option will invoke several features that improve the robustness of the method for most applications. If you do not specify this option, the original continuation algorithm will be used by default.

The first step of a continuation simulation is always a voltage-controlled step specified with the `InitialVstep` parameter. After this step, the I–V curve tracing proceeds automatically until the current or voltage at the continuation electrode advances outside of a user-defined continuation window specified with the parameters `MinVoltage`, `MaxVoltage`, `MinCurrent`, and `MaxCurrent`.

Continuation Command

For example:

```
Solve { ...
  Continuation (
    NewArc
    Name="collector" InitialVstep=0.1
    MinVoltage=0 MaxVoltage=10
    MinCurrent=0 MaxCurrent=1e-3
  )
  { Coupled { poisson electron hole } }
}
```

This code block specifies that the I–V curve must be traced at the collector electrode, the initial voltage-controlled step is 0.1 V, the voltage range is 0 V to 10 V, and the current range is 0 A to 1 mA.

The step size along the I–V curve is controlled primarily by the convergence of the simulation. The step size increases by a factor `Increment` (default is 1.5) if a solution converges, and it decreases by a factor `Decrement` (default is 2.0) if it does not converge.

You can limit the step size by specifying the parameters `MaxVstep`, `MaxIstep`, and `MaxIfactor`. These parameters limit the projections $\Delta V$ and $\Delta I$ calculated by Sentaurus Device from one point along the I–V curve to the next. The actual maximum spacing between successive points might differ slightly from these limits. The parameters `MaxVstep` and `MaxIstep` represent the maximum voltage and current steps, respectively, while `MaxIfactor` represents the maximum factor that the current is allowed to increase in one step.

During continuation, Sentaurus Device automatically calculates an optimal value for the load resistance that is attached to the continuation electrode. Limits for the calculated resistance can be specified using the `MinRload` and `MaxRload` parameters.

Tracing an I–V curve successfully with the continuation method depends on how accurately the local slope of the traced I–V curve is computed. At low biases, the current at the continuation electrode can be small and noisy. This can result in an inaccurate computation of the slope, which can sometimes cause the continuation method to backtrace. In such cases, it might be necessary to specify the parameter `Vadapt`, or `Iadapt`, or both that represent the minimum voltage and the current, respectively, that must be reached before the adaptive algorithm is switched on. From `MinVoltage` to `Vadapt` and from `MinCurrent` to `Iadapt`, the adaptive algorithm is switched off and the simulation proceeds as a simple voltage ramping through a fixed-value resistor attached to the continuation electrode. The default value for the fixed resistor is 0.001 $\Omega$ and can be changed using the `Rfixed` parameter.

4: Performing Numeric Experiments

Continuation Command

# Continuation in Mixed Mode

The continuation method can be used in mixed-mode simulations; however, the continuation contact must not be connected to any circuit node. When using continuation in mixed mode, the device instance must be prefixed to the `Name` parameter.

In the following example, consider a device with the identifier `mos1`, with electrodes named source, drain, gate, and substrate. The device instance for `mos1` (given in the `System` section) is `d1`. If drain should be used as the continuation electrode, no circuit connection should be made to it in the connectivity list, and it must be identified using `d1.Name` in the `Continuation` section:

```
Device mos1 {
  Electrode {
    {Name="source" Voltage=0.0}
    {Name="drain" Voltage=0.0}
    {Name="gate" Voltage=0.0}
    {Name="substrate" Voltage=0.0}
  }
  ...
}

System {
  mos1 d1 (source=s1 gate=g1 substrate=s1)
  set (s1=0 g1=0 b1=0)
}

Solve {
  ...
  Continuation(
    d1.Name="drain"
    ...
  ) {Coupled {Poisson Electron Hole}}
}
```

To bias a mixed-mode continuation electrode before `Continuation`, you can use a `Quasistationary` ramp. However, the electrode must be identified using the `Contact` keyword instead of `Name` to avoid biasing the contact as a circuit node. For example:

```
Quasistationary (
  InitialStep=1e-3
  ...
  Goal {Contact=d1."drain" Voltage=3}
) {Coupled {Poisson Electron Hole}}
```

4: Performing Numeric Experiments

Transient Command

# Transient Command

The Transient command is used to perform a transient time simulation. The command must start with a device that has already been solved. The simulation continues by iterating between incrementing time and re-solving the device (see Figure 12). The command to solve the device at each iteration is given with the Transient command.

Transient simulation flowchart showing a loop between "Increment time" and "Re-solve device"

Figure 12 Transient simulation

The syntax of the Transient command is:

```
Transient ( <parameter-list> ) { <solve-command> }
```

Table 346 on page 1635 lists the possible parameters and `<solve-command>` is Coupled or Plugin.

An example of performing a transient simulation for 10 μs is:

```
Transient( InitialTime = 0.0 FinalTime=1.0e-5 ){
    Coupled { Poisson Electron Hole }
}
```

The Transient command allows you to overwrite time-step control parameters, which have default values or are globally defined in the Math section. The error control parameters that are accepted by the Transient command are listed in Table 213 on page 1538.

The parameters TransientError, TransientErrRef, and TransientDigits control the error over the transient integration method. This differs from the error control for the Coupled statement, which only controls the error of each nonlinear solution. As with the error parameters for the Coupled statement, the transient error controls can be both absolute and relative. Absolute values are parameterized according to equation–variable type.

The plot controls of the Transient command are the same as for the Quasistationary command, except the $t$ is the real time (in seconds), and is not restricted to an interval from 0 to 1.

Plot can be given as a Transient parameter. For example:

```
Transient( InitialTime = 0.0 FinalTime = 1.0e-5
    Plot { Range = (0 3.0e-6) Intervals=3 } )
    { Coupled { Poisson Electron Hole } }
```

Transient Command

This example saves four plot files at t = 0.0, 1.0e–6, 2.0e–6, and 3.0e–6.

Similar to the Quasistationary simulation, data can also be saved and plotted when a specific step has passed since the last save by using the keyword `MinSpacing` in the `Plot` command. For example:

```
Transient(
  InitialTime = 0.0 FinalTime = 1.0e-5
  Plot { Range = (0 3.0e-6) MinSpacing= 2.0e-5 }
)
{ Coupled { Poisson Electron Hole } }
```

In this example, no extra intervals are added into the simulation. Within the range (0 3.0e-6), those ramping points that are 2.0e-5 larger than the last saved point are plotted and saved. After `MinSpacing` is defined in the command file, other plot commands will be ignored.

Alternatively, `Plot` can be put into the `Transient` solve command (see When to Plot on page 129):

```
Transient( InitialTime = 0.0 FinalTime = 1.0e-5 )
  { Coupled{ Poisson Electron Hole }
  Plot ( Time=( 1.0e-6; 2.0e-6; 3.0e-6 ) NoOverwrite )
}
```

# Numeric Control of Transient Analysis

You can control transient simulations by using a set of keywords available in the `Math` section and the options of `Transient` statements in the `Solve` section. Sentaurus Device uses implicit discretization of nonstationary equations and supports two discretization schemes: the trapezoidal rule/backward differentiation formula (TRBDF), which is the default, and the simpler backward Euler (BE) method. To select a particular transient method, specify `Transient=<transient-method>`, where `<transient-method>` can be `TRBDF` or `BE`.

In transient simulations, in addition to numeric errors of the nonlinear equations, discretization errors due to the finite time-step occur (see Transient Simulation on page 1155). By default, Sentaurus Device does not control the time step to limit this discretization error (that is, that time step depends only on convergence of Newton iterations).

To activate time-step control, `CheckTransientError` must be specified. For time-step control, Sentaurus Device uses a separate set of criteria, but as with Newton iterations, the control of both relative and absolute errors is performed.

The relative transient error $\epsilon_{R,tr}$ is defined similarly to $\epsilon_R$ in Eq. 32, p. 144:

$$ \epsilon_{R,tr} = 10^{-TransientDigits} \text{ (14)} $$

Transient Command

Similarly, for $x_{\text{ref,tr}}$ and $\varepsilon_{\text{A,tr}}$, the equation:

$$x_{\text{ref,tr}} = \frac{\varepsilon_{\text{A,tr}}}{\varepsilon_{\text{R,tr}}}x^* \tag{15}$$

is valid. The keyword `TransientDigits` must be used to specify relative error $\varepsilon_{\text{R,tr}}$ in transient simulations. An absolute error in time-step control can be specified by either the keyword `TransientError` ($\varepsilon_{\text{A,tr}}$) or `TransientErrRef` ($x_{\text{ref,tr}}$), and their values can be defined independently for each equation variable. The same flag as in Newton iteration control, `RelErrControl`, is used to switch to unscaled (`TransientErrRef`) absolute error specification.

For simulations with floating gates, Sentaurus Device can monitor the errors in the floating-gate charges as well. For details, see Floating Gates on page 1158.

**NOTE** All transient parameters in the `Math` section, except `Transient`, can be overwritten in the `Transient` command of the `Solve` section (see Transient Command on page 90).

The `Transient` command uses time-dependent boundary conditions (see Specifying Electrical Boundary Conditions on page 67) and correspondingly updates the quasi-Fermi potentials in doping wells. This might interfere with previously ramped ones in the `Quasistationary` command (see Ramping Quasi-Fermi Potentials in Doping Wells on page 76). This is critical for a `Poisson`-only solution. To avoid this, use `-UpdateQFPinTransientPoisson` in the `Math` section.

## Time-Stepping

A transient simulation computes the status of the system or device as a function of time for a finite time range, specified by `InitialTime` and `FinalTime`, by advancing from a status at a given time to the status at a later time point. The time step is chosen dynamically. The time step is bounded by `MinStep` and `MaxStep` from below and above, respectively; while `InitialStep` specifies the first time step at start time.

If the computation of the system status for a given time step fails, the time step is reduced iteratively until either the system status can be computed successfully or the minimum time step is reached. In the later case, the `Transient` terminates with an error. The factor by which a step is reduced can be set with the `Decrement` keyword.

After a successful computation of the system status, the time step is typically increased, depending on the computational effort for the actual time step. The maximum factor by which a step is increased can be controlled with the `Increment` keyword.

**4: Performing Numeric Experiments**

Transient Command

The effective time step can be smaller than the advancing time step, for example, if time points are specified for plotting, where a system status must be computed. However, these effective time steps do not reduce the advancing time step, that is, the subsequent effective time step might be as large as the advancing time step. You can bound (from above) the advancing time step at certain conditions by specifying turning points as a parameter in the `Transient`.

These conditions can be a list of arbitrary time points or time ranges (see Table 346 on page 1635). For example:

```
Transient ( ...
  TurningPoints (
    ( Condition ( Time ( 1.e-7 ; 2.e-7 ; 3.e-7 ) ) Value = 1.1e-9 )
    ( Condition ( Time ( Range = (1.e-7 2.e-7 ) ) ) Value = 2.1e-9 )
    ( Condition ( Time ( 1.23e-7 ; 1.45e-7 ; 1.67.e-7 ) ) Value = 1.0e-10 )
  )
)
```

The advancing time step is limited by the specified `Value` (in seconds) for the corresponding `Condition`. Here, the first condition limits the value for a list of time points. The second condition limits the time step for a whole range. If within a time range (where you have specified a maximum time step, like the second condition in this example) and you want to output results at specific time points within that range, simply specify these in another `Condition` statement (third statement in the example), ensuring that you set a `Value` that is less than the `Value` set for the `Range` in which the time points fall.

Observe that, for time points, the computation of the transient is triggered; while for `Range`, this is not the case. `Time` takes the same options as the `Time` keyword in `Plot` in `Solve`. The specification:

```
TurningPoints ( ... (1.e-9 1.e-10) )
```

serves as shorthand for a single time-point condition:

```
TurningPoints ( ... ( Condition ( Time ( 1.e-9 ) ) Value = 1.e-10 ) )
```

> **NOTE** Turning points related to optical simulations, specified using the unified interface for optical generation computation (see Chapter 21 on page 593), are described in Optical Turning Points on page 612.

In the off-state of a device, the displacement current might not be resolved due to numeric precision if the time step is too small, which leads to a spiky current. In this case, you can define:

```
TurningPoints ( Condition=(...) Value=<float> Factor=<int> )
```

Transient Command

The parameter `Factor` controls the criterion `max_currentValue < Factor`x`eps`, where `eps` represents the numeric limit for the precision in use, and `max_current` is the maximum terminal current of that device.

Sentaurus Device detects whether `Value` is too small to resolve the result, based on this criterion. If so, it prints a warning message and resets the time step to a more reasonable value.

By default, `Factor=0`. To solve a spiky current, set `Factor` to a positive value, for example, `Factor=10`.

***

## Ramping Physical Parameter Values

A `Transient` command allows parameters from the parameter file of Sentaurus Device to be ramped linearly.

The `Bias` statement (similar to the `Goal` subsection in a `Quasistationary` command; see Ramping Physical Parameter Values on page 79) has the form:

```
Bias { [ Device = <device> ]
    [ Material = <material> | MaterialInterface = <interface> |
    Region = <region> | RegionInterface = <interface> ]
    Model = <model> Parameter = <parameter> Value = <value_list>
}
```

Specifying the device and location (material, material interface, region, or region interface) is optional. However, the model name and parameter name must always be specified. For example:

```
Transient (
    InitialTime = 0 FinalTime = 1
    Bias( Material = "Silicon"
        Model = DeviceTemperature Parameter = "Temperature"
        Value = (300 at 0.1, 400 at 0.2, 450 at 0.5)
    )
    Bias( Region = "Channel"
        Model = DeviceTemperature Parameter = "Temperature"
        Value = (550 at 0.6, 400 at 0.8, 300 at 0.9)
    )
) { Coupled { Poisson Electron Hole } }
```

For a list of parameters that can be ramped in a `Transient` command, see Ramping Physical Parameter Values on page 79.

4: Performing Numeric Experiments

Transient Command

# Extrapolation

The `Transient` command can use the extrapolation from the solutions of the previous steps to predict the next solution. Extrapolation can be switched off (default) or on globally in the `Math` section:

```
Math { Extrapolate }
```

Alternatively, you can switch it off or on for a specific `Transient` command only:

```
Transient (
  Goal { ... }
  -Extrapolate
) { Coupled { Poisson Electron Hole } }
```

Sentaurus Device can use extrapolation in the following cases: inside a `Transient` command and between `Transient` commands.

## Inside a Transient Command

The initial guess for a given step is obtained by extrapolation from the solutions of the previous steps (if they exist).

## Between Quasistationary Commands

This extrapolation information is preserved between `Transient` commands, and it is also saved and loaded automatically by the `Save` and `Load` commands.

A `Transient` command can use this extrapolation information between the two `Transient` commands, if the following conditions are met:

1. The previous and current `Transient` commands are contiguous, that is, the final time of the previous `Transient` is equal to the initial time of the current `Transient`.

2. The values of the solution variables have not changed between the two `Transient` commands, for example, by a `Load` command.

If the extrapolation information from a previous `Transient` command can be used successfully, the following message appears in the log file:

```
Reusing extrapolation from a previous transient
```

The options to control the handling of extrapolation information described in Table 19 on page 84 are available for `Transient` as well. See Parameters of the Extrapolate Statement on page 84.

Transient Ramps

# Transient Ramps

As an alternative, Sentaurus Device provides `Transient` command syntax very similar to the `Quasistationary` command. This `Transient` command simplifies switching from quasistationary simulations to slow transient ones with minimal user effort. Replacing a quasistationary simulation with a slow transient is particularly useful in modeling wide-bandgap semiconductor devices, devices with trap states, breakdown simulations, and in general where convergence can be improved by switching to transient.

The transient ramp is activated by a `Quasistationary`-like command where the `Quasistationary` keyword is replaced by `Transient` and two optional parameters `InitialTime` and `FinalTime` can be used to control the ramp rate:

```
Solve { ...
    Transient (
        InitialTime = 0
        FinalTime = 1
        InitialStep = 0.01
        MaxStep = 0.1
        MinStep = 0.001
        Goal {name="gate" Voltage=5.0}
        Goal {name="drain" Current=1e-8}
    ) { Coupled {...} }
}
```

The default value for `InitialTime` is 0 or the final simulation time from a previous transient ramp simulation. The `FinalTime` default value is `InitialTime` + 1 second.

When a quasistationary ramp is inserted between two transient ramps, the time for the transient ramp after the quasistationary will be reset to zero if `InitialTime` is not specified.

If the dynamic nonlocal path band-to-band model is activated, the `NonlocalPath` section can be included (see Handling Derivatives on page 481).

In the following example, the last transient will bias the contact `anode` from 3 V at t = 0 to 0 V at t = 2 s:

```
Solve { ...
    Transient (
        FinalTime = 2
        InitialStep = 0.01
        MaxStep = 0.1
        MinStep = 0.001
        Goal {name="anode" Voltage=2.0}
    ) { Coupled {...} }
}
```

**4: Performing Numeric Experiments**

Large-Signal Cyclic Analysis

```
Quasistationary(
  InitialStep = 0.01
  MaxStep = 0.1
  MinStep = 0.001
  Goal {name="anode" Voltage=3.0}
) { Coupled {...} }

Transient (
  FinalTime = 2
  InitialStep = 0.01
  MaxStep = 0.1
  MinStep = 0.001
  Goal {name="anode" Voltage=0.0}
) { Coupled {...} }
}
```

The electrode bias time dependency is computed internally for the electrodes specified in the `Goal` section, so no time-dependent bias specification is allowed in the `Electrode` section for those contacts. `InitialStep`, `MaxStep`, and `MinStep` are like those in the `Quasistationary` case represented on a 0 to 1 scale. Sentaurus Device converts them internally to a scale from `InitialTime` to `FinalTime`.

This feature supports voltage, current, or charge ramps. Therefore, in the `Goal` section, only voltage, current, and charge contacts are allowed.

# Large-Signal Cyclic Analysis

For high-speed and high-frequency operations, devices are often evaluated by cyclic biases. After a time, device variables change periodically. This cyclic-bias steady state <sup>[3]</sup> is a condition that occurs when all parameters of a simulated system return to the initial values after one cycle bias is applied.

In fact, such a cyclic steady state is reached by using standard transient simulation. However, this is not always effective, especially if some processes in the system have very long characteristic times in comparison with the period of the signal.

For example, deep traps usually have relatively long characteristic times. A suggested approach <sup>[4]</sup> allows for significant acceleration of the process of reaching a cyclic steady state solution. The approach is based on iterative correction of the initial guess at the beginning of each period of transient simulation, using previous initial guesses and focusing on reaching a cyclic steady state. This approach is implemented in Sentaurus Device. An alternative frequency-domain approach is harmonic balance (see Harmonic Balance on page 106).

Large-Signal Cyclic Analysis

## Description of Method

The original method [4] is summarized. Transient simulation starts from some initial guess. A few periods of transient simulation are performed and, after each period, the change over the period of each independent variable of the simulated system is estimated (that is, the potential at each vertex of all devices, electron and hole concentrations, carrier temperatures, and lattice temperature if hydrodynamic or thermodynamic models are selected, trap occupation probabilities for each trap type and occupation level, and circuit node potentials in the case of mixed-mode simulation).

If $x_n^{\text{I}}$ denotes the value of any variable in the beginning of the $n$-th period, and $x_n^{\text{F}}$ denotes the same value at the end of the period, the cyclic steady state is reached when:

$$ \Delta x_n = x_n^{\text{F}} - x_n^{\text{I}} \tag{16} $$

is equal to zero.

Considering linear extrapolation and that the goal is to achieve $\Delta x_{n+1} = 0$, the next initial guess can be estimated as:

$$ x_{n+1}^{\text{I}} = x_n^{\text{I}} - \gamma \frac{x_n^{\text{I}} - x_{n-1}^{\text{I}}}{\Delta x_n - \Delta x_{n-1}} \Delta x_n \tag{17} $$

where $\gamma$ is a user-defined relaxation factor to stabilize convergence.

As Eq. 17 contains uncertainty such as 0/0, especially when $\Delta x$ is close to zero (when the solution is close to the steady state), special precautions are necessary to provide robustness of the algorithm.

Consider the derivation of Eq. 17 in a different fashion – near the cyclic steady state. If such a steady state exists, the initial guess $y = x^{\text{I}}$ is expected to behave with time as $y = a \exp(-\alpha t) + b$, where $\alpha > 0$. It is easy to show that Eq. 17 gives $x^{\text{I}} = b$, that is, a desirable cyclic steady-state solution.

It follows that the ratio $r$:

$$ r = \frac{x_n^{\text{I}} - x_{n-1}^{\text{I}}}{\Delta x_n - \Delta x_{n-1}} \tag{18} $$

can be estimated as $r \approx 1 / (1 - \exp(-\alpha t))$. From this, it is clear that because $\alpha$ is positive, the condition $r \geq 1$ must be valid. Moreover, $r$ can be very large if some internal characteristic time (like the trap characteristic time) is much longer than the period of the cycle.

**4: Performing Numeric Experiments**

Large-Signal Cyclic Analysis

Using the definition of $r$ from Eq. 18, Eq. 17 can be rewritten as:

$$x_{n+1}^{\text{I}} = x_n^{\text{I}} + \gamma r \Delta x_n \tag{19}$$

Although Eq. 18 and Eq. 19 are equivalent to Eq. 17, it is more convenient inside Sentaurus Device to use Eq. 18 and Eq. 19. Sentaurus Device never allows $r$ to be less than 1 because of the above arguments.

To provide convergence and robustness, it is reasonable also not to allow $r$ to become very large. In Sentaurus Device, $r$ cannot exceed a user-specified parameter $r_{\text{max}}$. You can specify different $r_{\text{max}}$ values for temperature, potential, and circuit node voltages. By default, $r_{\text{max}}$ is used for each equation. You can also specify the value of the parameter $r_{\text{min}}$.

An extrapolation procedure, which is described by Eq. 18 and Eq. 19, is performed for every variable of all the devices, in each vertex of the mesh. Instead of densities, which can spatially vary over the device by many orders of magnitude, the extrapolation procedure is applied to the appropriate quasi-Fermi potentials.

For the trap equations, extrapolation can be applied either to the trap occupation probability $f_{\text{T}}$ (the default) or, optionally, to the ‘trap quasi-Fermi level,’ $\Phi_{\text{T}} = -\ln((1 - f_{\text{T}})/f_{\text{T}})$. The cyclic steady state is supposedly reached if the following condition is satisfied:

$$\frac{\Delta x}{x + x_{\text{ref}}} < \varepsilon_{\text{cyc}} \tag{20}$$

Values of $x_{\text{ref}}$ are the same as `ErrRef` values of the `Math` section. For every object $o$ of the simulated system (that is, every variable of all devices), an averaged value $r_{\text{av}}^o$ of the ratio $r$ is estimated and can be optionally printed. Estimation of $r_{\text{av}}^o$ is performed only at such vertices of the object, where the condition:

$$\frac{\Delta x}{x + x_{\text{ref}}} < \frac{\varepsilon_{\text{cyc}}}{f} \tag{21}$$

is fulfilled, that is, the same condition as Eq. 20, but with a possibly different tolerance $\varepsilon 1_{\text{cyc}} = \varepsilon_{\text{cyc}}/f$.

You can specify the cyclic norm file name in the `File` section of the command file to store the cyclic norm as a function of the simulation time and the number of cyclic cycles for visualization of cyclic convergence.

The following extrapolation procedures are allowed:

1. Use of averaged extrapolation factors for every object. This is the default option.

2. Use of the factor $r$ independently for every mesh vertex of all objects. If for some reason, the criterion in Eq. 21 is already reached, the value of factor $r$ is replaced by the user-

Large-Signal Cyclic Analysis

defined parameter $r_{\text{min}}$. The option is activated by the keyword `-Average` in the `Extrapolate` statement inside the `Cyclic` specification.

3. The same as Step 2, but for the points where Eq. 21 is fulfilled, the value of factor $r$ is replaced by the averaged factor $r_{av}^o$. The option is activated by the keyword `-Average` in the `Extrapolate` statement inside the `Cyclic` specification, accompanied by the specification of the parameter $r_{\text{min}} = 0$.

4. You can limit the extrapolation factor for temperature equations (lattice, carrier temperatures), circuit node voltage, and electrostatic potential separately from carrier concentrations. For details about the associated keywords, see Table 335 on page 1627.

5. You can limit the cyclic extrapolation to a few cyclic cycles beyond which Sentaurus Device automatically switches to transient simulations. This allows the use of a mixed cyclic-transient methodology. This option can avoid the solution from oscillating around steady state.

6. You can specify a slightly modified extrapolation method using the keyword `CyclicExtrapolationMethod`. By default, Sentaurus Device uses Eq. 17 for extrapolation (`CyclicExtrapolationMethod=0`). However, in certain cases, setting `CyclicExtrapolationMethod=1`, which uses a slightly different formulation, can help with cyclic convergence.

7. For mixed-mode simulations, it has been observed that extrapolation applied to carrier concentrations often results in convergence issues. You can choose to exclude any field variable, that is, { $\psi, n, p, QP, Tl, Tc$ }, from cyclic extrapolation. The `IgnoreElectronPDE` option excludes electron density from cyclic extrapolation. Keywords relevant to this feature are explained in Table 335 on page 1627.

8. You can ignore a particular *region* for extrapolation. If specified in the command file, then none of the fields in the user-specified region is extrapolated using the cyclic extrapolation scheme. Fields in all other regions continue to be extrapolated cyclically.

# Using Cyclic Analysis

Cyclic analysis is activated by specifying the parameter `Cyclic` in the parameter list of the `Transient` statement. `Cyclic` is a complex structure–like parameter and contains cyclic options and parameters in parentheses:

```
Transient( InitialTime=0 FinalTime=2.e-7 InitialStep=2.e-14 MinStep=1.e-16
  Cyclic( <cyclic-parameters> )
) { ... }
```

With sub-options to the optional parameter `Extrapolate` to the `Cyclic` keyword, details of the cyclic extrapolation procedure are defined. Table 335 on page 1627 lists all options for `Cyclic`.

4: Performing Numeric Experiments

Small-Signal AC Analysis

An example of a Transient command with Cyclic specification is:

```
Transient( InitialTime=0 FinalTime=2.e-7 InitialStep=2.e-14 MinStep=1.e-16
  Cyclic( Period=8.e-10 StartingPeriod=4
    Accuracy=1.e-4 RelFactor=1
    Extrapolate (Average Print MaxVal=50) )
) { ... }
```

**NOTE** The value of the parameter `Period` in the `Cyclic` statement must be divisible by the period of the bias signal. A periodic bias signal must be specified elsewhere in the command file.

# Small-Signal AC Analysis

An `ACCoupled` solve section is an extension of a `Coupled` section with an extra set of parameters allowing small-signal AC analysis. Table 332 on page 1624 describes these parameters. In general, an `ACCoupled` is used in mixed mode. AC Simulation on page 1147 provides technical background information for the method.

## AC Analysis in Mixed-Mode Simulations

AC analysis computes the frequency-dependent admittance matrix $Y$ between circuit nodes of the specified electrical system.

For a given excitation frequency $\nu$, it describes the equivalent small-signal model by:

$$ \delta I = Y \delta V \qquad (22) $$

where $\delta V$ and $\delta I$ are the vectors of (complex-valued) voltage and current excitations at selected nodes, respectively. The admittance matrix can be represented as:

$$ Y = A + i 2 \pi \nu \ C \qquad (23) $$

by the real-valued conductance matrix $A$ and capacitance matrix $C$.

Within an `ACCoupled` section, you must specify the frequencies of interest and the circuit nodes considered in the admittance matrix. Furthermore, you might have to exclude some circuit instances from the given electrical system to describe the proper AC system:

*   `StartFrequency`, `EndFrequency`, `NumberOfPoints`, `Linear`, and `Decade`: Select the frequencies at which the AC analysis is performed.

*   `Frequency`: Specify a list of frequencies at which the AC analysis is performed.

Small-Signal AC Analysis

*   **ACExtract**: Specify an `ACCoupled`-specific file-name prefix for the extraction file, where the admittance matrices will be stored. If not specified, the `ACCoupled` writes into the global extraction file (given by `ACExtract` in `File`, which defaults to the extraction file `extraction_ac_des.plt`). The extraction file contains the frequency, the voltages at the nodes, and the entries of the matrices $A$ (denoted by a) and $C$ (denoted by c).

*   **ACPlot**: Invoke device plots containing AC response functions (solution variables and current densities). Here, you specify a file-name prefix, which generates a corresponding plot file for each AC node voltage excitation and frequency.

*   **Exclude**: Specify a list of system instances that should not be part of the AC system.

*   **Node**: Specify the list of AC nodes considered in the admittance matrix. For admittance matrix computations, a nonempty node list must be specified.

> **NOTE** If both `Frequency` and either one of `StartFrequency`, `EndFrequency`, or `NumberOfPoints` are defined, then the value defined in `Frequency` is used.

The `Exclude` list is used to remove a set of circuit or physical devices from the AC analysis. Typically, the power supply is removed so as not to short-circuit the AC analysis, but the list can also be used to isolate a single device from a whole circuit.

> **NOTE** The system analyzed consists of the equations specified in the body of the `ACCoupled` statement, without the instances removed by the `Exclude` list. The `Exclude` list only specifies instances, therefore, all equations of these instances are removed.

The `ACCompute` option controls AC or noise analysis performances within a `Quasistationary` or `Transient` ramp. The parameters in `ACCompute` are identical to the parameters in the `Plot` and `Save` commands (see Table 339 on page 1631). For example:

```
Quasistationary (...) {
  ACCoupled (...
    ACCompute (Time = (0; 0.01; 0.02; 0.03; 0.04; 0.05)
               Time = (Range = (0.9 1.0) Intervals = 4)
               Time = (Range = (0.1 0.2); Range = (0.7 0.8))
               When (Node = in Voltage = 1.5))
    {...}
  )
}
```

In this example, an AC analysis is performed only for the time points:

```
t = 0, 0.01, 0.02, 0.03, 0.04, 0.05
t = 0.9, 0.925, 0.95, 0.975, 1.0
```

and for all time points in the intervals [0.1, 0.2] and [0.7, 0.8]. Additionally, an AC analysis is triggered whenever the voltage at the node `in` reaches the 1.5 V threshold.

**4: Performing Numeric Experiments**

Small-Signal AC Analysis

If the AC or noise analysis is suppressed by the `ACCompute` option, an `ACCoupled` statement behaves like an ordinary `Coupled` statement.

The `Quasistationary` or `Transient` ramp that contains the `ACCoupled` also can contain a `CurrentPlot` specification (see When to Write to the Current File on page 113) to select the steps at which current output should occur.

The `CurrentPlot` and an `ACCompute` statement that the `ACCoupled` statement might contain are completely independent.

## Example

This example illustrates AC analysis of a simple device. A 1D resistor is connected to ground (through resistor `to_ground`) and to a voltage source `drive` at reverse bias of –3 V. After calculating the initial voltage point at –3 V, the left voltage is ramped to 1 V in 0.1 V increments. The AC parameters between nodes `left` and `right` are calculated at frequencies $f = 10^3 \text{ Hz}$, $10^4 \text{ Hz}$, $10^5 \text{ Hz}$, and $10^6 \text{ Hz}$. The circuit element `drive` and `to_ground` are excluded from the AC calculation.

By including circuits, complete Bode plots can be performed:

```
 Device "Res" { ...
    Electrode {{Name=anode    Voltage=-3 resist=1}
               {Name=cathode  Voltage= 0 resist=1}
    }
    File {Grid = "resist.tdr"}
    Physics {...}
 }

 System {
    "Res" "1d" (anode="left" cathode="right")
    Vsource_pset drive("left" "right"){dc = -3}
    Resistor_pset to_ground ("right" 0){resistance=1}
 }

 Math {
    Method=Blocked SubMethod=Super             # 1D, 2D default solvers for Coupled
    ACMethod=Blocked ACSubMethod=Super         # 1D, 2D default solvers for AC analysis
    NoAutomaticCircuitContact
 }

 Solve { ...
    ACCoupled (
       StartFrequency=1e3 EndFrequency=1e6 NumberOfPoints=4 Decade
       Node("left" "right")
       Exclude(drive to_ground)
       ACMethod=Blocked ACSubMethod("1d")=ParDiSo
    ) { Poisson Electron Hole Contact Circuit }
```

Small-Signal AC Analysis

```
    Quasistationary ( ...
      Goal{Parameter=drive.dc Value=1}
    ) {
      ACCoupled(
        StartFrequency=1e3 EndFrequency=1e6 NumberOfPoints=4 Decade
        Node("left" "right")
        Exclude(drive to_ground)
        ACMethod=Blocked ACSubMethod("1d")=ParDiSo
      ) { Poisson Electron Hole Circuit Contact }
    }
  }
```

# AC Analysis in Single-Device Mode

As previously described, AC analysis requires in general a mixed-mode simulation, that is, a `System` section must be defined. For single-device simulations, a simple AC system is constructed for you if you use `ImplicitACSystem` in the global `Math` section.

This implicit AC system is built internally and is essentially invisible to users. The implicit AC system has the following properties:

* For each voltage-controlled electrode of the device under test (DUT), an electrical circuit node is constructed and connected to the device contact. For other contact types, no nodes are constructed.

* Each implicit node is connected with a system instance describing the stationary and (possibly) transient voltage boundary conditions. Data provided for the device contacts is transferred implicitly to the system instances.

In the case of an implicit AC system generation, the `ACCoupled` provides slightly different default behavior:

* Node: If no AC nodes are specified, all implicit system nodes are used as AC nodes. Specified device contact names are interpreted implicitly as the corresponding node name.

* Exclude: If no exclude instances are specified, all implicit system instances attached to the AC nodes are excluded. Specified device contact names are interpreted as the corresponding system instance name.

### Additional remarks:

* Goal statements in `Quasistationary`: `Goal` statements for the electrode-voltage values for the device are interpreted as `Goal` statements for the implicit system instance connected to the corresponding node of the electrode.

* The implicit AC system is extracted before the `Solve` section is executed. Therefore, solve statements that change the mode of the contact type are not supported.

4: Performing Numeric Experiments

Small-Signal AC Analysis

### Example

```
Math {
    ImplicitACSystem             * build implicit AC system
}

Electrode { ...
    { Name="c1" Voltage=1 Voltage=(1 at 0. , 2. at 1.e-8) ... }
    { Name="c2" Current=0. }     * contact without implicit node connection
}

Solve { ...
    Quasistat ( ...
        Goal { Name= "c1" Voltage=2"} * contact goals are mapped onto instances
    ) { Coupled {...} }

    * AC analysis: use all implicit AC nodes
    ACCoupled ( StartFrequency=1.e6 EndFrequency=1.e9 NumberOfPoints=4 Decade
        ACExtract="AC1" ) {...}
    * AC analysis: use only one AC node
    ACCoupled ( StartFrequency=1.e6 EndFrequency=1.e9 NumberOfPoints=4 Decade
        Node ( "c1" )
        ACExtract="AC2" ) {...}
}
```

# Optical AC Analysis

Optical AC analysis calculates the quantum efficiency as a function of the frequency of the optical signal. This technique is based on the AC analysis technique, and provides real and imaginary parts of the quantum efficiency versus the frequency.

To start optical AC analysis, add the keyword `Optical` in an `ACCoupled` statement. For example:

```
ACCoupled ( StartFrequency=1.e4 EndFrequency=1.e9
        NumberOfPoints=31 Decade Node(a c)
        Optical Exclude(v1 v2) )
        { poisson electron hole }
```

For details, see Optical AC Analysis on page 716.

Harmonic Balance

# Harmonic Balance

Harmonic balance (HB) analysis is a frequency domain method to solve periodic or quasi-periodic, time-dependent problems. Compared to transient analysis (see Transient Command on page 90), HB is computationally more efficient for problems with time constants that differ by many orders of magnitude. Compared to AC analysis (see Small-Signal AC Analysis on page 101), the periodic excitation is not restricted to infinitesimally small amplitudes. An alternative to HB for the periodic case is cyclic analysis (see Large-Signal Cyclic Analysis on page 97).

**NOTE** Harmonic balance is not supported for traps (see Chapter 17 on page 489) or ferroelectrics (see Chapter 29 on page 855).

The time-dependent simulation problems take the form:

$$ \frac{d}{dt}q[r, u(t, r)] + f[r, u(t, r), w(t, r)] = 0 $$ (24)

where $f$ and $q$ are nonlinear functions that describe the circuit and the devices, $u$ is the vector of solution variables, and $w$ is a time-dependent excitation.

Assuming $w$ is quasi-periodic with respect to $f = (\hat{f}_1, \dots, \hat{f}_M)^T$, the vector of the positive base frequencies $\hat{f}_m$, and $\underline{H} = (H_1, \dots, H_M)^T$, the vector of nonnegative maximal numbers of harmonics $H_m$, the solution $u$ is approximated by a truncated Fourier series:

$$ u(t) = U_0 + \sum_{-\underline{H} \le \underline{h} \le \underline{H}} U_{\underline{h}} \exp(i\omega_{\underline{h}}t) $$ (25)

where $\omega_{\underline{h}} = 2\pi\underline{h} \cdot \hat{f}$. In Fourier space, Eq. 24 becomes:

$$ L(U) := i\Omega Q(U) + F(U) = 0 $$ (26)

where $\Omega$ is the frequency matrix, and $F$ and $Q$ are the Fourier series of $f$ and $q$. The function $L$ depends nonlinearly on $U$ and, therefore, solving Eq. 26 requires a nonlinear (Newton) iteration. For more details on the numerics of harmonic balance, see Harmonic Balance Analysis on page 1150.

## Modes of Harmonic Balance Analysis

Sentaurus Device supports two different modes to perform harmonic balance simulations: the MDFT mode and the SDFT mode.

4: Performing Numeric Experiments

Harmonic Balance

## MDFT Mode

The MDFT mode is suitable for multitone analysis and one-tone analysis, and is enabled by the `MDFT` option in the `HB` section of the global `Math` section. It uses the multidimensional Fourier transformation (MDFT) to switch between the frequency and time domain of the system.

This mode requires compact models defined by the compact model interface (CMI), which support assembly routines in the frequency domain, that is, the CMI-HB-MDFT function set as described in Compact Models User Guide, Analytical Description of CMI Models on page 129.

Sentaurus Device provides a basic set of compact models that support this functional behavior (see Compact Models User Guide, CMI Models With Frequency-Domain Assembly on page 171). Standard SPICE models are not supported in this mode.

## SDFT Mode

The SDFT mode supports only one-tone HB analysis. The mixed-mode circuit might contain SPICE models and CMI models that do not provide the CMI-HB-MDFT functional set. It is used if the MDFT mode is disabled.

# Performing Harmonic Balance Analysis

Harmonic balance simulations are enabled through the keyword `HBCoupled` in the `Solve` section. The syntax of `HBCoupled` is the same as for `Coupled` (see Coupled Statement on page 141). In addition, `HBCoupled` supports the options summarized in Table 338 on page 1630.

**NOTE** Not all `HBCoupled` options are supported by both modes.

The `Tone` option is mandatory, as no default values are provided.

Specifying several `Tone` options in MDFT mode enables multitone analysis. The base frequencies for the analysis can be given by explicit numeric constants or can refer to the frequencies of time-dependent sources in the `System` section.

An example of a two-tone analysis is:

```
Math {
  HB { MDFT }    * enable MDFT mode
  ...
}
System {
```

Harmonic Balance

```
  ...
  sd_hb_vsource2_pset "va" ( na 0 )                        * two-tone voltage source
   { dc = 1.0 freq = 1.e9 mag = 5.e-3 phase = -90.
   freq2 = 1.e3 mag2 = 1.e-3 phase2 = -90.}

  HBPlot "hbplot" ( v(na) i(va na) ... )                   * HB circuit output
 }
 Solve {
  * solve the DC problem
  ...
  Coupled { Poisson Electron Hole }

  * solve the HB problem
  HBCoupled ( * two-tone analysis
   Tone ( Frequency = "va"."freq" NumberOfHarmonics = 5 )
   Tone ( Frequency = "va"."freq2" NumberOfHarmonics = 1 )
   Initialize = DCMode
   Method = ILS
   GMRES ( Tolerance = 1.e-2 MaxIterations = 30 Restart = 30 )
  ) { Poisson Electron Hole }
 }
```

The base frequencies $\hat{f}_1$ and $\hat{f}_2$ in this example are taken from the time-dependent voltage source va.

HBCoupled can be used as a top-level `Solve` statement, or within `Plugin`, `QuasiStationary`.

**NOTE** If a `QuasiStationary` controls other `Solve` statements besides a single `HBCoupled`, step reduction due to convergence problems works correctly only when no `HBCoupled` in the failing step has converged before the statement that caused the failure is run.

## Solve Spectrum

The spectrum to be solved is determined by the specified tones. For different `HBCoupled` statements, the number of tones and their number of harmonics are allowed to change (where the $m$-th tone is identified with the $m$-th tone of the next spectrum, regardless of the value of its frequency, that is, the order of tones is significant).

For some applications, you might be interested only in a few spectrum components or you might want to reduce the computational burden in the Newton process. For such situations, you can reduce the solve spectrum (only for the MDFT mode) by applying spectrum truncation.

This is performed by specifying a list of spectrum (multi-)indices by using `SolveSpectrum` in the `HB` section of the global `Math` section, and referencing to this spectrum in the `HBCoupled` statement.

4: Performing Numeric Experiments

Harmonic Balance

For example:

```
Math { ...
  HB { ... SolveSpectrum ( Name = "sp1" ){ (0 0) (1 0) (0 1) (2 1) (2 -1) } }
}
Solve { ...
  HBCoupled ( ... SolveSpectrum = "sp1" ) { ... }
}
```

where, for example, the multi-index (2 -1) corresponds to the intermodulation frequency $2\hat{f}_1 - 1\hat{f}_2$.

## Convergence Parameters

The convergence behavior of `HBCoupled` can be analyzed and influenced independently of specifications for the convergence of `Coupled` solve statements. Some parameters can be set exclusively in the `HB` section of the global `Math` section (see Table 215 on page 1539), others can be set exclusively in the `HBCoupled` statement (see Table 338 on page 1630), and some can be set in both places.

Specifying `LogDensity` allows you to use transformed density variables in the HB analysis. Instead of using the carrier density variables directly, the logarithm of internally scaled carrier densities are used as solution variables in the HB Newton algorithm. This improves sometimes the convergence of the analysis. You can set this flag only in the global `Math` section, and the variable transformation applies to all `HBCoupled` statements.

The parameter `LogTemperature` works completely analogously to `LogDensity`, but here the variable transformation is applied to the (internally scaled) lattice and carrier temperature variables. This option requires the novel update error computation.

The parameter `sdft_update_norm_R` allows you to change between the update error computation (compatible with Version R-2020.09) and an improved novel variant. For linear variables, the differences are very small, but for logarithmic variables (that is, usage of `LogDensity` or `LogTemperature`), the novel update error computation deviates significantly and is more consistent. Therefore, it is highly recommended to switch off the old variant by specifying `-sdft_update_norm_R` in the `HB` section of the global `Math` section.

`CNormPrint` is used to print the residuum, the update error, and the number of corrections (the number of grid points where a correction of computed sample points is necessary) in each Newton step for all solved equations of all instances. This information can be used to adjust the numeric convergence parameters.

The `Derivative` flag in `HBCoupled` overwrites the `Derivative` flag of the `Math` section and determines whether all derivatives are included in the HB Newton process.

Harmonic Balance

With `RhsScale` and `UpdateScale`, you can scale the residuum and the update error of individual equations, respectively, which are used as Newton convergence criteria. This is often necessary for the electron and hole continuity equations, and the values differ for different applications and devices.

The parameters `ValueMin` and `ValueVariation` are used for positive solution variables to specify the allowed minimum value in the time domain, and the corresponding ratio of maximum and minimum values, respectively. The number of corrections (given by `CNormPrint`) indicates how many grid points violate the specified bounds.

---

## Harmonic Balance Analysis Output

All frequency-domain output data refers to the one-sided Fourier series representation for real-valued quantities, that is, it refers to $\tilde{U}_h$ of:

$$
\begin{aligned}
u(t) &= \tilde{U}_0 + \sum_{h \in K^+} \text{Re}(\tilde{U}_h \text{exp}(i\omega_{\underline{h}}t)) \\
&= \tilde{U}_0 + \sum_{h \in K^+} \left\{ \text{Re}(\tilde{U}_h) \text{cos}(\omega_{\underline{h}}t) - \text{Im}(\tilde{U}_h) \text{sin}(\omega_{\underline{h}}t) \right\}
\end{aligned}
\eqno(27)
$$

where the sum is taken over all multi-indices $\underline{h}$, which results in a positive frequency $\omega_{\underline{h}} = \underline{h} \cdot \underline{\hat{\omega}}$.

## Circuit Currents and Voltages

The keyword `HBPlot` in the `System` section allows you to plot circuit quantities. The syntax of `HBPlot` is identical to that of `Plot` in the `System` section (see Plotting Quantities on page 59). For both SDFT and MDFT modes, two output files are generated for the circuit quantities: `HB_F` for the frequency domain output, and `HB_T` for the time domain output. Output quantities for all bias points are combined into such output files in a way similar to AC analysis.

If conflicts impede information being saved in the same `.plt` file, then Sentaurus Device closes the current file, automatically modifies the file name by inserting an incrementer (for example, `HB_F_1` and `HB_T_1`), and prints a warning.

Output files for individual devices are suppressed as HB information is usually related to circuit nodes.

To activate the old output format, define:

```
Math { -NewHBFileNames }
```

4: Performing Numeric Experiments

Harmonic Balance

# Solution Variables

Plotting solution variables is implicitly performed if the `HB` section in the `Math` section is present. Sentaurus Device plots the magnitude and phase of the $\tilde{U}_h$ coefficients of Eq. 27, with the prefixes `MagHB` and `PhaseHB` to the variable names. For the SDFT mode, a suffix `_C<i>` with component `<i>` is added to the names. For the MDFT mode, a suffix corresponding to the intermodulation frequencies `_C_<i,j,k...>` is added to the names. To control the output quantities, you can define:

```
Plot { ...
    HBPlot ( <int>|order=<int> dataname[<list>] )
}
```

where `<int>` or `order=<int>` defines the order for plotting. For the SDFT mode, `order` is equal to the number of harmonics to be plotted. For the MDFT mode, it plots the results of intermodulation frequencies up to the integer defined by `order`. For example, for `order=3`, in two-tone simulations (frequencies f2 > f1), Sentaurus Device plots the datasets corresponding to f1, f2, 2&times;f1, 2&times;f2, f1+f2, f2&ndash;f1, 3&times;f1, 3&times;f2, 2&times;f1+f2, 2&times;f2+f1, 2&times;f1&ndash;f2, 2&times;f2&ndash;f1, as long as the resulting frequency is positive. If `order` is not defined, then the results of all harmonics used in the simulation are plotted. You can set `order=0` to suppress the HB datasets from the TDR files.

The keyword `dataname[<list>]` defines a list of datasets to be plotted. If `dataname` is not defined, then all related solution variables are plotted; otherwise, only the defined ones are plotted.

If options for `HBPlot` are not defined, then the results of all harmonics of all related solution variables are plotted, which is the default case.

# Output of Individual HBCoupled Statements

By using `-NewHBFileNames`, each converged `HBCoupled` statement plots its results into separate files, and the files previously described are not generated.

The device results (contact currents and voltages, temperatures, and heat component) in the time domain and frequency domain are plotted into individual files.

The file names for the time domain contain a component `Tdom`; the file names for the frequency domain contain a component `Hdom`.

Circuit currents and voltages are plotted as previously described, referring to the `HBPlot` statements in the `System` section, but now individual files are generated per converged `HBCoupled` statements.

Sentaurus&trade; Device User Guide

**4: Performing Numeric Experiments**
References

# Application Notes

Note that:

*   Convergence: Typically, the nonlinear convergence improves with an increasing number of harmonics *H* for one-tone HB simulations.

*   Linear solvers: Benefiting both memory requirements and simulation time, you can use the iterative linear solver GMRES for most simulations. Only for very small problems, in terms of grid size and number of harmonics, will the direct solver method be sufficient.

# References

[1] For information about Perl regular expression syntax, go to [https://www.boost.org/doc/libs/1_72_0/libs/regex/doc/html/boost_regex/syntax/perl_syntax.html](https://www.boost.org/doc/libs/1_72_0/libs/regex/doc/html/boost_regex/syntax/perl_syntax.html).

[2] R. J. G. Goossens *et al.*, “An Automatic Biasing Scheme for Tracing Arbitrarily Shaped *I-V* Curves,” *IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems*, vol. 13, no. 3, pp. 310–317, 1994.

[3] K. S. Kundert, J. K. White, and A. Sangiovanni-Vincentelli, *Steady-State Methods for Simulating Analog and Microwave Circuits*, Boston: Kluwer Academic Publishers, 1990.

[4] Y. Takahashi, K. Kunihiro, and Y. Ohno, “Two-Dimensional Cyclic Bias Device Simulator and Its Application to GaAs HJFET Pulse Pattern Effect Analysis,” *IEICE Transactions on Electronics*, vol. E82-C, no. 6, pp. 917–923, 1999.

