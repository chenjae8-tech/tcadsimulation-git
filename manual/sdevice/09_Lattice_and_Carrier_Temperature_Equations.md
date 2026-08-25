# CHAPTER 9 Lattice and Carrier Temperature Equations

*This chapter describes the equations for lattice and carrier temperatures.*

## Introduction to Temperature Equations

Sentaurus Device can compute up to three different temperatures: lattice temperature, electron temperature, and hole temperature. Lattice temperature describes self-heating of devices. The electron and hole temperatures are required to model nonequilibrium effects in deep-submicron devices (in particular, velocity overshoot and impact ionization).

The following options are available:

* The lattice temperature can be computed from the total dissipated heat, assuming the temperature is constant throughout the device.

* The lattice temperature can be computed nonuniformly using the default model, or the thermodynamic model, or the hydrodynamic model.

* One or both carrier temperatures can be computed using the hydrodynamic model.

Irrespective of the model used, the lattice temperature is stored in the dataset `Temperature`, and electron and hole temperatures are stored as `eTemperature` and `hTemperature`, respectively.

To solve the lattice temperature, you must specify a thermal boundary condition (see Thermal Boundary Conditions on page 235). To solve the carrier temperatures, no thermal boundary conditions are required.

By default (and as an initial guess), the lattice temperature is set to 300 K throughout the device or to the value of `Temperature` set in the `Physics` section. If the device has one or more defined thermodes, an average temperature is calculated from the temperatures at the thermodes and is set throughout the device. As an initial guess, electron and hole temperatures are set to the lattice temperature. Carrier temperatures that are not solved are assumed to equal the lattice temperature throughout the simulation.

9: Lattice and Carrier Temperature Equations
Uniform Self-Heating

# Uniform Self-Heating

A simple self-heating model is available to account for self-heating effects without solving the lattice heat flow equation. The self-heating effect can be captured with a uniform temperature, which is bias dependent or current dependent. The global temperature is computed from a global heat balance equation where the dissipated power $P_{\text{diss}}$ is equal to the sum of the boundary heat fluxes (on thermodes with finite thermal resistance):

$$P_{\text{diss}} = \sum_{i} \frac{T - T_{\text{thermode}}^{(i)}}{R_{\text{th}}^{(i)}} + \sum_{k} \frac{T - T_{\text{circ}}^{(k)}}{R_{\text{th}}^{(k)}} \tag{69}$$

where:

*   $T$ is the device global temperature.

*   $T_{\text{thermode}}^{(i)}$ and $R_{\text{th}}^{(i)}$ are the temperature and thermal resistivity of thermode $i$ not connected in a thermal circuit.

*   $T_{\text{circ}}^{(k)}$ and $R_{\text{th}}^{(k)}$ are the temperature and thermal resistivity of thermode $k$ connected in a thermal circuit.

The second sum in Eq. 69 becomes zero when the device is not connected to any thermal circuit.

For a thermode $k$ connected in a thermal circuit, an additional thermal circuit equation is solved for the temperature at the respective thermode $T_{\text{circ}}^{(k)}$. The thermal circuit equation solved is derived from the condition that the heat flux through the connected thermode is equal to the flux flowing through the thermal circuit element to which the thermode is connected.

In the case of thermode $k$ connected to a thermal resistor, the thermal circuit equation becomes:

$$(T - T_{\text{circ}}^{(k)}) / R_{\text{th}}^{(k)} = \nabla T^{\text{resistor}} / R_{\text{th}} \tag{70}$$

where:

*   The left-hand side represents the thermal flux at thermode $k$.

*   The right-hand side represents the heat flux flowing through the thermal resistor with thermal resistivity $R_{\text{th}}$.

*   $\nabla T^{\text{resistor}} = T_{\text{resistor}} - T_{\text{circ}}^{(k)}$ is the temperature drop across the thermal resistor.

For a thermal capacitor, the thermal equation becomes $(T - T_{\text{circ}}^{(k)}) / R_{\text{th}}^{(k)} = C_{\text{th}} \frac{d}{dt} \nabla T^{\text{capacitor}}$ where $\nabla T^{\text{capacitor}} = T_{\text{capacitor}} - T_{\text{circ}}^{(k)}$ is the voltage drop across the thermal capacitor in a transient simulation.

