# CHAPTER 21 Optical Generation

*This chapter describes various methods that are used to compute the optical generation rate when an optical wave penetrates into the device, is absorbed, and produces electron–hole pairs.*

The methods include simple optical beam absorption, the raytracing method, the transfer matrix method, the finite-difference time-domain, the beam propagation method, and loading external profiles from file. Different types of refractive index and absorption models, parameter ramping, and optical AC analysis are also described.

## Overview of Optical Generation

A unified interface for optical generation computation is available to provide a consistent simulation setup irrespective of the underlying optical solver methods. This allows for a gradual refinement of results and a balance of accuracy versus computation time in the course of a simulation, while only the solver-specific parameters have to change. Several approaches for computing the optical generation exist that are independent of the chosen optical solver:

*   Compute the optical generation resulting from a monochromatic optical source.

*   Compute the optical generation resulting from an illumination spectrum.

*   Set a constant value for the optical generation rate either per region or globally.

*   Read an optical generation profile from file.

*   Compute the optical generation as a sum of the above contributions, possibly with different optical solvers or different solver-specific settings or excitation parameters.

For each of the contributions listed, a separate scaling factor can be specified. For transient simulations, it is possible to apply a time-dependent scaling factor that can be used, for example, to model the response to a light pulse or any other time-dependent light signal. This feature can also be used to improve convergence if the optical generation rate is very high. The unified interface also allows you to save the computed optical generation rate to a file for reuse in other simulations.

The optical generation resulting from a monochromatic optical source or an illumination spectrum is determined as the product of the absorbed photon density, which is computed by the optical solver, and the quantum yield. Several models for the quantum yield are available ranging from a constant scaling factor to a spatially varying quantum yield based on the band gap of the underlying material and the excitation wavelength of the optical source.

Specifying the Type of Optical Generation Computation

In the following sections, the different approaches for computing the optical generation and their corresponding parameters are described.

---

# Specifying the Type of Optical Generation Computation

In the `OpticalGeneration` section of the command file, at least one of the following methods to compute the optical generation must be specified; otherwise, the optical generation is not computed and is set to zero everywhere:

* `ComputeFromMonochromaticSource` activates optical generation computation with a single wavelength that is either specified in the `Excitation` section or as a ramping variable.

* `ComputeFromSpectrum` allows the sum of optical generation to be computed from an input spectrum of wavelengths.

* `ReadFromFile` imports the optical generation profile.

* `SetConstant` allows you to set a background constant optical generation in the specified region or material.

> **NOTE** If you use the keyword `Scaling` in these optical generation methods, then the scaling applies only to quasistationary simulations. To scale transient simulations, see Specifying Time Dependency for Transient Simulations on page 606.

If several methods are specified, then the total optical generation rate is given by the sum of the contributions computed with each method. The general syntax is:

```
Physics {
  ...
  Optics (
    OpticalGeneration (
      ...
      ComputeFromMonochromaticSource (...)
      ComputeFromSpectrum (...)
      ReadFromFile (...)
      SetConstant ( ... Value = <float> )
    )
    Excitation (...)
    OpticalSolver (...)
    ComplexRefractiveIndex (...)
  )
}
```

Each method can have its own options such as a scaling factor or a particular time-dependency specification used in transient simulations. An example setup where the optical generation read

21: Optical Generation

Specifying the Type of Optical Generation Computation

from a file is scaled by a factor of 1.1 and a Gaussian time dependency is assumed for the monochromatic source is:

```
OpticalGeneration (
  ...
  ComputeFromMonochromaticSource (
      ...
      TimeDependence (
        WaveTime = (<t1>, <t2>)
        WaveTSigma = <float>
      )
  )
  ReadFromFile (
      ...
      Scaling = 1.1
  )
)
```

Both Scaling and TimeDependence can also be specified directly in the OpticalGeneration section if the same parameters will apply to all methods. If TimeDependence is specified directly in the OpticalGeneration section as well as in a source-specific section such as ComputeFromMonochromaticSource, then the latter takes precedence. For an overview of all available options, see Table 247 on page 1567.

By default, the optical generation rate is calculated for every semiconductor region. However, you can suppress the computation of the optical generation rate for a specific region or material by specifying the keyword -OpticalGeneration in the corresponding region or material Physics section:

```
Physics ( region="coating" ) { Optics ( -OpticalGeneration ) }

Physics ( material="InP" ) { Optics ( -OpticalGeneration ) }
```

To visualize the optical intensity and generation, the keywords OpticalIntensity and OpticalGeneration must be added to the Plot section:

```
Plot {
  ...
  OpticalIntensity
  OpticalGeneration
}
```

Specifying OpticalGeneration in the Plot section plots not only the total optical generation that enters the electrical equations, but also the contributions from the different methods of optical generation computation. See Appendix F on page 1479 for the corresponding data names.

21: Optical Generation

Specifying the Type of Optical Generation Computation

# Optical Generation From Monochromatic Source

Specifying `ComputeFromMonochromaticSource(...)` in the `OpticalGeneration` section activates the computation of the optical generation assuming a monochromatic light source. Details of the light source such as angle of incidence, wavelength, and intensity, and the optical solver used to model it must be set in the `Excitation` section and `OpticalSolver` section, respectively (see Specifying the Optical Solver on page 614 and Setting the Excitation Parameters on page 620).

Together with the possibility of ramping parameters (see Controlling Computation of Optical Problem in Solve Section on page 634), for example, the wavelength of the incident light, this model can be used to simulate the optical generation rate as a function of wavelength.

# Illumination Spectrum

The optical generation resulting from a spectral illumination source, which is sometimes also known as *white light generation*, can be modeled in Sentaurus Device by superimposing the spectrally resolved generation rates. To this end, `ComputeFromSpectrum(...)` must be listed in the `OpticalGeneration` section. The illumination spectrum is then read from a text file whose name must be specified in the `File` section:

```
File {
  ...
  IlluminationSpectrum = "illumination_spectrum.txt"
}
Physics {
  ...
  Optics (
    ...
    OpticalGeneration (
      ...
      ComputeFromSpectrum ( ... )
    )
  )
}
```

In its simplest form, the illumination spectrum file has a two-column format. The first column contains the wavelength in μm and the second column contains the intensity in W/cm<sup>2</sup>. The characters # and * mark the beginning of a comment.

As a default, the integrated generation rate resulting from the illumination spectrum is only computed once, that is, the first time the optical problem is solved and remains constant thereafter.

**21: Optical Generation**

Specifying the Type of Optical Generation Computation

However, you can force its recomputation on every occasion by specifying the keyword `RefreshEveryTime` in the `ComputeFromSpectrum` section.

When the optical problem remains constant, that is, the absorbed photon density does not change, but the quantum yield is expected to vary (see Quantum Yield Models on page 603), specify the keyword `KeepSpectralData` in the `ComputeFromSpectrum` section. With this keyword, the spectral information of the last optical solution is kept in memory and only the quantum yield, which is needed to compute the optical generation rate and the optical absorption heat (see Optical Absorption Heat on page 605), is updated during the simulation.

Plotting spectral results requires the specification of a file name in the `File` section using the keyword `SpectralPlot` as well as the specification of the keyword `KeepSpectralData` in the `ComputeFromSpectrum` section. A file with extension `.tdr` is used to save spatial fields such as optical generation for each entry of the spectrum. Other results from the optical solver, for example, reflection, transmission, and absorption in the case of the TMM solver, as a function of the spectrum parameters are saved in a file with the extension `.plt`. The quantities saved in the `.plt` file are subject to the optical solver used in the simulation. To control the file name and when to plot, the same syntax in the `Solve` section applies to `SpectralPlot` as well as to `Plot`. See When to Plot on page 129 and Appendix G on page 1507.

In simulations that contain only a monochromatic source, the results from the optical solver are written to the current file. However, if a spectral source is present, the values should reflect the result of both the monochromatic source and the spectral source. Therefore, relative quantities (that is, unitless quantities) such as reflection are represented by a weighted average over all entries of the illumination spectrum and the monochromatic source if present. The weight is given by the corresponding number of incident photons. On the other hand, absolute quantities are represented by a simple sum over all spectral entries and the monochromatic source if present.

> **NOTE** The default for saving spectral plots is to write consecutive plots into one file. However, to write consecutive plots into several enumerated files, specify `SpectralPlot(-collected)=<string>`.

## Multidimensional Illumination Spectra

Often, illumination spectra depend on additional parameters, which might be related to an experimental setup that users want to model. For example, the intensity of the incident light might depend on not only the wavelength but also the angle of incidence. To account for such simulation setups, Sentaurus Device supports multidimensional illumination spectra. The format of a corresponding illumination spectrum file is:

```
# some comment
* another comment # and so on
Optics/Excitation/Wavelength [um] theta [deg] phi [deg] intensity [W*cm^-2]
0.62 0 30 0.1
```

Specifying the Type of Optical Generation Computation

```
0.86 0 30 0.2
1.1 0 30 0.3
```

The header contains optional comment lines and a line defining the parameters assigned to each column. A parameter name or path is followed by its corresponding unit; if no unit is specified, the default unit of 1 is assumed. Listed parameters can refer either directly to existing parameters of the `Optics` section in Sentaurus Device or to user-defined parameters. The latter comes into play when using illumination spectra in combination with loading absorbed photon density or optical generation profiles from file. See Loading Solution of Optical Problem From Files on page 695 for details.

> **NOTE** The parameter `Intensity` is mandatory in every illumination spectrum file. However, the order of columns is arbitrary. Parameter names are case insensitive.

For multidimensional illumination spectrum files, the active columns must be selected in the command file. All other columns are ignored in the simulation. The required syntax in the `OpticalGeneration` section is:

```
ComputeFromSpectrum (
  ...
  Select (
    Parameter = ("Optics/Excitation/Wavelength" "Theta")
  )
)
```

The parameter `Intensity` is selected by default and does not need to be specified.

## Enhanced Spectrum Control

Being able to filter a given spectrum, based on a user-supplied condition, adds functionality to the computation of the optical generation resulting from a spectral illumination source. Specifying a static condition can be used to select a limited spectral range of interest or a subset of a multidimensional spectrum. The latter improves the handling of several spectra (for example, different standard spectra at various resolutions, and measured spectra) since they can be compiled in a single file and still be addressed separately.

A condition is called *dynamic* if it changes during the simulation. For example, a dynamic condition can include the excitation wavelength, which is ramped in a `Quasistationary` statement. Dynamic conditions can be used to ramp through different spectra or to superimpose a fixed spectrum with a varying spectrum.

21: Optical Generation

# Specifying the Type of Optical Generation Computation

To specify a condition, a Tcl-compatible expression enclosed in double quotation marks must be provided in the `Select` section:

```
ComputeFromSpectrum (
  ...
  Select (
    Parameter = ("Wavelength" "Theta")
    Condition = "$wavelength > 0.3 && $wavelength < 1.2"
  )
)
```

Identifiers preceded by a dollar sign ($) such as `wavelength` in the above example are considered to be variables referring to the respective column in the illumination spectrum file. Sentaurus Device extracts a subset of the spectrum by applying the condition expression to each row of the spectrum defined in the file. Before the expression is passed to the global Tcl interpreter of Sentaurus Device for evaluation, variables are substituted with their corresponding row-specific values. If the expression evaluates to true, the row is considered to be an active entry of the spectrum used in the `ComputeFromSpectrum` computation; otherwise, it is ignored.

**NOTE** By default, duplicate entries of the spectrum are ignored. However, specifying the keyword `AllowDuplicates` in the `Select` section will retain such entries.

Identifiers such as Sentaurus Device parameter names and variable names referring to the respective column in the illumination spectrum file are treated as case insensitive in the `Parameter` list and the `Condition` statement of the `Select` section.

Assuming a spectrum file containing different spectra distinguished by their names of the form:

```
wavelength [um] intensity [W*cm^-2] spectrum [1]
0.2 0.0012 "AM1.5g"
0.3 0.0034 "AM1.5g"
...
0.2 0.0056 "AM0"
...
```

a single spectrum can be selected by specifying the following in the `ComputeFromSpectrum` section:

```
Select (
  Parameter = ("Wavelength" "Spectrum")
  Condition = "$Spectrum == \"AM1.5g\" "
)
```

**NOTE** Double quotation marks in the Tcl expression must be escaped to avoid conflicts with the parser of the Sentaurus Device command file.

Specifying the Type of Optical Generation Computation

For a condition to change during the simulation, it must reference an internal variable of Sentaurus Device that is ramped in a Quasistationary statement. Sentaurus Device interprets identifiers without a preceding $ in the condition expression as internal parameters. If necessary due to ambiguity, internal parameters also can be specified using their full path such as Optics/Excitation/Wavelength. Specifying an identifier that cannot be matched with an internal parameter results in an error.

To select a subspectrum based on a dynamic condition, assume the following spectrum file:

```
wavelength [um] intensity [W*cm^-2] centralWavelength [nm]
0.2 0.0012 300
0.3 0.0034 300
...
0.3 0.0056 400
0.4 0.0068 400
...
```

The following command file syntax shows how to ramp through the various spectra identified by their central wavelength:

```
Physics {
  Optics (
    OpticalGeneration (
      ComputeFromSpectrum (
        Select (
          Parameter = ("Wavelength" "centralWavelength")
          Condition = "abs( Wavelength - $centralWavelength*1e-3 ) < 1e-6"
        )
      )
    )
  )
}

Solve {
  Quasistationary (
    Goal { modelParameter = "Wavelength" value = 1.2 }
  ) { Coupled {Poisson Electron Hole} }
}
```

**NOTE** In the condition expression, users are responsible for rescaling the spectrum variables, if necessary, when comparing them to internal parameters having a fixed unit. Despite the fact that the units of the spectrum variables are known to Sentaurus Device, it is unclear whether they are related to internal parameters as the names of spectrum variables are arbitrary.

When comparing floating-point numbers for equality in a condition expression, it is recommended that you check that the absolute value of

21: Optical Generation

Specifying the Type of Optical Generation Computation

their difference is smaller than a user-specified epsilon as shown in the examples. This avoids any unexpected precision issues resulting from numeric operations or reading floating-point numbers from file.

For more flexibility, the `Select` section contains an auxiliary keyword `Var`, which holds a floating-point value. It has no impact on the optical generation computation as such, but it can be ramped in a `Quasistationary` statement like any other internal parameter that supports ramping. Therefore, the keyword `Var` allows you to create dynamic conditions without affecting the results of any other optical generation contributions defined in the `OpticalGeneration` section such as `ComputeFromMonochromaticSource`. This is demonstrated by the following syntax, which is based on the above example where Sentaurus Device ramps through various spectra, but it contains a fixed monochromatic source:

```
Physics {
  Optics (
    Excitation (
      Wavelength = 0.6
    )
    OpticalSolver ( ... )
    OpticalGeneration (
      ComputeFromMonochromaticSource ( ... )
      ComputeFromSpectrum (
        Select (
          Parameter = ("Wavelength" "centralWavelength")
          Condition = "abs( Var - $centralWavelength*1e-3 ) < 1e-6"
        )
      )
    )
  )
}

Solve {
  Quasistationary (
    Goal { modelParameter = "Var" value = 1.2 }
  ) { Coupled {Poisson Electron Hole} }
}
```

The keyword `Var` can be plotted by specifying `ModelParameter="Physics/Optics/OpticalGeneration/ComputeFromSpectrum/Select/Var"` in the `CurrentPlot` section of the command file.

# Loading and Saving Optical Generation From and to Files

Sometimes, solving the optical problem might require long computation times, in which case, it can be useful to save the solution to a file and to load the optical generation or absorbed photon density profile in later simulations whose optical properties remain constant. In the

Specifying the Type of Optical Generation Computation

In the following example, optical generation is used as a synonym for absorbed photon density. The command file syntax for saving the optical generation rate to a file is:

```
File {
  OpticalGenerationOutput = <filename>
}
```

For loading the optical generation rate from a file, the syntax is:

```
File {
  OpticalGenerationInput = <filename>
}

Physics {
  Optics (
    OpticalGeneration (
      ReadFromFile (
        DatasetName = AbsorbedPhotonDensity | OpticalGeneration
      )
    )
  )
}
```

If the input file to be loaded contains both an optical generation and an absorbed photon density profile, the keyword `DatasetName` controls which one to use. By default, the absorbed photon density is used. The optical generation profile to be loaded also can be defined on a mixed-element grid that is different from the one used in the device simulation, or on a tensor grid resulting from an EMW simulation. In that case, the profile is interpolated automatically onto the simulation grid upon loading. For more details on how to control the interpolation, including the truncation and shifting of the interpolation domain, see Controlling Interpolation When Loading Optical Generation Profiles on page 714.

Further options of the `ReadFromFile` section can be found in Table 247 on page 1567. Similar but more powerful functionality is provided by the feature `FromFile` (see Loading Solution of Optical Problem From Files on page 695).

# Constant Optical Generation

Assigning a constant optical generation rate to a certain region or material is achieved by specifying a value for a particular region or material as shown here:

```
Physics (Region = <name of region>) {
  ...
  Optics (
    OpticalGeneration (
      SetConstant (
```

21: Optical Generation

Specifying the Type of Optical Generation Computation

```
              Value = <float>
           )
       )
      )
     }

     Physics (Material = <name of material>) {
      ...
      Optics (
       OpticalGeneration (
           SetConstant (
              Value = <float>
           )
       )
      )
     }
```

If all semiconductor regions are supposed to have the same optical generation rate, its value is best specified in the global `Physics` section as follows:

```
     Physics {
      ...
      Optics (
       OpticalGeneration (
           SetConstant (
              Value = <float>
           )
       )
      )
     }
```

**NOTE** The constant optical generation model is functionally equivalent to the constant carrier generation model presented in Constant Carrier Generation Model on page 440.

# Quantum Yield Models

The quantum yield model describes how many of the absorbed photons are converted to generated electron–hole pairs. The simplest model, `QuantumYield(Unity)`, assumes that all absorbed photons result in generated charge carriers irrespective of the band gap or other properties of the underlying material. This corresponds to a global quantum yield factor of one, which is the default value, except for nonsemiconductor regions where it is always set to zero even if photons are actually absorbed.

A more realistic model, `QuantumYield(Stepfunction(...))`, takes the band gap into account. If the excitation energy is greater than or equal to the bandgap energy $E_g$, the quantum

Specifying the Type of Optical Generation Computation

yield is set to one; otherwise, it is set to zero. The bandgap energy used can be set directly by specifying a value for `Energy` in eV or, alternatively, a corresponding `Wavelength` in micrometers. Another option is `Bandgap`, which uses the temperature-dependent bandgap energy as given in Bandgap and Electron-Affinity Models on page 260. To include bandgap narrowing effects in the form of Eq. 158, p. 261, the keyword `EffectiveBandgap` must be specified.

In the presence of free carrier absorption (FCA), which is activated in Sentaurus Device by specifying `CarrierDep(Imag)` in the `ComplexRefractiveIndex` section of the command file, the spatially varying quantum yield factor is reduced according to the ratio of free carrier absorption, $\alpha_{FCA}$, to total absorption, $\alpha_{tot}$:

$$ \eta_G = \eta_{G_\Theta} \left( 1 - \frac{\alpha_{FCA}}{\alpha_{tot}} \right) \text{ (674)} $$

where $\alpha_{FCA}$ and $\alpha_{tot}$ are determined by the `ComplexRefractiveIndex` specification in the parameter file, given the following relation between the absorption coefficient and the extinction coefficient:

$$ \alpha = \frac{4\pi k}{\lambda} \text{ (675)} $$

The change of the extinction coefficient due to free carrier absorption is represented by $\Delta k_{carr}$ (see Carrier Dependency on page 641). The prefactor $\eta_{G_\Theta}$ can be set to 1 by specifying the keyword `EffectiveAbsorption` in the `QuantumYield` section, or it can represent a step function: If the photon energy is sufficiently large to allow for interband optical absorption, it is 1, or otherwise 0. The latter requires the specification of a `Stepfunction` section, which takes precedence over `EffectiveAbsorption` if both are specified. The command file syntax for specifying quantum yield models is:

```
Physics {
  Optics (
    OpticalGeneration (
      ...
      QuantumYield = <float>
      QuantumYield ( Unity )
      QuantumYield (
        EffectiveAbsorption
        StepFunction ( Wavelength = <float> #[um]
                       # OR
                       Energy = <float>     #[eV]
        )
        StepFunction ( Bandgap | EffectiveBandgap )
      )
    )
  )
}
```

21: Optical Generation

Specifying the Type of Optical Generation Computation

For more sophisticated quantum yield models, Sentaurus Device offers a PMI interface (see Optical Quantum Yield on page 1329). All quantum yield models also can be specified in a region or material `Physics` section. The resulting quantum yield can be plotted by specifying `QuantumYield` in the `Plot` section.

**NOTE** By default, the optical absorption due to `ComputeFromSpectrum` is computed only once; any further changes in the quantum yield are neglected. To account for varying quantum yield, it is necessary to recompute the corresponding optical absorption by using `RefreshEveryTime` in the `ComputeFromSpectrum` section. However, this will impact simulator performance depending on the size of the spectrum and the chosen optical solver.

## Optical Absorption Heat

The absorbed photon energy E<sub>ph</sub> is distributed among different processes by quantum yield factors. The following two channels are accounted for:

*   Thermalization to the band gap (interband absorption): When a photon is absorbed across the band gap in a semiconductor, it is absorbed to create an electron–hole pair. The excess energy (photon energy minus the band gap) of the new electron–hole pair is assumed to thermalize, resulting eventually in lattice heating.

*   Complete thermalization (intraband absorption): In the case of the photon energy being smaller than the band gap, the photon can be absorbed to increase the energy of a carrier. The excess energy relaxes eventually, contributing to lattice heating.

In both processes, it is assumed that the eventual lattice heating occurs in the locality of photon absorption. The corresponding energy equation reads as:

$$ E_{ph} = \eta_{T_{Eg}} (E_{ph} - E_g) + \eta_G E_g + \eta_{T_0} E_{ph} $$ (676)

where the energy contributions of the first term and the third term are dissipated into the lattice through thermalization. The energy of the second term is consumed for the generation of an electron–hole pair.

In general, $\eta_{T_{Eg}} = \eta_G$ since it is assumed that every photon generates a charge carrier, while the residual energy E<sub>ph</sub> – E<sub>g</sub> is dissipated into the lattice. Therefore, ignoring free carrier absorption, if the chosen quantum yield model evaluates to 1, $\eta_{T_{Eg}} = \eta_G = 1$ and $\eta_{T_0} = 0$. If the quantum yield model evaluates to 0, $\eta_{T_{Eg}} = \eta_G = 0$ and $\eta_{T_0} = 1$.

Distinguishing between $\eta_{T_{Eg}}$ and $\eta_G$ allows for the control of multiple-generation processes as well. For example, in the UV spectrum, it is possible that E<sub>ph</sub> > 2E<sub>g</sub>, and so more than one charge carrier can be generated per absorbed photon. To model multiple-generation processes, the `OpticalQuantumYield` PMI (see Optical Quantum Yield on page 1329) must be used where all quantum yield factors can be specified independently for each vertex.

Specifying the Type of Optical Generation Computation

Supporting several optical absorption processes affects the value of $\eta_G$ as can be seen from Eq. 676. It no longer depends on the local effective bandgap energy only. Factoring in free carrier absorption means that photons absorbed through this process do not contribute to the optical generation rate, which is used in the drift-diffusion equations. In general, the quantum yield factors are independent as long as the energy equation is fulfilled locally.

The quantum yield factor $\eta_G$ is given by Eq. 674, and the quantum yield factor attributed to complete thermalization is computed as:

$$ \eta_{T_0} = 1 - \eta_G \text{ (677)} $$

The quantum yield factor $\eta_{T_{Eg}}$ is set to $\eta_G$ unless it is specified explicitly using the `OpticalQuantumYield` PMI.

> **NOTE** If $\eta_G$ is set to a constant value in the command file, $\eta_{T_0}$ is still given by Eq. 677 to ensure energy balance.

Specifying `OpticalAbsorptionHeat` and `ThermalizationYield` in the `Plot` section of the command file results in the following quantities being written to the plot file for each vertex:

*   `OpticalAbsorptionHeat`: $(\eta_{T_{Eg}}(E_{ph} - E_g) + \eta_{T_0}E_{ph})N_{ph}$

*   `OpticalAbsorptionHeat_Bandgap`: $\eta_{T_{Eg}}(E_{ph} - E_g)N_{ph}$

*   `OpticalAbsorptionHeat_Vacuum`: $\eta_{T_0}E_{ph}N_{ph}$

*   `ThermalizationYield_Bandgap`: $\eta_{T_{Eg}}$

*   `ThermalizationYield_Vacuum`: $\eta_{T_0}$

Here, $N_{ph}$ represents the number of absorbed photons.

> **NOTE** `OpticalAbsorptionHeat` is not calculated for optical absorption that is loaded using `ReadFromFile` or for constant optical generation specified by `SetConstant` because the corresponding wavelength of the light source is unknown.

# Specifying Time Dependency for Transient Simulations

To model the electrical response of a light pulse, incident on a device, a description of the light signal over time can be specified either globally or separately for each type of optical generation computation. For the former, `TimeDependence(...)` is listed directly in the `OpticalGeneration` section, while for the latter, it is given as an argument of the chosen type of optical generation computation.

If you specify `TimeDependence` both globally and for a specific type of optical generation computation such as `ComputeFromMonochromaticSource`, the latter takes precedence.

21: Optical Generation

Specifying the Type of Optical Generation Computation

`TimeDependence` can only be specified in the global `Physics` section and not for a particular region or material.

The given time dependency essentially scales the optical generation rate, resulting from a stationary solution of the optical problem as a function of time. The time dependency is only taken into account inside a `Transient` statement and the corresponding scaling factor for the different types of optical generation computation is automatically written to the `Current` file under the name `TimeDependence(Ft)`. If the optical generation needs to be scaled inside a `Quasistationary`, the keyword `Scaling` in the `OpticalGeneration` section can be used. However, this scaling factor does not apply inside a `Transient` statement. Instead, `Scaling` can be set directly in the respective `TimeDependence` section.

Different types of time dependency are available:

* Linear time dependency

* Gaussian time dependency

* Exponential time dependency

* Cosine time dependency

* Arbitrary time dependency read from a file

> **NOTE** If no time dependency has been specified, a scaling factor of 1 is used inside a `Transient` statement irrespective of any other scaling factors set in the `OpticalGeneration` section.

In addition, each of the above time dependencies can be extended to a periodic signal of the respective type. For the analytic time dependencies, you can specify a time interval `WaveTime= (<t1>, <t2>)`. Before `<t1>`, the optical generation rate undergoes an increase from zero characterized by the type of analytic time dependency. After `<t2>`, the optical generation rate experiences a corresponding decrease.

