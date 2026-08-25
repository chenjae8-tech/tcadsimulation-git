# CHAPTER 11 Transport Equations in Metals, Organic Materials, and Disordered Media

*This chapter describes transport equations in materials other than low-defect, inorganic semiconductors.*

# Singlet Exciton Equation

In organic semiconductor devices, besides the simulation of the electrical part consisting of solving the Poisson and continuity equations, the *singlet exciton equation* is introduced to account for optical properties of these materials related to Frenkel excitons.

This equation takes into account only singlet excitons because triplet excitons do not contribute directly to light emission. The equation models the dynamics of the generation, diffusion, recombination, and radiative decay of singlet excitons in organic semiconductors.

The singlet exciton equation, governing the transport of excitons in organic semiconductors, is given by:

$$ \frac{\partial n_{se}}{\partial t} = R_{bimolec} + \nabla \cdot D_{se} \nabla n_{se} - \frac{n_{se} - n_{se}^{eq}}{\tau} - \frac{n_{se} - n_{se}^{eq}}{\tau_{trap}} - R_{se} $$ (138)

where:

*   $n_{se}$ is the singlet exciton density.

*   $R_{bimolec}$ is the carrier bimolecular recombination rate acting as a singlet exciton generation term.

*   $D_{se}$ is the singlet exciton diffusion constant.

*   $\tau$, $\tau_{trap}$ are the singlet exciton lifetimes.

*   $R_{se}$ is the net singlet exciton recombination rate.

The first term on the right-hand side of Eq. 138 accounts for the creation of excitons through bimolecular recombination (see Bimolecular Recombination Model on page 484). The second term describes exciton diffusion; while radiative decay associated with light emission is accounted for by the third and fourth terms.

Singlet Exciton Equation

Nonradiative exciton destruction and conversion of excitons to free electron and free hole populations are described by the net exciton recombination rate (fifth term):

$$
\begin{aligned}
R_{se} &= R_{se-nf} + R_{se-pf} \\
R_{se-nf} &= (v_{se} + v_n)\sigma_{se-n}n_{se}n \\
R_{se-pf} &= (v_{se} + v_p)\sigma_{se-p}n_{se}p
\end{aligned}
\eqno(139)
$$

where:

*   $R_{se-nf}$, $R_{se-pf}$ are the exciton recombination rate due to free electron and free hole populations, respectively.

*   $v_{se} = v_{se,0}$ is the exciton velocity.

*   $v_n = v_{n,0}\sqrt{T/300\text{ K}}$ and $v_p = v_{p,0}\sqrt{T/300\text{ K}}$ are the electron and hole velocities. $v_{se,0}$, $v_{n,0}$, and $v_{p,0}$ are set in the parameter file.

*   $\sigma_{se-n}$ and $\sigma_{se-p}$ are the reaction cross sections between the singlet exciton, and the electron and hole, respectively.

In addition, the net exciton recombination rate $R_{se}$ might contain exciton interface dissociation rates converted to volume terms if the exciton interface dissociation model is activated (see Exciton Dissociation Model on page 485).

# Boundary and Continuity Conditions for Singlet Exciton Equation

At electrodes and thermodes, equilibrium is assumed for the singlet exciton population:

$$
n_{se}(T) = n_{se}^{eq}(T) = \gamma g_{ex}(N_C(T) + N_V(T))\exp(-\frac{E_{g,eff} - E_{ex}}{kT}) \eqno(140)
$$

where $\gamma = 1/4$, and $g_{ex}$ and $E_{ex}$ are the singlet exciton degeneracy factor and binding energy, respectively.

Conditions for the singlet exciton equation at interfaces depend on the interface type. The interface type is dictated by the two regions adjacent to the interface.

For interfaces where the singlet exciton equation is solved only in one of the regions of the interface, the boundary conditions imposed are either Eq. 140 (default) or $\nabla n_{se} \cdot \hat{n} = 0$ (zero flux), depending on the user selection.