9: Lattice and Carrier Temperature Equations

Uniform Self-Heating

If a thermode does not specify a thermal resistance or a thermal conductance, then by default, a Dirichlet boundary condition of a fixed thermode temperature is assumed. In this case, the thermode is not accounted for in the sum on the right-hand side of Eq. 69 because the respective heat flux is zero. When none of the thermodes specifies any thermal resistance or conductance, Eq. 69 cannot be solved.

The dissipated power $P_{\text{diss}}$ can be calculated as either the sum of all terminal currents multiplied by their respective terminal voltages ($\sum IV$), the sum of $IV$s from the user-specified node, or the total Joule heat $\int\limits_{V} (\vec{J} \cdot \vec{F}) dv$.

The global temperature $T_{i}$ for the point $t_{i}$ (in transient or quasistationary simulations) is computed based on the estimation of $T_{i}$ at the previous point $t_{i-1}$ and the solution temperature $T_{i-1}$ at the same point $t_{i-1}$.

> **NOTE** For uniform self-heating, the temperature is obtained by postprocessing, rather than computed self-consistently with all other solution variables. Therefore, the simulation results might depend on the simulation time step used in quasistationary or transient simulations. In addition, uniform self-heating must not be used for AC, noise, or harmonic balance simulations.

# Using Uniform Self-Heating

The uniform self-heating equation is activated in the global `Physics` section using the `PostTemperature` keyword:

```
Physics {
  PostTemperature
  ...
}
```

The heat fluxes at thermodes are defined in the `Thermode` sections by specifying `Temperature` and `SurfaceResistance` or `SurfaceConductance`:

```
Thermode {
  {Name= "top" Temperature=300 SurfaceConductance=0.1}
  ...
  {Name= "bottom" Temperature=300 SurfaceResistance=0.01}
}
```

The way $P_{\text{diss}}$ is computed can be chosen by options to `PostTemperature` in the command file:

* As $\sum IV$ over all electrodes:

```
Physics {
  PostTemperature(IV_diss)
```

Default Model for Lattice Temperature

```
    ...
}
```

*   As $\sum IV$ at user-selected electrodes:

```
Physics {
  PostTemperature(IV_diss("contact1" "contact2"))
  ...
}
```

*   As the integral of Joule heat over the device volume:

```
Physics {
  PostTemperature
  ...
}
```

Uniform self-heating can be used during a quasistationary or transient simulation. As the feature replaces the lattice heat flow equation (Eq. 71, Eq. 72, and Eq. 78, p. 204), it cannot be used with the lattice temperature equation activated in the `Coupled` section.

# Default Model for Lattice Temperature

Sentaurus Device can compute a spatially dependent lattice temperature even when neither the thermodynamic nor the hydrodynamic model is activated. The equation for the temperature is:

$$ \frac{\partial W_L}{\partial t} + \nabla \cdot \vec{S}_L = \left. \frac{dW_L}{dt} \right|_{coll} + \frac{1}{q} \vec{J}_n \cdot \nabla E_C + \left. \frac{dW_n}{dt} \right|_{coll} + \frac{1}{q} \vec{J}_p \cdot \nabla E_V + \left. \frac{dW_p}{dt} \right|_{coll} \text{ (71)} $$

(See Hydrodynamic Model for Current Densities on page 192 for an explanation of the symbols.) That is, the model is similar to the hydrodynamic model, but all temperatures merge into the lattice temperature, and all heating terms are accounted for in the lattice temperature equation.

To use this model, specify the keyword `Temperature` in the `Solve` section. You do not have to specify a model in the `Physics` section.

To account for Peltier heat at a contact, or a metal–semiconductor interface, or a conductive insulator–semiconductor interface, switch on the Peltier heating model explicitly. See Heating at Contacts, Metal–Semiconductor and Conductive Insulator–Semiconductor Interfaces on page 984.

9: Lattice and Carrier Temperature Equations
Thermodynamic Model for Lattice Temperature

# Thermodynamic Model for Lattice Temperature

With the thermodynamic model, the lattice temperature $T$ is computed from:

