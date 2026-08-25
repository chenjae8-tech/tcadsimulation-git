# CHAPTER 33 Thermal Properties

*This chapter describes the models that are important for lattice heating and the thermodynamic model: heat capacity, thermal conductivity, and thermoelectric power.*

## Heat Capacity

Table 162 lists the values of the heat capacity used in Sentaurus Device.

Table 162 Values of heat capacity c for various materials

| Material | c [J/K cm³] | Reference |
| --- | --- | --- |
| Silicon | 1.63 | [[1]]([1]) |
| Ceramic | 2.78 | [[2]]([2]) |
| SiO2 | 1.67 | [[2]]([2]) |
| Poly Si | 1.63 | ≈ Si |

By default, or when you specify `HeatCapacity(TempDep)` in the `Physics` section, the temperature dependency of the lattice heat capacity is modeled by the empirical function:

$$ c_L = cv + cv\_bT + cv\_cT^2 + cv\_dT^3 $$ (1076)

The equation coefficients can be specified in the parameter file by using the syntax:

```
LatticeHeatCapacity{
       cv = 1.63         # [J/(K cm^3)]
       cv_b = 0.0000e+00 # [J/(K^2 cm^3)]
       cv_c = 0.0000e+00 # [J/(K^3 cm^3)]
       cv_d = 0.0000e+00 # [J/(K^3 cm^3)]
}
```

All these coefficients can be mole fraction–dependent for mole-dependent materials.

To use a PMI model to compute heat capacity, specify the name of the model as a string as an option to `HeatCapacity` (see Heat Capacity on page 1300). To use a multistate configuration–dependent PMI for heat capacity, specify the model and its parameters as arguments to `PMIModel`, which, in turn, is an argument to `HeatCapacity` (see Multistate Configuration–Dependent Heat Capacity on page 1290).

33: Thermal Properties

Heat Capacity

To use a constant lattice heat capacity without touching the parameter file, specify `HeatCapacity(Constant)`.

# The pmi_msc_heatcapacity Model

The model can depend on state occupation probabilities of a multistate configuration (MSC). If no explicit dependency on an MSC is given, then it allows a piecewise linear (pwl) dependency on the lattice temperature, that is, it reads:

$$ c_V = c_V(T) \tag{1077} $$

If the model depends on an MSC, for each MSC state, then the heat capacity can be pwl temperature–dependent. The overall heat capacity is then averaged according to:

$$ c_V = \sum_{i} c_{V,i}(T)s_i \tag{1078} $$

where the sum is taken over all MSC states, and $s_i$ are the state occupation probabilities.

The model is activated in the `Physics` section by:

`HeatCapacity ( PMIModel ( Name="pmi_msc_heatcapacity" MSConfig="msc0" ) )`

Table 163 Parameters of pmi_msc_heatcapacity model

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| plot | – | 0 | – | {0,1} | Plot parameter to screen |
| cv | $c_V$ | 0. | J/Kcm³ | real | Constant value |
| cv_nb_Tpairs | – | 0 | – | >=0 | Number of interpolation points |
| cv_Tp<int>_X | –- | – | K | real | Temperature at <int>-th interpolation point |
| cv_Tp<int>_Y | – | – | J/Kcm³ | real | Value at <int>-th interpolation point |

You use the `cv` parameter to set a constant heat capacity, which is used as a global (no MSC dependency) or default state heat capacity. However, if you specify `cv_nb_Tpairs` greater than zero, the global and default state heat capacities are piecewise linear. In that case, you must specify the interpolation points as pairs of temperature and heat capacity values by using `cv_Tp<int>_X` and `cv_Tp<int>_Y`, respectively, where `<int>` ranges from zero to one less than `cv_nb_Tpairs`.

The global `cv_` parameters can be prefixed with `<state_name>_` for the named MSC states to overwrite the default state behavior.

 33: Thermal Properties
Thermal Conductivity

# Thermal Conductivity

Sentaurus Device uses the following temperature-dependent thermal conductivity $\kappa$ in silicon [3]:

$$ \kappa(T) = \frac{1}{a + bT + cT^2} \tag{1079} $$

where $a = 0.03 \text{ cm K W}^{-1}$, $b = 1.56 \times 10^{-3} \text{ cm W}^{-1}$, and $c = 1.65 \times 10^{-6} \text{ cm W}^{-1} \text{ K}^{-1}$. The range of validity is from 200 K to well above 600 K. Table 164 lists values of the thermal conductivity for some materials.

Table 164 Values of thermal conductivity $\kappa$ of silicon versus temperature

| Material | κ [W/(cm K)] | Reference |
| --- | --- | --- |
| Silicon | Eq. 1079 | [3] |
| Ceramic | 0.167 | [4] |
| SiO₂ | 0.014 | [1] |
| Poly Si | 1.5 | ≈ Si |

As additional options to the standard specification of the thermal conductivity model, there are two different expressions to define either thermal resistivity $\chi = 1/\kappa$ or thermal conductivity for any material. This is performed by using `Formula` in the parameter file or special keywords in the command file.

For `Formula=0` (thermal resistivity specification), Sentaurus Device uses:

$$ \chi = 1/\text{kappa} + 1/\text{kappa\_b} T + 1/\text{kappa\_c} T^2 \tag{1080} $$

For `Formula=1` (thermal conductivity specification), it is:

$$ \kappa = \text{kappa} + \text{kappa\_b} T + \text{kappa\_c} T^2 \tag{1081} $$

**NOTE** Sentaurus Device stores six independent parameters, namely:

* `1/kappa`, `1/kappa_b`, and `1/kappa_c` for the thermal resistivity model in Eq. 1080

* `kappa`, `kappa_b`, and `kappa_c` for the thermal conductivity model in Eq. 1081

Changing `kappa` does not modify `1/kappa` and vice versa. The same applies to `kappa_b` and `1/kappa_b`, as well as `kappa_c` and `1/kappa_c`.

Thermal Conductivity

Use the following syntax in the parameter file to select the required model and to specify the coefficients:

```
Kappa{
    Formula = 0
    1/kappa = 0.03           # [K cm/W]
    1/kappa_b = 1.5600e-03   # [cm/W]
    1/kappa_c = 1.6500e-06   # [cm/(W K)]
    kappa = 1.5              # [W/(K cm)]
    kappa_b = 0.0000e+00     # [W/(K^2 cm)]
    kappa_c = 0.0000e+00     # [W/(K^3 cm))]
}
```

The Physics section of the command file provides more flexibility to switch these expressions by using the keywords:

```
ThermalConductivity(
    TempDep Conductivity   # Formula = 1
    Constant Conductivity  # Formula = 1 without temperature dependence
    TempDep Resistivity    # Formula = 0
    Constant Resistivity   # Formula = 0 without temperature dependence
```

By default, Sentaurus Device uses Formula specified in the parameter file. All these coefficients in the parameter file can be mole dependent for mole-dependent materials.

Furthermore, a simple PMI and a multistate configuration–dependent PMI are available to compute thermal conductivity. See Thermal Conductivity on page 1311 and Multistate Configuration–Dependent Thermal Conductivity on page 1293.

# The AllDependent Thermal Conductivity Model

In general, thermal conductivity $\kappa$ is a function of lattice temperature $T$, doping density $N$, layer thickness $d_{Ly}$, and mole fraction $x$. Starting with the Boltzmann transport equation for phonons and with relaxation time approximations, $\kappa$ is expressed as an integral over phonon frequency [5]:

$$ \kappa = \frac{1}{3} \cdot \frac{1}{2\pi^2} \cdot n_j \cdot \sum_j \int_0^{\omega_{0,j}} \frac{\tau_{\omega,j}}{v_{\omega,j}} C(\omega) \omega^2 d\omega \tag{1082} $$

$$ C(x) = kx^2 e^x (e^x - 1)^{-2} \tag{1083} $$

$$ x = \frac{\hbar\omega}{kT} \tag{1084} $$

**33: Thermal Properties**
Thermal Conductivity

For each phonon branch $\kappa$, $\omega_{0,j}$ is the peak frequency, $v_{0,j}$ is the sound velocity, and $\tau_{0,j}$ is the total relaxation time. For the longitudinal mode ($j = L$), $n_L = 1$. For the transverse mode ($j = T$), $n_T = 1$.

# Bulk Thermal Conductivity Computation

The total relaxation time is calculated with given scattering mechanisms. For pure bulk material [5]:

$$ \tau_{LN}^{-1} = B_L \omega^2 T^3 + \tau_I^{-1} + \tau_b^{-1}, 0 < \omega < \omega_3 $$ (1085)

$$ \tau_{TN}^{-1} = B_T \omega T^4 + \tau_I^{-1} + \tau_b^{-1}, \omega < \omega_1 $$ (1086)

$$ \tau_{TU}^{-1} = B_{TU} \omega^2 / \sinh x + \tau_I^{-1} + \tau_b^{-1}, \omega_1 < \omega < \omega_2 $$ (1087)

$$ \tau_I^{-1} = A_I \omega^4 $$ (1088)

$$ \tau_b^{-1} = \frac{v_s}{FL} $$ (1089)

$$ v_s = \left[ \frac{1}{3} (v_L^{-1} + 2v_T^{-1}) \right]^{-1} $$ (1090)

Eq. 1085, Eq. 1086, and Eq. 1087 represent the phonon relaxation time for the longitudinal and transverse branches. For the transverse branch, the normal (N) process and the Umklapp (U) process are solved separately. Frequencies and phonon velocities are extracted from the bulk phonon dispersion:

* $\omega_1$ is the turning point of the transverse branch, where the U process starts to have an effect.

* $\omega_2$ is the peak frequency of the transverse branch.

* $\omega_3$ is the peak frequency of the longitudinal branch.

* $\omega_4$ is the turning point of the longitudinal branch.

* $v_L$ is the velocity of the longitudinal mode when $\omega < \omega_4$.

* $v_{Lp}$ is the velocity of the longitudinal mode when $\omega_4 < \omega < \omega_3$.

* $v_T$ is the velocity of the transverse mode when $\omega < \omega_1$.

* $v_{TU}$ is the velocity of the transverse mode when $\omega_1 < \omega < \omega_2$.

* $B_L$, $B_T$, and $B_{TU}$ are fitting parameters.