For a heterointerface where the singlet exciton equation is solved in both regions, the continuity conditions imposed are thermionic-like. In this case, you can select the barrier $\Delta E$ to be the

11: Transport Equations in Metals, Organic Materials, and Disordered Media

Singlet Exciton Equation

difference between the band gaps, the conduction bands, or the valence bands of the two regions.

Assuming that at heterointerfaces between materials 1 and 2 (that is, regions 1 and 2), $\Delta E > 0$ ($E_{g, 2} > E_{g, 1}$ for example), and $j_{se, 2}$ is the singlet exciton flux leaving material 2 and $j_{se, 1}$ is the singlet exciton flux entering material 1, the interface boundary condition can be written as:

$$
\begin{aligned}
j_{se, 1} &= j_{se, 2} \\
j_{se, 2} &= v_{si} \left( n_{se, 2} - n_{se, 1} \exp \left( -\frac{\Delta E}{kT} \right) \right)
\end{aligned}
\eqno(141)
$$

where $n_{se, 2}$ and $n_{se, 1}$ are the singlet exciton densities of materials 2 and 1 at the heterointerface, and $v_{si}$ is the organic heterointerface emission velocity defined in the parameter file.

# Using the Singlet Exciton Equation

To activate the singlet exciton equation, the keyword `SingletExciton` must be specified in the `Coupled` statement of the `Solve` section (see Coupled Statement on page 141). Then, the regions where the equation will be solved are selected by specifying the keyword `SingletExciton` with different options in the `Physics` section of the respective regions (by default, none of the regions is selected for solving the singlet exciton equation, so you must select at least one region).

The singlet exciton generation and recombination terms in Eq. 138 are switched off by default. They can be activated regionwise by specifying the corresponding keyword as an option for `Recombination` in the `SingletExciton` section of the respective region `Physics` section (see Table 254 on page 1572).

The keyword `Bimolecular` activates the bimolecular generation (first term). The keywords `Radiative` and `TrappedRadiative` switch on radiative decay of singlet excitons either directly or trap-assisted (third and fourth terms). Nonradiative exciton destruction (fifth term) is activated by `eQuenching` and `hQuenching`. For example:

```
Physics(Region="EML-ETL") {
  SingletExciton(Recombination(Bimolecular eQuenching hQuenching))
}
```

For interfaces where the singlet exciton equation is solved only in one of the regions of the interface, the default boundary conditions are defined by Eq. 140.

Singlet Exciton Equation

To switch to zero flux boundary condition $\nabla n_{\text{se}} \cdot \hat{n} = 0$, the keyword `FluxBC` must be specified as an option for `SingletExciton` in the interface `Physics` section:

```
Physics(RegionInterface="Region_0/Region_2") {
       SingletExciton(FluxBC)
}
```

For heterointerfaces, the default barrier type for the singlet exciton flux injection across the interface (defined in Eq. 141) is the bandgap energy difference.

The barrier can be switched to conduction band or valence band type by specifying the keyword `BarrierType` with the option `CondBand` or `ValBand` in the `SingletExciton` section of the heterointerface `Physics` section:

```
Physics(RegionInterface="Region_0/Region_2") {
       SingletExciton(BarrierType(CondBand)
}
```

Parameters used with the singlet exciton equation must be specified in the `SingletExciton` section of the parameter file.

Table 33 Parameters and their default values for singlet exciton equation

