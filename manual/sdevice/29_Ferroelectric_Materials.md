# CHAPTER 29 Ferroelectric Materials

*This chapter explains how ferroelectric materials are treated in a simulation using Sentaurus Device.*

In ferroelectric materials, the polarization $\vec{P}$ depends nonlinearly on the electric field $\vec{F}$. The polarization at a given time depends on the electric field at that time and the electric field at previous times. The history dependence leads to the well-known phenomenon of hysteresis, which is used in nonvolatile memory technology.

# Using Ferroelectrics

Sentaurus Device implements a model for ferroelectrics that features minor loop nesting and memory wipeout. Figure 52 demonstrates these properties and Ferroelectrics Model on page 858 discusses them further.

| F [kV/cm] | P [mAs/cm²] |
| --- | --- |
| -150 | -20 |
| -100 | -18 |
| -50 | -10 |
| 0 | 0 |
| 50 | 10 |
| 100 | 18 |
| 150 | 20 |

Figure 52 Example polarization curve

To activate the model, specify the keyword `Polarization` in the `Physics` section of the command file. Use the optional parameter `Memory` to prescribe the maximum-allowed nesting depth of minor loops. The smallest allowed value for `Memory` is 2; the default value is 10. If minor loop nesting becomes too deep, then the nesting property of the minor loops can be lost. However, the polarization curve remains continuous.

Using Ferroelectrics

The following example switches on the ferroelectric model in region `Region.17` and sets the size of the memory to 20 turning points for each element and each mesh axis:

```
Physics (region = "Region.17") {
  Polarization (Memory=20)
}
```

To obtain a plot of the polarization field, specify `Polarization/Vector` in the `Plot` section of the command file.

Sentaurus Device characterizes the static properties of a ferroelectric material by three parameters: the remanent polarization *P<sub>r</sub>*, the saturation polarization *P<sub>s</sub>*, and the coercive field *F<sub>c</sub>*. The hysteresis curve in Figure 52 on page 855 illustrates these quantities. Furthermore, Sentaurus Device parameterizes the transient response of the ferroelectric material by the relaxation times $\tau_E$ and $\tau_P$, and by a nonlinear coupling constant $k_n$ (see Ferroelectrics Model on page 858).

Specify the values for these parameters in the `Polarization` parameter set. For example:

```
Polarization
{ * Remanent polarization P_r, saturation polarization P_s,
  * and coercive field F_c for x,y,z direction (crystal axes)
    P_r = (1.0000e-05, 1.0000e-05, 1.0000e-05) #[C/cm^2]
    P_s = (2.0000e-05, 2.0000e-05, 2.0000e-05) #[C/cm^2]
    F_c = (2.5000e+04, 2.5000e+04, 2.5000e+04) #[V/cm]
  * Relaxation time for the auxiliary field tau_E, relaxation
  * time for the polarization tau_P, nonlinear coupling kn.
    tau_E = (0.0000e+00, 0.0000e+00, 0.0000e+00) #[s]
    tau_P = (0.0000e+00, 0.0000e+00, 0.0000e+00) #[s]
    kn    = (0.0000e+00, 0.0000e+00, 0.0000e+00) #[cm*s/V]
}
```

The parameters in this example are the defaults for the material `InsulatorX`. For all other materials, all default values are zero. Each of the three numbers given for any of the parameters corresponds to the value for the respective coordinate axis of the mesh. If a `P_s` component is zero, then the ferroelectric model is deactivated along the corresponding direction. If a `P_s` component is nonzero, then the respective `P_r` and `F_c` components must also be nonzero. Furthermore, the `P_r` component must be smaller than the `P_s` component. By default, the relaxation times are zero, which means that polarization follows the applied electric field instantaneously.

To start the simulation from a given polarization state *P<sub>ini</sub>*, use the optional keyword `initialvector` to prescribe the components of the initial polarization vector. The absolute value of each component given for `initialvector` must be smaller than or equal to the remanent polarization `P_r`, along the corresponding axis. The default for `initialvector` is a null vector.

Using Ferroelectrics

The following example sets the components of the initial polarization vector in region `R.Ferro` to 1.0e-05 C/cm<sup>2</sup> along each axis of the mesh:

```
Physics (Region= "R.Ferro") {
  Polarization (initialvector= (1.0e-05 1.0e-05 1.0e-05))
}
```

