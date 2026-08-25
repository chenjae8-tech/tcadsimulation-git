# CHAPTER 17 Traps and Fixed Charges

*This chapter describes how traps are handled by Sentaurus Device.*

## Introduction to Traps

Traps are important in device physics because they provide doping, enhance recombination, and increase leakage through insulators. Several models such as Shockley–Read–Hall recombination depend on traps implicitly, but do not actually model them. This chapter describes models that take the occupation and the space charge stored on traps explicitly into account. It also describes the specification of fixed charges.

Sentaurus Device handles several trap types and different types of energetic distribution, and provides various models for capture and emission rates. Traps are available for both bulk regions and interfaces. There is also a simple model restricted to insulator fixed charges (see Insulator Fixed Charges on page 524).

## Syntax for Traps

You specify trap distributions and trap models in the `Physics` section of the command file. In contrast to other models, most trap model parameters are also specified in this section. Parameter specifications in the parameter file serve as defaults for those in the command file.

Traps can be specified for interfaces or bulk regions. Specifications take the form:

```
Physics (Region="gobbledygook"){
  Traps(
    ( <trap_specification> )
    ( <trap_specification> )
    ...
  )
}
```

The same form applies to `Material`, `RegionInterface`, and `MaterialInterface`.

Each `<trap_specification>` describes one particular trap distribution and the models and parameters applied to it. Table 325 on page 1612 summarizes the options that can appear in trap specifications.

Introduction to Traps

When only one trap specification is present, you can omit the inner parentheses. For example:

```
Physics (Region="gobbledygook"){
  Traps(
    <trap_specification>
  )
}
```

> **NOTE** Wherever a contact exists at a specified region interface, Sentaurus Device does not recognize the interface traps within the bounds of the contact because the contact itself constitutes a region and effectively overwrites the interface between the two *material* regions. This is true even if the contact is not declared in the `Electrode` section.

## Trap Types

The following keywords select the trap type:

* `FixedCharge` traps are always completely occupied.

* `Acceptor` and `eNeutral` traps are uncharged when unoccupied, and they carry the charge of one electron when fully occupied.

* `Donor` and `hNeutral` traps are uncharged when unoccupied, and they carry the charge of one hole when fully occupied.

## Energetic and Spatial Distribution of Traps

The following keywords determine the energetic distribution of traps:

* `Level` selects a single-energy level.

* `Uniform` selects a uniform distribution.

* `Exponential` selects an exponential distribution.

* `Gaussian` selects a Gaussian distribution.

* `Table` selects a user-defined table distribution.

* `RandomizeEnergy` selects a random single energy level from the `Uniform`, `Gaussian`, or `Table` distributions.

**17: Traps and Fixed Charges**
Introduction to Traps

The relevant equations for the different trap distributions are:

$$
\begin{aligned}
& N_0 && \text{for } E = E_0 && \text{for Level} \\
& N_0 && \text{for } E_0 - 0.5 E_S < E < E_0 + 0.5 E_S && \text{for Uniform} \\
& N_0 \exp \left( -\left| \frac{E - E_0}{E_S} \right| \right) && && \text{for Exponential} \\
& N_0 \exp \left( -\frac{(E - E_0)^2}{2 E_S^2} \right) && && \text{for Gaussian} \quad (510) \\
& \begin{pmatrix} N_1 \\ \dots \\ N_m \end{pmatrix} && \begin{matrix} \text{for } E = E_1 \\ \dots \\ \text{for } E = E_m \end{matrix} && \text{for Table}
\end{aligned}
$$

$N_0$ is set with the `Conc` keyword as follows:

*   For a `Level` distribution, `Conc` is given in cm<sup>-3</sup> (for regionwise or materialwise specifications) or cm<sup>-2</sup> (for interface-wise specifications). For other distributions, `Conc` is given in eV<sup>-1</sup> cm<sup>-3</sup> or eV<sup>-1</sup> cm<sup>-2</sup>.

*   For `FixedCharge` traps, the sign of `Conc` denotes the sign of the fixed charges. For other trap types, `Conc` must not be negative.

*   For `DiscretetTrapT2T`, `Conc` has a different meaning and is used to scale the defined discrete traps (see Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506).

For a `Table` distribution, individual levels are given as a pair of energies (in eV) and the corresponding concentrations (in eV<sup>-1</sup> cm<sup>-3</sup> or eV<sup>-1</sup> cm<sup>-2</sup>). Depending on the presence of the `fromCondBand`, `fromMidBandGap`, or `fromValBand` keyword, energy levels in the table are relative to the conduction band, intrinsic energy, or valence band, respectively. To obtain the absolute concentration (in cm<sup>-3</sup> or cm<sup>-2</sup>) for each level, the energy range between the smallest and the largest energy in the table is split into intervals. The boundaries of the intervals are the energies that are in the middle between adjacent energies in the table. The absolute concentration of a level is the product of the size of the energy interval that contains it and the concentration specified in the table. If the table contains only one level, an interval size of 1 eV is assumed.

The following example creates a trap level at the midgap with a concentration of $0.1 \text{ eV} \times 10^{16} \text{ cm}^{-3} \text{ eV}^{-1} = 10^{15} \text{ cm}^{-3}$, and a level at both 0.1 eV above and below the midgap, with a concentration of $0.05 \text{ eV} \times 10^{15} \text{ cm}^{-3} \text{ eV}^{-1} = 5 \times 10^{13} \text{ cm}^{-3}$:

```
Traps ((Table=(-0.1 1e15 0 1e16 0.1 1e15) fromMidBandGap))
```

491

Introduction to Traps

In Eq. 510, $E_0$ and $E_S$ are given in eV by `EnergyMid` and `EnergySig`. The energy of the center of the trap distribution, $E_{\text{trap}}^0$, is obtained from $E_0$ depending on the presence of one of the following keywords:

$$
E_{\text{trap}}^0 = \begin{cases} E_C - E_0 - E_{\text{shift}} & \text{fromCondBand} \\ [E_C + E_V + kT \ln(N_V/N_C)]/2 + E_0 + E_{\text{shift}} & \text{fromMidBandGap} \\ E_V + E_0 + E_{\text{shift}} & \text{fromValBand} \end{cases} \quad (511)
$$

Internally, Sentaurus Device approximates trap energy distributions by discrete energy levels. The default number of levels is 13 and is set by `TrapDLN` in the `Math` section. A peak sampling method is available for the `Gaussian` and `Exponential` distributions, which can be activated with the syntax `TrapDLN(PeakSampling)=<int>` in the `Math` section.

> **NOTE** You are encouraged to use `TrapDLN(PeakSampling)=<int>` as this method provides a better discretization of the Gaussian and exponential trap energy distributions.

In Eq. 511, $E_{\text{shift}}$ is zero (default) or is computed by a physical model interface (PMI) specified in one of the following ways:

```
EnergyShift=<model_name>
EnergyShift=(<model_name>, <int>)
```

The PMI depends on the electric field and the lattice temperature. By default, these quantities are taken at the location of the trap. Alternatively, you can use `ReferencePoint=<vector>` to specify a coordinate in the device from where these quantities should be taken. See Trap Energy Shift on page 1360.

In a region for continuous traps with a defined trap energy distribution, every vertex of the trap region inherits that energy distribution. Alternatively, you can use a random trap energy distribution (`RandomizeEnergy`) whereby, at each vertex, there is only one trap energy level (chosen randomly from the energy distribution). The supported energy distributions are `Uniform`, `Gaussian`, and `Table`. The sampling is performed such that, when you collect the trap energy level defined in all vertices, there will be more samples located at the peak of the energy distribution. In the case of a `Table` definition for `RandomizeEnergy`, the first column of the table denotes the trap energy level and the second column is the associated probability of randomly choosing that energy level. Therefore, the sum of all the probability entries in the second column must add up to one. Note that this differs from the usual `Table` energy distribution, whereby the second column denotes the concentration.

For traps located at interfaces, `Region` or `Material` allows you to specify the region or material on one side of the interface; the energy specification then refers to the band structure on that side. For heterointerfaces, the charge and recombination rates due to traps are fully accounted

**17: Traps and Fixed Charges**
Introduction to Traps

for on that side. Without this side specification, the energy parameters refer to the bands that you see when you plot the band edges, which usually originate from the lower bandgap material. The charge and recombination rates due to traps are evenly distributed on both sides.

Note that if the trap energies are not specified relative to the band edges of the material with the lower bandgap, the correction of trap energies is performed at 300 K. This implies that if you perform a temperature-dependent simulation with traps at an interface between materials that have different temperature dependencies, you should use both heterointerfaces and `Region` or `Material` for the side specification, to make the correct specification of trap energies easier.

By default, trap energies refer to effective band edges, that is, band edges that include bandgap narrowing. By specifying `Reference=BandGap`, trap energies refer to band edges that exclude bandgap narrowing.

The `Cutoff` keyword controls truncation and applies only to traps with `Uniform`, `Gaussian`, and `Exponential` distributions:

*   `Cutoff=BandGap` truncates to the band gap at 300 K without bandgap narrowing.

*   `Cutoff=EffectiveBandGap` (default) truncates the trap energy distribution to the effective bandgap at 300 K.

*   `Cutoff=None` deactivates truncation.

*   `Cutoff=Simple` activates a truncation approach used by previous versions of Sentaurus Device, which ignores mole fraction dependency of the band gap.

> **NOTE** Truncation does not affect the band edges to which trap energies refer during simulation. These are always the solution-dependent band edges including temperature dependency. Traps with `Level` and `Table` distributions are never truncated to the band gap.

By default, trap concentrations are uniform over the domain for which they are specified. With `SFactor= "<dataset_name>"`, the given dataset determines the spatial distribution. If `Conc` is zero or is omitted, the dataset determines the density directly. For `Uniform`, `Gaussian`, and `Exponential` trap distributions, this is the total density (in cm<sup>-3</sup> or cm<sup>-2</sup>) of the integrated energy distribution. If `Conc` is nonzero, the `SFactor` is scaled by the maximum of its absolute value and multiplied by $N_0$. Datasets available for `SFactor` are:

*   `DeepLevels`, `xMoleFraction`, and `yMoleFraction` (read from the doping file)

