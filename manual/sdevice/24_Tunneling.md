# CHAPTER 24 Tunneling

*This chapter presents the tunneling models available in Sentaurus Device.*

In current microelectronic devices, tunneling has become a very important physical effect. In some devices, tunneling leads to undesired leakage currents (for gates in small MOSFETs). For other devices such as EEPROMs, tunneling is essential for the operation of the device.

The tunneling models discussed in this chapter refer to elastic charge-transport processes at interfaces or contacts. Tunneling also plays a role in some generation–recombination models (see Chapter 16 on page 419). These models do not deal with spatial transport of charge and, therefore, are not discussed here. In addition to tunneling, hot-carrier injection can also contribute to carrier transport across barriers. To model hot-carrier injection, see Chapter 25 on page 793. Tunneling to traps is discussed in Nonlocal Tunneling for Traps on page 517.

## Overview of Tunneling Models

Sentaurus Device provides different tunneling models. The nonlocal tunneling model is the most versatile (see Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774) and includes the following features:

*   Handles arbitrary barrier shapes

*   Includes carrier heating terms

*   Allows you to describe tunneling between the valence band and conduction band

*   Offers several different approximations for the tunneling probability

Use this model to describe tunneling at Schottky contacts, tunneling in heterostructures, and gate leakage through thin stacked insulators.

The next most powerful model is the direct tunneling model (see Direct Tunneling on page 770), and it includes the following features:

*   Assumes a trapezoidal barrier (this restricts the range of application to tunneling through insulators)

*   Neglects heating of the tunneling carriers

*   Optionally, accounts for image charge effects (at the cost of reduced numeric robustness)

Fowler–Nordheim Tunneling

Use this model to describe leakage through thin gate insulators, provided those are of uniform or of uniformly graded composition.

The Fowler–Nordheim model is the simplest (see Fowler–Nordheim Tunneling).

If the simulated device contains a floating gate, gate currents are used to update the charge on the floating gate after each time step in transient simulations. If EEPROM cells are simulated in two dimensions, it is generally necessary to include an additional coupling capacitance between the control and floating gates to account for the additional influence of the third dimension on the capacitance between these electrodes (see Floating Metal Contacts on page 232). The additional floating gate capacitance can be specified as `FGcap` in the `Electrode` statement (see Physical Models and the Hierarchy of Their Specification on page 18).

# Fowler–Nordheim Tunneling

Fowler–Nordheim tunneling is a special case of tunneling also covered by the nonlocal and direct tunneling models, where tunneling is to the conduction band of the oxide. The Fowler–Nordheim tunneling model is simple and efficient, and has proven useful to describe erase operations in EEPROMs, which is the application for which this model is recommended.

## Using Fowler–Nordheim

To switch on the Fowler–Nordheim tunneling model, specify `Fowler` as an option to `GateCurrent` in an appropriate interface `Physics` section, as follows:

```
Physics(MaterialInterface="Silicon/Oxide"){ GateCurrent(Fowler) }
```

or:

```
Physics(MaterialInterface="Silicon/Oxide"){ GateCurrent(Fowler(EVB)) }
```

The second specification activates the tunneling of electrons from and to the valence band as discussed in Fowler–Nordheim Model on page 769.

If `GateCurrent` is specified as above, Sentaurus Device computes gate currents between all silicon–oxide interfaces and the electrodes. The computation can be restricted to selected interfaces using region-interface `Physics` sections.

For simple one-gate devices, the tunneling current can be monitored on a contact specified by the keyword `GateName` in the `GateCurrent` statement.

**24: Tunneling**
Fowler–Nordheim Tunneling

You can use the Fowler–Nordheim tunneling model with any of the hot-carrier injection models (see Chapter 25 on page 793). The following example switches on the Fowler–Nordheim tunneling model and the classical lucky electron injection model simultaneously:

```
GateCurrent( Fowler Lucky )
```

# Fowler–Nordheim Model

The Fowler–Nordheim model reads:

$$ j_{\text{FN}} = AF_{\text{ins}}^2 \exp(-\frac{B}{F_{\text{ins}}}) \tag{791} $$

where $j_{\text{FN}}$ is the tunnel current density, $F_{\text{ins}}$ is the insulator electric field at the interface, and $A$ and $B$ are physical constants. The electric field at the interface shown by Sentaurus Visual is an interpolation of the fields in both regions, but Sentaurus Device uses the insulator field internally.

Due to the large energy difference between oxide and silicon conduction bands, tunneling electrons create electron–hole pairs in the erase operation when they enter the semiconductor. This additional carrier generation is included by an energy-independent multiplication factor $\gamma > 1$:

$$ j_n = \gamma \cdot j_{\text{FN}} \tag{792} $$

$$ j_p = (\gamma - 1) \cdot j_{\text{FN}} \tag{793} $$

If the electrons flow in an opposite direction, by default, $\gamma = 1$. The formulas above reflect the default behavior of Sentaurus Device, but sometimes the Fowler–Nordheim equation is used to emulate other tunneling effects, for example, the tunneling of electrons from the valence band into the gate. Such capability is activated by the additional keyword `EVB` in the command file. Sentaurus Device will continue to function even if $\gamma < 1$. For any electron tunneling direction, particularly a floating body SOI, this tunneling current is important because it strongly defines floating body potential. Different coefficients are needed for the write and erase operations because, in the first case, the electrons are emitted from monocrystalline silicon and, in the latter case, they are emitted from the polysilicon contact into the oxide.

The tunneling current is implemented as a current boundary condition at the interface where the current is produced.

For transient simulations, if the `Interface` keyword is also present in the `GateCurrent` section, carrier tunneling with explicitly evaluated boundary conditions for continuity

24: Tunneling
Direct Tunneling

equations is activated (similar to carrier injection with explicitly evaluated boundary conditions for continuity equations in Carrier Injection With Explicitly Evaluated Boundary Conditions for Continuity Equations on page 815).

## Fowler–Nordheim Parameters

The parameters of the Fowler–Nordheim model can be modified in the `FowlerModel` parameter set. Sentaurus Device uses different parameters (denoted as `erase` and `write`) depending on the direction of the electric field between the contact and semiconductor in the oxide layer. For example, if the field points from the contact to the semiconductor (that is, electrons flow into the contact), the ‘write’ parameter set is used. Table 138 lists the parameters and their default values.

Table 138 Coefficients for Fowler–Nordheim tunneling (defaults for silicon–oxide interface)

| Symbol | Parameter name | Default value | Unit | Remarks |
| --- | --- | --- | --- | --- |
| A (erase) | Ae | 1.87 × 10⁻⁷ | A/V² | A for the erase cycle |
| B (erase) | Be | 1.88 × 10⁸ | V/cm | B for the erase cycle |
| A (write) | Aw | 1.23 × 10⁻⁶ | A/V² | A for the write cycle |
| B (write) | Bw | 2.37 × 10⁸ | V/cm | B for the write cycle |
| γ | Gm | 1 | 1 |  |

# Direct Tunneling

Direct tunneling is the main gate leakage mechanism for oxides thinner than 3 nm. It turns into Fowler–Nordheim tunneling at oxide fields higher than approximately 6 MV/cm, independent of the oxide thickness. This section describes a fully quantum-mechanical tunneling model that is restricted to trapezoidal tunneling barriers and covers both direct tunneling and the Fowler–Nordheim regime. Optionally, the model considers the reduction of the tunneling barrier due to image forces.