In devices with ferroelectric and semiconductor regions, it might be difficult to obtain an initial solution of the Poisson equation. In many cases, the `LineSearchDamping` keyword can solve these problems (see Damped Newton Iterations on page 145). To use this keyword, start the simulation as follows:

```
coupled (LineSearchDamping=0.01) { Poisson }
```

Due to the decoupled handling of the polarization vector components (see Ferroelectrics Model) and the nonlinearity of the polarization versus electric-field relation, the resulting polarization profiles might not reflect the device symmetry for nonrectangular structures. Under these circumstances, it is helpful to specify the polarization direction different from the default ones, aligned with the coordinate axes. This is achieved with the help of the predefined reference surfaces.

In this case, the direction of the polarization vector at a given point in space is taken to be opposite to the geometrically shortest path connecting this point and the closest point on the specified surface. Such a vector is normal to the reference surface. This allows the polarization vector field to follow the device symmetry. As an example, for a cylindrical geometry, if the surface is taken as an exterior of the cylinder, then the polarization will align along the lines connecting the external surface and the center of the cylinder.

The following example illustrates how to use this feature in a simulation scenario where the polarization in region "R.Ferro" is perpendicular to the electrode "C.Gate", which composes the "S.Gate" surface:

```
Electrode { {Name="C.Gate" ...} }

Math { Surface "S.Gate" (Electrode="C.Gate") }

Physics (Region="R.Ferro") {
  Polarization(SurfaceName="S.Gate" SurfaceReconstruction)
}
```

The `Surface` defined in the global `Math` section can be a union of an arbitrary number of region or material interfaces and electrodes (see Table 206 on page 1518).

When performing simulations of ferroelectric gate-all-around structures discretized with an axis-aligned mesh, it is recommended to use the reference surface specified by the `SurfaceName` keyword together with the `SurfaceReconstruction` option, as in the previous example. This option activates an improved algorithm for calculating the directional

29: Ferroelectric Materials

Ferroelectrics Model

polarization. This combination alleviates the impact of device geometry and mesh quality on the physical results and obtains reliable polarization profiles independently on the mesh.

# Ferroelectrics Model

The vector quantity $\vec{P}$ is split into its components along the main axes of the mesh coordinate system. This results in one to three scalar problems. Sentaurus Device handles each problem separately using the model from [1] with extensions for transient behavior [2].

First, Sentaurus Device computes an auxiliary field $F_{\text{aux}}$ from the electric field $F$:

$$ \frac{d}{dt}F_{\text{aux}}(t) = \frac{F(t) - F_{\text{aux}}(t)}{\tau_E} \text{ (942)} $$

Here, $\tau_E$ is a material-specific time constant. For $\tau_E = 0$ or for quasistationary simulations, $F_{\text{aux}} = F$.

From the auxiliary field, Sentaurus Device computes the auxiliary polarization $P_{\text{aux}}$. The auxiliary polarization $P_{\text{aux}}$ is an algebraic function of the auxiliary field $F_{\text{aux}}$:

$$ P_{\text{aux}} = c \cdot P_s \cdot \tanh(w \cdot (F_{\text{aux}} \pm F_c)) + P_{\text{off}} \text{ (943)} $$

where $P_s$ is the saturation polarization, $F_c$ is the coercive field, and:

$$ w = \frac{1}{2F_c} \ln \frac{P_s + P_r}{P_s - P_r} \text{ (944)} $$

where $P_r$ is the remanent polarization. In Eq. 943, the plus sign applies to the decreasing auxiliary field and the minus sign applies to the increasing auxiliary field. The different signs reflect the hysteretic behavior of the material. $P_{\text{off}}$ and $c$ in Eq. 943 result from the polarization history of the material, see below.

Finally, from the auxiliary polarization and auxiliary field, Sentaurus Device computes the actual polarization $P$:

$$ \frac{d}{dt}P(t) = \frac{P_{\text{aux}}[F_{\text{aux}}(t)] - P(t)}{\tau_P} \left( 1 + k_n \left| \frac{d}{dt}F_{\text{aux}}(t) \right| \right) \text{ (945)} $$

Here, $\tau_P$ and $k_n$ are material-specific constants. For $\tau_P = 0$ or for quasistationary simulations, $P = P_{\text{aux}}$.