$$ \frac{\partial}{\partial t}(c_L T) - \nabla \cdot (\kappa \nabla T) = -\nabla \cdot [(P_n T + \Phi_n)\vec{J}_n + (P_p T + \Phi_p)\vec{J}_p] $$
$$ -\frac{1}{q}(E_C + \frac{3}{2}kT)(\nabla \cdot \vec{J}_n - qR_{net,n}) \eqno(72) $$
$$ -\frac{1}{q}(-E_V + \frac{3}{2}kT)(-\nabla \cdot \vec{J}_p - qR_{net,p}) + \hbar\omega G^{opt} $$

where:

*   $\kappa$ is the thermal conductivity (see Thermal Conductivity on page 969).

*   $c_L$ is the lattice heat capacity (see Heat Capacity on page 967).

*   $E_C$ and $E_V$ are the conduction and valence band energies, respectively.

*   $G^{opt}$ is the optical generation rate from photons with frequency $\omega$ (see Chapter 21 on page 593).

*   $R_{net,n}$ and $R_{net,p}$ are the electron and hole net recombination rates, respectively.

*   Current densities $J_n$ and $J_p$ are computed as described in Thermodynamic Model for Current Densities on page 191.

In metals, Eq. 72 degenerates into:

$$ \frac{\partial}{\partial t}(c_L T) - \nabla \cdot (\kappa \nabla T) = -\nabla \cdot [(PT + \Phi_M)\vec{J}_M] \eqno(73) $$

where:

*   $P$ is the metal thermoelectric power.

*   $\Phi_M$ is the Fermi potential in the metal.

*   $\vec{J}_M$ is the metal current density as defined in Eq. 142, p. 249.

# Total Heat and Its Contributions

The RHS of Eq. 72 is the total heat $H$. In the stationary case, the second term and the third term disappear, that is, the total heat is then given by:

$$ H = -\nabla \cdot [(P_n T + \Phi_n)\vec{J}_n + (P_p T + \Phi_p)\vec{J}_p] + \hbar\omega G^{opt} \eqno(74) $$

201

Thermodynamic Model for Lattice Temperature

The electron part can be rewritten as:

$$ -\nabla \cdot [(P_n T + \Phi_n) \vec{J}_n] = \frac{1}{q n \mu_n} |\vec{J}_n|^2 - q T \nabla P_n \cdot \vec{J}_n + [(P_n T + \Phi_n) \vec{J}_n \cdot n_S]_S \delta_S - q(P_n T + \Phi_n) R_{\text{net},n} \qquad (75) $$

where:

*   $n_S$ is the surface normal at region interface $S$.

*   $\delta_S$ denotes the surface delta function at region interface $S$.

*   $[\alpha]_S$ denotes the jump of a function $\alpha$ across the region interface $S$.

The resulting four terms are often denoted as the electron part of the Joule heat, Thomson heat, Peltier heat, and recombination heat, respectively.

## Using the Thermodynamic Model

To use the thermodynamic model, you must specify the keyword `Temperature` in the `Coupled` statement of the `Solve` section. Use the keyword `Thermodynamic` in the `Physics` section to activate extra terms in the current density equations (due to the gradient of the temperature).

To account for Peltier heat at a contact, or a metal–semiconductor interface, or a conductive insulator–semiconductor interface, switch on the Peltier heating model explicitly (see Heating at Contacts, Metal–Semiconductor and Conductive Insulator–Semiconductor Interfaces on page 984).

Sentaurus Device allows the total heat generation rate to be plotted and the separate components of the total heat to be estimated and plotted. The total heat generation rate is the term on the right-hand side of Eq. 72. It is plotted using the `TotalHeat` keyword in the `Plot` section. The total heat is calculated only when Sentaurus Device solves the temperature equation.

Table 28 shows the formulas to estimate individual heating mechanisms and the appropriate keywords to use in the `Plot` section of the command file (see Device Plots on page 128). The individual heat terms that are used for plotting and that are written to the `.log` file are less accurate than those Sentaurus Device uses to solve the transport equations. They serve as illustrations only.

Table 28 Terms and keywords used in Plot section of command file

| Heat name | Keyword | Formula |
| --- | --- | --- |
| Electron Joule heat | eJouleHeat | $\frac{\|\vec{J}_n\|^2}{q n \mu_n}$ |

**9: Lattice and Carrier Temperature Equations**

