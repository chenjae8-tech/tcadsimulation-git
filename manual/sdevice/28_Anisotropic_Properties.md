# CHAPTER 28 Anisotropic Properties

*This chapter discusses the anisotropic properties of semiconductor devices.*

## Anisotropic Properties of Semiconductor Devices

In general, all equations for semiconductor devices can be written in the following form:

$$ -\nabla \cdot \vec{J} = R $$ (901)

Here, vector $\vec{J} = \hat{\mu}\vec{g}$ and the tensor coefficient $\hat{\mu} = \mu \cdot \hat{A}$, where $\mu$ is a scalar function, tensor $\hat{A}$ is a $3 \times 3$ (or $2 \times 2$, in two dimensions) symmetric matrix, and vector $\vec{g}$ is a first-order differential expression.

In the isotropic case, tensor $\hat{A}$ is the unit matrix. In the common case, tensor $\hat{A}$ depends on the solution. Among the reasons why tensor $\hat{A}$ is a full matrix are the anisotropic properties of semiconductors (such as SiC) and the influence of mechanical stress, which affects anisotropic mobility (see Chapter 31 on page 885).

Table 145 Anisotropic models for the tensor coefficient $\hat{\mu}$ that Sentaurus Device supports

| Tensor coefficient | Equation or model |
| --- | --- |
| Mobility, $\hat{\mu}$ | Continuity equation for electrons and holes |
| Electrical permittivity, $\hat{\epsilon}$ | Poisson equation |
| Thermal conductivity, $\hat{\kappa}$ | Thermodynamics equation |
| Quantum potential parameter, $\hat{\alpha}$ | Density gradient model |

Sentaurus Device provides different anisotropic approximations for discretization for the Poisson, continuity, and thermodynamic equations, and for the density gradient model (see Anisotropic Approximations on page 834).

**NOTE** Anisotropic properties might have not only the tensor coefficient $\hat{\mu}$, but also some generation–recombination models (see Anisotropic Avalanche Generation on page 848).

Anisotropic Properties of Semiconductor Devices

---

# Anisotropic Approximations

Due to the complexity of anisotropic simulations, Sentaurus Device offers different approximations:

*   The `TensorGridAniso` approximation (default) is the most robust, but it has some accuracy issues for nonaxis-aligned meshes or when the anisotropy orientation does not coincide with the mesh orientation.

*   The `AnisoSG` approximation gives the most accurate results and is independent of the mesh orientation. Convergence, however, might be worse than for `TensorGridAniso`, for example.

*   The `StressSG` approximation gives the most accurate results and is independent of the mesh orientation. Convergence, however, might be worse than for `TensorGridAniso`.

*   The accuracy of the `AverageAniso` approximation depends on the Delaunay properties of the virtual mesh obtained after anisotropic transformation. If this mesh is a Delaunay mesh, the results are relatively accurate. Otherwise, the accuracy degrades.

## TensorGridAniso

This is the default approximation and it is correct only for tensor grids or grids close to tensor ones. The anisotropic effects are modeled using a tensor-grid approximation. The eigenvalues and eigenvectors of tensor $A$ are used as multiplication factors for the projections of vector $\vec{g}$ on mesh edges. The following options in the `Math` section activate this approximation:

```
Math {
  TensorGridAniso              # only for stress mobility
  TensorGridAniso(Piezo)       # stress problems, same as above
  TensorGridAniso(Aniso)       # anisotropic models, see this chapter
  TensorGridAniso(Aniso Piezo) # anisotropic models and stress mobility
}
```

## AnisoSG

The anisotropic Scharfetter–Gummel (`AnisoSG`) approximation is available for the Poisson, continuity, and thermodynamics equations. If the anisotropic direction is inconsistent with the mesh, the `AverageAniso` and `TensorGridAniso` approximations might not be accurate enough (*mesh orientation effect*). The `AnisoSG` approximation is not dependent on the mesh orientation.

Traditionally, the Scharfetter–Gummel approximation is used for the continuity equation (see Chapter 38 on page 1133), where the argument of the Bernoulli function $x^* = (\vec{E^*}, \vec{l})$ is a projection of the effective field $\vec{E^*}$ on edge $\vec{l}$. If, for the isotropic case, $x^*$ depends on values at edge nodes only, for an anisotropic problem, it is necessary to compute vector $\vec{E^*}$

**28: Anisotropic Properties**

Anisotropic Properties of Semiconductor Devices

elementwise. This concept allows for the generalization of the Scharfetter–Gummel approximation to the anisotropic case.

To activate the `AnisoSG` approximation, specify the keyword `AnisoSG` in the global `Math` section:

```
Math { AnisoSG }
```