Upper and lower turning points are points in the $P_{\text{aux}} - F_{\text{aux}}$ diagram where the sweep direction of the auxiliary field $F_{\text{aux}}$ changes from increasing to decreasing, and from decreasing to

29: Ferroelectric Materials
Ferroelectrics Model

increasing, respectively. At each bias point, the most recent upper and lower turning points, ($F_u, P_u$) and ($F_l, P_l$), must both be on each of the two curves defined by Eq. 943; this requirement determines $P_{\text{off}}$ and $c$.

Sentaurus Device *memorizes* turning points as they are encountered during a simulation. The memory always contains ($\infty, P_s$) as the oldest and ($-\infty, -P_s$) as the second-oldest turning point. By using Eq. 943, these two points define a pair of curves with $c = 1$ and $P_{\text{off}} = 0$; together, the two curves form the saturation loop. All other pairs of turning points result in $c < 1$ and define a pair of curves forming minor loops.

When the auxiliary field leaves the interval defined by $F_l$ and $F_u$ of the two newest turning points, these two turning points are removed from the memory; this reflects the memory wipeout observed in experiments. The pair of turning points that are newest in the memory, after this removal, determines the further $P_{\text{aux}}(F_{\text{aux}})$ relationship.

As the older of the dropped turning points was originally reached by walking on the curve defined by the turning points that now (after dropping) again determine $P_{\text{aux}}(F_{\text{aux}})$, the polarization curve remains continuous. For example, see points e, f, and i in Figure 52 on page 855. Furthermore, the minor loop defined by the two dropped turning points is nested inside the minor loop defined by the present turning points. The nesting of minor loops is also a feature known from experiments on ferroelectrics. Figure 52 illustrates this by the loops f-g and i-k, both of which are nested in loop e-h, which in turn is nested in loop c-d.

In small-signal (AC) analysis, a very small periodic signal is added to the DC bias (see Small-Signal AC Analysis on page 101). As a result, the (auxiliary) polarization at each point of the ferroelectric material changes along a very small minor loop nested in the main loop that stems from the DC variation of the bias voltage. The average slope of this minor loop is always smaller than the slope of the main loop at the point where the loops touch. Consequently, even at very low frequencies, the AC response of the system is different from what would be obtained by taking the derivative of the DC curves.

You can instruct Sentaurus Device to stay on the main branch of the hysteresis loop when computing the AC response. To this end, specify `MainLoopAC` to the `Polarization` keyword as in the following example:

```
Physics (Region = "R.Ferro") { Polarization (MainLoopAC) }
```

This gives rise to multivalued butterfly-like C–V characteristics when calculating the AC response of ferroelectric materials. At low frequencies, the AC response calculated in this way closely resembles the derivative of the DC curves.

As an example of how the turning point memory works, see Figure 52. The points on the polarization curve are reached in the sequence a, b, c, d, e, f, g, f, h, i, k, i, e, c. For simplicity, a quasistationary process is assumed and, therefore, $F_{\text{aux}} = F$ and $P_{\text{aux}} = P$. Starting the simulation at point a, the newest point in memory is b (Sentaurus Device initializes it in this

29: Ferroelectric Materials
Ginzburg–Landau–Khalatnikov Equation

way). The second newest point is a negative saturation point (l), and the oldest point is a positive saturation point (u). This memory state is denoted by [blu]. For this state, a is on the decreasing field curve. The curve segment (that is, the coefficients $c$ and $P_{\text{off}}$) from a to b is determined by the points l and b.

Ramping up from a makes a a turning point, so the memory becomes [ablu]. When crossing b and proceeding to c, a and b are dropped from the memory. Therefore, the memory becomes [lu]. These two points determine the curve from b to c. Turning at c, c is added to the memory, giving [clu]. From c to d, use c and l; at d, the memory becomes [dclu]; at point e, [edclu]; at f, [fedclu]; at g, [gfedclu]. Passing through f, the two newest points, f and g, are dropped and the memory is [edclu]; at h, [hedclu]; at i, [ihedclu]; at k, [kihedclu]. At i again, i and k are dropped, giving [hedclu]; at e, e and h are dropped, giving [dclu].

