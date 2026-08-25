# CHAPTER 30 Ferromagnetism and Spin Transport

*This chapter introduces the physics of spin transfer torque (STT) devices and describes the models used to simulate their behavior in Sentaurus Device.*

## Brief Introduction to Spintronics

Conventional semiconductor devices are based on charge transport. Electrons are treated as charged particles whose motion gives rise to current flow. In addition to their charge, electrons carry an intrinsic angular momentum called the electron *spin*. A charged particle with angular momentum acts as a magnetic dipole. In the absence of spatial ordering of the individual magnetic moments, their magnetic fields cancel out, and the effect of spin on electronic transport is small.

In ferromagnetic materials, however, the net magnetic moments of the inner electrons (typically, d- or f-orbitals) at neighboring lattice sites are aligned in parallel by the *exchange interaction*: Extended magnetic *domains* form, and the resulting magnetic field gives rise to a large difference in the energy of the state of conduction electrons depending on the relative orientation of magnetization and the spin direction.

The interaction between the spin of conduction electrons and the magnetization of ferromagnetic regions incorporated into the device structure gives rise to a whole class of *spintronics* devices. For example, the tunneling current between two ferromagnetic regions separated by a thin insulator becomes a function of the angle between the magnetization directions on either side of the barrier (the tunneling magnetoresistance effect). Conversely, the flow of spin-polarized electrons is accompanied by the transport of angular momentum (the spin current), and the absorption of spin current in a ferromagnetic region might change the magnetization direction (the spin transfer torque effect) <sup>[1]</sup>.

The following sections describe models in Sentaurus Device for the modeling of spintronics devices, in particular, for spin-selective tunneling through magnetic tunnel junctions (MTJs) and for the magnetization dynamics in ferromagnetic regions.

A simulation example for magnetization switching in an MTJ is available from the Applications Library <sup>[2]</sup>.

30: Ferromagnetism and Spin Transport
Transport Through Magnetic Tunnel Junctions

# Transport Through Magnetic Tunnel Junctions

The magnetic direct tunneling model describes the charge and spin currents flowing through a thin barrier layer sandwiched between two ferromagnetic regions. In contrast to a nonmagnetic tunnel junction, the current across an MTJ depends on both the applied voltage across the junction and the magnetization direction on either side of the barrier. This effect is called *tunneling magnetoresistance*.

## Magnetic Direct Tunneling Model

The magnetic direct tunneling model assumes the barrier layer to consist of a single material and treats the tunneling barrier as trapezoidal. Figure 53 shows a schematic band diagram of such an MTJ.

Schematic band diagram of an MTJ showing energy levels, effective masses (m*fm, m*ox), barrier height (Ub), Fermi level (EF), exchange splitting (Δ), and applied voltage (qV) across Ferromagnetic Layer 1, Oxide Barrier, and Ferromagnetic Layer 2.

Figure 53 Schematic band diagram of an MTJ

The current and spin transmission amplitudes for the MTJ are obtained by solving the Schrödinger equation with open boundary conditions. This can be done by applying the formalism of the non-equilibrium Green’s function (NEGF) [[3]]([3])[[4]]([4]). However, for the situation shown in Figure 53, finding the numeric solution to the open boundary can be accelerated by an analytic ansatz: In the ferromagnetic regions (zero field), the spinor components of the wavefunction can be expressed as linear combinations of forward- and backward-propagating plane waves. In the barrier region (constant field), Airy functions (of the first and second kind) are used instead.

At the interfaces, continuity of probability density and conservation of probability density flux are enforced. The resulting model resembles the regular DirectTunneling model used in Sentaurus Device to study the gate leakage currents of transistors (see Direct Tunneling on

**30: Ferromagnetism and Spin Transport**
Transport Through Magnetic Tunnel Junctions

page 770). However, instead of scalar wavefunctions, spinors are used to handle the spin degree of freedom, and the integral over the crystal momentum component parallel to the interface is retained.

Under certain restrictions ($\Delta = 0$; equal masses in metal and barrier regions, moderate bias), the results of the magnetic direct tunneling model reduce to those of the regular `DirectTunneling` model (see Direct Tunneling on page 770). The Airy function formulation of magnetic tunneling has been validated by direct comparison to an in-house NEGF implementation. In the lattice-converged limit, there is exact agreement between the NEGF and the Airy function results.