Thermodynamic Model for Lattice Temperature

Table 28 Terms and keywords used in Plot section of command file (Continued)

| Heat name | Keyword | Formula |
| --- | --- | --- |
| Hole Joule heat | hJouleHeat | $$\frac{\|\vec{J_p}\|^2}{q p \mu_p}$$ |
| Joule heat in conductive insulators | JouleHeat | $$\frac{\|\vec{J_{CI}}\|^2}{\sigma}$$ |
| Recombination heat | RecombinationHeat | $$q R_{\text{total}} ((\Phi_p + T P_p) - (\Phi_n + T P_n))$$ |
| Net recombination heat | netRecombinationHeat | $$q R_{\text{net},p} (\Phi_p + T P_p) - q R_{\text{net},n} (\Phi_n + T P_n)$$ |
| Thomson plus Peltier heat [1] | ThomsonHeat | $$-\vec{J_n} \cdot T \nabla P_n - \vec{J_p} \cdot T \nabla P_p$$ |
| Peltier heat | PeltierHeat | $$-T \left( \frac{\partial P_n}{\partial n} \vec{J_n} \cdot \nabla n + \frac{\partial P_p}{\partial p} \vec{J_p} \cdot \nabla p \right)$$ |

Here $R_{\text{total}} = 0.5(R_{\text{net},p} + R_{\text{net},n})$. To plot the lattice heat flux vector $\kappa \nabla T$, specify the keyword `lHeatFlux` in the `Plot` section (see Device Plots on page 128).

Sentaurus Device reports the maximum, minimum, and average device temperatures in both the plot file and log file whenever the self-heating equation is solved:

*   Maximum temperature ($T_{\text{max}}$) in the device as a function of the bias condition

*   Minimum temperature ($T_{\text{min}}$) in the device as a function of the bias condition

*   Average temperature ($T_{\text{avg}}$) in the device as a function of the bias condition

Device temperatures are not monitored and remain the same as the default lattice temperature, that is, room temperature, if the lattice temperature solution is not requested.

You can also use the current plot feature of Sentaurus Device to extract temperature information in different materials and regions. For example:

```
CurrentPlot {
  Temperature (
    Minimum(Material="Silicon")
    Maximum(Material="Silicon")
    Average(Material="Silicon")
    Minimum(Material="Oxide")
    Maximum(Material="Oxide")
    Average(Material="Oxide")
  )
}
```

9: Lattice and Carrier Temperature Equations
Hydrodynamic Model for Temperatures

# Hydrodynamic Model for Temperatures

Deep-submicron devices cannot be described properly using the conventional drift-diffusion transport model. In particular, the drift-diffusion approach cannot reproduce velocity overshoot and often overestimates the impact ionization generation rates. In this case, the hydrodynamic (or energy balance) model provides a good compromise between physical accuracy and computation time.

Since the work of Stratton [2] and Bløtekjær [3], there have been many variations of this model. The full formulation includes convective terms [4]. Sentaurus Device implements a simpler formulation without convective terms. In addition to the Poisson equation (Eq. 37, p. 179) and continuity equations (Eq. 57, p. 189), up to three additional equations for the lattice temperature $T$ and the carrier temperatures $T_n$ and $T_p$ can be solved.

The energy balance equations read:

$$ \frac{\partial W_n}{\partial t} + \nabla \cdot \vec{S}_n = \vec{J}_n \cdot \nabla E_C / q + \left. \frac{dW_n}{dt} \right|_{\text{coll}} \tag{76} $$

$$ \frac{\partial W_p}{\partial t} + \nabla \cdot \vec{S}_p = \vec{J}_p \cdot \nabla E_V / q + \left. \frac{dW_p}{dt} \right|_{\text{coll}} \tag{77} $$

$$ \frac{\partial W_L}{\partial t} + \nabla \cdot \vec{S}_L = \left. \frac{dW_L}{dt} \right|_{\text{coll}} \tag{78} $$

where the energy fluxes are:

$$ \vec{S}_n = -\frac{5 r_n \lambda_n}{2} \left( \frac{k T_n}{q} \vec{J}_n + f_n^{hf} \hat{\kappa}_n \nabla T_n \right) \tag{79} $$

