# CHAPTER 7 Poisson Equation and Quasi-Fermi Potentials

*This chapter discusses the Poisson equation, electrostatic potential, and quasi-Fermi potentials.*

In all semiconductor devices, mobile charges (electrons and holes) and immobile charges (ionized dopants or traps) play a central role. The charges determine the electrostatic potential and, in turn, are themselves affected by the electrostatic potential. Therefore, each electrical device simulation at the very least must compute the electrostatic potential.

When all contacts of a device are biased to the same voltage, the device is in equilibrium, and the electron and hole densities are described by a constant quasi-Fermi potential. Therefore, together with the electrostatic potential, the relation between the quasi-Fermi potentials and the electron and hole densities is sufficient to perform the simplest possible device simulation.

Maxwell–Boltzmann statistics is the default in Sentaurus Device, and you can choose to use Fermi–Dirac statistics as described in Fermi Statistics on page 182.

# Electrostatic Potential

The electrostatic potential is the solution of the Poisson equation, which is:

$$ \nabla \cdot (\varepsilon \nabla \phi - \vec{P}) = -q(p - n + N_D - N_A) - \rho_{\text{trap}} $$ (37)

where:

*   $\varepsilon$ is the electrical permittivity.

*   $\vec{P}$ is the ferroelectric polarization (see Chapter 29 on page 855).

*   $q$ is the elementary electronic charge.

*   $n$ and $p$ are the electron and hole densities.

*   $N_D$ is the concentration of ionized donors.

*   $N_A$ is the concentration of ionized acceptors.

*   $\rho_{\text{trap}}$ is the charge density contributed by traps and fixed charges (see Chapter 17 on page 489).

Electrostatic Potential

The dataset name for the electrostatic potential is `ElectrostaticPotential`. The right-hand side of Eq. 37 (divided by $-q$) is stored in the `SpaceCharge` dataset. The keyword for the Poisson equation in the `Solve` section is `Poisson`.

The dimensionless relative permittivity (that is, the permittivity in units of the vacuum permittivity $\varepsilon_0$) is given by the parameter `epsilon` in the `Epsilon` parameter set. The boundary conditions for the Poisson equation are discussed in Chapter 10 on page 211.

***

## Dipole Layer

At material interfaces, dipole layers of immobile charges can occur, leading to a potential jump across the interface. They are modeled by:

$$ \phi_2 - \phi_1 = \frac{q \sigma_D}{\varepsilon_r \varepsilon_0} $$ (38)

where:

*   $\phi_1$ and $\phi_2$ refer to the electrostatic potential at both sides of the interface (index 1 is the reference side).

*   $\sigma_D$ is the dipole surface density.

*   $\varepsilon_0$ is the free space permittivity.

*   $\varepsilon_r$ is the relative interface permittivity.

*   $q$ is the elementary electronic charge.

The dipole interface model can be invoked for insulator–insulator interfaces by specifying the following in the `Physics` section of the interface:

```
Dipole ( Reference = "R1" )
```

Here, `Reference` denotes the reference side of the interface, and it can be either a region name or the material name.

The parameters of the model are given in the `Dipole` parameter set of the region or material interface section in the parameter file, and are listed in Table 27.

Table 27 Dipole model parameters

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| σD | sigma_D | 0. | cm-1 |
| εr | epsilon | 3.9 | 1 |

7: Poisson Equation and Quasi-Fermi Potentials
Quasi-Fermi Potential With Boltzmann Statistics

**NOTE** At critical points where heterointerfaces and dipole interfaces intersect, semiconductor regions must be interface connected. Interface traps with tunneling cannot be located on dipole interfaces.

# Equilibrium Solution

For specific models (see Modified Ohmic Contacts on page 212, Barrier Lowering at Schottky Contacts on page 218, Floating Semiconductor Contacts on page 234, and Conductive Insulators on page 254), the equilibrium electrostatic potential is required internally. In this case, the Poisson equation is solved with equilibrium boundary conditions before any other `Coupled` statement and the solution is saved for use during the simulation.

You can control the parameters of the nonlinear solver for the equilibrium Poisson equation. The parameters `Iterations`, `Digits`, `NotDamped`, `LineSearchDamping`, and `RelErrControl`, described in Table 334 on page 1626, can be specified as options to the keyword `EquilibriumSolution` in the `Math` section (see Table 212 on page 1537) to control the Newton solver behavior.

The following example forces the Newton solver to solve for an equilibrium solution with 7 digits as the target accuracy and a maximum number of 100 iterations:

```
Math {
  ...
  EquilibriumSolution(Iterations=100 Digits=7)
  ...
}
```

# Quasi-Fermi Potential With Boltzmann Statistics

Electron and hole densities can be computed from the electron and hole quasi-Fermi potentials, and vice versa. If Boltzmann statistics is assumed, the formulas read:

$$ n = N_C \exp \left( \frac{E_{F,n} - E_C}{kT} \right) $$ (39)

$$ p = N_V \exp \left( \frac{E_V - E_{F,p}}{kT} \right) $$ (40)

where:

*   $N_C$ and $N_V$ are the effective density-of-states.

*   $E_{F,n} = -q \Phi_n$ and $E_{F,p} = -q \Phi_p$ are the quasi-Fermi energies for electrons and holes.

Fermi Statistics

*   $\Phi_n$ and $\Phi_p$ are electron and hole quasi-Fermi potentials, respectively.

*   $E_C$ and $E_V$ are conduction and valence band edges, defined as:

$$E_C = -\chi - q(\phi - \phi_{\text{ref}}) \tag{41}$$

$$E_V = -\chi - E_{g,\text{eff}} - q(\phi - \phi_{\text{ref}}) \tag{42}$$

where $\chi$ denotes the electron affinity, $E_{g,\text{eff}}$ is the effective band gap, and $\phi_{\text{ref}}$ is a constant reference potential (see below). The zero level for the quasi-Fermi potential agrees with the zero level for the voltages applied at the contacts.

In unipolar devices, such as MOSFETs, it is sometimes possible to assume that the value of quasi-Fermi potential for the minority carrier is constant in certain regions. In this case, the concentration of the minority carrier can be directly computed from Eq. 39 or Eq. 40. This strategy is applied in Sentaurus Device if one of the carriers (electron or hole) is not specified inside the `Coupled` statement of the `Solve` section. Sentaurus Device uses an approximation scheme to determine the constant value of the quasi-Fermi potential.

> **NOTE** In many cases if avalanche generation is important, the one carrier approximation cannot be applied even for unipolar devices.

The datasets for $E_{F,n}$, $\Phi_n$, $E_{F,p}$, and $\Phi_p$ are named eQuasiFermiEnergy, eQuasiFermiPotential, hQuasiFermiEnergy, and hQuasiFermiPotential, respectively.

The `ConstRefPot` parameter allows you to specify $\phi_{\text{ref}}$ explicitly. Otherwise, Sentaurus Device computes $\phi_{\text{ref}}$ from the vacuum level, using the following rules:

*   If there is silicon in any simulated semiconductor structure, then the intrinsic Fermi level of silicon is selected as reference, $\phi_{\text{ref}} = \Phi_{\text{intr}}(\text{Si})$.

*   Otherwise, if any simulated device structure contains GaAs, then $\phi_{\text{ref}} = \Phi_{\text{intr}}(\text{GaAs})$.

*   In all other cases, Sentaurus Device selects the material with the smallest band gap (assuming a mole fraction of 0) and takes the value of its intrinsic Fermi level as $\phi_{\text{ref}}$.

# Fermi Statistics

For the equations presented in the previous section, Boltzmann statistics was assumed for electrons and holes. Physically more correct, Fermi (also called Fermi–Dirac) statistics can be used. Fermi statistics becomes important for high values of carrier densities, for example, $n > 1 \times 10^{19} \text{ cm}^{-3}$ in the active regions of a silicon device.

Fermi Statistics

For Fermi statistics, Eq. 39 and for Eq. 40 are replaced by:

$$ n = N_C F_{1/2} \left( \frac{E_{F,n} - E_C}{kT} \right) $$ (43)

$$ p = N_V F_{1/2} \left( \frac{E_V - E_{F,p}}{kT} \right) $$ (44)

where $F_{1/2}$ is the Fermi integral of order 1/2.

Alternatively, you can write these expressions as:

$$ n = \gamma_n N_C \exp \left( \frac{E_{F,n} - E_C}{kT} \right) $$ (45)

$$ p = \gamma_p N_V \exp \left( \frac{E_V - E_{F,p}}{kT} \right) $$ (46)

where $\gamma_n$ and $\gamma_p$ are the functions of $\eta_n$ and $\eta_p$:

$$ \gamma_n = \frac{n}{N_C} \exp(-\eta_n) $$ (47)

$$ \gamma_p = \frac{p}{N_V} \exp(-\eta_p) $$ (48)