By default, Sentaurus Device adds turning points (see Time-Stepping on page 92) to the `Transient` statement at several characteristic time points of the light pulse to help convergence and to ensure it is resolved even if the time step of the `Transient` statement is larger than the entire pulse width. For details about optical turning points, see Optical Turning Points on page 612.

The linear time function as shown in Figure 23 on page 608 is expressed as:

$$ F(t) = \begin{cases} \max(0, m(t - t_1) + 1) & , t < t_1 \\ 1 & , t_1 \le t \le t_2 \\ \max(0, m(t_2 - t) + 1) & , t > t_2 \end{cases} \tag{678} $$

Specifying the Type of Optical Generation Computation

where *m* is given by `WaveTSlope`. Alternatively, `WaveTLin` can be specified, which is the inverse of *m*, that is, it corresponds to the rise time $t_{lin} = t_1 - t_0$ in seconds.

| Time [s] | Scaling [1] |
| --- | --- |
| 0 | 0 |
| t0 | 0 |
| t1 | 1 |
| t2 | 1 |
| t3 | 0 |
| 10 | 0 |

Figure 23 Rise and decay times based on a linear function

The Gaussian time function as shown in Figure 24 is expressed as:

$$
F(t) = \begin{cases} \exp\left(-\left(\frac{t-t_1}{\sigma}\right)^2\right) & , t < t_1 \\ 1 & , t_1 \le t \le t_2 \\ \exp\left(-\left(\frac{t-t_2}{\sigma}\right)^2\right) & , t > t_2 \end{cases} \tag{679)
$$

where $\sigma$ is defined by `WaveTSigma`.

| Time [s] | Scaling [1] |
| --- | --- |
| 0 | 0 |
| t0 | 0.1 |
| t1 | 1 |
| t2 | 1 |
| t3 | 0.1 |
| 10 | 0 |

Figure 24 Rise and decay times based on a Gaussian function

21: Optical Generation

Specifying the Type of Optical Generation Computation

The exponential time function as shown in Figure 25 is expressed as:

$$
F(t) = \begin{cases} \exp\left(\frac{t-t_1}{t_{\exp}}\right) & , t < t_1 \\ 1 & , t_1 \leq t \leq t_2 \\ \exp\left(\frac{t_2-t}{t_{\exp}}\right) & , t > t_2 \end{cases} \tag{680}
$$

where $t_{\exp}$ is defined by `WaveTExp`.

| Time [s] | Scaling [1] |
| --- | --- |
| 0.5 (t0) | 0.1 |
| 1.0 | 0.2 |
| 1.5 (t1) | 1.0 |
| 2.0 (t2) | 1.0 |
| 2.5 | 0.2 |
| 3.0 (t3) | 0.1 |
| 3.5 | 0.05 |

Figure 25 Rise and decay times based on an exponential function

The cosine time function as shown in Figure 26 on page 610 is expressed as:

$$
F(t) = \begin{cases} 0 & t \leq t_1 - t_{\cos} \lor t \geq t_2 + t_{\cos} \\ \frac{1}{2} \cdot \left(1 + \cos\left(\pi \frac{t-t_1}{t_{\cos}}\right)\right) & t_1 - t_{\cos} < t < t_1 \\ 1 & t_1 \leq t \leq t_2 \\ \frac{1}{2} \cdot \left(1 + \cos\left(\pi \frac{t-t_2}{t_{\cos}}\right)\right) & t_2 < t < t_2 + t_{\cos} \end{cases} \tag{681}
$$

where $t_{\cos}$ is defined by `WaveTCos`.

Specifying the Type of Optical Generation Computation

| Time [s] | Scaling [1] |
| --- | --- |
| 0.5 (t₀) | 0.0 |
| 1.0 | 0.5 |
| 1.5 (t₁) | 1.0 |
| 2.0 (t₂) | 1.0 |
| 2.5 | 0.5 |
| 3.0 (t₃) | 0.0 |

Figure 26 Rise and decay times based on a cosine function

If no time interval is specified, $t_1 = t_2 = 0$ is assumed. The analytic time dependencies are selected by specifying a value for the corresponding parameters as shown in Table 115.

Table 115 Selection of analytic time dependency

| Time dependency | Required keyword |
| --- | --- |
| Linear | WaveTSlope or WaveTLin |
| Gaussian | WaveTSigma |
| Exponential | WaveTExp |
| Cosine | WaveTCos |

An arbitrary time dependency can be applied by defining a time function whose interpolation points are given in a file with a white space–separated, two-column format. The first column contains the time points in seconds and the second column contains the corresponding function values. Linear interpolation is used to obtain function values between the interpolation points.

This type of time dependency can be activated using the following syntax:

```
File {
  OptGenTransientScaling= <filename>  # file containing interpolation points
}

Physics {
  Optics (
    OpticalGeneration (
      TimeDependence ( FromFile )
    )
  )
}
```

21: Optical Generation

Specifying the Type of Optical Generation Computation

```
    )
}
```

To transform any of the above time dependencies into a periodic signal, its period in seconds must be specified using the keyword `WaveTPeriod`. The specified signal is repeated infinitely, unless the number of periods is set explicitly with the keyword `WavePeriods`.

For linear and Gaussian time dependency, an additional temporal offset can be defined to essentially control the relative location of the signal within the period as illustrated in Figure 27.

| Time Label | Transient Scaling Factor |
| --- | --- |
| t0 | baseline |
| t1 | peak start |
| t2 | peak end |
| t3 | baseline |
| t'0 | baseline (start of 2nd period) |
| t'1 | peak start (2nd period) |
| t'2 | peak end (2nd period) |
| t'3 | baseline (2nd period) |

Figure 27 Extension of a predefined time dependency to a periodic signal where T<sub>period</sub>, N<sub>period</sub>, and t<sub>offset</sub> correspond to `WaveTPeriod`, `WavePeriods`, and `WaveTPeriodOffset`

The syntax for the linear periodic signal shown in Figure 27 is:

```
Physics {
  Optics (
    OpticalGeneration (
      TimeDependence (
        WaveTime = (t1, t2)
        WaveTSlope = m
        WaveTPeriod = Tperiod
        WavePeriods = Nperiod
        WaveTPeriodOffset = toffset
      )
    )
  )
}
```

21: Optical Generation
Specifying the Type of Optical Generation Computation

## Optical Turning Points

Typically, you specify turning points as described in Time-Stepping on page 92 in the `Transient` statement to limit the advancing time step. Controlling time-stepping based on knowledge about the device physics and its characteristics can improve the convergence behavior. Light pulses in transient simulations have a strong impact on device characteristics and, therefore, corresponding optical turning points are added by default. The default optical turning points also guarantee that a light pulse is resolved to a certain degree, independent of the advancing time step before the start time of the pulse. You can switch off the default optical turning points or change their parameters in the command file.

In contrast to general turning points described in Time-Stepping on page 92, optical turning points are specified in the `OpticalTurningPoints` section within the `TimeDependence` section with the definition of the light pulse.

The predefined optical turning points correspond to the time points $t_0$, $t_1$, $t_2$, and $t_3$ shown in Figure 23 on page 608 to Figure 27 on page 611, for which the advancing time step can be limited using the keywords `DtRiseStart`, `DtRiseEnd`, `DtFallStart`, and `DtFallEnd`, respectively. In addition, the time step can be limited for the ranges $[t_0 t_1]$, $[t_1 t_2]$, and $[t_2 t_3]$ that are associated with the keywords `DtRise`, `DtPlateau`, and `DtFall`. You can limit the maximum time step in these ranges separately using the aforementioned keywords or set the same maximum time step for all three time ranges using the keyword `Dt`. If both `Dt` and a range-specific keyword such as `DtPlateau` are specified, then the value of the range-specific keyword is used.

> **NOTE** Limiting the maximum time step within a range, using `DtRise`, `DtPlateau`, or `DtFall`, has an effect only if the time-stepping is such that the calculated time step used to advance from the last time point $t_i$ before a range is not larger than $t_3 - t_i$. In other words, limiting the time step becomes active only if the regular time-stepping enters the predefined range. See Time-Stepping on page 92 for details about the behavior of turning points.

Specifying a time step equal to 0 switches off the corresponding optical turning point or range.

> **NOTE** The points $t_0 - t_3$ are enabled by default; whereas, the ranges must be enabled explicitly by specifying a limiting time step greater than 0. To switch off all optical turning points and ranges, specify `-OpticalTurningPoints` in the respective `TimeDependence` section.

For analytic light signals with asymptotically decaying tails such as a Gaussian, the time points $t_0$ and $t_3$ are not naturally defined. By default, they are chosen to be the time points where the signal amplitude is equal to 0.01.

 **21: Optical Generation**
Solving the Optical Problem

However, by setting `MinAmplitude` in the `OpticalTurningPoints` section to a different value, you can shift the time points $t_0$ and $t_3$ in either direction.

For time-dependence `FromFile`, only the time points $t_0$ and $t_3$ and a single range $[t_0, t_3]$ are supported, which are active by default. The limiting time step for the range can be set with the keyword `Dt`. The time points $t_0$ and $t_3$ are associated with the first and last time points given in the `OptGenTransientScaling` file specified in the `File` section.

The following example demonstrates the syntax for optical turning points (an overview of the various parameters and corresponding default values is given in Table 248 on page 1569):

```
Physics {
  Optics (
    OpticalGeneration (
      TimeDependence (
        WaveTime = (t₁, t₂)
        WaveTSigma = σ
        OpticalTurningPoints (
          DtRiseStart = 1e-4        # [s]
          DtFallEnd = 0             # switch off turning point t₃
          MinAmplitude = 0.005
          DtPlateau = 1e-3          # [s]
          DtFall = 2e-4             # [s]
        )
      )
    )
  )
}
```

# Solving the Optical Problem

`ComputeFromMonochromaticSource` and `ComputeFromSpectrum` require the solution of the optical problem for a given excitation to obtain the optical generation rate. Several optical solvers are available and the choice for a specific method is determined usually by the optimum combination of accuracy of results and computation time.

Besides selecting a certain optical solver and specifying its particular parameters, it is necessary to define the excitation parameters, to choose an appropriate refractive index model, and to control when a solution is computed in the `Solve` section. These steps are explained in the following sections.

Solving the Optical Problem

## Specifying the Optical Solver

The following optical solvers are supported:

* Transfer matrix method (TMM)

* Finite-difference time-domain (FDTD)

* Raytracing (RT)

* Beam propagation method (BPM)

* Loading solution of optical problem from file

* Optical beam absorption method

* Composite method

> **NOTE** By default, the log of the optical solver is written to standard output and the simulation log file as part of the general simulation log. However, depending on the specific setup, the optical solver log can be verbose and affect the overall readability of the simulation log. To avoid this behavior, you can either:
>

> * Set `Verbosity=0` in the `Optics` section to completely suppress any logging activity of the optical solver except for warning and error messages.
>

> * Redirect the log of the optical solver to a separate log file by specifying the keyword `OpticsOutput` in the global `File` section.

## Transfer Matrix Method

The TMM solver is selected using the following syntax:

```
Physics {
  ...
  Optics (
    ...
    OpticalSolver (
      TMM ( <TMM options> )
    )
  )
}
```

The TMM-specific options, such as the parameters for the extraction of the layer stack, are described in Using Transfer Matrix Method on page 685.

21: Optical Generation
Solving the Optical Problem

# Finite-Difference Time-Domain Method

In contrast to the TMM solver, the FDTD-specific parameters, such as boundary conditions and extractors, are defined in a separate command file that is set in the `File` section with the keyword `OpticalSolverInput`. To provide some basic control of the FDTD solver from within Sentaurus Device, excitation parameters such as `Wavelength`, `Theta`, and `Phi`, as well as the polarization `Psi`, are overwritten by their counterparts in the `Excitation` section of the Sentaurus Device command file if specified.

**NOTE** The `Psi` keyword in EMW corresponds to the `PolarizationAngle` keyword in Sentaurus Device.

The FDTD solver in Sentaurus Device supports both the 2D and 3D excitation specification of EMW as outlined in Sentaurus™ Device Electromagnetic Wave Solver User Guide, Specifying Direction and Polarization on page 50.

The syntax for activating the FDTD solver requires as input the name of the command file of the FDTD solver. The general syntax is:

```
File {
  OpticalSolverInput= <EMW_command_file>
}

Physics {
  Optics (
    OpticalSolver (
      FDTD ( ... )
    )
  )
}
```

The FDTD algorithm is based on a tensor mesh, which can be generated independently before the device simulation. Another option is to build the tensor mesh during the simulation before the call to EMW. The main advantage of the latter option is that the tensor grid can be adjusted to a possibly changing excitation wavelength in a `Quasistationary` statement. Since the accuracy and stability of the FDTD method crucially depend on the discretization with respect to the wavelength, this feature becomes important when a large range of the light spectrum is scanned (see Illumination Spectrum on page 596 and Parameter Ramping on page 635).

To activate this feature, `GenerateMesh(...)` must be specified in the `FDTD` section and a common base name (that is, file name excluding suffix) for the boundary file and the Sentaurus Mesh command file must be defined in the `File` section using the keyword `MesherInput`. Sentaurus Mesh is then called with the specified base name prepended by the basename of the `Plot` file given in the `File` section of the Sentaurus Device command file.

Solving the Optical Problem

The resulting tensor grid file is detected automatically and replaces the grid file in the user-provided EMW command file.

By default, a tensor mesh is generated before the first call to EMW and remains in use during further calls to the solver. However, if the excitation wavelength varies and the initially built tensor mesh no longer fulfills the requirements, two options exist that control the update of the mesh.

Using the keyword `ForEachWavelength` in the `GenerateMesh` section triggers the computation of a new tensor mesh whenever the wavelength changes compared to the previous solution of the FDTD solver. Internally, the wavelength specified in the user-provided Sentaurus Mesh command file is replaced with the current value.

Since the slope of the complex refractive index as a function of wavelength can vary from almost zero to high values, depending on the wavelength interval, it is possible to limit the mesh generation according to a list of strictly monotonically increasing wavelengths. If the current wavelength enters a new interval, the mesh is updated and remains in use until the wavelength moves beyond the interval boundaries. The syntax for such a use case is:

```
FDTD (
  ...
  GenerateMesh (
    Wavelength = ( 0.35 0.55 0.7 0.8 ) # wavelength in [μm]
  )
)
```

For the command file syntax and options of the FDTD solver, refer to the *Sentaurus™ Device Electromagnetic Wave Solver User Guide*.

## Raytracing

More details about the raytracer can be found in Raytracing on page 648. The raytracer requires the use of the complex refractive index model, and various excitation variables can be ramped. These rampable excitation variables are `Intensity`, `Wavelength`, `Theta`, `Phi`, and `PolarizationAngle` or `Polarization`.

The required syntax is:

```
Physics {...
  Optics (
    ComplexRefractiveIndex(...)
    OpticalGeneration(...)
    OpticalSolver(
      RayTracing(...)
    )
```

**21: Optical Generation**
Solving the Optical Problem

```
      Excitation(...)
    )
  }
```

where the RayTracing section contains:

```
RayTracing(
  # Setting keywords of raytracer
  # -----------------------------
  CompactMemoryOption
  MonteCarlo
  OmitReflectedRays
  OmitWeakerRays
  RedistributeStoppedRays

  PolarizationVector = vector
  PolarizationVector = Random
  DepthLimit = integer
  MinIntensity = float                 # fraction, relative value
  RetraceCRIchange = float             # fractional change to retrace rays
  VirtualRegions { "string" "string" ... }
  VirtualRegions {}
  ExternalMaterialCRIFile = "string"
  WeightedOpticalGeneration

  # Defining starting rays:
  # -----------------------
  RayDistribution( ... )
  RectangularWindow (
    RectangleV1 = vector                # vertex 1 of rectangular window [um]
    RectangleV2 = vector                # vertex 2 of rectangular window [um]
    RectangleV3 = vector                # vertex 3 needed only for 3D [um]
    # number of rays = LengthDiscretization * WidthDiscretization
    LengthDiscretization = integer      # longer side
    WidthDiscretization = integer       # shorter side needed only for 3D
    RayDirection = vector
  )

  UserWindow (
    NumberOfRays = integer              # number of rays in file
    RaysFromFile = "filename.txt"       # position(um) direction area(cm^2)
    PolarizationVector = ReadFromExcitation
  )
)
```

Solving the Optical Problem

Some comments about the RT syntax:

*   The keyword `RetraceCRIchange` specifies the fractional change of the complex refractive index (either the real or imaginary part) from its previous state that will force a total recomputation of raytracing.

*   Starting rays for raytracing can be set using `RectangularWindow` or `UserWindow`. Details can be found in Window of Starting Rays on page 655. Only one of the windows can be chosen but not both.

*   Starting rays also can be set using the illumination window (see Illumination Window on page 622) and the `RayDistribution` section (see Distribution Window of Rays on page 657).

*   Raytracing in cylindrical coordinates is also possible (see Cylindrical Coordinates for Raytracing on page 658).

## Beam Propagation Method

The BPM solver is selected using the following syntax:

```
Physics {
  Optics (
    OpticalSolver (
      BPM ( <BPM options> )
    )
  )
}
```

The BPM-specific options, such as the specific excitation type or the discretization parameters, are described in Using Beam Propagation Method on page 704.

## Loading Solution of Optical Problem From File

The solution of the optical problem, which can be either an absorbed photon density profile or an optical generation profile, also can be loaded from a file. In contrast to using `OpticalGeneration ( ReadFromFile ( ... ) )`, the optical solver `FromFile` offers more flexibility for simulation setups that involve an illumination spectrum or parameter ramping.

The required syntax is:

```
File {
  OpticalSolverInput = "<file name or file name pattern>"
}

Physics {
  Optics (
    OpticalGeneration (
      ComputeFromMonochromaticSource ()
```

**21: Optical Generation**
Solving the Optical Problem

```
        )
        OpticalSolver (
            FromFile ( <FromFile options> )
        )
    )
}
```

The use of the optical solver `FromFile` is described in Loading Solution of Optical Problem From Files on page 695.

## Optical Beam Absorption Method

The following syntax is used to select the optical beam absorption method as the optical solver:

```
Physics {
    Optics (
        OpticalSolver (
            OptBeam ( <OptBeam options> )
        )
    )
}
```

The `OptBeam`-specific options, such as the parameters for the extraction of the layer stack, are described in Using Optical Beam Absorption Method on page 701.

## Composite Method

The following syntax is used to select the composite method as the optical solver:

```
Physics {
    Optics (
        OpticalSolver (
            Composite ( <Composite options> )
        )
    )
}
```

The `Composite` solver itself is not a numeric method to solve an optical problem. Instead, it coordinates the execution of other solvers that might depend on each other and sums their results to yield a general solution. As such, it requires the specification of at least another optical device instance. For details about this solution approach, see Composite Method on page 711.

619

**21: Optical Generation**

Solving the Optical Problem

# Setting the Excitation Parameters

The `Excitation` section is common to all optical solvers and mainly specifies a plane wave excitation. It contains the following keywords:

*   `Intensity` [W/cm<sup>2</sup>]
*   `Wavelength` [μm]
*   `Theta` [deg]
*   `Phi` [deg]
*   `PolarizationAngle` [deg] or `Polarization`

In combination with the optical solvers `TMM`, `OptBeam`, and `FromFile`, an additional `Window` section is required to specify the parameters of the illumination window, which is described in Illumination Window on page 622.

> **NOTE** For the optical solver `FromFile`, the requirement of a `Window` section only applies when one-dimensional profiles are loaded.

The intensity is defined with respect to an imagined surface normal to the propagation direction of the incident light. For the transfer matrix method (`TMM`) and the optical beam absorption method (`OptBeam`) specifying `ReferenceSurface=IlluminationWindow`, you can set the reference surface to the plane of the illumination window to obtain the default behavior of Version P-2019.03 and earlier.

The propagation direction is defined by the angles with the positive z-axis and x-axis, respectively. In two dimensions, the propagation direction is well-defined by specifying `Theta` only, where `Theta` corresponds to the angle between the propagation direction and the positive y-axis. However, in three dimensions, the propagation direction is defined by `Theta` and `Phi`:

*   `Theta` is the angle between the positive z-axis and the propagation direction.

*   `Phi` is the angle between the positive x-axis and the projection of the propagation direction on the xy plane as shown in Figure 28 on page 621.

For vectorial methods, such as the FDTD solver, the polarization is set using the keyword `PolarizationAngle`, which represents the angle between the H-field and the $z \times \hat{k}$ axis, where $\hat{k}$ is the unit wavevector (see Sentaurus™ Device Electromagnetic Wave Solver User Guide, Plane Waves on page 49).

21: Optical Generation
Solving the Optical Problem

For the TMM and RT solvers, the conventions for polarization are as follows:

*   In two dimensions, the keyword `Polarization` is a real number in the interval [0,1], where `Polarization=0` refers to TM, and `Polarization=1` refers to TE excitations, respectively. If the keyword `PolarizationAngle` is specified, it takes precedence over the keyword `Polarization`. A simple relationship between `PolarizationAngle` and `Polarization` can be established: Polarization = sin<sup>2</sup>(PolarizationAngle).

*   In three dimensions, the polarization vector is defined by rotating the $z \times \hat{k}$ vector counterclockwise, about the wave direction, by an angle defined by `PolarizationAngle` when looking in the propagation direction.

> **NOTE** For the RT solver, specifying the `PolarizationVector` explicitly overrides the keywords `Polarization` and `PolarizationAngle`.

Definition of coordinate system for 3D plane wave excitation and examples of parameters of 3D plane wave

Figure 28 Definition of coordinate system for 3D plane wave excitation and examples of parameters of 3D plane wave

Solving the Optical Problem

## Illumination Window

The concept of an illumination window to confine the light that is incident on the surface of a device structure plays an important role in various simulation setups for photo-diode devices, such as photodetectors, solar cells, and image sensors. Sentaurus Device supports a flexible user interface for the specification of one or more illumination windows, which also allows you to move these windows during a simulation by ramping the corresponding parameters. This common interface is available for the TMM, `FromFile` (only for loading 1D profiles), OptBeam, and RayTracing (see Using the Raytracer on page 651) solvers, while different solver-specific implementations exist for BPM (see Using Beam Propagation Method on page 704) solvers.

The illumination window is described using a local coordinate system specified by the global location of its origin and the x- and y-directions given as vectors or in terms of rotation angles as illustrated in Figure 29.

Within this local coordinate system, several window shapes can be defined using relative quantities such as width and height, together with an origin anchor for a line in 2D or a rectangular window in 3D. Alternatively, or for shapes that do not support relative quantities, absolute coordinates are used to characterize the shape of the window. For example, a polygon would be defined by specifying a series of vertices in the local 2D coordinate system.

Coordinate system used in the illumination window for (left) two dimensions and (right) three dimensions

Figure 29 Coordinate system used in the illumination window for (*left*) two dimensions and (*right*) three dimensions

The following window shapes are supported:

* Line (in 2D only)

* Rectangle (in 3D only)

* Polygon (in 3D only)

* Circle (in 3D only)

**21: Optical Generation**
Solving the Optical Problem

You can define more than one illumination window. The specification of an optional name tag allows you to refer to the respective window when ramping one of its parameters. It is also helpful for identifying results for a specific window in the current file. If two windows overlap, the solutions of the corresponding windows will be added in the intersection.

The global location of the origin of the local coordinate system is specified with the keyword `Origin`, whose default is (0, 0, 0). To specify its orientation, the directions of the coordinate axes can be defined using the vectors `XDirection` and `YDirection`. In two dimensions, only `XDirection` needs to be specified.

Alternatively, you can set three rotation angles `theta` (angle with z-axis), `phi` (angle between x-axis and projection of window normal n on xy plane), and `psi` (angle between local x-axis and the vector $\hat{z} \wedge \hat{n}$), which define the vector `RotationAngles` in three dimensions as shown in Figure 29 on page 622. For two dimensions, only the first angle of the vector `RotationAngles` is used, which means a rotation of the angle from the local +y'-axis to the local +x'-axis. The local origin can be defined within each `Window` using the keyword `Origin=<vector>`. The `RotationAngles` are compatible with the optical solvers TMM, Raytracing, Optbeam, and FromFile. In general, the direction of excitation defined in (`Theta`, `Phi`) of the `Excitation` section is independent of the angles defined by `RotationAngles`.

If the location of a window in the local coordinate system is not specified by its corresponding vertex coordinates, its placement is determined by the bounding box of the window shape and a cardinal direction such as `North`, `South`, `NorthWest`, and so on, or `Center` defining which point of the bounding box coincides with the local origin. The cardinal direction is specified using the keyword `OriginAnchor`.

The illumination window is specified in the `Excitation` section as follows:

```
Physics {
  Optics (
    Excitation (
      Window ( <Window options> )
    )
  )
}
```

The following examples introduce the supported window shapes and show different ways of specifying them. Depending on the simulation setup, one specification might be more convenient than others, for example, if the window needs to be moved by using the parameter ramping feature.

Solving the Optical Problem

## Line

Line normal to y-axis at y=-10, xmin=-5, xmax=5:

```
Window (
   Origin = (0,-10)
   OriginAnchor = Center # Default
   Line ( Dx = 10 )
)
```

Line normal to y-axis at y=-10, xmin=5, xmax=500:

```
Window (
   Origin = (5,-10)
   OriginAnchor = West
   Line ( Dx = 545 )
)
```

or alternatively:

```
Window (
   Origin = (0,-10)
   XDirection = (1, 0, 0) # Default
   Line (
    X1 = 5
    X2 = 500
   )
)
```

Two lines normal to y-axis at y=-10, with xmin1=5, xmax1=10, and xmin2=15, xmax2=20:

```
Window ("W1") (
   Origin = (5, -10)
   OriginAnchor = West
   Line ( Dx = 5 )
)

Window ("W2") (
   Origin = (15, -10)
   OriginAnchor = West
   Line ( Dx = 5 )
)
```

21: Optical Generation
Solving the Optical Problem

# Rectangle

Rectangle normal to z-axis at z=10, with width=10 and height=5, centered at x=0 and y=0:

```
Window (
  Origin = (0, 0, 10)
  OriginAnchor = Center # Default
  Rectangle (
    Dx = 10
    Dy = 5
  )
)
```

or alternatively:

```
Window (
  Origin = (0, 0, 10)
  Rectangle (
    Corner1 = (-5, -2.5)
    Corner2 = (5, 2.5)
  )
)
```

# Polygon

Triangle in xz plane at y=4, and corners at (0, 0, 0), (1, 0, 0), and (0, 0, 1):

```
Window (
  Origin = (0, 4, 0)
  XDirection = (1, 0, 0) # Default
  YDirection = (0, 0, 1)
  Polygon( (0, 0), (1, 0), (0, 1) )
)
```

