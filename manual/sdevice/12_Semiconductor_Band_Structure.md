# CHAPTER 12 Semiconductor Band Structure

*This chapter discusses the relevance of band structure to the simulation of semiconductor devices.*

For device simulation, the most fundamental property of a semiconductor is its band structure. Realistic band structures are complex and can be fully accounted for only in Monte Carlo simulations (see the Sentaurus™ Device Monte Carlo User Guide). In Sentaurus Device, the band structure is simplified to the following quantities:

*   Energies of the conduction and valence band edges or, parameterized differently, the band gap and electron affinity (see Band Gap and Electron Affinity)

*   Density-of-states (DOS) masses for electrons and holes, or parameterized differently, the band edge DOS (see Effective Masses and Effective Density-of-States on page 272)

# Intrinsic Density

The band gap and band edge DOS are summarized in the intrinsic density $n_i(T)$ (for undoped semiconductors):

$$ n_i(T) = \sqrt{N_C(T)N_V(T)} \exp \left( -\frac{E_g(T)}{2kT} \right) \text{ (151)} $$

and the effective intrinsic density (including doping-dependent bandgap narrowing):

$$ n_{i, \text{ eff}} = n_i \exp \left( \frac{E_{\text{bgn}}}{2kT} \right) \text{ (152)} $$

In devices that contain different materials, the electron affinity $\chi$ (see Band Gap and Electron Affinity) is also important. Along with the band gap, it determines the alignment of conduction and valence bands at material interfaces.

# Band Gap and Electron Affinity

The band gap is the difference between the lowest energy in the conduction band and the highest energy in the valence band. The electron affinity is the difference between the lowest energy in the conduction band and the vacuum level.

Band Gap and Electron Affinity

## Selecting the Bandgap Model

Sentaurus Device supports different bandgap models: `BennettWilson` (default), `delAlamo`, `JainRoulston`, `OldSlotboom`, `Slotboom` (the same as `OldSlotboom` with different default parameters), and `TableBGN`.

You specify the bandgap model in the `EffectiveIntrinsicDensity` statement in the `Physics` section. The following example activates the `Slotboom` model:

```
Physics {
  EffectiveIntrinsicDensity(BandGapNarrowing (Slotboom))
}
```

By default, bandgap narrowing is active. Bandgap narrowing can be switched off with the keyword `NoBandGapNarrowing`:

```
Physics {
  EffectiveIntrinsicDensity(NoBandGapNarrowing)
}
```

**NOTE** To plot the band gap including the bandgap narrowing, specify `EffectiveBandGap` in the `Plot` section of the command file. The quantity that Sentaurus Device plots when `BandGap` is specified does not include bandgap narrowing.

Table 36 on page 271 and Table 37 on page 272 list the model parameters available for calibration (see Bandgap and Electron-Affinity Models).

## Bandgap and Electron-Affinity Models

Sentaurus Device models the lattice temperature–dependency of the band gap as [1]:

$$ E_g(T) = E_g(0) - \frac{\alpha T^2}{T + \beta} $$ (153)

where $E_g(0)$ is the bandgap energy at $0\text{ K}$, and $\alpha$ and $\beta$ are material parameters (see Table 36).

To allow $E_g(0)$ to differ for different bandgap models, it is written as:

$$ E_g(0) = E_{g,0} + \delta E_{g,0} $$ (154)

Band Gap and Electron Affinity

$E_{g,0}$ is an adjustable parameter common to all models. For the `TableBGN` and `JainRoulston` models, $\delta E_{g,0} = 0$. Each of the other models offers its own adjustable parameter for $\delta E_{g,0}$ (see Table 36 on page 271).

The effective band gap results from the band gap reduced by bandgap narrowing:

$$E_{g,\text{eff}}(T) = E_g(T) - E_{\text{bgn}}$$ (155)

The electron affinity $\chi$ is the energy separation between the conduction band and the vacuum. For `BennettWilson`, `delAlamo`, `OldSlotboom`, `Slotboom`, and `TableBGN`, the affinity is temperature dependent and is affected by bandgap narrowing:

$$\chi(T) = \chi_0 + \frac{(\alpha + \alpha_2)T^2}{2(T + \beta + \beta_2)} + \text{Bgn2Chi} \cdot E_{\text{bgn}}$$ (156)

where $\chi_0$ and `Bgn2Chi` are adjustable parameters (see Table 36). `Bgn2Chi` defaults to 0.5 and, therefore, bandgap narrowing splits equally between conduction and valence bands.

For the `JainRoulston` model, the electron affinity depends also on the doping concentration (especially at high dopings) because bandgap narrowing is doping dependent:

$$\chi(T, N_{A,0}, N_{D,0}) = \chi_0 + \frac{(\alpha + \alpha_2)T^2}{2(T + \beta + \beta_2)} + E_{\text{bgn}}^{\text{cond}}$$ (157)

where $E_{\text{bgn}}^{\text{cond}}$ is the shift in the conduction band due to the `JainRoulston` bandgap narrowing and $\chi_0$ is an adjustable parameter as previously defined.

The main difference of the bandgap models is how they handle bandgap narrowing. Bandgap narrowing in Sentaurus Device has the form:

$$E_{\text{bgn}} = \Delta E_g^0 + \Delta E_g^{\text{Fermi}}$$ (158)

where $\Delta E_g^0$ is determined by the particular bandgap narrowing model used, and $\Delta E_g^{\text{Fermi}}$ is an optional correction to account for carrier statistics (see Eq. 172, p. 270).

## Bandgap Narrowing for Bennett–Wilson Model

Bandgap narrowing for the Bennett–Wilson [2] model (keyword `BennettWilson`) in Sentaurus Device reads:

$$\Delta E_g^0 = \begin{cases} E_{\text{ref}} \left[ \ln \left( \frac{N_{\text{tot}}}{N_{\text{ref}}} \right) \right]^2 & N_{\text{tot}} \geq N_{\text{ref}} \\ 0 & \text{otherwise} \end{cases}$$ (159)

Band Gap and Electron Affinity

The model was developed from absorption and luminescence data of heavily doped n-type materials. The material parameters $E_{\text{ref}}$ and $N_{\text{ref}}$ are accessible in the `Bennett` parameter set in the parameter file of Sentaurus Device (see Table 37 on page 272).

## Bandgap Narrowing for Slotboom Model

Bandgap narrowing for the Slotboom model (keyword `Slotboom` or `OldSlotboom`) (the only difference is in the parameters) in Sentaurus Device reads:

$$ \Delta E_g^0 = E_{\text{ref}} \left[ \ln \left( \frac{N_{\text{tot}}}{N_{\text{ref}}} \right) + \sqrt{\left( \ln \left( \frac{N_{\text{tot}}}{N_{\text{ref}}} \right) \right)^2 + 0.5} \right] \eqno(160) $$

The models are based on measurements of $\mu_n n_i^2$ in n-p-n transistors (or $\mu_p n_i^2$ in p-n-p transistors) with different base doping concentrations and a 1D model for the collector current [[3]–[6]]([3]–[6]). The material parameters $E_{\text{ref}}$ and $N_{\text{ref}}$ are accessible in the `Slotboom` and `OldSlotboom` parameter sets in the parameter file (see Table 37).

## Bandgap Narrowing for del Alamo Model

Bandgap narrowing for the del Alamo model (keyword `delAlamo`) in Sentaurus Device reads:

$$ \Delta E_g^0 = \begin{cases} E_{\text{ref}} \ln \left( \frac{N_{\text{tot}}}{N_{\text{ref}}} \right) & N_{\text{tot}} \ge N_{\text{ref}} \\ 0 & \text{otherwise} \end{cases} \eqno(161) $$

This model was proposed [[7]–[11]]([7]–[11]) for n-type materials. The material parameters $E_{\text{ref}}$ and $N_{\text{ref}}$ are accessible in the `delAlamo` parameter set in the parameter file (see Table 37).

## Bandgap Narrowing for Jain–Roulston Model

Bandgap narrowing for the Jain–Roulston model (keyword `JainRoulston`) in Sentaurus Device is implemented based on the literature [[12]]([12]) and is given by:

$$ \Delta E_g^0 = A \cdot N_{\text{tot}}^{1/3} + B \cdot N_{\text{tot}}^{1/4} + C \cdot N_{\text{tot}}^{1/2} + D \cdot N_{\text{tot}}^{1/2} \eqno(162) $$

where $A$, $B$, $C$, and $D$ are material-dependent coefficients that can be specified in the parameter file.

12: Semiconductor Band Structure
Band Gap and Electron Affinity

The coefficients $A$, $B$, $C$, and $D$ are derived from the quantities defined and described in the literature [12]:

$$ A = 1.83 \frac{\Lambda}{N_b^{1/3} \left( \frac{3}{4\pi} \right)^{1/3}} aR \quad [\text{eV} \cdot \text{cm}] \eqno(163) $$

$$ B = \frac{0.95 R a^{3/4}}{\left( \frac{3}{4\pi} \right)^{1/4}} \quad [\text{eV} \cdot \text{cm}^{3/4}] \eqno(164) $$

$$ C = \frac{1.57 R a^{3/2}}{N_b \left( \frac{3}{4\pi} \right)^{1/2}} \quad [\text{eV} \cdot \text{cm}^{3/2}] \eqno(165) $$

$$ D = \frac{1.57 R_{(\text{mino})} a^{3/2}}{N_b \left( \frac{3}{4\pi} \right)^{1/2}} \quad [\text{eV} \cdot \text{cm}^{3/2}] \eqno(166) $$

where $a$ is the effective Bohr radius, $R$ is the Rydberg energy, $N_b$ is the number of valleys in the conduction or valence band, $R_{(\text{mino})}$ is the Rydberg energy for the minority carrier band, and $\Lambda$ is a correction factor.