*   `TotalTrapConcentration`, `eTrappedCharge`, and `hTrappedCharge` (read from the file specified by `DevFields` in the `File` section)

*   PMI user fields (read from the file specified by `PMIUserFields` in the `File` section)

Introduction to Traps

If a `Physics` section specifies a location on `MaterialInterface` or `RegionInterface`, and the dataset for `SFactor` is `DeepLevels`, `eTrappedCharge`, `hTrappedCharge`, or `TotalTrapConcentration`, the input TDR file must have the corresponding fields on the interfaces (see Interface Plots on page 131).

Alternatively, with `SFactor= "<pmi_model_name>"`, the spatial distribution is computed using the PMI (see Space Factor on page 1446). During a transient simulation, this PMI allows you to have a time-dependent trap concentration. In this case, the spatial distribution can be computed based on the solution from the previous time step available through the PMI.

The `SpatialShape` keyword selects a multiplicative modifier function for the trap concentration. If `SpatialShape=Uniform` (default), then the multiplier for point ($x, y, z$) is:

$$ \Theta(\sigma_x - |x - x_0|) \Theta(\sigma_y - |y - y_0|) \Theta(\sigma_z - |z - z_0|) \eqno(512) $$

If `SpatialShape=Gaussian`, then the multiplier is:

$$ \exp \left( -\frac{(x - x_0)^2}{2\sigma_x^2} -\frac{(y - y_0)^2}{2\sigma_y^2} -\frac{(z - z_0)^2}{2\sigma_z^2} \right) \eqno(513) $$

In Eq. 512 and Eq. 513, ($x_0, y_0, z_0$) and ($\sigma_x, \sigma_y, \sigma_z$) are given (in $\mu$m) by the `SpaceMid` and `SpaceSig` keywords, respectively. By default, the components of `SpaceSig` are huge, so that the multiplier becomes one.

# Specifying Single Traps

Including `SingleTrap` in a trap specification allows you to simplify the specification of parameters to mimic the behavior of a single trap:

*   `SingleTrap` is allowed only with `Level` distributions for traps.

*   The coordinates specified by `SpaceMid`=($x_0, y_0, z_0$) snap to the nearest vertex in the material, region, or interface that is specified as part of the `Physics` section. If a global `Physics` specification is used, the coordinates snap to the nearest vertex in the device.

*   `SpatialShape=Uniform` is used automatically for the trap. You do not need to specify it.

*   `SpaceSig=(1e-6, 1e-6, 1e-6)` is used automatically for the trap. This is intended to confine the trap to a single vertex. You do not need to specify it.

*   The trap concentration is computed automatically such that a filled trap corresponds to one electronic charge. If you specify `Conc`, it is ignored.

*   When `SingleTrap` is specified for a `FixedCharge` trap, the sign of `Conc` (if specified) is used for the sign of the fixed charge. If `Conc` is omitted or `Conc=0` is specified, the fixed charge is positive. To obtain a negative fixed charge with `SingleTrap`, specify any negative value for `Conc`.

**17: Traps and Fixed Charges**

Introduction to Traps

* For 2D simulations, `AreaFactor` specified in the `Physics` section is used for the z-direction width when calculating the concentration.

* If specified with the random telegraph noise (RTN) option `SingleTrap(RTN)`, then access and set functions are available for mesh-based PMIs (see Runtime Support for Mesh-Based PMI Models on page 1203).

**Example**

Place two single `eNeutral` traps at the silicon–oxide interface:

```
Physics (MaterialInterface="Silicon/Oxide") {
  Traps (
    (SingleTrap eNeutral Level EnergyMid=0 fromMidBandGap
    SpaceMid=(0.0,0.0,0.1))
    (SingleTrap eNeutral Level EnergyMid=0 fromMidBandGap
    SpaceMid=(0.2,0.0,0.3))
  )
}
```

# Trap Randomization

You can randomize the spatial distribution of traps by specifying `Randomize` in the trap specification, with or without an integer value:

* `Randomize` is allowed only with `Level` distributions for traps or `DiscreteTrapT2T`.

* If you specify `SingleTrap`, the location of the single trap is randomized in the material, region, or interface that is specified as part of the `Physics` section. If a global `Physics` specification is used, then the location of this trap is randomized in the entire device. If `SpaceMid` is specified, then it is ignored.

* If you do not specify `SingleTrap`, then the concentration of traps at each vertex is randomized. This is accomplished by first determining the average number of traps at a vertex based on the spatial distribution created from the trap specification. Then, this is used as the expectation value for a Poisson-distribution random number generator to obtain a new random number of traps at the vertex. Finally, this is converted back to a trap concentration.

* If you specify `DiscreteTrapT2T` for trap-to-trap tunneling, then you need an additional keyword `NumberOfRandomTraps=<int>` to indicate the number of traps to be randomly distributed in the region (see Trap-to-Trap Tunneling (DiscreteTrapT2T) on page 506).

* If you specify `Randomize`, then the randomization differs every time you execute the command file. You can change this behavior, however, by specifying `Randomize` with an integer value:

    - `Randomize < 0`: No randomization occurs.

Introduction to Traps

*   Randomize = 0: Same as Randomize without a value. The randomization differs for every execution of the command file.

*   Randomize > 0: The specified number is used as the seed for the random number generator. This allows a particular randomization to be repeated for repeated executions of the same command file on the same platform.

## Examples

Randomize the location of one electron trap at the silicon–oxide interface:

```
Physics (MaterialInterface="Silicon/Oxide") {
      Traps (
        SingleTrap Randomize eNeutral Level EnergyMid=0 fromMidBandGap
      )
}
```

Randomize a Gaussian spatial distribution of traps in silicon:

```
Physics (Material="Silicon") {
      Traps (
        eNeutral Conc=1e16 Level EnergyMid=0 fromMidBandGap Randomize
        SpatialShape=Gaussian SpaceMid=(0.0,0.0,0.05) SpaceSig=(0.05,0.05,0.05)
      )
}
```

# Explicit Trap Occupation

When investigating time-delay effects, for example, it might be advantageous to start a transient simulation from an initial state with either totally empty or totally filled trap states. Depending on the position of the equilibrium Fermi level, however, it might be impossible to reach such an initial state from steady-state or quasistationary simulations (for example, it might be a metastable state with a very long lifetime).

Different mechanisms are available to initialize trap occupancies in the `Solve` section.

> **NOTE** An earlier mechanism is invoked by `TrapFilling` in the `Set` and `Unset` statements of the `Solve` section. Table 348 on page 1637 summarizes the syntax of these statements. This mechanism is deprecated with the exception of the `-Degradation` option.

The mechanism invoked by `Traps` in the `Set` statement in a `Solve` section allows you to set trap occupancies for individually named traps to spatial- and solution-independent values, and to freeze and unfreeze the trap occupancies of all traps. For descriptions of the options of `Traps` in the `Set` statement, see Table 348 on page 1637.

**17: Traps and Fixed Charges**
Introduction to Traps

To set a trap, you must define an identifying `Name` in its definition in `Traps`, which enables you to reference this trap in the `Set` command. The `Frozen` option freezes the trap occupancies for subsequent `Solve` sections, and the `-Frozen` option unfreezes them. Freezing traps implies that the traps are decoupled from both the conduction band and valence band, that is, their recombination terms are set to zero. Note that `Frozen` applies to all defined traps. Traps not explicitly initialized in the `Set` command are frozen at their actual values. For example:

```
Device "MOS" {
  Physics { ...
    Traps ( ( Name="t1" eNeutral ... ) ( Name="t2" hNeutral ... ) ... )
  }
}

System { ...
  MOS "mos1" ( ... ) { ... }
}

Solve { ...
  Set ( Traps ( "mos1"."t1" = 1. Frozen ) )
  ...
  Set ( Traps ( -Frozen ) )
  ...
}
```

In this example, some traps are named. In the first `Set` statement, trap "t1" of device "mos1" is explicitly set to one. Due to the `Frozen` option, trap "t1" is frozen at the specified value and trap "t2" is frozen at its actual value. The second `Set` statement releases all traps.

To set all the trap occupancies to a certain value between 0 and 1, you must specify the `Value` keyword as an option for `Traps`. In this case, the occupancy of all the traps (with or without names) is set to the value specified by the `Value` keyword.

In the following examples, trap occupancies are set to 1 and they are released later in the simulation using the `-Frozen` option:

```
Solve { ...
  Set ( Traps ( "mos1".value = 1. Frozen ) )
  ...
  Set ( Traps ( -Frozen ) )
  ...
}
```

or:

```
Solve { ...
  Set ( Traps ( value = 1. Frozen ) )
  ...
  Set ( Traps ( -Frozen ) )
}
```

Introduction to Traps

```
...
}
```

**NOTE** Freezing and unfreezing of traps using the `Solve-Set-Traps` command implies freezing and unfreezing of multistate configurations, respectively (see Manipulating MSCs During Solve on page 539). If the incomplete ionization model is used, dopant ionization is affected as well (see Chapter 13 on page 293).

---

# Options to Include Traps in Doping

The effect of traps on some physical models can be treated in an approximate manner by treating trap concentration as additional doping. The following options are available for this purpose:

```
Traps (
  <trap_specification>
  [Add2TotalDoping | Add2TotalDoping(ChargeTraps)]
)
```

If you specify `Add2TotalDoping`, then the trap concentration is added to both the acceptor (or donor) doping concentration (depending on the sign of the trap) and the total doping concentration. This affects models that depend on acceptor, donor, and total doping concentrations such as mobility and lifetime. However, this option has no effect on *mobility calculations* if a `MobilityDoping` file is used (see Mobility Doping File on page 411) or if incomplete ionization–dependent mobility is used (see Incomplete Ionization–Dependent Mobility Models on page 408).

If you specify `Add2TotalDoping(ChargedTraps)`, then the *charged* trap concentration is added to the acceptor or donor doping concentration *for mobility calculations only*. However, this option has no effect if a `MobilityDoping` file is used (see Mobility Doping File on page 411) or if incomplete ionization–dependent mobility is used (see Incomplete Ionization–Dependent Mobility Models on page 408).

---

# Trap Examples

