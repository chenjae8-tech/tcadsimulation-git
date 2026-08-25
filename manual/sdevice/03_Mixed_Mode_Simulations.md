# CHAPTER 3 Mixed-Mode Simulations

*This chapter describes how to specify circuits and compact devices for mixed-mode simulations.*

---

## Overview of Mixed-Mode Simulations

Sentaurus Device is a single-device simulator, and a mixed-mode device and circuit simulator. A single-device command file is defined through the mesh, contacts, physical models, and solve command specifications.

For a multidevice simulation, the command file must include specifications of the mesh (`File` section), contacts (`Electrode` section), and physical models (`Physics` section) for each device. A circuit netlist must be defined to connect the devices (see Figure 7), and solve commands must be specified that solve the whole system of devices.

Diagram showing the difference between a single device simulation and multiple devices connected via a netlist.

<a name="figure-7"></a>Figure 7 Each device in a multidevice simulation is connected with a circuit netlist

The `Device` command defines each physical device. A command file can have any number of `Device` sections. The `Device` section defines a device, but a `System` section is required to create and connect devices.

Sentaurus Device provides different compact models for use in mixed-mode simulations and supports different ways of specifying compact models as follows:

*   Netlist files support a subset of the Synopsys HSPICE® language. You can use these files to specify parameter sets and instances of SPICE models and HSPICE models (see HSPICE Netlist Files on page 45).

*   SPICE circuit files (extension `.scf`) are available for SPICE models, HSPICE models, and built-in models. Both parameter sets and instances can be specified (see SPICE Circuit Files on page 51).

Compact Models

* Compact circuit files (extension `.ccf`) support the compact model interface in Sentaurus Device. Devices and parameter sets for user-defined models must be specified in compact circuit files. Instances can appear either in compact circuit files or in the `System` section of the command file (see User-Defined Compact Models on page 45).

* Electrical and thermal circuits can be defined in the `System` section of the command file. Initial conditions for the circuit nodes can be specified, as well as `Plot` statements to generate output (see System Section on page 54).

# Compact Models

Sentaurus Device provides different compact models for use in mixed-mode simulations:

* SPICE models (see Table 7 on page 43)

* Frequently used HSPICE models (see Table 8 on page 44)

* Built-in, special-purpose models (see Table 9 on page 44)

* User-defined models (see User-Defined Compact Models on page 45)

This section describes the incorporation of compact models in mixed-mode simulations. The *Compact Models User Guide* provides references for the different models.

# Hierarchical Description of Compact Models

In Sentaurus Device, each compact model is described by a three-level hierarchy:

* **Device:** The device describes the basic properties of a compact model. This includes the names of the model, electrodes, thermodes, and internal variables, and the names and types of the internal states and parameters. Devices are predefined for SPICE models and built-in models. For user-defined models, you must specify the devices.

* **Parameter set:** Each parameter set is derived from a device. It defines default values for the parameters of a compact model. Usually, the parameters that are shared among several instances are defined in a parameter set. Most SPICE models and built-in models provide a default parameter set, which can be directly referenced in a circuit description. For more complicated models such as MOSFETs, you can introduce new parameter sets.

* **Instance:** Instances correspond to the elements in the Sentaurus Device circuit. Each instance is derived from a parameter set. It can override the values of its parameters if necessary.

For SPICE models and built-in models, you define parameter sets and instances. For user-defined models, it is possible (and required) to introduce new devices. For more information, see the *Compact Models User Guide*.

Compact Models

Table 7 Available SPICE models in Sentaurus Device

| Model | Device name | Name of default parameter set |
| --- | --- | --- |
| Resistor | Resistor | Resistor_pset |
| Capacitor | Capacitor | Capacitor_pset |
| Inductor | Inductor | Inductor_pset |
| Coupled inductors | mutual | mutual_pset |
| Voltage-controlled switch | Switch | Switch_pset |
| Current-controlled switch | CSwitch | CSwitch_pset |
| Voltage source | Vsource | Vsource_pset |
| Current source | Isource | Isource_pset |
| Voltage-controlled current source | VCCS | VCCS_pset |
| Voltage-controlled voltage source | VCVS | VCVS_pset |
| Current-controlled current source | CCCS | CCCS_pset |
| Current-controlled voltage source | CCVS | CCVS_pset |
| MOSFET | Mos1 | Mos1_pset |
| Mos2 | Mos2_pset |  |
| Mos3 | Mos3_pset |  |
| Mos6 | Mos6_pset |  |
| BSIM1 | BSIM1_pset |  |
| BSIM2 | BSIM2_pset |  |
| BSIM3 | BSIM3_pset |  |
| BSIM4 | BSIM4_pset |  |
| B3SOI | B3SOI_pset |  |
| Diode | Diode | Diode_pset |
| Bipolar junction transistor | BJT | BJT_pset |
| Junction field effect transistor | JFET | JFET_pset |
| GaAs MESFET | MES | MES_pset |

