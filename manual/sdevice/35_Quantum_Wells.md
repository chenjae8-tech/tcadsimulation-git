# CHAPTER 35 Quantum Wells

*This chapter presents the physics of quantum wells, and methods of gain calculations for the quantum wells and bulk regions.*

These gain methods include the simple rectangular well model, and gain physical model interface (PMI). Various gain-broadening mechanisms and strain effects are discussed. A localized quantum well (QW) model is presented together with a simplified InGaN/GaN QW gain model.

# Overview

In this section, the focus is on two aspects of modeling the quantum well:

* Radiative recombination processes important in a quantum well

* Gain calculations

A few types of recombination processes are important in the quantum well:

* Auger and Shockley–Read–Hall (SRH) recombinations deplete the QW carriers, and they form the dark current.

* Radiative recombination contains the stimulated and spontaneous recombination processes, which are important processes in LEDs.

These recombinations must be added to the carrier continuity equations to ensure the conservation of particles.

The gain calculation is based on Fermi’s golden rule and describes quantitatively the radiative emissions in the form of the stimulated and spontaneous emission coefficients. These coefficients contain the optical matrix element $|M_{ij}|^2$, which describes the probability of the radiative recombination processes. In the quantum well, computing the optical matrix element requires knowledge of the QW subbands and QW wavefunctions.

Sentaurus Device offers several options for computing the gain spectrum:

* A simple finite well model with analytic solutions. In addition, strain effects and polarization dependence of the optical matrix element are handled separately.

* A localized QW model that uses a trapezoidal QW model to take localized electric field effects into account.

35: Quantum Wells
Radiative Recombination and Gain Coefficients

*   A simplified InGaN/GaN QW gain model that provides analytic forms to adjust the parameters of the effective masses, various band offsets, and so on. These are subsequently used in the gain calculations.

*   A nonlocal QW model that uses the 1D Schrödinger solver on a nonlocal mesh to compute the QW subbands and QW wavefunctions (see Nonlocal Mesh for the 1D Schrödinger Equation on page 306). This model supports arbitrary potential wells.

*   User-specified gain routines in C++ language can be coupled self-consistently with Sentaurus Device using the PMI.

# Radiative Recombination and Gain Coefficients

After the carriers are captured in the active region, they experience either dark recombination processes (such as Auger and SRH) or radiative recombination processes (such as stimulated and spontaneous emissions), or escape from the active region. This section describes how stimulated and spontaneous emissions are computed in Sentaurus Device.

## Stimulated and Spontaneous Emission Coefficients

In the active region of the LED, radiative recombination is treated locally at each active vertex. The stimulated and spontaneous emissions are computed using Fermi’s golden rule.

At each active vertex of the quantum wells, the local stimulated emission coefficient is:

$$ r^{st}(\hbar\omega) = \sum_{i,j} \int dE C_o k_{st} |M_{i,j}|^2 D(E) \times (f_i^C(E) + f_j^V(E) - 1) L(E) $$ (1141)

and the local spontaneous emission coefficient is:

$$ r^{sp}(\hbar\omega) = \sum_{i,j} \int dE C_o k_{sp} |M_{i,j}|^2 D(E) f_i^C(E) f_j^V(E) L(E) $$ (1142)

where (for general III–V materials):

$$ C_0 = \frac{\pi e^2}{n_g c \varepsilon_0 m_0^2 \omega} $$ (1143)

$$ |M_{i,j}|^2 = P_{ij} |O_{i,j}|^2 \left( \frac{m_0}{m_e} - 1 \right) \frac{m_0 E_g (E_g + \Delta)}{12 (E_g + \frac{2}{3} \Delta)} $$ (1144)

35: Quantum Wells

Radiative Recombination and Gain Coefficients

$$ O_{i,j} = \int_{-\infty}^{\infty} dx \zeta_i(x) \zeta^*_j(x) $$ (1145)

$$ f^C_{(i, \Phi_n, E)} = \left( 1 + \exp \left( \frac{E_C + E_i + q\Phi_n + \frac{m_r}{m_e}E}{k_B T} \right) \right)^{-1} $$ (1146)

$$ f^V_{(j, \Phi_p, E)} = \left( 1 + \exp \left( \frac{E_V - E_j + q\Phi_p - \frac{m_r}{m_h}E}{k_B T} \right) \right)^{-1} $$ (1147)

$$ D^r_{(E)} = \frac{m_r}{\pi \hbar^2 L_x} $$ (1148)

$$ m_r = \left( \frac{1}{m_e} + \frac{1}{m_h} \right)^{-1} $$ (1149)

$L(E)$ is the gain-broadening function. The electron, light-hole, and heavy-hole subbands are denoted by the indices $i$ and $j$. $f^C_{i(E)}$ and $f^V_{j(E)}$ are the local Fermi–Dirac distributions for the conduction and valence bands, $D^r_{(E)}$ is the reduced density-of-states, $|O_{i,j}|^2$ is the overlap integral of the quantum mechanical wavefunctions, and $P_{ij}$ is the polarization-dependent factor of the momentum (optical) matrix element $|M_{i,j}|^2$. The spin-orbit split-off energy is $\Delta$ and $E_g$ is the bandgap energy. The polarization-dependent factor $P_{ij}$ in the optical matrix element is set to 1.0 for LED simulations. These emission coefficients determine the rate of production of photons when given the number of available quantum well carriers at the active vertex.

For materials of wurtzite crystal structure (InGaN), the optical matrix element $|M_{i,j}|^2$ and hole masses are different. These are explained in detail in Electronic Band Structure for Wurtzite Crystals on page 1033.

$k_{st}$ and $k_{sp}$ are scaling factors for the optical matrix element $|M_{i,j}|^2$ of the stimulated and spontaneous emissions, respectively. They have been introduced to allow you to tune the stimulated and spontaneous gain curves. Consequently, these parameters can change the threshold current.

The activating keywords are `StimScaling` and `SponScaling` in the `Physics-LED` section of the command file:

```
Physics {...
  LED (...
```

Radiative Recombination and Gain Coefficients

```
    Optics (...)
    # ---- Scale stimulated & spontaneous gain ----
    StimScaling = 1.0  # default value is 1.0
    SponScaling = 1.0  # default value is 1.0
    )
}
```