In general, papers on bandgap narrowing define the Jain–Roulston bandgap narrowing as $\Delta E_g^0 = C_1 \cdot N_{\text{tot}}^{1/3} + C_2 \cdot N_{\text{tot}}^{1/4} + C_3 \cdot N_{\text{tot}}^{1/2}$. Comparing this definition to Eq. 162, the coefficients $C_1$, $C_2$, and $C_3$ can be mapped to the ones of Sentaurus Device: $C_1 = A$, $C_2 = B$, and $C_3 = C + D$.

If, on the other hand, $C_1$, $C_2$, and $C_3$ are given, then computing the corresponding Sentaurus Device coefficients $A$, $B$, $C$, and $D$ requires splitting $C_3$ into $C$ and $D$ using Eq. 165 and Eq. 166.

Sentaurus Device needs four coefficients instead of three to compute $E_{\text{bgn}}^{\text{cond}}$ and the doping-dependent affinity (Eq. 157) internally. The expression of $E_{\text{bgn}}^{\text{cond}}$ is given by:

$$ E_{\text{bgn}}^{\text{cond}} = \begin{cases} A \cdot N_{\text{tot}}^{1/3} + C \cdot N_{\text{tot}}^{1/2} & N_{\text{D},0} > N_{\text{A},0} \\ B \cdot N_{\text{tot}}^{1/4} + D \cdot N_{\text{tot}}^{1/2} & \text{otherwise} \end{cases} \eqno(167) $$

The coefficients for SiC are available in Sentaurus Device. The default coefficients for SiC are for the material 4H-SiC. You need to define the coefficients for the material 6H-SiC in the parameter file. These coefficients are taken from the literature [13].

Band Gap and Electron Affinity

The coefficients $A$, $B$, $C$, and $D$ are specified in the `JainRoulston` section of the parameter file:

```
Material = "Silicon" {
  JainRoulston {
    * n-type
    A_n = 1.02e-8      # [eV cm]
    B_n = 4.15e-7      # [eV cm^(3/4)]
    C_n = 1.45e-12     # [eV cm^(3/2)]
    D_n = 1.48e-12     # [eV cm^(3/2)]
    * p-type
    A_p = 1.11e-8      # [eV cm]
    B_p = 4.79e-7      # [eV cm^(3/4)]
    C_p = 3.23e-12     # [eV cm^(3/2)]
    D_p = 1.81e-12     # [eV cm^(3/2)]
  }
}
```

Table 34 Coefficients and their default values for Jain–Roulston bandgap narrowing model

| Symbol | Parameter name | Default value for material | Unit |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Si | Ge | GaAs | 4H-SiC | 6H-SiC | All others |  |  |  |
| A | A_n | 1.02e-8 | 7.30e-9 | 1.65e-8 | 1.50e-8 | 1.12e-8 | 0.0 | eVcm |
| A_p | 1.11e-8 | 8.21e-9 | 9.77e-9 | 1.30e-8 | 1.30e-8 | 0.0 | eVcm |  |
| B | B_n | 4.15e-7 | 2.57e-7 | 2.38e-7 | 6.01e-7 | 6.67e-7 | 0.0 | eVcm3/4 |
| B_p | 4.79e-7 | 2.91e-7 | 3.87e-7 | 4.96e-7 | 5.50e-7 | 0.0 | eVcm3/4 |  |
| C | C_n | 1.45e-12 | 2.29e-12 | 1.83e-11 | 2.93e-12 | 1.01e-12 | 0.0 | eVcm3/2 |
| C_p | 3.23e-12 | 3.58e-12 | 3.41e-12 | 1.15e-12 | 1.14e-12 | 0.0 | eVcm3/2 |  |
| D | D_n | 1.48e-12 | 2.03e-12 | 7.25e-11 | 8.74e-12 | 1.73e-12 | 0.0 | eVcm3/2 |
| D_p | 1.81e-12 | 2.19e-12 | 4.84e-13 | 3.87e-13 | 6.64e-13 | 0.0 | eVcm3/2 |  |

## Table Specification of Bandgap Narrowing

You can specify bandgap narrowing using a table, which can be defined in the `TableBGN` parameter set. This table gives the value of bandgap narrowing as a function of donor or acceptor concentration, or total concentration (the sum of acceptor and donor concentrations).

When specifying acceptor and donor concentrations, the total bandgap narrowing is the sum of the contributions of the two dopant types. If only acceptor or only donor entries are present in the table, the bandgap narrowing contribution for the missing dopant type vanishes. Total concentration and donor or acceptor concentration must not be specified in the same table.

**12: Semiconductor Band Structure**
Band Gap and Electron Affinity

Each table entry is a line that specifies a concentration type (`Donor`, `Acceptor`, or `Total`) with a concentration in cm<sup>–3</sup>, and the bandgap narrowing for this concentration in eV. The actual bandgap narrowing contribution for each concentration type is interpolated from the table, using a scheme that is piecewise linear in the logarithm of the concentration.

For concentrations below (or above) the range covered by table entries, the bandgap narrowing of the entry for the smallest (or greatest) concentration is assumed. For example:

```
TableBGN {
  Total 1e16, 0
  Total 1e20, 0.02
}
```

means that for total doping concentrations below 10<sup>16</sup> cm<sup>–3</sup>, the bandgap narrowing vanishes, then increases up to 20 meV at 10<sup>20</sup> cm<sup>–3</sup> concentration and maintains this value for even greater concentrations. The interpolation is such that, in this example, the bandgap narrowing at 10<sup>18</sup> cm<sup>–3</sup> is 10 meV.

Tabulated default parameters for bandgap narrowing are available only for GaAs. For all other materials, you can specify the tabulated data in the parameter file.

> **NOTE** You cannot specify mole fraction–dependent bandgap narrowing tables. In particular, Sentaurus Device does not relate the parameters for ternary compound semiconductor materials to those of the related binary materials.

## Schenk Bandgap Narrowing Model

BennettWilson, delAlamo, JainRoulston, OldSlotboom, Slotboom, and TableBGN are all doping-induced bandgap narrowing models. They do not depend on carrier concentrations. High carrier concentrations produced in optical excitation or high electric field injection can also cause bandgap narrowing. This effect is referred to as plasma-induced bandgap narrowing.

The Schenk bandgap narrowing model described in [[14]]([14]) also takes into account the plasma-induced narrowing effect in silicon. In this model, the bandgap narrowing is the sum of two parts:

*   An exchange-correlation part, which is a function of plasma density and temperature

*   An ionic part, which is a function of activated doping concentration, plasma density, and temperature

Sentaurus Device supports two versions of the Schenk model: a simplified version where bandgap narrowing is computed at $T = 0\text{ K}$ and does not depend on temperature, and the full model where temperature dependence is accounted for. You can switch from the simplified

Band Gap and Electron Affinity

model (the default) to the full model by setting `IsSimplified=-1` in the Schenk bandgap narrowing section of the parameter file.

The full-model exchange correlation and ionic terms are described by:

$$ \Delta_{a}^{\text{xc}}(n, p, T) = -\frac{(4\pi)^{3}n_{\Sigma}^{2} \left[ \left( \frac{48n_{a}}{\pi g_{a}} \right)^{1/3} + c_{a} \ln(1 + d_{a}n_{p}^{p_{a}}) \right] + \left( \frac{8\pi\alpha_{a}}{g_{a}} \right) n_{a}\Upsilon^{2} + \sqrt{8\pi n_{\Sigma}}\Upsilon^{5/2}}{(4\pi)^{3}n_{\Sigma}^{2} + \Upsilon^{3} + b_{a}\sqrt{n_{\Sigma}}\Upsilon^{2} + 40n_{\Sigma}^{3/2}\Upsilon} $$ (168)

$$ \Delta_{a}^{\text{i}}(N_{\text{tot}}, n, p, T) = -\frac{N_{\text{tot}}[1 + U^{\text{i}}(n_{\Sigma}, \Upsilon)]}{\sqrt{\Upsilon n_{\Sigma}} / (2\pi) [1 + h_{a} \ln(1 + \sqrt{n_{\Sigma}}/\Upsilon) + j_{a}U^{\text{i}}(n_{\Sigma}, \Upsilon)n_{p}^{3/4}(1 + k_{a}n_{p}^{q_{a}})]} $$ (169)

and, for the simplified model by:

$$ \Delta_{a}^{\text{xc}}(n, p, T=0) = -\left[ \left( \frac{48n_{a}}{\pi g_{a}} \right)^{1/3} + c_{a} \ln(1 + d_{a}n_{p}^{p_{a}}) \right] $$ (170)

$$ \Delta_{a}^{\text{i}}(N_{\text{tot}}, n, p, T=0) = -N_{\text{tot}} \frac{0.799\alpha_{a}}{N_{p}^{3/4}} $$ (171)

where $a = \text{e, h}$ is the index for the carrier type, $\Upsilon = kT/Ry_{\text{ex}}$, $n_{\Sigma} = n + p$, $N_{p} = \alpha_{\text{e}}N_{\text{D}} + \alpha_{\text{h}}N_{\text{A}}$, and $U^{\text{i}}(n_{\Sigma}, \Upsilon) = n_{\Sigma}^{2}/\Upsilon^{3}$. The default values (silicon) and units for the parameters that can be changed in Sentaurus Device in this model are listed in Table 35 on page 268.

Sentaurus Device implements the Schenk bandgap narrowing model using the framework of the density gradient model (see Density Gradient Model on page 316). If you want to suppress the quantization corrections contained in this model, then set the density gradient model parameter $\gamma = 0$ (see Eq. 232, p. 317). Alternatively, you can specify the `LocalModelOnly` option in the `eQuantumPotential` and `hQuantumPotential` statements in the command file. The option `LocalModelOnly` automatically sets $\gamma = 0$ for all regions where both `LocalModel` and `LocalModelOnly` are invoked. For example:

```
Physics(Region = "Region1_Si") {
   ...
   eQuantumPotential(LocalModel=SchenkBGN_elec LocalModelOnly)
   hQuantumPotential(LocalModel=SchenkBGN_hole LocalModelOnly)
   ...
}
```

The Schenk model is switched on separately for electrons (conduction band correction) and holes (valence band correction). The complete bandgap narrowing correction is the sum of conduction and valence band corrections, and it can be obtained by switching on the Schenk model for both electrons and holes.

**12: Semiconductor Band Structure**
Band Gap and Electron Affinity

First, in the `Physics` section of silicon regions, `SchenkBGN_elec` must be specified as the `LocalModel` (that is, the model for $\Lambda_{PMI}$ in Eq. 232, p. 317) for `eQuantumPotential` (conduction bandgap correction), and `SchenkBGN_hole` must be specified as the `LocalModel` for `hQuantumPotential` (valence band correction).

In addition, because the Schenk model is a bandgap narrowing model itself, all other models must be switched off by specifying the keyword `NoBandGapNarrowing` as the argument for `EffectiveIntrinsicDensity`:

```
Physics(Region = "Region1_Si") {
      ...
      EffectiveIntrinsicDensity (NoBandGapNarrowing)
      eQuantumPotential(LocalModel=SchenkBGN_elec)
      hQuantumPotential(LocalModel=SchenkBGN_hole)
      ...
}
```

Apart from switching on quantum corrections in the `Physics` section, the equations for quantum corrections must be solved to compute the corrections. This is performed by specifying `eQuantumPotential` (for electrons) or `hQuantumPotential` (for holes) or both in the `Solve` section:

```
Solve {
      Coupled (LineSearchDamping=0.01){Poisson eQuantumPotential}
      Coupled {Poisson eQuantumPotential hQuantumPotential}
      quasistationary ( Goal {name="base" voltage=0.4}
                       Goal {name="collector" voltage=2.0}
                       Initialstep=0.1 Maxstep=0.1 Minstep=1e-6
                      )
        {coupled {poisson electron hole eQuantumPotential hQuantumPotential}}
}
```

Finally, to ignore the quantization corrections by the density gradient model, in the parameter file, $\gamma$ is set to zero. Then, the Schenk model parameter `IsSimplified` is set to 1 if the simplified model ($T = 0\text{ K}$) is used or -1 for the full model (temperature dependent):

```
Material = "Silicon" {
      ...
      *turn off everything in density gradient model except
      *apparent band-edge shift
      QuantumPotentialParameters {gamma = 0 , 0}
      ...
      SchenkBGN_elec {
        ...
        * Selects simplified model (1) or complete Schenk model (-1)
        IsSimplified = 1
      }
}
```

Band Gap and Electron Affinity

```
         SchenkBGN_hole {
            ...
            * Selects simplified model (1) or complete Schenk model (-1)
            IsSimplified = 1
         }
       }
```

The Schenk bandgap narrowing model is specifically for silicon. Sentaurus Device permits the model parameters to be changed in the parameter file (the `SchenkBGN_elec` and `SchenkBGN_hole` sections) as an option for also using this bandgap narrowing model for other materials. A full description of the parameters is given in the literature [[14]]([14]) and their default values are summarized in Table 35.

The Schenk bandgap narrowing can be visualized by specifying the data entry `eSchenkBGN` or `hSchenkBGN` or both in the `Plot` section of the command file.

Table 35 Default parameters for Schenk bandgap narrowing model

| Symbol | Parameter name | Default value (silicon) | Unit |
| --- | --- | --- | --- |
| SchenkBGN_elec |  |  |  |
| αe | alpha_e | 0.5187 | 1 |
| ge | g_e | 12 | 1 |
| Ryex | Ry_ex | 16.55 | meV |
| aex | a_ex | 3.719e-7 | cm |
| be | b_e | 8 | 1 |
| ce | c_e | 1.3346 | 1 |
| de | d_e | 0.893 | 1 |
| pe | p_e | 0.2333 | 1 |
| he | h_e | 3.91 | 1 |
| je | j_e | 2.8585 | 1 |
| ke | k_e | 0.012 | 1 |
| qe | q_e | 0.75 | 1 |
| SchenkBGN_hole |  |  |  |
| αh | alpha_h | 0.4813 | 1 |
| gh | g_h | 4 | 1 |
| Ryex | Ry_ex | 16.55 | meV |
| aex | a_ex | 3.719e-7 | cm |

**12: Semiconductor Band Structure**
Band Gap and Electron Affinity

Table 35 Default parameters for Schenk bandgap narrowing model (Continued)

| Symbol | Parameter name | Default value (silicon) | Unit |
| --- | --- | --- | --- |
| bh | b_h | 1 | 1 |
| ch | c_h | 1.2365 | 1 |
| dh | d_h | 1.1530 | 1 |
| ph | p_h | 0.2333 | 1 |
| hh | h_h | 4.20 | 1 |
| jh | j_h | 2.9307 | 1 |
| kh | k_h | 0.19 | 1 |
| qh | q_h | 0.25 | 1 |

## Bandgap Narrowing With Incomplete Ionization

The bandgap narrowing models introduced in Eq. 159, Eq. 160, Eq. 161, and Eq. 162, BennettWilson, delAlamo, JainRoulston, OldSlotboom, Slotboom, and TableBGN, use carrier concentrations $N_{tot}$ by default. Incomplete ionization affects bandgap narrowing. For details about the incomplete ionization model, see Chapter 13 on page 293.

Sentaurus Device implements the bandgap narrowing model with incomplete ionized doping concentration using the framework of the density gradient model (see Density Gradient Model on page 316). If you want to suppress the quantization corrections contained in this model, then set the density gradient model parameter $\gamma = 0$ (see Eq. 232, p. 317).

The bandgap narrowing model with incomplete ionization is a correction to the existing bandgap narrowing model. The carrier concentration $N_{tot}$ is replaced by the incomplete ionized doping concentration. Both the bandgap narrowing model and the incomplete ionization model should be activated within the `Physics` section.

The complete bandgap narrowing correction is the sum of conduction and valence band corrections, and it can be obtained by switching on the bandgap narrowing model for both electrons and holes. In the `Physics` section, you must specify `IncompleteBGN_elec` as the `LocalModel` for `eQuantumPotential` (conduction band correction) and `IncompleteBGN_hole` as the `LocalModel` for `hQuantumPotential` (valence band correction). For example:

```
Physics(Region = "Region1_Si") {
  ...
  EffectiveIntrinsicDensity (BandGapNarrowing(model_name))
  eQuantumPotential(LocalModel=IncompleteBGN_elec)
  hQuantumPotential(LocalModel=IncompleteBGN_hole)
  IncompleteIonization(options)
}
```

Band Gap and Electron Affinity

```
    ...
}
```

Since the bandgap narrowing model with incomplete ionization is a correction through the quantum equations, the equations of the quantum potential must be solved to compute the corrections. This correction is activated by specifying eQuantumPotential (for electrons) and hQuantumPotential (for holes) in the Solve section:

```
Solve {
  Coupled {Poisson eQuantumPotential hQuantumPotential}
  Quasistationary ( Goal {name="base" voltage=0.4}
                    Goal {name="collector" voltage=2.0}
                    Initialstep=0.1 Maxstep=0.1 Minstep=1e-6
                  )
  {coupled {poisson electron hole eQuantumPotential hQuantumPotential}}
}
```

## Bandgap Narrowing With Fermi Statistics

Parameters for bandgap narrowing are often extracted from experimental data assuming Maxwell–Boltzmann statistics. However, in the high-doping regime for which bandgap narrowing is important, Maxwell–Boltzmann statistics differs significantly from the more realistic Fermi statistics.

The bandgap narrowing parameters are, therefore, systematically affected by using the wrong statistics to interpret the experiment. For use in simulations that do not use Fermi statistics, this ‘error’ in the parameters is desirable, as it partially compensates the error by using the ‘wrong’ statistics in the simulation. However, for simulations using Fermi statistics, this compensation does not occur.

Therefore, Sentaurus Device can apply a correction to the bandgap narrowing to reduce the errors introduced by using Maxwell–Boltzmann statistics for the interpretation of experiments on bandgap narrowing (see Eq. 158, p. 261):

$$ \Delta E_g^{\text{Fermi}} = k300\text{K} \left[ \ln \left( \frac{N_V N_C}{N_{A,0} N_{D,0}} \right) + F_{1/2}^{-1} \left( \frac{N_{A,0}}{N_V} \right) + F_{1/2}^{-1} \left( \frac{N_{D,0}}{N_C} \right) \right] \text{ (172)} $$

where the right-hand side is evaluated at 300 K .

By default, correction Eq. 172 is switched on for simulations using Fermi statistics and switched off (that is, $\Delta E_g^{\text{Fermi}} = 0$ ) for simulations using Maxwell–Boltzmann statistics. To switch off the correction in simulations using Fermi statistics, specify `EffectiveIntrinsicDensity(NoFermi)` in the Physics section of the command file. This is recommended if you use parameters for bandgap narrowing that have been extracted assuming Fermi statistics. Sometimes for III–IV materials, the correction Eq. 172 is too large, and it is

**12: Semiconductor Band Structure**
Band Gap and Electron Affinity

recommended to switch it off in these cases. For Maxwell–Boltzmann statistics, either `EffectiveIntrinsicDensity(NoFermi)` or `EffectiveIntrinsicDensity()` means that the correction of Eq. 172 is set to zero.