The following example of a trap specification illustrates one donor trap level at the intrinsic energy with a concentration of 1×10<sup>15</sup> cm<sup>-3</sup> and capture cross-sections of 1×10<sup>-14</sup> cm<sup>2</sup>:

```
Traps(
  Donor Level EnergyMid=0 fromMidBandGap Conc=1e15 eXsection=1e-14
  hXsection=1e-14
)
```

17: Traps and Fixed Charges

Trap Models

This example shows trap specifications with exponential distributions, appropriate for a polysilicon thin-film transistor:

```
Traps(
  (eNeutral Exponential fromCondBand Conc=1e21 EnergyMid=0
    EnergySig=0.035 eXsection=1e-10 hXsection=1e-12)
  (eNeutral Exponential fromCondBand Conc=5e18 EnergyMid=0
    EnergySig=0.1 eXsection=1e-10 hXsection=1e-12)
  (hNeutral Exponential fromValBand Conc=1e21 EnergyMid=0
    EnergySig=0.035 eXsection=1e-12 hXsection=1e-10)
  (hNeutral Exponential fromValBand Conc=5e18 EnergyMid=0
    EnergySig=0.2 eXsection=1e-12 hXsection=1e-10)
)
```

# Trap Models

This section describes models for capture and emission rates.

## Trap Occupation Dynamics

The electron occupation $f^n$ of a trap is a number between 0 and 1, and changes due to the capture and emission of electrons:

$$ \frac{\partial f^n}{\partial t} = \sum_i r_i^n $$ (514)

$$ r_i^n = (1 - f^n)c_i^n - f^n e_i^n $$ (515)

Here, $c_i^n$ denotes an electron capture rate for an empty trap and $e_i^n$ denotes an electron emission rate for a full trap. The sum in Eq. 514 is over all capture and emission processes. For example, the capture of an electron from the conduction band is a process distinct from the capture of an electron from the valence band.

For the stationary state, the time derivative in Eq. 514 vanishes. The occupation becomes:

$$ f^n = \frac{\sum_i c_i^n}{\sum_i (c_i^n + e_i^n)} $$ (516)

Trap Models

and the net electron capture rate due to process $k$ becomes:

$$ r_k^n = \frac{c_k^n \sum e_i^n - e_k^n \sum c_i^n}{\sum (c_i^n + e_i^n)} $$ (517)

The previous equations are given in the electron picture, which is the most natural one for `eNeutral` and `Acceptor` traps (see Figure 21). For `hNeutral` and `Donor` traps, you might prefer to use the equivalent hole picture. Use the following relations to translate the electron picture into the hole picture:

* $c_i^p = e_i^n$

* $e_i^p = c_i^n$

* $f^p = 1 - f^n$

* $r_i^p = -r_i^n$

Trap occupation dynamics diagram showing electron emission/capture and hole capture/emission between Conduction and Valence bands.

Figure 21 Trap occupation dynamics: (left) electron picture and (right) hole picture

In particular, in the stationary state, for traps with concentration $N_0$ using the V-model (see Local Capture and Emission Rates on page 501), Eq. 517 leads to the Shockley–Read–Hall recombination rate:

$$ R_{\text{net}} = \frac{N_0 v_{\text{th}}^n v_{\text{th}}^p \sigma_n \sigma_p (np - n_{i,\text{eff}}^2)}{v_{\text{th}}^n \sigma_n (n + n_1 / g_n) + v_{\text{th}}^p \sigma_p (p + p_1 / g_p)} $$ (518)

Each capture and emission process couples the trap to a reservoir of carriers. If only a single process would be effective, in the stationary state, the trap would be in equilibrium with the reservoir for this process. This consideration (the principle of detailed balance) relates capture and emission rates:

$$ e_i = \frac{c_i}{g} \exp \left( \frac{E_{\text{trap}} - E_F^i}{k T_i} \right) $$ (519)

17: Traps and Fixed Charges

Trap Models

where:

*   $E_{\text{trap}}$ is the energy of the trap.

*   $E_F^i$ is the Fermi energy of the reservoir.

*   $T_i$ is the temperature of the reservoir.

*   $g$ is the degeneracy factor.

Sentaurus Device supports distinct degeneracy factors $g_n$ and $g_p$ for coupling to the conduction and valence bands. They default to 1 and are set with `eGfactor` and `hGfactor` in the command file, and with the `G` parameter pair in the `Traps` parameter set.

Capture and emission rates are either local (see Local Capture and Emission Rates on page 501) or nonlocal (see Nonlocal Tunneling for Traps on page 517). Sentaurus Device does not solve the current continuity equations in insulators and, therefore, supports local rates only for traps in semiconductors or at semiconductor interfaces.

Therefore, traps in insulators that are not connected to a semiconductor region by a nonlocal model do not have any capture and emission processes, and their occupation is undefined (except for `FixedCharge` traps). Sentaurus Device ignores them.

# Local Capture and Emission Rates

The electron capture rate from the conduction band at the same location as the trap is:

$$ c_C^n = \sigma_n \left[ (1 - g_n^J) v_{th}^n n + g_n^J \frac{J_n}{q} \right] $$ (520)

Similarly, the hole capture rate from the valence band is:

$$ c_V^p = \sigma_p [ (1 - g_p^J) v_{th}^p p + g_p^J J_p / q ] $$ (521)

Here, $g_n^J$ and $g_p^J$ are set with `eJfactor` and `hJfactor` in the command file, and with the `Jcoef` parameter pair in the `Traps` parameter set. $g_n^J$ and $g_p^J$ can take any value between 0 and 1. When they are zero (default), the V-model is used. When they are 1, the J-model (popular for modeling radiation problems) is used.

The electron emission rate to the conduction band is $e_C^n = v_{th}^n \sigma_n \gamma_n n_1 / g_n + e_{\text{const}}^n$ and the hole emission to the valence band is $e_V^p = v_{th}^p \sigma_p \gamma_p p_1 / g_p + e_{\text{const}}^p$. For $g_n^J = e_{\text{const}}^n = 0$ and $g_p^J = e_{\text{const}}^p = 0$, these rates obey the principle of detailed balance.

Above, $n_1 = N_C \exp[(E_{\text{trap}} - E_C) / kT]$ and $p_1 = N_V \exp[(E_V - E_{\text{trap}}) / kT]$. For Fermi statistics or with quantization (see Chapter 14 on page 303), $\gamma_n$ and $\gamma_p$ are given by Eq. 47 and Eq. 48, p. 183 (see Fermi Statistics on page 182); otherwise, $\gamma_n = \gamma_p = 1$.

Trap Models

$v_{th}^n$ and $v_{th}^p$ are the thermal velocities. Sentaurus Device offers two options, selected by the `VthFormula` parameter pair in the `Traps` parameter set (default is 1):

$$
v_{th}^{n, p} = \begin{cases} v_0^{n, p} \sqrt{\frac{T}{300 \text{K}}} & \text{VthFormula=1} \\ \sqrt{\frac{3kT}{m_{n, p}(300 \text{K})}} & \text{VthFormula=2} \end{cases} \tag{522)
$$

$v_0^{n, p}$ are given by the `Vth` parameter pair in the `Traps` section of the parameter file.

Sentaurus Device offers several options for the cross sections $\sigma_n$ and $\sigma_p$. In any case, trap cross sections are derived from the constant cross sections $\sigma_n^0$ and $\sigma_p^0$, which are set by the `eXsection` and `hXsection` keywords in the command file, and by the `Xsec` parameter pair in the `Traps` parameter set.

By default, the cross sections are constant: $\sigma_n = \sigma_n^0$ and $\sigma_p = \sigma_p^0$.

$e_{const}^n$ and $e_{const}^p$ represent the constant emission rate terms for carrier emission from the trap level to the conduction and valence bands. They can be set by `eConstEmissionRate` and `hConstEmissionRate` in the command file, and by the `ConstEmissionRate` parameter pair in the `Traps` parameter set (default $e_{const}^n = 0 \text{ s}^{-1}$, $e_{const}^p = 0 \text{ s}^{-1}$).

The `SimpleCapt` option restricts the field enhancement of cross sections to the emission rates only:

*   For the computation of $e_C^n$ and $e_V^n$, $\sigma_n$ and $\sigma_p$ are used.

*   For the computation of $c_C^n$ and $c_V^n$, $\sigma_n^0$ and $\sigma_n^0$ are used.

> **NOTE** Using different cross sections for capture and emission rates violates the principle of detailed balance. By default, the same cross sections are used for capture and emission rates.

## J-Model for Cross Sections

This model is selected by specifying `ElectricField` in the command file. It is intended for use with the J-model and reads:

$$
\sigma_{n, p} = \sigma_{n, p}^0 \left( 1 + a_1 \left| \frac{F}{1 \text{ Vm}^{-1}} \right|^{p_1} + a_2 \left| \frac{F}{1 \text{ Vm}^{-1}} \right|^{p_2} \right)^{p_0} \tag{523}
$$

where $a_1$, $a_2$, $p_0$, $p_1$, and $p_2$ are adjustable parameters available as parameter pairs `a1`, `a2`, `p0`, `p1`, and `p2` in the `Traps` parameter set.

17: Traps and Fixed Charges

Trap Models

Using the `SimpleCapt` option restricts the field enhancement of cross sections to the emission rates only.

## Hurkx Model for Cross Sections

This model is selected by specifying `Tunneling(Hurkx)` in the command file. The cross sections are obtained from $\sigma_n^0$ and $\sigma_p^0$ using Eq. 404, p. 426.

Using the `SimpleCapt` option restricts the field enhancement of cross sections to the emission rates only.

## Poole–Frenkel Model for Cross Sections

The Poole–Frenkel model [1] is frequently used to interpret transport effects in dielectrics and amorphous films. The model predicts an enhanced emission probability $\Gamma_{\text{pf}}$ for charged trap centers where the potential barrier is reduced because of the high external electric field.

To select the model, specify `PooleFrenkel` in the `Traps` specification (in the `Physics` section) of the command file.

Using the `SimpleCapt` option restricts the field enhancement of cross sections to the emission rates only.

In the Poole–Frenkel model:

$$ \sigma_{n, p}^{\text{enh}} = \sigma_{n, p}^0 (1 + ActivatePF \times \Gamma_{\text{pf}} + ActivatePhonon \times \Gamma_{\text{ph}}) $$
$$ \Gamma_{\text{pf}} = \frac{1}{\alpha^2} [1 + (\alpha - 1) \exp(\alpha)] - \frac{1}{2} $$ (524)
$$ \alpha = \left( \frac{1}{kT} \sqrt{\frac{q^3 F}{\pi \varepsilon_{\text{pf}}}} \right)^{\text{a\_power}} $$

and $\Gamma_{\text{ph}}$ is an enhancement factor derived from a semiclassical theory of phonon-assisted tunneling [2]:

$$ \Gamma_{\text{ph}} = \exp \left( \frac{F^2}{E_c^2} \right)^{\text{b\_power}} $$ (525)

where $E_c^2 = \frac{3 m^* \hbar}{e^2 \tau_2^3}$ and $\tau_2 = \frac{\hbar}{2 k_B T} + \tau_1$. $\tau_1$ can take negative values up to the limit of $\tau_2 > 0$.

Trap Models

For this model:

*   If you specify `PooleFrenkel` without options, then:

    *   For Donor and hNeutral traps, $\sigma_n = \sigma_n^{\text{enh}}$ and $\sigma_p = \sigma_p^0$.

    *   For Acceptor and eNeutral traps, $\sigma_p = \sigma_p^{\text{enh}}$ and $\sigma_n = \sigma_n^0$.

*   If you specify `PooleFrenkel(Electron)`, then $\sigma_n = \sigma_n^{\text{enh}}$ irrespective of trap type.

*   If you specify `PooleFrenkel(Hole)`, then $\sigma_p = \sigma_p^{\text{enh}}$ irrespective of trap type.

    You can use `PooleFrenkel(Electron)` and `PooleFrenkel(Hole)` together to activate the model for exchange with conduction and valence bands simultaneously.

*   $\varepsilon_{\text{pf}}$ is an adjustable parameter. It is set by the `epsPF` parameter pair in the `PooleFrenkel` parameter set.

*   A general power law (`a_power`) is applied to $\alpha$ and can be set in the `PooleFrenkel` parameter set.

*   The `b_power`, $\tau_1$ (`ph_tau1`), and $m^*$ (`ph_mass`) of the phonon-enhanced factor can be set in the `PooleFrenkel` parameter set.

*   `ActivatePF` and `ActivePhonon` are scaling and activating factors for the various components of the Poole–Frenkel enhancement, and these can be set in the `PooleFrenkel` parameter set.

# Makram-Ebeid–Lannoo Model

The Makram-Ebeid–Lannoo model [[3]]([3]) is a phonon-assisted tunnel emission model for carriers trapped on deep semiconductor levels, with its main application in two-band charge transport in silicon nitride [[4]]([4]). In this model, the deep trap acts as an oscillator or a core embedded in the nitride lattice, attracting electrons (electron trap) or holes (hole trap). The deep trap is defined by the phonon energy $W_{\text{ph}}$, the thermal energy $W_{\text{T}}$, and the optical energy $W_{\text{opt}}$.

The trap ionization rate is given by:

$$ P = \sum_{n = -\infty}^{\infty} \exp \left[ \frac{nW_{\text{ph}}}{2kT} - S \coth \frac{W_{\text{ph}}}{2kT} \right] I_n \left( \frac{S}{\sinh(W_{\text{ph}}/(2kT))} \right) P_i(W_{\text{T}} + nW_{\text{ph}}) $$ (526)

$$ P_i(W) = \frac{eF}{2\sqrt{2mW}} \exp \left( -\frac{4\sqrt{2m}}{3\hbar eF} W^{3/2} \right) $$ (527)

where:

*   $I_n$ is the modified Bessel function of the order $n$.

*   $S = (W_{\text{opt}} - W_{\text{T}}) / W_{\text{ph}}$.

*   $P_i(W)$ is the tunnel escape rate through the triangle barrier of height $W$.

17: Traps and Fixed Charges

Trap Models

Sentaurus Device implements the Makram-Ebeid–Lannoo model for `eNeutral` and `hNeutral` traps with `Level` distributions. The electron emission rate to the conduction band $e_C^n$ and the hole emission to the valence band $e_V^p$ are the trap ionization rates described by Eq. 526 with the corresponding $W_{ph}$, $W_T$, and $W_{opt}$ defining the associated deep trap.

The electron capture rate from the conduction band $c_C^n$ and the hole capture rate from the valence band $c_V^p$ are computed based on user selection. They can be obtained from the emission rates by the principle of detailed balance or using the constant capture cross-sections: $c_C^n = \sigma_n^0 [(1 - g_n^J) v_{th}^n n + g_n^J \frac{J_n}{q}]$, $c_V^p = \sigma_p^0 [(1 - g_p^J) v_{th}^p p + g_p^J J_p / q]$.

To select the model, specify `Makram-Ebeid` in the command file or the `Traps` parameter set:

*   If you specify `Makram-Ebeid` without options, the trap couples to both the conduction and valence bands through Makram-Ebeid–Lannoo trap emission rates.

*   If you specify `Makram-Ebeid(electron)`, an `eNeutral` trap couples to the conduction band through the Makram-Ebeid–Lannoo emission rate and to the valence band using the default emission rate.

*   If you specify `Makram-Ebeid(hole)`, an `hNeutral` trap couples to the valence band through the Makram-Ebeid–Lannoo emission rate and to the conduction band using the default emission rate.

The following example couples `eNeutral` traps with `Level` distributions described by the Makram–Ebeid–Lannoo model to both the conduction and valence bands:

```
Traps(
   ...
   (eNeutral Level ... Makram-Ebeid)
)
```

To couple an `eNeutral` trap with a `Level` distribution through the Makram–Ebeid–Lannoo emission rate only to the conduction band, while keeping the default emission rate to the valence band, specify the following in the command file:

```
Traps(
   ...
   (eNeutral Level ... Makram-Ebeid(electron))
)
```

By default, the electron capture rate from the conduction band to an `eNeutral` trap ($e_C^n$) and the hole capture rate from the valence band to an `hNeutral` trap ($e_V^p$) are computed from the corresponding emission rates using the principle of detailed balance.

By specifying `Makram-Ebeid(simpleCapt)`, capture rates are computed as:

*   $c_C^n = \sigma_n [(1 - g_n^J) v_{th}^n n + g_n^J \frac{J_n}{q}]$ for exchange with the conduction band.

*   $c_V^p = \sigma_p [(1 - g_p^J) v_{th}^p p + g_p^J J_p / q]$ for exchange with the valence band.

17: Traps and Fixed Charges

Trap Models

Here, $g_n^J$ and $g_p^J$ are set with `eJfactor` and `hJfactor` in the command file and with the `Jcoef` parameter pair in the `Traps` parameter set. $g_n^J$ and $g_p^J$ can take any value between 0 and 1. When they are zero or not specified (the default), the V-model is used with the simplified rates $c_C^n = \sigma^0 v_{th}^n n$ and $c_V^p = \sigma^0 v_{th}^p p$, respectively. When they are 1, the J-model is used.

You can adjust the deep trap parameters $W_{ph}$, $W_T$, and $W_{opt}$ in the `Makram-Ebeid` section of the parameter file. The default values are $W_{ph} = 0.06 \text{ eV}$, $W_T = 1.4 \text{ eV}$, and $W_{opt} = 2.8 \text{ eV}$. In addition, you can adjust the Makram-Ebeid–Lannoo tunneling masses $m$ in the parameter file. The default value is 0.5 for both electrons and holes.

The following example changes the $W_{ph}$, $W_T$, and $W_{opt}$ parameters in AlN:

```
Material = "AlN") {
  Makram-Ebeid(
    mt   = 0.3 ,0.5   #[1]
    Wph  = 0.065       #[eV]
    Wt   = 1.43        #[eV]
    Wopt = 2.7         #[eV]
  )
}
```

# Local Capture and Emission Rates From PMI

As an alternative to the previously described models, you can compute the local capture and emission rates $c_C^n$, $c_V^p$, $e_C^n$, and $e_V^p$ directly using a PMI (see Trap Capture and Emission Rates on page 1356). Using this PMI only makes sense for traps with `Level` distributions.

# Trap-to-Trap Tunneling (DiscreteTrapT2T)

Sentaurus Device supports trap-to-trap tunneling between single discrete traps with all types of energetic distributions. Discrete traps of the same type can be coupled through tunneling. You can implement trap-to-trap tunneling across interfaces of regions with different materials.

Trap-to-trap tunneling is activated by specifying combinations of the following keywords in the `Physics(Region="regname"){Traps(...)}` section:

*   Specify `DiscreteTrapT2T` for a trap with a discrete `Level` energy. The `Traps` statement for trap-to-trap tunneling can be defined only in a region `Physics` section, not in a `RegionInterface` or `MaterialInterface Physics` section.

*   The trap energy level can be specified from `FromMidBandGap`, `FromCondBand`, or `FromValBand` with the parameter `EnergyMid` (see $E_0$ in Eq. 511, p. 492). The `Eshift` PMI is not supported for the trap-to-trap tunneling model.

*   `Location` specifies the coordinates of traps involved in the trap-to-trap tunneling process. These coordinates are replaced by the coordinates of the nearest vertex, so the traps snap

**17: Traps and Fixed Charges**

Trap Models

to this vertex. Alternatively, use `Location=(mesh)` to select all vertices in that region. However, `Location` is optional if `Randomize` is used, or if the points for this region have been defined in the `Location` of another `DiscreteTrapT2T` specification (of another region).

*   `Coupled=Tunneling` means that traps are coupled through tunneling. The coupling can exist between vertices of two different regions if the distance between traps does not exceed the value of $R_{\text{cutoff}}$. In `DiscreteTrapT2T`, the coupling refers to two primary processes: (i) trap-to-trap tunneling between both `eNeutral` or both `hNeutral` traps, and (ii) a trap-to-trap recombination between an `eNeutral` trap and an `hNeutral` trap.