At the beginning of a simulation, the memory contains one turning point chosen such that the point $E_{\text{aux}} = 0$, $P_{\text{aux}} = P_{\text{ini}}$ is on the minor loop so defined (for example, point b in Figure 52 on page 855, in the case of $P_{\text{ini}} = 0$). The nature of the model is such that it is not possible to have a state of the system that is completely symmetric. In particular, even for a symmetric device and at the very beginning of the simulation, $P(E) \neq -P(-E)$. This asymmetry is most prominent for the virginal curves (for example, a-b in Figure 52) of the ferroelectric, which are different for different signs of voltage ramping.

# Ginzburg–Landau–Khalatnikov Equation

The Ginzburg–Landau–Khalatnikov equation provides a reliable description of ferroelectric material properties in terms of a free energy $F$ expanded as a power series in the ferroelectric polarization $P$. The state of the system is determined by minimizing this free energy $F(P)$ with respect to $P$. Interesting properties of ferroelectric materials emerge from a characteristic multi-well free-energy polarization landscape. Switching between the metastable minima of $F(P)$ due to an applied electric field $E$ gives rise to an electric-field polarization hysteresis phenomenon, used in nonvolatile memory technology. Stabilization of the saddle point of $F(P)$ by a depolarizing electric field allows for ferroelectric negative-capacitance operation, which is used in low-power computing applications.

Based solely on symmetry considerations, the Landau theory provides an expansion of the free energy $F$ as a power series of the order parameter [[3]](ref_3)[[4]](ref_4). For ferroelectric phase transitions, this order parameter is the polarization vector **P**. The free energy of a ferroelectric material occupying a region is written as [[3]](ref_3)[[4]](ref_4):

$$ F = \int_{\Omega} \left( \alpha_i P_i^2 + \beta_i P_i^4 + \gamma_i P_i^6 - g_{ij} \frac{\partial P_i}{\partial x_j} - E_i P_i + \varepsilon_0 E_i E_i \right) d\Omega \tag{946} $$

 **29: Ferroelectric Materials**
Ginzburg–Landau–Khalatnikov Equation

In the Ginzburg–Landau–Khalatnikov framework, the governing equation of polarization evolution can be obtained as a gradient flow associated with the free energy functional given in Eq. 946:

$$ \rho \frac{dP_i}{dt} + \nabla_{P_i} F = 0 $$ (947)

From Eq. 946 and Eq. 947, the electric field–polarization relation can be derived:

$$ \rho \frac{dP_i}{dt} + 2\alpha_i P_i + 4\beta_i P_i^3 + 6\gamma_i P_i^5 - 2g_{ij} \frac{\partial^2 P_i}{\partial x_j^2} - E_i = 0 $$ (948)

In these equations, $P_i$ and $E_i$ denote the Cartesian components ($ij = x, y, z$) of the polarization vector **P** in C/cm² and the electric field vector **E** in V/cm, respectively.

Each term in Eq. 946 has a physical interpretation:

* The first three terms correspond to the stored Landau energy due to polarization. The Landau energy builds in the information that the crystal prefers certain spontaneous polarization at its minima. The Landau coefficients $\alpha_i$, $\beta_i$, and $\gamma_i$ are used to parameterize the energy function, which can be extracted from electric-field polarization measurements of a ferroelectric capacitor.

* The fourth term, associated with polarization gradients, accounts for the potential energy caused by nonuniform polarization and is regarded as the energetic cost of forming domain walls [3]. This term penalizes sharp changes in the spatial distribution of the polarization vector field. The width of the polarization domain walls is proportional to the square root of the smallest eigenvalue of the matrix composed from the $g_{ij}$ coefficients.

* If the polarization deviates from the preferred states, corresponding to the minima of F[P], the energy cost must be compensated by the potential energy of the applied electric field **E** as described by the fifth term. This term enforces the need of the polarization to align with the electric field.

* The last term is the electrostatic energy associated with the electric field that is generated by the polarization distribution. For any polarization distribution, the electrostatic potential is determined by solving the Poisson equation (see Eq. 37, p. 179) in the entire simulation domain, subject to appropriate boundary conditions.

The steady-state solution ($dP_i / dt = 0$) of Eq. 948 corresponds to a thermal equilibrium state of the ferroelectric. In this state, the free energy attains its minimum when Eq. 946 is optimized with respect to the polarization distribution under the applied electric field. The equilibrium polarization distribution cannot be arbitrary. Instead, the energy-minimized polarization vector field must satisfy the equation of continuity [5]:

$$ \frac{\partial P_i}{\partial x_i} = 0 $$ (949)

