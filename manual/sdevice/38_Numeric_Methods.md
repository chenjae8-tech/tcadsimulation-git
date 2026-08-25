# CHAPTER 38 Numeric Methods

*This chapter presents some of the numeric methods used in Sentaurus Device.*

## Discretization

The well-known *box discretization* [1][2][3] is applied to discretize the partial differential equations (PDEs). This method integrates PDEs over a test volume such as that shown in Figure 83, which applies the Gaussian theorem and discretizes the resulting terms to a first-order approximation.

Single box for a triangular mesh in two dimensions

Figure 83 Single box for a triangular mesh in two dimensions

In general, box discretization discretizes each PDE of the form:

$$ \nabla \cdot \vec{J} + R = 0 $$ (1249)

into:

$$ \sum_{j \neq i} \kappa_{ij} \cdot j_{ij} + \mu(\Omega_i) \cdot r_i = 0 $$ (1250)

with values listed in Table 182 on page 1134.

In this case, the physical parameters $j_{ij}$ and $r_i$ have the values listed in Table 183 on page 1134, where $B(x) = x / (e^x - 1)$ is the Bernoulli function.

Discretization

Table 182 Box method parameters: coefficients and control volumes

| Dimension | $\kappa_{ij}$ | $\mu(\Omega_i)$ |
| --- | --- | --- |
| 1D | $1/l_{ij}$ | Box length |
| 2D | $d_{ij}/l_{ij}$ | Box area |
| 3D | $D_{ij}/l_{ij}$ | Box volume |

Table 183 Equations

| Equation | $j_{ij}$ | $r_i$ |
| --- | --- | --- |
| Poisson | $\varepsilon(u_i - u_j)$ | $-\rho_i$ |
| Electron continuity | $\mu^n(n_i B(u_i - u_j) - n_j B(u_j - u_i))$ | $R_i - G_i + \frac{d}{dt}n_i$ |
| Hole continuity | $\mu^p(p_j B(u_j - u_i) - p_i B(u_i - u_j))$ | $R_i - G_i + \frac{d}{dt}p_i$ |
| Temperature | $\kappa(T_i - T_j)$ | $H_i - \frac{d}{dt}T_i c_i$ |

One special feature of Sentaurus Device is that the actual assembly of nonlinear equations is performed elementwise, that is:

$$ \sum_{e \in \text{elements}(i)} \left\{ \left( \sum_{j \in \text{vertices}(e)} \kappa_{ij}^e \cdot j_{ij}^e \right) + \mu(\Omega_i^e) \cdot r_i^e \right\} = 0 $$ (1251)

This expression is equivalent to Eq. 1250 but has the advantage that some parameters (such as $\varepsilon$, $\mu_n$, $\mu_p$) can be handled elementwise, which is useful for numeric stability and physical exactness. In the 2D case, the box method coefficients have simple visual values: $\kappa_{ij}^e = d_{ij}^e/l_{ij}$ (see Figure 83 on page 1133). In the 3D case, these values are not trivial.

# Extended Precision

Although the coordinates of vertices of a mesh are stored with "double" precision accuracy, Sentaurus Device can compute box method coefficients and control volumes with "long double" extended-precision accuracy. This is especially important for the accurate calculation of box method parameters in meshes that contain sliver elements. The procedure is as follows:

1. Read "double" precision coordinates of the mesh vertices.

2. Convert these coordinates to "long double" extended precision.

3. Compute box method parameters with "long double" extended precision.

4. Convert coefficients and control volumes back to "double" precision.

The extended-precision calculation of box method parameters can be switched on by specifying `BM_ExtendedPrecision` in the global `Math` section of the command file.

38: Numeric Methods

Box Method Coefficients in the 3D Case

**NOTE** Extended-precision box method calculations are switched off if the global `Math` section contains either `BoxCoefficientsFromFile`, or `BoxMeasureFromFile`, or `NaturalBoxMethod` (see Saving and Restoring Box Method Coefficients on page 1143).

# Box Method Coefficients in the 3D Case

This section describes the coefficients of the box method in the 3D case.

## Basic Definitions

### Delaunay mesh

A mesh is a *Delaunay mesh* if the interior of the circumsphere (circumcircle for two dimensions) of each element contains no mesh vertices.

### Obtuse element

An element is called *obtuse* if the center of the circumsphere (circumcircle) is outside this element.

### Obtuse face

Let $P_f$ be the plane that contains the face $f$ of an element. Each plane splits 3D space into two half spaces, $S_{f1}$ and $S_{f2}$. A face $f$ is called *obtuse* if the center of the circumsphere of the element and the element itself lie in different half spaces, $S_{f1}$ and $S_{f2}$.

> **NOTE** In the 2D case, an obtuse triangle has only one obtuse edge.
> In the 3D case:
>

> * An obtuse prism has only one obtuse face.

> * An obtuse tetrahedron has one or two obtuse faces.

> * An obtuse pyramid has one, two, or three obtuse faces.

### Non-Delaunay element

An obtuse element is called *non-Delaunay* if the interior of the circumsphere (circumcircle) around this element contains another mesh vertex.

### Voronoï element center and Voronoï face center

Let $T$ be a mesh element. The center circumsphere (circle for two dimensions) around the element $T$ is called the *Voronoï element center* $V_T$. Let $f$ be the face of the element $T$. The center circumcircle around the face $f$ is called the *Voronoï face center* $V_f$.

38: Numeric Methods

# Box Method Coefficients in the 3D Case

**Voronoï box and face of the Voronoï box**

Let $v$ be a vertex of the mesh and let $ev^n (1 \le n \le N)$ be the set of edges connected to vertex $v$. Let $P_{ev}^n$ be the mid-perpendicular plane for the edge $ev^n$. The plane $P_{ev}^n$ splits 3D space into two half spaces. Let $S_{ev}^n$ be the half space that contains the vertex $v$. The intersection of all half spaces $S_{ev}^n$ is called the Voronoï box $B_v$ of vertex $v$. Therefore, the Voronoï box $B_v$ is the convex polyhedron and any face of $B_v$ is a convex polygon that lies in the mid-perpendicular plane $P_{ev}^n$. This face called the *face of the Voronoï box* $F_{ev}^n$.

In addition, let $T_v^m (1 \le m \le M)$ be the set of elements per vertex $v$ and let $T_{ev}^k (1 \le k \le K)$ be the set of elements per edge $ev$. For the Delaunay mesh, the next two propositions hold:

1. Vertices of the Voronoï box $B_v$ are Voronoï element centers $(V_{T_v^1}, V_{T_v^2}, \dots, V_{T_v^M})$.

2. Vertices of the face of the Voronoï box $F_{ev}^n$ are Voronoï element centers $(V_{T_{ev}^1}, V_{T_{ev}^2}, \dots, V_{T_{ev}^K})$ (see Figure 84 – Figure 86).

Face of the Voronoï box diagram showing elements 1-5, Voronoï element centers VT1-VT5, and face centers Vf1,2-Vf5,1 around a central point me.

Figure 84 Face of the Voronoï box for Delaunay mesh without obtuse elements: view of mid-perpendicular plane at edge $e$ with Voronoï element centers $V_{T^i}$ and the Voronoï face center $V_{f^{i,i+1}}$ between elements $T^i$ and $T^{i+1}$

**38: Numeric Methods**

Box Method Coefficients in the 3D Case

Diagram showing an obtuse element where the Voronoï box face is a polygon with vertices at Voronoï element centers.

Figure 85 Element 5 is an obtuse element; the face of the Voronoï box is a polygon ($V_{T^1}, V_{T^2}, V_{T^3}, V_{T^4}, V_{T^5}, V_{T^1}$), and all vertices are Voronoï element centers