Compact Models

Table 8 Available HSPICE models in Sentaurus Device

| Model | Device name |
| --- | --- |
| HSPICE Level 1 | HMOS_L1 |
| HSPICE Level 2 | HMOS_L2 |
| HSPICE Level 3 | HMOS_L3 |
| HSPICE Level 28 | HMOS_L28 |
| HSPICE Level 49 | HMOS_L49 |
| HSPICE Level 53 | HMOS_L53 |
| HSPICE Level 54 | HMOS_L54 |
| HSPICE Level 57 | HMOS_L57 |
| HSPICE Level 59 | HMOS_L59 |
| HSPICE Level 61 | HMOS_L61 |
| HSPICE Level 62 | HMOS_L62 |
| HSPICE Level 64 | HMOS_L64 |
| HSPICE Level 68 | HMOS_L68 |
| HSPICE Level 69 | HMOS_L69 |
| HSPICE Level 72 | HMOS_L72 |
| HSPICE Level 73 | HMOS_L73 |
| HSPICE Level 76 | HMOS_L76 |

Table 9 Built-in models in Sentaurus Device

| Model | Device name | Name of default parameter set |
| --- | --- | --- |
| Electrothermal resistor | Ter | Ter_pset |
| Ferroelectric capacitor | ferroelectric | ferroelectric_pset |
| MOS harness | MOS_harness | MOS_harness_pset |
| Parameter interface | Param_Interface_Device | Param_Interface |
| Saturable inductor | satinductor | satinductor_pset |
| SPICE temperature interface | Spice_Temperature_Interface_Device | Spice_Temperature_Interface |

3: Mixed-Mode Simulations
HSPICE Netlist Files

# User-Defined Compact Models

Sentaurus Device provides a compact model interface (CMI) for user-defined compact models. These models are implemented in C++ by you and linked to Sentaurus Device at runtime. Access to the source code of Sentaurus Device is not required.

To implement a new user-defined model:

1. Provide a corresponding equation for each variable in the compact model. For electrode voltages, compute the current flowing from the device into the electrode. For an internal model variable, use a model equation.

2. Write a formal description of the new compact model. Sentaurus Device reads this compact circuit file before the model is loaded.

3. Implement a set of C++ interface subroutines. Sentaurus Device provides a runtime environment.

4. Compile the model code into a shared object file, which is linked at runtime to Sentaurus Device. A `cmi` script executes this compilation.

5. Use the `CMIPath` keyword to define a search path in the `File` section of the command file.

6. Reference user-defined compact models in compact circuit files (extension `.ccf`) or directly in the `System` section of the command file.

# HSPICE Netlist Files

Sentaurus Device accepts HSPICE netlists that are provided in a separate file. A netlist is specified in the `System` section as follows:

```
System { Netlist = "spice_netlist.sp" }
```

Sentaurus Device can process only a subset of the HSPICE netlist syntax.

The recognized syntax is described in the following sections.

## Structure of Netlist Files

The first line of a netlist file is assumed to be a title line and is ignored. For example:

```
.TITLE 'amplifier netlist'
```

HSPICE Netlist Files

The title line is followed by a sequence of HSPICE statements, and the netlist is terminated by an optional `.END` statement:

```
.END
```

Everything after the final `.END` statement is ignored.

The netlist parser is case insensitive, except for string literals or file names in `.INCLUDE` statements:

```
.PARAM s = str('This is a case sensitive string.')
.INCLUDE 'Case/Sensitive/Filename'
```

## Comments

A line starting with either the dollar sign ($) character or the asterisk (*) character is a comment line. For example:

```
* This is a comment.
```

You can use in-line comments after the $ character:

```
R1 1 2 R=100 $ drain resistor
```

## Continuation Lines

Use the plus sign (+) character in the first column to indicate a continuation line:

```
R1 1 0
+ R=500
```

## The .INCLUDE Statement

Use the `.INCLUDE` statement to include another netlist in the current netlist:

```
.INCLUDE models.sp
```

## Numeric Constants

You can enter numbers in one of the following formats:

*   Integer (for example, 7)

*   Floating point (for example, -4.5)

*   Floating point with an integer exponent (for example, 3e8 and -1.2e9)

HSPICE Netlist Files

* Integer with a scale factor listed in Table 10 (for example, `6k`)

* Floating point with a scale factor listed in Table 10 (for example, `-8.9meg`)

**NOTE** The scale factor `a` is not a scale factor in a character string that contains `amps`. For example, the expression `20amps` is interpreted as 20 amperes of current, not as `20e-18mps`.

Table 10 Scale factors