In addition, the explicit trap equation must be activated in the `Solve` section to solve for the coupled trap occupation probability. The trap-to-trap tunneling framework can also be linked to other trap emission or capture processes. For example, in the `Physics-Traps` section, you can specify `PooleFrenkel` and `eBarrierTunneling` (or `hBarrierTunneling`) together. These other capture or emission processes are additive in nature and affect the overall occupancy of the trap.

Multiple trap entries can be defined in the same region and at the same vertex. There is no restriction to mixing a `DiscreteTrapT2T` trap entry and an implicit trap entry. You can also have multiple `DiscreteTrapT2T` entries in the same region with different trap types. For example:

```
Physics(Region="region_name") {
  Traps(
    ( eNeutral DiscreteTrapT2T Gaussian ... )
    ( hNeutral DiscreteTrapT2T Uniform ... )
    ( eNeutral DiscreteTrapT2T Table(...) ... )
    ( hNeutral DiscreteTrapT2T #level traps ... )
    ( # implicit continuous traps definition 1 )
    ( # implicit continuous traps definition 2 )
    ...
  )
}

Math {...
  Traps(Damping=0)     # Set Damping=0 for DiscreteTrapT2T
}
Plot {
  T2Tflux              # add T2Tflux to be output in TDR file
}

Solve { ...
  Transient(
    InitialTime=0 FinalTime=1.0
    InitialStep=1e-7 MaxStep=1e-1 MinStep=1e-20
  ){ Coupled{ Poisson Electron Hole Traps } }
}
```

Trap Models

> **NOTE** The eNeutral or Acceptor trap type caters to electrons, and the hNeutral or Donor trap type caters to holes. Interface traps are not supported for `DiscreteTrapT2T`; only region traps are supported.

Only `DiscreteTrapT2T` trap entries will couple with one another, and these are solved as a separate explicit trap equation coupled with the Poisson and continuity equations in the Newton scheme. Those implicit continuous trap entries are solved independently since they do not couple to each other. The indirect link between all trap entries is through the total space charge that goes into the Poisson and continuity equations. The fluxes between trap vertices can be plotted with the keyword `T2Tflux` in the `Plot` section, but this only applies to the case of `InelasticPhonon` trap-to-trap transition. The output contains `eT2Tflux` and `hT2Tflux`, which denote the electron and hole charge transport between trap vertices, respectively.

A typical `DiscreteTrapT2T` trap entry contains the following statements:

```
(
  # Define trap type and trap energy levels
  eNeutral
  FromCondBand EnergyMid=<float>
  Level
# Gaussian EnergySig=<float>          # or Exponential, Uniform, Table
# RandomizeEnergy=<int>               # set seed for randomized energy

  # Define DiscreteTrapT2T essential keywords
  DiscreteTrapT2T Coupled=Tunneling
  Transition=InelasticPhonon
  OutputT2TPaths("t2t_debug_file.txt") # define only once
  T2TPDEerrorScale = 1e-15             # define only once in all trap entries

  # Define DiscreteTrapT2T concentration
  T2TconcScale=<float>
  T2TfixedConc=<float>
# Conc=<float>                         # cannot use together with T2TfixedConc

  # Define DiscreteTrapT2T locations
  Location=(smesh)                     # choose every vertex in region
# Location=((x0 y0 z0) (x1 y1 z1) ... ) # cannot use with Sentaurus Mesh
# Randomize=<int>
# NumberOfRandomTraps=<int>

  # Local capture/emissions to Ec/Ev
  eXSection= 1.5e-14 hXSection= 1.5e-14
  PooleFrenkel(Electron)

  # Nonlocal tunneling from trap to Ec/Ev at interfaces/contacts
  eBarrierTunneling(NonLocal="NLM1" NonLocal="NLM2")
  HuangRhys=70 PhononEnergy=0.05 TrapVolume=1e-1
)
```

17: Traps and Fixed Charges

Trap Models

The following are switched on automatically when any `DiscreteTrapT2T` trap entries are detected:

```
Physics { Discontinuity }
Math { Traps(RegionWiseAssembly) }
```

This means hetero-double vertices are defined automatically at region interfaces. To reconcile implicit continuous trap results with the multilevel `DiscreteTrapT2T` results, you must switch on `Discontinuity` and `RegionWiseAssembly` in your implicit trap setup.

The traps involved in the tunneling process snap to the closest vertex. Because the traps are discrete, having a good mesh in the regions where trap-to-trap tunneling occurs is important to obtain meaningful results.

All the snapped vertices of the `DiscreteTrapT2T` entries in different regions are grouped together. Then, Sentaurus Device finds all the possible tunneling paths that could form pairs of traps, between which trap-to-trap tunneling will occur. As such, trap-to-trap tunneling across interfaces of different regions (with different materials) is possible.

There are different ways to set the trap concentration in `DiscreteTrapT2T`:

*   By default, the local trapped carrier density is such that, in the control volume for the trap where the vertex is located, there is one trapped charge if the trap is occupied, or zero charge otherwise. To map the number of discrete traps to a concentration, the parameter `T2TconcScale` is introduced:

$$ \text{T2TconcScale} = \frac{(\text{Concentration}) \times (\text{Volume of region})}{\text{Total number of region T2T traps}} \text{ (528)} $$

*   In cases where not all the vertices of a region are chosen, it is not trivial to calculate the sum of the Voronoï volumes of all the trap-to-trap vertices. By defining `Conc=<float>` in the trap-to-trap entry, an internal trap-to-trap scaling is calculated as:

$$ \text{internalT2TconcScale} = \frac{\text{Conc} \times (\text{Sum volume of T2T traps})}{\text{Total number of T2T traps}} \text{ (529)} $$

If you have also defined `T2TconcScale=<float>`, then the final multiplier to the trap at each vertex becomes:

$$ \text{finalT2TconcScale} = \text{internalT2TconcScale} \times \text{T2TconcScale} \text{ (530)} $$

*   Alternatively, you can fix the concentration at each trap-to-trap vertex by the keyword `T2TfixedConc=<float>`. In such a case, the number of traps at each trap-to-trap vertex is `T2TfixedConc` $\times$ `vertex_volume`. This definition is similar to how `Conc=<float>` is used in the implicit continuous traps.

17: Traps and Fixed Charges

Trap Models

If you have also specified `T2TconcScale=<float>`, then the final number of traps at each trap-to-trap vertex is:

$$ \text{Number of traps at each vertex} = \text{T2TfixedConc} \times \text{vertex\_volume} \times \text{T2TconcScale} \quad (531) $$

A number of randomly placed traps in the region can be generated using the keywords `Randomize` and `NumberOfRandomTraps`. `Randomize` can be specified with `Location` as long as the total number of traps is not greater than the number of vertices in the region.

With trap energy distribution and trap-to-trap tunneling, this means that every trap level of the distribution can be coupled to every other level at the same vertex as well as every other trap energy level of connected neighboring vertices.

To reduce the total number of trap-to-trap paths for faster computation, you can do one of the following:

*   Control the number of connections at a vertex, by using the following parameters in the `.par` file:

```
T2T_Rcutoff = <float>           # [um]
T2T_Rcutoff_inner = <float>     # [um], default of 0
```

In this case, only vertices within the distances of [`T2T_Rcutoff_inner`, `T2T_Rcutoff`] are valid for connection. Setting `T2T_Rcutoff_inner > 0` also means not coupling the different trap energy levels of a distribution at the same vertex.

*   Control the number of discrete trap levels of the distribution in the `Math` section:

```
TrapDLN(PeakSampling) = <int> # default is 13
```

`SFactor` (using the PMI or dataset name only) is supported for `DiscreteTrapT2T` and the following example lists the allowed combinations of `SFactor` and other `DiscreteTrapT2T` keywords:

```
Physics(Region="reg_name") {
  Traps(
    # Level traps of T2T with defined T2TfixedConc
    # SFactor normalized by its region peak value
    (eNeutral DiscreteTrapT2T ...
      Level FromCondBand EnergyMid=<float>
      T2TfixedConc = <float>                               # units of 1/cm^3
      T2TconcScale = <float>
      SFactor = "pmi_name"                                 # or "Dataset_name"
    )

    # Level traps of T2T with no T2TfixedConc
    # SFactor not normalized by its region peak value
    (eNeutral DiscreteTrapT2T ...
      Level FromCondBand EnergyMid=<float>
      T2TconcScale = <float>
```

**17: Traps and Fixed Charges**

Trap Models

```
        SFactor = "pmi_name"                # or "Dataset_name"
        -NormalizeSFactor                   # do not normalize SFactor
    )

    # COMBINATION NOT ALLOWED: Level traps of T2T with defined Conc
    # An error will terminate the simulation if such a combination is
    # detected during syntax parsing
    (eNeutral DiscreteTrapT2T ...
        Level FromCondBand EnergyMid=<float>
        Conc = <float>
        T2TConcScale = <float>
        SFactor = "pmi_name"                # or "Dataset_name"
    )

    # Trap energy distribution of T2T with defined Conc
    # SFactor not normalized by its region peak value
    (eNeutral DiscreteTrapT2T ...
        FromCondBand EnergyMid=<float> EnergySig=<float>
        Gaussian                            # or Exponential or Uniform or Table
        Conc = <float>                      # units of 1/cm^3/eV
        T2TConcScale = <float>
        SFactor = "pmi_name"                # or "Dataset_name"
        -NormalizeSFactor                   # do not normalize SFactor
    )

    # Random trap energy distribution of T2T with defined Conc
    (eNeutral DiscreteTrapT2T ...
        FromCondBand EnergyMid=<float> EnergySig=<float>
        Gaussian                            # or Exponential or Uniform or Table
        Conc = <float>                      # units of 1/cm^3
        RandomizeEnergy = <int>             # set random seed
        T2TConcScale = <float>
        SFactor = "pmi_name"                # or "Dataset_name"
    )
  )
}
```

Essentially, the normalized `SFactor` (normalized by the peak value of `SFactor` in the region) is multiplied by the local concentration of each vertex. To switch off the normalization of `SFactor`, use the `-NormalizeSFactor` option.

When are the `DiscreteTrapT2T` and implicit traps solved? Consider the following `Solve` section:

```
Solve {
  Poisson                                   <--- implicit solved
  Coupled {Poisson Traps}                   <--- implicit and T2T solved
  Coupled {Electron Hole}                   <--- implicit solved
}
```

