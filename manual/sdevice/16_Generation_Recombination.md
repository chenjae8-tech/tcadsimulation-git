# CHAPTER 16 Generation–Recombination

*This chapter describes the generation–recombination processes that can be modeled in Sentaurus Device.*

Generation–recombination processes exchange carriers between the conduction band and the valence band. They are very important in device physics, in particular, for bipolar devices. This chapter describes the generation–recombination models available in Sentaurus Device. Most models are local in the sense that their implementation (sometimes in contrast to reality) does not involve spatial transport of charge. For each individual generation or recombination process, the electrons and holes involved appear or vanish at the same location. The only exceptions are one trap-assisted tunneling model and one band-to-band tunneling model (see Dynamic Nonlocal Path Trap-Assisted Tunneling on page 428 and Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475). For models that couple the conduction and valence bands and account for spatial transport of charge, see Nonlocal Tunneling for Traps on page 517 and Nonlocal Tunneling at Interfaces, Contacts, and Junctions on page 774.

# Shockley–Read–Hall Recombination

Recombination through deep defect levels in the gap is usually called Shockley–Read–Hall (SRH) recombination. In Sentaurus Device, the following form is implemented:

$$ R_{net}^{SRH} = \frac{np - n_{i,eff}^2}{\tau_p(n + n_1) + \tau_n(p + p_1)} $$ (384)

with:

$$ n_1 = n_{i,eff} \exp \left( \frac{E_{trap}}{kT} \right) $$ (385)

$$ p_1 = n_{i,eff} \exp \left( \frac{-E_{trap}}{kT} \right) $$ (386)

where $E_{trap}$ is the difference between the defect level and intrinsic level. The variable $E_{trap}$ is accessible in the parameter file. The silicon default value is $E_{trap} = 0$.

Shockley–Read–Hall Recombination

The lifetimes $\tau_n$ and $\tau_p$ are modeled as a product of a doping-dependent (see SRH Doping Dependence on page 420), field-dependent (see SRH Field Enhancement on page 424), and temperature-dependent (see SRH Temperature Dependence on page 422) factor:

$$ \tau_c = \tau_{\text{dop}} \frac{f(T)}{1 + g_c(F)} $$ (387)

where $c = n$ or $c = p$. For an additional density dependency of the lifetimes, see Trap-Assisted Auger Recombination Model on page 431.

For simulations that use Fermi statistics (see Fermi Statistics on page 182) or quantization (see Chapter 14 on page 303), Eq. 384 must be generalized. The modified equation reads:

$$ R_{\text{net}}^{\text{SRH}} = \frac{np - \gamma_n \gamma_p n_{i,\text{eff}}^2}{\tau_p(n + \gamma_n n_1) + \tau_n(p + \gamma_p p_1)} $$ (388)

where $\gamma_n$ and $\gamma_p$ are given by Eq. 47 and Eq. 48, p. 183.

## Using SRH Recombination

Generation–recombination models are selected in the `Physics` section as an argument to the `Recombination` keyword:

```
Physics{ Recombination( <arguments> ) ...}
```

The SRH model is activated by specifying the `SRH` argument:

```
Physics{ Recombination( SRH ...) ...}
```

The keyword for plotting the SRH recombination rate is:

```
Plot{ ...
  SRHRecombination
}
```

## SRH Doping Dependence

Doping dependence of SRH lifetimes is modeled in Sentaurus Device with the Scharfetter relation:

$$ \tau_{\text{dop}}(N_{A,0} + N_{D,0}) = \tau_{\min} + \frac{\tau_{\max} - \tau_{\min}}{1 + \left( \frac{N_{A,0} + N_{D,0}}{N_{\text{ref}}} \right)^\gamma} $$ (389)

**16: Generation–Recombination**
Shockley–Read–Hall Recombination

Such a dependence arises from experimental data [1] and the theoretical conclusion that the solubility of a fundamental acceptor-type defect (probably a divacancy (E5) or a vacancy complex) is strongly correlated to the doping density [2][3][4]. Table 79 on page 423 lists the default values. The Scharfetter relation is used when the option `DopingDependence` is specified for SRH recombination:

```
Physics{ Recombination( SRH( DopingDependence ... ) ...) ...}
```

Without the option `DopingDependence`, $\tau = \tau_{max}$ is used.

# Lifetime Profiles From Files

Sentaurus Device can use spatial lifetime profiles provided by a file. Such profiles can be precomputed or generated manually by an editor such as Sentaurus Structure Editor (refer to the *Sentaurus™ Structure Editor User Guide*).

The names of the datasets for electron and hole lifetimes must be `eLifetime` and `hLifetime`, respectively. They are loaded from a file named by the keyword `LifeTime` in the `File` section:

```
File {
  Grid     = "MyDev_msh.tdr"
  LifeTime = "MyDev_msh.tdr"
  ...
}
```

For each grid point, the values defined by the lifetime profile are used as $\tau_{max}$ in Eq. 389.

Lifetime data can be in a separate file from the doping, but it must correspond to the same grid.

# Improved Nakagawa Model

The Scharfetter relation can be expanded to be:

$$ \tau_{dop}(N_{A,0} + N_{D,0}) = \frac{\tau_{max} + \tau_{min} \left( \frac{N_{A,0} + N_{D,0}}{N_{ref}} \right)^{\gamma}}{1 + \frac{\tau_{max}}{\tau_{0}} \left( \frac{N_{A,0} + N_{D,0}}{N_{ref}} \right)^{\gamma}} $$ (390)

Here, $\tau_{0}$ is an additional fitting parameter. By default, $\tau_{min} = 0$.

421

Shockley–Read–Hall Recombination

Then, Eq. 390 simplifies to:

$$ \tau_{\text{dop}}(N_{\text{A, 0}} + N_{\text{D, 0}}) = \frac{\tau_{\text{max}}}{1 + \frac{\tau_{\text{max}}}{\tau_0} \left( \frac{N_{\text{A, 0}} + N_{\text{D, 0}}}{N_{\text{ref}}} \right)^\gamma} \tag{391} $$

With another default, $\gamma = 1$, Eq. 391 is further simplified to:

$$ \frac{1}{\tau_{\text{dop}}(N_{\text{A, 0}} + N_{\text{D, 0}})} = \frac{1}{\tau_{\text{max}}} + \frac{1}{\tau_0} \cdot \left( \frac{N_{\text{A, 0}} + N_{\text{D, 0}}}{N_{\text{ref}}} \right) \tag{392} $$

This is the original equation in [5]. With $\tau_0 = \tau_{\text{max}}$, it corresponds to Eq. 389 with $\tau_{\text{min}} = 0, \gamma = 1$. Table 79 on page 423 lists the default values.

To activate the Nakagawa model, an additional option `Nakagawa` is specified in the `SRH(DopingDependence)` statement:

```
Physics {
  Recombination( SRH( DopingDependence ( Nakagawa )... ) ...)
  ...
}
```

## SRH Temperature Dependence

There is no consensus on the temperature dependence of SRH lifetimes. This appears to originate from a different understanding of lifetime. From measurements of the recombination lifetime [6][7]:

$$ \tau = \frac{\delta n}{R} \tag{393} $$

in power devices ($\delta n$ is the excess carrier density under neutral conditions, $\delta n = \delta p$), it was concluded that the lifetime increases with rising temperature.

Such a dependence was modeled either by a power law [6][7]:

$$ \tau(T) = \tau_0 \left( \frac{T}{300 \text{ K}} \right)^\alpha \tag{394} $$

or an exponential expression of the form:

$$ \tau(T) = \tau_0 e^{C \left( \frac{T}{300 \text{ K}} - 1 \right)} \tag{395} $$

16: Generation–Recombination
Shockley–Read–Hall Recombination

A calculation using the low-temperature approximation of multiphonon theory [8] gives:

$$ \tau_{\text{SRH}}(T) = \tau_{\text{SRH}}(300\text{ K}) \cdot f(T) \text{ with } f(T) = \left( \frac{T}{300\text{ K}} \right)^{T_{\alpha}} $$ (396)

with $T_{\alpha} = -3/2$, which is the expected decrease of minority carrier lifetimes with rising temperature. Since the temperature behavior strongly depends on the nature of the recombination centers, there is no universal law $\tau_{\text{SRH}}(T)$.

In Sentaurus Device, the power law model (Eq. 394) is activated with the `TempDependence` keyword in the `SRH` statement:

```
Physics { Recombination( SRH( TempDependence ...) ...) ...}
```

Additionally, Sentaurus Device supports an exponential model for $f(T)$:

$$ f(T) = e^{C \left( \frac{T}{300\text{ K}} - 1 \right)} $$ (397)

This model is activated with the keyword `ExpTempDependence`:

```
Physics { Recombination( SRH( ExpTempDependence ...) ...) ...}
```

# SRH Doping- and Temperature-Dependent Parameters

All the parameters of the doping- and temperature-dependent SRH recombination models are accessible in the `Scharfetter` parameter set.

Table 79 Parameters for doping- and temperature-dependent SRH lifetimes

| Symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |
| τmin | taumin | 0 | 0 | s |
| τmax | taumax | 1×10–5 | 3×10–6 | s |
| τ₀ | tau0 | 1×10–5 | 3×10–6 | s |
| Nref | Nref | 1×1016 | 1×1016 | cm–3 |
| γ | gamma | 1 | 1 | 1 |
| Tα | Talpha | –1.5 | –1.5 | 1 |
| C | Tcoeff | 2.55 | 2.55 | 1 |
| Etrap | Etrap | 0 | 0 | eV |

Shockley–Read–Hall Recombination

## SRH Field Enhancement

Field enhancement reduces SRH recombination lifetimes in regions of strong electric fields. It must not be neglected if the electric field exceeds a value of approximately 3×10<sup>5</sup> V/cm in certain regions of the device. For example, the I–V characteristics of reverse-biased p-n junctions are extremely sensitive to defect-assisted tunneling, which causes electron–hole pair generation before band-to-band tunneling or avalanche generation sets in. Therefore, it is recommended that field enhancement is included in the simulation of drain reverse leakage and substrate currents in MOS transistors.

Sentaurus Device provides the following field enhancement models:

*   Schenk Trap-Assisted Tunneling Model on page 425

*   Hurkx Trap-Assisted Tunneling Model on page 426

The Hurkx model is also available for trap capture and emission rates (see Hurkx Model for Cross Sections on page 503).

## Using Field Enhancement

Parameters in the `ElectricField` option of the `SRH` statement activate the local field–dependence of SRH lifetimes:

```
SRH( ...
  ElectricField (
    Lifetime = Constant | Hurkx | Schenk
    DensityCorrection = Local | None
  )
)
```

The `Lifetime` parameter selects the lifetime model:

*   The default is `Constant`, which is for field-independent lifetimes.

*   `Hurkx` selects the Hurkx lifetimes.

*   `Schenk` selects the Schenk lifetimes.

The `DensityCorrection` parameter defaults to `None`. A value of `Local` selects the model described in Density Correction for the Schenk and Hurkx Trap-Assisted Tunneling Models on page 427.

For backward compatibility:

*   `SRH (Tunneling)` selects `Lifetime=Schenk` and `DensityCorrection=Local`.

*   `SRH(Tunneling(Hurkx))` selects `Lifetime=Hurkx` and `DensityCorrection=None`.

16: Generation–Recombination

Shockley–Read–Hall Recombination

**NOTE** The inclusion of the Schenk or Hurkx model might lead to convergence problems. In such cases, try to specify the `NoSRHperPotential` flag in the *Math* section, which causes Sentaurus Device to exclude derivatives of $g(F)$ with respect to the potential from the Jacobian matrix.

# Schenk Trap-Assisted Tunneling Model

The field dependence of the recombination rate is taken into account by the field enhancement factors:

$$ [1 + g(F)]^{-1} $$ (398)

of the SRH lifetimes [[8]](8) (see Eq. 387, p. 420).

In the case of electrons, $g(F)$ has the form:

$$ g_n(F) = \left( 1 + \frac{(\hbar\Theta)^{3/2} \sqrt{E_t - E_0}}{E_0 \hbar\omega_0} \right)^{-\frac{1}{2}} \frac{(\hbar\Theta)^{3/4} (E_t - E_0)^{1/4}}{2 \sqrt{E_t E_0}} \left( \frac{\hbar\Theta}{kT} \right)^{\frac{3}{2}} $$ (399)
$$ \times \exp \left( - \frac{E_t - E_0}{\hbar\omega_0} + \frac{\hbar\omega_0 - kT}{2\hbar\omega_0} + \frac{2E_t + kT}{2\hbar\omega_0} \ln \frac{E_t}{\varepsilon_R} - \frac{E_0}{\hbar\omega_0} \ln \frac{E_0}{\varepsilon_R} + \frac{E_t - E_0}{kT} - \frac{4}{3} \left( \frac{E_t - E_0}{\hbar\Theta} \right)^{\frac{3}{2}} \right) $$

where $E_0$ denotes the energy of an optimum horizontal transition path, which depends on field strength and temperature in the following way:

$$ E_0 = 2 \sqrt{\varepsilon_F} [\sqrt{\varepsilon_F + E_t + \varepsilon_R} - \sqrt{\varepsilon_F}] - \varepsilon_R, \varepsilon_F = \frac{(2\varepsilon_R kT)^2}{(\hbar\Theta)^3} $$ (400)

In this expression, $\varepsilon_R = S\hbar\omega_0$ is the lattice relaxation energy, $S$ is the Huang–Rhys factor, $\hbar\omega_0$ is the effective phonon energy, $E_t$ is the energy level of the recombination center (thermal depth), and $\Theta = (q^2 F^2 / 2\hbar m_{\Theta,n})^{1/3}$ is the electro-optical frequency.

The mass $m_{\Theta,n}$ is the electron tunneling mass in the field direction and is given in the parameter file. The expression for holes follows from Eq. 399 by replacing $m_{\Theta,n}$ with $m_{\Theta,p}$ and $E_t$ with $E_{g,\text{eff}} - E_t$.

For electrons, $E_t$ is related to the defect level $E_{\text{trap}}$ of Eq. 385, p. 419 and Eq. 386, p. 419 by:

$$ E_t = \frac{1}{2} E_{g,\text{eff}} + \frac{3}{4} kT \ln \left( \frac{m_n}{m_p} \right) - E_{\text{trap}} - (32 R_C \hbar^3 \Theta^3)^{1/4} $$ (401)

Shockley–Read–Hall Recombination

where the effective Rydberg constant $R_{\text{C}}$ is:

$$ R_{\text{C}} = m_{\text{C}} \left( \frac{Z^2}{\varepsilon^2} \right) Ry $$ (402)

where $Ry$ is the Rydberg energy ( 13.606 eV ), $\varepsilon$ is the relative dielectric constant, and $Z$ is a fit parameter.

For holes, $E_{\text{t}}$ is given by:

$$ E_{\text{t}} = \frac{1}{2} E_{\text{g,eff}} - \frac{3}{4} kT \ln \left( \frac{m_{\text{n}}}{m_{\text{p}}} \right) + E_{\text{trap}} - (32 R_{\text{V}} \hbar^3 \Theta^3)^{1/4} $$ (403)

Note that $E_{\text{trap}}$ is measured from the intrinsic level and not from the midgap. The zero-field lifetime $\tau_{\text{SRH}}$ is defined by Eq. 389.

## Hurkx Trap-Assisted Tunneling Model

The following equations apply to electrons and holes. Lifetimes and capture cross-sections become functions of the trap-assisted tunneling factor $g(F) = \Gamma_{\text{tat}}$ :

$$ \tau = \tau_0 / (1 + \Gamma_{\text{tat}}) \text{ , } \sigma = \sigma_0 (1 + \Gamma_{\text{tat}}) $$ (404)

where $\Gamma_{\text{tat}}$ is given by:

$$ \Gamma_{\text{tat}} = \int_{0}^{\tilde{E}_n} \exp \left[ u - \frac{2}{3} \frac{\sqrt{u^3}}{\tilde{E}} \right] du $$ (405)

with the approximate solutions:

$$ \Gamma_{\text{tat}} \approx \begin{cases} \sqrt{\pi} \tilde{E} \cdot \exp \left[ \frac{1}{3} \tilde{E}^2 \right] \left( 2 - \text{erfc} \left[ \frac{1}{2} \left( \frac{\tilde{E}_n}{\tilde{E}} - \tilde{E} \right) \right] \right), & \tilde{E} \le \sqrt{\tilde{E}_n} \\ \sqrt{\pi \tilde{E}} \cdot \tilde{E}_n^{1/4} \exp \left[ -\tilde{E}_n + \tilde{E} \sqrt{\tilde{E}_n} + \frac{1}{3} \frac{\sqrt{\tilde{E}_n^3}}{\tilde{E}} \right] \text{erfc} [\tilde{E}_n^{1/4} \sqrt{\tilde{E}} - \tilde{E}_n^{3/4} / \sqrt{\tilde{E}}], & \tilde{E} > \sqrt{\tilde{E}_n} \end{cases} $$ (406)

where $\tilde{E}$ and $\tilde{E}_n$ are respectively defined as:

$$ \tilde{E} = \frac{E}{E_0} \text{, where } E_0 = \frac{\sqrt{8 m_0 m_{\text{t}} k^3 T^3}}{q \hbar} $$ (407)

16: Generation–Recombination
Shockley–Read–Hall Recombination

$$ \tilde{E}_n = \frac{E_n}{kT} = \begin{cases} 0, & kT \ln \frac{n}{n_i} > 0.5 E_g \\ \frac{0.5 E_g}{kT} - \ln \frac{n}{n_i}, & E_{\text{trap}} \le kT \ln \frac{n}{n_i} \le 0.5 E_g \\ \frac{0.5 E_g}{kT} - \frac{E_{\text{trap}}}{kT}, & E_{\text{trap}} > kT \ln \frac{n}{n_i} \end{cases} \tag{408} $$

where $m_t$ is the carrier tunneling mass and $E_{\text{trap}}$ is an energy of trap level that is taken from SRH recombination if the model is applied to the lifetimes ($\tau$) or from trap equations if it is applied to cross sections ($\sigma$).

When quantization is active (see Chapter 14 on page 303), the classical density:

$$ n_{\text{cl}} = n \exp \left( \frac{\Lambda}{kT} \right) \tag{409} $$

rather than the true density $n$ enters Eq. 408.

The Hurkx model has only one parameter, $m_t$, the carrier tunneling mass, which can be specified in the parameter file for electrons and holes as follows:

```
HurkxTrapAssistedTunneling {
     mt = <value>, <value>
}
```

## Density Correction for the Schenk and Hurkx Trap-Assisted Tunneling Models

In the original Schenk model [[8]]([8]), the density $n$ in Eq. 384 is replaced by:

$$ \tilde{n} = n \exp \left( - \frac{\gamma_n |\nabla E_{F,n}| (E_t - E_0)}{kTF} \right) \tag{410} $$

with $E_0$ and $E_t$ according to Eq. 400 and Eq. 401. $p$ is replaced by an analogous expression.

The parameters $\gamma_n = n / (n + n_{\text{ref}})$ and $\gamma_p = p / (p + p_{\text{ref}})$ are close to one for significantly large densities and vanish for small densities, switching off the density correction and improving numeric robustness. The reference densities $n_{\text{ref}}$ and $p_{\text{ref}}$ are specified (in cm<sup>-3</sup>) by the `DenCorRef` parameter pair in the `TrapAssistedTunneling` parameter set. They default to $10^3$ cm<sup>-3</sup>.

Parameters for the Schenk model are accessible in the `TrapAssistedTunneling` parameter set. The default parameters implemented in Sentaurus Device are related to the gold acceptor level: $E_{\text{trap}} = 0$ eV, $S = 3.5$, and $\hbar \omega_0 = 0.068$ eV.

16: Generation–Recombination
Shockley–Read–Hall Recombination

`TrapAssistedTunneling` provides a parameter `MinField` (specified in Vcm<sup>-1</sup>) used for smoothing at small electric fields. A value of zero (the default) disables smoothing.

# Dynamic Nonlocal Path Trap-Assisted Tunneling

The local Schenk and Hurkx trap-assisted tunneling (TAT) models described in SRH Field Enhancement on page 424 might not give accurate results at low temperatures or near abrupt junctions with a strong, nonuniform, electric field profile. Moreover, the local TAT models are not suitable for computing TAT in heterojunctions where the band edge is modulated by the material composition rather than the electric field.

In addition to the local Schenk and Hurkx TAT models, Sentaurus Device provides dynamic nonlocal path Schenk and Hurkx TAT models. These models take into account nonlocal TAT processes with the WKB transmission coefficient based on the exact tunneling barrier. In these models, electrons and holes are captured in or emitted from the defect level at different locations by the phonon-assisted tunneling process. As a result, the position-dependent electron and hole recombination rates as well as the recombination rate at the defect level are all different. For each location and for each carrier type, the tunneling path is determined dynamically based on the energy band profile rather than predefined by the nonlocal mesh. Therefore, these models do not require user-specification of the nonlocal mesh.

> **NOTE** The nonlocal path TAT models are not suitable for AC or noise analysis as nonlocal derivative terms in the Jacobian matrix are not taken into account. The lack of derivative terms can degrade convergence when the high-field saturation mobility model is switched on, or when the series resistance is defined at electrodes, or when there is a floating region.

## Recombination Rate

To compute the net electron recombination rate, the model dynamically searches for the tunneling path with the following assumptions:

*   The tunneling path is a straight line with its direction equal to the gradient of the conduction band at the starting position.

*   The tunneling energy is equal to the conduction band energy at the starting position and is equal to the defect level ($E_{\text{T}}(x) = E_{\text{trap}}(x) + E_{\text{i}}(x)$) at the ending position.

*   Electrons can be captured in or emitted from the defect level at any location between the starting position and the ending position of the tunneling path.

*   When the tunneling path encounters Neumann boundaries or semiconductor–insulator interfaces, it undergoes specular reflection.

16: Generation–Recombination
Shockley–Read–Hall Recombination

For a given tunneling path of length $l$ that starts at $x = 0$ and ends at $x = l$, electron capture and emission between the conduction band at $x = 0$ and the defect level at any position $x$ for $0 \le x \le l$ is possible. As a result, the net electron recombination rate at $x = 0$ from the conduction band due to the TAT process $R_{net, n}^{TAT}$ involves integration along the path as follows:

$$ R_{net, n}^{TAT} = C_n \int_0^l \frac{\Gamma_C(x, E_C(0))}{\tau_n(x)} \frac{T(0) + T(x)}{2\sqrt{T(0)T(x)}} \left[ \exp \left[ \frac{E_{F, n}(0) - E_C(0)}{kT(0)} \right] f^p(x) - \exp \left[ \frac{E_T(x) - E_C(0)}{kT(x)} \right] f^n(x) \right] dx $$ (411)

$$ C_n = |\nabla E_C(0)| \frac{N_C(0)}{kT(0)} \left( \exp \left[ \frac{E_{F, n}(0) - E_C(0)}{kT(0)} \right] + 1 \right)^{-\alpha} $$ (412)

$$ \Gamma_C(x, \varepsilon) = W_C(x, \varepsilon) \exp \left( -2 \int_0^x \kappa_C(x, \varepsilon) dr \right) $$ (413)

where:

*   $\tau_n$ is the electron lifetime.

*   $\alpha = 0$ for Boltzmann statistics and $\alpha = 1$ for Fermi–Dirac statistics.

*   $f^n$ is the electron occupation probability at the defect level.

*   $f^p$ is the hole occupation probability at the defect level.

*   $\kappa_C$ is the magnitude of the imaginary wavevector obtained from the effective mass approximation or from the Franz two-band dispersion relation (Eq. 808, p. 781).

*   $W_C(x, \varepsilon) = 1$ for the nonlocal Hurkx TAT model. For the nonlocal Schenk TAT model, $W_C(x, \varepsilon)$ is modeled as:

$$ W_C(x, \varepsilon) = \frac{\hbar [E_C(x) - E_C(0)] \exp(0.5) W[\varepsilon - E_T(x)]}{4x [E_C(x) - E_T(x)] \sqrt{\pi m_C kT(x) W[E_C(x) + kT(x)/2 - E_T(x)]}} $$ (414)

$$ W(\varepsilon) = \frac{1}{\sqrt{\chi}} \exp \left( \frac{\varepsilon}{2kT} + \chi \right) \left( \frac{z}{l + \chi} \right)^l $$ (415)

where:

*   $\chi = \sqrt{l^2 + z^2}$.

*   $l = \varepsilon / \hbar \omega_0$.

*   $z = S / \sinh(\hbar \omega_0 / 2kT)$.

*   $\hbar \omega_0$ is the phonon energy.

*   $S$ is the Huang–Rhys constant.

Shockley–Read–Hall Recombination

The net hole recombination rate can be obtained in a similar way. The quasistatic electron and hole occupation probabilities at the defect level can be determined by balancing the net electron capture rate and the net hole capture rate.

## Using the Dynamic Nonlocal Path Trap-Assisted Tunneling Model

The model is activated in the `SRH` option as follows:

```
Recombination( ...
    SRH( ...
        NonlocalPath (
            Lifetime = Schenk | Hurkx    # Hurkx model is used by default
            Fermi | -Fermi               # use alpha=1 (alpha=0 by default)
            TwoBand | -TwoBand    # use Franz two-band dispersion (off by default)
        )
    )
)
```

`Lifetime=Hurkx` (default) selects the nonlocal Hurkx model, while `Lifetime=Schenk` selects the nonlocal Schenk model. The `Fermi` option sets $\alpha$ equal to 1 ($\alpha = 0$ by default). The `TwoBand` option activates the Franz two-band dispersion (Eq. 808, p. 781) instead of the effective mass approximation for the computation of the imaginary wavevector.

The nonlocal path TAT model introduces no additional model parameters. The same minority carrier lifetime for the SRH model is used in the nonlocal path TAT model. The doping- and temperature-dependent lifetime as well as the lifetime loaded from file can be specified together with the nonlocal path TAT model.

**NOTE** The SRH field-enhancement model must not be used with the nonlocal path TAT model to avoid double-counting of the TAT process.

The nonlocal Hurkx model uses the tunneling mass specified in the `HurkxTrapAssistedTunneling` parameter set. The tunneling mass, the phonon energy, and the Huang–Rhys coupling constant for the nonlocal Schenk model are specified in the `TrapAssistedTunneling` parameter set.

The maximum length of the tunneling path is determined by the `MaxTunnelLength` parameter in the `Band2BandTunneling` parameter set.

You can consider electron TAT from Schottky contacts or Schottky metal–semiconductor interfaces using the nonlocal path TAT model. To consider the electron capture and emission from the Schottky contact, you must specify the parameter `TATNonlocalPathNC`, which represents the room temperature effective density-of-states ($N_C(300\text{K})$) for the Schottky contact in the electrode-specific `Physics` section.

16: Generation–Recombination
Shockley–Read–Hall Recombination

For example:

```
Physics (electrode = "source") { ...
  TATNonlocalPathNC = 2.0e19
}
```

Similarly, to consider the TAT from the Schottky metal–semiconductor interface, you must specify the room temperature effective density-of-states in the corresponding interface-specific Physics section. For example:

```
Physics (MaterialInterface = "Gold/Silicon") { ...
  TATNonlocalPathNC = 2.0e19
}
```

Sentaurus Device assumes that the effective density-of-states at $T$ follows:

$$ N_C(T) = N_C(300\text{K}) \left( \frac{T}{300\text{K}} \right)^{\frac{3}{2}} \tag{416} $$

Electron and hole recombination rates and the recombination rate at the defect level can be plotted as:

```
Plot { ...
  eSRHRecombination    # electron recombination rate
  hSRHRecombination    # hole recombination rate
  tSRHRecombination    # recombination rate at the defect level
}
```

# Trap-Assisted Auger Recombination Model

The trap-assisted Auger (TAA) recombination model is a modification of the SRH recombination and coupled defect level recombination models (see Shockley–Read–Hall Recombination on page 419 and Coupled Defect Level Recombination on page 433).

When TAA is active, Sentaurus Device uses the lifetimes [4]:

$$ \frac{\tau_p}{1 + \tau_p / \tau_p^{\text{TAA}}} \tag{417} $$

$$ \frac{\tau_n}{1 + \tau_n / \tau_n^{\text{TAT}}} \tag{418} $$

instead of the lifetimes $\tau_p$ and $\tau_n$ in Eq. 384 and Eq. 425.

Surface SRH Recombination Model

The TAA lifetimes in Eq. 417 depend on the carrier densities:

$$ \frac{1}{\tau_{n}^{\text{TAA}}} \approx C_{p}^{\text{TAA}}(n + p) \tag{419} $$

$$ \frac{1}{\tau_{p}^{\text{TAA}}} \approx C_{n}^{\text{TAA}}(n + p) \tag{420} $$

A reasonable order of magnitude for the TAA coefficients $C_{n}^{\text{TAA}}$ and $C_{p}^{\text{TAA}}$ is $1 \times 10^{-12} \text{ cm}^{3}\text{s}^{-1}$ to $1 \times 10^{-11} \text{ cm}^{3}\text{s}^{-1}$; the default values are $C_{n}^{\text{TAA}} = C_{p}^{\text{TAA}} = 1 \times 10^{-12} \text{ cm}^{3}\text{s}^{-1}$.

TAA recombination is activated by using the keyword `TrapAssistedAuger` in the `Recombination` statement in the `Physics` section (see Table 232 on page 1557):

```
Physics {
   Recombination(TrapAssistedAuger ...)
   ...
}
```

The trap-assisted Auger parameters $C_{n}^{\text{TAA}}$ and $C_{p}^{\text{TAA}}$ are accessible in the parameter set `TrapAssistedAuger`.

# Surface SRH Recombination Model

You can activate the surface SRH recombination model at semiconductor–semiconductor and semiconductor–insulator interfaces (see Interface-Specific Models on page 20).

At interfaces, an additional formula is used that is structurally equivalent to the bulk expression of the SRH generation–recombination:

$$ R_{\text{surf, net}}^{\text{SRH}} = \frac{np - n_{i,\text{eff}}^{2}}{(n + n_{1})/s_{p} + (p + p_{1})/s_{n}} \tag{421} $$

with:

$$ n_{1} = n_{i,\text{eff}} \exp\left(\frac{E_{\text{trap}}}{kT}\right) \text{ and } p_{1} = n_{i,\text{eff}} \exp\left(\frac{-E_{\text{trap}}}{kT}\right) \tag{422} $$

For Fermi statistics and quantization, the equations are modified in the same way as for bulk SRH recombination (see Eq. 388).

The recombination velocities of otherwise identically prepared surfaces depend, in general, on the concentration of dopants at the surface [[9]](9)[[10]](10)[[11]](11).

16: Generation–Recombination

Coupled Defect Level Recombination

Particularly, in cases where the doping concentration varies along an interface, including such a doping dependence is advised. Sentaurus Device models doping dependence of surface recombination velocities according to:

$$ s = s_0 \left[ 1 + s_{\text{ref}} \left( \frac{N_i}{N_{\text{ref}}} \right)^\gamma \right] $$ (423)

The results of Cuevas [[11]]([11]) indicate that for phosphorus-diffused silicon, $\gamma = 1$. The results of King and Swanson [[10]]([10]) imply that no significant doping dependence exists for the recombination velocities of boron-diffused silicon surfaces.

To activate the model, specify the option `SurfaceSRH` to the `Recombination` keyword in the `Physics` section for the respective interface. To plot the surface recombination, specify `SurfaceRecombination` in the `Plot` section. The parameters $E_{\text{trap}}$, $s_{\text{ref}}$, $N_{\text{ref}}$, and $\gamma$ are accessible in the parameter set `SurfaceRecombination`.

Table 80 Parameters of the surface SRH recombination model for silicon

| Symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |
| $s_0$ | S0 | $1 \times 10^3$ | $1 \times 10^3$ | cm/s |
| $s_{\text{ref}}$ | Sref | $1 \times 10^{-3}$ |  | 1 |
| $N_{\text{ref}}$ | Nref | $1 \times 10^{16}$ |  | cm$^{-3}$ |
| $\gamma$ | gamma | 1 |  | 1 |
| $E_{\text{trap}}$ | Etrap | 0 |  | eV |

The doping dependence of the recombination velocity can be suppressed by setting $s_{\text{ref}}$ to zero.

> **NOTE** The `SurfaceSRH` keyword also is supported for metal–semiconductor interfaces, but the model activated there differs from the one described here (see Electric Boundary Conditions for Metals on page 250).

---

# Coupled Defect Level Recombination

The steady-state recombination rate for two coupled defect levels (CDLs) generalizes the familiar single-level SRH formula. An important feature of the model is a possibly increased field effect that might lead to large excess currents. The model is discussed in the literature [[12]]([12]). Figure 20 on page 434 illustrates the notation of the model parameters.

Coupled Defect Level Recombination

Notation for CDL recombination including all capture and emission processes

Figure 20 Notation for CDL recombination including all capture and emission processes

The CDL recombination rate is given by:

$$ R = R_1 + R_2 + \left( \sqrt{R_{12}^2 - S_{12}} - R_{12} \right) \times \frac{\tau_{n1}\tau_{p2}(n + n_2)(p + p_1) - \tau_{n2}\tau_{p1}(n + n_1)(p + p_2)}{r_1 r_2} $$ (424)

with:

$$ r_j = \tau_{nj}(p + p_j) + \tau_{pj}(n + n_j) $$ (425)

$$ R_j = \frac{np - n_{i,\text{eff}}^2}{r_j} \text{ , } j = 1, 2 $$ (426)

$$ R_{12} = \frac{r_1 r_2}{2r_{12}\tau_{n1}\tau_{n2}\tau_{p1}\tau_{p2}(1 - \varepsilon)} + \frac{\tau_{n1}(p + p_1) + \tau_{p2}(n + n_2)}{2\tau_{n1}\tau_{p2}(1 - \varepsilon)} + \frac{\varepsilon[\tau_{n2}(p + p_2) + \tau_{p1}(n + n_1)]}{2\tau_{n2}\tau_{p1}(1 - \varepsilon)} $$ (427)

$$ S_{12} = \frac{1}{\tau_{n1}\tau_{p2}(1 - \varepsilon)} \left( 1 - \frac{\tau_{n1}\tau_{p2}}{\tau_{n2}\tau_{p1}} \varepsilon \right) (np - n_{i,\text{eff}}^2) $$ (428)

$$ \varepsilon = \exp \left( -\frac{|E_{t2} - E_{t1}|}{kT} \right) $$ (429)

where $\tau_{ni}$ and $\tau_{pi}$ denote the electron and hole lifetimes of the defect level $i$. The coupling parameter between the defect levels is called $r_{12}$ (keyword `TrapTrapRate` in the parameter file). Carrier lifetimes are calculated analogously to carrier lifetimes in the SRH model (see Shockley–Read–Hall Recombination on page 419). The number of parameters is doubled compared to the SRH model, and you can change them in the `CDL` parameter set.

The quantities $n_2$ and $p_2$ are the corresponding quantities of $n_1$ and $p_1$ for the second defect level. They are defined analogously to Eq. 385, p. 419 and Eq. 386, p. 419.

For Fermi statistics and quantization, the equations are modified in the same way as for SRH recombination (see Eq. 388, p. 420).

16: Generation–Recombination
Radiative Recombination Model

# Using Coupled Defect Level Recombination

You can switch on CDL recombination using the keyword `CDL` in the `Physics` section:

```
Physics{ Recombination( CDL ...) ...}
```

The contributions $R_1$ and $R_2$ in Eq. 426 can be plotted using the keywords `CDL1` and `CDL2` in the `Plot` section. For the net rate and coupling term, $R - R_1 - R_2$, the keywords `CDL` and `CDL3` must be specified.

# Radiative Recombination Model

The radiative (direct) recombination model expresses the recombination rate as:

$$ R_{\text{net}} = C \cdot (np - n_{i,\text{eff}}^2) $$ (430)

By default, Sentaurus Device selects $C = 2 \times 10^{-10} \text{ cm}^3 \text{s}^{-1}$ for GaAs and $C = 0 \text{ cm}^3 \text{s}^{-1}$ for other materials. For Fermi statistics and quantization, the equations are modified in the same way as for SRH recombination (see Eq. 388, p. 420).

## Using the Radiative Recombination Model

The keyword `Radiative` in the `Physics` section activates the radiative recombination model:

```
Physics { Recombination (Radiative) }
```

The model can also be switched on or off using the notation `+Radiative` or `-Radiative`:

```
Physics (Region = "gate") {
  Recombination (+Radiative)
}

Physics (Material = "AlGaAs") {
  Recombination (-Radiative)
}
```

The value of the radiative recombination rate is plotted as follows:

```
Plot { RadiativeRecombination }
```

The value of the parameter $C$ can be changed in the parameter file:

```
RadiativeRecombination { C = 2.5e-10 }
```

16: Generation–Recombination

Auger Recombination Model

# Auger Recombination Model

The rate of band-to-band Auger recombination $R_{\text{net}}^{\text{A}}$ is given by:

$$R_{\text{net}}^{\text{A}} = \left( C_n n + C_p p \right) \left( np - n_{i,\text{eff}}^2 \right) \eqno(431)$$

with temperature-dependent Auger coefficients [13][14][15]:

$$C_n(T) = \left( A_{\text{A},n} + B_{\text{A},n} \left( \frac{T}{T_0} \right) + C_{\text{A},n} \left( \frac{T}{T_0} \right)^2 \right) \left[ 1 + H_n \exp \left( -\frac{n}{N_{0,n}} \right) \right] \eqno(432)$$

$$C_p(T) = \left( A_{\text{A},p} + B_{\text{A},p} \left( \frac{T}{T_0} \right) + C_{\text{A},p} \left( \frac{T}{T_0} \right)^2 \right) \left[ 1 + H_p \exp \left( -\frac{p}{N_{0,p}} \right) \right] \eqno(433)$$

where $T_0 = 300\text{ K}$. There is experimental evidence for a decrease of the Auger coefficients at high injection levels [15]. This effect is explained as resulting from exciton decay: at lower carrier densities, excitons, which are loosely bound electron–hole pairs, increase the probability for Auger recombination. Excitons decay at high carrier densities, resulting in a decrease of recombination. This effect is modeled by the terms $1 + H \exp(-n/N_0)$ in Eq. 432 and Eq. 433.

Auger recombination is typically important at high carrier densities. Therefore, this injection dependence is seen only in devices where extrinsic recombination effects are extremely low, such as high-efficiency silicon solar cells. The injection dependence of the Auger coefficient can be deactivated by setting $H$ to zero in the parameter file.

For Fermi statistics and quantization, the equations are modified in the same way as for SRH recombination (see Eq. 388, p. 420). Table 81 lists the default values for silicon.

Table 81 Coefficients of the Auger recombination model

| Symbol | $A_{\text{A}} \text{ [cm}^6 \text{ s}^{-1}\text{]}$ | $B_{\text{A}} \text{ [cm}^6 \text{ s}^{-1}\text{]}$ | $C_{\text{A}} \text{ [cm}^6 \text{ s}^{-1}\text{]}$ | $H \text{ [1]}$ | $N_0 \text{ [cm}^{-3}\text{]}$ |
| --- | --- | --- | --- | --- | --- |
| Parameter name | A | B | C | H | NO |
| Electrons | $6.7 \times 10^{-32}$ | $2.45 \times 10^{-31}$ | $-2.2 \times 10^{-32}$ | 3.46667 | $1 \times 10^{18}$ |
| Holes | $7.2 \times 10^{-32}$ | $4.5 \times 10^{-33}$ | $2.63 \times 10^{-32}$ | 8.25688 | $1 \times 10^{18}$ |

**16: Generation–Recombination**
Intrinsic Recombination Model for Silicon

# Using the Auger Recombination Model

The model is activated by the argument `Auger` in the `Recombination` statement:

```
Physics{ Recombination( Auger ...) ...}
```

By default, Sentaurus Device uses Eq. 431 only if $R_{\text{net}}^{\text{A}}$ is positive and replaces the value by zero if $R_{\text{net}}^{\text{A}}$ is negative. To use Eq. 431 for negative values (that is, to allow for Auger net generation of electron–hole pairs), use the `WithGeneration` option to the `Auger` keyword:

```
Physics { Recombination( Auger(WithGeneration) ...) ...}
```

The Auger parameters are accessible in the `Auger` parameter set.

# Intrinsic Recombination Model for Silicon

With improvements in the quality of silicon bulk material, the technological progress of passivation techniques, and advanced characterization methods, an accurate description of the intrinsic recombination mechanisms of silicon became important to predict the performance of silicon-based devices. Richter et al. [16] developed a model to describe intrinsic recombination in crystalline silicon at 300 K covering a wide range of doping and carrier injection levels. The intrinsic recombination rate is calculated according to:

$$ R_{\text{intrinsic}} = (np - n_{i, \text{eff}}^2) [C_{n0} \cdot g_{\text{eeh}}(n_0) \cdot n_0 + C_{p0} \cdot g_{\text{ehh}}(p_0) \cdot p_0 + C_{\Delta n} \cdot \Delta n^{\text{exp}_{\Delta n}} + B_{\text{low}} \cdot B_{\text{rel}}(n, p)] \qquad (434) $$

The first two terms in the brackets stand for the common Auger expression with Coulomb enhancement factors $g_{\text{eeh}}$ and $g_{\text{ehh}}$, which are dominant in the low-injection condition.

$n, p$ describe the electron and hole carrier concentrations, $n_{i, \text{eff}}$ is the effective intrinsic carrier density, and $n_0, p_0$ denote the electron and hole concentration at thermal equilibrium (zero voltage applied), that is, for p-type doping:

$$ p_0 = N_a - N_d \qquad n_0 = \frac{n_{i, \text{eff}}^2}{p_0} \qquad (435) $$

For n-type doping:

$$ n_0 = N_d - N_a \qquad p_0 = \frac{n_{i, \text{eff}}^2}{n_0} \qquad (436) $$

$N_a$ is the total acceptor doping concentration, and $N_d$ is the total donor doping concentration.

Intrinsic Recombination Model for Silicon

The Coulomb enhancement factors $g_{eeh}$ and $g_{ehh}$ account for the enhanced probability of finding an electron and a hole in the immediate vicinity of each other:

$$ g_{eeh}(n_0) = 1 + C_{geeh} \left\{ 1 - \tanh \left[ \left( \frac{n_0}{N_{0, eeh}} \right)^{E_{geeh}} \right] \right\} $$ (437)

$$ g_{ehh}(p_0) = 1 + C_{gehh} \left\{ 1 - \tanh \left[ \left( \frac{p_0}{N_{0, ehh}} \right)^{E_{gehh}} \right] \right\} $$ (438)

The third term in the brackets of Eq. 434 is proportional to the excess carrier density $\Delta n$ and describes the Auger recombination for the high-injection condition.

The last term in the brackets of Eq. 434 describes the injection-dependent radiative recombination according to Altermatt *et al.* [17]<sup>1</sup>:

$$ B_{\text{rel}}(n, p) = b_{\text{min}} + \frac{b_{\text{max}} - b_{\text{min}}}{1 + \left( \frac{n + p}{b_1} \right)^{b_2} + \left( \frac{n + p}{b_3} \right)^{b_4}} $$ (439)

with:

$$ b_{\text{min}} = r_{\text{max}} + \frac{r_{\text{min}} - r_{\text{max}}}{1 + \left( \frac{T}{r_1} \right)^{r_2}} $$ (440)

$$ b_1 = 2 \left[ s_{\text{max}} + \frac{s_{\text{min}} - s_{\text{max}}}{1 + \left( \frac{T}{s_1} \right)^{s_2}} \right] $$ (441)

$$ b_3 = 2 \left[ w_{\text{max}} + \frac{w_{\text{min}} - w_{\text{max}}}{1 + \left( \frac{T}{w_1} \right)^{w_2}} \right] $$ (442)

$T$ is the temperature.

You can switch on this model by specifying `intrinsicRichter` in the `Recombination` section, which has been implemented as an installed PMI model.

<sup>1. For Eq. 439, Reference [17] notes the terms $n + p / b_1$ and $n + p / b_2$, instead of $(n + p) / b_1$ and $(n + p) / b_2$. In addition, a factor of 2 is missing in Eq. 441 and Eq. 442. This has been verified with the author and corrected in the implementation.</sup>

16: Generation–Recombination

Intrinsic Recombination Model for Silicon

**NOTE** To plot the spatial distribution of this recombination in the TDR file, add `PMIRecombination` as a plot variable.

The model parameters can be set in the Sentaurus Device parameter file section:

```
Material = "Silicon" {
   intrinsicRichter {
      blow=4.73e-15
      rmax=0.25
      ...
   }
}
```

The parameter name and default value for each constant in Eq. 434–Eq. 442 are taken from [16] and [17], and are listed in Table 82.

Table 82 Parameters and default values for constants

| Constant | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| Blow | Blow | 4.73e-15 | cm3/s |
| bmax | bmax | 1 | 1 |
| b2 | b2 | 0.54 | 1 |
| b4 | b4 | 1.25 | 1 |
| rmax | rmax | 0.2 | 1 |
| rmin | rmin | 0 | 1 |
| r1 | r1 | 320 | K |
| r2 | r2 | 2.5 | 1 |
| smax | smax | 1.5e18 | cm-3 |
| smin | smin | 1e7 | cm-3 |
| s1 | s1 | 550 | K |
| s2 | s2 | 3 | 1 |
| wmax | wmax | 4e18 | cm-3 |
| wmin | wmin | 1e9 | cm-3 |
| w1 | w1 | 365 | K |
| w2 | w2 | 3.54 | 1 |
| Cn0 | cn0 | 2.5e-31 | cm6/s |
| Cgeeh | geehC | 13 | 1 |
| N0, eeh | N0eeh | 3.3e17 | cm-3 |

Constant Carrier Generation Model

Table 82 Parameters and default values for constants (Continued)

| Constant | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| Egeeh | geehE | 0.66 | 1 |
| Cp0 | cp0 | 8.5e-32 | cm6/s |
| Cgehh | gehhC | 7.5 | 1 |
| N0, ehh | N0ehh | 7e17 | cm-3 |
| Egehh | gehhE | 0.63 | 1 |
| CΔn | cDn | 3e-29 | cm6/s |
| expΔn | expDn | 0.92 | 1 |

# Constant Carrier Generation Model

The simplest generation model computes a constant carrier generation G<sub>const</sub> and is activated in the `Physics` section as follows:

```
Physics {
  Recombination (
    ConstantCarrierGeneration (value = 1e10)  # [cm^-3 s^-1]
  )
}
```

Alternatively, the value of G<sub>const</sub> can be specified in the parameter file:

```
ConstantCarrierGeneration {
  value = 1e10                # [cm^-3 s^-1]
}
```

You can ramp the generation rate by specifying a corresponding `Goal` in a `Quasistationary` command:

```
Goal { Model = "ConstantCarrierGeneration"
       Parameter = "value"
       Value = 1e20
}
```

To visualize G<sub>const</sub>, plot the value of `PMIRecombination`:

```
Plot {
  PMIRecombination
}
```

The model also can be specified regionwise or materialwise.

16: Generation–Recombination
Avalanche Generation

**NOTE** The constant carrier generation model is functionally equivalent to the constant optical generation model (see Constant Optical Generation on page 602).

# Avalanche Generation

Electron–hole pair production due to avalanche generation (impact ionization) requires a certain threshold field strength and the possibility of acceleration, that is, wide space charge regions. If the width of a space charge region is greater than the mean free path between two ionizing impacts, charge multiplication occurs, which can cause electrical breakdown. The reciprocal of the mean free path is called the ionization coefficient $\alpha$. With these coefficients for electrons and holes, the generation rate can be expressed as:

$$ G_{ii} = \frac{1}{q} (\alpha_n |\vec{J_n}| + \alpha_p |\vec{J_p}|) $$ (443)

where $\vec{J_n}$ and $\vec{J_p}$ are the electron and hole current density vectors described in Introduction to Carrier Transport Models on page 189.

Sentaurus Device implements several models for the ionization coefficients: van Overstraeten – de Man, Okuto–Crowell, Lackner, University of Bologna, the new University of Bologna, and Hatakeyama.

Sentaurus Device allows you to select the appropriate driving force for the simulation, that is, the method used to compute the accelerating field. Choices include `GradQuasiFermi`, `Eparallel`, `CarrierTempDrive`, and `ElectricField` (see Driving Force on page 455).

## Using Avalanche Generation

Avalanche generation is switched on by using the keyword `Avalanche` in the `Recombination` statement in the `Physics` section. The keywords `eAvalanche` and `hAvalanche` specify separate models or driving forces for the electron and hole ionization coefficients, respectively.

The model is selected by using one of the keywords `vanOverstraeten`, `Okuto`, `Lackner`, `UniBo`, `UniBo2`, or `Hatakeyama`. The default model is `vanOverstraeten`.

The driving force is selected using one of the keywords `GradQuasiFermi`, `Eparallel`, `CarrierTempDrive`, or `ElectricField`. The default driving force is `GradQuasiFermi`.

Avalanche Generation

The following example selects the default van Overstraeten – de Man model for the electron impact ionization process with a driving force derived from electron temperature, and selects the Okuto–Crowell model for holes using the default driving force based on `GradQuasiFermi`:

```
Physics {
  Recombination(eAvalanche(CarrierTempDrive) hAvalanche(Okuto)... )
}
```

To include a dependency on energy bandgap in the avalanche generation models, specify the keyword `BandgapDependence` as an argument to `Avalanche`, `eAvalanche`, or `hAvalanche` (see the model descriptions in the next sections). For example:

```
Physics {
  Recombination(Avalanche(Lackner BandgapDependence))
}
```

To plot the avalanche generation rate, specify `AvalancheGeneration` in the `Plot` section. To plot either of the two terms on the right-hand side of Eq. 443 separately, specify `eAvalanche` or `hAvalanche`. To plot $\alpha_n$ or $\alpha_p$, specify `eAlphaAvalanche` or `hAlphaAvalanche`, respectively.

By default, the electron and hole current density vectors $\vec{J}_n$ and $\vec{J}_p$ in Eq. 443 are computed in a mesh element using the Scharfetter–Gummel approximation applied to each element edge (see Discretization on page 1133). This is consistent with the computation of $\nabla \cdot \vec{J}_n$ and $\nabla \cdot \vec{J}_p$ in Eq. 57, p. 189. This approximation is a good one to describe structures where the current density is low along the direction of large electrostatic potential change, such as the channel area of a MOSFET, but such a condition of low current density in the direction of potential change might not be satisfied for power-device applications. As a result, the Scharfetter–Gummel approximation in the avalanche generation term might lead to a requirement to have a very fine mesh or might result in small steps to be taken at a voltage ramp.

To overcome these issues, you can use another approximation for $\vec{J}_n$ and $\vec{J}_p$ in Eq. 443, which is based on the representation of these current density vectors as $\vec{J}_n = -q \mu_n n \nabla \Phi_n$ and $\vec{J}_p = -q \mu_p p \nabla \Phi_p$ (see Eq. 60, p. 191 and Eq. 61, p. 191). This approximation assumes that the carrier densities $n$ and $p$ are constant in elements and also makes the current density vectors constant in an element. Typically, you could see a small change in the breakdown voltage with this approximation, but it provides better convergence and stability properties.

To activate this alternative approximation, specify:

```
Math {
  AvalDensGradQF
}
```

The contribution that avalanche generation makes to the device equations is determined by multiplying the avalanche generation rate by the element-vertex control volumes (areas in two

16: Generation–Recombination
Avalanche Generation

dimensions) computed by the `AverageBoxMethod` algorithm. However, as noted in Truncated Obtuse Elements on page 1138, the total vertex control volume for an obtuse element is not the same as the total geometric volume for the element and can sometimes be several times larger. This can result in an exaggerated number of avalanche-generated carriers from such elements, which can contribute to premature breakdown. This might be the case if you observe that the breakdown voltage is much lower than expected, and the avalanche generation in the structure is confined to one or a few elements. To prevent this, an option is available to use truncated element-vertex volumes for avalanche calculations, where the total truncated vertex volume for an element is exactly equal to the geometric volume. To activate this option, specify:

```
Math {
  ElementVolumeAvalanche
}
```

Sometimes, mostly for 3D breakdown simulations, nearly flat elements can cause convergence and premature breakdown problems (due to singular numeric errors). Such nearly flat elements have a very small volume and excluding these elements does not affect breakdown voltage, but it helps to resolve problems with numeric singularity. To exclude such elements from the avalanche generation calculations, use the following keyword:

```
Math {
  AvalFlatElementExclusion = <float> #[0 to 90 degree]
}
```

In two dimensions, this keyword excludes elements from contributing to avalanche generation if all the angles are less than the specified value or larger than the 180°-specified value. In three dimensions, this keyword excludes elements if the maximum vertex *volume angle* for the element is less than the specified value, where the vertex volume angle is computed as the arcsine of the unit-edge volume (scalar triple product of the unit vectors along the three element edges that meet at the vertex).

> **NOTE** This keyword excludes only flat elements that, by definition, have poor angles at every vertex (very close to 0° or 180° in two dimensions). In three dimensions, for the case of a 90° angle between three edges of a vertex in an element (this case represents a good element), the vertex unit-edge volume is the maximum (equal to 1), and this makes the vertex volume angle equal to 90° as well. For a nearly flat element, both the unit-edge volume and the volume angle are nearly zero.

> The value of `AvalFlatElementExclusion` must not exceed 1–2°. Otherwise, too many elements might be excluded from the avalanche generation, causing a shift in breakdown voltage to higher values.

Avalanche Generation

To control and see the locations of nearly flat elements in a device structure, you can specify an option to plot the minimum and maximum volume angles for each element as follows:

```
Plot {
  AvalFlatElementMin/Element AvalFlatElementMax/Element
}
```

## van Overstraeten – de Man Model

This model is based on the Chynoweth law [18]:

$$ \alpha(F_{\text{ava}}) = \gamma a \exp(-\frac{\gamma b}{F_{\text{ava}}}) $$ (444)

with:

$$ \gamma = \frac{\tanh(\frac{\hbar\omega_{\text{op}}}{2kT_0})}{\tanh(\frac{\hbar\omega_{\text{op}}}{2kT})} $$ (445)

The factor $\gamma$ with the optical phonon energy $\hbar\omega_{\text{op}}$ expresses the temperature dependence of the phonon gas against which carriers are accelerated. The coefficients $a$, $b$, and $\hbar\omega_{\text{op}}$, as measured by van Overstraeten and de Man [19], apply to fields in the range from $1.75 \times 10^5 \text{ Vcm}^{-1}$ to $6 \times 10^5 \text{ Vcm}^{-1}$ and are listed in Table 83 on page 445.

Different values for $a$ and $b$ are used for high and low electric fields. The values `a(low)`, `b(low)` are used in the low field range up to $E_0$, and the values `a(high)`, `b(high)` are used in the high field above $E_0$.

If `BandgapDependence` is specified as an argument to `Avalanche`, the coefficient $b$ in Eq. 444 is replaced with:

$$ b \rightarrow \frac{\beta E_g}{q\lambda} $$ (446)

where $E_g$ is the energy bandgap, $\lambda$ is the optical-phonon mean free path for the carrier, and $\beta$ is a proportionality constant. Table 83 lists the default values for $\lambda$ and $\beta$.

You can adjust the parameters in the `vanOverstraetendeMan` parameter set.

16: Generation–Recombination
Avalanche Generation

Table 83 Parameters of van Overstraeten – de Man model (Eq. 444) for silicon

