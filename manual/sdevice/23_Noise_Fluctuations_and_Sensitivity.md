# CHAPTER 23 Noise, Fluctuations, and Sensitivity

*This chapter discusses noise analysis, fluctuation analysis, and sensitivity analysis in Sentaurus Device.*

This chapter explains the Sentaurus Device features to model noise, statistical fluctuations of doping, trap concentration, workfunction, band edge, geometry, dielectric constant, metal conductivity, and sensitivity to variations of model parameters, doping, and geometry. All these topics deal with the response of the device characteristics to small, device-internal variations. For noise, these variations occur randomly over time within a single device; for statistical fluctuations, the variations are random device-to-device variations; and for sensitivity, the variations are user supplied. Despite the different nature of the variations, they all can be handled by the same linearization approach called the impedance field method and, therefore, Sentaurus Device treats them all in a common framework.

Using the Impedance Field Method explains how to perform noise, fluctuation, and sensitivity analysis. Noise Sources on page 734 discusses the noise and random fluctuation models that Sentaurus Device offers. Statistical Impedance Field Method on page 745 describes a modeling approach for random dopant fluctuations, trap concentration fluctuations, geometric variations, and workfunction variations based on statistical sampling. Deterministic Variations on page 757 discusses user-supplied variations of doping, geometry, and model parameters.

Impedance Field Method on page 762 discusses the background of the method [1], and Noise Output Data on page 764 summarizes the data available for visualization.

## Using the Impedance Field Method

Sentaurus Device treats noise analysis, fluctuation analysis, and sensitivity analysis by the impedance field method, and as extensions of small-signal analysis (see Small-Signal AC Analysis on page 101).

> **NOTE** The impedance field method is not supported with the `HeteroInterface` option (see Abrupt and Graded Heterojunctions on page 11), the `Thermionic` option (see Thermionic Emission Current on page 819), or dipole layers (Dipole Layer on page 180).

For noise and random fluctuations, Sentaurus Device computes the variances and correlation coefficients for the voltages at selected circuit nodes, assuming the net current to these nodes is fixed. As the computation is performed in frequency space, the computed quantities are

Using the Impedance Field Method

called the noise voltage spectral densities. Sentaurus Device also computes the variances and correlation coefficients of the currents through the nodes, assuming fixed voltages; these quantities are the noise current spectral densities.

For the statistical impedance field method (sIFM) and for deterministic variations, Sentaurus Device computes responses of node voltages assuming fixed currents and responses of node currents assuming fixed voltages.

---

## Specifying Variations

To use noise and random fluctuation analysis, specify the physical models for the microscopic origin of the deviations (called the local noise sources, LNS) as options to the keyword `Noise` in the `Physics` section of the command file of Sentaurus Device:

```
Physics {
  ...
  Noise <string> ( <Noisemodels> )
}
```

where `<Noisemodels>` is a list that specifies any number of noise models listed in Table 313 on page 1606. The name given by the string after `Noise` is optional. Using `Noise` specifications with different names allows you to investigate different specifications of noise in a single simulation run.

For the sIFM, specify `RandomizedVariation` in the global `Math` section and in a device-specific global `Physics` section:

```
Math {
  RandomizedVariation <string> ( <specification> )
  ...
}
Device <string> {
  Physics {
    RandomizedVariation <string> ( <specification> )
  }
}
```

where `<specification>` specifies the details for the randomization (see Statistical Impedance Field Method on page 745).

23: Noise, Fluctuations, and Sensitivity

Using the Impedance Field Method

For deterministic variations, specify the variations as options to `DeterministicVariation` in the global `Physics` section:

```
Physics {
  DeterministicVariation( <variations> )
  ...
}
```

where `<variations>` is a list that specifies any number of deterministic variations (see Deterministic Variations on page 757 and Table 284 on page 1591).

## Specifying the Solver

In any case, use the `ObservationNode` option to the `ACCoupled` statement to specify the device nodes for which the noise spectral densities or deviations are required. For example:

```
ACCoupled (
  StartFrequency = 1.e8 EndFrequency = 1.e11
  NumberOfPoints = 7 Decade
  Node (n_source n_drain n_gate)
  Exclude (v_drain v_gate)
  ObservationNode (n_drain n_gate)
  ACExtract = "mos"
  NoisePlot = "mos"
  ){
  poisson electron hole contact circuit
  }
}
```

The keyword `ObservationNode` enables noise and fluctuation analysis (in this case, for the nodes `n_drain` and `n_gate`). `NoisePlot` specifies a file name prefix for device-specific plots (see Noise Output Data on page 764). For more information on the `ACCoupled` statement, see Small-Signal AC Analysis on page 101.

> **NOTE** The observation nodes must be a subset of the nodes specified in `Node(...)`.

## Analysis at Frequency Zero

You can perform variation analysis at frequency zero. If you specify in the `ACCoupled` statement the single frequency zero by:

```
StartFrequency = 0. EndFrequency = 0. NumberOfPoints = 1
```

Using the Impedance Field Method

this mode is activated, which enhances both speed and memory consumption of the analysis, compared to the analysis at positive frequency. However, you must be aware of the following:

*   Capacitances of AC nodes cannot be extracted and are set to zero in the output files.

*   For general structures, only the current Green’s functions (and their responses) are well defined and computed. The voltage Green’s functions and their related responses cannot be computed. Therefore, their computation is deactivated by default and corresponding output data is set to zero. However, if all parts of the structure are conductively (and not only capacitively) coupled, then voltage responses are well defined and their computation can be activated explicitly by specifying `VoltageGreenFunctions` as a parameter in the `ACCoupled` statement.

# Output of Results

The results of the analysis are the noise voltage spectral densities, the noise current spectral densities, and voltage and current deviations. They appear in the `ACExtract` file (see Table 135) and, in the case of the sIFM, in a separate `.csv` file. The units are V<sup>2</sup> s for the voltage spectral densities and A<sup>2</sup> s for the current noise spectral densities. If the string specified after `Noise` is not empty, it is prefixed to the name of the spectral density in the `ACExtract` file.

Table 135 Noise and fluctuation data written into ACExtract file

| Name | Description |
| --- | --- |
| S_V | Autocorrelation noise voltage spectral density (NVSD) |
| S_I | Autocorrelation noise current spectral density (NISD) |
| S_V_ee S_V_hh | Electron NVSD Hole NVSD |
| S_V_eeDiff S_V_hhDiff | Electron NVSD due to diffusion LNS Hole NVSD due to diffusion LNS |
| S_V_eeMonoGR S_V_hhMonoGR | Electron NVSD due to monopolar GR LNS Hole NVSD due to monopolar GR LNS |
| S_V_eeFlickerGR S_V_hhFlickerGR | Electron NVSD due to flicker GR LNS Hole NVSD due to flicker GR LNS |
| S_V_BandEdge S_I_BandEdge | NVSD and NISD due to band edge fluctuations |
| S_V_Conductivity S_I_Conductivity | NVSD and NISD due to metal conductivity fluctuations |
| S_V_Doping S_I_Doping | NVSD and NISD due to random dopant fluctuations |
| S_V_Epsilon S_I_Epsilon | NVSD and NISD due to dielectric constant variations |

 **23: Noise, Fluctuations, and Sensitivity**

Using the Impedance Field Method

Table 135 Noise and fluctuation data written into ACExtract file (Continued)

| Name | Description |
| --- | --- |
| S_V_Geometric S_I_Geometric | NVSD and NISD due to geometric fluctuations |
| S_V_TrapConcentration S_I_TrapConcentration | NVSD and NISD due to trap concentration fluctuations |
| S_V_Trap S_I_Trap | NVSD and NISD due to trapping noise |
| S_V_Workfunction S_I_Workfunction | NVSD and NISD due to workfunction fluctuations |
| ReS_VXV ImS_VXV | Real/imaginary parts of the cross correlation noise voltage spectral density (NVXVSD) |
| ReS_IXI ImS_IXI | Real/imaginary parts of the cross correlation noise current spectral density |
| ReS_VXV_ee ImS_VXV_ee ReS_VXV_hh ImS_VXV_hh | Real/imaginary parts of the electron/hole NVXVSD |
| ReS_VXV_eeDiff ImS_VXV_eeDiff ReS_VXV_hhDiff ImS_VXV_hhDiff | Real/imaginary parts of the electron/hole NVXVSD due to diffusion LNS |
| ReS_VXV_eeMonoGR ImS_VXV_eeMonoGR ReS_VXV_hhMonoGR ImS_VXV_hhMonoGR | Real/imaginary parts of the electron/hole NVXVSD due to monopolar GR LNS |
| ReS_VXV_eeFlickerGR ImS_VXV_eeFlickerGR ReS_VXV_hhFlickerGR ImS_VXV_hhFlickerGR | Real/imaginary parts of the electron/hole NVXVSD due to flicker GR LNS |
| ReS_VXV_BandEdge ReS_IXI_BandEdge | Real part of the NVXVSD and NIXISD due to band edge fluctuations |
| ReS_VXV_Conductivity ReS_IXI_Conductivity | Real part of the NVXVSD and NIXISD due to metal conductivity fluctuations |
| ReS_VXV_Doping ReS_IXI_Doping | Real part of the NVXVSD and NIXISD due to random dopant fluctuations |
| ReS_VXV_Epsilon ReS_IXI_Epsilon | Real part of the NVXVSD and NIXISD due to dielectric constant fluctuations |
| ReS_VXV_Geometric ReS_IXI_Geometric | Real part of the NVXVSD and NIXISD due to geometric fluctuations |