A variant of this direct tunneling model is used to describe spin-selective tunneling through magnetic tunnel junctions (see Transport Through Magnetic Tunnel Junctions on page 872).

 24: Tunneling
Direct Tunneling

# Using Direct Tunneling

The direct tunneling model is specified as an option of the `GateCurrent` statement (see Using Fowler–Nordheim on page 768) in an appropriate interface `Physics` section:

```
Physics(MaterialInterface="Silicon/Oxide") {
    GateCurrent( DirectTunneling )
}
```

The keyword `GateName` and the compatibility with the hot-carrier injection models (see Chapter 25 on page 793) are as for the Fowler–Nordheim model, see Fowler–Nordheim Tunneling on page 768.

To switch on the image force effect, the parameters `E0`, `E1`, and `E2` must be specified (in eV) in the parameter file. If these values are all equal (the default), the image force is neglected. Recommended values for both electrons and holes are `E0=0`, `E1=0.3`, and `E2=0.7`. Including the image force effect degrades convergence. For most purposes, the effect can be approximated by reducing the overall barrier height. For more information on model parameters, see Direct Tunneling Parameters on page 773.

To plot the direct tunneling current, the keywords `eSchenkTunnel` or `hSchenkTunnel` must be included in the `Plot` section:

```
Plot { eSchenkTunnel hSchenkTunnel }
```

# Direct Tunneling Model

This section summarizes the model described in the literature [[1]]([1]). It presents the formulas for electrons only; the hole expressions are analogous. The electron tunneling current density is:

$$ j_n = \frac{qm_Ck}{2\pi^2\hbar^3} \int_0^\infty dE \Upsilon(E) \left\{ T(0) \ln \left( \exp \left[ \frac{E_{F,n}(0) - E_C(0) - E}{kT(0)} \right] + 1 \right) \right. $$
$$ \left. - T(d) \ln \left( \exp \left[ \frac{E_{F,n}(d) - E_C(0) - E}{kT(d)} \right] + 1 \right) \right\} \eqno(794) $$

where $d$ is the effective thickness of the barrier, $m_C$ is a mass prefactor, the argument $0$ denotes one (the ‘substrate’) side of the barrier and $d$ denotes the other (‘gate’) side, and $E$ is the energy of the elastic tunnel process (relative to $E_C(0)$).

Direct Tunneling

$\Upsilon(E) = 2 / (1 + g(E))$ is the transmission coefficient for a trapezoidal potential barrier, with:

$$
g(E) = \frac{\pi^2}{2} \bigg\{ \sqrt{\frac{E_T}{E}} \sqrt{\frac{m_{Si}}{m_G}} (Bi'_d Ai_0 - Ai'_d Bi_0)^2 + \sqrt{\frac{E}{E_T}} \sqrt{\frac{m_G}{m_{Si}}} (Bi_d Ai'_0 - Ai_d Bi'_0)^2 + \frac{\sqrt{m_G m_{Si}}}{m_{ox}} \frac{\hbar \Theta_{ox}}{\sqrt{E E_T}} (Bi'_d Ai'_0 - Ai'_d Bi'_0)^2 + \frac{m_{ox}}{\sqrt{m_G m_{Si}}} \frac{\sqrt{E E_T}}{\hbar \Theta_{ox}} (Bi_d Ai_0 - Ai_d Bi_0) \bigg\} \tag{795}
$$

and:

$$
Ai_0 = Ai \Big( \frac{E_B(E) - E}{\hbar \Theta_{ox}} \Big), \quad Ai_d = Ai \Big( \frac{E_B(E) - q F_{ox} d - E}{\hbar \Theta_{ox}} \Big) \tag{796)
$$

and so on, where $\hbar \Theta_{ox} = (q^2 \hbar^2 F_{ox}^2 / 2 m_{ox})^{1/3}$ and $E_B(E)$ denotes the (substrate-side) barrier height for electrons of energy $E$. $E_T$ is the tunneling energy with respect to the conduction band edge on the gate side, $E_T = E - E_C(d) - E_C(0)$.

For compatibility with an earlier implementation of the model, $E_T$ is truncated to the value specified by the parameter `E_F_M` if it exceeds this value. $F_{ox} = V_{ox} / d$ is the electric field in the oxide (assumed to be uniform within the oxide, and including a band edge–related term when different barrier heights are specified at the two insulator interfaces). The quantities $m_G$, $m_{ox}$, and $m_{Si}$ represent the electron masses in the three materials, respectively. $Ai$ and $Bi$ are Airy functions, and $Ai'$ and $Bi'$ are their derivatives.

## Image Force Effect

Ultrathin oxide barriers are affected by the image force effect. If the latter is neglected, $E_B(E)$ is the bare barrier height $E_B$, which is an input parameter. The image force effect is included in the model by taking $E_B(E)$ as an energy-dependent pseudobarrier:

$$
E_B(E) = E_B(E_0) + \frac{E_B(E_2) - E_B(E_0)}{(E_2 - E_0)(E_1 - E_2)} (E - E_0)(E_1 - E) - \frac{E_B(E_1) - E_B(E_0)}{(E_1 - E_0)(E_1 - E_2)} (E - E_0)(E_2 - E) \tag{797}
$$

where $E_0$, $E_1$, and $E_2$ are chosen in the lower energy range of the barrier potential (between 0 eV and 1.5 eV in practical cases). If these values are chosen to be equal, the image force effect is automatically switched off. Otherwise, for each bias point:

$$
S_{tra}(E) = S_{im}(E) \tag{798}
$$

is solved for $E_j (j = 0, 1, 2)$, which results in three pseudobarrier heights $E_B(E_j)$ used in Eq. 797. In Eq. 798, $S_{tra}(E)$ is the action of the trapezoidal pseudobarrier:

$$
S_{tra}(E) = \frac{2}{3} \Bigg[ \frac{[E_B(E) - q F_{ox} d - E]^{3/2}}{\hbar \Theta_{ox}} \Theta[E_B(E) - q F_{ox} d - E] - \frac{[E_B(E) - E]^{3/2}}{\hbar \Theta_{ox}} \Bigg] \tag{799}
$$

24: Tunneling
Direct Tunneling

and $S_{\text{im}}(E)$ is the action of the respective image potential barrier:

$$ S_{\text{im}}(E) = \sqrt{\frac{2m_{\text{ox}}}{\hbar^2}} \int_{x_{\text{l}}(E)}^{x_{\text{r}}(E)} d\xi \sqrt{E_{\text{B}} - qF_{\text{ox}}\xi + E_{\text{im}}(\xi) - E} $$ (800)

$x_{\text{l,r}}(E)$ denotes the classical turning points for a given carrier energy that follow from:

$$ E_{\text{T}} - qF_{\text{ox}}x_{\text{l,r}} + E_{\text{im}}(x_{\text{l,r}}) = E $$ (801)

For the thickness of the pseudobarrier, $d = x_{\text{r}}(0) - x_{\text{l}}(0)$ is used, that is, the distance between the two turning points at the energy of the semiconductor conduction band edge of the interface. Therefore, $d$ is smaller than the user-given oxide thickness, when the image force effect is considered. The image potential itself is given by:

$$ E_{\text{im}}(x) = \frac{q^2}{16\pi\epsilon_{\text{ox}}} \sum_{n=0}^{10} (k_1 k_2)^n \left[ \frac{k_1}{nd + x} + \frac{k_2}{d(n + 1) - x} + \frac{2k_1 k_2}{d(n + 1)} \right] $$ (802)

with:

$$ k_1 = \frac{\epsilon_{\text{ox}} - \epsilon_{\text{Si}}}{\epsilon_{\text{ox}} + \epsilon_{\text{Si}}}, \quad k_2 = \frac{\epsilon_{\text{ox}} - \epsilon_{\text{G}}}{\epsilon_{\text{ox}} + \epsilon_{\text{G}}} = -1 $$ (803)

In Eq. 803, $\epsilon_{\text{ox}}$, $\epsilon_{\text{Si}}$, and $\epsilon_{\text{G}}$ denote the dielectric constants for the oxide, substrate, and gate material, respectively.

# Direct Tunneling Parameters

The parameters of the direct tunneling model are modified in the `DirectTunneling` parameter set. The appropriate default parameters for an oxide barrier on silicon are in Table 139. The parameters are specified according to the interface.

Table 139 Coefficients for direct tunneling (defaults for oxide barrier on silicon)

| Symbol | Parameter name | Electrons | Holes | Unit | Description |
| --- | --- | --- | --- | --- | --- |
| εox | eps_ins | 2.13 | 2.13 | 1 | Optical dielectric constant |
| EF(d) | E_F_M | 11.7 | 11.7 | eV | Fermi energy for gate contact |
| mG | m_M | 1 | 1 | m0 | Effective mass in gate contact |
| mox | m_ins | 0.50 | 0.77 | m0 | Effective mass in insulator |
| mSi | m_s | 0.19 | 0.16 | m0 | Effective mass in substrate |
| mC | m_dos | 0.32 | 0 | m0 | Semiconductor DOS effective mass |

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

Table 139 Coefficients for direct tunneling (defaults for oxide barrier on silicon) (Continued)

| Symbol | Parameter name | Electrons | Holes | Unit | Description |
| --- | --- | --- | --- | --- | --- |
| $E_B$ | `E_barrier` | 3.15 | 4.73 | eV | Semiconductor/insulator barrier (no image force) |
| $E_0$, $E_1$, $E_2$ | `E0, E1, E2` | 0 | 0 | eV | Energy nodes 0, 1, and 2 for pseudobarrier calculation |

If tunneling occurs between two semiconductors, the coefficients for metal (`m_M` and `E_F_M`) are not used. The semiconductor parameters for the respective interface are used. It is not valid to have contradicting parameter sets for two interfaces of an insulator between which tunneling occurs. In particular, `eps_ins`, `m_ins`, `E0`, `E1`, and `E2` must agree in the parameter specifications for both interfaces.

# Nonlocal Tunneling at Interfaces, Contacts, and Junctions

The tunneling current depends on the band edge profile along the entire path between the points connected by tunneling. This makes tunneling a nonlocal process. In general, the band edge profile has a complicated shape, and Sentaurus Device must compute it by solving the transport equations and the Poisson equation. The model described here takes this dependence fully into account.

To use the nonlocal tunneling model:

1. Construct a special-purpose nonlocal mesh (see Defining Nonlocal Meshes).

2. Specify the physical details of the tunneling model (see Specifying Nonlocal Tunneling Model on page 776).

3. Adjust the physical and numeric parameters (see Nonlocal Tunneling Parameters on page 778).

## Defining Nonlocal Meshes

It is necessary to specify a special-purpose nonlocal mesh for each part of the device for which you want to use the nonlocal tunneling model. Nonlocal meshes consist of ‘nonlocal’ lines that represent the tunneling paths for the carriers.

To control the construction of the nonlocal mesh, use the options of the keyword `NonLocal` in the global `Math` section.

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

Nonlocal meshes can be constructed using different forms:

*   In the simpler form, `NonLocal` specifies barrier regions.

The following example constructs a nonlocal mesh for a tunneling barrier that consists of the regions `oxtop` and `oxbottom`:

```
Math { Nonlocal "NLM" ( Barrier(Region="oxtop" Region="oxbottom") ) }
```

See Specification Using Barrier on page 155.

*   In the more general form, `NonLocal` specifies an interface or a contact where the mesh is constructed, and a distance `Length` (given in centimeters). Sentaurus Device then connects semiconductor vertices with a distance from the interface or contact no larger than `Length` to the interface or contact. These connections form the centerpiece of the nonlocal lines.

In the following example, Sentaurus Device constructs a nonlocal mesh called "NLM" that connects vertices up to a distance of 5 nm to the `Gate` electrode:

```
Math { Nonlocal "NLM" (Electrode="Gate" Length=5e-7) }
```

See Specification Using a Reference Surface on page 156.

Sentaurus Device introduces a coordinate along each nonlocal line. The interface or contact is at coordinate zero; the vertex for which the nonlocal line is constructed is at a positive coordinate. Below, the terms *upper* and *lower* refer to the orientation according to these nonlocal line–specific coordinates. This orientation is not related to the orientation of the mesh axes.

To form the nonlocal lines, Sentaurus Device extends the connection at the upper end, to fully cover the box for the vertex that is connected. Optionally, for nonlocal meshes at interfaces, the connection can be extended at the lower end (beyond the interface) by an amount specified by `Permeation` (in centimeters).

Sentaurus Device handles each nonlocal line separately. Therefore, two nonlocal lines connecting two vertices to the same interface do not allow the computing of tunneling between these vertices. To compute tunneling between vertices on the two sides of an interface, they must be covered by a single nonlocal line. This is where `Permeation` is needed.

For nonlocal meshes not used for trap tunneling, `Permeation` also affects the integration range for tunneling. With zero `Permeation`, the lower endpoint for tunneling is always at the interface; for positive `Permeation`, it can be anywhere on the nonlocal line. Therefore, for tunneling at smooth barriers (for example, band-to-band tunneling at a steep p-n junction), the nonlocal mesh used should not be reused for trap tunneling (see Nonlocal Tunneling for Traps on page 517), and `Permeation` should be positive.

When using the more general form of nonlocal mesh construction, specify a nonlocal mesh for only one side of a tunneling barrier. If on one side of the tunneling barrier there is a contact or a metal–nonmetal interface, specify the mesh there. In other cases, specify the nonlocal mesh

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

for the interface from which the carriers will tunnel away. If this side can change during the simulation, specify a nonzero `Permeation` (approximately as much as `Length` exceeds the barrier thickness). For tunneling barriers with multiple layers, do not specify a nonlocal mesh for the interfaces internal to the barrier.

For more options to the keyword `NonLocal`, see Table 221 on page 1543. For details about the nonlocal mesh and its construction, see Constructing Nonlocal Meshes on page 155.

> **NOTE** The nonlocality of tunneling can increase dramatically the time that is needed to solve the linear systems in the Newton iteration. To limit the speed degradation, keep `Length` and `Permeation` as small as possible. Consider optimizing the nonlocal mesh using the advanced options of `NonLocal` (see Constructing Nonlocal Meshes on page 155).

## Specifying Nonlocal Tunneling Model

