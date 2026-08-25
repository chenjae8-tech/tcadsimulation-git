# CHAPTER 14 Quantization

*This chapter describes the features that Sentaurus Device offers to model quantization effects.*

Some features of current MOSFETs (oxide thickness and channel width) have reached quantum-mechanical length scales. Therefore, the wave nature of electrons and holes can no longer be neglected. The most basic quantization effects in MOSFETs are the shift of the threshold voltage and the reduction of the gate capacity. Tunneling, another important quantum effect, is described in Chapter 24 on page 767.

# Modeling Quantization Effects

To include quantization effects in a classical device simulation, Sentaurus Device introduces a potential-like quantity $\Lambda_n$ in the classical density formula:

$$ n = N_C F_{1/2} \left( \frac{E_{F,n} - E_C - \Lambda_n}{kT_n} \right) $$ (221)

An analogous quantity $\Lambda_p$ is introduced for holes.

The most important effects related to the density modification (due to quantization) can be captured by proper models for $\Lambda_n$ and $\Lambda_p$. Other effects (for example, single electron effects) exceed the scope of this approach.

Sentaurus Device implements different quantization models for $\Lambda_n$ and $\Lambda_p$, which differ in physical sophistication, numeric expense, and robustness:

*   The van Dort model is a numerically robust, fast, and proven model (see The van Dort Model on page 304). It is suited only to bulk MOSFET simulations. While important terminal characteristics are well described by this model, it does not give the correct density distribution in the channel.

*   The 1D Schrödinger equation is a physically sophisticated quantization model (see 1D Schrödinger Equation on page 305). It can be used for MOSFET simulation, and quantum well and ultrathin SOI simulation. Simulations with this model tend to be slow and often lead to convergence problems, which restrict its use to situations with small current flow. Therefore, the Schrödinger equation is used mainly for the validation and calibration of other quantization models.

The van Dort Model

* For 3D structures, an external 2D Schrödinger solver can be used to provide a quantization model (see External 2D Schrödinger Solver on page 312). This is the physically most sophisticated approach, but requires a high computation time and a complicated setup, and provides reduced numeric robustness.

* For 3D structures, an external Boltzmann transport equation solver can be used to provide a quantum-correction potential as well as an effective mobility to be used in a subdomain of the Sentaurus Device mesh (see External Boltzmann Solver on page 314). Similar to an external 2D Schrödinger solver, it is a physically sophisticated and computationally demanding approach with reduced numeric robustness.

* The density gradient model (see Density Gradient Model on page 316) is numerically robust, but significantly slower than the van Dort model. It can be applied to MOSFETs, quantum wells and SOI structures, and gives a reasonable description of terminal characteristics and charge distribution inside a device. Compared to the other quantization models, it can describe 2D and 3D quantization effects.

* The modified local-density approximation (MLDA) model (see Modified Local-Density Approximation Model on page 324) is a numerically robust and fast model. It can be used for bulk MOSFET simulations and thin SOI simulations. Although it sometimes fails to calculate the accurate carrier distribution in the saturation regions because of its one-dimensional characteristic, it is suitable for 3D device simulations because of its numeric efficiency.

* The quantum-well quantization model (see Quantum-Well Quantization Model on page 332) can be applied to semiconductor quantum wells with a width that does not vary very much over the device. It approximates the solution by the solution for a trapezoidal potential.

---

# The van Dort Model

The van Dort model [1] computes $\Lambda_n$ of Eq. 221 as a function of $|\hat{n} \cdot \vec{F}|$, the electric field normal to the semiconductor–insulator interface:

$$ \Lambda_n = \frac{13}{9} \cdot k_{\text{fit}} \cdot G(\vec{r}) \cdot \left( \frac{\varepsilon \varepsilon_0}{4kT} \right)^{1/3} \cdot \left| |\hat{n} \cdot \vec{F}| - E_{\text{crit}} \right|^{2/3} \text{ (222)} $$

and likewise for $\Lambda_p$. Here, $k_{\text{fit}}$ and $E_{\text{crit}}$ are fitting parameters. The function $G(\vec{r})$ is defined by:

$$ G(\vec{r}) = \frac{2 \cdot \exp(-a^2(\vec{r}))}{1 + \exp(-2a^2(\vec{r}))} \text{ (223)} $$

**14: Quantization**
1D Schrödinger Equation

where $a(\vec{r}) = l(\vec{r})/\lambda_{\text{ref}}$ and $l(\vec{r})$ is a distance from the point $\vec{r}$ to the interface. The parameter $\lambda_{\text{ref}}$ determines the distance to the interface up to which the quantum correction is relevant. The quantum correction is applied to those carriers (electrons or holes) that are drawn towards the interface by the electric field; for the carriers driven away from the interface, the correction is 0.

## Using the van Dort Model

To activate the model for electrons or holes, specify `eQCvanDort` or `hQCvanDort` in the `Physics` section. For example:

```
Physics { ... eQCvanDort}
```

In Table 44, the default value of $\lambda_{\text{ref}}$ is from the literature [1]. Other parameters were obtained by fitting the model to experimental data for electrons [1] and holes [2].

Table 44 Default parameters for van Dort quantum correction model

| Symbol | Electrons | Holes | Unit |  |  |
| --- | --- | --- | --- | --- | --- |
| $k_{\text{fit}}$ | eFit | 2.4$\times$10–8 | hFit | 1.8$\times$10–8 | eVcm |
| $E_{\text{crit}}$ | eEcritQC | 105 | eEcritQC | 105 | V/cm |
| $\lambda_{\text{ref}}$ | dRef | 2.5$\times$10–6 | dRef | 2.5$\times$10–6 | cm |

By default, in Eq. 222, $\hat{n}$ is the normal to the closest semiconductor–insulator interface. The interface can be specified explicitly by `EnormalInterface` in the `Math` section (see Normal to the Interface on page 380).

# 1D Schrödinger Equation

To use the 1D Schrödinger equation:

1. Construct a special-purpose *nonlocal* mesh (see Nonlocal Mesh for the 1D Schrödinger Equation).

2. Activate the Schrödinger solver on the nonlocal line mesh with appropriate parameters (see Using the 1D Schrödinger Equation on page 307).

Sometimes, especially for heteromaterials, the physical model parameters must be adapted (see Parameters of the 1D Schrödinger Equation on page 307).

1D Schrödinger Equation

> **NOTE** The 1D Schrödinger equation is time consuming and often causes converge problems. Furthermore, small-signal analysis (see Small-Signal AC Analysis on page 101) and noise and fluctuation analysis (see Chapter 23 on page 729) are not possible when using this solver.

## Nonlocal Mesh for the 1D Schrödinger Equation

The specification of the nonlocal mesh determines where in the device the 1D Schrödinger equation can be solved. This section summarizes the features that are typically needed to obtain a correct nonlocal mesh for the 1D Schrödinger equation. For more information about constructing nonlocal meshes, see Nonlocal Meshes on page 152.

To generate a nonlocal mesh, specify `NonLocal` in the global `Math` section. Options to `NonLocal` control the construction of the nonlocal mesh. The following example generates a nonlocal mesh named "NLM" at the interface between regions `gateoxide` and `channel`:

```
Math {
  NonLocal "NLM" (
    RegionInterface="gateoxide/channel"
    Length=10e-7
    Permeation=1e-7
    Direction=(0 1 0) MaxAngle=5
    -Transparent(Region="gateoxide")
  )
}
```

The nonlocal lines extend 10 nm (according to `Length`) to one side of the interface and 1 nm (according to `Permeation`) to the other side. The segments of the nonlocal lines on the two sides are handled differently; see below. In the example, `Direction` and `MaxAngle` restrict the nonlocal mesh to lines that run along the y-axis, with a tolerance of 5°.

`Direction` defines a vector that is typically perpendicular to the interface; therefore, the specification above is appropriate for an interface in the xz plane.

For nonlocal meshes constructed for the Schrödinger equation, the `-Transparent` switch is important. In this example, it suppresses the construction of nonlocal lines for which the section with length `Length` passes through `gateoxide`. Therefore, Sentaurus Device only constructs nonlocal lines that extend 10 nm into `channel` and 1 nm into `gateoxide`, and suppresses the nonlocal lines that extend 1 nm into `channel` and 10 nm into `gateoxide`. Without the `-Transparent` switch, Sentaurus Device would construct both line types and, therefore, would solve the Schrödinger equation not only in the channel, but also in the poly gate (provided that a poly gate exists and `gateoxide` is thinner than 10 nm).

14: Quantization
1D Schrödinger Equation

# Using the 1D Schrödinger Equation

To activate the 1D Schrödinger equation for electrons or holes, specify `Electron` or `Hole` as an option to `Schroedinger` in the global `Physics` section.

The following example activates the Schrödinger equation for electrons on the nonlocal mesh named "NLM":

```
Physics {
  Schroedinger "NLM" (Electron)
}
```

Additional options to `Schroedinger` determine numeric accuracy, details of the density computation, and which eigenstates will be computed. Table 320 on page 1609 lists the optional keywords.

`MaxSolutions`, `Error`, and `EnergyInterval` support the option `electron` or `hole`. For example, the specification `MaxSolutions=30` sets the value for both electrons and holes. The specifications `MaxSolutions(electron)=2` and `MaxSolutions(hole)=3` set different values for electrons and holes.

By default, Sentaurus Device only computes bound states, that is, states with an energy that is below the largest value of the potential both left and right of the point with minimal potential. If, according to this definition, no bound states exist, the quantum corrections will be disabled. With the `EnergyInterval` parameter, this behavior can be changed to compute all states with an energy up to the specified value above the lowest potential point.

For backward compatibility, you can define `Schroedinger` in an interface-specific or a contact-specific `Physics` section; in this case, omit the nonlocal mesh name. The specification applies to an unnamed nonlocal mesh that has been constructed for the same location (see Unnamed Meshes on page 158).

# Parameters of the 1D Schrödinger Equation

Typically, the Schrödinger equation must be solved repeatedly, with different masses and potential profiles, resulting in a number of distinct *ladders* of eigenenergies. For example, the six-fold degenerate, anisotropic conduction band valleys in silicon require the Schrödinger equation to be solved up to three times with different parameters.

Sentaurus Device allows you to specify the number of ladders and the associated parameters explicitly, or it can extract the number of ladders and the parameters from other parameters and the nonlocal line direction automatically.

1D Schrödinger Equation