| Symbol | Parameter name | Default value | Location | Unit |
| --- | --- | --- | --- | --- |
| $\gamma$ | gamma | 0.25 | region | 1 |
| $\tau$ | tau | $1 \times 10^{-7}$ | region | s |
| $\tau_{\text{trap}}$ | tau_trap | $1 \times 10^{-8}$ | region | s |
| $L_{\text{diff}}$ | l_diff | $1 \times 10^{-3}$ | region | cm |
| $D_{\text{se}} = L_{\text{diff}}^2 / \tau$ |  |  | region | cm$^2$/s |
| $\sigma_{\text{se}-n}$ | ex_cXsection | $1 \times 10^{-8}$ | region | cm$^2$ |
| $\sigma_{\text{se}-p}$ | ex_cXsection | $1 \times 10^{-8}$ | region | cm$^2$ |
| $E_{\text{ex}}$ | Eex | 0.015 | region | eV |
| $g_{\text{ex}}$ | gex | 4 | region | 1 |
| $v_{\text{se}, 0}$ | vth | $1 \times 10^7$ | region | cm/s |
| $v_{n, 0}$ | vth_car | $1 \times 10^3$ | region | cm/s |
| $v_{p, 0}$ | vth_car | $1 \times 10^3$ | region | cm/s |
| $v_{\text{si}}$ | vel | $1 \times 10^8$ | interface | cm/s |

11: Transport Equations in Metals, Organic Materials, and Disordered Media
Transport in Metals

# Transport in Metals

The simulation of current transport in metals or semi-metals is important for interconnection problems in ICs. The current density in metals is given by:

$$ \vec{J}_M = -\sigma(\nabla\Phi_M + P\nabla T) $$ (142)

where:

*   $\sigma$ is the metal conductivity.

*   $\Phi_M$ is the Fermi potential in the metal.

*   $P$ is the metal thermoelectric power.

*   $T$ is the lattice temperature.

The second term in Eq. 142 accounts for the Seebeck effect, and it is nonzero only when computation of metal thermoelectric power is enabled (see Thermoelectric Power on page 981). For the steady-state case, $\nabla \cdot \vec{J}_M = 0$. Therefore, the equation for the Fermi potential inside of metals is:

$$ \nabla \cdot (\sigma(\nabla\Phi_M + P\nabla T)) = 0 $$ (143)

The following temperature dependence is applied for $\rho = 1/\sigma$:

$$ \rho = \rho_0(1 + \alpha_T(T - 273\text{ K})) $$ (144)

All these resistivity parameters can be specified in the parameter file as:

```
Resistivity {
  * Resist(T) = Resist0 * ( 1 + TempCoef * ( T - 273 ) )
    Resist0 = <value>      # [Ohm*cm]
    TempCoef = <value>     # [1/K]
}
```

No specific keyword is required in the command file because Sentaurus Device recognizes all conductor regions and applies the appropriate equations to these regions and interfaces. The metal conductivity equation Eq. 143 is a part of the `Contact` equation, which is solved automatically by default. If the keyword `NoAutomaticCircuitContact` is specified in the `Math` section or only the Poisson equation is solved, the `Contact` equation must be added explicitly in the `Coupled` statement to account for conductivity in metals.

To switch off current transport in metals, specify the keyword `-MetalConductivity` in the `Math` section.

Transport in Metals

> **NOTE** If you use the `-MetalConductivity` option, then all contacts placed directly on metal regions will be electrically disconnected from these regions.

## Electric Boundary Conditions for Metals

The following boundary conditions are used:

*   At contacts connected to metal regions, the Dirichlet condition $\Phi_M = V_{\text{applied}}$ is applied for the Fermi potential.

*   Interface conditions always include the displacement current $\vec{J}_D$ to ensure conservation of current.

*   For interfaces between metal and insulator, the equations are:

$$
\begin{aligned}
\vec{J}_M \cdot \hat{n} &= \vec{J}_D \cdot \hat{n} \\
\phi &= \Phi_M - \Phi_{\text{MS}}
\end{aligned}
\eqno(145)
$$

where $\Phi_{\text{MS}}$ is the workfunction difference between the metal and an intrinsic semiconductor selected (internally by Sentaurus Device) as a reference material, and $\hat{n}$ is the unit normal vector to the interface. The electrostatic potential inside metals is computed as $\phi = \Phi_M - \Phi_{\text{MS}}$.