| Scale factor | Description | Multiplying factor |
| --- | --- | --- |
| t | tera | 1012 |
| g | giga | 109 |
| meg or x | mega | 106 |
| k | kilo | 103 |
| mil | one-thousandth of an inch | 25.4 · 10-6 |
| m | milli | 10-3 |
| u | micro | 10-6 |
| n | nano | 10-9 |
| p | pico | 10-12 |
| f | femto | 10-15 |
| a | atto | 10-18 |

## Parameters and Expressions

In the HSPICE tool, parameters are names that you associate with a value. Numeric and string parameters are supported. For example:

```
.PARAM a = 4
.PARAM b = '2*a + 7'
.PARAM s = str('This is a string')
.PARAM t = str(s)
```

The following built-in mathematical functions are supported:

sin, cos, tan, asin, acos, atan, sinh, cosh, tanh, abs, sqrt, pow, pwr, log, log10, exp, db, int, nint, sgn, sign, floor, ceil, min, max

HSPICE Netlist Files

## Subcircuits

Reusable cells can be specified as subcircuits. The general definition is given by:

```
.SUBCKT name n1 n2 ... [param1=val] [param2=val] ...
.ENDS
```

or:

```
.MACRO name n1 n2 ... [param1=val] [param2=val] ...
.EOM
```

String parameters are supported as well:

```
.SUBCKT name n1 n2 ... [param=str('string')] ...
.ENDS
```

### Examples

```
.PARAM P5=5 P2=10

.SUBCKT SUB1 1 2 P4=4
  R1 1 0 P4
  R2 2 0 P5
  X1 1 2 SUB2 P6=7
  X2 1 2 SUB2
.ENDS

.MACRO SUB2 1 2 P6=11
  R1 1 2 P6
  R2 2 0 P2
.EOM

X1 1 2 SUB1 P4=6

X2 3 4 SUB2 P6=15
```

## The .MODEL Statement

The .MODEL statement has the following general syntax:

```
.MODEL model_name type [level=num] [pname1=val1] [pname2=val2] ...
```

Table 11 Recognized model types

| Type | Description | Type | Description |
| --- | --- | --- | --- |
| c | Capacitor model | npn | npn BJT model |
| csw | Current-controlled switch | pjf | p-channel JFET model |
| d | Diode model | pmf | p-channel MESFET |

HSPICE Netlist Files

Table 11 Recognized model types (Continued)

| Type | Description | Type | Description |
| --- | --- | --- | --- |
| l | Mutual inductor model | pmos | p-channel MOSFET model |
| njf | N-channel JFET model | pnp | pnp BJT model |
| nmf | N-channel MESFET | r | Resistor model |
| nmos | N-channel MOSFET model | sw | Voltage-controlled switch |

## Examples

```
.MODEL mod1 NPN BF=50 IS=1e-13 VFB=50 PJ=3 N=1.05

.MODEL mod2 PMOS LEVEL=72
+ aigbinv = 0.0111
+ at = -0.00156
```

## Elements

Element names must begin with a specific letter for each element type.

Table 12 HSPICE element types that are supported

| First letter | Element | Example |
| --- | --- | --- |
| c | Capacitor | Cbypass 1 0 10pf |
| d | Diode | D7 3 9D1 |
| e | Voltage-controlled voltage source | Ea 1 2 3 4 K |
| f | Current-controlled current source | Fsub n1 n2 vin 2.0 |
| g | Voltage-controlled current source | G12 4 0 3 0 10 |
| h | Current-controlled voltage source | H3 4 5 Vout 2.0 |
| i | Current source | IA 2 6 1e-6 |
| j | JFET or MESFET | J1 7 2 3 model_jfet w=10u l=10u |
| k | Linear mutual inductor | K1 L1 L2 0.98 |
| l | Linear inductor | Lx a b 1e-9 |
| m | MOS transistor | M834 1 2 3 4 N1 |
| q | Bipolar transistor | Q5 3 6 7 8 pnp1 |
| r | Resistor | R10 21 10 1000 |
| v | Voltage source | V1 8 0 5 |
| x | Subcircuit call | X1 2 4 17 31 MULTI WN=100 LN=5 |

HSPICE Netlist Files

Table 13 Berkeley SPICE element types that are supported

| First letter | Element | Example |
| --- | --- | --- |
| s | Voltage-controlled switch | S1 1 2 3 4 SWITCH1 ON |
| w | Current-controlled switch | W1 1 2 VCLOCK SWITCHMOD1 |
| z | GaAs MESFET | Z1 7 2 3 ZM1 AREA=2 |

## Netlist Commands

A limited set of netlist commands is recognized.

To make node names global across all subcircuits, use a `.GLOBAL` statement. For example:

```
.GLOBAL node1 node2 node3 ...
```

Use the `.OPTION PARHIER` statement to specify scoping rules. For example:

```
.OPTION PARHIER=GLOBAL|LOCAL
```