Diagram showing a non-Delaunay element where one vertex R of the Voronoï box face is not a Voronoï element center.

Figure 86 Element 5 is a non-Delaunay element; the face of the Voronoï box is a polygon ($V_{T^1}, V_{T^2}, V_{T^3}, R, V_{T^1}$), and vertex $R$ is not a Voronoï element center

# Element Intersection Box Method Algorithm

Sentaurus Device uses the element intersection box method algorithm. Let $S_{e\nu}^{T^i}$ be the area of intersection $F_{e\nu} \cap T^i$. For example:

1. Not obtuse elements (see Figure 84) or elements $T^1, T^2, T^3$ in (see Figure 85 and Figure 86):

$$ S_{e\nu}^{T^i} = \text{Area}(m_e, V_{f^{i-1,i}}, V_{T^i}, V_{f^{i,i+1}}, m_e) $$

Box Method Coefficients in the 3D Case

2. Obtuse elements (see Figure 85):

$$ S_{e\nu}^{T^4} = \text{Area}(m_e, V_{f^{3,4}}, V_{T^4}, V_{T^5}, p, m_e) \text{ and } S_{e\nu}^{T^5} = \text{Area}(m_e, p, V_{f^{5,1}}, m_e) $$

3. Non-Delaunay elements (see Figure 86):

$$ S_{e\nu}^{T^4} = \text{Area}(m_e, V_{f^{3,4}}, R, p, m_e) \text{ and } S_{e\nu}^{T^5} = \text{Area}(m_e, p, V_{f^{5,1}}, m_e) $$

Let edge $e$ have vertices $\nu1, \nu2$. If all elements around this edge are Delaunay elements, then $S_{e\nu1}^{T^i} = S_{e\nu2}^{T^i}$. For non-Delaunay elements, $S_{e\nu1}^{T^i} \neq S_{e\nu2}^{T^i}$.

The parameters needed for discretization, $\mu(\Omega_i^e)$ and $\kappa_{ij}^e$ from Eq. 1251, p. 1134, are 2D arrays $\mu(T^i, \nu)$ and $\kappa(T^i, e)$ ($\nu \in T^i$ is a vertex of the element, and $e = e(\nu1, \nu2)$ is the edge of the element).

The options for computing the box method coefficients are:

*   AverageBoxMethod

$$ \kappa(T^i, e) = 0.5 \cdot (S_{e\nu1}^{T^i} + S_{e\nu2}^{T^i}) / (\text{length}(e)) \tag{1252} $$

For non-Delaunay elements, you have the average coefficient value.

*   NaturalBoxMethod

$$ \kappa(T^i, e) = (S_{e\nu1}^{T^i}) / (\text{length}(e)) \tag{1253} $$

This algorithm has no averaging.

Both algorithms have the same coefficients for the Delaunay mesh. Only one box method algorithm can be activated. After computing the box method coefficients, Sentaurus Device uses these values for computation control volumes $\mu(T^i, \nu)$ using standard analytic formulas.

# Truncated Obtuse Elements

If a mesh has no obtuse elements, you have element-volume conservation for Measure values (see Figure 87 on page 1139):

$$ \text{Vol}(T^i) = \sum_{\nu \in T^i} \mu(T^i, \nu) \tag{1254} $$

**38: Numeric Methods**

Box Method Coefficients in the 3D Case

Diagram showing element-volume conservation for a mesh without obtuse elements, with vertices v1, v2, v3, v4 and numbered internal points.

Figure 87 Element-volume conservation for mesh without obtuse elements

For a Delaunay mesh, you have total-volume conservation (see Figure 88):

$$ V \equiv \sum_{i} Vol(T^{i}) = \sum_{i} \sum_{v \in T^{i}} \mu(T^{i}, v) \equiv V_{\text{BM}} $$ (1255)

Diagram showing total-volume conservation for a Delaunay mesh, with vertices v1, v2, v3, v4 and numbered internal points.

Figure 88 Total-volume conservation for Delaunay mesh

For a non-Delaunay mesh, you have no even total-volume conservation (see Figure 89 on page 1140):

$$ \delta V = abs(V - V_{\text{BM}}) > 0 $$ (1256)

Box Method Coefficients in the 3D Case

Diagram showing violation of total-volume conservation for non-Delaunay mesh

Figure 89 Violation of total-volume conservation for non-Delaunay mesh

There are problems for which element-volume conservation is very important (such as optical electronic or diffusion in Sentaurus Process). For these operations, Sentaurus Device has the special option `MixAverageBoxMethod`.

In this case, Sentaurus Device uses `AverageBoxMethod` to compute the coefficients and the algorithm *truncation obtuse elements* to compute the control volumes. Figure 90 shows the difference between the original and truncated Voronoï polygons in the 2D case.

Diagram comparing Voronoï polygons before and after algorithm truncation of obtuse elements Diagram comparing Voronoï polygons before and after algorithm truncation of obtuse elements

Figure 90 Algorithm truncation obtuse element: (*left*) Voronoï polygons before truncation – P1(v1,1,2,5,4,v1), P2(v2,1,2,3,v2), P3(v3,3,2,5,6,v3), P4(v4,4,5,6,v4); (*right*) Voronoï polygons after truncation – P1(v1,1,2,8,6,5,v1), P2(v2,1,2,3,4,v2), P3(v3,4,3,8,6,7,v3), P4(v4,5,6,7,v4)

For the 3D case, a similar algorithm of truncation is used.

Table 206 on page 1518 lists all the available options for computing box method parameters.

38: Numeric Methods
Box Method Coefficients in the 3D Case

# Weighted Box Method Coefficients

The main goal of any space discretization is the generation of a Delaunay mesh. In this case, the box method coefficients are positive and the finite volume scheme [1] (Eq. 1251, p. 1134) is monotone. For a non-Delaunay mesh, the `AverageBoxMethod` coefficients are positive, but the order of the approximation of PDEs is less than one.

Sentaurus Mesh can use special technology – Delaunay–Voronoï weights – for which the *weighted Voronoï diagram* has no overlap control volume for a non-Delaunay mesh. As a result, the finite volume scheme is monotone and the order of the approximation PDEs is equal to one.

## Weighted Points

A weighted point $\tilde{p} = (p, P^2)$ is interpreted as a sphere (circle in two dimensions) with a center $p$ and radius $P$. The weighted distance between $\tilde{p}$ and $\tilde{x} = (x, X)$ is defined as [4] [5][6]:

$$ \|\tilde{p} - \tilde{x}\| = \sqrt{\|p - x\|^2 - P^2 - X^2} $$ (1257)

The weighted points $\tilde{p}$ and $\tilde{x}$ are orthogonal if the weighted distance vanishes: $\|\tilde{p} - \tilde{x}\| = 0$.

In the 3D case, any four weighted points have a common orthogonal sphere called an *orthosphere*. Unless the four centers lie in a common plane, the orthosphere is unique and has a finite radius.

In the 2D case, any three weighted points have a common circle called an *orthocircle*. Unless the three centers lie in a common line, the orthocircle is unique and has a finite radius (see Figure 91).

Diagram showing three weighted points (circles) and their common orthocircle. The centers of the circles lie outside the orthocircle.

Figure 91 Since the radii of all weighted vertices are positive, their centers lie outside the orthocircle

38: Numeric Methods
Box Method Coefficients in the 3D Case

# Weighted Voronoï Diagram

The weighted generalization of the Voronoï diagram is obtained by substituting a weighted vertex for vertices and an orthosphere (orthocircle) for circumspheres (circumcircles).