The differential gains for electrons and holes are given by the derivatives of the coefficient of stimulated emission $r^{st}(\hbar\omega)$ (see Eq. 1141) with regard to the respective carrier density. They can be plotted by including the keywords `eDifferentialGain` and `hDifferentialGain` in the Plot section of the command file.

## Active Bulk Material Gain

The stimulated and spontaneous emission coefficients discussed are derived for the quantum well. However, these coefficients can apply to bulk materials with slight modifications. In bulk active materials, it is assumed that the optical matrix element is isotropic. The sum over the subbands is reduced to one electron, and one heavy-hole and one light-hole level, because there is no quantum-mechanical confinement in bulk material. In addition, the subband energies are set to $E_i = 0$, and the following coefficients are modified:

$$O_{i,j} = 1 \tag{1150}$$

$$D^r(E) = \frac{1}{2\pi^2} \left( \frac{2m_r}{\hbar^2} \right)^{3/2} E^{1/2} \tag{1151}$$

$$P_{i,j} = 1 \tag{1152}$$

All other expressions remain the same.

## Stimulated Recombination Rate

Radiative emissions contribute to the production of photons, but they also deplete the carrier population in the active region. At each active vertex, the stimulated recombination rate of the carriers must be equal to the sum of the photon production rate of every lasing mode so that conservation of particles is ensured. The stimulated recombination rate for each active vertex is:

$$R^{st}(x, y) = \sum_i r^{st}(\hbar\omega_i) S_i |\Psi_i(x, y)|^2 \tag{1153}$$

**35: Quantum Wells**
Gain-Broadening Models

where the sum is taken over all lasing modes. The stimulated emission coefficient is computed locally at this active vertex and its value is taken at the lasing energy, $\hbar\omega_i$, of mode $i$. $S_i$ is the photon rate of mode $i$, solved from the corresponding photon rate equation of mode $i$, and $|\Psi_i(x, y)|^2$ is the local optical field intensity of mode $i$ at this active vertex. This stimulated recombination rate is entered in the continuity equations to account for the correct depletion of carriers by stimulated emissions.

The total stimulated recombination rates on active vertices can be plotted by including the keyword `StimulatedRecombination` in the `Plot` section of the command file.

## Spontaneous Recombination Rate

The spontaneous emission rate and power are described in Spontaneous Emission Rate and Power on page 989. The total spontaneous recombination rates on active vertices can be plotted by including the keyword `SpontaneousRecombination` in the `Plot` section of the command file.

## Fitting Stimulated and Spontaneous Emission Spectra

The stimulated and spontaneous emission spectra can be fine-tuned by scaling and shifting. The spectra can be scaled in magnitude by the keywords `StimScaling=<float>` and `SponScaling=<float>` in the `Physics-LED` section. You can also shift the effective emission wavelength (and, therefore, the spectra) by an energy amount specified as `GainShift=<float>`.

# Gain-Broadening Models

Different line-shape broadening models are available: Lorentzian, Landsberg, and hyperbolic-cosine. These line-shape functions, $L(E)$, are embedded in the radiative emission coefficients in Eq. 1141 and Eq. 1142 to account for broadening of the gain spectrum.

## Lorentzian Broadening

Lorentzian broadening assumes that the probability of finding an electron or a hole in a given state decays exponentially in time [[1]](1). The line-shape function is:

$$ L(E) = \frac{\Gamma / (2\pi)}{(E_g - \hbar\omega + E)^2 + (\Gamma / 2)^2} \text{ (1154)} $$

35: Quantum Wells
Gain-Broadening Models

# Landsberg Broadening

The Landsberg model gives a narrower, asymmetric line-shape broadening, and its line-shape function is:

$$ L(E) = \frac{(\Gamma(E)) / (2\pi)}{(E_g - \hbar\omega + E)^2 + (\Gamma(E) / 2)^2} $$ (1155)

where:

$$ \Gamma(E) = \Gamma \sum_{k=0}^{3} a_k \left( \frac{E}{q\Psi_p - q\Psi_n} \right)^k $$ (1156)

and $q\Psi_p - q\Psi_n$ is the quasi-Fermi level separation. The coefficients $a_k$ are:

$$ \begin{aligned} a_0 &= 1 \\ a_1 &= -2.229 \\ a_2 &= 1.458 \\ a_3 &= -0.229 \end{aligned} $$ (1157)

# Hyperbolic-Cosine Broadening

The hyperbolic-cosine function has a broader tail on the low-energy side compared to Lorentzian broadening, and the line-shape function is:

$$ L(E) = \frac{1}{4\Gamma} \cdot \frac{1}{\cosh^2 \left( \frac{E}{2\Gamma} \right)} $$ (1158)

# Syntax to Activate Broadening

You can select only one line-shape function for gain broadening. This is activated by the keyword `Broadening` in the `Physics-LED` section of the command file. For example:

```
Physics {...
  LED (...
    Optics (...)
    # --- Line-shape broadening functions, choose one only ----
    Broadening (Type=Lorentzian Gamma=0.01)
#   Broadening (Type=Landsberg Gamma=0.01)      # Gamma in [eV]
#   Broadening (Type=CosHyper Gamma=0.01)
```

35: Quantum Wells
Gain-Broadening Models

```
  )
}
```

Gamma is the line width $\Gamma$, which must be defined in units of eV. If no `Broadening` keyword is detected, Sentaurus Device assumes the gain is unbroadened and does not perform the energy integral in Eq. 1141 and Eq. 1142.

# Electronic Band Structure for Wurtzite Crystals

To account for the strong coupling of the three valence bands (heavy holes (HH), light holes (LH), and crystal-field split-holes (CH)) in wurtzite crystals, the localized quantum-well model in Sentaurus Device supports a parabolic band approximation using effective masses at the $\Gamma$-point. It is derived from the three-band $\vec{k} \cdot \vec{p}$ method and considers strain effects assuming a growth direction along the $c$-axis of the hexagonal lattice. Based on general band-structure parameters for wurtzite crystals and a given strain defined by the mismatch of lattice constants, the band offsets and effective masses parallel and perpendicular to the growth direction are computed.

Starting from the diagonal strain tensor defined as:

$$ \varepsilon_{xx} = \varepsilon_{yy} = \frac{a_s - a_0}{a_0} \tag{1159} $$

