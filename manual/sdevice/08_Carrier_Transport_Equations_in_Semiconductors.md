# CHAPTER 8 Carrier Transport Equations in Semiconductors

*This chapter discusses carrier transport models for electrons and holes in inorganic semiconductors.*

# Introduction to Carrier Transport Models

Sentaurus Device supports several carrier transport models for semiconductors. They all can be written in the form of continuity equations, which describe charge conservation:

$$ \nabla \cdot \vec{J}_n = q(R_{\text{net},n} - G_{\text{net},n}) + q \frac{\partial n}{\partial t} \quad -\nabla \cdot \vec{J}_p = q(R_{\text{net},p} - G_{\text{net},p}) + q \frac{\partial p}{\partial t} \eqno(57) $$

where:

*   $R_{\text{net},n}$ and $R_{\text{net},p}$ are the electron and hole net recombination rate, respectively.

*   $G_{\text{net},n}$ and $G_{\text{net},p}$ are the electron and hole net generation rate, respectively.

*   $\vec{J}_n$ is the electron current density.

*   $\vec{J}_p$ is the hole current density.

*   $n$ and $p$ are the electron and hole density, respectively.

The transport models differ in the expressions used to compute $\vec{J}_n$ and $\vec{J}_p$. These expressions are the topic of this chapter. Additional equations to compute temperatures are usually also considered part of a transport model but are deferred to Chapter 9 on page 197. Models for $R_{\text{net},n}$ and $R_{\text{net},p}$ are discussed in Chapter 16 on page 419, Chapter 17 on page 489, and Chapter 24 on page 767. Boundary conditions for Eq. 57 are discussed in Chapter 10 on page 211.

Depending on the device under investigation and the level of modeling accuracy required, you can select different transport models:

*   **Drift-diffusion**: Isothermal simulation, suitable for low-power density devices with long active regions (see Drift-Diffusion Model on page 190).

*   **Thermodynamic**: Accounts for self-heating. Suitable for devices with low thermal exchange, particularly, high-power density devices with long active regions (see Thermodynamic Model for Current Densities on page 191).

Drift-Diffusion Model

*   **Hydrodynamic**: Accounts for energy transport of the carriers. Suitable for devices with small active regions (see Hydrodynamic Model for Current Densities on page 192).

*   **Monte Carlo**: Solves the Boltzmann equation for a full band structure.

The numeric approach for the Monte Carlo method (and the physical models usable with it) differs significantly from the other transport models. Therefore, the Monte Carlo method is described separately (see Sentaurus™ Device Monte Carlo User Guide).

For all other transport models, the solution of Eq. 57 is requested by the keywords `Electron` and `Hole` in the `Solve` section. When the equation for a density is not solved in a `Solve` statement, the quasi-Fermi potential for the respective carrier type remains fixed, unless the keyword `RecomputeQFP` is present in the `Math` section and the equation for the other density is solved.

Solutions of the densities $n$ and $p$ are stored in the datasets `eDensity` and `hDensity`, respectively. Current densities $J_n$ and $J_p$ are stored in the vector datasets `eCurrentDensity` and `hCurrentDensity`, their sum is stored in `ConductionCurrentDensity`, and the total current density (including displacement current) is stored in `TotalCurrentDensity`. For an alternative representation of the total current density, see Current Potential on page 193.

> **NOTE** Maxwell–Boltzmann statistics is the default for transport models in Sentaurus Device, and you can choose to use Fermi–Dirac statistics as described in Fermi Statistics on page 182.

# Drift-Diffusion Model

The drift-diffusion model is the default carrier transport model in Sentaurus Device. For the drift-diffusion model, the current densities for electrons and holes are given by:

$$ \vec{J}_n = \mu_n (n \nabla E_C - 1.5 n k T \nabla \ln m_n) + D_n (\nabla n - n \nabla \ln \gamma_n) $$ (58)

$$ \vec{J}_p = \mu_p (p \nabla E_V + 1.5 p k T \nabla \ln m_p) - D_p (\nabla p - p \nabla \ln \gamma_p) $$ (59)

The first term takes into account the contribution due to the spatial variations of the electrostatic potential, the electron affinity, and the band gap. The remaining terms take into account the contribution due to the gradient of concentration, and the spatial variation of the effective masses $m_n$ and $m_p$. For Fermi statistics, $\gamma_n$ and $\gamma_p$ are given by Eq. 47 and Eq. 48, p. 183. For Boltzmann statistics, $\gamma_n = \gamma_p = 1$.

8: Carrier Transport Equations in Semiconductors