Sometimes, the combined effect of mechanical stresses, Fermi correction, and bandgap narrowing results in a very small effective bandgap (~0 eV), particularly in high-doped source/drain regions of MOS devices. In some cases, the low effective bandgap can result in either convergence issues or other numeric issues. Sentaurus Device prints a warning message in the log file for one such vertex in the device if the effective bandgap is below 5% of the unperturbed bandgap (without a bandgap narrowing correction) of the semiconductor material. If you observe such a warning message, then it is recommended either to check the doping or stress at these vertices or to set the `EgMin` parameter (see Table 36) in the parameter file for the relevant semiconductor material.

# Bandgap Parameters

The band gap $E_{g,0}$ and values of $\delta E_{g,0}$ for each model are accessible in the `BandGap` section of the parameter file, in addition to the electron affinity $\chi_0$ and the temperature coefficients $\alpha$ and $\beta$. As an extension to what Eq. 153 and Eq. 156 suggest, the parameters $E_{g,0}$ and $\chi_0$ can be specified at any reference temperature $T_{par}$. By default, $T_{par} = 0\text{ K}$.

To prevent abnormally low (or negative) band gap, the calculated value of the band gap $E_g$ (which might include bandgap narrowing and stress effects) is limited if $E_g < E_{g,\min} + \delta E_{g,\min}$:

$$E_{g,\text{ limited}} = E_{g,\min} + \delta E_{g,\min} \exp[(E_g - E_{g,\min} - \delta E_{g,\min}) / \delta E_{g,\min}]$$ (173)

Table 36 Bandgap models: Parameters and their default values for silicon

| Symbol | Parameter name | Default | Unit | Band gap at 0 K $E_{g,0} + \delta E_{g,0} + \frac{\alpha T_{par}^2}{\beta + T_{par}}$ | Reference |
| --- | --- | --- | --- | --- | --- |
| $E_{g,0}$ | Eg0 | 1.1696 | eV | – | Eq. 154 |
| $\delta E_{g,0}$ | dEg0(Bennett) | 0.0 | eV | 1.1696 | Eq. 154 |
|  | dEg0(Slotboom) | $-4.795 \times 10^{-3}$ | eV | 1.1648 |  |
|  | dEg0(OldSlotboom) | $-1.595 \times 10^{-2}$ | eV | 1.1537 |  |
|  | dEg0(delAlamo) | $-1.407 \times 10^{-2}$ | eV | 1.1556 |  |
| $\alpha$ | alpha | $4.73 \times 10^{-4}$ | eV/K | – | Eq. 153, Eq. 156 |
| $\alpha_2$ | alpha2 | 0 | eV/K | – | Eq. 156 |

Effective Masses and Effective Density-of-States

Table 36 Bandgap models: Parameters and their default values for silicon (Continued)

| Symbol | Parameter name | Default | Unit | Band gap at 0 K | Reference |
| --- | --- | --- | --- | --- | --- |
| $E_{g,0} + \delta E_{g,0} + \frac{\alpha T_{par}^2}{\beta + T_{par}}$ |  |  |  |  |  |
| β | beta | 636 | K | – | Eq. 153, Eq. 156 |
| β2 | beta2 | 0 | K | – | Eq. 156 |
| χ0 | Chi0 | 4.05 | eV | – | Eq. 156 |
| Bgn2Chi | Bgn2Chi | 0.5 | 1 | – | Eq. 156 |
| $T_{par}$ | Tpar | 0 | K | – |  |
| $E_{g, \min}$ | EgMin | 0 | eV | – | Eq. 173 |
| $\delta E_{g, \min}$ | dEgMin | 0.01 | eV | – | Eq. 173 |

Table 37 summarizes the silicon default parameters for the analytic bandgap narrowing models available in Sentaurus Device.

Table 37 Bandgap narrowing models: Parameters and their default values for silicon

| Symbol | Parameter | Bennett | Slotboom | Old Slotboom | del Alamo | Unit |
| --- | --- | --- | --- | --- | --- | --- |
| $E_{ref}$ | Ebgn | $6.84 \times 10^{-3}$ | $6.92 \times 10^{-3}$ | $9.0 \times 10^{-3}$ | $18.7 \times 10^{-3}$ | eV |
| $N_{ref}$ | Nref | $3.162 \times 10^{18}$ | $1.3 \times 10^{17}$ | $1.0 \times 10^{17}$ | $7.0 \times 10^{17}$ | cm-3 |

# Effective Masses and Effective Density-of-States

Sentaurus Device provides two options for computing carrier effective masses and densities of states. The first method, selected by specifying `Formula=1` in the parameter file, computes an effective DOS as a function of carrier effective mass. The effective mass can be either independent of temperature or a function of the temperature-dependent band gap. The latter is the most appropriate model for carriers in silicon and is the default for simulations of silicon devices.

In the second method, selected by specifying `Formula=2` in the parameter file the effective carrier mass is computed as a function of a temperature-dependent DOS. The default for simulations of GaAs devices is `Formula=2`.

12: Semiconductor Band Structure

Effective Masses and Effective Density-of-States

# Electron Effective Mass and Density-of-States

**Formula=1**

The lattice temperature–dependence of the DOS effective mass of electrons is modeled by:

$$ m_n = 6^{2/3}(m_t^2 m_l)^{1/3} + m_m $$ (174)

where the temperature-dependent effective mass component $m_t(T)$ is best described in silicon by the temperature dependence of the energy gap [15]:

$$ \frac{m_t(T)}{m_0} = a \frac{E_g(0)}{E_g(T)} $$ (175)

The coefficient $a$ and the mass $m_l$ are defined in the parameter file with the default values provided in Table 38 on page 274. The parameter $m_m$, which defaults to zero, allows $m_n$ to be defined as a temperature-independent quantity if required.

The effective DOS in the conduction band $N_C$ follows from:

$$ N_C(m_n, T_n) = 2.5094 \times 10^{19} \left( \frac{m_n}{m_0} \right)^{\frac{3}{2}} \left( \frac{T_n}{300\text{ K}} \right)^{\frac{3}{2}} \text{cm}^{-3} $$ (176)

**Formula=2**

If `Formula=2` is specified in the parameter file, the value for the DOS is computed from $N_C(300\text{ K})$, which is read from the parameter file:

$$ N_C(T_n) = N_C(300\text{ K}) \left( \frac{T_n}{300\text{ K}} \right)^{\frac{3}{2}} $$ (177)

and the electron effective mass is simply a function of $N_C(300\text{ K})$:

$$ \frac{m_n}{m_0} = \left( \frac{N_C(300\text{ K})}{2.5094 \times 10^{19} \text{ cm}^{-3}} \right)^{\frac{2}{3}} $$ (178)

Effective Masses and Effective Density-of-States

## Electron Effective Mass and Conduction Band DOS Parameters

Table 38 lists the default coefficients for the electron effective mass and conduction band DOS models. The values can be modified in the `eDOSMass` parameter set.

**NOTE** The default setting for the `Formula` parameter depends on the materials, for example, it is equal to 1 for silicon and 2 for GaAs.

Table 38 Default coefficients for effective electron mass and DOS models

| Option | Symbol | Parameter name | Electrons | Unit |
| --- | --- | --- | --- | --- |
| Formula=1 | a | a | 0.1905 | 1 |
| ml | ml | 0.9163 | 1 |  |
| mm | mm | 0 | 1 |  |
| Formula=2 | NC(300 K) | Nc300 | 2.890×1019 | cm–3 |

## Hole Effective Mass and Density-of-States

### Formula=1

For the DOS effective mass of holes, the best fit in silicon is provided by the expression [16]:

$$ \frac{m_p(T)}{m_0} = \left( \frac{a + bT + cT^2 + dT^3 + eT^4}{1 + fT + gT^2 + hT^3 + iT^4} \right)^{\frac{2}{3}} + m_m $$ (179)

where the coefficients are listed in Table 39 on page 275. The parameter $m_m$, which defaults to zero, allows $m_p$ to be defined as a temperature-independent quantity. The effective DOS for holes $N_V$ follows from:

$$ N_V(m_p, T_p) = 2.5094 \times 10^{19} \left( \frac{m_p}{m_0} \right)^{\frac{3}{2}} \left( \frac{T_p}{300\text{ K}} \right)^{\frac{3}{2}} \text{cm}^{-3} $$ (180)

12: Semiconductor Band Structure

Effective Masses and Effective Density-of-States

# Formula=2

If `Formula=2` in the parameter file, the temperature-dependent DOS is computed from $N_V(300\text{ K})$ as given in the parameter file:

$$ N_V(T_p) = N_V(300\text{ K}) \left( \frac{T_p}{300\text{ K}} \right)^{\frac{3}{2}} \eqno(181) $$

and the effective hole mass is given by:

$$ \frac{m_p}{m_0} = \left( \frac{N_V(300\text{ K})}{2.5094 \times 10^{19}\text{ cm}^{-3}} \right)^{\frac{2}{3}} \eqno(182) $$

# Hole Effective Mass and Valence Band DOS Parameters

The model coefficients for the hole effective mass and valence band DOS can be modified in the parameter set `hDOSMass`. Table 39 lists the default parameter values.

**NOTE** The default setting for the `Formula` parameter depends on the materials, for example, it is equal to 1 for silicon and it is equal to 2 for GaAs.

Table 39 Default coefficients for hole effective mass and DOS models