The nonlocal tunneling model is activated and controlled in the global `Physics` section. Each tunneling event connects two points on a nonlocal line. Sentaurus Device distinguishes between tunneling to the conduction band and to the valence band at the lower of the two points.

To switch on these terms, use the options `eBarrierTunneling` and `hBarrierTunneling`. For example:

```
Physics {
  eBarrierTunneling "NLM" hBarrierTunneling "NLM"
}
```

switches on electron and hole tunneling for the nonlocal mesh called "NLM", and:

```
Physics {
  eBarrierTunneling "NLM" (PeltierHeat)
}
```

switches on tunneling to the conduction band only and activates the Peltier heating of the tunneling particles.

By default, all tunneling to the conduction band at the lower point on the line originates from the conduction band at the upper point, $j_C = j_{CC}$ (‘electron tunneling’), see Eq. 814, p. 787. Likewise, by default, the tunneling to the valence band at the lower point originates from the valence band at the upper point, $j_V = j_{VV}$ (that is, ‘hole tunneling’).

In addition, Sentaurus Device supports nonlocal band-to-band tunneling. To include the contributions by tunneling to and from the valence band at the upper point in $j_C$, specify

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

`eBarrierTunneling` with the `Band2Band=Simple` option. Then, $j_C = j_{CC} + j_{CV}$, see Eq. 814 and Eq. 817, p. 789. To include contributions by tunneling to and from the conduction band at the upper point to $j_V$, specify `hBarrierTunneling` with the `Band2Band=Simple` option. Then, $j_V = j_{VC} + j_{VV}$. With `Band2Band=Full`, the nonlocal band-to-band tunneling model uses Eq. 488, p. 476 instead of Eq. 816, p. 789 to calculate the band-to-band tunneling contribution, which makes the model consistent with the Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475 provided that the dynamic nonlocal path band-to-band model uses the direct tunneling model with the Franz dispersion relation. With `Band2Band=UpsideDown` (or only `Band2Band`), an obsolete, physically flawed, band-to-band tunneling model is activated.

For backward compatibility, you can activate the nonlocal tunneling model in an interface-specific or contact-specific `Physics` section; in that case, specify `eBarrierTunneling` and `hBarrierTunneling` as options to `Recombination`, and omit the nonlocal mesh name. The specification applies to an unnamed nonlocal mesh that has been constructed for the same location (see Unnamed Meshes on page 158).

Figure 48 illustrates the four contributions to the total tunneling current.

Diagram showing various nonlocal tunneling current contributions (jCC, jCV, jVC, jVV) at interfaces for eBarrierTunneling and hBarrierTunneling.

Figure 48 Various nonlocal tunneling current contributions

By default, Sentaurus Device assumes a single-band parabolic band structure for the tunneling particles, uses a WKB-based model for the tunneling probability, and ignores band-to-band tunneling and Peltier heating. Options to `eBarrierTunneling` and `hBarrierTunneling` override the default behavior. For available options, see Table 236 on page 1560. For a detailed discussion of the physics of the nonlocal tunneling model, see Physics of Nonlocal Tunneling Model on page 781.

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

When specifying the `Multivalley` option, the tunneling model uses the multivalley band structure (see Multivalley Band Structure on page 281). This allows you to account for conduction and valence bands with multiple valleys, anisotropic masses, and possibly geometric confinement. See Multivalley Band Structure and Geometric Quantization on page 785.

When specifying the `BarrierLowering` option, the tunneling model accounts for position-dependent barrier lowering corrections in the conduction-band and valence-band edges, shifting them inwards, toward the midgap. See WKB Tunneling Probability on page 781 and Eq. 810, p. 783.

## Nonlocal Tunneling Parameters

The nonlocal tunneling model has several fit parameters. They are specified in the `BarrierTunneling` parameter set.

The parameter pair `g` determines the dimensionless prefactors $g_C$ and $g_V$ (see Eq. 813 and Eq. 816). For unnamed meshes, specify them in the parameter set that is specific to the contact or interface for which the nonlocal tunneling model is activated. For named meshes, specify them in the global parameter set.

The parameter pair `mt` determines the tunneling masses $m_C$ and $m_V$ (see Eq. 804 and Eq. 805). They are properties of the materials that form the tunneling barrier. Therefore, specify them (in units of $m_0$) in region-specific or material-specific parameter sets. For tunneling at contacts, also specify the masses for the contact parameter set when using `Transmission` or `Schroedinger` (see Eq. 809, p. 782 and Schrödinger Equation–Based Tunneling Probability on page 784).

Sentaurus Device treats effective tunneling masses of value zero as undefined. If an effective tunneling mass for a region is undefined, Sentaurus Device uses the effective tunneling mass for the interface or contact for which tunneling is activated (for unnamed meshes) or the tunneling mass from the global parameter set (for named meshes). By default, all effective tunneling masses are undefined. Finally, if the model is used with the `Multivalley` option (see Multivalley Band Structure and Geometric Quantization on page 785), masses extracted from the multivalley model override the tunneling masses wherever they are available.

The following example changes the prefactors $g_C$ and $g_V$ to 1 and 2, respectively:

```
BarrierTunneling {
  mt = 0.5, 0.5
  g = 1 , 2
}
```

**24: Tunneling**

# Nonlocal Tunneling at Interfaces, Contacts, and Junctions

```
Material = "Oxide" {
    BarrierTunneling {
        mt = 0.42 , 1.0
    }
}
```

The tunneling masses are set to $0.5m_0$. In oxide, it sets the tunneling masses $m_C$ and $m_V$ to 0.42 and 1, respectively; these values take precedence over the masses specified globally.

The parameters `eoffset` and `hoffset` are lists of nonnegative energy shifts (in eV) that are added to the conduction-band and valence-band edges, shifting them outwards, away from the midgap. Specify them in a region-specific or material-specific parameter set. By default, a single shift value of zero is assumed. Sentaurus Device computes the tunneling current as the sum of the currents for each shift. Shifts in different regions are combined according to the position where they appear in the list; if the lists in different regions have different lengths, the last value in the shorter lists are repeated to extend them to the length of the longest list.

The parameter pair `alpha` determines the fit factors $\alpha_n$ and $\alpha_p$ for the quantization corrections for tunneling from inversion layers through insulator barriers (see Density Gradient Quantization Correction on page 785). The default values are zero, disabling the corrections. To enable them, set the parameters to one (or another positive value) in the interface- or contact-specific parameter set (for unnamed meshes) or in the global parameter set (for named meshes).

The parameter pairs `QuantumPotentialFactor` and `QuantumPotentialPosFac` specify the prefactors for the electron and hole quantum potentials obtained from the density gradient model (see Density Gradient Model on page 316) that can be added to the band edges used for evaluating the tunneling rate. By default, the parameters are zero, such that the quantum potentials are neglected in the computation of tunneling. When they are nonzero, the quantum potentials multiplied by the corresponding prefactors are added to the conduction and valence band edges for the computation of tunneling current.

For `QuantumPotentialFactor`, an addition is performed irrespective of the sign of the quantum potential. For `QuantumPotentialPosFac`, an addition is performed only where the quantum potential is positive, that is, only where quantization causes an effective widening of the band gap.

The quantum corrections activated by giving `QuantumPotentialFactor` or `QuantumPotentialPosFac` a nonzero value are intended for situations where quantization is caused by confinement perpendicular to the tunneling direction. In contrast, `alpha` is intended for tunneling from an inversion layer, where quantization is due to confinement in the tunneling direction.

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