29: Ferroelectric Materials

Ginzburg–Landau–Khalatnikov Equation

The electrical compatibility condition expressed in Eq. 949 ensures that polarization is divergence free and, consequently, the ferroelectric domain remains charge free. Therefore, the divergence-free polarization distribution is energy minimized.

# Using the Ginzburg–Landau–Khalatnikov Equation

To activate the equation, you must specify the keyword `FEPolarization` in the regionwise or materialwise `Physics` sections of the command file. Since ferroelectrics are insulators, the equation can be activated only for the materials of group `Insulator` (see User-Defined Materials on page 14).

Apart from activating the equation in the `Physics` section, the equation must be solved by adding `FEPolarization` in the `Solve` section. In general, it is recommended to perform transient simulations when using this equation. This emulates the physical process of polarization evolution and allows you to verify the decrease property of the free energy along the solution paths, for convergence to a physically relevant solution.

The following example solves the equation in region `GateOxide`. First, the Poisson equation is solved alone to obtain an initial guess of the electrostatic potential. Second, a transient simulation is performed for 1 s to find an initial state of the device. This is followed by biasing the gate contact from its initial value at t=1 s to 1 V at t=2 s by using a transient ramp command (see Transient Ramps on page 96):

```
Physics ( Region="GateOxide" ) {
  FEPolarization
}
Solve {
  Poisson
  Transient (
    InitialTime=0 FinalTime=1
  ) { Coupled { Poisson FEPolarization } }
  Transient (
    InitialTime=1 FinalTime=2
    Goal { name="Gate" Voltage=1 }
  ) { Coupled { Poisson FEPolarization } }
}
```

You can plot the polarization vector field by adding, in the `Plot` section, either of the following keywords:

* `FEPolarization/Vector` for plotting polarization vector distributions on vertices

* `FEPolarization/Element/Vector` for element-based plots (see Device Plots on page 128)

**29: Ferroelectric Materials**
Ginzburg–Landau–Khalatnikov Equation

For example, the following statement saves the `FEPolarization` vertex-vector dataset to the output file:

```
Plot { FEPolarization/Vector }
```

The model parameters are as follows:

*   $\alpha_i$, $\beta_i$, and $\gamma_i$ are ferroelectric material parameters, typically extracted from measurements.

*   $\rho$ is the viscosity, a kinetic coefficient associated with polarization-switching dynamics.

*   $g_{ij}$ is a coupling coefficient for the polarization gradient term of the free energy.

These parameters can be accessed in the parameter file and can be specified regionwise or materialwise. The ferroelectric property is considered isotropic by default. Therefore, the multiple coefficients in Eq. 948 can be replaced by single scalar values: $\alpha_i$=alpha, $\beta_i$=beta, $\gamma_i$=gamma, and $g_{ij}$=g.

For example:

```
FEPolarization {
   alpha = -1.3e+10   # cm/F
   beta  = 1.3e+20    # cm^5/(FC^2)
   gamma = 0.0        # cm^9/(FC^4)
   g     = 1.0e-03    # cm^3/F
   rho   = 1.0e+04    # Ohm*cm
}
```

This example corresponds to a ferroelectric undergoing a second-order (continuous) phase transition, since alpha < 0 and beta > 0. For first-order (discontinuous) phase transitions, set alpha < 0, beta < 0, and gamma > 0. In general, beta, or gamma, or both coefficients must be set to a positive value. Typical values of g range from 10<sup>–6</sup> to 10<sup>–2</sup> cm³ /F . Mole fraction dependency is not supported for these parameters.

Table 151 Parameters and their default values for Ginzburg–Landau–Khalatnikov equation

| Name | Description | Default value | Unit |
| --- | --- | --- | --- |
| alpha | α parameter | –4e9 | cm/F |
| beta | β parameter | –5e16 | cm⁵/(FC²) |
| gamma | γ parameter | 5e25 | cm⁹/(FC⁴) |
| g | Gradient term | 1e-3 | cm³/F |
| rho | ρ viscosity | 2.25e4 | Ωcm |

Ginzburg–Landau–Khalatnikov Equation

The quality of the divergence-free polarization constraint, as expressed by Eq. 949, is controlled by the `FEPolarizationIP` parameter, which is used in the global `Math` section:

```
Math { FEPolarizationIP=1.0 }
```

