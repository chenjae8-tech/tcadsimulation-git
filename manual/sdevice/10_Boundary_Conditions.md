# CHAPTER 10 Boundary Conditions

*This chapter describes the boundary conditions available in Sentaurus Device.*

This chapter describe the properties of electrical contacts, thermal contacts, floating contacts, as well as boundary conditions at other borders of a domain where an equation is solved. Continuity conditions (how the solutions of one equation on two neighboring regions are matched at the region interface) are discussed elsewhere (see, for example, Dipole Layer on page 180). This chapter is restricted to the boundary conditions for the equations presented in Chapter 7 on page 179, Chapter 8 on page 189, and Chapter 9 on page 197. Boundary conditions for less important equations are discussed with the equations themselves (see, for example, Chapter 11 on page 245).

## Electrical Boundary Conditions

This section discusses electrical boundary conditions.

### Ohmic Contacts

By default, contacts on semiconductors are Ohmic, with no resistance. When connected to a circuit node, the resistance is activated by:

`Math { MixedModeContactResistance=<float> }`

The default is 0. In this case, a 0.001 resistance is added to the circuit node, which is not scaled with AreaFactor. If `<float>` > 0, then `<float>`×AreaFactor is added to the circuit node. The AreaFactor comes solely from the Physics section. The one from the Electrode section is ignored.

Charge neutrality and equilibrium are assumed at Ohmic contacts:

$$ n_0 - p_0 = N_D - N_A $$ (99)

$$ n_0 p_0 = n_{i,eff}^2 $$ (100)

Electrical Boundary Conditions

For Boltzmann statistics, these conditions can be expressed analytically:

$$ \phi = \phi_F + \frac{kT}{q} \text{asinh} \left( \frac{N_D - N_A}{2n_{i,\text{eff}}} \right) $$ (101)

$$ n_0 = \sqrt{\frac{(N_D - N_A)^2}{4} + n_{i,\text{eff}}^2} + \frac{N_D - N_A}{2} \qquad p_0 = \sqrt{\frac{(N_D - N_A)^2}{4} + n_{i,\text{eff}}^2} - \frac{N_D - N_A}{2} $$ (102)

where $n_0, p_0$ are the electron and hole equilibrium concentrations, and $\phi_F$ is the Fermi potential at the contact (which equals the applied voltage if it is not a resistive contact; see Resistive Contacts on page 223). For Fermi statistics, Sentaurus Device computes the equilibrium solution numerically.

By default, $n = n_0, p = p_0$ are applied for concentrations at the Ohmic contacts. If the electron or hole recombination velocity is specified, Sentaurus Device uses the following current boundary conditions:

$$ \vec{j}_n \cdot \hat{n} = qv_n(n - n_0) \qquad \vec{j}_p \cdot \hat{n} = -qv_p(p - p_0) $$ (103)

where $v_n, v_p$ are the electron and hole recombination velocities. In the command file, the recombination velocities can be specified as:

```
Electrode { ...
  { Name="Emitter" Voltage=0 eRecVelocity = vn hRecVelocity = vp }
}
```

**NOTE** If the values of the electron and hole recombination velocities equal zero ($v_n = 0, v_p = 0$), then $\vec{j}_n \cdot \hat{n} = 0, \vec{j}_p \cdot \hat{n} = 0$. That is, the electrode only defines the electrostatic potential (which is useful for SOI devices).

By specifying `Poisson=Neumann` for an electrode, the boundary condition for the Poisson equation at a contact can be switched to a homogeneous Neumann boundary condition, that is, Eq. 101 is not applied.

# Modified Ohmic Contacts

Ohmic contacts, as described in Ohmic Contacts on page 211, can often lead to incorrect results around p-n junctions and heterointerfaces. The main cause is the charge neutrality condition imposed at the contact vertices located within the charged depletion region of the p-n junction or heterointerface. Ideally, the carrier densities at such contacts should be an extension of bulk densities with no sharp jump along the contact.

10: Boundary Conditions

Electrical Boundary Conditions

Sentaurus Device supports an alternative for Ohmic contacts that does not impose the charge neutrality condition. In this approach, the equilibrium nonlinear Poisson equation is solved at the beginning of the simulation with the Ohmic contacts under consideration removed (see Equilibrium Solution on page 181 for setting numeric parameters to obtain the equilibrium solution). The equilibrium electrostatic potential $\phi_{eq}$ obtained in this way is used instead of the built-in potential $\phi_{bi} = kT \operatorname{asinh}[(N_D - N_A) / 2n_{i,eff}] / q$ on the vertices of the Ohmic contacts under consideration. The boundary conditions for the continuity equations remain formally the same as in the case of Ohmic contacts but with the built-in potential $\phi_{bi}$ replaced by $\phi_{eq}$.

You can set the modified Ohmic contacts in the `Electrode` section with the keyword `EqOhmic`:

```
Electrode {
  ...
  {Name="drain" Voltage=0 EqOhmic}
}
```

**NOTE** The feature is supported only for isothermal simulations.

# Contacts on Insulators

For contacts on insulators (for example, gate contacts), the electrostatic potential is:

$$ \phi = \phi_F - \Phi_{MS} $$ (104)

where $\phi_F$ is the Fermi potential at the contact (which equals the applied voltage if it is not a resistive contact; see Resistive Contacts on page 223), and $\Phi_{MS}$ is the workfunction difference between the metal and an intrinsic reference semiconductor.

> **NOTE** If an Ohmic contact touches both an insulator and a semiconductor, the electrostatic potential along the contact can be discontinuous because the boundary conditions (Eq. 101 and Eq. 104) usually contradict. Eq. 101 takes precedence over Eq. 104.

$\Phi_{MS}$ can be specified in the `Electrode` section, either directly with `Barrier`, by specifying the metal workfunction with `WorkFunction`, or by specifying the electrode material:

```
Electrode { ...
  { Name="Gate" Voltage=0 Barrier = 0.55 }
}
Electrode { ...
  { Name="Gate" Voltage=0 WorkFunction = 5 }
}
Electrode { ...
  { Name="Gate" Voltage=0 Material="Gold" }
}
```

Electrical Boundary Conditions

In the last case, the value for the workfunction is obtained from the parameter file:

```
Material = "Gold" {
  Bandgap { WorkFunction = 5 }
}
```

To emulate a poly gate, a semiconductor material and doping concentration can be specified in the Electrode section:

```
Electrode { ...
  { Name="Gate" Voltage=0 Material="Silicon" (N = 5e19) }
}
```

where `N` is used to specify the doping in an n-type semiconductor material. The built-in potential is approximated by $(kT/q) \ln(N/n_i)$. A p-type doping can be selected, similarly, by the letter `P`. If the value of the doping concentration is not specified (only `N` or `P`), the Fermi potential of the electrode is assumed to equal the conduction or valence band edge.

# Schottky Contacts

The physics of Schottky contacts is considered in detail in [1] and [2]. In this section, a typical model for Schottky contacts [3] is considered. The following boundary conditions hold:

$$ \phi = \phi_F - \Phi_B + \frac{kT}{q} \ln \left( \frac{N_C}{n_{i,\text{eff}}} \right) $$ (105)

$$ \vec{J}_n \cdot \hat{n} = qv_n(n - n_0^B) \quad \vec{J}_p \cdot \hat{n} = -qv_p(p - p_0^B) $$ (106)

$$ n_0^B = N_C \exp \left( \frac{-q\Phi_B}{kT} \right) \quad p_0^B = N_V \exp \left( \frac{-E_{g,\text{eff}} + q\Phi_B}{kT} \right) $$ (107)

where:

* $\phi_F$ is the Fermi potential at the contact that is equal to an applied voltage $V_{\text{applied}}$ if it is not a resistive contact (see Resistive Contacts on page 223).

* $\Phi_B$ is the barrier height (the difference between the contact workfunction and the electron affinity of the semiconductor in n-type semiconductors, or the difference between the band gap and the barrier as defined for n-type semiconductors in the case of p-type semiconductors).

* $v_n$ and $v_p$ are the thermionic emission velocities.

* $n_0^B$ and $p_0^B$ are the equilibrium densities.

## Electrical Boundary Conditions

The default values for the thermionic emission velocities $v_n$ and $v_p$ are $2.573 \times 10^6$ cm/s and $1.93 \times 10^6$ cm/s, respectively.

The recombination velocities can be set in the `Electrode` section. For example:

```
Electrode { ...
  { Name="Gate" Voltage=0 Schottky Barrier = ΦB eRecVelocity = vn
    hRecVelocity = vp }
}
```

> **NOTE** The `Barrier` specification might produce incorrect results if the Schottky contact is connected to several different semiconductors. In such cases, use `WorkFunction` instead of `Barrier`. See Contacts on Insulators on page 213 for details.

Sentaurus Device also allows thermionic emission velocities $v_n$ and $v_p$ to be defined as functions of lattice temperature:

$$ v_n(T) = v_n(300\text{ K}) \sqrt{\frac{m_n(300\text{ K})}{m_n(T)}} \sqrt{\frac{T}{300\text{ K}}} \quad v_p(T) = v_p(300\text{ K}) \sqrt{\frac{m_p(300\text{ K})}{m_p(T)}} \sqrt{\frac{T}{300\text{ K}}} \quad (108) $$

where:

* $m_n$ and $m_p$ are the temperature-dependent electron and hole density-of-states (DOS) effective masses.

* $v_n(300\text{ K})$ and $v_p(300\text{ K})$ are the recombination velocities at 300 K specified in the `Electrode` section by `eRecVelocity` and `hRecVelocity`.

The default values for the thermionic emission velocities $v_n(300\text{ K})$ and $v_p(300\text{ K})$ are $2.573 \times 10^6$ cm/s and $1.93 \times 10^6$ cm/s, respectively.

To activate the temperature-dependent recombination velocity, specify `eRecVel(TempDep)`, or `hRecVel(TempDep)`, or `RecVel(TempDep)` in the electrode-specific `Physics` section:

```
Physics (Electrode = "cathode") { RecVel(TempDep) }
```

## Fermi-Level Pinning at Schottky Contacts

At a metal semiconductor contact or interface, there is a charge transfer between the metal and the interface states located inside the semiconductor bandgap. The charge transfer creates an interfacial dipole, which can change the Schottky barrier. This phenomenon, known as Fermi-level pinning, can be modeled by a Schottky pinning parameter $S$.

Electrical Boundary Conditions

The Schottky potential barrier accounting for the correction due to the charge transfer between the metal and the interface states in the semiconductor bandgap (pinning effect) is modeled as:

$$ \Phi_{\text{B}} = S \left( \Phi_{\text{M}} - \frac{E_{\text{CNL}}}{q} \right) + \left( \frac{E_{\text{CNL}}}{q} - \frac{\chi}{q} \right) $$ (109)

where:

*   $\Phi_{\text{M}}$ is the metal workfunction in V.

*   $E_{\text{CNL}}$ is the charge neutrality level with respect to the vacuum level in eV.

*   $S$ is the Schottky pinning parameter. For $S = 1$ (no pinning), there is no charge transfer, and the Schottky barrier becomes the classical Schottky limit. For $S = 0$ (strong pinning), you obtain the Bardeen limit where the metal Fermi level is pinned by the interface states at $E_{\text{CNL}}$.

The models available in Sentaurus Device for the Schottky pinning parameter $S$ are the Sze model and the Mönch model.

The Sze model is defined as [4]:

$$ S = \frac{1}{1 + \frac{q^2 (N_{\text{I}} d)}{\varepsilon \varepsilon_0}} $$ (110)

where $\varepsilon$ is the semiconductor permittivity, $N_{\text{I}}$ is the density of interface states per unit energy, and $d$ is their extent into the semiconductor. The parameters $N_{\text{I}}$ and $d$ are mole fraction dependent and can be modified in the Schottky section of the parameter file.

The Mönch model, which is the default, is an empirical formula and is defined as [5]:

$$ S = \frac{1}{1 + A(\varepsilon_{\infty} - 1)^B} $$ (111)

where $\varepsilon_{\infty}$ is the high-frequency limit of the permittivity (set to 12 for most materials), and $A$ and $B$ are mole fraction–adjustable parameters that you can modify in the Schottky section of the parameter file. You can set $\varepsilon_{\infty}$ in the `Epsilon_Inf` section of the parameter file:

```
Epsilon_Inf { epsilon_inf = 12 }
```

The charge neutrality level $E_{\text{CNL}}$ is also a mole fraction–dependent parameter adjustable in the parameter file.

> **NOTE** In general, $\varepsilon_{\infty}$ is tabulated for standard materials, so $S$ can be reliably determined from Eq. 111 for those materials. Using the $S$ equivalency between Eq. 110 and Eq. 111 values for $N_{\text{I}} d$ can be inferred.

10: Boundary Conditions

Electrical Boundary Conditions

To activate the pinning effect at the Schottky contacts, specify the `Pinning` keyword in the `Electrode` section, with the model defined as an option for the keyword `Model`:

```
Electrode { ...
   { name = "cnt1" voltage = 0 Schottky(Pinning(Model="Sze"))
      Workfunction=4.75 }
}
```

If the keyword `Model` is omitted, the Mönch model is used. The pinning model specification in the `Electrode` section has a higher priority. If the pinning model is specified in both the `Electrode` section and the electrode `Physics` section, the specification in the `Electrode` section is chosen.

The pinning model parameters in Eq. 110 and Eq. 111 are accessible in the `Schottky` subsection in the `Electrode` section of the parameter file.

Table 29 Parameters and their default values for Schottky pinning

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| A | Pinning_A | 0.1 | 1 |
| B | Pinning_B | 2 | 1 |
| NI | Pinning_Nint | 1010 | cm–2 eV–1 |
| d | Pinning_d | 2×10–7 | cm |
| ECNL | Pinning_CNL | 5.01964 | eV |

For example, to specify a mole fraction–dependent CNL on the contact `drain`, which is on the top of a mole fraction–dependent SiGe region `r3` defined as:

```
Physics(Region = "r3") { # Ge(x)Si(1-x)
* Mole-dependent material: SiGe(x=0) = Silicon
* Mole-dependent material: SiGe(x=1) = Germanium
   MoleFraction(
      xFraction=0.35
   )
}
```

specify in the parameter file something like:

```
Region = "r3" {
   Schottky {
      Xmax(0)=0.0
      Xmax(1)=0.8
      Xmax(2)=1.0

      Electrode = "drain" {
         Pinning_CNL(0) = 3.5
```

Electrical Boundary Conditions

```
                        Pinning_CNL(1) = 3.7
                        Pinning_CNL(2) = 3.8
                }
            }
        }
```

See Resistive Contacts on page 223 for a detailed description on how to specify mole-fraction parameters on contacts and interfaces.

## Barrier Lowering at Schottky Contacts

The barrier-lowering model for Schottky contacts can account for different physical mechanisms. The most important one is the image force [3], but it can also model tunneling and dipole effects.

The barrier lowering seen by the electron being emitted from metal into the conduction band and for the hole being emitted into the valence are given by:

$$ \Delta\Phi_{\text{B,e}}(\vec{F}) = \begin{cases} aa_{1, \text{e}} \left( \frac{\vec{F} \cdot \hat{n}}{F_0} \right)^{pp_{1, \text{e}}} + aa_{2, \text{e}} \left( \frac{\vec{F} \cdot \hat{n}}{F_0} \right)^{pp_{2, \text{e}}} & \text{if } \vec{F} \cdot \hat{n} > 0 \\ 0 & \text{if } \vec{F} \cdot \hat{n} \le 0 \end{cases} \text{ (112)} $$

$$ \Delta\Phi_{\text{B,h}}(\vec{F}) = \begin{cases} aa_{1, \text{h}} \left( \frac{\vec{F} \cdot \hat{n}}{F_0} \right)^{pp_{1, \text{h}}} + aa_{2, \text{h}} \left( \frac{\vec{F} \cdot \hat{n}}{F_0} \right)^{pp_{2, \text{h}}} & \text{if } \vec{F} \cdot \hat{n} \le 0 \\ 0 & \text{if } \vec{F} \cdot \hat{n} > 0 \end{cases} \text{ (113)} $$

where:

*   $\vec{F} \cdot \hat{n}$ is the normal component of the electric field on the local exterior normal pointing from semiconductor region to metal contact, $F_0 = 1 \text{ Vcm}^{-1}$.

*   $aa_{1, \text{e}}$, $aa_{2, \text{e}}$, $pp_{1, \text{e}}$, $pp_{2, \text{e}}$, $aa_{1, \text{h}}$, $aa_{2, \text{h}}$, $pp_{1, \text{h}}$, $pp_{2, \text{h}}$ are the model coefficients that can be specified in the parameter file of Sentaurus Device. Their default values are $aa_{1, \text{e}} = aa_{1, \text{h}} = 2.6 \times 10^{-4} \text{ eV}$, $pp_{1, \text{e}} = pp_{1, \text{h}} = 0.5$, $aa_{2, \text{e}} = aa_{2, \text{h}} = 0 \text{ eV}$, and $pp_{2, \text{e}} = pp_{2, \text{h}} = 1$.

The final value of the Schottky barrier is computed as $\Phi_{\text{B}} - \Delta\Phi_{\text{B,e}}(\vec{F})$ for the electrons in the conduction band and as $\Phi_{\text{B}} + \Delta\Phi_{\text{B,h}}(\vec{F})$ for the holes in the valence band. The barrier lowering also affects the equilibrium concentration of electrons $n_{\text{B}}^0$ and holes $p_{\text{B}}^0$ corresponding to its formula (Eq. 107), through the correction in barrier $\Phi_{\text{B}}$ described above.