| Option | Symbol | Parameter name | Holes | Unit |
| --- | --- | --- | --- | --- |
| Formula=1 | a | a | 0.4435870 | 1 |
| b | b | 0.3609528×10⁻² | K⁻¹ |  |
| c | c | 0.1173515×10⁻³ | K⁻² |  |
| d | d | 0.1263218×10⁻⁵ | K⁻³ |  |
| e | e | 0.3025581×10⁻⁸ | K⁻⁴ |  |
| f | f | 0.4683382×10⁻² | K⁻¹ |  |
| g | g | 0.2286895×10⁻³ | K⁻² |  |
| h | h | 0.7469271×10⁻⁶ | K⁻³ |  |
| i | i | 0.1727481×10⁻⁸ | K⁻⁴ |  |
| mₘ | mm | 0 | 1 |  |
| Formula=2 | N_V(300 K) | Nv300 | 3.140×10¹⁹ | cm⁻³ |

12: Semiconductor Band Structure
Gaussian Density-of-States for Organic Semiconductors

# Gaussian Density-of-States for Organic Semiconductors

Gaussian DOS has been introduced to better represent electron and hole effective DOS in disordered organic semiconductors. Within the Gaussian disorder model, electron and hole DOS are represented by:

$$ \Gamma(E) = \frac{N_t}{\sqrt{2\pi}\sigma_{\text{DOS}}} \exp \left( -\frac{(E - E_0)^2}{2\sigma_{\text{DOS}}^2} \right) $$ (183)

where $N_t$ is the total number of hopping sites with $N_t = N_{\text{LUMO}}$ for electrons (LUMO is the lowest unoccupied molecular orbital) and $N_t = N_{\text{HOMO}}$ for holes (HOMO is the highest occupied molecular orbital), $E_0$ and $\sigma_{\text{DOS}}$ are the energy center and the width of the DOS distribution, respectively.

Electron and hole densities in the most general case (Fermi–Dirac statistics) then are computed using Gaussian distribution from Eq. 183 as:

$$ \frac{n}{N_{\text{LUMO}}} = \frac{1}{\sqrt{2\pi}\sigma_n} \int_{-\infty}^{\infty} \exp \left( -\frac{(E - E_{0n})^2}{2\sigma_n^2} \right) \frac{1}{1 + e^{(E - E_{F,n})/(kT)}} dE = G_n(\zeta_n; \hat{s}_n) $$ (184)

$$ \frac{p}{N_{\text{HOMO}}} = \frac{1}{\sqrt{2\pi}\sigma_p} \int_{-\infty}^{\infty} \exp \left( -\frac{(E - E_{0p})^2}{2\sigma_p^2} \right) \frac{1}{1 + e^{(E_{F,p} - E)/(kT)}} dE = G_p(\zeta_p; \hat{s}_p) $$ (185)

where $\zeta_n = \frac{E_{F,n} - E_{0n}}{kT}$, $\zeta_p = \frac{E_{0p} - E_{F,p}}{kT}$, $\hat{s}_n = \frac{\sigma_n}{kT}$, $\hat{s}_p = \frac{\sigma_p}{kT}$.

Sentaurus Device computes Gauss–Fermi integrals $G_n(\zeta_n; \hat{s}_n)$ and $G_p(\zeta_p; \hat{s}_p)$ using an analytic approximation [[17]]([17]). The approximation covers both the nondegenerate and degenerate cases:

$$ G_c(\zeta_c; \hat{s}_c) = \begin{cases} \frac{\exp \left( \frac{\hat{s}_c^2}{2} + \zeta_c \right)}{1 + \exp(K(\hat{s}_c)(\zeta_c + \hat{s}_c^2))} & \zeta_c \le -\hat{s}_c^2 \text{ (nondegenerate region)} \\ \frac{1}{2} \text{erfc} \left( -\frac{\zeta_c}{\hat{s}_c\sqrt{2}} H(\hat{s}_c) \right) & \zeta_c > -\hat{s}_c^2 \text{ (degenerate region)} \end{cases} $$ (186)

where the index $c$ is $n$ or $p$, and the analytic functions $H$ and $K$ are given by:

$$ H(s) = \frac{\sqrt{2}}{s} \text{erfc}^{-1} \left( \exp \left( -\frac{s^2}{2} \right) \right) $$ (187)

**12: Semiconductor Band Structure**

Gaussian Density-of-States for Organic Semiconductors

$$ K(s) = 2 \left( 1 - \frac{H(s)}{s} \sqrt{\frac{2}{\pi}} \exp \left[ \frac{1}{2} s^2 (1 - H^2(s)) \right] \right) $$ (188)

The model is activated regionwise, materialwise, or globally by specifying the keyword `GaussianDOS_Full` in the respective Physics section together with the `Fermi` keyword in the global Physics section:

```
Physics(Region="Organic_sem1") {
  GaussianDOS_full
}

Physics {
  Fermi
}
```

The model parameters used in Eq. 184 and Eq. 185 are listed in Table 40. They can be specified in the `GaussianDOS_full` section of the parameter file.

Table 40 Gaussian DOS model parameters

| Parameter symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| Nt | NLUMO (electron) | Nt | 1×1021 | cm-3 |
| NHOMO (hole) | 1×1021 |  |  |  |
| σDOS | σn | sigmaDOS | 0.052 | eV |
| σp | 0.052 |  |  |  |
| E0 | E0n = E0 - EC (electron) | E0 | 0.1 | eV |
| E0p = EV - E0 (hole) | 0.1 |  |  |  |

In the case of nondegenerate semiconductors (Maxwell–Boltzmann approximation can be used for carrier densities), a simplified version based on a correction of standard densities-of-states $N_C$ and $N_V$ is available as well. The densities-of-states are corrected so that equivalent carrier densities are obtained when Gaussian densities-of-states described by Eq. 183, p. 276 are used instead of standard densities-of-states.

Gaussian Density-of-States for Organic Semiconductors

Introducing the notations:

$$
\begin{aligned}
A_e &= \frac{\sigma_n^2}{2k^2} \\
B_e &= \frac{E_{0n} - E_C}{k} \\
C_e &= \frac{E_{0n} - E_C}{\sqrt{2}\sigma_n} \\
A_h &= \frac{\sigma_p^2}{2k^2} \\
B_h &= \frac{E_V - E_{0p}}{k} \\
C_h &= \frac{E_V - E_{0p}}{\sqrt{2}\sigma_p}
\end{aligned}
\eqno(189)
$$

the electron and hole effective densities-of-states are computed in the Maxwell–Boltzmann approximation as:

$$ N_C(T) = \frac{N_{\text{LUMO}}}{2} \exp \left( \frac{A_e}{T^2} - \frac{B_e}{T} \right) \text{erfc} \left( \frac{\sqrt{A_e}}{T} - C_e \right) \eqno(190) $$

and:

$$ N_V(T) = \frac{N_{\text{HOMO}}}{2} \exp \left( \frac{A_h}{T^2} - \frac{B_h}{T} \right) \text{erfc} \left( \frac{\sqrt{A_h}}{T} - C_h \right) \eqno(191) $$

The simplified model can be activated regionwise or globally by specifying the keyword `GaussianDOS` for `EffectiveMass` in the `Physics` section of the command file:

```
Physics(Region="Organic_sem1") {
  EffectiveMass(GaussianDOS)
}
```

The model parameters used in Eq. 183, p. 276 and Eq. 189 and their default values are summarized in Table 41.

Table 41 Simplified Gaussian DOS model parameters

| Parameter symbol | Parameter name | Default value | Unit |  |
| --- | --- | --- | --- | --- |
| N_t N_{LUMO} (electron) | N_LUMO | 1×10^21 | cm^-3 |  |
| N_{HOMO} (hole) | N_HOMO | 1×10^21 |  |  |

12: Semiconductor Band Structure
Band Tails

Table 41 Simplified Gaussian DOS model parameters (Continued)

| Parameter symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| σDOS σn | sigmaDOS_e | 0.052 | eV |
| σp | sigmaDOS_h | 0.052 |  |
| E0cn = E0 - EC | E0_c | 0.1 | eV |
| E0v = EV - E0 | E0_v | 0.1 |  |

# Band Tails

According to [18], the semiconductor density-of-states in the presence of random dopant fluctuations and crystal defects should have band tails in the band gap. Here, presented in the semiconductor DOS, it is assumed that band tails bring additional mobile carriers into the conduction and valence bands. The DOS band tails might affect subthreshold transport properties of MOSFET applications strongly at cryogenic temperatures.

Gaussian and exponential band tail DOS are accounted for as an extension of both the conduction and valence bands in the following form:

$$
\begin{aligned}
D_g(\varepsilon) &= \frac{N_t}{\sigma\sqrt{2\pi}} \exp \left[ -0.5 \left( \frac{\varepsilon - \varepsilon_0}{\sigma} \right)^2 \right] \\
D_e(\varepsilon) &= \frac{N_t}{2\sigma} \exp \left[ -\left| \frac{\varepsilon - \varepsilon_0}{\sigma} \right| \right]
\end{aligned}
\eqno(192)
$$

where $N_t$ is a maximum of the band tail concentration, $\varepsilon_0$ is an energy position of the maximum in a reference to the conduction band or the valence band with positive $\varepsilon_0$ shifting the maximum into the band gap, and $\sigma$ is a characteristic energy width of the band tail distribution.

Based on the band tail DOS of Eq. 192, the total electron concentration versus the quasi-Fermi energy $E_{F,n}$ and temperature $T$ is computed as the following (similar applies to holes):

$$
n(E_{F,n}, T) = n_B(E_{F,n}, T) + \int_{-\infty}^{\infty} \frac{D_{g,e}(\varepsilon)}{1 + \exp \left( \frac{\varepsilon + E_C - E_{F,n}}{kT} \right)} d\varepsilon
\eqno(193)
$$

where $n_B(E_{F,n}, T)$ is the electron concentration computed using the DOS and band structure without the band tails.

Band Tails