# Using the Magnetic Direct Tunneling Model

The magnetic direct tunneling model is activated by specifying:

`Tunneling(DirectTunneling(MTJ))`

in the `Physics` section for the interface between the ferromagnetic and barrier materials in the command file:

```
Physics (MaterialInterface="CoFeB/MgO") {
  Tunneling(DirectTunneling(MTJ))
}
```

# Physics Parameters for Magnetic Direct Tunneling

The parameters for the magnetic direct tunneling model are defined in the `DirectTunneling` section of the parameter file pertaining to the required material (or region) interface. For example:

```
MaterialInterface="CoFeB/MgO" {
  DirectTunneling {
    m_M = 0.73
    m_dos = 0.73, 0            # hole m_dos must be zero
    m_ins = 0.16, 999          # hole value is ignored
    E_F_M = 2.25
    E_barrier = 3.285, 999     # hole value is ignored
    D_spin = 2.15
  }
}
```

The parameters for the magnetic direct tunneling model are described in Table 153 on page 874. Relative to the nonmagnetic direct tunneling, there is one additional parameter: the spin-energy splitting $\Delta$. The ferromagnetic materials are assumed to be metals; therefore, the

Transport Through Magnetic Tunnel Junctions

semiconductor effective mass parameter `m_S` is not used, and only electron tunneling is considered. Hole parameter values are ignored, but dummy values are required for correct parsing of the parameter file.

**NOTE** The parameters on either side of the barrier must be the same.

The image-force effective barrier model has not been tested in the context of the magnetic direct tunneling model. It is switched off by default.

Table 153 Coefficients for direct tunneling (values for MgO on CoFeB from [[4]]([4])[[5]]([5]))

| Symbol | Parameter name | Electrons | Holes | Unit | Description |
| --- | --- | --- | --- | --- | --- |
| EF | `E_F_M` | 2.25 | -/- | eV | Fermi energy in ferromagnet (relative to conduction band). |
| Δ | `D_spin` | 2.15 | -/- | eV | Energy splitting between spin-up and spin-down electrons in ferromagnet. |
| UB | `E_barrier` | 3.185 | <ignored> | eV | Energy barrier (difference of conduction band edge in ferromagnet and barrier). |
| mFM | `m_M` | 0.73 | -/- | m0 | Effective mass in ferromagnet. |
| mox | `m_ins` | 0.16 | <ignored> | m0 | Effective mass in barrier. |
| mdos | `m_dos` | 0.73 | 0 | m0 | Density-of-states mass parallel to the interface; the hole value must be zero. |

# Math Parameters for Magnetic Direct Tunneling

The evaluation of the MTJ tunneling integrals as well as the value caching and interpolation strategy for reusing previous results can be controlled by an `MTJ` statement in the `Math` section of the command file. For example:

```
Math {
  MTJ(interpolate(kT(order=1 Grid=1e-3)))
}
```

Table 154 on page 875 summarizes the available parameters. Parameter names are subdivided by a slash (/) to reflect the hierarchical structure of the `MTJ` statement. For example, the `order` parameter in the preceding example is listed as `interpolate/kT/order`.

30: Ferromagnetism and Spin Transport

Magnetization Dynamics

Table 154 Math parameters for magnetic direct tunneling model

| Parameter name | Default | Unit | Description |
| --- | --- | --- | --- |
| interpolate/Voltage/Grid | 1e-3 | V | Grid spacing for interpolation or snapping of the voltage across the MTJ. |
| interpolate/Voltage/order | 2 | – | Interpolation order for the applied voltage: 0: Simple value snapping 1: Piecewise linear interpolation 2: Piecewise parabolic interpolation |
| interpolate/kT/Grid | 1e-8 | eV | Grid spacing for interpolation or snapping of the temperature (multiplied by $k_B$) at both ends of a tunneling edge. |
| interpolate/kT/order | 0 | – | Interpolation order for the junction temperature: 0: Simple value snapping 1: Bilinear interpolation |
| dE | 0.01 | eV | Interval size for (total) energy integration. |
| dEp | 0.01 | eV | Interval size for energy integration (contribution from surface parallel k-vector). |
| digits | 10 | – | Number of significant digits in the tunneling integral. |