23: Noise, Fluctuations, and Sensitivity

Noise Sources

Table 135 Noise and fluctuation data written into ACExtract file (Continued)

| Name | Description |
| --- | --- |
| ReS_VXV_TrapConcentration ReS_IXI_TrapConcentration | Real part of the NVXVSD and NIXISD due to trap concentration fluctuations |
| ReS_VXV_Trap ImS_VXV_Trap ReS_IXI_Trap ImS_IXI_Trap | Real/imaginary parts of the NVXVSD and NIXISD due to trapping noise |
| ReS_VXV_Workfunction ReS_IXI_Workfunction | Real parts of the NVXVSD and NIXISD due to workfunction fluctuations |
| dV<name> | Voltage deviation due to deterministic variation <name> |
| dI<name> | Current deviation due to deterministic variation <name> |

# Noise Sources

> **NOTE** Noise scales differently with the device width compared to currents or voltages. For all noise sources noted in this section, for 2D devices, the device width is assumed to be given by `AreaFactor`. Therefore, it is not necessary to perform a full 3D simulation to obtain the correct scaling behavior for an essentially 2D structure. For 3D structures, when simulating only half (or a quarter) of the structure, you can use `AreaFactor=2` (or `AreaFactor=4`) to obtain the correct scale for the full structure, provided that spatial correlations of the noise sources can be neglected.

## Common Options

All noise sources discussed in this section can be specified with the parameters `SpaceMid`, `SpaceSig`, and `SpatialShape`. These parameters can restrict the noise source to a window. The possible values, the default values, and the modifier function specified by these keywords are described in Energetic and Spatial Distribution of Traps on page 490. The modifier function is applied to each of the two coordinates on which a noise source depends. For noise sources without spatial correlation, this means that the square of the modifier function is multiplied by the noise source.

For example, the following unnamed `Noise` section activates random dopant fluctuations globally:

```
Noise (Doping)
```

23: Noise, Fluctuations, and Sensitivity

Noise Sources

The following `Noise` section named `window` activates random dopant fluctuations in a cube of 20 nm side length, centered at the origin:

```
Noise "window" (
  Doping (
    SpaceMid = (0 0 0)
    SpaceSig = (0.01 0.01 0.01)
    SpatialShape = Uniform
  )
)
```

# Diffusion Noise

The diffusion noise source (keyword `DiffusionNoise`) available in Sentaurus Device reads:

$$ K_{n, n}^{\text{Diff}}(\vec{r}_1, \vec{r}_2, \omega) = 4qn(\vec{r}_1)kT_n(\vec{r}_1)\mu_n(\vec{r}_1)\delta(\vec{r}_1 - \vec{r}_2) $$ (773)

A corresponding expression is used for holes. $K_{n, n}^{\text{Diff}}$ is a diagonal tensor.

$T_n$ is either the lattice or carrier temperature, depending on the specification in the command file:

```
DiffusionNoise ( <temp_option> )
```

where `<temp_option>` is `LatticeTemperature` (default), `eTemperature`, `hTemperature`, or `e_h_Temperature`.

For example, if the following command is specified:

```
Physics {
  Noise ( DiffusionNoise ( eTemperature ) )
}
```

Sentaurus Device uses the electron temperature for the electron noise source and the lattice temperature for the hole noise source. The keyword `e_h_Temperature` forces the corresponding carrier temperature to be used for the diffusion noise source for each carrier type.

23: Noise, Fluctuations, and Sensitivity
Noise Sources

# Equivalent Monopolar Generation–Recombination Noise

An equivalent monopolar generation–recombination (GR) noise source model (keyword `MonopolarGRNoise`) for a two-level, GR process can be expressed as a tensor [2]:

$$ K_{n, n}^{GR}(\vec{r}_1, \vec{r}_2, \omega) = \frac{\vec{j}_n(\vec{r}_1) \vec{j}_n(\vec{r}_1)}{n} \cdot \frac{4\alpha\tau_{eq}}{1 + \omega^2\tau_{eq}^2} \delta(\vec{r}_1 - \vec{r}_2) $$ (774)

where $\alpha$ is a fitting parameter and $\tau_{eq}$ an equivalent GR lifetime. The parameters $\tau_{eq}$ and $\alpha$ can be modified in the parameter file of Sentaurus Device. A similar expression is used for holes.

> **NOTE** This model does not use the actual generation–recombination models activated in the simulation. Therefore, it cannot be considered a physical model for recombination noise.

# Bulk Flicker Noise

The flicker generation–recombination (GR) noise model (keyword `FlickerGRNoise`) for electrons (similar for holes) is:

$$ K_{n, n}^{fGR}(\vec{r}_1, \vec{r}_2, \omega) = \frac{\vec{j}_n(\vec{r}_1) \vec{j}_n(\vec{r}_1)}{n(\vec{r}_1)} \frac{2\alpha_H}{\pi\nu\ln(\tau_1/\tau_0)} [\operatorname{atan}(\omega\tau_1) - \operatorname{atan}(\omega\tau_0)] \delta(\vec{r}_1 - \vec{r}_2) $$ (775)

where $\alpha_H$ is a fit parameter; $\omega = 2\pi\nu$, the angular frequency; and the time constants fulfill $\tau_0 < \tau_1$. The parameters $\alpha_H$, $\tau_0$, and $\tau_1$ for electrons and holes are accessible in the parameter file. With increasing frequency, the noise source changes from constant to $1/\nu$ behavior close to the frequency $\nu_1 = 1/\tau_1$ and, ultimately, to $1/\nu^2$ behavior at $\nu_0 = 1/\tau_0$.

> **NOTE** This model does not use the actual generation–recombination and trap models activated in the simulation. Therefore, it cannot be considered a physical model for flicker noise.

# Trapping Noise

The `Traps` option to `Noise` activates a trapping noise model that follows the microscopic model in [3]. The trapping noise sources are determined fully by the trap model and, therefore, do not require additional adjustable parameters. For example:

```
Physics { Noise(Traps) }
```

23: Noise, Fluctuations, and Sensitivity

Noise Sources

activates trapping noise for all traps is the device. It is not possible to activate trapping noise for selected traps only. All trap models apart from tunneling to electrodes are supported. For more details on traps, see Chapter 17 on page 489.

Consider a trap level $k$ with concentration $N_{t,k}$ and trap electron occupation $f_k$. Trapping noise is expressed by adding a Langevin source $s_{i,k}$ to the net electron capture rate for each process $i$:

$$ R_{i,k} = N_{t,k}(1 - f_k)c_{i,k} - N_{t,k}f_k e_{i,k} + s_{i,k} $$ (776)

where $c_{i,k}$ is the electron capture rate for a trap occupied by zero electrons, and $e_{i,k}$ is the electron emission rate for a trap occupied by one electron (see also Eq. 515, p. 499). Denoting the expectation value with $\langle \ \rangle$, the trapping noise source takes the form:

$$ K_{ij,k}^{\text{trap}}(\omega) = 2q^2 \int dt \langle s_{i,k}(0)s_{j,k}(t) \rangle \exp(-i\omega t) = 2q^2 \delta_{ij} N_{t,k} [(1 - f_k)c_{i,k} + f_k e_{i,k}] $$ (777)

That is, different capture or emission processes are independent, and the noise source for a given process is twice the total trapping rate (the sum of the capture and emission rates). The model also assumes that different trap distributions are independent, so that their noise contributions add.

## Random Dopant Fluctuations

The noise sources for random dopant fluctuations are activated by the `Doping` keyword. The noise source for acceptor fluctuations reads:

$$ K_A^{\text{RDF}}(\vec{r}_1, \vec{r}_2, \omega) = N_A(\vec{r}_1) \frac{\Theta(0.5\text{Hz} - |\nu|)}{1\text{Hz}} \delta(\vec{r}_1 - \vec{r}_2) $$ (778)

Here, $\nu = \omega/2\pi$ is the frequency. An analogous expression holds for the noise source for donors, $K_D^{\text{RDF}}$. Physically, the noise sources are static. However, to avoid a $\delta$-function in frequency space, Sentaurus Device spreads the spectral density of the noise source over a 1 Hz frequency interval. Eq. 778 is based on the assumption that individual dopant atoms are completely uncorrelated.

Acceptors and donors are considered to be independent. Their contributions to the noise spectral densities add. By default, both acceptor and donor concentrations are assumed to fluctuate. Using either the option `Type=Acceptor` or `Type=Donor` of `Doping`, the fluctuation can be restricted to acceptors or donors, respectively. For example:

```
Physics {
   Noise "acceptor" ( Doping(Type=Acceptor) )
   Noise "donor" ( Doping(Type=Donor) )
}
```

Noise Sources

declares two named `Noise` sections that allow you to examine the impact of the fluctuation of acceptors and donors separately.

By default, Sentaurus Device neglects the impact of the random dopant fluctuations on mobility and bandgap narrowing. To take their impact into account, specify the `Mobility` and `BandgapNarrowing` options to the `Doping` keyword. For example:

```
Physics { Noise( Doping(Mobility) ) }
```