**NOTE** More complex polygon specifications also are supported by specifying several polygon loops, which might or might not intersect. In this case, the vertices of each loop must be enclosed in extra parentheses within the Polygon section.

# Circle

Circle in xy plane with center at (5, 4, -10) and radius 3:

```
Window (
  Origin = (5, 4, -10)
  XDirection = (1, 0, 0) # Default
  YDirection = (0, 1, 0) # Default
  Circle ( Radius = 3 )
)
```

Solving the Optical Problem

## Common Illumination Configurations

The most common cases of illumination are from either the top or the bottom of the device structure. Depending on the coordinate system, the DF–ISE coordinate system or the unified coordinate system (UCS), the bottom-to-top growth orientation aligns with the +z-axis or the –x-axis, respectively.

You can also use the `CoordinateSystem` keyword in the `Math` section to choose a different coordinate system from that of the input TDR grid file (see Reading a Structure on page 9). Table 116 lists the combinations of coordinate systems that you can control.

Table 116 Combinations of coordinate systems in TDR grid file and Math section

| Coordinate system in input TDR grid file | Math section CoordinateSystem{} | Coordinate system at runtime | Coordinate system in output TDR file |
| --- | --- | --- | --- |
| DF–ISE | AsIs | DF–ISE | DF–ISE |
| DF–ISE | DFISE | DF–ISE | DF–ISE |
| DF–ISE | UCS | UCS | UCS |
| UCS | AsIs | UCS | UCS |
| UCS | UCS | UCS | UCS |
| UCS | DFISE | DF–ISE | DF–ISE |

**NOTE** Excitation and window parameters follow the default coordinate system in Sentaurus Device (that is, the DF–ISE coordinate system). Therefore, if you select the UCS, you must set the correct parameters carefully.

The orientation of the excitation for the UCS might be confusing. Therefore, you can specify a simplified default set of parameters automatically using one of the following options in the `Excitation` section:

```
Optics (...
      Excitation (
         fromTop                # or fromBottom
      )
)
```

Table 117 and Table 118 on page 627 list the parameters affected by specifying `fromTop` or `fromBottom`.

21: Optical Generation
Solving the Optical Problem

Table 117 Default values for essential 2D excitation parameters when fromTop or fromBottom is activated

| Excitation parameter | 2D DF–ISE coordinate system | 2D UCS |  |  |
| --- | --- | --- | --- | --- |
| fromTop | fromBottom | fromTop | fromBottom |  |
| Theta | 0 | 180 | 90 | 270 |
| Origin | (0,ymin) | (0,ymax) | (xmin,0) | (xmax,0) |
| XDirection | (1,0) | (1,0) | (0,1) | (0,1) |
| Window type | Line | Line | Line | Line |
| X1 | xmin | xmin | ymin | ymin |
| X2 | xmax | xmax | ymax | ymax |

Table 118 Default values for essential 3D excitation parameters when fromTop or fromBottom is activated

| Excitation parameter | 3D DF–ISE coordinate system | 3D UCS |  |  |
| --- | --- | --- | --- | --- |
| fromTop | fromBottom | fromTop | fromBottom |  |
| Theta | 180 | 0 | 90 | 270 |
| Phi | 0 | 0 | 0 | 0 |
| Origin | (0,0,zmax) | (0,0,zmin) | (xmin,0,0) | (xmax,0,0) |
| XDirection | (1,0,0) | (1,0,0) | (0,0,1) | (0,0,1) |
| YDirection | (0,1,0) | (0,1,0) | (0,1,0) | (0,1,0) |
| Window type | Rectangle | Rectangle | Rectangle | Rectangle |
| Corner1 | (xmin,ymin) | (xmin,ymin) | (zmin,ymin) | (zmin,ymin) |
| Corner2 | (xmax,ymax) | (xmax,ymax) | (zmax,ymax) | (zmax,ymax) |

In these tables, xmin, xmax, ymin, ymax, zmin, and zmax refer to the bounding limits of the device. In two dimensions, Theta denotes an angle that is rotated from the positive x-axis towards the positive y-axis. In three dimensions, Theta starts from the positive z-axis towards the xy plane.

Referring to Table 117 and Table 118, the following examples demonstrate how the syntax is set up automatically.

**NOTE** In these examples, keywords whose default values are correct for the given use case have been omitted to demonstrate the minimum required specification.

Solving the Optical Problem

DF–ISE coordinate system in two dimensions:

```
Excitation (
  ...
  Window (
    Origin = (0, <ymin of device>)
    Line ( x1 = <xmin> x2 = <xmax> )    # Extent of illumination window
  )
)
```

## UCS in two dimensions:

```
Excitation (
  ...
  Theta = 90                            # Illumination from top in +x direction
  Window (
    Origin= (<xmin of device>, 0)
    xDirection= (0, 1)                  # Local x' points in global +y direction
    Line (x1=<ymin> x2=<ymax> )         # Extent of illumination window
  )
)
```

DF–ISE coordinate system in three dimensions:

```
Excitation (
  ...
  Theta = 180                           # Illumination from top in -z-direction
  Window (
    Origin = (0, 0, <zmax of device>)
    Rectangle (
      # Extent of illumination window
      corner1 = (<xmin>, <ymin>) corner2 = (<xmax>, <ymax> )
    )
  )
)
```

## UCS in three dimensions:

```
Excitation (
  ...
  Theta = 90                            # Illumination from top in +x-direction
  Window (
    Origin = (<xmin of device>, 0, 0)
    xDirection = (0, 0, 1)              # Local x' points in global +z-direction
    yDirection = (0, 1, 0)              # Local y' points in global +y-direction
    Rectangle (
      # Extent of illumination window
      corner1 = (<zmin>, <ymin>) corner2 = (<zmax>, <ymax> )
    )
  )
)
```

21: Optical Generation
Solving the Optical Problem

```
    )
  )
```

## Moving Illumination Windows Using Parameter Ramping

The following syntax demonstrates how to move and resize illumination windows during a simulation using the parameter ramping framework:

```
Physics {
  Optics (
    Excitation (
      Window("L1") (
        Origin = (-0.5, -0.1, 0)
        XDirection = (1,0,0)      # Default
        Line(
          x1 = -0.5
          x2 = 0.5
        )
      )
      Window("L2") (
        Origin = (0.5, -0.1, 0)
        OriginAnchor = Center     # Default
        XDirection = (1,0,0)      # Default
        Line( Dx = 1 )
      )
    )
  )
}

Solve{
  Optics
  Quasistationary (
    InitialStep=0.2 MaxStep=0.2 MinStep=0.2
    Goal { ModelParameter="Optics/Excitation/Window(L2)/Line/Dx" value=0.2 }
  ) { Optics }

  Quasistationary (
    InitialStep=0.2 MaxStep=0.2 MinStep=0.2
    Goal { ModelParameter="Optics/Excitation/Window(L2)/Origin[0]"
    value=0.9 }
    Goal { ModelParameter="Optics/Excitation/Window(L2)/Origin[1]"
    value=0.5 }
    Goal { ModelParameter="Optics/OpticalSolver/TMM/
    LayerStackExtraction(L2)/Position[0]" value=0.9 }
  ) { Optics }
}
```

For details about ramping parameters, including the ramping of vector parameters, see Parameter Ramping on page 635.

Solving the Optical Problem

## Spatial Intensity Function Excitation

With the illumination window feature, you can define a spatial profile within each illumination window (see Illumination Window on page 622). The intensity profile corresponds to a modified Gaussian profile with the shape shown in Figure 30.

| x | g(x) |
| --- | --- |
| 0 | 0.0 |
| 1 | 0.3 |
| 2 | 1.0 |
| 3 | 0.3 |
| 4 | 0.0 |

Figure 30 Gaussian spatial intensity distribution, showing the definition of key parameters

There is a top plateau, with both ends decaying with symmetric Gaussian functions. Its peak value is normalized to 1.0. Mathematically, the spatial shape is defined by:

$$ g_x(x) = \begin{cases} \exp \left[ -\frac{\left( |x - x_{\text{pos}}| - \frac{x_{\text{width}}}{2} \right)^2}{2\sigma^2} \right] & , |x - x_{\text{pos}}| > \frac{x_{\text{width}}}{2} \\ 1 & , \text{otherwise} \end{cases} \quad (682) $$

where $\sigma$ (Sigma) is the Gaussian width, $x_{\text{pos}}$ (PeakPosition) is the center peak position of the function, and $x_{\text{width}}$ (PeakWidth) is the width of the center plateau.

To add flexibility, you can add $g_0$ (Scaling) as a scaling factor to the final expression:

$$ g(x) = g_0 \cdot g_x(x) \quad (683) $$

**21: Optical Generation**
Solving the Optical Problem

This modified spatial Gaussian function can be applied to the different supported types of illumination window: line, rectangle, polygon, and circle (see Illumination Window on page 622). In two dimensions, the product of two modified Gaussian functions is:

$$g(x, y) = g_0 \cdot g_x(x) \cdot g_y(y)$$ (684)

The syntax of the spatial intensity function is embedded within the syntax of the illumination window:

```
Optics (
  Excitation (...
    Wavelength = 0.5
    Intensity = 100    * [W/cm2]
    Window(
      IntensityDistribution(
        Gaussian(
          Sigma = (<float>,<float>) | Length = (<float>,<float>)
          PeakPosition = (<float>,<float>)
          PeakWidth = (<float>,<float>)
          Scaling = <float>
        )
      )
      Rectangle(dx = 1, dy = 2)
    )
  )
)
```

**Comments about the syntax:**

* The `IntensityDistribution` section is specified within the illumination window (`Window`). It follows the local coordinate system of the window, that is, `PeakPosition` is taken with reference to the origin of the local coordinate of the window.

* Either `Sigma` or `Length` must be specified. If `Length` is specified, `Sigma` is calculated using the formula: $\sigma = x_{\text{length}} / \sqrt{2}$.

* Parameters are input as a single floating-point number (for one dimension) or a vector (for two dimensions). For example, `Sigma=0.05` for a 1D Gaussian and `Sigma=(0.03,0.04)` for a 2D Gaussian.

* The `IntensityDistribution` section works with the raytracing, `TMM`, `OptBeam`, and `FromFile` optical solvers.

**NOTE** For 1D solvers such as `TMM` and `OptBeam`, the spatial intensity profile is simply overlaid onto the 1D field distribution; it is not an indication of a more accurate solution.

631

Solving the Optical Problem

## Choosing Refractive Index Model

The complex refractive index model as described in Complex Refractive Index Model on page 640 is available for all optical solvers. It must be specified in the `Optics` section when using the unified interface for optical generation computation.

## Extracting the Layer Stack

The optical solvers TMM (see Transfer Matrix Method on page 680) and OptBeam (see Optical Beam Absorption Method on page 699) require the extraction of a layer stack from the actual device structure as they are based on 1D algorithms whose solution is extended to the dimension of the simulation grid. Both the extension of the solution and the extraction of the layer stack are bound to the illumination window (see Illumination Window on page 622), which determines the domain of the device structure being represented by the 1D optical problem.

The layer stack extraction algorithm works by extracting all grid elements along a line normal to the corresponding illumination window starting from a user-specified position within the window. The direction of extraction, that is, positive or negative, is derived from the propagation direction of the incident light as specified in the `Excitation` section.

By default, all elements belonging to the same region will form a single layer, which is part of the entire stack. This assumes that the material properties do not vary within the region. If this is not the case or not a good approximation, you can create a separate layer for each extracted element by selecting the option `ElementWise` instead of `RegionWise` for the keyword `Mode` in the `LayerStackExtraction` section. As this can lead to a large number of layers whose difference in material properties might be insignificant for the solution of the optical solver, yet impact its performance, a threshold value can be specified to control the creation of the layer stack from the extracted grid elements.

All elements whose relative difference in the refractive index or extinction coefficient, compared with the previous layer, is lower than the threshold are merged into one layer. In doing so, the refractive index and the extinction coefficient are treated separately, both deviations must be lower than the specified threshold. The material properties of this merged layer are obtained by averaging the corresponding element properties. The thickness of each element computed by the distance between the intersection points of the extraction line with the corresponding element is summed to yield the total thickness of the representative layer of the stack.

The threshold can be specified using the keyword `ComplexRefractiveIndexThreshold` in the `LayerStackExtraction` section.

21: Optical Generation
Solving the Optical Problem

Options are available for defining the starting point of the extraction line:

*   Exact position in the global coordinate system using the keyword `Position`

*   Position within the bounding box of the window designated by a cardinal direction

*   Position within the bounding box of the window specified as a point in the local coordinate system of the illumination window

The last two options require the specification of the keyword `WindowPosition`. Its argument can be either one of `North`, `South`, `NorthWest`, and so on, and `Center` or a 2D point, for example, `WindowPosition = (1.5, 2)`.

The following is an example for a `LayerStackExtraction` section used by the TMM solver:

```
Physics {
  Optics (
    OpticalSolver (
      TMM (
        LayerStackExtraction (
          WindowName = "L1"
          Position = (-0.5, -0.1, 0)
          Mode = ElementWise # Default RegionWise
        )
      )
    )
  )
}
```

The keyword `WindowName` is required if more than one illumination window exists. Its argument specifies to which illumination window the `LayerStackExtraction` refers.

> **NOTE** If the starting point of the extraction line is outside of the device structure, the extracted layer stack will contain a layer representing the space between the starting point of the extraction line and the surface of the device structure. In general, the material properties of vacuum are assigned to this layer. For optical solvers that support user-defined bulk media on the top and the bottom of the layer stack using the `Medium` statement, the material properties of the top medium if specified are used except that the extinction coefficient k is set to 0. For details about user-defined bulk media, see Using Transfer Matrix Method on page 685.

21: Optical Generation

Solving the Optical Problem

# Controlling Computation of Optical Problem in Solve Section

Specifying the keyword `Optics` in the `Solve` section triggers the solution of the optical problem. For example, the following is sufficient to compute the optical generation and the optical intensity:

```
Physics {
  Optics (
    OpticalGeneration ( ... )
  )
}

Solve { Optics }
```

If only the keyword `Optics` is specified in the `Solve` section, either directly or within a `Quasistationary` or `Transient` statement, and no other equations are solved, the simulation is classified as an optics standalone simulation. In general, such simulations do not require the specification of contacts in the grid file. In optics standalone simulations, it is possible to switch on the creation of double points at region interfaces independent of the type of interface. In other words, a heterojunction interface is treated in the same way as a semiconductor–insulator interface. This feature is enabled by specifying the keyword `Discontinuity` in the `Physics` section (see Discontinuous Interfaces on page 241).

The `Solve` section of a typical transient device simulation reads as follows:

```
Solve {
  Optics
  Poisson
  Coupled { Poisson Electron Hole }

  Transient (
    InitialTime = 0
    FinalTime = 3e-6
  ) { Coupled { Poisson Electron Hole } }
}
```

In this example, the optical generation rate is computed at the beginning when the optical problem is solved and is used afterwards in the electronic equations. To recompute the optical generation at a later point, the `Optics` statement can be listed wherever a `Coupled` statement is allowed.

The optical generation depends on the solution of the optical problem and, therefore, has an implicit dependency on all quantities that serve as input to the optical equation. Internally, an automatic update scheme ensures that, whenever the optical generation rate is read, all its

**21: Optical Generation**
Parameter Ramping

underlying variables are up-to-date. Otherwise, it will be recomputed. This mechanism can be switched off by specifying `-AutomaticUpdate` in the `OpticalGeneration` section. By default, `AutomaticUpdate` is switched on.

---

# Parameter Ramping

Sentaurus Device can be used to ramp the values of physical parameters (see Ramping Physical Parameter Values on page 79). For example, it is possible to sweep the wavelength of the incident light to extract the spectral dependency of a certain output characteristic conveniently. Ramping model parameters of the unified interface for optical generation computation works the same way except that instead of using the expression `Parameter= "<parameter name>"`, it uses the keyword `ModelParameter= "<parameter name or path>"`.

The value of `ModelParameter` can be either the parameter name itself such as `"Wavelength"` if it is unambiguous or the parameter name including its full path:

```
Solve {
  Quasistationary (
    Goal {
      [ Device = <device> ]
      [ Material = <material> | MaterialInterface = <interface> |
        Region = <region> | RegionInterface = <interface> ]
      ModelParameter = "Optics/Excitation/Wavelength" Value = <float>
    }
  ){ Optics }
}
```

Specifying the device and location (material, material interface, region, or region interface where applicable) is optional. However, `ModelParameter` and its `Value` must always be specified.

Similarly, the corresponding `CurrentPlot` section reads as follows:

```
CurrentPlot {
  [ Device = <device> ]
  [ Material = <material> | MaterialInterface = <interface> |
    Region = <region> | RegionInterface = <interface> ]
  ModelParameter = "Optics/Excitation/Wavelength"
}
```

Parameters whose value type is a vector of floating-point numbers support ramping of the individual vector components.

635

Parameter Ramping

For example, to ramp the x- and y-components of the illumination window origin, the following syntax is required:

```
Quasistationary (
  InitialStep=0.2 MaxStep=0.2 MinStep=0.2
  Plot { Range = ( 0., 1 ) Intervals = 5 }
  Goal { ModelParameter="Optics/Excitation/Window(L2)/Origin[0]" value=0.9 }
  Goal { ModelParameter="Optics/Excitation/Window(L2)/Origin[1]" value=0.5 }
) {
  Optics
}
```

**NOTE** When ramping parameters that reside in sections that can occur multiple times, such as the `Window` section, an identifying section name or tag in parentheses must follow the section name in the parameter path as shown in the example above.

Table 119 Parameters that can be ramped using the unified interface for optical generation computation

| Parameter path | Parameter name |
| --- | --- |
| Optics/OpticalGeneration | Scaling |
| Optics/OpticalGeneration/ComputeFromMonochromaticSource | Scaling |
| Optics/OpticalGeneration/ReadFromFile | Scaling |
| Optics/OpticalGeneration/ComputeFromSpectrum | Scaling |
| Optics/OpticalGeneration/SetConstant | Value |
| Optics/Excitation | Wavelength, Intensity, Theta, Phi, PolarizationAngle, Polarization |
| Optics/Excitation/Window | All parameters that are not of type string or identifier. |
| Optics/OpticalSolver/<SolverName> | Except for raytracing, all parameters that are not of type string or identifier. |

A list of parameter names that can be ramped in the command file is printed when the following command is executed:

```
sdevice --parameter-names <command file>
```

**NOTE** Parameters used in ramping must also exist in the relevant `Physics` section in order to set the values of the parameters to the initial values specified in the `Physics` section.

21: Optical Generation
Accurate Absorbed Photon Density for 1D Optical Solvers

# Accurate Absorbed Photon Density for 1D Optical Solvers

In 1D optical solvers such as `TMM`, `OptBeam`, and `FromFile`, the 1D absorbed photon density (APD) is superimposed onto the projected volume from an illumination window that extends into the 2D or 3D device geometry.

While the sampled APD at each vertex is exact for the 1D solver, the integration with `CurrentPlot` simply multiplies the box method volume, and this can result in inaccuracy due to the following:

*   If the mesh is coarse, the projected volume from an illumination window intersects the box method volumes partially at the fringes.

*   Depending on where the vertices are located, the box method–integrated APD can be smaller or larger than the true integrated value.

Such inaccuracies can lead to nonconservation of particles or energy because an incorrectly integrated APD produces an incorrect optically generated current.

To reduce the mesh dependency of the integrated APD values for 1D optical solvers, a virtual wireframe is constructed over the projected volume from an illumination window to compute a discrete Riemann integral of the APD. In the transverse plane of the illumination window, the wireframe is chosen automatically with either a discretization of 10 nm or a limit of 200 transverse wireframe cells. In the propagation direction, the wireframe is first divided into layers and, then within each layer, a further discretization of `NumberOfCellsPerLayer` is used for refinement.

The number of layers for the `TMM` and `OptBeam` solvers is fixed at the number of extraction layers, while the `FromFile` optical solver allows you to specify the number of layers. `NumberOfCellsPerLayer` can be controlled by all three optical solvers. Although a denser wireframe provides a more accurate integrated APD, it also slows down the simulation since the APD must be sampled at every wireframe point in the propagation direction.

After the accurate integrated APD has been computed, it is used to compute a weighting factor for the APD on the mesh vertices such that, when `CurrentPlot` multiplies the box method volume to obtain the integrated values, you can retrieve the correct integrated APD. The vertices within the projected volume from an illumination window are divided into the center zone and the fringe zone:

*   Center zone vertices have edges that connect only to vertices within the projected window volume.

*   Fringe zone vertices have edges that cross the boundary of the projected window volume.

> **NOTE** The weighting factor is applied only to the fringe zone vertices, so you might see a distorted APD value at those vertices.

Accurate Absorbed Photon Density for 1D Optical Solvers

Numerically, the weighting factor is computed in each layer and is defined as:

$$ W_{\text{layer}(k)} = \frac{\int\limits_{\text{layer}(k)} f_{\text{APD}}(\text{wireframe}) dv - \sum\limits_{\text{centerzone}} F_{\text{APD}}(v_i) \cdot \text{box}(v_i)}{\sum\limits_{\text{fringezone}} F_{\text{APD}}(v_i) \cdot \text{box}(v_i)} $$ (685)

After this computation, the weighting factor is applied to the APD of the fringe zone vertices:

$$ F'_{\text{APD}}(v_i) = W_{\text{layer}(k)} \cdot F_{\text{APD}}(v_i) $$ (686)

However, there can be instances whereby the center zone box-integrated APD is greater than the wireframe-integrated APD. In such cases, the weighting factor is computed as

$$ W_{\text{layer}(k)} = \frac{\int\limits_{\text{layer}(k)} f_{\text{APD}}(\text{wireframe}) dv}{\sum\limits_{\text{centerzone}} F_{\text{APD}}(v_i) \cdot \text{box}(v_i) + \sum\limits_{\text{fringezone}} F_{\text{APD}}(v_i) \cdot \text{box}(v_i)} $$ (687)

and it is applied to modify the APD of all center and fringe zone vertices.

This new methodology can be activated selectively in different illumination windows as follows:

```
Physics {...
  Optics (...
    Excitation (...
      Window("win_1") (...
        # To switch off, add '-' in front or leave blank.
        -WeightedAPDintegration
      )
      Window("win_2") (...
        # To switch on, use this keyword
        WeightedAPDintegration
      )
    )
  )
}
```

The syntax for controlling the wireframe density is:

```
Physics {...
  Optics (...
    Excitation (...
      Window(...) (...
        # Various options available
        WeightedAPDintegration(
```

21: Optical Generation

Accurate Absorbed Photon Density for 1D Optical Solvers

```
            PrintInfo
            NumberOfCellsPerLayer = <int>                # default is 10000
            NumberOfTransverseCellsPerDirection = <int> # default is 200
            Mode = Auto                                 # or Full, default is Auto
         )
      )
   )
   OpticalSolver(...
      FromFile(...
         # Default value is the number of regions but is limited to 20
         WeightedAPDintegrationlayers = <int>
         WeightedAPDIntegrationSetBoundaries = (<float>, <float>, ...)
      )
   )
)
}
```

Some comments about this syntax:

* To speed up the wireframe integration of APD, you probe strategic points (three points in two dimensions and five points in three dimensions) in each delta projection window (the illumination window area multiplied by the wireframe cell thickness) to determine whether to perform the full transverse numeric integration or to use a precomputed volume. The keyword `Mode=Auto` allows for a quick assessment and should be used when the projected illumination window is expected to stay within the device domain.

* For the TMM and `OptBeam` optical solvers, the number of layers is set to be the same as that from the `LayerStackExtraction` section. For the `FromFile` optical solver, you can set the number of layers using `WeightedAPDIntegrationLayers`, which divides the total propagation length into equal layer thicknesses. Alternatively, if the structure contains important thin layers, you can specify the boundaries of each layer using `WeightedAPDIntegrationSetBoundaries`. These boundaries are measured from the illumination window in the direction of propagation, so they must be positive numbers. Otherwise, the default for the number of layers is the number of significant regions, that is, regions whose volumes are at least 10% of the total volume of the device.

* You can control the discretization of the wireframe with the following keywords:

  * `NumberOfCellsPerLayer` controls the discretization in the direction of propagation.

  * `NumberOfTransverseCellsPerDirection` controls the discretization of the illumination window in the 2D plane containing the window.

**NOTE** The plane of the window might not necessarily align with the standard xy, yz, or xz planes.

21: Optical Generation
Complex Refractive Index Model

# Complex Refractive Index Model

The complex refractive index model in Sentaurus Device allows you to define the refractive index and the extinction coefficient depending on mole fraction, wavelength, temperature, carrier density, and local material gain. In addition, it provides a flexible interface that can be used to add new complex refractive index models as a function of almost any internally available variable. See Complex Refractive Index Model Interface on page 1322.

The complex refractive index model is designed primarily for use in the unified interface for optical generation computation and LED simulations. Other tools besides Sentaurus Device, such as Sentaurus Device Electromagnetic Wave Solver (EMW) and Sentaurus Mesh, also support this model, allowing for a consistent source of optical material parameters across the entire tool flow. A common Sentaurus Device parameter file can be shared and only the syntax for activating the different models might slightly change from tool to tool to comply with the respective command file syntax.

## Physical Model

The complex refractive index $\tilde{n}$ can be written as:

$$ \tilde{n} = n + i \cdot k \tag{688} $$

with:

$$ n = n_0 + \Delta n_\lambda + \Delta n_T + \Delta n_{\text{carr}} + \Delta n_{\text{gain}} \tag{689} $$

$$ k = k_0 + \Delta k_\lambda + \Delta k_{\text{carr}} \tag{690} $$

The real part $n$ is composed of the base refractive index $n_0$, and the correction terms $\Delta n_\lambda$, $\Delta n_T$, $\Delta n_{\text{carr}}$, and $\Delta n_{\text{gain}}$. The correction terms include the dependency on wavelength, temperature, carrier density, and gain.

The imaginary part $k$ is composed of the base extinction coefficient $k_0$, and the correction terms $\Delta k_\lambda$ and $\Delta k_{\text{carr}}$. The correction terms include the dependency on wavelength and carrier density. The absorption coefficient $\alpha$ is computed from $k$ and wavelength $\lambda$ according to:

$$ \alpha = \frac{4\pi}{\lambda} \cdot k \tag{691} $$

**21: Optical Generation**
Complex Refractive Index Model

# Wavelength Dependency

The complex refractive index model offers different ways to take wavelength dependency into account:

*   An analytic formula considers a linear and square dependency on the wavelength $\lambda$:

$$
\begin{aligned}
\Delta n_{\lambda} &= C_{n, \lambda} \cdot \lambda + D_{n, \lambda} \cdot \lambda^2 \\
\Delta k_{\lambda} &= C_{k, \lambda} \cdot \lambda + D_{k, \lambda} \cdot \lambda^2
\end{aligned}
\eqno(692)
$$