This value applies to all regions where the Ginzburg–Landau–Khalatnikov equation (`FEPolarization`) is activated. Generally, the higher the value of `FEPolarizationIP`, the better the approximation of the divergence-free condition on the polarization vector field. However, too high values of `FEPolarizationIP` might overshadow the equation of state, leading to spurious simulation results. Therefore, take care when adjusting this parameter. The recommended values are of order O(1). The default value of `FEPolarizationIP` is zero.

The anisotropic properties of a ferroelectric material can be modeled by referring to the `FEPolarization_tensor` parameter set. To use it, specify `FEPolarization(Tensor)` in the `Physics` section, when activating the model. In this parameter set, each of the elements of the Landau coefficients, $\alpha_i$=alphai, $\beta_i$=betai, and $\gamma_i$=gammai, corresponds to the $P_i$ polarization component along the respective coordinate axis of the mesh, where $i = 1, 2, 3$. Analogously, the $g_{ij}$ element of the anisotropic polarization gradient factor affects the spatial derivative of the $P_i$ polarization component along the $x_j$ direction, where $i, j = 1, 2, 3$. Generally, the polarization gradient coefficients $g_{ij}$ form a symmetric 3×3 tensor. Due to symmetry, it has only six independent components, and it is convenient to express it in a contracted six-component vector notation (Voigt form):

$$ g_{11} = g_1, g_{22} = g_2, g_{33} = g_3, g_{23} = g_{32} = g_4, g_{13} = g_{31} = g_5, g_{12} = g_{21} = g_6 $$ (950)

which is employed in the `FEPolarization_tensor` parameter set.

In the following example, a material is simulated that displays ferroelectric properties only along the x-axis and y-axis of the coordinate system. In the z-direction of the mesh, it behaves like a linear dielectric:

```
FEPolarization_tensor {
      alpha1 =-1.3e+10 # [cm/F]
      alpha2 =-1.3e+10 # [cm/F]
      alpha3 = 1.3e+12 # [cm/F]
      beta1  = 1.3e+20 # [cm^5/(FC^2)]
      beta2  = 1.3e+20 # [cm^5/(FC^2)]
      beta3  = 0.0      # [cm^5/(FC^2)]
      gamma1 = 0.0      # [cm^9/(FC^4)]
      gamma2 = 0.0      # [cm^9/(FC^4)]
      gamma3 = 0.0      # [cm^9/(FC^4)]
      g1     = 1.0e-03 # [cm^3/F]
      g2     = 1.0e-03 # [cm^3/F]
      g3     = 1.0e-03 # [cm^3/F]
      g4     = 1.0e-03 # [cm^3/F]
      g5     = 1.0e-03 # [cm^3/F]
      g6     = 1.0e-03 # [cm^3/F]
}
```

29: Ferroelectric Materials

Ginzburg–Landau–Khalatnikov Equation

```
    rho      = 1.0e+04  # [Ohm*cm]
}
```

Such an anisotropic ferroelectric material can be successfully integrated in a 3D FinFET device with the z ($i = 3$)-axis of the mesh assumed to be a transport direction. In this case, the ferroelectric field effect is caused by the x- and y-polarization components, perpendicular to the channel. The fact that no ferroelectric effect is present along the channel has a negligible impact on the device operation.

# Versions of the Solver

Different solver versions are available:

*   Default

*   Multidimensional

*   Solver II

## Default

For the default `FEPolarization` solver (first available in Version O-2018.06), the divergence-free polarization constraint (Eq. 949) is not supported. Consequently, the `FEPolarizationIP` parameter is ignored.

In addition, you must specify `direction` along the axis in the `FEPolarization` statement of the `Physics` section. For example:

```
Physics (Region="GateOxide") {
  FEPolarization ( direction="x" )
}
```

Here, `x` defines the switchable polarization component that is solved. The `direction` parameter takes only x, y, or z as its value. Polarization can be solved along the specified direction, which is the direction perpendicular to the gate, given the fact that the polarization vector can switch only along this direction. To solve tri-gate structures or FinFETs, you can define different ferroelectric regions and specify the appropriate direction in each region.

> **NOTE** You can define the model parameters in either the command file or the parameter file, except for `direction` that can be defined only in the command file.