BarrierTunneling can also be applied specifically to named nonlocal meshes. The following example changes the oxide tunneling mass for the nonlocal mesh `NLM` only:

```
Material = "Oxide" {
  BarrierTunneling "NLM" {
    mt = 0.42 , 1.0
  }
}
```

Specifications for named nonlocal meshes take precedence over the general specifications.

Specify numeric parameters for the model in the `Math` section, as an option of `NonLocal` for a given nonlocal mesh. The parameter `Digits` determines the relative accuracy (the number of valid decimal digits) to which Sentaurus Device computes the integrals in Eq. 814 and Eq. 817. The default value is 2. The parameter `EnergyResolution` (given in eV) is a lower limit for the energy step that Sentaurus Device uses to perform the integrations and it defaults to 0.005. The purpose of `EnergyResolution` is to limit the runtime for computing the tunneling currents in case the value of `Digits` is too large.

The following example increases the energy resolution for tunneling on the nonlocal mesh "NLM" to 1 meV and the relative accuracy of the tunneling current computation to three digits:

```
Math {
  NonLocal "NLM" (
    ...
    Digits=3
    EnergyResolution=0.001
  )
}
```

# Visualizing Nonlocal Tunneling

To visualize nonlocal tunneling, specify the keyword `eBarrierTunneling` or `hBarrierTunneling` in the `Plot` section (see Device Plots on page 128). The quantities plotted are in units of cm<sup>–3</sup>s<sup>–1</sup> and represent the rate at which electrons and holes are generated or disappear due to tunneling. To plot the Peltier heat generated in the conduction band and valence band due to nonlocal tunneling, specify `eNLLTunnelingPeltierHeat` and `hNLLTunnelingPeltierHeat`. The Peltier heat is plotted in units of Wcm<sup>–3</sup> and is available regardless of whether it is accounted for in the temperature equation.

The rates are plotted vertexwise and are averaged over the semiconductor volume controlled by a vertex. Therefore, they depend on the mesh spacing. This dependence can become particularly strong at interfaces where the band edges change abruptly.

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

# Physics of Nonlocal Tunneling Model

The nonlocal tunneling model in Sentaurus Device is based on the approach presented in the literature [2], but provides significant enhancements over the model presented there.

## WKB Tunneling Probability

The computation of the tunneling probabilities $\Gamma_{C, \nu}$ (for carriers tunneling to the $\nu$-th shifted conduction band at the interface or contact) and $\Gamma_{V, \nu}$ (for tunneling to the $\nu$-th shifted valence band) is, by default, based on the WKB approximation.

The WKB approximation uses the local (imaginary) wave numbers of particles at position $r$ and with energy $\varepsilon$:

$$\kappa_{C, \nu}(r, \varepsilon) = \sqrt{2m_C(r) |E_{C, \nu}(r) - \varepsilon|} \Theta[E_{C, \nu}(r) - \varepsilon] / \hbar$$ (804)

$$\kappa_{V, \nu}(r, \varepsilon) = \sqrt{2m_V(r) |\varepsilon - E_{V, \nu}(r)|} \Theta[\varepsilon - E_{V, \nu}(r)] / \hbar$$ (805)

Here, $m_C$ is the conduction-band tunneling mass and $m_V$ is the valence-band tunneling mass. Both tunneling masses are adjustable parameters (see Nonlocal Tunneling Parameters on page 778). $E_{C, \nu}$ and $E_{V, \nu}$ are the conduction and valence bands energies shifted by the $\nu$-th value in `eoffset` and `hoffset` (see Nonlocal Tunneling Parameters on page 778).

Using the local wave numbers and the interface transmission coefficients $T_{CC, \nu}$ and $T_{VV, \nu}$, the tunneling probability between positions $l$ and $u > l$ for a particle with energy $\varepsilon$ can be written as:

$$\Gamma_{CC, \nu}(u, l, \varepsilon) = T_{CC, \nu}(l, \varepsilon) \exp \left( -2 \int_{l}^{u} \kappa_{C, \nu}(r, \varepsilon) dr \right) T_{CC, \nu}(u, \varepsilon)$$ (806)

and:

$$\Gamma_{VV, \nu}(u, l, \varepsilon) = T_{VV, \nu}(l, \varepsilon) \exp \left( -2 \int_{l}^{u} \kappa_{V, \nu}(r, \varepsilon) dr \right) T_{VV, \nu}(u, \varepsilon)$$ (807)

If the option `TwoBand` is specified to `eBarrierTunneling` (see Table 236 on page 1560), Sentaurus Device replaces $\kappa_{C, \nu}$ in Eq. 806 with the two-band dispersion relation:

$$\kappa_{\nu} = \frac{\kappa_{C, \nu} \kappa_{V, \nu}}{\sqrt{\kappa_{C, \nu}^2 + \kappa_{V, \nu}^2}}$$ (808)

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

If the option `TwoBand` is specified to `hBarrierTunneling`, Sentaurus Device replaces $\kappa_{V, \nu}$ in Eq. 807 with the two-band relation Eq. 808. Near the conduction and the valence band edge, the two-band dispersion relation approaches the single band dispersion relations Eq. 804 and Eq. 805, and provides a smooth interpolation in between. Figure 49 illustrates this.

The two-band dispersion relation does not distinguish between electrons and holes. In particular, for the two-band dispersion relation, $\Gamma_{CC, \nu} = \Gamma_{VV, \nu}$.

| Energy [eV] | κV | κC |
| --- | --- | --- |
| -11 | 0 |  |
| -10 | 6.5 |  |
| -9 | 8 |  |
| -8 | 8.3 |  |
| -7 | 8 |  |
| -6 | 7.5 |  |
| -5 | 6.5 |  |
| -4 | 5.5 |  |
| -3 | 4 |  |
| -2 | 2 |  |
| -1 | 0 |  |
| 0 |  |  |

Figure 49 Comparison of two-band and single-band dispersion relations

The two-band dispersion relation is most useful when band-to-band tunneling is active (keyword `Band2Band`, see Table 236 on page 1560). However, the two-band dispersion relation can be used independently from band-to-band tunneling.

By default, the interface transmission coefficients $T_{CC, \nu}$ and $T_{VV, \nu}$ in Eq. 806 and Eq. 807 equal one. If the `Transmission` option is specified to `eBarrierTunneling` [3]:

$$ T_{CC, \nu}(x, \epsilon) = \frac{v_{-, \nu}(x, \epsilon) \sqrt{v_{-, \nu}(x, \epsilon)^2 + 16v_{+, \nu}(x, \epsilon)^2}}{v_{+, \nu}(x, \epsilon)^2 + v_{-, \nu}(x, \epsilon)^2} $$ (809)

Here, $v_{-, \nu}(x, \epsilon)$ denotes the velocity of a particle with energy $\epsilon$ on the side of the interface or contact at position $x$ where the particle moves freely in the conduction band, and $v_{+, \nu}(x, \epsilon)$ denotes the imaginary velocity on the side of the tunneling barrier (where the particle is in the gap). If the particle is free or in the barrier on both sides, $T_{CC, \nu}(x, \epsilon) = 1$. Velocities are the derivatives of the particle energy with respect to the wave number, $v_{\nu} = |\partial\epsilon / \partial\hbar\kappa_{C, \nu}|$. With the `TwoBand` option, $v_{+, \nu} = |\partial\epsilon / \partial\hbar\kappa_{\nu}|$ [4] (see Eq. 808). If the `Transmission` option is specified to `hBarrierTunneling`, analogous expressions hold for $T_{VV, \nu}$.

