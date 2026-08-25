# CHAPTER 15 Mobility

*This chapter describes the mobility models implemented in Sentaurus Device.*

## Introduction to Mobility Models

Sentaurus Device uses a modular approach for the description of the carrier mobilities. In the simplest case, mobility is a function of the lattice temperature. The constant mobility model should be used only for undoped materials (see Mobility due to Phonon Scattering on page 342). For doped materials, the carriers scatter with the impurities. This leads to a degradation of the mobility. Doping-Dependent Mobility Degradation on page 342 introduces the models that describe this effect.

Models that describe the effects of carrier–carrier scattering are presented in Carrier–Carrier Scattering on page 351. The Philips unified mobility model is a well-calibrated model that accounts for both impurity and carrier–carrier scattering (see Philips Unified Mobility Model on page 353).

Models that describe the mobility degradation at interfaces, for example, the silicon–oxide interface in the channel region of a MOSFET, are introduced in Mobility Degradation at Interfaces on page 357. These models account for the scattering with surface phonons and surface roughness.

Finally, models that describe mobility degradation in high electric fields are discussed in High-Field Saturation Models on page 387. A flexible model for hydrodynamic simulations is described in Energy-Dependent Mobility on page 828.

## Combining Mobility Models

Mobility models are selected in the `Physics` section as options to `Mobility`, `eMobility`, or `hMobility`:

```
Physics{ Mobility( <arguments> ) ... }
```

Specifications with `eMobility` apply to electrons; specifications with `hMobility` apply to holes; and specifications with `Mobility` apply to both carrier types.

Mobility due to Phonon Scattering

If more than one mobility model is activated for a carrier type, the different mobility contributions ($\mu_1, \mu_2, \dots$) for bulk, surface mobility, and thin layers are combined by Matthiessen's rule:

$$ \frac{1}{\mu} = \frac{1}{\mu_1} + \frac{1}{\mu_2} + \dots $$ (246)

If the high-field saturation model is activated, the final mobility is computed in two steps. First, the low field mobility $\mu_{\text{low}}$ is determined according to Eq. 246. Second, the final mobility is computed from a (model-dependent) formula as a function of a driving force $F_{\text{hfs}}$:

$$ \mu = f(\mu_{\text{low}}, F_{\text{hfs}}) $$ (247)

# Mobility due to Phonon Scattering

The constant mobility model [1] is active by default. It accounts only for phonon scattering and, therefore, it is dependent only on the lattice temperature:

$$ \mu_{\text{const}} = \mu_L \left( \frac{T}{300\text{K}} \right)^{-\zeta} $$ (248)

where $\mu_L$ is the mobility due to bulk phonon scattering. The default values of $\mu_L$ and the exponent $\zeta$ are listed in Table 47. The parameters of the constant mobility model are accessible in the `ConstantMobility` parameter set.

Table 47 Constant mobility model: Default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $\mu_L$ | mumax | 1417 | 470.5 | cm$^2$/Vs |
| $\zeta$ | exponent | 2.5 | 2.2 | 1 |

In some special cases, it might be necessary to deactivate the default constant mobility. This can be accomplished by specifying the `-ConstantMobility` option to `Mobility`:

```
Physics { Mobility ( -ConstantMobility ... ) ... }
```

# Doping-Dependent Mobility Degradation

In doped semiconductors, scattering of the carriers by charged impurity ions leads to degradation of the carrier mobility. Sentaurus Device supports several built-in models (see Masetti Model on page 344, Arora Model on page 345, and University of Bologna Bulk Mobility Model on page 346), one multistate configuration–dependent model (see The

15: Mobility
Doping-Dependent Mobility Degradation

pmi_msc_mobility Model on page 348), and two types of PMI for doping-dependent mobility (see PMIs for Bulk Mobility on page 349).

The Philips unified mobility model is also available to account for doping-dependent scattering. This model accounts for other effects as well (such as electron–hole scattering and screening of impurities by carriers) (see Philips Unified Mobility Model on page 353).

For very-short channel devices, it has been found that an additional contribution to low-field mobility is sometimes needed to match measured device characteristics. For this purpose, a ballistic mobility model is provided (see Low-Field Ballistic Mobility Models on page 349) that can be specified in addition to one of the doping-dependent mobility models described in this section.

# Using Doping-Dependent Mobility

Mobility degradation due to impurity scattering is activated by specifying the `DopingDependence` option to `Mobility`. The different model choices are selected as options to `DopingDependence`:

```
Physics {
  Mobility(
    DopingDependence (
      [ Masetti | Arora | UniBo | PhuMob | PhuMob2 |
        PMIModel(Name = "<msc-dependent-bulk-model>" ...) |
        BalMob( [Lch=<float>] ) |
        <doping-dependent-pmi-model>
      ]
    )
  )
}
```

If `DopingDependence` is specified without options, Sentaurus Device uses a material-dependent default. For example, in silicon, the default is the Masetti model; for GaAs, the default is the Arora model. The default model (Masetti or Arora) for each material can be specified by using the parameter `formula`, which is accessible in the `DopingDependence` parameter set in the parameter file:

```
DopingDependence: {
  formula= 1 , 1    # [1]
}
```

When `formula=1`, the Masetti model is the default. To use the Arora model as the default, specify `formula=2`.

15: Mobility
Doping-Dependent Mobility Degradation

The `UniBo` option selects the University of Bologna bulk mobility model. The options `PhuMob` and `PhuMob2` select the Philips unified mobility model and an alternative version of this model, respectively (see Philips Unified Mobility Model on page 353).

## Using More Than One Doping-Dependent Mobility Model

In most cases, only one doping-dependent mobility model should be specified to avoid double-counting mobility effects. However, Sentaurus Device allows more than one model to be used in a simulation. It can be useful, for example, to include additional degradation components that are created as PMI models into the bulk mobility calculation. When more than one model is specified as an option to `DopingDependence`, they are combined using Matthiessen’s rule. For example, the specification:

```
Physics { Mobility( DopingDependence( Masetti pmi_model1 pmi_model2) ...) ...}
```

calculates the total bulk mobility using:

$$ \frac{1}{\mu_b} = \frac{1}{\mu_{\text{Masetti}}} + \frac{1}{\mu_{\text{pmi\_model1}}} + \frac{1}{\mu_{\text{pmi\_model2}}} $$ (249)

# Masetti Model

The default model used by Sentaurus Device to simulate doping-dependent mobility in silicon was proposed by Masetti et al. [2]:

$$ \mu_{\text{dop}} = \mu_{\min1} \exp(-\frac{P_c}{N_{A,0} + N_{D,0}}) + \frac{\mu_{\text{const}} - \mu_{\min2}}{1 + ((N_{A,0} + N_{D,0})/C_r)^\alpha} - \frac{\mu_1}{1 + (C_s/(N_{A,0} + N_{D,0}))^\beta} $$ (250)

The reference mobilities $\mu_{\min1}$, $\mu_{\min2}$, and $\mu_1$, the reference doping concentrations $P_c$, $C_r$, and $C_s$, and the exponents $\alpha$ and $\beta$ are accessible in the parameter set `DopingDependence` in the parameter file. The corresponding values for silicon are given in Table 48.

Table 48 Masetti model: Default coefficients

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| μmin1 | mumin1 | 52.2 | 44.9 | cm2/Vs |
| μmin2 | mumin2 | 52.2 | 0 | cm2/Vs |
| μ1 | mu1 | 43.4 | 29.0 | cm2/Vs |
| Pc | Pc | 0 | 9.23×1016 | cm-3 |
| Cr | Cr | 9.68×1016 | 2.23×1017 | cm-3 |
| Cs | Cs | 3.43×1020 | 6.10×1020 | cm-3 |

15: Mobility
Doping-Dependent Mobility Degradation

Table 48 Masetti model: Default coefficients (Continued)

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| α | alpha | 0.680 | 0.719 | 1 |
| β | beta | 2.0 | 2.0 | 1 |

The low-doping reference mobility $\mu_{\text{const}}$ is determined by the constant mobility model (see Mobility due to Phonon Scattering on page 342).

# Arora Model

The Arora model [3] reads:

$$\mu_{\text{dop}} = \mu_{\text{min}} + \frac{\mu_d}{1 + ((N_{A,0} + N_{D,0})/N_0)^{A^*}} \tag{251}$$

with:

$$\mu_{\text{min}} = A_{\text{min}} \cdot \left( \frac{T}{300\text{ K}} \right)^{\alpha_m}, \mu_d = A_d \cdot \left( \frac{T}{300\text{ K}} \right)^{\alpha_d} \tag{252}$$

and:

$$N_0 = A_N \cdot \left( \frac{T}{300\text{ K}} \right)^{\alpha_N}, A^* = A_a \cdot \left( \frac{T}{300\text{ K}} \right)^{\alpha_a} \tag{253}$$

The parameters are accessible in the `DopingDependence` parameter set in the parameter file.

Table 49 Arora model: Default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| Amin | Ar_mumin | 88 | 54.3 | cm2/Vs |
| αm | Ar_alm | –0.57 | –0.57 | 1 |
| Ad | Ar_mud | 1252 | 407 | cm2/Vs |
| αd | Ar_ald | –2.33 | –2.23 | 1 |
| AN | Ar_N0 | 1.25×1017 | 2.35×1017 | cm–3 |
| αN | Ar_alN | 2.4 | 2.4 | 1 |
| Aa | Ar_a | 0.88 | 0.88 | 1 |
| αa | Ar_ala | –0.146 | –0.146 | 1 |

15: Mobility
Doping-Dependent Mobility Degradation

# University of Bologna Bulk Mobility Model

The University of Bologna bulk mobility model was developed for an extended temperature range between 25°C and 973°C. It should be used together with the University of Bologna inversion layer mobility model (see University of Bologna Surface Mobility Model on page 370). The model [4][5] is based on the Masetti approach with two major extensions. First, attractive and repulsive scattering are separately accounted for, therefore, leading to a function of both donor and acceptor concentrations. This automatically accounts for different mobility values for majority and minority carriers, and ensures continuity at the junctions as long as the impurity concentrations are continuous functions. Second, a suitable temperature dependence for most model parameters is introduced to predict correctly the temperature dependence of carrier mobility in a wider range of temperatures, with respect to other models. The temperature dependence of lattice mobility is reworked, with respect to the default temperature.

The model for lattice mobility is:

$$ \mu_L(T) = \mu_{\max} \left( \frac{T}{300\text{ K}} \right)^{-\gamma + c \left( \frac{T}{300\text{ K}} \right)} $$ (254)

where $\mu_{\max}$ denotes the lattice mobility at room temperature, and $c$ gives a correction to the lattice mobility at higher temperatures. The maximum mobility $\mu_{\max}$ and the exponents $\gamma$ and $c$ are accessible in the `UniBoDopingDependence` parameter set in the parameter file.

The model for bulk mobility reads:

$$ \mu_{\text{dop}}(T) = \mu_0(T) + \frac{\mu_L(T) - \mu_0(T)}{1 + \left( \frac{N_{D,0}}{C_{r1}(T)} \right)^\alpha + \left( \frac{N_{A,0}}{C_{r2}(T)} \right)^\beta} - \frac{\mu_1(N_{D,0}, N_{A,0}, T)}{1 + \left( \frac{N_{D,0}}{C_{s1}(T)} + \frac{N_{A,0}}{C_{s2}(T)} \right)^{-2}} $$ (255)

In turn, $\mu_0$ and $\mu_1$ are expressed as weighted averages of the corresponding limiting values for pure acceptor-doping and pure donor-doping densities:

$$ \mu_0(T) = \frac{\mu_{0d}N_{D,0} + \mu_{0a}N_{A,0}}{N_{A,0} + N_{D,0}} $$ (256)

$$ \mu_1(T) = \frac{\mu_{1d}N_{D,0} + \mu_{1a}N_{A,0}}{N_{A,0} + N_{D,0}} $$ (257)

The reference mobilities $\mu_{0d}$, $\mu_{0a}$, $\mu_{1d}$, and $\mu_{1a}$, and the reference doping concentrations $C_{r1}$, $C_{r2}$, $C_{s1}$, and $C_{s2}$ are accessible in the `UniBoDopingDependence` parameter set in the parameter file.

15: Mobility
Doping-Dependent Mobility Degradation

Table 50 lists the corresponding values of silicon for arsenic, phosphorus, and boron; $T_n = T/300\text{ K}$.

The default parameters of Sentaurus Device for electrons are those for arsenic. The bulk mobility model was calibrated with experiments [5] in the temperature range from 300 K to 700 K. It is suitable for isothermal simulations at large temperatures or nonisothermal simulations.

Table 50 Parameters of University of Bologna bulk mobility model

| Symbol | Parameter name | Electrons (As) | Electrons (P) | Holes (B) | Unit |
| --- | --- | --- | --- | --- | --- |
| μmax | mumax | 1441 | 1441 | 470.5 | cm2/Vs |
| c | Exponent2 | –0.11 | –0.11 | 0 | 1 |
| γ | Exponent | 2.45 | 2.45 | 2.16 | 1 |
| μ0d | mumin1 | 55.0$T_n^{-\gamma_{0d}}$ | 62.2$T_n^{-\gamma_{0d}}$ | 90.0$T_n^{-\gamma_{0d}}$ | cm2/Vs |
| γ0d | mumin1_exp | 0.6 | 0.7 | 1.3 | 1 |
| μ0a | mumin2 | 132.0$T_n^{-\gamma_{0a}}$ | 132.0$T_n^{-\gamma_{0a}}$ | 44.0$T_n^{-\gamma_{0a}}$ | cm2/Vs |
| γ0a | mumin2_exp | 1.3 | 1.3 | 0.7 | 1 |
| μ1d | mu1 | 42.4$T_n^{-\gamma_{1d}}$ | 48.6$T_n^{-\gamma_{1d}}$ | 28.2$T_n^{-\gamma_{1d}}$ | cm2/Vs |
| γ1d | mu1_exp | 0.5 | 0.7 | 2.0 | 1 |
| μ1a | mu2 | 73.5$T_n^{-\gamma_{1a}}$ | 73.5$T_n^{-\gamma_{1a}}$ | 28.2$T_n^{-\gamma_{1a}}$ | cm2/Vs |
| γ1a | mu2_exp | 1.25 | 1.25 | 0.8 | 1 |
| Cr1 | Cr | $8.9 \times 10^{16} T_n^{\gamma_{r1}}$ | $8.5 \times 10^{16} T_n^{\gamma_{r1}}$ | $1.3 \times 10^{18} T_n^{\gamma_{r1}}$ | cm–3 |
| γr1 | Cr_exp | 3.65 | 3.65 | 2.2 | 1 |
| Cr2 | Cr2 | $1.22 \times 10^{17} T_n^{\gamma_{r2}}$ | $1.22 \times 10^{17} T_n^{\gamma_{r2}}$ | $2.45 \times 10^{17} T_n^{\gamma_{r2}}$ | cm–3 |
| γr2 | Cr2_exp | 2.65 | 2.65 | 3.1 | 1 |
| Cs1 | Cs | $2.9 \times 10^{20} T_n^{\gamma_{s1}}$ | $4.0 \times 10^{20} T_n^{\gamma_{s1}}$ | $1.1 \times 10^{18} T_n^{\gamma_{s1}}$ | cm–3 |
| γs1 | Cs_exp | 0 | 0 | 6.2 | 1 |
| Cs2 | Cs2 | $7.0 \times 10^{20}$ | $7.0 \times 10^{20}$ | $6.1 \times 10^{20}$ | cm–3 |
| α | alpha | 0.68 | 0.68 | 0.77 | 1 |
| β | beta | 0.72 | 0.72 | 0.719 | 1 |

15: Mobility
Doping-Dependent Mobility Degradation

# The pmi_msc_mobility Model

The mobility model `pmi_msc_mobility` depends on the lattice temperature and the occupation probabilities of the states of a multistate configuration (MSC). The model averages the mobilities of all MSC states according to:

$$ \mu = \sum_{i} \mu_{i}(T)s_{i} $$ (258)

where the sum is taken over all MSC states, $\mu_{i}$ are the state mobilities, and $s_{i}$ are the state occupation probabilities. Each state mobility can be temperature dependent according to:

$$ \mu_{i} = \begin{cases} \mu_{i, \text{ref}} & \text{if } T < T_{\text{ref}} \\ \frac{1}{T_{g} - T_{\text{ref}}} [(T_{g} - T)\mu_{i, \text{ref}} + (T - T_{\text{ref}})\mu_{i, \text{g}}] & \text{if } T_{\text{ref}} \le T < T_{g} \\ \mu_{i, \text{g}} & \text{if } T_{g} \le T \end{cases} $$ (259)

where:

* The index $i$ refers to the state.

* $T_{\text{ref}}$ and $T_{g}$ are the reference and glass temperatures (terminology is borrowed from and the model is used for phase transition dynamics).

* $\mu_{i, \text{ref}}$ and $\mu_{i, \text{g}}$ are the (state-specific) mobilities for the corresponding temperatures.

The model is activated (here, for MSC "m0" and model string "e") by:

```
PMIModel ( Name="pmi_msc_mobility" MSConfig="m0" String="e" )
```

The given `String` is used to determine the names of parameters in the parameter file.

Table 51 Global and model-string parameters of pmi_msc_mobility

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| plot | – | 0 | – | {0,1} | Plot parameter to screen |
| Tref | $T_{\text{ref}}$ | 300. | K | >=0. | Reference temperature |
| Tg | $T_{g}$ | -1. | K | >=$T_{\text{ref}}$ or equal -1. | Glass temperature |
| mu_ref | – | 1. | cm/Vs | >0. | Value at reference temperature |
| mu_g | – | 1. | cm/Vs | >0. | Value at glass temperature |

15: Mobility

Doping-Dependent Mobility Degradation

The model uses a three-level hierarchy of sets of parameters to define the parameters for each state, namely, the global, the model-string, and the state parameters. The global parameters of the model are given in Table 51 on page 348. They serve as defaults for the model-string parameters, which are the global parameters with the prefix:

`<model_string>_`

where `<model_string>` is the `String` parameter given in the command file. The model-string parameters, in turn, serve as defaults for the state parameters (see Table 52), which are prefixed by:

`<model_string>_<state_name>_`

where `<state_name>` is the name of the MSC state.

Table 52 State parameters of pmi_msc_mobility

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| mu_ref | μi, ref | – | cm2/Vs | >0. | Value at reference temperature |
| mu_g | μi, g | – | cm2/Vs | >0. | Value at glass temperature |

# PMIs for Bulk Mobility

The PMIs for bulk mobility are described in Doping-Dependent Mobility on page 1237 and Multistate Configuration–Dependent Bulk Mobility on page 1287.

# Low-Field Ballistic Mobility Models

You can use one of the following models to describe ballistic mobility.

## Simple Channel Length–Dependent Ballistic Mobility Model

This model is based on Shur [6] and is given by the following simple expression, where ballistic mobility is proportional to the channel length:

$$ \mu_{\text{bal}} = k \cdot L_{\text{ch}} $$ (260)

Both $k$ and $L_{\text{ch}}$ are model parameters. In most cases, you specify a value for $L_{\text{ch}}$ (in nm) that corresponds to the actual channel length for the device being simulated. You can adjust the parameter $k$ to match measured device characteristics.

Doping-Dependent Mobility Degradation

Table 53 Simple ballistic mobility model: Default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| k | k | 20.0 | 20.0 | cm2/Vs nm |
| Lch | Lch | 107 | 107 | nm |

## Injection Velocity–Dependent Ballistic Mobility Model

This model includes the finite injection velocity from the source and drain with the mobility concept [7] and is given by the following expression:

$$\mu_{\text{bal}} = f \cdot L_{\text{ch}}$$ (261)

Here, $f$ is a function of injection velocity. The functional form of $f$ is given as follows:

$$f = \frac{1}{V_{\text{ds}} + V_{\text{b}}} \frac{V_{\text{b}}}{V_{\text{ds,lin}}} \left( \frac{L_{\text{ch}}}{L_{\text{ref}}} \right)^{\alpha} V_{\text{inj}} \frac{1 - \exp(-\frac{V_{\text{ds}}}{k_{\text{B}}T})}{1 + \exp(-\frac{V_{\text{ds}}}{k_{\text{B}}T})}$$ (262)

where:

* $\alpha$, $L_{\text{ch}}$, $L_{\text{ref}}$, $V_{\text{b}}$, $V_{\text{ds}}$, $V_{\text{ds,lin}}$, and $V_{\text{inj}}$ are model parameters (see Table 54).

* $T$ is the lattice temperature.

* $k_{\text{B}}$ is the Boltzmann constant.

Table 54 Injection velocity ballistic mobility model: Default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| \alpha | alpha | 0.0 | 0.0 | 1 |
| Lch | Lch | 107 | 107 | nm |
| Lref | Lref | 100 | 100 | nm |
| Vb | vbbal | 0.0 | 0.0 | V |
| Vds | vdsbal | 0.75 | 0.75 | V |
| Vds,lin | vdslin | 0.05 | 0.05 | V |
| Vinj | vinj | 3.0e7 | 3.0e7 | cm/s |

**15: Mobility**
Carrier–Carrier Scattering

To use a low-field ballistic mobility model, specify `BalMob` as an argument to `DopingDependence`. For example:

```
Physics {
   Mobility (
      DopingDependence ( PhuMob BalMob(Lch = 5.0) )
   )
}
```

In this case, $\mu_{bal}$ is combined with the mobility from `PhuMob` by using Matthiessen’s rule. If you do not specify `Lch`, then the default value of $10^7$ nm is used, which effectively deactivates the model.

By default, the simple channel length–dependent ballistic mobility model is activated by specifying `BalMob`. The injection velocity–dependent ballistic mobility model is invoked by setting a positive nonzero value for the $V_b$ parameter in the parameter file.