Thermal Conductivity

* $\tau_I^{-1}$ and $\tau_b^{-1}$ represent scattering due to point defects and the boundary, where:

    * $A_I$ is the scattering strength due to defects.

    * $L$ is the bulk sample dimension.

The model is activated in the command file by:

```
Physics (...) {
    ThermalConductivity ( AllDep )
}
```

## Example of Parameter File Segment

```
Kappa {
    ...
    omega1 = 2.357e13    #[s^-1]
    omega2 = 2.749e13    #[s^-1]
    ...
}
```

Table 165 Summary of parameters for bulk silicon and germanium

| Name | Symbol | Silicon | Germanium | Unit |
| --- | --- | --- | --- | --- |
| omega1 | $\omega_1$ | 2.357e13 | 1.322e13 | 1/s |
| omega2 | $\omega_2$ | 2.749e13 | 1.545e13 | 1/s |
| omega3 | $\omega_3$ | 7.463e13 | 4.36e13 | 1/s |
| omega4 | $\omega_4$ | 4.582e13 | 2.514e13 | 1/s |
| vL | $\nu_L$ | 8.48e3 | 4.92e3 | m/s |
| vLp | $\nu_{Lp}$ | 4.24e3 | 2.46e3 | m/s |
| vT | $\nu_T$ | 5.86e3 | 3.55e3 | m/s |
| vTU | $\nu_{TU}$ | 2e3 | 1.3e3 | m/s |
| BL | $B_L$ | 2e-24 | 6.9e-24 | s/K³ |
| BT | $B_T$ | 9.3e-13 | 1e-11 | 1/K⁴ |
| BTU | $B_{TU}$ | 5.5e-18 | 5e-18 | s |
| AI | $A_I$ | 1.32e-45 | 2.4e-45 | s³ |
| Lb | $L$ | 0.716e-2 | 0.24e-2 | m |
| V_h | $V$ | 12.1e-6 | 13.6e-6 | m³/mol |
| M_h | $M$ | 28 | 72.6 | Da |
| R_h | $R$ | 146e-12 | 125e-12 | m |

33: Thermal Properties
Thermal Conductivity

Table 165 Summary of parameters for bulk silicon and germanium (Continued)

| Name | Symbol | Silicon | Germanium | Unit |
| --- | --- | --- | --- | --- |
| epsilon | εs | 11.7 | 16.2 | 1 |
| m_c | me | 0.9 | 0.9 | 1 |
| m_v | mh | 0.58 | 0.58 | 1 |
| rho | ρ | 2.329e3 | 5.323e3 | kg/m³ |

**NOTE** To achieve good agreement with measurement, you need to understand the relative contribution of the three phonon branches to κ: κ<sub>TU</sub> mainly determines the high-temperature range. The absolute values of κ<sub>T</sub> and κ<sub>L</sub> determine the peak value of κ, while their relative ratio κ<sub>T</sub>/κ<sub>L</sub> affects the slope of κ at low temperatures: the lower the ratio, the larger the slope. The fitting parameters $B_L$, $B_T$, and $B_{TU}$ are determined accordingly.

## Bulk Relaxation Time With Doping

In the case of doped samples, κ decreases due to phonon scattering with impurities and free carriers. The phonon-impurity scattering is treated in a similar way to point defects [6]:

$$ \tau_{impurity}^{-1} = A\omega^4 $$ (1091)

$$ A = A_I + A_{\delta M} + A_{\delta R} + A_x $$ (1092)

$$ A_{\delta M} = \frac{NV^2}{4\pi v_s^3} \left( \frac{M - M_{doped}}{M} \right)^2 $$ (1093)

$$ A_{\delta R} = \frac{2NV^2}{\pi v_s^3} Q_0^2 \Upsilon^2 \left( \frac{R - R_{doped}}{R} \right)^2 $$ (1094)

$A_{\delta M}$ and $A_{\delta R}$ model the impact of mass and radius differences between the host atom and the impurity atom with the given doping concentration $N$, where:

*   $V$ is the crystal volume of the host atom.

*   $M$ is the mass of the host atom.

*   $M_{doped}$ is the mass of the impurity atom.

*   $R$ is the radius of the host atom.

*   $R_{doped}$ is the radius of the impurity atom.

Thermal Conductivity

*   $Q_0$ is a constant corresponding to the impurity.

*   $A_x$ is a fitting parameter.

The impact of phonon-carrier scattering is considered with two parts: the free carriers in the metallic state and the carriers bound to the impurity center. With a given carrier concentration $n$, the concentrations of bound carriers $N_n$ and metallic carriers $N_m$ are [7]:

$$N_n = n \exp(-t_c)$$ (1095)

$$N_m = n[1 - \exp(-t_c)]$$ (1096)

$$t_c = (4\pi/3)nr_c^3$$ (1097)

$$r_c = (144/\pi^2)^{1/3}a_B$$ (1098)

where the Bohr radius $a_B$ is:

$$a_B = \left( \frac{4\pi\epsilon_0\hbar^2}{m_0e^2} \right) \left( \frac{\epsilon_s}{\epsilon_0} \right) \left( \frac{m_0}{m_e} \right)$$ (1099)

Here:

*   $\epsilon_s$ is the dielectric constant.

*   $m_e$ (or $m_h$) is the electron (or hole) effective mass of the host atom.

The relaxation time related to bound carriers is [8]:

$$\tau_{\text{bound}, j}^{-1} = \frac{\omega^4[(1/3)\Xi_u]^4}{10\pi\rho^2v_s^2} \chi^2 \left( \frac{\omega}{v_s} \right) \left[ v_L^{-5} \chi^2 \left( \frac{\omega}{v_L} \right) + \frac{3}{2} v_T^{-5} \chi^2 \left( \frac{\omega}{v_T} \right) \right] \cdot w_j \cdot \frac{2\Delta^2}{(\Delta^2 - \hbar^2\omega^2)^2} (2N_n)$$ (1100)

$$\chi(q_j) = [1 + (1/4)a_B^2q_j^2]^{-2}$$ (1101)

where:

*   $\Xi_u$ is the shear deformation potential.

*   $\rho$ is the crystal mass density.

*   $w_L$, $w_T$, and $w_{TU}$ are parameters corresponding to each phonon mode.

33: Thermal Properties
Thermal Conductivity

For carriers in metallic states, the relaxation time is [6]:

$$ \tau_{\text{free}}^{-1} = \frac{(m_e E_D)^2 \omega}{2\pi\rho\hbar^3 v_s}, q < 2k_F $$ (1102)

$$ \tau_{\text{free}}^{-1} = \frac{b N_m (m_e E_D)^2}{\rho\hbar^3 q^5 a_B^3}, q > 2k_F $$ (1103)

where $E_D$ is the deformation potential, and $b$ is a fitting parameter.

Eq. 1102 and Eq. 1103 are continuous at $q = 2k_F$, which imposes the following relation:

$$ k_F = \left( \frac{b N_m \pi}{32 a_B^3} \right)^{1/6} $$ (1104)

Eq. 1091, Eq. 1100, Eq. 1102, and Eq. 1103 are added to Eq. 1085, Eq. 1086, and Eq. 1087 to solve for $\tau_{B,j}$, which is the bulk relaxation time.

Table 166 Summary of parameters for phosphorus and boron in silicon bulk samples

| Symbol | Name | Phosphorus | Name | Boron | Unit |
| --- | --- | --- | --- | --- | --- |
| Mdoped | M_n | 30.9 | M_p | 10.8 | Da |
| Rdoped | R_n | 123e-12 | R_p | 117e-12 | m |
| Q0 | Q0_n | 4 | Q0_p | 15 | 1 |
| Ξu | Eu_n | 9 | Eu_p | 45 | eV |
| wL | wL_n | 0.2 | wL_p | 0.02 | 1 |
| wT | wT_n | 8 | wT_p | 6 | 1 |
| wTU | wTU_n | 0.9e6 | wTU_p | 2e6 | 1 |

$E_D$, $b$, and $A_x$ are fitted to experiments for a given doping concentration and doping material.

Table 167 Summary of fitting parameters for phosphorus-doped silicon bulk samples

| Symbol | Name | Doping concentration [cm–3] | Unit |  |  |  |  |  |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 7.5e16 | 2.5e17 | 4.7e17 | 1e18 | 2e19 | 1.7e20 |  |  |  |
| ED | ED_n | 0 | 0.05 | 0.22 | 0.5 | 1.33 | 2.33 | eV |
| b | b | 0 | 8 | 8 | 8 | 186 | 286 | 1 |
| Ax | Ax | 0 | 0 | 11.75 | 11.75 | 6.75 | 11.75 | × 10–45 s3 |

Thermal Conductivity

Table 168 Summary of fitting parameters for boron-doped silicon bulk samples

| Symbol | Name | Doping concentration [cm-3] | Unit |  |  |
| --- | --- | --- | --- | --- | --- |
| 1e13 | 4e15 | 4e16 |  |  |  |
| ED | ED_p | 0 | 0 | 0.5 | eV |
| b | b | 0 | 0 | 18 | 1 |
| Ax | Ax | 0 | 0 | 1.2 | × 10-45 s3 |

**NOTE** To achieve good agreement with measurements for various doping concentrations, it is suggested to first determine $w_L$, $w_T$, and $w_{TU}$ for low-doping concentration samples: $w_{TU}$ mainly determines the high-temperature range, and $w_L$ and $w_T$ determine the peak value and their ratio $w_L/w_T$ determines the slope of the low-temperature range. For moderate doping cases, free-carrier scattering starts to have an effect; therefore, $E_D$ and $b$ are used to further fit the low-temperature range. For high doping cases, bound-carrier scattering is insignificant; therefore, $\kappa$ is mainly determined by $E_D$, $b$, and $A_x$.

In general, $E_D$, $b$, and $A_x$ must be fitted for each doping concentration. To provide a good guess for their values, a numerical table can be defined in the parameter file:

```
Kappa {
  NumericalTable (
    ** N ED_n ED_p b Ax
    7.5e16 0 0.5 8 0
    2.5e17 0.05 0.5 8 0
    ...
  )
}
```

The numerical table defines the fitted values of `ED_n`, `ED_p`, `b`, and `Ax` for some specific doping concentrations $N$. For other doping concentrations, these parameters are determined by interpolating the given values in the `NumericalTable`.