By default, the band-to-band tunneling probabilities $\Gamma_{CV, \nu}$ and $\Gamma_{VC, \nu}$ are also given by the expressions Eq. 806 and Eq. 807, respectively. When the `TwoBand` and `Transmission` options are specified for `eBarrierTunneling` to compute $\Gamma_{CV, \nu}$, $v_{-, \nu}$ in the expression for $T_{CC, \nu}(r, \epsilon)$

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

(see Eq. 809) is the velocity of the particle in the valence band and is computed from valence-band parameters. The converse holds for $\Gamma_{\text{VC}, \nu}$ when those options are specified for `hBarrierTunneling`.

For metals and contacts, the band-edge energy to compute the interface transmission coefficients is obtained from the `FermiEnergy` parameter of the `BandGap` section for the metal or contact. The masses used to compute the velocities are the tunneling effective masses for the metal or contact.

For metals and contacts when the `BarrierLowering` option is specified for `BarrierTunneling`, the band edges are corrected by a position-dependent lowering potential given by:

$$ \Delta\Phi_{\text{B}}(r) = \min\left( \frac{Aq}{16\pi\epsilon r}, \text{BL\_max} \right) \text{ (810)} $$

where $\epsilon$ is the material dielectric constant, $r$ is the distance from the interface or contact, and $A$ is a dimensionless fitting parameter. Because Eq. 810 has a singularity for $r \rightarrow 0$, Sentaurus Device limits $r$ by imposing a minimum value. You can set the minimum value for $r$ by specifying a maximum value for $\Delta\Phi_{\text{B}}(r)$ using the parameter `BL_max` (see Nonlocal Tunneling Parameters on page 778). `BL_max` must be positive.

The regionwise barrier-lowering fitting factor $A$ can be specified by the `A` parameter (default is 1):

```
Material = "Silicon" {
   BarrierTunneling {
      A = 1.02 , 1.0
   }
}
```

The barrier-lowering parameter `BL_max` allows you to adjust the maximum of the barrier lowering (corresponding to the minimum-allowed distance to the contact or interface). Its default value is 0.3 eV.

When the `BarrierLowering` model is defined, the effective band edge is typically lower than the original band edge. For the energy range between the lowered band edge and the original band edge, a thermionic emission–like current is calculated with transmission equal to 1.

To better resolve the lowering potential, an adaptive nonlocal mesh is generated when the `BarrierLowering` model is activated in tunneling. You can control the adaptive mesh by using the following syntax:

```
Math { NonLocal "NLM" (RefinedIntervals=1e-8) }
```

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

A smaller `RefinedIntervals` gives a finer mesh. It corresponds to the position-dependent lowering potential defined in Eq. 810. Its default value is 1, which produces the same results as previous releases. To have a better refinement, `RefinedIntervals=1e-8` is suggested, corresponding to A=1 and $BL_{max}=0.3eV$. With a smaller A or larger $BL_{max}$, the value of `RefinedIntervals` must be smaller.

> **NOTE** This feature is available only for the `BarrierLowering` model. If the `BarrierLowering` model is not specified, this feature is not activated.

To visualize the `BarrierLowering` model and the modified band edges, you can specify the following in the `NonLocalPlot` section:

```
NonLocalPlot((0 0)){
    CBBarrierLowering VBBarrierLowering
    CBEnergywithLowering VBEnergywithLowering
}
```

where:

*   `CBBarrierLowering` and `VBBarrierLowering` are the `BarrierLowering` values of the conduction band and the valence band, respectively.

*   `CBEnergywithLowering` and `VBEnergywithLowering` are the modified conduction band and valence band energies, respectively.

> **NOTE** These quantities can also be output by using the `Plot` section, but the values are not accurate since the resolution of the original mesh might be much lower than the nonlocal mesh. Therefore, always use `NonLocalPlot` to plot `BarrierLowering`-related quantities.

## Schrödinger Equation–Based Tunneling Probability

In addition to the WKB-based models discussed in WKB Tunneling Probability on page 781, Sentaurus Device can compute tunneling probabilities based on the Schrödinger equation. For the Schrödinger equation–based model, Sentaurus Device computes the tunneling probability $\Gamma_{CC, \nu}(E)$ (or $\Gamma_{VV, \nu}(E)$) by solving the 1D Schrödinger equation:

$$ (-\frac{d}{dr} \frac{\hbar^2}{m(r)} \frac{d}{dr} + E_{C, \nu}(r)) \Psi(r) = E(r) \Psi(r) $$ (811)

between the outermost classical turning points that belong to the tunneling energy $E$. For $m(r)$, Sentaurus Device uses the tunneling mass $m_t$ (see Nonlocal Tunneling Parameters on page 778). $E_{C, \nu}$ is the conduction-band energy shifted by the $\nu$-th value in `eoffset` (see Nonlocal Tunneling Parameters on page 778).

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

For boundary conditions, Sentaurus Device assumes incident and reflected plane waves outside the barrier on one side, and an evanescent plane wave on the other side. The energy for the plane waves is the greater of $kT_n$ and $E - E_{C, \nu}$, where $T_n$ and $E_{C, \nu}$ are taken at the point immediately outside the barrier on the respective side. The masses outside the barrier are the tunneling masses `mt` that are valid there.

## Density Gradient Quantization Correction

Two different quantization corrections to tunneling are available with the density gradient model (see Density Gradient Model on page 316).

The first correction is intended for tunneling from an inversion layer through an insulator. The corrections are multipliers to $T_{CC, \nu}(r, \varepsilon)$ and read:

$$ \exp \left( \alpha_n \frac{\Lambda_{fb,n}(r) - \Lambda_n(r)}{kT_n(r)} \right) \eqno(812) $$

where $\alpha_n$ is an adjustable parameter (see Nonlocal Tunneling Parameters on page 778), and $\Lambda_{fb,n}$ is the solution of the 1D density gradient equations for flatband (that is, $\phi = \text{const}$) conditions. A multiplier analogous to that in Eq. 812 exists for $T_{VV, \nu}$.

The second correction is intended for situations where quantization is due to confinement perpendicular to the tunneling direction, for example, for tunneling in the channel direction of a nanowire. For this correction, for the computation of tunneling, $\Lambda_n$ and $-\Lambda_p$ are added to the conduction band edge and the valence band edge, with prefactors as described in Nonlocal Tunneling Parameters on page 778.

The motivation for doing this is: If confinement and tunneling are perpendicular, the problem can be separated into a 1D tunneling problem and 2D quantization problems. From the 2D quantization problems, a subband profile along the tunneling direction can be extracted. The lowest energy subbands for electrons and holes form the effective barrier for the 1D tunneling problem. The lowest subband energy profile is approximated by the sum of the band edge and the quantum potential. Note that the latter approximation interprets the quantum potential as an energy-like quantity, ignoring the fact that the quantum potential also describes the shape of the wavefunction.

## Multivalley Band Structure and Geometric Quantization