**10: Boundary Conditions**
Electrical Boundary Conditions

In addition, Sentaurus Device implements a simplified model for barrier lowering. In this case, the barrier lowering is:

$$ \Delta\Phi_{\text{B}}(F) = \begin{cases} a_1 \left[ \left( \frac{F}{F_0} \right)^{p_1} - \left( \frac{F_{\text{eq}}}{F_0} \right)^{p_{1, \text{eq}}} \right] + a_2 \left[ \left( \frac{F}{F_0} \right)^{p_2} - \left( \frac{F_{\text{eq}}}{F_0} \right)^{p_{2, \text{eq}}} \right] & \text{if } F > \eta F_{\text{eq}} \\ 0 & \text{if } F \leq \eta F_{\text{eq}} \end{cases} $$ (114)

where:

*   $F_0 = 1 \text{ Vcm}^{-1}$.

*   $F_{\text{eq}}$ is the equilibrium electric field (see Equilibrium Solution on page 181 for setting numeric parameters to obtain the equilibrium solution).

*   $a_1, a_2, p_1, p_{1, \text{eq}}, p_2, \text{ and } p_{2, \text{eq}}$ are the model coefficients that can be specified in the parameter file of Sentaurus Device. Their default values are $a_1 = 2.6 \times 10^{-4} \text{ eV}$, $a_2 = 0 \text{ eV}$, $p_1 = p_{1, \text{eq}} = 0.5$, and $p_2 = p_{2, \text{eq}} = 1$.

For fields smaller than $\eta F_{\text{eq}}$ (where $\eta$ is one by default), barrier lowering is zero. The final value of the Schottky barrier is computed as $\Phi_{\text{B}} - \Delta\Phi_{\text{B}}(F)$ for n-doped contacts and $\Phi_{\text{B}} + \Delta\Phi_{\text{B}}(F)$ for p-doped contacts, because a difference between the metal workfunction and the valence band must be considered if holes are majority carriers. This model does not account for the direction of the electric field that determines in which band the barrier forms. For example, assume a Schottky contact on an n-type semiconductor with Schottky barrier 0.8 V. The flat band condition is at a forward bias of approximately 0.8 V. For a reverse bias and forward bias less than 0.8 V, the barrier is in the conduction band, so the barrier lowering is applied correctly for electrons. On the other hand, for a forward bias greater than 0.8 V, the barrier is now in the valence band, so the barrier lowering should be applied to holes, not to electrons as the model does. In this case, this simplified model fails. This model is tuned to work properly for reverse biases, where the barrier lowering produces a sizable change in I–V characteristics of the Schottky device.

You can use the `weight` parameter to combine one of the barrier models with the barrier lowering with interfacial insulator layer model described by Eq. 115. If the barrier-lowering model is the only model specified (no interfacial insulator layer model), the value of `weight` is 1 regardless of the value specified in the parameter file by `c_weight`.

Table 30 Parameters and their default values for barrier-lowering models

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| $aa_{1, e}$ | aa1 | $a_1 = 2.6 \times 10^{-4}$ | eV |
| $aa_{1, h}$ | aa1 | $a_1 = 2.6 \times 10^{-4}$ | eV |
| $aa_{2, e}$ | aa2 | 0 | eV |
| $aa_{2, h}$ | aa2 | 0 | eV |

Electrical Boundary Conditions

Table 30 Parameters and their default values for barrier-lowering models (Continued)

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| pp1, e | pp1 | 0.5 | 1 |
| pp1, h | pp1 | 0.5 | 1 |
| pp2, e | pp2 | 1 | 1 |
| pp2, h | pp2 | 1 | 1 |
| a1 | a1 | a1 = 2.6 × 10−4 | eV |
| a2 | a2 | 0 | eV |
| p1 | p1 | 0.5 | 1 |
| p2 | p2 | 1 | 1 |
| p1, eq | p1_eq | 0.5 | 1 |
| p2, eq | p2_eq | 1 | 1 |
| η | eta | 1 | 1 |
| weight | c_weight | 1 | 1 |

To activate the barrier-lowering model, specify BarrierLowering in the electrode-specific Physics section for the simplified model:

```
Physics(Electrode = "Gate") { BarrierLowering }
```

For the complete model, specify:

```
Physics(Electrode = "Gate") { BarrierLowering(Full) }
```

To specify parameters of the model, create the following parameter set:

```
Electrode = "Gate"{
    BarrierLowering {
        a1 = a₁             * [eV]
        p1 = p₁             * [1]
        p1_eq = p1, eq      * [1]
        a2 = a₂             * [eV]
        p2 = p₂             * [1]
        p2_eq = p2, eq
        eta = η             * [1]
        aa1 = aa1,e , aa1,h * [eV]
        pp1 = pp1,e , pp1,h * [1]
        aa2 = aa2,e , aa2,h * [eV]
        pp2 = pp2,e , pp2,h * [1]
    }
}
```

10: Boundary Conditions

Electrical Boundary Conditions

To emulate the barrier-lowering effect at a metal-semiconductor contact, with a thin virtual interfacial layer between the metal and the semiconductor, Sentaurus Device supports another barrier-lowering model that takes into account such an insulating interface layer. The model [[6]]([6]) assumes that a finite insulator layer is present between the metal and the semiconductor, and it includes both images with respect to the metal–insulator and insulator–semiconductor interfaces.

Sentaurus Device implements the barrier lowering with interfacial insulating layer model described in detail in [[6]]([6]) as:

$$
\Delta\Phi_{\text{B}}(d_0) = \begin{cases} \frac{q}{16\pi\varepsilon_{\text{ins}}} \left( \frac{1}{d_{\varepsilon}} + \frac{\beta}{t_{\text{ox}} - d_{\varepsilon}} \right) & 0 \le d_0 \le d_{\varepsilon} \\ \frac{q}{16\pi\varepsilon_{\text{ins}}} \left( \frac{1}{d_0} + \frac{\beta}{t_{\text{ox}} - d_0} \right) & d_{\varepsilon} < d_0 \le t_{\text{ox}} - d_{\varepsilon} \\ \frac{q}{16\pi\varepsilon_{\text{ins}}} \left( \frac{1}{t_{\text{ox}} - d_{\varepsilon}} + \frac{\beta}{d_{\varepsilon}} \right) - A \frac{t_{\text{ox}} - d_{\varepsilon}}{2d_{\varepsilon}} + \frac{A}{2d_{\varepsilon}} d_0 & t_{\text{ox}} - d_{\varepsilon} < d_0 \le t_{\text{ox}} + d_{\varepsilon} \\ \frac{q}{16\pi\varepsilon_{\text{sem}}} \left( \frac{1}{d_0} + \frac{\beta}{t_{\text{ox}} - d_0} \right) & d_0 > t_{\text{ox}} + d_{\varepsilon} \end{cases} \quad (115)
$$

where:

*   $\beta = \frac{\varepsilon_{\text{sem}} - \varepsilon_{\text{ins}}}{\varepsilon_{\text{sem}} + \varepsilon_{\text{ins}}}$

*   $A = \frac{q}{16\pi\varepsilon_{\text{sem}}} \left( \frac{1}{t_{\text{ox}} + d_{\varepsilon}} - \frac{\beta}{d_{\varepsilon}} \right) - \frac{q}{16\pi\varepsilon_{\text{ins}}} \left( \frac{1}{t_{\text{ox}} - d_{\varepsilon}} + \frac{\beta}{d_{\varepsilon}} \right)$.

*   $\varepsilon_{\text{sem}}$ is the semiconductor layer permittivity.

*   $\varepsilon_{\text{ins}}$ is the insulator layer permittivity.

*   $t_{\text{ox}}$ is the conforming insulator layer thickness.

*   $d_0$ is the distance from the metal surface (contact) to the point where the barrier lowering is evaluated.

*   $d_{\varepsilon}$ is a computational-adjustable parameter used to handle critical points in the model.

The second branch in Eq. 115 represents the barrier lowering due to the image-force potential of the electron in the insulator layer, where a numeric adjustment is applied to the edges of the layer to avoid infinite values. The first branch is introduced to saturate the value of the image-force potential close to the metal surface (contact), which otherwise would become infinite for $d_0 \to 0$. The last branch represents the barrier lowering due to the image-force potential of the electron in the semiconductor layer.

To avoid discontinuity and infinite values at the insulator–semiconductor interface, a linear transitional region is introduced (the third branch).

Electrical Boundary Conditions

The $d_{\varepsilon}$ parameter, which should be smaller than $t_{ox}$ for geometric reasons, allows you to adjust the functional shape of the model around the model critical points).

For consistency, when $t_{ox} = 0$, the model reverts to $\Delta\Phi_B(d_0, d_0 > 0) = \frac{q}{16\pi\varepsilon_{sem}d_0}$, which is the typical image-force barrier lowering for a metal–semiconductor interface.