The `AnisoSG` branch, if it converges, guarantees that concentrations remain positive. However, sometimes, there might be convergence problems due to the unstable computation of the argument of the Bernoulli function $x^*$ and corresponding derivatives, when the carrier concentration is very small. To mitigate this problem, you can use the following parameters:

*   `AnisoSG_MinDen` is a stabilization parameter for the computation of $x^*$. Its default value is 10 cm<sup>-3</sup>.

*   `AnisoSG_DerivativeMinDen` specifies the lower limit of carrier densities for the `AnisoSG` approximation. Corresponding derivatives are switched off if the node carrier density is below this value. Its default value is zero.

You can modify these values in the `Math` section:

```
Math {
  AnisoSG
  AnisoSG_MinDen = 1e6             # [cm-3]
  AnisoSG_DerivativeMinDen = 1e2   # [cm-3]
}
```

## StressSG

This approximation is implemented for stress problems and it affects anisotropic mobility (see Chapter 31 on page 885). To activate this approximation, specify the `StressSG` keyword in the global `Math` section:

```
Math { StressSG }
```

## AverageAniso

This approximation uses a local (vertex-wise) linear transformation, which transforms an anisotropic problem to an isotropic one. After this, Sentaurus Device uses the `AverageBoxMethod` algorithm to compute control volumes and coefficients (see Chapter 38 on page 1133). The keyword `AverageAniso` in the `Math` section activates this approximation. Due to the requirements of `AverageBoxMethod`, the `AverageAniso` approximation requires that either the input mesh consists of triangles only (tetrahedra in three dimensions) or the mesh is tensorial, with the main axes of this tensor mesh and the main axes of the anisotropy aligned to the simulation coordinate system.

28: Anisotropic Properties

Crystal and Simulation Coordinate Systems

# Crystal and Simulation Coordinate Systems

Sentaurus Device uses the simulation coordinate system (mesh geometry) and the crystal coordinate system. Anisotropic material parameters are defined in the crystal coordinate system.

The x-axis and y-axis of the simulation coordinate system are defined in the `LatticeParameters` section in the parameter file:

```
LatticeParameters {
  X = (1, 0,  0)
  Y = (0, 0, -1)
}
```

The z-axis is computed as the outer vector product of the x-axis and y-axis. The simulation coordinate system is defined relative to the crystal coordinate system. If the keyword `CrystalAxis` is present, the crystal coordinate system is defined relative to the simulation coordinate system (see Using Stress and Strain on page 887).

In fact, the `X` and `Y` vectors indicate the transformation that must be applied between the crystal and simulation coordinate systems to correctly compute physical quantities that are related to the given crystal orientation, such as stress, anisotropy, and carrier quantization.

In the example, the x-axis of the simulation coordinate system coincides with the x-axis of the crystal coordinate system. The y-axis of the simulation coordinate system runs along the negative z-axis of the crystal coordinate system. This is a common definition for 2D simulations of `Piezoelectric_Polarization` (see Chapter 31 on page 885).

Instead of the `LatticeParameters` section, the keywords `Piezo` and `PiezoParameters` are recognized as well. By default, Sentaurus Device uses X=(1,0,0), Y=(0,1,0), and Z=(0,0,1).

Sentaurus Device reads the `LatticeParameters` section (X and Y vectors) from a parameter file or directly from a TDR file. If both are found, parameters from the parameter file have a higher priority. If no `LatticeParameters` section is found, then the default values are used.

**IMPORTANT** In the 2D case, there is a difference between how Sentaurus Device interprets the `X` and `Y` vectors read from a parameter file or directly from a TDR file. All the general parameter files stored in the folder `$STROOT/tcad/$STRELEASE/lib/sdevice/MaterialDB/` have no definition of the `X` and `Y` vectors.

Sentaurus Process always uses the 3D crystal coordinate system and creates the same `LatticeParameters` section for 2D and 3D cases. If you define the `X` and `Y` vectors in the parameter file for a 2D

**28: Anisotropic Properties**
Cylindrical Symmetry

problem, then Sentaurus Device uses a special agreement regarding coordinate systems for 2D problems (see Anisotropic Direction in 2D Cases on page 838).

# Cylindrical Symmetry

Sentaurus Device supports only anisotropy with cylindrical symmetry. This means matrix $A$ can be written as:

$$ A = Q \begin{bmatrix} e & & \\ & e & \\ & & e_a \end{bmatrix} Q^T \quad \text{in three dimensions} $$
$$ \text{(902)} $$
$$ A_{2:2} = Q_{2:2} \begin{bmatrix} e & \\ & e_a \end{bmatrix} Q_{2:2}^T \quad \text{in two dimensions} $$

where:

*   $e, e_a$ are eigenvalues of $A$.