| Symbol | Parameter name | Default value | Valid range of electric field | Unit |  |
| --- | --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |  |
| a | a(low) | 7.03 × 10⁵ | 1.582 × 10⁶ | 1.75×10⁵ Vcm⁻¹ to E₀ | cm⁻¹ |
| a(high) | 7.03 × 10⁵ | 6.71 × 10⁵ | E₀ to 6×10⁵ Vcm⁻¹ |  |  |
| b | b(low) | 1.231 × 10⁶ | 2.036 × 10⁶ | 1.75×10⁵ Vcm⁻¹ to E₀ | V/cm |
| b(high) | 1.231 × 10⁶ | 1.693 × 10⁶ | E₀ to 6×10⁵ Vcm⁻¹ |  |  |
| E₀ | E0 | 4 × 10⁵ | 4 × 10⁵ |  | V/cm |
| hωop | hbarOmega | 0.063 | 0.063 |  | eV |
| λ | lambda | 62 × 10⁻⁸ | 45 × 10⁻⁸ |  | cm |
| β | beta(low) | 0.678925 | 0.815009 | 1.75×10⁵ Vcm⁻¹ to E₀ | 1 |
| beta(high) | 0.678925 | 0.677706 | E₀ to 6×10⁵ Vcm⁻¹ |  |  |

# Okuto–Crowell Model

Okuto and Crowell [20] suggested the empirical model:

$$ \alpha(F_{\text{ava}}) = a \cdot (1 + c(T - T_0)) F_{\text{ava}}^\gamma \exp \left[ -\left( \frac{b[1 + d(T - T_0)]}{F_{\text{ava}}} \right)^\delta \right] $$ (447)

where $T_0 = 300\text{ K}$ and Table 84 on page 446 lists the user-adjustable parameters with their default values for silicon. These values apply to the range of the electric field from $10^5\text{ Vcm}^{-1}$ to $10^6\text{ Vcm}^{-1}$.

If `BandgapDependence` is specified as an argument to `Avalanche`, the coefficient $b$ in Eq. 447 is replaced with:

$$ b \rightarrow \frac{\beta E_g}{q\lambda} $$ (448)

where $E_g$ is the energy bandgap, $\lambda$ is the optical-phonon mean free path for the carrier, and $\beta$ is a proportionality constant. Table 84 lists the default values for $\lambda$ and $\beta$.

You can adjust the parameters in the `Okuto` parameter set.

Avalanche Generation

Table 84 Parameters of Okuto–Crowell model (Eq. 447) for silicon

| Symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |
| a | a | 0.426 | 0.243 | V–1 |
| b | b | 4.81 × 105 | 6.53 × 105 | V/cm |
| c | c | 3.05 × 10–4 | 5.35 × 10–4 | K–1 |
| d | d | 6.86 × 10–4 | 5.67 × 10–4 | K–1 |
| γ | gamma | 1 | 1 | 1 |
| δ | delta | 2 | 2 | 1 |
| λ | lambda | 62 × 10–8 | 45 × 10–8 | cm |
| β | beta | 0.265283 | 0.261395 | 1 |

# Lackner Model

Lackner [21] derived a pseudo-local ionization rate in the form of a modification to the Chynoweth law, assuming stationary conditions. The temperature-dependent factor γ was introduced to the original model:

$$ \alpha_{\nu}(F_{\text{ava}}) = \frac{\gamma a_{\nu}}{Z} \exp \left( -\frac{\gamma b_{\nu}}{F_{\text{ava}}} \right) \text{ where } \nu = n, p $$ (449)

with:

$$ Z = 1 + \frac{\gamma b_n}{F_{\text{ava}}} \exp \left( -\frac{\gamma b_n}{F_{\text{ava}}} \right) + \frac{\gamma b_p}{F_{\text{ava}}} \exp \left( -\frac{\gamma b_p}{F_{\text{ava}}} \right) $$ (450)

$$ \gamma = \frac{\tanh \left( \frac{\hbar \omega_{\text{op}}}{2kT_0} \right)}{\tanh \left( \frac{\hbar \omega_{\text{op}}}{2kT} \right)} $$ (451)

The default values for *a*, *b*, and $\hbar \omega_{\text{op}}$ apply to silicon for the range of the electric field from $10^5 \text{ Vcm}^{-1}$ to $10^6 \text{ Vcm}^{-1}$.

16: Generation–Recombination
Avalanche Generation

If `BandgapDependence` is specified as an argument to `Avalanche`, then $b$ in Eq. 449 and Eq. 450 is replaced with:

$$ b \rightarrow \frac{\beta E_g}{q \lambda} \tag{452} $$

where $E_g$ is the energy bandgap, $\lambda$ is the optical-phonon mean free path for the carrier, and $\beta$ is a proportionality constant.

The model parameters are accessible in the `Lackner` parameter set.

Table 85 Parameters of Lackner model (Eq. 449) for silicon

| Symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |
| $a$ | a | $1.316 \times 10^6$ | $1.818 \times 10^6$ | cm$^{-1}$ |
| $b$ | b | $1.474 \times 10^6$ | $2.036 \times 10^6$ | V/cm |
| $\hbar \omega_{op}$ | hbarOmega | 0.063 | 0.063 | eV |
| $\lambda$ | lambda | $62 \times 10^{-8}$ | $45 \times 10^{-8}$ | cm |
| $\beta$ | beta | 0.812945 | 0.815009 | 1 |

# University of Bologna Impact Ionization Model

This model was developed for an extended temperature range between 25°C and 400°C. It is based on impact ionization data generated by the Boltzmann solver HARM [22]. It covers a wide range of electric fields (50 kVcm⁻¹ to 600 kVcm⁻¹) and temperatures (300 K to 700 K). The model is calibrated against impact ionization measurements [23][24] in the whole temperature range.

For an updated version of this model, see New University of Bologna Impact Ionization Model on page 449.

The model reads:

$$ \alpha(F_{ava}, T) = \frac{F_{ava}}{a(T) + b(T) \exp \left[ \frac{d(T)}{F_{ava} + c(T)} \right]} \tag{453} $$

The temperature dependence of the model parameters, determined by fitting experimental data, reads (for electrons):

$$ a(T) = a_0 + a_1 t^{a_2} \quad b(T) = b_0 \quad c(T) = c_0 + c_1 t + c_2 t^2 \quad d(T) = d_0 + d_1 t + d_2 t^2 \tag{454} $$

Avalanche Generation

and for holes:

$$ a(T) = a_0 + a_1 t \quad b(T) = b_0 \exp[b_1 t] \quad c(T) = c_0 t^{c_1} \quad d(T) = d_0 + d_1 t + d_2 t^2 \quad (455) $$

where $t = T / 1\text{ K}$.

If `BandgapDependence` is specified as an argument to `Avalanche`, then $d(T)$ is modified as follows:

$$ d(T) \rightarrow \Big( \frac{\beta E_g}{q \lambda} / d_0 \Big) (d_0 + d_1 t + d_2 t^2) \quad (456) $$

where $E_g$ is the energy bandgap, $\lambda$ is the optical-phonon mean free path for the carrier, and $\beta$ is a proportionality constant.

The model parameters are accessible in the `UniBo` parameter set.

Table 86 Parameters of University of Bologna impact ionization model for silicon

| Symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |
| $a_0$ | ha0 | 4.3383 | 2.376 | V |
| $a_1$ | ha1 | $-2.42 \times 10^{-12}$ | $1.033 \times 10^{-2}$ | V |
| $a_2$ | ha2 | 4.1233 | 0 | 1 |
| $b_0$ | hb0 | 0.235 | 0.17714 | V |
| $b_1$ | hb1 | 0 | $-2.178 \times 10^{-3}$ | 1 |
| $c_0$ | hc0 | $1.6831 \times 10^4$ | $9.47 \times 10^{-3}$ | Vcm⁻¹ |
| $c_1$ | hc1 | 4.3796 | 2.4924 | Vcm⁻¹, 1 |
| $c_2$ | hc2 | 0.13005 | 0 | Vcm⁻¹, 1 |
| $d_0$ | hd0 | $1.2337 \times 10^6$ | $1.4043 \times 10^6$ | Vcm⁻¹ |
| $d_1$ | hd1 | $1.2039 \times 10^3$ | $2.9744 \times 10^3$ | Vcm⁻¹ |
| $d_2$ | hd2 | 0.56703 | 1.4829 | Vcm⁻¹ |
| $\lambda$ | lambda | $62 \times 10^{-8}$ | $45 \times 10^{-8}$ | cm |
| $\beta$ | beta | 0.680414 | 0.562140 | 1 |

16: Generation–Recombination
Avalanche Generation

**NOTE** When you select the University of Bologna impact ionization model for both carriers, that is, `Recombination(Avalanche(UniBo))`, Sentaurus Device also activates Auger generation (see Auger Recombination Model on page 436).

Specify `Auger(-WithGeneration)` to deactivate this generation term if necessary.

# New University of Bologna Impact Ionization Model

The model described in University of Bologna Impact Ionization Model on page 447 was developed further [25][26][27] to cover an extended temperature range between 25°C and 500°C (773 K). It is based on impact ionization data generated by the Boltzmann solver HARM [22] and is calibrated against specially designed impact ionization measurements [23][24]. It covers a wide range of electric fields.

The model reads:

$$ \alpha(F_{\text{ava}}, T) = \frac{F_{\text{ava}}}{a(T) + b(T) \exp \left[ \frac{d(T)}{F_{\text{ava}} + c(T)} \right]} $$ (457)

where the coefficients $a$, $b$, $c$, and $d$ are polynomials of $T$:

$$ a(T) = \sum_{k=0}^{3} a_k \left( \frac{T}{1\text{K}} \right)^k, \quad b(T) = \sum_{k=0}^{10} b_k \left( \frac{T}{1\text{K}} \right)^k, \quad c(T) = \sum_{k=0}^{3} c_k \left( \frac{T}{1\text{K}} \right)^k, \quad d(T) = \sum_{k=0}^{3} d_k \left( \frac{T}{1\text{K}} \right)^k $$ (458)

If `BandgapDependence` is specified as an argument to `Avalanche`, then $d(T)$ is modified as follows:

$$ d(T) \rightarrow \left( \frac{\beta E_g}{q\lambda} / d_0 \right) \sum_{k=0}^{3} d_k \left( \frac{T}{1\text{K}} \right)^k $$ (459)

where $E_g$ is the energy bandgap, $\lambda$ is the optical-phonon mean free path for the carrier, and $\beta$ is a proportionality constant.

The model parameters are accessible in the `UniBo2` parameter set.

**NOTE** The name of the model is case sensitive. In both the command file and the parameter file, the exact capitalization of `UniBo2` must be used.

Avalanche Generation

Table 87 Parameters of new University of Bologna impact ionization model for silicon

| Symbol | Electrons | Holes | Unit |  |  |
| --- | --- | --- | --- | --- | --- |
| Parameter Name | Default value | Parameter Name | Default value |  |  |
| a0 | a0_e | 4.65403 | a0_h | 2.26018 | V |
| a1 | a1_e | −8.76031 × 10−3 | a1_h | 0.0134001 | V |
| a2 | a2_e | 1.34037 × 10−5 | a2_h | −5.87724 × 10−6 | V |
| a3 | a3_e | −2.75108 × 10−9 | a3_h | −1.14021 × 10−9 | V |
| b0 | b0_e | −0.128302 | b0_h | 0.058547 | V |
| b1 | b1_e | 4.45552 × 10−3 | b1_h | −1.95755 × 10−4 | V |
| b2 | b2_e | −1.0866 × 10−5 | b2_h | 2.44357 × 10−7 | V |
| b3 | b3_e | 9.23119 × 10−9 | b3_h | −1.33202 × 10−10 | V |
| b4 | b4_e | −1.82482 × 10−12 | b4_h | 2.68082 × 10−14 | V |
| b5 | b5_e | −4.82689 × 10−15 | b5_h | 0 | V |
| b6 | b6_e | 1.09402 × 10−17 | b6_h | 0 | V |
| b7 | b7_e | −1.24961 × 10−20 | b7_h | 0 | V |
| b8 | b8_e | 7.55584 × 10−24 | b8_h | 0 | V |
| b9 | b9_e | −2.28615 × 10−27 | b9_h | 0 | V |
| b10 | b10_e | 2.73344 × 10−31 | b10_h | 0 | V |
| c0 | c0_e | 7.76221 × 103 | c0_h | 1.95399 × 104 | Vcm−1 |
| c1 | c1_e | 25.18888 | c1_h | −104.441 | Vcm−1 |
| c2 | c2_e | −1.37417 × 10−3 | c2_h | 0.498768 | Vcm−1 |
| c3 | c3_e | 1.59525 × 10−4 | c3_h | 0 | Vcm−1 |
| d0 | d0_e | 7.10481 × 105 | d0_h | 2.07712 × 106 | Vcm−1 |
| d1 | d1_e | 3.98594 × 103 | d1_h | 993.153 | Vcm−1 |
| d2 | d2_e | −7.19956 | d2_h | 7.77769 | Vcm−1 |
| d3 | d3_e | 6.96431 × 10−3 | d3_h | 0 | Vcm−1 |
| λ | lambda_e | 62 × 10−8 | lambda_h | 45 × 10−8 | cm |
| β | beta_e | 0.391847 | beta_h | 0.831470 | 1 |

16: Generation–Recombination
Avalanche Generation

# Hatakeyama Avalanche Model

The Hatakeyama avalanche model [28] describes the anisotropic behavior in 4H-SiC power devices. The impact ionization coefficient $\alpha$ is obtained according to the Chynoweth law [18]:

$$ \alpha = \gamma a e^{-\frac{\gamma b}{F}} $$ (460)

with:

$$ \gamma = \frac{\tanh \left( \frac{\hbar \omega_{\text{op}}}{2kT_0} \right)}{\tanh \left( \frac{\hbar \omega_{\text{op}}}{2kT} \right)} $$ (461)

The coefficients $a$ and $b$ are computed dependent on the direction of the driving force $\vec{F}$. For the hexagonal crystal coordinate system, the direction of anisotropy usually coincides with the (0001) lattice crystal direction, while the other crystal directions are considered to be isotropic, like $(11\bar{2}0)$, for example. This allows for the decomposition of the driving force $\vec{F}$ into two components, parallel and orthogonal to the direction of anisotropy, to account for avalanche anisotropy.

The norm $F = \left\| \vec{F} \right\|_2$ satisfies the equation:

$$ F^2 = F_{0001}^2 + F_{11\bar{2}0}^2 $$ (462)

Based on the projections $F_{0001}$ and $F_{11\bar{2}0}$, the coefficients $a$ and $b$ are computed as follows:

$$ B = \frac{F}{\sqrt{\left( \frac{F_{11\bar{2}0}}{b_{11\bar{2}0}} \right)^2 + \left( \frac{F_{0001}}{b_{0001}} \right)^2}} $$ (463)

$$ a = a_{11\bar{2}0}^{\left( \frac{BF_{11\bar{2}0}}{b_{11\bar{2}0}F} \right)^2} a_{0001}^{\left( \frac{BF_{0001}}{b_{0001}F} \right)^2} $$ (464)

$$ A = \log \frac{a_{0001}}{a_{11\bar{2}0}} $$ (465)

$$ b = B \sqrt{1 - \theta A^2 \left( \frac{BF_{11\bar{2}0}F_{0001}}{Fb_{11\bar{2}0}b_{0001}} \right)^2} $$ (466)

451

Avalanche Generation

With the default $\theta = 1$, coefficient $b$ might become undefined for large values of the driving force $F$ (the argument of the square root in Eq. 466 becomes negative). This only happens if:

$$ F > \frac{2 \min(b_{0001}, b_{11\bar{2}0})}{\left| \log \frac{a_{0001}}{a_{11\bar{2}0}} \right|} $$ (467)

By setting $\theta = 0$, you have $b = B$, and coefficients $a$ and $b$ depend only on the direction of the driving force $\vec{F}$, not its magnitude.

Table 88 Parameters for 4H-SiC coefficients of Hatakeyama avalanche model

| Symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Electrons | Holes |  |  |  |
| $a_{0001}$ | a_0001 | $1.76 \times 10^8$ | $3.41 \times 10^8$ | cm−1 |
| $a_{11\bar{2}0}$ | a_1120 | $2.10 \times 10^7$ | $2.96 \times 10^7$ | cm−1 |
| $b_{0001}$ | b_0001 | $3.30 \times 10^7$ | $2.50 \times 10^7$ | V/cm |
| $b_{11\bar{2}0}$ | b_1120 | $1.70 \times 10^7$ | $1.60 \times 10^7$ | V/cm |
| $h\omega_{op}$ | hbarOmega | 0.19 | 0.19 | eV |
| $\theta$ | theta | 1 | 1 | 1 |

The Hatakeyama avalanche model uses a special-purpose interpolation formula to compute the coefficients $a$ and $b$ based on the direction of the driving force. This formula differs from the standard approach as described in Anisotropic Avalanche Generation on page 848.

## Driving Force of Hatakeyama Avalanche Model

In contrast to other avalanche models in Sentaurus Device (see Driving Force on page 455), which use only the magnitude $F$ of the driving force, the Hatakeyama avalanche model requires a vectorial driving force $\vec{F}$ to compute the coefficients $a$ and $b$. Depending on the driving force model, the following expressions are used:

*   `ElectricField`: The driving force $\vec{F}$ is defined as the straight electric field $\vec{E}$.

*   `Eparallel`: The driving force $\vec{F}$ is given by (where $\vec{j}$ is the electron or hole current density):

$$ \vec{F} = (\vec{E} \cdot \vec{j}) \cdot \frac{\vec{j}}{\|\vec{j}\|^2} $$ (468)

16: Generation–Recombination
Avalanche Generation

*   `GradQuasiFermi`: The driving force $\vec{F}$ is given by (where $\Phi$ is the electron or hole quasi-Fermi potential):

$$ \vec{F} = (\nabla\Phi, \hat{J}) \cdot \frac{\hat{J}}{\|\vec{j}\|^2} \tag{469} $$

*   `CarrierTempDrive`: The driving force $\vec{F}$ is given by (where $E^{\text{eff}}$ is the effective field obtained from the electron or hole carrier temperature):

$$ \vec{F} = \frac{\vec{j}}{j} E^{\text{eff}} \tag{470} $$

See Avalanche Generation With Hydrodynamic Transport on page 456.

## Default Anisotropic Coordinate System

For 2D simulations, Sentaurus Device assumes that the y-axis in the crystal coordinate system is the anisotropic axis $[0001]$, and the x-axis in the crystal coordinate system is the isotropic axis $[11\bar{2}0]$. For 3D simulations, the z-axis in the crystal coordinate system is the anisotropic axis, and the x-axis and y-axis span the isotropic plane. The simulation coordinate system relative to the crystal coordinate system is defined by the `X` and `Y` vectors in the `LatticeParameters` section of the parameter file (see Crystal and Simulation Coordinate Systems on page 836 and Coordinate Systems on page 954).