Thermodynamic Model for Current Densities

By default, the diffusivities $D_n$ and $D_p$ are given through the mobilities by the Einstein relation, $D_n = kT\mu_n$ and $D_p = kT\mu_p$. However, you can compute them independently (see Non-Einstein Diffusivity on page 401).

When the Einstein relation holds, the current equations can be simplified to:

$$ \vec{J}_n = -nq\mu_n\nabla\Phi_n \tag{60} $$

$$ \vec{J}_p = -pq\mu_p\nabla\Phi_p \tag{61} $$

where $\Phi_n$ and $\Phi_p$ are the electron and hole quasi-Fermi potentials, respectively (see Quasi-Fermi Potential With Boltzmann Statistics on page 181).

You can use the drift-diffusion model with a lattice temperature equation, but it is not mandatory. It is not possible to use the drift-diffusion model for a particular carrier type and to solve the carrier temperature for the same carrier type; the hydrodynamic model is required for that (see Hydrodynamic Model for Current Densities on page 192).

# Thermodynamic Model for Current Densities

In the thermodynamic model [1], the relations Eq. 60 and Eq. 61 are generalized to include the temperature gradient as a driving term:

$$ \vec{J}_n = -nq\mu_n(\nabla\Phi_n + P_n\nabla T) \tag{62} $$

$$ \vec{J}_p = -pq\mu_p(\nabla\Phi_p + P_p\nabla T) \tag{63} $$

where $P_n$ and $P_p$ are the absolute thermoelectric powers [2] (see Thermoelectric Power on page 981), and $T$ is the lattice temperature.

The model differs from drift-diffusion when the lattice temperature equation is solved (see Thermodynamic Model for Lattice Temperature on page 201). However, it is possible to solve the lattice temperature equation even when using the drift-diffusion model.

To activate the thermodynamic model, specify the `Thermodynamic` keyword in the global `Physics` section.

8: Carrier Transport Equations in Semiconductors

Hydrodynamic Model for Current Densities

# Hydrodynamic Model for Current Densities

In the hydrodynamic model, current densities are defined as:

$$ \vec{J_n} = \mu_n (n \nabla E_C + k T_n \nabla n - n k T_n \nabla \ln \gamma_n + \lambda_n f_n^{td} k n \nabla T_n - 1.5 n k T_n \nabla \ln m_n) $$ (64)

$$ \vec{J_p} = \mu_p (p \nabla E_V - k T_p \nabla p + p k T_p \nabla \ln \gamma_p - \lambda_p f_p^{td} k p \nabla T_p + 1.5 p k T_p \nabla \ln m_p) $$ (65)

The first term takes into account the contribution due to the spatial variations of electrostatic potential, electron affinity, and the band gap. The remaining terms in Eq. 64 and Eq. 65 take into account the contribution due to the gradient of concentration, the carrier temperature gradients, and the spatial variation of the effective masses $m_n$ and $m_p$. For Fermi statistics, $\gamma_n$ and $\gamma_p$ are given by Eq. 47 and Eq. 48, p. 183, and $\lambda_n = F_{1/2}(\eta_n)/F_{-1/2}(\eta_n)$ and $\lambda_p = F_{1/2}(\eta_p)/F_{-1/2}(\eta_p)$ (with $\eta_n$ and $\eta_p$ from Eq. 49 and Eq. 50, p. 183); for Boltzmann statistics, $\gamma_n = \gamma_p = \lambda_n = \lambda_p = 1$.

The thermal diffusion constants $f_n^{td}$ and $f_p^{td}$ are available in the `ThermalDiffusion` parameter set. They default to zero, which corresponds to the Stratton model [3][4].

Eq. 64 and Eq. 65 assume that the Einstein relation $D = \mu k T$ holds ($D$ is the diffusion constant), which is true only near the equilibrium. Therefore, Sentaurus Device provides the option to replace the carrier temperatures in Eq. 64 and Eq. 65 by $g T_c + (1 - g) T$, an average of the carrier temperature ($T_n$ or $T_p$) and the lattice temperature. This can be useful in devices where the carrier diffusion is important. The coefficient $g$ for electrons and holes can be specified in the `ThermalDiffusion` parameter set. It defaults to one.

To activate the hydrodynamic model, specify the keyword `Hydrodynamic` in the global `Physics` section. If only one carrier temperature equation is to be solved, then `Hydrodynamic` must be specified with an option, either `Hydrodynamic(eTemperature)` or `Hydrodynamic(hTemperature)`.

# Numeric Parameters for Continuity Equation