Other HSPICE netlist commands that have not been already mentioned explicitly are ignored.

## Specifying Physical Devices in Netlists

Sentaurus Device supports an extension of the HSPICE netlist format so that you can specify physical devices in an HSPICE netlist. The `.SDEVICE` statement declares the name of a physical device and its contacts:

```
.SDEVICE device_name drain gate source bulk
```

Instances of a physical device can be inserted into the netlist using the subcircuit command:

```
x1 d g s b device_name
```

The `.SDEVICE` statement and a subcircuit instantiation are equivalent to the following specification in the System section of a Sentaurus Device command file:

```
System { device_name x1 (drain=d gate=g source=s bulk=b) }
```

**NOTE** HSPICE names are case insensitive, and the netlist parser converts all identifiers to lowercase. Consequently, you must specify physical devices using lowercase in Sentaurus Device.

3: Mixed-Mode Simulations
SPICE Circuit Files

# SPICE Circuit Files

You can specify compact models in an external SPICE circuit file (extension `.scf`). The declaration of a parameter set can be:

```
PSET pset
    DEVICE dev
    PARAMETERS
    parameter0 = value0
    parameter1 = value1
    ...
END PSET
```

This declaration introduces the parameter set `pset` that is derived from the device `dev`. It assigns default values for the given parameters. The device `dev` should have already declared the parameter names. Furthermore, the values assigned to the parameters must be of the appropriate type.

Table 14 Parameters types in SPICE circuit files

| Parameter type | Example | Parameter type | Example |
| --- | --- | --- | --- |
| char | c = 'n' | char[] | cc = ['a' 'b' 'c'] |
| double | d = 3.14 | double[] | dd = [1.2 -3.4 5e6] |
| int | i = 7 | int[] | ii = [1 2 3] |
| string | s = "hello world" | string[] | ss = ["hello" "world"] |

Similarly, circuit instances can be declared as:

```
INSTANCE inst
    PSET pset
    ELECTRODES e0 e1 ...
    THERMODES t0 t1 ...
    PARAMETERS
       parameter0 = value0
       parameter1 = value1
       ...
END INSTANCE
```

According to this declaration, the instance `inst` is derived from the parameter set `pset`. Its electrodes are connected to the circuit nodes `e0`, `e1`, ..., and its thermodes are connected to `t0`, `t1`, and so on. This instance also defines or overrides parameter values.

See Compact Models User Guide, Syntax of Compact Circuit (.ccf) Files on page 178 Files on page 178) for the complete syntax of the input language for SPICE circuit files.

3: Mixed-Mode Simulations

SPICE Circuit Files

# Example

Consider the following simple rectifier circuit:

Rectifier circuit diagram showing a voltage source, a diode, and a resistor in a loop with nodes labeled 'in' and 'out'.

The circuit comprises three compact models and can be defined in the file `rectifier.scf` as:

```
 PSET D1n4148
  DEVICE Diode
  PARAMETERS
   is = 0.1p   // saturation current
   rs = 16     // Ohmic resistance
   cjo = 2p    // junction capacitance
   tt = 12n    // transit time
   bv = 100    // reverse breakdown voltage
   ibv = 0.1p // current at reverse breakdown voltage
 END PSET

 INSTANCE v
  PSET Vsource_pset
  ELECTRODES in 0
  PARAMETERS sine = [0 5 1meg 0 0]
 END INSTANCE

 INSTANCE d1
  PSET D1n4148
  ELECTRODES in out
  PARAMETERS temp = 30
 END INSTANCE

 INSTANCE r
  PSET Resistor_pset
  ELECTRODES out 0
  PARAMETERS resistance = 1000
 END INSTANCE
```

The parameter set D1n4148 defines the parameters shared by all diodes of type 1n4148. Instance parameters are usually different for each diode, for example, their operating temperature.

**NOTE** You must declare a parameter set before an instance can reference it.

3: Mixed-Mode Simulations

Command File for Mixed-Mode Simulations

The *Compact Models User Guide* further explains the SPICE parameters in this example. The command file for this simulation can be:

```
File { SPICEPath = ". lib spice/lib" }

System { Plot "rectifier" (time() v(in) v(out) i(r 0)) }

Solve {
  Circuit
  NewCurrentPrefix = "transient_"
  Transient (InitialTime = 0 FinalTime = 0.2e-5
             InitialStep = 1e-7 MaxStep = 1e-7) {Circuit}
}
```

The `SPICEPath` in the `File` section is assigned a list of directories. All directories are scanned for SPICE circuit files (`.scf`). Check the log file of Sentaurus Device to see which circuit files were found and used in the simulation.

The `System` section contains a `Plot` statement that produces the `rectifier_des.plt` file and plots the simulation time, the voltages of nodes `in` and `out`, and the current from resistor `r` into node 0.