$$ \varepsilon_{zz} = -2 \frac{C_{13}}{C_{33}} \varepsilon_{xx} \tag{1160} $$

$$ \varepsilon_{xy} = \varepsilon_{yz} = \varepsilon_{zx} = 0 \tag{1161} $$

where $a_s$ corresponds to the lattice constant of the substrate, and $a_0$ is the lattice constant of the unstrained layer. The energies of the valence band edge can be written as [2]:

$$ E_{hh}^0 = E_v^0 + \Delta_1 + \Delta_2 + \theta_\varepsilon + \lambda_\varepsilon \tag{1162} $$

$$ E_{lh}^0 = E_v^0 + \frac{\Delta_1 - \Delta_2 + \theta_\varepsilon}{2} + \lambda_\varepsilon + \sqrt{\left( \frac{\Delta_1 - \Delta_2 + \theta_\varepsilon}{2} \right)^2 + 2\Delta_3^2} \tag{1163} $$

$$ E_{ch}^0 = E_v^0 + \frac{\Delta_1 - \Delta_2 + \theta_\varepsilon}{2} + \lambda_\varepsilon - \sqrt{\left( \frac{\Delta_1 - \Delta_2 + \theta_\varepsilon}{2} \right)^2 + 2\Delta_3^2} \tag{1164} $$

Gain-Broadening Models

with $\theta_{\epsilon}$ and $\lambda_{\epsilon}$ expressing their dependency on the shear deformation potentials $D_{1}$ to $D_{4}$:

$$ \theta_{\epsilon} = D_{3}\epsilon_{zz} + D_{4}(\epsilon_{xx} + \epsilon_{yy}) \hfill (1165) $$

$$ \lambda_{\epsilon} = D_{1}\epsilon_{zz} + D_{2}(\epsilon_{xx} + \epsilon_{yy}) \hfill (1166) $$

The strain-dependent conduction band edge is given by:

$$ E_{c}^{0} = E_{v}^{0} + \Delta_{1} + \Delta_{2} + E_{g} + P_{c\epsilon} \hfill (1167) $$

where the energy shift $P_{c\epsilon}$ is due to the hydrostatic deformation potentials parallel ($a_{cz}$) and perpendicular ($a_{ct}$) to the growth direction:

$$ P_{c\epsilon} = a_{cz}\epsilon_{zz} + a_{ct}(\epsilon_{xx} + \epsilon_{yy}) \hfill (1168) $$

In the expressions for the band edges (Eq. 1162–Eq. 1164, and Eq. 1167), $E_{v}^{0}$ is used as the reference energy and stands for the CH band-edge energy in the absence of spin-orbit interaction. Table 177 and Table 178 summarize all band structure–related and strain-related parameters used in this section along with their specification in the Sentaurus Device parameter file.

Table 177 Parameters defined in BandstructureParameters section of parameter file

| Symbol | Parameter name | Unit | Description |
| --- | --- | --- | --- |
| $A_{1}$ | A1 | – | Hole effective mass parameter |
| $A_{2}$ | A2 | – | Hole effective mass parameter |
| $A_{3}$ | A3 | – | Hole effective mass parameter |
| $A_{4}$ | A4 | – | Hole effective mass parameter |
| $\Delta_{so}$ | so | eV | Spin-orbit split energy |
| $\Delta_{cr}$ | cr | eV | Crystal-field split energy |
| $\Delta_{1}$ |  | eV | Defined as $\Delta_{cr} = \Delta_{1}$ |
| $\Delta_{2}$ |  | eV | Defined as $\Delta_{so} = 3\Delta_{2}$ |
| $\Delta_{3}$ |  | eV | Defined as $\Delta_{so} = 3\Delta_{3}$ |

Table 178 Parameters defined in QWStrain section of parameter file

| Symbol | Parameter name | Unit | Description |
| --- | --- | --- | --- |
| $a_{0}$ | a0 | m | Lattice constant at T = 300 K |
| $\alpha$ | alpha | m/K | Model parameters describing linear temperature dependency of lattice constant: $a_{0}(T) = a_{0} + \alpha(T - T_{0})$ |
| $T_{0}$ | Tpar | K |  |

35: Quantum Wells
Gain-Broadening Models

Table 178 Parameters defined in QWStrain section of parameter file (Continued)

| Symbol | Parameter name | Unit | Description |
| --- | --- | --- | --- |
| $C_{33}$ | C_33 | eV | Elastic constant |
| $C_{13}$ | C_13 | eV | Elastic constant |
| $a_{cz}$ | a_c | eV | Hydrostatic deformation potential parallel to crystal growth direction1 |
| $a_{ct}$ | a_c | eV | Hydrostatic deformation potential perpendicular to crystal growth direction1 |
| $D_1$ | D1 | eV | Shear deformation potential |
| $D_2$ | D2 | eV | Shear deformation potential |
| $D_3$ | D3 | eV | Shear deformation potential |
| $D_4$ | D4 | eV | Shear deformation potential |

<sup>1</sup> $a_{cz}$ and $a_{ct}$ are assumed to be equal.

Based on a three-band $6 \times 6$ Hamiltonian matrix needed to describe the strong coupling of the three valence bands, analytic solutions for the dispersion relations $E(\vec{k})$ can be derived [2][3][4]. Performing a series expansion of $E$ at the $\Gamma$-point up to the second order in $k$ yields the effective masses that are used with the localized quantum-well model:

$$ m_{hh}^z = -m_0(A_1 + A_3)^{-1} \text{ (1169)} $$

$$ m_{hh}^t = -m_0(A_2 + A_4)^{-1} \text{ (1170)} $$

$$ m_{lh}^z = -m_0 \left( A_1 + \left( \frac{E_{lh}^0 - \lambda_\epsilon}{E_{lh}^0 - E_{ch}^0} \right) A_3 \right)^{-1} \text{ (1171)} $$

$$ m_{lh}^t = -m_0 \left( A_2 + \left( \frac{E_{lh}^0 - \lambda_\epsilon}{E_{lh}^0 - E_{ch}^0} \right) A_4 \right)^{-1} \text{ (1172)} $$

$$ m_{ch}^z = -m_0 \left( A_1 + \left( \frac{E_{ch}^0 - \lambda_\epsilon}{E_{ch}^0 - E_{lh}^0} \right) A_3 \right)^{-1} \text{ (1173)} $$

