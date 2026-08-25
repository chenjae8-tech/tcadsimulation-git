# CHAPTER 25 Hot-Carrier Injection

*This chapter discusses the hot-carrier injection models used in Sentaurus Device.*

## Overview of Hot-Carrier Injection Models

Hot-carrier injection is a mechanism for gate leakage. The effect is especially important for write operations in EEPROMs. Sentaurus Device provides different built-in hot-carrier injection models and a PMI for user-defined models:

*   Classical lucky electron injection (Maxwellian energy distribution)

*   Fiegna’s hot-carrier injection (non-Maxwellian energy distribution)

*   SHE distribution hot-carrier injection (non-Maxwellian energy distribution calculated from the spherical harmonics expansion (SHE) of the Boltzmann transport equation)

*   Hot-carrier injection PMI (see Hot-Carrier Injection on page 1431)

To activate hot-carrier injection models for electrons (or holes), use the options `eLucky` (`hLucky`), `eFiegna` (`hFiegna`), `eSHEDistribution` (`hSHEDistribution`), or `PMIModel_name(electron)` (`PMIModel_name(hole)`) to the `GateCurrent` statement in an interface-specific `Physics` section.

To activate the models for both carrier types, use the `Lucky`, `Fiegna`, `SHEDistribution`, or `PMIModel_name()` options. Hot-carrier injection models can be combined with all tunneling models (see Chapter 24 on page 767).

> **NOTE** The SHE distribution hot-carrier injection model calculates the tunneling component together with the thermionic emission term. Therefore, combining it with other tunneling models can result in double-counting of the tunneling component.

The meaning of a specification in the global `Physics` section is the same as for the Fowler–Nordheim model (see Fowler–Nordheim Tunneling on page 768).

**25: Hot-Carrier Injection**
Overview of Hot-Carrier Injection Models

---

# Destination of Injected Current

The destination of the injection current depends on the user selection and the material properties of the hot interface (interface source for hot carriers).

When the hot interface is a semiconductor–insulator interface, the injection current is sent nonlocally across the insulator region to an associated closest vertex. For each vertex of a hot interface, Sentaurus Device searches for an associated closest vertex located on a contact or semiconductor–insulator interface. The contacts or semiconductor–insulator interfaces used in the searching algorithm must be connected through adjacent insulator regions to the hot interface. Then, each vertex of the hot interface is associated with the closest vertex on a valid contact or semiconductor–insulator interface. Each vertex of the hot interface has either an associated contact vertex or an associated semiconductor–insulator interface vertex (see Figure 50).

Mapping of hot interface vertices to associated contact or semiconductor–insulator interface vertices

Figure 50 Mapping of hot interface vertices to associated contact or semiconductor–insulator interface vertices

When the hot interface is an interface between a semiconductor and a wide-bandgap semiconductor, you can select the destination. By default, the wide-bandgap semiconductor is treated as an insulator region, and the injection current is sent nonlocally across the region to the associated closest vertex as described for semiconductor–insulator interfaces. By using `Thermionic(HCI)` in the `Physics` section of the hot interface and specifying the injection region destination (the wide-bandgap semiconductor region) using the `InjectionRegion` option in the `GateCurrent` section, the points on the hot interface are made double-points and the injection current is injected locally in the same location where it was produced. The injected current on the wide-bandgap semiconductor side of the hot interface becomes the current boundary condition for the continuity equations solved in the region.

In the case where hot carriers are injected into semiconductor floating regions during transient simulations, the way the charge is added to the floating region is determined by the existence of a charge boundary condition (a region with a charge contact) associated with the region. If the charge boundary condition has been specified for a semiconductor floating region, the charge is added as a total charge update, using the integral boundary condition as defined by

25: Hot-Carrier Injection

Overview of Hot-Carrier Injection Models

Eq. 129, p. 234. If the charge boundary condition is not specified for the semiconductor floating region, the charge is added as an interface boundary condition for continuity equations (see Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity Equations on page 815). The total hot-carrier injection current added to semiconductor floating regions where the charge boundary condition is specified will be displayed on the electrode associated with the region (floating contact).

Floating semiconductor regions with a charge boundary condition inside a wide-bandgap semiconductor region are made possible by generalizing the concept of a semiconductor floating well.

Sentaurus Device defines a semiconductor *floating well* as a continuous zone of the same doping semiconductor regions in contact with each other and marked in the command file by a charge contact connected to one of regions in the zone. The concept is generalized by treating the inner semiconductor region (embedded floating region) as a separate well. Geometrically, the charge contact is defined on the interface between the inner and outer semiconductor regions. You must indicate in the `Electrode` section of the charge contact using either the `Region` or `Material` keyword which region is to be used as the floating region with a charge boundary condition.

Equilibrium boundary conditions are imposed on the surface of the special floating region previously described. The interface between the inner and outer semiconductor regions is treated as a heterointerface. You must specify the keyword `Heterointerface` in the `Physics` section of the interface between the inner and outer regions. If the inner region is the floating region, the boundary condition for continuity equations at the interface between the two regions, on the outer-region side, will be equilibrium for carrier concentrations. The charge update for the inner floating region is computed as the total current flowing through the floating region boundary (integral of current density over the floating region surface) multiplied by the time step.

Equilibrium carrier concentrations in a point on the double-point interface, on the outer-region side, are computed based on the carrier concentration on the inner-region side of the interface adjusted by $(N_{C,V}^{WB}/N_{C,V}^{FG})\exp(-\delta E_{C,V}/kT)$ where $\delta E_{C,V}$ is the jump in the conduction band for electrons or in the valence band for holes, and $N_{C,V}^{WB}/N_{C,V}^{FG}$ is the ratio between density-of-states in the two regions for electrons and holes, respectively. For example, to have a `PolySi` nanocrystal floating region with a charge boundary condition embedded in an outer `OxideAsSemiconductor` region, with the charge contact "fg1" geometrically somewhere on the interface between the two regions, you must specify:

```
Electrode {
  ...
  {Name "fg1" Charge= -1e-18 Material="PolySi"}
  ...
}
```

Overview of Hot-Carrier Injection Models

```
Physics(MaterialInterface="OxideAsSemiconductor/PolySi") {
    Heterointerface                                    # required by GeneralizedFG
}
```

Metal floating gates inside a wide-bandgap semiconductor region are allowed as well. In this case, equilibrium boundary conditions are imposed for the carrier densities at the interface between the semiconductor and the metal floating gate (on metal floating contact). Electrostatic potential at the metal floating contact is determined by the charge on the metal floating gate according to Eq. 127, p. 232. The equilibrium quasi-Fermi potential on the metal floating contact is given by $\Phi = \Phi_n = \Phi_p = \phi + \phi_{MS}$, where $\phi_{MS}$ is the workfunction difference between the metal and the semiconductor. Carrier densities at the metal floating contact are determined then by $\phi_{MS}$. The charge update for the metal floating gate is computed as the total current flowing through the metal floating region contact multiplied by the time step.

To activate this special case of the metal floating gate, you specify the `Metal` keyword in the `Electrode` section of the metal floating contact and give the value of the workfunction (which determines $\phi_{MS}$):

```
Electrode {
    ...
    {Name "fg1" Charge=0 Metal Workfunction=4.1}
    ...
}
```

The workfunction can be used as a calibration parameter.

For simple one-gate devices where the sole purpose is to evaluate the hot-carrier current injected across the oxide layer into a semiconductor region, the keyword `GateName` must be specified in the `GateCurrent` statement. In this case, the hot-carrier current is displayed on the electrode specified by `GateName` for both quasistationary and transient simulations.