You can adjust the $C_{n, \lambda}$, $D_{n, \lambda}$, $C_{k, \lambda}$, and $D_{k, \lambda}$ parameters in the `ComplexRefractiveIndex` section of the parameter file (see Table 122 on page 644).

*   Tabulated values can be read from the parameter file. The table contains three columns specifying wavelength $\lambda$, refractive index $n'$, and the extinction coefficient $k'$. Thereby, $n'$ and $k'$ represent $n_0 + \Delta n_{\lambda}$ and $k_0 + \Delta k_{\lambda}$, respectively. The character `*` is used to insert a comment. The row is terminated by a semicolon. For wavelengths not listed in the table, the refractive index and the extinction coefficient are obtained using linear interpolation or spline interpolation. At least two rows are required for linear interpolation. To form a cubic spline from the table entries, at least four rows are needed.

*   Tabulated values can be read from an external file. The file holds a table that is structured as described in the previous point. The name of the file is specified in the `ComplexRefractiveIndex` section of the parameter file.

# Temperature Dependency

The temperature dependency of the real part of the complex refractive index follows the relation according to:

$$ \Delta n_T = n_0 \cdot C_{n, T} \cdot (T - T_{\text{par}}) \eqno(693) $$

The parameters $C_{n, T}$ and $T_{\text{par}}$ can be adjusted in the `ComplexRefractiveIndex` section of the parameter file (see Table 125 on page 645).

# Carrier Dependency

The change in the real part of the complex refractive index due to free carrier absorption is modeled according to [1]:

$$ \Delta n_{\text{carr}} = -C_{n, \text{carr}} \cdot \frac{q^2 \lambda^2}{8 \pi^2 c^2 \varepsilon_0 n_0} \cdot \left( \frac{n}{m_n} + \frac{p}{m_p} \right) \eqno(694) $$

Complex Refractive Index Model

where:

*   $C_{n, \text{carr}}$ is a fitting parameter.

*   $q$ is the elementary charge.

*   $\lambda$ is the wavelength.

*   $c$ is the speed of light in free space.

*   $\varepsilon_0$ is the permittivity.

Furthermore, $n$ and $p$ are the electron and hole densities, and $m_n$ and $m_p$ are the effective masses of electron and hole, which are computed according to the specification of the `eDOSMass` and `hDOSMass` sections in the parameter file. If only optics is solved, for example `Solve {Optics}` is specified in the command file, then $n$ and $p$ correspond to the respective doping concentrations.

To account for the change of the extinction coefficient due to free carrier absorption, a model is available that assumes linear dependency on carrier concentration and power-law dependency on wavelength:

$$ \Delta k_{\text{carr}} = \frac{10^{-4}}{4\pi} \cdot \left[ \left( \frac{\lambda}{\mu\text{m}} \right)^{\Gamma_{k, \text{carr}, n}} \frac{C_{k, \text{carr}, n}}{\text{cm}^2} \cdot \frac{n}{\text{cm}^{-3}} + \left( \frac{\lambda}{\mu\text{m}} \right)^{\Gamma_{k, \text{carr}, p}} \frac{C_{k, \text{carr}, p}}{\text{cm}^2} \cdot \frac{p}{\text{cm}^{-3}} \right] \text{ (695)} $$

where:

*   $C_{k, \text{carr}, n}$, $C_{k, \text{carr}, p}$, $\Gamma_{k, \text{carr}, n}$, $\Gamma_{k, \text{carr}, p}$ are fitting parameters.

*   $\lambda$ is the wavelength in $\mu\text{m}$.

*   $n$ and $p$ are the electron and hole densities in units of $\text{cm}^{-3}$.

For linear dependency on wavelength, $C_{k, \text{carr}, n}$ and $C_{k, \text{carr}, p}$ are given in units of $\text{cm}^{-2}$.

An alternative formulation found in the literature [[2]]([2])[[3]]([3]) reads as follows:

$$ \Delta\alpha_{\text{FCA}} = An\lambda^B + Cp\lambda^D \text{ (696)} $$

where the free carrier absorption coefficient $\Delta\alpha_{\text{FCA}}$ is given in units of $\text{cm}^{-1}$, the wavelength is given in nanometers, and the carrier concentrations are given in $\text{cm}^{-3}$.

The fitting parameters $A$, $B$, $C$, and $D$ in Eq. 696 are related to the corresponding fitting parameters in Eq. 695 by the following expressions:

$$ \Gamma_{k, \text{carr}, n} = B + 1 \text{ (697)} $$

$$ C_{k, \text{carr}, n} = 10^{3B} A \text{ (698)} $$

21: Optical Generation

Complex Refractive Index Model

$$ \Gamma_{k, \text{ carr, } p} = D + 1 $$ (699)

$$ C_{k, \text{ carr, } p} = 10^{3D} C $$ (700)

You can adjust the parameters $C_{n, \text{ carr}}$, $C_{k, \text{ carr, } n}$, $C_{k, \text{ carr, } p}$, $\Gamma_{k, \text{ carr, } n}$, and $\Gamma_{k, \text{ carr, } p}$ in the `ComplexRefractiveIndex` section of the parameter file (see Table 126 on page 645).

## Gain Dependency

The complex refractive index model offers different formulas to take into account the gain dependency:

*   The linear model is given by $\Delta n_{\text{gain}} = C_{n, \text{ gain}} \cdot \left( \frac{n + p}{2N_{\text{par}}} - 1 \right)$.

*   The logarithmic model reads $\Delta n_{\text{gain}} = C_{n, \text{ gain}} \cdot \ln \left( \frac{n + p}{2N_{\text{par}}} \right)$.

You can adjust the parameters $C_{n, \text{ gain}}$ and $N_{\text{par}}$ in the `ComplexRefractiveIndex` section of the parameter file (see Table 127 on page 646).

You can implement additional complex refractive models with arbitrary dependencies by using the complex refractive index model interface (see Complex Refractive Index Model Interface on page 1322).

# Using Complex Refractive Index

The complex refractive index model is activated by using the `ComplexRefractiveIndex` statement in the `Optics` section of the `Physics` section. When using the unified interface for optical generation computation, `ComplexRefractiveIndex` can be specified globally, per region or per material. Otherwise, support is only available for global specification.

Table 282 on page 1590 lists the available keywords, which allow you to select the dependencies that change the complex refractive index. For example:

```
Physics {
  Optics (
    ComplexRefractiveIndex (
      WavelengthDep (real imag)
      TemperatureDep (real)
      CarrierDep (real imag)
      GainDep (real(log))
      CRIModel (Name=<string>)
```

Complex Refractive Index Model

```
      )
   )
}
```

Table 120 to Table 127 on page 646 summarize all the parameters valid for the `ComplexRefractiveIndex` section of the parameter file. They can be specified for mole-dependent materials using the standard Sentaurus Device technique with linear interpolation on specified mole intervals.

Interpolation for mole-dependent tables is more complex due to the 2D nature of the problem (interpolation with respect to mole fraction and wavelength) and the sharp discontinuities near the absorption edges. Therefore, if `Formula` = 1–3, the complex refractive index at a given wavelength and mole fraction is computed by interpolating its value with respect to the wavelength for the lower and upper limits of the mole-fraction interval and subsequently with respect to the mole fraction. Optionally, the latter interpolation can be linear or piecewise constant. By default, mole-fraction interpolation for `NumericalTable` is switched off, and Sentaurus Device will exit with an error if the complex refractive index is requested at a mole fraction for which no `NumericalTable` is defined.

Table 120 Base parameters

| Symbol | Parameter name | Unit |
| --- | --- | --- |
| n0 | n_0 | 1 |
| k0 | k_0 | 1 |

The keyword `Formula` is used in the parameter file to select one of the available models to describe the wavelength dependency.

Table 121 Model selection for wavelength dependency

| Keyword | Value | Description |
| --- | --- | --- |
| Formula | =0 | Use analytic formula (default). |
| =1 | Read tabulated values from parameter file. |  |
| =2 | Read tabulated values from external file. |  |

Table 122 Parameters used to described wavelength dependency

| Symbol | Parameter name | Unit |
| --- | --- | --- |
| Cn, λ | Cn_lambda | μm−1 |
| Dn, λ | Dn_lambda | μm−2 |
| Ck, λ | Ck_lambda | μm−1 |
| Dk, λ | Dk_lambda | μm−2 |

**21: Optical Generation**
Complex Refractive Index Model

Table 123 lists the different interpolation methods available for `NumericalTable`, where *logarithmic interpolation* refers to taking the natural logarithm of the coordinates, performing linear interpolation, and exponentiating the results.

If a value must be interpolated in an interval where one or both of the coordinates at the interval boundaries is smaller than or equal to zero, linear interpolation is used instead.

Table 123 Specifying interpolation method for NumericalTable

| Keyword | Value | Description |
| --- | --- | --- |
| TableInterpolation | =Linear | Use linear interpolation. |
| =Logarithmic | Use logarithmic interpolation. |  |
| =PositiveSpline | Use cubic spline interpolation. If interpolated values are negative, set them to zero (default). |  |
| =Spline | Use cubic spline interpolation. |  |

Table 124 lists the different interpolation methods available for interpolation of mole fraction–dependent `NumericalTable`.

Table 124 Specifying interpolation method for mole fraction–dependent NumericalTable

| Keyword | Value | Description |
| --- | --- | --- |
| MolefractionTableInterpolation | =Linear |  |
| =Off | Default |  |
| =PiecewiseConstant |  |  |

Table 125 Parameters used to describe temperature dependency

| Symbol | Parameter name | Unit |
| --- | --- | --- |
| $C_{n, T}$ | Cn_temp | K−1 |
| $T_{par}$ | Tpar | K |

Table 126 Parameters used to describe carrier dependency

| Symbol | Parameter name | Unit | Description |
| --- | --- | --- | --- |
| $C_{n, carr}$ | Cn_carr | 1 |  |
| $C_{k, carr, n}, C_{k, carr, p}$ | Ck_carr | cm2 | Values for electrons and holes are separated by a comma. |
| $\Gamma_{k, carr, n}, \Gamma_{k, carr, p}$ | Gamma_k_carr | 1 | Values for electrons and holes are separated by a comma. |

645

Complex Refractive Index Model

Table 127 Parameters used to described gain dependency

| Symbol | Parameter name | Unit |
| --- | --- | --- |
| $C_{n, \text{ gain}}$ | Cn_gain | 1 |
| $N_{\text{par}}$ | Npar | cm–3 |

An example of the `ComplexRefractiveIndex` section in the parameter file is:

```
ComplexRefractiveIndex {
    * Complex refractive index model: n_complex = n + i*k (unitless)
    * Base refractive index and extinction coefficient
    n_0 = 3.45        # [1]
    k_0 = 0.00        # [1]

    * Wavelength dependence
    * Example for analytical formula:
    Formula = 0
    Cn_lambda = 0.0000e+00      # [um^-1]
    Dn_lambda = 0.0000e+00      # [um^-2]
    Ck_lambda = 0.0000e+00      # [um^-1]
    Dk_lambda = 0.0000e+00      # [um^-2]
    * Example for reading values from parameter file:
    Formula = 1
    TableInterpolation = Spline
    NumericalTable
    ( * wavelength [um] n [1] k [1]
     0.30          5.003     4.130;
     0.31          5.010     3.552;
     0.32          5.023     3.259;
     0.33          5.053     3.009;
    )
    * Example for reading values from external file:
    Formula = 2
    NumericalTable = "GaAs.txt"

    * Temperature dependence (real):
    Cn_temp = 2.0000e-04       # [K^-1]
    Tpar = 3.0000e+02          # [K]

    * Carrier dependence (real)
    Cn_carr = 1                         # [1]
    * Carrier dependence (imag)
    Ck_carr = 0.0000e+00 , 0.0000e+00 # [cm^2]

    * Gain dependence (real)
    Cn_gain = 0.0000e+00       # [cm^3]
    Npar = 1.0000e+18          # [cm^-3]
}
```

 21: Optical Generation
Complex Refractive Index Model

The following `ComplexRefractiveIndex` section demonstrates the use of mole fraction–dependent `NumericalTables`:

```
ComplexRefractiveIndex {
  Formula = 1
  TableInterpolation = Linear
  MolefractionTableInterpolation = Linear
  Xmax(0)=0.0
  NumericalTable(0)
  ( * wavelength [um]   n [1]   k [1]
    0.30      5.003      4.130;
    0.31      5.010      3.552;
    0.32      5.023      3.259;
    0.33      5.053      3.009;
  )
  Xmax(1)=0.25
  NumericalTable(1)
  ( * wavelength [um]   n [1]   k [1]
    0.20      5.003      4.130;
    0.29      4.010      2.552;
    0.34      4.023      1.259;
    0.49      4.053      2.009;
  )
  Xmax(2)=0.6
  NumericalTable(2)
  ( * wavelength [um]   n [1]   k [1]
    0.25      3.123      0.130;
    0.27      3.410      0.552;
    0.29      3.523      0.259;
    0.43      3.753      0.009;
  )
}
```

The complex refractive index is plotted when the keyword `ComplexRefractiveIndex` is defined in the `Plot` section.

> **NOTE** `TableODB` is no longer supported. A wavelength table of complex refractive indices can be input using the `ComplexRefractiveIndex` - `NumericalTable` section instead.

The complex refractive index model is available for the following optical solvers:

* Raytracing (see Raytracing on page 648)

* Transfer matrix method for optical generation computation (see Transfer Matrix Method on page 680)

21: Optical Generation
Raytracing

# Raytracing

Sentaurus Device supports the simulation of photogeneration by raytracing in two and three dimensions for arbitrarily shaped structures, as well as body-of-revolution structures using 2D and cylindrical coordinates. The calculation of refraction, transmission, and reflection follows geometric optics, and special boundary conditions can be defined. A dual-grid setup can be used to speed up simulations that include raytracing.

## Raytracer

In Sentaurus Device, the raytracer has been implemented based on linear polarization. It is optimized for speed and needs to be used in conjunction with the complex refractive index model (see Complex Refractive Index Model on page 640). Each region/material must have a complex refractive index section defined in the parameter file. If the refractive index is zero, it is set to a default value of 1.0.

The raytracer uses a recursive algorithm: It starts with a source ray and builds a binary tree that tracks the transmission and reflection of the ray. A reflection/transmission process occurs at interfaces with refractive index differences. This is best illustrated in Figure 31.

Diagram showing an incident ray splitting into reflected and transmitted rays at an interface between two media with refractive indices n1 and n2. The diagram labels the incident, reflected, and transmitted electric field components for both TE and TM polarizations, along with the angles of incidence (θi), reflection (θr), and transmission (θt).

Figure 31 Incident ray splits into reflected and transmitted rays at an interface: the TE component of the polarization vector maintains the same direction, whereas the TM component changes direction

21: Optical Generation

Raytracing

An incident ray impinges on the interface of two different refractive index ($n_1$ and $n_2$) regions, resulting in a reflected ray and a transmitted ray. The incident, reflected, and transmitted rays are denoted by the subscripts $i$, $r$, and $t$, respectively. Likewise, the incident, reflected, and transmitted angles are denoted by $\theta_i$, $\theta_r$, and $\theta_t$, respectively. These angles can be derived from the concept of interface tangential phase-matching (commonly called Snell’s law) using:

$$n_1 \sin \theta_i = n_2 \sin \theta_t \hfill (701)$$

To define these angles, a plane of incidence must be clearly defined. It is apparent that the plane of incidence is the plane that contains both the normal to the interface and the vector of the ray.

When the plane of incidence is defined, the concept of TE and TM polarization can then be established.

A ray can be considered a plane wave traveling in a particular direction with its polarization vector perpendicular to the direction of propagation. The length of the polarization vector represents the amplitude, and the square of its length denotes the intensity. The TE polarization (s-wave) applies to the ray polarization vector component that is perpendicular to the plane of incidence. On the other hand, the TM polarization (p-wave) applies to the ray polarization vector component that is parallel to the plane of incidence.

In Figure 31 on page 648, the TE and TM components of the ray polarization vector are denoted by $E_{\text{TE}}$ and $E_{\text{TM}}$, respectively.

The TE and TM components of the ray polarization vector experience different reflection and transmission coefficients. These coefficients are:

Amplitude reflection coefficients:

$$r_{\text{TE}} = \frac{k_{1z} - k_{2z}}{k_{1z} + k_{2z}} \hfill (702)$$

$$r_{\text{TM}} = \frac{\varepsilon_2 k_{1z} - \varepsilon_1 k_{2z}}{\varepsilon_2 k_{1z} + \varepsilon_1 k_{2z}} \hfill (703)$$

Amplitude transmission coefficients:

$$t_{\text{TE}} = \frac{2k_{1z}}{k_{1z} + k_{2z}} \hfill (704)$$

$$t_{\text{TM}} = \frac{2\varepsilon_2 k_{1z}}{\varepsilon_2 k_{1z} + \varepsilon_1 k_{2z}} \hfill (705)$$

Raytracing

Power reflection coefficients:

$$ R_{\text{TE}} = |r_{\text{TE}}|^2 \tag{706} $$

$$ R_{\text{TM}} = |r_{\text{TM}}|^2 \tag{707} $$

Power transmission coefficients:

$$ T_{\text{TE}} = \frac{k_{2z}}{k_{1z}} |t_{\text{TE}}|^2 \tag{708} $$

$$ T_{\text{TM}} = \frac{\varepsilon_1 k_{2z}}{\varepsilon_2 k_{1z}} |t_{\text{TM}}|^2 \tag{709} $$

where:

$$ k_0 = 2\pi/\lambda_0 \tag{710} $$

$$ k_{1z} = n_1 k_0 \cos \theta_i \tag{711} $$

$$ k_{2z} = n_2 k_0 \cos \theta_t \tag{712} $$

$$ \varepsilon_1 = n_1^2 \tag{713} $$

$$ \varepsilon_2 = n_2^2 \tag{714} $$

where $\lambda_0$ is the free space wavelength, and $k_0$ is the free space wave number. Note that for amplitude coefficients, $1 + r = t$. For power coefficients, $R + T = 1$. These relations can be verified easily by substituting the above definitions of the reflection and transmission coefficients of the respective TE and TM polarizations. For normal incidence when $\theta_i = \theta_t = 0$, $r_{\text{TE}} = -r_{\text{TM}}$, and $R_{\text{TE}} = R_{\text{TM}}$.

If the refractive index is complex, the reflection and transmission coefficients are also complex. In such cases, only the absolute value is taken into account.

The raytracer automatically computes the plane of incidence at each interface, decomposes the polarization vector into TE and TM components, and applies the respective reflection and transmission coefficients to these TE and TM components.

21: Optical Generation

Raytracing

# Ray Photon Absorption and Optical Generation

When there is an imaginary component (extinction coefficient), $\kappa$, to the complex refractive index, absorption of photons occurs. To convert the absorption coefficient to the necessary units, the following formula is used for power/intensity absorption:

$$ \alpha(\lambda)[\text{cm}^{-1}] = \frac{4\pi\kappa}{\lambda} \tag{715} $$

In the complex refractive index model, the refractive index is defined element-wise. In each element, the intensity of the ray is reduced by an exponential factor defined by $\exp(-\alpha L)$ where $L$ is the length of the ray in the element.

Therefore, the photon absorption rate in each element is:

$$ G^{\text{opt}}(x, y, z, t) = I(x, y, z)[1 - e^{-\alpha L}] \tag{716} $$

$I(x, y, z)$ is the rate intensity (units of $\text{s}^{-1}$) of the ray in the element. After all of the photon absorptions in the elements have been computed, the values are interpolated onto the neighboring vertices and are divided by its sustaining volume to obtain the final units of $\text{s}^{-1} \cdot \text{cm}^{-3}$. The absorption of photons occurs in all materials (including nonsemiconductor) with a positive extinction coefficient for raytracing. Depending on the quantum yield (see Quantum Yield Models on page 603), a fraction of this value is added to the carrier continuity equation as a generation rate so that correct accounting of particles is maintained.

# Using the Raytracer

The raytracer must be invoked within the unified interface for optical generation computation (see Raytracing on page 616) and can have the following options:

* Raytracing used in simple optical generation

* Monte Carlo raytracing

* Multithreading for raytracing

* Compact memory model for raytracing

* User-defined and distribution windows of starting rays

* Cylindrical coordinates for raytracing

* Different boundary conditions for raytracing

* Visualizing raytracing results

Raytracing

Optical generation by raytracing is activated by the `RayTracing` statement in the `Physics` section. An example of optical generation by raytracing is:

```
 Plot {...
  RayTrees
 }

 Physics {...
  Optics (
   ComplexRefractiveIndex(
    WavelengthDep(real imag)
    CarrierDep(real imag)
    GainDep(real)                      * or real(log)
    TemperatureDep(real)
    CRImodel (Name = "crimodelname")
   )
   OpticalGeneration(...)
   Excitation (...
    PolarizationAngle = 45             * deg
    Wavelength         = 0.5           * um
    Intensity          = 0.1           * W/cm2
    Window(
             Rectangle(dx = 1, dy = 2)
             IntensityDistribution(...)
    )
   )
   OpticalSolver (
    RayTracing(
             RayDistribution(...)
             MonteCarlo
             CompactMemoryOption     * reduced memory consumption
             MinIntensity = 1e-3     * fraction of start intensity to stop ray
             UseAverageMinIntensity * use average intensity of all starting rays
                                     * as reference for MinIntensity
             DepthLimit = 1000       * maximum number of interfaces to pass
             RetraceCRIchange = 0.1 * fractional change of CRI to retrace
    )
   )
  )
 }
```

The complex refractive index model must be used in conjunction with the raytracer. Various dependencies of the complex refractive index can be included, and they are controlled by parameters in the `ComplexRefractiveIndex` section of the parameter file (see Complex Refractive Index Model on page 640). The CRI model can be defined regionwise or materialwise.

**21: Optical Generation**
Raytracing

The keyword `RetraceCRIchange` specifies the fractional change of the complex refractive index (either the real or imaginary part) from its previous state that will force a total recomputation of raytracing. To force retracing at every ramping point, you can set `RetraceCRIchange` to a negative number.

The starting rays are defined by a rectangular window or a user-defined window (see Window of Starting Rays on page 655).

# Terminating Raytracing

Raytracing offers different termination conditions:

*   Raytracing is terminated if the ray intensity becomes less than $n$ times (`MinIntensity` specifies $n$) the original intensity of each starting ray.

*   `DepthLimit` specifies the maximum number of material boundaries that the ray can pass through.

*   `UseAverageMinIntensity` activates the computation of an average value of all the starting rays, $I_{avg}$, and raytracing terminates when the ray intensity becomes less than $I_{avg} \times \text{MinIntensity}$. This is only useful with the spatial intensity excitation profile (see Spatial Intensity Function Excitation on page 630).

# Monte Carlo Raytracing

In instances where rays are randomly scattered, for example on rough surfaces, a Monte Carlo–type raytracing is required, since you need to look at the aggregate solution of the raytracing process.

The concept of Monte Carlo raytracing follows that of the Monte Carlo method for carrier transport simulation. Suppose a ray impinges an interface. In the deterministic framework, the ray will split into a reflected part and a transmitted part at this interface. In the Monte Carlo framework, you track only one ray path and take the reflectivity as a probability constraint to decide if the ray is to be reflected or transmitted. As more rays impinge this material interface, the aggregate number of reflected rays will recover information about the reflectivity, and this is the crux of the Monte Carlo method. In a likewise manner, rough surface scattering gives an angular probability and, using the same strategy, the ensemble average of rays can model the physics of rough surface scattering.

As an example, the algorithm for the Monte Carlo raytracing at a regular material interface is:

*   Compute the reflection and transmission coefficients, $R$ and $T$, of the ray at the material interface.

*   Generate a random number, $r$.

Raytracing

*   If $r \le R$, then choose to propagate the reflected ray only.

*   If $r > R$, then choose to propagate the transmitted ray only.

In the case of special rays, such as those from the raytrace PMI, care must be taken to choose only a single propagating ray based on a new set of probabilistic rules.

The Monte Carlo raytracing has been implemented in both general raytracing and LED raytracing. The syntax is:

```
Physics {
  Optics (
    OpticalSolver (
      RayTracing (
        MonteCarlo
      )
    )
  )
}
```

**NOTE** Since only one ray path is chosen at each scattering event in the Monte Carlo method, the rays in the raytree will appear to have the same intensity values after scattering.

# Multithreading for Raytracer

Each raytree traced from the list of starting rays is mutually exclusive, so that the raytracer is an excellent candidate for parallelization.

To activate the multithreading capability of the raytracer, include the following syntax in the Math section of the command file:

```
Math {
  Number_Of_Threads = 2    # or maximum
  StackSize = 20000000     # increase to, for example, 20 MB
}
```

**NOTE** Raytracing is a recursive process, so it can easily obliterate the default (1 MB) stack space if the level of the raytree becomes increasingly deep. This might lead to unexplained segmentation faults or termination of the program. To resolve this issue, increase the stack space using the keyword `StackSize` in the `Math` section as shown in the syntax. The other solution is to use the compact memory model as described next.

21: Optical Generation
Raytracing

# Compact Memory Model for Raytracer

The compact memory model for the raytracer does not store the raytree as it is being created, so it reduces the use of significant memory. Only essential information is tracked and stored, and this alleviates the amount of memory required. A reduced structure is used, and clever ways of extracting information in this reduced structure have been implemented without upsetting the multithreading feature of raytracing.

The compact memory model is activated as the default only for the unified interface for optical generation computation. The default is still switched off for the LED raytracing interface. A minus sign can be added in front of the keyword to deactivate it. If raytrees are requested to be plotted in the `Plot` statement, the compact memory model is switched off automatically, and a warning message appears in the log file to alert you of the changes. The command file syntax to switch off the compact memory option is:

```
Physics {...
  Optics( OpticalSolver(...
    RayTracing (
      -CompactMemoryOption
    )
  ))
}
```

# Window of Starting Rays

Two mutually exclusive options for defining a set of starting rays are available: a user-defined set of rays or a distribution window. You can define these in the `Physics-Optics-OpticalSolver-Raytracing` statement syntax:

```
UserWindow (
  NumberOfRays = integer                  # number of rays in file
  RaysFromFile = "filename.txt"           # position(um) direction area(cm^2)
  PolarizationVector = Random | ReadFromExcitation | ReadFromFile
)

RayDistribution (WindowName= "windowname1" ...)
```

**NOTE** The initial positions of starting rays must not be defined too close to or exactly on a vertex, an edge, a face, or an interface because the raytracer needs to determine the starting region of the rays.

21: Optical Generation

Raytracing

# User-Defined Window of Rays