# Magnetization Dynamics

This section discusses the modeling of the magnetization dynamics inside a free ferromagnetic layer in the presence of STT. The Landau–Lifshitz–Gilbert (LLG) equation is introduced with a discussion of the expression used for the effective magnetic field in the macrospin approximation. It is based on the presentation of magnetization dynamics and spin-current interaction in [[6]]([6])[[7]]([7]).

## Spin Dynamics of a Free Electron in a Magnetic Field

The spin angular momentum $\vec{S}$ and the magnetic moment $\vec{\mu}$ of a free electron are related by the gyromagnetic ratio:

$$ \gamma = \frac{|\vec{\mu}|}{|\vec{S}|} = -2.0023 \cdot \underbrace{\frac{e}{m_e} \cdot \frac{\hbar}{2}}_{\mu_B} < 0 \tag{951} $$

The energy $\hat{H}$ of a magnetic moment $\vec{\mu}$ in a local field $\vec{B} = \mu_0 \vec{H}$ is given by $\hat{H} = -\vec{\mu} \cdot \vec{B}$.

Magnetization Dynamics

This Hamiltonian gives rise to the dynamic equation:

$$ \frac{d\vec{S}}{dt} = \frac{i}{\hbar}[\hat{H}, \vec{S}] = -\frac{i}{\hbar}\gamma\mu_0[\vec{S} \cdot \vec{H}, \vec{S}] = \gamma\mu_0\vec{S} \times \vec{H} \tag{952} $$

which describes the precession of the electron spin around the direction of the local magnetic field. This can be expressed equivalently in terms of the magnetic moment instead of the spin angular momentum as:

$$ \frac{d\vec{\mu}}{dt} = -\gamma_0\vec{\mu} \times \vec{H}, \text{where } \gamma_0 = |\gamma|\mu_0 \tag{953} $$

## Magnetization Dynamics in a Ferromagnetic Layer

The magnetization vector $\vec{M}$ can be interpreted as a volume density $N/V$ of magnetic dipoles $\vec{\mu}$. In the absence of damping terms, the magnetization vector will precess around an effective magnetic field $\vec{H}_{\text{eff}}$ according to:

$$ \frac{d\vec{M}}{dt} = -\gamma_0\vec{M} \times \vec{H}_{\text{eff}} \tag{954} $$

where the effective field is obtained by taking the derivative of the magnetic energy density $U$ with respect to the local magnetization:

$$ \vec{H}_{\text{eff}} = -\frac{1}{\mu_0}\nabla_{\vec{M}}U \tag{955} $$

The LLG equation accounts for the observation that, over time, the magnetization aligns itself with the effective magnetic field, by adding a phenomenological *viscous* damping term [8]:

$$ \frac{d\vec{M}}{dt} = -\gamma_0\vec{M} \times \vec{H}_{\text{eff}} + \underbrace{\frac{\alpha}{M_s}\vec{M} \times \frac{d}{dt}\vec{M}}_{\text{Gilbert damping}} \tag{956} $$

where $M_s = |\vec{M}|$ is the saturation magnetization (assumed to be a material constant), and $\alpha$ is a phenomenological damping parameter.

In the presence of spin-polarized currents, the rate at which angular momentum is absorbed by the ferromagnetic layer also needs to be taken into account.

The spin current $\vec{Q}$ is defined as the rate at which angular momentum is injected into the ferromagnetic layer (the magnetic direct tunneling model provides both the charge current $I$ and the spin current $\vec{Q}$).

30: Ferromagnetism and Spin Transport
Magnetization Dynamics

It is assumed that the spin direction of the injected conduction electrons is aligned rapidly to the magnetization of the ferromagnetic layer. During this process, the normal component:

$$ \vec{\Gamma}_s = \vec{Q} - \frac{1}{M_s^2} \vec{M} (\vec{M} \cdot \vec{Q}) = \frac{1}{M_s^2} \vec{M} \times (\vec{Q} \times \vec{M}) \tag{957} $$