## Injection Barrier and Image Potential

All hot-carrier injection models are implemented as a postprocessing computation after each Sentaurus Device simulation point. The lucky electron model and Fiegna model specify some properties of semiconductor–insulator interfaces. The most important parameter is the height of the Si–SiO<sub>2</sub> barrier ($E_B$).

## Overview of Hot-Carrier Injection Models

The height is a function of the insulator field $F_{\text{ins}}$ and, at any point along the interface, it can be written as:

$$
E_{\text{B}} = \begin{cases} E_{\text{B}0} - \alpha q |F_{\text{ins}}|^{\frac{1}{2}} - \beta q |F_{\text{ins}}|^{\frac{2}{3}} - P_{\perp} V_{\text{sem}} & F_{\text{ins}} < 0 \\ E_{\text{B}0} - \alpha q |F_{\text{ins}}|^{\frac{1}{2}} - \beta q |F_{\text{ins}}|^{\frac{2}{3}} - P_{\perp} V_{\text{sem}} + V_{\text{ins}} & F_{\text{ins}} > 0 \end{cases} \quad (822)
$$

where $E_{\text{B}0}$ is the zero field barrier height at the semiconductor–insulator interface. The second term in the equation represents barrier lowering due to the image potential. The third term of the barrier lowering is due to the tunneling processes. For the Si–SiO<sub>2</sub> interface, $\alpha = 2.59 \times 10^{-4} \text{ V}^{1/2} \text{cm}^{1/2}$. There is a large deviation in the literature for the value of $\beta$, so it can be considered a fitting parameter. The fourth term $P_{\perp} V_{\text{sem}}$ appears only in the lucky electron model where $P_{\perp}$ is a model parameter ($P_{\perp} = 1$ by default), and $V_{\text{sem}}$ represents the kinetic energy gain when carriers travel a distance $y$ to the interface without losing any energy. In the Fiegna model, $V_{\text{sem}}$ is zero.

The insulator field $F_{\text{ins}}$ is defined as:

$$
F_{\text{ins}} = \vec{F}_{\text{ins}} \cdot \hat{n} \left[ 1 - P_{\text{total}} + P_{\text{total}} \frac{|\vec{F}_{\text{ins}}|}{|\vec{F}_{\text{ins}} \cdot \hat{n}|} \right] \quad (823)
$$

where $\hat{n}$ is a normal vector along the direction of hot-carrier injection, and $P_{\text{total}}$ is a model parameter ($P_{\text{total}} = 0$ by default).

In addition, all hot-carrier models contain a probability $P_{\text{ins}}$ of scattering in the image-force potential well:

$$
P_{\text{ins}} = \begin{cases} \exp \left( -\frac{x_0}{\lambda_{\text{ins}}} \right) & F_{\text{ins}} < 0 \\ \exp \left( -\frac{t_{\text{ins}} - x_0}{\lambda_{\text{ins}}} \right) P_{\text{repel}} & F_{\text{ins}} > 0 \end{cases} \quad (824)
$$

where $\lambda_{\text{ins}}$ is the scattering mean free path in the insulator, $t_{\text{ins}}$ is the distance between the vertex at the hot interface and the closest associated vertex, $P_{\text{repel}}$ is a model parameter ($P_{\text{repel}} = 1$ by default), and the distance $x_0$ is given as:

$$
x_0 = \min \left( \sqrt{\frac{q}{16 \pi \tilde{\epsilon}_{\text{ins}} |F_{\text{ins}}|}}, \frac{t_{\text{ins}}}{2} \right) \quad (825)
$$

In the above expression, $\tilde{\epsilon}_{\text{ins}} = \epsilon_{\text{ins}} (\epsilon_{\text{sem}} + \epsilon_{\text{ins}}) / (\epsilon_{\text{sem}} - \epsilon_{\text{ins}})$ is the effective dielectric constant of the insulator where $\epsilon_{\text{sem}}$ and $\epsilon_{\text{ins}}$ are the high-frequency dielectric constant of the semiconductor and insulator, respectively. In the lucky electron model and Fiegna model, $\tilde{\epsilon}_{\text{ins}}$

25: Hot-Carrier Injection
Classical Lucky Electron Injection

is directly accessible from the parameter file. In the SHE distribution model, $\epsilon_{\text{sem}}$ and $\epsilon_{\text{ins}}$ are separately set from the parameter file.

## Effective Field

The lucky electron model and Fiegna model have an effective electric field $F_{\text{eff}}$ as a parameter. In Sentaurus Device, there are three possibilities to calculate the effective field:

*   With the electric field parallel to the carrier flow (switched on by the keyword `Eparallel`, which is default for hot carrier currents). See Driving Force on page 455.

*   With recomputation of the carrier temperature of the hydrodynamic simulation (switched on by the keyword `CarrierTempDrive`). See Avalanche Generation With Hydrodynamic Transport on page 456.

*   With a simplified approach (compared to the second method): The drift-diffusion model is used for the device simulation, and carrier temperature is estimated as the solution of the simplified and linearized energy balance equation. As this is a postprocessing calculation, the keyword `CarrierTempPost` activates this option.

These keywords are parameters of the model keywords. For example, the lucky electron model looks like `eLucky(CarrierTempDrive)`. However, you must remember that, if the model includes the keyword `CarrierTempDrive`, then `Hydro` and a carrier temperature calculation must be specified in the `Physics` section.

# Classical Lucky Electron Injection

The classical total lucky electron current from an interface to a gate contact can be written as [1]:

$$ I_g = \iint J_n(x, y) P_s P_{\text{ins}} \left( \int_{E_B}^{\infty} P_{\epsilon} P_r d\epsilon \right) dx dy $$ (826)

where $P_s$ is the probability that the electron will travel a distance $y$ to the interface without losing any energy, $P_{\epsilon} d\epsilon$ is the probability that the electron has energy between $\epsilon$ and $\epsilon + d\epsilon$, $P_{\text{ins}}$ is the probability of scattering in the image force potential well (Eq. 824), and $P_r$ is the probability that the electron will be redirected. These probabilities are given by the expressions:

$$ P_r(\epsilon) = \frac{1}{2\lambda_r} \left( 1 - \sqrt{\frac{E_B}{\epsilon}} \right) $$ (827)

25: Hot-Carrier Injection

Fiegna Hot-Carrier Injection

$$ P_s(y) = \exp(-\frac{y}{\lambda}) $$ (828)

$$ P_\varepsilon(\varepsilon) = \frac{1}{\lambda F_{\text{eff}}} \exp(-\frac{\varepsilon}{\lambda F_{\text{eff}}}) $$ (829)

where:

*   $\lambda$ is the scattering mean free path in the semiconductor.

*   $\lambda_r$ is redirection mean free path.

*   $F_{\text{eff}}$ is the effective electric field (see Effective Field on page 798).

*   $E_B$ is the height of the semiconductor–insulator barrier.

The model coefficients can be changed in the parameter file in the section:

`LuckyModel { ... }`

Table 141 Coefficients and their default values for the lucky electron model

