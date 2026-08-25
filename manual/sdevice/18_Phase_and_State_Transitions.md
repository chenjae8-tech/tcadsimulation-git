# CHAPTER 18 Phase and State Transitions

*This chapter presents a framework for the simulation of local phase or state transitions.*

State transitions appear in device physics in various forms. Typical examples are the charge traps as described in Chapter 17 on page 489. In phase-change memory (PCM) devices, different phases (for example, crystalline and amorphous) of chalcogenides are used to store information and can be modeled with the framework described here. Furthermore, in the hydrogen transport degradation model (see MSC–Hydrogen Transport Degradation Model on page 555), diffusing mobile hydrogen species might be trapped in localized states.

In this chapter, a general modeling framework called *multistate configuration* (MSC) is presented to describe transitions between phases or states. The framework allows the specification of an arbitrary number of states that interact locally by an arbitrary number of transitions. The states can be charged and carry hydrogen atoms. Transitions between two states might interact with the conduction and valence band, or with hydrogen diffusion equations to preserve charge and the number of hydrogen atoms. The structure of transitions is limited to a linear local dependency between the state occupation rates. However, arbitrary nonlinear local dependency on the solution variables of the transport equations are allowed using PMI models. The state occupation rates are solved self-consistently with the transport model both for stationary and dynamic characteristics.

## Multistate Configurations and Their Dynamic

A multistate configuration (MSC) is defined by the number of states $N$ and the state occupation probabilities $s_1, \dots, s_N$ satisfying the condition:

$$ \sum_{i} s_i = 1 \tag{548} $$

For two states $i$ and $j$, an arbitrary number of transitions (described by capture and emission rates) is allowed. The dynamic equation is then given by:

$$ \dot{s}_i = \sum_{j \neq i} \sum_{t \in T_{ij}} c_{ij} s_j - e_{ij} s_i \tag{549} $$

Multistate Configurations and Their Dynamic

where $T_{ij}$ is the set of transitions between $i$ and $j$. For such a transition $t \in T_{ij}$ with capture and emission rates $c$ and $e$, respectively, you have $c = c_{ij} = e_{ji}$ and $e = e_{ij} = c_{ji}$ if $i$ and $j$ denote the reference state and interacting state, respectively. The problem can be written in the compact form:

$$ \dot{s} = Ts $$ (550)

where $T$ is the total transition matrix, composed of the individual transition matrices.

Each state can carry a number $K^Q$ of (positive) charges and a number $K^H$ of hydrogen atoms (both numbers can be positive or negative, and are zero by default). Transitions between two states must satisfy conservation laws for both quantities. Required particles can be taken from several reservoirs. Reservoir particles are characterized by the corresponding numbers $K_r^Q$ and $K_r^H$, and transitions specify the number $P_r$ of involved reservoir particles. The conservation laws then read:

$$ K_i - K_j = \sum_r P_r K_r $$ (551)

where $K_i$ and $K_j$ are the characteristic numbers for the reference and interacting states of the transition, respectively. The sum is taken over all reservoirs involved in the transition.

Table 98 lists the available particle reservoirs and their characteristics. The reservoirs of hydrogen atoms, molecules, and ions represent the corresponding mobile species in the hydrogen transport degradation model. Their use is illustrated in Reactions With Multistate Configurations on page 559.

The resulting space charge and recombination terms with the corresponding equations are taken into account automatically.

Table 98 MSC particle reservoirs and their characteristics

| Description | Identifying string | Particle | Charge $K^Q$ | Hydrogen $K^H$ | Equation |
| --- | --- | --- | --- | --- | --- |
| Conduction band | CB | electron | -1 | 0 | Electron |
| Valence band | VB | hole | 1 | 0 | Hole |
| Hydrogen atoms | HydrogenAtom | $H$ | 0 | 1 | HydrogenAtom |
| Hydrogen molecules | HydrogenMolecule | $H_2$ | 0 | 2 | HydrogenMolecule |
| Hydrogen ions | HydrogenIon | $H^+$ | 1 | 1 | HydrogenIon |

**18: Phase and State Transitions**

Specifying Multistate Configurations

# Specifying Multistate Configurations

A multistate configuration is specified by an `MSConfig` section placed into an `MSConfigs` section of a (region or material or global or interface) `Physics` section. It is described by its states (at least two) and transitions (each state must be involved in at least one transition) using the keywords `State` and `Transition`. An arbitrary number of `MSConfig` sections is allowed.