$$ m_{ch}^t = -m_0 \left( A_2 + \left( \frac{E_{ch}^0 - \lambda_\epsilon}{E_{ch}^0 - E_{lh}^0} \right) A_4 \right)^{-1} \text{ (1174)} $$

where $A_1$ to $A_4$ are called the hole effective mass parameters, which must be specified by users as shown in Table 177 on page 1034.

Gain-Broadening Models

To activate the simplified model for the treatment of the band structure of wurtzite crystals, the crystal type must be indicated in the `Physics` section of the command file.

If strain is to be accounted for, then the substrate lattice constant must be specified as a reference for the computation of the strain tensor in each layer as shown here:

```
Physics {
  LED (
    Bandstructure ( CrystalType = Wurtzite )
    Strain ( RefLatticeConst = 3.183e-10 )  #[m]
  )
}
```

Besides the computation of the band-edge energies and the effective masses using the formulas in Eq. 1162–Eq. 1164, Eq. 1167, and Eq. 1169–Eq. 1174, you can define these quantities explicitly. Each valence band can be characterized by a ladder specification as described in Explicitly Specifying Ladders on page 308. For materials exhibiting the wurtzite crystal structure, the syntax of the explicit ladder specification is extended to classify the specific hole type (HH, LH, or CH). This is needed for labeling the corresponding results such as subband energies or overlapping integrals during visualization.

For example, to explicitly define the properties of the various valence bands considering arbitrary strain, that is, the amount of strain is not declared to the tool, the ladder specification in the `SchroedingerParameters` section reads as follows:

```
SchroedingerParameters {
  Formula = 0,4
  hLadder(0.4376, 1.349, 1, 0.002, HeavyHole)
  hLadder(0.4373, 0.4375, 1, 0.003, LightHole)
  hLadder(0.4376, 0.4378, 1, 0.004, CrystalFieldSplitHole)
}
```

The first and second entry of `hLadder` correspond to the values for the parallel ($m^z$) and the perpendicular ($m^t$) effective mass. The third entry indicates the ladder degeneracy, which is set to 1 for GaN-based semiconductors, and the fourth entry is used to specify the band offset with respect to the valence band edge without strain in eV. To activate the explicit ladder specification, the value of `Formula` for holes must be set to 4.

> **NOTE** In this parameter file excerpt of the `SchroedingerParameters` section, the value of `Formula` for electrons is set to 0, which uses the isotropic density-of-states mass as both the quantization mass ($m^z$) and the mass ($m^t$) perpendicular to it.

The keyword `Formula` is used to select one of several options for defining effective masses and band offsets, which are summarized in Table 179 on page 1037.

35: Quantum Wells
Gain-Broadening Models

You can specify a single value, which only affects the specification for holes and uses the default value of 0 for electrons. Using a value pair allows the explicit specification of `Formula` for both electrons (first value) and holes (second value).

Table 179 Supported values of Formula for localized quantum-well model

| Formula | Description | Limitations |
| --- | --- | --- |
| 0 | Use isotropic density-of-states mass as $m^z$ and $m^t$. | Only supported for electrons. |
| 2 | Use `me`, `mh`, and `ml` to specify relative effective mass for electrons, heavy holes, and light holes, respectively. | Only supported for electrons, light holes, and heavy holes. It cannot be used if `NumberOfValenceBands` is set to a value greater than 2 in the command file. No distinction between $m^z$ and $m^t$. Band offsets due to strain cannot be specified explicitly. |
| 4 | Use `eLadder(...)` specification for electrons, and use `hLadder(...)` specification for holes. |  |
| 5 | Effective masses and band offsets are computed based on parameters specified in `BandstructureParameters` and `QWStrain` sections using parabolic band approximation as described in Electronic Band Structure for Wurtzite Crystals on page 1033. | Only supported for holes. |

# Optical Transition Matrix Element for Wurtzite Crystals

To compute the spontaneous emission spectrum, $r^{\text{sp}}(E)$, in LED simulations as defined in Eq. 1142, p. 1028, the optical transition matrix element must be evaluated. For quantum wells grown along the $c$-axis of the wurtzite crystal, the polarization-dependent transition matrix element for the different conduction band–to–valence band transitions can be written as [5]:

$$ |M_{hh}^{\text{TE}}|^2 = \frac{3}{2} O_{ij} (M_b^{\text{TE}})^2 $$ (1175)

$$ |M_{lh}^{\text{TE}}|^2 = \frac{3}{2} \cos^2(\theta_e) O_{ij} (M_b^{\text{TE}})^2 $$ (1176)

$$ |M_{ch}^{\text{TE}}|^2 = 0 $$ (1177)

$$ |M_{hh}^{\text{TM}}|^2 = 0 $$ (1178)

Gain-Broadening Models

$$ |M_{lh}^{TM}|^2 = \frac{3}{2} \sin^2(\theta_e) O_{ij} (M_b^{TM})^2 \tag{1179} $$

$$ |M_{ch}^{TM}|^2 = \frac{3}{2} O_{ij} (M_b^{TM})^2 \tag{1180} $$

where $O_{ij}$ refers to the overlap integral between the envelope wavefunctions of the $i$-th electron subband and the $j$-th valence subband. The anisotropic bulk momentum matrix elements are given by:

$$ (M_b^{TE})^2 = \frac{m_0}{6} \left( \frac{1}{m_c^z} - 1 \right) \frac{(E_g + \Delta_1 + \Delta_2)(E_g + 2\Delta_2) - 2\Delta_3^2}{E_g + 2\Delta_2} \tag{1181} $$

$$ (M_b^{TM})^2 = \frac{m_0}{6} \left( \frac{1}{m_c^t} - 1 \right) \frac{E_g [(E_g + \Delta_1 + \Delta_2)(E_g + 2\Delta_2) - 2\Delta_3^2]}{(E_g + \Delta_1 + \Delta_2)(E_g + \Delta_2) - \Delta_3^2} \tag{1182} $$

where $m_c^z$ and $m_c^t$ denote the relative electron mass parallel and perpendicular to the quantization direction, respectively, and $m_0$ denotes the electron rest mass. The angle $\theta_e$ is defined as:

$$ k_z = |\vec{k}| \cos(\theta_e) \tag{1183} $$

where $\vec{k}$ refers to the electron vector, and $\cos(\theta_e) = 1$ at the $\Gamma$-point of the quantum-well subband.

Arbitrary polarization is modeled as a linear combination of TE and TM polarization according to:

$$ |M_{i,j}|^2 = a \cdot |M_{i,j}^{TE}|^2 + (1 - a) \cdot |M_{i,j}^{TM}|^2 \tag{1184} $$

where $a$ is called the `PolarizationFactor`, which can be set in the `QWLocal` section as shown here. For purely TE or TM simulations, it is sufficient to set `Polarization` to the respective identifier:

```
Physics {
    QWLocal (
        Polarization = TE            # TM
        # or
        Polarization = Mixed
        PolarizationFactor = 0.4     # must be in interval [0 1]
    )
}
```

35: Quantum Wells
Simple Quantum-Well Subband Model

# Simple Quantum-Well Subband Model

This section describes the solution of the Schrödinger equation for a simple finite quantum-well model. This is the default model in Sentaurus Device. This simple quantum-well (QW) subband model is combined with separate QW strain (see Strain Effects on page 1042) to model most (III–V material) quantum-well systems.

In a quantum well, the carriers are confined in one direction. Of interest are the subband energies and wavefunctions of the bound states, which can be solved from the Schrödinger equation. In this simple QW subband model, it is assumed that the bands for the electron, heavy hole, and light hole are decoupled, and the subbands are solved independently by a 1D Schrödinger equation.

The time-independent 1D Schrödinger equation in the effective mass approximation is:

$$ \left( -\frac{\hbar^2}{2} \frac{\partial}{\partial x} \frac{1}{m(x)} \frac{\partial}{\partial x} + V(x) - E^i \right) \zeta^i(x) = 0 $$ (1185)

where $\zeta^i(x)$ is the $i$-th quantum mechanical wavefunction, $E^i$ is the $i$-th energy eigenvalue, and $V(x)$ is the finite well shape potential.

With the following ansatz for the even wavefunctions:

$$ \zeta(x) = C_1 \begin{cases} \cos\left(\frac{\kappa l}{2}\right) e^{-\alpha(|x|-l/2)} & , \quad |x| > l/2 \\ \cos(\kappa x) & , \quad |x| \le l/2 \end{cases} $$ (1186)

and the odd wavefunctions:

$$ \zeta(x) = C_2 \begin{cases} \pm \sin\left(\frac{\kappa l}{2}\right) e^{\mp(x \mp l/2)} & , \quad |x| > l/2 \\ \sin(\kappa x) & , \quad |x| \le l/2 \end{cases} $$ (1187)

Eq. 1185 becomes [1]:

$$ \alpha \frac{l}{2} + \frac{m_b}{m_w} \kappa \frac{l}{2} \cot\left(\kappa \frac{l}{2}\right) = 0 $$ (1188)

$$ \alpha \frac{l}{2} - \frac{m_b}{m_w} \kappa \frac{l}{2} \tan\left(\kappa \frac{l}{2}\right) = 0 $$ (1189)

Simple Quantum-Well Subband Model

with:

$$ \kappa = \frac{\sqrt{2m_w E}}{\hbar} $$ (1190)

$$ \alpha = \frac{\sqrt{2m_b (\Delta E_c - E)}}{\hbar} $$ (1191)

The first transcendental equation gives the even eigenvalues, and the second one gives the odd eigenvalues. The wavefunctions are immediately obtained with Eq. 1186 and Eq. 1187 after the subband energy $E$ has been computed. Having obtained the wavefunctions and subband energies, the carrier densities of the 1D-confined system are also computed by:

$$ n(x) = N_e^{2D} \sum_i |\zeta_i(x)|^2 F_0(\eta_n - E_i) $$ (1192)

$$ p(x) = N_{hh}^{2D} \sum_j |\zeta_{j(x)}|^2 F_0(\eta_p - E_{hh}^j) + N_{lh}^{2D} \sum_m |\zeta_{m(x)}|^2 F_0(\eta_p - E_{lh}^m) $$ (1193)

where $F_0(x)$ is the Fermi integral of the order 0, and $\eta_n$, $\eta_p$ denote the chemical potentials. The indices $hh$ and $lh$ denote the heavy and light holes, respectively.

The effective densities of states are:

$$ N_e^{2D} = \frac{k_B T m_e}{\hbar^2 \pi L_x} $$ (1194)

$$ N_{lh/hh}^{2D} = \frac{k_B T m_{lh/hh}}{\hbar^2 \pi L_x} $$ (1195)

where $L_x$ is the thickness of the quantum well. The thickness of each quantum well is automatically detected in Sentaurus Device by scanning the material regions for the keyword `Active`.

The effective masses of the carriers in the quantum well can be changed inside the parameter file:

```
eDOSMass
{
    * For effective mass specification Formula1 (me approximation):
    * or Formula2 (Nc300) can be used :
        Formula = 2   # [1]
    * Formula2:
    * me/m0 = (Nc300/2.540e19)^2/3
    * Nc(T) = Nc300 * (T/300)^3/2
}
```

35: Quantum Wells

Simple Quantum-Well Subband Model

```
        Nc300      = 8.7200e+16   # [cm-3]
 * Mole fraction dependent model.
 * If just above parameters are specified, then its values will be
 * used for any mole fraction instead of an interpolation below.
 * The linear interpolation is used on interval [0,1].
        Nc300(1)          = 6.4200e+17   # [cm-3]
}
...
SchroedingerParameters:
{ * For the hole masses for Schroedinger equation you can
 * use different formulas.
 * formula=1 (for materials with Si-like hole band structure)
 *   m(k)/m0=1/(A+-sqrt(B+C*((xy)^2+(yz)^2+(zx)^2)))
 *   where k=(x,y,z) is unit normal vector in reciprocal
 *   space. '+' for light hole band, '-' for heavy hole band
 * formula=2: Heavy hole mass mh and light hole mass ml are
 *   specified explicitly.
 * Formula 2 parameters:
        Formula = 2    # [1]
        ml      = 0.027 # [1]
        mh      = 0.08  # [1]
 * Mole fraction dependent model.
 * If just above parameters are specified, then its values will be
 * used for any mole fraction instead of an interpolation below.
 * The linear interpolation is used on interval [0,1].
        ml(1)   = 0.094 # [1]
        mh(1)   = 0.08  # [1]
}
```