In the `UserWindow` section, you can enter your own set of starting rays using a text file. This means that you can choose the positions, directions, area, and polarization vector of each starting ray, thereby achieving greater flexibility.

The power (W) of each ray then is computed by multiplying the input area (cm<sup>2</sup> in 3D or cylindrical simulations, and cm in 2D simulations) by the input wave power (W/cm<sup>2</sup>). Remarks are allowed but they must begin with a hash character (#). A sample of this file for 3D rays is:

```
filename.txt:
# Position(x,y,z)[um]  Direction(x,y,z)[um]  Area[cm^2] Polarization(x,y,z)
0.0     0.0     0.0     0.0     0.0     1.0     1.0e-5     1 0 0
0.0     0.05    0.0     0.0     0.0     1.0     1.0e-5     0 1 0
0.0     0.05    0.05    0.0     0.0     1.0     1.0e-5     0 1 0
...
```

> **NOTE** In 2D simulations, you must input the `Area` as a segment length (in cm). Consistent with 2D Sentaurus Device simulations, the third dimension is taken to be a default of 1 μm, which means that the actual area for each user ray is the user `Area` [cm] multiplied by 1 μm.

Different types of `PolarizationVector` can be chosen:

*   **Random**: A random vector perpendicular to the ray direction is generated. In two dimensions, the generated random vector can be a 3D vector.

*   **ReadFromFile**: The polarization vector is entered as the last three columns in the file.

*   **ReadFromExcitation**: The polarization vector is constructed based on the information contained within the `Excitation` section. This is the default if the keyword `PolarizationVector` is omitted. The priority order for reading the polarization under this option is:

1. `OpticalSolver - RayTracing - PolarizationVector= (<float> <float> <float>)`
2. `OpticalSolver - RayTracing - PolarizationRandom`
3. `Excitation - PolarizationAngle= <float>`
4. `Excitation - Polarization= TE | TM | <float>`

If none of these options is found, `Excitation - PolarizationAngle=0` is used by default.

> **NOTE** If `PolarizationVector` is set to `ReadFromExcitation` or `Random`, then the last three columns of the file that describe polarization are ignored.

In 2D simulations, the TE polarization vector is (0,0,1) and the TM polarization vector is formed by the cross product of the ray's direction vector and (0,0,1), with reference to Figure 31 on page 648.

21: Optical Generation
Raytracing

Table 128 Requirements for the parameters in the input file for the user ray

| Parameter | 2D simulation | Cylindrical simulation | 3D simulation |
| --- | --- | --- | --- |
| Position [ μm ] | (x,y,0) | (x,y,0) | (x,y,z) |
| Direction | (x,y,0) | (x,y,0) | (x,y,z) |
| Units of user input Area | cm (internally will be multiplied by 1 μm ) | cm2 | cm2 |
| Polarization vector (ReadFromFile only) | (x,y,z) | (x,y,z) | (x,y,z) |

# Distribution Window of Rays

When the illumination window (see Illumination Window on page 622) is defined for raytracing, a corresponding RayDistribution section must be created to define how the excitation parameters can be translated in a raytracing context:

```
Physics {
  Optics (
    Excitation(
      Window ("windowname1") (
        Origin = (xx,yy)
        OriginAnchor = Center | North | South | East | West | NorthEast |
          SouthEast | NorthWest | SouthWest
        RotationAngles = (phi, theta, psi)
        xDirection = (x,y,z)
        yDirection = (x,y,z)
        # You can define one of the following excitation shapes.
        # Rectangle, Circle, and Polygon are for three dimensions.
        Rectangle( ... )
        Line( ... )
        Circle( ... )
        Polygon( ... )
      )
      Window ("windowname2") (...)
      Window ("windowname3") (...)
    )
    OpticalSolver(
      Raytracing(
        RayDistribution(
          WindowName = "windowname1"
          Mode = Equidistant | MonteCarlo | AutoPopulate
          NumberOfRays = integer    # for Mode=MonteCarlo | AutoPopulate
          Dx = float                # for Mode=Equidistant
          Dy = float                # for Mode=Equidistant
          Scaling = float           # scaling factor
        )
      )
    )
  )
}
```

Raytracing

```
            RayDistribution (WindowName="windowname2" ...)
            RayDistribution (WindowName="windowname3" ...)
        )
      )
    )
}
```

Multiple excitation windows and `RayDistribution` windows can be created. The only restriction is that every `RayDistribution` section must have a matching `Excitation` section. Matching is through the user-specified window name. If no window name for the `RayDistribution` section is specified, the parameters in that window are applied to all excitation windows, except those with matching window names.

The shape of the excitation is defined in the `Excitation(...Window(...))` section, and the shape can be a `Line` for two dimensions, and a `Rectangle`, `Circle`, or `Polygon` for three dimensions.

There are different ways in which you can create a set of starting rays on the excitation shape:

* **Mode=Equidistant**: The starting positions of the rays are arranged in a regular grid with intervals defined by `Dx` and `Dy`. Then, the grid is superimposed onto the excitation shape to extract an appropriate set of starting rays.

* **Mode=MonteCarlo**: Random positions are generated with the excitation shape to form the set of starting rays.

* **Mode=AutoPopulate**: A uniform grid of variable grid size is superimposed onto the excitation shape. The grid size is varied until the maximum possible number of grid points that is less than `NumberOfRays` can be fitted into the shape, and the set of starting ray positions is extracted from the fitted grid vertices.

---

# Cylindrical Coordinates for Raytracing

Body-of-revolution structures can be modeled optically in raytracing by tracing the rays in the 2D cut of the cylindrical structure and taking into account the reflection at the cylindrical axis and the ring volume of revolution.

To model body-of-revolution structures with raytracing:

1. Switch on the cylindrical coordinates in the `Math` section, and specify the location of the cylindrical axis. You can use either the keyword `xAxis` to specify the revolution around the y-axis (`xAxis=<float>`) or the keyword `yAxis` to specify the revolution around the x-axis (`yAxis=<float>`). The syntax is:

```
Math { ...
  Cylindrical(xAxis=<float>)     # default is xAxis=0
}
```

21: Optical Generation

Raytracing

2. Define the illumination window appropriately, so that it lies on the same side as the device from the cylindrical axis, and both the window and device do not intersect the cylindrical axis.

3. There is no need to define any special reflecting boundary at the cylindrical axis. Sentaurus Device automatically creates an internal virtual reflecting boundary at the cylindrical axis so that any rays impinging it will be reflected.

4. The `RayDistribution` illumination window supports cylindrical coordinates. All methods of generating cylindrical starting rays are possible: `AutoPopulate`, `Equidistant`, and `MonteCarlo`. If the Gaussian spatial intensity is specified, the Gaussian shape is superimposed on the cylindrical ring-area weighted power of each starting ray, only for the `AutoPopulate` and `Equidistant` options. There is no support for the Gaussian spatial intensity and cylindrical `MonteCarlo` starting rays.

5. The illumination window can be at a skewed angle from the cylindrical axis, as shown in Figure 32.

Diagram showing an illumination window subtended at an angle θ from the cylindrical axis, with radii r1 and r2, and height h, forming an area of strip revolved around the cylindrical axis.

Figure 32 An illumination window subtended at an angle θ from the cylindrical axis, forming a conical surface of revolution

Assuming that the angle subtended between the illumination window and the cylindrical axis is θ, the conical ring area of revolution is:

$$ \text{Area} = \pi(r_1 + r_2)(r_2 - r_1)\frac{1}{\sin\theta} \hfill (717) $$

This area is multiplied to each starting ray to retrieve the power carried by it. As a check, when θ = 90°, Eq. 717 reduces to that of a ring area.

**21: Optical Generation**
Raytracing

# Boundary Condition for Raytracing

Special and spatially arbitrary boundary conditions can be specified in raytracing. There are two ways to define a boundary condition (BC) for raytracing by:

*   Using special contacts.

    In the contact-based definition, the boundaries are drawn as contacts (see Specifying Electrical Boundary Conditions on page 67) and are labeled accordingly using Sentaurus Structure Editor. These contacts can be constructed specifically for setting a raytrace boundary condition, or they can coincide with an electrode or a thermode. To define clearly special raytrace boundary conditions, each line or surface contact defined must have a distinct name. This means that two parallel contacts must have different contact names, and intersecting contacts must also have different contact names. The contact is discretized into edges (2D) or faces (3D) after meshing.

*   Using `Physics MaterialInterface` or `Physics RegionInterface`.

    In the `Physics MaterialInterface`–based or the `Physics RegionInterface`–based definition, the boundaries are defined at the interface between the material or region. As with typical Sentaurus Device operation, `RegionInterface` takes precedence over `MaterialInterface`. After meshing, the interface is discretized into edges (two dimensions) or faces (three dimensions).

A mixture of contact-based and physics interface definitions of BCs is allowed. However, the contact-based definition takes precedence over the physics interface–based definition if there is an overlap.

Each edge or face defined as a special contact can only associate itself to one type of boundary condition. The following boundary conditions are listed in the order of preference, that is, if two boundary conditions are specified for the same edge or face, the higher ranked one is chosen:

1. Fresnel BC

2. Constant reflectivity/transmittivity BC

3. Raytrace PMI BC

4. Multilayer antireflective coating BC

5. Diffuse surface BC, implemented as an installed PMI

6. Periodic BC

21: Optical Generation
Raytracing

## Fresnel Boundary Condition

The physics interface–based BC can quickly set many interfaces to a particular type of BC, especially if the material interface contains many region interfaces. What is missing is the disabling of a particular region interface from the general BC definition. Therefore, the Fresnel BC is introduced as a complement set to unset a particular region interface-based or contact-based BC. This can greatly simplify the command syntax input and enhance ease of use.

Furthermore, the Fresnel BC also can be used to sense the photon flux flowing through a particular interface when users activate the `PlotInterfaceFlux` feature (see Plotting Interface Flux on page 673).

The syntax for activating the Fresnel BC is:

```
RayTraceBC {                       Physics(RegionInterface="reg1/reg2") {
  { Name = "contact1"                RaytraceBC (
      Fresnel                          Fresnel
  }                                  )
}                                  }
```

## Constant Reflectivity and Transmittivity Boundary Condition

In the command file, constant reflectivity and transmittivity boundaries must be specified by the following syntax:

```
RayTraceBC {                       Physics (RegionInterface="regionname1/regionname2") {
  { Name = "ref_contact1"            RayTraceBC (
      Reflectivity = float             Reflectivity = float
  }                                    Transmittivity = float
  { Name = "ref_contact2"            )
      Reflectivity = float         }
      Transmittivity = float
  }
  ...
}
```

These are power reflection, $R$, and transmission, $T$, coefficients. It is not necessary for $R + T = 1$. If $R$ is specified only, $T = 1 - R$. If $T$ is specified only, $R = 1 - T$.

For total absorbing or radiative boundary conditions, set `Reflectivity=0` and `Transmittivity=0` (or `Transmittivity=1`). Defining `Reflectivity=1` ensures that rays are totally reflected at that boundary. In the 2D case, reflection occurs at the edge of the element. In the 3D case, reflection occurs at the face of the element. This versatile boundary condition feature enables you to use symmetry to reduce the simulation domain.

661

Raytracing

Examples of the boundary condition whereby `Reflectivity` has been set to 1.0 are shown in Figure 33 and Figure 34. In the 2D case, a star boundary is drawn within a device; in the 3D case, a rectangular boundary is drawn within the device.

2D LED device mesh with star boundary

Raytracing simulation in 2D LED with star boundary

Figure 33 Applying the reflecting boundary condition in a 2D LED simulation; the boundary is drawn as a star inside the device

3D LED device mesh with rectangular boundary

Raytracing simulation in 3D LED with rectangular waveguide boundary

Figure 34 Applying the reflecting boundary condition in a 3D LED simulation; the boundary is drawn as a hollow rectangular waveguide inside the device

## Raytrace PMI Boundary Condition

A special raytrace PMI BC can be defined. You can obtain useful information about the ray with this raytrace PMI and can modify some parameters of the ray. For details about this PMI and how it can be incorporated into the simulation, see Preprocessing for Newton Iterations and Newton Step Control on page 1411.

21: Optical Generation

Raytracing

As with the standard PMI, you can create a PMI section in the parameter file where you can initialize the parameters of the PMI. Note that the parameter must be specified either regionwise or material-wise in accordance to the standard PMI framework.

To activate the PMI, specify the location of the PMI BC and include the following syntax in the RayTraceBC section of the command file:

```
RayTraceBC {...                         Physics (MaterialInterface="materialname1/materialname2") {
  { Name = "pmi_contact"                  RayTraceBC (
      PMIModel = "pmi_modelname"            pmiModel = "modelname"
  }                                       )
}                                       }
```

**NOTE** Care must be taken to ensure that your PMI code is thread safe since the raytracing algorithm is multithreaded. Use only local variables and avoid global variables in your PMI code (see Parallelization on page 1191).

## Thin-Layer-Stack Boundary Condition

A thin-layer-stack boundary condition can be used to model interference effects in raytracing. The modeling of antireflective coatings used in solar cells is a typical example of the use of such boundary condition. The coatings are specified as special contacts and are treated as a boundary condition for the raytracer. The angle at which the ray is incident on the coating is passed as input to the TMM solver (the theory is described in Transfer Matrix Method on page 680), which returns the reflectance, transmittance, and absorbance for both parallel and perpendicular polarizations to the raytracer. The angle of refraction is calculated by the raytracer according to Snell’s law, a direct implication of phase matching. This boundary condition is available for both 2D and 3D simulations.

The following command file excerpt, along with its demonstration in Figure 35 on page 664, shows the use of this boundary condition:

```
RayTraceBC {                                Physics (MaterialInterface="Gas/Silicon") {
  { Name="rayContact1" reflectivity=1.0 }     RayTraceBC (
  { Name="rayContact2"                          TMM (
      ReferenceMaterial = "Gas"                   ReferenceMaterial = "Gas"
      LayerStructure {                            LayerStructure {
        70e-3 "Nitride"; # um                       70e-3 "Nitride"; # um
        6e-3 "Oxide"     # um                       6e-3 "Oxide";    # um
      }                                           }
    }                                           )
  }                                           )
}                                           }
```

Raytracing

The first line in the `RayTraceBC` section above shows the definition of a constant reflectivity as a boundary condition (see Fresnel Boundary Condition on page 661). This option is usually chosen for the boundary of the simulation domain.

The other section defines a multilayer structure, for which the corresponding contact (`rayContact2`) in the grid file can be seen as a placeholder. Alternatively, you can use the `Physics` interface method of specifying such a special BC (as shown in the above syntax to the right). For each layer, the corresponding thickness ([$\mu$m]) and material name must be specified. For the calculation of transmittance and reflectance, the transfer matrix method reads the complex refractive index from the respective parameter file. An additional parameter file or a new set of parameters must be added by you in either of the following cases: (a) a layer contains a material that does not exist in the grid file or (b) the material properties of a layer differ from the properties of a region in the grid file with the same material.

Illustration of thin-layer-stack boundary condition showing Gas, Nitride, Oxide, and Silicon layers with rayContact1 and rayContact2

Figure 35 Illustration of thin-layer-stack boundary condition for simulation of an antireflection-coated solar cell

To fix the orientation of the multilayer structure with respect to the specified contact in the grid file, a `ReferenceMaterial` or a `ReferenceRegion` that is adjacent to the contact must be specified. The topmost entry of the `LayerStructure` table corresponds to the layer that is adjacent to the `ReferenceMaterial` or `ReferenceRegion`.

**NOTE** You can only specify a `ReferenceMaterial` or `ReferenceRegion` if the material names or region names, respectively, on either side of the contact *do not coincide*.

The multilayer structure is allowed to have an arbitrary number of layers.

## TMM Optical Generation in Raytracer

In modern thin-film solar-cell design, the multilayer thin film can be made of materials that can generate carriers by absorbing photons. To cater to such a phenomenon, the TMM contact in

21: Optical Generation

Raytracing

the raytracer has been modified to collect optical generations as rays traverse the TMM contact. The collected optical generations can then be distributed into specific regions of the electrical grid.

In addition, to model the correct optical geometry, the thin-film layers must be drawn into the device structure. However, the raytracer treats the physics of thin film using a TMM contact, and these thin layers should effectively be ignored during the raytracing process. As such, you need to use `VirtualRegions` (see Virtual Regions in Raytracer on page 669) to ignore these thin layers in the raytracing process. The required syntax is:

```
RayTraceBC {...                                   Physics (RegionInterface="regionname1/
  { Name="TMMcontact"                             regionname2") {
       ReferenceMaterial = "Gas"                    RayTraceBC (
       LayerStructure {...}                          TMM (
       MapOptGenToRegions {"thinlayer1"               ReferenceMaterial = "Gas"
                         "thinlayer2" ...}            LayerStructure {...}
       QuantumEfficiency = float                      MapOptGenToRegions {"thinlayer1"
  }                                                                    "thinlayer2" ...}
}                                                     QuantumEfficiency = float
                                                     )
                                                    )
                                                   }

     Physics {...
            Optics(...
             OpticalSolver(
              RayTracing (...
               VirtualRegions{"toppml" "nitride" "oxide" ...}
              )
             )
            )
     }
```

A few comments about the syntax:

*   **QuantumEfficiency** denotes the fraction of absorbed photons in the TMM BC that will be converted to optical generation. The keyword `QuantumYield` also can be specified in the unified raytracing interface. Therefore, the overall quantum yield of the TMM BC is a product of `QuantumEfficiency` and `QuantumYield`.

*   The region names in the `MapOptGenToRegion` section refer to regions in the electrical device grid. The `MapOptGenToRegions{...}` list and `VirtualRegions{...}` list are independent, and there is no need for a one-to-one correspondence. For example, you can have `VirtualRegions{r1,r2,r3}` and `MapOptGenToRegions{r2,r4}` whereby the entire optical generation from a TMM BC will be mapped onto regions `r2` and `r4` according to their volume ratio. The order of the region list is not relevant.

Raytracing

* For the optical generation mapping, a constant optical generation profile is assumed. The optical generation from a TMM BC is lumped into a constant value and distributed to different `MapOptGenToRegions` regions according to their volume ratios.

* The region names in the `VirtualRegions` section refer to regions in the optical device grid.

## Diffuse Surface Boundary Condition

Rough surfaces can be modeled by diffuse surface boundary conditions. The available diffuse BC models are:

* Phong scattering model with distribution:

$$I/I_0 = \cos^\omega(\alpha + \gamma) \hfill (718)$$

where $\omega$ is the order of the Phong model, $\alpha$ is the scattered angle with respect to the scattering surface, and $\gamma$ is an offset angle for the lobe of the distribution.

* Lambert scattering model with distribution:

$$I/I_0 = \cos(\alpha + \gamma) \hfill (719)$$

**NOTE** The Lambert scattering model is a special case of the Phong model.

* Gaussian scattering model with distribution:

$$I/I_0 = \exp\left(-\frac{(\alpha + \gamma)^2}{2\sigma^2}\right) \hfill (720)$$

where $\sigma^2$ is the variance of the distribution.

* Random scattering model with uniform distribution

Within Sentaurus Device, a random number $x \in [0, 1]$ is generated, and a mapping function is used to compute the scattering angle $\alpha$. The mapping function is computed as follows.

The random number $x \in [0, 1]$ has a uniform distribution such that:

$$\int_0^1 f(x)dx = 1 \hfill (721)$$

The scattering angle $\alpha \in [0, \pi/2]$ has a distribution function, $p(\alpha)$, which can be the Phong, Lambert, or Gaussian model.

21: Optical Generation
Raytracing

# 3D Case

The mapping requirement is:

$$ p(\alpha) 2\pi R \sin \alpha d\alpha = f(x)dx $$ (722)

and the normalization requirement is:

$$ \int_{0}^{\pi/2} 2\pi R p(\alpha) \sin \alpha d\alpha = 1 $$ (723)

# 2D Case

The mapping requirement is:

$$ p(\alpha) R d\alpha = f(x)dx $$ (724)

and the normalization requirement is:

$$ \int_{0}^{\pi/2} p(\alpha) R d\alpha = 1 $$ (725)

For the different scattering models, $R$ must be derived based on the normalization conditions for 2D and 3D, respectively.

To find the inverse mapping of the random variable $x$ to $\alpha$, the integration of the probability density functions to $\alpha$ and $x$ is performed, respectively:

$$ \int_{0}^{\alpha} 2\pi R p(\alpha) \sin \alpha d\alpha = x \text{ for 3D} $$ (726)

$$ \int_{0}^{\alpha} p(\alpha) R d\alpha = x \text{ for 2D} $$ (727)

Then, the objective would be to express $\alpha$ as a function of $x$. As an example, the inverse mapping function for the 3D Phong model is:

$$ \alpha = \cos^{-1} [\sqrt[\omega+1]{1-x}] $$ (728)

The inverse mapping functions of the other scattering models can be derived in a similar way.

Raytracing

The diffuse surface BC has been implemented as an installed PMI and can be invoked by including the following syntax in the Sentaurus Device command file:

```
RayTraceBC {                                  Physics(RegionInterface="region1/region2") {
  { Name = "rough_contact"                      RayTraceBC (
      PMImodel = pmi_rtDiffuseBC ( ... )          PMImodel = pmi_rtDiffuseBC ( ... )
  }                                             )
}                                             }
```

where ... stands for the following scattering model parameters:

```
model = "Phong"                             # "Lambert", "Random", "Gaussian"
phong_w = 200                               # w parameter of Phong model
gaussian_sigma = 0.1                        # sigma parameter of Gaussian model
set_randomseed = 123                        # 0 to 10000, or -1=do not set
debug = 0                                   # 1=print debug message, 0=do not print,
                                            # 99999 = interactive debug
ReflectionTransmissionTable = "wavelengthRTtable.txt" # file input
pdfDimension = 2                            # dimension of probability density function
reflectivity = 0.0                          # reflectivity of rough surface
transmittivity = 1.0                        # transmittivity of rough surface
```

Some comments about the parameter settings:

* You can set the specific reflectivity and transmittivity of the diffusive surface. However, if you still want to use the original reflectivity and transmittivity computed from the adjoining regions, set `reflectivity=-1` and `transmittivity=-1`.

* Setting a random seed allows for reproducibility of the simulation results.

* A useful `debug` option is included to ensure that the correct distribution is obtained.

* You can include the content of the "wavelengthRTtable.txt" file that contains a table of three columns: wavelength ($\mu$m), reflectivity, and transmittivity. These are power reflectivity and transmittivity values, and enable the reflectivities and transmittivities of the specific diffuse boundary to change according to the wavelength.

* The `pdfDimension` refers to the dimension of the probability density function (PDF), and this can be chosen to be different from the dimension of the device. If this keyword is not included, the `pdfDimension` is set to the dimension of the device.

> **NOTE** Instead of specifying the PMI parameters in the command file, you also can define them in the parameter file. To do so, in the command file, in the RayTraceBC section, set `PMIModel= "pmi_rtDiffuseBC"`. In the material parameter file, add a section `pmi_rtDiffuseBC{...}`, where `{...}` corresponds to the scattering model parameters as previously described.

21: Optical Generation

Raytracing

# Periodic Boundary Condition

The periodic boundaries are limited to parallel X-, Y-, or Z-surfaces, so the device must have parallel surfaces in the direction of the periodicity. No special raytrace contacts need to be drawn onto the device, and you only need to specify the following syntax:

```
RayTraceBC {
 { Side="X" Periodic }
 { Side="Y" Periodic }
 { Side="Z" Periodic }
}
```

These periodic specifications are mutually exclusive, so you can specify a combination of any of them.

When the `PlotInterfaceFlux` feature (see Plotting Interface Flux on page 673) is activated, the corresponding entries describing the periodic fluxes are output to the plot file:

```
PeriodicFlux
 Xmin.FluxIn(region_name1)
 Xmin.FluxOut(region_name1)
 Xmax.FluxIn(region_name2)
 Xmax.FluxOut(region_name2)
 Ymin.FluxIn(region_name3)
 Ymin.FluxOut(region_name3)
 Ymax.FluxIn(region_name4)
 Ymax.FluxOut(region_name4)
 Zmin.FluxIn(region_name5)
 Zmin.FluxOut(region_name5)
 Zmax.FluxIn(region_name6)
 Zmax.FluxOut(region_name6)
```

**NOTE** Only those regions that contain any of the periodic BCs will be included in the list.

# Virtual Regions in Raytracer

This feature is a prelude to the TMM optical generation in the raytracer feature. Virtual regions can be defined in the raytracer such that rays ignore the presence of these regions during the raytracing process. In other words, when rays enter or leave a virtual region, no reflection or refraction occurs, and the ray is transmitted without change. This allows for additional flexibility in dual-grid simulations where some regions are important for electrical transport but insignificant for optics.

Raytracing

The syntax is:

```
Physics {...
  Optics(...
    OpticalSolver(
      RayTracing (...
        VirtualRegions{"nitride" "oxide" "layer555" ...}
      )
    )
  )
}
```

## External Material in Raytracer

The default material surrounding a device is assumed to be air. In many cases, especially in LEDs, the device can be immersed in another material such as epoxy or some kind of phosphor. To correctly account for the directional, reflectivity, and transmittivity changes caused by such external material, a user-defined file of wavelength-dependent complex refractive indices can be entered. The syntax is:

```
Physics {
  Optics (
    OpticalSolver (
      Raytracing (
        ExternalMaterialCRIFile = "string"
      )
    )
  )
}
```

The external material CRI file should contain three columns: wavelength ($\mu$m), n, and k. A hash sign (#) is used to precede remarks. If the keyword `ExternalMaterialCRIFile` is not specified, the external medium is taken to be air with refractive index of 1.0.

## Additional Options for Raytracing

Additional options allow better control of raytracing in Sentaurus Device:

* Omitting reflected rays when performing raytracing

* Omitting weaker rays when performing raytracing

21: Optical Generation
Raytracing

The syntax for these options is:

```
Physics { ...
  Optics(...
    OpticalSolver(
      RayTracing (
        OmitReflectedRays
        OmitWeakerRays
      )
    )
  )
}
```

# Redistributing Power of Stopped Rays

**NOTE** This feature applies to LED raytracing. It does not work with Monte Carlo raytracing due to the fundamental assumption of the Monte Carlo method.

When raytracing terminates at a designated `DepthLimit` or `MinIntensity` value, there is still leftover power in those terminated rays. The sum of the powers contained in all these stopped rays can be redistributed into the raytree. The total power of the rays is:

$$ P_{\text{Total}} = P_{\text{abs}} + P_{\text{escape}} + P_{\text{stopped}} $$ (729)

where $P_{\text{abs}}$ is the absorbed power, $P_{\text{escape}}$ is the power of the escaped rays (out of the device), and $P_{\text{stopped}}$ is the power of the rays terminated by the `DepthLimit` or `MinIntensity` condition.

Rearranging Eq. 729, the following expression is obtained:

$$ P_{\text{Total}} = \frac{1}{\left( 1 - \frac{P_{\text{stopped}}}{P_{\text{Total}}} \right)} (P_{\text{abs}} + P_{\text{escape}}) $$ (730)

Therefore, by multiplying a redistribution factor to $P_{\text{abs}}$ and $P_{\text{escape}}$, the leftover power in the stopped rays can be accounted for. The syntax is:

```
Physics {...
  Optics(...
    OpticalSolver(
      RayTracing (...
        RedistributeStoppedRays
      )
    )
  )
}
```

21: Optical Generation

Raytracing

# Weighted Interpolation for Raytrace Optical Generation

In raytracing, first optical absorption is computed elementwise, and then it is distributed evenly onto the associated vertices of the element. However, as a ray traverses an element, it can be closer to one particular corner or vertex of the element, in which case, distributing the optical absorption evenly onto all vertices of the element does not give a true picture. A better approximation is to use a weighted interpolation approach to distribute the optical absorption to vertices that are nearer to the center of each ray that traverses the element. The ray center is defined as the midpoint of the ray with respect to the optical absorption. This will improve the representation and accuracy of optical absorption profiles, and reduce the dependency on mesh size. The syntax is:

```
Physics{
  Optics(
    OpticalSolver(
      Raytracing(
        WeightedOpticalGeneration
      )
    )
  )
}
```

# Visualizing Raytracing

The keyword `RayTrees` can be set in the `Plot` section to visualize raytracing using the TDR format. Thereby, an additional geometry is added to the plot file representing the ray paths. The following datasets are available for each ray element:

*   Depth: Number of material boundaries that the ray has passed through

*   Intensity: Ray intensity

*   Transmitted (Boolean): True, as long as the ray is transmitted

**NOTE** `RayTrees` cannot be plotted with the compact memory option.

# Reporting Various Powers in Raytracing

Various powers are reported in the log file after a raytracing event, and the format is as follows:

```
Summary of RayTrace Total Photons and Powers:
               Input          Escaped       StoppedMinInt  StoppedDepth  AbsorbedBulk  AbsorbedBC
 Photons [#/s]: 4.531E+11     1.333E+11     4.142E+07      0.000E+00     6.236E+10     2.574E+11
 Powers [W]:   3.000E-07      8.826E-08     2.743E-11      0.000E+00     4.129E-08     1.704E-07
```

21: Optical Generation

Raytracing

A brief summary of these powers is:

*   Input power is computed by multiplying the input wave power (units of W/cm<sup>2</sup>) by the rectangular or circular window area where the starting rays have been defined.

*   In two dimensions, the length in the third dimension is taken as 1 μm, conforming to the rest of the Sentaurus Device 2D treatment. The total input power listed should correspond to the `Intensity` in the `Excitation` section multiplied by the actual area of the starting ray window. If an area factor has been defined in the simulation, this area factor also is multiplied into the result.

*   Escaped power refers to the sum of powers of the rays that are ejected from the device and are unable to re-enter the device.

*   StoppedMinInt power sums the powers of the rays terminated by the `MinIntensity` condition.

*   StoppedDepth power sums the powers of the rays terminated by the `DepthLimit` criteria.

*   AbsorbedBulk power refers to power absorbed in bulk regions.

*   AbsorbedBC power refers to power absorbed in the TMM contacts. This column is shown only if TMM contacts have been defined.

In the plot file, the raytrace photon rates and powers are listed under `RaytracePhoton` and `RaytracePower`, respectively. In addition, the ratio of the various powers and the input power are plotted under `RaytraceFraction`.

# Plotting Interface Flux

The photon flux flowing through any interface can be tracked with the `PlotInterfaceFlux` feature. The tracking is made possible by recording the reflected, transmitted, and absorbed flux flowing through each interface or contact BC. Since photon flux is directional, there is a need to distinguish between the flux flowing from Region 1 to Region 2, or from Region 2 to Region 1, as shown in Figure 36.

Diagram showing directional photon flux components (I, R, T, A) between Region 1 and Region 2.

Figure 36 Distinguishing directional photon flux

Raytracing

Consider the photon fluxes (carried by rays) flowing from Region 1 to Region 2. For photon flux conservation:

$$ I_{12} = R_{12} + T_{12} + A_{12} \tag{731} $$

where:

*   $I_{12}$ is the incident flux.

*   $R_{12}$ is the reflected flux.

*   $T_{12}$ is the transmitted flux.

*   $A_{12}$ is the flux absorbed at the interface.

The reverse is true for flux flowing from Region 2 to Region 1. At each interface, the summation of $R_{12}$, $T_{12}$, $A_{12}$, $R_{21}$, $T_{21}$ and $A_{21}$ is stored in the raytracing process.

With this information, you can compute various reflection and transmission coefficients at the interface that has been declared as a raytrace BC. For example, assume that light is illuminated from Region 1 to Region 2. Within Region 2, there can be multiple reflections, and some rays might escape back into Region 1 through $T_{21}$.

Therefore, the power reflection coefficient for the case in Figure 36 is:

$$ \tilde{R}_{12} = \frac{\sum R_{12} + \sum T_{21}}{\sum R_{12} + \sum T_{12} + \sum A_{12}} \tag{732} $$

The following syntax activates the feature for tracking and plotting interface fluxes:

```
Physics {...
  Optics (...
    OpticalSolver (...
      RayTracing (
        PlotInterfaceFlux
      )
    )
  )
}
```

This feature is limited to the unified raytracing interface. In the plot file, only the fluxes of the interfaces or contacts that have been declared as a raytrace BC are output. In addition, activating the PlotInterfaceFlux feature also enables the output of the absorbed photon density in every layer of the TMM BC. The output variables in the plot file are listed as follows:

```
RaytraceInterfaceFlux                # directional
  R(region1/region3)
  T(region1/region3)
  A(region1/region3)
```

21: Optical Generation
Raytracing

```
  R(region3/region1)
  T(region3/region1)
  A(region3/region1)

 RaytraceContactFlux                     # directional
  R(contactname1(region1/region3))       # the region is only a sample
  T(contactname1(region1/region3))
  A(contactname1(region1/region3))
  R(contactname1(region3/region1))
  T(contactname1(region3/region1))
  A(contactname1(region3/region1))

 RaytraceInterfaceTMMLayerFlux           # not directional
  A(region1/region3).layer1
  A(region1/region3).layer2
  A(region1/region3).layer3

 RaytraceContactTMMLayerFlux             # not directional
  A(contactname1(region1/region3)).layer1
  A(contactname1(region1/region3)).layer2
  A(contactname1(region1/region3)).layer3
```

A contact-based BC can possibly intersect many region interfaces. In the plot file output, only a representative region interface is used to indicate the directional flow of photon flux for the entire contact BC.

When the `PlotInterfaceFlux` feature is activated, the `OpticalIntensity` computation will change such that the intensity within each region is scaled to the net photon flux gained in that region. Therefore, the `OpticalIntensity` values can be negative in some regions. Integration of the `OpticalIntensity` within the region recovers the net photon flux flowing into that region.

# Far Field and Sensors for Raytracing

To collect information on the rays that exit a device, the concept of far field and sensors is introduced in the unified raytracer interface.

The far field is collected on a virtual circle for two dimensions and a virtual sphere for three dimensions. Ray collection does not destroy the rays. On the virtual far-field surface, the far-field intensity is computed based on a unit measure of radius, whereby the collected ray powers at each interval are divided by the radian angular arc (2D) or area (3D).

In two dimensions, far-field intensity = $\frac{\sum raypowers}{d\phi}$.

In three dimensions, far-field intensity = $\frac{\sum raypowers}{\{\cos((\theta_1) - \cos(\theta_2))\}d\phi}$.

Raytracing

On the other hand, a sensor sums the total power of all rays impinging the sensor. Two types of sensor can be defined:

*   A line segment sensor in two dimensions or a flat rectangular sensor in three dimensions.

*   An angular sensor that collects the power of the rays that radiate within the angular span of the sensor. In two dimensions, a range of $\phi$ defines the sensor; whereas in three dimensions, ranges of $\theta$ and $\phi$ are needed. These are defined according to the regular Cartesian coordinate system. In two dimensions, $\phi$ rotates from 0 at the positive x-axis in a counterclockwise direction towards the positive y-axis. In three dimensions, $\theta$ rotates from 0 at the positive z-axis towards the xy plane; whereas. $\phi$ is similarly defined as in two dimensions.

The `SensorSweep` option is also available for 3D simulations. It allows you to visualize the variation of ray power collected on a latitude or longitude ring band.

The syntax for activating the far field and sensors in the unified interface for optical generation computation is:

```
Physics {
  Optics (
    OpticalSolver (
      Raytracing(
        Farfield(
          Origin = auto | <vector>      # default is auto
          Discretization = <integer>    # default is 360 for 2D, 36 for 3D
          ObservationRadius = <float>   # default is 1e6 um (1 meter)
          Sensor(
            Name = "sensorname1"
            Rectangle (                 # 3D only
              Corner1 = <vector>
              Corner2 = <vector>
              Corner3 = <vector>
              UseNormalFlux
              AxisAligned               # 3D only
            )
            Line (                      # 2D only
              Corner1 = <vector>
              Corner2 = <vector>
              UseNormalFlux
            )
            Angular (
              Theta = (<float> <float>)
              Phi = (<float> <float>)
            )
          )
          Sensor(
            Name = "sensorname2"
            Rectangle ( ... )           # 3D only
```

21: Optical Generation

Raytracing

```
                  Line ( ... )                               # 2D only
                  Angular ( ... )
                )
                SensorSweep(                                 # 3D only
                  Name = "sensorname3"
                  Ndivisions = <integer>
                  VaryPhi
                  Theta = (<float> <float>)                  # Use with VaryPhi
                )
                SensorSweep(                                 # 3D only
                  Name = "sensorname4"
                  Ndivisions = <integer>
                  VaryTheta
                  Phi = (<float> <float>)                    # Use with VaryTheta
                )
              )
            )
          )
        )
      }
```

Some comments about the syntax:

* Multiple far-field `Sensor` and `SensorSweep` sections can be defined. However, each `Sensor` and `SensorSweep` section must have a unique name for identification.

* When `Line` or `Rectangle` sensors are used, the option `UseNormalFlux` allows you to sum the normal-projected power from the ray that is impinging the sensor at an angle.

* In the case of a `Rectangle` sensor in three dimensions, if you specify `AxisAligned`, then only opposing corners of the rectangle are required. Sentaurus Device automatically computes the other two corners of the rectangle.

* If an empty `Farfield()` section is specified, then the far field is plotted with the default values of `Discretization`, `Origin`, and `ObservationRadius`.

* The far field takes values of intensity type. Therefore, to recover the total number of photons, you must integrate over the angle (in radian).

* The 3D far field is projected onto a staggered grid (see Staggered 3D Grid LED Radiation Pattern on page 1012).

* The far field is plotted at every instance where the `Plot` statement in the `Solve` section is activated. The file names of the far field and sensor sweep are derived from the plot file name. For example, this syntax:

```
File {...
  Plot = "n99_des"
}
Solve {...
  Plot ( Range=(0,1) Intervals=5 )
}
```

Raytracing

produces the following far-field files:

```
n99_000000_des_farfield.tdr
n99_000001_des_farfield.tdr
...
n99_000000_des_sensorsweep.plt
n99_000001_des_sensorsweep.plt
...
```

* In the SensorSweep plot file, all the user-defined SensorSweep sections are defined in the following fields of the plot file:

```
sensorname3
 Phi
 Photons_DelTheta
sensorname4
 Theta
 Photons_DelPhi
```

* The values of the sensor are added to the general plot file of the simulation, and the field entries are:

```
RaytraceSensor
 sensorname1
 sensorname2
```

## Dual-Grid Setup for Raytracing

Raytracing in Sentaurus Device is based on tracing the rays in each cell of the simulation mesh. For simulations in which the optical material properties do not vary on a short length scale, this might lead to the unnecessary deterioration of simulation performance. In such cases, a dual-grid setup can be used, which allows the use of a coarse mesh for raytracing, while the electronic equations are solved on a finer mesh (see Figure 37 on page 680).

The basic syntax for setting up a raytracing dual-grid simulation is:

```
File {
  Output  = "output"
  Current = "current"
}

Plot {
  OpticalIntensity
  OpticalGeneration
}

# Specify grid and material parameter file names for raytracing:
OpticalDevice OptGrid {
  File {
```

21: Optical Generation
Raytracing

```
    Grid      = "raytrace.tdr"
    Doping    = "raytrace.tdr"
    Current   = "opto"
    Plot      = "opto"
    Parameter = "CIS.par"
  }
  Physics { HeteroInterface }
}

# Specify grid, material parameters, and physical models for electrical
# simulation:
Device CIS {
  Electrode {
    { Name="sub" Voltage = 0.0 }
    { Name="pd"  Voltage = 0.0 }
  }
  File {
    Grid      = "in_elec_pof.tdr"
    Doping    = "in_elec_pof.tdr"
    Parameter = "CIS.par"
    Current   = "current"
    Plot      = "plot"
  }
  Physics {
    AreaFactor = 1
    Optics(...
      ComplexRefractiveIndex(...
        WavelengthDep(real imag)
      )
      OpticalGeneration(...)
      Excitation(...)
      OpticalSolver(
        RayTracing (
          RayDistribution(...)
          DepthLimit = 1000
          MinIntensity = 1e-3
        )
      )
    )
  }
}

# Specify system connectivity:
System {
  OptGrid opt ()
  CIS d1 (pd=vdd sub=0) { Physics{ OptSolver = "opt" } }
  Vsource_pset drive(vdd 0){ dc = 0.0 }
}

Solve { Poisson }
```

Transfer Matrix Method

The dual-grid simulation setup also allows the unified raytracing interface to be used (see Raytracing on page 616).

Comparison of two grids used in a 3D dual-grid CMOS image sensor simulation showing fine and coarse meshes.

Figure 37 Comparison of two grids used in a 3D dual-grid CMOS image sensor simulation; the figures show cuts through the device center; (*left*) the electronic equations are solved on a fine grid and (*right*) a coarse grid is used for raytracing

# Transfer Matrix Method

Sentaurus Device can calculate the propagation of plane waves through layered media by using a transfer matrix approach.

## Physical Model

In the underlying model of the optical carrier generation rate, monochromatic plane waves with arbitrary angles of incidence and polarization states penetrating a number of planar, parallel layers are assumed. Each layer must be homogeneous, isotropic, and optically linear. In this case, the amplitudes of forward and backward running waves $A_j^{\pm}$ and $B_j^{\pm}$ in each layer in Figure 38 on page 681 are calculated with help of transfer matrices.

These matrices are functions of the complex wave impedances $Z_j$ given by $Z_j = n_j \cdot \cos \Theta_j$ in the case of E polarization (TE) and by $Z_j = n_j / (\cos \Theta_j)$ in the case of H polarization (TM). Here, $n_j$ denotes the complex index of refraction and $\Theta_j$ is the complex counterpart of the angle of refraction ($n_0 \cdot \sin \Theta_0 = n_j \cdot \sin \Theta_j$).

21: Optical Generation
Transfer Matrix Method

The transfer matrix of the interface between layers $j$ and $j + 1$ is defined by:

$$ T_{j, j+1} = \frac{1}{2Z_j} \cdot \begin{bmatrix} Z_j + Z_{j+1} & Z_j - Z_{j+1} \\ Z_j - Z_{j+1} & Z_j + Z_{j+1} \end{bmatrix} \tag{733} $$

The propagation of the plane waves through layer $j$ can be described by the transfer matrix:

$$ T_j(d_j) = \begin{bmatrix} \exp\left(2\pi i \ n_j \cos \Theta_j \ \frac{d_j}{\lambda}\right) & 0 \\ 0 & \exp\left(-2\pi i \ n_j \cos \frac{\Theta_j d_j}{\lambda}\right) \end{bmatrix} \tag{734} $$

with the thickness $d_j$ of layer $j$ and the wavelength $\lambda$ of the incident light.

The transfer matrices connect the amplitudes of Figure 38 as follows:

$$ \begin{pmatrix} B_j^+ \\ A_j^+ \end{pmatrix} = T_{j, j+1} \cdot \begin{pmatrix} A_{j+1}^- \\ B_{j+1}^- \end{pmatrix} $$
$$ \begin{pmatrix} A_j^- \\ B_j^- \end{pmatrix} = T_j(d_j) \cdot \begin{pmatrix} B_j^+ \\ A_j^+ \end{pmatrix} \tag{735} $$

Diagram showing wave amplitudes A and B in a layered medium with refractive indices n and transfer matrices T connecting the interfaces.

Figure 38 Wave amplitudes in a layered medium and transfer matrices connecting them

It is assumed that there is no backward-running wave behind the layered medium, and the intensity of the incident radiation is known. Therefore, the amplitudes $A_j^\pm$ and $B_j^\pm$ at each interface can be calculated with appropriate products of transfer matrices.

Transfer Matrix Method

For both cases of polarization, the intensity in layer $j$ at a distance $d$ from the upper interface $(j, j + 1)$ is given by:

$$ I_{T(\text{TE, TM})}(d) = \frac{\Re(Z_j)}{\Re(Z_0)} \cdot \left| T_j(d) \cdot \begin{pmatrix} A_j^- \\ B_j^- \end{pmatrix} \right|^2 $$ (736)

with the proper wave impedances. If $\delta$ is the angle between the vector of the electric field and the plane of incidence, the intensities have to be added according to:

$$ I(d) = I_{\text{TM}}(d) + I_{\text{TE}}(d) $$ (737)

where $I_{\text{TM}} = (1 - a)I(d)$ and $I_{\text{TE}} = aI(d)$ with $a = \cos^2 \delta$.

One of the layers must be the electrical active silicon layer where the optical charge carrier generation rate $G^{\text{opt}}$ is calculated. The rate is proportional to the photon flux $\Phi(d) = I(d)/\hbar\omega$.

In the visible and ultraviolet region, the photon energy $\hbar\omega$ is greater than the band gap of silicon. In this region, the absorption of photons by excitation of electrons from the valence to the conduction band is the dominant absorption process for nondegenerate semiconductors. Far from the absorption threshold, the absorption is considered to be independent of the free carrier densities and doping. Therefore, the silicon layer is considered to be a homogeneous region.

The absorption coefficient $\alpha$ is the relative rate of decrease in light intensity along its path of propagation due to absorption. This decrease must be distinguished from variations caused by the superposition of waves. Therefore, the rate of generated electron–hole pairs is:

$$ G_0^{\text{opt}} = \alpha\eta \frac{I(d)}{\hbar\omega} $$ (738)

where the absorption coefficient $\alpha$ is given by the imaginary part of $4\pi Z_{\text{Si}}/\lambda$. The quantum yield $\eta$ is defined as the number of carrier pairs generated by one photon. More details about the available quantum yield models and their specification in the `OpticalGeneration` section of the command file are given in Quantum Yield Models on page 603.

## Rough Surface Scattering

To model the effect of light trapping due to scattering of incident light at rough interfaces of a planar multilayer structure, the standard TMM approach describing the propagation of coherent light is extended. Part of the coherent light incident at a rough interface is scattered and spreads incoherently throughout the structure. Scalar scattering theory [4][5] allows to approximate the amount of scattered light at a rough interface. The so-called haze parameter defines the ratio of diffused (scattered) light to total (diffused + specular) light. The directional

21: Optical Generation
Transfer Matrix Method

dependency of the scattering process is modeled by angular distribution functions (ADFs). In this scenario, a rough interface is characterized by its haze function (haze parameter as a function of the wavelength of incident light) for reflection and transmission as well as the ADF for direct coherent light incident at the interface and the ADF for scattered light incident at the interface.

The implementation of rough surface scattering within the existing TMM framework follows the semi-coherent optical model outlined in [6]. It is based on the following assumptions:

*   The haze factor determines the fraction of direct light, transferred to scattered light.

*   Coherent and diffused light incident on a rough interface are scattered differently using different ADFs.

*   Interfaces are nonabsorptive, meaning photon flux is conserved at interfaces.

*   For scattered light incident at a rough interface, the mean value of TE and TM polarized light for reflectance and transmittance is used.

*   For the scattered light, the total reflectance and transmittance for a rough interface are assumed to be equal to the ones for the corresponding flat interface.

*   The phase change of the electric field traveling across a rough interface is the same as in the case of the corresponding flat interface.

*   Scattered light incident at a rough interface is further split, according to its haze factor, into a specular part, which corresponds to light incident at a flat interface, and a diffused part leading to further spreading of the incident scattered light.

Given these assumptions, the specular and diffused components of light at each interface can be expressed in terms of the corresponding haze functions and ADFs. The description of coherent light incident at a rough interface differs from the approach taken in [6] in that a generalized interface matrix has been derived. It accounts for the reduced reflection and transmission according to the respective haze functions and allows to keep the common TMM computation approach for the electric field and intensity. The reduced interface matrix reads as follows:

$$ \tilde{T}_{j,j+1} = \frac{1}{h_{j+1,j}^t t_{j+1,j}} \begin{bmatrix} 1 & (h_{j+1,j}^r r_{j,j+1}) \\ (h_{j,j+1}^r r_{j,j+1}) & (h_{j,j+1}^t h_{j+1,j}^t + (h_{j+1,j}^r h_{j,j+1}^r - h_{j,j+1}^t h_{j+1,j}^t) r_{j,j+1}^2) \end{bmatrix} \text{ (739)} $$

where $r_{j,j+1}$ and $t_{j,j+1}$ denote the Fresnel reflection and transmission coefficients for normal incidence given by:

$$ r_{j,j+1} = \frac{n_j - n_{j+1}}{n_j + n_{j+1}} \text{ (740)} $$

$$ t_{j,j+1} = \frac{2n_j}{n_j + n_{j+1}} \text{ (741)} $$

Transfer Matrix Method

and $h_{j,j+1}^r$ and $h_{j,j+1}^t$ are reduction factors determined by the haze functions for reflection and transmission:

$$ h_{j,j+1}^r = \sqrt{1 - H_{j,j+1}^r} $$ (742)

$$ h_{j,j+1}^t = \sqrt{1 - H_{j,j+1}^t} $$ (743)

The haze functions for reflection and transmission derived from the scalar scattering theory are:

$$ H_{j,j+1}^r(\lambda, \phi_j) = 1 - \exp \left[ -\left( \frac{4\pi\sigma_{\text{rms}}c_r(\lambda, \sigma_{\text{rms}})n_j\cos\phi_j}{\lambda} \right)^{a^r} \right] $$ (744)

$$ H_{j,j+1}^t(\lambda, \phi_j) = 1 - \exp \left[ -\left( \frac{4\pi\sigma_{\text{rms}}c_t(\lambda, \sigma_{\text{rms}})|n_j\cos\phi_j - n_{j+1}\cos\phi_{j+1}|}{\lambda} \right)^{a^t} \right] $$ (745)

where $\sigma_{\text{rms}}$ stands for the root-mean-square roughness of the interface and $\lambda$ is the wavelength of the incident light. The exponent $a^{r/t}$ and the correction function $c_{r/t}$ are fitting parameters to better match experimental data.

> **NOTE** The haze functions defined in Eq. 744 and Eq. 745 are given in their general form, which also covers light incident at the angle $\phi_j$ from the surface normal. This expression is needed in the description of scattered light incident at a rough interface.

For the propagation of the angular intensity components of scattered light through each layer, the effective path length is used to stay within the one-dimensional formalism:

$$ I(\lambda, \phi_j, d) = I(\lambda, \phi_j) \exp \left( -\frac{\alpha(\lambda)d}{\cos\phi_j} \right) $$ (746)

The scattering solver first propagates all forward-going components through the layer structure and completes a round trip by propagating all backward-going components. In each round trip, part of the light might be absorbed within the structure as well as transmitted through the front or back side, depending on the material properties at the given wavelength. This leads to a reduction of the light intensity components at the various interfaces with increasing number of iterations. When the ratio of the largest remaining intensity component in the system to the sum of all initial intensity components falls below the value of `Tolerance`, the solver terminates. As a consequence, the residual intensity of each component at all interfaces is not included in the extracted results.

21: Optical Generation
Transfer Matrix Method

The overall simulation flow consists of the following steps:

* Solving the coherent propagation problem following the default TMM solver algorithm, but using the generalized interface matrices for rough interfaces. In this step, the starting light intensity for scattered light is calculated at each interface as well.

* The scattered light is propagated through the structure following an iterative approach similar to raytracing as outlined in [6]. However, other than raytracing, instead of single rays, ray bundles with discrete angular distribution are propagated from layer to layer. The number of iterations needed to solve the scattering problem to the required accuracy mainly depends on how much light is absorbed within the structure and how much light is coupled out at the front and back ends during a single round trip.

* The scattered and coherent absorbed photon density profiles are summed and passed to the quantum yield model.

**NOTE** Support for rough surface scattering is limited to normal incident light.

For more information on how to apply the rough surface scattering model and its configuration options, see Using Scattering Solver on page 687.

# Using Transfer Matrix Method

The transfer matrix method is only supported by the unified interface for optical generation computation (see Overview of Optical Generation on page 593). The `OpticalGeneration` section activates the computation of the optical generation along with optional parameters such as the quantum yield. The `OpticalSolver` section determines the underlying optical solver together with solver-specific parameters as shown in the following example:

```
Physics {...
 Optics (...
  OpticalGeneration (...)
  ComplexRefractiveIndex (...)
  Excitation (...
   Window ("L1") (...)
  )
  OpticalSolver (
   TMM (
    PropagationDirection = Perpendicular # Default Refractive
    NodesPerWavelength = 20
    LayerStackExtraction (...
     WindowName = "L1"
     Medium (...)
    )
   )
  )
 )
}
```

Transfer Matrix Method

```
      Excitation (...
        Window ("L1") (...)
      )
    )
  }
```

The properties of the incident light such as Wavelength, Intensity, Polarization, and angle of incidence Theta are specified in the Excitation section (see Setting the Excitation Parameters on page 620) along with one or several illumination windows (see Illumination Window on page 622), which confine the incident light to a certain part of the device structure.

An illumination window determines how the 1D solution of the transfer matrix method is interpolated to the higher dimensional device grid. The minimum coordinate of the 1D profile is pinned to the illumination window, and the interpolation of the profile in propagation direction can be performed either perpendicular to it or according to Snell's law, which is the default. The corresponding keyword in the TMM section is `PropagationDirection`, which can take either `Perpendicular` or `Refractive` as its argument. The accuracy of the integrated absorbed photon density for 1D TMM solutions in a 2D or 3D device can be controlled by various parameters (see Accurate Absorbed Photon Density for 1D Optical Solvers on page 637).

The `LayerStackExtraction` section determines how a 1D complex refractive index profile is extracted automatically from the grid file (see Extracting the Layer Stack on page 632). Based on this profile, the polarization-dependent optical intensity is calculated and interpolated onto the grid according to the referenced illumination window and the value of `PropagationDirection`. The optical generation profile then is calculated from the window-specific intensities. For overlapping windows, the intensity are summed in the region of intersection.

By default, the surrounding media at the top and bottom of the extracted layer stack are assumed to have the material properties of vacuum. However, the default can be overwritten by specifying a separate `Medium` section in the `LayerStackExtraction` section for the top and bottom of the layer stack if necessary. In the `Medium` section, a `Location` must be specified and a `Material`, or, alternatively, the values of `RefractiveIndex` and `ExtinctionCoefficient`:

```
LayerStackExtraction(
  Medium (
    Location = top
    Material = "Silicon"
  )
  Medium (
    Location = bottom
    RefractiveIndex = 1.4
    ExtinctionCoefficient = 1e-3
  )
)
```

**21: Optical Generation**
Transfer Matrix Method

If the optical generation profile is the sole quantity of interest, it is sufficient to specify the keyword `Optics` exclusively in the `Solve` section.

The TMM solver offers two options for computing the optical intensity from the complex field amplitudes of the forward-propagating and backward-propagating waves. Specifying `IntensityPattern=StandingWave` computes the optical intensity $I$ as follows:

$$ I = \text{Re}(A + B)^2 + \text{Im}(A + B)^2 \hfill (747) $$

whereas using the syntax:

```
TMM (...
  IntensityPattern = Envelope
)
```

computes the optical intensity $I$ using the following formula to prevent oscillations on the wavelength scale that might not be possible to resolve on the mixed-element simulation grid:

$$ I = \text{Re}(A)^2 + \text{Im}(A)^2 + \text{Re}(B)^2 + \text{Im}(B)^2 \hfill (748) $$

where $A$ and $B$ are the complex field amplitudes of the forward-propagating and backward-propagating waves, respectively. `IntensityPattern` can be specified globally, per region, or per material.

The keywords of `TMM` are summarized in Table 262 on page 1575.

## Using Scattering Solver

To model the effect of scattering at rough interfaces, the scattering solver (see Rough Surface Scattering on page 682) must be configured in the command file, and the parameters characterizing each rough interface must be specified in the corresponding parameter file section.

## Command File Specification

The scattering solver is activated by specifying a `Scattering` section within the `TMM` section. By default, all interfaces are treated as rough. However, whether part of the light incident on a specific interface is actually scattered depends on the corresponding haze functions for reflection and transmission defined in the parameter file. A haze function evaluating to zero is equivalent to the interface being treated as flat.

Transfer Matrix Method

You can flag explicitly a specific region or material interface as not being rough as in the following example:

```
Physics {
  Optics (
    OpticalSolver (
      TMM (
        Scattering ( ... )
        RoughInterface    #Default
      )
    )
  )
}

Physics (RegionInterface="<region1>/<region2>") {
  Optics (
    OpticalSolver (
      TMM (
        -RoughInterface
      )
    )
  )
}
```

Sometimes, it might be more practical to set all interfaces as flat by specifying `-RoughInterface` in the global `Physics` section and only to label specific interfaces as rough in a corresponding region or material interface `Physics` section.

The angular discretization of the interval $[-\pi/2, \pi/2]$ used for the ray bundles in the scattering solver can be set with the keyword `AngularDiscretization` in the `Scattering` section. The keywords `Tolerance` and `MaxNumberOfIterations` determine the termination condition of the iterative scattering solver (see Rough Surface Scattering on page 682):

```
Physics {
  Optics (
    OpticalSolver (
      TMM (
        Scattering (
          AngularDiscretization = 90
          MaxNumberOfIterations = 150
          Tolerance = 1e-3
        )
      )
    )
  )
}
```

**21: Optical Generation**
Transfer Matrix Method

For weakly absorbing structures, such as semiconductor layer stacks illuminated with light in the infrared part of the spectrum, many iterations might be necessary until the given `Tolerance` is reached. To detect such cases and to limit the total simulation time, it is advisable to adjust the value of `MaxNumberOfIterations`.

# Parameter File Specification

All parameters characterizing a rough interface are defined in the `OpticalSurfaceRoughness` section of the respective region or material interface section in the parameter file. The parameters can be classified into two groups: One relates to the specification of the haze functions and one contains the selection of the various angular distribution functions (ADFs).

For specifying the haze function for reflection (`HazeFunction_R`) and transmission (`HazeFunction_T`), two options are available:

*   **Constant**: For each of the two haze functions H<sub>R</sub> and H<sub>T</sub>, a constant value can be set using the keywords `H_R` and `H_T`. This option can be useful if a simulation is performed at a single wavelength and the surface roughness is not varied as the haze functions usually depend on both.

*   **Analytic**: The analytic expressions given by Eq. 744, p. 684 and Eq. 745, p. 684 are evaluated. where the surface roughness $\sigma_{rms}$, the exponents $a_R$ and $a_T$, and the correction functions $c_R$ and $c_T$ are supplied by the user. In the simplest approximation, $c_R$ and $c_T$ are assumed to be constants over the whole wavelength range. However, in general, the correction functions are used to fit the analytic haze functions against experimental data. For that purpose, tabulated values are supported by setting `CorrectionFunction_R` or `CorrectionFunction_T` equal to `Table`.

Besides the haze functions, the ADFs are used to characterize the behavior of light incident at rough interfaces. The model supports the specification of different ADFs for direct incident light at a rough interface as well as for scattered light incident at a rough interface. Some ADFs depend on an additional parameter apart from the angle of incidence, whose value must be supplied by the user.

The detailed syntax including all options for the definition of the haze functions and ADFs are given in the following tables (where applicable, the default value is given at the beginning of the description).

Table 129 Specification of haze functions

| Symbol | Keyword | Value | Description |
| --- | --- | --- | --- |
| $H^r(\lambda, \phi)$ | `HazeFunction_R` | `=Constant \| Analytic` | Constant Type of haze function for reflection. |
| $H^t(\lambda, \phi)$ | `HazeFunction_T` | `=Constant \| Analytic` | Constant Type of haze function for transmission. |

Transfer Matrix Method

Table 129 Specification of haze functions (Continued)

| Symbol | Keyword | Value | Description |
| --- | --- | --- | --- |
| HR | H_R | =<float> | 0 Constant value for haze function for reflection. |
| HT | H_T | =<float> | 0 Constant value for haze function for transmission. |
| σrms | Sigma | =<float> | 0 Optical surface roughness in [nm] used in analytic haze functions for reflection and transmission. |
| aR | a_R | =<float> | 2 Exponent of analytic haze function for reflection. |
| aT | a_T | =<float> | 3 Exponent of analytic haze function for transmission. |
|  | CorrectionFunction_R | =Constant \| Table | Constant Type of correction function of analytic haze function for reflection. |
|  | CorrectionFunction_T | =Constant \| Table | Constant Type of correction function of analytic haze function for transmission. |
| cR | c_R | =<float> | 1 Constant value in interval [0 1] for correction function of analytic haze function for reflection. |
| cT | c_T | =<float> | 1 Constant value in interval [0 1] for correction function of analytic haze function for transmission. |
| cR(λ) | c_R | (<table\>) | Tabulated values for correction function of analytic haze function for reflection. First column contains wavelength in [μm] and second column contains value of correction function in interval [0 1]. |
| cT(λ) | c_T | (<table\>) | Tabulated values for correction function of analytic haze function for transmission. First column contains wavelength in [μm] and second column contains value of correction function in interval [0 1]. |
|  | TableInterpolation_c_R | =Linear \| Spline | Linear Type of interpolation used for tabulated values of correction function for analytic haze function for reflection. |
|  | TableInterpolation_c_T | =Linear \| Spline | Linear Type of interpolation used for tabulated values of correction function for analytic haze function for transmission. |

**21: Optical Generation**
Transfer Matrix Method

Table 130 Specification of angular distribution functions (not normalized)

| Symbol | Keyword | Value | Description |
| --- | --- | --- | --- |
| $f_1(\varphi)$ | ADFDirect_R | =Constant \| Triangle \| Gauss \| Lorentz \| Cosine \| Ellipse | Cosine Type of angular distribution function for direct incident light reflected at a rough interface. |
| $C$ | CDirect_R | =<float> | 2 Fitting parameter used in angular distribution function (where applicable) for direct incident light reflected at a rough interface. |
| $f_1(\varphi)$ | ADFDirect_T | =Constant \| Triangle \| Gauss \| Lorentz \| Cosine \| Ellipse | Cosine Type of angular distribution function for direct incident light transmitted through a rough interface. |
| $C$ | CDirect_T | =<float> | 2 Fitting parameter used in angular distribution function (where applicable) for direct incident light transmitted through a rough interface. |
| $f_2(\varphi)$ | ADFScatter_R | =Constant \| Triangle \| Gauss \| Lorentz \| Cosine \| Ellipse | Constant Type of angular distribution function for scattered light reflected at a rough interface. |
| $C$ | CScatter_R | =<float> | 1 Fitting parameter used in angular distribution function (where applicable) for scattered light reflected at a rough interface. |
| $f_2(\varphi)$ | ADFScatter_T | =Constant \| Triangle \| Gauss \| Lorentz \| Cosine \| Ellipse | Constant Type of angular distribution function for scattered light transmitted through a rough interface. |
| $C$ | CScatter_T | =<float> | 1 Fitting parameter used in angular distribution function (where applicable) for scattered light transmitted through a rough interface. |

Table 131 Definition of different ADF types used in Table 130

| Type | Formula |
| --- | --- |
| Constant | $f(\varphi) = 1$ |
| Triangle | $f(\varphi) = 1 - 2\|\varphi\|/\pi$ |
| Gauss | $f(\varphi) = e^{-\varphi^2/(2C)}$ |
| Lorentz | $f(\varphi) = e^{1/(\varphi^2 + C^2)}$ |

Transfer Matrix Method

Table 131 Definition of different ADF types used in Table 130 (Continued)

| Type | Formula |
| --- | --- |
| Cosine | $f(\varphi) = \cos^C(\varphi)$ |
| Ellipse | $f(\varphi) = \frac{\cos(\varphi)}{\cos^2(\varphi) + (2C)^{-2} \sin^2(\varphi)}$ |

The following figures illustrate the various ADFs specified in Table 130 on page 691.

| $\varphi$ | Constant | Triangle |
| --- | --- | --- |
| $-\frac{\pi}{2}$ | 0.32 | 0 |
| 0 | 0.32 | 0.64 |
| $\frac{\pi}{2}$ | 0.32 | 0 |

Figure 39 ADF of type Constant and Triangle

| $\varphi$ | C=0.5 | C=1 | C=2 |
| --- | --- | --- | --- |
| $-\frac{\pi}{2}$ | 0.18 | 0.18 | 0.18 |
| 0 | 0.56 | 0.45 | 0.38 |
| $\frac{\pi}{2}$ | 0.18 | 0.18 | 0.18 |

Figure 40 ADF of type Gauss

**21: Optical Generation**
Transfer Matrix Method

| φ | C=0.5 | C=1 | C=2 |
| --- | --- | --- | --- |
| -π/2 | 0.1 | 0.4 | 0.4 |
| 0 | 1.5 | 0.5 | 0.4 |
| π/2 | 0.1 | 0.4 | 0.4 |

Figure 41 ADF of type Lorentz

| φ | C=0.5 | C=1 | C=2 |
| --- | --- | --- | --- |
| -π/2 | 0 | 0 | 0 |
| 0 | 0.42 | 0.5 | 0.6 |
| π/2 | 0 | 0 | 0 |

Figure 42 ADF of type Cosine

| φ | C=0.5 | C=1 | C=2 |
| --- | --- | --- | --- |
| -π/2 | 0 | 0 | 0 |
| 0 | 0.5 | 0.3 | 0.25 |
| π/2 | 0 | 0 | 0 |

Figure 43 ADF of type Ellipse

Transfer Matrix Method

The following `OpticalSurfaceRoughness` section is an example for the specification of analytic haze functions and the default angular distribution functions:

```
OpticalSurfaceRoughness {
  HazeFunction_R=Analytic
  HazeFunction_T=Analytic
  Sigma=20  #[nm]
  a_R=2
  a_T=3
  CorrectionFunction_R=Table
  TableInterpolation_c_R=Spline
  c_R(
    0.3 04
    0.4 0.65
    0.8 0.9
    1.3 0.95
  )
  CorrectionFunction_T=Constant
  c_T=0.7

  ADFDirect_R=Cosine
  CDirect_R=2
  ADFDirect_T=Cosine
  CDirect_T=2
  ADFScatter_R=Constant
  ADFScatter_T=Constant
}
```

## Plot Quantities

When specifying `OpticalIntensity` and `AbsorbedPhotonDensity` in the `Plot` section of the command file, the following additional datasets are written to the plot file:

*   OpticalIntensityCoherent: Specular part of optical intensity resulting from propagation of coherent light

*   OpticalIntensityIncoherent: Diffuse part of optical intensity resulting from propagation of incoherent light

*   AbsorbedPhotonDensityCoherent: Specular part of absorbed photon density resulting from propagation of coherent light

*   AbsorbedPhotonDensityIncoherent: Diffuse part of absorbed photon density resulting from propagation of incoherent light

**21: Optical Generation**
Loading Solution of Optical Problem From Files

# Loading Solution of Optical Problem From Files

In solar-cell and CIS simulations, it is often necessary to load several optical generation profiles as a function of one or more parameters, for example, excitation wavelength or angle of incidence, in Sentaurus Device. These profiles then are used to compute the response to each of them separately or to compute the response to the spectrum as a whole. A typical example is the computation of white-light generation using several generation profiles previously computed by Sentaurus Device Electromagnetic Wave Solver (EMW) or different wavelengths of the visible spectrum.

The parameters corresponding to a specific absorbed photon density or optical generation profile are written to the respective output file as special TDR tags as well. For 1D profiles generated with external tools, such tags can be specified in the file header (see Importing 1D Profiles Into Higher-Dimensional Grids on page 697). This ensures that a profile can be identified later when loaded into a Sentaurus Device simulation. For example, if the optical problem is solved externally, it is not possible to determine the quantum yield, which is necessary to compute the optical generation based on the electronic properties of the underlying device structure. However, since the corresponding excitation wavelength is stored along with the optical solution, the quantum yield computation can be performed later in Sentaurus Device after loading the profile to compute the optical generation.

Absorbed photon density or optical generation profiles loaded into Sentaurus Device using the optical solver `FromFile` must meet one of the following requirements:

*   Profiles must be saved in a TDR file.

*   One-dimensional profiles that are to be imported into higher-dimensional grids must comply with the PLX file format described in Importing 1D Profiles Into Higher-Dimensional Grids on page 697.

If the grid on which the profile is saved is not the same as that used for the device simulation (different mixed-element grid or arbitrary tensor grid arising from EMW simulation), the profile is interpolated automatically onto the simulation grid upon loading. For more details on how to control the interpolation, including the truncation and shifting of the interpolation domain, see Controlling Interpolation When Loading Optical Generation Profiles on page 714.

The basic command file syntax for loading profiles from file is:

```
File {
  OpticalSolverInput = "<filename or filename pattern of profiles>"
}

Physics {
  Optics (
    OpticalGeneration (
      ComputeFromMonochromaticSource ()                        # or
```

Loading Solution of Optical Problem From Files

```
          ComputeFromSpectrum ()
        )
        OpticalSolver (
          FromFile (
            DatasetName = AbsorbedPhotonDensity          # Default
            SpectralInterpolation = Linear               # Default Off
            IdentifyingParameter = ("Wavelength" "Theta")
          )
        )
      )
    )
}
```

**NOTE** The optical solver `FromFile` requires the specification of `ComputeFromMonochromaticSource` or `ComputeFromSpectrum` in the `OpticalGeneration` section. Otherwise, the computation of the optical generation based on the loaded profile is not activated.

The keyword `OpticalSolverInput` takes as its argument either the name of a single TDR or PLX file, or a UNIX-style file name pattern to select several such files whose names match the specified pattern. In both cases, a single file can contain more than one absorbed photon density or optical generation profile. In TDR files, the different profiles are saved in separate TDR states; whereas, in PLX files, they are simply listed sequentially, including their respective headers (see Importing 1D Profiles Into Higher-Dimensional Grids on page 697).

Each profile is characterized by its set of parameters, whose values must be unique among the profiles selected in the `File` section. As profiles can be characterized by different numbers of parameters, you must specify the ones to be considered for checking uniqueness by using the keyword `IdentifyingParameter`. Supported arguments are a simple parameter name such as `Wavelength` or, if ambiguous, a full parameter path such as `Optics/Excitation/Wavelength`.

You can also introduce new parameters, that is, parameters that do not exist in Sentaurus Device, by assigning them to a profile and referring to them in the list of `IdentifyingParameter`. Added parameters will appear under the following path:

`Optics/OpticalSolver/FromFile/UserDefinedParameters/<Name of added parameter>`

User-defined parameters also are supported in the `IlluminationSpectrum` file in the `File` section (see Illumination Spectrum on page 596).

**NOTE** Only profiles that carry intensity as a parameter tag are supported for loading from files. Other profiles are ignored with a warning message. However, intensity must not be listed as `IdentifyingParameter` unless you want to enforce explicitly that all profiles are also unique with respect to their intensity.

21: Optical Generation

Loading Solution of Optical Problem From Files

The intensity associated with each profile and saved as a parameter tag in the respective file plays a special role as it is needed to scale the loaded profile according to the requested intensity. For `ComputeFromMonochromaticSource`, the loaded profile must be scaled to conform with the intensity specified in the `Excitation` section according to:

$$ G = \frac{I_{\text{exc}}}{I_{\text{loaded}}} G_{\text{loaded}} \tag{749} $$

For `ComputeFromSpectrum`, the loaded profile for each spectral component is scaled to match the intensity given in the corresponding entry of the illumination spectrum file. The total optical generation is then computed as the sum over the scaled profiles given by:

$$ G_{\text{tot}} = \sum_{n} \frac{I_{n, \text{ spectrum}}}{I_{n, \text{ loaded}}} G_{n, \text{ loaded}} \tag{750} $$

When using the feature `ComputeFromSpectrum` (see Illumination Spectrum on page 596) or when ramping parameters, it is possible that, for a requested set of parameter values, no profile can be found that matches it. By default, the program will exit with an appropriate error message; however, you have two further options to deal with such situations. Using the keyword `SpectralInterpolation`, either `PiecewiseConstant` or `Linear` interpolation can be selected. Interpolation is based on the leading identifying parameter as opposed to complex multidimensional interpolation.

As mentioned earlier, two profile quantities are supported, absorbed photon density and optical generation, which can be selected using the keyword `DatasetName`. The choice determines whether a quantum yield model (see Quantum Yield Models on page 603) will be applied. If optical generation is specified, quantum yield is assumed to be 1. Otherwise, the corresponding quantum yield model specified in the `OpticalGeneration` section is used to compute the optical generation profile from the loaded absorbed photon density.

# Importing 1D Profiles Into Higher-Dimensional Grids

Importing 1D profiles into higher-dimensional grids is supported for files in PLX format. The following example documents the syntax of PLX files for two 1D profiles characterized by three parameters in a single file:

```
# some comments
"<optional string for tagging a profile>"
Wavelength = 0.5 [um] Theta = 0 [deg] Intensity = 0.1 [W*cm^-2]
0.0 1e19
0.8 1e20
1.4 1e17
2.0 5e18
```

Loading Solution of Optical Problem From Files

```
# some comments
"<optional string for tagging a profile>"
Wavelength = 0.6 [um] Theta = 30[deg] Intensity = 0.1 [W*cm^-2]
0.0 1e19
0.8 1e20
1.4 1e17
2.0 5e18
...
```

Each profile can be preceded by an optional comment starting with the hash character (#), an optional tag given in double quotation marks, and a list of parameters with their corresponding value and unit as shown in the example above. If a tag is supplied, then it will be used as a curve name when visualizing the file in Inspect, which also supports PLX files containing several profiles.

After the 1D profiles have been loaded into Sentaurus Device, they must be interpolated onto the 2D or 3D grid. Similar to the TMM solver (see Using Transfer Matrix Method on page 685), the concept of an illumination window is applied for this purpose and it requires the specification of at least one `Window` section in the `Excitation` section. See Illumination Window on page 622 for further details. The accuracy of the integrated APD for 1D profiles in a 2D or 3D device can be controlled by various parameters (see Accurate Absorbed Photon Density for 1D Optical Solvers on page 637).

> **NOTE** For the interpolation of the 1D profile onto the 2D or 3D grid, the first data point of a profile is always pinned to the illumination window plane, independent of its actual coordinate value.

# Ramping Profile Index

The optical solver `FromFile` supports a keyword `ProfileIndex`, which can be used to address a certain profile directly by its index instead of its identifying parameters. The index is derived from all valid profiles sorted according to the value of the leading identifying parameter specified in the command file.

This feature can be used to ramp through all available profiles in a `Quasistationary` statement without having to know the exact parameter values for each profile. The spectral interpolation options described in Loading Solution of Optical Problem From Files on page 695 also are supported for ramping the `ProfileIndex`. If an index value is requested in a `Quasistationary` statement that exceeds the number of valid profiles, then the `Quasistationary` is finished and control is given to the following statement in the `Solve` section.

21: Optical Generation
Optical Beam Absorption Method

The following example shows the ramping of the `ProfileIndex`:

```
File {
  OpticalSolverInput = "absorbed_photon_density_input_*file.tdr"
}

Physics {
  OpticalGeneration (
    ComputeFromMonochromaticSource ()
  )
  OpticalSolver (
    FromFile (
      ProfileIndex = 0
      DatasetName = AbsorbedPhotonDensity
      SpectralInterpolation = Off
      IdentifyingParameter = ("Optics/Excitation/Wavelength" "Theta" "Phi")
    )
  )
}

Solve {
  Quasistationary (
    InitialStep=0.01 MaxStep=0.01 MinStep=0.01
    Plot { Range = ( 0., 1 ) Intervals = 5 }
    Goal { ModelParameter="ProfileIndex" value=100 }
  ) { Optics }
}
```

Note that the counting of profiles starts with index zero. For more information about ramping parameters, see Parameter Ramping on page 635.

# Optical Beam Absorption Method

The optical beam absorption method in Sentaurus Device computes optical generation by simple photon absorption using Beer’s law. Thereby, multiple optical beams can be defined to represent the incident light.

## Physical Model

Figure 44 on page 700 illustrates one optical beam and its optical intensity distribution in a 3D device. J<sub>0</sub> denotes the optical beam intensity (number of photons that cross an area of 1 cm<sup>2</sup> per 1 s) incident on the semiconductor device. (x<sub>min</sub>, y<sub>min</sub>) and (x<sub>max</sub>, y<sub>max</sub>) define the rectangular illumination window. The space shape F<sub>xy</sub> of the incident beam intensity is defined by the illumination window, where F<sub>xyv</sub> is equal to 1 inside of it and zero otherwise.

Optical Beam Absorption Method

Intensity distribution of an optical beam modeled by a rectangular illumination window

Figure 44 Intensity distribution of an optical beam modeled by a rectangular illumination window

The following equations describe useful relations for the photogeneration problem:

$$
\begin{aligned}
E_{\text{ph}} &= \frac{hc}{\lambda} \\
J_0 &= \frac{P_0}{E_{\text{ph}}}
\end{aligned}
\eqno{(751)}
$$

where:

*   $P_0$ is the incident wave power per area [W/cm$^2$].

*   $\lambda$ is the wavelength [cm].

*   $h$ is Planck's constant [J s].

*   $c$ is the speed of light in a vacuum [cm/s].

*   $E_{\text{ph}}$ is the photon energy that is approximately equal to $\frac{1.24}{\lambda [\mu\text{m}]}$ in eV.

The optical beam absorption model computes the optical generation rate along the z-axis taking into account that the absorption coefficient varies along the propagation direction of the beam according to:

$$
G^{\text{opt}}(z, t) = J_0 F_t(t) F_{xy} \cdot \alpha(\lambda, z) \cdot \exp\left(-\left|\int_{z_0}^z \alpha(\lambda, z') dz'\right|\right) \eqno{(752)}
$$

where:

*   $t$ is the time.

*   $F_t(t)$ is the beam time behavior function. For a Gaussian pulse, it is equal to 1 for $t$ in $[t_{\text{min}}, t_{\text{max}}]$ and shows a Gaussian distribution decay outside the interval with the standard deviation $\sigma_t$.

21: Optical Generation
Optical Beam Absorption Method

*   $z_0$ is the coordinate of the semiconductor surface.

*   $\alpha(\lambda, z)$ is the nonuniform absorption coefficient along the z-axis.

As described in the following section, the optical beam absorption method supports a wide range of window shapes (see Illumination Window on page 622) as well as arbitrary beam time behavior functions (see Specifying Time Dependency for Transient Simulations on page 606). It is also not limited to beams propagating along the z-axis. The example above has only been used for demonstration purposes.

# Using Optical Beam Absorption Method

The optical beam absorption method is activated by the optical solver `OptBeam`. The profile of the absorption coefficient used in Eq. 752 is determined by the `LayerStackExtraction` section inside the `OptBeam` section; whereas, the shape of the beam is specified by the illumination window. The wavelength and intensity of the incident light are defined in the `Excitation` section.

The required syntax of the optical beam absorption method is summarized here:

```
Physics {
  ...
  Optics (
    ...
    Excitation (
      Wavelength = 0.5
      Intensity = 0.1
      Window("L1") (
        <window options>
      )
    )
    OpticalSolver (
      OptBeam (
        LayerStackExtraction (
          WindowName = "L1"
          <layer stack extraction options>
        )
      )
    )
  )
}
```

Further details about the `Window` and `LayerStackExtraction` sections can be found in Illumination Window on page 622 and Extracting the Layer Stack on page 632, respectively.

21: Optical Generation
Beam Propagation Method

The accuracy of the integrated absorbed photon density for 1D profiles in a 2D or 3D device can be controlled by various parameters (see Accurate Absorbed Photon Density for 1D Optical Solvers on page 637).

**NOTE** You can simulate several beams at the same time by specifying the corresponding number of `Window` and `LayerStackExtraction` sections. However, all beams are assigned the same wavelength and intensity, which is specified in the common `Excitation` section.

# Beam Propagation Method

In Sentaurus Device, the beam propagation method (BPM) can be applied to find the light propagation and penetration into devices such as photodetectors. Despite being an approximate method, its efficiency and relative accuracy make it attractive for bridging the gap between the raytracer and the FDTD solver (EMW) featured in Sentaurus Device. The BPM solver is available for both 2D and 3D device geometries, where its computational efficiency compared with a full-wave approach becomes particularly apparent in three dimensions.

**NOTE** Do not use BPM for 3D CMOS image sensors because BPM cannot resolve the polarization transformation caused by the 3D lens.

## Physical Model

The BPM implemented in Sentaurus Device is based on the fast Fourier transform (FFT) and is a variant of the FFT BPM, which was developed by Feit and Fleck [7].

The solution of the scalar Helmholtz equation:

$$ \left[ \nabla_t^2 + \frac{\partial^2}{\partial z^2} + k_0^2 n^2(x, y, z) \right] \phi(x, y, z) = 0 $$ (753)

at $z + \Delta z$ with $\nabla_t^2 = \partial^2 / \partial x^2 + \partial^2 / \partial y^2$ and $n(x, y, z)$ being the complex refractive index can be written as:

$$ \frac{\partial}{\partial z} \phi(x, y, z + \Delta z) = \mp i \sqrt{k_0^2 n^2 + \nabla_t^2} \phi(x, y, z) = \pm i \wp \phi(x, y, z) $$ (754)

In the paraxial approximation, the operator $\wp$ reduces to:

$$ \wp \cong \sqrt{k_0^2 n_0^2 + \nabla_t^2} + k_0 \delta n $$ (755)

21: Optical Generation

Beam Propagation Method

where $n_0$ is taken as a constant reference refractive index in every transverse plane. By expressing the field $\phi$ at $z$ as a spatial Fourier decomposition of plane waves, the solution to Eq. 753 for forward-propagating waves reads:

$$ \phi(x, y, z + \Delta z) = \frac{1}{(2\pi)^2} \exp(ik_0 \delta n \Delta z) \int_{-\infty}^{\infty} d\vec{k}_t \exp(i\vec{k}_t \cdot \vec{r}) \exp(i\sqrt{k_0^2 n_0^2 - \vec{k}_t^2} \Delta z) \tilde{\phi}(\vec{k}_t, z) \tag{756} $$

where $\tilde{\phi}$ denotes the transverse spatial Fourier transform. As can be seen from Eq. 756, each Fourier component experiences a phase shift, which represents the propagation in a medium characterized by the reference refractive index $n_0$. The phase-shifted Fourier wave is then inverse-transformed and given an additional phase shift to account for the refractive index inhomogeneity at each $(x, y, z + \Delta z)$ position. In the numeric implementation of Eq. 756, an FFT algorithm is used to compute the forward and inverse Fourier transform.

## Bidirectional BPM

The bidirectional algorithm is based on two operators as described by Kaczmarski and Lagasse [8]. The first operator defines a unidirectional propagation, which is outlined in the previous section. The second operator accounts for the reflections at interfaces of the refractive index along the propagation direction. In a first pass, the reflections at all interfaces are computed. The following pass in the opposite direction adds these contributions to the propagating field and calculates the reflections of the forward-propagating field. By iterating this procedure until convergence is reached, a self-consistent algorithm is established.

## Boundary Conditions

Due to the finite size of the computational domain, appropriate boundary conditions must be chosen, which minimize any numeric errors in the propagation of the optical field related to boundary effects. In the standard FFT BPM, any waves propagating through a boundary will reappear as a new perturbation at the opposite side of the computation window, effectively representing periodic boundary conditions. In situations where the optical field vanishes at the domain boundaries, this effect can be neglected. In other cases, an absorbing boundary condition is needed.

Perfectly matched layers (PMLs) boundary conditions have the advantage of absorbing the optical field when it reaches the domain boundaries. The BPM implemented in Sentaurus Device supports the PML boundary condition, which has been developed for continuum spectra.

The formulation is based on the introduction of a stretching operator:

$$ \nabla_s \equiv \frac{1}{S_x} \hat{x} \frac{\partial}{\partial x} + \frac{1}{S_y} \hat{y} \frac{\partial}{\partial y} + \frac{1}{S_z} \hat{z} \frac{\partial}{\partial z} \tag{757} $$

Beam Propagation Method

from which an equivalent set of the Maxwell equations can be derived. In Eq. 757, $S_x$, $S_y$, and $S_z$ are called stretching parameters, which are complex numbers defined in different PML regions. In non-PML regions, these stretching parameters are equal to one. The modified propagation equation then reads:

$$ \phi(x, y, z + \Delta z) = \frac{1}{(2\pi)^2} \exp(i S_z k_0 \delta n \Delta z) \iint_{-\infty}^{\infty} d\vec{k}_t \exp(i\vec{k}_t \cdot \vec{r}) \exp(i S_z) \exp(i \sqrt{k_0^2 n_0^2 - \hat{k}_t^2} \Delta z) \tilde{\phi}(\vec{k}_t, z) \quad (758) $$

where $\hat{k}_t^2 = (k_x/S_x)^2 + (k_y/S_y)^2$ is the square of the stretched transverse wave number. The stretching parameters can be fine-tuned to minimize spurious reflections.

# Using Beam Propagation Method

## General

The following code excerpt describes the general setup for using the scalar BPM solver to compute the optical generation. The computation of the optical generation is activated by an `OpticalGeneration` section, in which the `QuantumYield` model, as defined in Eq. 738, p. 682 and Eq. 739, p. 683, can be specified. Solver-specific parameters are listed in the `BPM` section. The excitation parameters are split into the general `Excitation` section for parameters common to all optical solvers and the `BPM Excitation` section. In the latter section, you can select either a `PlaneWave` or `Gaussian` excitation.

The `GridNodes` parameter determines the number of discretization points for each spatial dimension. In the next line, the reference refractive index is specified that is used in the operator expansion in Eq. 755, p. 702.

The parameters related to the excitation field and the boundary conditions for each spatial dimension are grouped in subsections as explained here:

```
Physics {
  ...
  Optics (
    OpticalGeneration (
      QuantumYield (
        ...
      )
    )
    OpticalSolver (
      BPM (
        GridNodes = (256,256,1600)
        ReferenceRefractiveIndex = 2.2
        Excitation (
          ...
        )
      )
    )
  )
}
```

**21: Optical Generation**
Beam Propagation Method

```
        Boundary (
          ...
        )
      )
    )
    Excitation (
      Wavelength = 0.5
      Intensity = 0.1
      Theta = 0.0
    )
  )
)
}
```

As the reference refractive index can greatly influence the accuracy of the solution due its use in the expansion of the propagation operator, several options are available for its specification. The simplest option is to specify a globally constant value as shown above. For multilayer structures with large refractive index contrasts, better results can be achieved by using either the average or the maximum value of the refractive index in each propagation plane. In some cases, a reference refractive index that is computed as the field-weighted average of the refractive index in each propagation plane might be the best option. In addition to these options, a global offset can be specified to further optimize the results. For details about selecting the various options, see Table 235 on page 1559.

## Bidirectional BPM

The bidirectional BPM solver is activated by specifying a `Bidirectional` section in the `BPM` section:

```
Optics (
  OpticalSolver (
    BPM (
      ...
      Bidirectional (
        Iterations = 3
        Error = 1e-3
      )
    )
  )
)
```

In the `Bidirectional` section, two break criteria can be set to control the total number of forward and backward passes that are performed in the beam propagation method. If the number of iterations exceeds the value of `Iterations` or if the relative error with respect to the previous iteration is smaller than the value of `Error`, it is assumed that the solution has been found. Note that a single iteration can be either a forward or backward pass.

705

Beam Propagation Method

From a performance point of view, it is important to mention that consecutive iterations only require a fraction of CPU time compared with the initial pass.

For plotting the optical field after every iteration, the keyword `OpticalField` must be listed in the `Plot` section of the command file. If only the final optical intensity is of interest, it is sufficient to specify the keyword `OpticalIntensity` in the `Plot` section.

## Excitation

In the beam propagation method, a given input field, which is referred to as excitation in the remainder of this section, is propagated through the device structure. Two types of excitation are supported: a `Gaussian` and a (truncated) `PlaneWave`. Both are characterized by a propagation direction, wavelength, and power as shown below. In two dimensions, the propagation direction is determined by the angle between the positive y-axis and the propagation vector. To specify the propagation direction in three dimensions, two angles, `Theta` and `Phi`, must be given. Their definition is illustrated in Figure 45.

> **NOTE** The propagation direction must be along the z-direction (nonzero z-component of the propagation vector) in three dimensions and along the y-direction (nonzero y-component of the propagation vector) in two dimensions.

The incident light power in the plane wave is specified as the `Intensity` in [W/cm<sup>2</sup>]. For a Gaussian excitation, the given value refers to its maximum. All of these parameters are listed in the global `Excitation` section.

Definition of angles for specification of propagation direction in three dimensions

Figure 45 Definition of angles for specification of propagation direction in three dimensions

The excitation parameters common to all types of excitation are:

```
Physics {
  ...
  Optics (
    Excitation (
```

21: Optical Generation
Beam Propagation Method

```
               Theta = 10.0        # [degree]
               Phi = 60.0          # [degree], only in 3D
               Wavelength = 0.3    # [um]
               Intensity = 0.1     # [W/cm^2]
               ...
              )
              ...
      )
     }
```

A Gaussian excitation along the propagation direction defined by $k$ is determined by its half-width `SigmaGauss` [μm] and its center position `CenterGauss` [μm] as shown below for a 2D and 3D device geometry.

Gaussian excitation (2D):

```
 Physics {
  ...
  Optics(
          OpticalSolver (
           BPM (
             Excitation (
                Type = "Gaussian"
                SigmaGauss = (2.0)   # [um]
                CenterGauss = (0.0)  # [um]
             )
           )
          )
          ...
  )
 }
```

Gaussian excitation (3D):

```
 Physics {
  ...
  Optics(
          OpticalSolver (
           BPM (
             Excitation (
                Type = "Gaussian"
                SigmaGauss = (2.0,4.0) # [um]
                CenterGauss = (0.0,1.0) # [um]
             )
           )
          )
          ...
  )
 }
```

Beam Propagation Method

For a plane wave excitation, it is possible to specify the truncation positions for each coordinate axis as well as a parameter that determines the fall-off. For numeric reasons, a discrete truncation must be avoided. Instead, a Fermi function–like fall-off is available:

$$ F_{xy} = \left[ 1 + \exp \left( \frac{|\tilde{x}| - x_0}{s_x} \right) \right]^{-1} \cdot \left[ 1 + \exp \left( \frac{|\tilde{y}| - y_0}{s_y} \right) \right]^{-1} $$
$$ \phi(x, y, z = 0) = F_{xy} \cdot \phi_0 $$
(759)

which can be tuned by adjusting the TruncationSlope and TruncationPosition parameters in the Excitation section. In Eq. 759, $\phi_0$ is the amplitude of the incident light, $s_{x,y}$ denotes the TruncationSlope, $\tilde{x}, \tilde{y}$ is the position with respect to the symmetry point, and $x_0, y_0$ is the half width. Both $\tilde{x}, \tilde{y}$ and $x_0, y_0$ are deduced from the TruncationPosition parameters. In two dimensions, the second factor on the right-hand side in Eq. 759 is omitted.

Truncated plane wave excitation (2D):

```
Physics {
  Optics (
    OpticalSolver (
      BPM (
        Excitation (
          Type = "PlaneWave"
          TruncationPositionX = (-1.0,1.0)
          TruncationSlope = (0.3)
        )
      )
    )
    ...
  )
}
```

Truncated plane wave excitation (3D):

```
Physics {
  Optics (
    OpticalSolver (
      BPM (
        Excitation (
          Type = "PlaneWave"
          TruncationPositionX = (-1.0,1.0)
          TruncationPositionY = (-2.0,3.0)
          TruncationSlope = (0.3,0.3)
        )
      )
    )
  )
}
```

**21: Optical Generation**
Beam Propagation Method

# Boundary

For every spatial dimension, a separate boundary condition and corresponding parameters can be defined. Periodic boundary conditions inherent to the FFT BPM solver are the default in the transverse dimensions. The specification of PML boundary conditions in the x-direction and y-direction is shown below. With the keyword `Order`, the spatial variation of the complex stretching parameter can be specified. In this example, a quadratic increase from the minimum value to the maximum value within the given number of `GridNodes` on either side has been chosen.

Optionally, several `VacuumGridNodes` can be inserted between the physical simulation domain and the PML boundary:

```
Physics {
  Optics(
    OpticalSolver (
      BPM (
        Boundary (
          Type = "PML"
          Side = "X"
          Order = 2
          StretchingParameterReal = (1.0,1,0)
          StretchingParameterImag = (1.0,5.0)
          GridNodes = (5,5)
          VacuumGridNodes = (4,4)
        )
        Boundary (
          Type = "PML"
          Side = "y"
          Order = 2
          StretchingParameterReal = (1.0,1,0)
          StretchingParameterImag = (1.0,4.0)
          GridNodes = (8,8)
        )
      )
    )
    ...
  )
}
```

# Ramping Input Parameters

Several input parameters of the BPM solver such as the wavelength of the incident light can be ramped to obtain device characteristics as a function of the specified parameter. The general concept of ramping the values of physical parameters is described in Ramping Physical Parameter Values on page 79.

**21: Optical Generation**

**Beam Propagation Method**

For details about ramping Optics parameters, see Parameter Ramping on page 635.

## Visualizing Results on Native Tensor Grid

For an accurate analysis of the BPM results, the complex refractive index, the complex optical field, and the optical intensity can be plotted on the native tensor grid. In general, the results from the BPM solver are interpolated from a tensor grid to a mixed-element grid on which the device simulation is performed.

For physical and numeric reasons, the mesh resolution of the optical grid needs to be much finer than that of the electrical grid in most regions of the device. This can lead to the introduction of interpolation errors, for example, by undersampling the respective dataset on the electrical grid. To obtain an estimate of the interpolation error, it can be beneficial to visualize the BPM results on its native tensor grid. As typical tensor grids in three dimensions tend to be very large, it is also possible to extract a limited domain for more efficient visualization. In two dimensions, a rectangular subregion or an axis-aligned straight line can be plotted; whereas in three dimensions, a subvolume, a plane perpendicular to the coordinate axes, and a straight line can be visualized directly on the tensor grid.

Tensor plots can be activated by specifying one or more `TensorPlot` sections and an optional base name for the tensor-plot file name in the `File` section.

The following syntax extracts a plane perpendicular to the z-axis at position Z = 1.3 μm, which extends from –2 μm to 3 μm, and from –1 μm to 5 μm in the x- and y-direction, respectively:

```
File (
  ...
  TensorPlot = "tensor_plot"
)
...
TensorPlot (
  Name = "plane_z_const"
  Zconst = 1.3
  Xmin = -2
  Xmax = 3
  Ymin = -1
  Ymax = 5
){
  ComplexRefractiveIndex
  OpticalField
  OpticalIntensity
}
```

21: Optical Generation
Composite Method

To extract a box in three dimensions that extends over the whole device horizontally but is bound in the vertical direction, the `TensorPlot` section looks like:

```
TensorPlot (
  Name = "bounded_box"
  Zmin = 3
  Zmax = 8
){
  ...
}
```

# Composite Method

The composite method is an optical solver that composes an optical solution by summing the results of other optical solvers. Its flexibility targets applications with more complex optical setups that can be modeled as a linear superposition of individual solution components.

The unified interface for optical generation computation is limited in that the contribution from `ComputeFromMonochromaticSource` and `ComputeFromSpectrum` to the total optical generation rate is computed by the same optical solver. While some optical solvers allow the definition of different illumination windows, they still must share the same excitation parameters. It is also not possible to specify several `ComputeFromMonochromaticSource` and `ComputeFromSpectrum` sections at the same time to model, for example, different light sources illuminating a device. Sometimes you can work around these limitations by precomputing the illumination by one light source and loading it in a subsequent simulation using `ReadFromFile`. However, it typically results in more complex simulation setups and tool flows.

With the composite method, these limitations can be overcome. Its implementation is based on the mixed-mode simulation framework that requires the creation of a separate optical device instance for each optical solver. An optical device instance is essentially a device instance limited to the computation of an optical problem. For details about mixed-mode in Sentaurus Device, see Chapter 3 on page 41.

# Using the Composite Method

A typical simulation setup requires the definition of a named master `Device` or `OpticalDevice` (in the case of optics standalone simulations), and one or more additional definitions of `OpticalDevice`.

> **NOTE** Syntactically, there is no difference between a named `Device` and a named `OpticalDevice` section at the top level in the command file. However, instances created from these definitions fulfill different tasks.

Composite Method

In the master, the composite method is specified as the optical solver in the Optics section:

```
Device diode {
  File { ... }
  Electrode { ... }
  Plot { ... }
  Math { ... }
  Physics {
    ...
    Optics (
      ...
      OpticalSolver (Composite)
    )
  }
}

OpticalDevice optdevice {
  File { ... }
  Plot { ... }
  Math { ... }
  Physics {
    Optics (
      Excitation (
        Wavelength = 0.3
        Theta = 30
        Intensity = 0.1
      )
      OpticalSolver ( TMM (...) )
      ComplexRefractiveIndex ( ... )
      OpticalGeneration (
        ...
        ComputeFromMonochromaticSource ( ... )
        ComputeFromSpectrum ( ... )
      )
    )
  }
}
```

Any of the other optical solvers listed in Specifying the Optical Solver on page 614 can be specified in the `OpticalDevice` definitions whose instances are accessed by the composite method. You can create more than one instance from a given `OpticalDevice` definition and overwrite specific parameters in the instantiation statement.

This is particularly useful for modeling different illumination sources that share many common properties. For example:

```
System {
  diode d1 (
    "p-contact" = vdd "n-contact" = gnd
```

21: Optical Generation

Composite Method

```
      OpticalDevice = [ "tmm1" "tmm2" "tmm3" ]
    ) { ... }
    optdevice tmm1 () { Physics { Optics ( Excitation (Wavelength = 0.4) ) } }
    optdevice tmm2 () { Physics { Optics ( Excitation (Theta = 50) ) } }
    optdevice tmm3 () { Physics { Optics ( Excitation (Intensity = 0.2) ) } }
}
```

In this example, the device instance `d1` is associated with the optical device instances `tmm1`, `tmm2`, and `tmm3` by the `OpticalDevice` statement. These are the optical device instances that the Composite solver defined in `Device diode` will consider when composing its solution.

In the `Solve` section, the different instances can be addressed separately by preceding the equation name with the instance name followed by a dot, or as a whole by specifying the equation only as shown in the optics standalone example:

```
Solve {
  tmm1.Optics
  Coupled (d1.Optics tmm2.Optics tmm3.Optics)
  Optics
}
```

In optoelectronic simulations, the `Optics` equation can be omitted and is solved implicitly (considering all device and optical device instances) if the corresponding optical generation models are activated:

```
Solve {
  Quasistationary (
    InitialStep = 1 MaxStep = 1 MinStep = 1
    Goal { OpticalDevice = "tmm1" ModelParameter = "Wavelength" = 0.8 }
    Goal { OpticalDevice = "tmm3" ModelParameter = "Wavelength" = 0.4 }
  ) {
    Coupled { Poisson Electron Hole }
  }
}
```

**NOTE** The `Coupled` statement can contain either electrical transport equations such as `Poisson`, `Electron`, and `Hole`, or several instance-specific `Optics` equations, but not a combination of both. If you want to explicitly call `Optics` and electrical transport equations, you must use a `Plugin` statement.

Generally, simulation results such as spatial-dependent plots and current plots are produced for each `Device` or `OpticalDevice` instance according to the respective `Plot` and `CurrentPlot` sections. However, for ease of use, the most relevant spatial-dependent datasets from `OpticalDevice` instances used by the Composite solver are written automatically to corresponding TDR files.

Controlling Interpolation When Loading Optical Generation Profiles

Such datasets have their original dataset name appended with `FromInstance_<instance name>`, for example, `OpticalGenerationFromInstance_tmm1`.

To access `CurrentPlot` quantities from one `Device` or `OpticalDevice` in another `Device` or `OpticalDevice`, use either the `Device="<name>"` or `OpticalDevice="<name>"` specification in the `CurrentPlot` section.

# Controlling Interpolation When Loading Optical Generation Profiles

You can load optical generation and absorbed photon density profiles into Sentaurus Device using either of the following features:

*   Loading and Saving Optical Generation From and to Files on page 601

*   Loading Solution of Optical Problem From Files on page 695

If the optical generation or absorbed photon density profile to be loaded is defined on a grid that is different from the one used in the device simulation, it is interpolated automatically onto the simulation grid upon loading. The source grid can be either a mixed-element grid or a tensor grid resulting from an EMW simulation. By default, vertex-based linear interpolation is used.

For mixed-element to mixed-element interpolation, a conservative interpolation algorithm is supported <sup>[9]</sup>, which guarantees that the integral of the interpolation quantity on the source grid is the same as on the destination grid. To select this option, set `GridInterpolation` to `Conservative` instead of `Simple`.

The result of the interpolation can be further controlled by specifying a relative shift between the source and the destination grid, as well as by restricting the source and destination domain used for the interpolation. This feature is useful when the optical solution has been computed on a smaller or larger domain than the electrical simulation grid and, therefore, must be aligned accordingly.

The `ShiftVector` is specified directly in the `ReadFromFile` or `FromFile` section; whereas, the source and destination domain is specified in a section called `ImportDomain`.

A domain can be defined as either a list of regions or a box given by its lower-left and upper-right corners as shown in this example:

```
Physics {
  Optics (
    OpticalGeneration (
      ReadFromFile (
```

**21: Optical Generation**

Controlling Interpolation When Loading Optical Generation Profiles

```
GridInterpolation = Conservative
ShiftVector = (0.5 1 2)
ImportDomain (
    SourceRegions = ("substrate", "region_1")
    DestinationBoxCorner1 = (0.5 0.5 1)
    DestinationBoxCorner2 = (2 2 4)
)
```

Figure 46 illustrates the concept of domain truncation using source and destination domains, as well as applying a relative shift between the optical and electrical grids.

Illustration of domain truncation and shifting of source and destination grids used in interpolation, showing Optical Grid with Restricted Source Domain and Electrical Grid with Restricted Destination Domain, followed by their combination with a Shift Vector and Interpolation (Import) Region.

Figure 46 Illustration of domain truncation and shifting of source and destination grids used in interpolation

Optical AC Analysis

The interpolation algorithm always interpolates the values even if the material of the source and destination grid is different at a certain vertex. However, optical generation is always set to zero in nonsemiconductor regions irrespective of the source profile. For details about specifying the source and destination domain in the `ImportDomain` section, see Table 241 on page 1562.

**NOTE** `GridInterpolation`, `ShiftVector`, and `ImportDomain` are not supported for the importing of 1D profiles because the Illumination Window on page 622 already provides similar functionality.

Region domains specified in the `ImportDomain` section are supported only for source grids that are mixed-element type or tensor type, containing region information (the `Extractor` section in EMW must contain `Region` in the `Quantity` list).

# Optical AC Analysis

An optical AC analysis calculates the quantum efficiency as a function of the frequency of the optical signal intensity. The method is based on the AC analysis technique and provides real and imaginary parts of the quantum efficiency versus the frequency.

During an optical AC analysis, a small perturbation of the incident wave power $\delta P_0$ is applied. Therefore, the photogeneration rate is perturbated as $G^{opt} + \delta G^{opt} e^{i\omega t}$, where $\omega = 2\pi f$ ($f$ is the frequency) and $\delta G^{opt}$ is an amplitude of a local perturbation.

The resulting small-signal device current perturbation $\delta I_{dev}$ is the sum of real and imaginary parts, and the expressions for the quantum efficiency are:

$$ \eta = \frac{Re[\delta I_{dev}]/q}{\delta P^{tot} \lambda / hc} $$
$$ C_{opt} = \frac{1}{\omega} \cdot \frac{Im[\delta I_{dev}]/q}{\delta P^{tot} \lambda / hc} \eqno(760) $$
$$ \delta P^{tot} = \int_S \delta P_0 ds $$

where the quantity $\delta P^{tot} \lambda / hc$ gives a perturbation of the total number of photons and $Re[\delta I_{dev}]/q$ is a perturbation of the total number of electrons at an electrode. As a result, for each electrode, Sentaurus Device places two values into the AC output file, `photo_a` and `photo_c`, that correspond to $\eta$ and $C_{opt}$, respectively. To start the optical AC analysis, add the keyword `Optical` in the `ACCoupled` statement. For example:

```
ACCoupled ( StartFrequency=1.e4 EndFrequency=1.e9
            NumberOfPoints=31 Decade Node(a c) Optical )
{ poisson electron hole }
```

21: Optical Generation
References

**NOTE** If an element is excluded (`Exclude` statement) in optical AC (this is usually the case for voltage sources in regular AC simulation), it means that this element is not present in the simulated circuit and, correspondingly, it provides zero AC current for all branches that are connected to the element. Therefore, do *not* exclude voltage sources.

# References

[1] B. R. Bennett, R. A. Soref, and J. A. Del Alamo, “Carrier-Induced Change in Refractive Index of InP, GaAs, and InGaAsP,” IEEE Journal of Quantum Electronics, vol. 26, no. 1, pp. 113–122, 1990.

[2] D. A. Clugston and P. A. Basore, “Modelling Free-carrier Absorption in Solar Cells,” Progress in Photovoltaics: Research and Applications, vol. 5, no. 4, pp. 229–236, 1997.

[3] D. K. Schroder, R. N. Thomas, and J. C. Swartz, “Free Carrier Absorption in Silicon,” IEEE Journal of Solid-State Circuits, vol. SC-13, no. 1, pp. 180–187, 1978.

[4] H. E. Bennett and J. O. Porteus, “Relation Between Surface Roughness and Specular Reflectance at Normal Incidence,” Journal of the Optical Society of America, vol. 51, no. 2, pp. 123–129, 1961.

[5] P. Beckmann and A. Spizzichino, *The Scattering of Electromagnetic Waves from Rough Surfaces*, Norwood, Massachusetts: Artech House, 1987.

[6] J. Krc, F. Smole, and M. Topic, “Analysis of Light Scattering in Amorphous Si:H Solar Cells by a One-Dimensional Semi-coherent Optical Model,” *Progress in Photovoltaics: Research and Applications*, vol. 11, no. 1, pp. 15–26, 2003.

[7] M. D. Feit and J. A. Fleck, Jr., “Light propagation in graded-index optical fibers,” *Applied Optics*, vol. 17, no. 24, pp. 3990–3998, 1978.

[8] P. Kaczmarski and P. E. Lagasse, “Bidirectional Beam Propagation Method,” *Electronics Letters*, vol. 24, no. 11, pp. 675–676, 1988.

[9] F. Alauzet and M. Mehrenberger, “P<sup>1</sup>-conservative solution interpolation on unstructured triangular meshes,” *International Journal for Numerical Methods in Engineering*, vol. 84, no. 13, pp. 1552–1588, 2010.

## References

 