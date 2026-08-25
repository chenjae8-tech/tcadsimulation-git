# CHAPTER 22 Radiation

*This chapter describes the radiation models used in Sentaurus Device.*

When high-energy particles penetrate a semiconductor device, they deposit their energy by the generation of electron–hole pairs. These charges can perturb the normal operation of the device. This chapter describes the models for carrier generation by gamma radiation, alpha particles, and heavy ions.

# Carrier Generation by Gamma Radiation

To activate the gamma radiation model, specify the keyword `Radiation(...)`, with optional parameters, in the `Physics` section. For example:

```
Physics { ...
  Radiation(
    Dose = <float> | DoseRate = <float>
    DoseTime = (<float>,<float>)
    DoseTSigma = <float>
  )
}
```

where:

*   `DoseRate` (in rad/s) represents *D* in Eq. 761.

*   The optional `DoseTime` (in s ) allows you to specify the time period during which exposure to the constant `DoseRate` occurs.

*   `DoseTSigma` (in s ) can be combined with `DoseTime` to specify the standard deviation of a Gaussian rise and fall of the radiation exposure.

*   As an alternative to `DoseRate`, you can specify `Dose` (in rad) to represent the total radiation exposure over the `DoseTime` interval. In this case, `DoseTime` must be specified.

To plot the generation rate due to gamma radiation, specify `RadiationGeneration` in the `Plot` section.

Carrier Generation by Alpha Particles

## Yield Function

Generation of electron–hole pairs due to radiation is an electric field–dependent process [1] and is modeled as follows:

$$
\begin{aligned}
G_r &= g_0 D \cdot Y(F) \\
Y(F) &= \left( \frac{F + E_0}{F + E_1} \right)^m
\end{aligned}
\eqno(761)
$$

where $D$ is the dose rate, $g_0$ is the generation rate of electron–hole pairs, and $E_0$, $E_1$, and $m$ are constants.

All these constants can be specified in the parameter file of Sentaurus Device as follows:

```
Radiation {
  g = 7.6000e+12      # [1/(rad*cm^3)]
  E0 = 0.1            # [V/cm]
  E1 = 1.3500e+06     # [V/cm]
  m = 0.9             # [1]
}
```

# Carrier Generation by Alpha Particles

To activate the alpha particle model, specify the keyword `AlphaParticle(...)`, with optional parameters, in the `Physics` section. For example:

```
Physics { ...
  AlphaParticle (<keyword_options>)
}
```

Table 276 on page 1587 lists the keyword options for alpha particles.

To plot the instant generation rate $G(t)$ due to alpha particles, specify `AlphaGeneration` in the `Plot` section. To plot $\int_{-\infty}^{\infty} dtG$, specify `AlphaCharge`.

> **NOTE** The generation by alpha particles cannot be used except in transient simulations. The number of electron–hole pairs generated before the initial time of the transient is added to the carrier densities at the beginning of the simulation.

An option to improve the spatial integration of the charge generation is presented in References on page 727.

22: Radiation

Carrier Generation by Alpha Particles

# Using the Alpha Particle Model

The generation rate caused by an alpha particle with energy $E$ is computed by [[2]]([2]):

$$ G(u, v, w, t) = \frac{a}{\sqrt{2\pi} \cdot s} \exp \left[ -\frac{1}{2} \left( \frac{t - t_m}{s} \right)^2 - \frac{1}{2} \left( \frac{v^2 + w^2}{w_t^2} \right) \right] \left[ c_1 e^{\alpha u} + c_2 \exp \left( -\frac{1}{2} \left( \frac{u - \alpha_1}{\alpha_2} \right)^2 \right) \right] $$ (762)

if $u < \alpha_1 + \alpha_3$, and by:

$$ G(u, v, w, t) = 0 $$ (763)

if $u \geq \alpha_1 + \alpha_3$. In this case, $u$ is the coordinate along the particle path, and $v$ and $w$ are coordinates orthogonal to $u$. The direction and place of incidence are defined in the `Physics` section of the command file with the keywords `Direction` and `Location` (or `StartPoint`, see Note on page 725), respectively. The $t_m$ parameter is the time of the generation peak defined by the keyword `Time`. A Gaussian time dependence can also be used to simulate the typical generation due to pulsed laser or electron beams.