# Syntax for Simple Quantum-Well Model

This simple QW subband model is the default model when the QWTransport model is activated:

```
Physics {...
  LED (...
    Optics (...)
    # ----- Specify QW model and physics -----
    QWTransport
    QWExtension = AutoDetect  # QW widths auto-detection
  )
}
```

Table 265 on page 1577 provides the keywords that are associated with this simple QW model.

35: Quantum Wells
Strain Effects

# Strain Effects

It is well known that strain of the quantum well modifies the stimulated and spontaneous emission gain spectra. Due to the deformation potentials in the crystal at the well–bulk interface and valence band mixing effects, band structure modifications occur mainly for the valence bands. They have an impact on the optical recombination and transport properties.

In the simple QW subband model discussed in the previous section, a simpler approach to the QW strain effects is adopted. The simple QW subband model does not include nonparabolicities of the band structure, arising from valence band mixing and strain, in a rigorous manner. However, by carefully selecting the effective masses in the well, a good approximation of the strained band structure can be obtained [6]. The effective masses can be changed in the parameter file as previously shown.

Basically, strain has two impacts on the band structure. Due to the deformation potentials, the effective band offsets of the conduction and valence bands are modified. This is included in the simple QW subband model by:

$$ \delta E_{C} = 2 a_{c} \left( 1 - \frac{C_{12}}{C_{11}} \right) \varepsilon $$ (1196)

$$ \delta E_{V}^{HH} = 2 a_{v} \left( 1 - \frac{C_{12}}{C_{11}} \right) \varepsilon + b \left( 1 + 2 \frac{C_{12}}{C_{11}} \right) \varepsilon $$ (1197)

$$ \delta E_{V}^{LH} = 2 a_{v} \left( 1 - \frac{C_{12}}{C_{11}} \right) \varepsilon - b \left( 1 + 2 \frac{C_{12}}{C_{11}} \right) \varepsilon + \frac{\Delta}{2} - \left( - \frac{1}{2} \sqrt{\Delta^{2} + 9 \delta E_{sh}^{2} - 2 \delta E_{sh} \Delta} \right) $$ (1198)

where $a_{n}$ and $a_{c}$ are the hydrostatic deformation potential of the conduction and valence bands, respectively. The shear deformation potential is denoted with $b$ and $\Delta$ is the spin-orbit split-off energy. The elastic stiffness constants are $C_{11}$ and $C_{12}$, and $\varepsilon$ is the relative lattice constant difference in the active region. The hydrostatic component of the strain shifts the conduction band offset by $\delta E_{C}$ and shifts the valence band offset by $\delta E_{V}^{0} = 2 a_{v} (1 - C_{12} / C_{11}) \varepsilon$.

The shear component of the strain decouples the light hole and heavy hole bands at the $\Gamma$ point, and shifts the valence bands by an amount of $\delta E_{sh} = b (1 + 2 C_{12} / C_{11}) \varepsilon$ in opposite directions.

 35: Quantum Wells
Strain Effects

# Syntax for Quantum-Well Strain

To activate the strain shift, specify the keyword `Strain` in the `Physics-LED` section of the command file:

```
Physics {...
  LED (...
    Optics (...)
    # --- QW physics ---
    QWTransport
    QWExtension = AutoDetect
    # --- QW strain ---
    Strain
  )
}
```

The parameters $a_n$, $a_c$, and $b$ can be entered as `a_nu`, `a_c`, and `b_shear`, respectively, in the `QWStrain` section of the parameter file:

```
QWStrain
{
  * Deformation Potentials (a_nu, a_c, b, C_12, C_11
  * and strainConstant eps :
  * Formula:
  * eps = (a_bulk - a_active)/a_active
  * dE_c = ...
  * dE_lh = ...
  * dE_hh = ...
    eps = -1.0000e-02        # [1]
  * a_nu = 1.27              # [1]
  * a_c = -5.0400e+00        # [1]
  * b_shear = -1.7000e+00    # [1]
  * C_11 = 10.11             # [1]
  * C_12 = 5.61              # [1]
}
```

The elastic stiffness constants $C_{11}$ and $C_{12}$ can be specified by `C_11` and `C_12`. Due to valence band mixing and strain, the valence bands can become nonparabolic. However, within a small range from the band edge, parabolicity can still be assumed. In the simulation, you can modify the effective heavy-hole and light-hole masses in the parameter file for the subband calculation to account for this effect.

The spin-orbit split-off energy can be specified in the `BandstructureParameters` section of the parameter file:

```
BandstructureParameters{
  ...
```

Localized Quantum-Well Model

```
    so = 0.34  # [eV]
    ...
}
```

# Localized Quantum-Well Model

In GaN-based quantum-well systems, the polarization charge sheets at the interfaces of the quantum well or barrier induce a large field within the quantum well. These fields skew the energy bands and cause mismatches in the alignment of the electron and hole wavefunctions.

The localized quantum-well model takes into account field effects in a fully coupled methodology. The activation syntax is included in the `Physics` section of each active quantum well:

```
Physics (region="QW1") {...
  Active(Type=QuantumWell)
  QWLocal (
    NumberOfElectronSubbands = 5
    NumberOfLightHoleSubbands = 2
    NumberOfHeavyHoleSubbands = 4
    NumberOfCrystalFieldSplitHoleSubbands = 3
    NumberOfValenceBands = 3
  # -ElectricFieldDep
    WidthExtraction (
      # indicate side regions or materials of QW if sides
      # do not coincide with domain boundaries
      SideRegion = ("reg1", ..., "regn")
      SideMaterial = ("mat1", ..., "matn")
      MinAngle = (<float>, <float>)
      ChordWeight = <float>
    )
  )
}
```

By default, the electric field dependency is activated in the localized quantum-well model. However, it can be deactivated by using the `-ElectricFieldDep` keyword. The maximum number of subbands for electrons, heavy holes (HH), light holes (LH), and crystal-field split-holes (CH) must be specified to enable Sentaurus Device to limit the scope of the computation. The actual number of subbands used is computed as the simulation progresses. By default, only the heavy-hole (HH) band and the light-hole (LH) band are considered. Changing the value of `NumberOfValenceBands` from 2 to 3 includes the crystal-field split-hole (CH) band in the computation and is the recommended setting for materials exhibiting the wurtzite crystal system.