The `Solve` section describes the simulation. The keyword `Circuit` denotes the circuit equations to be solved.

Instances in a circuit also can appear directly in the `System` section of the command file. For example:

```
System {
  Vsource_pset v (in 0) {sine = (0 5 1meg 0 0)}
  D1n4148 d1 (in out) {temp = 30}
  Resistor_pset r (out 0) {resistance = 1000}

  Plot "rectifier" (time() v(in) v(out) i(r 0))
}
```

# Command File for Mixed-Mode Simulations

This section discusses the most important sections of the Sentaurus Device command file for mixed-mode simulations.

Command File for Mixed-Mode Simulations

# System Section

The `System` section defines the netlist of physical devices and circuit elements to be solved. The netlist is connected through circuit nodes. By default, a circuit node is electrical, but it can be declared to be electrical or thermal:

```
Electrical { enode0 enode1 ... }
Thermal { tnode0 tnode1 ... }
```

Each electrical node is associated with a voltage variable, and each thermal node is associated with a temperature variable. Node names are numeric or alphanumeric. Node `0` is predefined as the ground node (0 V).

You can define compact models in HSPICE netlist files (see HSPICE Netlist Files on page 45) or in SPICE circuit files (see SPICE Circuit Files on page 51). However, instances of compact models can also appear directly in the `System` section of the command file:

```
parameter-set-name instance-name (node0 node1 ...) {<attributes>}
```

The order of nodes in the connectivity list corresponds to the electrodes and thermodes in the SPICE device definition (refer to the Compact Models User Guide).

The connectivity list is a list of *contact name=node name* connections, separated by white space. The contact name is the name of the contact from the grid file of the given device, and the node name is the name of the circuit netlist node as previously defined in the definition of a circuit element.

Physical devices are defined as:

```
device-type instance-name (connectivity list) {<attributes>}
```

The connectivity list of a physical device explicitly establishes the connection between a contact and a node. For example, the following defines a physical diode and a circuit diode:

```
Diode_pset circuit_diode (1 2) {...}                 # circuit diode
Diode243   device_diode (anode=1 cathode=2) {...}     # physical diode
```

Both diodes have their anode connected to node 1 and their cathode connected to node 2.

In the case of the circuit diode, the device specification defines the order of electrodes (see Compact Models User Guide, Syntax of Compact Circuit (.ccf) Files on page 178 Files on page 178)). Conversely, the connectivity for the physical diode must be given explicitly. The names `anode` and `cathode` of the contacts are defined in the grid file of the device. The device types of the physical devices must be defined elsewhere in the command file (with `Device` sections) or an external `.device` file.

Command File for Mixed-Mode Simulations

The `System` section can contain the initial conditions of nodes (see Initializing Nodes on page 58). Different types of initialization can be specified:

*   Fixed values (`Set`)

*   Fixed until transient (`Initialize`)

*   Initialized only for the first solve (`Hint`)

The `System` section can also contain `Plot` statements to generate plot files of node values, currents through devices, and parameters of internal circuit elements. For a simple case of one device without circuit connections (besides resistive contacts), the keyword `System` is not required because the system is implicit and trivial given the information from the `Electrode`, `Thermode`, and `File` sections at the base level.

# Physical Devices

A physical device is instantiated using a previously defined device type, name, connectivity list, and optional parameters. For example:

```
device_type instance-name (<connectivity_list>) {
  <optional_device_parameters>
}
```

If no extra device parameters are required, the device is specified without braces. For example:

```
device-type instance-name (<connectivity_list>)
```

The device parameters overload the parameters defined in the device type. As for a device type of Sentaurus Device, the parameters can include `Electrode`, `Thermode`, `File`, `Plot`, `Physics`, and `Math` sections.

> **NOTE** Electrodes have `Voltage` statements that set the voltage of each electrode. If electrodes are connected to nodes through the connectivity list, these values are only hints (as defined by the keyword `Hint`) for the first Newton solve, but they do not set the electrodes to those values as with the keyword `Set`. By default, an electrode that is connected to a node is floating.

> Electrodes must be connected to electrical nodes and thermodes to thermal nodes. This allows electrodes and thermodes to share the same contact name or number.

Command File for Mixed-Mode Simulations

## Circuit Devices

You can declare SPICE instances in HSPICE netlist files (see HSPICE Netlist Files on page 45) or in SPICE circuit files (see SPICE Circuit Files on page 51). They can also appear directly in the `System` section of the command file. For example:

```
pset inst (e0 e1 ... t0 t1 ...) {
  parameter0 = value0
  parameter1 = value1
  ...
}
```

This declaration in the command file provides the same information as the equivalent declaration in an HSPICE netlist file or a SPICE circuit file.

Array parameters must be specified with parentheses, not braces. For example:

```
dd = (1.2 -3.4 5e6)
ss = ("hello" "world")
```