*   At metal–semiconductor interfaces, by default, there is an Ohmic boundary condition. Schottky boundary conditions can be selected as an option.

The Ohmic boundary condition at metal–semiconductor interfaces reads:

$$
\begin{aligned}
\vec{J}_M \cdot \hat{n} &= (\vec{J}_n + \vec{J}_p + \vec{J}_D) \cdot \hat{n} \\
\phi &= \Phi_M + \phi_0 \\
n &= n_0 \\
p &= p_0
\end{aligned}
\eqno(146)
$$

where:

*   $\phi_0$ is the equilibrium electrostatic potential (the built-in potential).

*   $n_0$ and $p_0$ are the electron and hole equilibrium concentrations (see Ohmic Contacts on page 211).

There are several options for the Schottky interface (refer to the equations in Schottky Contacts on page 214). The potential barrier between metal and semiconductor is computed automatically, and the barrier tunneling model (see Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774) and the barrier lowering model (see Barrier Lowering at Schottky Contacts on page 218) can be applied.

11: Transport Equations in Metals, Organic Materials, and Disordered Media

Transport in Metals

To select these models, use the following syntax in the command file:

```
Physics(MaterialInterface = "Metal/Silicon") { Schottky eRecVelocity=1e6
  hRecVelocity=1e6 }
Physics(MaterialInterface = "Metal/Silicon") { Schottky BarrierLowering }
Physics(MaterialInterface = "Metal/Silicon") { Schottky }
```

The default values of electron and hole surface recombination velocities are `eRecVel=2.573e6` and `hRecVel=1.93e6`, respectively. Similarly to Electrode conditions, if `Schottky` is not specified but the `SurfaceSRH` keyword is specified, then Sentaurus Device will apply Ohmic boundary conditions to the electrostatic potential and the surface recombination for both electron and hole carrier current densities on such interfaces.

> **NOTE** At nonmetal interfaces, the keyword `SurfaceSRH` activates a different model from the one described in this section (see Surface SRH Recombination Model on page 432).

Both Ohmic and Schottky interfaces support a distributed resistance model similar to the one described in Resistive Contacts on page 223. If a distributed resistance is specified at the interface, a distributed voltage drop $\Delta\phi(R_d) = R_d(\vec{J}_n + \vec{J}_p + \vec{J}_D) \cdot \hat{n}$ is applied to the existing boundary condition for potential, where $\Delta\phi(R_d)$ is the voltage drop across the interface, and $R_d$ is the distributed resistance at the interface. In addition, for Ohmic interfaces, emulation of a Schottky interface using a doping-dependent resistivity model is possible. These options are activated as following:

```
# Distributed resistance at Ohmic interface
Physics(MaterialInterface = "Metal/Silicon") {DistResist=1e-6}
# Distributed resistance at Schottky interface
Physics(MaterialInterface = "Metal/Silicon") {Schottky DistResist=1e-6}
# Distributed resistance at Ohmic interface emulating a Schottky interface
Physics(MaterialInterface = "Metal/Silicon")
  {DistResist = SchottkyResist}
```

For Schottky interfaces, the distributed resistance model works with all other options previously described.

For all other metal boundaries, the Neumann condition $\vec{J}_M \cdot \hat{n} = 0$ is applied.

> **NOTE** By default, Sentaurus Device computes output currents through a contact using integration over the associated wells. For metal contacts, the integration can be switched off and the local current can be used instead by specifying the keyword `DirectCurrent` in the `Math` section. This option might produce a wrong current at the metal contact.

Transport in Metals

## Metal Workfunction

To specify the metal workfunction, use the `Bandgap` parameter set. For example:

```
Material = "Gold" {
  Bandgap { WorkFunction = 5 # [eV] }
}
```

It is also possible to account for workfunction variations within the metal.

If such variations can be characterized by mole-fraction variations and if the metal is treated as a mole fraction–dependent material (see Mole-Fraction Materials on page 15), then `WorkFunction` in the `Bandgap` parameter set can be specified as a mole fraction–dependent quantity. For example:

```
Material = "Metal" {
  Bandgap {
    Xmax(0)=0.0
    Xmax(1)=0.2
    WorkFunction(0) = 4.53# [eV]
    WorkFunction(1) = 4.38# [eV]
  }
}
```

The positional dependency of the workfunction in metals also can be specified directly in the `Physics` section of the command file using one of three different methods:

```
Physics (Material = "<name>" | Region = "<name>") {
  MetalWorkfunction (
    [ Workfunction=<wf> ] |
    [ Workfunction=(<wf₁>, <x₁>, <y₁>, <z₁>)
      Workfunction=(<wf₂>, <x₂>, <y₂>, <z₂>)
      ...
      Workfunction=(<wfₙ>, <xₙ>, <yₙ>, <zₙ>) ] |
    [ SFactor= "<dataset_name-or-pmi_model_name>" [Factor=<scale>]
      [Offset=<offset>] ]
  )
}
```

The first method (`Workfunction=<wf>`) simply specifies a constant workfunction value for the material or region that overrides any specification from the parameter file.

The next method allows the specification of an arbitrary number of workfunction–position quadruplets. The workfunction at a vertex in the metal is assigned the value of the workfunction from the quadruplet whose position is closest to the vertex.

11: Transport Equations in Metals, Organic Materials, and Disordered Media

Transport in Metals

Alternatively, you can use the `SFactor` parameter to specify a dataset name (which includes the PMI user fields `PMIUserField0` through `PMIUserField299`) from which the vertex workfunction values will be taken, or a space factor PMI model can be specified that calculates the vertex workfunction values directly (see Space Factor on page 1446). If `Factor=<scale>` is specified, then the `SFactor` values are normalized and then are multiplied by this factor. If `Offset=<offset>` is specified, then this value is added to the raw or scaled `SFactor` values.

## Metal Workfunction Randomization

The workfunction in metal regions can be randomized using specifications in the command file:

```
Physics (Material = "<name>" | Region = "<name>") {
  MetalWorkfunction (
    Randomize (
      AverageGrainSize=<size>           # [micrometers]
      GrainProbability=(<P1>, <P2>, ...)
      GrainWorkfunction=(<wf1>, <wf2>, ...) #[eV]
      RandomSeed=<seed>
      AtInsulatorInterface
      UniformDistribution
    )
  )
}
```

The approach taken assumes that the metal consists of randomized grains of varying size and shape that can be characterized with an average grain size. It also assumes that the grains in the metal occur with a finite number of orientations, and the number of grains for each orientation can be characterized with a probability of occurrence. All grains of the same orientation are assumed to have the same workfunction, but the workfunction can be different for each orientation.

`AverageGrainSize` is used to determine the average number of grains for a region, which then is used as the expectation value for a Poisson distribution, random number generator to determine the actual number of grains for the region. Each grain can have a different shape and size.

You can specify an arbitrary number of `GrainProbability` values, but their sum must be equal to one. In addition, there must be a one-to-one correspondence between `GrainProbability` values and `GrainWorkfunction` values.

By default, the seed for the random number generator used in the randomization process is different for every simulation. However, `RandomSeed` can be specified if required. This allows a particular randomization to be repeated if the same seed is used in a subsequent simulation of the same device on the same computer.

Conductive Insulators

The `AtInsulatorInterface` option confines the randomization to the metal–insulator interface vertices. However, the resulting workfunction values at the interface will be exactly the same as those obtained when the entire metal region is randomized.

The `UniformDistribution` option *attempts* to use grains with a uniform size that are distributed uniformly. The success of this is highly dependent on the grid used in the metal region.

The workfunction in metal regions can be saved in a plot file for visualization by specifying `MetalWorkfunction` in the `Plot` section of the command file.

## Temperature in Metals

In metals, only the lattice temperature is defined. If the lattice temperature is solved, in metals, it obeys the following equation:

$$ c_L \frac{\partial T}{\partial t} - \nabla \cdot \kappa \nabla T = -\nabla \psi_M \cdot \vec{J}_M $$ (147)

where $\kappa$ is the thermal conductivity (see Thermal Conductivity on page 969). If current transport in metals is switched off, the right-hand side of Eq. 147 vanishes. However, a heat flow in metals can still be simulated.

# Conductive Insulators

Leakage currents in dielectrics can be modeled by allowing dielectrics to have conductive properties. The conductive insulator (leaky insulator) model implements dielectrics that have nonzero (but typically low) conductivity (a metal-like property), besides the pure dielectric properties.

In a conductive insulator, the electrostatic potential is computed using the Poisson equation, similar to a pure dielectric. As in metals, conductivity is modeled by the Fermi potential (solving Eq. 143) and then the leakage current is computed using Eq. 142. Since the model does not allow net charge in the conductive insulator, the Poisson equation remains unchanged by adding conductive properties to the insulator.

The equation for the Fermi potential inside a conductive insulator is the same used for metals (see Eq. 143), where $\sigma$ is now the conductivity of the conductive insulator and $\Phi_M = \Phi_{CI}$ is the Fermi potential in the conductive insulator.

11: Transport Equations in Metals, Organic Materials, and Disordered Media
Conductive Insulators

The following boundary conditions are used for this equation:

*   At contacts connected to conductive insulator regions, the Dirichlet condition $\Phi_{\text{CI}} = V_{\text{applied}}$ is applied for the Fermi potential.

*   Interface conditions always include the displacement current $\vec{J}_D$ in insulators, conductive insulators, and semiconductors to ensure conservation of current.

*   For conductive insulator–semiconductor interfaces, Ohmic-like boundary conditions, thermionic-like boundary conditions, and boundary conditions for floating regions are available.

Leakage from or to a semiconductor to or from a conductive insulator is mainly determined by two factors: the conductive properties of the interface and the bulk resistivity of the conductive insulator. The bulk resistivity-limited conduction corresponds to the case when the current flow is limited by the high resistivity of the conductive insulator region, and the interface has zero resistivity. This case is modeled by the Ohmic-like boundary conditions:

$$
\begin{aligned}
\vec{J}_{\text{CI}} \cdot \hat{n} &= (\alpha \vec{J}_n + (1 - \alpha) \vec{J}_p) \cdot \hat{n} \\
\Phi_{\text{CI}} &= \phi - \phi_0
\end{aligned}
\eqno(148)
$$

where:

*   $\Phi_{\text{CI}}$ and $\vec{J}_{\text{CI}}$ are the Fermi potential and current density on the interface.

*   $\phi$ is the electrostatic potential (the solution of the Poisson equation in insulator and semiconductor regions).

*   $\phi_0$ is the built-in potential.

*   $\hat{n}$ is the unit normal vector to the interface.

*   $\vec{J}_n$ and $\vec{J}_p$ are the electron and hole currents on the semiconductor side of the interface.

*   $\alpha$ is the fraction ($0 \le \alpha \le 1$) of the current density of the conductive insulator going to the electron current density.

Thermionic-like emission at the interface models the case where conduction is limited by both interface properties and the bulk resistivity of the conductive insulator. Thermionic boundary conditions read:

$$
\begin{aligned}
\vec{J}_{\text{CI}} \cdot \hat{n} &= (\vec{J}_{n, \text{th}} + \vec{J}_{p, \text{th}}) \cdot \hat{n} \\
\vec{J}_{n, \text{th}} &= aq \left[ v_n(T_n)n - v_n(T) \left( \frac{T}{T_n} \right)^{1.5} N_C \exp \left( \frac{E_F^{\text{CI}} - E_C}{kT} \right) \right] \\
\vec{J}_{p, \text{th}} &= aq \left[ v_p(T_p)p - v_p(T) \left( \frac{T}{T_p} \right)^{1.5} N_V \exp \left( \frac{E_V - E_F^{\text{CI}}}{kT} \right) \right]
\end{aligned}
\eqno(149)
$$