As an option, you can select to compute a barrier-lowering average based on Eq. 115 over the distance $d_o$ from the contact or an average around $d_o$.

The barrier lowering with interfacial insulator layer model can be combined as a weighted sum with any of the barrier-lowering models described by Eq. 112 (or Eq. 113) or Eq. 114, but not with both.

To activate the barrier lowering with interfacial insulator layer model, specify `InsBarrierLowering` in the `Schottky` subsection of the `Electrode` or the electrode-specific `Physics` section:

```
Electrode { ...
   { name = "cnt1" voltage = 0 Schottky(InsBarrierLowering))
    Workfunction=4.75 }
}
Physics(Electrode = "cnt1") { ...
   Schottky(InsBarrierLowering)
}
```

To compute an average based on Eq. 115 over the distance $d_o$, specify also the keyword `Average`:

```
Physics(Electrode = "Gate") { InsBarrierLowering(Average) }
```

To compute an average based on Eq. 115 over a symmetric interval `delta`, centered around $d_o$, specify the keyword `DeltaAverage` in the `InsBarrierLowering` section of the command file:

```
Physics(Electrode = "Gate") { InsBarrierLowering(DeltaAverage) }
```

You can adjust the parameter `InsBL_delta` in the `Schottky` section of the parameter file:

```
Electrode = "anode" {
   Schottky {
       InsBL_delta = 1.0000e-08    * [cm]
   }
}
```

The model parameters $t_{ox}$, $\varepsilon_{ins}$, $d_{\varepsilon}$, $d_0$, and `nn` can be specified in the `Schottky` section of the parameter file (see Table 31 on page 223). The parameter `nn` controls the number of equidistant intervals over which the integration is performed using the trapezoidal rule in the case of averaging. The $t_{ox}$, $\varepsilon_{ins}$, and $d_{\varepsilon}$ parameters are mole fraction dependent.

10: Boundary Conditions

Electrical Boundary Conditions

You can use the `weight` parameter to combine the barrier lowering with the interfacial insulator layer model with either the barrier model described by Eq. 112 (or Eq. 113) or Eq. 114. If only the barrier lowering with interfacial insulator layer model is specified (by `InsBarrierLowering` in the electrode-specific `Physics` section), the value of `weight` is 1 regardless of the value specified in the parameter file by `InsBL_c_weight`. If the model is used together with other barrier-lowering models, the `weight` parameters in both models can be adjusted individually such that their sum is 1. The overall barrier-lowering effect would be a weighted sum of the models.

Table 31 Parameters of barrier lowering with interfacial insulator layer model

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| tox | InsBL_tox | 2 × 10−7 | cm |
| εins | InsBL_epsins | 3.9 | 1 |
| d0 | InsBL_d0 | 1 × 10−7 | cm |
| dε | InsBL_d_eps | 1 × 10−8 | cm |
| nn | InsBL_nn | 20 | 1 |
| weight | InsBL_c_weight | 1 | 1 |
| delta | InsBL_delta | 1 × 10−8 | cm |

# Resistive Contacts

By default, contacts have a resistance of 1 mΩ when they are connected to a circuit node, and no resistance otherwise. The resistance can be changed with `Resist` or `DistResist` or both in the `Electrode` section.

The following example defines an emitter as a contact with resistance 1 Ω (assuming that `AreaFactor` is one):

```
Electrode { ...
  { name = "emitter" voltage = 2 Resist=1 }
}
```

The following example defines an emitter as a contact with a distributed resistance of 0.0002 Ωcm² in series with a 100 Ω lump resistor, with the 2 V external voltage applied to the lump resistor:

```
Electrode { ...
  { name = "emitter" voltage = 2 Resist=100 DistResist=2e-4 }
}
```

Electrical Boundary Conditions

If $V_{\text{applied}}$ is applied to the contact through a resistor $R$ (`Resist` in the `Electrode` section) or distributed resistance $R_{\text{d}}$ (`DistResist` in the `Electrode` section), there is an additional equation to compute $\phi_{\text{F}}$ in Eq. 101, Eq. 104, and Eq. 105.

For a distributed resistance, $\phi_{\text{F}}$ is different for each mesh vertex of the contact and is computed as a solution of the following equation for each contact vertex, self-consistently with the system of all equations:

$$ \hat{n} \cdot [\vec{J}_{\text{p}}(\phi_{\text{F}}) + \vec{J}_{\text{n}}(\phi_{\text{F}}) + \vec{J}_{\text{D}}(\phi_{\text{F}})] = \frac{(V_{\text{applied}} - \phi_{\text{F}})}{R_{\text{d}}} \tag{116} $$

For a resistor, $\phi_{\text{F}}$ is a constant over the contact and only one equation per contact is solved self-consistently with the system of all equations:

$$ \int_{s} \hat{n} \cdot [\vec{J}_{\text{p}}(\phi_{\text{F}}) + \vec{J}_{\text{n}}(\phi_{\text{F}}) + \vec{J}_{\text{D}}(\phi_{\text{F}})] ds = \frac{(V_{\text{applied}} - \phi_{\text{F}})}{R} \tag{117} $$

where $s$ is a contact area used in a Sentaurus Device simulation to compute a total current through the contact.

When both a lump resistor $R$ and a distributed resistance $R_{\text{d}}$ are specified, $\phi_{\text{F}}$ is computed for each mesh vertex of the contact as a solution of the following equations, self-consistently with the system of all equations:

$$ \hat{n} \cdot [\vec{J}_{\text{p}}(\phi_{\text{F}}) + \vec{J}_{\text{n}}(\phi_{\text{F}}) + \vec{J}_{\text{D}}(\phi_{\text{F}})] = \frac{(V_{\text{internal}} - \phi_{\text{F}})}{R_{\text{d}}} \tag{118} $$

$$ \frac{V_{\text{applied}} - V_{\text{internal}}}{R} = \int_{s} \frac{V_{\text{internal}} - \phi_{\text{F}}}{R_{\text{d}}} ds \tag{119} $$

where $V_{\text{internal}}$ depends on $\phi_{\text{F}}$ along the contact (on all contact vertices) and $\int_{s} \frac{V_{\text{internal}} - \phi_{\text{F}}}{R_{\text{d}}} ds$ is the total current on the contact.

**NOTE** In 2D simulations, $R$ must be specified in units of $\Omega\mu\text{m}$. In 3D simulations, $R$ must be specified in units of $\Omega$. $R_{\text{d}}$ is given in $\Omega\text{cm}^{2}$ (see Table 201 on page 1512).