*   $Q$ is the $3 \times 3$ orthogonal matrix from eigenvectors of $A: Q = \begin{bmatrix} \vec{A}_x & \vec{A}_y & \vec{A}_z \end{bmatrix}$.

*   The quantity $A_{2:2}$ denotes the leading $2 \times 2$ submatrix of $A$.

# Anisotropic Direction in 3D Cases

The vector $\vec{A}_z$ defines the anisotropic direction in the simulation coordinate system. This direction can be defined in the `Aniso` subsection of the command file in the crystal coordinate system (default) or the simulation coordinate system. The default value is the z-axis (the y-axis in the 2D case). For example:

```
Physics {
  Aniso( direction = (1, 1, 0) )
                             # anisotropic direction in crystal coordinate system
  Aniso( direction(CrystalSystem) = (1, 1, 0) )            # same as above

  # anisotropic direction in simulation coordinate system
  Aniso(Mobility direction(SimulationSystem) = (0, 1, -1) )
}
```

Cylindrical Symmetry

A symbolic definition such as `direction=zAxis` (`xAxis` or `yAxis`) is acceptable. This vector defines the anisotropic direction for all anisotropic models except for the density gradient model (see Anisotropic Directions for Density Gradient Model on page 852).

---

# Anisotropic Direction in 2D Cases

The main rule for anisotropic direction in 2D cases is the following:

**The direction of anisotropy in 2D cases must lie in the plane of simulation.**

Let `aniso_dir` be the 3D vector of anisotropy in the simulation coordinate system.

First, Sentaurus Device computes `aniso_dir=(ax,ay,az)`. If the `az` component does not equal zero, then Sentaurus Device prints an error message.

Second, Sentaurus Device uses one of the following ways to find the anisotropic direction:

*   The `Aniso` subsection with the direction definition (keyword `direction`) in the command file (higher priority) (see Aniso Subsection With Direction Definition)

*   The `X` and `Y` vectors from a parameter file or from a TDR file (see Aniso Subsection Without Direction Definition on page 839)

## Aniso Subsection With Direction Definition

In this case, the `X` and `Y` vectors and `direction` vector can be 3D vectors (but the z-component of the `aniso_dir` vector must be zero).

The following examples show correct and incorrect definitions.

### Example 1: SimulationSystem Option

In this case, there is no dependence on the `LatticeParameters` section.

```
Aniso( direction(SimulationSystem)=(ax ay 0) )           # correct
Aniso( direction(SimulationSystem)=(ax ay az) )          # incorrect
```

### Example 2: CrystalSystem Option (Default)

There is a dependence on the `LatticeParameters` section.

```
Aniso( direction(CrystalSystem)=(cx cy cz) )
```

28: Anisotropic Properties
Cylindrical Symmetry

In this case, Sentaurus Device uses the vector=`(cx cy cz)` and the `X` and `Y` vectors to compute `aniso_dir=(ax,ay,az)`. If `az=0`, then the definition is correct. Otherwise, the definition is incorrect.

## Example 3: LatticeParameters Section

Let the `LatticeParameters` section be the following:

```
LatticeParameters {
  X = ( 0.0000e+00, 0.0, -1.0)
  Y = (-8.6603e-01, 0.5,  0.0)
}
```

In this case, `Aniso(direction(CrystalSystem)=(0 0 1))` is correct: `aniso_dir=(-1 0 0)`.

However, `Aniso(direction(CrystalSystem)=(0 1 0))` is incorrect: `aniso_dir=(0, 0.5, 0.8)`.

## Aniso Subsection Without Direction Definition

In this case, Sentaurus Device uses only the `X` and `Y` vectors to compute `aniso_dir=(ax,ay,az)`. If `az=0`, then the definition is correct. Otherwise, the definition is incorrect.

Sentaurus Device interprets the `X` and `Y` vectors differently in the following cases:

*   Vectors are read from a parameter file (see X and Y Vectors Read From Parameter File).

*   Vectors are read from a TDR file (see X and Y Vectors Read From TDR File (Sentaurus Process) on page 840).

## X and Y Vectors Read From Parameter File

All the general parameter files have no definition of `X` and `Y` vectors. If you define the `X` and `Y` vectors in the parameter file for a 2D problem, then Sentaurus Device uses a special agreement regarding coordinate systems in two dimensions:

*   In the crystal coordinate system and simulation coordinate system, there are only two axes:

    ```
    {Xc, Yc}
    {Xs, Ys}
    ```

*   The y-axis of the crystal coordinate system is the direction of anisotropy.

Cylindrical Symmetry

*   The `X` and `Y` vectors must be two-dimensional vectors, that is, the third coordinate must equal zero. It means that only the next definition is correct in 2D cases:

```
LatticeParameters {
  X = (x1, x2, 0)
  Y = (y1, y2, 0)
}
```