The weighted bisector plane $B_{ij}$ between $\tilde{p}_i$ and $\tilde{p}_j$ is the locus of points at an equal-weighted distance from $\tilde{p}_i$ and $\tilde{p}_j$. The center of the orthosphere $x$ is the intersection of the bisector planes $x = \bigcap_{i \neq j} B_{ij}$. The weighted middle point $m_{ij}$ between $\tilde{p}_i$ and $\tilde{p}_j$ is the intersection of the segment $[p_i, p_j]$ and the bisector plane $B_{ij}$. The value $m_{ij}$ is equal to:

$$m_{ij} = \alpha_i p_i + \alpha_j p_j$$ (1258)

where:

$$\alpha_i = 0.5 \left( 1 - \frac{P_i^2 - P_j^2}{\|p_i - p_j\|^2} \right), \alpha_j = 1 - \alpha_i$$ (1259)

Therefore, the weighted bisector plane $B_{ij}$ is orthogonal to the segment $[p_i, p_j]$ and contains the weighted middle point $m_{ij}$, which is sufficient to compute the weighted coefficients and control volumes. If the radius $P_i \neq P_j$, then the middle point $m_{ij} \neq 0.5(p_i + p_j)$ and the weighted Voronoï diagram have no overlap control volume for non-Delaunay meshes (see Figure 92). This is the main property of the weighted Voronoï diagram.

Two-dimensional non-Delaunay mesh showing overlap elements in a non-weighted Voronoï diagram Two-dimensional non-Delaunay mesh showing no overlap elements in a weighted Voronoï diagram

Figure 92 Two-dimensional non-Delaunay mesh: (*left*) not weighted Voronoï diagram has overlap elements and (*right*) weighted Voronoï diagram has no overlap elements

Sentaurus Process computes the squared radii ($P_i^2$, plot name: `DelVorWeight` [$\mu\text{m}^2$]) of the weighted vertices and writes them to a TDR file (see the option `StoreDelaunayWeight` in Sentaurus™ Process User Guide, Table 90 on page 777).

If you specify the keyword `WeightedVoronoiBox` in the `Math` section of the command file, Sentaurus Device reads the corresponding arrays from a TDR file and computes the weighted coefficients and measure.

**38: Numeric Methods**
Box Method Coefficients in the 3D Case

# Saving and Restoring Box Method Coefficients

Usually, the coefficients needed for discretization are computed inside Sentaurus Device. For experimental purposes, it might be preferred to use externally provided data. `Measure` and `Coefficients` ($\mu^e(\Omega_i)$ and $\kappa_{ij}^e$ from Eq. 1251, p. 1134) can be stored in, and loaded into and from the debug file. There are two options for element numbering in such files:

*   Internal Sentaurus Device numbering with `MeasureCoefficientsDebug` as the debug file name

*   Mesh numbering (from grid file) with `MeasureCoefficients.debug` as the debug file name for this option

If you specify the keyword `BoxMeasureFromFile` or `BoxCoefficientsFromFile` in the `Math` section and there is the file `MeasureCoefficientsDebug` in the simulation directory, Sentaurus Device reads the corresponding arrays from this file.

If you specify either the keyword `BoxMeasureFromFile(GrdNumbering)` or the keyword `BoxCoefficientsFromFile(GrdNumbering)` and there is the `MeasureCoefficients.debug` file, then Sentaurus Device reads the corresponding arrays from this file. If there are no such debug files but these keywords are specified, then Sentaurus Device computes `Measure` and `Coefficients` and writes them in the corresponding file.

The format of the `MeasureCoefficientsDebug` file is as follows. In line $k$ of the `Measure` section, the control volume for each element-vertex $j$ of element $k$ is stored (that is, value `Measure[k][j]`). The numeration of elements and local numeration of vertices inside the element (see Figure 95 on page 1206) correspond to the internal Sentaurus Device numbering.

The `Coefficients` section in this file has a similar format. For example, the `Measure` section in the file can appear as follows:

```
Measure {
  8.719666833501378e-08 4.359833416750702e-08 4.359833416750729e-08
  8.719666833501378e-08 4.359833416750702e-08 4.359833416750729e-08
  ...
}
```

The format of the `MeasureCoefficients.debug` file differs. There are four sections: `Info`, `Elem_type`, `Measure`, and `Coefficients`. In line $k$ of the `Measure` section, the control volume for each element-vertex $j$ of element $k$ is stored (that is, value `Measure[k][j]`). The numeration of elements and local numeration of vertices inside the element correspond to the grid file. The `Coefficients` section in the debug file has a similar format.

Box Method Coefficients in the 3D Case

For example, the file can look like:

```
Info {
  dimension        = 2
  nb_vertices      = 10
  nb_grd_elements  = 11
  nb_des_elements  = 7
}

Elem_type {
  point        = 0
  line         = 1
  triangle     = 2
  rectangle    = 3
  tetrahedron  = 5
  pyramid      = 6
  prism        = 7
  cuboid       = 8
}

                              Measure { # unit = [um^2]
# grd_elem  des_elem  elem_type
  0   0   2   1.828427124999999e+00 9.142135625000004e-01 9.142135625000002e-01
  1   1   2   4.052251462735666e+00 4.052251462735666e+00 8.104502925471332e+00
  ...
  7      -1      1      # contact or interface
  8      -1      1      # contact or interface
  ...
}

                              Coefficients { # unit = [1]
# grd_elem  des_elem  elem_type
  0   0   2   1.093836321204215e+00 1.100111438811216e-16 2.285533906249999e-01
  1   1   2   0.000000000000000e+00 8.379715512271076e-01 8.379715512271076e-01
  ...
  7      -1      1      # contact or interface
  8      -1      1      # contact or interface
  ...
}
```

# Statistics About Non-Delaunay Elements

The log file contains information about region non-Delaunay elements and interface non-Delaunay elements. For more information, see Utilities User Guide, Chapter 4 on page 27.

Box Method Coefficients in the 3D Case

## Region Non-Delaunay Elements

A log file contains common data about the mesh and information about non-Delaunay elements per region (for Delaunay mesh DeltaVolume=0 and non-DelaunayVolume=0):

```
/------- Region non-Delaunay elements -------------------------------------------------
Region      Volume      BoxMethodVolume  DeltaVolume  Elements  non-Delaunay      non-DelaunayVolume
name        [um2]       [um2]            [%]                    Elements          [um2]      [%]
---------------------------------------------------------------------------------------
Nitride     1.9500000e-04  2.2635574e-04  16.080        53      12 (22.64 %)      1.8215e-04 (1.1e-05)
. . .
Oxide       6.0618645e-03  8.0705629e-03  33.137      2500     818 (32.72 %)      2.3715e-04 (2.0e-04)
Silicon     3.5548100e-02  4.9531996e-02  39.338     12656    5057 (39.96 %)      1.0715e-04 (1.0e-05)
Total       4.6402113e-02  6.4934852e-02  39.939     16550    6383 (38.57 %)      2.9218e-04 (2.1e-05)
\--------------------------------------------------------------------------------------
!!!!!! WARNING: Region_0 DeltaVolume = 39.338% > 1.0e-04%
```

If DeltaVolume exceeds some user-defined limit (default: 10<sup>-4</sup>), then Sentaurus Device prints a warning message. You can change this limit value in the global Math section. For example:

```
Math { ...
    DeltaVolumeLimit = 1e-2
}
```

## Interface Non-Delaunay Elements

An interface element is an element that has a face (or an edge in two dimensions) lying on the interface. A non-Delaunay element is an interface non-Delaunay element only if its obtuse face lies on the surface of the interface (see Figure 93).

Diagram showing oxide and silicon interface elements with numbered regions 1 through 6.

Figure 93 Blue (1, 2, 3) and green (4, 5, 6) elements are oxide and silicon interface elements, respectively. Elements 2 and 4 are non-Delaunay elements, not interface non-Delaunay elements. Only element 3 is an interface non-Delaunay element.