$$ \eta_n = \frac{E_{F,n} - E_C}{kT} $$ (49)

$$ \eta_p = \frac{E_V - E_{F,p}}{kT} $$ (50)

---

# Using Fermi Statistics

To activate Fermi statistics, you must specify the keyword `Fermi` in the `Physics` section:

```
Physics {
  ...
  Fermi
}
```

**NOTE** Fermi statistics can be activated only for the entire device. Region-specific or material-specific activation is not possible, and the keyword `Fermi` can be defined in any `Physics` section.

7: Poisson Equation and Quasi-Fermi Potentials
Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells

# Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells

To determine an initial guess for the electrostatic potential and quasi-Fermi potentials, a device is divided into doping well regions, where a doping well region is a semiconductor region consisting of a set of connected semiconductor elements bounded by nonsemiconductor elements or by vacuum (a doping well region might contain several mesh semiconductor regions). Then, each doping well region is further subdivided into wells of n-type and p-type doping, such that p-n junctions (DopingConcentration=0) serve as dividers between wells. For doping wells with more than one contact, the wells are further subdivided, such that no well is associated with more than one contact. Every well is connected uniquely to a contact or it has no contact (floating well).

> **NOTE** Sentaurus Device uses integers to enumerate all doping wells. You can visualize the indices of the doping wells by plotting the `DopingWells` field.

In wells with contacts, the quasi-Fermi potential of the majority carrier is set to the voltage on the contact associated with the well. For wells that have no contacts, the following equations define the quasi-Fermi potential for the majority carriers:

$$ \Phi_p = k_{\text{float}} V_{\max} + (1 - k_{\text{float}}) V_{\min} $$ (51)

$$ \Phi_n = (1 - k_{\text{float}}) V_{\max} + k_{\text{float}} V_{\min} $$ (52)

where:

*   $V_{\min}$ and $V_{\max}$ are the minimum and maximum of the contact voltages of the semiconductor wells with contacts in the doping well region, where the contactless well under consideration is located.

*   The coefficient $k_{\text{float}}$ is an adjustable parameter with a default value of 0. To change the value of $k_{\text{float}}$, use the keyword `FloatCoef` in the `Physics` section.

If a well has a contact and it is the only well in the doping well region to which it belongs, then the quasi-Fermi potential of the minority carrier is set equal to the quasi-Fermi potential of the majority carrier. For all other wells, the quasi-Fermi potential of the minority carrier is set to $V_{\min}$ or $V_{\max}$ if the well is n-type or p-type, respectively, with $V_{\min}$ and $V_{\max}$ previously described.

The electrostatic potential in a well is set to the value of the quasi-Fermi potential of the majority carrier adjusted by the built-in potential, that is, the initial solution will obey charge neutrality in all semiconductor regions.

7: Poisson Equation and Quasi-Fermi Potentials

Alternative Initial Guess for Quasi-Fermi Potentials From Linear Conduction Equation

# Regionwise Specification of Initial Quasi-Fermi Potentials

You can set initial quasi-Fermi potentials regionwise. This is especially useful in charge-coupled device (CCD) simulations, where a CCD cell or region must be initially in a certain state (usually, deep depletion). By specifying an initial quasi-Fermi potential, the region or set of regions can be brought to the proper state or states at the start of the simulation.

The initial quasi-Fermi potentials for electrons and holes can be specified regionwise in the Physics section using `eQuasiFermi` for electrons and `hQuasiFermi` for holes, followed by the value in volts:

```
Physics(Region="region_1") {
  eQuasiFermi = 10
}
```

The initial quasi-Fermi potential is recomputed when the continuity equation for the respective carrier is solved. If the continuity equation for the carrier whose quasi-Fermi potential has been specified is not solved, then the quasi-Fermi potential does not change. In this case, the device can be biased to an initial state through a quasistationary or transient simulation, while keeping the initial specified quasi-Fermi potential.

# Alternative Initial Guess for Quasi-Fermi Potentials From Linear Conduction Equation

Sentaurus Device provides an alternative method to initialize the quasi-Fermi potentials in semiconductor materials. It is more computationally intensive than their initialization in doping wells, but often gives better results, especially in complicated device structures with multiple contacts per doping well region.

In this approach, a solution of the linear conduction equations:

$$ -\nabla \cdot (\sigma_{n_0} \nabla\Phi_n) = 0 $$ (53)