$$ \vec{S}_p = -\frac{5 r_p \lambda_p}{2} \left( \frac{-k T_p}{q} \vec{J}_p + f_p^{hf} \hat{\kappa}_p \nabla T_p \right) \tag{80} $$

$$ \vec{S}_L = -\kappa_L \nabla T_L \tag{81} $$

$$ \hat{\kappa}_n = \frac{k^2}{q} n \mu_n T_n \tag{82} $$

$$ \hat{\kappa}_p = \frac{k^2}{q} p \mu_p T_p \tag{83} $$

 9: Lattice and Carrier Temperature Equations
Hydrodynamic Model for Temperatures

and $\lambda_n$ and $\lambda_p$ are defined as for Eq. 64 and Eq. 65, p. 192. The parameters $r_n$, $r_p$, $f_n^{\text{hf}}$, and $f_p^{\text{hf}}$ are accessible in the parameter file of Sentaurus Device. Different values of these parameters can significantly influence the physical results, such as velocity distribution and possible spurious velocity peaks. By changing these parameters, Sentaurus Device can be tuned to a very wide set of hydrodynamic or energy balance models as described in the literature. The default parameter values of Sentaurus Device are:

$$r_n = r_p = 0.6 \tag{84}$$

$$f_n^{\text{hf}} = f_p^{\text{hf}} = 1 \tag{85}$$

By changing the constants $f_n^{\text{hf}}$ and $r_n$, you can change the convective contribution and the diffusive contributions independently. With the default set of transport parameters of Sentaurus Device, the prefactor of the diffusive term has the form:

$$\kappa_n = \frac{3}{2} \cdot \frac{k^2 \lambda_n}{q} n \mu_n T_n \tag{86}$$

The collision terms are expressed by this set of equations:

$$\left. \frac{\partial W_n}{\partial t} \right|_{\text{coll}} = -H_n - \xi_n \frac{W_n - W_{n0}}{\tau_{en}} \tag{87}$$

$$\left. \frac{\partial W_p}{\partial t} \right|_{\text{coll}} = -H_p - \xi_p \frac{W_p - W_{p0}}{\tau_{ep}} \tag{88}$$

$$\left. \frac{\partial W_L}{\partial t} \right|_{\text{coll}} = H_L + \xi_n \frac{W_n - W_{n0}}{\tau_{en}} + \xi_p \frac{W_p - W_{p0}}{\tau_{ep}} \tag{89}$$

Here, $H_n$, $H_p$, and $H_L$ are the energy gain/loss terms due to generation–recombination processes. The expressions used for these terms are based on approximations [5] and have the following form for the major generation–recombination phenomena:

$$H_n = 1.5 k T_n (R_{\text{net}}^{\text{SRH}} + R_{\text{net}}^{\text{rad}} + R_{n, \text{net}}^{\text{trap}}) - E_{g, \text{eff}} (R_n^{\text{A}} - G_n^{\text{ii}}) - \alpha (\hbar \omega - E_{g, \text{eff}}) G^{\text{opt}} \tag{90}$$

$$H_p = 1.5 k T_p (R_{\text{net}}^{\text{SRH}} + R_{\text{net}}^{\text{rad}} + R_{p, \text{net}}^{\text{trap}}) - E_{g, \text{eff}} (R_p^{\text{A}} - G_p^{\text{ii}}) - (1 - \alpha) (\hbar \omega - E_{g, \text{eff}}) G^{\text{opt}} \tag{91}$$

$$H_L = [R_{\text{net}}^{\text{SRH}} + 0.5 (R_{n, \text{net}}^{\text{trap}} + R_{p, \text{net}}^{\text{trap}})] (E_{g, \text{eff}} + 1.5 k T_n + 1.5 k T_p) \tag{92}$$

Hydrodynamic Model for Temperatures

where:

*   $R_{net}^{SRH}$ is the Shockley–Read–Hall (SRH) recombination rate (see Shockley–Read–Hall Recombination on page 419).

*   $R_{net}^{rad}$ is the radiative recombination rate (see Radiative Recombination Model on page 435).

*   $R_n^A$ and $R_p^A$ are Auger recombination rates related to electrons and holes (see Auger Recombination Model on page 436).

*   $\hbar\omega$ is the photon energy (see Hydrodynamic Model Parameters on page 207).