To emulate the behavior of a Schottky contact [[7]](https://example.com/ref7), Schottky contact resistivity at zero bias was derived and a doping-dependent resistivity model of such contacts was obtained. This model is activated for Ohmic contacts by the keyword `DistResist=SchottkyResist` in the `Electrode` section.

10: Boundary Conditions
Electrical Boundary Conditions

The model is expressed as:

$$ R_d = R_{\infty} \frac{300\text{ K}}{T_0} \exp \left( \frac{q\Phi_B}{E_0} \right) $$
$$ E_0 = E_{00} \text{coth} \left( \frac{E_{00}}{kT_0} \right) \eqno(120) $$
$$ E_{00} = \frac{qh}{4\pi} \sqrt{\frac{|N_{D,0} - N_{A,0}|}{\varepsilon_s m_t}} $$

where:

*   $\Phi_B$ is the Schottky barrier (in this model, for electrons, this is the difference between the metal workfunction and the electron affinity of the semiconductor; for holes, this is the difference between the valence band energy of the semiconductor and the metal workfunction).

*   $R_{\infty}$ is the Schottky resistance for an infinite doping concentration at the contact (or zero Schottky barrier).

*   $\varepsilon_s$ is the semiconductor permittivity.

*   $m_t$ is the tunneling mass.

*   $T_0$ is the device lattice temperature defined in the `Physics` section (see Table 231 on page 1547).

The parameters $\Phi_B$, $R_{\infty}$, and $m_t$ can be mole dependent, and they can be specified in the region or material sections of the parameter file. If the parameters are mole independent, they also can be specified directly in the `Electrode` section of the parameter file.

For example, if the contact "top" covers two semiconductor regions "reg1" and "reg2", the mole dependency of parameter $R_{\infty}$ can be defined as:

```
Region = "reg1" {
  SchottkyResistance {
    Xmax(0) = 0.0
    Xmax(1) = 0.6
    Electrode = "top" {
      Rinf = 2.4000e-09 , 5.2000e-09    # [Ohm*cm^2]
      Rinf(1) = 2.5000e-09 , 5.2000e-09 # [Ohm*cm^2]
    }
  }
}

Region = "reg2" {
  SchottkyResistance {
    Xmax(0) = 0.0
    Xmax(1) = 0.1
    Xmax(2) = 0.6
    Electrode = "top" {
```

Electrical Boundary Conditions

```
        Rinf = 2.5000e-09 , 5.2000e-09    # [Ohm*cm^2]
        Rinf(1) = 2.6000e-09 , 5.2000e-09 # [Ohm*cm^2]
        Rinf(2) = 2.9000e-09 , 5.2000e-09 # [Ohm*cm^2]
      }
    }
  }
```

In the example, the parameter $R_{\infty}$ of contact "top" is defined in "reg1" and "reg2" with different mole dependencies.

If the Schottky resistance parameters are not mole fraction dependent, the parameters can be specified regionwise or materialwise in the SchottkyResistance section:

```
Region = "reg1" {
  SchottkyResistance {
    Rinf = 2.4000e-09 , 5.2000e-09 # [Ohm*cm^2]
  }
}
```

For backward compatibility, the Schottky resistance parameters that are not mole fraction dependent also can be defined directly in the Electrode section of the Schottky resistive contact:

```
Electrode = "gate" {
  # no mole fraction dependency allowed
  SchottkyResistance {
    Rinf = 2.4000e-09 , 5.2000e-09 # [Ohm*cm^2]
    PhiB = 0.6        , 0.51       # [eV]
  }
}
```

When multiple definitions of the Schottky resistance parameters are found in the parameter file, a priority scheme is used:

1. If a Region section contains a SchottkyResistance subsection with an Electrode specification, then the parameters specified here are chosen.

2. If there is no Region section with a SchottkyResistance subsection having an Electrode specification, then Material sections are searched next. If a Material section contains a SchottkyResistance subsection with an Electrode specification, then the parameters specified are chosen.

3. If there is no Region section or Material section with a SchottkyResistance subsection having an Electrode specification, only constant parameters can be specified. First, the global Electrode sections are searched for constant parameters:

```
Electrode = "gate" {
  # no mole fraction dependency allowed
  SchottkyResistance {
```

10: Boundary Conditions

Electrical Boundary Conditions

```
        Rinf = 2.4000e-09 , 5.2000e-09  # [Ohm*cm^2]
    }
}
```

If this section is found, then the parameters here are chosen. If not, a `Region` section with a `SchottkyResistance` subsection and constant parameters is searched for:

```
Region = "reg1" {
    SchottkyResistance {
        Rinf = 2.4000e-09 , 5.2000e-09  # [Ohm*cm^2]
    }
}
```

If a `Region` section is found, then the parameters are chosen here. If not, a `Material` section with a `SchottkyResistance` subsection and constant parameters is the last possible specification:

```
Material = "Silicon" {
    SchottkyResistance {
        Rinf = 2.4000e-09 , 5.2000e-09  # [Ohm*cm^2]
    }
}
```

4. If nothing is specified at all, then the default values are chosen, with their values:

a) $m_t = 0.19$, $R_\infty = 2.4 \times 10^{-9} \Omega\text{cm}^2$, $\Phi_B = 0.6 \text{ eV}$ for electrons

b) $m_t = 0.19$, $R_\infty = 5.2 \times 10^{-9} \Omega\text{cm}^2$, $\Phi_B = 0.51 \text{ eV}$ for holes <sup>[7]</sup>

These parameters can be specified independently in different sections as previously described. The priority scheme is applied independently of each of them.

When multiple regions are connected to a Schottky resist contact, the value of the Schottky resistance at the common vertices on the contact is taken as a maximum of the region Schottky resistances. In other words, the Schottky resistance at the common vertices is computed for each region with the region parameters, and the maximum value among regions is chosen.

In the case of alloys, parameters are interpolated from the composing materials. For example, in the case of Ge<sub>x</sub>Si<sub>1-x</sub>, the value of $R_\infty$ is computed from the two side materials and the corresponding mole-fraction specification. The command file is:

```
Physics (Material = "SiliconGermanium") {  # Gex(x)Si(1-x)
  * Mole fraction material: SiGe(x=0) = Silicon
  * Mole fraction material: SiGe(x=1) = Germanium
  MoleFraction(
    xFraction = 0.35
  )
}
```

Electrical Boundary Conditions

The parameter file is:

```
Material = "Silicon" {
    SchottkyResistance {
        Rinf = 2.3000e-09 , 5.1000e-09 # [Ohm*cm^2]
    }
}

Material = "Germanium" {
    SchottkyResistance {
        Rinf = 2.4000e-09 , 5.0000e-09 # [Ohm*cm^2]
    }
}
```

The model is applied to each contact vertex and checks the sign of the doping concentration $N_{D,0} - N_{A,0}$. If the sign is positive, the electron parameters are used to compute $R_d$ for the vertex. If the sign is negative, the hole parameters are used.

As an option, you can specify a constant metal workfunction parameter instead of a mole fraction–dependent Schottky barrier parameter $\Phi_B$. In this case, Sentaurus Device computes the Schottky barrier $\Phi_B$ in Eq. 120 as the difference between the specified contact workfunction and the electron affinity of the semiconductor (in the case of n-type semiconductors), or as the difference between the valence band energy and the contact workfunction (in the case of p-type semiconductors). Although only a constant contact workfunction is allowed, the computed Schottky barrier $\Phi_B$ captures the mole-fraction dependency more physically through the electron affinity and the bandgap mole-fraction dependencies.

To use the metal contact workfunction option to compute the Schottky barrier $\Phi_B$, specify the `Workfunction` keyword in the `SchottkyResistance` subsection, of the `Electrode` section, of the parameter file. For example, to compute the Schottky barrier $\Phi_B$ corresponding to a 4.1 eV workfunction at the contact `top2`, specify in the parameter file:

```
Electrode = "top2" {
    SchottkyResistance {
        # PhiB = 0.6 , 0.51    # [eV]
        Workfunction = 4.1
    }
}
```

In this case, the values of the Schottky barrier $\Phi_B$ in the parameter file (if specified by `PhiB`) are ignored because they are internally computed.

For convenience, you can also specify the workfunction in the contact section of the region or material:

```
Region = "reg2" {
    SchottkyResistance {
```

10: Boundary Conditions

Electrical Boundary Conditions

```
        Workfunction = 4.1
        Xmax(0) = 0.0
        Xmax(1) = 0.1
        Xmax(2) = 0.6
        Electrode = "top" {
          Rinf = 2.5000e-09 , 5.2000e-09         # [Ohm*cm^2]
          Rinf(1) = 2.6000e-09 , 5.2000e-09 # [Ohm*cm^2]
          Rinf(2) = 2.9000e-09 , 5.2000e-09 # [Ohm*cm^2]
        }
    }
  }
```

In this case, note that the workfunction is applied to `reg2` only. If the contact extends over multiple regions, the workfunction can be activated only in certain regions by explicitly specifying `Workfunction` in the respective region.

When the workfunction is specified in both the `Electrode` section and the `Region` or `Material` sections, the `Electrode` section takes precedence.

A more general model for Schottky resistance can be implemented using the Schottky resistance PMI (see Schottky Resistance on page 1399). In this case, Schottky-distributed resistance $R_d$ can be an arbitrary function of lattice temperature, electron temperature, hole temperature, electron affinity, band gap, bandgap narrowing, conduction-band effective density-of-states, valence-band effective density-of-states, and effective intrinsic density, $R_d = R_d(T, T_n, T_p, \chi, E_g, E_{bgn}, N_C, N_V, n_{i,eff})$. The PMI model can access the built-in Schottky resistance model parameters (constant or mole fraction–dependent) using the vertex-based PMI support function `InitModelParameter()` (see Runtime Support for Vertex-Based PMI Models on page 1194).

# Resistive Interfaces

The distributed resistance interface model is supported for metal–semiconductor and metal–metal interfaces only. The interfaces are treated as discontinuous double-point interfaces.

To activate the model, specify the keyword `DistResist` in the `Physics` section of the resistive interface:

```
  Physics (MaterialInterface="AlGaAs/Aluminum") {
    DistResist=1e-3
  }
```

Like Schottky contacts, the behavior of a Schottky interface can be emulated using the doping-dependent resistivity model described by Eq. 120, p. 225. The model is activated for Ohmic

Electrical Boundary Conditions

metal–semiconductor interfaces by the keyword `DistResist=SchottkyResistance` in the Physics section of the interface:

```
Physics(MaterialInterface="AlGaAs/Aluminum") {
      DistResist=SchottkyResistance
}
```

The Schottky resistance parameters can be mole dependent or constant. When the parameter file contains multiple definitions of the Schottky resistance parameters, the same priority scheme used for contacts is applied.

As for the contacts, you can specify a constant metal workfunction parameter instead of a mole fraction–dependent Schottky barrier parameter $\Phi_B$. The syntax is similar to contacts, but the `Workfunction` keyword must be specified in the `RegionInterface` section or the `MaterialInterface` section instead of the `Electrode` section.