## Thin-Layer Relaxation Time

For thin layers with thickness $d_{Ly}$, the relaxation time decreases [9]:

$$\tau_{Ly,j} = F(\delta_j, p)\tau_{B,j}$$ (1105)

$$F(\delta_j, p) = 1 / \left[ 1 + \frac{3}{8\delta_j}(1 - p) \right]$$ (1106)

33: Thermal Properties

Thermal Conductivity

where $\delta_j = r_\delta d_{Ly} / (v_j \tau_{B,j})$ and $p = \exp(-\frac{16\pi^3\eta^2}{\lambda^2})$, and where:

*   $r_\delta$ is a constant to adjust the mean free path in some situations.

*   $d_{Ly}$ is the layer thickness.

*   $\eta$ is a fitting parameter.

*   $\lambda = 2\pi v_s / \omega$.

The layer thickness is computed internally by setting the `LayerThickness` command in the Physics section (see Extracting Layer Thickness on page 333). Alternatively, you can define the layer thickness by setting the parameter $d_{Ly}$ if `LayerThickness` is not defined. By default, $d_{Ly}$ is 0.3 m, which ensures $F(\delta_j, p) = 1$, thereby the bulk relaxation time is taken into account.

Table 169 Default values for thin-layer parameters and the numeric integral

| Symbol | Name | Default | Range | Unit |
| --- | --- | --- | --- | --- |
| dLy | dLy | 3e-1 | real | m |
| rδ | r_del | 1 | [0,1] | 1 |
| η | eta | 1.5e-10 | real | m |
| Nω | Nomg | 3 | integer | 1 |
| ζ | order | 2 | integer | 1 |

# Mole Fraction–Dependent Relaxation Time

To compute $\kappa$ for alloy materials such as SiGe, the parameters are interpolated according to the standard Vegard law. This is performed using the built-in MoleFraction-dependent functionality in Sentaurus Device. All parameters in Table 165 on page 972 are MoleFraction-dependent parameters.

An example of the parameter file is:

```
Kappa {
  ...
  omega1(0) = 2.357e13 #[s^-1]
  omega1(1) = 1.322e13 #[s^-1]
  ...
  AI(0) = 1.32e-45 #[s^3]
  AI(1) = 2.4e-45 #[s^3]
  Xmax(1) = 1
  B(AI(1)) = -3.74e-42
}
```

Thermal Conductivity

> **NOTE** Impurity scattering is significant in alloy materials. Therefore, `B(AI(1))` is fitted to achieve good agreement with measurement.

Eq. 1082 involves an integral over phonon frequency. The numeric integration is solved with the Gauss quadrature method, which can be fine-tuned by adjusting the following parameters:

*   $N_\omega$ is the number of integration points.

*   $\zeta$ is the order of the Legendre polynomial that is used in the Gauss quadrature method.

Table 169 on page 977 lists the default values of these two parameters. More integration points and higher orders generally lead to more accurate results, while the performance decreases significantly. Nevertheless, when using $N_\omega = 3$ and $\zeta = 2$, the computed $\kappa$ agrees well with measurements.

---

# The ConnellyThermalConductivity Model

For thin layers, the scattering of acoustic phonons at interfaces reduces the mean free path and reduces thermal conductivities. In the review paper [[10]](reference_10), an integral equation describes the geometric effect of the reduced phonon path. The actual model provides an excellent fit of the behavior. The thermal conductivity $\kappa$ is given by:

$$ \kappa = \kappa_{\text{bulk}} \left( \frac{t + t_0}{0.6\Lambda + t + t_0} \right)^\eta $$ (1107)

where:

*   $t$ is the layer thickness extracted by the simulator for the layer.

*   $t_0$ is the phonon penetration at interfaces.

*   $\Lambda$ is the phonon mean free path.

*   $\eta$ is the power exponent for the thickness dependency.

*   $\kappa_{\text{bulk}}$ is the bulk thermal conductivity.

Table 170 Parameters of ConnellyThermalConductivity model

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| plot | – | 0 | – | {0,1} | Plots parameter to screen |
| lambda | $\Lambda$ | 0.3 | μm | real | Phonon mean free path |
| t0 | $t_0$ | 5e-4 | μm | >=0 | Phonon penetration at interfaces |
| eta | $\eta$ | 0.8 | 1 | real | Power exponent |
| UseLayerThicknessField | – | 0 | – | {0,1} | Selects layer thickness quantity |
| bulkmodel | – | Kappa | – | string | Name for bulk model parameter |

**33: Thermal Properties**
Thermal Conductivity

# Layer Thickness Computation

The layer thickness $t$ is computed internally (see Extracting Layer Thickness on page 333). By default, the model uses the layer thickness quantity `LayerThickness`. Setting `UseLayerThicknessField=1` selects the quantity `LayerThicknessField`.

# Bulk Thermal Conductivity Computation

The bulk thermal conductivity $\kappa_{\text{bulk}}$ is computed from parameters found in the section given by the `bulkmodel` parameter. It recognizes the parameters given in Table 171.