of the injected angular momentum is transferred from the conduction electrons to the core electrons of the ferromagnet and exerts an additional torque on the magnetization. This is the eponymous spin transfer torque of STT-RAM:

$$ \frac{d\vec{M}}{dt} = -\gamma_0 \vec{M} \times \vec{H}_{\text{eff}} + \frac{\alpha}{M_s} \vec{M} \times \frac{d\vec{M}}{dt} + \underbrace{\frac{\gamma_0 \vec{\Gamma}_s}{\mu_0 V}}_{\text{STT}} \tag{958} $$

In terms of the magnetization direction $\vec{m} = \vec{M} / M_s$ and after the elimination of the time derivative on the RHS of Eq. 958, the LLG equation with STT takes the form:

$$ (1 + \alpha^2) \frac{d\vec{m}}{dt} = -\gamma_0 \left( \vec{m} \times \left( \vec{H}_{\text{eff}} + \frac{\alpha \vec{\Gamma}_s}{\mu_0 M_s V} \right) + \alpha \vec{m} \times (\vec{m} \times \vec{H}_{\text{eff}}) + \frac{\vec{\Gamma}_s}{\mu_0 M_s V} \right) \tag{959} $$

# Contributions of the Magnetic Energy Density

As shown in Eq. 955, p. 876, the effective magnetic field that drives the magnetization dynamics is related to the energy density $U$. In general, the magnetization can be a position and a time-dependent vector field $\vec{M}(\vec{x}, t)$. Then, the energy density $U$ can be written as:

$$ U = U_X + U_{\text{demag}} + U_{\text{aniso}} + U_{\text{ext}} \tag{960} $$

with contributions due to the following effects:

*   Exchange interaction: $U_X = A \sum_{i = x, y, z} \left( \frac{\partial m_i}{\partial x_i} \right)^2$

    This term favors parallel alignment of nearby spins in a ferromagnet ($A < 0$). If this term dominates, a single magnetic domain can span the entire sample.

*   Stray/demagnetizing field: $U_{\text{demag}} = -\frac{\mu_0}{2} \vec{M} \cdot \vec{H}_{\text{demag}}$

    The demagnetizing field is the magnetic field caused by the sum of all magnetic moments in the sample. In sufficiently large samples, the energy content of the demagnetizing field can be reduced by the formation of multiple magnetic domains.

Magnetization Dynamics

In smaller samples, this term favors aligning the magnetization direction along the longest extension of the sample (like in a *compass needle*).

*   Magnetocrystalline anisotropy: $U_{\text{aniso}}$

In crystalline materials, the magnetic energy might depend on the direction of the magnetization relative to the crystal axes.

*   Zeeman energy: $U_{\text{ext}} = -\vec{M} \cdot \vec{B}_{\text{ext}}$

Energy of the magnetic moments in an external magnetic field.

---

# Energy Density and Effective Field in Macrospin Approximation

In the macrospin approximation, each magnetic region is considered to consist of a single, perfectly aligned, magnetic domain. This removes the position dependency from the magnetization vector field $\vec{M}(\vec{x}, t)$ of the previous section and reduces it to a single time-dependent magnetization vector $\vec{M}(t)$.

The macrospin approximation models the dominance of the exchange term over the remaining terms in the energy density (a single perfect domain). Since there is no more position dependency in the magnetization direction inside the sample, $U_X$ vanishes.

In addition, the energy density $U$ and, therefore, the effective magnetic field $\vec{E}_{\text{eff}}$ are treated as local functions of $\vec{M}$. This implies the assumption of a position-independent demagnetizing field inside the ferromagnetic layer. It can be shown that, in an infinite thin film as well as in an ellipsoidal [9] ferromagnetic sample, the demagnetizing field is exactly constant and parallel to the magnetization direction. For a cylindrical thin-film geometry, this is still approximately true.

At the level of the macrospin approximation, the effects of magnetocrystalline anisotropy and the demagnetizing field become indistinguishable and are grouped together into a single *effective anisotropy* term.

In Sentaurus Device, the energy density associated with this effective anisotropy is divided into the *uniaxial anisotropy*:

$$U_K = K(1 - m_z^2) \tag{961}$$

where:

$$K = \frac{1}{2} \mu_0 M_s H_k \tag{962}$$

30: Ferromagnetism and Spin Transport
Magnetization Dynamics

and $H_k$ is the Stoner–Wohlfarth switching field, and the *easy-plane anisotropy*:

$$ U_P = K_P m_x^2 \tag{963} $$

with:

$$ K_P = \frac{1}{2} \mu_0 M_s M_{\text{eff}} \tag{964} $$

where $M_{\text{eff}}$ is used as a parameter to account for deviations from the ideal thin-film geometry ($M_s = M_{\text{eff}}$).

# Using Magnetization Dynamics in Device Simulations

Magnetization dynamics is included in the simulation if the equation name `LLG` is specified in the `Solve` section of the command file. Usually, transient simulations are required for STT devices.

To solve magnetizations, the current flow in metals, and the electrostatic potential simultaneously, you must solve the LLG equation, the contact equation, and the Poisson equation as a system of coupled equations. Therefore, a typical `Solve` statement for an STT device simulation would be:

```
Transient (InitialTime=0 FinalTime=12e-9 maxstep=1.0e-11) {
   Coupled { Poisson Contact LLG }
}
```

The time-step size must be limited to ensure that the high-frequency oscillations typical of magnetization dynamics are captured.

## Domain Selection and Initial Conditions

The definition of fixed and pinned regions, and of initial conditions for the magnetization direction is handled by the `Magnetism` statement in the region-specific `Physics` sections:

```
Physics(Region="AnodeWell") {
   Magnetism(PinnedMagnetization Init(phi=0.0 theta=0.0))
}
Physics(Region="CathodeWell") {
   Magnetism(Init(phi=0.0 theta=3.14))
}
```

Here, the magnetization in the region `AnodeWell` is pinned at $\vartheta = \varphi = 0$ ($m_z = 1$); whereas, the magnetization in the region `CathodeWell` is free with initial conditions of $\varphi = 0$ and $\vartheta = 3.14$ (close to $m_z = -1$).

Magnetization Dynamics

An external magnetic field $\vec{H}_{ext}$ (in A/m) can be specified in the `Magnetism` statement as `H_ext= (<Hx>, <Hy>, <Hz>)`.

## Plotting Time-Dependent Magnetization

In the macrospin approximation, the magnetization is constant across each region. Then, the full time evolution of the magnetization can be captured by plotting the average direction of the magnetization vector in the free layer. In the simulation example [2], the free layer is called `CathodeWell`, and plotting of the magnetization direction is triggered by the following `CurrentPlot` section:

```
CurrentPlot { MagnetizationDir/Vector3D(average(Region="CathodeWell")) }
```

In addition to the magnetization direction in Cartesian coordinates, you can plot the magnetization of the zenith angle `Magnetization_theta` and the azimuth `Magnetization_phi` of the magnetization direction ($\vartheta = \varphi = 0$ corresponds to the positive $z$-direction).

# Parameters for Magnetization Dynamics

The parameters for magnetization dynamics (LLG equation) are defined in the `Magnetism` section of the corresponding material or region in the parameter file.

Table 155 Parameters for LLG equation (typical values shown)

| Symbol | Parameter name | Value | Unit | Description |
| --- | --- | --- | --- | --- |
| $M_s$ | `SaturationMagnetization` | 8.0e5 | A/m | Saturation magnetization of the ferromagnetic material. |
| $\alpha$ | `alpha` | 0.01 | 1 | Gilbert damping coefficient. |
| $H_K$ | `Hk` | 7957.75 | A/m | Stoner–Wohlfarth switching field (depends on layer geometry). |
| $M_{eff}$ | `Meff` | 5e5 | A/m | Effective magnetization for parameterizing the easy-plane anisotropy (geometry dependent). |
| $A$ | `A` | 1e-11 | J/m | Exchange stiffness of the ferromagnetic material (only used if macrospin is disabled; see Magnetization Dynamics Beyond Macrospin: Position-Dependent Exchange and Spin Waves on page 882). |

30: Ferromagnetism and Spin Transport

Thermal Fluctuations