The `DistResist` model is the default for distributed interface resistance simulations. However, to improve convergence performance, an alternative model is available. To activate this alternative model at the metal–semiconductor interface, specify `MSDistResist=<float>` or `MSDistResist=SchottkyResistance` in the Physics section, as follows:

```
Physics(MaterialInterface="AlGaAs/Aluminum") {
      MSDistResist=1e-3
}

Physics(MaterialInterface="AlGaAs/Aluminum") {
      MSDistResist=SchottkyResistance
}
```

A doping-dependent Schottky barrier model is supported for metal–semiconductor Schottky barriers. Image force lowering of the potential energy barrier is included in Schottky contacts. The model is based on the distributed resistance interface model. The Schottky barrier height is dependent on the doping on the semiconductor side.

**NOTE** This model works at the metal–semiconductor interface. It does not work for contacts.

The effects of image force rounding of the potential energy barrier are included. The magnitude of the bias-dependent image force lowering ($\Delta\varphi$), relative to the band bending ($E_b$), is defined as [8]:

$$ \frac{\Delta\varphi}{E_b} = \left[ 16\pi \left( \frac{E_b}{E_{11}} \right)^{3/2} \frac{x_m}{\omega} \right]^{-1/2} \left( 1 + 3\frac{x_m}{\omega} \right) \hfill (121) $$

$$ E_{11} = 9.05 \times 10^{-7} \left[ \frac{N}{K_s K_d^2} \right]^{1/3} \hfill (122) $$

## Electrical Boundary Conditions

$$ \frac{x_m}{\omega} = \frac{2}{3} + \frac{1}{3} \cos \frac{\delta}{3} - \frac{1}{\sqrt{3}} \sin \frac{\delta}{3} \eqno(123) $$

$$ \cos \delta = 1 - \frac{27}{32 \pi (E_b / E_{11})^{3/2}} \eqno(124) $$

where $K_s$ is the static dielectric constant, $K_d$ is the high-frequency dielectric constant, $E_{11}$ is a constant of the material with the unit of energy, and $N$ is the electron density.

The syntax can be used in either the `RegionInterface` or `MaterialInterface` section. You can activate the model by specifying the following:

*   The keyword `DistResist=SchottkyResistance` activates the Schottky interface resistance model.

*   The option `SRDoping` activates the image-force potential lowering model in Schottky contacts.

For example:

```
Physics(MaterialInterface="AlGaAs/Aluminum") {
  DistResist=SchottkyResistance
  SRDoping
}
```

A more general model for interface Schottky resistance can be implemented using the Schottky resistance PMI (see Schottky Resistance on page 1399). In this case, Schottky-distributed resistance $R_d$ can be an arbitrary function of lattice temperature, electron temperature, hole temperature, electron affinity, band gap, bandgap narrowing, conduction-band effective density-of-states, valence-band effective density-of-states, and effective intrinsic density, $R_d = R_d(T, T_n, T_p, \chi, E_g, E_{bgn}, N_C, N_V, n_{i, \text{eff}})$. The PMI model can access the built-in Schottky resistance model parameters using the vertex-based PMI support function `InitModelParameter()` (see Runtime Support for Vertex-Based PMI Models on page 1194).

# Boundaries Without Contacts

Outer boundaries of the device that are not contacts are treated with ideal Neumann boundary conditions:

$$ \varepsilon \nabla \phi + \vec{P} = 0 \eqno(125) $$

$$ \vec{J}_n \cdot \hat{n} = 0 \quad \vec{J}_p \cdot \hat{n} = 0 \eqno(126) $$

Eq. 126 also applies to semiconductor–insulator interfaces.

Floating Contacts

## Application Notes

Setting `Barrier` in the `Electrode` statement is typically used to define the semiconductor Schottky barrier, but it also can be used for all other types of contact where it simply shifts the contact electrostatic potential by the specified value. It can be useful for some fitting and calibration, but it might lead to zero bias currents if these barrier values are different for contacts placed in the same region or material.

Given differences in the `Barrier` setting and to avoid zero bias currents, there are special rules for specifying `WorkFunction` in the `Electrode` statement. The `WorkFunction` is ignored for contact mesh nodes if it is located at:

*   Only in metals or only in semiconductors with Ohmic boundary conditions

*   An interface between a semiconductor and any other type of material with Ohmic boundary conditions at the semiconductor side

Like the `Barrier` setting, the `WorkFunction` is used to define the semiconductor Schottky barrier including contacts placed at metal–semiconductor interfaces. In addition, it is used for contacts placed at metal–insulator interfaces or solely in insulator regions.

# Floating Contacts

This section discusses floating contacts.

## Floating Metal Contacts

The charge on a floating contact (for example, a floating gate in an EEPROM cell) is specified in the `Electrode` section:

```
Electrode { ...
  { name="FloatGate" charge=1e-15 }
}
```

In the case of a floating metal contact (a contact not in touch with any semiconductor region), the electrostatic potential is determined by solving the Poisson equation with the following charge boundary condition:

$$ \int \epsilon \hat{n} \cdot \nabla \phi dS = Q $$ (127)

10: Boundary Conditions

Floating Contacts

where $\hat{n}$ is the normal vector on the floating contact surface $S$, and $Q$ is the specified charge on the floating contact. The electrostatic potential on the floating-contact surface is assumed to be constant.

An additional capacitance between floating contact and control contact is necessary if, for example, EEPROM cells are simulated in a 2D approximation, to account for the additional influence on the capacitance from the real 3D layout. The additional capacitance can be specified in the `Electrode` section using the keyword `FGcap`.

For example, if you have `ContGate` and `FloatGate` contacts, additional `ContGate`/`FloatGate` capacitance is specified as:

```
Electrode {
  { name="ContGate" voltage=10 }
  { name="FloatGate" charge=0 FGcap=(value=3e-15 name="ContGate") }
}
```

where `value` is the capacitance value between `FloatGate` and `ContGate`. For the 1D case, the capacitance unit is F/$\mu$m$^2$; for the 2D case, F/$\mu$m; and for the 3D case, F.

If the floating-contact capacitance is specified, Eq. 127 changes to:

$$ \int \varepsilon \hat{n} \cdot \nabla \phi dS + C_{FC}(\phi_{CC} - \phi_{FC} + \phi_B) = Q \eqno(128) $$

where:

*   $C_{FC}$ is the specified floating-contact capacitance.

*   $\phi_{FC}$ is the floating-contact potential.

*   $\phi_{CC}$ is the potential on the control electrode (specified in the `FGcap` statement).

*   $\phi_B$ is a barrier specified in the `Electrode` section for the floating contact, which can be used as a fitting parameter (default value is zero).

> **NOTE** If the control contact is a metal, then the value of $\phi_{CC}$ is defined by the applied voltage and the metal barrier/workfunction (see Contacts on Insulators on page 213). However, if the control contact touches a semiconductor region, then $\phi_{CC}$ is equal to the applied voltage with an averaged built-in potential on the contact.

Floating contacts can have several capacitance values for different control contacts. For example:

```
Electrode {
  { name="source" voltage=0 }
  { name="ContGate" voltage=10 }
  { name="FloatGate" charge=0 FGcap( (value=3e-15 name="ContGate")
```

Floating Contacts

```
    (value=2e-15 name="source") }
}
```

In transient simulations, Sentaurus Device takes the charge specified in the `Electrode` section as an initial condition. After each time step, the charge is updated due to tunneling and hot-carrier injection currents. For a description of tunneling and hot-carrier injection, see Chapter 24 on page 767 and Chapter 25 on page 793, respectively.

# Floating Semiconductor Contacts

Sentaurus Device can simulate floating semiconductor contacts by connecting an electrode with charge boundary condition to an insulated semiconductor region. Within that floating-contact region, Sentaurus Device solves the Poisson equation with the following charge boundary condition:

$$ \int_{FC} [q(p - n + N_D - N_A) + \rho_{\text{trap}}] dV = Q_{FC} $$ (129)

where $Q_{FC}$ denotes the total charge on the floating gate and $\rho_{\text{trap}}$ is the charge density contributed by traps and fixed charges (see Chapter 17 on page 489). The integral is calculated over all nodes of the floating-contact region [9].

The charge $Q_{FC}$ is a boundary condition that must be specified in a Sentaurus Device `Electrode` statement in exactly the same way as for a floating metal contact:

```
Electrode {
  { name="floating_gate" Charge=1e-14 }
}
```

It is also possible to use the charge as a goal in a `Quasistationary` command:

```
Quasistationary (Goal {Name="floating_gate" Charge = 1e-13})
  { Coupled {Poisson Electron} }
```

Sentaurus Device automatically identifies a floating semiconductor contact based on information in the geometry (`.tdr`) file. It is not necessary for the charge contact to cover the entire boundary of the floating semiconductor region. A small contact is sufficient if the floating region has the same doping type throughout. However, if both n-type and p-type volumes exist in the floating region, both volumes must be associated with the floating contact defining the floating region. This can be achieved by having a contact in touch with both volumes.