*   $\alpha$ is a dimensionless parameter that describes how the surplus energy of the photon splits between the bands (see Hydrodynamic Model Parameters on page 207).

*   $G_n^{ii}$ and $G_p^{ii}$ are impact ionization rates (see Avalanche Generation on page 441).

*   $R_{n, net}^{trap}$ and $R_{p, net}^{trap}$ are the recombination rates through trap levels (see Chapter 17 on page 489).

*   $G^{opt}$ is the optical generation rate (see Chapter 21 on page 593).

Surface recombination is taken into account in a way similar to bulk SRH recombination. Usually, the influence of $H_n$, $H_p$, and $H_L$ is small, so they are not activated by default. To take these energy sources into account, the keyword `RecGenHeat` must be specified in the `Physics` section.

The energy densities $W_n$, $W_p$, and $W_L$ are given by:

$$ W_n = nw_n = n \left( \frac{3kT_n}{2} \right) \eqno(93) $$

$$ W_p = pw_p = p \left( \frac{3kT_p}{2} \right) \eqno(94) $$

$$ W_L = c_L T \eqno(95) $$

The corresponding equilibrium energy densities are:

$$ W_{n0} = nw_{n0} = n \frac{3kT}{2} \eqno(96) $$

$$ W_{p0} = pw_{p0} = p \frac{3kT}{2} \eqno(97) $$

The parameters $\xi_n$ and $\xi_p$ in Eq. 87 to Eq. 89 improve numeric stability. They speed up relaxation for small densities and they approach 1 for large densities:

$$ \xi_n = 1 + \frac{n_{min}}{n} \left( \frac{n_0}{n_{min}} \right)^{\max[0, (T - T_n) / 100 \, \text{K}]} \eqno(98) $$

**9: Lattice and Carrier Temperature Equations**
Hydrodynamic Model for Temperatures

and likewise for $\xi_p$. Here, $n_{\text{min}}$ and $n_0$ are adjustable small density parameters.

# Hydrodynamic Model Parameters

The default set of transport coefficients (Eq. 84 and Eq. 85, p. 205) can be changed in the parameter file. The coefficients $r$ and $f^{\text{hf}}$ are specified in the `EnergyFlux` and `HeatFlux` parameter sets, respectively. Energy relaxation times $\tau_{en}$ and $\tau_{ep}$ can be modified in the `EnergyRelaxationTime` parameter set.

$\alpha$ in Eq. 90 and Eq. 91 divides the contribution of the optical generation rate into the energy gain or loss terms $H_n$ and $H_p$. `OptGenOffset` specifies $\alpha$, which can take values between 0 and 1 (default is 0.5). The angular frequency $\omega$ in Eq. 90 and Eq. 91 corresponds to the wavelength specified to compute the optical generation rate. This wavelength is defined by `OptGenWavelength` if the optical generation is loaded from a file (see Optical AC Analysis on page 716).

Both `OptGenOffset` and `OptGenWavelength` are options to `RecGenHeat` (see Table 231 on page 1547).

The parameters $n_{\text{min}}$ and $n_0$ in Eq. 98 are set with `RelTermMinDensity` and `RelTermMinZeroDensity`, respectively, in the global `Math` section. The default values for $n_{\text{min}}$ and $n_0$ are $10^3 \text{ cm}^{-3}$ and $2 \times 10^8 \text{ cm}^{-3}$, respectively.

# Using the Hydrodynamic Model

To activate the hydrodynamic model, you must specify the keyword `Hydrodynamic` in the `Physics` section. If only one carrier temperature equation is to be solved, `Hydrodynamic` must be specified with the appropriate parameter, either `Hydrodynamic(eTemperature)` or `Hydrodynamic(hTemperature)`. If the hydrodynamic model is not activated for a particular carrier type, Sentaurus Device merges the temperature for this carrier with the lattice temperature. That is, these temperatures are equal, and their heating terms (see the right-hand sides of Eq. 76, Eq. 77, and Eq. 78) are added.

In addition, you must specify the `eTemperature`, `hTemperature`, and `Temperature` keywords inside the `Coupled` statement of the `Solve` section (see Coupled Statement on page 141) to actually solve a carrier temperature equation or the lattice temperature equation. Temperatures remain fixed during `Solve` statements in which their equation is not solved.