activates the random dopant fluctuation noise source, taking into account the impact of the fluctuations on mobility.

> **NOTE** It is strongly advisable to use either both the `BandgapNarrowing` and `Mobility` options or neither option. Otherwise, inconsistencies can arise when the mobility depends indirectly on bandgap narrowing. Even when this dependency is weak, the inconsistency can lead to large errors in IFM results.

# Random Geometric Fluctuations

The geometric fluctuation model accounts for random displacements of electrodes on insulator, as well as metal–insulator, insulator–insulator, and semiconductor–insulator interfaces. The noise source reads:

$$ K^{\text{geo}}(\vec{r}_1, \vec{r}_2, \omega) = \frac{\Theta(0.5\text{Hz} - |\nu|)}{1\text{Hz}} \langle \delta s(\vec{r}_1) \delta s(\vec{r}_2) \rangle $$ (779)

where $\nu = \omega/2\pi$ is the frequency, and the correlation of the displacements $\delta s$ is given by:

$$ \langle \delta s(\vec{r}_1) \delta s(\vec{r}_2) \rangle = \hat{n}(\vec{r}_1) \cdot \hat{n}(\vec{r}_2) [a_{\text{iso}}(\vec{r}_1) + |\vec{a}(\vec{r}_1) \cdot \hat{n}(\vec{r}_1)|] [a_{\text{iso}}(\vec{r}_2) + |\vec{a}(\vec{r}_2) \cdot \hat{n}(\vec{r}_2)|] \exp \left[ -\frac{(\vec{r}_1 - \vec{r}_2)^2}{\lambda^2} \right] $$ (780)

where:

*   $\vec{r}_1$ and $\vec{r}_2$ are positions on the interface.

*   $\hat{n}(\vec{r})$ is the local interface normal in point $\vec{r}$.

*   $a_{\text{iso}}$ (the isotropic correlation amplitude), $\vec{a}$ (the vectorial correlation amplitude), and $\lambda$ (the correlation length) are adjustable parameters.

The correlation has the following noteworthy properties:

*   Displacements of interface positions occur only in the interface normal direction.

*   The displacement amplitude depends on the interface direction when $\vec{a}$ is nonzero.

23: Noise, Fluctuations, and Sensitivity

Noise Sources

* Displacements are spatially correlated; the correlations decay with increasing distance.

* Correlations depend on the relative normal direction. Perpendicular interfaces are uncorrelated; opposing interfaces are negatively correlated (so the actual shifts are positively correlated).

The impact of displacements is accounted for in the variation of the dielectric constant in the Poisson equation, in the variation of the space charge in the Poisson equation, and in the variation of the band-edge profile in the continuity and density gradient equations. The impact through other quantities, such as tunneling rates, is currently neglected.

To use geometric fluctuations, in the global `Math` section for a device, specify one or more surfaces. Each surface has a name and is the union of an arbitrary number of interfaces and electrodes. The following example specifies a surface `S2` that consists of all the poly–oxide interfaces in the device and the `channel/gateoxide` region interface:

```
Device "MOS" {
  Math {
    Surface "S2" (
      RegionInterface="channel/gateoxide"
      MaterialInterface="PolySi/Oxide"
    )
    ...
  }
```

The order in which regions or materials in the specification of interfaces are named determines the sense of interface displacements: The positive direction points from the region or material named first into the region or material named second.

The surfaces are then used to activate the noise sources. The following example activates geometric fluctuations for surfaces `S1` and `S2`:

```
Physics {
  Noise(
    GeometricFluctuations "S1"
    GeometricFluctuations "S2"
  ) ...
} ...
} ...
```

Points on the same surface are correlated according to Eq. 780. Points on different surfaces are uncorrelated. The contributions of different surfaces to the noise spectral densities add.

The parameters $a_{iso}$, $\vec{a}$, and $\lambda$ are specified as the parameters `Amplitude_Iso`, `Amplitude`, and `lambda` in a surface-specific `GeometricFluctuations` parameter set. All three parameters are given in micrometers, and default to zero. $\lambda$ must be set to positive value.

Noise Sources

For example:

```
GeometricFluctuations "S1" {
  lambda = 5e-3
  Amplitude = (9e-4, 3e-4, 0)
  Amplitude_Iso = 1e-4
}
```

**NOTE** For 3D structures, the mesh spacing on the fluctuating interfaces must be small compared to the correlation length $\lambda$ to be able to resolve the Gaussian in Eq. 780. For 2D structures, the mesh does not need to resolve the Gaussian.

The `GeometricFluctuations` keyword supports options, which are specified as follows:

```
GeometricFluctuations "S1" (
  Options = <0..1>                   * default 0
  WeightQuantumPotential = <float>   * default 0.5
  WeightDielectric = <float>         * default 0
)
```

When you specify geometric variations for a semiconductor–insulator interface, you can specify whether the variation should be applied to both sides of the interface (`Options=0`) or only to the semiconductor side (`Options=1`).

For example, in a MOSFET, if you want to change the thickness of the semiconductor body, but not the thickness of the gate insulator, you can use `Options=0` and include in the `Surface` specification both the (bottom) semiconductor–gate insulator interface and the (top) gate insulator–contact or poly interface, such that the movements of the top and bottom gate insulator interfaces leave the gate insulator thickness unaltered. Alternatively, you can use `Option=1` and include in the surface specification only the (bottom) semiconductor–gate insulator interface. Physically, both options are nearly equivalent; however, the latter can sometimes be numerically more accurate.

The values given with `WeightQuantumPotential` and `WeightDielectric` interpolate between two different approximations for the variation terms that arise from the density- gradient quantum correction and the dielectric constant. Calibrating these two parameters can improve the accuracy of geometric variation results. Doing so is usually only worthwhile when computing insulator position variations, while keeping the insulator thickness fixed.

23: Noise, Fluctuations, and Sensitivity
Noise Sources

# Random Trap Concentration Fluctuations

Trap concentration variations are activated by the `TrapConcentration` option to `Noise`. For each trap level, Sentaurus Device uses a noise source of the form:

$$ K_{ii}^{\text{trapconc}}(\vec{r}_1, \vec{r}_2, \omega) = N_i(\vec{r}_1) \frac{\Theta(0.5\text{Hz} - |\nu|)}{1\text{Hz}} \delta(\vec{r}_1 - \vec{r}_2) $$ (781)

Here, $N_i$ is the concentration for the trap level $i$.

All trap levels are assumed to be mutually independent. Their contributions to the noise spectral densities add.

The trap concentration fluctuation model accounts for the impact of the trap concentration on the space charge in the Poisson equation and on the trap-related generation–recombination rates in the continuity equations.

# Random Workfunction Fluctuations

The random workfunction fluctuations describe the impact of the fluctuation of the workfunction at contacts on insulators and at metal–insulator interfaces. The noise source reads:

$$ K^{\text{workfunction}}(\vec{r}_1, \vec{r}_1, \nu) = \frac{\Theta(0.5\text{Hz} - |\nu|)}{1\text{Hz}} a(\vec{r}_1) a(\vec{r}_2) \exp \left[ -\frac{(\vec{r}_1 - \vec{r}_2)^2}{\lambda^2} \right] $$ (782)

where:

*   $\nu = \omega/2\pi$ is the frequency.

*   $a$ is the workfunction standard deviation.

*   $\lambda$ is the correlation length.

> **NOTE** The spatial correlation in Eq. 782 differs from the one created by the randomization procedure used for the sIFM-based approach (see Workfunction Variations on page 751).

Workfunction fluctuations are activated by the `WorkfunctionFluctuations` option to `Noise`. This option must be followed by a string that denotes the name of a surface that consists exclusively of contacts on insulators and metal–insulator interfaces. For example:

```
Device "MOS" {
   Math {
      Surface "S3" (
         Electrode = "gate"
```

Noise Sources

```
        MaterialInterface = "Nitride/Aluminum"
    )
}
Physics {
    Noise(WorkfunctionFluctuations "S3") ...
} ...
} ...
```

The definition of surfaces is described in Random Geometric Fluctuations on page 738. Any number of `WorkfunctionFluctuations` (with different names) can be specified. They are considered to be uncorrelated, and their contributions to the noise spectral densities add.

The parameters $a$ and $\lambda$ are specified by `Amplitude` (in eV) and `lambda` (in $\mu$m) in a surface-specific `WorkfunctionFluctuations` parameter set. For example:

```
WorkfunctionFluctuations "S3" {
    lambda = 0.01
    Amplitude = 0.4
}
```

---

# Random Band Edge Fluctuations

Random band edge fluctuations describe the effect of the variation of the electron affinity $\delta\chi$ and the band gap $\delta E_{g,tot} = \alpha\delta\chi + \delta E_g$, where $\alpha$ is a user-specified parameter, and $\delta\chi$ and $\delta E_g$ are statistically independent ($\langle\delta\chi(\vec{r}_1)\delta E_g(\vec{r}_2)\rangle = 0$) fields with Gaussian correlations. Therefore, noise sources for conduction band and valence band variations are:

$$ K^{E_C}(\vec{r}_1, \vec{r}_1, \nu) = \frac{\Theta(0.5\text{Hz} - |\nu|)}{1\text{Hz}} a_\chi^2 \exp\left[ -\frac{(\vec{r}_1 - \vec{r}_2)^2}{\lambda^2} \right] $$ (783)