```
Physics ( Region = "si" ) {
  MSConfigs (
    MSConfig ( Name = "ca"
      State ( Name = "c" ) State ( Name = "a" )
      Transition ( Name = "t1"
        To="c" From="a" CEModel("pmi_ce_msc" 0))
    )
    ...
  )
}
```

This example specifies a multistate configuration with two states and one transition between them. See Table 311 on page 1605 for the parameters supported by `MSConfig`.

`State` requires a `Name` as an identifier. The state can carry both a number of positive charges by specifying `Charge`, and a number of hydrogen atoms by using `Hydrogen`.

`Transition` requires several parameters. The keyword `CEModel` specifies a transition model including its optional model index (see Transition Models on page 531). The reference and interacting states of the transition are selected by the keywords `To` and `From`, respectively. A `Name` specification is mandatory as well.

A transition between differently charge states (correspondingly for hydrogen atoms) requires additional charged particles to preserve the total charge. With `Reservoirs`, you can specify a list of reservoirs (`CB` and `VB` for the conduction band and valence band, respectively), which provides the necessary number of particles specified by `Particles` as an argument to the reservoir. The conduction band serves as an electron reservoir, and the valence band is a hole reservoir.

# Multistate Configurations on Interfaces

You can also define MSCs on interfaces. Therefore, an MSC might look like the following example:

```
Physics (MaterialInterface="Oxide/Silicon") {
  MSConfigs (
    MSConfig (
```

Specifying Multistate Configurations

```
      Name="msc0"
      State(Name="s0" Charge=0 Hydrogen=1)
      State(Name="s1" Charge=1 Hydrogen=0)
      Transition (
        Name="Depassivation" CEModel("CEModel_PMI",1)
        To="s1" From="s0"
        Reservoirs("VB"(Particles=+1) "HydrogenAtom"(Particles=-1))
        FieldFromInsulator
      )
    )
  )
}
```

Observe that, for interface MSCs, the reservoirs refer to bulk reservoirs. At interfaces between the insulator and semiconductor, you can explicitly require that the field from the insulator is selected by using `FieldFromInsulator` in the MSC specification.

# Additional Remarks

An eNeutral level trap of the form:

```
(Name="eN" eNeutral Conc=1.e+13 CBRate=("pmi_ce0" 0) VBRate=("pmi_ce0" 1))
```

can be specified equivalently as an MSC in the following way:

```
MSConfig ( Name="eN" Conc=1.e+13
  State ( Name="s0" Charge=0 ) State ( Name="s1" Charge=-1 )
  Transition ( Name="tCB" CEModel("pmi_ce0" 0)
    To="s1" From="s0" Reservoirs("CB"(Particles=+1)))
  Transition ( Name="tVB" CEModel("pmi_ce0" 1)
    To="s0" From="s1" Reservoirs("VB"(Particles=+1)))
)
```

For all multistate configurations, the dynamic is always solved implicitly, that is, no extra equation needs to be specified as an argument to the `Coupled` or `Transient` solve statements.

**NOTE** Only quasistationary and transient simulations support multistate configurations. Small-signal analysis (see Small-Signal AC Analysis on page 101), harmonic balance analysis (see Harmonic Balance on page 106), and noise analysis (see Chapter 23 on page 729) do not support multistate configurations.

The computation of state occupation is influenced by the `TrapFilling` option of the `Set` and `Unset` statements in the `Solve` section (see Table 331 on page 1623). It is frozen if the trap-filling option `Frozen` is

18: Phase and State Transitions
Transition Models

set; otherwise, the occupation rates are treated as free. You can release the frozen status again by the `Unset(TrapFilling)` statement.

The transition dynamic might become numerically unstable, that is, it cannot be solved with sufficient accuracy if, for example, the forward and backward rates of all transitions at one operation point differ by several orders of magnitude. Using `-Elimination` in `MSConfig` applies a different solving algorithm, often improving the numeric robustness in such cases.

The state occupation probabilities can be plotted in groups or individually by specifying `MSConfig` (see Table 329 on page 1621) in the `Plot` section.

# Transition Models

The MSC framework allows an arbitrary number of transitions between two states of an MSC. Each transition model can be either the model `pmi_ce_msc`, or a trap capture and emission PMI (see Trap Capture and Emission Rates on page 1356).