Box Method Coefficients in the 3D Case

The following is an example of a log file for interface non-Delaunay elements:

```
/-------- Interface non Delaunay elements ------------------------------------
 Region1             Elements  non Delaunay      Volume            non Delaunay
 Region2                       Elements          [um2]             DeltaVolume [um2]
 -----------------------------------------------------------------------------
 ..............................................................................
 silicon                3      0 (  0.00 %)    1.5775139e-03     0.0000000e+00 (  0.00 %)
 oxide                  3      1 ( 33.0 %)     1.6776069e-03     0.1100000e-03 (  0.10 %)
 ..............................................................................
 Total                  6      1 ( 16.0 %)     3.6951838e-02     0.1100000e+00 (  0.05 %)
 \-----------------------------------------------------------------------------
```

## Plot Section

Table 184 lists the plot variables that might be useful for visualizing box method statistics (see Scalar Data on page 1480). See Utilities User Guide, Chapter 4 on page 27 for the definitions of these variables.

Table 184 Plot variables for box method data

| Plot variable | Location |
| --- | --- |
| BM_AngleElements | Element |
| BM_CoeffIntersectionNonDelaunayElements | Element |
| BM_ElementsWithCommonObtuseFace | Element |
| BM_ElementsWithObtuseFaceOnBoundaryDevice | Element |
| BM_ElementVolume | Element |
| BM_IntersectionNonDelaunayElements | Element |
| BM_VolumeIntersectionNonDelaunayElements | Element |
| BM_wCoeffIntersectionNonDelaunayElements | Element |
| BM_wElementsWithCommonObtuseFace | Element |
| BM_wElementsWithObtuseFaceOnBoundaryDevice | Element |
| BM_wIntersectionNonDelaunayElements | Element |
| BM_wVolumeIntersectionNonDelaunayElements | Element |
| BM_AngleVertex | Vertex |
| BM_EdgesPerVertex | Vertex |
| BM_ElementsPerVertex | Vertex |
| BM_ShortestEdge | Vertex |

**38: Numeric Methods**
AC Simulation

# Improved Accuracy of Box Method Parameters

For challenging meshes containing slivers or non-Delaunay elements, it is recommended to use the `BM_StableCalculation` option in the global `Math` section of the command file. It is switched off by default.

Specifying this option activates enhancements to the box method calculations, which lead to the improved accuracy of the resulting parameters. Consequently, the `DeltaVolume` quality measure is reduced for non-Delaunay meshes.

# AC Simulation

AC simulation is based on small-signal AC analysis. The response of the device to ‘small’ sinusoidal signals superimposed upon an established DC bias is computed as a function of frequency and the DC operating point. Steady-state solution is used to build up a linear algebraic system [7] whose solution provides the real and imaginary parts of the variation of the solution vector ($\phi, n, p, T_n, T_p, T$) induced by small sinusoidal perturbation at the contacts.

## AC Response

The AC response is obtained from the three basic semiconductor equations (see Eq. 37, p. 179 and Eq. 57, p. 189) and from up to three additional energy conservation equations to account for electron, hole, and lattice temperature responses. In the following description of the AC system, temperatures have been omitted in the solution vector and Jacobian for simplicity, a complete description being formally obtained by adding the temperature responses to the solution vector and the corresponding lines to the system Jacobian.

After discretization, the simplified system of equations can be symbolically represented at node $i$ of the computation mesh as:

$$ F_{\phi i}(\phi, n, p) = 0 \tag{1260} $$

$$ F_{ni}(\phi, n, p) = \dot{G}_{ni}(n) \tag{1261} $$

$$ F_{pi}(\phi, n, p) = \dot{G}_{pi}(p) \tag{1262} $$

where $F$ and $G$ are nonlinear functions of the vector arguments $\phi, n, p$, and the dot denotes time differentiation.

38: Numeric Methods

AC Simulation

By substituting the vector functions of the form $\xi_{\text{total}} = \xi_{\text{DC}} + \tilde{\xi}e^{i\omega t}$ into Eq. 1260, Eq. 1261, and Eq. 1262 where $\xi = \phi, n, p$, $\xi_{\text{DC}}$ is the value of $\xi$ at the DC operating point, and $\tilde{\xi}$ is the corresponding response (or the phasor uniquely identifying the complex perturbation) and then expanding the nonlinear functions $F$ and $G$ in the Taylor series around the DC operating point and keeping only the first-order terms (the small-signal approximation), the AC system of equations at node $i$ can be written as:

$$ \sum_{j} \begin{bmatrix} \frac{\partial F_{\phi i}}{\partial \phi_j} & \frac{\partial F_{\phi i}}{\partial n_j} & \frac{\partial F_{\phi i}}{\partial p_j} \\ \frac{\partial F_{ni}}{\partial \phi_j} & \frac{\partial F_{ni}}{\partial n_j} - i\omega \frac{\partial G_{ni}}{\partial n_j} & \frac{\partial F_{ni}}{\partial p_j} \\ \frac{\partial F_{pi}}{\partial \phi_j} & \frac{\partial F_{pi}}{\partial n_j} & \frac{\partial F_{pi}}{\partial p_j} - i\omega \frac{\partial G_{pi}}{\partial p_j} \end{bmatrix}_{\text{DC}} \begin{bmatrix} \tilde{\phi}_j \\ \tilde{n}_j \\ \tilde{p}_j \end{bmatrix} = 0 \tag{1263} $$

where the solution vector is scaled with respect to terminal voltages (at the contact where the voltage is applied, $\tilde{\phi}$ is 1). Therefore, the unit of carrier density responses is $\text{cm}^{-3}\text{V}^{-1}$ and the potential response is unitless.

The matrix of Eq. 1263 differs from the Jacobian of the system of equations Eq. 1260, Eq. 1261, and Eq. 1262 only by pure imaginary additive terms involving derivatives of $G$ with respect to carrier densities.

The global AC matrix system is obtained by imposing the corresponding AC boundary conditions and performing the summation (assembling the global matrix).

Common AC boundary conditions used in AC simulation are Neumann boundary and oxide–semiconductor jump conditions carried over directly from DC simulation; Dirichlet boundary conditions for carrier densities where $n$ and $p$ at Ohmic contacts are $\tilde{n} = \tilde{p} = 0$; and Dirichlet boundary conditions for AC potential at Ohmic contacts that are used to excite the system.

After assembling the global AC matrix and taking into account the boundary conditions, the AC system becomes:

$$ [J + iD]\tilde{X} = B \tag{1264} $$

where:

*   $J$ is the Jacobian matrix.

*   $D$ contains the contributions of the $G$ functions to the matrix.

*   $B$ is a real vector dependent on the AC voltage drive.

*   $\tilde{X}$ is the AC solution vector.

38: Numeric Methods
AC Simulation

By writing the solution vector as $\tilde{X} = X_R + iX_I$ with $X_R$ and $X_I$ the real and imaginary part of the solution vector, respectively, the AC system can be rewritten using only real arithmetic as:

$$ \begin{bmatrix} J & -D \\ D & J \end{bmatrix} \begin{bmatrix} X_R \\ X_I \end{bmatrix} = \begin{bmatrix} B \\ 0 \end{bmatrix} \eqno(1265) $$

The AC response is actually computed by solving the system Eq. 1264 or Eq. 1265.

An `ACPlot` statement in the `ACCoupled` statement is used to plot AC responses ($\tilde{\phi}, \tilde{n}, \tilde{p}, \tilde{T}_n, \tilde{T}_p, \tilde{T}$). Responses are plotted in the AC plot file of Sentaurus Device with a separate file for each frequency.