35: Quantum Wells

Localized Quantum-Well Model

A `WidthExtraction` section is included to enable you to specify how the quantum-well thickness can be extracted. This thickness is important to define the quantum-well width so as to compute the solution to the Schrödinger equation. `MinAngle` and `ChordWeight` are parameters used in a special method to compute the thickness of the quantum-well layer that is not aligned to one of the major axes (see Thickness Extraction on page 336).

If the `QWLocal` section is defined in the global `Physics` section, the parameters of the maximum number of bands in each band are applied to all the specified `Active(Type=QuantumWell)` regions.

By default, the localized quantum-well model does not account for the correction of the densities in the quantum well due to quantization. To take quantization into account, use the `eDensityCorrection` and `hDensityCorrection` options of `QWLocal`. For more details, see Quantum-Well Quantization Model on page 332.

> **NOTE** The variables in Table 180 also apply to the nonlocal quantum-well model.

Table 180 Variables for plotting when using the localized quantum-well model

| Variable | Description |
| --- | --- |
| QW_chEigenEnergy | Eigenenergies of the crystal-field split-hole bound states [eV] |
| QW_chNumberOfBoundStates | Actual number of QW bound states for crystal-field split-holes |
| QW_chRelativeEffectiveMass | Relative effective mass of crystal-field split-holes |
| QW_chStrainBandShift | Shift in crystal-field split-hole band due to strain effects |
| QW_eEigenEnergy | Eigenenergies of the electron bound states [eV] |
| QW_ElectricFieldProjection | Electric field in the QW [V/cm] NOTE This variable does not apply to the nonlocal quantum-well model. |
| QW_eNumberOfBoundStates | Actual number of QW bound states for electrons |
| QW_eRelativeEffectiveMass | Relative effective mass of electrons |
| QW_eStrainBandShift | Shift in conduction band due to strain effects |
| QW_hhEigenEnergy | Eigenenergies of the heavy-hole bound states [eV] |
| QW_hhNumberOfBoundStates | Actual number of QW bound states for heavy holes |
| QW_hhRelativeEffectiveMass | Relative effective mass of heavy holes |
| QW_hhStrainBandShift | Shift in heavy-hole band due to strain effects |
| QW_lhEigenEnergy | Eigenenergies of the light-hole bound states [eV] |
| QW_lhNumberOfBoundStates | Actual number of QW bound states for light holes |
| QW_lhRelativeEffectiveMass | Relative effective mass of light holes |

Nonlocal Quantum-Well Model Using 1D Schrödinger Solver

Table 180 Variables for plotting when using the localized quantum-well model (Continued)

| Variable | Description |
| --- | --- |
| QW_lhStrainBandShift | Shift in light-hole band due to strain effects |
| QW_OverlapIntegral | Overlap integrals between electron and hole wavefunctions |
| QW_QuantizationDirection | Quantization direction of the QW |
| QW_Width | Extracted width of the QW [ μm ] |

You also can include any of the variables in Table 180 in the `CurrentPlot` statement. For example:

```
CurrentPlot { ...
  QW_eEigenEnergy (
    Minimum (Region = "QW1")
    Maximum (Region = "QW1")
    Average (Region = "QW1")
  )
}
```

**NOTE** This is an advanced model. If you are interested in using this model, then contact TCAD Support for assistance in evaluating whether this model is suitable for use in your device (see Contacting Your Local TCAD Support Team Directly on page xlv).

# Nonlocal Quantum-Well Model Using 1D Schrödinger Solver

The most rigorous model available in Sentaurus Device to model quantum wells is the 1D Schrödinger solver on a nonlocal mesh that covers the quantum-well structure (see Nonlocal Mesh for the 1D Schrödinger Equation on page 306). A nonlocal mesh consists of numerous cutlines parallel to the quantization direction on which the potential distribution and effective masses are extracted. On each nonlocal line, the 1D Schrödinger solver computes the eigenenergies and the wavefunctions. Then, the eigenenergies of the bound states and the overlap integrals of the wavefunctions for the various optical transitions are interpolated back to the device simulation mesh to calculate the radiative recombination.

This model also supports the simulation of mole fraction–graded quantum wells by defining the band-structure parameters and the effective masses as mole fraction dependent (see Mole-Fraction Specification on page 17 and Parameters for Composition-Dependent Materials on page 24).

35: Quantum Wells

Nonlocal Quantum-Well Model Using 1D Schrödinger Solver

To use the 1D Schrödinger solver for quantum wells:

1. Construct a special-purpose *nonlocal* mesh that covers the quantum-well structure (see Nonlocal Mesh for the 1D Schrödinger Equation on page 306). The nonlocal lines should extend beyond the well region into the barrier regions on either side by approximately the well width.

2. Activate the 1D Schrödinger solver on the nonlocal line mesh with appropriate parameters (see Using the 1D Schrödinger Equation on page 307, Parameters of the 1D Schrödinger Equation on page 307, and Electronic Band Structure for Wurtzite Crystals on page 1033).

3. Mark quantum-well regions as active by specifying `Active(Type=QuantumWell)` in the corresponding region-specific `Physics` sections.

For example, to use the 1D Schrödinger solver to simulate a quantum well that is 3 nm wide and whose plane is perpendicular to the z-axis, specify the following syntax in the command file:

```
Physics (Region="QW1") { Active(Type=QuantumWell) }

NonLocal "QW1" (
  RegionInterface="QW1/Barrier0"
  Length = 6e-7
  Permeation = 3e-7
  Direction = (0 0 1)
  MaxAngle = 5
  Discretization = 1e-8
  -Transparent(Region="Barrier0")
)

Physics {
  Schroedinger "QW1" (Electron Hole Polarization = TE -DensityCorrection)
}
```

By default, the nonlocal quantum-well model accounts for the correction of the densities in the quantum well due to quantization. However, at the beginning, it is recommended to disable the correction of the densities (`-DensityCorrection`) as it has an adverse effect on convergence as shown in this example. For details, see 1D Schrödinger Equation on page 310.