## The pmi_ce_msc Model

The `pmi_ce_msc` transition model supports the following features:

* Arbitrary number of states and transitions

* Charge states

* Several transition rate models (nucleation, growth, electron and hole exchange)

* Equilibrium computation (necessary for detailed balance processes)

* Energy and particle exchange

### States

The states are described by a base energy $E_i$, a degeneracy factor $g_i$, the number of negative elementary charges $K_i$ (an arbitrary integer), and the energy $E_i^-$ of one electron in the state. The inner energy of the state is then:

$$ H_i = E_i + K_i E_i^- $$ (552)

The electron energy is the sum of the valence band energy and the user-specified value $E_{i, \text{ user}}^-$.

Transition Models

## Equilibrium

The equilibrium occupation probabilities $s_i^*$ are needed to guarantee the detailed balance principle for all transitions. The equilibrium is determined by the state parameters, the temperature, and the Fermi levels of the involved particle reservoirs. You have:

$$ Z_i = g_i \exp(-\beta(H_i - K_i E_F)) \tag{553} $$

$$ Z = \sum_i Z_i \tag{554} $$

$$ s_i^* = Z_i / Z \tag{555} $$

Here, $E_F$ is the quasi-Fermi energy and $\beta$ is the thermodynamic beta. The quasi-Fermi energy is approximated inside the PMI. Let the (approximated) intrinsic density $n_I$ and the intrinsic Fermi energy $E_I$ be:

$$ n_I = \sqrt{N_C N_V \exp(-\beta E_g)} \tag{556} $$

$$ E_I = \frac{1}{2} \left[ (E_C + E_V) + kT \ln \left( \frac{N_V}{N_C} \right) \right] \tag{557} $$

Then, the carrier quasi-Fermi energies are approximated from the carrier densities by:

$$ E_{F,n} = E_I + kT \ln \left( \frac{n}{n_I} \right) \tag{558} $$

$$ E_{F,p} = E_I - kT \ln \left( \frac{p}{n_I} \right) \tag{559} $$

and equilibrium Fermi energy then as:

$$ E_F = \frac{1}{2} (E_{F,n} + E_{F,p}) \tag{560} $$

## Transitions

You can select the transition models, listed in Table 99 on page 533, by using the `Formula` parameter in the parameter file.

**18: Phase and State Transitions**
Transition Models

In this section, $i$ denotes the *to* state, while $j$ specifies the *from* state of the transition. For most of the models, only the forward reaction rate (capture) is given, while the backward reaction rate (emission) is computed by:

$$ \frac{e}{c} = \frac{s_j^*}{s_i^*} \tag{561} $$

if not stated otherwise.

Table 99 The pmi_ce_msc transition models

| Description | Formula |
| --- | --- |
| Arrhenius law | 0 |
| Nucleation according to Peng | 1 |
| Growth according to Peng | 2 |
| Single trap | 7 |
| MSC trap | 8 |

## Arrhenius Law (Formula=0)

The forward reaction rate (capture) is given by:

$$ c = r_0 \exp(-\beta E_{\text{act}}) \tag{562} $$

where $r_0$ is the maximal transition frequency and $E_{\text{act}}$ is the activation energy.

## Nucleation According to Peng (Formula=1)