For details about the `ACPlot` statement, see Table 332 on page 1624. For details and examples of small-signal AC analysis, see Small-Signal AC Analysis on page 101.

# AC Current Density Responses

When the AC system is solved, the AC current density responses $\tilde{J}_D, \tilde{J}_n$, and $\tilde{J}_p$ are computed using:

$$ \tilde{J}_D = -i\omega\varepsilon\nabla\tilde{\phi} \eqno(1266) $$

$$ \tilde{J}_n = \left. \frac{\partial J_n}{\partial \phi} \right|_{DC} \tilde{\phi} + \left. \frac{\partial J_n}{\partial n} \right|_{DC} \tilde{n} + \left. \frac{\partial J_n}{\partial p} \right|_{DC} \tilde{p} \eqno(1267) $$

$$ \tilde{J}_p = \left. \frac{\partial J_p}{\partial \phi} \right|_{DC} \tilde{\phi} + \left. \frac{\partial J_p}{\partial p} \right|_{DC} \tilde{p} + \left. \frac{\partial J_p}{\partial n} \right|_{DC} \tilde{n} \eqno(1268) $$

The unit of current density responses is Acm<sup>-2</sup>V<sup>-1</sup>.

The responses of the heat fluxes for the lattice ($\tilde{S}_L$), electrons ($\tilde{S}_n$), and holes ($\tilde{S}_p$) are analogous. Their unit is Wcm<sup>-2</sup>V<sup>-1</sup>.

The `ACPlot` statement in the `System` section is used to plot the AC current density responses. Responses are added to the AC solution response in the AC plot files of Sentaurus Device.

**38: Numeric Methods**
Harmonic Balance Analysis

# Harmonic Balance Analysis

Harmonic balance (HB) analysis is a frequency domain method to solve periodic and quasi-periodic time-dependent problems for steady-state solutions [[8]]([8])[[9]]([9]). It is a popular method for RF circuit design applications. While transient discretization schemes allow the simulation of arbitrary time-dependent problems, HB more efficiently models periodic and quasi-periodic problems for systems with time constants that vary by many orders of magnitude. The detailed command file syntax is given Harmonic Balance on page 106.

## Harmonic Balance Equation

In general, the dynamic mixed-mode simulation problem takes the form:

$$ \frac{d}{dt}q[r, u(t, r)] + f[r, u(t, r), w(t)] = 0 \tag{1269} $$

where $f$ and $q$ are nonlinear functions, $w$ represents explicitly time-dependent devices (in particular, voltage or current sources), and the function $u$ is the vector of all solution variables.

Let $f_1, \dots, f_K$ be a set of different frequencies with $f_k > 0$, then both the sources and the solution are approximated by a truncated Fourier series:

$$ u(t) = U_0 + \sum_{1 \le k \le K} \{ U_k \exp(i\omega_k t) + U_k^* \exp(-i\omega_k t) \} \tag{1270} $$

A formal Fourier transform of Eq. 1269 results in the HB equation for the problem:

$$ L(U) = i\Omega Q(U) + F(U) = 0 \tag{1271} $$

where $F$ and $Q$ are the finite Fourier series of $f$ and $q$, respectively, $\Omega$ is the frequency matrix, and $U$ is the vector of all Fourier coefficients of $u$.

## Multitone Harmonic Balance Analysis

Multitone HB analysis makes use of the multidimensional Fourier transformation (MDFT). This means that the problem is mapped onto a problem in a multidimensional frequency and multidimensional time domain, thereby exploiting the equivalence of Fourier spectra of quasi-periodic functions with their corresponding multidimensional functions.

**38: Numeric Methods**

Harmonic Balance Analysis

# Multidimensional Fourier Transformation

The MDFT maps multidimensional functions onto a multidimensional spectrum.

Let $M$ be a positive integer, the number of tones, $\hat{f}_1, \dots, \hat{f}_M$, be a finite set of different positive numbers, the base frequencies of tones, and $H_1, \dots, H_M$ nonnegative integer numbers, the maximal number of harmonics for each tone.

Define for each tone $m$ the $m$-th base period $T_m := 1/\hat{f}_m$, the $m$-th circular frequency $\omega_m := 2\pi\hat{f}_m$, the $m$-th (minimum) number of sampling points $S_m := 2H_m + 1$, and the $m$-th (maximum) sampling interval $\delta_m = T_m/S_m$.

Furthermore, let $\underline{x} = (x_1, \dots, x_M)^T$ denote the $M$-dimensional vector, and let $D_{\underline{x}} = \text{diag}(x_1, \dots, x_M)$ denote the $M \times M$-matrix composed of the values $x_1, \dots, x_M$.

The set of multi-indices associated with $\underline{H}$ is given by:

$$K := \{ \underline{h} \in \mathbf{Z}^M : -H_m \le h_m \le H_m \text{ for all } 1 \le m \le M \}$$ (1272)

Let $u^M$ be a function on the $M$-dimensional space $\mathbf{C}^M$ given by:

$$u^M(t_1, \dots, t_M) = \sum_{\underline{h} \in K} U_{\underline{h}}^M \exp(i\underline{h}D_{\underline{\omega}}\underline{t})$$ (1273)

with given complex numbers $U_{\underline{h}}^M$, then:

$$U_{\underline{h}}^M = \frac{1}{T} \int_0^{T_1} \dots \int_0^{T_M} u^M(t_1, \dots, t_M) \exp(-i\underline{h}D_{\underline{\omega}}\underline{t}) dt_1 \dots dt_M$$ (1274)

with $T := \prod_{1 \le m \le M} T_m$. $U^M = (U_{\underline{h}}^M)_{\underline{h} \in K}$ is the multidimensional spectrum of $u^M$.

Sampling the function in all dimensions at the equidistant sampling points $\underline{t}_{\underline{s}} = D_{\underline{\delta}}\underline{s} (0 \le \underline{s} < \underline{S})$, the discrete MDFT is written formally as:

$$U^M = \Gamma^M u^M$$ (1275)

that is, $\Gamma^M$ is a linear map from $\mathbf{C}^S$ onto $\mathbf{C}^S$ where $S := \prod_{1 \le m \le M} S_m$ is the total number of sampling points.

1151

**38: Numeric Methods**

Harmonic Balance Analysis

## Quasi-Periodic Functions

The multidimensional function $u^M$ can be projected onto a one-dimensional time space by:

$$u(t) := u^M(t, \dots, t) = \sum_{\underline{h} \in K} U_{\underline{h}} \exp(i \underline{h} \underline{\omega} t) \tag{1276}$$

Functions satisfying this representation are called quasi-periodic. The set:

$$\Lambda := \{f_{\underline{h}} \in \mathbb{R} : f_{\underline{h}} = \underline{h} \cdot \hat{f} \text{ for all } \underline{h} \in K\} \tag{1277}$$

is the spectrum domain associated with $f$ and $K$ (or $H$). The projection is invertible if, for two different multi-indices $\underline{h}_1$ and $\underline{h}_2$ in $K$, the resulting frequencies $f_{\underline{h}_1}$ and $f_{\underline{h}_2}$ differ. Note that the one-dimensional Fourier spectrum of $u$ coincides with the multidimensional spectrum of $u^M$.

While for the multidimensional function $u^M$ $S$ sample points can be specified to compute the multidimensional spectrum, the one-dimensional sample points for $u$ are not well defined (but are virtual in the multidimensional time domain).

## Multidimensional Frequency Domain Problem

Multitone HB analysis is essentially a translation of (one-dimensional or multidimensional) time-domain problems in a multidimensional frequency domain. Although originally derived from a time-domain problem, circuit equations are specified directly in a multidimensional frequency domain. This avoids sampling of (one-dimensional) time-dependent sources, which cannot be performed accurately on a sample set of size $S$. This is the reason why the compact circuit models must provide the CMI-HB-MDFT function set.