Certain SPICE models have internal nodes that are accessible through the form `instance_name.internal_node`. For example, a SPICE inductance creates an internal node `branch`, which represents the current through the instance. Therefore, the expression `v(l.branch)` can be used to gain access to the current through the inductor `l`. This is useful for plotting internal data or initializing currents through inductors (refer to the *Compact Models User Guide* for a list of the internal nodes for each model).

## Electrical and Thermal Netlists

Both electrical and thermal netlists can coexist in the same system. For example:

```
System {
  Thermal (ta tc t300)
  Set (t300 = 300)
  Hint (ta = 300 tc = 300)

  Isource_pset i (a 0) {dc = 0}
  PRES pres ("Anode"=a "Cathode"=0 "Anode"=ta "Cathode"=tc)
  Resistor_pset ra (ta t300) {resistance = 1}
  Resistor_pset rc (tc t300) {resistance = 1}

  Plot "pres" (v(a) t(ta) t(tc) h(pres ta) h(pres tc) i(pres 0))
}
```

The current source `i` drives a resistive physical device `pres`. This device has two contacts `Anode` and `Cathode` that are connected to the circuit nodes `a` and `0`, and are also used as thermodes, which are connected to the heat sink `t300` through two thermal resistors `ra` and `rc`.

3: Mixed-Mode Simulations
Command File for Mixed-Mode Simulations

The `Plot` statement accesses the voltage of node `a`, the temperature of nodes `ta` and `tc`, the heat flux from `pres` into `ta` and `tc`, and the current from `pres` into the ground node `0`.

Many SPICE models provide a temperature parameter for electrothermal simulations. In Sentaurus Device, a temperature parameter is connected to the thermal circuit by a parameter interface.

Circuit diagram showing a current source and a resistor connected between nodes 1 and 0, with a thermal node t connected to the resistor.

For example, in this simple circuit, the resistor `r` is a SPICE semiconductor resistor whose resistance depends on the value of the temperature parameter `temp`:

$$ r_0 = rsh \cdot \frac{l - \text{narrow}}{w - \text{narrow}} $$
$$ r(\text{temp}) = r_0 \cdot (1 + tc_1 \cdot (\text{temp} - \text{tnom}) + tc_2 \cdot (\text{temp} - \text{tnom})^2) $$
(12)

To feed the value of thermal node `t` as a parameter into resistor `r`, a parameter interface is required:

```
 System {
  Thermal (t)
  Set (t = 300)

  Isource_pset i (1 0) {dc = 1}
  cres_pset r (1 0) {temp = 27 l = 0.01 w = 0.001}
  Param_Interface rt (t) {parameter = "r.temp" offset = -273.15}

  Plot "cres" (t(t) p(r temp) i(r 0) v(1))
 }
```

The parameter set `cres_pset` for resistor `r` is defined in an external SPICE circuit file:

```
 PSET cres_pset
  DEVICE Resistor
  PARAMETERS
              rsh = 1
              narrow = 0
              tc1 = 0.01
              tnom = 27
 END PSET
```

The parameter interface `rt` updates the value of `temp` in `r` when the variable `t` is changed. This is the general mechanism in Sentaurus Device, which allows a circuit node to connect to a model parameter.

Command File for Mixed-Mode Simulations

> **NOTE** It is important to declare the parameter interface after the instance to which it refers. Otherwise, Sentaurus Device cannot establish the connection between the parameter interface and the instance.

Temperatures in Sentaurus Device are defined in kelvin. SPICE temperatures are measured in degree Celsius. Therefore, an offset of –273.15 must be used to convert kelvin to degree Celsius.

The parameter `Spice_Temperature` in the `Math` section initializes the global SPICE circuit temperature at the beginning of a simulation. It cannot be used to change the SPICE temperature later. To modify the SPICE temperature during a simulation, a *SPICE temperature interface* must be used.

A SPICE temperature interface has one contact that can be connected to an electrode or a thermode. When the value $u$ of the electrode or thermode changes, the global SPICE temperature is updated according to:

$$ \text{Spice temperature} = \text{offset} + c_1 u + c_2 u^2 + c_3 u^3 $$ (13)

By default, $\text{offset} = c_2 = c_3 = 0$ and $c_1 = 1$. Therefore, the SPICE temperature interface ensures that the global SPICE temperature is identical to the value $u$.

In the following example, a SPICE temperature interface is used to ramp the global SPICE temperature from 300 K to 400 K:

```
System {
  Set (st = 300)
  Spice_Temperature_Interface ti (st) { }
}
Solve {
  Quasistationary (Goal {Node = st Value = 400} DoZero
    InitialStep = 0.1 MaxStep = 0.1) {
    Coupled {Circuit}
  }
}
```

## Initializing Nodes