A nucleation model, in analogy to the model in [[1]](https://example.com), [[2]](https://example.com), and [[3]](https://example.com), is given by:

$$ c_N = r_0 \exp(-\beta(E_{\text{act}} + \Delta G^*(T))) \tag{563} $$

where:

$$ \Delta G^*(T) = \frac{16\pi}{3} \frac{\gamma_{\text{SL}}^3}{\Delta G(T)^2} \tag{564} $$

$$ \Delta G(T) = \begin{cases} \Delta H_2 \left[ 1 - \frac{T}{T_g} \left( 1 - \frac{\Delta H_1 T_m - T_g}{\Delta H_2 T_m} \right) \right] & \text{if } T < T_g \\ \Delta H_1 \frac{T_m - T}{T_m} & \text{if } T_g < T < T_m \\ 0 & \text{if } T_m < T \end{cases} \tag{565} $$

Transition Models

## Growth According to Peng (Formula=2)

Growing crystalline phases is often described by a growth velocity, for example, in [1]. Some of the growing model has been adopted in the following local model, which reads as:

$$ c_{\text{G}} = r_0 [1 - \exp(-\beta \Delta G(T) v_{\text{MM}})] \exp(-\beta E_{\text{act}}) $$ (566)

if $T < T_{\text{m}}$; otherwise, it is zero.

## Single-Trap Transition (Formula=7)

This model depends on the carrier density $d_{\text{c}}$. It resembles some standard trap models and is intended to be used in two-state MSCs only. If the number of electrons in the reference state is greater than in the interacting state, that is, $K_i > K_j$, then the capture process depends on the electron density and uses $d_{\text{c}} = n$. If $K_i < K_j$, then $d_{\text{c}} = p$; otherwise, you use $d_{\text{c}} = 0$. The capture rate is then given by:

$$ c = \sigma v_{\text{th}} d_{\text{c}} $$ (567)

where $\sigma$ is the cross section and $v_{\text{th}}$ is the thermal velocity. The emission rate for electron capturing is computed as:

$$ e = c \exp(\beta(E_{\text{T}} - E_{\text{F}, n})) $$ (568)

where $E_{\text{T}}$ is the trap energy. For hole-capturing, the emission rate reads as:

$$ e = c \exp(\beta(E_{\text{F}, p} - E_{\text{T}})) $$ (569)

## MSC Trap With Emulated Detailed Balance (Formula=8)

The actual model generalizes the single-trapping model (Formula=7) to general MSC states and transitions. The capture rate is computed as in the single trapping case above. The emission rate, however, is computed as follows. Let $N_n$ and $N_p$ be the number of electrons and holes, respectively, which are destroyed during the process. Then, you have:

$$ N_n - N_p = K_i - K_j $$ (570)

and you require:

$$ \frac{e}{c} = g_{ji} \exp(-N_n \beta_n (E_{\text{F}, n} - \overline{E_{\text{C}}}) + N_p \beta_p (E_{\text{F}, p} - \overline{E_{\text{V}}}) + \beta_l (-N_n \overline{E_{\text{C}}} + N_p \overline{E_{\text{V}}} - H_{ji})) $$ (571)

where you used $g_{ji} = g_j / g_i$ and $H_{ji} = H_j - H_i$.

**18: Phase and State Transitions**
Transition Models

The average conduction band and valence band energies are:

$$ \overline{E_C} = E_C + \frac{3}{2}kT_n \quad \text{and} \quad \overline{E_V} = E_V - \frac{3}{2}kT_p \eqno(572) $$

In thermal equilibrium, the detailed balance principle is satisfied.

## Model Parameters

The model requires parameters for all states and transitions to allow a consistent computation of the thermal equilibrium of the MSC as a whole. Therefore, parameters are grouped into global, state, and transition parameters.

The parameters `nb_states` and `nb_transitions` determine the number of states and transitions, respectively, and must be both consistent with the command file specification. The parameter `sindex<int>` specifies for the `<int>`-th state a parameter index, which determines a prefix for the state parameters. For example, given `sindex0=5`, the parameters prefixed with `s5_` are read for the 0-th state. A similar parameter index selection is available for transitions using the parameters `tindex<int>` (for example, `tindex2=7` reads the parameters prefixed by `t7_`).

For transitions, the specified parameter index must coincide with the model index of the transition in the command file.

Table 100 Global parameters

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| plot | — | 0 | — | {0,1} | Plots some properties to screen |
| nb_states | — | 0 | — | >=0, integer | Number of states |
| nb_transitions | — | 0 | — | >=0, integer | Number of transitions |
| sindex<int> | — | — | — | >=0, integer | Parameter index of <int>-th state |
| tindex<int> | — | — | — |  | Parameter index of <int>-th transition |

Table 101 Global material and default transition parameters of pmi_ce_msc

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| E_g | $E_g$ | 0.5 | eV | >0. | Band gap |
| N_C | $N_C$ | $1 \times 10^{19}$ | cm-3 | >0. | Electron density-of-states |
| N_V | $N_V$ | $1 \times 10^{19}$ | cm-3 | >0. | Hole density-of-states |

535

Transition Models

Table 101 Global material and default transition parameters of pmi_ce_msc (Continued)

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| Tm | Tm | 1 × 10100 | K | >0. | Melting temperature |
| Tg | Tg | 1 × 10100 | K | >0. | Glass temperature |
| DeltaH1 | ΔH1 | 0. | J/cm3 | >0. | Heat of solid-to-liquid |
| DeltaH2 | ΔH2 | 0. | J/cm3 | >0. | Heat of amorphous-to-crystalline |
| GammaSL | γSL | 0. | J/cm2 | >0. | Interfacial free-energy density |
| MM_volume | vMM | 0. | cm3 | >0. | Monomer volume |
| Reference_E_T | – | 0 | – | {0,1,2} | Reference energy for ET |

Table 102 Reference_E_T interpretation

| Value | Symbol | Description |
| --- | --- | --- |
| 0 | ET = (EC + EV)/2 + ET, user | Midgap |
| 1 | ET = EC – ET, user | Conduction band |
| 2 | ET = EV + ET, user | Valence band |

Table 103 State parameters

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| E | Ei | 0. | eV | real | Constant base energy |
| g | gi | 1. | 1 | >0. | Degeneracy |
| charge | –Ki | 0 | 1 | integer | Number of positive elementary charges |
| E_charge | Ei, user– | 0. | eV | real | Particle energy with respect to valence band |
| E_nb_Tpairs | – | 0 | – | >=0 | Number of interpolation points for base energy |
| E_Tp<int>_X | – | – | K |  | Temperature of <int>-th interpolation point |
| E_Tp<int>_Y | – | – | eV |  | Energy of <int>-th interpolation point |

Alternatively, the base energy can be described as a piecewise linear (pwl) function of the temperature: With `E_nb_Tpairs`, you specify the number of interpolation points. For the `<int>`-th interpolation point (0 ≤ `<int>` < `E_nb_Tpairs`), you must specify with `E_Tp<int>_X` the temperature and with `E_Tp<int>_Y`, the corresponding energy. The pwl specification is used if `E_nb_Tpairs` is greater than zero.

Some transition parameters are inherited from the global specification (see Table 101 on page 535). They can be overwritten for specific transitions by using the appropriate parameter prefix. Table 104 on page 537 lists additional transition parameters.

**18: Phase and State Transitions**
Interaction of Multistate Configurations With Transport

Table 104 Transition parameters of pmi_ce_msc

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| CB_nb_particles | $N_n$ | 0 | 1 | integer | Particle number of reservoir CB |
| E_T | $E_{T, \text{ user}}$ | 0. | eV | real | Trap energy |
| Eact | $E_{\text{act}}$ | 0. | eV | real | Activation energy |
| formula | – | – | – | Table 99 | Model selection |
| r0 | $r_0$ | 1. | Hz | >0. | Maximal frequency |
| s0 | – | – | – |  | Parameter index of ‘to’ state |
| s1 | – | – | – |  | Parameter index of ‘from’ state |
| sigma | $\sigma$ | $1 \times 10^{-15}$ | cm$^2$ | >0 | Cross section |
| VB_nb_particles | $N_p$ | 0 | 1 | integer | Particle number of reservoir VB |
| vth | $v_{\text{th}}$ | $1 \times 10^7$ | cm/s | >0 | Thermal velocity |

# Interaction of Multistate Configurations With Transport

Multistate configurations (MSCs) have a direct impact on the transport through their charge density and their recombination rates with selected reservoirs. Furthermore, several physical models can be made explicitly dependent on the occupation probabilities of a specific MSC by using the PMI.

## Apparent Band-Edge Shift

The keywords `eBandEdgeShift`, `hBandEdgeShift`, or `BandEdgeShift` in an `MSConfig` section switch on band-edge shift models for the conduction band, the valence band, or both, respectively. The model itself is either the MSC-dependent `pmi_msc_abes` model (see The pmi_msc_abes Model on page 538) or a user-defined `PMI_MSC_ApparentBandEdgeShift` model as described in Multistate Configuration–Dependent Apparent Band-Edge Shift on page 1284.

The apparent band-edge shifts become visible only if the density gradient transport model is used. To avoid the implicit use of the density gradient quantum correction model, the (electron and hole) `gamma` parameters in the `QuantumPotentialParameters` parameter set must be set to zero in the parameter file.

Interaction of Multistate Configurations With Transport

A typical simulation is:

```
Physics {
  MSConfigs (
    MSConfig ( ...
      eBandEdgeShift ( "pmi_abes" 0 )
      hBandEdgeShift ( "pmi_abes" 1 )
    )
  )
  eQuantumPotential
  hQuantumPotential
}
Solve {
  Coupled { Poisson Electron Hole Temperature eQuantumPotential
            hQuantumPotential }
  Transient ( ... ) {
    Coupled { Poisson Electron Hole Temperature eQuantumPotential
              hQuantumPotential }
  }
}
```

Here, the user PMI model `pmi_abes` has been used for both the conduction and valence bands.

## The pmi_msc_abes Model

The `pmi_msc_abes` model depends on the lattice temperature $T$ and, if an MSC is specified, on the state occupation probabilities $s_i$, and it reads as:

$$ \Lambda = \sum_{i} \Lambda_i(T) s_i $$ (573)

where the sum is taken over all MSC states, and $\Lambda_i(T)$ is the apparent band-edge shift (ABES) of state $i$.

The model is activated by using (here, for electrons, a MSC named "m0", and a model index 5) as described above:

```
eBandEdgeShift ( "pmi_msc_abes" 5 )
```

The model uses a two-level or three-level hierarchy (depending on `use_mi_pars`) to determine the state parameters, namely, the global, the model index, and the state parameters. Table 105 on page 539 lists the global parameters.

**18: Phase and State Transitions**
Manipulating MSCs During Solve

Table 105 Global, model-string, and state parameters of pmi_msc_abes

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| plot | — | 0 | — | {0,1} | Plot parameter to screen |
| use_mi_pars | — | 0 | — | {0,1} | Use model index for parameter set |
| lambda | $\Lambda$ | 0. | eV | real | Constant value |
| lambda_nb_Tpairs | — | 0 | — | >=0 | Number of interpolation points |
| lambda_Tp<int>_X | — | — | K | >0. | Temperature at <int>-th interpolation point |
| lambda_Tp<int>_Y | — | — | eV | real | Value at <int>-th interpolation point |

The names of model index parameters are prefixed with:

`mi<model_index>_`

The state parameters have one of the prefixes depending on the value of `use_mi_pars`:

`mi<model_index>_<state_name>_`
`<state_name>_`

The `lambda_` parameters enable either a constant or pwl apparent band-edge shift for each state, which is fully analogous to the specification described in The pmi_msc_heatcapacity Model on page 968.

# Thermal Conductivity, Heat Capacity, and Mobility

The following models allow the dependency on MSC occupation probabilities:

* The pmi_msc_mobility Model on page 348

* The pmi_msc_heatcapacity Model on page 968

* The pmi_msc_thermalconductivity Model on page 980

Descriptions of PMIs for MSC-dependent thermal conductivity, heat capacity, and mobility can be found in Multistate Configuration–Dependent Thermal Conductivity on page 1293, Multistate Configuration–Dependent Heat Capacity on page 1290, and Multistate Configuration–Dependent Bulk Mobility on page 1287, respectively.

# Manipulating MSCs During Solve

The MSC dynamic is, in general, solved implicitly. However, sometimes it might be useful to manipulate the computations. For example, you might want to initialize MSCs with nonsteady-

Manipulating MSCs During Solve

state solutions or to freeze the dynamic of MSCs because time constants are very large compared to electronic and thermal effects. Furthermore, it might be of interest to disable specific MSC transitions for certain applications (for example, in phase-change memory applications to freeze phases but to allow electronic transitions). The available mechanisms are described here.

## Explicit State Occupations

You can set explicitly the state occupations of MSCs to a spatial-independent and solution-independent value, and freeze and unfreeze the dynamic of the MSCs during Solve by using `MSConfigs` in a `Set` command (see Table 340 on page 1632 for a summary of options).

To set the state occupations of an MSC, you use the `MSConfig` command within `MSConfigs`, identify the MSC by using its name (and, for mixed-mode simulations, the device name using `Device`), and specify the occupancies for the involved states using `State`.

The state occupations are then set collectively and normalized implicitly, while unspecified states default to zero occupation. The `Frozen` option of `MSConfigs` applies to all existing MSCs and freezes the state occupations at the set or actual values. To unfreeze the dynamics of the MSCs again, the `-Frozen` option is used.

The following example illustrates the syntax for single-device simulations:

```
Physics {
  MSConfigs ( ...
    MSConfig ( Name="msc1" State ( Name="s0" ) State ( Name="s1" ) ... )
  )
}
Solve { ...
  Set (
    MSConfigs (
      MSConfig ( Name="msc1"
           State (Name="s0" Value=0.1) State (Name="s1" Value=0.4) )
      Frozen                          # freeze the MSC dynamic
    )
  )
  ...
  Set ( MSConfigs ( -Frozen ) )        # unfreeze the MSC dynamic
}
```

Here, the occupancies of states `s0` and `s1` of the MSC `msc1` are set to 0.2 and 0.8, respectively, due to the implicit normalization; all other states are unoccupied.

**18: Phase and State Transitions**
Example: Two-State Phase-Change Memory Model

**NOTE** Freezing and unfreezing MSCs implies freezing and unfreezing traps, respectively (see the Solve-Set-Traps command in Explicit Trap Occupation on page 496).

# Manipulating Transition Dynamics

You can manipulate the transition dynamic by accessing prefactors for individual transition forward (capture) and backward (emission) reaction rates. This means that the modified rate $\tilde{c} = \kappa c$ ($\kappa$ is the prefactor, and $c$ is the true reaction rate) is used in the dynamic equation. By setting selected transition prefactors to zero, you can decouple states into independent groups. Especially, if you decouple a certain state from all others, the state is frozen, that is, it retains its occupation in the subsequent analysis. With:

```
Set( (Device="d1" MSConfig="m7" Transition="t3" CPreFactor=0. EPreFactor=0.) )
```

both reaction rates of the specified transition are set to zero (`PreFactor` can be used for common settings of both reaction rates). Omitting one of the specifying string keywords `Device`, `MSConfig`, and `Transition` applies the setting to all corresponding objects in the Device-MSConfig-Transition hierarchy.

**NOTE** The prefactors affect only subsequent computations, but they do not change the physical parameters of the MSC.

# Example: Two-State Phase-Change Memory Model

Phase-change memory (PCM) devices store a bit as the phase (crystalline or amorphous) of a (chalcogenide) material. Reading information takes advantage of the different conductances of the phases. Storing information requires switching the phases. To switch to the amorphous phase, a high current is passed through the material, heating up the device above the melting point. When switching off the current, the molten material cools so rapidly that it cannot crystallize, but remains in a metastable amorphous phase. To switch to the crystalline phase, the material is reheated more gently. The material remains solid, but the temperature is sufficient that the phase can relax to the equilibrium crystalline phase.

The PCM device is modeled by a two-state model representing the crystalline and amorphous phase using an MSC with two uncharged states. The transition is modeled by the Arrhenius law formula (`Formula=0`) of the `pmi_ce_msc` transition model.

The model has four parameters:

*   The base energies and the degeneracy factors of the states determine the equilibrium.

*   The activation energy $E_{act}$ and $r_0$ of the transition determine the velocity of the transition.

**18: Phase and State Transitions**
References

A short interpretation is given:

Let $s = s_c$ denote the degree of crystallization of the material and $s_a = 1 - s$, the amorphization rate. Assuming an energy difference $\delta E > 0$ between the amorphous and crystalline phases, and that the amorphous phase has $g > 1$ times more microscopic realizations than the crystalline state, in equilibrium $s = 1 / [g \exp(-\delta E / kT) + 1]$, that is, the amorphous state is preferred at higher temperatures. The critical temperature where the equilibrium occupation rates $s_c$ and $s_a$ are equal is $T_{\text{crit}} = \delta E / k \ln(g)$.

The dynamic is given by crystallization and amorphization rates $r_c = r_0 \exp(-E_{\text{act}} / kT)$ and $r_a = r_0 g \exp(-(E_{\text{act}} + \delta E) / kT)$, respectively, assuming a simple Arrhenius law for the crystallization rate. Here, $r_0$ is the maximal crystallization rate, and $E_{\text{act}}$ is the activation energy.

# References

[1] C. Peng, L. Cheng, and M. Mansuripur, “Experimental and theoretical investigations of laser-induced crystallization and amorphization in phase-change optical recording media,” Journal of Applied Physics, vol. 82, no. 9, pp. 4183–4191, 1997.

[2] S. Senkader and C. D. Wright, “Models for phase-change of Ge<sub>2</sub>Sb<sub>2</sub>Te<sub>5</sub> in optical and electrical memory devices,” Journal of Applied Physics, vol. 95, no. 2, pp. 504–511, 2004.

[3] D.-H. Kim *et al.*, “Three-dimensional simulation model of switching dynamics in phase change random access memory cells,” Journal of Applied Physics, vol. 101, p. 064512, March 2007.