The Fourier transformation of quasi-periodic functions is the composition:

$$\Gamma = \Gamma^M \circ P^{-1} \tag{1278}$$

where $\Gamma^M$ is the multidimensional Fourier transformation of Eq. 1275 and $P^{-1}$ is the inverse of the projection Eq. 1276.

## One-Tone Harmonic Balance Analysis

For one-tone HB analysis, the standard discrete Fourier transformation can be used, which includes that the sampling points are defined explicitly in a (one-dimensional) time domain. Therefore, the problem can be extracted directly from the time-domain formulation of the circuit.

1152

**38: Numeric Methods**
Harmonic Balance Analysis

# Solving the Harmonic Balance Equation

The HB equation (Eq. 1271) is a nonlinear equation in $U$ and is solved by the Newton algorithm. In each Newton step, the following linear equation must be solved:

$$ \frac{\partial L}{\partial U}(U) \cdot \delta U = -L(U) $$ (1279)

The Jacobian $\partial L / \partial U$ in Fourier space is computed from the Jacobian in the time domain as follows. For a nonlinear scalar function $g : \boldsymbol{R} \rightarrow \boldsymbol{R}$ and a $T$-periodic scalar signal $u(t)$, the Fourier coefficients $G \in \boldsymbol{C}^S$ of $g(u(t))$ are approximated:

$$ G(U) = \Gamma g(\hat{u}) = \Gamma g(\Gamma^{-1} U) $$ (1280)

where $\Gamma$ and $\Gamma^{-1}$ are the discrete Fourier transform operator and its inverse, $\hat{u}$ is the vector of the time samples $u(t_i)$, and $g(\hat{u})$ is the vector of values $g(u(t_i))$.

The derivatives of the $k$-th Fourier component $G_k$ with respect to the $j$-th Fourier component $U_j$ read:

$$ \frac{\partial G_k}{\partial U_j}(U) = \sum_l \Gamma_{kl} \frac{\partial g}{\partial U_j}(\hat{u}_l) = \sum_l \Gamma_{kl} \frac{\partial g}{\partial u}(\hat{u}_l) \Gamma_{lj}^{-1} $$ (1281)

The corresponding Jacobian is written in the compact form:

$$ \frac{\partial G}{\partial U} = \Gamma \hat{J}_u \Gamma^{-1} \text{ with } \hat{J}_u = \frac{\partial g}{\partial u}(\hat{u}) $$ (1282)

For scalar functions $g$ and $u$, $\hat{J}_u$ is a diagonal matrix. For vector-valued functions $g$ and $u$, $\hat{J}_u$ is a block-diagonal matrix.

Using the notation above, Eq. 1271 becomes:

$$ L(U) = i\Omega \Gamma q(\hat{u}(U)) + \Gamma f(\hat{u}(U)) = 0 $$ (1283)

and Eq. 1279 for the Newton step takes the form:

$$ (i\Omega \Gamma \hat{J}_q \Gamma^{-1} + \Gamma \hat{J}_f \Gamma^{-1}) \delta U = -L(U) $$ (1284)

The Newton algorithm constructs a sequence $U^k$ of the Fourier coefficients of the time-domain solution vector $u$. The sequence is considered to be converged if both the residual $|L(U^k)|$ and the update error are small.

38: Numeric Methods
Harmonic Balance Analysis

# Solving the Harmonic Balance Newton Step Equation

The memory requirements for storing the HB Jacobian matrix typically become very large, as its size is increased by a factor of $S^2$ compared to the corresponding DC or transient matrix. For a very small number of harmonics and a moderately sized simulation grid, using a direct linear solver might be feasible. However, using the GMRES(m) iterative method is recommended for most applications.

## Restarted GMRES Method

The HB module makes use of a preconditioned restarted generalized minimum residual GMRES(m) method [10], a Krylow subspace method, which does not need to store the Jacobian in memory, as only matrix-vector products have to be computed.

GMRES(m) requires a suitable preconditioner to achieve convergence. A (left) preconditioner $P$ is a matrix that approximates a given matrix $A$, but is much easier to invert than $A$ itself. Instead of solving the linear equation $Ax = b$ for given $A$ and $b$, the (left) preconditioned problem $P^{-1}Ax = P^{-1}b$ is solved. The preconditioner used for HB [11] takes the form:

$$ P = i\Omega \begin{bmatrix} \bar{J}_q & & 0 \\ & \dots & \\ 0 & & \bar{J}_q \end{bmatrix} + \begin{bmatrix} \bar{J}_f & & 0 \\ & \dots & \\ 0 & & \bar{J}_f \end{bmatrix} \eqno(1285) $$

where the matrix $\bar{J}_f$, and similarly $\bar{J}_q$, is computed as:

$$ \bar{J}_f = \frac{1}{S} \sum_{0 \le s \le S-1} J_f(t_s) \eqno(1286) $$

and $J_f$ denotes the Jacobian of $f$ with respect to $u$. The preconditioner equals the HB Jacobian in the limit of small signals, where the coupling terms between frequencies vanish. Therefore, each diagonal block of $P$ corresponds to the AC matrix for the respective harmonic. This preconditioner is well suited to moderately large signal applications.

The preconditioner can be computed without an explicit Fourier transform, and its inversion is more economical than for the full Jacobian. The inversion is performed by applying a complex direct solver for each harmonic component separately, thereby requiring the computational costs of solving $(S+1)/2$ complex-valued linear systems. The computational complexity is of the order $O(S)$ for inverting the preconditioner, and $O(S \ln(S))$ for one complete iteration step of the iterative solver, while the number of iterations necessary to achieve convergence is unknown (but bounded).

**38: Numeric Methods**
Transient Simulation

## Direct Solver Method

For the direct solver, the complex-valued $S \times S$ linear system (Eq. 1284) is transformed to a $S \times S$ real-valued problem, which is possible as only real-valued functions are involved. The resulting linear system is solved by the direct solver PARDISO. The direct solver requires the entire matrix stored in memory. Therefore, the memory capacity is easily exceeded for increasing $S$. In addition, the computational complexity is of the order $O(S^3)$.

# Transient Simulation

Transient equations used in semiconductor device models and circuit analysis can be formally written as a set of ordinary differential equations:

$$\frac{d}{dt}q(z(t)) + f(t, z(t)) = 0 \tag{1287}$$

which can be mapped to the DC and transient parts of the PDEs.

Sentaurus Device uses implicit discretization of transient equations (see Eq. 1287) and supports two discretization schemes: simple backward Euler and composite trapezoidal rule/ backward differentiation formula (TRBDF), which is the default.

## Backward Euler Method

Backward Euler is a very stable method, but it has only a first-order of approximation over time step $h_n$. The discretization can be written as:

$$q(t_n + h_n) + h_n f(t_n + h_n) = q(t_n) \tag{1288}$$

The local truncation error (LTE) estimation is based on the comparison of the obtained solution $q(t_n + h_n)$ with the linear extrapolation from the previous time step.

The extrapolated solution is written as:

$$q^{\text{extr}} = q(t_n) - \frac{f(t_n) + f(t_n + h_n)}{2} h_n \tag{1289}$$

Then, in every point, the relative error can be estimated as $(q(t_n + h_n) - q^{\text{extr}}) / q(t_n + h_n)$.

38: Numeric Methods

Transient Simulation

Using Eq. 1288 and Eq. 1289, and estimating the norm of relative error, Sentaurus Device computes the value:

$$ r = \sqrt{\frac{1}{N} \sum_{i=1}^{N} \left( \frac{f(t_n + h_n) - f(t_n)}{\varepsilon_{R,tr} |q_n(t_n + h_n)| + \varepsilon_{A,tr}} h_n \right)^2} $$ (1290)

where the sum is taken over all unknowns (that is, all free vertices of all equations), and $\varepsilon_{R,tr}$ and $\varepsilon_{A,tr}$ are the relative and absolute transient errors, respectively.

The next time step is estimated as:

$$ h_{est} = h_n r^{-1/2} $$ (1291)

The value of the estimated time step is used for the $h_{n+1}$ computation (see Controlling Transient Simulations on page 1157).

# TRBDF Composite Method

The transient scheme [12] for the approximation of Eq. 1287 is briefly reviewed here. From each time point $t_n$, the next time point $t_n + h_n$ ($h_n$ is the current step size) is not directly reached. Instead, a step in between to $t_n + \gamma h_n$ is made. This improves the accuracy of the method, and $\gamma = 2 - \sqrt{2}$ has been shown to be the optimal value. Using this, two nonlinear systems are reached.

For the trapezoidal rule (TR) step:

$$ 2q(t_n + \gamma h_n) + \gamma h_n f(t_n + \gamma h_n) = 2q(t_n) - \gamma h_n f(t_n) $$ (1292)

For the BDF2 step:

$$ (2 - \gamma)q(t_n + h_n) + (1 - \gamma)h_n f(t_n + h_n) = (1/\gamma)(q(t_n + \gamma h_n) - (1 - \gamma)^2 q(t_n)) $$ (1293)

The LTE is estimated after such a double step as:

$$ \tau = \left[ \frac{f(t_n)}{\gamma} - \frac{f(t_n + \gamma h_n)}{\gamma(1 - \gamma)} + \frac{f(t_n + h_n)}{1 - \gamma} \right] $$ (1294)

$$ C = \frac{-3\gamma^2 + 4\gamma - 2}{12(2 - \gamma)} $$ (1295)

**38: Numeric Methods**
Transient Simulation

Sentaurus Device then computes the following value from this:

$$ r = \sqrt{\frac{1}{N} \sum_{i=1}^{N} \left( \frac{\tau_i}{\varepsilon_{R,tr} |q_n(t_n + h_n)| + \varepsilon_{A,tr}} \right)^2} $$ (1296)

where the sum is taken over all unknowns (that is, all free vertices of all equations), and $\varepsilon_{R,tr}$ and $\varepsilon_{A,tr}$ are the relative and absolute transient errors, respectively. Since the TRBDF method has a second-order approximation over $h_n$, the next step can be estimated as:

$$ h_{\text{est}} = h_n r^{-1/3} $$ (1297)

The value of the estimated time step is used for the $h_{n+1}$ computation (see Controlling Transient Simulations).

# Controlling Transient Simulations

By default, Sentaurus Device uses the TRBDF method. To switch to backward Euler (BE), you can specify `Transient=BE` either in the `Math` section (which changes the default time integration method) or in the options of a `Transient` statement in the `Solve` section (which changes the time integration method only for that particular `Transient` statement).

The TRBDF method is a second-order integration method that provides better accuracy than the backward Euler method, and is the only reliable method for challenging transient problems. Alternatively, the often recommended backward Euler method is a first-order integration method, which provides faster and more robust convergence behavior than the TRBDF method, but at the expense of accuracy, often filtering out fast-varying signals such as ringing.

To evaluate whether a time step was successful and to provide an estimate for the next step size, the following rules are applied:

*   If one of the nonlinear systems cannot be solved, then the step is refused and tried again with $h_n = 0.5 \cdot h_n$.

*   Otherwise, the inequality $r < 2f_{\text{rej}}$ is tested. If it is fulfilled, then the transient simulation proceeds with $h_{n+1} = h_{\text{est}}$. Otherwise, the step is tried again with $h_n = 0.9 \cdot h_{\text{est}}$.

*   The LTE is checked only if the `CheckTransientError` option is selected. Otherwise, the selection of the next time step is based only on convergence of nonlinear iterations.

To activate LTE evaluation and time-step control, you must specify `CheckTransientError` either globally (in the `Math` section) or locally as an option in the `Transient` statement. The keyword `NoCheckTransientError` deactivates time-step control. The value of the relative error is defined by the parameter `TransientDigits` according to Eq. 14, p. 91.

Transient Simulation

The absolute error is given by the keyword `TransientError` or is recomputed from `TransientErrRef` ($x_{\text{ref,tr}}$) using Eq. 15, p. 92 (if `RelErrControl` is switched on). Sentaurus Device provides the default values of $\epsilon_{\text{R,tr}}$, $\epsilon_{\text{A,tr}}$, and $x_{\text{ref,tr}}$. The coefficient $f_{\text{rej}}$ is equal to 1 by default. You can define the values of $\epsilon_{\text{R,tr}}$, $\epsilon_{\text{A,tr}}$, $x_{\text{ref,tr}}$, and $f_{\text{rej}}$ globally in the `Math` section, or you can specify them as options in the `Transient` statement. In the latter case, it overwrites the default and `Math` specifications for this command.

## Floating Gates

During a transient time step, the charge $Q$ of a floating gate is updated as a function of the injection current $i$:

$$ \Delta Q = \int_{t_1}^{t_2} i(t) dt \tag{1298} $$

$\Delta Q$ represents the charge increase for the time step $[t_1, t_2]$.

Because the floating-gate charge is not updated self-consistently during a transient step, but only as a postprocessing operation, the numeric update is given by:

$$ \Delta Q = i(t_1) \cdot \Delta t \tag{1299} $$

where $\Delta t = t_2 - t_1$. The error of this numeric approximation is estimated by:

$$ \Delta Q_{\text{error}} = \frac{|i(t_2) - i(t_1)|}{2} \Delta t \tag{1300} $$

With the option `CheckTransientError`, the error $\Delta Q_{\text{error}}$ in the charge update is monitored as well. In the case of relative error control (`RelErrControl`), a transient step is accepted only if the following condition holds:

$$ \frac{\Delta Q_{\text{error}}}{10^{-\text{Digits}}(|Q| + \text{ErrRef})} < 1 \tag{1301} $$

The values of `Digits` and `ErrRef` can be specified in the `Math` section. For example:

```
Math {
  TransientDigits = 3
  TransientErrRef (Charge) = 1.602192e-19
}
```

**38: Numeric Methods**
Nonlinear Solvers

In the case of absolute error control (`-RelErrControl`), a transient step is accepted only if the following condition holds:

$$ \frac{\frac{\Delta Q_{\text{error}}}{q}}{10^{-\text{Digits}} \frac{|Q|}{q} + \text{Error}} < 1 \tag{1302} $$

The electron charge $q = 1.602192 \cdot 10^{-19} \text{C}$ is used as a scaling factor.

The values of `Digits` and `Error` can be specified in the `Math` section. For example:

```
Math {
  TransientDigits = 3
  TransientError (Charge) = 1e-3
}
```

Note that the values of `ErrRef` and `Error` are related by the equation:

$$ \text{ErrRef} = \frac{\text{Error}}{10^{-\text{Digits}}} q \tag{1303} $$

# Nonlinear Solvers

In the next sections, the `Digits` variable corresponds to the keyword `Digits`, which can be given in the `Math` section (see Convergence and Error Control on page 143), or in parentheses of each `Plugin` or `Coupled` statement.

## Fully Coupled Solution

For the solution of nonlinear systems, the scheme developed by Bank and Rose [13] is applied. This scheme tries to solve the nonlinear system $g(z) = 0$ by the Newton method:

$$ \vec{g} + \vec{g}' \vec{x} = 0 \tag{1304} $$