Trap Models

```
      Coupled {Poisson Electron Hole Traps}   <--- implicit and T2T solved
      ...
}
```

To stop the implicit traps from being solved, freeze the traps. To not solve `DiscreteTrapT2T`, do not include `Traps` in the `Coupled` statement.

**NOTE** Even if the traps are frozen, the space charge will still contain the values of the trapped charges (`frozen_TrapOccupation` $\times$ `Concentration`) of the various trap entries.

When you freeze the traps, you cannot solve `Traps` in any `Coupled` statement. Otherwise, Sentaurus Device will terminate with an error message.

You can also output all the trap-to-trap tunneling paths by specifying the keyword `OuputT2TPaths("filename.txt")` in the `Traps` section where trap-to-trap tunneling is activated. At the end of this file, a summary of the concentration for each `DiscreteTrapT2T` trap entry is printed so that you can verify the actual concentration being used.

**NOTE** When you use the explicit trap equation for `DiscreteTrapT2T`, you must set `Traps(Damping=0)` in the `Math` section.

There are different types of trap-to-trap tunneling model in Sentaurus Device:

* Mode Oscillator Model

* Inelastic Phonon Model

## Mode Oscillator Model

The traps involved in trap-to-trap tunneling processes are regarded as single-mode oscillators embedded in the dielectric matrix [5] with a capture rate described by:

$$ c_i = \sum_{j \neq i} C_f \frac{\hbar W_T \sqrt{\pi}}{m_t m_0 r_{j,i}^2 Q_0 \sqrt{kT}} \exp \Bigl( -\frac{W_{\text{opt}} - W_T}{2kT} \Bigr) \exp \Bigl( -\frac{2r_{j,i} \sqrt{2m_t m_0 W_T}}{\hbar} \Bigr) \exp \Bigl( -\frac{E_{\text{trap}}^i - E_{\text{trap}}^j + |E_{\text{trap}}^i - E_{\text{trap}}^j|}{2kT} \Bigr) f_j \quad (532) $$

where:

* Transitions occur between localized state $i$ with energy $E_{\text{trap}}^i$ and neighbouring localized trap states $j$ with energies $E_{\text{trap}}^j$.

* $W_{\text{opt}}$ is the trap optical ionization energy.

* $W_T$ is the trap thermal ionization energy.

* $Q_0 = \sqrt{2(W_{\text{opt}} - W_T)}$.

* $r_{i,j}$ is the spatial distance between traps $i$ and $j$ involved in the transition.

17: Traps and Fixed Charges

Trap Models

*   $f_j$ is the localized trap $j$ occupation probability.

*   $C_f$ is a multiplication factor, which is 1 by default.

*   $m_t$ is the trap-to-trap tunneling mass.

Tunneling between two traps is activated only if the spatial distance between them is smaller than the user-defined parameter $R_{\text{cutoff}}$, which limits the interaction distance for tunneling. By default, the parameter is infinite, so potentially all traps defined in all regions (specified as trap-to-trap tunneling regions) are considered. You can adjust $R_{\text{cutoff}}$ to reduce the size of the Jacobian and numeric issues. Ideally, $R_{\text{cutoff}}$ should be of the order of the spatial distance between traps to allow only first-order neighbor interactions.

The transition rate parameters $W_{\text{opt}}$, $W_{\text{T}}$, $R_{\text{cutoff}}$, $C_f$, and $m_t$ are available through the parameter file in the region trap section.

Table 96 Parameters and their default values for trap-to-trap tunneling

| Symbol | Parameter name | Default value | Unit |
| --- | --- | --- | --- |
| Wopt | T2T_Wopt | 3 | eV |
| WT | T2T_WT | 1.5 | eV |
| Rcutoff | T2T_Rcutoff | 1×1030 | cm |
| Cf | T2T_factor | 1 | 1 |
| mt | T2T_m | 0.5 | 1 |

For trap-to-trap vertex pairs (v1, v2) that lie across a region interface (reg1/reg2), the trap-to-trap tunneling parameters are used in the following order:

1. If there is a `RegionInterface="reg1/reg2"` Traps section in the parameter file, then `T2T_Wopt`, `T2T_WT`, `T2T_m`, and `T2T_factor` of the `RegionInterface` parameters are used directly in the transition rate calculation. Note that in `RegionInterface`, `T2T_Rcutoff` has no meaning.

2. Otherwise, the trap-to-trap tunneling parameters are taken as the average of those values defined in the trap-to-trap tunneling parameters of each region reg1 and reg2.

## Inelastic Phonon Model

Referring to Eq. 514, p. 499, the net change of electron trap occupation at trap $i$, due to capture and emission processes from $i$ to its neighboring (connected) traps is:

$$r_i^n = \sum_j \{f_i(1 - f_j)c_{j,i} - (1 - f_i)f_j e_{i,j}\}$$ (533)

Trap Models

where $c_{j,i}$ is the electron capture rate from trap $j$ to trap $i$, and $e_{i,j}$ is the electron emission rate from trap $i$ to trap $j$. A similar expression exists for holes.

> **NOTE** The trap-to-trap tunneling capture and emission terms here differ from those that describe the transport from the trap to the continuous states of the conduction or valence bands.

The inelastic phonon model for the trap-to-trap process is adapted from [6]. You list the charge capture rate (from trap $j$ to trap $i$) as:

$$ c_{j,i}(\vec{x}_i) = \frac{1}{\tau_0} T_{j,i}((\vec{x}_j|E), \vec{x}_i) M_{i,j}(l) \tag{534} $$

where $\tau_0$ is a tuning parameter, $T_{j,i}$ is the charge tunneling probability from trap $j$ to trap $i$, and $M_{i,j}$ is the phonon transition probability between the two trap energy levels.

The tunneling probability is computed using a simplified WKB formulation:

$$ T_{j,i}((\vec{x}_j|E), \vec{x}_i) = \frac{|\Psi(x_i)|^2}{|\Psi(x_j)|^2} = \exp \left( -\frac{2}{\hbar} \int_{x_j}^{x_i} \sqrt{2m|V(x) - E|} dx \right) \tag{535} $$

where $m$ is the tunneling mass, and $V(x)$ is the conduction or valence energy band variation between the traps $i$ and $j$. You further assume that the conduction or valence band energies between the traps are linear. In the case of traps that are located in different materials, such that the tunneling path crosses a material interface with discontinuities in the conduction or valence band, the tunneling probability becomes a multiplication of tunneling probabilities in each material.

The phonon transition probability is:

$$ M_{i,j}(l) = \left[ \alpha \frac{(l \mp S)^2}{S} + 1 - \alpha \right] \frac{1}{\sqrt{2\pi}} \frac{1}{\sqrt{\chi}} \frac{z^l}{(l + \chi)^l} \exp \left( -S(2f_B + 1) + \frac{l\hbar\omega_0}{2kT} + \chi \right) \tag{536} $$

where:

*   The upper sign is for electrons and the lower sign is for holes.

*   $S$ is the Huang–Rhys factor.

*   $\alpha$ is a tuning factor for the phonon term, similar to Eq. 545, p. 518.

*   $z = 2S\sqrt{f_B(f_B + 1)}$ and $\chi = \sqrt{l^2 + z^2}$.

*   $f_B = \frac{1}{\exp\left(\frac{\hbar\omega_0}{kT}\right) - 1}$ is the Bose–Einstein distribution function for phonons.

*   $l = \frac{|E_{ti} - E_{tj}|}{\hbar\omega_0}$.

17: Traps and Fixed Charges

Trap Models

The key physics are that spatial transport is modeled by the tunneling probability and inelastic transport of the trap energy difference is modeled by the phonon transition probability.

You assume that the trap occupation follows a Fermi-type distribution:

$$ f_{ti} = \frac{1}{1 + g_i \exp \left( \beta \frac{E_{ti}}{kT_i} \right)} $$ (537)

where $g_i$ is the degeneracy factor and $\beta = \begin{cases} 1 & \text{for eNeutral} \\ -1 & \text{for hNeutral} \end{cases}$.

The concept of detailed balance states that there should be zero net transition in each of the different processes at equilibrium, that is, $r_i^n = 0$. Substituting this trap occupancy distribution (Eq. 537) into the stationary condition ($r_i^n = 0$), you can derive the relationship between the capture and emission terms for each trap-to-trap process as:

$$ \frac{e_{i,j}}{c_{j,i}} = \frac{g_i}{g_j} \exp \left\{ \beta \left( \frac{E_{ti}}{kT_i} - \frac{E_{tj}}{kT_j} \right) \right\} $$ (538)

Therefore, after the capture rate is computed, you can compute the emission rate using this expression.

The command file syntax for the inelastic phonon model can be defined only in a `Region-Physics` section with the keyword `Transition=InelasticPhonon`.

**NOTE** You must define `Transition=InelasticPhonon` in the `Physics` sections of every region, whereby you connect the traps using this inelastic phonon trap-to-trap process.

The additions to the parameter file are:

```
Traps {
  T2T_phonon_energy = <float> , <float> # [eV] phonon energy
  T2T_tau0 = <float> , <float>          # [s] fitting parameter
  T2T_S = <float> , <float>             # [1] Huang-Rhys factor
  T2T_g = <float> , <float>             # [1] degeneracy factor
  T2T_mass = <float> , <float>          # [1] relative tunneling mass to m0
  T2T_alpha = <float> , <float>         # [1] tuning factor for phonon term
}
```

You can define these parameters only in a `Region` or `Material` section in the parameter file. Only `T2T_tau0` can be additionally defined in a `RegionInterface` section to allow for special fine-tuning between traps located across region interfaces. Mole fraction dependence is not supported. Table 97 on page 516 lists the default values for these parameters.

17: Traps and Fixed Charges

Trap Models

# Trap-to-Trap Recombination

The trap-to-trap recombination rate assumes mutually exclusive probabilities of electron and hole tunneling to the vertices or sites of each other for recombination:

$$ R_{ij} = \frac{1}{\tau_{\text{recom}}} [T_{ij(e)} \times M_{ij(e)}(l) + T_{ji(h)} \times M_{ij(h)}(l)] \tag{539} $$

where:

*   The tunneling probabilities ($T_{ij(e)}$, $T_{ji(h)}$) and the phonon probabilities ($M_{ij(e)}(l)$, $M_{ij(h)}(l)$) assume the same form as the `InelasticPhonon` trap-to-trap tunneling capture process and use almost the same set of parameters except for a new modification of:

$$ l = \frac{\beta |E_{ti} - E_{tj}|}{\hbar\omega_0} \tag{540} $$

$\beta$ has been introduced to add another degree for fitting.

*   $\tau_{\text{recom}}$ is a fitting parameter.

Similarly, by detailed balance, you can determine the trap-to-trap generation rate, $G_{i,j}$, as follows:

$$ \frac{R_{i,j}}{G_{i,j}} = g_i g_j \exp \left\{ \beta \left( \frac{E_{ti}}{kT_i} - \frac{E_{tj}}{kT_j} \right) \right\} \tag{541} $$

Trap-to-trap recombination can be activated by the keyword `T2Trecombination` in the `DiscreteTrapT2T` trap entry. The parameters of the trap-to-trap generation or recombination rates can be modified in the `Traps` section of the parameter file:

```
T2T_recom = <float>       # [s] recombination rate fitting parameter
T2T_recom_beta = <float>  # [1] energy fitting parameter
```

Table 97 Default values for parameters of inelastic phonon model and trap-to-trap recombination

| Parameter | Default for eNeutral | Default for hNeutral | Unit |
| --- | --- | --- | --- |
| T2T_phonon_energy | 0.057 | 0.057 | eV |
| T2T_tau0 | 1e-4 | 1e-4 | s |
| T2T_S | 2 | 2 | 1 |
| T2T_g | 1 | 1 | 1 |
| T2T_mass | 0.1 | 0.5 | 1 |
| T2T_alpha | 1 | 1 | 1 |

17: Traps and Fixed Charges
Trap Models

Table 97 Default values for parameters of inelastic phonon model and trap-to-trap recombination (Continued)

| Parameter | Default for eNeutral | Default for hNeutral | Unit |
| --- | --- | --- | --- |
| T2T_recom | 1e10 (only one value) | s |  |
| T2T_recom_beta | 1 (only one value) | 1 |  |

## Trap-to-Trap Flux of InelasticPhonon Model