| Symbol | Parameter name (Electrons) | Default value (Electrons) | Parameter name (Holes) | Default value (Holes) | Unit |
| --- | --- | --- | --- | --- | --- |
| $\lambda$ | eLsem | $8.9 \times 10^{-7}$ | hLsem | $1.0 \times 10^{-7}$ | cm |
| $\lambda_{\text{ins}}$ | eLins | $3.2 \times 10^{-7}$ | hLins | $3.2 \times 10^{-7}$ | cm |
| $\lambda_r$ | eLsemR | $6.2 \times 10^{-6}$ | hLsemR | $6.2 \times 10^{-6}$ | cm |
| $E_{B0}$ | eBar0 | 3.1 | hBar0 | 4.7 | eV |
| $\alpha$ | eBL12 | $2.6 \times 10^{-4}$ | hBL12 | $2.6 \times 10^{-4}$ | $(V \cdot cm)^{1/2}$ |
| $\beta$ | eBL23 | $3.0 \times 10^{-5}$ | hBL23 | $3.0 \times 10^{-5}$ | $(V \cdot cm^2)^{1/3}$ |
| $\varepsilon_{\text{ins}}$ | eps_ins | 3.1 | eps_ins | 3.1 | 1 |
| $P_\perp$ | Pvertical | 1 | Pvertical | 1 | 1 |
| $P_{\text{repel}}$ | Prepel | 1 | Prepel | 1 | 1 |
| $P_{\text{total}}$ | Ptotal | 0 | Ptotal | 0 | 1 |

# Fiegna Hot-Carrier Injection