Table 171 Parameters of ConnellyThermalConductivity for bulk thermal conductivity

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| Formula | – | 0 | – | {0,1} | Selects formula |
| a1 | $a_1$ | 1. | W/K cm | real | See Eq. 1109 |
| b1 | $b_1$ | 0. | W/K² cm | real |  |
| c1 | $c_1$ | 0. | W/K³ cm | real |  |
| a0 | $a_0$ | 1. | K cm/W | real | See Eq. 1108 |
| b0 | $b_0$ | 0. | cm/W | real |  |
| c0 | $c_0$ | 0. | cm/W K | real |  |

Similar to the default model, for `Formula=0`:

$$ \kappa_{\text{bulk}} = \frac{1}{a_0 + b_0 T + c_0 T^2} \text{ (1108)} $$

For `Formula=1`:

$$ \kappa_{\text{bulk}} = a_1 + b_1 T + c_1 T^2 \text{ (1109)} $$

The model is activated in the command file by:

```
Physics (...) {
  ThermalConductivity ( "ConnellyThermalConductivity" )
}
```

Thermal Conductivity

## Example of Parameter File Segment

```
Material = "MyMaterial" {
  ConnellyThermalConductivity {
    lambda = 0.3                    * [um]
    ...
    UseLayerThicknessField = 0      * use LayerThickness/LayerThicknessField
    bulkmodel = "MyKappa"           * bulk model name
  }
  MyKappa {                         * parameter section specified by 'bulkmodel'
    Formula = 0                     * select formula
    ...
  }
}
```

# The pmi_msc_thermalconductivity Model

This model depends on the lattice temperature and the state occupation probabilities of an MSC. If it does not depend on an MSC, then it allows a pwl temperature dependency and reads as:

$$ \kappa = \kappa(T) $$ (1110)

If an explicit MSC dependency is given, the global thermal conductivity is computed as:

$$ \kappa = \sum_{i} \kappa_{i}(T)s_{i} $$ (1111)

where the sum is taken over all MSC states, $\kappa_{i}$ are the state thermal conductivities, and $s_{i}$ are the state occupation probabilities.

The model is activated in the Physics section by:

```
ThermalConductivity (
      PMIModel ( Name="pmi_msc_thermalconductivity" MSConfig="m0" )
)
```

Table 172 Parameters of pmi_msc_thermalconductivity model

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| plot | – | 0 | – | {0,1} | Plot parameter to screen |
| kappa | κ | 0. | W/Kcm | real | Constant value |
| kappa_nb_Tpairs | – | 0 | – | >=0 | Number of interpolation points |

**33: Thermal Properties**
Thermoelectric Power

Table 172 Parameters of pmi_msc_thermalconductivity model (Continued)

| Name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| kappa_Tp<int>_X | – | – | K | real | Temperature at <int>-th interpolation point |
| kappa_Tp<int>_Y | – | – | W/Kcm | real | Value at <int>-th interpolation point |

See The pmi_msc_heatcapacity Model on page 968 for an explanation of the individual parameters and how the parameters can be overwritten for individual MSC states. Only the name of the parameters (use `kappa`) and the unit change.

# Thermoelectric Power

Sentaurus Device supports the following choices for computing the thermoelectric powers, $P_n$ and $P_p$, in semiconductors:

* Use a tabulated set of experimental values for silicon as a function of temperature and carrier concentration

* Use analytic formulas with two adjustable parameters, $\kappa$ and $s$

* As a user-defined function of the carrier density and the lattice temperature (thermoelectric power PMI)

In metals, the thermoelectric power $P$ is only allowed as a user-defined function of the electric field vector and the lattice temperature (as a PMI model).

# Physical Models

This section discusses the different physical models.

## Table-Based TEPower Model

By default, Sentaurus Device computes the thermoelectric powers, $P_n$ and $P_p$, using a table of experimental values of thermoelectric powers for silicon published by Geballe and Hull [11] as functions of temperature and carrier concentration.

Sentaurus Device extrapolates $P_n T$ and $P_p T$ linearly for temperatures between 360 K and 500 K, thereby preserving the $1/T$ dependency of data presented at higher temperatures by Fulkerson *et al.* [12], which holds up to near the intrinsic temperature.

Thermoelectric Power

$P_n$ and $P_p$ are shown in Figure 60 as a function of temperature and carrier concentration as used in Sentaurus Device.

| Temperature [K] | n=1e19 cm⁻³ | n=1e18 cm⁻³ | n=1e17 cm⁻³ | n=1e16 cm⁻³ | n=1e15 cm⁻³ | n=1e14 cm⁻³ |
| --- | --- | --- | --- | --- | --- | --- |
| 250 | -0.6 | -0.8 | -1.0 | -1.2 | -1.4 | -1.6 |
| 300 | -0.7 | -0.9 | -1.1 | -1.3 | -1.5 | -1.7 |
| 350 | -0.8 | -1.0 | -1.2 | -1.4 | -1.6 | -1.8 |
| 400 | -0.9 | -1.1 | -1.3 | -1.5 | -1.7 | -1.9 |
| 450 | -1.0 | -1.2 | -1.4 | -1.6 | -1.8 | -2.0 |
| 500 | -1.1 | -1.3 | -1.5 | -1.7 | -1.9 | -2.1 |