To activate the band tail DOS model, you can use the `BandTailDOS`, `eBandTailDOS`, or `hBandTailDOS` statement in the `Physics` section. These statements should be set with one of the following options, as for example, for electron band tails:

```
eBandTailDOS(Exponent)
eBandTailDOS(Gaussian)
```

The band tail DOS parameters of Eq. 192 ($N_t$, $\sigma$, and $\varepsilon_0$) should be set for electron and hole band tails in the following section of the parameter file:

```
BandTailDOS{
  Nt       = 1e19,   1e19   # [cm-3]
  sigmaDOS = 0.0075, 0.0075 # [eV]
  E0       = 0.0,    0.0    # [eV]
}
```

By default, Sentaurus Device uses the Fermi–Dirac distribution function in the band tail part of Eq. 193 independently of the carrier statistics defined in the `Physics` section. In addition, for better convergence at cryogenic temperatures, Sentaurus Device uses an abrupt distribution function, which simplifies integration in Eq. 193.

**NOTE** To have a true distribution function with numeric integration of band tail carriers (with a Gauss–Laguerre quadrature approximation) in Eq. 193, use `-SimpleBandTailIntegration` in the `Math` section of the command file.

To have the distribution function in Eq. 193 set by the carrier statistics defined in the `Physics` section, use `-FermiBandTailStatistics` in the `Math` section of the command file.

To compute the carrier concentration in Eq. 193 with the Gaussian band tails, you can apply a specific and accurate approximation developed for the DOS of organic materials (see Gaussian Density-of-States for Organic Semiconductors on page 276). It can be activated with the `GaussianFromOrganic` option in the band tail statements.

With an experimental option, you can consider that not all carriers are thermalized to ambient or lattice temperature, for example, due to a forward bias heating. For this option, two carrier populations are accounted for in the carrier concentration computation, where a nonthermalized population will have a user-defined temperature equal to $T = q\sigma/k$, where $\sigma$ is the band tail parameter, and $k$ is the Boltzmann constant. In this case, the DOS and band structure without band tails are used for both populations, but for the nonthermalized population, $N_t$ will work as the effective DOS, and $\varepsilon_0$ will work as an additional band-edge shift. To activate this option, specify `TwoPopulation` in the band tail statements.

12: Semiconductor Band Structure
Multivalley Band Structure

# Multivalley Band Structure

Eq. 43 and Eq. 44, p. 183 give a dependency of electron and hole concentrations on the quasi–Fermi level for a single-valley representation of the semiconductor band structure. Stress-induced change of the silicon band structure and the nature of low bandgap materials require you to consider several valleys in the conduction and valence bands to compute the correct dependency of the carrier concentration on the quasi–Fermi level.

With the parabolic band assumption and Fermi–Dirac distribution function applied to each valley, the multivalley electron and hole concentrations are represented as follows:

$$ n = N_C F_{MV, n} \left( \frac{E_{F,n} - E_C}{kT} \right) = N_C \sum_{i = 1}^{N_n} g_n^i F_{1/2} \left( \frac{E_{F,n} - E_C - \Delta E_n^i}{kT} \right) $$ (194)

$$ p = N_V F_{MV, p} \left( \frac{E_V - E_{F,p}}{kT} \right) = N_V \sum_{i = 1}^{N_p} g_p^i F_{1/2} \left( \frac{\Delta E_p^i + E_V - E_{F,p}}{kT} \right) $$ (195)

where $N_n$ and $N_p$ are the electron and hole numbers of valleys, $g_n^i$ and $g_p^i$ are the electron and hole DOS valley factors (see Eq. 205 and Eq. 206), and $\Delta E_n^i$ and $\Delta E_p^i$ are the electron and hole valley energy shifts relative to the band edges $E_C$ and $E_V$, respectively. All other variables in these equations are the same as in Eq. 43 and Eq. 44, p. 183. Without Fermi statistics, the Fermi–Dirac integrals $F_{1/2}$ in these equations are replaced by exponents that correspond to the Boltzmann statistics for each valley.

Similarly to the Fermi statistics, the inverse functions of $F_{MV, n}$ and $F_{MV, p}$ are used to define the variables $\gamma_n$ and $\gamma_p$ that bring an additional drift term with $\nabla(\ln \gamma)$ as it is expressed in Eq. 47 and Eq. 48, p. 183:

$$ \gamma_n = \frac{n}{N_C} \exp \left( -F_{MV, n}^{-1} \left( \frac{n}{N_C} \right) \right) $$ (196)

$$ \gamma_p = \frac{p}{N_V} \exp \left( -F_{MV, p}^{-1} \left( \frac{p}{N_V} \right) \right) $$ (197)

To compute the inverse functions $F_{MV, n}^{-1} \left( \frac{n}{N_C} \right)$ and $F_{MV, p}^{-1} \left( \frac{p}{N_V} \right)$, an internal Newton solver is used.

Together with the fast Joyce–Dixon approximation of the Fermi–Dirac integral $F_{1/2}$, the multivalley model of Sentaurus Device provides an option for a numeric integration over the energy to compute the carrier density using Gauss–Laguerre quadratures. This extends applicability of the model to account for band nonparabolicity (see Nonparabolic Band

Multivalley Band Structure

Structure) and the MOSFET channel quantization effect using the multivalley MLDA model (see Modified Local-Density Approximation Model on page 324). To control the accuracy and CPU time of such a numeric integration, it is possible to set a user-defined number of integration points in the Gauss–Laguerre quadratures.

## Nonparabolic Band Structure

The Fermi–Dirac integral $F_{1/2}$ assumes a typical parabolic band approximation where an energy dependency of the DOS is approximated with $\sqrt{\varepsilon}$. Usually, such a simple approximation is valid only in the vicinity of the band minima. Generally, the isotropic nonparabolicity parameter $\alpha$ is introduced into the dispersion relation as follows: $\varepsilon(1 + \alpha\varepsilon) = (\hbar k)^2 / (2m)$, where **k** is the wavevector, and $m$ is the effective mass.

With such a dispersion, the multivalley carrier density is computed similarly to Eq. 194 and Eq. 195, but $F_{1/2}$ is replaced by the following integral:

$$ F_{1/2}^{\alpha}(\eta, T) = \int_{0}^{\infty} \frac{(1 + 2kT\alpha\varepsilon)\sqrt{\varepsilon(1 + kT\alpha\varepsilon)}}{1 + e^{\varepsilon - \eta}} d\varepsilon $$ (198)

where $\eta$ is the carrier quasi-Fermi energy defined by Eq. 49 and Eq. 50, p. 183.

Compared to $F_{1/2}$, the above integral explicitly depends on the carrier temperature $T$, which is accounted for in hydrodynamic and thermodynamic problems.

The more general case of nonparabolic bands can be accounted for with the six-band $\mathbf{k} \cdot \mathbf{p}$ band-structure model for holes (see Strained Hole Effective Mass and DOS on page 897). The model considers three hole bands (the heavy-hole, light-hole, and split-off bands) and the DOS of band $n$ is given generally by:

$$ D_n(\varepsilon) = \frac{2}{(2\pi)^3} \oint_{\varepsilon_n(\mathbf{\kappa}) = \varepsilon} \frac{dS}{|\nabla_{\mathbf{\kappa}}\varepsilon_n(\mathbf{\kappa})|} $$ (199)

Therefore, accounting for Fermi–Dirac carrier distribution over the energy, the total hole concentration in the valence band can be expressed as:

$$ p(E_{F,p}, T) = \sum_{i} \int_{0}^{\infty} \frac{D_i(\varepsilon)}{1 + \exp\left(\frac{\varepsilon - \Delta E_p^i - E_V + E_{F,p}}{kT}\right)} d\varepsilon $$ (200)

where variable notations correspond to ones in Eq. 195 and integrals over the energy in Eq. 200 are computed numerically using Gauss–Laguerre quadrature.

**12: Semiconductor Band Structure**
Multivalley Band Structure

Similar to the parabolic case, without Fermi statistics, the Fermi–Dirac distribution function in Eq. 198 and Eq. 200 is replaced by the Boltzmann one.

## Bandgap Widening

The bandgap widening effect is related to the carrier geometric confinement, which is important to account for in ultrathin layer semiconductor structures. Typically, the electrons in the $\Gamma$-valley of III–V materials have a very small effective mass, which leads to increased geometric confinement in such materials. This effect in the model is accounted for by the simple assumption that the carrier DOS in Eq. 198 and Eq. 199, and in the Fermi–Dirac integrals of Eq. 194 and Eq. 195, is zero up to the first subband energy $\varepsilon_1$ computed analytically for the infinite barrier rectangular quantum well with the layer thickness size $L_z$. Mostly, this option is designed to work together with the MLDA quantization model (see Modified Local-Density Approximation Model on page 324).

Moreover, the multivalley band structure with this bandgap widening model could be used with other quantization models, such as the Density Gradient Model on page 316.

The first subband energy for nonparabolic bands is computed for each valley $i$ as follows:

$$ \varepsilon_1^i = \frac{-1 + \sqrt{1 + \frac{2\alpha^i}{m_q^i} \left( \frac{\hbar\pi}{L_z} \right)^2}}{2\alpha^i} $$ (201)

where $\alpha^i$ is the band nonparabolicity, $L_z$ is the layer thickness, and $m_q^i$ is the quantization mass computed automatically along the confinement direction or specified in the valley definition. To account for $\varepsilon_1^i$ in the density integrals Eq. 198 and Eq. 199, the DOS energy is replaced by $\varepsilon + \varepsilon_1^i$. Various options to compute the layer thickness automatically or to define it explicitly are described in Geometric Parameters on page 386 and Using the MLDA Model on page 328.

## Monte Carlo Density-of-States

