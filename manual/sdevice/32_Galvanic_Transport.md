# CHAPTER 32 Galvanic Transport

*This chapter describes the model for carrier transport in magnetic fields.*

# Model Description

For analysis of magnetic field effects in semiconductor devices, the transport equations governing the flow of electrons and holes in the interior of the device must be set up and solved.

To this end, the commonly used drift-diffusion-based model of the carrier current densities $\vec{J}_n$ and $J_p$ must be augmented by magnetic field–dependent terms that account for the action of the transport equations governing the flow of electrons and holes in the interior of the device, the *Lorentz force* on the motion of the carriers [1][2][3]:

$$ \vec{J}_\alpha = \mu_\alpha \vec{g}_\alpha + \mu_\alpha \frac{1}{1 + (\mu_\alpha^* B)^2} [\mu_\alpha^* \vec{B} \times \vec{g}_\alpha + \mu_\alpha^* \vec{B} \times (\mu_\alpha^* \vec{B} \times \vec{g}_\alpha)] \quad \text{with } \alpha = n, p \quad (1075) $$

where:

*   $\vec{g}_\alpha$ is current vector without mobility (see Current Densities on page 842).

*   $\mu_\alpha^*$ is the Hall mobility.

*   $\vec{B}$ is the magnetic induction vector, and $B$ is the magnitude of this vector.

The perpendicular (transverse) components of Hall and drift mobility are related by $\mu_n^* = r_n \mu_n$ and $\mu_p^* = r_p \mu_p$, where $r_n$ and $r_p$ denote the Hall scattering factors. In the case of bulk silicon, typical values are $r_n = 1.1$ and $r_p = -0.7$.

# Using Galvanic Transport Model

In the `Physics` section of the command file, specify the magnetic field vector using the keyword `MagneticField= (<x>,<y>,<z>)`. In the following example, a field of 0.1 Tesla is applied parallel to the z-axis:

```
Physics { ...
  MagneticField = (0.0, 0.0, 0.1)
}
```

This parameter can be ramped (see Ramping Physical Parameter Values on page 79).

32: Galvanic Transport
Discretization Scheme for Continuity Equations

# Discretization Scheme for Continuity Equations

Sentaurus Device uses a modified discretization scheme for continuity equations in a constant magnetic field. This scheme contains an additive term to the effective electric field in the Scharfetter–Gummel approximation, that is, in this approximation, the argument to the Bernoulli function has an additional magnetic term. This discretization scheme has good convergence and mesh stability (the new approximation does not demand a special grid).

**NOTE** You cannot combine the galvanic transport model with the following models: hydrodynamic, impact ionization, aniso, piezo, and quantum modeling.

The value of the magnetic field is a critical parameter for convergence. For doping-dependent mobility, convergence is reliable up to $B = 10\text{ T}$. For more general mobility, convergence has a limit of the magnetic field up to $B = 1\text{ T}$.

# References

[1] W. Allegretto, A. Nathan, and H. Baltes, “Numerical Analysis of Magnetic-Field-Sensitive Bipolar Devices,” *IEEE Transactions on Computer-Aided Design*, vol. 10, no. 4, pp. 501–511, 1991.

[2] C. Riccobene *et al.*, “Operating Principle of Dual Collector Magnetotransistors Studied by Two-Dimensional Simulation,” *IEEE Transactions on Electron Devices*, vol. 41, no. 7, pp. 1136–1148, 1994.

[3] C. Riccobene *et al.*, “First Three-Dimensional Numerical Analysis of Magnetic Vector Probe,” in *IEDM Technical Digest*, San Francisco, USA, pp. 727–730, December 1994.