10: Boundary Conditions

Thermal Boundary Conditions

It is assumed that no current flows within the floating region. Therefore, the quasi-Fermi potential for electrons and holes is identical and constant within the floating region:

$$ \Phi_n = \Phi_p = \Phi \tag{130} $$

Therefore, the electron and hole densities $n$ and $p$ are functions of the electrostatic potential $\phi$ and the quasi-Fermi potential $\Phi$ as discussed in Quasi-Fermi Potential With Boltzmann Statistics on page 181 and Fermi Statistics on page 182. Sentaurus Device does not solve the electron and hole continuity equations within a floating region.

In transient simulations, Sentaurus Device takes the charge specified in the `Electrode` section as an initial condition. After each time step, the charge is updated due to hot-carrier injection or tunneling currents including tunneling to traps. For a description of tunneling models and how to enable them, see Chapter 24 on page 767. For hot-carrier injection models, see Chapter 25 on page 793.

The floating-contact capacitance can be specified in the `Electrode` statement in exactly the same way as for the floating metal contact (see Floating Metal Contacts on page 232). The only difference is that the potential on the semiconductor floating contact is not always a constant. Therefore, defining a constant capacitance might not be strictly correct, and it gives only approximate results. Sentaurus Device uses the semiconductor floating-contact Fermi level to compute the charge associated with the floating-contact capacitance and solves an equilibrium problem (zero voltages and zero charges, see Equilibrium Solution on page 181 for setting numeric parameters to get the equilibrium solution) at the beginning to find a reference Fermi level.

For plotting purposes, floating semiconductor contacts are handled differently from other electrodes. Instead of the voltage, the value of the quasi-Fermi potential $\Phi$ is displayed.

# Thermal Boundary Conditions

This section discusses thermal boundary conditions.

## Boundary Conditions for Lattice Temperature

For the solution of Eq. 70, p. 198, Eq. 71, p. 200, Eq. 72, p. 201, and Eq. 78, p. 204, thermal boundary conditions must be applied. Wachutka [10] is followed, but the difference in thermo-powers between the semiconductor and metal at Ohmic contacts is neglected. For free, thermally insulating, surfaces:

$$ \kappa \hat{n} \cdot \nabla T = 0 \tag{131} $$

Thermal Boundary Conditions

where $\hat{n}$ denotes a unit vector in the direction of the outer normal.

At thermally conducting interfaces, thermally resistive (nonhomogeneous Neumann) boundary conditions are imposed:

$$ \kappa \hat{n} \cdot \nabla T = \frac{T_{\text{ext}} - T}{R_{\text{th}}} \tag{132} $$

where $R_{\text{th}}$ is the external thermal resistance, which characterizes the thermal contact between the semiconductor and adjacent material.

For the special case of an ideal heat sink ($R_{\text{th}} \rightarrow 0$), Dirichlet boundary conditions are imposed:

$$ T = T_{\text{ext}} \tag{133} $$

By default, the Dirichlet boundary condition is imposed. For the Neumann boundary condition (Eq. 132), you can specify $R_{\text{th}}$ with the keyword `SurfaceResistance` in the specification of the Thermode (see Table 352 on page 1639). Alternatively, you can use `SurfaceConductance` to specify $1/R_{\text{th}}$.

When the lattice temperature equation is solved, the lattice temperature (`Temperature`) and lattice heat flux (`lHeatFlux`) at thermodes are added automatically to the `.plt` file in the corresponding `Thermode` section. The unit for heat flux is W for 3D, W/$\mu$m for 2D, and W/$\mu$m$^2$ for 1D.

At insulator–insulator, insulator–semiconductor, semiconductor–semiconductor, metal–semiconductor, metal–metal, and metal–insulator interfaces, a distributed thermal resistance is supported as well.

To activate this feature, specify the distributed resistance by using the `DistrThermalResist` keyword in the `Physics` section of the respective interface.

The following example activates a distributed thermal resistance at the interface between region "reg1" and region "reg2" with the value 0.001 cm$^2$K/W :

```
Physics (RegionInterface="reg1/reg2") {
  DistrThermalResist=1e-3
}
```

As for thermionic emission, double points are used at the interfaces where distributed thermal resistance has been activated. In this case, double points allow a discontinuity in the lattice temperature on the two sides of the interface.

**10: Boundary Conditions**
Periodic Boundary Conditions

Assuming an interface between materials 1 and 2 such that $\Delta T = T_{2} - T_{1} > 0$, if $\vec{S}_{L, 1}$ is the heat flux density entering material 1 and $\vec{S}_{L, 2}$ is the heat flux density leaving material 2, the thermal boundary condition at the interface between materials 1 and 2 can be written as:

$$ \vec{S}_{L, 2} = \vec{S}_{L, 1} \tag{134} $$

$$ \vec{S}_{L, 1} = \frac{T_{2} - T_{1}}{R_{d, \text{th}}} \tag{135} $$

where $R_{d, \text{th}}$ is the interface-distributed resistance defined with `DistrThermalResist` as described here.

A PMI model for the calculation of the distributed thermal resistance is available. The PMI model allows you to specify the distributed thermal resistance by using physical variables at the two sides of the interface. See Distributed Thermal Resistance on page 1297.

# Boundary Conditions for Carrier Temperatures

For the carrier temperatures $T_{n}$ and $T_{p}$, at the thermal contacts, fast relaxation to the lattice temperature (boundary condition $T_{n} = T_{p} = T$) is assumed.

For other boundaries, adiabatic conditions for carrier temperatures are assumed:

$$ \kappa_{n} \hat{n} \cdot \nabla T_{n} = \kappa_{p} \hat{n} \cdot \nabla T_{p} = 0 \tag{136} $$

When the hydrodynamic model is used, the lattice temperature (`Temperature`), the lattice heat flux (`lHeatFlux`), and the carrier heat fluxes (`eHeatFlux` and `hHeatFlux`) at thermodes are added automatically to the `.plt` file in the corresponding `Thermode` section. The unit for heat fluxes is W for 3D, W/$\mu$m for 2D, and W/$\mu$m<sup>2</sup> for 1D.

# Periodic Boundary Conditions

The use of periodic boundary conditions (PBCs) can be helpful for simulations of periodic device structures, for example, lines or arrays of cells. Instead of building a periodic simulation domain, you can supply PBCs at the lower and upper boundary planes (perpendicular to the main axis of the coordinate system) of a single cell. Periodicity of the solution means that the two boundary planes are virtually identified, thereby forming a PBC interface: The solution is (weakly) continuous across this interface, and currents (or fluxes in the general case) can flow from one side to the other.

Periodic Boundary Conditions

You can select between two different numeric PBC approaches, referred to as the Robin PBC (RPBC) approach and mortar PBC (MPBC) approach. Both approaches support the following:

* Several transport models, namely, drift-diffusion, thermodynamic, and hydrodynamic transport

* Both conforming and nonconforming geometries and meshes

* Two-dimensional and 3D device structures

* The conservation of the fluxes (for example, current conservation for the continuity equations)

* Both one-fold and two-fold periodicity, that is, PBC can be applied in one axis direction and simultaneously in two directions for 3D structures

## Robin PBC Approach

The RPBC approach uses a current (or flux) model between both sides of the PBC interface of the form:

$$ \alpha(u_1 - u_2) - j_{12} = 0 $$ (137)

where:

* $u_1$ and $u_2$ are the solution variables of an equation at both sides of the PBC interface.

* $j_{12}$ is the flux density of the equation across the PBC interface.

* $\alpha$ represents a user-provided tuning parameter. The tuning parameter allows you to determine how strongly the local current density across the interface reduces the discontinuity of the solution variable. A large $\alpha$ reduces the jumps of the solution variable, while for $\alpha = 0$, no continuity is enforced at all and no current will flow across the interface.

## Mortar PBC Approach

In the MPBC approach, both sides of the PBC interface are effectively glued together on one side (the mortar side), while on the other side (the nonmortar side), a weak continuity condition for the equation potential (mostly, the solution variable) is imposed. Therefore, the MPBC approach is not symmetric with respect to the selection of the mortar side if the mesh is nonconforming. The side where the accuracy requirements are larger (and, typically, the mesh is finer) should be selected as the mortar side. The equation potential for the carrier continuity equations are the corresponding quasi-Fermi potentials, while for the other equations, the solution variable is chosen. The MPBC approach does not require a current model across the PBC interface.

10: Boundary Conditions
Periodic Boundary Conditions

# Specifying Periodic Boundary Conditions

Periodic boundary conditions are activated by using `PeriodicBC` in the global or device `Math` section. Table 206 on page 1518 provides a complete list of possible options.

## Specifying Robin Periodic Boundary Conditions