The total hot-carrier injection current according to the Fiegna model [[2]](https://example.com/reference2) can be written as:

$$ I_g = q \int P_{\text{ins}} \left( \int_{E_{B0}}^{\infty} v_\perp(\varepsilon) f(\varepsilon) g(\varepsilon) d\varepsilon \right) ds $$ (830)

Fiegna Hot-Carrier Injection

where:

*   $\varepsilon$ is the electron energy.

*   $E_{B0}$ is the height of the semiconductor–insulator barrier.

*   $v_{\perp}$ is the velocity normal to the interface.

*   $f(\varepsilon)$ is the electron energy distribution.

*   $g(\varepsilon)$ is the density-of-states of the electrons.

*   $P_{\text{ins}}$ is the probability of scattering in the image force potential well as described by Eq. 824.

*   $\int ds$ is an integral along the semiconductor–insulator interface.

The following expression for the electron energy distribution was proposed for a parabolic and an isotropic band structure, and equilibrium between lattice and electrons:

$$ f(\varepsilon) = A \exp \left( -\chi \frac{\varepsilon^3}{F_{\text{eff}}^{1.5}} \right) \tag{831} $$

Therefore, the gate current can be rewritten as:

$$ I_g = q \frac{A}{3\chi} \int P_{\text{ins}} n \frac{F_{\text{eff}}^{3/2}}{\sqrt{E_B}} e^{-\frac{\chi E_B^3}{F_{\text{eff}}^{3/2}}} ds \tag{832} $$

where $F_{\text{eff}}$ is an effective field (see Effective Field on page 798).

Table 142 Coefficients and their default values for the Fiegna model

| Symbol | Parameter name (Electrons) | Default value (Electrons) | Parameter name (Holes) | Default value (Holes) | Unit |
| --- | --- | --- | --- | --- | --- |
| A | eA | $4.87 \times 10^4$ | hA | $4.87 \times 10^4$ | cm/s/eV$^{2.5}$ |
| $\chi$ | eChi | $1.3 \times 10^8$ | hChi | $1.3 \times 10^8$ | (V/cm/eV)$^{1.5}$ |
| $\lambda_{\text{ins}}$ | eLins | $3.2 \times 10^{-7}$ | hLins | $3.2 \times 10^{-7}$ | cm |
| $E_{B0}$ | eBar0 | 3.1 | hBar0 | 4.7 | eV |
| $\alpha$ | eBL12 | $2.6 \times 10^{-4}$ | hBL12 | $2.6 \times 10^{-4}$ | (V $\cdot$ cm)$^{1/2}$ |
| $\beta$ | eBL23 | $1.5 \times 10^{-5}$ | hBL23 | $1.5 \times 10^{-5}$ | (V $\cdot$ cm$^2$)$^{1/3}$ |
| $\varepsilon_{\text{ins}}$ | eps_ins | 3.1 | eps_ins | 3.1 | 1 |
| $P_{\text{repel}}$ | Prepel | 1 | Prepel | 1 | 1 |
| $P_{\text{total}}$ | Ptotal | 0 | Ptotal | 0 | 1 |

25: Hot-Carrier Injection
SHE Distribution Hot-Carrier Injection

These coefficients can be changed in the parameter file in the `FiegnaModel` section.

# SHE Distribution Hot-Carrier Injection

To obtain the hot-carrier injection current, accurate knowledge of the nonequilibrium electron-energy distribution is required. The spherical harmonics expansion (SHE) distribution hot-carrier injection model calculates the hot-carrier injection current using the nonequilibrium energy distribution $f$ obtained from the lowest-order SHE of the semiclassical Boltzmann transport equation (BTE) (see Spherical Harmonics Expansion Method on page 802).

The total hot-carrier injection current is obtained from [3]:

$$ I_g = \frac{2qAg_v}{4} \int \int_{0}^{\infty} P_{\text{ins}} \left[ \int_{0}^{1} g(\varepsilon)v(\varepsilon)f(\varepsilon) \left( \int \Gamma \left[ \varepsilon - \frac{h^3 g(\varepsilon)v(\varepsilon)x}{8\pi m_{\text{ins}}} \right] dx \right) d\varepsilon \right] ds $$ (833)

where:

*   $A$ is a dimensionless prefactor ($A = 1$ by default).

*   $g_v$ is the valley degeneracy factor.

*   $P_{\text{ins}}$ is the probability of electrons moving from the interface to the barrier peak without scattering (see Eq. 824, p. 797).

*   $g$ is the density-of-states per valley and per spin.

*   $v$ is the magnitude of the electron velocity.

*   $\Gamma$ is the transmission coefficient obtained from the WKB approximation including the image-potential barrier-lowering.

*   $m_{\text{ins}}$ is the insulator effective mass.

*   $\int ds$ is an integral along the semiconductor–insulator interface.

The transmission coefficient can be written as:

$$ \Gamma(\varepsilon_{\perp}) = \exp \left( -\frac{2}{\hbar} \int_{0}^{t_{\text{ins}}} \sqrt{2m_{\text{ins}}[E_B(r) - \varepsilon_{\perp}]} \Theta[E_B(r) - \varepsilon_{\perp}] dr \right) $$ (834)

$$ E_B(r) = E_{B0} + qF_{\text{ins}}r + E_{\text{im}}(r) $$ (835)

$$ E_{\text{im}}(r) = -\frac{q^2}{16\pi\varepsilon_{\text{ins}}} \sum_{n=0}^{\infty} \left( \frac{\varepsilon_{\text{sem}} - \varepsilon_{\text{ins}}}{\varepsilon_{\text{sem}} + \varepsilon_{\text{ins}}} \right)^{2n+1} \left[ \frac{1}{nt_{\text{ins}} + r} + \frac{1}{(n+1)t_{\text{ins}} - r} - \frac{2}{(n+1)t_{\text{ins}}} \left( \frac{\varepsilon_{\text{sem}} - \varepsilon_{\text{ins}}}{\varepsilon_{\text{sem}} + \varepsilon_{\text{ins}}} \right) \right] $$ (836)

## SHE Distribution Hot-Carrier Injection

where $E_{B0}$ is the barrier height.

To use the SHE distribution hot-carrier injection model, you must obtain the distribution function by solving the SHE method (see Spherical Harmonics Expansion Method on page 802). Eq. 836 represents the image-potential barrier-lowering. You can switch off the image-potential barrier-lowering using:

```
Physics(MaterialInterface="Silicon/Oxide") { ...
  GateCurrent( eSHEDistribution( -ImagePotential ) )
}
```

# Spherical Harmonics Expansion Method

The spherical harmonics expansion (SHE) method computes the microscopic carrier energy distribution function $f(\vec{r}, \varepsilon)$ by solving the lowest-order SHE of the Boltzmann transport equation (BTE) [4]:

$$ -\nabla \cdot \left[ \frac{v^2(\vec{r}, \varepsilon_t)}{3} \tau(\vec{r}, \varepsilon_t) g(\vec{r}, \varepsilon_t) \nabla f(\vec{r}, \varepsilon_t) \right] = g(\vec{r}, \varepsilon_t) s(\vec{r}, \varepsilon_t) $$ (837)

where:

* $f$ is the occupation probability of electrons ($f$ can be larger than one as nondegenerate statistics is assumed).

* $\varepsilon_t$ is the total energy including the conduction band energy $E_C$ and the kinetic energy $\varepsilon$.

* $v$ is the magnitude of the electron velocity.

* $1/\tau$ is the total scattering rate.

* $g$ is the density-of-states per valley and per spin.

* $s$ is the net in-scattering rate due to inelastic scattering and generation–recombination processes.

In Eq. 837, $g(\varepsilon)$ and $v(\varepsilon)$ can be obtained from the energy–wavevector dispersion relation, $\varepsilon_b(\vec{k})$, of semiconductors:

$$ g_v g(\varepsilon) = g_v \sum_{b=1}^{N_b} g_b(\varepsilon) = \sum_{b=1}^{N_b} \int_{\varepsilon} \frac{1}{4\pi^2 \hbar v_b(\vec{k})} ds_{\vec{k}} $$ (838)

$$ g_v g(\varepsilon) v^2(\varepsilon) = g_v \sum_{b=1}^{N_b} g_b(\varepsilon) v_b^2(\varepsilon) = \sum_{b=1}^{N_b} \int_{\varepsilon} \frac{v_b(\vec{k})}{4\pi^2 \hbar} ds_{\vec{k}} $$ (839)

**25: Hot-Carrier Injection**
SHE Distribution Hot-Carrier Injection

where:

*   $\varepsilon = \varepsilon_t - E_C(\vec{r})$ is the kinetic energy.

*   $g_v$ is the valley degeneracy.

*   $b$ is the band index.

*   $N_b$ is the number of bands.

*   $v_b(\vec{k})$ is the magnitude of wavevector-dependent group velocity.

*   $h$ is Planck’s constant.

*   The integration is over the equienergy surface of the first Brillouin zone.

In addition, the energy-dependent square wavevector is defined as:

$$g_v k^2(\varepsilon) = g_v \sum_{b=1}^{N_b} k_b^2(\varepsilon) = \sum_{b=1}^{N_b} \int_{\varepsilon} \frac{1}{4\pi} ds_{\vec{k}}$$ (840)

These energy-dependent, band structure–related quantities can be obtained either from the precalculated band-structure file or from the single band, analytic, nonparabolic, band-structure model. For more information on the band-structure file, see Using Spherical Harmonics Expansion Method on page 806.

The analytic nonparabolic band-structure model gives [5]:

$$\frac{v^2(\varepsilon)}{3} = \frac{2\varepsilon(1 + \alpha\varepsilon)}{3m_c(1 + 2\alpha\varepsilon)^2}$$ (841)

$$g(\varepsilon) = \frac{2\pi(2m_n)^{3/2}}{h^3} [\varepsilon(1 + \alpha\varepsilon)]^{1/2} (1 + 2\alpha\varepsilon)$$ (842)

$$k^2(\varepsilon) = \pi h g(\varepsilon) v(\varepsilon)$$ (843)

where $\alpha$ is the nonparabolicity factor, $m_c$ is the conductivity effective mass, and $m_n$ is the density-of-states effective mass.

The total scattering rate and the net in-scattering rate can be written as:

$$\frac{1}{\tau(\varepsilon)} = \frac{1}{\tau_c(\varepsilon)} + \frac{1}{\tau_{ii}(\varepsilon)} + \frac{1}{\tau_{ac}(\varepsilon)} + \frac{1}{\tau_{ope}(\varepsilon)} + \frac{1}{\tau_{opa}(\varepsilon)}$$ (844)

$$s(\varepsilon) = \frac{f_{loc}(\varepsilon) - f(\varepsilon)}{\tau_{ii}(\varepsilon)} + \frac{f(\varepsilon - \varepsilon_{op}) \exp(-\frac{\varepsilon_{op}}{kT}) - f(\varepsilon)}{\tau_{ope}(\varepsilon)} + \frac{f(\varepsilon + \varepsilon_{op}) \exp(\frac{\varepsilon_{op}}{kT}) - f(\varepsilon)}{\tau_{opa}(\varepsilon)} - \frac{R_{net} f_{loc}(\varepsilon)}{n}$$ (845)

SHE Distribution Hot-Carrier Injection

where:

*   $1/\tau_c$ is the Coulomb scattering rate.

*   $1/\tau_{ii}$ is the impact ionization scattering rate.

*   $1/\tau_{ac}$ is the acoustic phonon scattering rate.

*   $1/\tau_{ope}$ is the scattering rate due to optical phonon emissions.

*   $1/\tau_{opa}$ is the scattering rate due to optical phonon absorptions.

*   $\varepsilon_{op}$ is the optical phonon energy.

*   $R_{net}$ is the net recombination rate.

*   $n$ is the electron density.

*   $f_{loc} = \exp[(E_{F,n} - E_C - \varepsilon)/kT]$ is the local equilibrium distribution function.

The Coulomb scattering rate can be written as [6]:

$$ \frac{1}{\tau_c(\varepsilon)} = \frac{q^4 \pi^2 g(\varepsilon) N_{i,eff}}{2h \varepsilon_{sem}^2 [k^2(\varepsilon) + k_0^2]^2} \left[ \ln(1+b) - \frac{b}{1+b} \right] \text{ (846)} $$

$$ b(\varepsilon) = \frac{4[k^2(\varepsilon) + k_0^2]kT\varepsilon_{sem}}{q^2(n+p)} \text{ (847)} $$

$$ N_{i,eff} = \begin{cases} (N_D + N_A) \zeta_{major}(N_{major}) & N_{major} > N_{minor} \\ (N_D + N_A) \zeta_{minor}(N_{minor}) & N_{major} < N_{minor} \end{cases} \text{ (848)} $$

where:

*   $\varepsilon_{sem}$ is the dielectric constant of a semiconductor material.

*   $k_0^2$ is an adjustable parameter that controls the energy dependency of the impurity scattering.

*   $N_{major}$ is $N_D$ for electrons and $N_A$ for holes.

*   $N_{minor}$ is $N_A$ for electrons and $N_D$ for holes.

*   $\zeta_{major}$ and $\zeta_{minor}$ are tabulated fitting functions introduced to match the experimental low-field mobility curve as a function of majority and minority doping concentrations, respectively.

25: Hot-Carrier Injection

SHE Distribution Hot-Carrier Injection

Two different expressions for the impact ionization scattering rate are available. The first expression can be written as [6]:

$$ \frac{1}{\tau_{ii}(\varepsilon)} = \begin{cases} \left( \frac{\varepsilon - \varepsilon_{ii,1}}{1 \text{ eV}} \right)^{\nu_{ii,1}} s_{ii,1} & \varepsilon_{ii,1} < \varepsilon < \varepsilon_{ii,3} \\ \left( \frac{\varepsilon - \varepsilon_{ii,2}}{1 \text{ eV}} \right)^{\nu_{ii,2}} s_{ii,2} & \varepsilon > \varepsilon_{ii,3} \end{cases} \text{ (849)} $$

where:

*   $s_{ii,1}$ and $s_{ii,2}$ are the impact ionization coefficients.

*   $\nu_{ii,1}$ and $\nu_{ii,2}$ are the exponents.

*   $\varepsilon_{ii,1}$, $\varepsilon_{ii,2}$, and $\varepsilon_{ii,3}$ are the reference energies.

The second expression can be written as [7]:

$$ \frac{1}{\tau_{ii}(\varepsilon)} = \sum_{j=1}^{3} \left( \frac{\varepsilon - \varepsilon_{ii,j}}{1 \text{ eV}} \right)^{\nu_{ii,j}} \Theta(\varepsilon - \varepsilon_{ii,j}) s_{ii,j} \text{ (850)} $$

Specifying `ii_formula=1` in the `SHEDistribution` parameter set activates the first expression; while `ii_formula=2` activates the second expression. The impact ionization model parameters for electrons and holes are obtained from [6] and [8], respectively.

The acoustic-phonon and optical-phonon scattering rates can be written as [5][6]:

$$ \frac{g(\varepsilon)}{\tau_{ac}(\varepsilon)} = \sum_{i=1}^{N_b} \sum_{j=1}^{N_b} \frac{4\pi^2 k T D_{ac,ij}^2}{\hbar \rho c_L^2} g_i(\varepsilon) g_j(\varepsilon) \text{ (851)} $$

$$ \frac{g(\varepsilon)}{\tau_{ope}(\varepsilon)} = \sum_{i=1}^{N_b} \sum_{j=1}^{N_b} \frac{\hbar D_{op,ij}^2}{2\rho \varepsilon_{op}} (N_{op} + 1) g_i(\varepsilon) g_j(\varepsilon - \varepsilon_{op}) \text{ (852)} $$

$$ \frac{g(\varepsilon)}{\tau_{opa}(\varepsilon)} = \sum_{i=1}^{N_b} \sum_{j=1}^{N_b} \frac{\hbar D_{op,ij}^2}{2\rho \varepsilon_{op}} N_{op} g_i(\varepsilon) g_j(\varepsilon + \varepsilon_{op}) \text{ (853)} $$

where:

*   $i$ and $j$ are the band indices.

*   $D_{ac,ij}$ and $D_{op,ij}$ are the deformation potentials for acoustic and g-type optical phonons, respectively ($D_{ac,ij} = D_{ac,ji}$ and $D_{op,ij} = D_{op,ji}$).

*   $\rho$ is the mass density.

25: Hot-Carrier Injection

SHE Distribution Hot-Carrier Injection

*   $c_L$ is the sound velocity.

*   $N_{op} = [\exp(\epsilon_{op}/kT) - 1]^{-1}$ is the phonon number.

If $D_{ac,ij} = D_{ac}$ and $D_{op,ij} = D_{op}$ regardless of the band indices, Eq. 851, Eq. 852, and Eq. 853 can be simplified to:

$$\frac{1}{\tau_{ac}(\epsilon)} = \frac{4\pi^2 kTD_{ac}^2}{h\rho c_L^2}g(\epsilon)$$ (854)

$$\frac{1}{\tau_{ope}(\epsilon)} = \frac{hD_{op}^2}{2\rho\epsilon_{op}}(N_{op} + 1)g(\epsilon - \epsilon_{op})$$ (855)

$$\frac{1}{\tau_{opa}(\epsilon)} = \frac{hD_{op}^2}{2\rho\epsilon_{op}}N_{op}g(\epsilon + \epsilon_{op})$$ (856)

Dirichlet boundary condition as $f(\epsilon) = \exp[(E_{F,n} - E_C - \epsilon)/kT]$ is assumed for electrodes.

Boundary conditions for abrupt heterointerfaces are similar to the corresponding boundary conditions for the thermionic emission model. Assume that at the heterointerface between materials 1 and 2, the conduction band edge jump is positive ($\Delta E_C = E_{C,2} - E_{C,1} > 0$). If $J_{n,2}(\epsilon)$ and $J_{n,1}(\epsilon)$ are the energy-dependent electron current density per spin and per valley entering material 2 and leaving material 1, the interface condition can be written as:

$$J_{n,2}(\epsilon) = J_{n,1}(\epsilon)$$ (857)

$$J_{n,2}(\epsilon) = \frac{q}{4}g_2(\epsilon)v_2(\epsilon)[f_2(\epsilon) - f_1(\epsilon)]$$ (858)

where $g_i(\epsilon)$, $v_i(\epsilon)$, and $f_i(\epsilon)$ are the density-of-states, the group velocity, and the occupation probability of material $i$, respectively.

All other boundaries are treated with reflective boundary conditions.

# Using Spherical Harmonics Expansion Method

The electron-energy distribution function is calculated from Eq. 837, p. 802 in the semiconductor regions specified by the global, region-specific, or material-specific `Physics` section:

```
Physics { eSHEDistribution( <arguments> ) ...}
```

**25: Hot-Carrier Injection**
SHE Distribution Hot-Carrier Injection

By default, $g(\varepsilon)$, $v(\varepsilon)$, and $k^2(\varepsilon)$ are obtained from the analytic band model. These band structure–related quantities also can be obtained from the default electron-band file `eSHEBandSilicon.dat` in the directory `$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/she` by specifying the argument `FullBand`:

```
Physics { eSHEDistribution( FullBand ... ) ... }
```

The default electron-band file `eSHEBandSilicon.dat` contains the band-structure quantities obtained from the nonlocal empirical pseudopotential method for relaxed silicon. Similarly, there is a default hole-band file `hSHEBandSilicon.dat` in the same directory.

> **NOTE** For silicon regions, it is recommended to use the `FullBand` option as the default model parameters are calibrated based on the full band structure. In addition, there is no performance penalty when using the `FullBand` option.

You also can specify your own band file as:

```
Physics { eSHEDistribution( FullBand = "filename" ... ) ... }
```

The band file is a plain text file composed of $1 + 3N_b$ columns of data where $N_b$ is the number of bands ($1 \le N_b \le 4$). The first column represents the kinetic energy $\varepsilon$ [eV]. The subsequent columns represent $g_v g_b(\varepsilon)$ [cm<sup>-3</sup> eV<sup>-1</sup>], $g_v g_b(\varepsilon)v_b^2(\varepsilon)$ [cm<sup>-1</sup> s<sup>-2</sup> eV<sup>-1</sup>], and $g_v k_b^2(\varepsilon)$ [cm<sup>-2</sup>] for band $b$ ($1 \le b \le N_b$). The kinetic energy should start from zero, and the energy spacing between the neighbour rows should be uniform. Refer to `eSHEBandSilicon.dat` for more information.

When `FullBand` is specified for devices containing SiGe, the band-structure quantities for SiGe regions are taken from mole fraction–dependent files in the same directory where the silicon files are located. The band-structure data was obtained from the nonlocal empirical pseudopotential method for relaxed SiGe with mole-fraction values of 0.0, 0.1, 0.2, ..., 1.0:

*   Electron files: `eSHEBandSiGeX0.0.dat`, `eSHEBandSiGeX0.1.dat`, ...
*   Hole files: `hSHEBandSiGeX0.0.dat`, `hSHEBandSiGeX0.1.dat`, ...

Sentaurus Device automatically chooses the appropriate files based on the average x-mole fraction value in each SiGe region. Linear interpolation of band-structure quantities is used for intermediate x-mole fraction values.

> **NOTE** The simulation of electrons in SiGe is deactivated.

Model parameters in the `SHEDistribution` parameter set (see Table 143 on page 812) can be specified with mole-fraction dependency. As with data from the band-structure files, the average x-mole fraction value in each region is used to determine the parameter values.

SHE Distribution Hot-Carrier Injection

Sentaurus Device provides a simplified SHE model based on the relaxation time approximation (RTA) for the hot-carrier injection current computation. Although the RTA is a poor approximation, the RTA can remove the energy coupling and reduce simulation time. You can activate the RTA mode as follows:

```
Physics { eSHEDistribution( RTA ... ) ... }
```

When the RTA mode is selected, the relaxation time is defined as:

$$ \frac{1}{\tau_{\text{RTA}}(\varepsilon)} = \frac{v(\varepsilon)}{\lambda_{\text{sem}}} + \frac{1}{\tau_0} \tag{859} $$

where $\lambda_{\text{sem}}$ and $\tau_0$ are adjustable parameters representing a mean free path and relaxation time. In the RTA mode, Eq. 845 is replaced by:

$$ s(\varepsilon) = \frac{f_{\text{loc}}(\varepsilon) - f(\varepsilon)}{\tau_{\text{RTA}}(\varepsilon)} \tag{860} $$

**NOTE** In the RTA mode, you must specify `SHEIterations=1` together with `SHESOR` in the global `Math` section. The RTA mode must not be used for self-consistent computations as the carrier flux is not conserved.

In the SHE method, the low-field mobility is determined by the microscopic scattering rate:

$$ \mu_{\text{low}} = \frac{q \int_0^\infty \tau(\varepsilon) g(\varepsilon) v^2(\varepsilon) \exp(-\frac{\varepsilon}{kT}) d\varepsilon}{3kT \int_0^\infty g(\varepsilon) \exp(-\frac{\varepsilon}{kT}) d\varepsilon} \tag{861} $$

The mobility obtained from Eq. 861 and that from the macroscopic mobility model specified in the `Physics` section generally differ. For example, Eq. 861 overestimates the low-field mobility in the inversion layer of MOSFETs as the scattering rate in Eq. 844, p. 803 does not account for the mobility degradation at interfaces. To resolve this inconsistency, the Coulomb scattering rate is adjusted locally to match the low-filed mobility obtained from the mobility model. This option is activated by default. To switch off this option, specify:

```
Physics { eSHEDistribution( -AdjustImpurityScattering ... ) ... }
```

Similarly, for the hole-energy distribution function, specify `hSHEDistribution` in the `Physics` section.

Eq. 837, p. 802 is a coupled energy-dependent conservation equation with diffusion and source terms. The number of unknown variables in the SHE method is much larger than that in the drift-diffusion model or hydrodynamic model because of the additional total energy coordinate.

**25: Hot-Carrier Injection**
SHE Distribution Hot-Carrier Injection

By default, the blockwise successive over-relaxation (SOR) method is used to solve the equation iteratively where the SOR iteration is performed over different total energies. The linear solver for the block system, the number of SOR iterations, and the SOR parameter can be accessed by the keywords `SHEMethod`, `SHEIterations`, and `SHESORParameter` in the global `Math` section. The default values are:

```
Math {
  SHEMethod=super
  SHEIterations=20
  SHESORParameter=1.1
}
```

Instead of using the blockwise SOR method, you also can solve Eq. 837, p. 802 for different energies simultaneously by switching off the keyword `SHESOR` in the global `Math` section. Although any matrix solver can be used, the iterative linear solver ILS is the only practical option to solve Eq. 837 because of the large matrix size.

The ILS default parameters in `set=3` can be used for the SHE method. For example:

```
Math {
  -SHESOR
  SHEMethod=ILS(set = 3)
  ...
}
```

The ILS default parameters in `set=3` are defined as:

```
set (3) {
  iterative (gmres(100), tolrel=1e-8, tolunprec=1e-4, tolabs=0, maxit=200);
  preconditioning (ilut(0.00011,-1));
  ordering ( symmetric=rcm, nonsymmetric=mpsilst );
  options ( compact=yes, verbose=0, refinebasis=0, refinescaling=none,
         refineresidual=0 );
};
```

The global `Math` section provides some parameters related to the energy grid specification. The minimum and the maximum of the total energy coordinate are defined as:

$$ \varepsilon_{t,\min} = \min[E_C(\vec{r})] \tag{862} $$

$$ \varepsilon_{t,\max} = \max[E_C(\vec{r})] + \varepsilon_{\text{margin}} \tag{863} $$

where $\varepsilon_{\text{margin}}$ is an energy margin ($\varepsilon_{\text{margin}} = 1\text{eV}$ by default). The energy grid spacing is defined by the fraction of the phonon energy $\Delta\varepsilon_t = \varepsilon_{\text{op}}/N_{\text{refine}}$ where $N_{\text{refine}}$ is a positive integer ($N_{\text{refine}} = 1$ by default).

SHE Distribution Hot-Carrier Injection

The parameters $\epsilon_{margin}$ and $N_{refine}$ can be set in the global `Math` section:

```
Math {
  SHETopMargin = 1.0  # e_margin [eV]
  SHERefinement = 1   # N_refine
  ...
}
```

While the total energy grid is used for the computation, a uniform kinetic energy grid is used for plotting. The maximum kinetic energy to be plotted can be specified by the keyword `SHECutoff` (5 eV by default) in the global `Math` section:

```
Math { SHECutoff = 5.0 ... }
```

By default, the carrier energy distribution is updated in the postprocessing computation after each Sentaurus Device simulation point. You can suppress or activate the postprocessing computation using the `Set` statement of the `Solve` section. For example:

```
Solve { ...
  Set ( eSHEDistribution (Frozen) )   # freeze the distribution function
  ...
  Set ( eSHEDistribution (-Frozen) )  # unfreeze the distribution function
  ...
}
```

As long as the distribution function is frozen, the distribution is unchanged during simulation.

Instead of the postprocessing computation, you also can obtain the self-consistent DC solution by using the `Plugin` statement. For example:

```
Solve { ...
  Plugin (iterations=100) { Poisson eSHEDistribution hole }
  ...
}
```

In the self-consistent mode, the carrier density and the terminal current are obtained directly from the SHE method. You also can include the quantum correction in the SHE method. For example:

```
Solve { ...
  Plugin { Coupled {Poisson eQuantumPotential} eSHEDistribution hole }
  ...
}
```

25: Hot-Carrier Injection
SHE Distribution Hot-Carrier Injection

**NOTE** In the self-consistent mode, you must specify the keyword `DirectCurrent` in the global `Math` section. In addition, you might need to increase `SHERefinement` to improve the resolution of the energy grid. The self-consistent mode does not support transient, AC, and noise analysis. In general, the lowest-order SHE method might not be sufficiently accurate to simulate nanoscale transistors as the contribution of higher-order terms increases with decreasing device length [9]. The convergence rate of the `Plugin` method can be very slow when large biases are applied.

For backward compatibility, the following pairs of keywords are recognized as synonyms in the command file:

*   `SHEDistribution` and `TailDistribution`

*   `eSHEDistribution` and `TaileDistribution`

*   `hSHEDistribution` and `TailhDistribution`

*   `SHEIterations` and `TailDistributionIterations`

*   `SHEMethod` and `TailDistributionMethod`

*   `SHESOR` and `TailDistributionSOR`

*   `SHESORParameter` and `TailDistributionSORParameter`

In the PMI, you can read the distribution function, density-of-states, and group velocity obtained from the SHE method using the following read functions:

*   `ReadeSHEDistribution`: Returns $f(\varepsilon)$ for electrons.

*   `ReadeSHETotalDOS`: Returns $2g_v g(\varepsilon)$ for electrons.

*   `ReadeSHETotalGSV`: Returns $2g_v g(\varepsilon)v^2(\varepsilon)$ for electrons.

*   `ReadhSHEDistribution`: Returns $f(\varepsilon)$ for holes.

*   `ReadhSHETotalDOS`: Returns $2g_v g(\varepsilon)$ for holes.

*   `ReadhSHETotalGSV`: Returns $2g_v g(\varepsilon)v^2(\varepsilon)$ for holes.

For more information, see Chapter 39 on page 1165.

The parameters for the SHE method are available in the `SHEDistribution` parameter set. Table 143 on page 812 lists the coefficients of models and their default values.

**NOTE** The optical phonon energy $\varepsilon_{op}$ is closely related to the energy grid spacing. Therefore, the same optical phonon energy must be used in the simulation domain.

SHE Distribution Hot-Carrier Injection

Table 143 Default parameters for SHE distribution model

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| ρ | rho | 2.329 |  | g/cm3 |
| εsem | epsilon | 11.7 |  | ε0 |
| εins | eps_ins | 2.15 |  | ε0 |
| mc | m_s | 0.26 | 0.26 | m0 |
| mn | m_dos | 0.328 | 0.689 | m0 |
| mins | m_ins | 0.5 | 0.77 | m0 |
| α | alpha | 0.5 | 0.669 | eV–1 |
| gv | g | 6 | 1 | 1 |
| A | A | 1 | 1 | 1 |
| EB0 | E_barrier | 3.1 | 4.73 | eV |
| λins | Lins | 2.0 × 10–7 | 2.0 × 10–7 | cm |
| λsem | Lsem | 5.0 × 10–6 | 1.0 × 10–6 | cm |
| τ0 | tau0 | 1.0 × 10–12 | 1.0 × 10–12 | s |
| Dac/cL | Dac_cl | 1.027 × 10–5 | 6.29 × 10–6 | eVs/cm |
| Dop | Dop | 1.25 × 109 | 8.7 × 108 | eV/cm |
| εop | HbarOmega | 0.06 | 0.0633 | eV |
| k02 | swv0 | 0.0 | 0.0 | cm–2 |
|  | ii_formula1 | 1 | 1 |  |
| sii,1 | ii_rate1 | 1.49 × 1011 | 0.0 | s–1 |
| sii,2 | ii_rate2 | 1.13 × 1012 | 1.14 × 1012 | s–1 |
| sii,3 | ii_rate3 | 0.0 | 0.0 | s–1 |
| εii,1 | ii_energy1 | 1.128 | 1.128 | eV |
| εii,2 | ii_energy2 | 1.572 | 1.49 | eV |
| εii,3 | ii_energy3 | 1.75 | 1.49 | eV |
| νii,1 | ii_exponent1 | 3.0 | 0.0 | 1 |
| νii,2 | ii_exponent2 | 2.0 | 3.4 | 1 |
| νii,3 | ii_exponent3 | 0.0 | 0.0 | 1 |

25: Hot-Carrier Injection
SHE Distribution Hot-Carrier Injection

Table 144 lists the coefficients and the default values of the tabulated doping-dependent fitting parameters $\zeta_{major}$ and $\zeta_{minor}$ for electrons and holes.

> **NOTE** By default, the fitting parameters $\zeta_{major}$ and $\zeta_{minor}$ are neglected as the impurity scattering rate is adjusted automatically according to the low-field mobility. You must switch off `AdjustImpurityScattering` to use these parameters.

Table 144 Default parameters for unitless doping-dependent functions $\zeta_{major}$ and $\zeta_{minor}$

| Doping | Parameter name (electrons) | $\zeta_{major}$ (electrons) | $\zeta_{minor}$ (electrons) | Parameter name (holes) | $\zeta_{major}$ (holes) | $\zeta_{minor}$ (holes) |
| --- | --- | --- | --- | --- | --- | --- |
| 1015.00/cm3 | efit(0) | 1.20698 | 2.63089 | hfit(0) | 2.36872 | 3.84998 |
| 1015.25/cm3 | efit(1) | 1.26585 | 2.61522 | hfit(1) | 2.47647 | 3.82989 |
| 1015.50/cm3 | efit(2) | 1.35031 | 2.62123 | hfit(2) | 2.65631 | 3.87730 |
| 1015.75/cm3 | efit(3) | 1.45972 | 2.64751 | hfit(3) | 2.91784 | 3.98847 |
| 1016.00/cm3 | efit(4) | 1.59727 | 2.68504 | hfit(4) | 3.28127 | 4.16424 |
| 1016.25/cm3 | efit(5) | 1.76810 | 2.73218 | hfit(5) | 3.77842 | 4.40187 |
| 1016.50/cm3 | efit(6) | 1.97625 | 2.77580 | hfit(6) | 4.44356 | 4.68485 |
| 1016.75/cm3 | efit(7) | 2.22278 | 2.80091 | hfit(7) | 5.29810 | 4.97515 |
| 1017.00/cm3 | efit(8) | 2.50474 | 2.79066 | hfit(8) | 6.33175 | 5.21189 |
| 1017.25/cm3 | efit(9) | 2.81348 | 2.72938 | hfit(9) | 7.48564 | 5.32107 |
| 1017.50/cm3 | efit(10) | 3.13088 | 2.60729 | hfit(10) | 8.64257 | 5.23752 |
| 1017.75/cm3 | efit(11) | 3.42620 | 2.42644 | hfit(11) | 9.62681 | 4.93200 |
| 1018.00/cm3 | efit(12) | 3.66329 | 2.20490 | hfit(12) | 10.2280 | 4.42987 |
| 1018.25/cm3 | efit(13) | 3.82090 | 1.97450 | hfit(13) | 10.2758 | 3.80695 |
| 1018.50/cm3 | efit(14) | 3.91451 | 1.77291 | hfit(14) | 9.74236 | 3.16136 |
| 1018.75/cm3 | efit(15) | 4.00744 | 1.63637 | hfit(15) | 8.78324 | 2.57856 |
| 1019.00/cm3 | efit(16) | 4.21180 | 1.59940 | hfit(16) | 7.66672 | 2.11166 |
| 1019.25/cm3 | efit(17) | 4.69302 | 1.70363 | hfit(17) | 6.65698 | 1.78292 |
| 1019.50/cm3 | efit(18) | 5.69842 | 2.01596 | hfit(18) | 5.94642 | 1.59808 |
| 1019.75/cm3 | efit(19) | 7.63117 | 2.65859 | hfit(19) | 5.66599 | 1.56334 |
| 1020.00/cm3 | efit(20) | 11.1923 | 3.85825 | hfit(20) | 5.94556 | 1.70207 |

25: Hot-Carrier Injection
SHE Distribution Hot-Carrier Injection

# Visualizing Spherical Harmonics Expansion Method

For plotting purposes, the SHE method provides several macroscopic variables that can be obtained from the energy distribution function:

$$ n_{\text{SHE}} = 2g_{\text{v}} \int_{0}^{\infty} g(\varepsilon) f(\varepsilon) d\varepsilon $$ (864)

$$ T_{n, \text{ SHE}} = \frac{2g_{\text{v}}}{n_{\text{SHE}}} \int_{0}^{\infty} \frac{2\varepsilon}{3k} g(\varepsilon) f(\varepsilon) d\varepsilon $$ (865)

$$ G_{n, \text{ SHE}}^{ii} = 2g_{\text{v}} \int_{0}^{\infty} \frac{1}{\tau_{ii}(\varepsilon)} g(\varepsilon) f(\varepsilon) d\varepsilon $$ (866)

$$ \vec{J}_{n, \text{ SHE}} = \frac{2qg_{\text{v}}}{3} \int_{0}^{\infty} g(\varepsilon) v^{2}(\varepsilon) \nabla f(\varepsilon) d\varepsilon $$ (867)

$$ \vec{v}_{n, \text{ SHE}} = \frac{\vec{J}_{n, \text{ SHE}}}{qn_{\text{SHE}}} $$ (868)

where $n_{\text{SHE}}$, $T_{n, \text{ SHE}}$, $G_{n, \text{ SHE}}^{ii}$, $\vec{J}_{n, \text{ SHE}}$, and $\vec{v}_{n, \text{ SHE}}$ are the electron density, the average energy, the avalanche generation rate, the current density, and the average velocity, respectively.

The corresponding keywords for plotting these macroscopic variables are:

```
Plot {
  eSHEDensity               # electron density [/cm^3]
  eSHEEnergy                # average electron energy [K]
  eSHEAvalancheGeneration   # electron avalanche generation rate [/cm^3s]
  eSHECurrentDensity/Vector # electron current density [A/cm^2]
  eSHEVelocity/Vector       # electron average velocity [cm/s]
}
```

The corresponding keywords for holes are hSHEDensity, hSHEEnergy, hSHEAvalancheGeneration, hSHECurrentDensity, and hSHEVelocity.

 25: Hot-Carrier Injection

Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity Equations

To plot the position-dependent electron-energy distribution function $f$ for each kinetic energy grid, specify `eSHEDistribution/SpecialVector` in the `Plot` section:

```
Plot {
  ...
  eSHEDistribution/SpecialVector
}
```

Similarly, for the hole-energy distribution function, specify `hSHEDistribution/SpecialVector`. The column $i$ of the special vector represents the distribution function at $\varepsilon = (i + 1)\Delta\varepsilon$. For example, `eSHEDistribution_C2` represents $f$ at $\varepsilon = 3\Delta\varepsilon$.

In addition, Sentaurus Device allows you to plot the electron-energy distribution function versus kinetic energy at positions specified in the command file.

The plot file is a `.plt` file, and its name must be defined in the `File` section by the keyword `eSHEDistribution`:

```
File {
  ...
  eSHEDistribution = "edist"
}
```

Plotting is activated by including the `eSHEDistributionPlot` section (similar to the `CurrentPlot` section) in the command file with a set of coordinates of positions:

```
eSHEDistributionPlot {
  (-0.02 0) (0 0) (0.02 0)
  ...
}
```

For each position defined by its coordinates, Sentaurus Device determines the enclosing element and interpolates the distribution function using the data at the element vertices. Similarly, for the hole-energy distribution function, define `hSHEDistribution` in the `File` section and include the `hSHEDistributionPlot` section in the command file.

# Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity Equations

Hot-carrier current can be added as an interface boundary condition for continuity equations in adjacent semiconductor regions. A typical structure (see Figure 51 on page 816) consists of sequences of semiconductor–insulator–semiconductor regions. Hot-carrier current produced at one semiconductor–insulator interface from the sequence is added to the second semiconductor–insulator interface, using the closest vertex algorithm described in Destination of Injected Current on page 794.

Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity Equations

**NOTE** This feature is available only for transient simulations and is especially useful for writing and erasing memory cells.

Engineering drawing of hot-carrier injection in a MOSFET structure showing G, S, D terminals, insulator layers, and injection current as boundary condition.

Figure 51 Injection of hot-carrier current in a MOSFET structure

At each time step after the solution is computed, the hot-carrier injection (HCI) currents are post-evaluated using the solution. For the next time step, the HCI currents are added using the current boundary condition for continuity equations in semiconductor regions, where carriers are injected, and then the whole carrier transport task is solved self-consistently.

The carriers leave the semiconductor region where they are produced and enter nonlocally into the semiconductor region where they are injected. To conserve current, injection current is subtracted from the former semiconductor region and added to the latter.

By using this method, the solution is obtained self-consistently (with one time-step delay) even if there is no carrier transport through the insulator region.

The feature is activated automatically during a transient simulation when any of the hot-carrier injection models is activated in the `GateCurrent` section and the floating semiconductor region where the hot carriers are to be injected does not have a charge boundary condition specified. Specifying `GateName` in the `GateCurrent` section disables the feature.

In addition, hot-carrier injection and the currents of the Fowler–Nordheim tunneling model can be computed at semiconductor–oxide-as-semiconductor interfaces. This is an extension of the searching algorithm described in Destination of Injected Current on page 794. In this case, there is a semiconductor–semiconductor interface instead of semiconductor–insulator interface. To avoid ambiguity, one of the interface regions must be selected as an insulator using the keyword `InjectionRegion`:

```
Physics(RegionInterface="Region_sem12/Region_sem2") {
      GateCurrent(Fowler eLucky InjectionRegion="Region_sem2")
}
```

25: Hot-Carrier Injection
References

# References

[1] K. Hasnat *et al.*, "A Pseudo-Lucky Electron Model for Simulation of Electron Gate Current in Submicron NMOSFET's," *IEEE Transactions on Electron Devices*, vol. 43, no. 8, pp. 1264–1273, 1996.

[2] C. Fiegna *et al.*, "Simple and Efficient Modeling of EPROM Writing," *IEEE Transactions on Electron Devices*, vol. 38, no. 3, pp. 603–610, 1991.

[3] S. Jin *et al.*, "Gate Current Calculations Using Spherical Harmonic Expansion of Boltzmann Equation," in *International Conference on Simulation of Semiconductor Processes and Devices (SISPAD)*, San Diego, CA, USA, pp. 202–205, September 2009.

[4] A. Gnudi *et al.*, "Two-dimensional MOSFET Simulation by Means of a Multidimensional Spherical Harmonics Expansion of the Boltzmann Transport Equation," *Solid-State Electronics*, vol. 36, no. 4, pp. 575–581, 1993.

[5] C. Jacoboni and L. Reggiani, "The Monte Carlo method for the solution of charge transport in semiconductors with applications to covalent materials," *Reviews of Modern Physics*, vol. 55, no. 3, pp. 645–705, 1983.

[6] C. Jungemann and B. Meinerzhagen, *Hierarchical Device Simulation: The Monte-Carlo Perspective*, Vienna: Springer, 2003.

[7] E. Cartier *et al.*, "Impact ionization in silicon," *Applied Physics Letters*, vol. 62, no. 25, pp. 3339–3341, 1993.

[8] T. Kunikiyo *et al.*, "A model of impact ionization due to the primary hole in silicon for a full band Monte Carlo simulation," *Journal of Applied Physics*, vol. 79, no. 10, pp. 7718–7725, 1996.

[9] S.-M. Hong and C. Jungemann, "A fully coupled scheme for a Boltzmann-Poisson equation solver based on a spherical harmonics expansion," *Journal of Computational Electronics*, vol. 8, no. 3-4, pp. 225–241, 2009.

## References