To have consistency between the continuity transport models (see Carrier Transport Equations in Semiconductors on page 189) and the Monte Carlo method (refer to the *Sentaurus™ Device Monte Carlo User Guide*), there is an option to use Monte Carlo DOS in the multivalley model. The Monte Carlo DOS is computed for the full semiconductor band structure used in Monte Carlo simulations.

Multivalley Band Structure

If the DOS $D_i(\varepsilon)$ is computed for various bands in the conduction band, the electron density can be expressed as:

$$ n(E_{F,n}, T) = \sum_i \int_0^\infty \frac{D_i(\varepsilon)}{1 + \exp \left( \frac{\varepsilon + \Delta E_n^i + E_C - E_{F,n}}{kT} \right)} d\varepsilon $$ (202)

where $E_{F,n}$ is the electron quasi-Fermi energy, and $\Delta E_n^i$ is the difference between the energy of band $i$ and the conduction band edge. A similar expression works for the hole density (see Eq. 200).

# Non-Three-Dimensional Density-of-States

As known generally for the parabolic bands, 3D DOS $D_i(\varepsilon)$ in Eq. 200 and Eq. 202, for example, has $\varepsilon^{1/2}$ for the energy dependence. However, for thin 2D structures and thin 1D nanowires, a strong geometric confinement modifies the energy dependence in DOS to $\varepsilon^0$ and $\varepsilon^{-1/2}$, respectively. Another case is 2D materials. For graphene-like materials with atomic layers, the energy dependence changes to $\varepsilon^1$.

In a general form accounting for nonparabolicity, such a DOS of valley or band $i$ can be written in the following simple form:

$$ D_i(\varepsilon, \alpha, k) = N_k(1 + 2\alpha\varepsilon)\varepsilon^k(1 + \alpha\varepsilon)^k $$ (203)

where:

* $D_i(\varepsilon, \alpha, k)$, with $k = 1/2, 0, -1/2$, and $1$, represents 3D, 2D, 1D, and 2D material DOS, respectively.

* $N_k$ is a valley or band constant factor, which can be written as follows for all of these DOS cases:

$$ \begin{aligned} N_{1/2} &= \frac{\sqrt{2}m_i^{3/2}}{\pi^2 \hbar^3} \\ N_0 &= \frac{m_i}{\pi \hbar^2 L} \\ N_{-1/2} &= \frac{\sqrt{2m_i}}{\pi \hbar L^2} \\ N_1 &= \frac{2}{\pi \hbar^2 c^2 L} \end{aligned} $$ (204)

12: Semiconductor Band Structure
Multivalley Band Structure

where $m_i$ is the effective DOS mass of valley or band $i$, $L$ is a layer thickness used in device simulation, and $c$ is the speed of light.

**NOTE** In Eq. 204 $N_{1/2}$ represents constants in 3D effective DOS, and it is provided solely as a reference.

# Using Multivalley Band Structure

Multivalley statistics is activated with the keyword `MultiValley` in the `Physics` section. If the model must be activated only for electrons or holes, the keywords `eMultiValley` and `hMultiValley` can be used, respectively. The model can be defined regionwise as well.

For testing and comparison purposes, the numeric Gauss–Laguerre integration (mentioned in Nonparabolic Band Structure on page 282) can be activated for the Fermi–Dirac integral $F_{1/2}$.

To set such an integration, the keyword `DensityIntegral` must be used as in the following statement:

```
Physics { (e|h)Multivalley(DensityIntegral) }
```

Similarly, to activate the carrier density computation that accounts for nonparabolicity as in Eq. 198, the following statement must be used:

```
Physics { (e|h)Multivalley(Nonparabolicity) }
```

To activate the six-band k·p band-structure model for holes described in Strained Hole Effective Mass and DOS on page 897 and Nonparabolic Band Structure on page 282, you can specify the following:

```
Physics { hMultivalley(kpDOS) }
```

This statement creates three hole bands (light, heavy, and spin-orbit) in the multivalley model. The parameters affecting the six-band k·p band-structure model (see Eq. 1000, p. 898 for the DOS mass and Eq. 199, p. 282) include the deformation potentials of the model for hole bands (`adp`, `bdp`, `ddp`, and `dso`) and the Luttinger parameters (`gamma_1`, `gamma_2`, and `gamma_3`). All parameters can be specified in the `LatticeParameters` section of the parameter file and can be mole fraction dependent. These parameters define relaxed hole bands and the stress-induced change (see Deformation of Band Structure on page 890).

To control the accuracy of surface integration in Eq. 199, p. 282, you can use the following grid setting in $k$-space, `Math{ kGridSizeFor6kp(Nphi,Ntheta) }`, where `Nphi` and `Ntheta` define the number of points for an angular spherical coordinate system. Due to symmetry and possibly the stress effect in DOS, half of the $k$-space is used, where both angles are changed from 0° to 180°. The default setting is `kGridSizeFor6kp(10,16)`.

Multivalley Band Structure

To activate the two-band k·p band-structure model for electrons described in Strained Electron Effective Mass and DOS on page 895 (where three Δ₂ valleys will be created), specify:

```
Physics { eMultivalley(kpDOS) }
```

The parameters affecting the two-band k·p band-structure model for Δ₂ valleys (see Eq. 987–Eq. 990) include the deformation potentials of the k·p model for electron bands (xis, dbs, xiu, and xid), the Sverdlov k·p parameter (Mkp), and the relaxed nonparabolicity α₀ (this is accounted for only with the `Nonparabolicity` keyword in the `eMultivalley` statement). These parameters can be specified in the `LatticeParameters` section of the parameter file. In addition, the Δ₂ valley effective masses (me_l0 and me_t0) can be defined in the `StressMobility` section. All parameters can be mole fraction dependent. These parameters define three relaxed Δ₂ valleys and the stress-induced change (see Deformation of Band Structure on page 890).

To control the number of Gauss–Laguerre integration points (the default is 30, which gives a good compromise between accuracy of the numeric integration and CPU time), the global `Math` statement must be used:

```
Math { DensityIntegral(30) }
```

For non-k·p bands, all multivalley model parameters are defined in the `MultiValley` section of the parameter file.

You can define an arbitrary number of valleys; however, by default, for example for silicon, Sentaurus Device defines three Δ₂ electron valleys and two hole valleys as follows:

```
MultiValley{
  eValley"Delta1"(1,0,0)(ml=0.914, mt=0.196, energy=0, degeneracy=2,
                         alpha=0.5, xiu=9.16, xid=0.77)
  eValley"Delta2"(0,1,0)(ml=0.914, mt=0.196, energy=0, degeneracy=2,
                         alpha=0.5, xiu=9.16, xid=0.77)
  eValley"Delta3"(0,0,1)(ml=0.914, mt=0.196, energy=0, degeneracy=2,
                         alpha=0.5, xiu=9.16, xid=0.77)
  hValley"LH"(m=0.16, energy=0, degeneracy=1)
  hValley"HH"(m=0.49, energy=0, degeneracy=1)
}
```

The above definition of "Delta" valleys represents a most general way to define valleys in the multivalley band structure. For example, the valley "Delta1" defines an ellipsoidal valley with the effective masses m<sub>l</sub> = 0.914 and m<sub>t</sub> = 0.196, its main axis oriented in the <100> direction, the nonparabolicity α = 0.5 eV<sup>-1</sup>, the degeneracy equal to 2, zero energy shift ΔE<sub>n</sub> from the conduction band edge, and the deformation potentials Ξ<sub>u</sub>, Ξ<sub>d</sub>, which are used to have a stress effect in the valley energy using the linear deformation potential model (see Eq. 980 in Deformation of Band Structure on page 890).

Multivalley Band Structure

The general valley definition allows also another parameter $m_q$ that could redefine the quantization mass computed automatically by the multivalley MLDA model (see Modified Local-Density Approximation Model on page 324). The hole valleys above are assumed to be simple spherical ones with no stress dependency. This is a huge simplification compared to the six-band k·p model.

**NOTE** With both the `Multivalley(parfile)` and `Multivalley` options, only valleys defined in the `Multivalley` section of the parameter file (or default material-specific ones) will be used. With the `Multivalley` section in the parameter file, all default valleys will be ignored and only valleys defined in the parameter file will be used.

With the `Multivalley(kpDOS)` option in the `Physics` section, all multivalley model parameters ($N_n$, $N_p$, $g_n^i$, $g_p^i$, $\Delta E_n^i$, and $\Delta E_p^i$) are defined and described by stress models in Multivalley Band Structure on page 899. This case ignores all valleys defined in the parameter file. To use the k·p bands together with valleys in the parameter file, specify:

```
Multivalley(kpDOS parfile)
```

The option `eMultivalley(kpDOS parfile)` can be used, for example, for SiGe applications where the two-band k·p model brings three $\Delta_2$ valleys, but four L-valleys are taken from the parameter file. Generally, it is a useful option to combine k·p and analytic valleys, but you must be careful not to double-count the $\Delta_2$ valleys because, by default, the parameter file for SiGe has analytic $\Delta_2$ valleys as well. So, these valleys must be removed from the `Multivalley` section of the parameter file. However, if no `Multivalley` section is defined in the parameter file, the default valleys are still used and there might be double-counting.

To account for the bandgap widening effect as in Eq. 201, the `ThinLayer` keyword must be in the `MultiValley` statement, and the `LayerThickness` statement must be set. All `LayerThickness` options are described in Extracting Layer Thickness on page 333 where generally the layer thickness can be extracted automatically for defined regions. In addition, some specific options can be found in Using the MLDA Model on page 328 for non-1D confinement, but practically, if the geometric confinement is mostly 1D, such a setting could be as simple as:

```
LayerThickness( Thickness = Lz )
Multivalley( ThinLayer )
```