The maximum of the Bragg peak, $\alpha_1$, is fitted to data [[3]]([3]) by a polynomial function:

$$ \alpha_1 = a_0 + a_1 E + a_2 E^2 $$ (764)

The parameter $c_1$ is given by:

$$ c_1 = \exp[\alpha(\alpha_1[10\text{MeV}] - \alpha_1[E])] $$ (765)

The scaling factor $a$ is determined from:

$$ \int_0^\infty \int_{-\infty}^\infty \int_{-\infty}^\infty \int_{-\infty}^\infty G(u, v, w, t) dt dw dv du = \frac{E}{E_p} $$ (766)

where $E_p$ is the average energy needed to create an electron–hole pair. The remaining parameters are listed in Table 132. They are available in the parameter set `AlphaParticle` and are valid for alpha particles with energies between 1 MeV and 10 MeV.

Table 132 Coefficients for carrier generation by alpha particles

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| s | s | 2 × 10⁻¹² | s |
| wₜ | wt | 1 × 10⁻⁵ | cm |
| c₂ | c2 | 1.4 | 1 |
| a | alpha | 90 | cm⁻¹ |

Carrier Generation by Heavy Ions

Table 132 Coefficients for carrier generation by alpha particles (Continued)

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| $\alpha_2$ $\alpha_3$ | alpha2 | $5.5 \times 10^{-4}$ | cm |
| alpha3 | $2 \times 10^{-4}$ | cm |  |
| $E_p$ | Ep | 3.6 | eV |
| $a_o$ $a_1$ $a_2$ | a0 | $-1.033 \times 10^{-4}$ | cm |
| a1 | $2.7 \times 10^{-10}$ | cm/eV |  |
| a2 | $4.33 \times 10^{-17}$ | cm/eV$^2$ |  |

# Carrier Generation by Heavy Ions

When a heavy ion penetrates a device structure, it loses energy and creates a trail of electron–hole pairs. These additional electrons and holes might cause a large enough current to switch the logic state of a device, for example, a memory cell. Important factors are:

* The energy and type of the ion

* The angle of penetration of the ion

* The relation between the lost energy or linear energy transfer (LET) and the number of pairs created

The simulation of a single event upset caused by a heavy ion impact is activated by using the keyword `HeavyIon` in an appropriate `Physics` section. For example:

```
# Default heavy ion
Physics {
 HeavyIon (<keyword_options>)
}

# User-defined heavy ion
Physics {
 HeavyIon (<IonName>) (<keyword_options>)
}
```

**NOTE** User-defined heavy ions do not have default parameters. Therefore, in the parameter file, a specification of the following form must appear (see Table 134 on page 725):

```
HeavyIon(<IonName>)(...)
```

Table 277 on page 1587 describes the options for `HeavyIon`. The generation rate by the heavy ion is generally used in transient simulations. The number of electron–hole pairs generated before the initial time of the transient is added to the carrier densities at the beginning of the simulation. The total charge density and the instant generation rate are plotted using `HeavyIonCharge` and `HeavyIonGeneration` in the `Plot` section, respectively.

22: Radiation
Carrier Generation by Heavy Ions

If the value of `Wt_hi` is 0, then uniform generation is selected. If the value of `LET_f` is 0, then the keyword `LET_f` can be ignored.

# Using the Heavy Ion Model

Figure 47 shows a simple model for the heavy ion impinging process.

A heavy ion penetrating a semiconductor showing track length lmax and transverse spatial influence w(l)

Figure 47 A heavy ion penetrating a semiconductor; its track is defined by a length and the transverse spatial influence is assumed to be symmetric about the track axis

The generation rate caused by the heavy ion is computed by:

$$ G(l, w, t) = G_{\text{LET}}(l) R(w, l) T(t) $$ (767)

if $l < l_{\text{max}}$ ($l_{\text{max}}$ is the length of the track), and by:

$$ G(l, w, t) = 0 $$ (768)

if $l \geq l_{\text{max}}$. $R(w)$ and $T(t)$ are functions describing the spatial and temporal variations of the generation rate. $G_{\text{LET}}(l)$ is the LET generation density and its unit is $\text{pairs/cm}^3$.