Parameters for the Schrödinger equation are region specific. The Schrödinger equation must not be solved across regions with fundamentally different band structures. Sentaurus Device displays an error message if band structure compatibility is violated.

## Explicitly Specifying Ladders

Any number of `eLadder(` $m_{z, \nu}$ , $m_{xy, \nu}$ , $d_{\nu}$ , $\Delta E_{\nu}$ `)` specifications (for electrons) or `hLadder(` $m_{z, \nu}$ , $m_{xy, \nu}$ , $d_{\nu}$ , $\Delta E_{\nu}$ `)` specifications (for holes) is possible in the parameter set `SchroedingerParameters`. The $\nu$-th specification for a particular carrier type defines the quantization mass $m_{z, \nu}$, the mass perpendicular to the quantization direction $m_{xy, \nu}$, the ladder degeneracy $d_{\nu}$, and a nonnegative band edge shift $\Delta E_{\nu}$.

The parameter pair `ShiftTemperature` in the `SchroedingerParameters` parameter set is given in kelvin and determines the temperatures $T_{ref}$ for electrons and holes that enter scaling factors applied to $m_{xy, \nu}$. The scaling factors ensure that the masses for the Schrödinger equation are consistent with the density-of-states masses. For electrons, the scaling factor is:

$$ \frac{m_n^{3/2}}{\sum_{\nu} d_{\nu} m_{xy, \nu} m_{z, \nu}^{1/2} \exp(-\Delta E_{\nu} / k T_{ref})} \eqno(224) $$

and likewise for holes. $T_{ref}$ defaults to a large value. When $T_{ref} = 0$, scaling is disabled.

## Automatically Extracting Ladder Parameters

When no explicit ladder specification is present, Sentaurus Device attempts to extract the required parameters automatically. The `formula` parameter pair in the parameter set `SchroedingerParameters` specifies which expressions for the masses to use. If an explicit ladder specification is present, then `formula` for the respective carrier type is ignored, and only the explicit ladder specification is accounted for.

For each carrier, if the `formula` is 0, Sentaurus Device uses the isotropic density-of-states mass as both the quantization mass and the mass perpendicular to it.

For electrons, if the `formula` is 1, Sentaurus Device uses the anisotropic (silicon-like) masses specified in the `eDOSMass` parameter set. The quantization mass for the conduction band valley $\nu$ reads:

$$ \frac{1}{m_{z, \nu}} = \sum_{i=1}^{3} \frac{z_i^2}{m_{i, \nu}} \eqno(225) $$

**14: Quantization**
1D Schrödinger Equation

where $m_{i, \nu}$ are the effective mass components for valley $\nu$, and $z_i$ are the coefficients of the unit normal vector pointing in the quantization direction, expressed in the crystal coordinate system.

The `LatticeParameters` parameter set determines the relation to the mesh coordinate system (see Crystal and Simulation Coordinate Systems on page 836).

For holes, ‘warped’ band structure (formula 1), or heavy-hole and light-hole masses (formula 2) are available (see Table 45 on page 309). For the former, the quantization mass is given by:

$$ m_{z, \nu} = \frac{m_0}{A \pm \sqrt{B + C \cdot (z_1^2 z_2^2 + z_2^2 z_3^2 + z_3^2 z_1^2)}} $$ (226)

For the latter, `ml` and `mh` (given as multiples of $m_0$) determine directly the masses for the light-hole and heavy-hole bands.

The masses $m_{xy, \nu}$ are chosen to achieve the same density-of-states mass as used in classical simulations. For electrons:

$$ m_{xy, \nu} = \frac{m_n^{3/2}}{m_{z, \nu}^{1/2} n_\nu} $$ (227)

where $n_\nu$ is the number of band valleys (or bands). The expression for holes is analogous.

`SchroedingerParameters` offers a parameter pair `offset` to model the lifting of the degeneracy of band minima in strained materials. Unless exactly two ladders exist, `offset` must be zero. Positive offsets apply to the electron ladder with lower degeneracy or the heavy-hole band; negative values apply to the electron ladder of higher degeneracy or the light-hole band. The modulus of the value is added to the band edge for the respective ladder, moving it away from mid-gap, while the other ladder remains unaffected. For holes, the shift is taken into account in the scaling of $m_{xy, \nu}$ as it is in Eq. 224.

Table 45 Parameters for hole effective masses in Schrödinger solver

| Formula | Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- | --- |
| 1 | A | A | 4.22 | 1 |
| B | B | 0.6084 | 1 |  |
| C | C | 23.058 | 1 |  |
| 2 | m_l | ml | 0 | 1 |
| m_h | mh | 0 | 1 |  |

1D Schrödinger Equation

---

## Visualizing the Solutions

To visualize the results obtained by the 1D Schrödinger equation, Sentaurus Device offers special keywords for the `NonLocalPlot` section (see Visualizing Data Defined on Nonlocal Meshes on page 154).

To plot the wavefunctions, specify `WaveFunction` in the `NonLocalPlot` section. Sentaurus Device plots wavefunctions in units of $\mu\text{m}^{-1/2}$. To plot the eigenenergies, specify `EigenEnergy`; Sentaurus Device plots them in units of eV. The names of the curves in the output have two numeric indices. The first index denotes the ladder index and the second index denotes the number of zeros of the wavefunction (see $\nu$ and $j$ in Eq. 228).

Without further specification, Sentaurus Device will plot all eigenenergies and wavefunctions it has computed. The `Electron` and `Hole` options to `WaveFunction` and `EigenEnergy` restrict the output to the wavefunctions and eigenenergies for electrons and holes, respectively.

The `Electron` and `Hole` options have a sub-option `Number=<int>` to restrict the output to a certain number of states of lowest energy.

The following example will plot all hole wavefunctions and the three lowest-energy electron wavefunctions for the nonlocal mesh line close to the coordinate (0, 0, 0):

```
NonLocalPlot(
  (0 0)
){
  WaveFunction(Electron(Number=3) Hole)
}
```

To plot the overlap integrals between all pairs of the computed wavefunctions on a nonlocal line, specify `OverlapIntegral` in the `NonLocalPlot` section.

---

## 1D Schrödinger Equation

Omitting x- and y-coordinates for simplicity, the 1D Schrödinger equation for electrons is:

$$ \left( -\frac{\partial}{\partial z} \frac{\hbar^2}{2m_{z, \nu}(z)} \frac{\partial}{\partial z} + E_C(z) + \Delta E_\nu \right) \Psi_{j, \nu}(z) = E_{j, \nu} \Psi_{j, \nu}(z) \quad (228) $$

where:

*   $z$ is the quantization direction (typically, the direction perpendicular to the silicon–oxide interface in a MOSFET).

*   $\nu$ labels the ladder.

14: Quantization
1D Schrödinger Equation

* $\Delta E_{\nu}$ is the (region-dependent) energy offset for the ladder $\nu$.

* $m_{z, \nu}$ is the effective mass component in the quantization direction.

* $\Psi_{j, \nu}$ is the $j$-th normalized eigenfunction.

* $E_{j, \nu}$ is the $j$-th eigenenergy.

From the solution of this equation, the density is computed as:

$$ n(z) = \frac{kT(z)}{\pi \hbar^2} \sum_{j, \nu} |\Psi_{j, \nu}(z)|^2 d_{\nu} m_{xy, \nu}(z) \Big[ F_0 \Big( \frac{E_{F, n}(z) - E_{j, \nu}}{kT(z)} \Big) - F_0 \Big( \frac{E_{F, n}(z) - E_{\text{max}, \nu}}{kT(z)} \Big) \Big] + \sum_{\nu} n_{\text{cl}, \nu} $$ (229)

where $m_{xy, \nu}$ is the mass component perpendicular to the quantization direction and $d_{\nu}$ is the degeneracy for ladder $\nu$. For the parameters $m_{z, \nu}$, $m_{xy, \nu}$, $d_{\nu}$, and $\Delta E_{\nu}$, see Parameters of the 1D Schrödinger Equation on page 307.

If `DensityTail=MaxEnergy`, $E_{\text{max}, \nu}$ in Eq. 229 is the energy of the highest computed subband for ladder $\nu$; otherwise, it is an estimate of the energy of the lowest not computed subband. $n_{\text{cl}, \nu}$ is the contribution to the classical density for ladder $\nu$ by energies above $E_{\text{max}, \nu}$.

At the ends of the nonlocal line, Sentaurus Device optionally smoothly blends from the classical density to the density according to Eq. 229. Equating the resulting density to Eq. 221 determines $\Lambda_n$.

The Schrödinger equation is solved over a finite domain $[z_-, z_+]$. At the endpoints of this domain, the boundary condition:

$$ \frac{\Psi'_{j, \nu}}{\Psi_{j, \nu}} = \mp \frac{\sqrt{2m_{z, \nu} |E_{j, \nu} - E_C|}}{\hbar} $$ (230)

is applied, where for the upper sign, all position-dependent functions are taken at $z_+$ and, for the lower sign, at $z_-$.

# Notes on the Use of the 1D Schrödinger Equation

Note that:

* **Convergence problems**: Near the flatband condition, minor changes in the band structure can change the number of bound states between zero and one. By default, Sentaurus Device computes only bound states and, therefore, this change switches from a purely classical solution to a solution with quantization. To avoid the large change in density that this transition can cause, set `EnergyInterval` to a nonzero value (for example, 1). Then, a few unbound states are computed and a hard transition is avoided.

External 2D Schrödinger Solver

*   The Schrödinger solver uses an iterative method. If this iterative method fails to converge, the solution of the coupled system of all equations will not be accepted, even if the RHS and the error as reported in the log file are small.

*   Always include a part of the ‘barrier’ in the nonlocal line on which the Schrödinger equation is solved. In a MOSFET, besides the channel region, solve the Schrödinger equation in a part of the oxide adjacent to the channel (for example, 1 nm deep). Use the `Permeation` option to `NonLocal` to achieve this (see Nonlocal Mesh for the 1D Schrödinger Equation on page 306). Failure to solve in a part of the oxide adjacent to the channel blinds the Schrödinger solver to the barrier. It does not know the electrons are confined and the quantization effects are not obtained.

# External 2D Schrödinger Solver

For 3D structures, Sentaurus Device can connect to external 2D Schrödinger solvers to compute the quantum-mechanical density correction. Sentaurus Device interpolates solution-dependent data, such as band edges, quasi-Fermi potentials, and temperature, to 2D cross sections of the device, and passes it to the 2D Schrödinger solvers. From this information and their own configuration, the 2D Schrödinger solvers compute quantum-mechanical densities and pass them back to Sentaurus Device. Using these densities and Eq. 221, p. 303, Sentaurus Device computes the quantum potentials $\Lambda_n$ and $\Lambda_p$. Then, the quantum potentials are interpolated to the 3D device mesh and are used in subsequent calculations.

The connection to the external 2D Schrödinger solver is defined in the global `Physics` section:

```
ExternalSchroedinger <string> (
  NumberOfSlices=<int>      * required parameter, at least two
  Carriers = <carrierlist> * required parameter
  Volume=<string>           * optional
  SBandCommandFile=<string> * optional
  DampingLength=<float>     * in um, default 0.005
  MaxMismatch=<float>       * in um, default 1e-4
)
```

The string after `ExternalSchroedinger` is a name used to establish the connection to the 2D Schrödinger solver processes. Two Sentaurus Device processes running concurrently on the same computer, in the same working directory, must not use the same value for this name.

`NumberOfSlices` is the number of 2D slices (cross sections) of the 3D mesh on which to solve the 2D Schrödinger equation. The slices themselves are provided to Sentaurus Device by the 2D Schrödinger solver processes. They must correspond to cuts of the 3D mesh Sentaurus Device is using, that is, at the same point, the 3D mesh and the 2D slices must have the same region. Sentaurus Device checks this condition, with a tolerance that can be changed with the `MaxMismatch` parameter.

**14: Quantization**
External 2D Schrödinger Solver

To allow users to perform 3D simulations of a symmetric structure with a reduced mesh, the interface to the external 2D Schrödinger solver takes the `ThinLayer(Mirror)` specification into account (see Geometric Parameters of the LayerThickness Command on page 335). Note, however, that the 2D Schrödinger solver still needs the full 2D slices.

Slices are numbered from zero to `NumberOfSlices-1`. This number is used to refer to slices individually, for example, in error messages. The number also is used by the 2D Schrödinger solvers to identify a particular slice.

The carrier types to which you apply a quantum correction are specified by `Carriers`. Possible values are `(Electron)`, `(Hole)`, and `(Electron Hole)` to apply the correction to electrons only, holes only, or both, respectively.

The quantum correction is only applied to semiconductors. If specified, the application is further restricted to the named volume given by `Volume` (for named volumes, see Random Band Edge Fluctuations on page 742). Within that domain, the quantum correction from the 2D slices is interpolated to the volume enclosed by the slices. With increasing distance from the enclosed volume, the quantum correction is damped. For vertices farther outside the enclosed volume than the distance specified with `DampingLength`, the 2D Schrödinger quantum corrections $\Lambda_n$ and $\Lambda_p$ are zero.

> **NOTE** For typical MOSFET applications, the 2D Schrödinger solver is used mostly to account for the quantization in the active channel area. However, source and drain regions can use other simpler quantum-correction models such as density gradient (see Density Gradient Model on page 316) or MLDA (see Modified Local-Density Approximation Model on page 324). For such a combination, the `DampingLength` parameter is also used in the density gradient or MLDA quantum corrections ($\Lambda_{nO}$ and $\Lambda_{pO}$) to have a smooth transition between these corrections. The parameter defines a position-dependent damping $\alpha_{SE}$ (which is equal to 1 inside the 2D Schrödinger domain and goes to 0 at `DampingLength` distance from that domain), and the combined quantum corrections are computed as $\alpha_{SE}\Lambda_n + (1 - \alpha_{SE})\Lambda_{nO}$ and $\alpha_{SE}\Lambda_p + (1 - \alpha_{SE})\Lambda_{pO}$.

If `SBandCommandFile` is used to provide the name of a command file for Sentaurus Band Structure, then Sentaurus Device automatically starts Sentaurus Band Structure processes with this command file. Sentaurus Device passes to each process the number of the slice it handles on the command line.

Otherwise, users are responsible for starting the 2D Schrödinger solver processes, which must be started in the same working directory on the same computer as the Sentaurus Device process that connects to them.

External Boltzmann Solver

See Sentaurus™ Device Monte Carlo User Guide, Using Sentaurus Band Structure as an External Schrödinger Solver for Sentaurus Device on page 208 for details about the 2D Schrödinger solver.

## Notes on the Use of External 2D Schrödinger Solvers

One crucial step in using the interface to external 2D Schrödinger solvers is to decide the number and the placement of the slices. Usually, the quantum corrections are applied to the channel of a device. The slices at least must resolve the shape of the cross section of the channel.

Using the quantum potentials Λ<sub>*n*</sub> and Λ<sub>*p*</sub> as the quantities that are interpolated between slices, interpolation becomes insensitive to potential and quasi-Fermi potential drops along the channel. Therefore, for devices with a uniform channel cross section, one slice close to either end of the channel should be sufficient to obtain sufficient accuracy.

> **NOTE** The placement of the slices is not specified in Sentaurus Device. The only information specified in the Sentaurus Device command file about the slices it their number. The placement of the slices is the responsibility of the external 2D Schrödinger solvers. Therefore, their configuration must be consistent with the 3D mesh used by Sentaurus Device.

Similarly, the exact model for quantization, as well as band structure information beyond the band edges, is not specified by Sentaurus Device, but by the configuration of the 2D Schrödinger solvers.

## External Boltzmann Solver

For 3D structures, Sentaurus Device can connect to Sentaurus Device QTX using the Subband-BTE solver to obtain the extracted quantum-correction potential. For coupled carrier–Poisson simulations, Sentaurus Device can also use an effective mobility extracted from the Subband-BTE solver. Similar to the approach described in External 2D Schrödinger Solver on page 312, Sentaurus Device interpolates solution-dependent data, such as band edges, quasi-Fermi potentials, and temperature, to 2D cross sections of the device, and passes it to the Subband-BTE solver. From this information and its own configuration, the Subband-BTE solver computes the quantum-correction potential and the effective mobility and passes them back to Sentaurus Device for solving the coupled carrier–Poisson equations. Solution-dependent data is exchanged only on 2D cross sections, and the respective simulator interpolates it to the 3D device mesh as needed.

14: Quantization
External Boltzmann Solver

The connection to the external Boltzmann solver is defined in the global Physics section:

```
ExternalBoltzmannSolver <string> (
  NumberOfSlices=<int>             * required parameter, at least two
  Carriers = ( Electron | Hole )   * required parameter
  Mobility ( Electron | Hole )     * optional
  ContactName=<string>             * optional
  SBTECommandFile=<string>         * optional
)
```

The string after `ExternalBoltzmannSolver` is a name used to establish the connection to the Subband-BTE solver process. Two Sentaurus Device processes running concurrently on the same computer, in the same working directory, must not use the same value for this name.

`NumberOfSlices` is the number of 2D slices (cross sections) of the 3D mesh on which data is exchanged between the Sentaurus Device and Subband-BTE solver processes. The slices themselves are provided to Sentaurus Device by the Subband-BTE solver. They must correspond to cuts of the 3D mesh Sentaurus Device is using, that is, at the same point, the 3D mesh and the 2D slices must have the same region.

> **NOTE** Contrary to simulations using the external 2D Schrödinger solver, all slices for a given connection are handled by a single Subband-BTE solver process.

The keyword `Carriers` specifies the carrier type, either electron or holes, for which the Boltzmann transport equation is solved.

Unless `Mobility` is specified, only the quantum-correction potential computed by the Subband-BTE solver is passed to Sentaurus Device. Specifying `Mobility (<carrier>)` also triggers the Subband-BTE solver to extract the effective carrier mobility and to pass it to Sentaurus Device where it is applied to the 3D domain enclosed by the slices. Within that domain, the application of any other mobility model specified in the Sentaurus Device command file is suppressed.

Alternatively, if you specify the following statement, the effective mobility extracted by the Subband-BTE solver can complement certain mobility models specified in the Sentaurus Device command file:

```
Mobility (<carrier>(-DisableInternalMobilityModels))
```

Supported mobility models are:

* Carrier-carrier scattering

* Mobility degradation at interfaces

* Thin-layer mobility

14: Quantization

Density Gradient Model

*   High-field saturation

*   Ballistic mobility

Constant and doping-dependent mobility degradation models in Sentaurus Device cannot be combined with the effective mobility provided by the Subband-BTE solver.

To allow the Subband-BTE solver to output current–voltage characteristics, you can select a specific `ContactName` in the Sentaurus Device command file for which Sentaurus Device sends the value of the current to the Subband-BTE solver.

Additional optional keywords such as `Volume`, `MaxMismatch`, and `DampingLength` allow you to further control the interpolation of the quantum-correction potential and the effective mobility to the 3D mesh of Sentaurus Device and are described in External 2D Schrödinger Solver on page 312.

> **NOTE** `DampingLength` is interpreted differently for the interpolation of the quantum-correction potential and the effective mobility. For the former, the same behavior as described in External 2D Schrödinger Solver applies; whereas, for the latter, the damping length specifies the distance from the enclosed domain at which there is a discrete transition from the effective mobility extracted by the Subband-BTE solver and the mobility according to the mobility model specification in the Sentaurus Device command file.

If `SBTECommandFile` is used to provide the name of a command file for the Subband-BTE solver, Sentaurus Device automatically starts the solver process with this command file.

Otherwise, users are responsible for starting the Subband-BTE solver process, which must be started in the same working directory on the same computer as the Sentaurus Device process that connects to it.

For details about using the Subband-BTE solver, see Sentaurus™ Device QTX User Guide, Using Subband-BTE Solver as an External Solver for Sentaurus Device on page 7.

***

# Density Gradient Model

For the density gradient model [3][4], $\Lambda_n$ in Eq. 221 is given by a partial differential equation:

$$ \Lambda_n = -\frac{\gamma\hbar^2}{12m_n} \left\{ \nabla^2 \ln n + \frac{1}{2} (\nabla \ln n)^2 \right\} = -\frac{\gamma\hbar^2}{6m_n} \frac{\nabla^2 \sqrt{n}}{\sqrt{n}} \tag{231} $$

Density Gradient Model

where $\gamma = \gamma_0 \cdot \gamma_{\text{pmi}}$ is a fit factor. The $\gamma_0$ is solution independent. It is dependent on the mole fraction and the distance to the nearest insulating surface (option `AutoOrientation`). The additional factor $\gamma_{\text{pmi}}$ (solution dependent) can be defined by a PMI (see Gamma Factor for Density Gradient Model on page 1422).

Introducing the reciprocal thermal energy $\beta = 1/kT_n$, the mass-driving term $\Phi_m = -kT_n \ln(N_C/N_{\text{ref}})$ (with an arbitrary normalization constant $N_{\text{ref}}$) and the potential-like quantity $\overline{\Phi} = E_C + \Phi_m + \Lambda_n$, Eq. 231 can be rewritten and generalized as:

$$ \Lambda_n = \frac{\hbar^2 \gamma}{12m_n} \{ \nabla \cdot \alpha(\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) $$
$$ + \vartheta (\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) \cdot \alpha (\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) \} + \Lambda_{\text{PMI}} \eqno(232) $$

with the default parameters $\xi = \eta = 1$, $\vartheta = 1/2$, and $\alpha$ is a symmetric matrix that defaults to one. In insulators, Sentaurus Device does not compute the Fermi energy; therefore, in insulators, $\xi = \eta = 0$. By default, Sentaurus Device uses Eq. 232, which for Fermi statistics deviates from Eq. 231, even when $\xi = \eta = 1$ and $\vartheta = 1/2$. The density-based expression Eq. 231 is available as an option (see Using the Density Gradient Model on page 318).

Optionally, you can choose an alternative formula where the mass term appears *between* rather than *in front of* the differential operators:

$$ \Lambda_n = - \{ \nabla \cdot \frac{\hbar^2 \gamma}{12m_n} \alpha(\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) $$
$$ + \vartheta (\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) \cdot \frac{\hbar^2 \gamma}{12m_n} \alpha (\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) \} + \Lambda_{\text{PMI}} \eqno(233) $$

While Eq. 232 is the default for reasons of backward compatibility, Eq. 233 resembles more closely the Schrödinger equation and, therefore, is considered physically superior.

In Eq. 232, $\Lambda_{\text{PMI}}$ is a locally dependent quantity computed from a user-specified PMI model (see Apparent Band-Edge Shift on page 1268), from the Schenk bandgap narrowing model (see Schenk Bandgap Narrowing Model on page 265), or from apparent band-edge shifts caused by multistate configurations (see Apparent Band-Edge Shift on page 537). By default, $\Lambda_{\text{PMI}} = 0$.

At Ohmic contacts, interfaces to metals with Ohmic boundary conditions, resistive contacts, and current contacts, the boundary condition $\Lambda_n = \Lambda_{\text{PMI}}$ is imposed. At Schottky contacts, gate contacts, interfaces to metals with Schottky boundary conditions, and external boundaries, homogeneous Neumann boundary conditions are used:

$\hat{n} \cdot \alpha(\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi) = 0$.

At internal interfaces between regions where the density gradient equation is solved, $\overline{\Phi}$ must be continuous. In addition, for Eq. 232, $\hat{n} \cdot \underline{\alpha}(\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi)$ must be continuous. For Eq. 233, $\hat{n} \cdot \gamma \alpha(\xi \nabla \beta E_{F,n} - \nabla \beta \overline{\Phi} + (\eta - 1)q \nabla \beta \phi)/m_n$ must be continuous.

Density Gradient Model

At internal interfaces between a region where the equation is solved (indicated below by $0^-$) and a non-metal region where it is not solved ($0^+$), an inhomogeneous Neumann boundary condition obtained from the analytic solution of the 1D step problem is applied:

$$ \hat{n} \cdot \nabla \Lambda_n^+ = \sqrt{\frac{24m_n(0^+)kT_n}{\hbar^2 \gamma(0^+) \bar{\alpha}}} [E_C(0^+) - E_C(0^-) - \Lambda_n] f \left( \frac{2\vartheta(0^+)}{kT_n} [\Lambda_n - E_C(0^+) + E_C(0^-)] \right) \eqno(234) $$

where $f(x) = \sqrt{[(\exp x - 1) / x - 1] / x}$ and $\bar{\alpha} = \det[\alpha(0^+)]^{1/3}$.

In conjunction with Eq. 234, a homogeneous Neumann boundary condition can be imposed on interfaces of regions where quantum effects are insignificant, that is, interfaces away from the channel region in MOS devices. You should always use Eq. 234 as the boundary condition on interfaces in the channel region where quantum effects can significantly alter charge carrier concentration. The homogeneous Neumann boundary condition is:

$$ \hat{n} \cdot \nabla \Lambda_n^+ = 0 \eqno(235) $$

Optionally, Sentaurus Device offers a modified mobility to improve the modeling of tunneling through semiconductor barriers:

$$ \mu = \frac{\mu_{cl} + r\mu_{tunnel}}{1 + r} \eqno(236) $$

where $\mu_{cl}$ is the usual (classical) mobility as described in Chapter 15 on page 341, $\mu_{tunnel}$ is a fit parameter, and $r = \max(0, n/n_{cl} - 1)$. Here, $n_{cl}$ is the 'classical' density (see Eq. 409). In this modification, for $n > n_{cl}$, the additional carriers (density $n - n_{cl}$) are considered as tunneling carriers that are subject to a different mobility $\mu_{tunnel}$ than the classical carriers (density $n_{cl}$).

## Using the Density Gradient Model

The density gradient equation for electrons and holes is activated by the `eQuantumPotential` and `hQuantumPotential` switches in the `Physics` section. Use `-eQuantumPotential` and `-hQuantumPotential` to switch off the equations. These switches can also be used in regionwise or materialwise `Physics` sections. In metal regions, the equations are never solved. For a summary of available options, see Table 293 on page 1594.

The option `Formula` selects either Eq. 232 (`Formula=0`, default) or Eq. 233 (`Formula=1`).

The `Ignore` switch to `eQuantumPotential` and `hQuantumPotential` instructs Sentaurus Device to compute the quantum potential, but not to use it. `Ignore` is intended for backward compatibility to earlier versions of Sentaurus Device.

14: Quantization
Density Gradient Model

The `Resolve` switch enables a numeric approach that handles discontinuous band structures, at moderately refined interfaces that are not heterointerfaces, more accurately than the default approach.

The switch `Density` to `eQuantumPotential` and `hQuantumPotential` activates the density-based formula Eq. 231 instead of the potential-based formula Eq. 232. If this option is used, the parameters $\xi$ and $\eta$ must both be 1.

The `LocalModel` option of `eQuantumPotential` and `hQuantumPotential` specifies the name of a PMI model (see Physical Model Interface on page 1165) or the Schenk bandgap narrowing model (see Schenk Bandgap Narrowing Model on page 265) for $\Lambda_{\text{PMI}}$ in Eq. 232. An additional apparent band-edge shift contribution can be added if the corresponding model of a multistate configuration is switched on (see Apparent Band-Edge Shift on page 537).

The `BoundaryCondition` option of the `eQuantumPotential` and `hQuantumPotential` specifications in metal interface-specific or electrode-specific `Physics` sections allows you to explicitly specify the boundary condition for the quantum potential, overriding the default boundary condition. Possible values are `Dirichlet` and `Neumann`, to enforce homogeneous Dirichlet and Neumann boundary conditions, respectively.

The homogeneous Neumann boundary condition (Eq. 235) can be specified in the command file in the following ways:

* Doping density–based specification in the `Math` section:

    * `RefNd_QuantumPotential=<float>`

        All vertices on semiconductor–insulator interfaces that have a semiconductor donor doping density greater than `RefNd_QuantumPotential` are treated with the homogeneous Neumann boundary condition.

    * `RefNa_QuantumPotential=<float>`

        All vertices on semiconductor–insulator interfaces that have a semiconductor acceptor doping density greater than `RefNa_QuantumPotential` are treated with the homogeneous Neumann boundary condition.

    For example:

    ```
    Math {
      RefNd_QuantumPotential=<float>
      RefNa_QuantumPotential=<float>
    }
    ```

* Region interface–based specification in the `Physics` section:

    The `BoundaryCondition` attribute of `e|hQuantumPotential` specifications in `Physics` sections allows you to specify the boundary condition for the quantum potential on various interfaces, overriding the default nonhomogeneous boundary condition in Eq. 234.

Density Gradient Model

For example:

```
Physics(RegionInterface="Region_1/Region_2") {
  eQuantumPotential(BoundaryCondition = HomogeneousNeumann)
}
```

The region interface specification can be combined with a doping-based specification in the Math section.

*   Homogeneous boundary condition in a box:

In this approach, you use a box to apply a nonhomogeneous boundary condition only on interfaces inside the box. The box information is the same as that of eQPBox and hQPBox in the command file as described in Notes on the Use of the Density Gradient Model on page 322 with the additional `QboxForBC` keyword. For example:

```
Math {
  eQPBox(QboxForBC {MinX=0.042 MaxX=0.045 MinY=0.008 MaxY=0.015}
              {MinX=0.022 MaxX=0.027 MinY=0.002 MaxY=0.004}
  )
  hQPBox(QboxForBC {MinX=0.042 MaxX=0.045 MinY=0.008 MaxY=0.015}
              {MinX=0.022 MaxX=0.027 MinY=0.002 MaxY=0.004}
  )
}
```

Unlike the evaluation box described in Notes on the Use of the Density Gradient Model, which effectively suppresses the quantum potential outside the box, the presence of the `QboxForBC` keyword allows for the density-gradient solution in all materials specified in the command file with an interface-specific boundary condition, that is, interfaces with nonhomogeneous boundary conditions inside the box and homogeneous boundary conditions outside the box.

Apart from activating the equations in the Physics section, the equations for the quantum corrections must be solved by using `eQuantumPotential` or `hQuantumPotential`, or both in the Solve section. For example:

```
Physics { eQuantumPotential }

Plot { eQuantumPotential }

Solve {
  Coupled { Poisson eQuantumPotential }
  Quasistationary (
    DoZero InitialStep=0.01 MaxStep=0.1 MinStep=1e-5
    Goal { Name="gate" Voltage=2 }
  ){
    Coupled { Poisson Electron eQuantumPotential }
  }
}
```

**14: Quantization**
Density Gradient Model

The quantum corrections can be plotted. To this end, use `eQuantumPotential`, or `hQuantumPotential`, or both in the `Plot` section.

To activate the mobility modification according to Eq. 236, specify the `Tunneling` switch to `Mobility` in the `Physics` section of the command file. Specify $\mu_{\text{tunnel}}$ for electrons and holes by the `mutunnel` parameter pair in the `ConstantMobility` parameter set.

The parameters $\gamma$, $\vartheta$, $\xi$, and $\eta$ are available in the `QuantumPotentialParameters` parameter set. The parameters can be specified regionwise and materialwise. They cannot be functions of the mole fraction in heterodevices. In insulators, $\xi$ is always assumed as zero, regardless of user specifications.

The diagonal of $\alpha$ in the crystal coordinate system (see Crystal and Simulation Coordinate Systems on page 836) is determined by the parameter pairs `alpha[1]`, `alpha[2]`, and `alpha[3]` (for the $x$-direction, $y$-direction, and $z$-direction, respectively) in the `QuantumPotentialParameters` parameter set. Unless $\alpha$ is a multiple of the unit matrix, Sentaurus Device solves an anisotropic problem.

The following example decreases the quantization effect along the $y$-direction to half, for both electrons and holes:

```
QuantumPotentialParameters {
  alpha[1] = 1   1
  alpha[2] = 0.5 0.5
}
```

The anisotropic density-gradient equation supports the `AverageAniso` approximation (see Chapter 28 on page 833) and the tensor grid approximation (see Tensor Grid Option on page 948). For the latter, `TensorGridAniso` must be selected as the numeric method in the `Math` section, and either `eQuantumPotential` or `hQuantumPotential` must be specified as an option of `Aniso` in the `Physics` section. For example:

```
Physics { Aniso (eQuantumPotential) }
Math { TensorGridAniso(Aniso) }
```

## Named Parameter Sets for the Density Gradient Model

The `QuantumPotentialParameters` parameter set can be named. For example, in the parameter file, to declare a parameter set with the name `myset`, you can write:

```
QuantumPotentialParameters "myset" { ... }
```

To use a named parameter set, specify its name with `ParameterSetName` as an option to either `eQuantumPotential` or `hQuantumPotential in the command file. For example:

```
Physics { eQuantumPotential (ParameterSetName = "myset") }
```

Density Gradient Model

By default, the unnamed parameter set is used.

## Auto-Orientation for the Density Gradient Model

The `eQuantumPotential` and `hQuantumPotential` models support the auto-orientation framework (see Auto-Orientation Framework on page 38) that switches between different named parameter sets based on the orientation of the nearest interface. This can be activated by specifying `AutoOrientation` as an argument to either `eQuantumPotential` or `hQuantumPotential` in the command file. For example:

```
Physics { eQuantumPotential (AutoOrientation) }
```

# Notes on the Use of the Density Gradient Model

Note that:

*   **Fitting parameters:** The parameter $\gamma$ has been calibrated only for silicon. The quantum correction affects the densities and field distribution in a device. Therefore, parameters for mobility and recombination models that have been calibrated to classical simulations (or simulations with the van Dort model) might require recalibration.

*   **Evaluation box:** You can improve convergence by solving the density gradient equations only within regions that are adequately meshed for that task. For example, in FinFETs, it is understood that, for a fin situated on a large substrate, given the oppressive cost of meshing the surface of the substrate to density gradient standards, it is beneficial to solve the equations only in the fin.

    This works well if the fin can be specified as a unique region that coincides with the domain over which the quantum potential is useful. However, in structures formed by Sentaurus Process, such precise registration of regions might not be possible.

    An alternate approach is to reduce the quantum potential in parts of a region that are not of interest. In this approach, the parameter $\gamma$ effectively attenuates the quantum potential outside the ‘Box’ where the solution of quantum potential might cause convergence issues. The corresponding command file can be written as:

```
Math {
  eQPBox({MinX=0.042 MaxX=0.045 MinY=0.008 MaxY=0.015 Attenuation_Length=1e-3}
         {MinX=0.022 MaxX=0.027 MinY=0.002 MaxY=0.004 Attenuation_Length=2e-3}
  )
  hQPBox({MinX=0.042 MaxX=0.045 MinY=0.008 MaxY=0.015 Attenuation_Length=2e-3}
         {MinX=0.022 MaxX=0.027 MinY=0.002 MaxY=0.004 Attenuation_Length=4e-3}
  )
}
```

14: Quantization
Density Gradient Model

The parameter $\gamma$ is effectively attenuated using an error function for each of the six specified domain boundaries. `Attenuation_Length` determines the decay of the transition, where 0 is abrupt, and the default value is 1e-3 $\mu$m.

*   **Tunneling:** The density gradient model increases the current through the semiconducting potential barriers. However, this effect is not a trustworthy description of tunneling through the barrier. To model tunneling, use one of the dedicated models that Sentaurus Device provides (see Chapter 24 on page 767). To suppress unwanted tunneling or to fit tunneling currents despite these concerns, consider using the modified mobility model according to Eq. 236.

*   **Convergence:** In general and particularly for the density gradient corrections, solving additional equations worsens convergence. Typically, it is advisable to solve the equations for the quantum potentials whenever the Poisson equation is solved (using a `Coupled` statement). Usually, the best strategy to obtain an initial solution at the beginning of the simulation is to do a coupled solve of the Poisson equation and the quantum potentials, without the current and temperature equations.

To obtain this initial solution, it is sometimes necessary that you set the `LineSearchDamping` optional parameter (see Damped Newton Iterations on page 145) to a value less than 1; a good value is 0.01.

Often, using initial bias conditions that induce a current flow work well for a classical simulation, but do not work when the density gradient model is active. In such cases, start from equilibrium bias conditions and put an additional voltage ramping at the beginning of the simulation.

If an initial solution is still not possible, consider using Fermi statistics (see Fermi Statistics on page 182). Check grid refinement and pay special attention to interfaces between insulators and highly doped semiconductor regions. For classical simulations, the refinement perpendicular to such interfaces is often not critical, whereas for quantum mechanical simulations, quantization introduces variations at small length scales, which must be resolved.

*   **Avalanche:** The combination of using the density gradient model with an avalanche model can sometimes degrade convergence. An option is available in the `Math` section that can often result in better convergence in this situation:

```
Math {RefDens_QuantumPotential=<n₀>}
```

where $n_0$ is the carrier concentration below which the effects of quantum corrections are reduced.

*   **Speed:** Activate the equations only for regions where the quantum corrections are physically needed. For example, usually, the density gradient equations do not need to be computed in insulators. Using the model selectively, typically, also benefits convergence.

*   By default, the DOS mass used in the expressions of the density gradient method ignores the effects of strain (see Strained Effective Masses and Density-of-States on page 895). This is accomplished by using the expression $m_n = m_{n0} + \nu \cdot \Delta m_n$ with a default value of

Modified Local-Density Approximation Model

$\nu = 0$, where $m_{n0}$ is the unstrained mass and $\Delta m_n$ is the change in mass due to strain. The parameter $\nu$ can be specified in the `QuantumPotentialParameters` parameter set.

*   **Homogeneous Neumann boundary condition:** Applying this boundary condition (Eq. 235) to interfaces in highly doped regions and to semiconductor–shallow trench isolation interfaces often results in better convergence behavior without affecting device characteristics. It is particularly helpful when impact ionization and nonlocal band-to-band tunneling models are used for device simulations (see Chapter 16 on page 419).

*   By default, the density gradient model uses an exponential approximation in the continuity equation, which gives its solution as the carrier concentration multiplied by a quantum-mechanical factor. To activate another approximation where the quantum potential is applied directly to the electrostatic potential as a quantum-mechanical band edge, use keyword `DirectQuantumCorrection` in the global `Math` section.

# Modified Local-Density Approximation Model

The modified local-density approximation (MLDA) model is a quantum-mechanical model that calculates the confined carrier distributions that occur near semiconductor–insulator interfaces [[5]](reference_5). It can be applied to both inversion and accumulation, and simultaneously to electrons and holes. It is based on a rigorous extension of the local-density approximation and provides a good compromise between accuracy and runtime.

Following Paasch and Übensee [[5]](reference_5), the confined electron density at a distance $z$ from a Si–SiO<sub>2</sub> interface is given, under Fermi statistics, by:

$$ n_{\text{MLDA}}(\eta_n) = N_C \left( \frac{2}{\sqrt{\pi}} \right) \int_0^\infty d\varepsilon \frac{\sqrt{\varepsilon}}{1 + \exp[(\varepsilon - \eta_n)]} [1 - j_0(2z\sqrt{\varepsilon}/\lambda_n)] \eqno(237) $$

where $\eta_n$ is given by Eq. 49, p. 183, $j_0$ is the 0<sup>th</sup>-order spherical Bessel function, and $\lambda_n = \sqrt{\hbar^2 / 2m_{qn}kT_n}$ is the electron thermal wavelength which depends on the quantization mass $m_{qn}$. The integrand of Eq. 237 is very similar to the classical Fermi integrand, with an additional factor describing confinement for small $z$. A similar equation is applied to holes.

Sentaurus Device provides the following MLDA model options:

*   One option is the simple original model that uses only one user-defined parameter $\lambda$ per carrier type.

*   The second option (considered in Interface Orientation and Stress Dependencies) accounts for the multivalley/band property of the electron and hole band structures.

14: Quantization
Modified Local-Density Approximation Model

For the simple model, in Boltzmann statistics, Eq. 237 simplifies to the following expression for the electron density (the hole density is similar):

$$ n_{MLDA}(\eta_n) = N_C \exp(\eta_n) [1 - \exp(-(z/\lambda_n)^2)] $$ (238)

# Interface Orientation and Stress Dependencies

The MLDA model allows you to consider a dependency of the quantization effect on interface orientation and stress. Mainly, such dependencies come from mass anisotropy and stress related valley/band energy change.

Mass anisotropy has been considered in the literature [6] where ellipsoidal type of bands, which correspond to three electron $\Delta_2$-valleys in silicon, were used. The main result of the article is that Eq. 237 is still valid for each of three electron $\Delta_2$-valleys with the effective DOS equal to $N_C/3$.

Another result is that the quantization mass of each valley $m_{qn}^i$ should be computed as a rotation of the inverse mass tensor from the crystal system (where the tensor is diagonal) to another one where one axis is perpendicular to the interface and the mass component, which corresponds to the axis, should be taken as $m_{qn}^i$.

Considering three electron $\Delta_2$-valleys, Eq. 237 could be rewritten as follows:

$$ n_{MLDA}(\eta_n, z) = \sum_{i=1}^3 \int_0^\infty \frac{D_n^i(\epsilon, z)}{1 + \exp(\epsilon - \eta_n - \Delta\eta^i)} d\epsilon $$
$$ D_n^i(\epsilon, z) = N_C g_n^i \left(\frac{2}{\sqrt{\pi}}\right) \sqrt{\epsilon} \left[1 - j_0 \left(2z \sqrt{\frac{2m_{qn}^i kT_n \epsilon}{\hbar^2}}\right)\right] $$ (239)

where:

*   $D_n^i(\epsilon, z)$ is the electron DOS of valley $i$ with a dependency on the normalized energy $\epsilon$ and on the distance to the interface $z$.

*   $g_n^i$ is defined by Eq. 205, p. 289 or Eq. 206, p. 289; however, in the case of stress, $N_C g_n^i$ is defined by Eq. 991, p. 896.

*   $\Delta\eta^i$ represents the stress-induced valley energy change (see Deformation of Band Structure on page 890).

Similar to Eq. 239, the same multivalley MLDA quantization model could be applied to holes with hole bands defined in the `MultiValley` section of the parameter file described in Multivalley Band Structure on page 281, but such spherical or ellipsoidal hole bands do not produce a correct dependency of the hole quantization on the interface orientation. Therefore,

Modified Local-Density Approximation Model

for holes, the six-band k·p band structure is used. The bulk six-band k·p model is described in [[14]](https://example.com/14)[[15]](https://example.com/15) of Chapter 31 on page 885. An extension of the MLDA model is formulated for arbitrary bands and applied to the six-band k·p band structure [[7]](https://example.com/7).

The DOS of one hole band is written generally as follows:

$$ D^i(\varepsilon, z) = \frac{2}{(2\pi)^3} \oint \frac{dS}{|\nabla_k \varepsilon^i(\vec{k})|} \left[ 1 - \exp \left( i2z\gamma_{kp} \sum_j k_j \frac{w_{j3}(\vec{k})}{w_{33}(\vec{k})} \right) \right] $$ (240)

where:

*   $\varepsilon^i(\vec{k})$ is a hole band dispersion of the bulk six-band k·p model (the model considers three bands: heavy holes, light holes, and the spin-orbit split-off band holes).

*   The surface integral is in k-space over isoenergy surface $S$ defined by $\varepsilon^i(\vec{k}) = \varepsilon$.

*   $w_{ij}$ are components of the reciprocal mass tensor computed locally on the isoenergy surface.

*   $\gamma_{kp}$ is a fitting parameter that accounts for the nonparabolicity of hole bands in the MLDA model.

The hole density near the interface is computed similarly to the electron one in Eq. 239, but with the DOS from Eq. 240. The interface orientation and stress dependencies of the hole quantization are defined naturally by the physical property of the six-band k·p model.

# Heterojunctions

Originally, the MLDA quantization model was developed to describe the carrier density at semiconductor–insulator interfaces where a zero density (wavefunction) assumption on the interface is a reasonable approximation due to a typically high-band offset between the semiconductor and insulator. Such an assumption is mostly incorrect if the model is applied to heterojunctions where the band offset between two semiconductors is small. To apply the MLDA model to heterojunctions [[8]](https://example.com/8), you can use a wave penetration length in the model:

$$ z_0 = \frac{\hbar}{\sqrt{2m\Delta\varepsilon}} $$ (241)

where $m$ is the carrier (electron or hole) effective mass of the low-bandgap semiconductor, and $\Delta\varepsilon$ is the band offset between two semiconductors (in the conduction or valence band). According to [[8]](https://example.com/8), the penetration length $z_0$ is simply added to the interface distance $z$ in Eq. 237–Eq. 240.

14: Quantization
Modified Local-Density Approximation Model

# Nonparabolic Bands and Geometric Quantization

Other effects that can play an important role, for example, in III–V semiconductors are the band nonparabolicity and geometric quantization in thin-layer structures. For the bulk case, the carrier density computation with the nonparabolic bands is described in Nonparabolic Band Structure on page 282. To account for this effect and 1D geometric quantization (between two parallel interfaces that confine the carriers) in the MLDA model, the DOS in Eq. 239 must be replaced with the following [9]:

$$ D_n^i(\varepsilon, z) = N_C g_n^i \left( \frac{2}{\sqrt{\pi}} \right) (1 + 2kT_n \alpha^i \varepsilon') \sqrt{\varepsilon' (1 + kT_n \alpha^i \varepsilon')} [1 - j_0(zK) - j_0((L_z - z)K) + j_0(L_z K)] $$

$$ K = 2 \sqrt{\frac{2m_{qn}^i kT_n \varepsilon' (1 + kT_n \alpha^i \varepsilon')}{\hbar^2}} \quad \varepsilon' = \varepsilon + \frac{\varepsilon_1}{kT_n} \quad \varepsilon_1 = \frac{-1 + \sqrt{1 + \frac{2\alpha^i}{m_{qn}^i} \left( \frac{\hbar \pi}{L_z} \right)^2}}{2\alpha^i} $$ (242)

where:

*   $\alpha^i$ is the band nonparabolicity.

*   $L_z$ is a distance between the parallel interfaces.

*   $\varepsilon_1$ is the first subband energy of the infinite-barrier quantum well with size $L_z$.

Eq. 242 assumes that the DOS is equal to zero up to the first subband energy $\varepsilon_1$ and this gives an effect of bandgap widening in thin-layer structures.

For the hole six-band k·p bands in Eq. 240, geometric quantization is accounted for similarly by using the first subband energy $\varepsilon_1$. In this case, the quantization mass in $\varepsilon_1$ is taken to be energy dependent along the quantization direction, which comes from the reciprocal mass tensor $w_{ij}$ used in Eq. 240.

This MLDA quantization option is implemented using the multivalley carrier density model described in Multivalley Band Structure on page 281. It uses all of the valley and mass parameter definitions of the multivalley model in the `MultiValley` section of the parameter file. In addition, it applies a numeric integration of Eq. 237, Eq. 239 based on Gauss–Laguerre quadratures as described in Nonparabolic Band Structure on page 282. The numeric integration is applied to both Fermi–Dirac statistics and Boltzmann statistics. By default, the model automatically finds the closest interface and accounts for its orientation by recomputing the quantization mass for each valley and channel mesh point. The interface orientation is found using a vector normal to the interface and an orientation of the simulation coordinate system in reference to the crystal system defined in the `LatticeParameters` section of the parameter file (see Crystal and Simulation Coordinate Systems on page 836). For fitting purposes, you have an option to define a specific quantization mass for each valley using the parameter file (see Using the MLDA Model on page 328).

Modified Local-Density Approximation Model

---

## Using the MLDA Model

To activate the multivalley orientation–dependent model, the keyword `MLDA` must be used in the `MultiValley` statement of the `Physics` section:

```
Physics { MultiValley(MLDA) }
```

To activate the model only for electrons or holes, use `eMultiValley(MLDA)` or `hMultiValley(MLDA)`, respectively.

You can modify parameters of the model in the `MultiValley` section of the parameter file (see Using Multivalley Band Structure on page 285). By default, longitudinal and transverse effective masses are specified in the `(e|h)Valley` sections. These masses form the inverse mass tensor in the valley ellipsoidal coordinate system, which is rotated to the interface system, and is used to compute the quantization mass $m_q$.

For users who want to define a constant quantization mass per valley, ignoring automatic interface orientation dependency, there is an option to define it in the `Valley` statement:

```
MultiValley { (e|h)Valley(mq = mq) }
```

To activate the multivalley MLDA model based on the six-band k·p band structure for holes (see Eq. 240) or the two-band k·p model for $\Delta_2$ electron valleys, an additional keyword must be used:

```
Physics { MultiValley(MLDA kpDOS) }
```

In this case, all k·p model parameters are defined in the `LatticeParameters` section of the parameter file (see Using Strained Effective Masses and DOS on page 898). The fitting parameter $\gamma_{kp}$ in Eq. 240 should be specified as a value of the parameter `hkpDOSfactor` in the `MLDAQMModel` section of the parameter file as follows:

```
MLDAQMModel{
   hkpDOSfactor = 0.4
   ekpDOSfactor = 1.0
}
```

The parameter `ekpDOSfactor` can be used as a fitting parameter for the electron multivalley MLDA model (as a factor to $z$ in Eq. 239) if `eMultiValley(MLDA kpDOS)` is specified in the `Physics` section of the command file. To use the multivalley MLDA model for both k·p bands and valleys defined in the parameter file, `MultiValley(MLDA kpDOS parfile)` must be used.

To apply the MLDA model to heterojunctions, the penetration length $z_0$ (see Eq. 241) must be specified (default is zero) in the parameter file for electrons and holes separately. This length is considered to be a fitting parameter specific for heterojunctions, and Eq. 241 should be used only as a reference.

14: Quantization

Modified Local-Density Approximation Model

For example, with a 5 Å penetration, the penetration length can be specified as:

```
MLDAQMModel{
  ePenetration = 5e-8  # [cm]
  hPenetration = 5e-8  # [cm]
}
```

To activate the multivalley MLDA model with nonparabolic bands (Eq. 242), the keywords `Multivalley(MLDA Nonparabolicity)` must be specified. If the nonparabolicity should be ignored only in the MLDA part of the model (in the Bessel functions $j_0$ of Eq. 242), you must use `MLDA(-Nonparabolicity)`.

To have the geometric quantization accounted for as in Eq. 242 (the part dependent on the quantization length $L_z$), the `ThinLayer` keyword must be in the `MultiValley` statement and the `LayerThickness` statement must be set. All `LayerThickness` options are described in Extracting Layer Thickness on page 333 where generally the layer thickness (the quantization length $L_z$) can be extracted automatically for defined regions.

Practically, if the geometric quantization is mostly 1D, such a setting can be as simple as:

```
LayerThickness( Thickness = Lz )
Multivalley(MLDA ThinLayer)
```

For more complicated cases, such as for rectangular nanowires, the geometric quantization at corners is important and the following statements with automatic extraction of the quantization length $L_z$ can be used:

```
LayerThickness( MaxFitWeight = 0.35 DimensionWeight = 1.0 )
Multivalley(MLDA ThinLayer)
```

The parameter `DimensionWeight` is specific to the model where the first subband energy $\epsilon_1$ is used, as in Eq. 242. This parameter works as a factor to $\epsilon_1$ and is designed as a fitting factor to effectively account for multidimensional quantization. Its default value is 1, but it should be increased with a reduction of the nanowire size.

To plot the electron and hole effective quantum corrections of the quantization models activated in the `Multivalley` statement (`MLDA` and `ThinLayer`), the `eMVQMBandgapShift` and `hMVQMBandgapShift` keywords must be present in the `Plot` section.

By default, the MLDA model looks for all semiconductor–insulator interfaces and calculates the normal distance $z$ in Eq. 237–Eq. 240 to the nearest interface. The MLDA model also uses the `EnormalInterface` option and the `GeometricDistances` option (see Normal to the Interface on page 380). To improve numerics if there is a coarse mesh in highly doped regions, there is an option to compute an averaged distance from a vertex to the interface based on element volumes and interface distances of elements, which contain the vertex (surrounding elements).

Modified Local-Density Approximation Model

The option is implemented only for the multivalley MLDA and has an adjusting parameter that can be specified as follows:

```
Math { MVMLDAcontrols(AveDistanceFactor = 0.05) }
```

The default value of the parameter is 0.05 but, if it is equal to zero, the normal distance $z$ is not modified by such averaging. If the parameter is unit, the distance $z$ will be computed as an averaged distance using the normal distances of all vertices of the surrounded semiconductor elements with element–vertex volume weights.

To control a distance from the interface where the multivalley MLDA models will be applied, use the following statement:

```
Math { MVMLDAcontrols(MaxIntDistance = 1e-6) }
```

The default value of `MaxIntDistance` is 10<sup>–6</sup> cm .

To control the multivalley MLDA models by the doping concentration (for example, to exclude partially source/drain regions), the following command can be used:

```
Math { MVMLDAcontrols(MaxDoping4Majority = 1e19) }
```

where `MaxDoping4Majority` defines the maximum doping concentration where the multivalley MLDA models are applied for majority carriers. For example, if `MaxDoping4Majority` is equal to zero, it excludes source/drain regions completely and the models are applied only for minority carriers. The default value of `MaxDoping4Majority` is 10<sup>22</sup> cm<sup>–3</sup> , that is, there are no limitations related to the doping concentration.

If the statement `hMultivalley(MLDA kpDOS)` is activated, then the model performs an initial computation of energy-dependent data based on the bulk six-band k·p dispersion model. This computation might be time consuming, especially for 3D simulations and with the `hSubband` model active (see Mobility Modeling on page 902).

To control the accuracy of surface integration in Eq. 240, p. 326, you can use the following grid setting in $k$-space, `Math{ kGridSizeFor6kpMLDA(Nphi,Ntheta) }`, where `Nphi` and `Ntheta` define the number of points for an angular spherical coordinate system. Due to symmetry and possibly the stress effect in DOS, half of the $k$-space is used, where both angles are changed from 0° to 180°. The default setting is `kGridSizeFor6kpMLDA(25,25)`.

To separate this initial computation from bias ramping, there is an option to save and load the energy-dependent data file. For example:

```
Math { MVMLDAcontrols(Save = "file_name") }
Math { MVMLDAcontrols(Load = "file_name") }
```

If `LoadWithInterpolation= "file_name"` is used, then the saved data file could have a mesh different to the simulation one, and this option will interpolate the data to the simulation mesh.

14: Quantization

Modified Local-Density Approximation Model

In addition, to exclude source/drain or other regions, the keyword `MLDAbox` can be used to define the range of the interface from which the MLDA distance function is calculated:

```
Math{
    EnormalInterface(
        regionInterface=["SemiRegion/InsulRegion"]
        materialInterface=["OxideAsSemiconductor/Silicon"]
    )
    * single MLDAbox
    MLDAbox( MinX=-0.1, MaxX=0.1, MinY=-0.01, MaxY=0.01 )
    * multiple MLDAbox
    MLDAbox( { MinX=-0.1, MaxX=0.1, MinY=-0.01, MaxY=0.01 }
             { MinX=-0.1, MaxX=0.1, MinY= 0.05, MaxY=0.06 } )
}
```

The unit of the parameters `MinX`, `MaxX`, `MinY`, and `MaxY` in the `MLDAbox` is micrometer.

To activate the simple MLDA model (with one parameter $\lambda$ per carrier type), use the keyword `MLDA` in the `Physics` section. To activate the model for electrons or holes only, use `eMLDA` or `hMLDA`. The model also can be specified in the regionwise or materialwise `Physics` section, and can be switched off by using `-MLDA`, `-eMLDA`, or `-hMLDA`.

By default, the thermal wavelength is computed from the thermal wavelengths at 300 K as $\lambda = \lambda_{300}\sqrt{300\text{ K}/T_n}$; alternatively, $\lambda = \lambda_{300}$ can be used.

To activate or deactivate the temperature dependence of the thermal wavelength, the `LambdaTemp` switch can be specified as an option to `MLDA`:

```
Physics {
    MLDA (           * eMLDA | hMLDA for one carrier
        -LambdaTemp  * switch off temperature dependency
    )
}
```

In Table 46, the default values of $\lambda_{300}$ were determined by comparison with the Schrödinger equation solver at 23.5 Å and 25.0 Å for electrons and holes, respectively. These parameters are accessible in the `MLDA` parameter set.

Table 46 Default coefficients for MLDA model

| Symbol | Electrons | Holes | Unit |  |  |
| --- | --- | --- | --- | --- | --- |
| $\lambda_{300}$ | eLambda | 23.5$\times$10-8 | hLambda | 25$\times$10-8 | cm |

To plot the electron and hole effective quantum corrections of the simple MLDA model (see Eq. 237), the `eMLDAQuantumPotential` and `hMLDAQuantumPotential` keywords must be present in the `Plot` section.

Quantum-Well Quantization Model

## Notes on the Use of the MLDA Model

Note that:

* For each carrier type, only one of the two MLDA options (either multivalley `(e|h)MultiValley(MLDA)` or only `(e|h)MLDA`) can be used in the `Physics` section.

* The multivalley MLDA model can be used to compute stress-related mobility change (see Mobility Modeling on page 902) and, therefore, it is required to be switched on for these mobility models. However, for some cases, other quantum models might be needed in the carrier density computation. For such cases, the multivalley MLDA model can be activated for all models except the density as follows:

```
(e|h)MultiValley(MLDA -Density)
```

Such activation (exclusion of the multivalley option from the density computation) is global for the whole device even if it appears in one region of the device only.

* Theoretically, the MLDA model should give zero carrier density at the semiconductor–insulator interface. However, since the zero carrier density results in various numeric problems, the actual values of carrier density at the interface calculated by the program are very small but greater than zero. This is achieved by assuming a very thin transition layer (one-hundredth of an ångström) between the insulator and the semiconductor.

* MLDA quantization is switched off at contacts and at a small distance to the contacts (to avoid numeric and physical inconsistencies). By default, the distance to the contacts (where the model is switched off) is 75 Å.

To change the distance, use `MLDAMinDistanceToContact=<number>` (in units of $\mu$m) in the `Math` section.

## Quantum-Well Quantization Model

The quantum-well quantization model is activated in the `Physics` section for semiconductor regions using the `eDensityCorrection` and `hDensityCorrection` options of `QWLocal`. For example:

```
Physics(Region = "well") {
  QWLocal(
    eDensityCorrection
    hDensityCorrection
  )
}
```

For additional options of `QWLocal`, see Localized Quantum-Well Model on page 1044 and Table 250 on page 1570.

14: Quantization
Extracting Layer Thickness

The *quantum well* is composed of all regions in which this model is active. Sentaurus Device computes the local thickness $t$ of the quantum well and, together with the local electric field $F$, computes the electron density as:

$$n = \frac{kT}{t \hbar^2 \pi} \sum_{\nu} d_{\nu} m_{xy, \nu} \sum_{j} F_0 \left( \frac{E_{F, n} - \tilde{E}_C - E_{j, \nu}(F, t)}{kT} \right)$$ (243)

A similar expression is used for holes. In Eq. 243, $j$ runs over all subbands of band $\nu$. The eigenenergy $E_{j, \nu}(F, t)$ is measured relative to the band edge $\tilde{E}_C$ at the center of the well. $E_{j, \nu}(F, t)$ and $E_C$ are computed from the local field $F$ and the local band edge $E_C$, assuming that the field in the well is constant and equal to $F$, and that the barriers limiting the well are symmetric and are given by the average barrier height of the entire quantum well.

During Newton iterations, large fields can occur, which can cause the `QWLocal` implementation to take a lot of time and memory. With the `MaxElectricField` parameter of `QWLocal`, you can set a cutoff value for the field. The default is $10^6$ V/cm. To ensure that the cutoff does not affect the result, you can check that, for the converged solution, the electric field in the well does not exceed the cutoff.

Contrary to the 1D Schrödinger equation (see Parameters of the 1D Schrödinger Equation on page 307), which can extract the number of ladders and its parameters automatically, an explicit ladder specification (see Explicitly Specifying Ladders on page 308) is required in the parameter file. The number of bands in the ladders must be the same over the entire quantum well and in the regions adjacent to it. To specify the number of subbands to be computed for electrons, heavy holes, and light holes, use the keywords `NumberOfElectronSubbands`, `NumberOfHeavyHoleSubbands`, and `NumberOfLightHoleSubbands`, respectively.

**NOTE** To use the quantum-well quantization model, you must use the `HeteroInterface` or the `Thermionic` keyword. Furthermore, each quantum-well region must be adjacent to at least one semiconductor barrier region.

To use the quantum-well quantization model in the context of the simulation of light-emitting diodes, see Localized Quantum-Well Model on page 1044 and Table 250 on page 1570.

# Extracting Layer Thickness

Sentaurus Device provides models (for example, MLDA and mobility) that account for quantum-mechanical effects that occur in thin semiconducting films. These models use a parameter `LayerThickness`, which is intrinsically one-dimensional; it is well defined only in the case of an infinite sheet of fixed thickness. Sentaurus Device generalizes this parameter to arbitrary structures in two and three dimensions using the concept of the *radius of the largest*

Extracting Layer Thickness

*sphere that fits in a material and touches the surface point nearest a given point.* Therefore, a `LayerThickness` is defined as a scalar field throughout a structure.

Sentaurus Device can compute `LayerThickness` in one of the following ways:

*   Using the `LayerThickness` command:

```
LayerThickness(<geo_parameters>)
```

*   Using the `ThinLayer` subcommand (see Thin-Layer Mobility Model on page 381):

```
Mobility(ThinLayer(<geo/physical_parameters>)
```

As a result, there are two scalar arrays: `LayerThickness` and `LayerThicknessField`.

By default, both the `LayerThickness` and `LayerThicknessField` arrays are valid only in semiconductors. For `LayerThicknessField` only, the material group where the array is valid can be selected by the `AllowLayerThickness` keyword in the global `Math` section. Possible values are `Semiconductor` (default), `Insulator`, `Metal`, and `Everywhere`.

> **NOTE** Use the `LayerThickness` command only in region- or material-specific `Physics` sections. In particular, if you use the command in the global `Physics` section, the layer will be composed of all regions of the allowed material types. Using the `LayerThickness` command with `AllowLayerThickness=Everywhere` always results in an infinite layer.

# Combining the LayerThickness Command and ThinLayer Subcommand

To activate the `LayerThickness` command, you must specify the `LayerThickness` keyword with geometric parameters in the region, or material, or global `Physics` section. If the mobility model contains the `ThinLayer` subcommand with geometric parameters, this model uses the `LayerThickness` array; otherwise, the `LayerThicknessField` array will be used. For all other `ThinLayer`-dependent models, an external `LayerThickness` command must be set.

## Example 1

```
Physics (Material= Silicon) {
  # LayerThickness command: computation LayerThicknessField array
  LayerThickness(<geo_params>)

  # ThinLayer without <geo_params>: mobility uses LayerThicknessField array
  Mobility(ThinLayer(<physical_params>))
  MultiValley( ThinLayer )    # MultiValley uses LayerThicknessField array
}
```

**14: Quantization**
Extracting Layer Thickness

**Example 2**

```
Physics (Material= Silicon) {
  # LayerThickness command: computation LayerThicknessField array
  LayerThickness(<geo_params>)

  # ThinLayer with <geo-params>: mobility uses LayerThickness array
  Mobility( ThinLayer(<geo_params> <physical_params>) )

  MultiValley( ThinLayer )        # MultiValley uses LayerThicknessField array
}
```

**Example 3**

```
Physics (Material= Silicon) {     # without external LayerThickness command
  # mobility uses LayerThickness array
  Mobility( ThinLayer(<geo_params> <physical_params>) )
  MultiValley( ThinLayer )        # error: LayerThickness command must be set
}
```

# Geometric Parameters of the LayerThickness Command

The `LayerThickness` command has the following optional parameters: `Thickness`, `ChordWeight`, `MinAngle`, and `MaxFitWeight`.

> **NOTE** The `ThinLayer` subcommand has the same `<geo_params>` as well as the optional `<physical_params>` (see Using the Thin-Layer Mobility Model on page 383).

The parameter `Thickness` explicitly specifies the thickness of a layer (in micrometers). If it is not present, Sentaurus Device extracts the thickness automatically. For the extraction, it assumes that all regions where `ThinLayer` is specified (regardless of carrier type) belong to the thin layer.

> **NOTE** The external boundary is not considered to be a boundary of the thin layer. However, each interface between a region that specifies `ThinLayer` and a region that does not is considered to be a boundary of the thin layer, even if these two regions are both semiconductor regions.

The following example activates the computation of the `LayerThicknessField` array in regions A and B:

```
Physics(Region="A") { LayerThickness() }
Physics(Region="B") { LayerThickness(Thickness=0.005) }
```

Its thickness is extracted in region `A` and is assumed to be 5 nm in region `B`.

335

Extracting Layer Thickness

If the structure is a part of a larger symmetric structure and the full structure can be obtained by mirroring the simulated structure at a symmetry plane, the option `Mirror` must be activated in the global `Math` section.

`Mirror` is a vector that has the dimension of the device. Each component of the vector denotes the mirroring property for the corresponding axis and can have one of the values:

* None (no symmetry plane perpendicular to the axis).

* Max (symmetry plane at the largest coordinate of the axis).

* Min (symmetry plane at smallest coordinate).

* Both (symmetry planes at largest and smallest coordinates).

The following example means that there is a symmetry plane at the largest y-coordinate, as well as the smallest and largest z-coordinates:

```
Math {
  ThinLayer ( Mirror = (None Max Both) )
}
```

The full structure is six times bigger than the simulated one.

You can verify the proper thickness extraction using the plot variables `LayerThickness` and `LayerThicknessField`. Note that the layer thickness is defined in such a way that it becomes zero in concave corners of the layer. In addition, due to interpolation, `LayerThickness` can deviate by approximately half of the local mesh spacing from the thickness actually used for computation. For more information on thickness extraction and the options to control it, see Thickness Extraction on page 336.

## Thickness Extraction

The definition of the *thickness* of a layer in a general geometry is not self-evident. This section describes how Sentaurus Device defines thickness.

To determine the thickness of a layer at a given point $P$, Sentaurus Device first finds the closest point $C_1$ on the surface of the layer. Then, a sphere is constructed that touches the surface in $C_1$ and has its midpoint within the layer, on the line passing through $C_1$ and $P$.

Then, the diameter of this sphere is increased, until it touches the surface at a second point, $C_2$, and the surface normal at this point encloses an angle with the vector pointing from $C_1$ to $P$ of at least $\beta$. By default, $\beta = 0$, so any second touch point $C_2$ is accepted, and the construction results in a sphere that is completely within the layer.

14: Quantization
Extracting Layer Thickness

The thickness is a linear combination of the diameter of the final sphere, $d$, and the distance $c_{12}$ between $C_1$ and $C_2$ (the chord length):

$$t = \alpha c_{12} + (1 - \alpha)d \tag{244}$$

The parameter $\alpha$ can be set with the keyword `ChordWeight`, which is an option of `ThinLayer`. The default value is zero.

The value of angle $\beta$ can be changed with the keyword `MinAngle`, an option to `ThinLayer`. `MinAngle` expects two values: The first value sets $\beta$, and the second value sets an angle $\gamma$ that must be larger than $\beta$.

If the angle of the surface normal at $C_2$ and the vector pointing from $C_1$ to $P$ is between $\beta$ and $\gamma$, the value of the diameter $d$ is multiplied by a factor that is very large if the angle is close to $\beta$, and by a factor that approaches one when the angle approaches $\gamma$. The purpose of the transition region between $\beta$ and $\gamma$ is to smooth the transition between touch points that fulfill the angle criterion and points that do not.

The following example sets $\alpha$ to 0.5, $\beta$ to 89°, and $\gamma$ to 90°:

```
LayerThickness(
  MinAngle=(89,90)
  ChordWeight=0.5
)
```

The default value for $\beta$ is zero, which causes the extracted layer thickness to go to zero in concave corners of the layer, even when the corners have a wide opening angle. This can be unwanted, and choosing a larger value for $\beta$ can resolve this issue. However, there can be situations where a larger $\beta$ can make the thickness extraction ambiguous, for example, when the choice of $C_1$ is not unique.

To illustrate the thickness extraction, consider the example in Figure 19.

Thickness extraction diagram showing points C1, C2, C'2, P and a 90 degree angle within a thin layer boundary.

Figure 19 Thickness extraction

The thick black line is the boundary of the thin layer, and the red dot $P$ indicates the position at which the thickness is extracted. First, the closest boundary point $C_1$ is found, which is to the left of $P$. Then, with the default $\beta = 0$, the largest circle touching at $C_1$ is inscribed into the layer. This is the smaller circle, with a second touch point $C_2$. From this circle, the layer

References

thickness is obtained by a linear combination of the chord length (diagonal red line) and the diameter (horizontal red line).

The angle between the normal vectors $C_1$ and $C_2$ is 90° . Therefore, if the value of $\beta$ is greater than 90° but smaller than 180° , the smaller circle is not considered. Instead, the larger circle (with a second touch point $C_2'$) determines the layer thickness; for this circle, the angle between the normal vectors is 180° .

There is another option to compute the layer thickness, which also is based on considered spheres (or circles in Figure 19 on page 337 for the 2D case), but with some of the following modifications. The above algorithm for each point $P$ (that is, for each mesh element center) constructs a sphere that satisfies the described conditions. As a result, you have a set of spheres that cover the region where the thickness should be computed. After that, for each mesh element (the point $P$), you check whether this point is inside some subset of spheres, and you take the maximum sphere diameter $d_m$ from this subset as the thickness for the point $P$. This way might be useful for spherical, circular, or nonplanar boundaries.

The user-defined keyword `MaxFitWeight` controls this option as follows:

$$ t_m = \alpha_m d_m + (1 - \alpha_m)t $$ (245)

where $t$ is the thickness from Eq. 244, and $\alpha_m$ is defined by the keyword `MaxFitWeight` and is equal to zero by default.

# References

[1] M. J. van Dort, P. H. Woerlee, and A. J. Walker, “A Simple Model for Quantisation Effects in Heavily-Doped Silicon MOSFETs at Inversion Conditions,” *Solid-State Electronics*, vol. 37, no. 3, pp. 411–414, 1994.

[2] S. A. Hareland et al., “A Simple Model for Quantum Mechanical Effects in Hole Inversion Layers in Silicon PMOS Devices,” *IEEE Transactions on Electron Devices*, vol. 44, no. 7, pp. 1172–1173, 1997.

[3] M. G. Ancona and H. F. Tiersten, “Macroscopic physics of the silicon inversion layer,” *Physical Review B*, vol. 35, no. 15, pp. 7959–7965, 1987.

[4] M. G. Ancona and G. J. Iafrate, “Quantum correction to the equation of state of an electron gas in a semiconductor,” *Physical Review B*, vol. 39, no. 13, pp. 9536–9540, 1989.

[5] G. Paasch and H. Übensee, “A Modified Local Density Approximation: Electron Density in Inversion Layers,” *Physica Status Solidi (b)*, vol. 113, no. 1, pp. 165–178, 1982.

**14: Quantization**
References

[6] G. Paasch and H. Übensee, “Carrier Density near the Semiconductor–Insulator Interface: Local Density Approximation for Non-Isotropic Effective Mass,” *Physica Status Solidi (b)*, vol. 118, no. 1, pp. 255–266, 1983.

[7] O. Penzin, G. Paasch, L. Smith, and F.O. Heinz, “Extended Quantum Correction Model Applied to Six-Band k·p Valence Bands Near Silicon/Oxide Interfaces,” *IEEE Transactions on Electron Devices*, vol. 58, no. 6, pp. 1614–1619, 2011.

[8] G. Paasch, T. Fiedler, and I. Bartoš, “Subband Energies at Semiconductor Heterojunctions: An Approximate Quantization Formula,” *Physica Status Solidi (b)*, vol. 134, no. 2, pp. 825–835, 1986.

[9] O. Penzin, G. Paasch, and L. Smith, “Nonparabolic Multivalley Quantum Correction Model for InGaAs Double-Gate Structures,” *IEEE Transactions on Electron Devices*, vol. 60, no. 7, pp. 2246–2250, 2013.

## References