## Specification of Anisotropic Direction

There are different possibilities to specifying the direction of anisotropy used by anisotropic models (in increasing priority):

1. Take the direction from the TDR file specification, coming from Sentaurus Process.

2. Specify the direction explicitly in the `LatticeParameters` section of a Sentaurus Device parameter file.

3. Use an explicit directional specification in the `Aniso` subsection of the Sentaurus Device command file.

For avalanche models with an explicit anisotropic model parameter definition (such as Okuto–Crowell and van Overstraeten – de Man), specifying the anisotropic direction in the `Aniso` subsection must be assisted with the explicit activation of the anisotropic avalanche model:

```
Aniso (
  Avalanche
```

Avalanche Generation

```
    Direction = (1 0 0)
)
```

For the Hatakeyama avalanche model, `Avalanche` is not required in the `Aniso` subsection because this model is implicitly anisotropic.

Previously, it was only possible to know the direction of anisotropy for the Hatakeyama avalanche model by looking at the `LatticeParameters` section in the parameter file. The explicit directional specification in the `Aniso` subsection was ignored. Moreover, if the `LatticeParameters` section came directly from Sentaurus Process, then the parameters were interpreted incorrectly in the 2D case.

Therefore, for the Hatakeyama avalanche model:

* If the `LatticeParameters` section comes directly from Sentaurus Process, then these parameters are interpreted correctly.

* Explicit specification of the direction of anisotropy in the command file is also supported for the Hatakeyama avalanche model.

> **NOTE** The `-Hatakeyama` flag in the `Aniso` subsection allows for backward compatibility with previous releases.

## Examples

Assume you have a 2D problem with the Hatakeyama avalanche model. There is no `LatticeParameters` section in the parameter file, but the TDR file contains the following:

```
LatticeParameters {
  X = ( 0.0000e+00, 0.0000e+00, -1.0000e+00)
  Y = (-8.6603e-01, 0.5,         0.0000e+00)
}
```

Case 0: If the `Aniso` subsection of the `Physics` section has no direction specification, then the anisotropic direction is the z-axis of the crystal coordinate system, that is, the `X` and `Y` vectors define the anisotropic direction along the x-axis of the simulation coordinate system.

```
Physics {
  # Case 1: Direct anisotropic direction specification. In this
  # case, Sentaurus Device does not use the X and Y vectors.
  Aniso( direction=(0 0 1) )  # z-axis of (default) crystal coordinate system

  # Case 2: Direct definition of anisotropic direction in simulation
  # coordinate system.
  Aniso( direction(SimulationSystem)=(1 0 0) )

  # Case 3: Same as Case 2 - symbolic definition.
  Aniso( direction(SimulationSystem)=xAxis )
```

16: Generation–Recombination

Avalanche Generation

```
    # Case 4: Backward compatibility with Version N-2017.09.
    Aniso(-Hatakeyama)
}
```

# Driving Force

In Sentaurus Device, the driving force $F_{\text{ava}}$ for impact ionization can be computed as the component of the electrostatic field in the direction of the current, $F_{\text{ava}} = \vec{F} \cdot \hat{J}_{n,p}$, (keyword `Eparallel`), or the value of the gradient of the quasi-Fermi level, $F_{\text{ava}} = |\nabla \Phi_{n,p}|$, (keyword `GradQuasiFermi`). For these two possibilities, $F_{\text{ava}}$ is affected by the keyword `ParallelToInterfaceInBoundaryLayer` (see Field Correction Close to Interfaces on page 400). For hydrodynamic simulations, $F_{\text{ava}}$ can be computed from the carrier temperature (keyword `CarrierTempDrive`, see Avalanche Generation With Hydrodynamic Transport on page 456). The default model is `GradQuasiFermi` and, only for hydrodynamic simulations, it is `CarrierTempDrive`. See Table 233 on page 1557 for a summary of keywords.

The option `ElectricField` is used to perform breakdown simulations using the *ionization integral* method (see Approximate Breakdown Analysis on page 457).

## Interpolation of Avalanche Driving Forces

As with high-field saturation mobility, Sentaurus Device provides interpolation of avalanche driving forces to the electric field at low carrier concentrations, which can sometimes improve convergence behavior.

For the `GradQuasiFermi` driving force, interpolation to the electric field is described in Interpolation of the GradQuasiFermi Driving Force on page 399. As noted there, you can specify the following keywords for the interpolation parameters for electrons and holes in the `Math` section:

*   `RefDens_eGradQuasiFermi_ElectricField`

*   `RefDens_hGradQuasiFermi_ElectricField`

These keywords affect the calculation of the driving forces for *both* high-field saturation mobility and avalanche generation.

For the `Eparallel` driving force, interpolation to the electric field is given by:

$$ F_{\text{ava, } n} = \frac{n}{n + n_0} \left( \vec{F} \cdot \frac{\vec{J}_n}{J_n} \right) + \frac{n_0}{n + n_0} |\vec{F}| $$ (471)

Avalanche Generation

You can specify the reference densities for electrons and holes in the Math section by using the following parameters:

*   RefDens_eEparallel_ElectricField_Aval

*   RefDens_hEparallel_ElectricField_Aval

# Avalanche Generation With Hydrodynamic Transport

If the hydrodynamic transport model is used, the default driving force $F_{ava}$ equals an effective field $E^{eff}$ obtained from the carrier temperature.

The usual conversion of local carrier temperatures to effective fields $E^{eff}$ is described by the algebraic equations:

$$ \mu_n \left( E_n^{eff} \right)^2 = n \frac{3k T_n - T}{2q \lambda_n \tau_{en}} $$ (472)

$$ \mu_p \left( E_p^{eff} \right)^2 = p \frac{3k T_p - T}{2q \lambda_p \tau_{ep}} $$ (473)

which are obtained from the energy conservation equation under time-independent, homogeneous conditions. Eq. 472 and Eq. 473 have been simplified in Sentaurus Device by using the assumption $\mu_n E_n^{eff} = v_{sat,n}$ and $\mu_p E_p^{eff} = v_{sat,p}$. This assumption is true for high values of the electric field. However, for low field, the impact ionization rate is negligibly small.

The parameters $\lambda_n$ and $\lambda_p$ are fitting coefficients (default value 1) and their values can be changed in the parameter set `AvalancheFactors`, where they are represented as `n_l_f` and `p_l_f`, respectively.

The conventional conversion formulas Eq. 472 and Eq. 473 can be activated by specifying parameters $\Upsilon_n = 0$, $\Upsilon_p = 0$ in the same `AvalancheFactors` section.

The simplified conversion formulas predict a linear dependence of effective electric field on temperature for high values of carrier temperature. For silicon, however, Monte Carlo simulations do not confirm this behavior. To obtain a better agreement with Monte Carlo data, additional heat sinks must be taken into account by the inclusion of an additional term in the equations for $E^{eff}$.

**16: Generation–Recombination**
Approximate Breakdown Analysis

Such heat sinks arise from nonelastic processes, such as impact ionization itself. Sentaurus Device supports the following model to account for these heat sinks:

$$ _{nv} \text{sat},n E_n^{\text{eff}} = n \frac{3k T_n - T}{2q \lambda_n \tau_{en}} + \frac{\Upsilon_n}{q} (E_g + \delta_n k T_n) \alpha_n _{nv} \text{sat},n $$ (474)

A similar equation is used to determine $E_p^{\text{eff}}$. To activate this model, set the parameters $\Upsilon_n$ and $\Upsilon_p$ to 1. This is the default for silicon, where the generalized conversion formula Eq. 474 gives good agreement with Monte Carlo data for $\delta_n = \delta_p = 3/2$. For all other materials, the default of the parameters $\Upsilon_n$ and $\Upsilon_p$ is 0.

> **NOTE** This procedure ensures that the same results are obtained as with the conventional local field–dependent models in the bulk case. Conversely, the temperature-dependent impact ionization model usually gives much more accurate predictions for the substrate current in short-channel MOS transistors.

Table 89 Parameters of the hydrodynamic avalanche model

| Symbol | Parameter name | Default value |
| --- | --- | --- |
| $\lambda_n$ | n_l_f | 1 |
| $\lambda_p$ | p_l_f | 1 |
| $\Upsilon_n$ | n_gamma | 1 |
| $\Upsilon_p$ | p_gamma | 1 |
| $\delta_n$ | n_delta | 1.5 |
| $\delta_p$ | p_delta | 1.5 |

# Approximate Breakdown Analysis

Junction breakdown due to avalanche generation is simulated by inspecting the ionization integrals:

$$ I_n = \int\limits_0^W \alpha_n(x) e^{-\int\limits_x^W (\alpha_n(x') - \alpha_p(x')) \, dx'} \, dx $$ (475)

$$ I_p = \int\limits_0^W \alpha_p(x) e^{-\int\limits_0^x (\alpha_p(x') - \alpha_n(x')) \, dx'} \, dx $$ (476)

**16: Generation–Recombination**

Approximate Breakdown Analysis

where $\alpha_n$, $\alpha_p$ are the ionization coefficients for electrons and holes, respectively, and $W$ is the width of the depletion zone. The integrations are performed along field lines through the depletion zone. Avalanche breakdown occurs if both ionization integrals are greater than or equal to one. Eq. 475 describes electron injection (electron primary current) and Eq. 476 describes hole injection. Since these breakdown criteria do not depend on current densities, you can perform a breakdown analysis by computing only the Poisson equation and ionization integrals under the assumption of constant quasi-Fermi levels in the depletion region.

# Using Breakdown Analysis

To enable breakdown analysis, Sentaurus Device provides the driving force `ElectricField`, which can be computed even for constant quasi-Fermi levels.

> **NOTE** The driving force `ElectricField` is less physical than the others available in Sentaurus Device. Therefore, you should use it only for approximate breakdown analysis.

Specifying `ComputeIonizationIntegrals` in the `Math` section switches on computation of the ionization integrals. For example:

```
Math{
  ...
  ComputeIonizationIntegrals ()
}
```

## Initial Element List

Depending on the details of the device design, it is generally not known which ionization path will contribute the most to breakdown. Sentaurus Device offers various strategies to generate the initial set of elements from which the path search starts. The following electric field–based restrictions of the initial set of elements are available:

* `ComputeAtMaxElectricField`:
  The path search starts from the element having the maximal electric field within a semiconductor region. This strategy is the fastest since only one path is evaluated at every bias point. However, there might be another path that contributes more to breakdown. In structures where the maximum electric field location jumps as a function of applied bias, this can cause nonsmooth curves for ionization integrals.

* `ComputeAtMaxElectricField(delta=<float>)`:
  All elements within a semiconductor region where the electric field is higher than the maximal electric field within a semiconductor region minus `delta` are taken into the initial element list. The parameter `delta` is given in V/cm. This is the default option.

**16: Generation–Recombination**
Approximate Breakdown Analysis

* `MinElectricField=<float>`:
  All elements within a semiconductor region where the electric field is higher than `MinElectricField`, in units of V/cm, are taken into the initial element list.

In addition to electric field–based restrictions, the initial set of elements can be restricted by the spatial position:

* Using `ComputeAll`, all elements within a semiconductor region are taken into the initial element list. You should combine this strategy with another spatial restriction strategy. Otherwise, excessive computation times might occur in structures with a large number of elements.

* In the `ComputeIonizationIntegrals` section, the `Window` section can be specified with different geometric shapes. Only elements with center positions within the specified geometric shapes are considered for the path search. You can specify the following geometric shapes:

  * `Cuboid(corner1=<vector> corner2=<vector>)`:
    `corner1` and `corner2` are the diagonally opposite corners of the cuboid.

  * `Sphere(center=<vector>, radius=<float>)`:
    `center` is the vector to the center of the sphere, and `radius` is the radius of the sphere.

  * `Cylinder(center1=<vector> center2=<vector> radius=<float>)`:
    `center1` and `center2` are vectors to the circular bases of the cylinder, and `radius` is the radius of the bases of the cylinder.

For example:

```
ComputeIonizationIntegrals (
    ComputeAll
    Window (
        Cuboid(corner1=(-1 -1 1) corner2=(2 -2 2))        # in um
        Sphere(center=(2.5 3.5 -4.5) radius=0.5)          # in um
        Cylinder(center1=(5.1 6.2 7.3) center2=(0 0.1 0) radius=1.1) # in um
    )
)
```

## Path Reflection

By default, the path is reflected at the device boundary. Using `-PathReflection()`, the path search stops if the algorithm steps into a nonsemiconductor material or outside the device. The path search stops if the path comes close to a contact.

Additional options within the `PathReflection()` section are available:

* `ReflectAtMaterial=<material>`:
  The path is reflected at the interface to the defined materials. Elements inside the specified materials are excluded from the initial element list.

Approximate Breakdown Analysis

*   `ReflectAtRegion=<region>`:
    The path is reflected at the interface to the defined regions. Elements inside the specified regions are excluded from the initial element list.

*   `CloseToContact=<float>`:
    The path search algorithm stops when the distance between the path point and a contact is smaller than the specified value given in $\mu$m (default: 0.1 $\mu$m).

For example:

```
ComputeIonizationIntegrals (
  PathReflection(
    ReflectAtMaterial="Oxide"
    ReflectAtMaterial="PolySi"
    ReflectAtRegion="region1"
    ReflectAtRegion="region2"
    CloseToContact=0.01                # um
  )
)
```

## Periodic Boundary Conditions

You can apply periodic boundary conditions to the path search by using the `PeriodicBC` keyword. If Robin periodic boundary conditions are specified in the `Math` section (see Robin PBC Approach on page 238), then the parameters are taken from there. If mortar periodic boundary conditions are specified, then periodic boundary conditions for the path search are switched off. The Robin periodic boundary conditions can be overwritten. For example:

```
ComputeIonizationIntegrals(
  PeriodicBC(
    (Direction=0 Coordinates=(-1.0 2.0))   # periodic in x-direction
    (Direction=1 Coordinates=(0.5 12.0))   # periodic in y-direction
  )
)
```

The keyword `Direction=<int>` specifies the normal direction of the periodic boundary planes where `Direction=0 | 1 | 2` correspond to the x-, y-, and z-direction. The keyword `Coordinates=(<float> <float>)` specifies the left and right periodic boundary planes. The path search stops if the periodic translation ends outside of the device.

Auxiliary control is given with the keyword `MaxReflections=<int>`, which controls the maximum number of boundary reflections until the path search stops.

All elements with center positions outside of the specified periodic boundary condition planes are excluded from the initial element list.

**16: Generation–Recombination**
Approximate Breakdown Analysis

**NOTE** Periodic boundary conditions can be used only in the path search mode without path reflection. Therefore, path reflection is switched off automatically if periodic boundary conditions are used.

# Electrostatic Stopping Criteria for Path Search

In addition, two modes are available to stop the path search:

*   Electric field condition (default): The path search stops when the absolute value of the electric field is smaller than a threshold value, which is controlled with the keyword `PathSearchStopField=<float>` (default 1000 V/cm).

*   Electrostatic potential condition: The path search stops when the electrostatic potential is smaller than the minimum electrostatic potential $\phi_{\min}$ or larger than the maximum electrostatic potential $\phi_{\max}$, which are given by $\phi_{\min} = \phi_{\min}^c + \Delta\phi_{\min}$ and $\phi_{\max} = \phi_{\max}^c - \Delta\phi_{\max}$ with the minimal value $\phi_{\min}^c$ and the maximal value $\phi_{\max}^c$ of the electrostatic potential at contacts, and the electrostatic potential shifts $\Delta\phi_{\min}$ and $\Delta\phi_{\max}$.

You can control the electrostatic potential shifts by using the keyword `PathSearchStopDeltaPotential=<float> <float>`, where $\Delta\phi_{\min}$ corresponds to the first value and $\Delta\phi_{\max}$ corresponds to the second value.

By default, Sentaurus Device reports only the path with the largest value. With the addition of the keyword `WriteAll`, information about all the computed ionization paths, according to the selected strategy, are written to the log file.

# Stopping Criteria for Breakdown Simulations

The keyword `BreakAtIonIntegral` in the `Math` section terminates the quasistationary simulation when the largest electron and hole ionization integrals per path are greater than or equal to one.

The complete syntax of this keyword is `BreakAtIonIntegral(<number> <value>)` where a quasistationary simulation finishes if the `<number>` of electron and hole ionization integrals per path is greater than or equal to `<value>`. For example:

```
Math { BreakAtIonIntegral }
```

# Visualizing Breakdown Paths

## Visualization in Current Plot File

When you use `ComputeIonizationIntegrals`, the values of the path with the highest ionization integrals $I_n$ and $I_p$ (Eq. 475 and Eq. 476) are saved automatically in the current plot file (`*.plt` file) as `PhiElectron` and `PhiHole`, respectively.

Approximate Breakdown Analysis

## Visualization in TDR File

### Save Best Breakdown Path as Volume Dataset in Existing TDR File

The keywords `eIonIntegral`, `hIonIntegral`, and `MeanIonIntegral` in the `Plot` section specify the corresponding ionization integrals. The best path is saved as the volume dataset in the existing TDR file. For example:

```
Plot {
     eIonIntegral
     hIonIntegral
     MeanIonIntegral
}
```

### Save Several Breakdown Paths as 1D Datasets in Separate TDR File

The keywords `SaveEIonIntegralPaths` and `SaveHIonIntegralPaths` in the `ComputeIonizationIntegrals` section store breakdown paths in a TDR file. For example:

```
Math {
     ComputeIonizationIntegrals (
          SaveEIonIntegralPaths = 1
          SaveHIonIntegralPaths = 1
     )
}
```

By default, Sentaurus Device stores the paths that have the largest ionization integral values for electrons and holes. You can set the required number of paths to store by using `SaveEIonIntegralPaths=<int>` and `SaveHIonIntegralPaths=<int>`.

Sentaurus Device also stores the interpolated field variables, specified in the `Plot` section, along with the breakdown paths.

You specify the output TDR file for visualizing breakdown paths in the `File` section as follows:

```
File {
     IonIntegral = "@ABA@"
}
```

The keyword `IonIntegral` generates a TDR file containing breakdown paths and interpolated fields along the paths.

### Typical Command File of Sentaurus Device

```
Electrode {
     { name="anode" Voltage=0 }
     { name="cathode" Voltage=600 }
```

**16: Generation–Recombination**

Approximate Breakdown Analysis

```
}
File {
  grid        = "@grid@"
  doping      = "@doping@"
  current     = "@plot@"
  output      = "@log@"
  plot        = "@data@"
  IonIntegral = "@ABA@"
}
Physics {
  Mobility (DopingDependence HighFieldSaturation)
  Recombination(SRH Auger Avalanche(ElectricField))
}
Solve {
  Quasistationary(
    InitialStep=0.02 MaxStep=0.01 MinStep=0.01
    Goal {name=cathode voltage=1000}
  )
  { poisson }
}
Math {
  Iterations=100
  BreakAtIonIntegral
  ComputeIonizationIntegrals(
    MinElectricField = 2.0e5
    SaveEIonIntegralPaths = 1
    SaveHIonIntegralPaths = 1
  )
}
Plot {
  eIonIntegral hIonIntegral MeanIonIntegral
  eDensity hDensity
  ElectricField/Vector
  eAlphaAvalanche hAlphaAvalanche
}
```

# Approximate Breakdown Analysis With Carriers

Sentaurus Device allows ionization integrals to be calculated when solving the electron and hole current continuity equations. In this case, however, impact ionization–generated carriers will be included self-consistently in the solution, and the benefits of performing an approximate breakdown analysis (faster simulations with fewer convergence issues) will be lost.

Avalanche Breakdown Probability

To prevent the self-consistent inclusion of impact ionization–generated carriers in the solution of the device equations, specify the option `AvalPostProcessing` in the `Math` section:

```
Math { AvalPostProcessing }
```

This option allows ionization integrals to be calculated even when solving for carriers, but retains the benefits of an approximate breakdown analysis.

## Using GradQuasiFermi as a Driving Force

The direction field is used for the geometric path search through the device. It can be specified in the `ComputeIonizationIntegrals()` section using `direction=<string>` as follows:

*   `direction="ElectricField"` (default): The path search follows the electric vector field.

*   `direction="eGradQuasiFermi"`: The path search follows the gradient of the electron quasi-Fermi energy.

*   `direction="hGradQuasiFermi"`: The path search follows the gradient of the hole quasi-Fermi energy.

The direction field is used for the path search stopping criterion `PathSearchStopField`.

The ionization field, that is, the driving force for the impact ionization, is used for the computation of the ionization coefficients in Eq. 475, p. 457 and Eq. 476, p. 457.

For example:

```
Math {
  ComputeIonizationIntegrals(
    direction="eGradQuasiFermi"
  )
}
Physics {
  Recombination(
    Avalanche(GradQuasiFermi)
  )
}
```

# Avalanche Breakdown Probability

For the simulation of single-photon avalanche diodes, knowledge of the avalanche breakdown probability is useful. Sentaurus Device can compute the electron $P_e(r)$, the hole $P_h(r)$, and the joint $P_j(r)$ avalanche breakdown probability according to the model of McIntyre [[29]]([29]).

**16: Generation–Recombination**
Avalanche Breakdown Probability

The joint avalanche breakdown probability along the electric field line $s(r)$ is given by:

$$ P_j(s) = \frac{P_h(0)f(s)}{P_h(0)f(s) + 1 - P_h(0)} $$ (477)

where $f(s) = \exp[\int_0^s (\alpha_e - \alpha_h) ds']$. Sentaurus Device solves the following line integrals along electric field lines in the multiplication region:

$$ -\log[1 - P_h(0)] = \int_0^w \alpha_h(s) P_j(s) ds $$ (478)

$$ 1 - P_h(s) = (1 - P_h(0)) \exp \left[ \int_0^s \alpha_h(s') P_j(s') ds' \right] $$ (479)

The multiplication region is defined as the region where the electric field is higher than a threshold value. Outside the multiplication region, $P_e(r) = P_h(r) = P_j(r) = 0$.

# Using Avalanche Breakdown Probability

The keyword `BreakdownProbability` in the `Physics` section controls the computation of the avalanche breakdown probability:

```
Physics { ...
  BreakdownProbability()
}
```

You can control the threshold electric field for the definition of the multiplication region with the keyword `MinElectricField` (default value: 1.0e5 V/cm).

For example:

```
Physics { ...
  BreakdownProbability(MinElectricField=1.0e4)
}
```

The model for the impact ionization coefficients $\alpha_e$ and $\alpha_h$ is read from the `Avalanche` section (see Avalanche Generation on page 441).

**NOTE** This feature is designed for quasistationary stimulations. For meaningful breakdown probabilities, you must exclude impact ionization–generated carriers from the device equations. Therefore, additionally use the `AvalPostprocessing` option in the `Math` section (see Approximate Breakdown Analysis With Carriers on page 463).

High-Field Entrance Position and Time

To plot the electron, the hole, and the joint avalanche breakdown probability, specify `eBreakdownProbability`, `hBreakdownProbability`, and `jBreakdownProbability` in the `Plot` section.

# High-Field Entrance Position and Time

The charge collection probability can be defined as the probability that a carrier generated at position *x* outside the multiplication region will reach a point *m* (high-field entrance position) on the border of the multiplication region. Knowledge of the high-field entrance position is also useful for the computation of quantities that are related to the breakdown probability.

As APDs and SPADs are reverse biased devices, minority carrier trajectories starting from *x* and reaching *m* are of interest:

*   The local net doping is n-type, $n > p$: The minority hole current vector $\vec{J_h}$ is followed.

*   The local net doping is p-type, $p \ge n$: The negative minority electron current vector $-\vec{J_e}$ is followed.

# Using High-Field Entrance Position and Time

The keyword `ComputeCarrierPath` in the `Math` section controls the computation of the high-field entrance position. You can control the threshold electric field for the definition of the multiplication region with the keyword `thresholdField` (default: 1.0e5 V/cm). For example:

```
Math {
  ...
  ComputeCarrierPath(thresholdField=2.0e4)
}
```

The path search starts either from every vertex position or element center position inside a semiconductor material. This can be controlled with the keyword `startFrom="vertex"` (default) or `startFrom="element"`. For example:

```
ComputeCarrierPath(
  startFrom = "element"
)
```

The path search is reflected at device boundaries by default. By default, the path search stops as well when it reaches contacts. In addition, you can specify that the path search stops when it is close to a contact by using the keyword `closeToContact=<float>` (in $\mu$m). For example:

```
ComputeCarrierPath(
  PathReflection(closeToContact=0.01)
)
```

**16: Generation–Recombination**
High-Field Entrance Position and Time

Results are saved in the following datasets:

*   HighFieldEntrancePosition: A vector field where every position $x$ is assigned to the high-field entrance position $m$

*   HighFieldEntranceVertex: A scalar field where every position $x$ is assigned to the vertex that is the closest vertex from $m$ inside the multiplication region

*   HighFieldEntranceMask: A scalar field where additional information is stored in the mask value (see Table 90)

Table 90 Description of mask values

| Mask value | Assignment of position | Description |
| --- | --- | --- |
| 0 | $x \rightarrow x$ | * $x$ is outside the multiplication region * Path search does not run into multiplication region |
| 1 | $x \rightarrow m$ | * $x$ is outside the multiplication region * Follow $\vec{J}_h$ in n-doped semiconductor region * Found $m$ in multiplication region |
| 2 | $x \rightarrow m$ | * $x$ is outside the multiplication region * Follow $-\vec{J}_e$ in p-doped semiconductor region * Found $m$ in multiplication region |
| 3 | $x \rightarrow x$ | * $x$ is inside the multiplication region * No need for path search |
| -1 | $x \rightarrow x$ | All other cases |

*   HighFieldEntranceTime: A scalar field that computes the transit time of the carriers from the start position $s = 0$ until the high-field entrance position $s = m$ according to $t = \int_0^m \frac{ds}{v(s)}$, where the data entries `eVelocity` or `hVelocity` are used for $v(s)$, respectively. The transit time is nonzero for paths that reach the multiplication region.

# Visualization in TDR Files

This section discusses visualization in TDR files.

## Save Volume Dataset in Existing TDR File

To plot the datasets for the vertex-wise search, specify `HighFieldEntrancePosition/Vector`, `HighFieldEntranceVertex`, and `HighFieldEntranceMask` in the `Plot` section. To plot the datasets for the elementwise search, specify `HighFieldEntrancePosition/Element/Vector`, `HighFieldEntranceVertex/Element`, and `HighFieldEntranceMask/Element`.

High-Field Entrance Position and Time

**NOTE** The datasets are designed for data transfer. Therefore, plotting HighFieldEntrancePosition/Vector and HighFieldEntranceVertex is not necessarily meaningful.

## Save Carrier Paths as 1D Datasets in Separate TDR File

You specify a separate output TDR file name for visualizing carrier paths in the `File` section using `CarrierPath`. For example:

```
File {
  CarrierPath = "myFileName.tdr"
}
```

Plotting the carrier paths is controlled by the `SaveEPaths` and `SaveHPaths` statements in the `ComputeCarrierPath` section. For large numbers of available paths, it is useful to reduce the total number of written paths using `skip=<int>`, which specifies the number of paths omitted for plotting (default: `skip=0`). The first path to be plotted can be shifted using `offset=<int>` (default: `offset=0`). For example:

```
Math {
  ComputeCarrierPath (
    SaveEPaths (
      skip = 25
      offset = 13
    )
    SaveHPaths (
      skip = 10
      offset = 0
    )
  )
}
```

Alternatively, a list of path index numbers can be specified and plotted. For example:

```
Math {
  ComputeCarrierPath (
    SaveEPaths (
      list = (12 17 43 512 831)
    )
    SaveHPaths (
      list = (121 82 55)
    )
  )
}
```

16: Generation–Recombination
Band-to-Band Tunneling Models

Sentaurus Device also stores the interpolated field variables, specified in the `Plot` section, along the carrier paths. For large numbers of carrier paths and plot variables, you can reduce the loading time in Sentaurus Visual by switching off `withPlotData`. For example:

```
Math {
  ComputeCarrierPath (
    SaveEPaths ( -withPlotData )
  )
}
```

**NOTE** Dynamic datasets that are triggered from the following plot names are *not* stored in the path:

`AbsorbedPhotonDensity`, `ComplexRefractiveIndex`, `OpticalAbsorptionHeat`, `OpticalGeneration`, `OpticalIntensity`, `QuantumYield`, `QW_OverlapIntegral`, `ThermalizationYield`

# Band-to-Band Tunneling Models

Sentaurus Device provides different band-to-band tunneling models:

*   Schenk Band-to-Band Tunneling Model on page 471

*   Hurkx Band-to-Band Tunneling Model on page 473

*   Modified Hurkx Band-to-Band Tunneling Model on page 474

*   Simple Band-to-Band Tunneling Models on page 475

*   Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475

The Schenk, Hurkx, modified Hurkx, and simple models use a common approach to suppress artificial band-to-band tunneling near insulator interfaces and for rapidly varying fields (see Tunneling Near Interfaces and Equilibrium Regions on page 471).

# Using Band-to-Band Tunneling

Band-to-band tunneling is controlled by the `Band2Band` option of `Recombination`:

```
Recombination( ...
  Band2Band (
    Model = Schenk | Hurkx | modifiedHurkx | E1 | E1_5 | E2 | NonlocalPath
    DensityCorrection = Local | None
    InterfaceReflection | -InterfaceReflection
    FranzDispersion | -FranzDispersion
    ParameterSetName = (<string>...)
```

Band-to-Band Tunneling Models

```
    )
  )
```

The following options for `Model` are available:

*   `Schenk` selects the Schenk model.

*   `Hurkx` selects the Hurkx model.

*   `modifiedHurkx` selects the modified Hurkx model.

*   `E1`, `E1_5`, and `E2` select one of the simple models.

*   `NonlocalPath` selects the nonlocal path model.

The keyword `DensityCorrection` is used by the Schenk, Hurkx, modified Hurkx, and simple models, and its default value is `None`. A value of `Local` activates a local-density correction (see Schenk Density Correction on page 472).

The option `InterfaceReflection` is used by the nonlocal path model and is switched on by default. This option allows a tunneling path reflected at semiconductor–insulator interfaces. When it is switched off, band-to-band tunneling is neglected when the tunneling path encounters semiconductor–insulator interfaces.

The option `FranzDispersion` is used by the nonlocal path model and is switched off by default. When it is switched on, the Franz dispersion relation (Eq. 808, p. 781) instead of the Kane dispersion relation (Eq. 489, p. 477) for the imaginary wavevector is used in the direct tunneling process. The indirect tunneling process is not affected by this option.

All models use `ParameterSetName` to specify a list of names of `Band2BandTunneling` parameter sets. For each name, band-to-band tunneling is computed using the parameters in the named parameter set, and the results are all added to give the total band-to-band tunneling rate. Without `ParameterSetName`, only band-to-band tunneling obtained with the unnamed `Band2BandTunneling` parameter set is computed.

The following example uses the nonlocal path model, summing the contributions obtained with the `phonon-assisted` and `direct` parameter sets:

```
Band2Band(
  Model=NonlocalPath
  ParameterSetName=("phonon-assisted" "direct")
)
```

For backward compatibility:

*   `Band2Band` (no parameters) selects the Schenk model with local-density correction.

*   `Band2Band(Hurkx)` selects the Hurkx model without density correction.

*   `Band2Band(E1)`, `Band2Band(E1_5)`, and `Band2Band(E2)` select one of the simple models.

16: Generation–Recombination
Band-to-Band Tunneling Models

The parameters for all band-to-band tunneling models are available in the parameter set `Band2BandTunneling`. The parameters specific to individual models are described in the respective sections. The parameter `MinField` (specified in Vcm<sup>−1</sup>) is used by the Schenk, Hurkx, modified Hurkx, and simple models for smoothing at small electric fields. A value of zero (the default) deactivates smoothing.

Named `Band2BandTunneling` parameter sets are specified in the parameter file. The following example specifies a parameter set named `phonon-assisted`:

```
Band2BandTunneling "phonon-assisted" { ... }
```

> **NOTE** Parameters in named `Band2BandTunneling` parameter sets do not have default values. Therefore, you must specify values for all the parameters used by the model you select in the command file.

## Tunneling Near Interfaces and Equilibrium Regions

Physically, band-to-band tunneling occurs over a certain tunneling distance. If the material properties or the electric field change significantly over this distance, Eq. 480, Eq. 483, and Eq. 487 become inaccurate. In particular, near insulator interfaces, band-to-band tunneling vanishes, as no states to tunnel to are available in the insulator.

In some parts of the device (near equilibrium regions), it is possible that the electric field is large but changes rapidly, so that the actual tunneling distance (the distance over which the electrostatic potential change amounts to the band gap) is bigger and, therefore, tunneling is much smaller than expected from the local field alone.

To account for these effects, additional control parameters are introduced in the parameter set `Band2BandTunneling`:

```
dDist = <value> # [cm]
dPot  = <value> # [V]
```

By default, both parameters equal zero. Sentaurus Device deactivates band-to-band tunneling within a distance `dDist` from insulator interfaces. If `dPot` is nonzero (reasonable values for `dPot` are of the order of the band gap), Sentaurus Device deactivates band-to-band tunneling at each point where in the field direction, the change of the electrostatic potential over a distance of `dPot`/ $F$ is smaller than `dPot`/2.

# Schenk Band-to-Band Tunneling Model

Phonon-assisted band-to-band tunneling cannot be neglected in steep p-n junctions (with a doping level of 1×10<sup>19</sup> cm<sup>−3</sup> or more on both sides) or in high normal electric fields of MOS structures. It must be switched on if the field, in some regions of the device, exceeds

Band-to-Band Tunneling Models

(approximately) 8×10<sup>5</sup> V/cm. In this case, defect-assisted tunneling must also be switched on (see SRH Field Enhancement on page 424).

Band-to-band tunneling is modeled using the expression [30]:

$$ R_{\text{net}}^{\text{bb}} = AF^{7/2} \frac{\tilde{n}\tilde{p} - n_{i, \text{eff}}^2}{(\tilde{n} + n_{i, \text{eff}})(\tilde{p} + n_{i, \text{eff}})} \left[ \frac{(F_C^+)^{-3/2} \exp\left( -\frac{F_C^+}{F} \right)}{\exp\left( \frac{\hbar\omega}{kT} \right) - 1} + \frac{(F_C^\pm)^{-3/2} \exp\left( -\frac{F_C^\pm}{F} \right)}{1 - \exp\left( -\frac{\hbar\omega}{kT} \right)} \right] $$ (480)

where $\tilde{n}$ and $\tilde{p}$ equal $n$ and $p$ for `DensityCorrection=None`, and are given by Eq. 482 for `DensityCorrection=Local`.

The critical field strengths read:

$$ F_C^\pm = B(E_{g, \text{eff}} \pm \hbar\omega)^{3/2} $$ (481)

The upper sign in Eq. 480 refers to tunneling generation ($np < n_{i, \text{eff}}^2$) and the lower sign refers to recombination ($np > n_{i, \text{eff}}^2$). The quantity $\hbar\omega$ denotes the energy of the transverse acoustic phonon.

For Fermi statistics and quantization, Eq. 480 is modified in the same way as for SRH recombination (see Eq. 388, p. 420).

The model parameters [30] can be accessed in the `Band2BandTunneling` parameter set. The default values were obtained assuming the field direction to be $\langle 111 \rangle$.

Table 91 Parameters of the Schenk band-to-band tunneling model

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| A | A | 8.977×10²⁰ | cm⁻¹s⁻¹V⁻² |
| B | B | 2.14667×10⁷ | Vcm⁻¹eV⁻³/² |
| $\hbar\omega$ | hbarOmega | 18.6 | meV |

## Schenk Density Correction

The modified electron density reads:

$$ \tilde{n} = n \left( \frac{n_{i, \text{eff}}}{N_C} \right)^{\frac{\gamma_n |\nabla E_{F,n}|}{F}} $$ (482)

16: Generation–Recombination
Band-to-Band Tunneling Models

There is a similar relation for $\tilde{p}$. The parameters $\gamma_n = n / (n + n_{\text{ref}})$ and $\gamma_p = p / (p + p_{\text{ref}})$ work as discussed in Density Correction for the Schenk and Hurkx Trap-Assisted Tunneling Models on page 427. The reference densities $n_{\text{ref}}$ and $p_{\text{ref}}$ are specified (in cm<sup>−3</sup>) by the `DenCorRef` parameter pair in the `Band2BandTunneling` parameter set.

An additional parameter `MinGradQF` (specified in eVcm<sup>−1</sup>) is available for smoothing at small values of the gradient for the Fermi potential.

# Hurkx Band-to-Band Tunneling Model

Similar to the other band-to-band tunneling models, in the Hurkx model [31], tunneling carriers are modeled by an additional generation–recombination process. Its contribution is expressed as:

$$ R_{\text{net}}^{\text{bb}} = A \cdot D \cdot \left( \frac{F}{1 \text{ V/cm}} \right)^P \exp \left( -\frac{B E_g(T)^{3/2}}{E_g(300\text{K})^{3/2} F} \right) $$ (483)

where:

$$ D = \frac{np - n_{i,\text{eff}}^2}{(n + n_{i,\text{eff}})(p + n_{i,\text{eff}})} (1 - |\alpha|) + \alpha $$ (484)

Here, specifying $\alpha = 0$ gives the original Hurkx model, whereas $\alpha = -1$ gives only generation ($D = -1$), and $\alpha = 1$ gives only recombination ($D = 1$). Therefore, if $D < 0$, it is a net carrier generation model. If $D > 0$, it is a recombination model. For Fermi statistics and quantization, Eq. 484 is modified in the same way as for SRH recombination (see Eq. 388).

For `DensityCorrection=Local`, $n$ and $p$ in Eq. 484 are replaced by $\tilde{n}$ and $\tilde{p}$ (see Schenk Density Correction on page 472).

You can specify the coefficients $A$ (in cm<sup>−3</sup>s<sup>−1</sup>), $B$ (in V/cm), $P$, and $\alpha$ in the parameter set `Band2BandTunneling`. By default, Sentaurus Device uses $\alpha = 0$ and the parameters from the E2 model (see Table 92 on page 475). Different values for the generation (`Agen`, `Bgen`, and `Pgen`) and recombination (`Arec`, `Brec`, and `Prec`) of carriers are supported.

For example, to change the parameters to those used in [31], use:

```
Band2BandTunneling {
  Agen = 4e14 # [1/(cm3s)]
  Bgen = 1.9e7 # [V/cm]
  Pgen = 2.5  # [1]
  Arec = 4e14 # [1/(cm3s)]
  Brec = 1.9e7 # [V/cm]
  Prec = 2.5  # [1]
}
```

Band-to-Band Tunneling Models

```
    alpha = 0   # [1]
}
```

# Modified Hurkx Band-to-Band Tunneling Model

Due to the nonlocal nature of the dynamic nonlocal path band-to-band tunneling model, convergence problems might arise for some devices. Therefore, Sentaurus Device offers the modified Hurkx band-to-band tunneling model that resembles more closely the results from the dynamic nonlocal path band-to-band tunneling model and shows better convergence behavior due to its local nature.

Eq. 483 is modified according to:

$$ R_{\text{net}}^{\text{mH}} = R_{\text{net}}^{\text{bb}} \cdot g $$ (485)

It differs from the Hurkx band-to-band tunneling model by a factor of:

$$ g = \begin{cases} \left( \frac{F - F_0}{F_0} \right)^Q & \text{for } F \geq F_0 \\ 0 & \text{for } F < F_0 \end{cases} $$ (486)

where:

*   $g$ is introduced to avoid large tunneling generation at zero bias with a fitting parameter $Q$.

*   The local parameter $F_0 = \max \left( \tilde{F}_0, \sqrt{C \frac{2qE_g(300K)N_{\text{net}}}{\varepsilon}} \right)$, with the equilibrium electric field at zero bias $\tilde{F}_0$ and the scaling factor $C$.

The coefficients $Q$ and $C$ can be specified in the `Band2BandTunneling` parameter set. By default, Sentaurus Device uses $Q = 1.5$, $C = 1$, and $\alpha = -1$. For example, to change the parameters for this model, specify:

```
Band2BandTunneling {
  Qgen = 1.5 # [1]
  Cgen = 1.0 # [1]
  Qrec = 2.5 # [1]
  Crec = 1.0 # [1]
}
```

16: Generation–Recombination
Band-to-Band Tunneling Models

# Simple Band-to-Band Tunneling Models

Sentaurus Device provides a family of simple band-to-band tunneling models. Compared to the advanced models, the greatest weakness of the simple models is that they predict a nonzero generation rate even in equilibrium.

A general expression for these models can be written for the generation term [32] as:

$$ G^{b2b} = AF^P \exp(-\frac{B}{F}) $$ (487)

Depending on the value of `Model`, $P$ takes the value 1, 1.5, or 2.

Table 92 lists the coefficients of the models and their default values. The coefficients $A$ and $B$ can be changed in the `Band2BandTunneling` parameter set.

Table 92 Coefficients of the simple band-to-band tunneling models

| Model | P | A | B |
| --- | --- | --- | --- |
| E1 | 1 | 1.1 $\times$ 1027 cm-2s-1V-1 | 21.3 $\times$ 106 Vcm-1 |
| E1_5 | 1.5 | 1.9 $\times$ 1024 cm-1.5s-1V-1.5 | 21.9 $\times$ 106 Vcm-1 |
| E2 | 2 | 3.4 $\times$ 1021 cm-1s-1V-2 | 22.6 $\times$ 106 Vcm-1 |

# Dynamic Nonlocal Path Band-to-Band Tunneling Model

Sufficient band-bending caused by electric fields or heterostructures can make electrons in the valence band valley ($\Gamma$-valley in the $k$-space), at a certain location, reach the conduction band valley ($\Gamma$-, $X$-, or $L$-valley in the $k$-space) at different locations using direct or phonon-assisted band-to-band tunneling processes.

This model implements the nonlocal generation of electrons and holes caused by direct and phonon-assisted band-to-band tunneling processes [33]. In direct semiconductors such as GaAs and InAs, the direct tunneling process is usually dominant. On the other hand, the phonon-assisted tunneling process is dominant in indirect semiconductors such as Si and Ge. If energy differences between the conduction band valleys are small, it is possible that both the direct and the phonon-assisted tunneling processes are important.

The generation rate is obtained from the nonlocal path integration, and electrons and holes are generated nonlocally at the ends of the tunneling path. As a result, the position-dependent electron and hole generation rates are different in this model. The model can be applied to heterostructure devices with abrupt and graded heterojunctions.

Band-to-Band Tunneling Models

The main difference between this model and the band-to-band tunneling model based on the nonlocal mesh (see Band-to-Band Contributions to Nonlocal Tunneling Current on page 788) is that the tunneling path is determined dynamically based on the energy band profile rather than predefined by the nonlocal mesh. Therefore, this model does not require user-specification of the nonlocal mesh.

The model dynamically searches for the tunneling path with the following assumptions:

*   The tunneling path starts from the valence band minus the valence band offset in a region where the nonlocal path model is active.

*   The tunneling path is a straight line with its direction opposite to the gradient of the valence band at the starting position. The valence band offset does not change the direction of the tunneling path.

*   The tunneling energy is equal to the valence band energy minus the valence band offset at the starting position and is equal to the conduction band energy plus the conduction band offset at the ending position.

*   When the tunneling path encounters Neumann boundaries or semiconductor–insulator interfaces, it undergoes specular reflection.

*   The tunneling path ends at the conduction band plus the conduction band offset.

If the path crosses a region where the nonlocal path model is not active, by default, the tunneling from this path is discarded. If the `-eB2BGenWithinSelectedRegions` flag is specified in the global `Math` section, tunneling for all paths entirely within semiconductor regions are accounted for.

> **NOTE** By default, nonlocal derivative terms in the Jacobian matrix are not taken into account. To use AC or noise analysis with the present model, computation of nonlocal derivatives must be switched on (see Using the Nonlocal Path Band-to-Band Tunneling Model on page 479). The lack of derivative terms can degrade convergence when the high-field saturation mobility model is switched on or the series resistance is defined at electrodes.

## Band-to-Band Generation Rate

For a given tunneling path of length $l$ that starts at $x = 0$ and ends at $x = l$, holes are generated at $x = 0$ and electrons are generated at $x = l$. The net hole recombination rate at $x = 0$ due to the direct band-to-band tunneling process $R_{net}^d$ can be written as:

$$ R_{net}^d = |\nabla E_V(0)| C_d \exp \left( -2 \int_0^l \kappa dx \right) \left[ \left( \exp \left[ \frac{\varepsilon - E_{F,n}(l)}{kT(l)} \right] + 1 \right)^{-1} - \left( \exp \left[ \frac{\varepsilon - E_{F,p}(0)}{kT(0)} \right] + 1 \right)^{-1} \right] \text{ (488)} $$

16: Generation–Recombination
Band-to-Band Tunneling Models

where:

$$ C_{\text{d}} = \frac{g\pi}{36\hbar} \left[ \int_{0}^{l} \frac{dx}{\kappa} \right]^{-1} \left[ 1 - \exp \left( -k_{\text{m}}^{2} \int_{0}^{l} \frac{dx}{\kappa} \right) \right] . $$

*   $h$ is Planck’s constant.

*   $g$ is the degeneracy factor.

*   $\varepsilon = E_{\text{V}}(0) - \Delta_{\text{V}}(0) = E_{\text{C}}(l) + \Delta_{\text{C}}(l)$ is the tunneling energy.

*   $\Delta_{\text{C}}$ is the conduction band offset. $\Delta_{\text{C}}$ can be positive if the considered tunneling process involves the conduction band valley whose energy minimum is greater than the conduction band energy $E_{\text{C}}$. $\Delta_{\text{C}} > 0$ increases the effective band gap.

*   $\Delta_{\text{V}}$ is the valence band offset, and $\Delta_{\text{V}} > 0$ increases the effective band gap.

*   $\kappa$ is the magnitude of the imaginary wavevector obtained from the Kane two-band dispersion relation [[33]](https://example.com/reference33):

$$ \kappa = \frac{1}{\hbar} \sqrt{m_{\text{r}} E_{\text{g,tun}} (1 - \alpha^{2})} \tag{489} $$

$$ \alpha = -\frac{m_{0}}{2m_{\text{r}}} + 2 \sqrt{\frac{m_{0}}{2m_{\text{r}}} \left( \frac{\varepsilon - E_{\text{V}} + \Delta_{\text{V}}}{E_{\text{g,tun}}} - \frac{1}{2} \right) + \frac{m_{0}^{2}}{16m_{\text{r}}^{2}} + \frac{1}{4}} \tag{490} $$

$$ \frac{1}{m_{\text{r}}} = \frac{1}{m_{\text{V}}} + \frac{1}{m_{\text{C}}} \tag{491} $$

$E_{\text{g,tun}} = E_{\text{g,eff}} + \Delta_{\text{C}} + \Delta_{\text{V}}$ is the effective band gap including the band offsets, and $k_{\text{m}}$ is the maximum transverse momentum determined by the maximum valence-band energy $\varepsilon_{\text{max}}$ and the minimum conduction-band energy $\varepsilon_{\text{min}}$ :

$$ k_{\text{m}}^{2} = \min(k_{\text{vm}}^{2}, k_{\text{cm}}^{2}) \tag{492} $$

$$ k_{\text{vm}}^{2} = \frac{2m_{\text{V}}(\varepsilon_{\text{max}} - \varepsilon)}{\hbar^{2}} \tag{493} $$

$$ k_{\text{cm}}^{2} = \frac{2m_{\text{C}}(\varepsilon - \varepsilon_{\text{min}})}{\hbar^{2}} \tag{494} $$

In the Kane two-band dispersion relation, the effective mass in the conduction band $m_{\text{C}}$ and the valence band $m_{\text{V}}$ are related [[33]](https://example.com/reference33):

$$ \frac{1}{m_{\text{C}}} = \frac{1}{2m_{\text{r}}} + \frac{1}{m_{0}} \tag{495} $$

Band-to-Band Tunneling Models

$$ \frac{1}{m_V} = \frac{1}{2m_r} - \frac{1}{m_0} \tag{496} $$

The net hole recombination rate due to the phonon-assisted band-to-band tunneling process $R_{\text{net}}^{\text{p}}$ can be written as:

$$ R_{\text{net}}^{\text{p}} = |\nabla E_V(0)| C_{\text{p}} \exp \left( -2 \int\limits_0^{x_0} \kappa_V dx - 2 \int\limits_{x_0}^l \kappa_C dx \right) \left[ \left( \exp \left[ \frac{\varepsilon - E_{F,n}(l)}{kT(l)} \right] + 1 \right)^{-1} - \left( \exp \left[ \frac{\varepsilon - E_{F,p}(0)}{kT(0)} \right] + 1 \right)^{-1} \right] \tag{497} $$

$$ C_{\text{p}} = \int\limits_0^l \frac{g(1 + 2N_{\text{op}}) D_{\text{op}}^2}{2^6 \pi^2 \rho \varepsilon_{\text{op}} E_{\text{g,tun}}} \frac{m_V m_C}{\sqrt{hl \sqrt{2m_r} E_{\text{g,tun}}}} dx \left( \int\limits_0^{x_0} \frac{dx}{\kappa_V} \right)^{-1} \left( \int\limits_{x_0}^l \frac{dx}{\kappa_C} \right)^{-1} \left[ 1 - \exp \left( -k_{\text{vm}}^2 \int\limits_0^{x_0} \frac{dx}{\kappa_V} \right) \right] \left[ 1 - \exp \left( -k_{\text{cm}}^2 \int\limits_{x_0}^l \frac{dx}{\kappa_C} \right) \right] \tag{498} $$

where $D_{\text{op}}$, $\varepsilon_{\text{op}}$, and $N_{\text{op}} = [\exp(\varepsilon_{\text{op}}/kT) - 1]^{-1}$ are the deformation potential, energy, and number of optical phonons, respectively, $\rho$ is the mass density, and $\kappa_V$ and $\kappa_C$ are the magnitude of the imaginary wavevectors from the Keldysh dispersion relation:

$$ \kappa_V = \frac{1}{\hbar} \sqrt{2m_V |\varepsilon - E_V + \Delta_V|} \Theta(\varepsilon - E_V + \Delta_V) \tag{499} $$

$$ \kappa_C = \frac{1}{\hbar} \sqrt{2m_C |E_C + \Delta_C - \varepsilon|} \Theta(E_C + \Delta_C - \varepsilon) \tag{500} $$

and $x_0$ is the location where $\kappa_V = \kappa_C$.

As Eq. 488, p. 476 and Eq. 497 are the extension of the results in [33] to arbitrary band profiles, these expressions are reduced to the well-known Kane and Keldysh models in the uniform electric-field limit [33]:

$$ R_{\text{net}} = A \left( \frac{F}{F_0} \right)^P \exp \left( -\frac{B}{F} \right) \tag{501} $$

where $F_0 = 1 \text{V/cm}$, $P = 2$ for the direct tunneling process, and $P = 2.5$ for the phonon-assisted tunneling process.

At $T = 300 \text{ K}$ without the bandgap narrowing effect, the prefactor $A$ and the exponential factor $B$ for the direct tunneling process can be expressed by [33]:

$$ A = \frac{g \pi m_r^{1/2} (qF_0)^2}{9h^2 [E_g(300\text{K}) + \Delta_C + \Delta_V]^{1/2}} \tag{502} $$

$$ B = \frac{\pi^2 m_r^{1/2} [E_g(300\text{K}) + \Delta_C + \Delta_V]^{3/2}}{qh} \tag{503} $$

16: Generation–Recombination
Band-to-Band Tunneling Models

For the phonon-assisted tunneling process, $A$ and $B$ can be expressed by [33]:

$$ A = \frac{g(m_V m_C)^{3/2} (1 + 2N_{op}) D_{op}^2 (qF_0)^{5/2}}{2^{21/4} \hbar^{5/2} m_r^{5/4} \rho \epsilon_{op} [E_g(300\text{K}) + \Delta_C + \Delta_V]^{7/4}} $$ (504)

$$ B = \frac{2^{7/2} \pi m_r^{1/2} [E_g(300\text{K}) + \Delta_C + \Delta_V]^{3/2}}{3qh} $$ (505)

# Using the Nonlocal Path Band-to-Band Tunneling Model

Setting `Model=NonlocalPath` in the `Band2Band` option of the command file activates the nonlocal path band-to-band tunneling model. Multiple processes with different parameters are supported by using the `ParameterSetName` keyword and multiple named `Band2BandTunneling` parameter sets (see Using Band-to-Band Tunneling on page 469).

> **NOTE** Each tunneling path (characterized by a particular parameter set name) must have a consistent tunneling process (either direct or phonon-assisted) in different regions. For example, specifying `Ppath=0` (direct tunneling) in silicon regions and specifying `Ppath` greater than zero (phonon-assisted tunneling) in polysilicon regions generate an error message.

`MaxTunnelLength` in the parameter file specifies the maximum length of the tunneling path. If the length reaches `MaxTunnelLength` before a valid tunneling path is found, then band-to-band tunneling is neglected.

You can choose between two input parameter sets in the `Band2BandTunneling` section:

*   The first parameter set consists of ($m_C$, $m_V$, $g$, $\Delta_C$, $\Delta_V$) in the case of direct tunneling or ($m_C$, $m_V$, $gD_{op}^2/\rho$, $\epsilon_{op}$, $\Delta_C$, $\Delta_V$) in the case of phonon-assisted tunneling.

*   The second parameter set consists of ($A$, $B$, $m_V/m_C$, $\Delta_C$, $\Delta_V$) in the case of direct tunneling or ($A$, $B$, $m_V/m_C$, $\epsilon_{op}$, $\Delta_C$, $\Delta_V$) in the case of phonon-assisted tunneling.

> **NOTE** The temperature-specific band gap $E_g(300\text{K}) + \Delta_C + \Delta_V$ in Eq. 502 to Eq. 505 is used solely for the definitions of the $A$ and $B$ parameters to be consistent with the Kane and Keldysh models in the uniform electric-field limit. Internally, the second parameter set is transformed into the first parameter set. The band gap that is used for the WKB integrals features all dependencies (for example, mole fraction, temperature, and stress) as specified in the `Physics` section.

You can specify an anisotropic electron tunneling mass according to the ellipsoidal valley band structure model. In the `Band2BandTunneling` section, the longitudinal and transversal electron

Band-to-Band Tunneling Models

tunneling masses are given by `m_c_l` and `m_c_t`, respectively. The longitudinal direction of the ellipsoid is given in crystal coordinates by `ldir_c`. For the WKB integration, Sentaurus Device computes the directional tunneling mass along the tunneling direction according to:

$$ \frac{1}{m_{\vec{d}}} = \frac{1}{\hbar^2} \frac{\partial^2 E(\vec{k})}{\partial \vec{d}^2} $$ (506)

Specifying $\epsilon_{\text{op}} = 0$ selects the direct tunneling process. When $\epsilon_{\text{op}} = 0$ and the option `FranzDispersion` is switched on in the `Band2Band` option of the command file, the magnitude of the imaginary wavevector is obtained from the Franz two-band dispersion relation (Eq. 808, p. 781) instead of the Kane two-band dispersion relation (Eq. 489, p. 477).

Specifying $\epsilon_{\text{op}} > 0$ selects the phonon-assisted tunneling process. When $m_V / m_C = 0$, $m_V$ and $m_C$ are determined from Eq. 495, p. 477 and Eq. 496, p. 478.

In the parameter file, the parameter pairs `QuantumPotentialFactor` and `QuantumPotentialPosFac` in the `Band2BandTunneling` parameter set specify the prefactors for the electron and hole quantum potentials obtained from the density gradient model (see Density Gradient Model on page 316) that can be added to the effective band gap for tunneling. By default, they are zero, such that the quantum potentials are neglected in the computation of the generation rate. When they are nonzero, the quantum potentials multiplied by the corresponding prefactors are added to the conduction and valence band edges when the transmission coefficient is computed. For `QuantumPotentialFactor`, an addition is performed irrespective of the sign of the quantum potential. For `QuantumPotentialPosFac`, an addition is performed only when the quantum potential is positive, that is, only where quantization causes an effective widening of the band gap. For example, the following section causes the electron and hole quantum potentials to be added to the band gap wherever they cause an effective widening of the band gap:

```
Band2BandTunneling {
  ...
  QuantumPotentialPosFac = 1 1
}
```

Table 93 lists the model parameters, which can be mole fraction dependent. The default values for parameters $A$ and $B$ were obtained from [[31]]([31]).

Table 93 Parameters of nonlocal path band-to-band tunneling model

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| A | Apath | 4×1014 | cm-3s-1 |
| B | Bpath | 1.9×107 | Vcm-1 |
| gDop2 / ρ | Cpath | 0 | J2cmkg-1 |
| g | degeneracy | 0 | 1 |

16: Generation–Recombination
Band-to-Band Tunneling Models

Table 93 Parameters of nonlocal path band-to-band tunneling model (Continued)

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| ΔC | Dcpath | 0 | eV |
| ΔV | Dvpath | 0 | eV |
| $\vec{l}_{dir,c}$ | ldir_c | (0,0,0) | 1 |
| mC | m_c | 0 | m0 |
| mC,l | m_c_l | 0 | m0 |
| mC,t | m_c_t | 0 | m0 |
| mV | m_v | 0 | m0 |
| mC,q | m_c_q | 0.26 | m0 |
| mV,q | m_v_q | 0.16 | m0 |
| εop | Ppath | 0.037 | eV |
| mV/mC | Rpath | 0 | 1 |

# Handling Derivatives

Due to the dynamic search for tunnel paths, the structure of the system Jacobian depends on solution variables. Therefore, the nonzero entries of the Jacobian are not known *a priori*. The possible entries are estimated before entering the Newton loop.

The computation of nonlocal derivative terms is controlled in the global `Math` section, in the `Quasistationary` statement (see Quasistationary Ramps on page 74) and in the `Transient` statement (see Transient Ramps on page 96) using the `NonlocalPath` section.

Using the `Derivative` option in the `NonlocalPath` section, the computation of nonlocal derivatives can be switched on (`Derivative=1`) and switched off (`Derivative=0`). By default, the computation of nonlocal derivatives is switched off.

If nonlocal derivatives are computed, then different strategies are available, using the `Strategy` option, to fill the system Jacobian:

*   If `Strategy=1`, then all previously collected Jacobian entries are registered as possible nonzero entries for the next Newton loop. The collection bin of possible Jacobian entries is emptied at the beginning of the Quasistationary and Transient ramps.

*   If `Strategy=2`, then Jacobian entries that occur only during the last N Newton iterations are registered as possible nonzero entries for the next Newton loop.

*   If `Strategy=3`, then it automatically activates and deactivates the computation of nonlocal derivatives during the Quasistationary and Transient ramps, depending on the step

Band-to-Band Tunneling Models

size. If the step size is smaller than `MinStep`, nonlocal derivatives are computed. If the step size is greater than `MaxStep`, nonlocal derivatives are not computed. Jacobian entries that occur during the last `N` Newton iterations are registered as possible nonzero entries for the next Newton loop.

For example:

```
NonlocalPath (
  Derivative=1
  Strategy=3
  N=5
  MinStep=1.0e-5
  MaxStep=1.0e-2
)
```

**NOTE** Including nonlocal derivatives is computationally heavy and reduces the sparsity of the system Jacobian. Simulation times will increase.

## Tunneling Parameters From the Physical Model Interface

You can create a tunneling parameters PMI model for the customized computation of `DcPath`, `DvPath`, `m_c`, and `m_v` (see Tunneling Parameters on page 1234). When the computation of nonlocal derivatives is switched on (`Derivative=1`), nonlocal derivatives with respect to the lattice temperature are included automatically.

## Energy Shift due to Geometric Confinement

If carriers are confined in thin semiconductor layers, then geometric quantization leads to an energy shift of the conduction and valence bands leading to a larger band gap. The quantum-mechanical energy shift is described by the "particle in a box" model, which describes a particle in a one-dimensional infinite potential well.

For a parabolic dispersion, the energy shift can be described as:

$$ \Delta E_q = \frac{\hbar^2}{2m_q} \left( \frac{\pi}{L} \right)^2 $$ (507)

where:

*   $L$ is the box length and is computed with the `LayerThickness` command (see Extracting Layer Thickness on page 333).

*   $m_q$ is the quantization mass.

This energy shift due to geometric confinement can be switched on (`LayerThickness`) and switched off (`-LayerThickness`) in the `NonlocalPath` section.

Band-to-Band Tunneling Models

**NOTE** You must also switch on the `LayerThickness` command in the corresponding `Physics` section.

You can specify the electron (`m_c_q`) and hole (`m_v_q`) quantization masses in the `Band2BandTunneling` section in the parameter file.

## Postprocessing Mode

To estimate the nonlocal tunneling generation rate without convergence difficulties and without computationally heavy nonlocal derivatives, Sentaurus Device provides the postprocessing mode of the dynamic nonlocal path band-to-band tunneling model.

The postprocessing mode can be switched on (`Postprocessing`) and switched off (`-Postprocessing`) in the `NonlocalPath` section. By default, the postprocessing mode is switched off. Specifying the `NonlocalPath` section in the `Quasistationary` or `Transient` statement overwrites the specifications of the `NonlocalPath` section in the global `Math` section.

In the postprocessing mode, generation rates due to the dynamic nonlocal path band-to-band tunneling model are excluded from the continuity equations. Based on this solution without nonlocal tunneling, Sentaurus Device calculates the nonlocal tunneling generation rates in a postprocessing step.

**NOTE** In the postprocessing mode, nonlocal tunneling is not computed self-consistently. There is no feedback of the nonlocal tunneling generation rates on the solution that has been used to calculate the nonlocal tunneling generation rates.

The tunneling generation currents are computed according to $J^{n/p} = q \int R_{net}^{n/p}(r) d^3r$ where the integration volume expands over all semiconductor regions.

If postprocessing is activated, then the electron and hole tunneling generation currents `eBand2BandGenerationCurrent` and `hBand2BandGenerationCurrent` are written in units of C/s into the plot file.

## Frozen Tunneling Direction

In some cases, the estimation of the tunneling direction pointing along the negative gradient of the valence band energy can be a tunneling direction of minor importance. Furthermore, freezing the tunneling direction can support numeric stability to achieve convergence. You can specify the tunneling direction by setting `direction=<vector>` in the `NonlocalPath` section.

16: Generation–Recombination
Bimolecular Recombination Model

## Visualizing Nonlocal Band-to-Band Generation Rate

To plot the electron and hole generation rates, specify `eBand2BandGeneration` and `hBand2BandGeneration` in the `Plot` section, respectively.

**NOTE** `Band2BandGeneration` is equal to `hBand2BandGeneration`.

# Bimolecular Recombination Model

The bimolecular recombination model describes the interaction of electron–hole pairs and singlet excitons (see Singlet Exciton Equation on page 245).

The rate of electron–hole pair and singlet exciton recombination follows the Langevin form, that is, it is proportional to the carrier mobility. The bimolecular recombination rate is given by:

$$ R_{\text{bimolec}} = \gamma \cdot \frac{q}{\varepsilon_0 \varepsilon_{\text{r}}} \cdot (\mu_{\text{n}} + \mu_{\text{p}}) \left( np - n_{\text{i,eff}}^2 \frac{n_{\text{se}}}{n_{\text{se}}^{\text{eq}}} \right) $$ (508)

where:

*   $\gamma$ is a prefactor for the singlet exciton.

*   $q$ is the elementary charge.

*   $\varepsilon_0$ and $\varepsilon_{\text{r}}$ denote the free space and relative permittivities, respectively.

*   Electron and hole mobilities are given by $\mu_{\text{n}}$ and $\mu_{\text{p}}$, accordingly.

*   $n$, $p$, and $n_{\text{i,eff}}$ describe the electron, hole, and effective intrinsic density, respectively.

*   $n_{\text{se}}$ is the singlet exciton density.

*   $n_{\text{se}}^{\text{eq}}$ denotes the singlet-exciton equilibrium density.

# Using the Bimolecular Recombination Model

You activate the model by specifying `Bimolecular` as an argument of the `Recombination` statement in the `SingletExciton` section (see Table 254 on page 1572). It is switched off by default and can be activated regionwise (see Singlet Exciton Equation on page 245). For example:

```
Physics (Region="EML-ETL") {
  SingletExciton (
    Recombination ( Bimolecular )
  )
}
```

 16: Generation–Recombination
Exciton Dissociation Model

The model parameter is accessible in the `SingletExciton` section of the parameter file.

Table 94 Parameter of the bimolecular recombination model

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| γ | gamma | 0.25 | 1 |

# Exciton Dissociation Model

The exciton dissociation model describes the dissociation of singlet excitons into electron–hole pairs at semiconductor–semiconductor and semiconductor–insulator interfaces.

The rate of singlet exciton interface dissociation is modeled as:

$$ R_{\text{se,diss}}^{\text{surf}} = v_{\text{se, 0}} \sigma_{\text{se} - N_{\text{diss}}} N_{\text{se,diss}}^{\text{surf}} (n_{\text{se}} - n_{\text{se}}^{\text{eq}}) $$ (509)

where:

*   $v_{\text{diss}}^{\text{surf}} = v_{\text{se, 0}} \sigma_{\text{se} - N_{\text{diss}}} N_{\text{se,diss}}^{\text{surf}}$ is the singlet exciton recombination velocity in cm/s.

*   $\sigma_{\text{se} - N_{\text{diss}}}$ is the capture cross-section of exciton dissociation centers with the surface density $N_{\text{se,diss}}^{\text{surf}}$.

*   $v_{\text{se, 0}}$ is the singlet exciton thermal velocity.

*   $n_{\text{se}}$ and $n_{\text{se}}^{\text{eq}}$ are the exciton and equilibrium exciton densities, respectively.

In the dissociation process, a singlet exciton generates an electron–hole pair. The rate in Eq. 509 is a recombination rate for the singlet exciton equation and a generation rate for the electron and hole continuity equations.

## Using the Exciton Dissociation Model

The model is activated using the keyword `Dissociation` as an argument of the `Recombination` statement in the `SingletExciton` section (see Table 254 on page 1572). It is switched off by default and can be activated regionwise (see Singlet Exciton Equation on page 245). The following example activates exciton dissociation at the `EML/ETL` region interface:

```
Physics (RegionInterface="EML/ETL") {
  SingletExciton (Recombination ( Dissociation ))
}
```

References

The model parameters are accessible in the `SingletExciton` section of the parameter file.

Table 95 Parameters of the exciton dissociation model

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| σse – Ndiss | ex_dXsection | 1×10–8 | cm2 |
| Nse,disssurf | N_diss | 1×1010 | cm–2 |

# References

[1] D. J. Roulston, N. D. Arora, and S. G. Chamberlain, “Modeling and Measurement of Minority-Carrier Lifetime versus Doping in Diffused Layers of n+-p Silicon Diodes,” *IEEE Transactions on Electron Devices*, vol. ED-29, no. 2, pp. 284–291, 1982.

[2] J. G. Fossum, “Computer-Aided Numerical Analysis of Silicon Solar Cells,” *Solid-State Electronics*, vol. 19, no. 4, pp. 269–277, 1976.

[3] J. G. Fossum and D. S. Lee, “A Physical Model for the Dependence of Carrier Lifetime on Doping Density in Nondegenerate Silicon,” *Solid-State Electronics*, vol. 25, no. 8, pp. 741–747, 1982.

[4] J. G. Fossum *et al.*, “Carrier Recombination and Lifetime in Highly Doped Silicon,” *Solid-State Electronics*, vol. 26, no. 6, pp. 569–576, 1983.

[5] A. Nakagawa, “One-dimensional device model of the npn bipolar transistor including heavy doping effects under Fermi statistics,” *Solid-State Electronics*, vol. 22, no. 11, pp. 943–949, 1979.

[6] M. S. Tyagi and R. Van Overstraeten, “Minority Carrier Recombination in Heavily-Doped Silicon,” *Solid-State Electronics*, vol. 26, no. 6, pp. 577–597, 1983.

[7] H. Goebel and K. Hoffmann, “Full Dynamic Power Diode Model Including Temperature Behavior for Use in Circuit Simulators,” in *Proceedings of the 4th International Symposium on Power Semiconductor Devices & ICs (ISPSD)*, Tokyo, Japan, pp. 130–135, May 1992.

[8] A. Schenk, “A Model for the Field and Temperature Dependence of Shockley–Read–Hall Lifetimes in Silicon,” *Solid-State Electronics*, vol. 35, no. 11, pp. 1585–1596, 1992.

[9] R. R. King, R. A. Sinton, and R. M. Swanson, “Studies of Diffused Phosphorus Emitters: Saturation Current, Surface Recombination Velocity, and Quantum Efficiency,” *IEEE Transactions on Electron Devices*, vol. 37, no. 2, pp. 365–371, 1990.

[10] R. R. King and R. M. Swanson, “Studies of Diffused Boron Emitters: Saturation Current, Bandgap Narrowing, and Surface Recombination Velocity,” *IEEE Transactions on Electron Devices*, vol. 38, no. 6, pp. 1399–1409, 1991.

16: Generation–Recombination
References

[11] A. Cuevas et al., “Surface Recombination Velocity and Energy Bandgap Narrowing of Highly Doped n-Type Silicon,” in *13<sup>th</sup> European Photovoltaic Solar Energy Conference*, Nice, France, pp. 337–342, October 1995.

[12] A. Schenk and U. Krumbein, “Coupled defect-level recombination: Theory and application to anomalous diode characteristics,” *Journal of Applied Physics*, vol. 78, no. 5, pp. 3185–3192, 1995.

[13] L. Huldt, N. G. Nilsson, and K. G. Svantesson, “The temperature dependence of band-to-band Auger recombination in silicon,” *Applied Physics Letters*, vol. 35, no. 10, pp. 776–777, 1979.

[14] W. Lochmann and A. Haug, “Phonon-Assisted Auger Recombination in Si with Direct Calculation of the Overlap Integrals,” *Solid State Communications*, vol. 35, no. 7, pp. 553–556, 1980.

[15] R. Häcker and A. Hangleiter, “Intrinsic upper limits of the carrier lifetime in silicon,” *Journal of Applied Physics*, vol. 75, no. 11, pp. 7570–7572, 1994.

[16] A. Richter et al., “Improved parameterization of Auger recombination in silicon,” *Energy Procedia*, vol. 27, pp. 88–94, April 2012.

[17] P. P. Altermatt et al., “Injection dependence of spontaneous radiative recombination in c-Si: experiment, theoretical analysis, and simulation,” in *Proceedings of the 5<sup>th</sup> International Conference on Numerical Simulation of Optoelectronic Devices (NUSOD)*, Berlin, Germany, pp. 47–48, September 2005.

[18] A. G. Chynoweth, “Ionization Rates for Electrons and Holes in Silicon,” *Physical Review*, vol. 109, no. 5, pp. 1537–1540, 1958.

[19] R. van Overstraeten and H. de Man, “Measurement of the Ionization Rates in Diffused Silicon p-n Junctions,” *Solid-State Electronics*, vol. 13, no. 1, pp. 583–608, 1970.

[20] Y. Okuto and C. R. Crowell, “Threshold Energy Effect on Avalanche Breakdown Voltage in Semiconductor Junctions,” *Solid-State Electronics*, vol. 18, no. 2, pp. 161–168, 1975.

[21] T. Lackner, “Avalanche Multiplication in Semiconductors: A Modification of Chynoweth’s Law,” *Solid-State Electronics*, vol. 34, no. 1, pp. 33–42, 1991.

[22] M. C. Vecchi and M. Rudan, “Modeling Electron and Hole Transport with Full-Band Structure Effects by Means of the Spherical-Harmonics Expansion of the BTE,” *IEEE Transactions on Electron Devices*, vol. 45, no. 1, pp. 230–238, 1998.

[23] S. Reggiani et al., “Electron and Hole Mobility in Silicon at Large Operating Temperatures—Part I: Bulk Mobility,” *IEEE Transactions on Electron Devices*, vol. 49, no. 3, pp. 490–499, 2002.

[24] M. Valdinoci et al., “Impact-ionization in silicon at large operating temperature,” in *International Conference on Simulation of Semiconductor Processes and Devices (SISPAD)*, Kyoto, Japan, pp. 27–30, September 1999.

References

[25] E. Gnani *et al.*, “Extraction method for the impact-ionization multiplication factor in silicon at large operating temperatures,” in *Proceedings of the 32nd European Solid-State Device Research Conference (ESSDERC)*, Florence, Italy, pp. 227–230, September 2002.

[26] S. Reggiani *et al.*, “Investigation about the High-Temperature Impact-Ionization Coefficient in Silicon,” in *Proceedings of the 34th European Solid-State Device Research Conference (ESSDERC)*, Leuven, Belgium, pp. 245–248, September 2004.

[27] S. Reggiani *et al.*, “Experimental extraction of the electron impact-ionization coefficient at large operating temperatures,” in *IEDM Technical Digest*, San Francisco, CA, USA, pp. 407–410, December 2004.

[28] T. Hatakeyama *et al.*, “Physical Modeling and Scaling Properties of 4H-SiC Power Devices,” in *International Conference on Simulation of Semiconductor Processes and Devices (SISPAD)*, Tokyo, Japan, pp. 171–174, September 2005.

[29] R. J. McIntyre, “On the Avalanche Initiation Probability of Avalanche Diodes Above the Breakdown Voltage,” *IEEE Transactions on Electron Devices*, vol. ED-20, no. 7, pp. 637–641, 1973.

[30] A. Schenk, “Rigorous Theory and Simplified Model of the Band-to-Band Tunneling in Silicon,” *Solid-State Electronics*, vol. 36, no. 1, pp. 19–34, 1993.

[31] G. A. M. Hurkx, D. B. M. Klaassen, and M. P. G. Knuvers, “A New Recombination Model for Device Simulation Including Tunneling,” *IEEE Transactions on Electron Devices*, vol. 39, no. 2, pp. 331–338, 1992.

[32] J. J. Liou, “Modeling the Tunnelling Current in Reverse-Biased p/n Junctions,” *Solid-State Electronics*, vol. 33, no. 7, pp. 971–972, 1990.

[33] E. O. Kane, “Theory of Tunneling,” *Journal of Applied Physics*, vol. 32, no. 1, pp. 83–91, 1961.