| Temperature [K] | p=1e14 cm⁻³ | p=1e15 cm⁻³ | p=1e16 cm⁻³ | p=1e17 cm⁻³ | p=1e18 cm⁻³ | p=1e19 cm⁻³ |
| --- | --- | --- | --- | --- | --- | --- |
| 250 | 1.6 | 1.4 | 1.2 | 1.0 | 0.8 | 0.6 |
| 300 | 1.7 | 1.5 | 1.3 | 1.1 | 0.9 | 0.7 |
| 350 | 1.8 | 1.6 | 1.4 | 1.2 | 1.0 | 0.8 |
| 400 | 1.9 | 1.7 | 1.5 | 1.3 | 1.1 | 0.9 |
| 450 | 2.0 | 1.8 | 1.6 | 1.4 | 1.2 | 1.0 |
| 500 | 2.1 | 1.9 | 1.7 | 1.5 | 1.3 | 1.1 |

Figure 60 Thermoelectric powers (left) $P_n$ and (right) $P_p$ as a function of temperature and carrier concentration

## Analytic TEPower Model

As an alternative, you can use analytic formulas as described in [13][14] to compute the thermoelectric powers in nongenerate semiconductors:

$$ P_n = -\kappa_n \frac{k}{q} \left[ \left( \frac{5}{2} - s_n \right) + \ln \left( \frac{N_C}{n} \right) \right] $$ (1112)

$$ P_p = \kappa_p \frac{k}{q} \left[ \left( \frac{5}{2} - s_p \right) + \ln \left( \frac{N_V}{p} \right) \right] $$ (1113)

where you can adjust the parameters $\kappa$ and $s$ in the parameter file.

Table 173 Parameters of analytic TEPower model

| Parameter name | Symbol | Default | Unit | Range | Description |
| --- | --- | --- | --- | --- | --- |
| s_n | $s_n$ | 1. | – | real | See Eq. 1112 |
| s_p | $s_p$ | 1. | – | real | See Eq. 1113 |
| scale_n | $\kappa_n$ | 1. | – | real | See Eq. 1112 |
| scale_p | $\kappa_p$ | 1. | – | real | See Eq. 1113 |

## PMI_ThermoElectricPower Model

In the most general case, thermoelectric powers in semiconductors can be computed using the thermoelectric power PMI (see Thermoelectric Power on page 1317) as functions of the lattice

33: Thermal Properties
Thermoelectric Power

temperature and the carrier density. Both the standard and simplified PMI (with automatic derivatives) are supported.

## Thermoelectric Power in Metals

In metals, thermoelectric power is defined as a PMI depending on the gradient of the Fermi potential $\nabla\Phi_M$ and the lattice temperature $T$ (see Metal Thermoelectric Power on page 1307). It is used in connection with thermodynamic transport in metals (the Seebeck effect).

# Using Thermoelectric Power

Thermoelectric powers in semiconductors are computed automatically when the `Temperature` equation is solved and the keyword `Thermodynamic` is specified in the global `Physics` section. By default, tabulated silicon data is used.

To activate an analytic formula (Eq. 1112, Eq. 1113) or thermoelectric power PMI models either regionwise, or materialwise, or globally, the keyword `TEPower` with `Analytic` or the PMI name as an option must be specified in the corresponding `Physics` section.

The following example activates an analytic formula in `"region1"`, the thermoelectric power PMI `pmi_tepower` in `"region2"`, and tabulated data interpolation in all other semiconductor regions:

```
Physics(Region="region1") {
  TEPower(Analytic)           # analytic formula TEP model in "region1"
}

Physics(Region="region2") {
  TEPower(pmi_tepower)        # PMI in "region2"
}
```

For backward compatibility, the keyword `AnalyticTEP` in the `Physics` section is still available to activate an analytic formula for thermoelectric power globally. It is equivalent to specifying `TEPower(Analytic)` in the global `Physics` section.

The coefficients for the thermoelectric powers defined by the analytic formula are available in the `TEPower` parameter set (see Table 164 on page 969).

Thermoelectric power in metals is activated selectively when the `Temperature` equation is solved and the keyword `Thermodynamic` is specified in the global `Physics` section. To activate it regionwise, materialwise, or globally, the keyword `MetalTEPower` with the metal thermoelectric power PMI name as an option must be specified in the corresponding `Physics` sections.

Heating at Contacts, Metal–Semiconductor and Conductive Insulator–Semiconductor Interfaces

The following example activates the metal thermoelectric power computation and thermodynamic transport in the copper part of the device:

```
Physics(Material="Copper") {
  MetalTEPower(pmi_tepower)
}
```

# Heating at Contacts, Metal–Semiconductor and Conductive Insulator–Semiconductor Interfaces

You can model Peltier heat at a contact, or a metal–semiconductor interface, or a conductive insulator–semiconductor interface as:

$$ Q = J_n(\alpha_n \Delta E_n + (1 - \alpha_n)\Delta \epsilon_n) $$ (1114)

$$ Q = J_p(\alpha_p \Delta E_p + (1 - \alpha_p)\Delta \epsilon_p) $$ (1115)

where:

* $Q$ is the heat density at the contact or interface (when $Q > 0$, there is heating; when $Q < 0$, there is cooling).