# Time-Step Control for Magnetization Dynamics

To improve time-step control during the transient solution of the LLG equation, you can restrict the maximum change of the magnetization direction during the simulation that might occur during a single time step. If this limit is exceeded, the update is rejected, and the time step $\Delta t$ is reduced until the limit is met.

For example, a maximum local change of the Cartesian components of the magnetization of 0.1 per time step is requested in the `Math` section of the command file like this:

```
Math {
  Magnetism(dxyz=0.1))
}
```

The default value for `dxyz` is 0.15.

# Thermal Fluctuations

The magnetization dynamics can be influenced by thermal fluctuations. This effect can be included in the analysis by replacing the deterministic effective field $\vec{H}_{\text{eff}}$ with $\vec{H}_{\text{eff}} + \vec{H}_{\text{T}}$, where the *thermal fluctuation field* $\vec{H}_{\text{T}}$ is a stochastic field with the autocorrelation function [[10]]([10]):

$$ \langle H_{\text{T}}^i(t) H_{\text{T}}^j(t') \rangle = \frac{2kT\alpha}{\gamma_0 \mu_0 M_s V} \delta_{i,j} \delta(t - t') \eqno(965) $$

## Using Thermal Fluctuations

Modeling of thermal fluctuations is activated by adding the `ThermalFluctuations` keyword to the `Magnetism` statement of the `Physics` section:

```
Physics {
  Magnetism(ThermalFluctuations)
}
```

The magnitude of the thermal fluctuation field can be modified by multiplication with the optional parameter `H_th_scaling_factor` (default: 1). The syntax for suppressing $\vec{H}_{\text{T}}$ by a factor of 2 (which corresponds to dividing the temperature by 4) is:

```
Physics {
  Magnetism(ThermalFluctuations H_th_scaling_factor=0.5)
}
```

30: Ferromagnetism and Spin Transport
Parallel and Perpendicular Spin Transfer Torque

# Parallel and Perpendicular Spin Transfer Torque

In an MTJ, it is customary to decompose the STT $\vec{\Gamma}_s$ (Eq. 957, p. 877) into *perpendicular* and *parallel* (or *in-plane*) components, relative to the plane spanned by the magnetization directions on both sides of the tunneling barrier.

If $\vec{n} = \vec{m}_1 \times \vec{m}_2$ is the unit normal vector of this plane, then the perpendicular torque is defined as:

$$ \vec{\Gamma}_{\perp} = (\vec{n} \cdot \vec{\Gamma}_s) \vec{n} \tag{966} $$

The in-plane torque is defined as:

$$ \vec{\Gamma}_{||} = -\vec{n} \times (\vec{n} \times \vec{\Gamma}_s) = \vec{\Gamma}_s - \vec{\Gamma}_{\perp} \tag{967} $$

Sometimes, it might be instructive to be able to modify the relative strength of the in-plane and the perpendicular torque components. For this purpose, user-accessible scaling factors $\epsilon_{||}$ and $\epsilon_{\perp}$ are provided. If they are modified from their default values of 1, the STT $\vec{\Gamma}_s$ in the LLG equation (Eq. 959, p. 877) is replaced with an effective torque:

$$ \vec{\Gamma}_{s, \text{eff}} = \epsilon_{||} \vec{\Gamma}_{||} + \epsilon_{\perp} \vec{\Gamma}_{\perp} \tag{968} $$

In the command file, these scaling factors can be accessed from the `Physics` section:

```
Physics {
  Magnetism(parallel_torque_scaling_factor=<double>)      # ε||
  Magnetism(perpendicular_torque_scaling_factor=<double>) # ε⊥
}
```

# Magnetization Dynamics Beyond Macrospin: Position-Dependent Exchange and Spin Waves

The macrospin approximation is based on the assumption that the effect of the exchange interaction is much stronger than all other magnetic effects. Therefore, the most energetically favorable magnetization configuration is a single perfectly aligned domain that spans the entire ferromagnet.

In many structures, however, there is competition between the exchange interaction, which favors single-domain behavior, and the demagnetizing field, which tries to break down domains to reduce the energy content of the stray field. The nonlocality of the demagnetizing

 30: Ferromagnetism and Spin Transport

