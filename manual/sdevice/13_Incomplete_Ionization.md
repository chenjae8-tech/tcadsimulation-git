# CHAPTER 13 Incomplete Ionization

*This chapter discusses how to account for incomplete ionization in Sentaurus Device.*

## Considering Incomplete Ionization

In silicon, with the exception of indium, dopants can be considered to be fully ionized at room temperature because the impurity levels are sufficiently shallow. However, when impurity levels are relatively deep compared to the thermal energy $kT$, incomplete ionization must be considered. This is the case for indium acceptors in silicon and nitrogen donors and aluminum acceptors in silicon carbide. In addition, for simulations at reduced temperatures, incomplete ionization must be considered for all dopants. For these situations, Sentaurus Device has an ionization probability model based on activation energy. The ionization (activation) is computed separately for each species present.

All doping species for Sentaurus Device are defined in the `datexcodes.txt` file. To add new doping species or to modify an existing specification, see Specifying Doping Species on page 12.

## Using the Incomplete Ionization Model

The incomplete ionization model is activated with the keyword `IncompleteIonization` in the `Physics` section:

```
Physics{ IncompleteIonization }
```

The incomplete ionization model for selected species is activated with the additional keyword `Dopants`:

```
Physics{ IncompleteIonization(Dopants = "Species_name1 Species_name2 ...") }
```

For example, the following command line activates the model only for boron:

```
Physics{ IncompleteIonization(Dopants = "BoronActiveConcentration") }
```

The incomplete ionization model can be specified in region or material physics (see Region-Specific and Material-Specific Models on page 19). In this case, the model is activated only in these regions or materials.

Using the Incomplete Ionization Model

Using `DonorPlusConcentration` and `AccepMinusConcentration` in the `Plot` section of the device, you can visualize the ionized donor and acceptor concentrations, respectively. The net ionized doping concentration can be plotted using `IonizedDopingConcentration` or `DopingConcentration`:

`IonizedDopingConcentration` (`DopingConcentration`) = `DonorPlusConcentration` - `AccepMinusConcentration`

Finally, the substitutional (active) net concentration can be plotted using `ActiveDopingConcentration`:

`ActiveDopingConcentration` = `DonorConcentration` - `AcceptorConcentration`

**NOTE** Incomplete ionization is implemented in terms of traps and, therefore, is affected by setting the trap occupation explicitly (see Explicit Trap Occupation on page 496). Use named traps to avoid affecting dopant ionization by settings intended for *real* traps only.

# Incomplete Ionization Model

The concentration of ionized impurity atoms is given by Fermi–Dirac distribution:

$$ N_{D} = \frac{N_{D,0}}{1 + g_{D} \exp \left( \frac{E_{F,n} - E_{D}}{kT} \right)} \text{ for } N_{D,0} < N_{D,\text{crit}} $$ (207)

$$ N_{A} = \frac{N_{A,0}}{1 + g_{A} \exp \left( \frac{E_{A} - E_{F,p}}{kT} \right)} \text{ for } N_{A,0} < N_{A,\text{crit}} $$ (208)

where $N_{D,0}$ and $N_{A,0}$ are the substitutional (active) donor and acceptor concentrations, $g_{D}$ and $g_{A}$ are the degeneracy factors for the impurity levels, and $E_{D}$ and $E_{A}$ are the donor and acceptor ionization (activation) energies.

In the literature [[1]](1), incomplete ionization in SiC material has been considered and another general distribution function has been proposed, which can be expressed as:

$$ N_{D} = \frac{N_{D,0}}{1 + G_{D}(T) \exp \left( \frac{E_{F,n} - E_{C}}{kT} \right)} $$ (209)

$$ N_{A} = \frac{N_{A,0}}{1 + G_{A}(T) \exp \left( -\frac{E_{F,p} - E_{V}}{kT} \right)} $$ (210)

13: Incomplete Ionization
Using the Incomplete Ionization Model

where $G_D(T)$ and $G_A(T)$ are the ionization factors discussed in [[2]]([2])[[3]]([3]). These factors can be defined by a PMI (see [[1]]([1]) and Example: Matsuura Incomplete Ionization on page 1441).

By comparing Eq. 207 and Eq. 208 to Eq. 209 and Eq. 210, it can be seen that, in the case of the Fermi distribution function, the ionization factors can be written as:

$$ G_D(T) = g_D \cdot \exp \left( \frac{\Delta E_D}{kT} \right), \Delta E_D = E_C - E_D \text{ and } G_A(T) = g_A \cdot \exp \left( \frac{\Delta E_A}{kT} \right), \Delta E_A = E_A - E_V \quad (211) $$

In Sentaurus Device, the basic variables are potential, electron concentration, and hole concentration. Therefore, it is more convenient to rewrite Eq. 207 and Eq. 208 in terms of the carrier concentration instead of the quasi-Fermi levels:

$$ N_D = \frac{N_{D,0}}{1 + g_D \frac{n}{n_1}}, \text{ with } n_1 = N_C \exp \left( -\frac{\Delta E_D}{kT} \right) \text{ for } N_{D,0} < N_{D,\text{crit}} \quad (212) $$

$$ N_A = \frac{N_{A,0}}{1 + g_A \frac{p}{p_1}}, \text{ with } p_1 = N_V \exp \left( -\frac{\Delta E_A}{kT} \right) \text{ for } N_A < N_{A,\text{crit}} \quad (213) $$

The expressions for $n_1$ and $p_1$ in these two equations are valid for Boltzmann statistics and without quantization. If Fermi–Dirac statistics or a quantization model (see Chapter 14 on page 303) is used, then $n_1$ and $p_1$ are multiplied by the coefficients $\gamma_n$ and $\gamma_p$ defined in Eq. 47 and Eq. 48, p. 183 (see Fermi Statistics on page 182). For $N_{D/A} > N_{D/A, \text{crit}}$, the dopants are assumed to be completely ionized, in which case, every donor and acceptor species is considered in the Poisson equation. The values of $N_{D,\text{crit}}$ and $N_{A,\text{crit}}$ can be adjusted in the parameter file of Sentaurus Device.

To provide a complete ionization for high doping concentrations, the donor and acceptor activation energies are effectively reduced by the total doping in the semiconductor [[4]]([4]). It also suggests to have an additional temperature dependence in the activation energy as a fitting option. This is accounted for in the expressions:

$$ \Delta E_D = \Delta E_{D,0} - \alpha_D \cdot N_{\text{tot}}^{1/3} + \beta_D \left[ \left( \frac{300}{T} \right)^{\gamma_D} - 1 \right] \frac{kT}{q} \quad (214) $$

$$ \Delta E_A = \Delta E_{A,0} - \alpha_A \cdot N_{\text{tot}}^{1/3} + \beta_A \left[ \left( \frac{300}{T} \right)^{\gamma_A} - 1 \right] \frac{kT}{q} \quad (215) $$

where:

*   $N_{\text{tot}} = N_{A,0} + N_{D,0}$ is the total doping concentration.

*   $T$ is the lattice temperature.

*   $\alpha_{A/D}$, $\beta_{A/D}$, and $\gamma_{A/D}$ are model fitting parameters.

Physical Model Parameters

The development undertaken in [[5]]([5]) and [[6]]([6]) suggests an alternative Altermatt ionization model, which is based on accounting for changes introduced by impurities into the semiconductor density-of-states. This model is still based on Eq. 212 and Eq. 213, but with some modifications of the degeneracy factors $g_D$ and $g_A$, and the activation energies $\Delta E_D$ and $\Delta E_A$:

$$ g'_D = \frac{b_D}{g_D + (1 - b_D) \frac{n}{n_1}}, g'_A = \frac{b_A}{g_A + (1 - b_A) \frac{p}{p_1}}, b_{A/D} = \frac{1}{1 + (N_{A/D,0} / N_b)^{d_b}} \text{ (216)} $$

$$ \Delta E_{A/D} = \frac{\Delta E_{A/D,0}}{1 + (N_{A/D,0} / N_E)^{d_E}} + \beta_{A/D} \left[ \left( \frac{300}{T} \right)^{\gamma_{A/D}} - 1 \right] \frac{kT}{q}, \text{ (217)} $$

where $N_b$, $d_b$, $N_E$, and $d_E$ are additional fitting parameters of the model defined for each impurity separately, and the last term in Eq. 217 is added similarly to Eq. 214 and Eq. 215 for fitting purposes.

In transient simulations, the terms:

$$ \frac{\partial N_D^n}{\partial t} = \sigma_D v_{th}^n \left[ \frac{n_1}{g_D} N_{D,0} - \left( n + \frac{n_1}{g_D} \right) N_D \right] \text{ (218)} $$

$$ \frac{\partial N_A^p}{\partial t} = \sigma_A v_{th}^p \left[ \frac{p_1}{g_A} N_{A,0} - \left( p + \frac{p_1}{g_A} \right) N_A \right] \text{ (219)} $$

are included in the continuity equations, where $v_{th}^{n,p}$ denotes the carrier thermal velocities, and $\sigma_{A/D}$ is the capture or emission cross-section.

For very low temperature applications, a field-enhanced ionization of impurities might play an important role. Generally, the ionization equations, such as Eq. 218 and Eq. 219, involve an account of the emission and capture carrier fluxes with the conduction band or valence band. These equations are the same as described for the trap model in Local Capture and Emission Rates on page 501. The field-enhanced ionization of the incomplete ionization model enhances the emission cross-section with the following allowed models: J-Model for Cross Sections on page 502, Hurkx Model for Cross Sections on page 503, and Poole–Frenkel Model for Cross Sections on page 503.