When used with the `Multivalley` option, the tunneling model uses the multivalley band structure as described in Multivalley Band Structure on page 281. In particular, this means:

* Multiple tunneling processes are accounted for. For band-to-band tunneling, tunneling between all valleys of the conduction band to all valleys of the valence band is accounted for. For tunneling within the conduction band or within the valence band, tunneling within

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

each valley is accounted for; while no tunneling between different valleys is taken into account.

* The tunneling mass is the inverse of the reciprocal mass tensor specified by the multivalley parameters, projected in the tunneling direction. Where no multivalley parameters are available, the tunneling mass is determined from the tunneling parameters as described in Nonlocal Tunneling Parameters on page 778.

* The conduction and valence band edges used to compute tunneling include the band offsets as described by the multivalley model parameters.

* When the multivalley band structure is used with the `ThinLayer` model, the resulting quantum corrections due to geometric confinement are used in the tunneling model as well. The details of how this is performed are described next.

For the interplay of tunneling and quantization, two limiting cases can be distinguished:

* When tunneling is perpendicular to the confinement, the quantization increases the tunneling barrier, as discussed in Density Gradient Quantization Correction on page 785.

* When tunneling is in the confinement direction, quantization does not affect the tunneling barrier. However, quantization affects the density-of-states available to carriers in the bands to which they tunnel.

To connect the two limiting cases, Sentaurus Device uses the following heuristic approach: For each point along the tunneling path and for each valley, the angle $\beta$ between the tunneling direction and the confinement direction is computed in a coordinate system where the mass tensor of the valley becomes diagonal. From $\beta$ and the total quantization energy $\varepsilon_1^i$ given by Eq. 201, p. 283, a "perpendicular" quantization energy is obtained, $\varepsilon_{\perp}^i = (1 + -\cos^2\beta)\varepsilon_1^i$. The latter is added to the band edges in computing the tunneling probability (see WKB Tunneling Probability on page 781 and Schrödinger Equation–Based Tunneling Probability on page 784).

The total energy is added to the bands in the expressions for the energy and position integrations (see Nonlocal Tunneling Current on page 787). None of these terms is added for the expressions for carrier heating (see Carrier Heating on page 789).

> **NOTE** It is recommended that the number of valleys and their names are the same on an entire tunneling path, even when the path runs in more than one region.

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

# Nonlocal Tunneling Current

For a point at $u$, the expression for the net conduction band electron recombination rate due to tunneling to and from the $\nu$-th shifted conduction band at point $l < u$ with energy $\varepsilon$ is:

$$ R_{CC, \nu}(u, l, \varepsilon) - G_{CC, \nu}(u, l, \varepsilon) = \frac{A_{CC}}{qk} \vartheta \Big[ \varepsilon - E_{C, \nu}(u), -\frac{dE_{C, \nu}}{du}(u) \Big] \vartheta \Big[ \varepsilon - E_{C, \nu}(l), \frac{dE_{C, \nu}}{dl}(l) \Big] \Gamma_{CC, \nu}(u, l, \varepsilon) \times \text{ (813)} $$
$$ \Big[ T_n(u) \ln \Big( 1 + \exp \Big[ \frac{E_{F,n}(u) - \varepsilon}{kT_n(u)} \Big] \Big) - T_n(l) \ln \Big( 1 + \exp \Big[ \frac{E_{F,n}(l) - \varepsilon}{kT_n(l)} \Big] \Big) \Big] $$

where $\vartheta(x, y) = \delta(x)|y|\Theta(y)$, $A_{CC} = g_C A_0$ is the effective Richardson constant (with $A_0 = 4\pi m_0 kq/h^3$ the Richardson constant for free electrons), and $g_C$ is a fit parameter (see Nonlocal Tunneling Parameters on page 778). $R_{CC, \nu}$ relates to the first term and $G_{CC, \nu}$ to the second term in the second line of Eq. 813. $\Gamma_{CC, \nu}$ is the tunneling probability (see Eq. 806).

For nonlocal lines with zero `Permeation`, the second $\vartheta$-function is replaced with $\Theta[\varepsilon - E_{C, \nu}(l)]\delta(l - 0^-)$ (with $0^-$ infinitesimally smaller than 0). For contacts, metals, or in the presence of the option `BandGap`, the second $\vartheta$-function is replaced with $\delta(l - 0^-)$.

The contribution to the electron tunneling current density by electrons that tunnel from the conduction band at points above $l$ to the conduction band at point $l$ is the integral over the recombination rate (Eq. 813):

$$ \frac{dj_{CC}}{dl}(l) = -q \sum_{\nu} \int\limits_l^{\infty} \int\limits_{-\infty}^{\infty} [R_{CC, \nu}(u, l, \varepsilon) - G_{CC, \nu}(u, l, \varepsilon)] d\varepsilon du \text{ (814)} $$

The options for `hBarrierTunneling` and the expressions for the valence band to valence band tunneling current density $j_{VV}$ are analogous.

Tunneling current calculation is very sensitive to mesh density. To reduce mesh sensitivity and to achieve reasonable results with a relatively coarse mesh, a phenomenological correction function is used to fine-tune the Fermi potential and the integration weight along the nonlocal line:

$$ f(l) = C \exp(-\lambda l) \sin(\omega l + \theta \pi) \min(1, (\alpha_0 \Delta l)^{\beta_0}) \min(1, (\alpha_1 \Delta l_{\perp})^{\beta_1}) \min \Big( 1, \Big( \frac{N}{N_0} \Big)^{\beta_0 + \beta_1} \Big) \text{ (815)} $$

where:

*   $C$ is the coefficient of the correction function.

*   $\lambda$ is the damping ratio, which controls how fast the correction function approaches 0.

*   $\omega$ is the periodicity of the correction function.

*   $\theta$ is the phase of the correction function.

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

*   $\alpha$ and $\beta$ control the damping with regard to mesh density.

*   $N_0$ is a parameter that controls doping concentration dependency.

By default, C=0 so that the correction function has no impact. $\Delta l$ is the distance from the nonlocal line base to its first real mesh point along the line, and $\Delta l_\perp$ is the distance from the nonlocal line base to its neighbor mesh point perpendicular to the line direction. When the real mesh is sufficiently fine, $\Delta l$ is very small, so that the correction function becomes negligible. These parameters are specified in the `BarrierTunneling` section of the parameter file:

```
Electrode = "source" {
    BarrierTunneling {
        C = 0.12 , 0.12
        lambda = 1e7 , 1e7
        omega = 5e7 , 5e7
        phase= 0.0 , 0.0
    }
}
```

Table 140 Model parameters for correction function

| Symbol | Parameter name | Default value (electrons) | Unit |
| --- | --- | --- | --- |
| C | C | 0.0 | 1 |
| λ | lambda | 1 × 10⁷ | 1/cm |
| ω | omega | 5 × 10⁷ | 1/cm |
| θ | phase | 0.0 | 1 |
| α₀ | alpha0 | 5 × 10⁷ | 1/cm |
| β₀ | beta0 | 3.0 | 1 |
| α₁ | alpha1 | 5 × 10⁷ | 1/cm |
| β₁ | beta1 | 0.0 | 1 |
| N₀ | N0 | 1 × 10²⁰ | cm⁻³ |

It has been noted that, in a typical transistor, the correction added to the source contact has a more pronounced impact than the drain contact.