## X and Y Vectors Read From TDR File (Sentaurus Process)

Sentaurus Process always uses the 3D crystal coordinate system and creates the same `LatticeParameters` section for 2D and 3D cases. The z-axis of the crystal coordinate system is the direction of anisotropy.

```
LatticeParameters {
  X = (x1, x2, x3)
  Y = (y1, y2, y3)
  # Z = (z1, z2, z3)      it is a vector product of X and Y, that is, Z=[X,Y]
}
```

In this case, `aniso_dir=(x3, y3, z3)`. If `z3=0`, then the definition is correct. Otherwise, the definition is incorrect.

For example, using the `LatticeParameters` section from Example 3: LatticeParameters Section on page 839:

```
aniso_dir=Z=[X,Y]=(0.5, 8.6603e-01, 0.0)
```

If `z3!=0`, then the definition is correct.

However, for example:

```
LatticeParameters {
  X = ( 0.0348782, 0.0604109, -0.99756)
  Y = (-0.86603,   0.5,        0.0000e+00)
  #Z=[X,Y]= ( 0.498782, 0.863916, 0.0697565)
}
```

In this case, `aniso_dir=(-0.99756, 0, 0.06976)`. If `z3!=0`, then the definition is incorrect.

# Aniso(direction) Versus LatticeParameters

If you know the direction of anisotropy in the simulation coordinate system, then the keyword `direction` with the `SimulationSystem` option is the simplest way to define the anisotropic direction. The next examples are equivalent.

28: Anisotropic Properties

Cylindrical Symmetry

# Example 1

```
Parameter file:
LatticeParameters {
  X = ( 0.8, 0.6, 0)
  Y = (-0.6, 0.8, 0)
}

Input command file:
Physics {
  Aniso( direction=(0.5, 0.5) )             # in crystal coordinate system
}
```

# Example 2

```
Input command file:
Physics {
  # No dependence on LatticeParameters
  Aniso( direction(SimulationSystem)=(0.7, 0.1) )
}
```

| Vector | X-component | Y-component |
| --- | --- | --- |
| Ysim | -0.6 | 0.8 |
| Xsim | 0.8 | 0.6 |
| Aniso Direction Vector | 0.5 | 0.5 |
| Simulation System Vector | 0.7 | 0.1 |

See Anisotropic Directions for Density Gradient Model on page 852.

---

# Orthogonal Matrix From Eigenvectors Q

Let $A = (x, y, z)$ be a vector row and let $\vec{A} = (x, y, z)'$ be a vector column.

If the anisotropic direction has the default value (z-axis in three dimensions or y-axis in two dimensions), then the matrix $Q$ is:

$$ Q = R^T, R = \begin{bmatrix} \frac{\vec{X}}{\|\vec{X}\|} & \frac{\vec{Y}}{\|\vec{Y}\|} & \frac{\vec{Z}}{\|\vec{Z}\|} \end{bmatrix} $$ (903)

Anisotropic Mobility

where the vector rows X, Y, and Z are defined in the `LatticeParameters` section.

If the anisotropic direction is a vector $\vec{A}_d = (x, y, z)'$ in the crystal coordinate system, then the matrix $Q$ is:

$$Q = \left[ \vec{A}_x \vec{A}_y \vec{A}_z \right], \vec{A}_z = R^T \cdot \vec{A}_d / \| \vec{A}_d \| \hfill (904)$$

If the anisotropic direction is a vector $\vec{A}_d = (x, y, z)'$ in the simulation coordinate system, then the matrix $Q$ is:

$$Q = \left[ \vec{A}_x \vec{A}_y \vec{A}_z \right], \vec{A}_z = \vec{A}_d / \| \vec{A}_d \| \hfill (905)$$

Sentaurus Device computes the vectors $\vec{A}_x, \vec{A}_y$ to ensure that the matrix $Q$ is orthogonal.

# Anisotropic Mobility

In some semiconductors, such as silicon carbide, electrons and holes can exhibit different mobilities along different crystallographic axes.

## Anisotropy Factor

In a 3D simulation, Sentaurus Device assumes that electrons or holes exhibit a mobility $\mu$ along the x-axis and y-axis, and an anisotropic mobility $\mu_{\text{aniso}}$ along the z-axis. In a 2D simulation, the regular mobility $\mu$ is observed along the x-axis, and $\mu_{\text{aniso}}$ is observed along the y-axis. The anisotropy factor $r$ is defined as the ratio:

$$r = \frac{\mu}{\mu_{\text{aniso}}} \hfill (906)$$

## Current Densities

In the isotropic case, current densities can be expressed by:

$$\vec{J}_n = \mu_n \vec{g}_n \hfill (907)$$