$T(t)$ is defined as a Gaussian function:

$$ T(t) = \frac{2 \cdot \exp \left[ -\left( \frac{t - t_0}{\sqrt{2} \cdot s_{\text{hi}}} \right)^2 \right]}{\sqrt{2} \cdot s_{\text{hi}} \sqrt{\pi} \left( 1 + \text{erf} \left( \frac{t_0}{\sqrt{2} \cdot s_{\text{hi}}} \right) \right)} $$ (769)

where $t_0$ is the moment of the heavy ion penetration (see the keyword `Time` in Table 277 on page 1587), and $s_{\text{hi}}$ is the characteristic value of the Gaussian (see `s_hi` in Table 134 on page 725).

Carrier Generation by Heavy Ions

The spatial distribution, $R(w, l)$, can be defined as either an exponential function (default):

$$R(w, l) = \exp(-\frac{w}{w_t(l)})$$ (770)

or a Gaussian function:

$$R(w, l) = \exp(-(\frac{w}{w_t(l)})^2)$$ (771)

where $w$ is a radius defined as the perpendicular distance from the track. The characteristic distance $w_t$ is defined as `Wt_hi` in the `HeavyIon` statement and can be a function of the length $l$ (see Table 277 on page 1587).

In addition, the spatial distribution $R(w, l)$ can be defined as a PMI function (see Heavy Ion Spatial Distribution on page 1427).

The LET generation density, $G_{LET}(l)$, is given by:

$$G_{LET}(l) = a_1 + a_2l + a_3e^{a_4l} + k' [c_1(c_2 + c_3l)^{c_4} + \text{LET\_f}(l)]$$ (772)

where `LET_f(l)` (defined by the keyword `LET_f`) is a function of the length $l$. Example 2 on page 726 illustrates how to use an array of values to specify the length dependence of `LET_f(l)`. A linear interpolation is used for values between the array entries of `LET_f`.

There are two options for the units of `LET_f`: pairs/cm<sup>3</sup> (default) or pC/$\mu$m (activated by the keyword `PicoCoulomb`). Depending on the units chosen, $k'$ takes on different values in order to make Eq. 772 dimensionally consistent. Table 133 summarizes the appropriate values of $k'$ for different device dimensions.

Table 133 Setting correct $k'$ to make LET generation density equation dimensionally consistent

| Condition | Two-dimensional device | Three-dimensional device |
| --- | --- | --- |
| LET_f has units of pairs/cm³ and R(w, l) is exponential or Gaussian | k' = k | k' = k |
| LET_f has units of pC/μm and R(w, l) is exponential | k' = $\frac{k}{2w_td}$ d = 1μm | k' = $\frac{k}{2\pi w_t^2}$ |
| LET_f has units of pC/μm and R(w, l) is Gaussian | k' = $\frac{k}{\sqrt{\pi}w_td}$ d = 1μm | k' = $\frac{k}{\pi w_t^2}$ |

22: Radiation

Carrier Generation by Heavy Ions

Exercise care when choosing the correct units for `Wt_hi` and `Length`. The default unit of `Wt_hi` and `Length` is centimeter. If you specify `PicoCoulomb`, then the unit becomes μm. For examples illustrating the correct unit use, see Examples: Heavy Ions.

Table 134 lists the other coefficients used in Eq. 772 with their default values, and they can be adjusted in the parameter file of Sentaurus Device.

> **NOTE** The keyword `Location` defines a bidirectional track for which Sentaurus Device computes the generation rate in both directions from the place of incidence along the `Direction` vector. The keyword `StartPoint` defines a one-directional track. In this case, Sentaurus Device computes the generation rate only in the positive direction from the place of incidence.

Table 134 Coefficients for carrier generation by heavy ion (HeavyIon parameter set)