* $J_n$ and $J_p$ are the electron and hole current densities normal to the contact or interface.

* $\Delta E_n$ and $\Delta E_p$ are the energy differences for electrons and holes across the interface or at the contact.

* $\alpha_n$, $\alpha_p$, $\Delta \epsilon_n$, and $\Delta \epsilon_p$ are fitting parameters with $0 \le \alpha_n, \alpha_p \le 1$.

For the thermodynamic model, Sentaurus Device computes the energy differences for electrons and holes as:

$$ \Delta E_n = \Phi_M - \beta_n(\Phi_n + \gamma_n TP_n) + (1 - \beta_n)E_C/q $$ (1116)

$$ \Delta E_p = \Phi_M - \beta_p(\Phi_p + \gamma_p TP_p) + (1 - \beta_p)E_V/q $$ (1117)

where $\beta_n$, $\beta_p$, $\gamma_n$, and $\gamma_p$ are fitting parameters.

For the default lattice temperature model and the hydrodynamic model, Sentaurus Device computes the energy differences for electrons and holes as:

$$ \Delta E_n = \Phi_M + E_C/q $$ (1118)

$$ \Delta E_p = \Phi_M + E_V/q $$ (1119)

33: Thermal Properties

References

To activate Peltier heat, specify the keyword `MSPeltierHeat` in the corresponding interface or electrode `Physics` section. For example:

```
Physics(MaterialInterface="Silicon/Metal") {
  MSPeltierHeat
  ...
}
```

or:

```
Physics(Electrode="cathode") {
  MSPeltierHeat
  ...
}
```

The fitting parameters $\alpha$, $\beta$, $\gamma$, and $\Delta\varepsilon$ can be specified in the `MSPeltierHeat` parameter set of the region interface or electrode for which Peltier heat is computed:

```
MaterialInterface = "Silicon/Metal" {
  MSPeltierHeat {
    alpha  = 1.0 , 1.0  # [1]
    beta   = 1.0 , 1.0
    gamma  = 1.0 , 1.0
    deltaE = 0.0 , 0.0  # [eV]
  }
}
```

Their default values are $\alpha_n = \alpha_p = \beta_n = \beta_p = \gamma_n = \gamma_p = 1$ and $\Delta\varepsilon_n = \Delta\varepsilon_p = 0\text{ eV}$.

# References

[1] S. M. Sze, *Physics of Semiconductor Devices*, New York: John Wiley & Sons, 2<sup>nd</sup> ed., 1981.

[2] D. J. Dean, *Thermal Design of Electronic Circuit Boards and Packages*, Ayr, Scotland: Electrochemical Publications Limited, 1985.

[3] C. J. Glassbrenner and G. A. Slack, “Thermal Conductivity of Silicon and Germanium from 3°K to the Melting Point,” *Physical Review*, vol. 134, no. 4A, pp. A1058–A1069, 1964.

[4] S. S. Furkay, “Thermal Characterization of Plastic and Ceramic Surface-Mount Components,” *IEEE Transactions on Components, Hybrids, and Manufacturing Technology*, vol. 11, no. 4, pp. 521–527, 1988.

[5] M. G. Holland, “Analysis of Lattice Thermal Conductivity,” *Physical Review*, vol. 132, no. 6, pp. 2461–2471, 1963.

References

[6] M. Asheghi *et al.*, “Thermal conduction in doped single-crystal silicon films,” *Journal of Applied Physics*, vol. 91, no. 8, pp. 5079–5088, 2002.

[7] N. Mikoshiba, “Model for the Metal–Nonmetal Transition in Impure Semiconductors,” *Reviews of Modern Physics*, vol. 40, no. 4, pp. 833–838, 1968.

[8] D. Fortier and K. Suzuki, “Effect of P Donors on Thermal Phonon Scattering in Si,” *Le Journal de Physique*, vol. 37, pp. 143–147, February 1976.

[9] E. H. Sondheimer, “The mean free path of electrons in metals,” *Advances in Physics*, vol. 50, no. 6, pp. 499–537, 2001.

[10] A. M. Marconnet, M. Asheghi, and K. E. Goodson, “From the Casimir Limit to Phononic Crystals: 20 Years of Phonon Transport Studies Using Silicon-on-Insulator Technology,” *Journal of Heat Transfer*, vol. 135, no. 6, p. 061601, 2013.

[11] T. H. Geballe and G. W. Hull, “Seebeck Effect in Silicon,” *Physical Review*, vol. 98, no. 4, pp. 940–947, 1955.

[12] W. Fulkerson *et al.*, “Thermal Conductivity, Electrical Resistivity, and Seebeck Coefficient of Silicon from 100 to 1300°K,” *Physical Review*, vol. 167, no. 3, pp. 765–782, 1968.

[13] R. A. Smith, *Semiconductors*, Cambridge: Cambridge University Press, 2<sup>nd</sup> ed., 1978.

[14] C. Herring, “The Role of Low-Frequency Phonons in Thermoelectricity and Thermal Conduction,” in *Semiconductors and Phosphors: Proceedings of the International Colloquium*, Garmisch-Partenkirchen, Germany, pp. 184–235, August 1956.