To activate the use of the Monte Carlo DOS in the multivalley model, specify one of the following options:

```
Physics { (e|h)Multivalley(mcDOS("mcdos_file_name")) }
```

Multivalley Band Structure

or:

```
Physics { (e|h)Multivalley(mcDOS) }
File { mcDOS="mcdos_file_name" }
```

To save the Monte Carlo DOS file, use `CreateDOSFile=1` or `CreateDOSFile=2` in the `MonteCarlo` statement of the command file (refer to the *Sentaurus™ Device Monte Carlo User Guide*). The DOS saved in the file can be solely the DOS of the full conduction and valence bands (`CreateDOSFile=1`) or the DOS of separate bands (`CreateDOSFile=2`). For the DOS of separate bands, the multivalley model will search for bands with the same energy minima and will combine such bands into one in the multivalley model (to speed up related numeric density integrations). The saved Monte Carlo DOS file will be named `<MonteCarloOut>.dostot.dat`, where `MonteCarloOut` is an output field of the Monte Carlo simulations in the `File` section of the input file.

> **NOTE** The `mcDOS` option in the `Multivalley` statement cannot be used with any other option. Therefore, the Monte Carlo DOS (bands) cannot be combined with analytic and k · p bands, and with the multivalley `MLDA` and `ThinLayer` quantization models.

For any analytic valley, you can use the non-3D DOS option described by Eq. 203 and Eq. 204. To activate this option, you must set `dospower=k` in the `(e|h)Valley` statement in the parameter file:

* `dospower=0.5` is the default and corresponds to 3D DOS.

* `dospower=0` specifies 2D DOS.

* `dospower=-0.5` specifies 1D DOS.

* `dospower=1` specifies 2D material DOS with automatic recomputation of the constant factor $N_k$ in the effective DOS.

The required layer thickness $L$ for all of these options must be set by the `LayerThickness` command (see Extracting Layer Thickness on page 333).

For 2D material DOS in Eq. 204, the speed of light $c$ is used, but in reality, for a specific 2D material, it must be replaced by the Fermi velocity $v_F$, which is a material-specific property. To account for that, you must use a factor $(c/v_F)^2$ in the parameter `degeneracy` in the `(e|h)Valley` statement. This factor is equal to approximately $10^5$ for graphene.

> **NOTE** Generally, you can set the parameter `dospower` to any arbitrary number. However, if the value is not equal to specific values in Eq. 204, 3D effective DOS will be used.

**12: Semiconductor Band Structure**
Multivalley Band Structure

There are two options for the model parameters $g_n^i$ and $g_p^i$. By default, these parameters are defined by the effective masses from the `(e|h)Valley` statement, and such a definition removes the dependency on $N_C$ and $N_V$ (defined by Effective Masses and Effective Density-of-States on page 272) in Eq. 194 and Eq. 195:

$$ g_{n,p}^i = \frac{2.5094 \times 10^{19}}{N_{C,V}} d^i \sqrt{\frac{m_l^i m_t^i m_t^i}{m_0 m_0 m_0}} \left( \frac{T_{n,p}}{300 \text{ K}} \right)^{\frac{3}{2}} \tag{205} $$

Another option is to use `Multivalley(RelativeToDOSMass)`. In this case, the parameters $g_n^i$ and $g_p^i$ define the carrier density relative to the effective DOS $N_C$ and $N_V$:

$$ g_{n,p}^i = \frac{d^i \sqrt{m_l^i m_t^i m_t^i}}{\sum_{k=1}^N d^k \sqrt{m_l^k m_t^k m_t^k} \exp \left( \mp \frac{\Delta E_{n,p}^k}{kT} \right)} \tag{206} $$

where $\Delta E_n^k$ and $\Delta E_p^k$ are the valley energy shifts in reference to the band edge (positive for the conduction band and negative for the valence band).

If all valley energy shifts equal zero, Eq. 206 provides the single-valley condition where, as usual, only the effective DOS and band edge define the semiconductor band structure and carrier concentration.

The valley definition allows you to have mole fraction–dependent valley parameters. The following example shows the definition for two valleys ($\Delta_2$ and L) and with two mole fraction intervals in SiGe material:

```
MultiValley{
  Xmax(0) = 0.0
  Xmax(1) = 0.85
  Xmax(2) = 1.0

  eValley"Delta1"(1,0,0)(ml=0.914 mt=0.196 energy=0 alpha=0.5 degeneracy=2
                         xiu=9.16 xid=0.77)
  eValley"L1"(1,1,1)(ml=1.69 mt=0.13 energy=1.1 alpha=0.5 degeneracy=1
                     xiu=11.5 xid=-6.58)
  eValley"Delta1"(1)(ml=0.914 mt=0.196 energy=0 alpha=0.5 degeneracy=2
                     xiu=9.16 xid=0.77)
  eValley"L1"(1)(ml=1.768 mt=0.0967 energy=0 alpha=0.5 degeneracy=1
                 xiu=11.5 xid=-6.58)
  eValley"Delta1"(2)(ml=0.915 mt=0.201 energy=0.19 alpha=0.5 degeneracy=2
                     xiu=9.42 xid=-0.54)
  eValley"L1"(2)(ml=1.768 mt=0.0967 energy=0 alpha=0.5 degeneracy=1
                 xiu=11.5 xid=-6.58)
}
```

References

# References

[1] W. Bludau, A. Onton, and W. Heinke, “Temperature dependence of the band gap in silicon,” *Journal of Applied Physics*, vol. 45, no. 4, pp. 1846–1848, 1974.

[2] H. S. Bennett and C. L. Wilson, “Statistical comparisons of data on band-gap narrowing in heavily doped silicon: Electrical and optical measurements,” *Journal of Applied Physics*, vol. 55, no. 10, pp. 3582–3587, 1984.

[3] J. W. Slotboom and H. C. de Graaff, “Measurements of Bandgap Narrowing in Si Bipolar Transistors,” *Solid-State Electronics*, vol. 19, no. 10, pp. 857–862, 1976.

[4] J. W. Slotboom and H. C. de Graaff, “Bandgap Narrowing in Silicon Bipolar Transistors,” *IEEE Transactions on Electron Devices*, vol. ED-24, no. 8, pp. 1123–1125, 1977.

[5] J. W. Slotboom, “The pn-Product in Silicon,” *Solid-State Electronics*, vol. 20, no. 4, pp. 279–283, 1977.

[6] D. B. M. Klaassen, J. W. Slotboom, and H. C. de Graaff, “Unified Apparent Bandgap Narrowing in n- and p-Type Silicon,” *Solid-State Electronics*, vol. 35, no. 2, pp. 125–129, 1992.

[7] J. del Alamo, S. Swirhun, and R. M. Swanson, “Simultaneous Measurement of Hole Lifetime, Hole Mobility and Bandgap Narrowing in Heavily Doped n-Type Silicon,” in *IEDM Technical Digest*, Washington, DC, USA, pp. 290–293, December 1985.

[8] J. del Alamo, S. Swirhun, and R. M. Swanson, “Measuring and Modeling Minority Carrier Transport in Heavily Doped Silicon,” *Solid-State Electronics*, vol. 28, no. 1–2, pp. 47–54, 1985.

[9] S. E. Swirhun, Y.-H. Kwark, and R. M. Swanson, “Measurement of Electron Lifetime, Electron Mobility and Band-Gap Narrowing in Heavily Doped p-Type Silicon,” in *IEDM Technical Digest*, Los Angeles, CA, USA, pp. 24–27, December 1986.

[10] S. E. Swirhun, J. A. del Alamo, and R. M. Swanson, “Measurement of Hole Mobility in Heavily Doped n-Type Silicon,” *IEEE Electron Device Letters*, vol. EDL-7, no. 3, pp. 168–171, 1986.

[11] J. A. del Alamo and R. M. Swanson, “Measurement of Steady-State Minority-Carrier Transport Parameters in Heavily Doped n-Type Silicon,” *IEEE Transactions on Electron Devices*, vol. ED-34, no. 7, pp. 1580–1589, 1987.

[12] S. C. Jain and D. J. Roulston, “A Simple Expression for Band Gap Narrowing (BGN) in Heavily Doped Si, Ge, GaAs and Ge<sub>x</sub>Si<sub>1-x</sub> Strained Layers,” *Solid-State Electronics*, vol. 34, no. 5, pp. 453–465, 1991.

[13] U. Lindefelt, “Doping-induced band edge displacements and band gap narrowing in 3C–, 4H–, 6H–SiC, and Si,” *Journal of Applied Physics*, vol. 84, no. 5, pp. 2628–2637, 1998.

12: Semiconductor Band Structure

References

[14] A. Schenk, “Finite-temperature full random-phase approximation model of band gap narrowing for silicon device simulation,” *Journal of Applied Physics*, vol. 84, no. 7, pp. 3684–3695, 1998.

[15] M. A. Green, “Intrinsic concentration, effective densities of states, and effective mass in silicon,” *Journal of Applied Physics*, vol. 67, no. 6, pp. 2944–2954, 1990.

[16] J. E. Lang, F. L. Madarasz, and P. M. Hemenger, “Temperature dependent density of states effective mass in nonparabolic p-type silicon,” *Journal of Applied Physics*, vol. 54, no. 6, p. 3612, 1983.

[17] G. Paasch and S. Scheinert, “Charge carrier density of organics with Gaussian density of states: Analytical approximation for the Gauss–Fermi integral,” *Journal of Applied Physics*, vol. 107, no. 10, p. 104501, 2010.

[18] E. O. Kane, “Thomas-Fermi Approach to Impure Semiconductor Band Structure,” *Physical Review*, vol. 131, no. 1, pp. 79–88, 1963.

## References

 