|  | shi | a1 | a2 | a3 | a4 | k | c1 | c2 | c3 | c4 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Keyword | s_hi | a_1 | a_2 | a_3 | a_4 | k_hi | c_1 | c_2 | c_3 | c_4 |
| Default value | 2e-12 | 0 | 0 | 0 | 0 | 1 | 0 | 1 | 0 | 1 |
| Default unit | s | pairs/cm3 | pairs/cm3/cm | pairs/cm3 | cm-1 | 1 | pairs/cm3 | 1 | cm-1 | 1 |
| Unit if PicoCoulomb is chosen | s | pairs/cm3 | pairs/cm3/μm | pairs/cm3 | μm-1 | 1 | pC/μm | 1 | μm-1 | 1 |

# Examples: Heavy Ions

This section presents examples of using the heavy ion model.

## Example 1

The track has a constant `LET_f` value of 0.2 pC/μm across the track. The track length is 1 μm ($l_{max} = 1 \text{ μm}$) and the heavy ion crosses the device at time 0.1 ps. The unit of `LET_f` is pC/μm and the spatial distribution is Gaussian. Since `PicoCoulomb` is specified, the values of `Length` and `Wt_hi` are expressed in terms of μm. The keyword `HeavyIonChargeDensity` in the `Plot` section plots the charge density generated by the ion.

```
Physics {
  Recombination ( SRH(DopingDependence) )
  Mobility (DopingDependence Enormal HighFieldSaturation)
  HeavyIon (
    Direction=(0,1)
    Location=(1.5,0)
    Time=1.0e-13
```

Carrier Generation by Heavy Ions

```
        Length=1
        Wt_hi=3
        LET_f=0.2
        Gaussian
        PicoCoulomb
       )
}
Plot { eDensity hDensity ElectricField HeavyIonChargeDensity }
```

## Example 2

The `LET_f` and radius (`Wt_hi`) values are functions of the position along the track (in this case, $l_{\text{max}} = 1.7 \times 10^{-4} \text{ cm}$). Values in between the array entries are interpolated linearly. The unit of `LET_f` is $\text{pairs/cm}^3$ (because `PicoCoulomb` is not specified), and the unit for `Length` and `Wt_hi` is centimeter. For each value of length, there is a corresponding value of `LET_f` and a value for the radius. The spatial distribution in the perpendicular direction from the track is exponential.

```
Physics {
    Recombination ( SRH(DopingDependence) )
    HeavyIon (
        Direction=(0,1)
        Location=(1.5,0)
        Time=1.0e-13
        Length = [1e-4 1.5e-4 1.6e-4 1.7e-4]
        LET_f = [1e6 2e6 3e6 4e6]
        Wt_hi = [0.3e-4 0.2e-4 0.25e-4 0.1e-4]
        Exponential
    )
}
```

## Example 3

This example illustrates multiple ion strikes in the model.

```
Physics {
    Recombination ( SRH(DopingDependence) )
    HeavyIon (
        Direction=(0,1)
        Location=(0,0)
        Time=1.0e-13
        Length = [1e-4 1.5e-4 1.6e-4 1.7e-4]
        LET_f = [1e6 2e6 3e6 4e6]
        Wt_hi = [0.3e-4 0.2e-4 0.25e-4 0.1e-4]
    )
```

22: Radiation
References

```
    HeavyIon ("Ion1")(
      Direction=(0,1)
      Location=(1,0)
      Time=1.0e-13
      Length = [1e-4 1.5e-4 1.6e-4 1.7e-4]
      LET_f = [1e6 2e6 3e6 4e6]
      Wt_hi = [0.3e-4 0.2e-4 0.25e-4 0.1e-4]
    )
}
```

User-defined heavy ions do not have default parameters. Therefore, in the parameter file, a specification of the following form must appear (see Table 134 on page 725):

`HeavyIon("Ion1")(...)`

---

# References

[1] J.-L. Leray, “Total Dose Effects: Modeling for Present and Future,” *IEEE Nuclear and Space Radiation Effects Conference (NSREC) Short Course*, 1999.

[2] A. Erlebach, *Modellierung und Simulation strahlensensitiver Halbleiterbauelemente*, Aachen: Shaker, 1999.

[3] L. C. Northcliffe and R. F. Schilling, “Range and Stopping - Power Tables for Heavy Ions,” *Nuclear Data Tables*, vol. A7, no. 1–2, New York: Academic Press, pp. 233–463, 1969.

References

 