Carrier concentrations must never be negative. If during a Newton iteration a concentration erroneously becomes negative, Sentaurus Device applies damping procedures to make it positive. The concentration that finally results from a Newton iteration is limited to a value that can be specified in cm<sup>-3</sup> by `DensLowLimit=<float>` in the global `Math` section (default: 10<sup>-100</sup> cm<sup>-3</sup>).

8: Carrier Transport Equations in Semiconductors

Numeric Approaches for Contact Current Computation

**NOTE** For very-low device temperatures (below 50 K), the carrier concentration might be extremely small. To support simulations using such temperatures, specify `ExtendedPrecision` (see Extended Precision on page 174) and `DensLowLimitPower=<int>` in the global `Math` section (default: –100). The lowest carrier concentration limit will be set to the minimum between `DensLowLimit=<float>` and $10^{\text{DensLowLimitPower}} \text{ cm}^{-3}$.

---

# Numeric Approaches for Contact Current Computation

By default, Sentaurus Device computes the contact current as the sum of the integral of the current density over the surface of the doping well associated with the contact and the integral of the charge generation rate over the volume of the doping well. The following alternative, mutually exclusive approaches can be selected in the global `Math` section:

* `CurrentWeighting` activates a domain-integration method that uses a solution-dependent weighting function to minimize numeric errors (see [[5]](reference_5) for details).

* `DirectCurrent` activates computation of the current as the surface integral of the current density over the contact area.

> **NOTE** The current that flows into nodes in mixed-mode simulations is always computed with the `DirectCurrent` approach, regardless of the specification in the `Math` section.

---

# Current Potential

The total current density:

$$ \vec{J} = \vec{J}_n + \vec{J}_p + \vec{J}_D \text{ (66)} $$

satisfies the conservation law $\nabla \cdot \vec{J} = 0$.

Consequently, $\vec{J}$ can be written as the curl of a vector potential $\vec{W}$:

$$ \vec{J} = \nabla \times \vec{W} \text{ (67)} $$

In a 2D simulation, $\vec{W}$ only has a nonzero component along the z-axis, which is written simply as $W_z = W$.

Current Potential

The total current density is then given by:

$$ \vec{J} = \begin{bmatrix} \frac{\partial W}{\partial y} \\ -\frac{\partial W}{\partial x} \end{bmatrix} $$ (68)

The function *W* has the following important properties:

*   The contour lines of *W* are the current lines of $\vec{J}$.

*   The difference between the values of *W* at any two points equals the total current flowing across any line linking these points.

Sentaurus Device computes the 2D current potential according to the approach proposed by Palm and Van de Wiele [6].

To visualize the results, add the keyword `CurrentPotential` to the `Plot` section:

```
Plot { CurrentPotential }
```

Figure 18 displays plots of the total current density and current potential for a simple square device.

Total current density plot

Current potential plot

Figure 18 (Left) Total current density [Acm<sup>–2</sup>] and (right) current potential [Acm<sup>–1</sup>]

8: Carrier Transport Equations in Semiconductors

References

# References

[1] G. Wachutka, “An Extended Thermodynamic Model for the Simultaneous Simulation of the Thermal and Electrical Behaviour of Semiconductor Devices,” in *Proceedings of the Sixth International Conference on the Numerical Analysis of Semiconductor Devices and Integrated Circuits (NASECODE VI)*, Dublin, Ireland, pp. 409–414, July 1989.

[2] H. B. Callen, *Thermodynamics and an Introduction to Thermostatistics*, New York: John Wiley & Sons, 2nd ed., 1985.

[3] R. Stratton, “Diffusion of Hot and Cold Electrons in Semiconductor Barriers,” *Physical Review*, vol. 126, no. 6, pp. 2002–2014, 1962.

[4] Y. Apanovich et al., “Numerical Simulation of Submicrometer Devices Including Coupled Nonlocal Transport and Nonisothermal Effects,” *IEEE Transactions on Electron Devices*, vol. 42, no. 5, pp. 890–898, 1995.

[5] P. D. Yoder et al., “Optimized Terminal Current Calculation for Monte Carlo Device Simulation,” *IEEE Transactions on Computer-Aided Design of Integrated Circuits and Systems*, vol. 16, no. 10, pp. 1082–1087, 1997.

[6] E. Palm and F. Van de Wiele, “Current Lines and Accurate Contact Current Evaluation in 2-D Numerical Simulation of Semiconductor Devices,” *IEEE Transactions on Electron Devices*, vol. ED-32, no. 10, pp. 2052–2059, 1985.

## References

