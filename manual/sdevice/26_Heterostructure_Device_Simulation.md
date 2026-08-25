# CHAPTER 26 Heterostructure Device Simulation

*This chapter describes carrier transport boundary conditions for heterointerfaces.*

## Thermionic Emission Current

Conventional transport equations cease to be valid at a heterojunction interface, and currents and energy fluxes at the abrupt interface between two materials are better defined by the interface condition at the heterojunction. In defining thermionic current and thermionic energy flux, Sentaurus Device follows the literature [1].

## Using Thermionic Emission Current

To activate the thermionic current model for electrons at a region-interface (material-interface) heterojunction, the keyword `eThermionic` must be specified in the appropriate region-interface (material-interface) `Physics` section. For example:

```
Physics(MaterialInterface="GaAs/AlGaAs") {
  eThermionic
}
```

Similarly, to activate thermionic current for holes, the keyword `hThermionic` must be specified. The keyword `Thermionic` activates the thermionic emission model for both electrons and holes. If any of these keywords is specified in the `Physics` section for a region `Region.0`, where `Region.0` is a semiconductor, the appropriate model will be applied to each `Region.0`–semiconductor interface.

For small particle and energy fluxes across the interface, the condition of continuous quasi-Fermi level and carrier temperature is sometimes used. This option is activated by the keyword `Heterointerface` in the appropriate `Physics` section. In realistic transistors, such an approach might lead to unsatisfactory results [2].

You can change the coefficients of the thermionic emission model in the `ThermionicEmission` parameter set in an interface-specific section in the parameter file:

```
RegionInterface = "regionA/regionB" {
  ThermionicEmission {
    A = 2, 2  # [1]
    B = 4, 4  # [1]
```

26: Heterostructure Device Simulation

Thermionic Emission Current

```
        C = 1, 1    # [1]
    }
}
```

# Thermionic Emission Model

Assume that at the heterointerface between material 1 and material 2, the conduction edge jump is positive, that is $\Delta E_C > 0$, where $\Delta E_C = E_{C, 2} - E_{C, 1}$ (that is, $\chi_1 > \chi_2$). If $J_{n, 2}$ and $S_{n, 2}$ are the electron current density and the electron energy flux density entering material 2, and $J_{n, 1}$ and $S_{n, 1}$ are the electron current density and the electron energy flux density leaving material 1, then the interface condition can be written as:

$$ J_{n, 2} = J_{n, 1} $$ (869)

$$ J_{n, 2} = a_n q \left[ v_{n, 2} n_2 - \frac{m_{n, 2}}{m_{n, 1}} v_{n, 1} n_1 \exp \left( - \frac{\Delta E_C}{k T_{n, 1}} \right) \right] $$ (870)

$$ S_{n, 2} = S_{n, 1} + \frac{c_n}{q} J_{n, 2} \Delta E_C $$ (871)

$$ S_{n, 2} = -b_n \left[ v_{n, 2} n_2 k T_{n, 2} - \frac{m_{n, 2}}{m_{n, 1}} v_{n, 1} n_1 k T_{n, 1} \exp \left( - \frac{\Delta E_C}{k T_{n, 1}} \right) \right] $$ (872)

where the ‘emission velocities’ are defined as:

$$ v_{n, i} = \sqrt{\frac{k T_{n, i}}{2 \pi m_{n, i}}} $$ (873)

and by default, the coefficients in the above equations are $a_n = 2$, $b_n = 4$, and $c_n = 1$, which corresponds to the literature [1]. Similar equations for the hole thermionic current and hole thermionic energy flux are presented below:

$$ J_{p, 2} = J_{p, 1} $$ (874)

$$ J_{p, 2} = -a_p q \left[ v_{p, 2} p_2 - \frac{m_{p, 2}}{m_{p, 1}} v_{p, 1} p_1 \exp \left( \frac{\Delta E_V}{k T_{p, 1}} \right) \right] $$ (875)

$$ S_{p, 2} = S_{p, 1} + \frac{c_p}{q} J_{p, 2} \Delta E_V $$ (876)

**26: Heterostructure Device Simulation**
Thermionic Emission Current

$$ S_{p, 2} = -b_p \left[ v_{p, 2} p_2 k T_{p, 2} - \frac{m_{p, 2}}{m_{p, 1}} v_{p, 1} n_1 k T_{p, 1} \exp \left( \frac{\Delta E_V}{k T_{p, 1}} \right) \right] $$ (877)

$$ v_{p, i} = \sqrt{\frac{k T_{p, i}}{2 \pi m_{p, i}}} $$ (878)

An equivalent set of equations are used if Fermi carrier statistics is selected.

# Thermionic Emission Model With Fermi Statistics

With Fermi statistics, the electron current density and the electron energy flux density are:

$$ J_{n, 2} = a_n q \left( v_{n, 2} N_{C, 2} \zeta_{n, 2} - \frac{m_{n, 2}}{m_{n, 1}} v_{n, 1} N_{C, 1} \zeta_{n, 1} \right) $$ (879)

$$ S_{n, 2} = -b_n \left( v_{n, 2} k T_{n, 2} N_{C, 2} \zeta_{n, 2} - \frac{m_{n, 2}}{m_{n, 1}} v_{n, 1} k T_{n, 1} N_{C, 1} \zeta_{n, 1} \right) $$ (880)

$$ \zeta_{n, 2} = \ln [1 + \exp(-\eta_{n, 2})] + \eta_{n, 2} $$ (881)