# Carrier–Carrier Scattering

Two models are supported for the description of carrier–carrier scattering. One model is based on Choo [8] and Fletcher [9], and uses the Conwell–Weisskopf theory. As an alternative to the Conwell–Weisskopf model, Sentaurus Device supports a model based on the Brooks–Herring screening theory [10]. The carrier–carrier contribution to the overall mobility degradation is captured in the mobility term $\mu_{eh}$. This is combined with the mobility contributions from other degradation models ($\mu_{other}$) according to Matthiessen’s rule:

$$ \frac{1}{\mu} = \frac{1}{\mu_{other}} + \frac{1}{\mu_{eh}} \text{ (263)} $$

## Using Carrier–Carrier Scattering

Carrier–carrier scattering models are activated by specifying the `CarrierCarrierScattering` option to `Mobility`. Either of the two different models are selected by an additional flag:

```
Physics { Mobility (
   CarrierCarrierScattering( [ ConwellWeisskopf | BrooksHerring ] )
...)...}
```

The Conwell–Weisskopf model is the default in Sentaurus Device for carrier–carrier scattering and is activated when `CarrierCarrierScattering` is specified without an option.

Carrier–Carrier Scattering

## Conwell–Weisskopf Model

$$ \mu_{eh} = \frac{D(T/300\text{ K})^{3/2}}{\sqrt{np}} \left[ \ln \left( 1 + F \left( \frac{T}{300\text{ K}} \right)^2 (pn)^{-1/3} \right) \right]^{-1} \text{ (264)} $$

The parameters $D$ and $F$ are accessible in the parameter file. The default values appropriate for silicon are given in Table 55.

## Brooks–Herring Model

$$ \mu_{eh} = \frac{c_1(T/300\text{ K})^{3/2}}{\sqrt{np}} \frac{1}{\phi(\eta_0)} \text{ (265)} $$

where $\phi(\eta_0) = \ln(1 + \eta_0) - \eta_0 / (1 + \eta_0)$ and:

$$ \eta_0(T) = \frac{c_2}{N_C F_{-1/2}(n/N_C) + N_V F_{-1/2}(p/N_V)} \left( \frac{T}{300\text{ K}} \right)^2 \text{ (266)} $$

Table 56 lists the silicon default values for $c_1$ and $c_2$.

## Physical Model Parameters

Parameters for the carrier–carrier scattering models are accessible in the parameter set `CarrierCarrierScattering`.

Table 55 Conwell–Weisskopf model: Default parameters

| Symbol | Parameter name | Value | Unit |
| --- | --- | --- | --- |
| D | D | 1.04×10²¹ | cm⁻¹V⁻¹s⁻¹ |
| F | F | 7.452×10¹³ | cm⁻² |

Table 56 Brooks-Herring model: Default parameters

| Symbol | Parameter name | Value | Unit |
| --- | --- | --- | --- |
| c₁ | c1 | 1.56×10²¹ | cm⁻¹V⁻¹s⁻¹ |
| c₂ | c2 | 7.63×10¹⁹ | cm⁻³ |

15: Mobility
Philips Unified Mobility Model

# Philips Unified Mobility Model

The Philips unified mobility model, proposed by Klaassen [11], unifies the description of majority and minority carrier bulk mobilities. In addition to describing the temperature dependence of the mobility, the model takes into account electron–hole scattering, screening of ionized impurities by charge carriers, and clustering of impurities.

The Philips unified mobility model is well calibrated. Though it was initially used primarily for bipolar devices, it is widely used for MOS devices.

## Using the Philips Unified Mobility Model

There are different methods for activating the Philips unified mobility model.

As described in Using Doping-Dependent Mobility on page 343, you can activate the model by specifying `PhuMob` as an option to `DopingDependence`. This method is required if you want to combine `PhuMob` with an additional doping-dependent model (for example, a doping-dependent PMI model to account for other degradation effects).

Alternatively, you can activate the Philips unified mobility model by specifying the `PhuMob` option to `Mobility` directly:

```
Physics{ Mobility ( PhuMob ... ) ... }
```

Specifying `PhuMob` in this way causes Sentaurus Device to completely ignore any specification made with `DopingDependence`, if present, to avoid accidental double-counting of mobility effects.

The `PhuMob` model also can be activated with an additional option:

```
Physics{ Mobility ( PhuMob[(Arsenic | Phosphorus)] ...) ... }
```

The option `Arsenic` or `Phosphorus` specifies which parameters (see Table 58 on page 357) are used. These parameters reflect the different electron mobility degradation that is observed in the presence of these donor species.

> **NOTE** The Philips unified mobility model describes mobility degradation due to both impurity scattering and carrier–carrier scattering mechanisms. Therefore, the keyword `PhuMob` must not be combined with the keyword `DopingDependence` or `CarrierCarrierScattering`. If a combination of these keywords is specified, Sentaurus Device uses only the Philips unified mobility model.

15: Mobility
Philips Unified Mobility Model

# Using an Alternative Philips Unified Mobility Model

Sentaurus Device provides an extended PMI reimplementation of the Philips unified mobility model (see Doping-Dependent Mobility on page 1237). To use it, specify `PhuMob2` as the option for `DopingDependence`:

```
Physics { Mobility (DopingDependence(PhuMob2)...)...}
```

The reimplementation uses the `PhuMob2` parameter set. The parameter `FACT_G` has a default value of 1. It modifies the function $G(P_i)$ shown in Eq. 279 by a factor $G(P_i) = \text{FACT\_G}$ (right-hand side in Eq. 279). Otherwise, the reimplementation fully agrees with the model described below.

# Description of the Philips Unified Mobility Model

According to the Philips unified mobility model, there are two contributions to carrier mobilities. The first, $\mu_{i, L}$, represents phonon (lattice) scattering and the second, $\mu_{i, DAeh}$, accounts for all other bulk scattering mechanisms (due to free carriers, and ionized donors and acceptors). These partial mobilities are combined to give the bulk mobility $\mu_{i, b}$ for each carrier according to Matthiessen’s rule:

$$ \frac{1}{\mu_{i, b}} = \frac{1}{\mu_{i, L}} + \frac{1}{\mu_{i, DAeh}} \tag{267} $$

In Eq. 267 and all of the following model equations, the index $i$ takes the value ‘e’ for electrons and ‘h’ for holes. The first contribution due to lattice scattering takes the form:

$$ \mu_{i, L} = \mu_{i, \text{max}} \left( \frac{T}{300 \text{ K}} \right)^{-\theta_i} \tag{268} $$

The second contribution has the form:

$$ \mu_{i, DAeh} = \mu_{i, N} \left( \frac{N_{i, sc}}{N_{i, sc,eff}} \right) \left( \frac{N_{i, ref}}{N_{i, sc}} \right)^{\alpha_i} + \mu_{i, c} \left( \frac{n + p}{N_{i, sc,eff}} \right) \tag{269} $$

with:

$$ \mu_{i, N} = \frac{\mu_{i, \text{max}}^2}{\mu_{i, \text{max}} - \mu_{i, \text{min}}} \left( \frac{T}{300 \text{ K}} \right)^{3\alpha_i - 1.5} \tag{270} $$

$$ \mu_{i, c} = \frac{\mu_{i, \text{max}} \mu_{i, \text{min}}}{\mu_{i, \text{max}} - \mu_{i, \text{min}}} \left( \frac{300 \text{ K}}{T} \right)^{0.5} \tag{271} $$

15: Mobility
Philips Unified Mobility Model

for electrons:

$$ N_{e,sc} = N_{D}^{*} + N_{A}^{*} + p $$ (272)

$$ N_{e,sc,eff} = N_{D}^{*} + G(P_{e})N_{A}^{*} + f_{e} \frac{p}{F(P_{e})} $$ (273)

and for holes:

$$ N_{h,sc} = N_{A}^{*} + N_{D}^{*} + n $$ (274)

$$ N_{h,sc,eff} = N_{A}^{*} + G(P_{h})N_{D}^{*} + f_{h} \frac{n}{F(P_{h})} $$ (275)

The effects of clustering of donors ($N_{D}^{*}$) and acceptors ($N_{A}^{*}$) at ultrahigh concentrations are described by ‘clustering’ functions $Z_{D}$ and $Z_{A}$, which are defined as:

$$ N_{D}^{*} = N_{D,0}Z_{D} = N_{D,0} \left[ 1 + \frac{N_{D,0}^{2}}{c_{D}N_{D,0}^{2} + N_{D,ref}^{2}} \right] $$ (276)

$$ N_{A}^{*} = N_{A,0}Z_{A} = N_{A,0} \left[ 1 + \frac{N_{A,0}^{2}}{c_{A}N_{A,0}^{2} + N_{A,ref}^{2}} \right] $$ (277)

The analytic functions $G(P_{i})$ and $F(P_{i})$ in Eq. 273 and Eq. 275 describe minority impurity and electron–hole scattering. They are given by:

$$ F(P_{i}) = \frac{0.7643P_{i}^{0.6478} + 2.2999 + 6.5502(m^{*}{}_{i}/m^{*}{}_{j})}{P_{i}^{0.6478} + 2.3670 - 0.8552(m^{*}{}_{i}/m^{*}{}_{j})} $$ (278)

and:

$$ G(P_{i}) = 1 - a_{g} \left[ b_{g} + P_{i} \left( \frac{m_{0}}{m^{*}{}_{i}} \frac{T}{300\text{ K}} \right)^{\alpha_{g}} \right]^{-\beta_{g}} + c_{g} \left[ P_{i} \left( \frac{m^{*}{}_{i}}{m_{0}} \frac{300\text{ K}}{T} \right)^{\alpha'_{g}} \right]^{-\gamma_{g}} $$ (279)

where $m^{*}{}_{i}$ denotes a fit parameter for carrier $i$ (which is related to the effective carrier mass) and $m^{*}{}_{j}$ denotes a fit parameter for the other carrier.

15: Mobility
Philips Unified Mobility Model

# Screening Parameter

The screening parameter $P_i$ is given by a weighted harmonic mean of the Brooks–Herring approach and Conwell–Weisskopf approach:

$$ P_i = \left[ \frac{f_{CW}}{3.97 \times 10^{13} \text{ cm}^{-2} N_{i, sc}^{-2/3}} + f_{BH} \frac{(n + p)}{1.36 \times 10^{20} \text{ cm}^{-3} m^*_i} \right]^{-1} \left( \frac{T}{300 \text{ K}} \right)^2 $$ (280)

The evaluation of $G(P_i)$ depends on the value of the screening parameter $P_i$. For values of $P_i < P_{i, \min}$, $G(P_{i, \min})$ is used instead of $G(P_i)$, where $P_{i, \min}$ is the value at which $G(P_i)$ reaches its minimum. If $G(P_{i, \min})$ is negative, which might happen in the model for the lattice temperature $T$ below 50 K, then $|G(P_{i, \min})|$ is used for $G(P_i) < |G(P_{i, \min})|$.

# Philips Model Parameters

Table 57 lists the built-in values for the parameters $a_g$, $b_g$, $c_g$, $\alpha_g$, $\alpha'_g$, $\beta_g$, and $\gamma_g$ in Eq. 279.

Table 57 Philips unified mobility model parameters

| Symbol | Value | Unit |
| --- | --- | --- |
| $a_g$ | 0.89233 | 1 |
| $b_g$ | 0.41372 | 1 |
| $c_g$ | 0.005978 | 1 |
| $\alpha_g$ | 0.28227 | 1 |
| $\alpha'_g$ | 0.72169 | 1 |
| $\beta_g$ | 0.19778 | 1 |
| $\gamma_g$ | 1.80618 | 1 |

Other parameters for the Philips unified mobility model are accessible in the parameter set `PhuMob`.

Table 58 and Table 59 on page 357 list the silicon defaults for other parameters. Sentaurus Device supports different parameters for electron mobility, which are optimized for situations where the dominant donor species in the silicon is either arsenic or phosphorus. The arsenic parameters are used by default.

15: Mobility
Mobility Degradation at Interfaces

Table 58 Philips unified mobility model: Electron and hole parameters (silicon)

| Symbol | Parameter name | Electrons (arsenic) | Electrons (phosphorus) | Holes (boron) | Unit |
| --- | --- | --- | --- | --- | --- |
| μmax | mumax_* | 1417 | 1414 | 470.5 | cm2/Vs |
| μmin | mumin_* | 52.2 | 68.5 | 44.9 | cm2/Vs |
| θ | theta_* | 2.285 | 2.285 | 2.247 | 1 |
| N{e,h},ref | n_ref_* | 9.68×1016 | 9.2×1016 | 2.23×1017 | cm−3 |
| α | alpha_* | 0.68 | 0.711 | 0.719 | 1 |

The original Philips unified mobility model uses four fit parameters: the weight factors f<sub>CW</sub> and f<sub>BH</sub>, and the ‘effective masses’ m<sup>*</sup><sub>e</sub> and m<sup>*</sup><sub>h</sub>. The optimal parameter set, determined by accurate fitting to experimental data [[11]]([11]) is shown in Table 59. The Philips unified mobility model can be slightly modified by setting parameters f<sub>e</sub> = 0 and f<sub>h</sub> = 0 as required for the Lucent mobility model (see Lucent Model on page 394).

Table 59 Philips unified mobility model: Other fitting parameters (silicon)

| Symbol | Parameter name | Value | Unit |
| --- | --- | --- | --- |
| m*e/m0 | me_over_m0 | 1 | 1 |
| m*h/m0 | mh_over_m0 | 1.258 | 1 |
| fCW | f_CW | 2.459 | 1 |
| fBH | f_BH | 3.828 | 1 |
| fe | f_e | 1.0 | 1 |
| fh | f_h | 1.0 | 1 |

# Mobility Degradation at Interfaces

In the channel region of a MOSFET, the high transverse electric field forces carriers to interact strongly with the semiconductor–insulator interface. Carriers are subjected to scattering by acoustic surface phonons and surface roughness. The models in this section describe mobility degradation caused by these effects.

## Using Mobility Degradation at Interfaces

To activate mobility degradation at interfaces, select a method to compute the transverse field F<sub>⊥</sub> (see Computing Transverse Field on page 380).

Mobility Degradation at Interfaces

To select the calculation of field perpendicular to the semiconductor–insulator interface, specify the `Enormal` option to `Mobility`:

```
Physics { Mobility ( Enormal ...) ...}
```

Alternatively, to select calculation of $F_{\perp}$ perpendicular to current flow, specify:

```
Physics { Mobility ( ToCurrentEnormal ...) ...}
```

To select a mobility degradation model, specify an option to `Enormal` or `ToCurrentEnormal`. Valid options are `Lombardi`, `IALMob`, `UniBo`, or a PMI model provided by users. In addition, one or more mobility degradation components can be specified, including `Coulomb2D`, `RCS`, `RPS`, `NegInterfaceCharge`, and `PosInterfaceCharge`. For example:

```
Physics { Mobility ( Enormal(UniBo) ...) ...}
```

selects the University of Bologna model (see University of Bologna Surface Mobility Model on page 370). The default model is `Lombardi` (see Enhanced Lombardi Model on page 359).

> **NOTE** The mobility degradation models discussed in this section are very sensitive to mesh spacing. It is recommended that you reduce the vertical mesh spacing to 0.1 nm in the silicon at the oxide interface underneath the gate. For the extensions of the `Lombardi` model (see Eq. 285, p. 359), even smaller spacing of 0.05 nm is appropriate. This fine spacing is required only in the two uppermost rows of mesh and can be increased progressively moving away from the interface.

You can use more than one interface degradation mobility model in a simulation. For example, it can be useful to include additional degradation components that are created as PMI models into the `Enormal` mobility calculation. When more than one model is specified as an option to `Enormal`, they are combined using Matthiessen’s rule. For example, the specification:

```
Physics { Mobility ( Enormal( Lombardi pmi_model1 pmi_model2) ...) ...}
```

calculates the total `Enormal` mobility using:

$$ \frac{1}{\mu_{\text{Enormal}}} = \frac{1}{\mu_{\text{Lombardi}}} + \frac{1}{\mu_{\text{pmi\_model1}}} + \frac{1}{\mu_{\text{pmi\_model2}}} \text{ (281)} $$

> **NOTE** By default, an absolute value of the transverse electric field is used in all interface degradation mobility models (see Computing Transverse Field on page 380). To define mobility degradation only for carriers that are pulled to the interface by the electric field, specify the option `MobEnormalSignDependence` in the `Math` section.

15: Mobility
Mobility Degradation at Interfaces

# Enhanced Lombardi Model

The surface contribution due to acoustic phonon scattering has the form:

$$ \mu_{\text{ac}} = \frac{B}{F_{\perp}} + \frac{C((N_{\text{A},0} + N_{\text{D},0} + N_2)/N_0)^{\lambda}}{F_{\perp}^{1/3}(T/300\,\text{K})^k} $$ (282)

and the contribution attributed to surface roughness scattering is given by:

$$ \mu_{\text{sr}} = \left( \frac{(F_{\perp}/F_{\text{ref}})^{A^*}}{\delta} + \frac{F_{\perp}^3}{\eta} \right)^{-1} $$ (283)

These surface contributions to the mobility ($\mu_{\text{ac}}$ and $\mu_{\text{sr}}$) are then combined with the bulk mobility $\mu_{\text{b}}$ according to Matthiessen’s rule (see Mobility due to Phonon Scattering on page 342 and Doping-Dependent Mobility Degradation on page 342):

$$ \frac{1}{\mu} = \frac{1}{\mu_{\text{b}}} + \frac{D}{\mu_{\text{ac}}} + \frac{D}{\mu_{\text{sr}}} $$ (284)

The reference field $F_{\text{ref}} = 1\text{ V/cm}$ ensures a unitless numerator in Eq. 283. $F_{\perp}$ is the transverse electric field normal to the semiconductor–insulator interface, see Computing Transverse Field on page 380. $D = \exp(-x/l_{\text{crit}})$ (where $x$ is the distance from the interface and $l_{\text{crit}}$ a fit parameter) is a damping that switches off the inversion layer terms far away from the interface. All other parameters are accessible in the parameter file.

In the Lombardi model [1], the exponent $A^*$ in Eq. 283 is equal to 2. According to another study [12], an improved fit to measured data is achieved if $A^*$ is given by:

$$ A^* = A + \frac{(\alpha_{\perp,n}n + \alpha_{\perp,p}p)N_{\text{ref}}^{\nu}}{(N_{\text{A},0} + N_{\text{D},0} + N_1)^{\nu}} $$ (285)

where $n$ and $p$ denote the electron and hole concentrations, respectively. For electron mobility, $\alpha_{\perp,n} = \alpha_{\perp}$ and $\alpha_{\perp,p} = \alpha_{\perp}a_{\text{other}}$; for hole mobility, $\alpha_{\perp,n} = \alpha_{\perp}a_{\text{other}}$ and $\alpha_{\perp,p} = \alpha_{\perp}$.

The reference doping concentration $N_{\text{ref}} = 1\text{ cm}^{-3}$ cancels the unit of the term raised to the power $\nu$ in the denominator of Eq. 285. The Lombardi model parameters are accessible in the parameter set `EnormalDependence`.

Table 60 on page 360 lists the respective default parameters that are appropriate for silicon. The parameters $B$, $C$, $N_0$, and $\lambda$ were fitted at SGS Thomson and are not in the literature [1].

Mobility Degradation at Interfaces

Table 60 Lombardi model: Default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $B$ | B | 4.75×10⁷ | 9.925×10⁶ | cm/s |
| $C$ | C | 5.80×10² | 2.947×10³ | cm⁵/³V⁻²/³s⁻¹ |
| $N_0$ | N0 | 1 | 1 | cm⁻³ |
| $N_2$ | N2 | 1 | 1 | cm⁻³ |
| $\lambda$ | lambda | 0.1250 | 0.0317 | 1 |
| $k$ | k | 1 | 1 | 1 |
| $\delta$ | delta | 5.82×10¹⁴ | 2.0546×10¹⁴ | cm²/Vs |
| $A$ | A | 2 | 2 | 1 |
| $\alpha_\perp$ | alpha | 0 | 0 | cm³ |
| $N_1$ | N1 | 1 | 1 | cm⁻³ |
| $\nu$ | nu | 1 | 1 | 1 |
| $\eta$ | eta | 5.82×10³⁰ | 2.0546×10³⁰ | V²cm⁻¹s⁻¹ |
| $a_{other}$ | aother | 0 | 0 | 1 |
| $l_{crit}$ | l_crit | 1×10⁻⁶ | 1×10⁻⁶ | cm |
| $a_{ac}$ | a_ac | 1.0 | 1.0 | 1 |
| $a_{sr}$ | a_sr | 1.0 | 1.0 | 1 |

The modifications of the Lombardi model suggested in [[12]]([12]) can be activated by setting $\alpha_\perp$ to a nonzero value.

Table 61 lists a consistent set of parameters for the modified model.

Table 61 Lombardi model: Lucent coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $B$ | B | 3.61×10⁷ | 1.51×10⁷ | cm/s |
| $C$ | C | 1.70×10⁴ | 4.18×10³ | cm⁵/³V⁻²/³s⁻¹ |
| $N_0$ | N0 | 1 | 1 | cm⁻³ |
| $N_2$ | N2 | 1 | 1 | cm⁻³ |
| $\lambda$ | lambda | 0.0233 | 0.0119 | 1 |
| $k$ | k | 1.7 | 0.9 | 1 |

15: Mobility

Mobility Degradation at Interfaces

Table 61 Lombardi model: Lucent coefficients for silicon (Continued)

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| δ | delta | 3.58×1018 | 4.10×1015 | cm2/Vs |
| A | A | 2.58 | 2.18 | 1 |
| α⊥ | alpha | 6.85×10–21 | 7.82×10–21 | cm3 |
| N1 | N1 | 1 | 1 | cm–3 |
| ν | nu | 0.0767 | 0.123 | 1 |
| η | eta | 1×1050 | 1×1050 | V2cm–1s–1 |
| aother | aother | 1 | 1 | 1 |
| lcrit | l_crit | 1 | 1 | cm |
| aac | a_ac | 1.0 | 1.0 | 1 |
| asr | a_sr | 1.0 | 1.0 | 1 |

## Stress Factors for Mobility Components

If isotropic stress-dependent mobility enhancement factors are applied to mobility components (see Factor Models Applied to Mobility Components on page 943), the Lombardi mobility components become:

$$ \begin{aligned} \mu'_{\text{ac}} &= \gamma_{\text{ac}}\mu_{\text{ac}} \quad , \quad \gamma_{\text{ac}} = 1 + a_{\text{ac}}(\gamma - 1) \\ \mu'_{\text{sr}} &= \gamma_{\text{sr}}\mu_{\text{sr}} \quad , \quad \gamma_{\text{sr}} = 1 + a_{\text{sr}}(\gamma - 1) \end{aligned} \eqno(286) $$

where $a_{\text{ac}}$ and $a_{\text{sr}}$ are stress scaling parameters that can be specified in the parameter set `EnormalDependence`, and $\gamma$ is an isotropic enhancement factor calculated from a stress-dependent Factor model (see Isotropic Factor Models on page 937).

## Named Parameter Sets for the Lombardi Model

The `EnormalDependence` parameter set can be named. For example, in the parameter file, you can write:

```
EnormalDependence "myset" { ... }
```

to declare a parameter set with the name `myset`. To use a named parameter set, specify its name with `ParameterSetName` as an option to `Lombardi` in the command file. For example:

```
Mobility (
  Enormal( Lombardi( ParameterSetName = "myset" ...) ...)
)
```

15: Mobility

Mobility Degradation at Interfaces

By default, the unnamed parameter set is used.

## Auto-Orientation for the Lombardi Model

The `Lombardi` model supports the auto-orientation framework (see Auto-Orientation Framework on page 38) that switches between different-named parameter sets based on the orientation of the nearest interface. This can be activated by specifying the `Lombardi` command file parameter `AutoOrientation`:

```
Mobility (
  Enormal( Lombardi( AutoOrientation ...) ...)
)
```

# Inversion and Accumulation Layer Mobility Model

The inversion and accumulation layer mobility (IALMob) model is based on the *unified* portion of the model described in [[13]]([13]). This model includes doping and transverse-field dependencies and is similar to the Lucent (Darwish) model [[12]]([12]), but it contains additional terms that account for *two-dimensional* Coulomb impurity scattering. The implementation of the IALMob model is based on modified versions of the Philips Unified Mobility Model on page 353 and the Enhanced Lombardi Model on page 359, but it is completely self-contained and all parameters associated with this model are specified independently of those models. A complete description is given here.

The following expressions apply to both electron mobility and hole mobility when the following substitutions are made:

$$ \text{Electron Mobility: } c = n, c_{\text{other}} = p, N_{\text{inv}} = N_{A,0}, N_{\text{acc}} = N_{D,0}, P = P_e, m^* = m_e^*, m_{\text{other}}^* = m_h^* $$
$$ \text{Hole Mobility: } c = p, c_{\text{other}} = n, N_{\text{inv}} = N_{D,0}, N_{\text{acc}} = N_{A,0}, P = P_h, m^* = m_h^*, m_{\text{other}}^* = m_e^* $$ (287)

The model has contributions from Coulomb impurity scattering, phonon scattering, and surface roughness scattering:

$$ \frac{1}{\mu} = \frac{1}{\mu_C} + \frac{1}{\mu_{ph}} + \frac{D}{\mu_{sr}} $$ (288)

where $D = \exp(-x/l_{\text{crit}})$ ($x$ is the distance from the interface).

## Coulomb Scattering

The Coulomb impurity scattering term has 2D and 3D contributions. The 2D contribution is primarily due to effects occurring near the interface and the 3D contribution is primarily due

15: Mobility
Mobility Degradation at Interfaces

to effects occurring in the bulk. These contributions are combined using a field-dependent function $f(F_{\perp}, t, T)$ and a distance factor $D_{C}$:

$$\mu_{C} = \mu_{C,3D}(1 - D_{C}) + D_{C}[f(F_{\perp}, t, T)\mu_{C,3D} + (1 - f(F_{\perp}, t, T))\mu_{C,2D}] \tag{289}$$

where:

$$f(F_{\perp}, t, T) = \frac{1}{1 + \exp \left( \frac{SF_{\perp}^{2/3}}{T} + \frac{S_{t}}{(t + t_{0})^{2}T} - p \right)} \tag{290}$$

and $D_{C} = \exp(-x/l_{\text{crit},C})$. In Eq. 290, $t$ is the local layer thickness (see Thickness Extraction on page 336), which is calculated automatically when using the ThinLayer mobility model (see Thin-Layer Mobility Model on page 381) or if the `LayerThickness` command in the `Physics` section is used to calculate layer thickness.

Two-dimensional Coulomb scattering has both inversion and accumulation layer contributions, and also includes a dependency on the local layer thickness:

$$\frac{1}{\mu_{C,2D}} = \text{erf} \left( \frac{t + t_{1}}{t_{\text{Coulomb}}} \right) \left( \frac{1}{\mu_{C,2D,\text{inv}}} + \frac{1}{\mu_{C,2D,\text{acc}}} \right) \tag{291}$$

where:

$$\mu_{C,2D,\text{inv}} = \left[ \left( \frac{D_{1,\text{inv}}(T/300\text{K})^{\alpha_{1,\text{inv}}}(c/N_{\text{sc,ref}})^{\nu_{0,\text{inv}}}}{(N_{\text{inv}}/N_{\text{dop,ref}})^{\nu_{1,\text{inv}}}} \right)^{2} + \left( \frac{D_{2,\text{inv}}(T/300\text{K})^{\alpha_{2,\text{inv}}}}{(N_{\text{inv}}/N_{\text{dop,ref}})^{\nu_{2,\text{inv}}}} \right)^{2} \right]^{-1/2} \tag{292}$$

$$\mu_{C,2D,\text{acc}} = \left[ \left( \frac{D_{1,\text{acc}}(T/300\text{K})^{\alpha_{1,\text{acc}}}(c/N_{\text{sc,ref}})^{\nu_{0,\text{acc}}}}{(N_{\text{acc}}/N_{\text{dop,ref}})^{\nu_{1,\text{acc}}}} \right)^{2} + \left( \frac{D_{2,\text{acc}}(T/300\text{K})^{\alpha_{2,\text{acc}}}}{(N_{\text{acc}}/N_{\text{dop,ref}})^{\nu_{2,\text{acc}}}} \right)^{2} \right]^{-1/2} G(P) \tag{293}$$

The 3D Coulomb scattering part of Eq. 289 is taken from the Philips unified mobility model (PhuMob) and is given by:

$$\mu_{C,3D} = \mu_{N} \left( \frac{N_{\text{sc}}}{N_{\text{sc,eff}}} \right) \left( \frac{N_{\text{ref}}}{N_{\text{sc}}} \right)^{\alpha} + \mu_{c} \left( \frac{c + c_{\text{other}}}{N_{\text{sc,eff}}} \right) \tag{294}$$

where:

$$\mu_{N} = \frac{\mu_{\text{max}}^{2}}{\mu_{\text{max}} - \mu_{\text{min}}} \left( \frac{T}{300\text{K}} \right)^{3\alpha - 1.5} \tag{295}$$

Mobility Degradation at Interfaces

$$ \mu_{c} = \frac{\mu_{\max} \mu_{\min}}{\mu_{\max} - \mu_{\min}} \left( \frac{300\text{K}}{T} \right)^{1/2} \tag{296} $$

$$ N_{\text{sc}} = N_{D}^{*} + N_{A}^{*} + c_{\text{other}} \tag{297} $$

$$ N_{\text{sc,eff}} = N_{\text{acc}}^{*} + G(P)N_{\text{inv}}^{*} + \frac{c_{\text{other}}}{F(P)} \tag{298} $$

In the previous expressions, quantities marked with an asterisk (*) indicate that the clustering formulas from the Philips unified mobility model are invoked:

$$ N_{D}^{*} = N_{D,0} \left[ 1 + \frac{N_{D,0}^{2}}{c_{D}N_{D,0}^{2} + N_{D,\text{ref}}^{2}} \right] \tag{299} $$

$$ N_{A}^{*} = N_{A,0} \left[ 1 + \frac{N_{A,0}^{2}}{c_{A}N_{A,0}^{2} + N_{A,\text{ref}}^{2}} \right] \tag{300} $$

Optionally, the clustering formulas can be used for all occurrences of $N_{A}$ and $N_{D}$ in the model by specifying the `IALMob` command file parameter `ClusteringEverywhere`.

The `AsPhPhuMob` option activates linear interpolation between the arsenic and phosphorus PhuMob parameter sets with respect to the arsenic and phosphorus concentrations.

The functions $F(P)$ and $G(P)$ describe electron–hole and minority impurity scattering, respectively, and $P$ is a screening parameter:

$$ F(P) = \frac{0.7643P^{0.6478} + 2.2999 + 6.5502(m^{*}/m_{\text{other}}^{*})}{P^{0.6478} + 2.3670 - 0.8552(m^{*}/m_{\text{other}}^{*})} \tag{301} $$

$$ G(P) = 1 - \frac{0.89233}{\left[ 0.41372 + P \left( \frac{m_{0}}{m^{*}} \frac{T}{300\text{K}} \right)^{0.28227} \right]^{0.19778}} + \frac{0.005978}{\left[ P \left( \frac{m^{*}}{m_{0}} \frac{300\text{K}}{T} \right)^{0.72169} \right]^{1.80618}} \tag{302} $$

$$ P = \left[ \frac{2.459}{3.97 \times 10^{13} \text{ cm}^{-2} N_{\text{sc}}^{-2/3}} + \frac{3.828(c + c_{\text{other}})(m_{0}/m^{*})}{1.36 \times 10^{20} \text{ cm}^{-3}} \right]^{-1} \left( \frac{T}{300\text{K}} \right)^{2} \tag{303} $$

By default, the full PhuMob model described by the previous expressions is used (`FullPhuMob`). However, the ‘other’ carrier in these expressions can be ignored ($c_{\text{other}} = 0$) by specifying `-FullPhuMob` in the command file. This specification also ignores the standard PhuMob modification of the $G(P)$ function, which invokes $G = G(P_{\min})$ for $P < P_{\min}$, where $P_{\min}$ is the value where $G(P)$ reaches its minimum. If $G(P_{\min})$ is negative, which might happen in

**15: Mobility**
Mobility Degradation at Interfaces

the model for the lattice temperature $T$ below 50 K, then $|G(P_{\text{min}})|$ is used for $G(P) < |G(P_{\text{min}})|$.

## Phonon Scattering

The phonon-scattering portion of Eq. 288 also has 2D and 3D parts. The way in which these parts are combined depends on the value of the `PhononCombination` parameter in the `IALMob` command file:

$$ \mu_{\text{ph}} = \begin{cases} \min \left\{ \frac{\mu_{\text{ph,2D}}}{D}, \mu_{\text{ph,3D}} \right\} & , \text{ PhononCombination=0} \\ \left[ \frac{D}{\mu_{\text{ph,2D}}} + \frac{1}{\mu_{\text{ph,3D}}} \right]^{-1} & , \text{ PhononCombination=1 (default)} \\ \left[ \frac{D}{\mu_{\text{ph,2D}}} + \frac{f(F_{\perp}, t, T)}{\mu_{\text{ph,3D}}} \right]^{-1} & , \text{ PhononCombination=2} \end{cases} \tag{304} $$

where:

$$ \mu_{\text{ph,2D}} = \frac{B}{F_{\perp}} + \frac{C \left( \alpha_{\text{ph,2D,A}} ((N_{\text{A,0}} + N_2/2) / 1 \text{ cm}^{-3})^{\lambda_{\text{ph,2D,A}}} + \alpha_{\text{ph,2D,D}} ((N_{\text{D,0}} + N_2/2) / 1 \text{ cm}^{-3})^{\lambda_{\text{ph,2D,D}}} \right)^{\lambda}}{F_{\perp}^{1/3} (T/300 \text{ K})^k} \tag{305} $$

$$ \mu_{\text{ph,3D}} = \mu_{\text{max}} \left( \frac{T}{300 \text{ K}} \right)^{-\theta} \tag{306} $$

## Surface Roughness Scattering

Surface roughness scattering is given by:

$$ \mu_{\text{sr}} = \frac{\left( \alpha_{\text{sr,A}} ((N_{\text{A,0}} + N_2/2) / 1 \text{ cm}^{-3})^{\lambda_{\text{sr,A}}} + \alpha_{\text{sr,D}} ((N_{\text{D,0}} + N_2/2) / 1 \text{ cm}^{-3})^{\lambda_{\text{sr,D}}} \right)^{\lambda_{\text{sr}}}}{\left( \frac{(F_{\perp} / 1 \text{ V/cm})^{A^*}}{\delta} + \frac{F_{\perp}^3}{\eta} \right)} \tag{307} $$

where:

$$ A^* = A + \frac{\alpha_{\perp} (n + p)}{((N_{\text{A,0}} + N_{\text{D,0}} + N_1) / 1 \text{ cm}^{-3})^{\nu}} \tag{308} $$

Mobility Degradation at Interfaces

## Parameters

Parameters associated with the model are accessible in the `IALMob` parameter set. Their values for silicon are shown in Table 62 and Table 63.

Table 62 IALMob parameters (part 1): Default coefficients for silicon

| Symbol | Parameter name | Value | Unit |
| --- | --- | --- | --- |
| – | EnormMinimum | 0.0 | V/cm |
| $N_{D,ref}$ | nref_D | $4 \times 10^{20}$ | cm−3 |
| $N_{A,ref}$ | nref_A | $7.2 \times 10^{20}$ | cm−3 |
| $c_D$ | cref_D | 0.21 | 1 |
| $c_A$ | cref_A | 0.5 | 1 |
| $m_e^* / m_0$ | me_over_m0 | 1.0 | 1 |
| $m_h^* / m_0$ | mh_over_m0 | 1.258 | 1 |

Table 63 IALMob parameters (part 2): Default coefficients for silicon

| Symbol | Parameter name | Electron value | Hole value | Unit |
| --- | --- | --- | --- | --- |
| $\mu_{max}$ | mumax | 1417.0 | 470.5 | cm2/(Vs) |
| $\mu_{min}$ | mumin | 52.2 | 44.9 | cm2/(Vs) |
| $\theta$ | theta | 2.285 | 2.247 | 1 |
| $N_{ref}$ | n_ref | $9.68 \times 10^{16}$ | $2.23 \times 10^{17}$ | cm−3 |
| $N_{dop,ref}$ | ndop_ref | $10^{18}$ | $10^{18}$ | cm−3 |
| $N_{sc,ref}$ | nsc_ref | $10^{18}$ | $10^{18}$ | cm−3 |
| $\alpha$ | alpha | 0.68 | 0.719 | 1 |
| $S$ | S | 0.3042 | 0.3042 | K(cm/V)2/3 |
| $S_t$ | S_t | 0.0 | 0.0 | K($\mu$m)2 |
| $t_0$ | t0 | 0.0005 | 0.0005 | $\mu$m |
| $p$ | p | 4.0 | 4.0 | 1 |
| $l_{crit,C}$ | l_crit_c | $10^3$ | $10^3$ | cm |
| $B$ | B | $9.0 \times 10^5$ | $9.0 \times 10^5$ | cm/s |
| $C$ | C | 4400.0 | 4400.0 | cm5/3/V2/3/s |
| $\lambda$ | lambda | 0.057 | 0.057 | 1 |

**15: Mobility**
Mobility Degradation at Interfaces

Table 63 IALMob parameters (part 2): Default coefficients for silicon (Continued)

| Symbol | Parameter name | Electron value | Hole value | Unit |
| --- | --- | --- | --- | --- |
| k | k | 1.0 | 1.0 | 1 |
| αph,2D,A | alpha_ph2d_A | 1.0 | 1.0 | 1 |
| αph,2D,D | alpha_ph2d_D | 1.0 | 1.0 | 1 |
| λph,2D,A | lambda_ph2d_A | 1.0 | 1.0 | 1 |
| λph,2D,D | lambda_ph2d_D | 1.0 | 1.0 | 1 |
| δ | delta | 3.97 × 1013 | 3.97 × 1013 | cm2/(Vs) |
| λsr | lambda_sr | 0.057 | 0.057 | 1 |
| A | A | 2.0 | 2.0 | 1 |
| α⊥ | alpha_sr | 0.0 | 0.0 | cm3 |
| ν | nu | 0.0 | 0.0 | 1 |
| η | eta | 1.0 × 1050 | 1.0 × 1050 | V2/cm/s |
| N1 | N1 | 1.0 | 1.0 | cm-3 |
| N2 | N2 | 1.0 | 1.0 | cm-3 |
| αsr,A | alpha_sr_A | 1.0 | 1.0 | 1 |
| αsr,D | alpha_sr_D | 1.0 | 1.0 | 1 |
| λsr,A | lambda_sr_A | 1.0 | 1.0 | 1 |
| λsr,D | lambda_sr_D | 1.0 | 1.0 | 1 |
| lcrit | l_crit | 103 | 103 | cm |
| D1,inv | D1_inv | 135.0 | 135.0 | cm2/(Vs) |
| D2,inv | D2_inv | 40.0 | 40.0 | cm2/(Vs) |
| ν0,inv | nu0_inv | 1.5 | 1.5 | 1 |
| ν1,inv | nu1_inv | 2.0 | 2.0 | 1 |
| ν2,inv | nu2_inv | 0.5 | 0.5 | 1 |
| α1,inv | alpha1_inv | 0.0 | 0.0 | 1 |
| α2,inv | alpha2_inv | 0.0 | 0.0 | 1 |
| D1,acc | D1_acc | 135.0 | 135.0 | cm2/(Vs) |
| D2,acc | D2_acc | 40.0 | 40.0 | cm2/(Vs) |

Mobility Degradation at Interfaces

Table 63 IALMob parameters (part 2): Default coefficients for silicon (Continued)

| Symbol | Parameter name | Electron value | Hole value | Unit |
| --- | --- | --- | --- | --- |
| ν0,acc | nu0_acc | 1.5 | 1.5 | 1 |
| ν1,acc | nu1_acc | 2.0 | 2.0 | 1 |
| ν2,acc | nu2_acc | 0.5 | 0.5 | 1 |
| α1,acc | alpha1_acc | 0.0 | 0.0 | 1 |
| α2,acc | alpha2_acc | 0.0 | 0.0 | 1 |
| tCoulomb | tcoulomb | 0.0 | 0.0 | μm |
| t1 | t1 | 0.0003 | 0.0003 | μm |
| aph,2D | a_ph2d | 1.0 | 1.0 | 1 |
| aph,3D | a_ph3d | 1.0 | 1.0 | 1 |
| aC,2D | a_c2d | 1.0 | 1.0 | 1 |
| aC,3D | a_c3d | 1.0 | 1.0 | 1 |
| asr | a_sr | 1.0 | 1.0 | 1 |

## Stress Factors for Mobility Components

If isotropic stress-dependent mobility enhancement factors are applied to mobility components (see Factor Models Applied to Mobility Components on page 943), the IALMob mobility components become:

$$ \mu'_{ph,2D} = \gamma_{ph,2D}\mu_{ph,2D} \text{ , } \gamma_{ph,2D} = 1 + a_{ph,2D}(\gamma - 1) $$
$$ \mu'_{ph,3D} = \gamma_{ph,3D}\mu_{ph,3D} \text{ , } \gamma_{ph,3D} = 1 + a_{ph,3D}(\gamma - 1) $$
$$ \mu'_{C,2D} = \gamma_{C,2D}\mu_{C,2D} \text{ , } \gamma_{C,2D} = 1 + a_{C,2D}(\gamma - 1) $$ (309)
$$ \mu'_{C,3D} = \gamma_{C,3D}\mu_{C,3D} \text{ , } \gamma_{C,3D} = 1 + a_{C,3D}(\gamma - 1) $$
$$ \mu'_{sr} = \gamma_{sr}\mu_{sr} \text{ , } \gamma_{sr} = 1 + a_{sr}(\gamma - 1) $$

where *a*<sub>ph,2D</sub>, *a*<sub>ph,3D</sub>, *a*<sub>C,2D</sub>, *a*<sub>C,3D</sub>, and *a*<sub>sr</sub> are stress scaling parameters that can be specified in the IALMob parameter set, and γ is an isotropic enhancement factor calculated from a stress-dependent `Factor` model (see Isotropic Factor Models on page 937).

**15: Mobility**
Mobility Degradation at Interfaces

# Using the Inversion and Accumulation Layer Mobility Model

The inversion and accumulation layer mobility model is selected by specifying the `IALMob` keyword as an argument to `Enormal` in the command file. No mobility `DopingDependence` should be specified, as this is already included in the model. It is also not necessary to specify `-ConstantMobility`, as this will be invoked automatically with `IALMob`.

For small values of $F_{\perp}$, the acoustic phonon and surface roughness components of `IALMob` make an insignificant contribution to the total mobility. If required, the parameter `EnormMinimum` can be specified (in the parameter file) to suppress the calculation of acoustic phonon scattering and surface roughness for $F_{\perp} < \text{EnormMinimum}$.

The complete model described in [13] is obtained by combining `IALMob` with the Hänsch model [14] for high-field saturation (see Extended Canali Model on page 388). For example:

```
Physics {
     Mobility (
          Enormal (IALMob)
          HighFieldSaturation
     )
}
```

To select the Hänsch model, specify the parameter $\alpha = 1$ in the `HighFieldDependence` section. In addition, the $\beta$ exponent in the Hänsch model is equal to 2, which can be specified by setting $\beta_{0} = 2$ and $\beta_{\text{exp}} = 0$:

```
HighFieldDependence {
     alpha   = 1.0, 1.0     # [1]
     beta0   = 2.0, 2.0     # [1]
     betaexp = 0.0, 0.0
}
```

## Named Parameter Sets for the IALMob Model

The `IALMob` parameter set can be named. For example, in the parameter file, you can write the following to declare a parameter set with the name `myset`:

```
IALMob "myset" { ... }
```

To use a named parameter set, specify its name with `ParameterSetName` as an option to `IALMob` in the command file. For example:

```
Mobility (
     Enormal( IALMob( ParameterSetName = "myset" ...) ...)
)
```

By default, the unnamed parameter set is used.

Mobility Degradation at Interfaces

## Auto-Orientation for the IALMob Model

The IALMob model supports the auto-orientation framework (see Auto-Orientation Framework on page 38) that switches between different named parameter sets based on the orientation of the nearest interface. This can be activated by specifying the IALMob command file parameter `AutoOrientation`:

```
Mobility (
  Enormal( IALMob( AutoOrientation ...) ...)
)
```

# University of Bologna Surface Mobility Model

The University of Bologna surface mobility model was developed for an extended temperature range between 25°C and 648°C. It should be used together with the University of Bologna bulk mobility model (see University of Bologna Bulk Mobility Model on page 346). The inversion layer mobility in MOSFETs is degraded by Coulomb scattering at low normal fields and by surface phonons and surface roughness scattering at large normal fields.

In the University of Bologna model [4], all these effects are combined by using Matthiessen’s rule:

$$ \frac{1}{\mu} = \frac{1}{\mu_{bsc}} + \frac{D}{\mu_{ac}} + \frac{D}{\mu_{sr}} \text{ (310)} $$

where $1/\mu_{bsc}$ is the contribution of Coulomb scattering, and $1/\mu_{ac}$ and $1/\mu_{sr}$ are those of surface phonons and surface roughness scattering, respectively. $D = \exp(-x/l_{crit})$ (where $x$ is the distance from the interface and $l_{crit}$ a fit parameter) is a damping that switches off the inversion layer terms far away from the interface.

The term $\mu_{bsc}$ is associated with substrate impurity and carrier concentration. It is decomposed in an unscreened part (due to the impurities) and a screened part (due to local excess carrier concentration):

$$ \mu_{bsc}^{-1} = \mu_b^{-1} \left[ D \left( \frac{1}{(1 + f_{sc}^\tau)^{1/\tau}} - 1 \right) + D_b \right] \text{ (311)} $$

where $\mu_b$ is given by the bulk mobility model, and $\tau$ is a fit parameter. The screening function is given by:

$$ f_{sc} = \left( \frac{N_1}{N_{A,0} + N_{D,0}} \right)^\eta \frac{N_{np}}{N_{A,0} + N_{D,0}} \text{ (312)} $$

15: Mobility
Mobility Degradation at Interfaces

where $N_{np}$ is a total carrier concentration which exceeds the electron and hole equilibrium concentrations ($n_{eq}$ and $p_{eq}$) and is computed as follows:

$$N_{np} = C_n^\alpha(n - n_{eq}) + C_p^\alpha(p - p_{eq})$$ (313)

where $C_{n,p}^\alpha$ are electron and hole concentration coefficients used in the mobility for a carrier $\alpha$ (electron or hole).

If surface mobility is plotted against the effective normal field, mobility data converges toward a universal curve. Deviations from this curve appear at the onset of weak inversion, and the threshold field changes with the impurity concentration at the semiconductor surface [15]. The term $\mu_{bsc}$ models these deviations, in that, it is the roll-off in the effective mobility characteristics. As the effective field increases, the mobilities become independent of the channel doping and approach the universal curve.

The main scattering mechanisms are, in this case, surface phonons and surface roughness scattering, which are expressed by:

$$\mu_{ac} = C(T) \left( \frac{N_{A,0} + N_{D,0}}{N_2} \right)^a \frac{1}{F_\perp^\delta}$$ (314)

$$\mu_{sr} = B(T) \left( \frac{N_{A,0} + N_{D,0} + N_3}{N_4} \right)^b \frac{1}{F_\perp^\lambda}$$ (315)

$F_\perp$ is the electric field normal to the semiconductor–insulator interface (see Computing Transverse Field on page 380).

Parameters for the model are accessible in the `UniBoEnormalDependence` parameter set. Table 64 lists the silicon default parameters. The reported parameters are detailed in the literature [16]. The model was calibrated with experiments [15][16] in the temperature range from 300 K to 700 K.

Table 64 Parameters of University of Bologna surface mobility model ($T_n = T/300\text{ K}$)

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $N_1$ | N1 | $2.34 \times 10^{16}$ | $2.02 \times 10^{16}$ | cm$^{-3}$ |
| $N_2$ | N2 | $4.0 \times 10^{15}$ | $7.8 \times 10^{15}$ | cm$^{-3}$ |
| $N_3$ | N3 | $1.0 \times 10^{17}$ | $2.0 \times 10^{15}$ | cm$^{-3}$ |
| $N_4$ | N4 | $2.4 \times 10^{18}$ | $6.6 \times 10^{17}$ | cm$^{-3}$ |
| $B$ | B | $5.8 \times 10^{18} \cdot T_n^{\gamma_B}$ | $7.82 \times 10^{15} \cdot T_n^{\gamma_B}$ | cm$^2$/Vs |
| $\gamma_B$ | B_exp | 0 | 1.4 | 1 |

Mobility Degradation at Interfaces

Table 64 Parameters of University of Bologna surface mobility model ($T_n = T/300\text{ K}$)

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $C$ | c | $1.86 \times 10^4 T_n^{-\gamma_C}$ | $5.726 \times 10^3 T_n^{-\gamma_C}$ | cm$^2$/Vs |
| $\gamma_C$ | C_exp | 2.1 | 1.3 | 1 |
| $\tau$ | tau | 1 | 3 | 1 |
| $C_{n,p}^{electron}$ | c_ele | 1 | 0 | 1 |
| $C_{n,p}^{hole}$ | c_hole | 0 | 1 | 1 |
| $\eta$ | eta | 0.3 | 0.5 | 1 |
| $a$ | ac_exp | 0.026 | $-0.02$ | 1 |
| $b$ | sr_exp | 0.11 | 0.08 | 1 |
| $l_{crit}$ | l_crit | $1 \times 10^{-6}$ | $1 \times 10^{-6}$ | cm |
| $\delta$ | delta | 0.29 | 0.3 | 1 |
| $\lambda$ | lambda | 2.64 | 2.24 | 1 |
| $D_b$ | a | 0 | 0 | 1 |

**NOTE** Eq. 314 and Eq. 315 have a root dependence on $F_\perp$ and, for a relatively small $F_\perp$, this might lead to numeric instabilities. To resolve that, you can specify `MobEnormalUniboRegularizationField=1000` [V/cm] in the `Math` section. Simulation results are not affected by this setting if practically useful $F_\perp$ is higher than the regularization field defined by such a setting.

# Mobility Degradation Components due to Coulomb Scattering

Different mobility degradation components due to Coulomb scattering are available in Sentaurus Device that can be combined with other interface mobility degradation models:

*   **NegInterfaceCharge** accounts for mobility degradation due to a negative interface charge (from charged traps and fixed charge).

*   **PosInterfaceCharge** accounts for mobility degradation due to a positive interface charge (from charged traps and fixed charge).

*   **Coulomb2D** accounts for mobility degradation due to ionized impurities near the interface.

Mobility Degradation at Interfaces

These degradation components can be specified separately or in combination with each other. If specified, they will be combined using Matthiessen’s rule:

$$ \frac{1}{\mu} = \frac{1}{\mu_{\text{other}}} + \frac{1}{\mu_{\text{nic}}} + \frac{1}{\mu_{\text{pic}}} + \frac{1}{\mu_{\text{C2D}}} $$ (316)

where:

*   $\mu_{\text{other}}$ represents the other DopingDependence and Enormal models specified for the simulation.

*   $\mu_{\text{nic}}$ represents the NegInterfaceCharge mobility degradation component.

*   $\mu_{\text{pic}}$ represents the PosInterfaceCharge mobility degradation component.

*   $\mu_{\text{C2D}}$ represents the Coulomb2D mobility degradation component.

The general form of the mobility degradation components due to Coulomb scattering is given by:

$$ \mu_C = \frac{\mu_1 \left( \frac{T}{300 \text{ K}} \right)^k \left\{ 1 + \left[ c / \left( c_{\text{trans}} \left( \frac{N_{A,D} + N_1}{10^{18} \text{cm}^{-3}} \right)^{\gamma_1} \left( \frac{N_{\text{coulomb}}}{N_0} \right)^{\eta_1} \right) \right]^\nu \right\} }{\left( \frac{N_{A,D} + N_2}{10^{18} \text{cm}^{-3}} \right)^{\gamma_2} \left( \frac{N_{\text{coulomb}}}{N_0} \right)^{\eta_2} \cdot D \cdot f(F_\perp)} $$ (317)

where:

*   $N_{\text{coulomb}} = \begin{cases} \text{negative interface charge density,} & \text{for the NegInterfaceCharge component} \\ \text{positive interface charge density,} & \text{for the PosInterfaceCharge component} \\ \text{local } N_{A,D}, & \text{for the Coulomb2D component} \end{cases}$

*   $N_0 = \begin{cases} 10^{11} \text{cm}^{-2}, & \text{for the Neg/PosInterfaceCharge components} \\ 10^{18} \text{cm}^{-3}, & \text{for the Coulomb2D component} \end{cases}$

*   $c = n$ (electron mobility) or $p$ (hole mobility)

*   $N_{A,D} = N_{A,0}$ (electron mobility) or $N_{D,0}$ (hole mobility)

and:

$$ f(F_\perp) = 1 - \exp[-(F_\perp / E_0)^\gamma] $$ (318)

$$ D = \exp(-x / l_{\text{crit}}) $$ (319)

In Eq. 319, $x$ is the distance from the interface.

Mobility Degradation at Interfaces

Parameters associated with the components are accessible in the parameter sets `NegInterfaceChargeMobility`, `PosInterfaceChargeMobility`, and `Coulomb2DMobility`. Table 65 lists their default values.

Table 65 Parameters for mobility degradation components due to Coulomb scattering

| Symbol | Parameter name | μnic | μpic | μC2D | Unit |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Electron | Hole | Electron | Hole | Electron | Hole |  |  |  |
| μ1 | mu1 | 40.0 | 40.0 | 40.0 | 40.0 | 40.0 | 40.0 | cm2V−1s−1 |
| k | T_exp | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1 |
| ctrans | c_trans | 1018 | 1018 | 1018 | 1018 | 1018 | 1018 | cm−3 |
| ν | c_exp | 1.5 | 1.5 | 1.5 | 1.5 | 1.5 | 1.5 | 1 |
| η1 | Nc_exp1 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1 |
| η2 | Nc_exp2 | 0.5 | 0.5 | 0.5 | 0.5 | 0.5 | 0.5 | 1 |
| N1 | N1 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | cm−3 |
| N2 | N2 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | cm−3 |
| γ1 | N_exp1 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 1 |
| γ2 | N_exp2 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 | 1 |
| lcrit | l_crit | 10−6 | 10−6 | 10−6 | 10−6 | 10−6 | 10−6 | cm |
| E0 | E0 | 2.0×105 | 2.0×105 | 2.0×105 | 2.0×105 | 2.0×105 | 2.0×105 | V/cm |
| γ | En_exp | 2.0 | 2.0 | 2.0 | 2.0 | 2.0 | 2.0 | 1 |
| aC | a_c | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1.0 | 1 |

## Stress Factors for Mobility Components

If isotropic stress-dependent mobility enhancement factors are applied to mobility components (see Factor Models Applied to Mobility Components on page 943), the Coulomb degradation component becomes:

$$ \mu'_C = \gamma_C \mu_C, \gamma_C = 1 + a_C(\gamma - 1) $$ (320)

where $a_C$ is a stress scaling parameter that can be specified in the `NegInterfaceChargeMobility`, `PosInterfaceChargeMobility`, or `Coulomb2DMobility` parameter set, and $\gamma$ is an isotropic enhancement factor calculated from a stress-dependent Factor model (see Isotropic Factor Models on page 937).

15: Mobility

Mobility Degradation at Interfaces

# Using Mobility Degradation Components

The `Coulomb2D` model is a local model that uses local values of $N_{\text{A}}$ and $N_{\text{D}}$. To use this model, specify `Coulomb2D` in addition to the standard `Enormal` model. For example:

```
Physics {
  Mobility (
    PhuMob HighFieldSaturation
    Enormal (Lombardi Coulomb2D)
  )
}
```

The `NegInterfaceCharge` and `PosInterfaceCharge` models are nonlocal models because $N_{\text{C}}$ used in these models is a charge density at a location that might be different from the point where mobility is being calculated.

If `Math{-GeometricDistances}` is not specified, $N_{\text{coulomb}}$ is the charge density at the point on the interface that is the closest distance to the point where mobility is being calculated. If there is not a vertex at this interface point, $N_{\text{coulomb}}$ is interpolated from the charge density at the surrounding vertices.

If `Math{-GeometricDistances}` is specified, $N_{\text{coulomb}}$ is the charge density at the vertex on the interface that is the closest distance to the point where mobility is being calculated.

To use these models, specify `NegInterfaceCharge`, or `PosInterfaceCharge`, or both in addition to a standard `Enormal` model. For convenience, both models can be specified with the single keyword `InterfaceCharge`. For example:

```
Physics {
  Mobility (
    PhuMob HighFieldSaturation
    Enormal (Lombardi InterfaceCharge)
  )
}
```

> **NOTE** When using mobility degradation components, a standard `Enormal` model (such as `Lombardi`) must be specified explicitly in addition to the mobility degradation component. Sentaurus Device will not include the Lombardi model by default (this only occurs when `Enormal` is specified with no arguments).

By default, the `NegInterfaceCharge` and `PosInterfaceCharge` models use the charge density $N_{\text{coulomb}}$ located at the nearest semiconductor–insulator interface. Alternatively, these models can use the charge density at the nearest user-defined surface by specifying the surface name as an argument to the interface charge model.

Mobility Degradation at Interfaces

For example:

```
Physics {
  Mobility (
    PhuMob HighFieldSaturation
    Enormal (Lombardi
      NegInterfaceCharge(SurfaceName="S1")
      PosInterfaceCharge(SurfaceName="S2")
      ...
    )
  )
}
```

Surfaces are defined in the global `Math` section and represent the union of an arbitrary number of interfaces. The following example specifies a surface named S1 that consists of all the HfO<sub>2</sub>–oxide interfaces, as well as the region_1–region_2 interface:

```
Math {
  Surface "S1" (
    MaterialInterface="HfO2/Oxide"
    RegionInterface="region_1/region_2"
  )
}
```

## Remote Coulomb Scattering Model

High-k gate dielectrics are being considered as an alternative to SiO<sub>2</sub> to reduce unacceptable leakage currents as transistor dimensions decrease. One obstacle when using high-k gate dielectrics is that a degraded carrier mobility is often observed for such devices. Although the causes of high-k mobility degradation are not completely understood, a possible contributor is remote Coulomb scattering (RCS).

Sentaurus Device provides an empirical model for RCS degradation that can be combined with other `Enormal` models using Matthiessen’s rule:

$$ \frac{1}{\mu_{\text{Enormal}}} = \frac{1}{\mu_{\text{Enormal}_1}} + \frac{1}{\mu_{\text{Enormal}_2}} + ... + \frac{D_{\text{rcs}} D_{\text{rcs\_highk}}}{\mu_{\text{rcs}}} \text{ (321)} $$

The RCS model is taken from [17] and accounts for the mobility degradation observed with HfSiON MISFETs. This is attributed to RCS:

$$ \mu_{\text{rcs}} = \mu_{\text{rcs0}} \left( \frac{N_{\text{A, D}}}{3 \times 10^{16} \text{ cm}^{-3}} \right)^{\gamma_1} \left( \frac{T}{300 \text{ K}} \right)^{\gamma_2} (g_{\text{screening}})^{\gamma_3 + \gamma_4 \cdot \ln \left( \frac{N_{\text{A, D}}}{3 \times 10^{16} \text{ cm}^{-3}} \right)} / f(F_{\perp}) \text{ (322)} $$

15: Mobility
Mobility Degradation at Interfaces

where $N_{A,D} = N_{A,0}$ (electron mobility) or $N_{D,0}$ (hole mobility).

In Eq. 322, the $g_{\text{screening}}$ factor accounts for screening of the remote charge by carriers. In [17], this is expressed in terms of the inversion charge density. Here, a local expression that depends on carrier concentration is used:

$$g_{\text{screening}} = s + \frac{c}{c_0 \left( \frac{N_{A,D}}{3 \times 10^{16} \text{ cm}^{-3}} \right)^{\gamma_5}}$$ (323)

In Eq. 323, $c$ is the carrier concentration ($n$ for electron mobility and $p$ for hole mobility), and $s$, $c_0$, and $\gamma_5$ are parameters.

In Eq. 322, $f(F_{\perp})$ is a function that confines the degradation to areas of the structure where $F_{\perp}$ is large enough to initiate inversion:

$$f(F_{\perp}) = 1 - \exp(-\xi F_{\perp} / N_{\text{depl}})$$ (324)

In the above expression, $N_{\text{depl}}$ is a doping- and temperature-dependent approximation for the depletion charge density [cm<sup>-2</sup>].

The distance factors used in Eq. 321 are given by:

$$D_{\text{rcs}} = \exp(-(\text{dist} + d_{\text{crit}}) / l_{\text{crit}})$$ (325)

$$D_{\text{rcs\_highk}} = \exp(-\text{dist}_{\text{highk}} / l_{\text{crit\_highk}})$$ (326)

In these expressions, dist is the distance from the nearest semiconductor–insulator interface, and dist<sub>highk</sub> is the distance from the nearest high-k insulator. If no high-k insulator is found in the structure, $D_{\text{rcs\_highk}} = 1$.

Parameters used in the RCS model are accessible in the `RCSMobility` parameter set in the parameter file. Values for silicon are shown in Table 66.

Table 66 RCSMobility parameters: Default coefficients for silicon

| Symbol | Parameter name | Electron value | Hole value | Unit |
| --- | --- | --- | --- | --- |
| μrcs0 | murcs0 | 149.0 | 149.0 | cm2/Vs |
| γ1 | gamma1 | -0.23187 | -0.23187 | 1 |
| γ2 | gamma2 | 2.1 | 2.1 | 1 |
| γ3 | gamma3 | 0.40 | 0.40 | 1 |
| γ4 | gamma4 | 0.05 | 0.05 | 1 |

Mobility Degradation at Interfaces

Table 66 RCSMobility parameters: Default coefficients for silicon (Continued)

| Symbol | Parameter name | Electron value | Hole value | Unit |
| --- | --- | --- | --- | --- |
| γ5 | gamma5 | 1.0 | 1.0 | 1 |
| s | s | 0.1 | 0.1 | 1 |
| c0 | c0 | 3.0 × 1016 | 3.0 × 1016 | cm-3 |
| dcrit | d_crit | 0.0 | 0.0 | cm |
| lcrit | l_crit | 1 × 10-6 | 1 × 10-6 | cm |
| lcrit_highk | l_crit_highk | 1 × 106 | 1 × 106 | cm |
| ξ | xi | 1.3042 × 107 | 1.3042 × 107 | V-1cm-1 |
| arcs | a_rcs | 1.0 | 1.0 | 1 |

## Stress Factors for Mobility Components

If isotropic stress-dependent mobility enhancement factors are applied to mobility components (see Factor Models Applied to Mobility Components on page 943), the RCS degradation becomes:

$$ \mu'_{rcs} = \gamma_{rcs}\mu_{rcs} \text{ , } \gamma_{rcs} = 1 + a_{rcs}(\gamma - 1) \eqno(327) $$

where $a_{rcs}$ is a stress scaling parameter that can be specified in the `RCSMobility` parameter set, and $\gamma$ is an isotropic enhancement factor calculated from a stress-dependent Factor model (see Isotropic Factor Models on page 937).

## Remote Phonon Scattering Model

Sentaurus Device also provides a simple empirical model for remote phonon scattering (RPS) degradation that can be combined with other `Enormal` models using Matthiessen’s rule:

$$ \frac{1}{\mu_{Enormal}} = \frac{1}{\mu_{Enormal_1}} + \frac{1}{\mu_{Enormal_2}} + ... + \frac{D_{rps}D_{rps\_highk}}{\mu_{rps}} \eqno(328) $$

The RPS model is extracted from figures in [[18]](reference_18) and accounts for a portion of the mobility degradation observed with HfO<sub>2</sub>-gated MOSFETs. This term is attributed to RPS:

$$ \mu_{rps} = \frac{\mu_{rps0}}{\left( \frac{F_{\perp}}{10^6 \text{ V/cm}} \right)^{\gamma_1} \left( \frac{T}{300 \text{ K}} \right)^{\gamma_2}} \eqno(329) $$

**15: Mobility**
Mobility Degradation at Interfaces

The distance factors used in Eq. 328 are given by:

$$ D_{\text{rps}} = \exp(-(\text{dist} + d_{\text{crit}}) / l_{\text{crit}}) $$ (330)

$$ D_{\text{rps\_highk}} = \exp(-\text{dist}_{\text{highk}} / l_{\text{crit\_highk}}) $$ (331)

In these expressions, dist is the distance from the nearest semiconductor–insulator interface, and dist<sub>highk</sub> is the distance from the nearest high-k insulator. If no high-k insulator is found in the structure, $D_{\text{rps\_highk}} = 1$.

Parameters used in the RPS model are accessible in the `RPSMobility` parameter set in the parameter file. Values for silicon are shown in Table 67.

Table 67 RPSMobility parameters: Default coefficients for silicon

| Symbol | Parameter Name | Electron value | Hole value | Unit |
| --- | --- | --- | --- | --- |
| μrps0 | murps0 | 496.7 | 496.7 | cm2/Vs |
| γ1 | gamma1 | 0.68 | 0.68 | 1 |
| γ2 | gamm2 | 0.34 | 0.34 | 1 |
| dcrit | d_crit | 0.0 | 0.0 | cm |
| lcrit | l_crit | 1 × 10-6 | 1 × 10-6 | cm |
| lcrit_highk | l_crit_highk | 1 × 106 | 1 × 106 | cm |
| arps | a_rcs | 1.0 | 1.0 | 1 |

# Stress Factors for Mobility Components

If isotropic stress-dependent mobility enhancement factors are applied to mobility components (see Factor Models Applied to Mobility Components on page 943), the `RPS` degradation becomes:

$$ \mu'_{\text{rps}} = \gamma_{\text{rps}}\mu_{\text{rps}} \quad , \quad \gamma_{\text{rps}} = 1 + a_{\text{rps}}(\gamma - 1) $$ (332)

where $a_{\text{rps}}$ is a stress scaling parameter that can be specified in the `RPSMobility` parameter set, and $\gamma$ is an isotropic enhancement factor calculated from a stress-dependent `Factor` model (see Isotropic Factor Models on page 937).

15: Mobility

Mobility Degradation at Interfaces

# Computing Transverse Field

Sentaurus Device supports two different methods for computing the normal electric field $F_{\perp}$:

*   Using the normal to the interface

*   Using the normal to the current

For vertices at the interface, an optional correction $F_{\text{corr}}$ for the field value is also available.

## Normal to the Interface

Assume that mobility degradation occurs at an interface $\Gamma$. By default, the distance to the interface is the true geometric distance, and $\hat{n}$ is the gradient of the distance to the interface. When the `-GeometricDistances` option is specified in the `Math` section, for a given point $\vec{r}$, Sentaurus Device locates the nearest vertex $\vec{r}_i$ on the interface $\Gamma$, approximates the distance of $\vec{r}$ to the interface by the distance to $\vec{r}_i$, and determines the direction $\hat{n}$ normal to the interface at vertex $\vec{r}_i$. From $\hat{n}$, the normal electric field is:

$$F_{\perp}(\vec{r}) = \left| \vec{F}(\vec{r}) \cdot \hat{n} + F_{\text{corr}} \right| \hfill (333)$$

To activate the Lombardi model with this method of computing $F_{\perp}$, specify the `Enormal` flag to `Mobility`. The keyword `ToInterfaceEnormal` is synonymous with `Enormal`.

By default, the interface $\Gamma$ is a semiconductor–insulator interface. Sometimes, it is important to change this default interface definition, for example, when the insulator (oxide) is considered a wide-bandgap semiconductor. In this case, Sentaurus Device allows this interface to be specified with `EnormalInterface` in the `Math` section.

In the following example, Sentaurus Device takes as $\Gamma$ the union of interfaces between materials, OxideAsSemiconductor and Silicon, and regions, regionK1 and regionL1:

```
Math {
  EnormalInterface (
    regioninterface=["regionK1/regionL1"],
    materialinterface=["OxideAsSemiconductor/Silicon"]
  )
}
```

15: Mobility
Thin-Layer Mobility Model

## Normal to the Current Flow

Using this method, $F_{\perp}(\vec{r})$ is defined as the component of the electric field normal to the electron ($c = n$) or hole ($c = p$) currents $\vec{J}_c(\vec{r})$:

$$ F_{c, \perp}(\vec{r}) = F(\vec{r}) \sqrt{1 - \left( \frac{\vec{F}(\vec{r}) \cdot \vec{J}_c(\vec{r})}{F(\vec{r}) J_c(\vec{r})} \right)^2} + F_{\text{corr}} $$ (334)

where $F_{n, \perp}$ is used for the evaluation of electron mobility and $F_{p, \perp}$ is used for the evaluation of hole mobility. Through corrections of the current, $F_{n, \perp}$ and $F_{p, \perp}$ also are affected by the keyword `ParallelToInterfaceInBoundaryLayer` (see Field Correction Close to Interfaces on page 400).

> **NOTE** For very low current levels, the computation of the electric field component normal to the currents might be numerically problematic and lead to convergence problems. It is recommended to use the option `Enormal`. Besides possible numeric problems, both approaches give the same or very similar results.

## Field Correction on Interface

For vertices on the interface, due to discretization, the normal electric field in inversion is underestimated systematically due to screening by the charge at the same vertex. Therefore, Sentaurus Device supports a correction of the field:

$$ F_{\text{corr}}(\vec{r}) = \frac{\alpha l \rho(\vec{r})}{\varepsilon} $$ (335)

where $\alpha$ is dimensionless and is specified with `NormalFieldCorrection` in the `Math` section (reasonable values range from 0 to 1; the default is zero), $\rho$ is the space charge, $\varepsilon$ is the dielectric constant in the semiconductor, and $l$ is an estimate for the depth of the box of the vertex in the normal direction.

# Thin-Layer Mobility Model

The thin-layer mobility model applies to devices with silicon layers that are only a few nanometers thick. In such devices, geometric quantization leads to a mobility that cannot be expressed with a normal field-dependent interface model such as those described in Mobility Degradation at Interfaces on page 357, but it depends explicitly on the layer thickness.

Thin-Layer Mobility Model

The thin-layer mobility model described here is based on the model described in the literature [19] and is used in conjunction with either the Lombardi model (see Enhanced Lombardi Model on page 359) or the `IALMob` model (see Inversion and Accumulation Layer Mobility Model on page 362).

> **NOTE** When using the thin-layer mobility model in conjunction with the Lombardi model, it is recommended to also use the Philips Unified Mobility Model on page 353. The Philips unified mobility model must be activated separately from the thin-layer mobility model.

The thin-layer mobility $\mu_{\text{tl}}$ consists of contributions of thickness fluctuation scattering, surface phonon scattering, bulk phonon scattering, and additional contributions from the normal field-dependent interface model used in conjunction with it:

$$ \frac{1}{\mu_{\text{tl}}} = \frac{D}{\mu_{\text{tf}}} + \frac{D}{\mu_{\text{sp}}} + \frac{D}{\mu_{\text{bp}}} + \begin{cases} \frac{D}{\mu_{\text{sr}}} & \text{, Lombardi} \\ \frac{D}{\mu_{\text{sr}}} + \frac{1}{\mu_{\text{ph,3D}}} + \frac{1}{\mu_{\text{C}}} & \text{, IALMob} \end{cases} \tag{336} $$

where:

* $D = \exp(-x/l_{\text{crit}})$ (see Enhanced Lombardi Model on page 359 (Lombardi) or Inversion and Accumulation Layer Mobility Model on page 362 (IALMob)).

* $\mu_{\text{sr}}$ is given by Eq. 283, p. 359 (Lombardi) or Eq. 307, p. 365 (IALMob).

* $\mu_{\text{ph,3D}}$ is given by Eq. 306, p. 365 (IALMob).

* $\mu_{\text{C}}$ is given by Eq. 292, p. 363 (IALMob).

The thickness fluctuation term is given by:

$$ \frac{1}{\mu_{\text{tf}}} = \frac{1}{\mu_{\text{tf0}}(t_b/1\text{ nm})^{\eta_1} \left[ 1 + \left( \frac{F_{\perp}}{F_{\text{tf0}}} \right)^{\eta_2} \right]} + \frac{1}{\mu_{\text{tfh0}}(t_b/1\text{ nm})^{\eta_1} \left( \frac{F_{\text{tfh0}}}{F_{\perp}} \right)} \tag{337} $$

The surface phonon term is given by:

$$ \mu_{\text{sp}} = \mu_{\text{sp0}} \exp(t_b/t_{\text{sp0}}) \tag{338} $$

The bulk phonon term is given by:

$$ \mu_{\text{bp}} = P_1 \mu_{\text{ac, 1}} + (1 - P_1) \mu_{\text{ac, 2}} \tag{339} $$

$$ P_1 = p_1 + \frac{1 - p_1}{1 + p_2 \exp(-p_3 \Delta E / kT)} \tag{340} $$

**15: Mobility**
Thin-Layer Mobility Model

$$ \Delta E = \frac{\hbar^2 \pi^2}{2 t_b^2} \left( \frac{1}{m_{z2}} - \frac{1}{m_{z1}} \right) \eqno(341) $$

$$ \mu_{ac, \nu} = \frac{\mu_{ac0, \nu}}{[1 + (W_{T\nu} / W_{F\nu})^\beta]^{1/\beta}} \left( \frac{W_{T\nu}}{1 \text{ nm}} \right) \eqno(342) $$

$$ W_{T\nu} = \frac{2}{3} t_b + W_{T0\nu} \left( \frac{t_b}{1 \text{ nm}} \right)^4 \left( \frac{F_\perp}{1 \text{ MV/cm}} \right) \eqno(343) $$

$$ \frac{W_{F\nu}}{1 \text{ nm}} = \zeta^{\nu - 1} \frac{\mu_{ac}}{P_{bulk} \mu_{ac0, 1} + \zeta (1 - P_{bulk}) \mu_{ac0, 2}} \eqno(344) $$

where:

* $\mu_{ac}$ is given by Eq. 282, p. 359 (Lombardi) or by $\mu_{ph,2D}$ Eq. 305, p. 365 (IALMob).

* $P_{bulk} = p_1 + (1 - p_1) / (1 + p_2)$.

* The thickness $t_b$ is the larger of the local layer thickness and $t_{min}$.

* $t_{min}$, $\mu_{tf0}$, $F_{tf0}$, $\mu_{tfh0}$, $F_{tfh0}$, $\eta_1$, $\eta_2$, $\mu_{sp0}$, $t_{sp0}$, $\mu_{ac0, \nu}$, $p_1$, $p_2$, $p_3$, $m_{z1}$, $m_{z2}$, $\beta$, $W_{T0\nu}$, and $\zeta$ are model parameters.

# Using the Thin-Layer Mobility Model

To activate the thin-layer mobility model, specify `ThinLayer(<parameters>)` as an option to `eMobility`, `hMobility`, or `Mobility`. The optional parameters are `<geo_parameters>` and `<physical_parameters>`.

The `ThinLayer` subcommand has the same `<geo_parameters>` as the `LayerThickness` command (see Extracting Layer Thickness on page 333).

## Physical Parameters

Specify `Lombardi` or `IALMob` (including any optional arguments for these models) as an option to `ThinLayer` to indicate which normal field-dependent interface model is used in conjunction with the thin-layer mobility calculations (`Lombardi` is the default). For example:

```
Physics {
  Mobility (
    PhuMob
    ThinLayer (Lombardi(...))
  )
}
```

Thin-Layer Mobility Model

or:
```
Physics {
  Mobility (
    ThinLayer (IALMob(...))
  )
}
```

**NOTE** When using `ThinLayer(Lombardi)` or `ThinLayer(IALMob)`, do not specify `Enormal(Lombardi)` or `Enormal(IALMob)` in addition. This would result in double-counting the scattering mechanisms that are already accounted for (see Eq. 336). However, `Enormal` must still be used to include other required degradation terms. For example:

```
Physics {
  Mobility ( ThinLayer (IALMob(...))
             Enormal (InterfaceCharge)
  )
}
```

When `ThinLayer(Lombardi(...))` is specified, the parameters to compute $D$, $\mu_{sr}$, and $\mu_{ac}$ are the same as used for the Lombardi model (see Table 60 on page 360 and Table 61 on page 360). Synopsys considers the parameters in Table 61 to be more suitable for the thin-layer mobility model; however, the defaults are still given in Table 60.

When `ThinLayer(IALMob(...))` is specified, the parameters to compute $D$, $\mu_{sr}$, $\mu_{ph,3D}$, $\mu_C$, and $\mu_{ph,2D}$ are the same as used for the IALMob model (see Table 62 on page 366 and Table 63 on page 366).

The other parameters are specified as electron–hole pairs in the `ThinLayerMobility` parameter set. Table 68 summarizes the parameters.

## Table 68 Parameters for thin-layer mobility model

| Symbol | Parameter name | Electron | Hole | Unit |
| --- | --- | --- | --- | --- |
| $t_{min}$ | tmin | 0.002 | 0.002 | μm |
| $\mu_{tf0}$ | mutf0 | 0.15 | 0.28 | cm$^2$V$^{-1}$s$^{-1}$ |
| $F_{tf0}$ | ftf0 | 6250 | 10$^{100}$ | Vcm$^{-1}$ |
| $\mu_{tfh0}$ | mutfh0 | 10$^6$ | 10$^6$ | cm$^2$V$^{-1}$s$^{-1}$ |
| $F_{tfh0}$ | ftfh0 | 10$^{100}$ | 10$^{100}$ | Vcm$^{-1}$ |
| $\eta_1$ | eta1 | 6 | 6 | 1 |
| $\eta_2$ | eta2 | 1 | 1 | 1 |
| $\mu_{sp0}$ | musp0 | 1.145$\times$10$^{-8}$ | 1.6$\times$10$^{-10}$ | cm$^2$V$^{-1}$s$^{-1}$ |

15: Mobility
Thin-Layer Mobility Model

Table 68 Parameters for thin-layer mobility model (Continued)

| Symbol | Parameter name | Electron | Hole | Unit |
| --- | --- | --- | --- | --- |
| $t_{sp0}$ | tsp0 | $10^{-4}$ | $10^{-4}$ | μm |
| $\mu_{ac0, 1}$ | muac01 | 315 | 30.2 | cm$^2$V$^{-1}$s$^{-1}$ |
| $\mu_{ac0, 2}$ | muac02 | 6.4 | 69 | cm$^2$V$^{-1}$s$^{-1}$ |
| $p_1$ | p1 | 0.55 | 0 | 1 |
| $p_2$ | p2 | 400 | 0.66 | 1 |
| $p_3$ | p3 | 1.44 | 1 | 1 |
| $m_{z1}$ | mz1 | 0.916 | 0.29 | $m_0$ |
| $m_{z2}$ | mz2 | 0.19 | 0.25 | $m_0$ |
| $\beta$ | beta | 4 | 4 | 1 |
| $W_{T01}$ | wt01 | $3 \times 10^{-6}$ | 0 | μm |
| $W_{T02}$ | wt02 | $3.5 \times 10^{-7}$ | 0 | μm |
| $\zeta$ | zeta | 2.88 | 1.05 | 1 |
| $a_{tf}$ | a_tf | 1.0 | 1.0 | 1 |
| $a_{sp}$ | a_sp | 1.0 | 1.0 | 1 |
| $a_{bp}$ | a_bp | 1.0 | 1.0 | 1 |

# Stress Factors for Mobility Components

If isotropic stress-dependent mobility enhancement factors are applied to mobility components (see Factor Models Applied to Mobility Components on page 943), the `ThinLayer` mobility components become:

$$
\begin{aligned}
\mu'_{tf} &= \gamma_{tf}\mu_{tf} \text{ , } \gamma_{tf} = 1 + a_{tf}(\gamma - 1) \\
\mu'_{sp} &= \gamma_{sp}\mu_{sp} \text{ , } \gamma_{sp} = 1 + a_{sp}(\gamma - 1) \\
\mu'_{bp} &= \gamma_{bp}\mu_{bp} \text{ , } \gamma_{bp} = 1 + a_{bp}(\gamma - 1)
\end{aligned}
\eqno(345)
$$

where $a_{tf}$, $a_{sp}$, and $a_{bp}$ are stress scaling parameters that can be specified in the `ThinLayerMobility` parameter set, and $\gamma$ is an isotropic enhancement factor calculated from a stress-dependent `Factor` model (see Isotropic Factor Models on page 937).

Thin-Layer Mobility Model

## Auto-Orientation and Named Parameter Sets

The thin-layer mobility model implicitly supports the auto-orientation framework (see Auto-Orientation Framework on page 38) and named parameter sets (see Named Parameter Sets on page 36). That is, auto-orientation or named parameter sets for the `ThinLayerMobility` parameters will be used (and required) if these options are invoked for the normal field–dependent interface model used in conjunction with the thin-layer mobility model.

For example, this specification:

```
Physics {
  Mobility (
    PhuMob
    ThinLayer (Lombardi(AutoOrientation))
  )
}
```

invokes auto-orientation for both the Lombardi-specific calculations *and* the thin layer–specific calculations. In this case, Sentaurus Device requires orientation-dependent parameter sets for both the `EnormalDependence` parameters (for Lombardi) and the `ThinLayerMobility` parameters.

As another example, this specification:

```
Physics {
  Mobility (
    ThinLayer (IALMob(ParameterSetName="110"))
  )
}
```

uses both the IALMob "110" parameter set and the `ThinLayerMobility` "110" parameter set.

## Geometric Parameters

The `ThinLayer` subcommand has the same `<geo_parameters>` as the `LayerThickness` command (see Geometric Parameters of the LayerThickness Command on page 335).

15: Mobility
High-Field Saturation Models

# High-Field Saturation Models

In high electric fields, the carrier drift velocity is no longer proportional to the electric field, instead, the velocity saturates to a finite speed $v_{sat}$. Sentaurus Device supports different models for the description of this effect:

* The Canali model, two transferred electron models, and two PMIs are available for all transport models.

* The basic model and the Meinerzhagen–Engl model both require hydrodynamic simulations.

* Another flexible model for hydrodynamic simulation is described in Energy-Dependent Mobility on page 828.

## Using High-Field Saturation Models

The high-field saturation models comprise three submodels: the actual mobility model, the velocity saturation model, and the driving force model. With a some restrictions, these models can be freely combined.

The actual mobility model is selected by flags to `eHighFieldSaturation` or `hHighFieldSaturation`. The default is the Canali model (see Extended Canali Model on page 388).

The flag `TransferredElectronEffect` selects the transferred electron model (see Transferred Electron Model on page 390).

Similarly, an alternative transferred electron model is activated by the flag `TransferredElectronEffect2` (see Transferred Electron Model 2 on page 390).

The flags `CarrierTempDriveBasic` and `CarrierTempDriveME` activate the ‘basic’ and the Meinerzhagen–Engl model, respectively (see Basic Model on page 392 and Meinerzhagen–Engl Model on page 393). These two models require hydrodynamic simulations.

For the Canali model, the two transferred electron models, and the `PMI_HighFieldMobility` PMI, the driving force model is selected by a flag to `eHighFieldSaturation` or `hHighFieldSaturation`. Available flags are `GradQuasiFermi` (the default), `Eparallel`, `EparallelToInterface`, and `CarrierTempDrive` (see Driving Force Models on page 395). The latter is only available in hydrodynamic simulations. The `PMI_HighFieldMobility2` PMI supports `EparallelToInterface`, `Eparallel`, and `ElectricField` for the electric-field driving force. For the ‘basic’ model and the Meinerzhagen–Engl model, the driving force is part of the actual mobility model and cannot be chosen independently.

High-Field Saturation Models

For all except the ‘basic’ model and the PMIs, a velocity saturation model can be selected in the `HighFieldDependence` parameter set (see Velocity Saturation Models on page 394).

## Named Parameter Sets for the High-Field Saturation Models

The `HighFieldDependence` and `HydroHighFieldDependence` parameter sets can be named. For example, in the parameter file, you can write:

```
HighFieldDependence "myset" { ... }
```

to declare a parameter set with the name `myset`.

To use a named parameter set, specify its name with `ParameterSetName` as an option to `HighFieldSaturation`, `eHighFieldSaturation`, or `hHighFieldSaturation`. For example:

```
eMobility (
  HighFieldSaturation( ParameterSetName = "myset" ...) ...
)
```

By default, the unnamed parameter set is used.

## Auto-Orientation for the High-Field Saturation Models

The `HighFieldSaturation` and `Diffusivity` models support the auto-orientation framework that switches between different `HighFieldDependence` named parameter sets based on the surface orientation of the nearest interface (see Auto-Orientation Framework on page 38).

To activate this feature, specify `AutoOrientation` as an option to either `Diffusivity` or `HighFieldSaturation` in the command file. For example:

```
Mobility (
  HighFieldSaturation( AutoOrientation ...) ...
)
```

# Extended Canali Model

The Canali model [20] originates from the Caughey–Thomas formula [21], but has temperature-dependent parameters, which were fitted up to 430 K by Canali et al. [20]:

$$ \mu(F) = \frac{(\alpha + 1)\mu_{\text{low}}}{\alpha + \left[ 1 + \left( \frac{(\alpha + 1)\mu_{\text{low}}F_{\text{hfs}}}{v_{\text{sat}}} \right)^{\beta} \right]^{1/\beta}} $$ (346)

 15: Mobility
High-Field Saturation Models

where $\mu_{\text{low}}$ denotes the low-field mobility. Its definition depends on which of the previously described mobility models have been activated (see Mobility due to Phonon Scattering on page 342 to Philips Unified Mobility Model on page 353). The exponent $\beta$ is temperature dependent according to:

$$ \beta = \beta_0 \left( \frac{T}{300 \text{ K}} \right)^{\beta_{\text{exp}}} \eqno(347) $$

Details about the saturation velocity $v_{\text{sat}}$ and driving field $F_{\text{hfs}}$ are discussed in Velocity Saturation Models on page 394 and Driving Force Models on page 395. All other parameters are accessible in the parameter set `HighFieldDependence`.

The silicon default values are listed in Table 69 on page 389.

A modified version of the Canali model is the Hänsch model [14]. It is activated by setting the parameter $\alpha = 1$. The Hänsch model is part of the Lucent mobility model (see Lucent Model on page 394). When using the hydrodynamic driving force Eq. 361, $\alpha$ must be zero.

For the hydrodynamic driving force, Eq. 361 can be substituted into Eq. 346. Solving for $\mu$ yields the hydrodynamic Canali model:

$$ \mu = \frac{\mu_{\text{low}}}{\left[ \sqrt{1 + \gamma^2 \max(w_c - w_0, 0)^\beta} + \gamma \max(w_c - w_0, 0)^{\beta/2} \right]^{2/\beta}} \eqno(348) $$

where $\gamma$ is given by $\gamma = \frac{1}{2} \left( \frac{\mu_{\text{low}}}{q \tau_{e,c} v_{\text{sat}}^2} \right)^{\beta/2}$.

In this form, the model has a discontinuous derivative at $w_0 = w_c$, which can lead to numeric problems. Therefore, Sentaurus Device applies a smoothing algorithm in the carrier temperature region $T < T_c < (1 + K_{dT})T$ to create a smooth transition between the low-field mobility $\mu_{\text{low}}$ and the mobility given in Eq. 348. $K_{dT}$ defaults to 0.2 and can be accessed in the parameter set `HighFieldDependence`.

Table 69 Canali model parameters (default values for silicon)

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $\beta_0$ | beta0 | 1.109 | 1.213 | 1 |
| $\beta_{\text{exp}}$ | betaexp | 0.66 | 0.17 | 1 |
| $\alpha$ | alpha | 0 | 0 | 1 |

15: Mobility
High-Field Saturation Models

# Transferred Electron Model

For GaAs and other materials with a similar band structure, a negative differential mobility can be observed for high driving fields. This effect is caused by a transfer of electrons into a energetically higher side valley with a much larger effective mass. Sentaurus Device includes a transferred electron model for the description of this effect, as given by [22]:

$$ \mu = \frac{\mu_{\text{low}} + \left( \frac{v_{\text{sat}}}{F_{\text{hfs}}} \right) \left( \frac{F_{\text{hfs}}}{E_0} \right)^4}{1 + \left( \frac{F_{\text{hfs}}}{E_0} \right)^4} $$ (349)

Details of the saturation velocity $v_{\text{sat}}$ and the driving field $F_{\text{hfs}}$ are discussed in Velocity Saturation Models on page 394 and Driving Force Models on page 395. The reference field strength $E_0$ can be set in the parameter set `HighFieldDependence`.

The `HighFieldDependence` parameter set also includes a variable $K_{\text{smooth}}$, which is equal to 1 by default. If $K_{\text{smooth}} > 1$, a smoothing algorithm is applied to the formula for mobility in the driving force interval $F_{\text{vmax}} < F < K_{\text{smooth}} F_{\text{vmax}}$, where $F_{\text{vmax}}$ is the field strength at which the velocity is at its maximum, $v_{\text{max}} = \mu F_{\text{vmax}}$. In this interval, Eq. 349 is replaced by a polynomial that produces the same values and derivatives at the points $F_{\text{vmax}}$ and $K_{\text{smooth}} F_{\text{vmax}}$. It is sometimes numerically advantageous to set $K_{\text{smooth}} \approx 20$.

Table 70 Transferred electron model: Default parameters

| Symbol | Parameter | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| E0 | E0_TrEf | 4000 | 4000 | Vcm⁻¹ |
| Ksmooth | Ksmooth_TrEf | 1 | 1 | 1 |

# Transferred Electron Model 2

Sentaurus Device provides an alternative high-field saturation mobility model for III–nitride materials:

$$ \mu = \frac{\mu_{\text{low}} + \mu_1 \left( \frac{F_{\text{hfs}}}{E_0} \right)^\alpha + v_{\text{sat}} \frac{F_{\text{hfs}}^{\beta-1}}{E_1^\beta}}{1 + \gamma \left( \frac{F_{\text{hfs}}}{E_0} \right)^\alpha + \left( \frac{F_{\text{hfs}}}{E_1} \right)^\beta} $$ (350)

 15: Mobility
High-Field Saturation Models

This model is a unification of the two models proposed in [23] and [24]. The model in [23] can be obtained by setting $\mu_1 = 0$ and $E_0 = E_1$. Similarly, the model in [24] can be obtained by setting $\gamma = 1$.

The model parameters are specified in the `TransferredElectronEffect2` section of the parameter file:

```
TransferredElectronEffect2 (
  mu1 = 0, 0
  E0 = 220893.6, 4000
  E1 = 220893.6, 4000
  alpha = 0.7857, 0
  beta = 7.2044, 4
  gamma = 6.1973, 0
)
```

The default electron parameters for Al<sub>x</sub>Ga<sub>1–x</sub>N and In<sub>x</sub>Ga<sub>1–x</sub>N are taken from [23] and are shown in Table 71 and Table 72.

Table 71 Transferred electron effect 2 model parameters in Al<sub>x</sub>Ga<sub>1–x</sub>N

| Material | μ₁ [cm²V⁻¹s⁻¹] | E₀ = E₁ [Vcm⁻¹] | α [1] | β [1] | γ [1] |
| --- | --- | --- | --- | --- | --- |
| GaN | 0 | 220893.6 | 0.7857 | 7.2044 | 6.1973 |
| Al₀.₂Ga₀.₈N | 0 | 245579.4 | 0.7897 | 7.8138 | 6.9502 |
| Al₀.₅Ga₀.₅N | 0 | 304554.1 | 0.8080 | 9.4438 | 8.0022 |
| Al₀.₈Ga₀.₂N | 0 | 386244.0 | 0.8324 | 12.5795 | 8.6037 |
| AlN | 0 | 447033.9 | 0.8554 | 17.3681 | 8.7253 |

Table 72 Transferred electron effect 2 model parameters in In<sub>x</sub>Ga<sub>1–x</sub>N

| Material | μ₁ [cm²V⁻¹s⁻¹] | E₀ = E₁ [Vcm⁻¹] | α [1] | β [1] | γ [1] |
| --- | --- | --- | --- | --- | --- |
| GaN | 0 | 220893.6 | 0.7857 | 7.2044 | 6.1973 |
| In₀.₂Ga₀.₈N | 0 | 151887.0 | 0.7670 | 6.0373 | 5.1797 |
| In₀.₅Ga₀.₅N | 0 | 93815.1 | 0.7395 | 4.8807 | 3.7387 |
| In₀.₈Ga₀.₂N | 0 | 63430.5 | 0.6725 | 4.1330 | 2.7321 |
| InN | 0 | 52424.2 | 0.6078 | 3.8501 | 2.2623 |

For other materials, as well as for hole mobility, the parameters in Table 73 are used.

Table 73 Default transferred electron effect 2 model parameters

| μ₁ [cm²V⁻¹s⁻¹] | E₀ = E₁ [Vcm⁻¹] | α [1] | β [1] | γ [1] |
| --- | --- | --- | --- | --- |
| 0 | 4000 | 0 | 4 | 0 |

High-Field Saturation Models

With these parameters, the model reverts to the standard transferred electron model (see Transferred Electron Model on page 390).

Sometimes, convergence problems are observed when the derivative of the velocity $v = \mu F_{hfs}$ with respect to the driving force $F_{hfs}$ becomes negative. As a potential solution, Sentaurus Device provides an option to specify a lower bound for this derivative:

```
Math {
  TransferredElectronEffect2_MinDerivativePerField = 0
}
```

If required, individual bounds can be specified for electrons and holes:

```
Math {
  TransferredElectronEffect2_eMinDerivativePerField = -1e-3
  TransferredElectronEffect2_hMinDerivativePerField = -1e-2
}
```

By default, Sentaurus Device applies the lower bound $\partial v / \partial F_{hfs} \geq -10^{100} \text{cm}^2 \text{V}^{-1} \text{s}^{-1}$. Note that this lower bound cannot be applied to the hydrodynamic driving force (`CarrierTempDrive`).

## Multivalley Transferred Electron Mobility

This experimental model accounts for the transferred electron effect in III–V applications based on the usage of the Sentaurus Device hydrodynamic model (see Hydrodynamic Model for Temperatures on page 204) and the multivalley band-structure representation (see Multivalley Band Structure on page 281). For a description of the model and its settings, see Multivalley Transferred Carrier Mobility Model on page 920.

## Basic Model

According to this very simple model, the mobility decays inversely with the carrier temperature:

$$ \mu = \mu_{low} \left( \frac{300 \text{ K}}{T_c} \right) \eqno(351) $$

where $\mu_{low}$ is the low-field mobility and $T_c$ is the carrier temperature.

**15: Mobility**
High-Field Saturation Models

# Meinerzhagen–Engl Model

According to the Meinerzhagen–Engl model [[25]]([25]), the high field mobility degradation is given by:

$$ \mu = \frac{\mu_{\text{low}}}{\left[ 1 + \left( \mu_{\text{low}} \frac{3k(T_c - T)}{2q \tau_{e,c} v_{\text{sat}}^2} \right)^\beta \right]^{1/\beta}} $$ (352)

where $\tau_{e,c}$ is the energy relaxation time.

The coefficients of the saturation velocity $v_{\text{sat}}$ (see Eq. 353) and the exponent $\beta$ (see Eq. 347) are accessible in the parameter file:

```
HighFieldDependence {
    vsat0   = <value for electrons> <value for holes>
    vsatexp = <value for electrons> <value for holes>
}
HydroHighFieldDependence {
    beta0   = <value for electrons> <value for holes>
    betaexp = <value for electrons> <value for holes>
}
```

The silicon default values are given in Table 74 and Table 75 on page 395.

Table 74 Meinerzhagen–Engl model: Default parameters

| Silicon | Electrons | Holes | Unit |
| --- | --- | --- | --- |
| $\beta_0$ | 0.6 | 0.6 | 1 |
| $\beta_{\text{exp}}$ | 0.01 | 0.01 | 1 |

# Physical Model Interfaces

Sentaurus Device offers different physical model interfaces (PMIs) for high-field mobility saturation:

* The first PMI is activated by specifying the name of the model as an option of `HighFieldSaturation`, `eHighFieldSaturation`, or `hHighFieldSaturation`. See High-Field Saturation on page 1246.

* The second PMI allows you to implement models that depend on two driving forces. It is specified by `PMIModel` as the option to `HighFieldSaturation`, `eHighFieldSaturation`, or `hHighFieldSaturation`. See High-Field Saturation With Two Driving Forces on page 1255.

393

15: Mobility
High-Field Saturation Models

# Lucent Model

The Lucent model has been developed by Darwish *et al.* [[12]]([12]). Sentaurus Device implements this model as a combination of:

*   An extended Philips unified mobility model (see Philips Unified Mobility Model on page 353) with the parameters $f_e = 0$ and $f_h = 0$ (see Table 59 on page 357). The Lucent model described in [[12]]([12]) also does not include clustering. To disable clustering in the Philips unified mobility model, set the parameters $N_{\text{ref,A}}$ and $N_{\text{ref,D}}$ to very large numbers.

*   The enhanced Lombardi model (see Enhanced Lombardi Model on page 359) with the parameters from Table 61 on page 360.

*   The Hänsch model (see Extended Canali Model on page 388) with the parameter $\alpha = 1$ (see Table 69 on page 389). In addition, the $\beta$ exponent in the Hänsch model is equal to 2, which can be accomplished by setting $\beta_0 = 2$ and $\beta_{\text{exp}} = 0$.

# Velocity Saturation Models

Sentaurus Device supports different velocity saturation models.

Model 1 is part of the Canali model and is given by:

$$ v_{\text{sat}} = v_{\text{sat,0}} \left( \frac{300 \text{ K}}{T} \right)^{v_{\text{sat,exp}}} \text{ (353)} $$

This model is recommended for silicon.

Model 2 is recommended for GaAs. Here, $v_{\text{sat}}$ is given by:

$$ v_{\text{sat}} = \begin{cases} A_{\text{vsat}} - B_{\text{vsat}} \left( \frac{T}{300 \text{ K}} \right) & v_{\text{vsat}} > v_{\text{sat,min}} \\ v_{\text{sat,min}} & \text{otherwise} \end{cases} \text{ (354)} $$

Parameters of both models are accessible in the `HighFieldDependence` parameter set.

## Selecting Velocity Saturation Models

The variable `Vsat_formula` in the `HighFieldDependence` parameter set selects the velocity saturation model. If `Vsat_formula` is set to 1, Eq. 353 is used. If `Vsat_formula` is set to 2, Eq. 354 is selected. The default value of `Vsat_formula` depends on the semiconductor material, for example, for silicon the default is 1; for GaAs, it is 2.

15: Mobility
High-Field Saturation Models

Table 75 Velocity saturation parameters

| Symbol | Parameter | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| vsat,0 | vsat0 | 1.07×10⁷ | 8.37×10⁶ | cm/s |
| vsat,exp | vsatexp | 0.87 | 0.52 | 1 |
| Avsat | A_vsat | 1.07×10⁷ | 8.37×10⁶ | cm/s |
| Bvsat | B_vsat | 3.6×10⁶ | 3.6×10⁶ | cm/s |
| vsat,min | vsat_min | 5.0×10⁵ | 5.0×10⁵ | cm/s |

# Driving Force Models

Sentaurus Device supports five models for the driving force $F_{hfs}$, the first two of which also are affected by the `ParallelToInterfaceInBoundaryLayer` keyword (see Field Correction Close to Interfaces on page 400). For a summary of keywords, see Table 273 on page 1585.

## Electric Field Parallel to the Current

For the first model (flag `Eparallel`), the driving field for electrons is the electric field parallel to the electron current density:

$$ F_{hfs, n} = \vec{F} \cdot \frac{\vec{J}_n}{J_n} $$ (355)

To avoid numeric noise in the calculation of the `Eparallel` driving force, Sentaurus Device provides an option of setting $F_{hfs, n}$ to zero for very small current densities, defined as:

$$ \frac{J_n}{\mu_n} < \frac{c_{min}}{\mu_{ref}} $$ (356)

Here, $\mu_{ref} = 1000 \text{ cm}^2 \text{V}^{-1} \text{s}^{-1}$ is an arbitrary reference mobility, and $c_{min}$ is specified (in $\text{Acm}^{-2}$) by `CDensityMin` in the `Math` section (default is 0).

The driving field for holes is analogous.

The electric field parallel to the current is the physically correct driving force for high-field saturation mobility models as well as for avalanche generation. Unfortunately, this driving force suffers from numeric instabilities for small currents because the direction of the current is not well defined and fluctuates easily. Therefore, the radius of convergence can be very small. The following driving forces are provided as alternatives with improved numeric stability.

15: Mobility
High-Field Saturation Models

# Gradient of Quasi-Fermi Potential

For the second model (flag `GradQuasiFermi`), the driving field for electrons is:

$$ F_{hfs, n} = |\nabla \Phi_n| $$ (357)

By default, the electric field replaces the gradient of the quasi-Fermi potential within mesh elements touching a contact:

$$ F_{hfs, n} = |\vec{F}| $$ (358)

In the `Math` section, you can request that Eq. 357 is used for all elements:

```
Math {
  ComputeGradQuasiFermiAtContacts = UseQuasiFermi
}
```

The driving field for holes is analogous.

**NOTE** Usually, Eq. 355 and Eq. 357 give the same or very similar results. However, numerically, one model might prove to be more stable. For example, in regions with small current, the evaluation of the parallel electric field can be numerically problematic.

This is the default driving force for drift-diffusion simulations.

# Electric Field Parallel to the Interface

The third model (keyword `EparallelToInterface`) computes the driving force as the electric field parallel to the closest semiconductor–insulator interface:

$$ F_{hfs} = |(I - \hat{n}\hat{n}^T)\vec{F}| $$ (359)

The vector $\hat{n}$ is a unit vector pointing to the closest semiconductor–insulator interface. It is determined in the same way as for the mobility degradation at interfaces. To select explicitly a semiconductor–insulator interface, use the `EnormalInterface` specification in the `Math` section (see Normal to the Interface on page 380).

The driving force of `EparallelToInterface` is the same for electrons and holes. It is numerically stable because it does not depend on the direction of the current. However, this model will only give valid results if the current flows predominantly parallel to the interface (such as in the channel of MOSFET devices).

15: Mobility
High-Field Saturation Models

In certain situations, for example, in the channel of a FinFET, the direction of the current is known. In this case, you can specify a constant direction vector $\vec{d}$ in the `Math` section:

```
Math {
  EparallelToInterface (
    Direction = (1 0 0)
  )
}
```

Then, the driving force is computed as the electric field $\vec{F}$ parallel to the direction vector $\vec{d}$:

$$ F_{hfs} = \frac{\max(\vec{d} \cdot \vec{F}, 0)}{|\vec{d}|} \tag{360} $$

**NOTE** Eq. 360 ensures a nonnegative driving force $F_{hfs, n}$. If the scalar product between the direction vector $\vec{d}$ and the electric field $\vec{F}$ becomes negative, the driving force will be set to zero. This effectively switches off high-field saturation.

Therefore, it is crucial that the direction of vector $\vec{d}$ is aligned with the direction of the current flow. Otherwise, you might inadvertently disable the high-field saturation mobility model.

An `EparallelToInterface` specification can appear in the global `Math` section, as well as in materialwise or regionwise `Math` sections. If no direction vector, or a zero direction vector, has been specified, the driving force will revert to Eq. 359.

It also might be required to restrict the validity of the direction vector $\vec{d}$ to only a part of a device. This can be accomplished by specifying a list of boxes together with the required direction vector:

```
Math {
  EparallelToInterface (      # 2D example
    Direction = (1 0)
    Box = ((1 1) (3 4))
    Box = ((3 3) (5 4))
  )

  EparallelToInterface (      # 3D example
    Direction = (0 0 1)
    Box = ((1 1 0) (3 4 1))
    Box = ((3 3 0) (5 4 1))
  )
}
```

Boxes are specified by the coordinates of the corners of a diagonal (units of μm). The driving force in Eq. 360 is then only applied to mesh vertices that are contained in at least one of the

15: Mobility
High-Field Saturation Models

boxes. On all other vertices, the driving force in Eq. 359 is used. You can specify different direction vectors $\vec{d}$ in different parts of a device by using multiple `EparallelToInterface` statements in the `Math` section.

You also can plot the normalized direction vector $\vec{d} / |\vec{d}|$ in the `Plot` section:

```
Plot {
  EP2I_Direction/Vector
}
```

This can be useful to visualize the areas where the driving force in Eq. 360 applies.

## Hydrodynamic Driving Force

The fourth model (keyword `CarrierTempDrive`) requires hydrodynamic simulation. The driving field for electrons is:

$$ F_{\text{hfs}, n} = \sqrt{\frac{\max(w_n - w_0, 0)}{\tau_{e, n} q \mu_n}} $$ (361)

where $w_n = 3kT_n/2$ is the average electron thermal energy, $w_0 = 3kT/2$ is the equilibrium thermal energy, and $\tau_{e, n}$ is the energy relaxation time. The driving fields for holes are analogous.

This is the default driving force for hydrodynamic simulations.

## Electric Field

The fifth model (keyword `ElectricField`) uses the electric field as an approximation for $F_{\text{hfs}}$.

## Interpolation of Driving Forces to Zero Field

For numeric reasons, Sentaurus Device actually implements the following generalizations of Eq. 355 and Eq. 357:

$$ F_{\text{hfs}, n} = \frac{n}{n + n_0} \vec{F} \cdot \frac{\vec{j}_n}{j_n} $$ (362)

$$ F_{\text{hfs}, n} = \frac{n}{n + n_0} |\nabla \Phi_n| $$ (363)

Here, $n_0$ is a numeric damping parameter. The values for electrons and holes default to zero, and are set (in cm<sup>-3</sup>) in the `Math` section with the `RefDens_eGradQuasiFermi_Zero` and

15: Mobility
High-Field Saturation Models

`RefDens_hGradQuasiFermi_Zero` parameters. Using positive values for $n_0$ can improve convergence for problems where strong generation–recombination occurs in regions with small density.

Instead of `RefDens_eGradQuasiFermi_Zero` and `RefDens_hGradQuasiFermi_Zero`, the old aliases `eDrForceRefDens` and `hDrForceRefDens` can be used as well.

## Interpolation of the GradQuasiFermi Driving Force

Occasionally, convergence problems can be attributed to the GradQuasiFermi driving force, particularly when $\nabla\Phi_n$ changes rapidly for small changes in the electron density $n$. In such cases, you can use the gradient of a modified quasi-Fermi potential $\tilde{\Phi}_n$ instead. In the case of Boltzmann statistics, the modified quasi-Fermi potentials are given by:

$$ \tilde{\Phi}_n = \phi - \phi_{\text{ref}} + \frac{\chi}{q} - \frac{kT}{q} \log \frac{n + n_0}{N_C} \tag{364} $$

$$ \tilde{\Phi}_p = \phi - \phi_{\text{ref}} + \frac{\chi}{q} + \frac{E_{g, \text{eff}}}{q} + \frac{kT}{q} \log \frac{p + p_0}{N_V} \tag{365} $$

The equivalent expressions for Fermi statistics are:

$$ \tilde{\Phi}_n = \phi - \phi_{\text{ref}} + \frac{\chi}{q} - \frac{kT}{q} F_{1/2}^{-1} \left( \frac{n + n_0}{N_C} \right) \tag{366} $$

$$ \tilde{\Phi}_p = \phi - \phi_{\text{ref}} + \frac{\chi}{q} + \frac{E_{g, \text{eff}}}{q} + \frac{kT}{q} F_{1/2}^{-1} \left( \frac{p + p_0}{N_V} \right) \tag{367} $$

The values of $n_0$ and $p_0$ can be specified with the following parameters in the `Math` section:

*   `RefDens_eGradQuasiFermi_ElectricField_HFS`

*   `RefDens_hGradQuasiFermi_ElectricField_HFS`

For $n_0 = 0$, you have $\nabla\tilde{\Phi}_n = \nabla\Phi_n$ and, for $n_0 \rightarrow \infty$, you have $\nabla\tilde{\Phi}_n \rightarrow \vec{F}$ as a limit (in the isothermal case). Therefore, this approach represents an interpolation between the gradient of the quasi-Fermi potential $\nabla\Phi_n$ and the electric field $\vec{F}$.

These interpolation parameters affect only the computation of the `GradQuasiFermi` driving force for high-field saturation mobility. If you want the driving force for both high-field saturation mobility *and* avalanche generation to use interpolation to the electric field, you can use the following keywords (see Interpolation of Avalanche Driving Forces on page 455):

*   `RefDens_eGradQuasiFermi_ElectricField`

*   `RefDens_hGradQuasiFermi_ElectricField`

High-Field Saturation Models

As an alternative, Sentaurus Device also provides an interpolation between the gradient of the quasi-Fermi potential and the electric field parallel to the interface:

$$ F_{hfs, n} = \frac{n}{n + n_0} |\nabla \Phi_n| + \frac{n_0}{n + n_0} |(I - \hat{n}\hat{n}^T)\vec{F}| $$ (368)

The reference densities for electrons and holes can be specified in the `Math` section by the following parameters:

* `RefDens_eGradQuasiFermi_EparallelToInterface_HFS`

* `RefDens_hGradQuasiFermi_EparallelToInterface_HFS`

## Interpolation of the Eparallel Driving Force

As with the `GradQuasiFermi` driving force, convergence problems associated with the `Eparallel` driving force can sometimes be alleviated with an interpolation to the electric field $\vec{F}$ at low carrier concentrations:

$$ F_{hfs, n} = \frac{n}{n + n_0} \left( \vec{F} \cdot \frac{\vec{J}_n}{J_n} \right) + \frac{n_0}{n + n_0} |\vec{F}| $$ (369)

In this case, the reference densities for electrons and holes can be specified in the `Math` section by the following parameters:

* `RefDens_eEparallel_ElectricField_HFS`

* `RefDens_hEparallel_ElectricField_HFS`

Interpolation of the `Eparallel` driving force to the electric field for avalanche generation can be specified with separate parameters (see Interpolation of Avalanche Driving Forces on page 455).

## Field Correction Close to Interfaces

`ParallelToInterfaceInBoundaryLayer` in the `Math` section controls the computation of driving forces for mobility and avalanche models along interfaces. With this switch, the avalanche and mobility computations in boundary elements along interfaces use only the component parallel to the interface of the following vectors:

* Current vector

* Gradient of the quasi-Fermi potential

In this context, an interface is either a semiconductor–insulator region interface or an external boundary interface of the device.

**15: Mobility**
High-Field Saturation Models

This switch can be useful to avoid nonphysical breakdowns along an interface with a coarse mesh. It can be specified regionwise, in which case, it applies only to boundary elements in a given region.

The switch `ParallelToInterfaceInBoundaryLayer` supports two “layer” options:

```
Math {
  ParallelToInterfaceInBoundaryLayer (PartialLayer)
  ParallelToInterfaceInBoundaryLayer (FullLayer)
}
```

If `PartialLayer` is specified, parallel fields are only used in elements that are connected to the interface by an edge (in 2D) or a face (in 3D). This is the default. The option `FullLayer` uses parallel fields in all elements that touch the interface by either a face, an edge, or a vertex.

The switch `ParallelToInterfaceInBoundaryLayer` is activated by default. It can be deactivated by specifying `-ParallelToInterfaceInBoundaryLayer`. Additional options are available for `ParallelToInterfaceInBoundaryLayer` to deactivate it only on portions of the interface. Specifying `-ExternalBoundary` deactivates it on all external boundaries; whereas, `-ExternalXPlane`, `-ExternalYPlane`, and `-ExternalZPlane` deactivates it only on external boundaries perpendicular to the x-axis, y-axis, and z-axis, respectively. Specifying `-Interface` deactivates it on semiconductor–insulator region interfaces.

# Non-Einstein Diffusivity

By default, in the drift-diffusion equation (see Drift-Diffusion Model on page 190), Sentaurus Device assumes that the Einstein relation holds, and the diffusivity is related to the mobility by $D_n = kT\mu_n$ and $D_p = kT\mu_p$. For short-channel devices with steep doping gradients, this relation is no longer valid. Therefore, Sentaurus Device allows you to compute the diffusivities independently from the mobilities.

To be able to reuse existing mobility models, Sentaurus Device expresses the diffusivities in terms of diffusivity mobilities, $D_n = kT\mu_{n, \text{diff}}$ and $D_p = kT\mu_{p, \text{diff}}$, and you can specify models and parameters for $\mu_{n, \text{diff}}$ and $\mu_{p, \text{diff}}$, which are different from $\mu_n$ and $\mu_p$.

To compute the diffusivity mobilities, specify the keyword `Diffusivity`, `eDiffusivity`, or `hDiffusivity` as an option to `eMobility`, `hMobility`, or `Mobility`. The options for `eDiffusivity` and `hDiffusivity` are the same as for `HighFieldSaturation`. The low-field mobility that enters the diffusivity mobility is the same as for the high-field mobility.

The simplest way to obtain diffusivity mobilities different from the mobilities is to use named parameters sets to achieve a different parameterization (see Named Parameter Sets for the High-Field Saturation Models on page 388).

High-Field Saturation Models

For example:

```
eMobility (
  HighFieldSaturation(ParameterSetName = "mymobpara")
  Diffusivity(ParameterSetName = "mydiffpara")
  DopingDependence     * applies to both diffusivity and mobility
)
```

It is also possible to use entirely different models for high-field mobilities and diffusivity mobilities.

Diffusivity mobilities can be plotted. The names of the datasets are `eDiffusivityMobility` and `hDiffusivityMobility`.

The implementation of non-Einstein diffusivities has several restrictions. In particular, the following models use a current density that assumes the Einstein relation still holds:

*   The models to compute the driving fields for mobility (Driving Force Models on page 395) and avalanche generation (see Driving Force on page 455)

*   The J-model for trap cross-sections (see J-Model for Cross Sections on page 502)

*   The current densities that appear in Eq. 79 and Eq. 80, p. 204

Transport in magnetic fields is not supported. Support for anisotropy is restricted to the tensor grid method with current-independent anisotropy. The hydrodynamic model is supported, but it is not recommended for use with non-Einstein diffusivity.

# High-Field Saturation Mobility Scaling

Sentaurus Device allows the mobility calculated by the `HighFieldSaturation` models to be scaled. The parameters `ku` and `kv` are used to scale low-field mobility ($\mu_{low}$) and saturation velocity ($v_{sat}$), respectively, which appear in the formulas presented in this section:

$$ \mu_{low} \rightarrow ku \cdot \mu_{low} \tag{370} $$

$$ v_{sat} \rightarrow kv \cdot v_{sat} \tag{371} $$

The parameters `ku` and `kv` are specified in the `HighFieldDependence` parameter set in the parameter file and have default values of 1.0.

15: Mobility
Ballistic Mobility Model

# Ballistic Mobility Model

To account for the ballistic effect in drift-diffusion transport, a ballistic mobility model can be combined with the total drift-diffusion mobility using Matthiessen’s rule:

$$ \frac{1}{\mu} = \frac{1}{\mu_{\text{dd}}} + \frac{1}{\mu_{\text{bal}}} \tag{372} $$

where $\mu_{\text{bal}}$ represents the ballistic mobility. Sentaurus Device provides two models for $\mu_{\text{bal}}$ that are described in the following sections:

*   Channel Length–Dependent Model

*   Kinetic Velocity Model

## Channel Length–Dependent Model

The simplest channel length–dependent ballistic mobility model [6] is given by the following expression:

$$ \mu_{\text{bal}}(T) = k(T) \cdot L_{\text{ch}} \tag{373} $$

where $L_{\text{ch}}$ is a user-defined parameter. In most cases, you will specify a value for $L_{\text{ch}}$ (in nm) that corresponds to the actual channel length for the device being simulated.

According to [6], $k(T)$ is expressed as:

$$ k(T) = \frac{qv_T}{2k_{\text{B}}T} \quad v_T = \sqrt{\frac{2k_{\text{B}}T}{\pi m^*}} \tag{374) $$

where $q$ is the electron charge, $T$ is the lattice temperature, $k_{\text{B}}$ is the Boltzmann constant, and $v_T$ is the thermal velocity with the effective mass $m^*$ in the transport direction. If you define the parameter $k_{300} = k(300\text{ K})$, then the effective mass $m^*$ from Eq. 374 can be expressed as:

$$ m^* = \frac{q^2}{(600\text{ K})\pi k_{\text{B}}k_{300}^2} \tag{375} $$

Using $k_{300}$, Eq. 373 can be rewritten as:

$$ \mu_{\text{bal}}(T) = k_{300} \sqrt{\frac{300\text{ K}}{T}} \cdot L_{\text{ch}} \tag{376} $$

where $k_{300}$ is a user-defined parameter specified in the parameter file. This parameter can be adjusted to match measured device characteristics.

Ballistic Mobility Model

---

# Kinetic Velocity Model

To avoid using the explicit channel length dependency in Eq. 376, the authors of [[26]]([26]) developed a kinetic velocity model (KVM) with the following terms: thermionic emission and free carrier acceleration. The thermionic emission term in the ballistic mobility is given by:

$$ \mu^T{_{bal}} = \frac{\sqrt{\frac{k_BT}{m^*}} y_T \left( \frac{q\psi}{k_BT} \right)}{|\nabla\psi|} \qquad y_T(x) = e^x \sqrt{\alpha_0 + 2(1 - e^{-x})} \eqno(377) $$

where $\psi$ is the quasi-Fermi potential with reference to the source contact and with a negative sign for holes, $m^*$ is from Eq. 375 and can be adjusted using the parameter $k_{300}$, and $\alpha_0$ is a factor to an initial kinetic velocity near source.

The free carrier acceleration term in the ballistic mobility is given by:

$$ \mu^B{_{bal}} = \frac{\sqrt{\frac{k_BT}{m^*}} y_B \left( \frac{q\psi}{k_BT} \right)}{|\nabla\psi|} \qquad y_B(x) = \sqrt{\alpha_0 + 2x} \eqno(378) $$

The total KVM ballistic mobility is expressed as follows:

$$ \frac{1}{\mu_{bal}} = \frac{\alpha_T}{\mu^T{_{bal}}} + \frac{\alpha_B}{\mu^B{_{bal}}} \eqno(379) $$

where $\alpha_T$ is the thermionic emission constant, which according to the theory of [[27]]([27]) should equal 1.52, and $\alpha_B$ is the distribution function factor of the free carrier acceleration term, which should be effective mass (semiconductor material) dependent.

**NOTE** The free carrier acceleration term (Eq. 378) is required if pure ballistic transport should be modeled using the drift-diffusion model. However, for typical MOSFET applications where carrier mobility is affected by carrier scattering in the channel, the thermionic emission term alone (Eq. 377 and Eq. 379) should be sufficient.

---

# Fermi–Dirac Statistics

Both Eq. 376 and Eq. 379 are written for the Boltzmann statistics, but for the strong inversion regime in MOSFET applications, accounting for Fermi–Dirac statistics might be essential (especially for III–V materials).

[]()

15: Mobility
Ballistic Mobility Model

To account for that, the following correction is suggested in [26]:

$$ \mu_{\text{bal}} = \tilde{\mu}_{\text{bal}} \sqrt{\frac{k_B T}{q} \frac{\partial \ln n}{\partial \psi}} $$ (380)

where $\tilde{\mu}_{\text{bal}}$ is from Eq. 376 or Eq. 379, and $n$ is the carrier concentration.

## Frensley Rule

Typically, the ballistic mobility is combined with the total drift-diffusion mobility $\mu_{\text{dd}}$ using Matthiessen’s rule (Eq. 372), but [26] and [27] suggest the following Frensley rule to compute the final mobility $\mu$:

$$ \frac{\mu}{\mu_{\text{dd}}} + \left( \frac{\mu}{\mu_{\text{bal}}} \right)^2 = 1 $$ (381)

## Using the Ballistic Mobility Model

To activate the channel length–dependent ballistic mobility (Eq. 376) with available options, you can specify the following in the `Physics` section of the command file:

```
Mobility (
   BalMob(Lch = 5.0 Fermi Frensley TempDep)
)
```

Here, `Lch` is the channel length (in nm), the `Fermi` option activates the Fermi–Dirac correction (Eq. 380), the `Frensley` option activates Eq. 381 for the final mobility $\mu$ (if not specified, Matthiessen’s rule is used), and the `TempDep` option activates the temperature dependency in Eq. 376. If `Lch` is not specified, the default value of $10^7$ nm is used, which effectively disables the model.

The model has one user-defined fitting parameter $k_{300}$ that is accessible in the `BalMob` parameter set in the parameter file.

Table 76 BalMob model: Default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $k_{300}$ | k | 20.0 | 20.0 | cm$^2$/Vs nm |

Ballistic Mobility Model

To activate only the thermionic emission term of the KVM (Eq. 377 and Eq. 379) with available options, you can specify the following in the Physics section of the command file:

```
Mobility (
  BalMob(KVM Fermi Frensley)
)
```

where the KVM option must be used and activates the model, the Fermi option activates the Fermi–Dirac correction (Eq. 380), and the Frensley option activates Eq. 381 for the final mobility $\mu$ (if not specified, Matthiessen’s rule is used). To activate the total KVM with the free carrier acceleration term (Eq. 377, Eq. 378, and Eq. 379) the `KVM(Full)` option must be used.

The KVM also has the same fitting parameter $k_{300}$ that must be specified in the parameter file (see Table 76 on page 405) and defines the effective mass $m^*$ needed in Eq. 377 and Eq. 378. In addition, Table 77 lists the KVM-specific parameters that are accessible in the `BalMob` parameter set in the parameter file.

Table 77 BalMob model: KVM default coefficients for silicon

| Symbol | Parameter name | Electrons | Holes | Unit |
| --- | --- | --- | --- | --- |
| $\alpha_T$ | Tfactor | 2 | 2 | 1 |
| $\alpha_B$ | Bfactor | 0.3 | 0.3 | 1 |
| $\alpha_0$ | V0factor | 1 | 1 | 1 |

## Using the PMI Fitting Parameter in the Ballistic Mobility Model

A PMI model for the fitting parameter $k_{300}$ can be used in the ballistic mobility model. To activate this PMI model, specify the following in the Physics section of the command file:

```
Mobility (
  BalMob(KVM pmi_parameterK_model_name)
)
```

For an example of this PMI model, see Fitting Parameter for Ballistic Mobility on page 1243. You can also use any variables computed by a mobility stress factor of the PMI model (see Mobility Stress Factor on page 1339) as dependent parameters to recalculate $k_{300}$. You can specify the following in the Physics section of the command file:

```
Mobility (
  BalMob(KVM pmi_parameterK_model_name)
)
Piezo (
```

406

15: Mobility

General Model for Mobility Degradation by Traps in the Bulk and at Semiconductor Interfaces

```
Model(
    Mobility(
        pmi_parameterK_model
        pmi_effectiveStress_model
    )
)
```

# General Model for Mobility Degradation by Traps in the Bulk and at Semiconductor Interfaces

Traps at interfaces, grain boundaries, and in the bulk of a semiconductor cause mobility degradation by Coulomb scattering. The bulk trap Coulomb scattering (BTCS) model can model trap-related Coulomb scattering. It includes the dependency on the trap concentration, the influence of the screening by mobile charge carriers, and the weakening of Coulomb scattering with increasing temperature. Eq. 382 relates the trap concentration to the mobility degradation component, which is then combined using Matthiessen’s rule to the total mobility:

$$ \mu_C = \frac{\mu_1 \left( \frac{T}{300\text{ K}} \right)^k \left\{ 1 + \left[ \frac{c}{c_{\text{trans}} \left( \frac{N_{A,D} + N_1}{10^{18}\text{ cm}^{-3}} \right)^{\gamma_1} \left( \frac{N_C}{N_0} \right)^{\eta_1}} \right]^\nu \right\}}{\left( \frac{N_{A,D} + N_2}{10^{18}\text{ cm}^{-3}} \right)^{\gamma_2} \left( \frac{N_C}{N_0} \right)^{\eta_2} \exp(-\frac{r}{l_{\text{crit}}})} $$ (382)

where:

*   $N_C$ represents the total trapped charge.

*   $c$ denotes the electron concentration $n$ or the hole concentration $p$.

*   $N_{A,D}$ is the acceptor or donor doping concentration for electron or hole mobility, respectively.

*   $T$ is the device temperature.

*   $l_{\text{crit}}$ is a characteristic length that controls the influence of traps in the neighborhood $r$ of a certain mesh point, on the mobility degradation. It is relevant only for the nonlocal option of the model.

*   $\mu_1$, $k$, $c_{\text{trans}}$, $\gamma_1$, $\gamma_2$, $\nu$, $\eta_1$, $\eta_2$, $N_0$, $N_1$, and $N_2$ are fit parameters.

Incomplete Ionization–Dependent Mobility Models

The model has the following options:

* The local option (default) calculates the mobility degradation at one mesh point caused by the trap concentration at that mesh point.

* The nonlocal option takes the mobility lowering caused by the traps located at a certain distance from the mesh point at which the mobility degradation is calculated into account. This is done by using Mathiessen’s rule. The parameter `NonlocalLengthLimit` defines the corresponding radius of influence (in cm). Traps that are beyond this distance do not contribute to the mobility degradation at a given mesh point.

For example, to use the model for the region `R.channel`, specify:

```
Physics (Region="R.Channel") {
  Mobility( ... BTCSMob(Nonlocal NonlocalLengthLimit=1e-4) )
}
```

This statement switches on the nonlocal option of the model using 1.0e-4 cm for the `NonlocalLengthLimit` parameter.

The following parameters are available in the parameter file:

```
BTCSMobility {
  mu1 = 40, 40                             #[cm^2/Vs]
  T_exp = 1, 1                             #[1]
  c_trans = 1.0000e+18, 1.0000e+18         #[cm^(-3)]
  c_exp = 1.5, 1.5                         #[1]
  Nc_exp1 = 1, 1                           #[1]
  Nc_exp2 = 0.5, 0.5                       #[1]
  N0 = 1.0000e+18, 1.0000e+18              #[cm^(-3)]
  N1 = 1, 1                                #[cm^(-3)]
  N2 = 1, 1                                #[cm^(-3)]
  N_exp1 = 0.0000e+00, 0.0000e+00          #[1]
  N_exp2 = 0.0000e+00, 0.0000e+00          #[1]
  l_crit = 1.0000e-06, 1.0000e-06          #[cm]
}
```

# Incomplete Ionization–Dependent Mobility Models

Sentaurus Device supports incomplete ionization–dependent mobility models. To activate this dependence, specify the keyword `IncompleteIonization` in `Mobility` sections. The incomplete ionization model (see Chapter 13 on page 293) must also be activated. The Physics section for this case can be as follows:

```
Physics {
  IncompleteIonization
```

15: Mobility
Poole–Frenkel Mobility (Organic Material Mobility)

```
    Mobility ( Enormal IncompleteIonization )
}
```

In this case, for all equations that contain $N_{A,0}$, $N_{D,0}$, $N_{tot}$, Sentaurus Device uses $N_A$, $N_D$, $N_i$.

The following mobility models depend on incomplete ionization:

* Masetti model, see Eq. 250

* Arora model, see Eq. 251

* University of Bologna bulk model, see Eq. 255–Eq. 257

* Philips unified model, see Eq. 276 and Eq. 277

* Lombardi model, see Eq. 282 and Eq. 285

* IALMob model, see Eq. 287, Eq. 299, Eq. 300, Eq. 305, Eq. 307, and Eq. 308

* University of Bologna inversion layer model, see Eq. 312–Eq. 315

* Coulomb degradation components, see Eq. 317

* RCS model, see Eq. 322 and Eq. 323

# Poole–Frenkel Mobility (Organic Material Mobility)

Most organic semiconductors have mobilities dependent on the electric field. Sentaurus Device supports mobilities having a square-root dependence on the electric field, which is a typical mobility dependence for organic semiconductors. The mobility as a function of the electric field is given by:

$$ \mu = \mu_0 \exp(-\frac{E_0}{kT}) \exp(\sqrt{F}(\frac{\beta}{T} - \gamma)) $$ (383)

where $\mu_0$ is the low-field mobility, $\beta$ and $\gamma$ are fitting parameters, $E_0$ is the effective activation energy, and $F$ is the driving force (electric field). The parameters $E_0$, $\beta$, and $\gamma$ can be adjusted in the `PFMob` section of the parameter file:

```
Material = "pentacene"
...
PFMob {
  beta_e = 1.1
  beta_h = 1.1
  E0_e = 0.0
  E0_h = 0.0
  gamma_e = 0.1
  gamma_h = 0.2
}
...
}
```

Mobility Averaging

with their default parameters: `beta_e=beta_h=0.1`, `E0_e=E0_h=0` (in eV), and `gamma_e=gamma_h=0.0`.

Since the derivative of mobility with respect to the driving force is infinite at zero fields, the evaluation of this derivative is performed by replacing the square root of the driving force with an equivalent approximation having a finite derivative for zero field. The approximation of the square root with the regular square root can be adjusted by specifying the parameter `delta_sqrtReg` in the `PFMob` section of the parameter file. Typical values are in the range 0.1–0.0001; its default value is 0.1.

The model can be activated for both electrons and holes by specifying the keyword `PFMob` as a model for `HighFieldSaturation` in the `Mobility` section and the driving force as a parameter:

```
Physics(Region="pentacene") {
    ...
    Mobility (
        HighFieldSaturation(PFMob Eparallel)
    )
    ...
}
```

The model can also be selected for electrons or holes separately:

```
Physics { Mobility ( [eHighFieldSaturation(PFMob Eparallel)]
                     [hHighFieldSaturation(PFMob Eparallel)]) ...}
```

**NOTE** Because the Poole–Frenkel mobility model is implemented through the high-field saturation framework, all the parameters specified for driving forces (see Driving Force Models on page 395) also apply to this model.

---

# Mobility Averaging

Sentaurus Device computes separate values of the mobility for each vertex of each semiconductor element of the mesh. To guarantee current conservation, these mobilities are then averaged to obtain either one value for each semiconductor element of the mesh or one value for each edge of each semiconductor element.

Element averaging is used by default and requires less memory than element–edge averaging. Element–edge averaging results in a smaller discretization error than element averaging, in particular, when the enhanced Lombardi model (see Enhanced Lombardi Model on page 359) with α<sub>⊥</sub> ≠ 0 is used. The time to compute the mobility is nearly identical for both approaches.

15: Mobility
Mobility Doping File

To select the mobility averaging approach, specify `eMobilityAveraging` and `hMobilityAveraging` in the `Math` section. The value is `Element` for element averaging, and `ElementEdge` for element–edge averaging.

# Mobility Doping File

The `Grid` parameter in the `File` section of a command file can be used to read a TDR file that contains the device geometry, mesh, and doping.

By default, the doping read from this file is used in the mobility calculations previously described.

As an alternative, Sentaurus Device allows the donor and acceptor concentrations *for mobility calculations only* to be read from a separate TDR file. This is accomplished using the `MobilityDoping` parameter:

```
File {
  Grid           = "mosfet.tdr"
  MobilityDoping = "mosfet_mobility.tdr"
}
```

**Notes:**

* The geometry and mesh in the `MobilityDoping` file must match the `Grid` file.

* If a `MobilityDoping` file is specified, then it deactivates the mobility dependency on `IncompleteIonization` if this mobility option is specified.

* Donor and acceptor concentrations read from a `MobilityDoping` file can be specified in the `Plot` section of the command file with `MobilityDonorConcentration` and `MobilityAcceptorConcentration`, respectively.

* For PMI models, the `MobilityDoping` file concentrations can be read using:

```
double Nd = ReadDoping("MobilityDonorConcentration")
double Na = ReadDoping("MobilityAcceptorConcentration")
```

# Effective Mobility

It is often useful to know the effective channel mobility seen by carriers as well as other effective or averaged quantities in the channel. To simplify the task of obtaining such quantities, Sentaurus Device provides an `EffectiveMobility` current plot PMI that extracts several quantities of interest for both electrons and holes.

15: Mobility

Effective Mobility

Table 78 lists the electron quantities extracted by the EffectiveMobility PMI. The extracted hole quantities are analogous.

Table 78 Electron quantities extracted with the EffectiveMobility PMI; hole quantities are analogous ($\tilde{n} = n$ or $n_{\text{SHE}}$ if UseSHEDensity = 0 or 1, respectively)

| Name | Symbol | Start Point or Start Box method | Volume Box method | Unit |
| --- | --- | --- | --- | --- |
| eSheetDensity | $n_{\text{sheet}}$ | $\int_{0}^{s_{\text{max}}} n(s) ds$ | $\frac{\int n(\mathbf{r}) d\Omega}{\int dS}$ | cm-2 |
| eAverageDensity | $n_{\text{avg}}$ | $\frac{1}{s_{\text{max}}} \int_{0}^{s_{\text{max}}} n(s) ds$ | $\frac{\int n(\mathbf{r}) d\Omega}{\int d\Omega}$ | cm-3 |
| eSHESheetDensity | $n_{\text{SHE,sheet}}$ | $\int_{0}^{s_{\text{max}}} n_{\text{SHE}}(s) ds$ | $\frac{\int n_{\text{SHE}}(\mathbf{r}) d\Omega}{\int dS}$ | cm-2 |
| eSHEAverageDensity | $n_{\text{SHE,avg}}$ | $\frac{1}{s_{\text{max}}} \int_{0}^{s_{\text{max}}} n_{\text{SHE}}(s) ds$ | $\frac{\int n_{\text{SHE}}(\mathbf{r}) d\Omega}{\int d\Omega}$ | cm-3 |
| eAverageField | $E_{\text{avg,n}}$ | $\frac{1}{\tilde{n}_{\text{sheet}}} \int_{0}^{s_{\text{max}}} E_{\perp}(s) \tilde{n}(s) ds$ | $\frac{\int \|E(\mathbf{r})\| \tilde{n}(\mathbf{r}) d\Omega}{\int \tilde{n}(\mathbf{r}) d\Omega}$ | V/cm |
| eEffectiveField | $E_{\text{eff,n}}$ | $E_{\text{avg,n}} + \left( \eta_{\text{e}} - \frac{1}{2} \right) \frac{q}{\varepsilon_{\text{s}}} \tilde{n}_{\text{sheet}}$ | $E_{\text{avg,n}} + \left( \eta_{\text{e}} - \frac{1}{2} \right) \frac{q}{\varepsilon_{\text{s}}} \tilde{n}_{\text{sheet}}$ | V/cm |
| eChargeEffField | $E_{\text{eff,ch,n}}$ | $\frac{q}{\varepsilon_{\text{s}}} \left( \int_{0}^{s_{\text{max}}} (N_{\text{A}} - N_{\text{D}} - p) ds + \eta_{\text{e}} \tilde{n}_{\text{sheet}} \right)$ | $\frac{q}{\varepsilon_{\text{s}}} \left( \frac{\int (N_{\text{A}} - N_{\text{D}} - p) d\Omega}{\int dS} + \eta_{\text{e}} \tilde{n}_{\text{sheet}} \right)$ | V/cm |
| eMobility | $\mu_{\text{eff,n}}$ | $\frac{1}{\tilde{n}_{\text{sheet}}} \int_{0}^{s_{\text{max}}} \mu_{\text{n}}(s) \tilde{n}(s) ds$ | $\frac{\int \mu_{\text{n}}(\mathbf{r}) \tilde{n}(\mathbf{r}) d\Omega}{\int \tilde{n}(\mathbf{r}) d\Omega}$ | cm2/Vs |
| eStressFactorXX | $\left( \frac{\mu_{\text{n,xx}}}{\mu_{\text{n0}}} \right)_{\text{eff}}$ | $\frac{1}{\tilde{n}_{\text{sheet}} \mu_{\text{eff,n}}} \int_{0}^{s_{\text{max}}} \left( \frac{\mu_{\text{n,xx}}}{\mu_{\text{n0}}} \right) \mu_{\text{n}}(s) \tilde{n}(s) ds$ | $\frac{\int (\mu_{\text{n,xx}} / \mu_{\text{n0}}) \mu_{\text{n}}(\mathbf{r}) \tilde{n}(\mathbf{r}) d\Omega}{\int \mu_{\text{n}}(\mathbf{r}) \tilde{n}(\mathbf{r}) d\Omega}$ | 1 |
| eStressFactorYY | $\left( \frac{\mu_{\text{n,yy}}}{\mu_{\text{n0}}} \right)_{\text{eff}}$ | $\frac{1}{\tilde{n}_{\text{sheet}} \mu_{\text{eff,n}}} \int_{0}^{s_{\text{max}}} \left( \frac{\mu_{\text{n,yy}}}{\mu_{\text{n0}}} \right) \mu_{\text{n}}(s) \tilde{n}(s) ds$ | $\frac{\int (\mu_{\text{n,yy}} / \mu_{\text{n0}}) \mu_{\text{n}}(\mathbf{r}) \tilde{n}(\mathbf{r}) d\Omega}{\int \mu_{\text{n}}(\mathbf{r}) \tilde{n}(\mathbf{r}) d\Omega}$ | 1 |

15: Mobility
Effective Mobility

Table 78 Electron quantities extracted with the EffectiveMobility PMI; hole quantities are analogous ($\tilde{n} = n$ or $n_{\text{SHE}}$ if UseSHEDensity = 0 or 1, respectively) (Continued)

| Name | Symbol | Start Point or Start Box method | Volume Box method | Unit |
| --- | --- | --- | --- | --- |
| eStressFactorZZ | $\left( \frac{\mu_{n,zz}}{\mu_{n0}} \right)_{\text{eff}}$ | $\frac{1}{\tilde{n}_{\text{sheet}} \mu_{\text{eff,n}}} \int_{0}^{s_{\text{max}}} \left( \frac{\mu_{n,zz}}{\mu_{n0}} \right) \mu_{n}(s) \tilde{n}(s) ds$ | $\frac{\int (\mu_{n,zz} / \mu_{n0}) \mu_{n}(r) \tilde{n}(r) d\Omega}{\int \mu_{n}(r) \tilde{n}(r) d\Omega}$ | 1 |

# EffectiveMobility PMI Methods

The EffectiveMobility PMI provides different methods for extracting quantities from the device:

*   The *Start Point method* extracts quantities at a single point in the channel. The method is invoked by specifying the `Start` parameter (see Using the EffectiveMobility PMI) to identify the starting location for a line that will pass through the structure. The extracted quantities will be obtained from integrals along this line. By default, the selected `Start` location will snap to the nearest semiconductor–insulator interface vertex, and the line will be normal to the interface.

*   The *Start Box method* is an extension of the Start Point method and is used to extract quantities over an extended region of the channel. The method is invoked by specifying the `StartBoxMin` and `StartBoxMax` parameters to surround the portion of the semiconductor–insulator interface where the extraction will occur. All interface vertices enclosed in the start box will be used as starting locations for line integrals through the device. The reported extracted quantities will be an interface-area weighted average of all the calculated line integrals.

*   In contrast to the previous method, the quantities extracted with the *Volume Box method* will be obtained by performing volume integrals over a selected portion of the device. The method is invoked by specifying the `BoxMin` and `BoxMax` parameters to identify where the integration should occur. The specified box should surround both the interface and volume of interest. The size of the semiconductor–insulator interface area enclosed in the box will be extracted and used in the calculations whenever a sheet density (#/cm<sup>2</sup>) is required.

# Using the EffectiveMobility PMI

To include the quantities listed in Table 78 on page 412 in the current plot file, specify one or more instances of the EffectiveMobility PMI in the `CurrentPlot` section of the command file. The syntax and options for the EffectiveMobility PMI are:

```
CurrentPlot {
  PMIModel (
    Name = "EffectiveMobility"
```

Effective Mobility

```
        [GroupName = <string>]
        [ [ Start = (x₀, y₀, z₀) [SnapToNode = 0 | 1] ] |
          [ StartBoxMin = (xₘᵢₙ, yₘᵢₙ, zₘᵢₙ) StartBoxMax = (xₘₐₓ, yₘₐₓ, zₘₐₓ) ]
          [Direction = (dx, dy, dz)] [Depth = sₘₐₓ] ] |
        [BoxMin = (xₘᵢₙ, yₘᵢₙ, zₘᵢₙ) BoxMax = (xₘₐₓ, yₘₐₓ, zₘₐₓ) [Width = <float>] ]
        [Region = (<string1>, <string2>, ...)]
        [ChannelType = -1 | 1 | 0]
        [eta_e = ηₑ] [eta_h = ηₕ] [epsilon = εₛ/ε₀]
        [UseSHEDensity = 0 | 1]
    )
}
```

The parameters are described here:

*   GroupName is the name of the data group for the extracted quantities. A data group with this name will appear in Sentaurus Visual or Inspect when a current plot file (`*.plt` file) is loaded. The default group name is `"Channel"`. If there is more than one `EffectiveMobility` PMI used in a `CurrentPlot` section, GroupName must be used to distinguish between different sets of results.

*   Start specifies the starting location used in the Start Point method. All coordinates must be specified in μm. Only the coordinates corresponding to the dimensionality of the structure are required (for example, only x₀ and y₀ in two dimensions).

*   SnapToNode is used to snap the Start location to the nearest semiconductor–insulator interface vertex. Specify SnapToNode=1 to snap (default). Specify SnapToNode=0 to not snap.

*   Direction is used to specify a direction vector for the line along which the line integrals will be performed. By default, the direction for lines initiated at a semiconductor–insulator interface vertex will be taken as normal to the interface. If `Direction` is specified, the units are arbitrary, as the specified direction vector will be normalized.

*   Depth is the line integration distance in μm. The default is 0.5 μm. The actual integration distance can be shorter if the line encounters a structure boundary, a non-semiconductor material, or a region not included in the `Region` list (see below). `Depth` is usually chosen so that contributions to the integral beyond a distance of `Depth` are negligible.

*   StartBoxMin and StartBoxMax specify the minimum and maximum coordinates for a box that surrounds the semiconductor–insulator interface starting points used in the Start Box method. All coordinates are specified in μm.

*   BoxMin and BoxMax specify the minimum and maximum coordinates for a box that surrounds the semiconductor volume and interface used in the Volume Box method. All coordinates are specified in μm.

*   Width represents an interface length in two dimensions or an interface area in three dimensions, and is used when sheet densities are required for the extracted quantities. `Width` must be specified in μm for 2D structures and μm² for 3D structures. If `Width` is not specified, the interface length or area is extracted automatically from the portion of the interface enclosed within the user-specified box. A default value of `width` = 0.04 μm in

15: Mobility
References

two dimensions or 0.0016 μm<sup>2</sup> in three dimensions will be used if an interface length or area cannot be found.

*   Region can optionally be used to specify a list of region names where the extraction calculations will be confined. If `Region` is not specified, all semiconductor regions will be considered.

*   ChannelType specifies which quantities are extracted as follows:

    *   Specify `ChannelType=-1` to extract electron quantities.

    *   Specify `ChannelType=1` to extract hole quantities.

    *   Specify `ChannelType=0` to extract both quantities.

*   eta_e, eta_h, and epsilon are parameters used in the calculation of effective fields. Their default values are `eta_e=0.5`, `eta_h=0.333333`, and `epsilon=11.7`.

*   UseSHEDensity specifies whether the standard carrier densities (`UseSHEDensity=0`) or the SHE carrier densities (`UseSHEDensity=1`) are used as the weighting functions in the integral calculations. The default is `UseSHEDensity=0`.

# References

[1] C. Lombardi *et al.*, “A Physically Based Mobility Model for Numerical Simulation of Nonplanar Devices,” *IEEE Transactions on Computer-Aided Design*, vol. 7, no. 11, pp. 1164–1171, 1988.

[2] G. Masetti, M. Severi, and S. Solmi, “Modeling of Carrier Mobility Against Carrier Concentration in Arsenic-, Phosphorus-, and Boron-Doped Silicon,” *IEEE Transactions on Electron Devices*, vol. ED-30, no. 7, pp. 764–769, 1983.

[3] N. D. Arora, J. R. Hauser, and D. J. Roulston, “Electron and Hole Mobilities in Silicon as a Function of Concentration and Temperature,” *IEEE Transactions on Electron Devices*, vol. ED-29, no. 2, pp. 292–295, 1982.

[4] S. Reggiani *et al.*, “A Unified Analytical Model for Bulk and Surface Mobility in Si n- and p-Channel MOSFET’s,” in *Proceedings of the 29th European Solid-State Device Research Conference (ESSDERC)*, Leuven, Belgium, pp. 240–243, September 1999.

[5] S. Reggiani *et al.*, “Electron and Hole Mobility in Silicon at Large Operating Temperatures—Part I: Bulk Mobility,” *IEEE Transactions on Electron Devices*, vol. 49, no. 3, pp. 490–499, 2002.

[6] M. S. Shur, “Low Ballistic Mobility in Submicron HEMTs,” *IEEE Electron Device Letters*, vol. 23, no. 9, pp. 511–513, 2002.

## References

[7] A. Erlebach, K. H. Lee, and F. M. Bufler, “Empirical Ballistic Mobility Model for Drift-Diffusion Simulation,” in *Proceedings of the 46th European Solid-State Device Research Conference (ESSDERC)*, Lausanne, Switzerland, pp. 420–423, September 2016.

[8] S. C. Choo, “Theory of a Forward-Biased Diffused-Junction P-L-N Rectifier—Part I: Exact Numerical Solutions,” *IEEE Transactions on Electron Devices*, vol. ED-19, no. 8, pp. 954–966, 1972.

[9] N. H. Fletcher, “The High Current Limit for Semiconductor Junction Devices,” *Proceedings of the IRE*, vol. 45, no. 6, pp. 862–872, 1957.

[10] A. Schenk, *Advanced Physical Models for Silicon Device Simulation*, Wien: Springer, 1998.

[11] D. B. M. Klaassen, “A Unified Mobility Model for Device Simulation—I. Model Equations and Concentration Dependence,” *Solid-State Electronics*, vol. 35, no. 7, pp. 953–959, 1992.

[12] M. N. Darwish et al., “An Improved Electron and Hole Mobility Model for General Purpose Device Simulation,” *IEEE Transactions on Electron Devices*, vol. 44, no. 9, pp. 1529–1538, 1997.

[13] S. A. Mujtaba, *Advanced Mobility Models for Design and Simulation of Deep Submicrometer MOSFETs*, PhD thesis, Stanford University, Stanford, CA, USA, December 1995.

[14] W. Hänsch and M. Miura-Mattausch, “The hot-electron problem in small semiconductor devices,” *Journal of Applied Physics*, vol. 60, no. 2, pp. 650–656, 1986.

[15] S. Takagi et al., “On the Universality of Inversion Layer Mobility in Si MOSFET’s: Part I—Effects of Substrate Impurity Concentration,” *IEEE Transactions on Electron Devices*, vol. 41, no. 12, pp. 2357–2362, 1994.

[16] G. Baccarani, *A Unified mobility model for Numerical Simulation*, Parasitics Report, DEIS-University of Bologna, Bologna, Italy, 1999.

[17] H. Tanimoto et al., “Modeling of Electron Mobility Degradation for HfSiON MISFETs,” in *International Conference on Simulation of Semiconductor Processes and Devices (SISPAD)*, Monterey, CA, USA, September 2006.

[18] W. J. Zhu and T. P. Ma, “Temperature Dependence of Channel Mobility in HfO<sub>2</sub>-Gated NMOSFETs,” *IEEE Electron Device Letters*, vol. 25, no. 2, pp. 89–91, 2004.

[19] S. Reggiani et al., “Low-Field Electron Mobility Model for Ultrathin-Body SOI and Double-Gate MOSFETs With Extremely Small Silicon Thicknesses,” *IEEE Transactions on Electron Devices*, vol. 54, no. 9, pp. 2204–2212, 2007.

[20] C. Canali et al., “Electron and Hole Drift Velocity Measurements in Silicon and Their Empirical Relation to Electric Field and Temperature,” *IEEE Transactions on Electron Devices*, vol. ED-22, no. 11, pp. 1045–1047, 1975.

**15: Mobility**
References

[21] D. M. Caughey and R. E. Thomas, “Carrier Mobilities in Silicon Empirically Related to Doping and Field,” *Proceedings of the IEEE*, vol. 55, no. 12, pp. 2192–2193, 1967. https://doi.org/10.1109/PROC.1967.6123

[22] J. J. Barnes, R. J. Lomax, and G. I. Haddad, “Finite-Element Simulation of GaAs MESFET’s with Lateral Doping Profiles and Submicron Gates,” *IEEE Transactions on Electron Devices*, vol. ED-23, no. 9, pp. 1042–1048, 1976.

[23] M. Farahmand et al., “Monte Carlo Simulation of Electron Transport in the III-Nitride Wurtzite Phase Materials System: Binaries and Ternaries,” *IEEE Transactions on Electron Devices*, vol. 48, no. 3, pp. 535–542, 2001.

[24] V. M. Polyakov and F. Schwierz, “Influence of Electron Mobility Modeling on DC *I–V* Characteristics of WZ-GaN MESFET,” *IEEE Transactions on Electron Devices*, vol. 48, no. 3, pp. 512–516, 2001.

[25] B. Meinerzhagen and W. L. Engl, “The Influence of the Thermal Equilibrium Approximation on the Accuracy of Classical Two-Dimensional Numerical Modeling of Silicon Submicrometer MOS Transistors,” *IEEE Transactions on Electron Devices*, vol. 35, no. 5, pp. 689–697, 1988.

[26] O. Penzin et al., “Kinetic Velocity Model to Account for Ballistic Effects in the Drift-Diffusion Transport Approach,” *IEEE Transactions on Electron Devices*, vol. 64, no. 11, pp. 4599–4606, 2017.

[27] W. R. Frensley, “Barrier-Limited Transport in Semiconductor Devices,” *IEEE Transactions on Electron Devices*, vol. ED-30, no. 12, pp. 1619–1623, 1983.

[28] F. M. Bufler and W. Fichtner, “Hole and electron transport in strained Si: Orthorhombic versus biaxial tensile strain,” *Applied Physics Letters*, vol. 81, no. 1, pp. 82–84, 2002.

[29] M. T. Currie et al., “Carrier mobilities and process stability of strained Si n- and p-MOSFETs on SiGe virtual substrates,” *Journal of Vacuum Science & Technology B*, vol. 19, no. 6, pp. 2268–2279, 2001.

[30] C. W. Leitz et al., “Hole mobility enhancements and alloy scattering-limited mobility in tensile strained Si/SiGe surface channel metal–oxide–semiconductor field-effect transistors,” *Journal of Applied Physics*, vol. 92, no. 7, pp. 3745–3751, 2002.

[31] F. M. Bufler, *Full-Band Monte Carlo Simulation of Electrons and Holes in Strained Si and SiGe*, München: Herbert Utz Verlag, 1998.

[32] R. Braunstein, A. R. Moore, and F. Herman, “Intrinsic Optical Absorption in Germanium-Silicon Alloys,” *Physical Review*, vol. 109, no. 3, pp. 695–710, 1958.

References

 