The `Set` statement establishes the node value. (The `Unset` statement is used to free a node after a `Set` statement.) This value remains fixed during all subsequent simulations until a `Set` or an `Unset` statement is used in the `Solve` section (see Mixed-Mode Electrical Boundary Conditions on page 69), or the node becomes a `Goal` of a `Quasistationary`, which controls the node itself (see Quasistationary in Mixed Mode on page 80). For a set node, the corresponding equation (that is, the current balance equation for electrical nodes and the heat balance equation for thermal nodes) is not solved, unlike an unset node.

**3: Mixed-Mode Simulations**
Command File for Mixed-Mode Simulations

**NOTE** The `Set` and `Unset` statements exist in the `Solve` section. These act like the System-level `Set` but allow more flexibility (see System Section on page 54).

You can also use the `Set` statement to change the value of a parameter in a compact model. In the following example, the resistance of resistor `r1` changes to 1000 $\Omega$:

```
Set (r1."resistance" = 1000)
```

The `Initialize` statement is similar to the `Set` statement except that node values are kept only during nontransient simulations. When a transient simulation starts, the node is released with its actual value, that is, the node is unset.

**NOTE** The `Initialize` statement can be used with an internal node to set a current through an inductor before a transient simulation. For example:

```
Inductor_pset L2 (a b){ inductance = 1e-5 }
Initialize (L2.branch = 1.0e-4)
```

The `Hint` statement provides a guess value for an unset node for the first Newton step only. The numeric value is given in volt, ampere, or kelvin. A current value only makes sense for internal current nodes in circuit devices. The statements are used as follows:

```
Set ( <node> = <float> <node> = <float> ... )
Unset ( <node> <node> ... )
Initialize ( <node> = <float> <node> = <float> ... )
Hint ( <node> = <float> <node> = <float> ... )
```

## Example

```
Set ( anode = 5 )
```

# Plotting Quantities

The `System` section can contain any number of `Plot` statements to print voltages at nodes, currents through devices, or circuit element parameters. The output is stored in a specified file name. If no file name is provided, the output is sent to the standard output file and the log file. The syntax of the `Plot` statement is:

```
Plot [<filename>] (<plot_command_list>)
```

where `<plot_command_list>` is a list of nodes or plot commands (see Table 350 on page 1638).

Command File for Mixed-Mode Simulations

**NOTE** Plot commands are case sensitive.

The `Plot` statement does not print the time by default. When plotting a transient simulation, you must add the `time()` command.

## Examples

```
Plot (a b i(r1 a) p(r1 rT) p(v0 "sine[0]"))
Plot "plotfile" (time() v(a b) i(d1 a))
```

## Modifying Plot Output

You can use the `ACPlot` statement in the `System` section to modify the output in the Sentaurus Device AC plot file:

```
System {
  ACPlot (<plot_command_list>)
}
```

The `<plot_command_list>` is the same as the plot commands discussed in Plotting Quantities on page 59.

If an `ACPlot` statement is specified, then the given quantities are plotted in the Sentaurus Device AC plot file with the results from the AC analysis. Otherwise, only the voltages at the AC nodes are plotted with the results from the AC analysis.

# Device Section

The `Device` sections of the command file define the different device types used in the system to be simulated. Each device type must have an identifier name that follows the keyword `Device`. Each `Device` section can include `Electrode`, `Thermode`, `File`, `Plot`, `Physics`, and `Math` sections. For example:

```
Device "resist" {
  Electrode { ... }
  File { ... }
  Physics { ... }
  ...
}
```

If information is not specified in the `Device` section, then information from the lowest level of the command file is taken (if defined there). For example:

```
# Default Physics section
Physics { ... }
```

**3: Mixed-Mode Simulations**
Command File for Mixed-Mode Simulations

```
Device resist {
 # This device has no Physics section, so it uses the default set above
 Electrode { ... }
 File { ... }
}
```

# File Section

In the `File` section, you can specify the following:

* Name of the output file (keyword `Output`) and name of the small-signal AC extraction file (keyword `ACExtract`)

* Sentaurus Device directory path (keyword `DevicePath`)

* Search path for SPICE models (keyword `SPICEPath`) and compact models (keyword `CMIPath`)

* Default file names for the devices

See Table 202 on page 1514 for the syntax of these keywords.

For the keywords `Output` and `ACExtract`, only a file name without an extension is required. Sentaurus Device automatically appends a predefined extension:

```
File {
  Output = "mct"
  ACExtract = "mct"
}
```

For the keywords `DevicePath`, `SPICEPath`, and `CMIPath`, you must assign a list of directories for which Sentaurus Device searches. For example:

```
File {
  DevicePath = "../devices:/usr/local/tcad/devices:."
  SPICEPath  = ". lib lib/spice"
  CMIPath    = ". libcmi"
}
```