$$ K^{E_V}(\vec{r}_1, \vec{r}_1, \nu) = \frac{\Theta(0.5\text{Hz} - |\nu|)}{1\text{Hz}} [(1 + \alpha)^2 a_\chi^2 + a_{E_g}^2] \exp\left[ -\frac{(\vec{r}_1 - \vec{r}_2)^2}{\lambda^2} \right] $$ (784)

For $a_{E_g} = 0$, some interesting limiting cases exist:

* For $\alpha = 0$, the conduction band and valence band vary in the same direction with the same amplitude.

* For $\alpha = -1$, the valence band does not vary at all.

* For $\alpha = -2$, the conduction band and the valence band vary in opposite directions.

Band edge fluctuations are activated by the option `BandEdgeFluctuations` to `Noise`:

```
Physics { Noise(BandEdgeFluctuations <string>) }
```

**23: Noise, Fluctuations, and Sensitivity**
Noise Sources

Here, the string identifies a volume specification that determines where, in the device, band edge fluctuations are active. Named volumes are specified in the device global `Math` section by providing lists of regions and materials that belong to the volume:

```
Math {
  Volume <string> (
    Regions = (<string>...)
    Materials = (<string>...)
  )
}
```

The dimensionless parameter $\alpha$, the correlation length $\lambda$ ($\mu$m), and the amplitudes $a_\chi$ and $a_{E_g}$ are specified as `Chi2Eg`, `Lambda`, `Amplitude_Chi`, and `Amplitude_Eg` in a named global parameter set `BandEdgeFluctuations`:

```
BandEdgeFluctuations <string> {
  Amplitude_Chi = <float>        * in eV, default 0
  Amplitude_Eg = <float>         * in eV, default 0
  Chi2Eg = <float>               * dimensionless, default 0
  Lambda = <float>               * in µm, no default (required)
}
```

The string is the name with which the band edge fluctuations are activated as a `Noise` option in the device global `Physics` section.

# Random Metal Conductivity Fluctuations

Metal conductivity fluctuations are activated by the option `ConductivityFluctuations` to `Noise`:

```
Physics { Noise(ConductivityFluctuations <string>) }
```

Here, `<string>` identifies a named volume specification that determines where, in the device, metal conductivity fluctuations are active. For the specification of named volumes, see Random Band Edge Fluctuations on page 742.

Metal conductivity fluctuations are assumed to have Gaussian spatial correlations. You specify parameters for metal conductivity fluctuations in the named global `ConductivityFluctuations` parameter set in the parameter file:

```
ConductivityFluctuations <string> {
  Amplitude = <float>            * amplitude in A/cmV
  Lambda= <float>                * correlation length in um
}
```

743

Noise Sources

The string is the name with which the metal conductivity fluctuations are activated as a `Noise` option in the device global `Physics` section.

## Random Dielectric Constant Fluctuations

Random dielectric constant fluctuations are activated by the option `EpsilonFluctuations` to `Noise`:

```
Physics {
  Noise(EpsilonFluctuations <string>)
}
```

Here, `<string>` identifies a named volume specification that determines where, in the device, dielectric constant fluctuations are active. For the specification of named volumes, see Random Band Edge Fluctuations on page 742. Random dielectric constant fluctuations are assumed to have Gaussian spatial correlations.

Parameters for random dielectric constant fluctuations are specified in the named global `EpsilonFluctuations` parameter set in the parameter file:

```
EpsilonFluctuations <string> {
  Amplitude = <float>              * amplitude, dimensionless
  Lambda= <float>                  * correlation length in um
}
```

The string is the name with which the dielectric constant fluctuations are activated as a `Noise` option in the device global `Physics` section.

## Noise From SPICE Circuit Elements

To take into account the noise generated by SPICE circuit elements, specify the `CircuitNoise` option to `ACCoupled` (see Compact Models User Guide, Chapter 1 on page 1). The form of the noise source for a particular circuit element is defined by the respective compact model.

Due to a restriction of the SPICE noise models, SPICE circuit elements contribute only to the autocorrelation noise. For cross-correlation noise, Sentaurus Device considers SPICE circuit elements as noiseless. Non–SPICE compact circuit elements do not implement noise at all and, therefore, Sentaurus Device always treats them as noiseless.

23: Noise, Fluctuations, and Sensitivity
Statistical Impedance Field Method

# Statistical Impedance Field Method

The statistical impedance field method (sIFM) can be applied to doping concentration, trap concentration, semiconductor–insulator and insulator–insulator interface positions, and the workfunction at contacts on insulators and metal–insulator interfaces. It creates a large number of randomized variations of the quantities under investigation (dopant concentrations, trap concentrations, or workfunction) and computes the modification of the device characteristics in linear response.

The sIFM is specified in the global `Math` section:

```
Math {
  RandomizedVariation <string> (
    NumberOfSamples = <int>
    Randomize = <int>
    ExtrudeTo3D
    RandomField(...)
  )
  ...
}
```

Any number of `RandomizedVariation` specifications can be present, each of which specifies the sample size and the random seed for one set of variations. The sets are distinguished by the optional string after the `RandomizedVariation` keyword.

`NumberOfSamples` determines the number of variations in a set. `Randomize` determines the seed for the random number generator. For a value of zero (the default), the seed value is selected automatically and differently in each simulation run. A negative value disables the sIFM, and a positive value is directly taken as the seed for the random number generator. The last possibility allows to reproduce results for different simulation runs of the same device, on the same platform, and the same release of Sentaurus Device.

For 2D structures, the keyword `ExtrudeTo3D` instructs Sentaurus Device to perform randomization for a 3D structure that is obtained by extruding the 2D structure to a width given by the `AreaFactor`. This is necessary to correctly model variations with spatial correlations, but it will increase runtime for these variations. By default, randomization is performed in two dimensions, which corresponds to variations that are perfectly correlated in the third spatial direction. `ExtrudeTo3D` has no effect on 3D structures.

`RandomField` allows you to specify the statistical properties of the spatial correlations for this `RandomizedVariation` specification (see Spatial Correlations and Random Fields on page 747).

Statistical Impedance Field Method

The quantities to be randomized are specified in a device-global `Physics` section:

```
Device <string> {
    Physics {
        RandomizedVariation <string> (<specifications>)
    }
}
```

The string after `RandomizedVariation` in the `Physics` section is matched with the one after `RandomizedVariation` in the global `Math` section, and `<specifications>` is described along with the individual variations in the following sections.

For one `ACCoupled` statement, for each `RandomizedVariation` specification, the sIFM creates two files per `ObservationNode`: one for voltage and one for current variation at the node. The file names are derived from the base name given by `ACExtract`, the string after the `RandomizedVariation` keyword, the name of the type of variation (current or voltage), the node name, and the extension `.csv`. The file contains comma separated values (CSV), a very simple format that can be imported by many applications (for example, spreadsheet programs).

The first line contains the column headings, using double-quoted strings. Each subsequent line corresponds to one bias point and one frequency.

The first couple of columns contain the data specified in the `ACPlot` statement. They serve to connect each line to a bias point. The rest of the columns within each line correspond to the current or voltage shift for one particular randomized profile. For all lines, the same column always corresponds to the same profile. For frequencies larger than 0.5 Hz, the shifts are zero.

## Options Common to sIFM Variations

All variations supported by sIFM provide the keywords `SpatialShape`, `SpaceMid`, and `SpaceSig`. They allow you to multiply the variation by a space-dependent factor, and they work in the same way as for traps (see Energetic and Spatial Distribution of Traps on page 490). The shape functions must adequately be resolved by the mesh. The following example activates random doping variations, which are damped with a Gaussian function on a length scale of 10 nm around the origin:

```
Physics {
    RandomizedVariation "rnd" (
        Doping(
            SpatialShape = Gaussian
            SpaceMid = (0 0 0)
            SpaceSig = (0.01 0.01 0.01)
        )
    )
}
```

23: Noise, Fluctuations, and Sensitivity

Statistical Impedance Field Method

Using `SpatialShape=Uniform` instead of `SpatialShape=Gaussian` would switch off the doping variation completely for points outside a cube of 20 nm side length centered at the origin.

By default, `SpatialShape` is `Uniform`, and `SpaceSig` is a vector with very large components. Therefore, by default, the space-dependent factor is one everywhere. If the mesh has dimension $d$, only the $d$ first components of `SpaceMid` and `SpaceSig` are significant; additional components are ignored.

# Spatial Correlations and Random Fields

Several variations supported by sIFM are spatially correlated. You can specify the statistical properties of the correlation either directly in the specification of the variation or by declaring `RandomField` in the `RandomizedVariation` section in the global `Math` section. If the statistical properties are specified directly in the specification of the variation, the variation is statistically independent from all other variations. In contrast, if `RandomField` is declared, all variations in the same `RandomizedVariation` section are correlated, and direct specifications are ignored.

Random fields are declared like this:

```
Math {
   RandomizedVariation <string> (
      RandomField(
         CorrelationFunction = Grain | Exponential | Gaussian
         AverageGrainSize = <vector>     * in μm
         Lambda = <vector>               * in μm
         Resolution = <vector>
         MaxInternalPoints = <int>
      )
      ...
   )
}
```

The spatial domain covered by a random field is obtained automatically from the spatial domains in which the variations that use it are active. A random field can have more than one component.

