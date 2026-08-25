# Version S-2021.06, June 2021

**SYNOPSYS<sup>®</sup>**

# Copyright and Proprietary Information Notice

© 2021 Synopsys, Inc. This Synopsys software and all associated documentation are proprietary to Synopsys, Inc. and may only be used pursuant to the terms and conditions of a written license agreement with Synopsys, Inc. All other use, reproduction, modification, or distribution of the Synopsys software or the associated documentation is strictly prohibited.

## Destination Control Statement

All technical data contained in this publication is subject to the export control laws of the United States of America. Disclosure to nationals of other countries contrary to United States law is prohibited. It is the reader’s responsibility to determine the applicable regulations and to comply with them.

## Disclaimer

SYNOPSYS, INC., AND ITS LICENSORS MAKE NO WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, WITH REGARD TO THIS MATERIAL, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

## Trademarks

Synopsys and certain Synopsys product names are trademarks of Synopsys, as set forth at [https://www.synopsys.com/company/legal/trademarks-brands.html](https://www.synopsys.com/company/legal/trademarks-brands.html).

All other product or company names may be trademarks of their respective owners.

## Free and Open-Source Licensing Notices

If applicable, Free and Open-Source Software (FOSS) licensing notices are available in the product installation.

## Third-Party Links

Any links to third-party websites included in this document are for your convenience only. Synopsys does not endorse and is not responsible for such websites and their practices, including privacy practices, availability, and content.

www.synopsys.com

<page_number>ii</page_number> 

 S-2021.06

# Contents

**About This Guide** **xliii**
*   Conventions xliii
*   Customer Support xliv
    *   Accessing SolvNetPlus xliv
    *   Contacting Synopsys Support xliv
    *   Contacting Your Local TCAD Support Team Directly xlv
*   Acknowledgments xlv

**Part I Getting Started** **1**

**Chapter 1 Introduction to Sentaurus Device** **3**
*   Functionality of Sentaurus Device 3
    *   Creating and Meshing Device Structures 5
    *   Tool Flow 5
*   Starting Sentaurus Device 6
    *   From the Command Line 6
    *   From Sentaurus Workbench 7
*   TCAD Sentaurus Tutorial: Simulation Projects 8

**Chapter 2 Specifying Physical Devices** **9**
*   Reading a Structure 9
    *   Cylindrical Coordinate System 10
    *   Abrupt and Graded Heterojunctions 11
*   Specifying Doping Species 12
*   Specifying Materials 14
    *   User-Defined Materials 14
    *   Mole-Fraction Materials 15
*   Mole-Fraction Specification 17
*   Physical Models and the Hierarchy of Their Specification 18
    *   Region-Specific and Material-Specific Models 19
    *   Interface-Specific Models 20
    *   Electrode-Specific Models 21
*   Physical Model Parameters 22
    *   Search Strategy for Parameter Files 23
    *   Parameters for Composition-Dependent Materials 24
    *   Ternary Semiconductor Composition 26

<page_number>iii</page_number>

# Contents

Quaternary Semiconductor Composition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 28
Default Model Parameters for Compound Semiconductors. . . . . . . . . . . . . . . . . . 29
Combining Parameter Specifications. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 30
Materialwise Parameters. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 30
Regionwise Parameters. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 31
Material Interface–Wise Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 32
Region Interface–Wise Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 32
Electrode-Wise Parameters. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 32
Generating a Copy of Parameter File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 32
Undefined Physical Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 34
Default Parameters. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 35
Named Parameter Sets . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 36
Auto-Orientation Framework . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 38
Changing Orientations Used With Auto-Orientation . . . . . . . . . . . . . . . . . . . . . . . 38
Auto-Orientation Smoothing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 39
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 40

## Chapter 3 Mixed-Mode Simulations **41**

Overview of Mixed-Mode Simulations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 41
Compact Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 42
Hierarchical Description of Compact Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 42
User-Defined Compact Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 45
HSPICE Netlist Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 45
Structure of Netlist Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 45
Comments. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 46
Continuation Lines . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 46
The .INCLUDE Statement . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 46
Numeric Constants . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 46
Parameters and Expressions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 47
Subcircuits . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 48
The .MODEL Statement. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 48
Elements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 49
Netlist Commands . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 50
Specifying Physical Devices in Netlists . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 50
SPICE Circuit Files. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 51
Example . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 52
Command File for Mixed-Mode Simulations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 53
System Section. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 54
Physical Devices. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 55
Circuit Devices . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 56
Electrical and Thermal Netlists . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 56

<page_number>iv</page_number>

# Contents

Initializing Nodes ................................................................................................................. 58
Plotting Quantities ............................................................................................................... 59
Modifying Plot Output ................................................................................................... 60
Device Section ...................................................................................................................... 60
File Section .......................................................................................................................... 61
Math Section ........................................................................................................................ 62
Working With Mixed-Mode Simulations ................................................................................... 62
From Single-Device to Multidevice Command Files .......................................................... 62
File-Naming Conventions for Mixed Mode ........................................................................ 64

**Chapter 4 Performing Numeric Experiments** **67**
Specifying Electrical Boundary Conditions ............................................................................... 67
Changing Boundary Condition Type During Simulation ..................................................... 68
Mixed-Mode Electrical Boundary Conditions .................................................................... 69
Specifying Thermal Boundary Conditions ................................................................................. 70
Break Criteria: Conditionally Stopping the Simulation .............................................................. 71
Global Contact Break Criteria .......................................................................................... 72
Global Device Break Criteria ........................................................................................... 72
Sweep-Specific Break Criteria .......................................................................................... 73
Mixed-Mode Break Criteria ............................................................................................. 74
Quasistationary Ramps .......................................................................................................... 74
Ramping Boundary Conditions ........................................................................................ 75
Ramping Quasi-Fermi Potentials in Doping Wells ............................................................. 76
Ramping Physical Parameter Values ................................................................................. 79
Quasistationary in Mixed Mode ....................................................................................... 80
Saving and Plotting During a Quasistationary ................................................................... 82
Extrapolation ................................................................................................................... 82
Inside a Quasistationary Command ............................................................................ 83
Between Quasistationary Commands .......................................................................... 83
Parameters of the Extrapolate Statement .................................................................... 84
Continuation Command ......................................................................................................... 87
Continuation Control Parameters ...................................................................................... 87
Continuation in Mixed Mode ............................................................................................ 89
Transient Command .............................................................................................................. 90
Numeric Control of Transient Analysis ............................................................................. 91
Time-Stepping ................................................................................................................. 92
Ramping Physical Parameter Values ................................................................................. 94
Extrapolation ................................................................................................................... 95
Inside a Transient Command ...................................................................................... 95
Between Quasistationary Commands .......................................................................... 95
Transient Ramps .................................................................................................................... 96

<page_number>v</page_number>

# Contents

Large-Signal Cyclic Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 97
    Description of Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 98
    Using Cyclic Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 100
Small-Signal AC Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 101
    AC Analysis in Mixed-Mode Simulations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 101
        Example . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 103
    AC Analysis in Single-Device Mode. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 104
    Optical AC Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 105
Harmonic Balance. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 106
    Modes of Harmonic Balance Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 106
        MDFT Mode. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 107
        SDFT Mode . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 107
    Performing Harmonic Balance Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 107
        Solve Spectrum. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 108
        Convergence Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 109
    Harmonic Balance Analysis Output . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 110
        Circuit Currents and Voltages . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 110
        Solution Variables . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 111
        Output of Individual HBCoupled Statements. . . . . . . . . . . . . . . . . . . . . . . . . . . . 111
    Application Notes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 112
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 112

---

**Chapter 5 Simulation Results** **113**
    Current File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 113
        When to Write to the Current File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 113
            Example: CurrentPlot Statements. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 115
        NewCurrentPrefix Statement. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 116
        Tracking Additional Data in the Current File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 116
        CurrentPlot Section . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 117
            Example: Mixed Mode . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 119
            Example: Advanced Options . . . . . . . . . . . . . . . .; . . . . . . . . . . . . . . . . . . . . . . . 119
            Example: Plotting Parameter Values . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 120
        CurrentPlot Options . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 120
    Tcl Formulas . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 121
        Dataset Option . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 122
        Function Option . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 123
        Unit Option. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 123
        Init Option. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 123
        Formula Option. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 123
        Finish Option . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 124
        Operation Option . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 124

<page_number>vi</page_number>

# Contents

Examples . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 126
Device Plots . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 128
*   What to Plot . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 128
*   When to Plot . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 129
*   Snapshots . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 130
*   Interface Plots . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 131
*   Log File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 132
Extraction File. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 132
*   Extraction File Format . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 132
*   Analysis Modes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 134
*   File Section . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 135
*   Electrode Section . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 135
*   Extraction Section . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 135
*   Solve Section . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 136

**Chapter 6 Numeric and Software-Related Issues** **139**
*   Structure of Command File. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 139
    *   Inserting Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 139
*   Solve Section: How the Simulation Proceeds. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 140
*   Nonlinear Iterations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 141
    *   Coupled Statement. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 141
        *   Convergence and Error Control . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 143
        *   Damped Newton Iterations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 145
        *   Derivatives . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 146
        *   Incomplete Newton Algorithm. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 146
        *   Additional Equations Available in Mixed Mode . . . . . . . . . . . . . . . . . . . . . . . . . . 147
        *   Selecting Individual Devices in Mixed Mode . . . . . . . . . . . . . . . . . . . . . . . . . . . . 148
        *   Relaxed Newton Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 149
    *   Plugin Command . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 151
*   Linear Solvers . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 151
*   Nonlocal Meshes. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 152
    *   Specifying Nonlocal Meshes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 153
    *   Visualizing Nonlocal Meshes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 154
    *   Visualizing Data Defined on Nonlocal Meshes. . . . . . . . . . . . . . . . . . . . . . . . . . . . . 154
    *   Constructing Nonlocal Meshes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
        *   Specification Using Barrier . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 155
        *   Specification Using a Reference Surface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 156
    *   Special Handling of the 1D Schrödinger Equation . . . . . . . . . . . . . . . . . . . . . . . . . . 157
    *   Special Handling of the Nonlocal Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . 158
    *   Unnamed Meshes. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 158
    *   Performance Suggestions. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 159

<page_number>vii</page_number>

# Contents

Monitoring Convergence Behavior ................................................................................................. 159
- CNormPrint ................................................................................................................................. 160
- NewtonPlot ................................................................................................................................. 160
- Automatic Activation of CNormPrint and NewtonPlot ............................................................... 161
- Simulation Statistics for Plotting and Output ............................................................................. 162
  - Simulation Statistics in Current Plot Files ............................................................................. 162
  - Simulation Statistics in Design-of-Experiments Variables ................................................... 163
Save and Load Statements ................................................................................................................. 163
Tcl Command File ............................................................................................................................. 165
- Performing Device Simulations ................................................................................................... 165
- sdevice Command ....................................................................................................................... 168
- sdevice_init Command ................................................................................................................ 168
- sdevice_solve Command ............................................................................................................. 169
- sdevice_finish Command ............................................................................................................. 169
- sdevice_parameters Command ................................................................................................... 169
- Extracting Parameters ................................................................................................................. 169
  - Available Inspect Tcl Commands .......................................................................................... 170
- Redirecting Output ...................................................................................................................... 171
- Known Restrictions ..................................................................................................................... 171
Parallelization .................................................................................................................................... 172
Extended Precision ............................................................................................................................ 174
System Command .............................................................................................................................. 176
References .......................................................................................................................................... 176

# Part II Physics in Sentaurus Device 177

## Chapter 7 Poisson Equation and Quasi-Fermi Potentials 179
Electrostatic Potential ........................................................................................................................ 179
- Dipole Layer ............................................................................................................................... 180
- Equilibrium Solution ................................................................................................................... 181
Quasi-Fermi Potential With Boltzmann Statistics ............................................................................. 181
Fermi Statistics .................................................................................................................................. 182
- Using Fermi Statistics ................................................................................................................. 183
Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells ..................... 184
- Regionwise Specification of Initial Quasi-Fermi Potentials ....................................................... 185
Alternative Initial Guess for Quasi-Fermi Potentials From Linear Conduction Equation .......................................................................................................................................... 185
Electrode Charge Calculation ............................................................................................................ 187

<page_number>viii</page_number>

Contents

**Chapter 8 Carrier Transport Equations in Semiconductors** **189**
Introduction to Carrier Transport Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 189
Drift-Diffusion Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 190
Thermodynamic Model for Current Densities . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 191
Hydrodynamic Model for Current Densities . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 192
Numeric Parameters for Continuity Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 192
Numeric Approaches for Contact Current Computation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 193
Current Potential . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 193
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 195

**Chapter 9 Lattice and Carrier Temperature Equations** **197**
Introduction to Temperature Equations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 197
Uniform Self-Heating . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 198
Using Uniform Self-Heating . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 199
Default Model for Lattice Temperature . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 200
Thermodynamic Model for Lattice Temperature . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 201
Total Heat and Its Contributions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 201
Using the Thermodynamic Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 202
Hydrodynamic Model for Temperatures . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 204
Hydrodynamic Model Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 207
Using the Hydrodynamic Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 207
Numeric Parameters for Temperature Equations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 208
Validity Ranges for Lattice and Carrier Temperatures . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 208
Scaling of Lattice Heat Generation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 208
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 209

**Chapter 10 Boundary Conditions** **211**
Electrical Boundary Conditions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 211
Ohmic Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 211
Modified Ohmic Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 212
Contacts on Insulators . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 213
Schottky Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 214
Fermi-Level Pinning at Schottky Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 215
Barrier Lowering at Schottky Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 218
Resistive Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 223
Resistive Interfaces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 229
Boundaries Without Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 231
Application Notes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 232
Floating Contacts . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 232

<page_number>ix</page_number>

# Contents

Floating Metal Contacts.................................................................................................................................... 232
Floating Semiconductor Contacts .................................................................................................................... 234
Thermal Boundary Conditions .......................................................................................................................... 235
Boundary Conditions for Lattice Temperature ............................................................................................ 235
Boundary Conditions for Carrier Temperatures .......................................................................................... 237
Periodic Boundary Conditions .......................................................................................................................... 237
Robin PBC Approach ................................................................................................................................... 238
Mortar PBC Approach.................................................................................................................................. 238
Specifying Periodic Boundary Conditions .................................................................................................. 239
Specifying Robin Periodic Boundary Conditions ................................................................................... 239
Specifying Mortar Periodic Boundary Conditions.................................................................................. 240
Application Notes ........................................................................................................................................ 240
Specialized Linear Solver for MPBC....................................................................................................... 240
Discontinuous Interfaces.................................................................................................................................... 241
Representation of Physical Quantities Across Interfaces ............................................................................ 241
Interface Conditions at Discontinuous Interfaces ........................................................................................ 242
Critical Points .............................................................................................................................................. 242
References.......................................................................................................................................................... 242

---

**Chapter 11 Transport Equations in Metals, Organic Materials, and Disordered Media** **245**
Singlet Exciton Equation ................................................................................................................................... 245
Boundary and Continuity Conditions for Singlet Exciton Equation ............................................................ 246
Using the Singlet Exciton Equation............................................................................................................. 247
Transport in Metals............................................................................................................................................ 249
Electric Boundary Conditions for Metals .................................................................................................... 250
Metal Workfunction ..................................................................................................................................... 252
Metal Workfunction Randomization ....................................................................................................... 253
Temperature in Metals.................................................................................................................................. 254
Conductive Insulators ........................................................................................................................................ 254

---

**Chapter 12 Semiconductor Band Structure** **259**
Intrinsic Density ................................................................................................................................................ 259
Band Gap and Electron Affinity ....................................................................................................................... 259
Selecting the Bandgap Model ...................................................................................................................... 260
Bandgap and Electron-Affinity Models....................................................................................................... 260
Bandgap Narrowing for Bennett–Wilson Model .................................................................................... 261
Bandgap Narrowing for Slotboom Model ............................................................................................... 262
Bandgap Narrowing for del Alamo Model.............................................................................................. 262
Bandgap Narrowing for Jain–Roulston Model........................................................................................ 262

<page_number>x</page_number>

# Contents

Table Specification of Bandgap Narrowing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 264
Schenk Bandgap Narrowing Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 265
Bandgap Narrowing With Incomplete Ionization . . . . . . . . . . . . . . . . . . . . . . . . 269
Bandgap Narrowing With Fermi Statistics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 270
Bandgap Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 271
Effective Masses and Effective Density-of-States . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 272
Electron Effective Mass and Density-of-States . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 273
Formula=1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 273
Formula=2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 273
Electron Effective Mass and Conduction Band DOS Parameters . . . . . . . . . . . . . . . 274
Hole Effective Mass and Density-of-States . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 274
Formula=1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 274
Formula=2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 275
Hole Effective Mass and Valence Band DOS Parameters . . . . . . . . . . . . . . . . . . . . 275
Gaussian Density-of-States for Organic Semiconductors . . . . . . . . . . . . . . . . . . . . . . . . 276
Band Tails . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 279
Multivalley Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 281
Nonparabolic Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 282
Bandgap Widening . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 283
Monte Carlo Density-of-States . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 283
Non-Three-Dimensional Density-of-States . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 284
Using Multivalley Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 285
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 290

---

**Chapter 13 Incomplete Ionization** **293**
Considering Incomplete Ionization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 293
Using the Incomplete Ionization Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 293
Incomplete Ionization Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 294
Physical Model Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 296
Multiple Lattice Sites . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 299
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 300

---

**Chapter 14 Quantization** **303**
Modeling Quantization Effects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 303
The van Dort Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 304
Using the van Dort Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 305
1D Schrödinger Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 305
Nonlocal Mesh for the 1D Schrödinger Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . 306
Using the 1D Schrödinger Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 307
Parameters of the 1D Schrödinger Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 307

<page_number>xi</page_number>

# Contents

Explicitly Specifying Ladders . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 308
Automatically Extracting Ladder Parameters. . . . . . . . . . . . . . . . . . . . . . . . . . . . 308
Visualizing the Solutions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 310
1D Schrödinger Equation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 310
Notes on the Use of the 1D Schrödinger Equation . . . . . . . . . . . . . . . . . . . . . . . . . . 311
External 2D Schrödinger Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 312
Notes on the Use of External 2D Schrödinger Solvers . . . . . . . . . . . . . . . . . . . . . . . 314
External Boltzmann Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 314
Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 316
Using the Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 318
Named Parameter Sets for the Density Gradient Model . . . . . . . . . . . . . . . . . . . 321
Auto-Orientation for the Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . 322
Notes on the Use of the Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . . . . 322
Modified Local-Density Approximation Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 324
Interface Orientation and Stress Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 325
Heterojunctions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 326
Nonparabolic Bands and Geometric Quantization . . . . . . . . . . . . . . . . . . . . . . . . . . 327
Using the MLDA Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 328
Notes on the Use of the MLDA Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 332
Quantum-Well Quantization Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 332
Extracting Layer Thickness . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 333
Combining the LayerThickness Command and ThinLayer Subcommand . . . . . . . . 334
Geometric Parameters of the LayerThickness Command . . . . . . . . . . . . . . . . . . . . . 335
Thickness Extraction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 336
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 338

---

# Chapter 15 Mobility 341
Introduction to Mobility Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 341
Combining Mobility Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 341
Mobility due to Phonon Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 342
Doping-Dependent Mobility Degradation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 342
Using Doping-Dependent Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 343
Using More Than One Doping-Dependent Mobility Model . . . . . . . . . . . . . . . . 344
Masetti Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 344
Arora Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 345
University of Bologna Bulk Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 346
The pmi_msc_mobility Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 348
PMIs for Bulk Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 349
Low-Field Ballistic Mobility Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 349
Simple Channel Length–Dependent Ballistic Mobility Model . . . . . . . . . . . . . . 349
Injection Velocity–Dependent Ballistic Mobility Model . . . . . . . . . . . . . . . . . . . 350

<page_number>xii</page_number>

# Contents

Carrier–Carrier Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 351
    Using Carrier–Carrier Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 351
    Conwell–Weisskopf Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 352
    Brooks–Herring Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 352
    Physical Model Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 352
Philips Unified Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 353
    Using the Philips Unified Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 353
    Using an Alternative Philips Unified Mobility Model . . . . . . . . . . . . . . . . . . . . . . . 354
    Description of the Philips Unified Mobility Model. . . . . . . . . . . . . . . . . . . . . . . . . . 354
    Screening Parameter . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 356
    Philips Model Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 356
Mobility Degradation at Interfaces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 357
    Using Mobility Degradation at Interfaces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 357
    Enhanced Lombardi Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 359
        Stress Factors for Mobility Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 361
        Named Parameter Sets for the Lombardi Model . . . . . . . . . . . . . . . . . . . . . . . . . 361
        Auto-Orientation for the Lombardi Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 362
    Inversion and Accumulation Layer Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . 362
        Coulomb Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 362
        Phonon Scattering. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 365
        Surface Roughness Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 365
        Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 366
        Stress Factors for Mobility Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 368
        Using the Inversion and Accumulation Layer Mobility Model . . . . . . . . . . . . . . 369
        Named Parameter Sets for the IALMob Model . . . . . . . . . . . . . . . . . . . . . . . . . . 369
        Auto-Orientation for the IALMob Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 370
    University of Bologna Surface Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . 370
    Mobility Degradation Components due to Coulomb Scattering . . . . . . . . . . . . . . . . 372
        Stress Factors for Mobility Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 374
        Using Mobility Degradation Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 375
    Remote Coulomb Scattering Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 376
        Stress Factors for Mobility Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 378
    Remote Phonon Scattering Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 378
        Stress Factors for Mobility Components . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 379
    Computing Transverse Field . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 380
        Normal to the Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 380
        Normal to the Current Flow . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 381
        Field Correction on Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 381
Thin-Layer Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 381
    Using the Thin-Layer Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 383
    Physical Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 383

<page_number>xiii</page_number>

# Contents

Stress Factors for Mobility Components ................................................................................. 385
Auto-Orientation and Named Parameter Sets ................................................................... 386
Geometric Parameters....................................................................................................... 386
High-Field Saturation Models................................................................................................... 387
Using High-Field Saturation Models................................................................................ 387
Named Parameter Sets for the High-Field Saturation Models ................................. 388
Auto-Orientation for the High-Field Saturation Models .......................................... 388
Extended Canali Model ..................................................................................................... 388
Transferred Electron Model............................................................................................... 390
Transferred Electron Model 2 ........................................................................................... 390
Multivalley Transferred Electron Mobility ....................................................................... 392
Basic Model....................................................................................................................... 392
Meinerzhagen–Engl Model ............................................................................................... 393
Physical Model Interfaces ................................................................................................. 393
Lucent Model..................................................................................................................... 394
Velocity Saturation Models ............................................................................................... 394
Selecting Velocity Saturation Models ....................................................................... 394
Driving Force Models ....................................................................................................... 395
Electric Field Parallel to the Current ......................................................................... 395
Gradient of Quasi-Fermi Potential ............................................................................ 396
Electric Field Parallel to the Interface ....................................................................... 396
Hydrodynamic Driving Force.................................................................................... 398
Electric Field.............................................................................................................. 398
Interpolation of Driving Forces to Zero Field ........................................................... 398
Interpolation of the GradQuasiFermi Driving Force ................................................ 399
Interpolation of the Eparallel Driving Force ............................................................. 400
Field Correction Close to Interfaces.......................................................................... 400
Non-Einstein Diffusivity ................................................................................................... 401
High-Field Saturation Mobility Scaling ........................................................................... 402
Ballistic Mobility Model........................................................................................................... 403
Channel Length–Dependent Model.................................................................................. 403
Kinetic Velocity Model ..................................................................................................... 404
Fermi–Dirac Statistics ....................................................................................................... 404
Frensley Rule..................................................................................................................... 405
Using the Ballistic Mobility Model .................................................................................. 405
Using the PMI Fitting Parameter in the Ballistic Mobility Model ................................... 406
General Model for Mobility Degradation by Traps in the Bulk and at Semiconductor
Interfaces ................................................................................................................... 407
Incomplete Ionization–Dependent Mobility Models ............................................................... 408
Poole–Frenkel Mobility (Organic Material Mobility) .............................................................. 409
Mobility Averaging................................................................................................................... 410
Mobility Doping File ................................................................................................................ 411

<page_number>xiv</page_number>

# Contents

Effective Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 411
    EffectiveMobility PMI Methods . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 413
    Using the EffectiveMobility PMI . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 413
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 415

**Chapter 16 Generation–Recombination** . . . . . . . . . . . . . . . . . . . . **419**
    Shockley–Read–Hall Recombination . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 419
        Using SRH Recombination . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 420
        SRH Doping Dependence . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 420
        Lifetime Profiles From Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 421
        Improved Nakagawa Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 421
        SRH Temperature Dependence . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 422
        SRH Doping- and Temperature-Dependent Parameters . . . . . . . . . . . . . . . . . . . . . . 423
        SRH Field Enhancement . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 424
            Using Field Enhancement. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 424
            Schenk Trap-Assisted Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 425
            Hurkx Trap-Assisted Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 426
            Density Correction for the Schenk and Hurkx Trap-Assisted Tunneling Models 427
        Dynamic Nonlocal Path Trap-Assisted Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . 428
            Recombination Rate . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 428
            Using the Dynamic Nonlocal Path Trap-Assisted Tunneling Model. . . . . . . . . . 430
        Trap-Assisted Auger Recombination Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 431
    Surface SRH Recombination Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 432
    Coupled Defect Level Recombination . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 433
        Using Coupled Defect Level Recombination . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 435
    Radiative Recombination Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 435
        Using the Radiative Recombination Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 435
    Auger Recombination Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 436
        Using the Auger Recombination Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 437
    Intrinsic Recombination Model for Silicon . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 437
    Constant Carrier Generation Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 440
    Avalanche Generation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 441
        Using Avalanche Generation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 441
        van Overstraeten – de Man Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 444
        Okuto–Crowell Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 445
        Lackner Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 446
        University of Bologna Impact Ionization Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . 447
        New University of Bologna Impact Ionization Model . . . . . . . . . . . . . . . . . . . . . . . 449
        Hatakeyama Avalanche Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 451
            Driving Force of Hatakeyama Avalanche Model. . . . . . . . . . . . . . . . . . . . . . . . . 452
            Default Anisotropic Coordinate System. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 453

<page_number>xv</page_number>

# Contents

Specification of Anisotropic Direction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 453
Driving Force . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 455
Interpolation of Avalanche Driving Forces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 455
Avalanche Generation With Hydrodynamic Transport . . . . . . . . . . . . . . . . . . . . . . 456
Approximate Breakdown Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 457
Using Breakdown Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 458
Stopping Criteria for Breakdown Simulations . . . . . . . . . . . . . . . . . . . . . . . . . . . 461
Visualizing Breakdown Paths . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 461
Typical Command File of Sentaurus Device . . . . . . . . . . . . . . . . . . . . . . . . . . . . 462
Approximate Breakdown Analysis With Carriers . . . . . . . . . . . . . . . . . . . . . . . . . . . 463
Using GradQuasiFermi as a Driving Force . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 464
Avalanche Breakdown Probability . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 464
Using Avalanche Breakdown Probability . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 465
High-Field Entrance Position and Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 466
Using High-Field Entrance Position and Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 466
Visualization in TDR Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 467
Save Volume Dataset in Existing TDR File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 467
Save Carrier Paths as 1D Datasets in Separate TDR File . . . . . . . . . . . . . . . . . . . 468
Band-to-Band Tunneling Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 469
Using Band-to-Band Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 469
Tunneling Near Interfaces and Equilibrium Regions . . . . . . . . . . . . . . . . . . . . . . 471
Schenk Band-to-Band Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 471
Schenk Density Correction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 472
Hurkx Band-to-Band Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 473
Modified Hurkx Band-to-Band Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . 474
Simple Band-to-Band Tunneling Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 475
Dynamic Nonlocal Path Band-to-Band Tunneling Model . . . . . . . . . . . . . . . . . . . . 475
Band-to-Band Generation Rate . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 476
Using the Nonlocal Path Band-to-Band Tunneling Model . . . . . . . . . . . . . . . . . 479
Handling Derivatives . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 481
Tunneling Parameters From the Physical Model Interface . . . . . . . . . . . . . . . . . 482
Energy Shift due to Geometric Confinement . . . . . . . . . . . . . . . . . . . . . . . . . . . . 482
Postprocessing Mode . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 483
Frozen Tunneling Direction . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 483
Visualizing Nonlocal Band-to-Band Generation Rate . . . . . . . . . . . . . . . . . . . . . 484
Bimolecular Recombination Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 484
Using the Bimolecular Recombination Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 484
Exciton Dissociation Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 485
Using the Exciton Dissociation Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 485
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 486

<page_number>xvi</page_number>

Contents

**Chapter 17 Traps and Fixed Charges** **489**
Introduction to Traps 489
- Syntax for Traps 489
- Trap Types 490
- Energetic and Spatial Distribution of Traps 490
- Specifying Single Traps 494
- Trap Randomization 495
- Explicit Trap Occupation 496
- Options to Include Traps in Doping 498
- Trap Examples 498
Trap Models 499
- Trap Occupation Dynamics 499
- Local Capture and Emission Rates 501
- J-Model for Cross Sections 502
- Hurkx Model for Cross Sections 503
- Poole–Frenkel Model for Cross Sections 503
- Makram-Ebeid–Lannoo Model 504
- Local Capture and Emission Rates From PMI 506
- Trap-to-Trap Tunneling (DiscreteTrapT2T) 506
- Mode Oscillator Model 512
- Inelastic Phonon Model 513
- Trap-to-Trap Recombination 516
- Trap-to-Trap Flux of InelasticPhonon Model 517
- Nonlocal Tunneling for Traps 517
- Electron Capture Rate for the Phonon-Assisted Transition 518
- Electron Capture Rate for the Elastic Transition 519
Numeric Parameters for Traps 520
Visualizing Traps 520
Insulator Fixed Charges 524
References 524

**Chapter 18 Phase and State Transitions** **527**
Multistate Configurations and Their Dynamic 527
Specifying Multistate Configurations 529
- Multistate Configurations on Interfaces 529
- Additional Remarks 530
Transition Models 531
- The pmi_ce_msc Model 531
- States 531
- Transitions 532

<page_number>xvii</page_number>

# Contents

Model Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 535
Interaction of Multistate Configurations With Transport . . . . . . . . . . . . . . . . . . . . . . . . 537
    Apparent Band-Edge Shift. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 537
        The pmi_msc_abes Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 538
    Thermal Conductivity, Heat Capacity, and Mobility . . . . . . . . . . . . . . . . . . . . . . . . 539
Manipulating MSCs During Solve . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 539
    Explicit State Occupations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 540
    Manipulating Transition Dynamics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 541
Example: Two-State Phase-Change Memory Model . . . . . . . . . . . . . . . . . . . . . . . . . . . 541
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 542

**Chapter 19 Degradation** **543**
    Overview of Degradation Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 543
    Trap Degradation Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 544
        Trap Formation Kinetics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 544
            Power Law and Kinetic Equation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 544
            Si-H Density–Dependent Activation Energy . . . . . . . . . . . . . . . . . . . . . . . . . . . . 545
            Diffusion of Hydrogen in Oxide. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 546
        Model Equations and Syntax . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 546
            Reaction Enhancement Factors . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 548
            Using the Trap Degradation Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 549
    Device Lifetime and Simulation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 550
    Degradation in Insulators. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 553
Fluence Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 554
MSC–Hydrogen Transport Degradation Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 555
    Hydrogen Transport. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 555
        Boundary Conditions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 557
    Reactions Between Mobile Elements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 557
    Reactions With Multistate Configurations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 559
    The CEModel_Depassivation Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 560
    Using MSC–Hydrogen Transport Degradation Model . . . . . . . . . . . . . . . . . . . . . . . 562
        Changing Charge and Hydrogen Composition of Species . . . . . . . . . . . . . . . . . . 564
Two-Stage NBTI Degradation Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 564
    Formulation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 565
    Using Two-Stage NBTI Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 568
Extended Nonradiative Multiphonon Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 569
    eNMP Model Description . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 569
    Using the eNMP Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 572
        eNMP Quantities Available for Plotting . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 572
        eNMP Model Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 573
        eNMP Transition Rates PMI Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 574

<page_number>xviii</page_number>

# Contents

Hot-Carrier Stress Degradation Model 575
- Model Description 575
    - Single-Particle and Multiple-Particle Interface-Trap Densities 575
    - Field-Enhanced Thermal Degradation 577
    - Carrier Distribution Function 578
    - Bond Dispersion 579
- Using the HCS Degradation Model 580
Activated Barrier Double Well Thermionic Model 582
- Model Description 582
- Using the ABDWT Model 583
Transient Trap Occupancy Model 585
- Model Description 585
- Using the Transient Trap Occupancy Model 586
References 587

**Chapter 20 Organic Devices** **589**
- Introduction to Organic Device Simulation 589
- References 590

**Chapter 21 Optical Generation** **593**
- Overview of Optical Generation 593
- Specifying the Type of Optical Generation Computation 594
    - Optical Generation From Monochromatic Source 596
    - Illumination Spectrum 596
        - Multidimensional Illumination Spectra 597
        - Enhanced Spectrum Control 598
    - Loading and Saving Optical Generation From and to Files 601
- Constant Optical Generation 602
- Quantum Yield Models 603
    - Optical Absorption Heat 605
- Specifying Time Dependency for Transient Simulations 606
    - Optical Turning Points 612
- Solving the Optical Problem 613
    - Specifying the Optical Solver 614
        - Transfer Matrix Method 614
        - Finite-Difference Time-Domain Method 615
        - Raytracing 616
        - Beam Propagation Method 618
    - Loading Solution of Optical Problem From File 618
    - Optical Beam Absorption Method 619

<page_number>xix</page_number>

# Contents

Composite Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 619
Setting the Excitation Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 620
    Illumination Window . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 622
    Spatial Intensity Function Excitation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 630
Choosing Refractive Index Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 632
Extracting the Layer Stack. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 632
    Controlling Computation of Optical Problem in Solve Section . . . . . . . . . . . . . . . . 634
Parameter Ramping. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 635
Accurate Absorbed Photon Density for 1D Optical Solvers. . . . . . . . . . . . . . . . . . . . . . 637
Complex Refractive Index Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 640
    Physical Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 640
        Wavelength Dependency . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 641
        Temperature Dependency. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 641
        Carrier Dependency . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 641
        Gain Dependency . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 643
    Using Complex Refractive Index . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 643
Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 648
    Raytracer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 648
    Ray Photon Absorption and Optical Generation . . . . . . . . . . . . . . . . . . . . . . . . . . . . 651
    Using the Raytracer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 651
    Terminating Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 653
    Monte Carlo Raytracing. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 653
    Multithreading for Raytracer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 654
    Compact Memory Model for Raytracer. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 655
    Window of Starting Rays. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 655
        User-Defined Window of Rays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 656
        Distribution Window of Rays. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 657
    Cylindrical Coordinates for Raytracing. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 658
    Boundary Condition for Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 660
        Fresnel Boundary Condition. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 661
        Constant Reflectivity and Transmittivity Boundary Condition . . . . . . . . . . . . . . 661
        Raytrace PMI Boundary Condition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 662
        Thin-Layer-Stack Boundary Condition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 663
        TMM Optical Generation in Raytracer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 664
        Diffuse Surface Boundary Condition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 666
        Periodic Boundary Condition . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 669
    Virtual Regions in Raytracer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 669
    External Material in Raytracer. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 670
    Additional Options for Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 670
    Redistributing Power of Stopped Rays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 671
    Weighted Interpolation for Raytrace Optical Generation . . . . . . . . . . . . . . . . . . . . . 672

<page_number>xx</page_number>

Contents

Visualizing Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 672
Reporting Various Powers in Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 672
Plotting Interface Flux . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 673
Far Field and Sensors for Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 675
Dual-Grid Setup for Raytracing. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 678
Transfer Matrix Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 680
Physical Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 680
Rough Surface Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 682
Using Transfer Matrix Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 685
Using Scattering Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 687
Loading Solution of Optical Problem From Files. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 695
Importing 1D Profiles Into Higher-Dimensional Grids. . . . . . . . . . . . . . . . . . . . . . . 697
Ramping Profile Index. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 698
Optical Beam Absorption Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 699
Physical Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 699
Using Optical Beam Absorption Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 701
Beam Propagation Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 702
Physical Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 702
Bidirectional BPM . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 703
Boundary Conditions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 703
Using Beam Propagation Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 704
General . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 704
Bidirectional BPM . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 705
Excitation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 706
Boundary . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 709
Ramping Input Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 709
Visualizing Results on Native Tensor Grid . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 710
Composite Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 711
Using the Composite Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 711
Controlling Interpolation When Loading Optical Generation Profiles. . . . . . . . . . . . . . 714
Optical AC Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 716
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 717

**Chapter 22 Radiation** **719**
Carrier Generation by Gamma Radiation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 719
Yield Function . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 720
Carrier Generation by Alpha Particles . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 720
Using the Alpha Particle Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 721
Carrier Generation by Heavy Ions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 722
Using the Heavy Ion Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 723
Examples: Heavy Ions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 725

<page_number>xxi</page_number>

# Contents

Example 1 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 725
Example 2 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 726
Example 3 . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 726
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 727

**Chapter 23 Noise, Fluctuations, and Sensitivity** **729**
Using the Impedance Field Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 729
Specifying Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 730
Specifying the Solver. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 731
Analysis at Frequency Zero . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 731
Output of Results . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 732
Noise Sources . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 734
Common Options. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 734
Diffusion Noise . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 735
Equivalent Monopolar Generation–Recombination Noise . . . . . . . . . . . . . . . . . . . . 736
Bulk Flicker Noise . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 736
Trapping Noise . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 736
Random Dopant Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 737
Random Geometric Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 738
Random Trap Concentration Fluctuations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 741
Random Workfunction Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 741
Random Band Edge Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 742
Random Metal Conductivity Fluctuations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 743
Random Dielectric Constant Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 744
Noise From SPICE Circuit Elements. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 744
Statistical Impedance Field Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 745
Options Common to sIFM Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 746
Spatial Correlations and Random Fields . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 747
Doping Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 749
Trap Concentration Variations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 750
Workfunction Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 751
Geometric Variations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 752
Band Edge Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 753
Metal Conductivity Variations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 754
Dielectric Constant Variations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 755
Doping Profile Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 756
Deterministic Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 757
Deterministic Doping Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 757
Deterministic Geometric Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 759
Parameter Variations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 760
IFM Section. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 761

<page_number>xxii</page_number>

# Contents

Impedance Field Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 762
Noise Output Data. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 764
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 766

**Chapter 24 Tunneling** **767**
    Overview of Tunneling Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 767
    Fowler–Nordheim Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 768
        Using Fowler–Nordheim . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 768
        Fowler–Nordheim Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 769
        Fowler–Nordheim Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 770
    Direct Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 770
        Using Direct Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 771
        Direct Tunneling Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 771
            Image Force Effect . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 772
        Direct Tunneling Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 773
    Nonlocal Tunneling at Interfaces, Contacts, and Junctions . . . . . . . . . . . . . . . . . . . . . . 774
        Defining Nonlocal Meshes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 774
        Specifying Nonlocal Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 776
        Nonlocal Tunneling Parameters. . . . . . . . . . . . . . .; . . . . . . . . . . . . . . . . . . . . . . . . . 778
        Visualizing Nonlocal Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 780
        Physics of Nonlocal Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 781
            WKB Tunneling Probability. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 781
            Schrödinger Equation–Based Tunneling Probability . . . . . . . . . . . . . . . . . . . . . . 784
            Density Gradient Quantization Correction. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 785
            Multivalley Band Structure and Geometric Quantization . . . . . . . . . . . . . . . . . . 785
            Nonlocal Tunneling Current. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 787
                Band-to-Band Contributions to Nonlocal Tunneling Current . . . . . . . . . . . . . . . 788
            Carrier Heating . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 789
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 790

**Chapter 25 Hot-Carrier Injection** **793**
    Overview of Hot-Carrier Injection Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 793
        Destination of Injected Current . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 794
        Injection Barrier and Image Potential . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 796
        Effective Field . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 798
    Classical Lucky Electron Injection . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 798
    Fiegna Hot-Carrier Injection. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 799
    SHE Distribution Hot-Carrier Injection . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 801
        Spherical Harmonics Expansion Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 802
        Using Spherical Harmonics Expansion Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . 806

xxiii
<page_number>xxiii</page_number>

# Contents

Visualizing Spherical Harmonics Expansion Method . . . . . . . . . . . . . . . . . . . . . . . . 814
Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity
Equations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 815
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 817

**Chapter 26 Heterostructure Device Simulation** **819**
Thermionic Emission Current. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 819
Using Thermionic Emission Current . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 819
Thermionic Emission Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 820
Thermionic Emission Model With Fermi Statistics . . . . . . . . . . . . . . . . . . . . . . . . . 821
Gaussian Transport Across Organic Heterointerfaces . . . . . . . . . . . . . . . . . . . . . . . . . . 822
Using Gaussian Transport at Organic Heterointerfaces . . . . . . . . . . . . . . . . . . . . . . 822
Gaussian Transport at Organic Heterointerface Model . . . . . . . . . . . . . . . . . . . . . . . 823
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 824

**Chapter 27 Energy-Dependent Parameters** **825**
Overview. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 825
Energy-Dependent Energy Relaxation Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 825
Spline Interpolation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 827
Energy-Dependent Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 828
Spline Interpolation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 829
Energy-Dependent Peltier Coefficient . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 830
Spline Interpolation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 832

**Chapter 28 Anisotropic Properties** **833**
Anisotropic Properties of Semiconductor Devices . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 833
Anisotropic Approximations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 834
TensorGridAniso . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 834
AnisoSG . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 834
StressSG . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 835
AverageAniso . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 835
Crystal and Simulation Coordinate Systems. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 836
Cylindrical Symmetry . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 837
Anisotropic Direction in 3D Cases . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 837
Anisotropic Direction in 2D Cases . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 838
Aniso Subsection With Direction Definition . . . . . . . . . . . . . . . . . . . . . . . . . . . . 838
Aniso Subsection Without Direction Definition . . . . . . . . . . . . . . . . . . . . . . . . . . . . 839
Aniso(direction) Versus LatticeParameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 840
Orthogonal Matrix From Eigenvectors Q . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 841

xxiv

# Contents

Anisotropic Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 842
- Anisotropy Factor . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 842
- Current Densities . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 842
- Driving Forces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 844
- Total Anisotropic Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 845
- Self-Consistent Anisotropic Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 846
- Anisotropic Mobility Visualization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 847
Anisotropic Metal Resistivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 848
- Total Anisotropic Metal Resistivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 848
Anisotropic Avalanche Generation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 848
Anisotropic Electrical Permittivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 850
Anisotropic Thermal Conductivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 851
Anisotropic Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 852
- Anisotropic Directions for Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . 852

**Chapter 29 Ferroelectric Materials** **855**
- Using Ferroelectrics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 855
- Ferroelectrics Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 858
- Ginzburg–Landau–Khalatnikov Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 860
  - Using the Ginzburg–Landau–Khalatnikov Equation . . . . . . . . . . . . . . . . . . . . . . . . 862
  - Versions of the Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 865
    - Default . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 865
    - Multidimensional . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 866
    - Solver II . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 867
  - Bitlis Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 868
- References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 870

**Chapter 30 Ferromagnetism and Spin Transport** **871**
- Brief Introduction to Spintronics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 871
- Transport Through Magnetic Tunnel Junctions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 872
  - Magnetic Direct Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 872
  - Using the Magnetic Direct Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 873
  - Physics Parameters for Magnetic Direct Tunneling . . . . . . . . . . . . . . . . . . . . . . . . 873
  - Math Parameters for Magnetic Direct Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . 874
- Magnetization Dynamics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 875
  - Spin Dynamics of a Free Electron in a Magnetic Field . . . . . . . . . . . . . . . . . . . . . . 875
  - Magnetization Dynamics in a Ferromagnetic Layer . . . . . . . . . . . . . . . . . . . . . . . . 876
  - Contributions of the Magnetic Energy Density . . . . . . . . . . . . . . . . . . . . . . . . . . . . 877
  - Energy Density and Effective Field in Macrospin Approximation . . . . . . . . . . . . . . 878
  - Using Magnetization Dynamics in Device Simulations . . . . . . . . . . . . . . . . . . . . . . 879

<page_number>xxv</page_number>

# Contents

Domain Selection and Initial Conditions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 879
Plotting Time-Dependent Magnetization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 880
Parameters for Magnetization Dynamics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 880
Time-Step Control for Magnetization Dynamics . . . . . . . . . . . . . . . . . . . . . . . . . . . 881
Thermal Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 881
Using Thermal Fluctuations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 881
Parallel and Perpendicular Spin Transfer Torque . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 882
Magnetization Dynamics Beyond Macrospin: Position-Dependent Exchange and Spin
Waves . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 882
Using Position-Dependent Exchange . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 883
User-Defined Contributions to Effective Magnetic Field of LLG Equation . . . . . . . . . 884
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 884

**Chapter 31 Mechanical Stress** **885**
Overview of Mechanical Stress . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 885
Stress and Strain in Semiconductors . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 885
Using Stress and Strain . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 887
Stress Tensor . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 888
Strain Tensor . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 888
Stress Limits . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 889
Crystallographic Orientation and Compliance Coefficients . . . . . . . . . . . . . . . . . 889
Deformation of Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 890
Using Deformation Potential Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 893
Strained Effective Masses and Density-of-States . . . . . . . . . . . . . . . . . . . . . . . . . . . 895
Strained Electron Effective Mass and DOS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 895
Strained Hole Effective Mass and DOS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 897
Using Strained Effective Masses and DOS . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 898
Multivalley Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 899
Using Multivalley Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 901
Mobility Modeling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 902
Multivalley Electron Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 903
Intervalley Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 904
Effective Mass . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 906
Inversion Layer . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 908
Using Multivalley Electron Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . 910
Multivalley Hole Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 913
Effective Mass . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 913
Scattering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 914
Using Multivalley Hole Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 916
Multivalley Ballistic Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 918
Using Multivalley Ballistic Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . 919

<page_number>xxvi</page_number>

# Contents

Multivalley Transferred Carrier Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . 920
    Using Multivalley Transferred Carrier Mobility Model. . . . . . . . . . . . . . . . . . . . 921
Intel Stress-Induced Hole Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 921
    Stress Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 922
    Generalization of Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 923
    Using Intel Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 925
Piezoresistance Mobility Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 926
    Doping and Temperature Dependency . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 928
    Using Piezoresistance Mobility Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 929
    Named Parameter Sets for Piezoresistance . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 930
    Auto-Orientation for Piezoresistance . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 930
    Enormal- and MoleFraction-Dependent Piezo Coefficients . . . . . . . . . . . . . . . . 931
    Using Piezoresistive Prefactors Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 931
Isotropic Factor Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 937
    Using Isotropic Factor Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 938
    Piezoresistance Factor Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 939
    Effective Stress Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 939
    Mobility Stress Factor PMI Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 942
    SFactor Dataset or PMI Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 943
    Isotropic Factor Model Options . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 943
    Factor Models Applied to Mobility Components. . . . . . . . . . . . . . . . . . . . . . . . . 943
Stress Mobility Model for Minority Carriers. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 944
Dependency of Saturation Velocity on Stress . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 946
Mobility Enhancement Limits . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 947
    Plotting Mobility Enhancement Factors . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 948
Numeric Approximations for Tensor Mobility. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 948
    Tensor Grid Option . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 948
    Stress Tensor Applied to Low-Field Mobility. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 949
Piezoelectric Polarization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 950
    Strain Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 950
        Simplified Strain Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 951
    Stress Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 951
    Poisson Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 952
    Parameter File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 953
    Coordinate Systems . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 954
    Converse Piezoelectric Field . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 954
    Piezoelectric Datasets . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 955
        Discontinuous Piezoelectric Charge at Heterointerfaces . . . . . . . . . . . . . . . . . . . 955
    Gate-Dependent Polarization in GaN Devices . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 955
        Two-Dimensional Simulations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 956
Mechanics Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 957

<page_number>xxvii</page_number>

Contents

Options for the Stress Solver . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 958
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 961

# Chapter 32 Galvanic Transport 965
Model Description. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 965
Using Galvanic Transport Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 965
Discretization Scheme for Continuity Equations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 966
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 966

# Chapter 33 Thermal Properties 967
Heat Capacity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 967
The pmi_msc_heatcapacity Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 968
Thermal Conductivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 969
The AllDependent Thermal Conductivity Model . . . . . . . . . . . . . . . . . . . . . . . . . . . 970
Bulk Thermal Conductivity Computation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 971
Bulk Relaxation Time With Doping. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 973
Thin-Layer Relaxation Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 976
Mole Fraction–Dependent Relaxation Time . . . . . . . . . . . . . . . . . . . . . . . . . . . . 977
The ConnellyThermalConductivity Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 978
Layer Thickness Computation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 979
Bulk Thermal Conductivity Computation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 979
The pmi_msc_thermalconductivity Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 980
Thermoelectric Power . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 981
Physical Models. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 981
Table-Based TEPower Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 981
Analytic TEPower Model. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 982
PMI_ThermoElectricPower Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 982
Thermoelectric Power in Metals. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 983
Using Thermoelectric Power . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 983
Heating at Contacts, Metal–Semiconductor and Conductive Insulator–Semiconductor
Interfaces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 984
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 985

# Chapter 34 Light-Emitting Diodes 987
Modeling Light-Emitting Diodes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 987
Coupling Electronics and Optics in LED Simulations . . . . . . . . . . . . . . . . . . . . . . . . . . 988
Single-Grid Versus Dual-Grid LED Simulation . . . . . . . . . . . . . . . . . . . . . . . . . . . . 988
Electrical Transport in Light-Emitting Diodes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 989
Spontaneous Emission Rate and Power. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 989

<page_number>xxviii</page_number>

# Contents

Spontaneous Emission Power Spectrum . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 990
Current File and Plot Variables for LED Simulations. . . . . . . . . . . . . . . . . . . . . . . . 991
LED Wavelength . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 993
Optical Absorption Heat . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 994
Quantum Well Physics. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 995
Accelerating Gain Calculations and LED Simulations . . . . . . . . . . . . . . . . . . . . . . . 996
Discussion of LED Physics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 996
LED Optics: Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 997
Compact Memory Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 998
Isotropic Starting Rays From Spontaneous Emission Sources . . . . . . . . . . . . . . . . . 998
Anisotropic Starting Rays From Spontaneous Emission Sources . . . . . . . . . . . . . . . 999
Randomizing Starting Rays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1000
Pseudorandom Starting Rays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1001
Reading Starting Rays From File. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1001
Moving Starting Rays on Boundaries . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1002
Clustering Active Vertices. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1002
Plane Area Cluster . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1003
Nodal Clustering. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1004
Optical Grid Element Clustering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1004
Using the Clustering Feature . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1004
Debugging Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1005
Print Options in Raytracing . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1006
Interfacing LED Starting Rays to LightTools . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1007
Example: n99_000000_des_lighttools.txt File. . . . . . . . . . . . . . . . . . . . . . . . . . 1008
LED Radiation Pattern . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1009
Two-Dimensional LED Radiation Pattern and Output Files . . . . . . . . . . . . . . . . . . 1011
Three-Dimensional LED Radiation Pattern and Output Files . . . . . . . . . . . . . . . . . 1012
Staggered 3D Grid LED Radiation Pattern . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1012
Spectrum-Dependent LED Radiation Pattern . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1014
Tracing Source of Output Rays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1015
Interfacing Far-Field Rays to LightTools . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1016
Example: farfield_lighttools.txt File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1017
Nonactive Region Absorption (Photon Recycling) . . . . . . . . . . . . . . . . . . . . . . . . . . . 1018
Device Physics and Tuning Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1018
Example of 3D GaN LED Simulation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1019
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1025

# Chapter 35 Quantum Wells 1027

Overview. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1027
Radiative Recombination and Gain Coefficients . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1028
Stimulated and Spontaneous Emission Coefficients . . . . . . . . . . . . . . . . . . . . . . . . 1028

<page_number>xxix</page_number>

# Contents

Active Bulk Material Gain . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1030
- Stimulated Recombination Rate . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1030
- Spontaneous Recombination Rate . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1031
- Fitting Stimulated and Spontaneous Emission Spectra . . . . . . . . . . . . . . . . . . . . . . 1031
Gain-Broadening Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1031
- Lorentzian Broadening . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1031
- Landsberg Broadening . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1032
- Hyperbolic-Cosine Broadening . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1032
- Syntax to Activate Broadening . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1032
- Electronic Band Structure for Wurtzite Crystals . . . . . . . . . . . . . . . . . . . . . . . . . . . 1033
- Optical Transition Matrix Element for Wurtzite Crystals . . . . . . . . . . . . . . . . . 1037
Simple Quantum-Well Subband Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1039
- Syntax for Simple Quantum-Well Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1041
Strain Effects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1042
- Syntax for Quantum-Well Strain . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1043
Localized Quantum-Well Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1044
Nonlocal Quantum-Well Model Using 1D Schrödinger Solver . . . . . . . . . . . . . . . . . . . . 1046
Importing Gain and Spontaneous Emission Data With PMI . . . . . . . . . . . . . . . . . . . . . . 1048
- Implementing Gain PMI . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1048
References . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1051

---

**Chapter 36 Kinetic Monte Carlo MIM Transport** **1053**
- KMC Simulation Space and Math Settings . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1053
    - KMC Simulation Space . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1054
    - Setting the Minimum Defect Distances . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1055
    - Specifying the Random Seed . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1055
    - Omitting KMC Simulations Near Steady State . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1056
    - Omitting the KMC Simulation Completely . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1056
    - Resetting the Fraction of Defects Filled With Electrons . . . . . . . . . . . . . . . . . . . . . 1057
    - Sampling Potential at All Crossings . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1057
    - Resetting the Rate More Frequently . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1057
    - Adjusting the Calculated Tunneling Rates . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1058
    - Setting the Integration Points . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1058
    - Specifying the Approximate Bessel Function . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1058
- Specifying Electrodes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1059
- Specifying Insulators . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1060
- Specifying Defects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1060
- Creating the Grain Field . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1062
- Tunneling Processes . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1064
    - Specifying Tunneling Processes and Related Options . . . . . . . . . . . . . . . . . . . . . . 1064
    - Direct Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1065

xxx

# Contents

Poole–Frenkel Emission . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1066
Elastic Electrode-to-Trap and Trap-to-Electrode Tunneling . . . . . . . . . . . . . . . . . . 1067
    Option for Elastic Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1068
Inelastic Electrode-to-Trap and Trap-to-Electrode Tunneling . . . . . . . . . . . . . . . . 1068
    Options for Inelastic Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1070
Trap-to-Trap Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1070
    Trap-to-Trap Tunneling Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1070
    Inelastic Phonon Trap-to-Trap Tunneling Model. . . . . . . . . . . . . . . . . . . . . . . . 1071
    Multiphonon Trap-to-Trap Tunneling Model. . . . . . . . . . . . . . . . . . . . . . . . . . . 1072
Image Charge Barrier Lowering . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1073
Energy-Dependent Mass . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1073
Including the MIM Charge in the Poisson Equation . . . . . . . . . . . . . . . . . . . . . . . . 1074
    Average Electron Occupancy in the MIM Charge . . . . . . . . . . . . . . . . . . . . . . . 1075
Printing Options. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1075
Rate Equation Current Calculation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1076
Conductive Path Current Analysis. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1077
Sensitivity Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1077
Time-Dependent Dielectric Breakdown Simulations . . . . . . . . . . . . . . . . . . . . . . . 1080
    Adjustment for Vacancy Sites per Volume . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1082
    TDDB Break Criteria . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1082
    TDDB Models . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1083
    Fluence Dependency. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1084
Performing the Simulation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1085
Printed Output . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1087
    Setup Information . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1087
    Occupancy and Energy . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1089
    Event Statistics. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1089
    Tunneling Rates . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1090
Quantities Available for Plotting . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1091
    Quantities Written to the Current Plot (*.plt) File. . . . . . . . . . . . . . . . . . . . . . . . . . 1091
    Special MIM Current File (Currents and Capacitance) . . . . . . . . . . . . . . . . . . . . . . 1091
    Quantities Written to TDR Files . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1092
        Concentration Plots. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1092
        Particle Plots. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1093
        Band Diagram With Traps. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1093
Example: MIM Leakage Current . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1094
    Sentaurus Device Command File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1094
    Sentaurus Device Parameter File. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1096
    Results . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1097
Example: TiN/ZrO2/TiN KMC-TDDB Simulation . . . . . . . . . . . . . . . . . . . . . . . . . . . 1098
    Sentaurus Device Command File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1099

<page_number>xxxi</page_number>

# Contents

Sentaurus Device Parameter File 1101
Results 1102
References 1104

**Chapter 37 Kinetic Monte Carlo ReRAM 1107**
Starting the Simulation and Specifying Particles 1107
Capacity of Defects 1108
KMC Events 1109
Location of KMC Events 1110
Particle or Particle Pairs Involved in KMC Events 1110
Parameters of KMC Events 1110
Diffusion Events 1111
Generation and Recombination Events 1111
Filament Growth and Recession Events 1112
KMC Simulation Space and Math Settings 1112
KMC Simulation Space 1113
Random Seed 1114
KMC Time Step Control 1114
Current Compliance 1115
Specifying the Material 1115
Specifying the Field and Temperature 1116
Transient Calculation for ReRAM 1117
Current in ReRAM Operations 1117
Conduction Current 1117
Trap-Assisted Tunneling Calculation 1118
Particles for Trap-Assisted Tunneling Calculation 1118
Physics for Trap-Assisted Tunneling Calculation 1118
Stopping Criteria of Trap-Assisted Tunneling Calculation 1119
Parameters for Trap-Assisted Tunneling Calculation 1120
Simulation Output 1121
Current and Particles 1121
Event and Particle Statistics 1121
Defect and Field Visualization 1122
ReRAM Example 1123
Sentaurus Device Command File 1123
Sentaurus Device Parameter File 1127

<page_number>xxxii</page_number>
S-2021.06

Contents

# Part III Numeric Methods and External Interfaces **1131**

**Chapter 38 Numeric Methods** **1133**
* Discretization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1133
    - Extended Precision . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1134
    - Box Method Coefficients in the 3D Case . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1135
        - Basic Definitions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1135
        - Element Intersection Box Method Algorithm . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1137
        - Truncated Obtuse Elements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1138
        - Weighted Box Method Coefficients . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1141
            - Weighted Points . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1141
            - Weighted Voronoï Diagram . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1142
        - Saving and Restoring Box Method Coefficients . . . . . . . . . . . . . . . . . . . . . . . . . . . 1143
        - Statistics About Non-Delaunay Elements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1144
            - Region Non-Delaunay Elements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1145
            - Interface Non-Delaunay Elements . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1145
            - Plot Section. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1146
        - Improved Accuracy of Box Method Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . 1147
* AC Simulation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1147
    - AC Response . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1147
    - AC Current Density Responses . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1149
* Harmonic Balance Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1150
    - Harmonic Balance Equation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1150
    - Multitone Harmonic Balance Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1150
        - Multidimensional Fourier Transformation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1151
        - Quasi-Periodic Functions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1152
        - Multidimensional Frequency Domain Problem . . . . . . . . . . . . . . . . . . . . . . . . . 1152
        - One-Tone Harmonic Balance Analysis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1152
    - Solving the Harmonic Balance Equation. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1153
    - Solving the Harmonic Balance Newton Step Equation . . . . . . . . . . . . . . . . . . . . . . 1154
        - Restarted GMRES Method. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1154
        - Direct Solver Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1155
* Transient Simulation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1155
    - Backward Euler Method . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1155
    - TRBDF Composite Method. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1156
    - Controlling Transient Simulations. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1157
    - Floating Gates. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1158
* Nonlinear Solvers . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1159
    - Fully Coupled Solution . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1159

<page_number>xxxiii</page_number>

Contents

‘Plugin’ Iterations ................................................................................................. 1161
References................................................................................................................. 1162

# Chapter 39 Physical Model Interface 1165
Introduction to the Physical Model Interface ............................................................ 1165
Using a PMI Model ............................................................................................. 1167
Available Interfaces............................................................................................. 1168
Standard C++ Interface.................................................................................. 1168
Simplified C++ Interface ............................................................................... 1171
Nonlocal Interface ........................................................................................ 1175
Shared Object Code ...................................................................................... 1187
Command File of Sentaurus Device .................................................................... 1187
Parameter File of Sentaurus Device..................................................................... 1189
Parallelization ..................................................................................................... 1191
Thread-Local Storage .................................................................................... 1192
Debugging Physical Model Interfaces.................................................................. 1193
Runtime Support for Vertex-Based PMI Models ................................................ 1194
Support at Model Scope ................................................................................ 1195
Support at Compute Scope ............................................................................ 1197
Experimental Functions ................................................................................ 1201
Runtime Support for Vertex-Based Multistate Configuration–Dependent Models 1202
Runtime Support for Mesh-Based PMI Models .................................................. 1203
Device Mesh.................................................................................................. 1205
Device Data .................................................................................................. 1211
Runtime Support to Write PMI Output to Log File............................................. 1216
Generation–Recombination ...................................................................................... 1217
Avalanche Generation ......................................................................................... 1217
Dependencies ................................................................................................ 1217
Standard C++ Interface.................................................................................. 1218
Simplified C++ Interface ............................................................................... 1219
Example: Okuto Avalanche Generation........................................................ 1220
Generation–Recombination ................................................................................. 1224
Dependencies ................................................................................................ 1224
Standard C++ Interface.................................................................................. 1225
Simplified C++ Interface ............................................................................... 1226
Example: Auger Recombination ................................................................... 1227
Lifetimes ............................................................................................................. 1227
Dependencies ................................................................................................ 1227
Standard C++ Interface.................................................................................. 1228
Simplified C++ Interface ............................................................................... 1229
Example: Doping- and Temperature-Dependent Lifetimes .......................... 1229

<page_number>xxxiv</page_number>

# Contents

Nonlocal Generation–Recombination . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1232
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1232
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1233
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1233
- Example: Point-to-Point Tunneling . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1234
Tunneling Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1234
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1235
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1235
- Example: Constant Tunneling Parameters . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1236
Mobility. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1237
- Doping-Dependent Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1237
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1238
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1238
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1239
- Example: Masetti Doping-Dependent Mobility . . . . . . . . . . . . . . . . . . . . . . . . . 1240
- Fitting Parameter for Ballistic Mobility. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1243
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1244
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1244
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1244
- Example: Ballistic Mobility . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1245
- High-Field Saturation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1246
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1246
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1247
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1249
- Example: Canali High-Field Saturation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1250
- High-Field Saturation With Two Driving Forces . . . . . . . . . . . . . . . . . . . . . . . . . . 1255
- Command File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1255
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1255
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1256
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1258
- Mobility Degradation at Interfaces . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1259
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1259
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1260
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1262
- Example: Lombardi Mobility Degradation . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1263
Semiconductor Band Structure . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1268
- Apparent Band-Edge Shift. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1268
- Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1268
- Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1269
- Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1270
Band Gap . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1271

<page_number>xxxv</page_number>

# Contents

Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1271
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1271
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1272
Example: Default Temperature Dependence . . . . . . . . . . . . . . . . . . . . . . . . . . . 1272
Bandgap Narrowing. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1274
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1274
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1274
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1275
Example: Bennett–Wilson Bandgap Narrowing . . . . . . . . . . . . . . . . . . . . . . . . 1275
Effective Mass . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1277
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1277
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1277
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1278
Example: Linear Effective Mass . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1278
Electron Affinity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1281
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1281
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1281
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1282
Example: Default Temperature Dependence . . . . . . . . . . . . . . . . . . . . . . . . . . . 1282
Phase and State Transitions. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1284
Multistate Configuration–Dependent Apparent Band-Edge Shift. . . . . . . . . . . . . . 1284
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1284
Additional Functionality. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1285
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1285
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1286
Multistate Configuration–Dependent Bulk Mobility. . . . . . . . . . . . . . . . . . . . . . . . 1287
Command File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1287
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1288
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1289
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1289
Multistate Configuration–Dependent Heat Capacity. . . . . . . . . . . . . . . . . . . . . . . . 1290
Command File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1290
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1291
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1291
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1292
Multistate Configuration–Dependent Thermal Conductivity . . . . . . . . . . . . . . . . . 1293
Command File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1293
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1293
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1294
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1295
Thermal Properties and Heat. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1296

<page_number>xxxvi</page_number>

# Contents

Distributed Thermal Resistance 1297
- Dependencies 1297
- Simplified C++ Interface 1298
- Example: Electron Density Dependence 1299
Heat Capacity 1300
- Dependencies 1300
- Standard C++ Interface 1300
- Simplified C++ Interface 1301
- Example: Constant Heat Capacity 1302
Heat Generation Rate 1303
- Dependencies 1303
- Standard C++ Interface 1304
- Simplified C++ Interface 1305
- Example: Dependency on Electric Field and Gradient of Temperature 1306
Metal Thermoelectric Power 1307
- Dependencies 1307
- Standard C++ Interface 1308
- Simplified C++ Interface 1309
- Example: Linear Field Dependency of Metal TEP 1309
Thermal Conductivity 1311
- Dependencies 1312
- Standard C++ Interface 1312
- Simplified C++ Interface 1313
- Example: Temperature-Dependent Thermal Conductivity 1313
- Example: Thin-Layer Thermal Conductivity 1315
Thermoelectric Power 1317
- Dependencies 1317
- Standard C++ Interface 1318
- Simplified C++ Interface 1319
- Example: Analytic TEP 1319
Optics 1322
- Complex Refractive Index Model Interface 1322
- C++ Application Programming Interface 1323
- Shared Object Code 1328
- Command File of Sentaurus Device 1329
Optical Quantum Yield 1329
- Dependencies 1330
- Standard C++ Interface 1331
- Simplified C++ Interface 1332
Special Contact PMI for Raytracing 1333
- Dependencies 1333

<page_number>xxxvii</page_number>

# Contents

Standard C++ Interface 1335
Example: Assessing and Modifying a Ray 1337
Mechanical Stress 1339
Mobility Stress Factor 1339
Dependencies 1340
Standard C++ Interface 1340
Simplified C++ Interface 1341
Example: Effective Stress 1342
Piezoelectric Polarization 1347
Dependencies 1347
Standard C++ Interface 1348
Simplified C++ Interface 1348
Example: Gaussian Polarization 1349
Piezoresistive Coefficients 1350
Dependencies 1350
Standard C++ Interface 1350
Simplified C++ Interface 1351
Stress 1352
Dependencies 1352
Standard C++ Interface 1352
Simplified C++ Interface 1353
Example: Constant Stress 1354
Traps and Fixed Charges 1355
Trap Capture and Emission Rates 1356
Traps 1356
Multistate Configurations 1356
Dependencies 1356
Standard C++ Interface 1357
Simplified C++ Interface 1358
Example: Arrhenius Law 1359
Trap Energy Shift 1360
Command File 1360
Dependencies 1360
Standard C++ Interface 1361
Simplified C++ Interface 1361
Degradation 1362
Diffusivity 1362
Dependencies 1363
Simplified C++ Interface 1363
Example: Field-Dependent Hydrogen Diffusivity 1364
eNMP Transition Rates 1366

<page_number>xxxviii</page_number>

# Contents

Distinction Between Electron and Hole Transitions . . . . . . . . . . . . . . . . . . . . . 1367
Transition Rates for All Sample Defects . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1368
Parameter Randomization. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1368
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1369
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1371
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1372
Example: eNMP Model Transition Rates. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1373
Ferroelectrics and Ferromagnetics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1377
Ferroelectrics Hysteresis . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1378
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1378
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1379
Ferroelectrics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1380
Ferromagnetism and Spin Transport . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1381
User-Defined Interlayer Exchange Coupling . . . . . . . . . . . . . . . . . . . . . . . . . . . 1382
User-Defined Bulk or Interface Contributions to the Effective Magnetic Field 1385
User-Defined Magnetostatic Potential Calculation . . . . . . . . . . . . . . . . . . . . . . 1394
Electrical Resistivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1395
Metal Resistivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1395
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1396
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1396
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1397
Example: Linear Metal Resistivity. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1397
Schottky Resistance . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1399
Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1399
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1400
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1401
Example: Built-in Schottky Resistance . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1402
Simulation Controls . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1404
Current Plot File. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1404
Structure of Current Plot File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1404
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1405
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1406
Example: Average Electrostatic Potential . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1406
Postprocessing for Transient Simulations . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1408
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1409
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1409
Example: Postprocess User-Field. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1410
Preprocessing for Newton Iterations and Newton Step Control . . . . . . . . . . . . . . 1411
Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1412
Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1413
Flow of Computation . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1414

<page_number>xxxix</page_number>

# Contents

Various . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1415
- Dielectric Permittivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1415
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1415
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1416
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1416
    - Example: Temperature-Dependent Dielectric Permittivity . . . . . . . . . . . . . . . . 1417
- Energy Relaxation Times. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1418
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1418
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1419
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1419
    - Example: Constant Energy Relaxation Times . . . . . . . . . . . . . . . . . . . . . . . . . . 1420
- Gamma Factor for Density Gradient Model . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1422
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1422
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1423
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1424
    - Example: Solution-Dependent Gamma Factor. . . . . . . . . . . . . . . . . . . . . . . . . . 1425
- Heavy Ion Spatial Distribution . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1427
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1428
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1428
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1429
    - Example: Gaussian Spatial Distribution Function . . . . . . . . . . . . . . . . . . . . . . 1430
- Hot-Carrier Injection . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1431
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1431
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1431
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1432
    - Example: Lucky Hot-Carrier Injection. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1433
- Incomplete Ionization . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1438
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1439
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1439
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1440
    - Example: Matsuura Incomplete Ionization. . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1441
- Space Factor. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1446
    - Dependencies . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1447
    - Standard C++ Interface. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1447
    - Simplified C++ Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1447
    - Example: PMI User Field as Space Factor. . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1448
References. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1449

## Chapter 40 Tcl Interfaces 1451
Overview. . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1451
Mesh-Based Runtime Support . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1451

<page_number>xl</page_number>

# Contents

Device Mesh . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1452
- Vertex . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1453
- Edge . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1454
- Element . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1454
- Region . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1455
- Region Interface . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1456
Device Data . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1457
- One-Dimensional Arrays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1458
- Two-Dimensional Arrays . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1458
Current Plot File . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1458
Tcl Functions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1459
- tcl_cp_constructor . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1459
- tcl_cp_destructor . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1460
- tcl_cp_Compute_Dataset_Names . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1460
- tcl_cp_Compute_Function_Names . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1460
- tcl_cp_Compute_Plot_Values . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1461
Example: Average Electron Conductivity . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1461

**Part IV Appendices** **1463**

**Appendix A Mathematical Symbols** **1465**

**Appendix B Syntax** **1469**

**Appendix C File-Naming Conventions** **1471**
File Extensions . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1471

**Appendix D Command-Line Options** **1473**
Starting Sentaurus Device . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1473
Command-Line Options . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1473

**Appendix E Runtime Statistics** **1477**
Generating Statistics . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1477

**Appendix F Data Names and Plot Names** **1479**
Overview . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1479
Scalar Data . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . 1480

xli
<page_number>xli</page_number>

# Contents

Vector Data ................................................................. 1502
Special Vector Data ......................................................... 1505
Tensor Data ................................................................. 1505
Particle Data ............................................................... 1505

**Appendix G Command File Overview** **1507**
Organization of Command File Overview ...................................... 1507
Top Level of Command File .................................................. 1509
CurrentPlot ................................................................ 1509
Device ..................................................................... 1511
Electrode .................................................................. 1512
File ....................................................................... 1514
GainPlot ................................................................... 1517
HydrogenBoundary ........................................................... 1517
IFM ........................................................................ 1518
Math ....................................................................... 1518
NoisePlot .................................................................. 1546
NonLocalPlot ............................................................... 1546
OpticalDevice .............................................................. 1547
Physics .................................................................... 1547
Generation and Recombination ............................................... 1557
LED ........................................................................ 1577
Mobility ................................................................... 1582
Radiation Models ........................................................... 1587
Various .................................................................... 1588
Plot ....................................................................... 1621
RayTraceBC ................................................................. 1622
Solve ...................................................................... 1623
System ..................................................................... 1637
TensorPlot ................................................................. 1638
Thermode ................................................................... 1639
Various .................................................................... 1639

<page_number>xlii</page_number>

# About This Guide

The Synopsys® Sentaurus™ Device tool is a full-featured, electrothermal, mixed-mode device and circuit simulator for one-dimensional, two-dimensional, and three-dimensional semiconductor devices. It incorporates advanced physical models and robust numeric methods for the simulation of most types of semiconductor device ranging from very deep-submicron silicon MOSFETs to large bipolar power structures. In addition, SiC and III–V compound homostructure and heterostructure devices are fully supported.

The user guide is divided into parts:

* Part I presents information about starting Sentaurus Device and how it interacts with other Synopsys tools.

* Part II describes the physics and the physical models in Sentaurus Device.

* Part III describes the physical model interface, which provides direct access to certain models in the semiconductor transport equations, and the numeric methods used in Sentaurus Device.

* Part IV contains the appendices.

This guide assumes familiarity with working on UNIX-like systems and requires a basic understanding of semiconductor device physics and its terminology.

For additional information, see:

* The TCAD Sentaurus release notes, available on the Synopsys SolvNetPlus support site (see Accessing SolvNetPlus on page xliv)

* Documentation available on the SolvNetPlus support site

# Conventions

The following conventions are used in Synopsys documentation.

| Convention | Description |
| --- | --- |
| Bold text | Identifies a selectable icon, button, menu, or tab. It also indicates the name of a field or an option. |
| `Courier font` | Identifies text that is displayed on the screen or that the user must type. It identifies the names of files, directories, paths, parameters, keywords, and variables. |

<page_number>xliii</page_number>

About This Guide

Customer Support

| Convention | Description |
| --- | --- |
| Italicized text | Used for emphasis, the titles of books and journals, and non-English words. It also identifies components of an equation or a formula, a placeholder, or an identifier. |
| Menu > Command | Indicates a menu command, for example, File > New (from the File menu, choose New). |

# Customer Support

Customer support is available through the Synopsys SolvNetPlus support site and by contacting the Synopsys support center.

## Accessing SolvNetPlus

The SolvNetPlus support site includes an electronic knowledge base of technical articles and answers to frequently asked questions about Synopsys tools. The site also gives you access to a wide range of Synopsys online services, which include downloading software, viewing documentation, and entering a call to the Support Center.

To access the SolvNetPlus site:

1. Go to [https://solvnetplus.synopsys.com](https://solvnetplus.synopsys.com).

2. Enter your user name and password. (If you do not have a Synopsys user name and password, follow the instructions to register.)

## Contacting Synopsys Support

If you have problems, questions, or suggestions, you can contact Synopsys support in the following ways:

* Go to the Synopsys Global Support Centers site on www.synopsys.com. There you can find email addresses and telephone numbers for Synopsys support centers throughout the world.

* Go to either the Synopsys SolvNetPlus site or the Synopsys Global Support Centers site and open a case (Synopsys user name and password required).

<page_number>

xliv
</page_number>

About This Guide
Acknowledgments

# Contacting Your Local TCAD Support Team Directly

Send an email message to:

* support-tcad-us@synopsys.com from within North America and South America

* support-tcad-eu@synopsys.com from within Europe

* support-tcad-ap@synopsys.com from within Asia Pacific (China, Taiwan, Singapore, Malaysia, India, Australia)

* support-tcad-kr@synopsys.com from Korea

* support-tcad-jp@synopsys.com from Japan

# Acknowledgments

Parts of Sentaurus Device were codeveloped by Integrated Systems Laboratory of ETH Zurich in the joint research project LASER with financial support by the Swiss funding agency CTI and in the joint research project VCSEL with financial support by the Swiss funding agency TOP NANO 21. The GEBAS Library was codeveloped by Integrated Systems Laboratory of ETH Zurich in the joint research project MQW with financial support by the Swiss funding agency TOP NANO 21.

<page_number>

xlv
</page_number>

# About This Guide

Acknowledgments

<page_number>xlvi</page_number>

# Part I Getting Started

This part of the ** contains the following chapters:

Chapter 1 Introduction to Sentaurus Device

Chapter 2 Specifying Physical Devices

Chapter 3 Mixed-Mode Simulations

Chapter 4 Performing Numeric Experiments

Chapter 5 Simulation Results

Chapter 6 Numeric and Software-Related Issues