By default, the energy conservation equations of Sentaurus Device do not include generation–recombination heat sources. To activate them, the keyword `RecGenHeat` must be specified in the `Physics` section.

Numeric Parameters for Temperature Equations

To plot the electron, hole, and lattice heat flux vectors $\vec{S}_n, \vec{S}_p, \vec{S}_L$ (see Eq. 79, Eq. 80, and Eq. 81), specify the corresponding keywords `eHeatFlux`, `hHeatFlux`, and `lHeatFlux` in the Plot section (see Device Plots on page 128).

To plot $\vec{J}_n \cdot \nabla E_C / q$ and $\vec{J}_p \cdot \nabla E_V / q$ (see Eq. 76 and Eq. 77), specify the corresponding keywords `eJEheat` and `hJEHeat`.

To plot $dW_n / dt|_{coll}$, $dW_p / dt|_{coll}$, and $dW_L / dt|_{coll}$ (see Eq. 76, Eq. 77, and Eq. 78), specify the corresponding keywords `eColHeat`, `hColHeat`, and `lColHeat`.

To plot $H_n$, $H_p$, and $H_L$ (see Eq. 90, Eq. 91, and Eq. 92), specify the corresponding keywords `eRecGenHeat`, `hRecGenHeat`, and `lRecGenHeat`.

# Numeric Parameters for Temperature Equations

This section presents the numeric parameters for temperature equations.

## Validity Ranges for Lattice and Carrier Temperatures

Lower and upper limits for the lattice temperature and the carrier temperatures exist.

The allowed temperature ranges are specified (in K) by `lT_Range=(<float> <float>)` (defaults 50 K and 5000 K) and `cT_Range=(<float> <float>)` (defaults 10 K and 80000 K). These ranges apply both to the temperatures during the Newton iterations and to the final results.

## Scaling of Lattice Heat Generation

For the lattice heat equation, you have the possibility to disable the heat term by using:

```
Physics ( Region="Bulk" ) { ... HeatPreFactor = 0. }
```

This reduces or even eliminates the strong coupling, given by the Joule heat, of the lattice heat equation with the carrier continuity equations, and leads in general to smooth temperature profiles. This simplified coupled system of carrier transport and lattice temperature might converge easier than the fully coupled system including the heat term. Instead of ramping the fully coupled system to a required bias condition, it might be easier to ramp first the simplified coupled system to the required bias condition, and ramp subsequently the `HeatPreFactor` from zero to one.

9: Lattice and Carrier Temperature Equations

References

**NOTE** Due to the strong nonlinearity of semiconductor equations, which allows multiple solutions in general, and especially for examples with strong generation–recombination rates, the `HeatPreFactor` ramping might lead to a different but still valid solution.

In the command file, this second ramp could be:

```
Quasistationary (
  Goal { Region="Bulk" ModelParameter="Physics/HeatPreFactor" Value=1 }
) { Coupled { Poisson Electron Hole Temperature } }
```

**NOTE** The `Goal` statement requires the specification of a `Region`, and a `Physics` section for the corresponding region must be specified in the command file.

# References

[1] K. Kells, *General Electrothermal Semiconductor Device Simulation*, Series in Microelectronics, vol. 37, Konstanz, Germany: Hartung-Gorre, 1994.

[2] R. Stratton, “Diffusion of Hot and Cold Electrons in Semiconductor Barriers,” *Physical Review*, vol. 126, no. 6, pp. 2002–2014, 1962.

[3] K. Bløtekjær, “Transport Equations for Electrons in Two-Valley Semiconductors,” *IEEE Transactions on Electron Devices*, vol. ED-17, no. 1, pp. 38–47, 1970.

[4] A. Benvenuti *et al.*, “Evaluation of the Influence of Convective Energy in HBTs Using a Fully Hydrodynamic Model,” in *IEDM Technical Digest*, Washington, DC, USA, pp. 499–502, December 1991.

[5] D. Chen *et al.*, “Dual Energy Transport Model with Coupled Lattice and Carrier Temperatures,” in *Simulation of Semiconductor Devices and Processes (SISDEP)*, vol. 5, Vienna, Austria, pp. 157–160, September 1993.

## References

 