The number of components in the random field is the largest number required by any of the variations that refer to the random field. Only band edge variations require two components; the other variations require only one component. The components are numbered starting from zero. Variations with only one component always use the zero-th component of the random field.

`CorrelationFunction` determines the way in which spatial correlations are modeled.

Statistical Impedance Field Method

If `CorrelationFunction=Grain` (default), first, grains are generated randomly. The creation of grains works as described in Metal Workfunction Randomization on page 253. If `AverageGrainSize` is the vector $(\lambda_x, \lambda_y, \lambda_z)$, the vertex at coordinate $(x, y, z)$ belongs to the grain with the center $(x_0, y_0, z_0)$ for which $(x - x_0)^2 / \lambda_x^2 + (y - y_0)^2 / \lambda_y^2 + (z - z_0)^2 / \lambda_z^2$ becomes smallest.

For each grain and for each component of the random field, a random number $g$ in the range from 0 to 1 is selected, with uniform probability and statistically independent from the random number for other grains or other components. For variations that use a list of discrete values for the variation, $g$ is mapped into this list according to the variation-specific probability for the values in the list. If $g$ is close to zero, the first value in the list will be taken. If $g$ is close to 1, the last value in the list will be taken. For variations with continuous values, $g$ will be mapped by a monotonically increasing function to the probability distribution for the variation.

If `CorrelationFunction` is `Exponential` or `Gaussian`, a Fourier approach is used to create fields $g(\vec{r})$ of exponentially correlated or Gaussian correlated, dimensionless random numbers. The fields for different components of the random field are uncorrelated.

The correlation length is given (in $\mu$m) by the components $(\lambda_x, \lambda_y, \lambda_z)$ of `Lambda`:

$$ \langle g(x, y, z) g(x_0, y_0, z_0) \rangle = \exp(-\sqrt{(x - x_0)^2 / \lambda_x^2 + (y - y_0)^2 / \lambda_y^2 + (z - z_0)^2 / \lambda_z^2}) $$ (785)

$$ \langle g(x, y, z) g(x_0, y_0, z_0) \rangle = \exp(-(x - x_0)^2 / \lambda_x^2 - (y - y_0)^2 / \lambda_y^2 - (z - z_0)^2 / \lambda_z^2) $$ (786)

The physical variation is obtained by multiplying $g(\vec{r})$ by a variation-specific amplitude.

For Gaussian and exponential correlations, `Resolution` (one to three dimensionless positive components; default `(0.25 0.25 0.25)`) can be used to specify how accurately spatial correlations should be resolved, for each spatial axis. The components specify this accuracy in units of `Lambda`. One possible application for `Resolution` is to use a large value for one axis to pretend that the domain is nearly flat along this direction, which reduces the dimension of the Fourier transform and can give a substantial speedup.

For Gaussian and exponential correlations, `MaxInternalPoints` specifies the maximum number of internal points used to compute the randomization. The default value is a very large integer. If the number of internal points used to compute the randomization exceeds the value set with `MaxInternalPoints`, Sentaurus Device terminates. The purpose of this is to avoid excessive computation time, which scales superlinearly with the number of internal points.

To reduce the number of internal points, restrict the randomized domain, or increase `Lambda` or `Resolution`.

You can specify `Lambda` and `AverageGrainSize` as vectors with less than three components. In this case, the missing components are assumed equal to the last given component.

**23: Noise, Fluctuations, and Sensitivity**
Statistical Impedance Field Method

All options that are available in the `RandomField` section are also available as options to the specification of all variations with spatial correlation, with the same meaning of keywords.

The specification of variations with spatial correlation supports a string, which allows you to put several such variations into the same `RandomizedVariation` section. Their contribution is added. For example:

```
Physics {
  RandomizedVariation "rv" (
    Geometric "g1" ( ... )
    Geometric "g2" ( ... )
  )
}
```

# Doping Variations

Doping variations are enabled using the `Doping` keyword:

```
Physics {
  RandomizedVariation <string> (
    Doping (
      Type = Doping | Acceptor | Donor
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
      -Mobility
      -BandgapNarrowing
    )
  )
}
```

For `RandomizedVariation` specifications in the `Math` section for which no `RandomizedVariation` specification of the same name is present in the `Physics` section, dopant variations are enabled automatically.

`Type` determines which dopants to randomize. For `Acceptor`, only acceptors are randomized. For `Donor`, only donors are randomized. For `Doping` (default), both are randomized.

For the options of `Doping`, see Options Common to sIFM Variations on page 746.

Acceptor and donor concentrations are randomized independently, assuming dopants are spatially uncorrelated and using a Poisson distribution function.

Statistical Impedance Field Method

This means that for a vertex $i$ of the mesh with a box volume $V_i$ and an average doping concentration $N_i$, the probability to find exactly $k$ dopants in the box for vertex $i$ is:

$$ P_i(k) = \frac{(N_i V_i)^k}{k!} \exp(-N_i V_i) \qquad (787) $$

The volume $V_i$ is a 3D volume. If the simulated structure is 2D, the `AreaFactor` is taken into account to compute $V_i$. Eq. 787 is consistent with the assumptions that are used to obtain Eq. 778, p. 737.

The sIFM accounts for the impact of dopant concentration on space charge, mobility, and bandgap narrowing. The options `-Mobility` and `-BandgapNarrowing` disable the impact due to mobility and bandgap narrowing, respectively.

**NOTE** It is strongly advisable to use either both the `-BandgapNarrowing` and `-Mobility` options or neither option. Otherwise, inconsistencies can arise when the mobility depends indirectly on bandgap narrowing. Even when this dependency is weak, the inconsistency can lead to large errors in IFM results.

When the keyword `RandomizedDoping` appears in a device-specific `Plot` section, all randomized acceptor and donor profiles are written to the `Plot` file. The individual profiles are identified by a number in their name. This number is the same one that appears in the first line of the `.csv` files.

**NOTE** If the number of random samples is large, plotting randomized doping profiles can occupy a large amount of memory.

## Trap Concentration Variations

For the sIFM, variations of the random trap concentration are activated with the keyword `TrapConcentration`:

```
Physics {
  RandomizedVariation <string> (
    TrapConcentration (
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
    )
  )
}
```

**23: Noise, Fluctuations, and Sensitivity**

Statistical Impedance Field Method

All trap levels are randomized independently, assuming traps are spatially uncorrelated. The same expression as for doping concentration, Eq. 787, p. 750, is used. For the options of `TrapConcentration`, see Options Common to sIFM Variations on page 746.

The sIFM accounts for the impact of the trap concentration on the space charge in the Poisson equation and on the trap-related generation–recombination rates in the continuity equations.

# Workfunction Variations

For the sIFM, workfunction variations are activated and controlled using the `Workfunction` keyword:

```
Physics {
  RandomizedVariation <string> (
    Workfunction <string> (
      Surface = <string>
      CorrelationFunction = Grain | Exponential | Gaussian
      AverageGrainSize = <vector>
      Lambda = <vector>
      Resolution = <vector>
      MaxInternalPoints = <int>
      GrainProbability = (<float>...)
      GrainWorkfunction = (<float>...)  * in eV
      Amplitude = <float>               * in eV
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
    )
  )
}
```

`Surface` specifies the name of a surface that consists of contacts on insulators and metal–insulator interfaces only. The specification of surfaces is described in Random Geometric Fluctuations on page 738. The workfunction is randomized for interfaces and contacts that are part of the given `Surface`.

`GrainWorkfunction` is a list of workfunction values (in eV) that can occur for a metal grain. `GrainProbability` is a list that gives the probabilities with which these workfunctions occur. These two parameters are used for `Grain` correlations. `Amplitude` (in eV) is a multiplier to the dimensionless field $g(\vec{r})$ that is used for Gaussian and exponential correlations. For details, see Spatial Correlations and Random Fields on page 747.

As the sIFM models the effect of deviations, the values of `GrainWorkfunction` are adjusted to have an average that agrees with the nominal workfunction specified for the electrode or metal. Therefore, adding the same value to all `GrainWorkfunction` values will not affect the results.

**23: Noise, Fluctuations, and Sensitivity**

Statistical Impedance Field Method

For the other options of `Workfunction`, see Options Common to sIFM Variations on page 746 and Spatial Correlations and Random Fields on page 747.

The sIFM accounts for the impact of the workfunction on the boundary condition for the electrostatic potential at metal–insulator interfaces and at contacts on insulators.

---

# Geometric Variations

For the sIFM, geometric variations are activated and controlled using the `Geometric` keyword:

```
Physics {
  RandomizedVariation <string> (
    Geometric <string> (
      Surface = <string>
      CorrelationFunction = Grain | Exponential | Gaussian
      AverageGrainSize = <vector>
      Lambda = <vector>
      Resolution = <vector>
      MaxInternalPoints = <int>
      Amplitude = <vector>        * in micrometer
      Amplitude_Iso = <float>     * in micrometer
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
      Options = <0..1>
      WeightQuantumPotential = <float>
      WeightDielectric = <float>
    )
  )
}
```

`Surface` specifies the name of a surface that consists of electrodes on insulator, metal–insulator, semiconductor–insulator, and insulator–insulator interfaces only. The specification of surfaces is described in Random Geometric Fluctuations on page 738. The interface position is randomized for interfaces that are part of the given `Surface`.