$$ -\nabla \cdot (\sigma_{p_0} \nabla\Phi_p) = 0 $$ (54)

serves as an initial guess for the electron and hole quasi-Fermi potentials, $\Phi_n$ and $\Phi_p$, respectively.

The conductivity coefficients for electrons ($\sigma_{n_0}$) and holes ($\sigma_{p_0}$) are approximated as:

$$ \sigma_{n_0} = q\mu_{L,n}n_0 $$ (55)

Alternative Initial Guess for Quasi-Fermi Potentials From Linear Conduction Equation

$$ \sigma_{p_0} = q\mu_{L,p}p_0 \tag{56} $$

where $n_0$, $p_0$ are the equilibrium carrier concentrations, and $\mu_{L,n}$, $\mu_{L,p}$ are the constant carrier mobilities. The concentrations $n_0$ and $p_0$ are calculated by invoking the charge neutrality condition (Eq. 99, p. 211) and the law of mass action (Eq. 100, p. 211). The mobilities $\mu_{L,n}$ and $\mu_{L,p}$ are taken as the values of the `mumax` parameter for electrons and holes, respectively, from the `ConstantMobility` parameter set (see Mobility due to Phonon Scattering on page 342).

The following boundary conditions are used when solving Eq. 53 and Eq. 54:

* At contacts, the Dirichlet boundary condition is applied, by setting the quasi-Fermi potentials equal to the voltage on the contact.

* For interfaces between a semiconductor and an insulator, a homogeneous Neumann boundary condition is imposed.

* At semiconductor–semiconductor and semiconductor–metal interfaces, the continuity of quasi-Fermi potentials is enforced.

In the command file, the initialization of quasi-Fermi potentials from the solution of Eq. 53 and Eq. 54 is activated by the `IniteQuasiFermi` and `InithQuasiFermi` options, respectively, set in the `Physics` section. You can use these options independently and can also use them in regionwise or materialwise `Physics` sections. The following example activates the linear conduction equation for the electron quasi-Fermi potential in region n-epi:

```
Physics (Region="n-epi") {
  IniteQuasiFermi
}
```

For interior interfaces where the linear conduction equation is solved only in one of the regions of the interface, the continuity condition for quasi-Fermi potentials is evaluated based on the initial guess coming from doping wells (see Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells on page 184). In metal regions, Eq. 53 and Eq. 54 are never solved. Instead, the metal conductivity equation is used to compute the Fermi level (see Transport in Metals on page 249).

Therefore, the linear conduction equation is solved by default only in semiconductor regions. However, the solution of the linear conduction equation can be extended to insulator regions by using the `includingInsulator` option. For example:

```
IniteQuasiFermi(includingInsulator)
InithQuasiFermi(includingInsulator)
```

In insulator regions, the conductivity coefficients $\sigma_{n_0}$ and $\sigma_{p_0}$, in Eq. 53 and Eq. 54, are approximated as $\sigma_{n_0} = \sigma_{p_0} = 1/\rho_0$, where $\rho_0$ is the resistivity value of the corresponding insulator material. The resistivity value $\rho_0$ is taken as the value of the `Resist0` parameter from the `Resistivity` parameter set (see Transport in Metals on page 249).

**7: Poisson Equation and Quasi-Fermi Potentials**

Electrode Charge Calculation

If the continuity equation for the carrier whose quasi-Fermi potential has been specified is not solved, then the initial quasi-Fermi potential is recomputed for every ramping step. In this case, the concentration of the carrier is calculated directly from Eq. 39, p. 181 or Eq. 40, p. 181 (see Quasi-Fermi Potential With Boltzmann Statistics on page 181).

You can access the datasets storing the values of $\Phi_n$, $\sigma_{n_0}$, $\Phi_p$, and $\sigma_{p_0}$ by using the keywords `eQuasiFermiPotential`, `eInitialConductivity/Element`, `hQuasiFermiPotential`, and `eInitialConductivity/Element`, respectively.

# Electrode Charge Calculation

Sentaurus Device outputs the electrode charge to the current plot file (`*.plt` file) after each bias or time point.

For an electrode that contacts an insulator region only, the charge is computed from Gauss’s law and represents the charge that would sit on the surface of a real contact to the device.

For an electrode that contacts a semiconductor region, the charge also is computed from Gauss’s law; however, the Gaussian surface used for the integration includes the doping well associated with the electrode. In this case, the electrode charge represents the charge that sits on the electrode plus the space charge in the doping well.

**Electrode Charge Calculation**