$$ \zeta_{n, 1} = \ln [1 + \exp(-\eta'_{n, 1})] + \eta'_{n, 1} $$ (882)

$$ \eta'_{n, 1} = \eta_{n, 1} - \frac{\Delta E_C}{k T_{n, 1}} $$ (883)

Here, $\eta_n$ is given in Eq. 49, p. 183 and $N_C$ is given in Eq. 176, p. 273. Similar equations apply to holes:

$$ J_{p, 2} = -a_p q \left( v_{p, 2} N_{V, 2} \zeta_{p, 2} - \frac{m_{p, 2}}{m_{p, 1}} v_{p, 1} N_{V, 1} \zeta_{p, 1} \right) $$ (884)

$$ S_{p, 2} = -b_p \left( v_{p, 2} k T_{p, 2} N_{V, 2} \zeta_{p, 2} - \frac{m_{p, 2}}{m_{p, 1}} v_{p, 1} k T_{p, 1} N_{V, 1} \zeta_{p, 1} \right) $$ (885)

$$ \zeta_{p, 2} = \ln [1 + \exp(-\eta_{p, 2})] + \eta_{p, 2} $$ (886)

$$ \zeta_{p, 1} = \ln [1 + \exp(-\eta'_{p, 1})] + \eta'_{p, 1} $$ (887)

$$ \eta'_{p, 1} = \eta_{p, 1} + \frac{\Delta E_V}{k T_{p, 1}} $$ (888)

Gaussian Transport Across Organic Heterointerfaces

Here, $\eta_p$ is given in Eq. 50, p. 183 and $N_V$ is given in Eq. 180, p. 274.

If Fermi statistics is used, this model can be activated by specifying `Formula=1` in the `ThermionicEmission` section of the parameter file:

```
ThermionicEmission { Formula=1 }
```

By default `Formula=0`, it activates the old model, where the Boltzmann-like thermionic emission equations similar to Eq. 869–Eq. 878 are used. This can lead to incorrect results in high carrier density. In this case, a warning message will be given.

> **NOTE** Always specify `Formula=1` when Fermi statistics is used. If Fermi statistics is not used, Eq. 869–Eq. 878 will be activated regardless of the `Formula` statement in the parameter file.

# Gaussian Transport Across Organic Heterointerfaces

A thermionic-like current boundary condition has been introduced to correctly account for carrier transport across organic heterointerfaces. An organic heterointerface is defined in this context as an heterointerface with the Gaussian density-of-states (DOS) model (see Gaussian Density-of-States for Organic Semiconductors on page 276) activated in both regions that are adjacent to the heterointerface.

## Using Gaussian Transport at Organic Heterointerfaces

The model is activated by switching to the Gaussian DOS model in both regions of the heterointerface that are meant to be organic:

```
Physics(Region="OrganicRegion_1") {
  EffectiveMass(GaussianDOS)
}

Physics(Region="OrganicRegion_2") {
  EffectiveMass(GaussianDOS)
}
```

and then specifying the keyword `Organic_Gaussian` as an option for the `Thermionic` model in the `Physics` section of the organic heterointerface:

```
Physics(RegionInterface="OrganicRegion_1/OrganicRegion_2") {
  Thermionic(Organic_Gaussian)
}
```

This syntax also automatically switches on the double points at the organic heterointerface.

**26: Heterostructure Device Simulation**

Gaussian Transport Across Organic Heterointerfaces

You can adjust the parameters $v_{n, \text{org}}$ and $v_{p, \text{org}}$ in Eq. 890 and Eq. 892 in the `ThermionicEmission` section of the parameter file (their default values are $1 \times 10^6$ cm/s):

```
RegionInterface="OrganicRegion_1/OrganicRegion_2" {
    ThermionicEmission {
        vel_org = 1e7, 1e7  # [cm/s]
    }
}
```

# Gaussian Transport at Organic Heterointerface Model

Assuming a positive conduction edge jump and a negative valence edge jump from material 1 to material 2, the boundary conditions at the organic heterointerface are given by:

$$J_{n, 2} = J_{n, 1} \tag{889}$$

$$J_{n, 2} = v_{n, \text{org}} q \left( n_2 - n_1 \exp \left( -\frac{\Delta E_C}{k T_{n, 1}} \right) \right) \tag{890}$$

$$J_{p, 2} = J_{p, 1} \tag{891}$$

$$J_{p, 2} = v_{p, \text{org}} q \left( p_2 - p_1 \exp \left( -\frac{\Delta E_V}{k T_{p, 1}} \right) \right) \tag{892}$$

where:

*   $J_{n, 2}$ and $J_{n, 1}$ are the electron current densities entering material 2 and leaving material 1, respectively.

*   $J_{p, 2}$ and $J_{p, 1}$ are the hole current densities leaving material 2 and entering material 1, respectively.

*   $\Delta E_C = d_{C, 2} - d_{C, 1}$ where $d_{C, 2}$ and $d_{C, 1}$ are the distances of the Gaussian distribution peaks to the conduction band edges.

*   $\Delta E_V = d_{V, 2} - d_{V, 1}$ where $d_{V, 2}$ and $d_{V, 1}$ are the distances of the Gaussian distribution peaks to the valence band edges.

26: Heterostructure Device Simulation
References

# References

[1] D. Schroeder, *Modelling of Interface Carrier Transport for Device Simulation*, Wien: Springer, 1994.

[2] K. Horio and H. Yanai, “Numerical Modeling of Heterojunctions Including the Thermionic Emission Mechanism at the Heterojunction Interface,” *IEEE Transactions on Electron Devices*, vol. 37, no. 4, pp. 1093–1098, 1990.