Device files (extension `.device`) in `DevicePath` are loaded. The devices found can then be used in the `System` section.

SPICE circuit files (extension `.scf`) in `SPICEPath` are parsed and added to the `System` section of the command file.

Compact circuit files (extension `.ccf`) and the corresponding shared object files (extension `.so.arch`) in `CMIPath` are parsed and added to the `System` section of the command file.

Working With Mixed-Mode Simulations

Device-specific keywords are defined under the file entry in the `Device` section.

## Math Section

You can specify the following keywords in the global `Math` section for mixed-mode simulations:

```
Math {
  Spice_Temperature=<float>
  Spice_gmin=<float>
}
```

The keyword `Spice_Temperature` is the global SPICE circuit temperature (default: 300.15 K). The keyword `Spice_gmin` refers to the minimum conductance in SPICE (default: 10<sup>-12</sup> $\Omega$<sup>-1</sup>).

To compute the numeric Jacobian for the SPICE behavioral model (E-element and G-element), you need to specify the following keyword in the global `Math` section:

```
Math {
  BehavSrcNumericDeriv=0.001
}
```

The keyword `BehavSrcNumericDeriv` is the deviation of the variable. Its default is 0, which means no Jacobian is computed.

# Working With Mixed-Mode Simulations

In Sentaurus Device, mixed-mode simulations are handled as a direct extension of single-device simulations.

## From Single-Device to Multidevice Command Files

The command file of Sentaurus Device accepts both single-device and multidevice problems. Although the two forms of input look different, they fit in the same input syntax pattern. This is possible because the command file has multiple levels of definitions and there is a built-in default mechanism for the `System` section.

The complete input syntax allows for three levels of device definition: global, device, and instance (see Figure 8 on page 63). These levels are linked in that the global level is the default for the device level and instance level.

Working With Mixed-Mode Simulations

```
File {...}
Electrode {...}   } Global
...

Device <type> {
  File {...}
  Electrode {...} } Device
  ...
}

System {
  <type> <name> {
    File {...}
    Electrode {...} } Instance
    ...
  }
}
```

Figure 8 Three levels of device definition

By default, if no `Device` section exists, a single device is created with the content of a global device. If no `System` section exists, one is created with this single device. In this way, single devices are converted to multidevice problems with a single device and no circuit.

**NOTE** The device that is created by default has the name " " (that is, an empty string).

This translation process can be performed manually by creating a `Device` and `System` section with a single entry (see Figure 9).

```
                                File {
                                  Output = "diode"
                                }

Electrode {                     Device diode {
  {name="anode"   Voltage=0}      Electrode {
  {name="cathode" Voltage=1}        {name="anode"   Voltage=0}
}                                   {name="cathode" Voltage=1}
                                  }
File {                            File {
  Grid   = "diode.tdr"              Grid = "diode.tdr"
  Output = "diode"                }
}                               }

                                System {
                                  diode diode1 ...
                                }
```

Figure 9 Translating single-device syntax to mixed-mode syntax

Working With Mixed-Mode Simulations

The `Solve` section can also be converted if you specify `NoAutomaticCircuitContact`. In Figure 10, all occurrences of `Poisson` must be expanded to `Poisson Contact Circuit`.

Diagram showing the translation of default solve syntax to a NoAutomaticCircuitContact form with code blocks and arrows indicating the expansion of Poisson to Poisson Contact Circuit.

<a id="figure-10"></a>Figure 10 Translating default solve syntax to a NoAutomaticCircuitContact form

# File-Naming Conventions for Mixed Mode

You can define a `File` section at all levels of a command file. Therefore, a default file name can be potentially included by more than one device.

In the following example, both `r1` and `r2` use the save device parameters set up in the definition of `res`:

```
Device res {
  File { Save="res" ... }
  ...
}
System {
  res r1
  res r2
}
```

Therefore, in principle, `r1` and `r2` have the same default for `Save` (that is, `res`). Since it is impractical to save both device instances under the same name, names of device instances (that is, `r1` and `r2`) are concatenated to the file name to produce the files `res.r1` and `res.r2`.

This process of file name extension applies to the keywords `Current`, `Plot`, and `Save` of the `File` section, and also when the file name is copied from the global default to a device type declaration.

**3: Mixed-Mode Simulations**
Working With Mixed-Mode Simulations

In practice, the following possibilities exist:

* The file name is defined at the instance level, in which case, it is unchanged.

* The file name is defined at the device level, in which case, the instance name is concatenated to the original file name.

* The file name is defined at the global level of the command file, in which case, the device name and instance name are concatenated to the original file name.

Table 15 File name extensions for the Current, Plot, and Save keywords

| Level | File name format |
| --- | --- |
| Instance | <given name> |
| Device | <given name>.<instance name> |
| Global | <given name>.<device type>.<instance name> |

Working With Mixed-Mode Simulations

 