The variables in Table 180 on page 1045 can be plotted when using the nonlocal quantum-well model. These variables also can be specified in the `CurrentPlot` statement (see Tracking Additional Data in the Current File on page 116) and the `NonlocalPlot` statement (see Visualizing the Solutions on page 310).

> **NOTE** This is an advanced model. If you are interested in using this model, then contact TCAD Support for assistance in evaluating whether this model is suitable for use in your device (see Contacting Your Local TCAD Support Team Directly on page xlv).

35: Quantum Wells
Importing Gain and Spontaneous Emission Data With PMI

# Importing Gain and Spontaneous Emission Data With PMI

Sentaurus Device can import external stimulated and spontaneous emission data through the physical model interface (PMI).

Sentaurus Device calls the user-written gain calculations through the PMI with the variables: electron density $n$, hole density $p$, electron temperature $eT$, hole temperature $hT$, and transition energy $E$. The user-written gain calculation then returns the gain $g$ and the derivatives of gain with respect to $n$, $p$, $eT$, and $hT$ to Sentaurus Device. The derivatives are required to ensure proper convergence of the Newton iterations. In this way, the user-import gain is made self-consistent within the simulation.

```mermaid
graph LR
    subgraph PMI
        direction TB
        G["g(E, n, p, eT, hT) ,$$\frac{dg}{dn}, \frac{dg}{dp}, \frac{dg}{deT}, \frac{dg}{dhT}$$"]
        V["n , p , eT , hT , E"]
    end

    Users["Users supply gainand derivatives"]
    SD["Sentaurus Devicesupplies n , p , eT ,hT , and E"]

    Users -- "" --> G
    G -- "" --> SD
    SD -- "" --> V
    V -- "" --> Users
```

Figure 71 Illustration of the gain PMI concept

# Implementing Gain PMI

The PMI uses the object-orientation capability of the C++ language (see Chapter 39 on page 1165). A brief outline is given here of the gain PMI.

In the Sentaurus Device header file `PMIModels.h`, the following base class is defined for gain:

```cpp
class PMI_StimEmissionCoeff : public PMI_Vertex_Interface {
public:
  PMI_StimEmissionCoeff (const PMI_Environment& env);
  virtual ~PMI_StimEmissionCoeff ();

  virtual void Compute_rstim
  (double E,
  double n,
  double p,
  double et,
```

**35: Quantum Wells**
Importing Gain and Spontaneous Emission Data With PMI

```cpp
       double ht,
       double& rstim) = 0;

       virtual void Compute_drstimdn
       (double E,
       double n,
       double p,
       double et,
       double ht,
       double& drstimdn) = 0;

       virtual void Compute_drstimdp
       (double E,
       double n,
       double p,
       double et,
       double ht,
       double& drstimdp) = 0;

       virtual void Compute_drstimdet
       (double E,
       double n,
       double p,
       double et,
       double ht,
       double& drstimdet) = 0;

       virtual void Compute_drstimdht
       (double E,
       double n,
       double p,
       double et,
       double ht,
       double& drstimdht) = 0;
     };
```

To implement the PMI model for gain, you must declare a derived class in the user-written header file:

```cpp
     #include "PMIModels.h"

     class StimEmissionCoeff : public PMI_StimEmissionCoeff {
     // User-defined variables for his/her own routines
      private:
       double a, b, c, d;

      public:
       // Need a constructor and destructor for this class
       StimEmissionCoeff (const PMI_Environment& env);
```

Importing Gain and Spontaneous Emission Data With PMI

```cpp
  ~StimEmissionCoeff ();

  // --- User needs to write the following routines in the .C file ---
  // The value of the function is return as the last pointer argument

  // stimulated emission coeff value
  void Compute_rstim (double E,
                     double n,
                     double p,
                     double et,
                     double ht,
                     double& rstim);

  // derivative wrt n
  void Compute_drstimdn (double E,
                        double n,
                        double p,
                        double et,
                        double ht,
                        double& drstimdn);

  // derivative wrt p
  void Compute_drstimdp (double E,
                        double n,
                        double p,
                        double et,
                        double ht,
                        double& drstimdp);

  // derivative wrt eT
  void Compute_drstimdet (double E,
                        double n,
                        double p,
                        double et,
                        double ht,
                        double& drstimdet);

  // derivative wrt hT
  void Compute_drstimdht (double E,
                        double n,
                        double p,
                        double et,
                        double ht,
                        double& drstimdht);
};
```

35: Quantum Wells
References

Next, you must write the functions `Compute_rstim`, `Compute_drstimdn`, `Compute_drstimdp`, `Compute_drstimdet`, and `Compute_drstimdht` to return the values of the stimulated emission coefficient and its derivatives to Sentaurus Device using this gain PMI. If you have, for example, a table of gain values, then you must implement these functions to interpolate the values of the gain and derivatives from the table.

The spontaneous emission coefficient can also be imported using the PMI. The implementation is exactly the same as the stimulated emission coefficient, and you only need to replace `StimEmissionCoeff` with `SponEmissionCoeff` in the previous code example.

# References

[1] L. A. Coldren and S. W. Corzine, *Diode Lasers and Photonic Integrated Circuits*, New York: John Wiley & Sons, 1995.

[2] S. L. Chuang and C. S. Chang, "A band-structure model of strained quantum-well wurtzite semiconductors," *Semiconductor Science and Technology*, vol. 12, no. 3, pp. 252–263, 1997.

[3] S. L. Chuang and C. S. Chang, "k·p method for strained wurtzite semiconductors," *Physical Review B*, vol. 54, no. 4, pp. 2491–2504, 1996.

[4] M. Kumagai, S. L. Chuang, and H. Ando, "Analytical solutions of the block-diagonalized Hamiltonian for strained wurtzite semiconductors," *Physical Review B*, vol. 57, no. 24, pp. 15303–15314, 1998.

[5] S. L. Chuang, "Optical Gain of Strained Wurtzite GaN Quantum-Well Lasers," *IEEE Journal of Quantum Electronics*, vol. 32, no. 10. pp. 1791–1800, 1996.

[6] Z.-M. Li et al., "Incorporation of Strain Into a Two-Dimensional Model of Quantum-Well Semiconductor Lasers," *IEEE Journal of Quantum Electronics*, vol. 29, no. 2, pp. 346–354, 1993.

## References

 