# Physical Model Parameters

You can access the values of the dopant level $E_{A/D,0}$, the doping- and temperature-dependent shift parameters $\alpha_{A/D}$, $\beta_{A/D}$, and $\gamma_{A/D}$, the impurity degeneracy factor $g_{A/D}$, and the cross section $\sigma_{A/D}$ in the parameter set `Ionization`.

**13: Incomplete Ionization**
Physical Model Parameters

For each ionized doping species, the `Ionization` parameter set must contain a separate subsection where the parameters $E_{A/D,0}$, $\alpha_{A/D}$, $\beta_{A/D}$, $\gamma_{A/D}$, $g_{A/D}$, and $\sigma_{A/D}$ are defined. For example, for the dopant BoronActiveConcentration, described in Specifying Doping Species on page 12, for the material silicon, the parameter set is:

```
Material = "Silicon" {
  ...
  Ionization {
    ...
    Species ("BoronActiveConcentration") {
      type = acceptor
      E_0  = 0.045        # [eV]
      alpha = 3.1e-8      # [eV cm]
      beta = 0            # [1]
      gamma = 1           # [1]
      g    = 4            # [1]
      Xsec = 1.0e-12      # [cm^2]
      Xsec_formula    = 1
      highdop_formula = 1
    }
  }
}
```

You can omit the field `type` because the dopant type is specified in the `datexcodes.txt` file. It is used here for informative purposes only.

Table 42 Default coefficients for incomplete ionization model for dopants in silicon

| Symbol | Parameter name | Default value for species * | Unit |  |  |  |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| As | P | Sb | B | Al | In | N | NDopant | PDopant |  |  |  |
| $E_{A/D,0}$ | E_0 | 0.054 | 0.045 | 0.039 | 0.045 | 0.045 | 0.16 | 0.045 | 0.045 | 0.045 | eV |
| $\alpha_{A/D}$ | alpha | 3.1×10⁻⁸ | eVcm |  |  |  |  |  |  |  |  |
| $\beta_{A/D}$ | beta | 0 | 1 |  |  |  |  |  |  |  |  |
| $\gamma_{A/D}$ | gamma | 1 | 1 |  |  |  |  |  |  |  |  |
| $g_{A/D}$ | g | 2 | 2 | 2 | 4 | 4 | 4 | 2 | 2 | 4 | 1 |
| $\sigma_{A/D}$ | Xsec | 1.0×10⁻¹² | cm² |  |  |  |  |  |  |  |  |
| $N_{D,crit}$ | NdCrit | 1.0×10²² | cm⁻³ |  |  |  |  |  |  |  |  |
| $N_{A,crit}$ | NaCrit | 1.0×10²² | cm⁻³ |  |  |  |  |  |  |  |  |

To activate the Altermatt ionization model defined by Eq. 216 and Eq. 217, specify `highdop_formula=2` as well as the additional parameters $N_b$, $d_b$, $N_E$, and $d_E$.

Physical Model Parameters

For example, for boron, it should be as follows:

```
Species ("BoronActiveConcentration") {
      highdop_formula = 2
      b_Nref = 6e18                   # [cm^-3]
      b_pow = 2.4                     # [1]
      E_Nref = 1.7e18                 # [cm^-3]
      E_pow = 1.4                     # [1]
}
```

Table 43 lists all the silicon default parameters of the Altermatt model in Eq. 216 and Eq. 217 as suggested by [5] and [6].

Table 43 Default parameters of Altermatt model

| Symbol | Parameter name | Default value for species * | Unit |  |  |
| --- | --- | --- | --- | --- | --- |
| As | B | P |  |  |  |
| Nb | b_Nref | 1.4e19 | 6e18 | 6e18 | cm–3 |
| db | b_pow | 3 | 2.4 | 2.3 | 1 |
| NE | E_Nref | 4e18 | 1.7e18 | 3e18 | cm–3 |
| dE | E_pow | 1.5 | 1.4 | 2 | 1 |

**NOTE** Implementation of the Altermatt model in [5] and [6] replaces *n*, *p* by the doping concentrations *N*<sub>D,0</sub>, *N*<sub>A,0</sub>, respectively, in Eq. 216 to make the model more stable numerically. It is not recommended in Sentaurus Device, but it is still possible with the `-CarrierDensityInAltermatt` option in the `Math` section.

For experimental and fitting purposes, the activation energies of Eq. 214, Eq. 215, and Eq. 217 can be combined into one for any ionization model defined by `highdop_formula`. It can be activated by using the keyword `CombinedEnergy` in the `Species` section with the following expression:

$$ \Delta E_{A/D} = \frac{\Delta E_{A/D,0}}{1 + (N_{A/D,0}/N_E)^{d_E}} - \alpha_{A/D} \cdot N_{tot}^{1/3} + \beta_{A/D} \left[ \left( \frac{300}{T} \right)^{\gamma_{A/D}} - 1 \right] \frac{kT}{q} $$ (220)

To activate the field-enhanced ionization models, use the keyword `Xsec_formula`, where:

* `Xsec_formula=2` activates the J-Model for Cross Sections on page 502.

* `Xsec_formula=3` activates the Hurkx Model for Cross Sections on page 503.

* `Xsec_formula=4` activates the Poole–Frenkel Model for Cross Sections on page 503.

13: Incomplete Ionization
Multiple Lattice Sites

See the corresponding sections for details about how to set the parameters of these models.

# Multiple Lattice Sites

In certain semiconductors, dopants can occupy different lattice sites, resulting in different activation energies for incomplete ionization. An example is 6H-SiC where nitrogen can occupy either a hexagonal site h, or a cubic site k<sub>1</sub> or k<sub>2</sub>.

For the most accurate results, the doping concentration at each lattice site must be modeled by a different doping species. This approach works as follows:

*   Introduce new doping species in the `datexcodes.txt` file to describe the doping concentrations in each lattice site (see Specifying Doping Species on page 12).

To model the nitrogen doping in 6H-SiC, you can introduce the following species:

*   Nitrogen_h_Concentration

*   Nitrogen_k1_Concentration

*   Nitrogen_k2_Concentration

*   Provide a TDR doping file with the concentrations for the new doping species.

*   Provide incomplete ionization model parameters for the new doping species (see Physical Model Parameters on page 296).

In many cases, it is sufficient to specify the average occupation probability of the various lattice sites. For example, you might assume that nitrogen doping in 6H-SiC occupies the hexagonal site h and the cubic sites k<sub>1</sub> or k<sub>2</sub> with equal probability.

Sentaurus Device supports this simplification using a `Split` specification in the command file:

```
Physics {
  IncompleteIonization (
    Split (
      Doping = "NitrogenConcentration"
      Weights = (0.3333 0.3333 0.3334)
    )
  )
}
```

**NOTE** The sum of the weights must be one.

With a `Split` specification, you no longer need to introduce new doping species in the `datexcodes.txt` file. Instead, Sentaurus Device generates the necessary doping species as required and initializes them based on the occupation probabilities.

References

In the example, Sentaurus Device introduces the following doping species automatically:

* NitrogenConcentration_split1

* NitrogenActiveConcentration_split1

* NitrogenPlusConcentration_split1

* NitrogenConcentration_split2

* NitrogenActiveConcentration_split2

* NitrogenPlusConcentration_split2

* NitrogenConcentration_split3

* NitrogenActiveConcentration_split3

* NitrogenPlusConcentration_split3

> **NOTE** The generated doping species also can be used in a device plot (see Device Plots on page 128).

The corresponding parameters can then be specified in the parameter file as described in Physical Model Parameters on page 296:

```
Ionization {
  Species ("NitrogenConcentration_split1") {
    E_0 = 0.1
    alpha = 2.5e-8
    g = 2
    Xsec = 1e-12
  }
  ...
}
```

# References

[1] H. Matsuura, “Influence of Excited States of Deep Acceptors on Hole Concentration in SiC,” in *International Conference on Silicon Carbide and Related Materials (ICSCRM)*, Tsukuba, Japan, pp. 679–682, October 2001.

[2] P. Y. Yu and M. Cardona, *Fundamentals of Semiconductors: Physics and Materials Properties*, Berlin: Springer, 2nd ed., 1999.

[3] K. F. Brennan, *The Physics of Semiconductors: With applications to optoelectronic devices*, Cambridge: Cambridge University Press, 1999.

[4] M. R. Shaheed and C. M. Maziar, “A Physically Based Model for Carrier Freeze-out in Si- and SiGe- Base Bipolar Transistors Suitable for Implementation in Device Simulators,” in *Proceedings of the 1994 Bipolar/BiCMOS Circuits and Technology Meeting (BCTM)*, Minneapolis, MN, USA, pp. 191–194, October 1994.

**13: Incomplete Ionization**

References

[5] P. P. Altermatt, A. Schenk, and G. Heiser, “A simulation model for the density of states and for incomplete ionization in crystalline silicon. I. Establishing the model in Si:P,” *Journal of Applied Physics*, vol. 100, no. 11, p. 113714, 2006.

[6] P. P. Altermatt *et al.*, “A simulation model for the density of states and for incomplete ionization in crystalline silicon. II. Investigation of Si:As and Si:B and usage in device simulation,” *Journal of Applied Physics*, vol. 100, no. 11, p. 113715, 2006.

References