When using the parameter file, you use the `FEPolarization` parameter set (see Table 151 on page 863), which is the same as the default implementation, except that mole fraction–dependent parameters for compound materials are supported in this version (see

Ginzburg–Landau–Khalatnikov Equation

Parameters for Composition-Dependent Materials on page 24). However, it is not possible to use the `FEPolarization_tensor` parameter set with this solver.

> **NOTE** When you define parameters in both the command file and the parameter file, those in the command file take precedence. In addition, all parameters must be defined entirely in the command file or the parameter file. Mixed definitions are not allowed.

Since this version solves only one component of the polarization vector field, the output is stored in a scalar dataset `FEPolarization` instead of a vector dataset.

To plot `FEPolarization`, specify:

```
Plot { FEPolarization }
```

By default, the polarization field is initialized to zero. You can use `sFactor` to set the initial value of the polarization. The following example initializes the polarization field $P_x$ to the value stored in `PMIUserField1`:

```
Physics (Region="GateOxide") {
  FEPolarization ( direction="x" sFactor=("PMIUserField1") )
}
```

## Multidimensional

To solve simultaneously for all of the Cartesian components of the polarization vector field, it is recommended to use this version of the `FEPolarization` solver, which is activated by specifying the `CompatibleFEPolarization` keyword in the global `Math` section. This version supports the `FEPolarizationIP` parameter for simulating solenoidal (divergence-free) polarization vector fields as in the following example:

```
Math {
  CompatibleFEPolarization
  FEPolarizationIP=1.0
}
```

You must also set `direction="all"` in the `FEPolarization` statement of the `Physics` section as follows:

```
Physics {
  FEPolarization ( direction="all" )
}
```

When using `CompatibleFEPolarization`, special care must be taken if the ferroelectric region is not rectangular. You might observe a nonphysical diminishing of the polarization close to nonaxis-aligned interfaces. This issue can be alleviated by lowering the value of `FEPolarizationIP`. However, this might result in a poor approximation of the polarization

**29: Ferroelectric Materials**

Ginzburg–Landau–Khalatnikov Equation

divergence-free condition, which has a negative impact on numeric stability. For structures with nonrectangular regions, it is recommended to use the default `FEPolarization` approach.

This version supports the `FEPolarizationIP` parameter for simulating solenoidal (divergence-free) polarization vector fields as in the following example:

```
Math {
  CompatibleFEPolarization
  FEPolarizationIP=1.0
}
```

The `FEPolarization_tensor` parameter set is not supported in this version.

# Solver II

The previously discussed geometric restriction can be removed by using the new version of the solver activated by specifying the `FEPolarizationSolver2` keyword in the global `Math` section. This solver supports the `FEPolarizationIP` parameter and the parameter set `FEPolarization_tensor`, and it is the most stable solver.

However, due to numerics and software-related aspects, the following physical models do not yet work with the Ginzburg–Landau–Khalatnikov equation:

*   Dipole Layer on page 180

*   Thermodynamic Model for Current Densities on page 191

*   Hydrodynamic Model for Current Densities on page 192

*   Temperature equations (see Chapter 9 on page 197)

*   Modified Ohmic Contacts on page 212

*   Contacts on Insulators on page 213

*   Floating Contacts on page 232

*   Periodic Boundary Conditions on page 237

*   Explicit Trap Occupation on page 496

*   Diffusion of Hydrogen in Oxide on page 546

*   Degradation in Insulators on page 553

*   Tunneling (see Chapter 24 on page 767)

*   Ferroelectrics on page 1380

In addition, not all numeric techniques can be used with the Ginzburg–Landau–Khalatnikov equation. The following methods are not supported:

*   Mixed-mode simulations (see Chapter 3 on page 41)

*   Small-Signal AC Analysis on page 101

Ginzburg–Landau–Khalatnikov Equation

*   Harmonic Balance on page 106

*   AC Simulation on page 1147

*   Harmonic Balance Analysis on page 1150

*   TRBDF Composite Method on page 1156

## Bitlis Solver

A specialized linear solver is available for electrostatic problems, including the Poisson and `FEPolarization` equations. You activate this solver by specifying `Bitlis` as an option to the `Method` keyword, which is used in Sentaurus Device to select various solution algorithms (see Linear Solvers on page 151 for details about the `Method` keyword).

The iterative linear solver Bitlis implements the generalized minimal residual (GMRES) method. The parameters of this solver are specified in parentheses after the solver declaration in the global `Math` section as follows:

```
Math {
  Method = Bitlis (Restart=100, Tolerance=1e-5, Iterations=200)
}
```

The parameter `Restart` determines a number of GMRES back-vectors. If the solution did not converge within a given `Restart` number, then GMRES restarts the iteration. A higher number of back-vectors improves convergence but at the expense of higher memory and execution time. The `Tolerance` coefficient controls the stopping criterion of the iterative method. The method stops if the norm of the residual is reduced by this factor or if a maximum number of iterations is reached. The latter is specified by the `Iterations` parameter. Table 152 lists the default values of these parameters.

Table 152 Parameters of Bitlis solver

| Parameter | Default value |
| --- | --- |
| Iterations | 200 |
| Restart | 100 |
| Tolerance | 1e-8 |

The Bitlis solver can be combined with a multi-grid preconditioner to achieve good performance and to reduce the time to compute the solution. A multi-grid method tries to approximate the original discrete equations on a hierarchy of grids and uses solutions from coarse grids to accelerate the convergence on the finest grid. You activate the multi-grid preconditioner in Sentaurus Device by specifying the `MGPreconditioner` statement in the global `Math` section.

**29: Ferroelectric Materials**

Ginzburg–Landau–Khalatnikov Equation

This statement accepts multiple parameters that control the multi-grid algorithm:

```
Math {
  MGPreconditioner(
    MaxLevels=3,
    MinSize=20,
    RelaxationError=1e-10,
    MaxIterations=3,
    SolutionError=1e-8,
    MaxCycles=3
  )
}
```

The parameter `MaxLevels` allows you to declare a maximum number of interpolation levels that build the multi-grid hierarchy in Sentaurus Device. The parameter `MinSize` alters the multi-grid hierarchy and can be used to specify the minimum size of the coarsest grid. Sentaurus Device will not create further interpolation levels if current level size is less than this number.

On the coarsest level, the direct linear solver PARDISO is invoked to solve an approximate discrete problem. The solution of this problem is interpolated to the finest grid using multi-grid techniques. In this process, smoothing of the error is necessary. To this end, a few iterations of the basic iterative damped Jacobi method are invoked. The parameter `RelaxationError` controls the smoothness of the error as it declares the convergence criterion for the smoother. That is, the smoothing iteration stops if the norm of the preconditioned residual is reduced by this factor. The maximum number of smoother sweeps is set by the `MaxIterations` parameter. Better convergence and a larger number of smoothing iterations improve the quality of the approximate solution within the multi-grid preconditioner. However, the application time of the multi-grid preconditioner in every GMRES iteration increases in this case.

The parameters `SolutionError` and `MaxCycles` control the overall convergence of the multi-grid preconditioner.

Only the solutions of the Poisson and `FEPolarization` equations are accelerated with the multi-grid preconditioner for the Bitlis iterative method. Other equations are solved using PARDISO (see Linear Solvers on page 151 for details about this method).

> **NOTE** If you specify the `MGPreconditioner` statement in the `Math` section, but the Bitlis solver is not used, then the statement has no effect on the linear solve. The Bitlis solver is not compatible with the `Blocked` method.

29: Ferroelectric Materials

References

# References

[1] B. Jiang *et al.*, “Computationally Efficient Ferroelectric Capacitor Model for Circuit Simulation,” in *Symposium on VLSI Technology*, Kyoto, Japan, pp. 141–142, June 1997.

[2] K. Dragosits, *Modeling and Simulation of Ferroelectric Devices*, PhD thesis, Technische Universität Wien, Vienna, Austria, December 2000.

[3] P. Chandra and P. B. Littlewood, “A Landau Primer for Ferroelectrics,” *Topics in Applied Physics*, vol. 105, pp. 69–116, 2007.

[4] N. Ng, R. Ahluwalia, and D. J. Srolovitz, “Depletion-layer-induced size effects in ferroelectric thin films: A Ginzburg-Landau model study,” *Physical Review B*, vol. 86, p. 094104, September 2012.

[5] L. D. Landau and I. M. Khalatnikov, “On the Anomalous Absorption of Sound Near a Second Order Phase Transition Point” (Dokl. Akad. Nauk SSSR, 96, 469, 1954), *Collected Papers of L. D. Landau*, D. Ter Haar (ed.), Oxford: Pergamon, pp. 626–629, 1965.