$$\vec{J}_p = \mu_p \vec{g}_p \hfill (908)$$

where $\vec{g}_n$ and $\vec{g}_p$ are the *currents without mobilities*.

28: Anisotropic Properties
Anisotropic Mobility

In the drift-diffusion model, you have:

$$ \vec{g}_n = -nq\nabla\Phi_n $$ (909)

$$ \vec{g}_p = -pq\nabla\Phi_p $$ (910)

as can be seen from Eq. 60 and Eq. 61, p. 191. For the thermodynamic model, Eq. 62 and Eq. 63, p. 191 imply that:

$$ \vec{g}_n = -nq(\nabla\Phi_n + P_n\nabla T) $$ (911)

$$ \vec{g}_p = -pq(\nabla\Phi_p + P_p\nabla T) $$ (912)

In the hydrodynamic case, you have:

$$ \vec{g}_n = n\nabla E_C + kT_n\nabla n + f_n^{td}kn\nabla T_n - 1.5nkT_n\nabla \ln m_n $$ (913)

$$ \vec{g}_p = p\nabla E_V - kT_p\nabla p - f_p^{td}kp\nabla T_p - 1.5pkT_p\nabla \ln m_p $$ (914)

according to Eq. 64 and Eq. 65, p. 192.

For anisotropic mobilities, Eq. 907 and Eq. 908 must be rewritten as:

$$ \vec{J}_n = \mu_n A_{r_n} \vec{g}_n $$ (915)

$$ \vec{J}_p = \mu_p A_{r_p} \vec{g}_p $$ (916)

where $r_n$ and $r_p$ are the anisotropy factors for electrons and holes, respectively. If the crystal coordinate system coincides with the simulation coordinate system of Sentaurus Device, depending on the dimension of the problem, the matrices $A_r$ are given by:

$$ A_r = \begin{bmatrix} 1 & & \\ & 1 & \\ & & 1/r \end{bmatrix} \text{ or } A_r = \begin{bmatrix} 1 & \\ & 1/r \end{bmatrix} $$ (917)

In general, however, $A_r$ must be written as:

$$ A_r = Q \begin{bmatrix} 1 & & \\ & 1 & \\ & & 1/r \end{bmatrix} Q^T \text{ or } A_r = Q_{2:2} \begin{bmatrix} 1 & \\ & 1/r \end{bmatrix} Q_{2:2}^T $$ (918)

Anisotropic Mobility

where $Q$ is defined in Eq. 902, p. 837 – Eq. 904, p. 842.

# Driving Forces

In the isotropic case, the electric field parallel to the electron or hole current is given by (see Eq. 355, p. 395):

$$ F_c = \frac{\vec{F} \cdot \vec{J}_c}{J_c} = \frac{\vec{F} \cdot \vec{g}_c}{g_c} \tag{919} $$

For anisotropic mobilities:

$$ F_c = \frac{\vec{F} \cdot A \vec{g}_c}{|A \vec{g}_c|} \tag{920} $$

Similarly, the electric field perpendicular to the current, as given in Eq. 334, p. 381, must be rewritten as:

$$ F_{c, \perp} = \sqrt{F^2 - \frac{(\vec{F} \cdot A \vec{g}_c)^2}{|A \vec{g}_c|^2}} \tag{921} $$

Eq. 357, p. 396 shows how the gradient of the Fermi potential $\Phi_c$ can be used as the driving force in high-field saturation models. For this case, Sentaurus Device has two formulas:

$$ F_c = |A \nabla \Phi_c| \text{ (default formula)} \tag{922} $$

$$ F_c = \frac{(A \nabla \Phi_c, \nabla \Phi_c)}{|A \nabla \Phi_c|} \text{ (second formula)} \tag{923} $$

The global `Math` parameter `AnisoGradQF_formula=0 | 1` selects the corresponding formula.

In the isotropic hydrodynamic Canali model, the driving force $\vec{F}_c$ satisfies:

$$ \vec{F}_c \cdot \mu \vec{F}_c = \frac{w_c - w_0}{\tau_{ec} q} \tag{924) $$

as can be seen from Eq. 361, p. 398. To derive the appropriate expression in the anisotropic case, it is assumed that $F_c$ operates parallel to the current, that is:

$$ \vec{F}_c = F_c \hat{e}_c \tag{925} $$

28: Anisotropic Properties

Anisotropic Mobility

where:

$$ \hat{e}_c = \frac{\vec{A_{gc}}}{|\vec{A_{gc}}|} \tag{926} $$

is the direction of the electron or hole current.

Instead of Eq. 924, you now have:

$$ \mu F_c^2 (A \hat{e}_c) \cdot \hat{e}_c = \frac{w_c - w_0}{\tau_{ec} q} \tag{927} $$

or:

$$ F_c = \sqrt{\frac{w_c - w_0}{\tau_{ec} q \mu A \hat{e}_c \cdot \hat{e}_c}} \tag{928} $$

# Total Anisotropic Mobility

This is the simplest mode in Sentaurus Device. Only a total anisotropy factor $r_e$ or $r_h$ is specified in the command file:

```
Physics {
  Aniso(
    eMobilityFactor (Total) = rₑ
    hMobilityFactor (Total) = rₕ
  )
}
```

Sentaurus Device computes the mobility $\mu$ for electrons or holes along the main crystallographic axis as usual. The mobility $\mu_{\text{aniso}}$ is then given by:

$$ \mu_{\text{aniso}} = \frac{\mu}{r} \tag{929} $$

**NOTE** In this mode, Sentaurus Device does not update the driving forces as discussed in Driving Forces on page 844.

28: Anisotropic Properties

Anisotropic Mobility

# Self-Consistent Anisotropic Mobility

This is the most accurate, but also the most expensive, mode in Sentaurus Device. The electron and hole mobility models specified in the `Physics` section are evaluated separately for the major and minor crystallographic axes, but with different parameters for each axis.

This option is activated in the `Physics` section for electron or hole mobilities as follows:

```
Physics {
  Aniso(
    eMobility
    hMobility
  )
}
```

To simplify matters, you can specify the following option to activate self-consistent, anisotropic, mobility calculations for both electrons and holes:

```
Physics {
  Aniso( Mobility )
}
```

Table 146 Isotropic mobility models and their anisotropic versions

| Isotropic mobility model | Anisotropic mobility model |
| --- | --- |
| ConstantMobility | ConstantMobility_aniso |
| DopingDependence | DopingDependence_aniso |
| EnormalDependence | EnormalDependence_aniso |
| HighFieldDependence | HighFieldDependence_aniso |
| UniBoDopingDependence | UniBoDopingDependence_aniso |
| UniBoEnormalDependence | UniBoEnormalDependence_aniso |
| UniBoHighFieldDependence | UniBoHighFieldDependence_aniso |
| HydroHighFieldDependence | HydroHighFieldDependence_aniso |

The physical model interface (PMI) also supports anisotropic mobility calculations. The constructors of the classes `PMI_DopingDepMobility`, `PMI_EnormalMobility`, and `PMI_HighFieldMobility` contain an additional flag to distinguish between the isotropic and anisotropic case (see Chapter 39 on page 1165).

28: Anisotropic Properties

Anisotropic Mobility

For example, you can specify these parameters for the constant mobility model in the parameter file of Sentaurus Device:

```
ConstantMobility {
  mumax = 1.4170e+03, 4.7050e+02
  Exponent = 2.5, 2.2
}
```

The following parameters would then compute a reduced constant mobility along the anisotropic axis:

```
ConstantMobility_aniso {
  mumax = 1.0e+03, 4.0e+02
  Exponent = 2.5, 2.2
}
```

In each vertex, Sentaurus Device introduces the anisotropy factors $r_e$ and $r_h$ as two additional unknowns. For a given value of $r$, the driving forces $F_c$ and $F_{c, \perp}$ are computed as discussed in Driving Forces on page 844, and the mobilities along the isotropic and anisotropic axes are obtained. The equation for the unknown factor $r$ is then given by:

$$ r = \frac{\mu(r)}{\mu_{\text{aniso}}(r)} \text{ (930)} $$

This nonlinear equation is solved in each vertex for both electron and hole mobilities.

# Anisotropic Mobility Visualization

You can specify various plot names in the `Plot` section to visualize the anisotropic mobility calculations.

Table 147 Plot names for anisotropic mobility

| Plot name | Description |
| --- | --- |
| eMobility | Electron mobility along main axis |
| hMobility | Hole mobility along main axis |
| eMobilityAniso | Electron mobility along anisotropic axis |
| hMobilityAniso | Hole mobility along anisotropic axis |
| eMobilityAnisoFactor | Anisotropic factor for electrons |
| hMobilityAnisoFactor | Anisotropic factor for holes |

28: Anisotropic Properties

Anisotropic Metal Resistivity

# Anisotropic Metal Resistivity

In thin-metal layered structures, the metal resistivity can differ along different coordinate axes (see Transport in Metals on page 249).

**NOTE** The anisotropic metal resistivity option is not supported for conductive insulators (see Conductive Insulators on page 254).

## Total Anisotropic Metal Resistivity

This option is similar to Total Anisotropic Mobility on page 845. Sentaurus Device assumes that the metal resistivity $\rho$ is the same in all directions perpendicular to the anisotropic direction (see Aniso(direction) Versus LatticeParameters on page 840%20Versus%20LatticeParameters%20on%20page%20840)) and is $\rho_{\text{aniso}}$ along the direction. The anisotropy factor $r$ is defined as the ratio:

$$ r = \frac{\rho}{\rho_{\text{aniso}}} \hfill (931) $$

To activate this option, specify the metal resistivity anisotropy factor $r$ in the command file regionwise or globally, as follows:

```
Physics {
  Aniso( MetalResistivityFactor(Total) = r )
}
```

# Anisotropic Avalanche Generation

Sentaurus Device computes the avalanche generation according to Eq. 443, p. 441. In the isotropic case, the terms $nv_n$ and $pv_p$ can also be written, respectively, as:

$$ nv_n = \mu_n \left| \vec{g}_n \right| \hfill (932) $$

$$ pv_p = \mu_p \left| \vec{g}_p \right| \hfill (933) $$

If anisotropic mobilities are switched on, Eq. 932 and Eq. 933 are replaced by:

$$ nv_n = \mu_n \left| A_{r_n} \vec{g}_n \right| \hfill (934) $$

$$ pv_p = \mu_p \left| A_{r_p} \vec{g}_p \right| \hfill (935) $$

Anisotropic Avalanche Generation

**NOTE** Eq. 934 and Eq. 935 apply only to total direction–dependent and self-consistent mobility calculations. If you select the total anisotropic option, then Eq. 932 and Eq. 933 are used (see Total Anisotropic Mobility on page 845).

Anisotropic avalanche calculations can be activated in the `Physics` section, independently for electrons and holes:

```
Physics {
    Aniso(
        eAvalanche
        hAvalanche
    )
}
```

The keyword `Avalanche` activates calculations of anisotropic avalanche for both electrons and holes:

```
Physics { Aniso( Avalanche ) }
```

In the anisotropic mode, different avalanche parameters can be specified along the isotropic and anisotropic axes.

Table 148 Isotropic avalanche models and their anisotropic versions

| Isotropic avalanche model | Anisotropic avalanche model |
| --- | --- |
| vanOverstraetendeMan | vanOverstraetendeMan_aniso |
| Okuto | Okuto_aniso |

Sentaurus Device uses interpolation to compute avalanche parameters for an arbitrary direction of the current. Let $\hat{e}_c$ be the direction of the electron or hole current as defined in Eq. 926, p. 845. In the crystal reference system, the current is given by:

$$ \hat{e}'_c = Q^T \hat{e}_c = \begin{bmatrix} e'_x \\ e'_y \\ e'_z \end{bmatrix} \text{ (936)} $$

Sentaurus Device interpolates an avalanche parameter $p$ depending on the direction of the current $\hat{e}_c$, according to:

$$ p(\hat{e}'_c) = (e'^2_x + e'^2_y) \cdot p_{\text{isotropic}} + e'^2_z \cdot p_{\text{anisotropic}} \quad \text{for 3D simulations} $$
$$ \text{ (937)} $$
$$ p(\hat{e}'_c) = e'^2_x \cdot p_{\text{isotropic}} + e'^2_y \cdot p_{\text{anisotropic}} \quad \text{for 2D simulations} $$

**28: Anisotropic Properties**

Anisotropic Electrical Permittivity

The PMI also supports the calculation of anisotropic avalanche generation. The current without mobility $A_{g_c}$ is passed as an input parameter, and it can be used by the PMI code to determine the model parameters depending on the direction of the current (see Avalanche Generation on page 1217).

> **NOTE** The Hatakeyama avalanche model is an anisotropic avalanche model (see Hatakeyama Avalanche Model on page 451). However, it must not be used with an `Aniso(Avalanche)` specification.

---

# Anisotropic Electrical Permittivity

The electrical permittivity $\varepsilon$ in Eq. 37, p. 179 can have different values along different crystallographic axes. If the crystallographic axes coincide with the coordinate system of Sentaurus Device, the scalar $\varepsilon$ is replaced by the matrix:

$$ E = \begin{bmatrix} \varepsilon & & \\ & \varepsilon & \\ & & \varepsilon_{\text{aniso}} \end{bmatrix} \text{ or } E = \begin{bmatrix} \varepsilon & \\ & \varepsilon_{\text{aniso}} \end{bmatrix} \eqno(938) $$

depending on the dimension of the problem. For general crystallographic axes, the matrix $E$ is given by:

$$ E = Q \begin{bmatrix} \varepsilon & & \\ & \varepsilon & \\ & & \varepsilon_{\text{aniso}} \end{bmatrix} Q^T \text{ or } E = Q_{2:2} \begin{bmatrix} \varepsilon & \\ & \varepsilon_{\text{aniso}} \end{bmatrix} Q_{2:2}^T \eqno(939) $$

where $Q$ is defined in Eq. 902, p. 837 – Eq. 904, p. 842.

Anisotropic electrical permittivity is switched on using the keyword `Poisson` in the `Physics` section of the command file (regionwise or materialwise specification is supported):

```
Physics (Material = "SiC"){
  Aniso (Poisson)
}
```

The model parameters for $\varepsilon$ and $\varepsilon_{\text{aniso}}$ can be specified in the parameter file. Table 149 lists the corresponding models.

Table 149 Anisotropic electrical permittivity models

| Isotropic model | Anisotropic model |
| --- | --- |
| Epsilon | Epsilon_aniso |

28: Anisotropic Properties
Anisotropic Thermal Conductivity

Different parameters can be specified for each region or each material. The following section in the command file of Sentaurus Device plots electrical permittivities:

```
Plot {
  DielectricConstant
  "DielectricConstantAniso"
}
```

# Anisotropic Thermal Conductivity

The thermal conductivity $\kappa$ in Eq. 71, p. 200 can have different values along different crystallographic axes. If the crystallographic axes coincide with the coordinate system of Sentaurus Device, the scalar $\kappa$ is replaced by the matrix:

$$ K = \begin{bmatrix} \kappa & & \\ & \kappa & \\ & & \kappa_{aniso} \end{bmatrix} \text{ or } K = \begin{bmatrix} \kappa & \\ & \kappa_{aniso} \end{bmatrix} \hfill (940) $$

depending on the dimension of the problem.

For general crystallographic axes, the matrix $K$ is given by:

$$ K = Q \begin{bmatrix} \kappa & & \\ & \kappa & \\ & & \kappa_{aniso} \end{bmatrix} Q^T \text{ or } K = Q_{2:2} \begin{bmatrix} \kappa & \\ & \kappa_{aniso} \end{bmatrix} Q_{2:2}^T \hfill (941) $$

where $Q$ is defined in Eq. 902, p. 837 – Eq. 904, p. 842.

Anisotropic thermal conductivity is switched on using the keyword `Temperature` in the `Physics` section of the command file (regionwise or materialwise specification is supported):

```
Physics (Material = "SiC") {
  Aniso (Temperature)
}
```

The model parameters for $\kappa$ and $\kappa_{aniso}$ can be specified in the parameter file. Table 150 lists the corresponding models.

Table 150 Anisotropic thermal conductivity models

| Isotropic model | Anisotropic model |
| --- | --- |
| Kappa | Kappa_aniso |

Anisotropic Density Gradient Model

Different parameters can be specified for each region or each material. You can also use the PMI to compute anisotropic thermal conductivities. The constructor of the class `PMI_ThermalConductivity` has an additional parameter to distinguish between the isotropic and anisotropic directions (see Thermal Conductivity on page 1311).

The following section in the command file of Sentaurus Device plots thermal conductivities:

```
Plot {
    "ThermalConductivity"
    "ThermalConductivityAniso"
}
```

# Anisotropic Density Gradient Model

The density gradient model provides support for anisotropic quantization. See Density Gradient Model on page 316.

## Anisotropic Directions for Density Gradient Model

By default, the anisotropic direction of the density gradient model is the same as in all other models. However, the density gradient model can have other anisotropic directions. Moreover, you can have three different axes of anisotropy.

### Example 1

Global anisotropic models and density gradient model have different direction:

```
Physics {
  Aniso(
    # global anisotropic direction relative to crystal coordinate system
    direction(CrystalSystem)=(0.6, 0.8) Poisson Temperature

    # aniso direction for DG model relative to simulation coordinate system
    eQuantumPotential{ direction(SimulationSystem)=(1,1,0) }
  )
}
```

### Parameter file:

```
QuantumPotentialParameters {
  alpha[1] = 4 1     # aniso direction = (1, 1, 0) relative to
                     # simulation coordinate system
```

28: Anisotropic Properties

Anisotropic Density Gradient Model

```
   alpha[2] = 1 1         # isotropic value
   alpha[3] = 1 1         # isotropic value, in 3D case alpha[3] = alpha[2]
}
```

## Example 2

Anisotropic density gradient model has three anisotropic axes:

```
Aniso( eQuantumPotential(
  AnisoAxes(SimulationSystem) = {
    ( 0.6, 0.8, 0)
    (-0.8, 0.6, 0)
  }
))
```

## Parameter file:

```
QuantumPotentialParameters {
  alpha[1] = 4 1         # aniso axis = ( 0.6, 0.8, 0)
  alpha[2] = 1 1         # aniso axis = (-0.8, 0.6, 0)
  alpha[3] = 2 1         # aniso axis = ( 0.0, 0.0, 1) this vector is computed
}
```

**28: Anisotropic Properties**

Anisotropic Density Gradient Model