11: Transport Equations in Metals, Organic Materials, and Disordered Media

Conductive Insulators

where:

*   $\vec{J}_{n, \text{th}}$ and $\vec{J}_{p, \text{th}}$ are the electron and hole thermionic-emission current densities on the interface from the semiconductor side.

*   $v_n(T) = (kT/2\pi m_n)^{0.5}$ and $v_p(T) = (kT/2\pi m_p)^{0.5}$ are 'emission velocities' at the interface.

*   $T$, $T_n$, and $T_p$ are the lattice, electron and hole temperatures, respectively.

*   $E_F^{\text{CI}}$, $E_C$, and $E_V$ are the conductive insulator Fermi-level energy, conduction band energy, and valence band energy, respectively.

*   $a$ is a constant set through the parameter file, which has the default value of 2.

By using a conductive insulator layer between a semiconductor floating region and a semiconductor region, leakage from a semiconductor floating-gate can be emulated. The boundary condition used in this case is:

$$ \vec{J}_{\text{CI}} \cdot \hat{n} = -\sigma \nabla \Phi $$ (150)

where $\Phi$ is the Fermi potential close to the interface. In this case, during transient simulations, the charge update on the floating gate is computed as $J_{\text{CI}} \Delta t$, where $J_{\text{CI}}$ is the total current at the conductive insulator–floating gate interface, and $\Delta t$ is the current time step. The activation of this type of boundary condition is automatic if the boundary condition at the conductive insulator–semiconductor floating-gate interface is Ohmic and the simulation is transient (to allow for charging and discharging of the floating gate).

The model is activated by using the keyword `CondInsulator` in the `Physics` section to make the dielectric conductive and by adding the `CondInsulator` equation in the `Solve` section to actually solve the Fermi potential:

```
Physics(Region="insulator"){
    ...
    CondInsulator
    ...
}

Solve {
    ...
    Coupled {Poisson Electron Hole Contact CondInsulator}
    ...
}
```

The parameters for the resistivity of conductive insulators (see Eq. 144) are specified in the `Resistivity` parameter set:

```
Material = "Si3N4" {
    Resistivity {
        * Resist(T) = Resist0 * (1 + TempCoef * (T-273))
```

Conductive Insulators

```
      Resist0 = 3.0e9       # [Ohm*cm]
      TempCoef = 43.0e-4    # [1/K]
    }
  }
```

Boundary conditions according to Eq. 148 are used by default. The parameter $\alpha$ in Eq. 148 is given by the value of `curw` in the `CondInsCurr` parameter set:

```
MaterialInterface = "Si3N4/AlGaN" {
  CondInsCurr {
    curw = 1.0    # [1]
  }
}
```

Thermionic emission at the semiconductor–conductive insulator interface is enabled by adding `eThermionic` or `hThermionic` in the `Physics` section:

```
Physics(MaterialInterface="Si3N4/AlGaN") {
  *----- Insulator/AlGaN -----
  ...
  eThermionic
  hThermionic
  ...
}
```

where the parameter $a$ (see Eq. 149) is specified in the parameter file:

```
MaterialInterface = "Si3N4/AlGaN" {
  ThermionicEmission {
    A = 2, 2
  }
}
```

For nonthermionic interfaces, an equilibrium solution is needed internally to solve the `CondInsulator` equation. The equilibrium solution is computed automatically by a nonlinear iteration. Sentaurus Device allows you to specify numeric parameters of the nonlinear iteration as options to the keyword `EquilibriumSolution` in the `Math` section (see Equilibrium Solution on page 181 and Table 212 on page 1537). The following example forces the Newton solver to solve up to 100 iterations:

```
Math {
  ...
  EquilibriumSolution(Iterations=100)
  ...
}
```

Conductive Insulators

 