RPBCs can be activated individually for all supported equations (see Electrostatic Potential on page 179, Chapter 8 on page 189, and Chapter 9 on page 197). The solution variable *u* of the selected equation (for example, the electrostatic potential $\phi$ of the Poisson equation), and the corresponding flux density *j* are listed in Table 32.

Table 32 Solution variables and fluxes used in periodic boundary conditions

| u | j | Description |
| --- | --- | --- |
| $\phi$ | $\varepsilon \nabla \phi$ | Electrostatic Potential on page 179 |
| $n$ | $\vec{J}_n$ | Chapter 8 on page 189 |
| $p$ | $\vec{J}_p$ |  |
| $T_n$ | $\vec{S}_n$ | Chapter 9 on page 197 |
| $T_p$ | $\vec{S}_p$ |  |
| $T$ | $\kappa \nabla T$ | Chapter 9 on page 197 |

An RPBC is typically activated by `PeriodicBC(<options>)`, where `<options>` provides a selection of the equations and boundaries. Multiple specifications of `<options>` are possible to select several equations: `PeriodicBC( (<options1>) ... (<optionsN>) )`.

> **NOTE** If the material parameters or the doping concentration differ on both sides of the interface, RPBC might result in nonphysical solutions.

An example of specifying RPBCs for different equations and boundaries is:

```
Math {
  PeriodicBC(
    (Direction=0 Coordinates=(-1.0 2.0))
    (Poisson Direction=1 Coordinates=(-1e50 1e50))
    (Electron Direction=1 Coordinates=(-1e50 1e50) Factor=2.e8)
  )
}
```

Here, the first option applies periodic boundary conditions to all equations in the direction of the x-axis and for the coordinates –1.0 $\mu$m and 2.0 $\mu$m. The next two options specify periodic boundary conditions for the electron and hole continuity equations in the y-direction and for

Periodic Boundary Conditions

the device side coordinates. `Factor` determines the tuning parameter $\alpha$ in the flux density model and defaults to 1.e8.

## Specifying Mortar Periodic Boundary Conditions

Periodic boundary conditions using the MPBC approach are activated in the global or device `Math` section by:

```
PeriodicBC ( ( Type=MPBC Direction=1 MortarSide=Ymax ) )
```

`Direction` selects the coordinate axis where the PBC interface is created (that is, here the y-axis). `MortarSide` specifies that the plane at maximum coordinate values is taken as the mortar side (the default is the minimum coordinate plane). The maximum and minimum coordinate planes are extracted automatically. Using `MortarSide` implies the MPBC approach (making `Type` and `Direction` redundant), which means the following specification enables a two-fold MPBC simulation:

```
PeriodicBC( ( MortarSide=Xmin MortarSide=Ymax ) )
```

# Application Notes

Note that:

*   The RPBC approach supports, in contrast to the MPBC approach, some flexibility with respect to the involved equations.

*   The MPBC approach treats the PBC interface essentially as a heterointerface. Conductor regions touching the PBC interface are not supported in MPBC. Heterointerfaces touching the PBC interface are allowed, but there are cases where the periodicity is further relaxed.

*   If the device structure forms a heterointerface at the PBC interface, the MPBC approach must be used. The RPBC approach provides nonphysical results.

## Specialized Linear Solver for MPBC

Using MPBC in combination with iterative linear solvers (such as ILS), you might observe some convergence problems. If feasible, using a direct solver (such as PARDISO) should resolve the problem. Otherwise, an improved preconditioner or the use of extended precision improves the convergence behavior in many cases.

There is a specialized linear solver available for MPBC simulations that utilizes the advantages of the iterative solver ILS and improves the robustness of the simulations. This solver can be enabled by a (temporary) user interface. Specifying `UseSchurSolver` in the global `Math` section replaces the `Blocked` method by the specialized MPBC solver for all `Coupled`

10: Boundary Conditions
Discontinuous Interfaces

statements. Coupled statements using other methods are not affected. Note that this solver is not yet available for AC analysis.

# Discontinuous Interfaces

Discontinuous interfaces generalize the framework used for the simulation of heterointerfaces at semiconductor–semiconductor interfaces (see Abrupt and Graded Heterojunctions on page 11 and Heterostructure Device Simulation on page 819). They build the basis for models generating discontinuities of physical quantities across region interfaces.

## Representation of Physical Quantities Across Interfaces

Several interface conditions result in discontinuous physical quantities across these interfaces. An interface is a *discontinuous interface* if all physical quantities use a discontinuous representation across this interface. The continuity of selected quantities is guaranteed by applying (often implicitly) corresponding interface conditions. By default, the interface conditions at discontinuous interfaces imply continuity for the solution variable.

You can enforce every interface to be a discontinuous interface by using `Discontinuity` in any `Physics` section. For example:

```
Physics ( MaterialInterface= "Silicon/Oxide" ) {
  Discontinuity  * applies to all interfaces of the two materials
}

Physics ( Material= "Silicon" ) {
  Discontinuity  * applies to all interfaces to other materials
}
```

Discontinuous interfaces are allowed between any two regions, independent of their material or material group (semiconductor, insulator, or conductor). They are implicitly or explicitly used for the following interface models:

*   Dipole (see Dipole Layer on page 180)

*   Discontinuity

*   DistrThermalResist (see Boundary Conditions for Lattice Temperature on page 235)

*   HeteroInterface (see Abrupt and Graded Heterojunctions on page 11)

*   Thermionic, eThermionic, hThermionic (see Heterostructure Device Simulation on page 819)

**10: Boundary Conditions**

References

*   Concept of ‘semiconductor floating gate’ (see Destination of Injected Current on page 794)

*   Optics standalone simulations (see Controlling Computation of Optical Problem in Solve Section on page 634)

# Interface Conditions at Discontinuous Interfaces

At general discontinuous interfaces (that is, involving arbitrary material groups), not all interface conditions are yet supported. So far, the interface conditions related to drift-diffusion, thermodynamic, and hydrodynamic transport are allowed. Simulations using only heterointerfaces (that is, semiconductor–semiconductor interfaces including the `HeteroInterface` flag) as discontinuous interfaces support the full set of transport equations and interface conditions. Note that a discontinuous semiconductor–semiconductor interface must be a heterointerface.

# Critical Points

Geometric locations, where several interfaces intersect or an interface intersects the boundary or contact, are so-called critical points. At such critical points, not all interface conditions can be fulfilled, in general, and conflicts are resolved by implicit rules.

Critical points are supported if the set of discontinuous interfaces either is empty, or is the entire set of involved interfaces, or consists of heterointerfaces.

# References

[1] A. Schenk and S. Müller, “Analytical Model of the Metal-Semiconductor Contact for Device Simulation,” in *Simulation of Semiconductor Devices and Processes (SISDEP)*, vol. 5, Vienna, Austria, pp. 441–444, September 1993.

[2] A. Schenk, *Advanced Physical Models for Silicon Device Simulation*, Wien: Springer, 1998.

[3] S. M. Sze, *Physics of Semiconductor Devices*, New York: John Wiley & Sons, 2<sup>nd</sup> ed., 1981.

[4] A. M. Cowley and S. M. Sze, “Surface states and barrier height of metal-semiconductor systems,” *Journal of Applied Physics*, vol. 36, no. 10, pp. 3212–3220, 1965.

[5] W. Mönch, “Chemical trends of barrier heights in metal-semiconductor contacts: on the theory of the slope parameter,” *Applied Surface Science*, vol. 92, pp. 367–371, February 1996.

**10: Boundary Conditions**

References

[6] A. Tugulea and D. Dascalu, “The image-force effect at a metal-semiconductor contact with an interfacial insulator layer,” *Journal of Applied Physics*, vol. 56, no. 10, pp. 2823–2831, 1984.

[7] K. Varahramyan and E. J. Verret, “A Model for Specific Contact Resistance Applicable for Titanium Silicide–Silicon Contacts,” *Solid-State Electronics*, vol. 39, no. 11, pp. 1601–1607, 1996.

[8] V. L. Rideout and C. R. Crowell, “Effects of Image Force and Tunneling on Current Transport in Metal–Semiconductor (Schottky Barrier) Contacts,” *Solid-State Electronics*, vol. 13, no. 7, pp. 993–1009, 1970.

[9] S. Sugino *et al.*, “Analysis of Writing and Erasing Procedure of Flotox EEPROM Using the New Charge Balance Condition (CBC) Model,” in *Workshop on Numerical Modeling of Processes and Devices for Integrated Circuits (NUPAD IV)*, Seattle, WA, USA, pp. 65–69, May 1992.

[10] G. K. Wachutka, “Rigorous Thermodynamic Treatment of Heat Generation and Conduction in Semiconductor Device Modeling,” *IEEE Transactions on Computer-Aided Design*, vol. 9, no. 11, pp. 1141–1149, 1990.

## References