Magnetization Dynamics Beyond Macrospin: Position-Dependent Exchange and Spin Waves

field has not yet been implemented in Sentaurus Device. However, even without it, restoring the vector-field character to the magnetization direction $\vec{m}(\vec{x}, t)$ and adding the exchange field:

$$ \vec{H}_X = \frac{2A}{\mu_0 M_s} \nabla^2 \vec{m} \tag{969} $$

to the effective field $\vec{H}_{eff}$ of the LLG equation (Eq. 959, p. 877) leads to interesting phenomena such as spin waves. This allows, for example, the modeling of the nonlocal switching behavior of devices such as the spin-torque majority gate suggested in [11].

Snapshot of position-dependent magnetization direction in a spin-torque majority gate

Figure 54 Snapshot of position-dependent magnetization direction in a spin-torque majority gate; the pinned layer is split into four pieces, and the MTJs with different applied voltages compete for switching of the cross-shaped free layer

## Using Position-Dependent Exchange

The exchange term becomes active as soon as the node-merging mechanism of the macrospin approximation is deactivated:

```
Physics (Region="CathodeWell") {
  Magnetism(-MacroSpin)          # deactivate macrospin approximation
}
```

30: Ferromagnetism and Spin Transport
User-Defined Contributions to Effective Magnetic Field of LLG Equation

# User-Defined Contributions to Effective Magnetic Field of LLG Equation

You can define additional contributions to the $\vec{H}_{\text{eff}}$ field of the LLG equation (Eq. 959, p. 877) by using the physical model interface (PMI). See Chapter 39 on page 1165 for general information about the PMI and Ferromagnetism and Spin Transport on page 1381 for details about spintronics-specific PMI models.

# References

[1] D. C. Ralph and M. D. Stiles, “Spin transfer torques,” *Journal of Magnetism and Magnetic Materials*, vol. 320, no. 7, pp. 1190–1216, 2008.

[2] *Simulation of Magnetization Switching in a CoFeB/MgO/CoFeB Magnetic Tunnel Junction*, available from TCAD Sentaurus Version S-2021.06 installation, go to `Applications_Library/Memory/STT_MTJ`.

[3] D. Datta *et al.*, “Quantitative Model for TMR and Spin-transfer Torque in MTJ devices,” in *IEDM Technical Digest*, San Francisco, CA, USA, pp. 548–551, December 2010.

[4] Y. Hiramatsu *et al.*, “NEGF Simulation of Spin-Transfer Torque in Magnetic Tunnel Junctions,” in *International Meeting for Future of Electron Devices*, Osaka, Japan, pp. 102–103, May 2011.

[5] D. Datta *et al.*, “Voltage Asymmetry of Spin-Transfer Torques,” *IEEE Transactions on Nanotechnology*, vol. 11, no. 2, pp. 261–272, 2012.

[6] J. Z. Sun, “Spin-current interaction with a monodomain magnetic body: A model study,” *Physical Review B*, vol. 62, no. 1, pp. 570–578, 2000.

[7] J. Miltat, G. Albuquerque, and A. Thiaville, “An Introduction to Micromagnetics in the Dynamic Regime,” *Spin Dynamics in Confined Magnetic Structures I*, vol. 83, B. Hillebrands and K. Ounadjela (eds.), Springer: Berlin, pp. 1–34, 2002.

[8] T. L. Gilbert, “A Phenomenological Theory of Damping in Ferromagnetic Materials,” *IEEE Transactions on Magnetics*, vol. 40, no. 6, pp. 3443–3449, 2004.

[9] J. A. Osborn, “Demagnetizing Factors of the General Ellipsoid,” *Physical Review*, vol. 67, no. 11 and 12, pp. 351–357, 1945.

[10] J. Xiao, A. Zangwill, and M. D. Stiles, “Macrospin models of spin transfer dynamics,” *Physical Review B*, vol. 72, no. 1, p. 014446, 2005.

[11] D. E. Nikonov, G. I. Bourianoff, and T. Ghani, “Proposal of a Spin Torque Majority Gate Logic,” *IEEE Electron Device Letters*, vol. 32, no. 8, pp. 1128–1130, 2011.