## Band-to-Band Contributions to Nonlocal Tunneling Current

When you specify the `Band2Band` option to `eBarrierTunneling` (see Table 236 on page 1560), the total current that flows to the conduction band at point $l$ also contains electrons that originate from the valence band at position $u > l$.

24: Tunneling

Nonlocal Tunneling at Interfaces, Contacts, and Junctions

For `Band2Band=Simple`, the recombination rate of the valence-band electrons with energy $\varepsilon$ at point $u$ (in other words, the generation rate of holes at $u$) due to tunneling to or from the $\nu$-th shifted conduction band at $l$ is:

$$ R_{CV, \nu}(u, l, \varepsilon) - G_{CV, \nu}(u, l, \varepsilon) = \frac{A_{CV}}{2qk} \vartheta \left[ \varepsilon - E_{V, \nu}(u), \frac{dE_{V, \nu}}{du}(u) \right] \vartheta \left[ \varepsilon - E_{C, \nu}(l), \frac{dE_{C, \nu}}{dl}(l) \right] \Gamma_{CV, \nu}(u, l, \varepsilon) \times \text{ (816)} $$
$$ [T_p(u) + T_n(l)] \left[ \left( 1 + \exp \left[ \frac{\varepsilon - E_{F, p}(u)}{kT_p(u)} \right] \right)^{-1} - \left( 1 + \exp \left[ \frac{\varepsilon - E_{F, n}(l)}{kT_n(l)} \right] \right)^{-1} \right] $$

where $A_{CV} = \sqrt{g_C g_V} A_0$. The prefactor $g_V$ is a fit parameter, see Nonlocal Tunneling Parameters on page 778. $\Gamma_{CV, \nu}$ is the band-to-band tunneling probability discussed above. The modifications for zero `Permeation`, contacts, metals, and the `BandGap` option are as for Eq. 813.

The current density of electrons that tunnel from the valence band at points above $l$ to the conduction band at point $l$ is the integral over the recombination rate (Eq. 816):

$$ \frac{dj_{CV}}{dl}(l) = -q \sum_{\nu} \int\limits_l^{\infty} \int\limits_{-\infty}^{\infty} [R_{CV, \nu}(r, l, \varepsilon) - G_{CV, \nu}(r, l, \varepsilon)] d\varepsilon dr \text{ (817)} $$

For band-to-band tunneling processes, the energy of the tunneling particles often lies deep in the gap of the barrier. The single-band dispersion relations that Sentaurus Device uses by default (see Eq. 804 and Eq. 805) are based on the band structure near the band edges, and might not be useful in this regime. The two-band dispersion relation according Eq. 808 is a better choice. To use the two-band dispersion relation, specify the option `TwoBand` to `eBarrierTunneling` (see Table 236 on page 1560).

The options for `hBarrierTunneling` and the expressions for the conduction band to valence band tunneling current density $j_{VC}$ are analogous.

## Carrier Heating

In hydrodynamic simulations, carrier transport leads to energy transport and, therefore, to heating or cooling of electrons and holes. The energy transport has a convective and a Peltier part. By default, Sentaurus Device ignores the Peltier part. To include the Peltier terms for the tunneling particles, specify the option `PeltierHeat` to `eBarrierTunneling` or `hBarrierTunneling` (see Table 236 on page 1560).

The convective part of the heat generation in the conduction and valence bands at position $u$ due to tunneling of carriers with energy $\varepsilon$ to and from the $\nu$-th shifted conduction band at $l < u$ is approximated as:

$$ H_{conv, CC, \nu}(u, l, \varepsilon) = \frac{\delta}{2} [G_{CC, \nu}(u) kT_n(l) - R_{CC, \nu}(u) kT_n(u)] \text{ (818)} $$

References

and:

$$ H_{\text{conv,CV, }\nu}(u, l, \varepsilon) = \frac{\delta}{2} [R_{\text{CV, }\nu}(u)kT_p(u) - G_{\text{CV, }\nu}(u)kT_n(l)] \tag{819} $$

By default, Sentaurus Device neglects Peltier heating and uses $\delta = 3$, which corresponds to the three degrees of freedom of the carriers. If Peltier heating is included in a simulation, the convective contribution due to one degree of freedom is already contained in the Peltier heating term. Therefore, in this case, Sentaurus Device uses $\delta = 2$. The convective parts of the heat generation in the conduction band at $l$, due to tunneling of carriers of energy $\varepsilon$ from the conduction band and the valence band at $u > l$, are $-H_{\text{conv,CC, }\nu}(u, l, \varepsilon)$ and $-H_{\text{conv,CV, }\nu}(u, l, \varepsilon)$. The expressions for the convective part of the heat generation in the valence band are analogous.

If the computation of Peltier heating is activated (see Table 236 on page 1560), Sentaurus Device computes additional heating terms. The Peltier part of the heat generation in the electron system at point $u$ due to tunneling to and from the $\nu$-th shifted conduction band at point $l < u$ is:

$$ H_{\text{Pelt,CC, }\nu}(u, l, \varepsilon) = [E_C(u^+) - \varepsilon] [R_{\text{CC, }\nu}(u, l, \varepsilon) - G_{\text{CC, }\nu}(u, l, \varepsilon)] \tag{820} $$

where $u^+$ is infinitesimally larger than $u$. Eq. 820 vanishes everywhere except at abrupt jumps of the band edge. The Peltier part of the heat generation in the electron system at point $l$ due to tunneling from the conduction band at $u > l$ obeys an equation similar to Eq. 820, with $E_C(u^+) - \varepsilon$ replaced by $\varepsilon - E_C(l^-)$.

When the `Band2Band` option is used (see Table 236 on page 1560), Sentaurus Device also takes into account the band-to-band terms of the Peltier part of the heat generation at point $u$:

$$ H_{\text{Pelt,CV, }\nu}(u, l, \varepsilon) = [E_V(u^+) - \varepsilon] [R_{\text{CV, }\nu}(u, l, \varepsilon) - G_{\text{CV, }\nu}(u, l, \varepsilon)] \tag{821} $$

and, similarly, for the Peltier heat generation at point $l$.

The expressions for $H_{\text{Pelt,VV, }\nu}$ and $H_{\text{Pelt,VC, }\nu}$ are analogous to those for conduction band tunneling.

# References

[1] A. Schenk and G. Heiser, “Modeling and simulation of tunneling through ultra-thin gate dielectrics,” Journal of Applied Physics, vol. 81, no. 12, pp. 7900–7908, 1997.

[2] M. Ieong et al., “Comparison of Raised and Schottky Source/Drain MOSFETs Using a Novel Tunneling Contact Model,” in IEDM Technical Digest, San Francisco, CA, USA, pp. 733–736, December 1998.

24: Tunneling
References

[3] F. Li *et al.*, “Compact Model of MOSFET Electron Tunneling Current Through Ultra-thin SiO<sub>2</sub> and High-k Gate Stacks,” in *Device Research Conference*, Salt Lake City, UT, USA, pp. 47–48, June 2003.

[4] L. F. Register, E. Rosenbaum, and K. Yang, “Analytic model for direct tunneling current in polycrystalline silicon-gate metal–oxide–semiconductor devices,” *Applied Physics Letters*, vol. 74, no. 3, pp. 457–459, 1999.

References