For `Grain` correlations, for each grain, a random number $g$ is selected from a Gaussian distribution of average zero and variance one. For each surface point that is contained in the grain, the interface shift along the normal direction $\hat{n}$ is given by $g\hat{n} \cdot (a_{\text{iso}} + \vec{a} \cdot \hat{n})$. Here, $a_{\text{iso}}$ and $\vec{a}$ are the values specified (in $\mu\text{m}$) by `Amplitude_Iso` and `Amplitude`. For Gaussian and exponential variation, the field $g(\vec{r})$ of dimensionless correlated random numbers determines the interface shift along the normal direction $\hat{n}$ in a point $\vec{r}$ on the surface as $g(\vec{r})\hat{n} \cdot (a_{\text{iso}} + \vec{a} \cdot \hat{n})$. As above, $a_{\text{iso}}$ and $\vec{a}$ are the values specified by `Amplitude_Iso` and `Amplitude`. For more details, see Spatial Correlations and Random Fields on page 747.

752

**23: Noise, Fluctuations, and Sensitivity**
Statistical Impedance Field Method

The keywords `Options`, `WeightQuantumPotential`, and `WeightDielectric` work as explained in Random Geometric Fluctuations on page 738.

For the other options of `Geometric`, see Options Common to sIFM Variations on page 746 and Spatial Correlations and Random Fields on page 747.

# Band Edge Variations

For the sIFM, band edge variations are activated and controlled using the `BandEdge` keyword:

```
Physics {
  RandomizedVariation <string> (
    BandEdge <string> (
      Volume = <string>               * required
      CorrelationFunction = Grain | Exponential | Gaussian
      AverageGrainSize = <vector>
      Lambda = <vector>
      Resolution = <vector>
      MaxInternalPoints = <int>
      ChiComponent = <0..1>           * default 0, RandomField component to use
      EgComponent = <0..1>            * default 1, RandomField component to use
      GrainProbability = (<float>...) * dimensionless, nonnegative
      GrainChi = (<float>...)         * eV, same size as GrainProbability
      GrainEg = (<float>...)          * eV, default 0, same size as or smaller
                                      * than GrainProbability
      Chi2Eg = <float>                * dimensionless, default 0
      Amplitude_Chi = <float>         * eV
      Amplitude_Eg = <float>          * eV
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
    )
  )
}
```

`Volume` specifies a named volume that determines where band edge variations are active. For the specification of named volumes, see Random Band Edge Fluctuations on page 742.

For `Grain` correlations, `GrainProbability` is a list that gives the probabilities with which these shifts occur. `GrainChi` is a list of affinity shifts $\delta\chi$ (in eV) with the same number of values as `GrainProbability`. Bandgap variations are computed as $\delta E_{g,tot} = \alpha\delta\chi + \delta E_g$, where $\alpha$ is given by the `Chi2Eg` keyword, and $\delta E_g$ are values selected (statistically independently from the $\delta\chi$, but using the same `GrainProbability` list) from the list `GrainEg` (in eV). `GrainEg` has, at most, as many values as `GrainProbability`. Missing values is `GrainEg` are assumed to be zero.

Statistical Impedance Field Method

The values in `GrainChi` and `GrainEg` automatically adjust to have zero average. Therefore, adding a constant to all components of these lists has no effect.

For exponential and Gaussian correlations, $\delta\chi$ and $\delta E_g$ are obtained by multiplying `Amplitude_Chi` and `Amplitude_Eg` (in eV) by the zero-th and first component of the dimensionless field $g(\vec{r})$ that is used for Gaussian and exponential correlations.

For all correlations, if `RandomField` is used, `ChiComponent` and `EgComponent` allow you to specify the component of the random field used to determine $\delta\chi$ and $\delta E_g$.

For details about correlations, see Spatial Correlations and Random Fields on page 747. For the other remaining options, see Options Common to sIFM Variations on page 746.

# Metal Conductivity Variations

For the sIFM, metal conductivity variations are activated and controlled using the `Conductivity` keyword:

```
Physics {
  RandomizedVariation <string> (
    Conductivity<string> (
      Volume = <string>                   * required
      CorrelationFunction = Grain | Exponential | Gaussian
      AverageGrainSize = <vector>
      Lambda = <vector>
      Resolution = <vector>
      MaxInternalPoints = <int>
      GrainProbability = (<float>...)     * dimensionless, nonnegative
      GrainConductivity = (<float>...)    * A/cmV, size as GrainProbability
      Amplitude = <float>                 * A/cmV
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
    )
  )
}
```

Volume specifies a named volume that determines where metal conductivity variations are active. For the specification of named volumes, see Random Band Edge Fluctuations on page 742.

For `Grain` correlations, `GrainProbability` is a list that gives the probabilities with which these shifts occur. `GrainConductivity` is a list of a conductivity shifts (in A/cmV) with the same number of values as `GrainProbability`. The values in `GrainConductivity` are adjusted to have zero average. Therefore, adding a constant to all components of this list has no effect.

**23: Noise, Fluctuations, and Sensitivity**
Statistical Impedance Field Method

Amplitude (in A/cmV ) is a multiplier to the dimensionless field $g(\vec{r})$ that is used for Gaussian and exponential correlations.

For details about correlations, see Spatial Correlations and Random Fields on page 747. For the other remaining options, see Options Common to sIFM Variations on page 746.

---

# Dielectric Constant Variations

For the sIFM, relative dielectric constant variations are activated and controlled using the `Epsilon` keyword:

```
Physics {
  RandomizedVariation <string> (
    Epsilon <string> (
      Volume = <string>                  * required
      CorrelationFunction = Grain | Exponential | Gaussian
      AverageGrainSize = <vector>
      Lambda = <vector>
      Resolution = <vector>
      MaxInternalPoints = <int>
      GrainProbability = (<float>...)    * dimensionless, nonnegative
      GrainEpsilon = (<float>...) * dimensionless, size as GrainProbability
      Amplitude = <float>                * dimensionless
      SpatialShape = Uniform | Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
    )
  )
}
```

`Volume` specifies a named volume that determines where relative dielectric constant variations are active. For the specification of named volumes, see Random Band Edge Fluctuations on page 742.

For `Grain` correlations, `GrainProbability` is a list that gives the probabilities with which these shifts occur. `GrainEpsilon` is a list of a relative dielectric constant shifts with the same number of values as `GrainProbability`. The values in `GrainEpsilon` are adjusted to have zero average. Therefore, adding a constant to all components of this list has no effect.

Amplitude (dimensionless) is a multiplier to the dimensionless field $g(\vec{r})$ that is used for Gaussian and exponential correlations.

For details about correlations, see Spatial Correlations and Random Fields on page 747. For the other remaining options, see Options Common to sIFM Variations on page 746.

23: Noise, Fluctuations, and Sensitivity

Statistical Impedance Field Method

---

# Doping Profile Variations

Doping profile variations are activated and controlled using the `DopingVariation` keyword:

```
Physics {
    RandomizedVariation <string> (
        DopingVariation <string> (
            CorrelationFunction = Grain | Exponential | Gaussian
            AverageGrainSize = <vector>
            Lambda = <vector>
            Resolution = <vector>
            MaxInternalPoints = <int>
            SFactor = <string>
            Amplitude = <vector>    * µm
            Amplitude_Iso = <float> * µm
            Conc = <float>          * 1/ccm
            Type = Doping | Acceptor | Donor
            SpatialShape = Uniform | Gaussian
            SpaceMid = <vector>
            SpaceSig = <vector>
            -Mobility
            -BandgapNarrowing
        )
    )
}
```

The options `SFactor`, `Conc`, `Type`, `Amplitude`, and `Amplitude_Iso` are used to describe a doping profile shift based on the gradient of a dataset, as described in Deterministic Doping Variations on page 757. In addition to what is described there, for sIFM, the shift is multiplied by a spatially correlated, dimensionless, random field.

For grain correlations, the random number in each grain is Gaussian distributed, with zero average and variance of one. For exponential and Gaussian correlations, the dimensionless random field is the one obtained from the Fourier approach.

By default, the impact of doping concentration on space charge, mobility, and bandgap narrowing is accounted for. The options `-Mobility` and `-BandgapNarrowing` disable the impact due to mobility and bandgap narrowing, respectively.

**NOTE** It is strongly advisable to use either both the `-BandgapNarrowing` and `-Mobility` options or neither option. Otherwise, inconsistencies can arise when the mobility depends indirectly on bandgap narrowing. Even when this dependency is weak, the inconsistency can lead to large errors in IFM results.

756

23: Noise, Fluctuations, and Sensitivity
Deterministic Variations

For the other options of `DopingVariation`, see Options Common to sIFM Variations on page 746 and Spatial Correlations and Random Fields on page 747.

# Deterministic Variations

For deterministic variations, you specify the variations directly, by specifying the actual deviation in doping, geometry, or model parameters. Sentaurus Device computes the effect of the variations on the observation node voltages and currents in a linear response. As for random fluctuations, deterministic variations are assumed to be different from zero only for analysis frequencies up to 0.5 Hz.

Compared to random fluctuations, deterministic variations give you more control over the variation and are easier to understand, because no statistical interpretation is required and no second-order moments appear. In the case of geometric variations, the computational effort is smaller as well.

## Deterministic Doping Variations

Deterministic doping variations are specified as an option to `DeterministicVariation` in the `Physics` section:

```
Physics {
  DeterministicVariation(
    DopingVariation <name> (
      SFactor = <string>
      Amplitude = <vector>
      Amplitude_Iso = <float>
      Amplitude_Abs = <float>
      Conc = <float>
      Factor = <float>
      Type = Doping | Acceptor | Donor
      SpatialShape = Gaussian | Uniform
      SpaceMid = <vector>
      SpaceSig = <vector>
      -Mobility
      -BandgapNarrowing
    ) ...
  ) ...
}
```

Here, `<name>` is a string that names the variation and will be used to identify output to the `ACExtract` file. If it coincides with the name of a geometric or a parameter variation, the contributions of the variations are added.

757

Deterministic Variations

`SFactor` specifies a scalar dataset. Allowed datasets are doping concentrations and `PMIUserFields`. If you do not specify any dataset, a constant density of 1 cm<sup>–3</sup> is assumed.

By specifying `Conc`, the concentration is normalized and then multiplied by the concentration specified with `Conc`. `Conc` is given in cm<sup>–3</sup>. If `Conc` is not specified or is zero, the values from the dataset will be used unaltered.

If the `SFactor` dataset is a `PMIUserField` dataset or another dataset that is not a density, Sentaurus Device cannot properly determine the units of the dataset and, therefore, it interprets its value with a different scaling constant to the one you intended. Specifying `Conc` can be useful in this case, as the normalization of the `SFactor` eliminates the ambiguous units.

By default, the resulting concentration $X$ determines the fluctuation $\delta N$ directly, $\delta N = X$. If you use `Amplitude_Iso`, `Amplitude`, or `Amplitude_Abs` to specify nonzero isotropic or vectorial amplitudes $a_{iso}$, $\vec{a}$, and $\vec{a}_{abs}$, the fluctuation is computed from $X$ as $\delta N = -\vec{a} \cdot \nabla X - a_{iso} |\nabla X| - \vec{a}_{abs} \cdot \text{abs}(\nabla X)$, where $\text{abs}(\nabla X)$ is the vector obtained by taking the absolute value of $\nabla X$ component-wise. The vectorial amplitude models the small displacement of a profile, and the isotropic amplitude models a shift of a doping front (perpendicular to the equi-doping lines). For this to work properly, the mesh must accurately resolve the variations of $X$. Both amplitudes are specified in $\mu\text{m}$.

Optionally, a dimensionless value `Factor` can be specified, which is multiplied by the resulting $\delta N$. The factor defaults to one. Its purpose is to easily specify variations that are a certain percentage of a given doping data field.

Using the keywords `SpatialShape`, `SpaceMid`, and `SpaceSig`, you can multiply $\delta N$ by either a Gaussian function or a window function. These keywords work in the same way as for traps (see Energetic and Spatial Distribution of Traps on page 490). The shape functions must adequately be resolved by the mesh.

`Type` selects whether the variation applies to the acceptor concentration ($\delta N_A = \delta N$), the donor concentration ($\delta N_D = \delta N$), or doping as a whole. In the latter case, a negative variation increases the acceptor concentration; a positive variation increases donor concentration.

By default, the impact of doping concentration on space charge, mobility, and bandgap narrowing is accounted for. The options `-Mobility` and `-BandgapNarrowing` disable the impact due to mobility and bandgap narrowing, respectively.

**NOTE** It is strongly advisable to use either both the `-BandgapNarrowing` and `-Mobility` options or neither option. Otherwise, inconsistencies can arise when the mobility depends indirectly on bandgap narrowing. Even when this dependency is weak, the inconsistency can lead to large errors in IFM results.

For a summary of options to `DopingVariation`, see Table 287 on page 1591.

**23: Noise, Fluctuations, and Sensitivity**
Deterministic Variations

# Deterministic Geometric Variations

Deterministic geometric variations are specified as an option to `DeterministicVariation` in the `Physics` section:

```
Physics {
  DeterministicVariation(
    GeometricVariation <name> (
      Surface = <string>
      Amplitude = <vector>
      Amplitude_Iso = <float>
      SpatialShape = Gaussian
      SpaceMid = <vector>
      SpaceSig = <vector>
      Options = <0..1>
      WeightQuantumPotential = <float>
      WeightDielectric = <float>
    ) ...
  ) ...
}
```

Here, `<name>` is a string that names the variation and will be used to identify output to the ACExtract file. If it coincides with the name of a doping or a parameter variation, the contributions of the variations are added.

`Surface` identifies the displaced interfaces. Its specification is described in Random Geometric Fluctuations on page 738. The amount of displacement along the positive normal in a point $r$ on the surface is determined by `Amplitude_Iso` ($a_{iso}$) and `Amplitude` ($a$), both specified in $\mu$m, as $\delta s(\vec{r}) = a_{iso}(\vec{r}) + \vec{a}(\vec{r}) \cdot \hat{n}(\vec{r})$.

Using the keywords `SpatialShape`, `SpaceMid`, and `SpaceSig`, you can multiply $\delta s$ by a Gaussian function.

These keywords work in the same way as for traps (see Energetic and Spatial Distribution of Traps on page 490). The Gaussian must be resolved adequately by the mesh.

The keywords `Options`, `WeightQuantumPotential`, and `WeightDielectric` work as explained in Random Geometric Fluctuations on page 738.

For a summary of options of `GeometricVariation`, see Table 301 on page 1598.

759

**23: Noise, Fluctuations, and Sensitivity**

Deterministic Variations

# Parameter Variations

Sentaurus Device allows to compute the linear response to the variation of any parameter that can be ramped. The parameter variations are specified as an option to `DeterministicVariation` in the `Physics` section:

```
Physics {
  DeterministicVariation (
    ParameterVariation <name> (
      (
        Material = <string>
        Region = <string>
        MaterialInterface = <string>
        RegionInterface = <string>
        Model = <string>
        Parameter = <string>
        Value     = <float>
        Factor    = <float>
        Summand   = <float>
      )...
    )...
  )...
}
```

Here, `<name>` is a string that names the variation and is used to identify output to the `ACExtract` file. If it coincides with the name of a doping or a geometry variation, the contributions of the variations are added.

The option of `ParameterVariation` is a list of an arbitrary number of individual parameter specifications, each of which is enclosed by a pair of parentheses. All these variations are performed together to compute their cumulative impact.

`Material`, `Region`, `MaterialInterface`, or `RegionInterface` specify the location of the parameter that is varied. At most, one of these keywords must be specified. `Model` specifies the name of the model to which the varied parameter belongs, and `Parameter` is the name of the parameter within this model. All these keywords specify a parameter in the same way as for parameter ramping (see Ramping Physical Parameter Values on page 79).

To specify the correct location for a parameter can be complicated. Combining Parameter Specifications on page 30 explains how the specifications in the parameter file determine the location from which the parameters used in the computation are taken.

Each varied parameter has an original value $\gamma$ (the default value, or the value that was set in the parameter file).

23: Noise, Fluctuations, and Sensitivity

IFM Section

The modified value $\gamma'$ can be given by one of two ways:

*   Directly by specification of the modified value using `Value=` $\gamma'$

*   By using the keywords `Factor` and `Summand`: $\gamma' = \text{Factor} \cdot \gamma + \text{Summand}$

Sentaurus Device assembles the right-hand side twice: once with the original parameters, and once with the modified parameters. Then, the difference in the right-hand sides is used to compute the variation of output characteristics in the linear response. However, as the right-hand sides are not linear in the parameters, the method is not perfectly linear, which becomes visible if the parameter variation $\gamma' - \gamma$ is not small. On the other hand, if the parameter variation becomes too small, numeric noise can obscure the results.

# IFM Section

Instead of defining the noise and variation models in the `Math` and `Physics` sections, you can also define all these models in the `IFM` section as follows:

```
IFM {
  Noise (
    ...
  )
  RandomizedVariation (
    ...
  )
  DeterministicVariation (
    ...
  )
  ...
}
```

Parameters of the `Noise` model can be defined in the `IFM` section as well:

```
IFM {
  Noise (
    MonopolarGRNoise (
      e_alpha = 1...
    )...
  )...
}
```

Table 136 on page 762 lists all the `Noise` model parameters.

Impedance Field Method

Table 136 Noise model parameters

| Model | Symbol | Default value | Unit |
| --- | --- | --- | --- |
| MonopolarGRNoise | e_alpha | 1 | 1 |
| h_alpha | 1 | 1 |  |
| e_tau | 1e-7 | s |  |
| h_tau | 1e-7 | s |  |
| FlickerGRNoise | e_alpha_H | 2e-3 | 1 |
| h_alpha_H | 2e-3 | 1 |  |
| e_tau0 | 1e-6 | s |  |
| h_tau0 | 1e-6 | s |  |
| e_tau1 | 3e-4 | s |  |
| h_tau1 | 3e-4 | s |  |
| GeometricFluctuations | lambda | 0 | μm |
| Amplitude_Iso | -3e303 | μm |  |
| Amplitude | (-3e303, -3e303, -3e303) | μm |  |
| WorkfunctionFluctuations | lambda | 0 | μm |
| Amplitude | -1 | eV |  |
| BandEdgeFluctuations | lambda | 0 | μm |
| Amplitude_chi | 0 | eV |  |
| Amplitude_Eg | 0 | eV |  |
| Chi2Eg | 0 | 1 |  |
| ConductivityFluctuations | lambda | 0 | μm |
| Amplitude | -1 | A cm-1V-1 |  |
| EpsilonFluctuations | lambda | 0 | μm |
| Amplitude | -1 | 1 |  |