$$ \vec{z}^j - \vec{z}^{j+1} = \lambda \vec{x} \tag{1305} $$

where $\lambda$ is selected such that $\|\vec{g}_{k+1}\| < \|\vec{g}_k\|$, but is as close as possible to 1. Sentaurus Device handles the error by computing an error function that can be defined by two methods.

38: Numeric Methods

Nonlinear Solvers

The Newton iterations stop if the convergence criteria are fulfilled. One convergence criterion is the norm of the right-hand side, that is, $\|g\|$ in Eq. 1304. Another natural criterion can be the relative error of the variables measured, such as $\left\| \frac{(\lambda x)}{z} \right\|$.

Conversely, for very small $z$ updates, $\lambda x$ must be measured with respect to some reference value of the variable $z_{\text{ref}}$. The formula used in Sentaurus Device as the second convergence criterion is:

$$ \frac{1}{\varepsilon_{\text{R}}} \frac{1}{N} \sum_{e, i} \frac{|z(e, i, j) - z(e, i, j - 1)|}{|z(e, i, j)| + z_{\text{ref}}(e)} < 1 \eqno(1306) $$

where $z(e, i, j)$ is the solution of the equation $e$ (Poisson, electron, hole, and so on) at node $i$ after Newton iteration $j$. The constant $N$ is given by the total number of nodes multiplied by the total number of equations. The parameter $\varepsilon_{\text{R}}$ is the relative error criterion.

Newton iteration graph showing g(z) vs z with points for iterations j and j+1

Figure 94 Newton iteration

The value of $\varepsilon_{\text{R}} = 10^{-\text{Digits}}$ is set by specifying the following in the `Math` section:

```
Math{...
   Digits = 5
}
```

where `5` is the default for `Digits`. The reference values $z_{\text{ref}}(e)$ ensure numeric stability even for cases when $z(e, i, j)$ is zero or very small. This error condition ensures that the respective equations are solved to an accuracy of approximately $z_{\text{ref}}(e)\varepsilon_{\text{R}}$.

Eq. 1306 can be written in the symbolic form:

$$ \frac{1}{\varepsilon_{\text{R}}} \left\| \frac{\lambda x}{z^j + z_{\text{ref}}} \right\| < 1 \eqno(1307) $$

**38: Numeric Methods**
Nonlinear Solvers

Eq. 1307 can also be rewritten in the equivalent form:

$$ \left\| \frac{\lambda \bar{x}}{\epsilon_{\text{R}} \bar{z}^j + \epsilon_{\text{A}}} \right\| < 1 $$ (1308)

where $\bar{z}^j = z^j / z^*$ and $\bar{x} = x / z^*$.

$z^*$ is the normalization factor (for example, it is the intrinsic carrier density $n_i = 1.48 \times 10^{10} \text{ cm}^{-3}$ for electron and hole equations, and the thermal voltage $u_{T0} = 25.8 \text{ mV}$ for the Poisson equation).

The absolute error is related to the relative error through:

$$ \epsilon_{\text{A}} = \epsilon_{\text{R}} \frac{z_{\text{ref}}}{z^*} $$ (1309)

Sentaurus Device supports two schemes for controlling error conditions. The default scheme is based on Eq. 1306. The default values for the parameters $z_{\text{ref}}$ are listed in Table 336 on page 1628. They also are accessible in the `Math` section. For example:

```
Math{...
  ErrRef( Electron ) = 1e10
  ErrRef( Hole )     = 1e10
}
```

The second scheme is activated with the keyword `-RelErrControl` in the `Math` section and is based on Eq. 1308. The default values for the parameters $\epsilon_{\text{A}}$ are listed in Table 336. They also are accessible in the `Math` section. For example:

```
Math{...
  -RelErrControl
  Error( Electron ) = 1e-5
  Error( Hole )     = 1e-5
}
```

# ‘Plugin’ Iterations

This is the traditional scheme, which is also known as *Gummel iterations* in most other device simulators. Consider that there are $n$ sets of nonlinear systems $g_j(z_1 \dots z_n) = 0$ ($n$ can be, for example, 3 and the sets can be the Poisson equation and two continuity equations). This method starts with values $z_1^{(1)}, \dots, z_n^{(1)}$ and then solves each set $g_j = 0$ separately and consecutively.

**38: Numeric Methods**

References

One loop could be:

$$ \begin{array}{l} g_{1}(z_{1}^{(i)}, z_{2}^{(i)}, \dots, z_{n}^{(i)}) = 0 \Rightarrow z_{1}^{(i+1)} \\ \dots \\ g_{1}(z_{1}^{(i+1)}, \dots, z_{n-1}^{(i+1)}, z_{n}) = 0 \Rightarrow z_{n}^{(i+1)} \end{array} \tag{1310} $$

If an update $(\lambda x)$ of the solution between two successive plugin iterations is defined as:

$$ (\lambda x) = z_{j}^{(i+1)} - z_{j}^{(i)} \tag{1311} $$

Eq. 1307 or Eq. 1308 can be applied for convergence control in plugin iterations.

# References

[1] R. E. Bank, D. J. Rose, and W. Fichtner, “Numerical Methods for Semiconductor Device Simulation,” IEEE Transactions on Electron Devices, vol. ED-30, no. 9, pp. 1031–1041, 1983.

[2] R. S. Varga, *Matrix Iterative Analysis*, Englewood Cliffs, New Jersey: Prentice-Hall, 1962.

[3] E. M. Buturla *et al.*, “Finite-Element Analysis of Semiconductor Devices: The FIELDAY Program,” IBM Journal of Research and Development, vol. 25, no. 4, pp. 218–231, 1981.

[4] H. Edelsbrunner, “Triangulations and meshes in computational geometry,” *Acta Numerica*, vol. 9, pp. 133–213, March 2000.

[5] S.-W. Cheng *et al.*, “Sliver Exudation,” *Journal of the ACM*, vol. 47, no. 5, pp. 883–904, 2000.

[6] H. Edelsbrunner and D. Guoy, “An Experimental Study of Sliver Exudation,” in *Proceedings of the 10th International Meshing Roundtable*, Newport Beach, CA, USA, pp. 307–316, October 2001.

[7] S. E. Laux, “Application of Sinusoidal Steady-State Analysis to Numerical Device Simulation,” in *New Problems and New Solutions for Device and Process Modelling: An International Short Course held in association with the NASECODE IV Conference*, Dublin, Ireland, pp. 60–71, 1985.

[8] B. Troyanovsky, Z. Yu, and R. W. Dutton, “Physics-based simulation of nonlinear distortion in semiconductor devices using the harmonic balance method,” *Computer Methods in Applied Mechanics and Engineering*, vol. 181, no. 4, pp. 467–482, 2000.

[9] P. J. C. Rodrigues, *Computer-Aided Analysis of Nonlinear Microwave Circuits*, Boston: Artech House, 1998.

**38: Numeric Methods**
References

[10] Y. Saad, *Iterative Methods for Sparse Linear Systems*, Philadelphia: SIAM, 2nd ed., 2003.

[11] P. Feldmann, B. Melville, and D. Long, “Efficient Frequency Domain Analysis of Large Nonlinear Analog Circuits,” in *Proceedings of the IEEE Custom Integrated Circuits Conference*, San Diego, CA, USA, pp. 461–464, May 1996.

[12] R. E. Bank *et al.*, “Transient Simulation of Silicon Devices and Circuits,” *IEEE Transactions on Computer-Aided Design*, vol. CAD-4, no. 4, pp. 436–451, 1985.

[13] R. E. Bank and D. J. Rose, “Global Approximate Newton Methods,” *Numerische Mathematik*, vol. 37, no. 2, pp. 279–295, 1981.

## References

 