To visualize the trap-to-trap inelastic phonon transport processes of charges between trap vertices, you compute an electron density vectorial flux (units of # cm<sup>-3</sup> s<sup>-1</sup>) according to the formula:

$$ \begin{aligned} \bar{J}_{e, v1} = N_{t1} \left( \sum_{i=2}^{N(eNeutral)} N_{ti} \left\{ c_{i, 1(n)(k)} f_{ti} (1 - f_{t1(k)}) - e_{1, i(n)(k)} f_{t1(k)} (1 - f_{ti}) \right\} \cdot \frac{\bar{v}_i - \bar{v}_1}{|\bar{v}_i - \bar{v}_1|} \right) \\ + N_{t1} \sum_{j=2}^{M(hNeutral)} N_{tj} \left\{ -R_{1j} f_{t1(k)} f_{tj} + G_{1j(k)} (1 - f_{t1(k)}) (1 - f_{tj}) \right\} \cdot \frac{\bar{v}_j - \bar{v}_1}{|\bar{v}_j - \bar{v}_1|} \end{aligned} $$ (542)

A similar expression is derived for the hole flux. These fluxes contain both inelastic phonon trap-to-trap tunneling and recombination processes. To output the trap-to-trap fluxes, add the following option to the Plot section:

```
Plot { T2Tflux }
```

The final plotted quantities are the electron and hole vectorial fluxes (units of # s<sup>-1</sup>) in the TDR output file:

$$ eT2Tflux = \bar{J}_{e, v1} \times Vol_{v1} $$ (543)

$$ hT2Tflux = \bar{J}_{h, v1} \times Vol_{v1} $$ (544)

# Nonlocal Tunneling for Traps

Traps can be coupled to nearby interfaces and contacts by tunneling. Sentaurus Device models nonlocal tunneling to traps as the sum of an inelastic phonon-assisted process and an elastic process [7][8].

17: Traps and Fixed Charges

Trap Models

To use the nonlocal tunneling model for traps:

*   For each interface or contact that you want to couple to traps by tunneling, generate a nonlocal mesh. A nonlocal mesh describes the tunneling paths between the vertices where the traps are located, and the interface or contact for which the nonlocal mesh is constructed (see Nonlocal Meshes on page 152).

*   Specify `eBarrierTunneling` (for coupling to the conduction band) and `hBarrierTunneling` (for coupling to the valence band) in the trap specification in the command file. Provide the names of the nonlocal meshes that the trap must be coupled to using the `NonLocal` keyword of `eBarrierTunneling` and `hBarrierTunneling`.

*   Adjust `TrapVolume`, `HuangRhys`, and `PhononEnergy`, the tunneling masses, and the interface-specific prefactors (see Nonlocal Tunneling Parameters on page 778).

> **NOTE** To model trap-assisted leakage through a barrier that contains traps, at least two separate nonlocal meshes are needed, one for each side of the barrier.

For example:

```
Traps (
   hNeutral Conc=1e15 fromMidBandGap EnergyMid=0 Level TrapVolume=1e-7
   eBarrierTunneling(Nonlocal="NLM1" Nonlocal="NLM2")
)
```

## Electron Capture Rate for the Phonon-Assisted Transition

The electron capture rate for the phonon-assisted transition from the conduction band is:

$$ c_{C,phonon}^n = \frac{\sqrt{m_t m_0^3 k^3 T_n^3} g_C}{\hbar^3 \sqrt{\chi}} V_T S \omega \left[ \frac{\alpha(S-l)^2}{S} + 1 - \alpha \right] \exp \left[ -S(2f_B + 1) + \frac{\Delta E}{2kT} + \chi \right] $$
$$ \times \left( \frac{z}{l + \chi} \right)^l F_{1/2} \left( \frac{E_{F,n} - E_C(0)}{kT_n} \right) \frac{|\Psi(z_o)|^2}{|\Psi(0)|^2} $$ (545)

where:

*   $V_T$ is the interaction volume of the trap. It is set by `TrapVolume` (in μm³) in the command file and in the `Traps` parameter set. The default is 0. `TrapVolume` must be positive when tunneling is activated.

*   $S$ is the Huang–Rhys factor. It is set by `HuangRhys` (dimensionless) in the command file and in the `Traps` parameter set. The default is 0.

*   $\hbar\omega$ is the energy of the phonons involved in the transition. It is set by `PhononEnergy` (in eV) in the command file and in the `Traps` parameter set. The default is 0.

*   $\alpha$ is a dimensionless parameter. It is set by `alpha` (dimensionless) in the command file and in the `Traps` parameter set. The default is 1.

 17: Traps and Fixed Charges

Trap Models

* $l$ is the number of the phonons emitted in the transition.

* $f_B = [\exp(\hbar\omega/kT) - 1]^{-1}$ is the Bose–Einstein occupation of the phonon state.

* $z = 2S\sqrt{f_B(f_B + 1)}$.

* $\chi = \sqrt{l^2 + z^2}$.

* $\Delta E = E_C + 3kT_n/2 - E_{\text{trap}}$, which is the dissipated energy.

* The Fermi energy $E_{F,n}$ and the electron temperature $T_n$ are obtained at the interface or contact, while the lattice temperature is obtained at the site $z_o$ of the trap.

* $m_t$ is the relative (dimensionless) tunneling mass.

* $g_C$ is the prefactor for the Richardson constant at the interface or contact.

For details about these parameters, see Nonlocal Tunneling Parameters on page 778.

# Electron Capture Rate for the Elastic Transition

The electron capture rate for the elastic transition from the conduction band is:

$$c_{C,\text{elastic}}^n = \frac{\sqrt{8m_t}m_0^{3/2}g_C}{\hbar^4\pi}\gamma V_T[E_C(z_o) - E_{\text{trap}}]^2\Theta[E_{\text{trap}} - E_C(0)]\sqrt{E_{\text{trap}} - E_C(0)}f\left(\frac{E_{F,n} - E_{\text{trap}}}{kT_n}\right)\frac{|\Psi(z_o)|^2}{|\Psi(0)|^2}$$ (546)

where $f(x) = 1/(1 + \exp(-x))$ and $\gamma$ is a dimensionless parameter `gamma` that can be set in the command file or the `Traps` parameter set and that defaults to 1. The emission rates are obtained from the capture rates by the principle of detailed balance (see Eq. 519). The hole terms are analogous to the electrons terms. However, `hBarrierTunneling` for contacts and metals is nonphysical and, therefore, ignored.

The ratio of wavefunction is obtained from $\Gamma_{CC}$ described in WKB Tunneling Probability on page 781 as:

$$\frac{|\Psi(z_o)|^2}{|\Psi(0)|^2} = \frac{v(0)}{v(z_o)}\Gamma_{CC}$$ (547)

where $v$ denotes the (possibly imaginary) velocities.

To avoid singularities, for the inelastic transition with the WKB tunneling model, the velocity $v(z_o)$ at the trap site is replaced by the thermal velocity. For the inelastic process, $\Gamma_{CC}$ is computed at the tunneling energy $E_C + kT_n/2$ and, for elastic process, at energy $E_{\text{trap}}$. For the tunneling probability, the default one-band model and the `TwoBand` option are available, as described in WKB Tunneling Probability on page 781.

**17: Traps and Fixed Charges**

Numeric Parameters for Traps

# Numeric Parameters for Traps

When used with Fermi statistics, traps sometimes lead to convergence problems, especially at the beginning of a simulation when Sentaurus Device tries to find an initial solution. Often, you can resolve this problem by changing the numeric damping of the trap charge in the nonlinear Poisson equation.

To change the numeric damping, set `Damping` to a nonnegative number in the `Traps` statement in the global `Math` section. For example:

```
Math {
  Traps(Damping=100)
}
```

Larger values of `Damping` increase damping of the trap charge; a value of `0` deactivates damping. The default value is `10`.

Depending on the particular example, increasing damping might improve or degrade convergence behavior. There are no guidelines regarding the optimal value.

At nonheterointerface vertices, bulk traps are considered only from the region with the lowest band gap. When bulk traps from other regions are important, use the `RegionWiseAssembly` option in the `Traps` statement in the global `Math` section, which properly considers bulk traps from all adjacent regions.

# Visualizing Traps

You can plot the concentration of trapped electrons and holes (full concentration multiplied by trap occupation) as follows:

*   Specify `eTrappedCharge` in the `Plot` section to plot the concentration of trapped electrons in `eNeutral` and `Acceptor` traps and of negative fixed charges.

*   Specify `hTrappedCharge` in the `Plot` section to plot the concentration of trapped holes in `hNeutral` and `Donor` traps and of positive fixed charges.

These datasets include the contribution of interface charges. To that end, Sentaurus Device converts interface densities to volume densities and, therefore, their contribution depends on the mesh spacing. To plot interface charges separately as interface densities, use `eTrappedCharge/RegionInterface` and `hTrappedCharge/RegionInterface`. In Sentaurus Visual, these quantities are selected with `Int(eTrappedCharge)` and `Int(hTrappedCharge)`.

**17: Traps and Fixed Charges**

Visualizing Traps

Specify `TotalTrapConcentration` to plot the absolute value of the net bulk trap concentration. Similarly, specify `TotalTrapConcentration/RegionInterface` to plot the absolute value of the net interface trap concentration. In Sentaurus Visual, this quantity is selected with `Int(TotalTrapConcentration)`. These quantities do not account for occupancy. You can specify `eTrapConcentration` and `hTrapConcentration` to plot the absolute values of the bulk trap concentration for acceptor-type or donor-type traps, respectively.

You can also specify the `eInterfaceTrappedCharge` and `hInterfaceTrappedCharge` quantities, to plot the amount of trapped charges at interfaces in cm<sup>-2</sup>. These quantities have nonzero values only at interface vertices.

Specify `TotalInterfaceTrapConcentration` to plot the absolute value of the net interface trap concentration. This is similar to `TotalTrapConcentration/RegionInterface`; however, `TotalInterfaceTrapConcentration` is stored as a bulk quantity with a nonzero value only on interfaces. You can specify `eInterfaceTrapConcentration` and `hInterfaceTrapConcentration` to plot the absolute value of the interface trap concentrations for acceptor-type or donor-type traps, respectively.

Specify `TrapConcentration` to plot the separated full bulk trap concentration that was defined in each trap entry and at each trap energy level. This applies only in the `CurrentPlot` statement. In the `CurrentPlot` statement, you can also specify `TrapConcentrationPerEntry` to plot the integrated trap concentration for each trap entry.

The entries for trap concentration per energy per trap are displayed in the current plot file as:

```
TrapConcentration_<TrapEntryName>(<TrapType>, <EnergyDistribution>)/
<EnergyLevel>
```

For example, the following trap entry in the command file:

```
Traps (
    (name= "A1Int" Conc= 1e11 Acceptor Uniform EnergyMid=0 fromMidBandGap)
)
```

is displayed as `TrapConcentration_A1Int(Ac, Un)/0` to `TrapConcentration_A1Int(Ac, Le)/12`. Note that the number of energy levels is set by `TrapDLN` and defaults to 13. The TDR file displays the integrated trap concentration as `TrapConcentration_A1Int(Ac, Un)`.

> **NOTE** For traps specified in insulators at vertices on interfaces to semiconductors, the charge density in the insulator parts associated with the vertices is reassigned to the semiconductor parts. This involves rescaling the densities with the ratio of the volumes of the two parts and, typically, this distorts the data for visualization. However, the distortion has no effect on the actual solution.

Visualizing Traps

Specify `TrapConcPerEntry` to plot the trap concentrations for each energy level of each trap entry specified in the command file. This also stores the integrated trap concentration (trap concentration summed over all energy levels for a given trap entry).

In plot files, the entries for trap concentration per energy per trap are displayed as:

```
TrapConcentration_<TrapEntryName>(<TrapType>, <EnergyDistribution>)-
<EnergyLevel>
```

For example, the following trap entry in the command file:

```
Traps (
  (name= "A1Int" Conc= 1e11 Acceptor Uniform EnergyMid=0 fromMidBandGap)
)
```

results in 13 entries from `TrapConcentration_A1Int(Ac, Un)-0` to `TrapConcentration_A1Int(Ac, Le)-12`. In addition, the integrated trap concentration is stored as `TrapConcentration_A1Int(Ac, Un)`.

To plot the recombination rates for the conduction band and valence band due to traps, specify `eGapStatesRecombination` and `hGapStatesRecombination`, respectively.

Specify `TrappingRates` in the `Plot` section to see the capture and emission rates for each trap, split into local processes (as described in Local Capture and Emission Rates), inelastic tunneling processes (see Electron Capture Rate for the Phonon-Assisted Transition), and elastic tunneling processes (see Electron Capture Rate for the Elastic Transition). For `eNeutral` and `Acceptor` traps, capture is electron capture. For `hNeutral` and `Donor` traps, capture is hole capture, and likewise for emission.

In addition, you can plot the trapped carrier density and occupancy probability versus energy at positions specified in the command file. You must define the name of the plot (.plt) file in the `File` section using the keyword `TrappedCarPlotFile`. For example:

```
File {
  ...
  TrappedCarPlotFile = "itraps_trappedcar"
}
```

Plotting is activated by including the `TrappedCarDistrPlot` section (similar to the `CurrentPlot` section) in the command file:

```
TrappedCarDistrPlot {
  MaterialInterface="Silicon/Oxide" {(0.5 0)}
  ...
}
```

17: Traps and Fixed Charges

Visualizing Traps

The positions that define where the trapped carrier density, occupancy probability, and trap density versus energies should be plotted are specified materialwise or regionwise in the `TrappedCarDistrPlot` section, grouped into regions, materials, region interfaces, and material interfaces.

A set of coordinates of positions in parentheses follows the region or region interface. For example:

```
TrappedCarDistrPlot {
    MaterialInterface="Silicon/Oxide" {(0.5 0)}
    RegionInterface="Region_2/Region_3" {(0.1 0.001)}
    Region="Region_1" {(0.3 0) (0 0) (-0.1 0.2)}
    Material="Silicon" {(0.27 0) (0 0.01)}
    ...
}
```

For each position defined by its coordinates, Sentaurus Device searches for the closest vertex inside the corresponding region or on the corresponding region interface. This is the actual position where plotting is performed.

The difference between user coordinates and actual coordinates is displayed in the log file for each valid position in the `TrappedCarDistrPlot` section in the following format:

```
[Position(User)       ClosestVertex   PositionClosestVertex]
[(2.4000,-0.1000)            718                   (2.3130,-0.0500)]
[(2.5000,-0.1000)            743                   (2.3500,-0.0500)]
```

In addition, a simplified syntax for a global position inside the device is available:

```
TrappedCarDistrPlot {
    (0.5 0)
    ...
}
```

In this case, the distribution plotting uses the closest vertex.

Based on trap types and positions, a unique entry is created in the generated plot. The naming is `<TrapType><Counter>(<position>)`, where `<Counter>` is applied when multiple traps of the same type are used. For each entry, the `Energy`, `TrappedChargeDistribution`, `DistributionFunction`, and `TrapDensity` fields are available for plotting. In addition, for each entry, `eQuasiFermi` and `hQuasiFermi` are available for plotting, which allow you to monitor the evolution of `DistributionFunction` relative to quasi-Fermi levels.

17: Traps and Fixed Charges

Insulator Fixed Charges

# Insulator Fixed Charges

Sentaurus Device supports fixed charges in insulators and at insulator interfaces. Insulator fixed charges are defined with the keyword `FixedCharge` in the `Physics-Traps` section:

```
Physics (Material="Oxide"){
  Traps(
    (FixedCharge
      SpatialShape = [Gaussian | Uniform]
      Conc = <float>          # [cm-3]
      SpaceMid = <vector>     # [um]
      SpaceSig = <vector>     # [um]
    )
  )
}
```

This syntax applies similarly to `MaterialInterface`, `Region`, and `RegionInterface`.

The keyword `Conc` specifies the maximum bulk or interface concentration of fixed charges in cm<sup>–3</sup> or cm<sup>–2</sup>, respectively. The `SpaceMid` and `SpaceSig` keywords have the same meaning as for traps (see Energetic and Spatial Distribution of Traps on page 490). They are optional for uniform spatial distributions but mandatory for Gaussian spatial distributions.

# References

[1] L. Colalongo *et al.*, “Numerical Analysis of Poly-TFTs Under Off Conditions,” *Solid-State Electronics*, vol. 41, no. 4, pp. 627–633, 1997.

[2] S. D. Ganichev *et al.*, “Distinction between the Poole-Frenkel and tunneling models of electric-field-stimulated carrier emission from deep levels in semiconductors,” *Physical Review B*, vol. 61, no. 15, pp. 10361–10365, 2000.

[3] S. Makram-Ebeid and M. Lannoo, “Quantum model for phonon-assisted tunnel ionization of deep levels in a semiconductor,” *Physical Review B*, vol. 25, no. 10, pp. 6406–6424, 1982.

[4] K. A. Nasyrov *et al.*, “Two-bands charge transport in silicon nitride due to phonon-assisted trap ionization,” *Journal of Applied Physics*, vol. 96, no. 8, pp. 4293–4296, 2004.

[5] K. A. Nasyrov and V. A. Gritsenko, “Charge transport in dielectrics via tunneling between traps,” *Journal of Applied Physics*, vol. 109, no. 9, p. 093705, 2011.

[6] A. Schenk, *Advanced Physical Models for Silicon Device Simulation*, Wien: Springer, 1998.

**17: Traps and Fixed Charges**

References

[7] A. Palma *et al.*, “Quantum two-dimensional calculation of time constants of random telegraph signals in metal-oxide–semiconductor structures,” *Physical Review B*, vol. 56, no. 15, pp. 9565–9574, 1997.

[8] F. Jiménez-Molinos *et al.*, “Direct and trap-assisted elastic tunneling through ultrathin gate oxides,” *Journal of Applied Physics*, vol. 91, no. 8, pp. 5116–5124, 2002.

## References