# Impedance Field Method

The impedance field method splits noise and fluctuation analysis into two tasks. The first task is to provide models for local microscopic fluctuations inside the devices. The selection of the appropriate models depends on the problem. You have to select the models according to the kind of fluctuation that interests you. The second task is to determine the impact of the local

[](https://www.synopsys.com/glossary/what-is-sentaurus.html)

23: Noise, Fluctuations, and Sensitivity
Impedance Field Method

fluctuations on the terminal characteristics. To solve this task, the response of the contact voltage or contact current to local fluctuation is assumed to be linear. For each contact, Green’s functions are computed that describe this linear relationship. In contrast to the first task, the second task is purely numeric, as the Green’s functions are completely specified by the transport model.

A Green’s function describes the response $G_{\xi}^{c}(x, \omega)$ of the current or voltage at node $c$ due to a perturbation of quantity $\xi$ at location $x$ with angular frequency $\omega$. Particularly important is the case where $\xi$ is the right-hand side of the partial differential equation for a solution variable $\phi$ (see Eq. 37, p. 179), $n$ or $p$ (see Eq. 57, p. 189), $T_{n}$ (see Eq. 76, p. 204), $T_{p}$ (see Eq. 77, p. 204), or $T$.

Given the Green’s function and a variation $\delta\xi$ of the quantity $\xi$, Sentaurus Device can compute the current response at node $c$ as:

$$ \delta I_{c} = \int G_{\xi}^{c}(x, \omega) \delta\xi(x, \omega) dx $$ (788)

Here, the integral runs over the entire device. For the sIFM (see Statistical Impedance Field Method on page 745), $\delta\xi$ is obtained by the randomization procedure specific to the type of variation and, for deterministic variations (see Deterministic Variations on page 757), $\delta\xi$ is given by users.

For noise (and noise-like descriptions of static variations; see Noise Sources on page 734), it is assumed that the expectation value $\langle\delta\xi\rangle$ of $\delta\xi$ vanishes, and the second-order statistic moment, the so-called noise source, is considered:

$$ K(x, x', \omega) = \langle\delta\xi(x, \omega) \cdot \delta\xi^{*}(x', \omega)\rangle $$ (789)

From the noise source, the noise current spectral densities (or in the static case, the variances and covariances) are obtained as:

$$ S_{I}^{c_{1}, c_{2}} = \iint G_{\xi}^{c_{1}}(x, \omega) K(x, x', \omega) G_{\xi}^{c_{2}*}(x', \omega) dxdx' $$ (790)

Similar relations are used for the noise voltage spectral densities $S_{V}$.

Some of the noise sources are local, $K(x, x', \omega) = \delta(x - x')K(x, \omega)$, which allows you to reduce the number of integrations in Eq. 790 to one. $K(x, \omega)$ is called the *local noise source* (LNS), and the integrand of Eq. 790 in this case is called the *local noise current spectral density* (LNISD), and the corresponding integrand for $S_{V}$ is called the *local noise voltage spectral density* (LNVSD).

23: Noise, Fluctuations, and Sensitivity
Noise Output Data

# Noise Output Data

Several variables can be plotted during noise analysis. For each device, a `NoisePlot` section can be specified similar to the `Plot` section, where the data to be plotted is listed. Besides the standard data, additional noise-specific data or groups of data can be specified, as listed in Table 137. In the tables, the abbreviations LNS (local noise source) and LNVSD (local noise voltage spectral density) are used.

Autocorrelation data refers to Eq. 790 when $c_1 = c_2$. Data selected in the `NoisePlot` section is plotted for each device and observation node at a given frequency into a separate file. File names with the following format are used:

`<noise-plot>_<device-name>_<ob-node>_<number>_acgf_des.tdr`

where `<noise-plot>` is the prefix specified by the `NoisePlot` option to `ACCoupled`.

**NOTE** Only the noise data specified in a `Noise` section without a name, or with an empty string as a name, will be plotted.

In the case of $c_1 \neq c_2$ in Eq. 790, node cross-correlation spectra are computed and integrands become complex. Data specified in the `NoisePlot` section is plotted for each device and each pair of observation nodes at a given frequency into a separate file.

The file names have the format:

`<noise-plot>_<device-name>_<ob-node-1>_<ob-node-2>_<number>_acgf_des.tdr`

Table 137 Device noise data

| Keyword | Description |
| --- | --- |
| eeDiffusionLNS | Electron diffusion LNS |
| hhDiffusionLNS | Hole diffusion LNS |
| eeMonopolarGRLNS | Trace of electron monopolar GR LNS |
| hhMonopolarGRLNS | Trace of hole monopolar GR LNS |
| eeFlickerGRLNS | Trace of electron flicker GR LNS |
| hhFlickerGRLNS | Trace of hole flicker GR LNS |
| ReLNVXVSD ImLNVXVSD | Real/imaginary parts of LNVSD |
| ReLNISD ImLNISD | Real/imaginary parts of local noise current spectral density |

764

23: Noise, Fluctuations, and Sensitivity
Noise Output Data

Table 137 Device noise data (Continued)

| Keyword | Description |
| --- | --- |
| ReeeLNVXVSD ImeeLNVXVSD | Real/imaginary parts of LNVSD for electrons |
| RehhLNVXVSD ImhhLNVXVSD | Real/imaginary parts of LNVSD for holes |
| ReeeDiffusionLNVXVSD ImeeDiffusionLNVXVSD | Real/imaginary parts of diffusion LNVSD for electrons |
| RehhDiffusionLNVXVSD ImhhDiffusionLNVXVSD | Real/imaginary parts of diffusion LNVSD for holes |
| ReeeMonopolarGRLNVXVSD ImeeMonopolarGRLNVXVSD | Real/imaginary parts of electron monopolar LNVSD |
| RehhMonopolarGRLNVXVSD ImhhMonopolarGRLNVXVSD | Real/imaginary parts of hole monopolar LNVSD |
| ReeeFlickerGRLNVXVSD ImeeFlickerGRLNVXVSD | Real/imaginary parts of electron flicker GR LNVSD |
| RehhFlickerGRLNVXVSD ImhhFlickerGRLNVXVSD | Real/imaginary parts of hole flicker GR LNVSD |
| ReTrapLNISD ImTrapLNISD | Real/imaginary parts of local trapping noise current spectral density |
| ReTrapLNVSD ImTrapLNVSD | Real/imaginary parts of local trapping noise voltage spectral density |
| PoECReACGreenFunction PoECImACGreenFunction CurECReACGreenFunction CurECImACGreenFunction | Real/imaginary parts of $G_n$ |
| PoHCReACGreenFunction PoHCImACGreenFunction CurHCReACGreenFunction CurHCImACGreenFunction | Real/imaginary parts of $G_p$ |
| PoETReACGreenFunction PoETImACGreenFunction CurETReACGreenFunction CurETImACGreenFunction | Real/imaginary parts of $G_{T_n}$ |
| PoHTReACGreenFunction PoHTImACGreenFunction CurHTReACGreenFunction CurHTImACGreenFunction | Real/imaginary parts of $G_{T_p}$ |

References

Table 137 Device noise data (Continued)

| Keyword | Description |
| --- | --- |
| PoLTReACGreenFunction PoLTImACGreenFunction CurLTReACGreenFunction CurLTImACGreenFunction | Real/imaginary parts of $G_T$ |
| PoPotReACGreenFunction PoPotImACGreenFunction CurPotReACGreenFunction CurPotImACGreenFunction | Real/imaginary parts of $G_\phi$ |
| PoGeoGreenFunction CurGeoGreenFunction | Real part of the Green’s functions for geometric variations |
| GradPoECReACGreenFunction GradPoECImACGreenFunction GradPoHCReACGreenFunction GradPoHCImACGreenFunction GradPoETReACGreenFunction GradPoETImACGreenFunction GradPoHTReACGreenFunction GradPoHTImACGreenFunction | Real/imaginary parts of $\nabla \cdot G_n$, $\nabla \cdot G_p$, $\nabla \cdot G_{T_n}$, $\nabla \cdot G_{T_p}$ for voltage noise |
| Grad2PoECACGreenFunction Grad2PoHCACGreenFunction | $\|G_n\|^2$ and $\|G_p\|^2$ for voltage noise |
| AllLNS | All used LNS |
| AllLNVXVSD | All used LNVSD |
| GreenFunctions | Green’s functions and their gradients |

# References

[1] F. Bonani *et al.*, “An Efficient Approach to Noise Analysis Through Multidimensional Physics-Based Models,” *IEEE Transactions on Electron Devices*, vol. 45, no. 1, pp. 261–269, 1998.

[2] J.-P. Nougier, “Fluctuations and Noise of Hot Carriers in Semiconductor Materials and Devices,” *IEEE Transactions on Electron Devices*, vol. 41, no. 11, pp. 2034–2049, 1994.

[3] F. Bonani and G. Ghione, “Generation–recombination noise modelling in semiconductor devices through population or approximate equivalent current density fluctuations,” *Solid-State Electronics*, vol. 43, no 2, pp. 285–295, 1999.

