# CHAPTER 39 Physical Model Interface

*This chapter discusses the flexible physical model interface (PMI) that is used to add new physical models to Sentaurus Device.*

## Introduction to the Physical Model Interface

The PMI provides direct access to certain models in the semiconductor transport equations. You can provide new C++ functions to compute these models, and Sentaurus Device loads the functions at runtime using the dynamic loader. No access to the Sentaurus Device source code is necessary.

You can modify the models in the following sections:

*   Generation–Recombination

    - Avalanche Generation

    - Generation–Recombination

    - Lifetimes

    - Nonlocal Generation–Recombination

    - Tunneling Parameters

*   Mobility

    - Doping-Dependent Mobility

    - Fitting Parameter for Ballistic Mobility

    - High-Field Saturation

    - High-Field Saturation With Two Driving Forces

    - Mobility Degradation at Interfaces

*   Semiconductor Band Structure

    - Apparent Band-Edge Shift

    - Band Gap

    - Bandgap Narrowing

    - Effective Mass

    - Electron Affinity

Introduction to the Physical Model Interface

* Phase and State Transitions

    * Multistate Configuration–Dependent Apparent Band-Edge Shift

    * Multistate Configuration–Dependent Bulk Mobility

    * Multistate Configuration–Dependent Heat Capacity

    * Multistate Configuration–Dependent Thermal Conductivity

* Thermal Properties and Heat

    * Distributed Thermal Resistance

    * Heat Capacity

    * Heat Generation Rate

    * Metal Thermoelectric Power

    * Thermal Conductivity

    * Thermoelectric Power

* Optics

    * Complex Refractive Index Model Interface

    * Optical Quantum Yield

    * Special Contact PMI for Raytracing

* Mechanical Stress

    * Mobility Stress Factor

    * Piezoelectric Polarization

    * Piezoresistive Coefficients

    * Stress

* Traps and Fixed Charges

    * Trap Capture and Emission Rates

    * Trap Energy Shift

* Degradation

    * Diffusivity

    * eNMP Transition Rates

* Ferroelectrics and Ferromagnetics

    * Ferroelectrics Hysteresis

    * Ferroelectrics

39: Physical Model Interface
Introduction to the Physical Model Interface

* Ferromagnetism and Spin Transport

■ Electrical Resistivity

* Metal Resistivity

* Schottky Resistance

■ Simulation Controls

* Current Plot File

* Postprocessing for Transient Simulations

* Preprocessing for Newton Iterations and Newton Step Control

■ Various

* Dielectric Permittivity

* Energy Relaxation Times

* Gamma Factor for Density Gradient Model

* Heavy Ion Spatial Distribution

* Hot-Carrier Injection

* Incomplete Ionization

* Space Factor

# Using a PMI Model

To use a PMI model in a Sentaurus Device simulation, the following steps are required:

1. Implement a C++ subroutine to evaluate the PMI model. In the case of the standard interface, you must write additional C++ subroutines to evaluate the derivatives of the PMI model with respect to all input variables.

2. Compile the C++ subroutine that implements the PMI model with `cmi <pmi_file_name>.C`. This produces the `<pmi_file_name>.so.<platform>` shared object file that Sentaurus Device loads at runtime (see Shared Object Code on page 1187).

> **NOTE** The version of the C++ compiler used for a PMI model must be identical to the version of the C++ compiler used to compile Sentaurus Device. Use the command `cmi -a` to verify the compiler versions.

3. Define the `PMIPath` variable in the `File` section of the command file. This variable defines the search path for the shared object files. A PMI model is activated in the `Physics` section of the command file by specifying its name (see Command File of Sentaurus Device on page 1187).

Introduction to the Physical Model Interface

Parameters for PMI models can appear in the parameter file under a section with the PMI model name (see Parameter File of Sentaurus Device on page 1189). Alternatively, you can also define the PMI model parameters in the Sentaurus Device command file that uses the PMI model (see Command File of Sentaurus Device on page 1187).

The source code for the examples presented in this chapter is located in the following directory:

`$STROOT/tcad/$STRELEASE/Applications_Library/GettingStarted/sdevice/pmi`

---

## Available Interfaces

For most models, Sentaurus Device provides two equivalent interfaces:

*   The *standard C++ interface* is based on the data type `double`. Separate subroutines must be written to evaluate the model and its derivatives. This interface provides performance comparable to the built-in models in Sentaurus Device (see Standard C++ Interface on page 1168).

*   The *simplified C++ interface* is based on the data type `pmi_float`. Only a single subroutine must be implemented to evaluate the model (see Simplified C++ Interface on page 1171). For local models, the derivatives of the model are obtained by automatic differentiation. This interface also supports extended-precision floating-point arithmetic (see Extended Precision on page 174).

There is an additional interface where values are computed based on nonlocal values of the input variables (see Nonlocal Interface on page 1175).

## Standard C++ Interface

For each PMI model, you must implement a C++ subroutine to evaluate the model. Additional subroutines are necessary to evaluate the derivatives of the model with respect to all the input variables. More specifically, you must implement a C++ class that is derived from a base class declared in the header file `PMIModels.h`. In addition, a *virtual constructor function* must be provided, which allocates an instance of the derived class.

### Example: Implementing Auger Recombination as New PMI Model

Consider the implementation of Auger recombination as a new PMI model. (The built-in Auger recombination model is discussed in Auger Recombination Model on page 436.) In its simplest form, Auger recombination can be written as:

$$ R_{net} = C \cdot (n + p) \cdot (np - n_{i,eff}^{2}) $$ (1312)

**39: Physical Model Interface**
Introduction to the Physical Model Interface

Sentaurus Device needs to evaluate the value of $R_{\text{net}}$ and the derivatives:

$$
\begin{aligned}
\frac{\partial R_{\text{net}}}{\partial n} &= C(np - n_{i,\text{eff}}^2 + (n + p)p) \\
\frac{\partial R_{\text{net}}}{\partial p} &= C(np - n_{i,\text{eff}}^2 + (n + p)n) \\
\frac{\partial R_{\text{net}}}{\partial n_{i,\text{eff}}} &= -2C(n + p)n_{i,\text{eff}}
\end{aligned}
\hfill (1313)
$$

In the header file `PMIModels.h`, the following base class is defined for recombination models:

```cpp
class PMI_Recombination : public PMI_Vertex_Interface {

public:
  PMI_Recombination (const PMI_Environment& env);
  virtual ~PMI_Recombination ();

  virtual void Compute_r
    (const double t, const double n, const double p,
    const double nie, const double f, double& r) = 0;

  virtual void Compute_drdt
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdt) = 0;

  virtual void Compute_drdn
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdn) = 0;

  virtual void Compute_drdp
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdp) = 0;

  virtual void Compute_drdnie
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdnie) = 0;

  virtual void Compute_drdf
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdf) = 0;
};
```

To implement a PMI model for Auger recombination, you must declare a derived class:

```cpp
#include "PMIModels.h"

class Auger_Recombination : public PMI_Recombination {

  double C;
```

Introduction to the Physical Model Interface

```cpp
public:
  Auger_Recombination (const PMI_Environment& env);
  ~Auger_Recombination ();

  void Compute_r
    (const double t, const double n, const double p,
    const double nie, const double f, double& r);

  void Compute_drdt
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdt);

  void Compute_drdn
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdn);

  void Compute_drdp
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdp);

  void Compute_drdnie
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdnie);

  void Compute_drdf
    (const double t, const double n, const double p,
    const double nie, const double f, double& drdf);
};
```

The constructor of the derived class is invoked for each region of the device.

In this example, the variable C is initialized from the parameter file:

```cpp
Auger_Recombination::
Auger_Recombination (const PMI_Environment& env) :
  PMI_Recombination (env)
{ C = InitParameter ("C", 1e-30);
}
```

If the parameter *C* is not found in the parameter file, then a default value of 10<sup>-30</sup> is used (see Parameter File of Sentaurus Device on page 1189). During a Newton iteration, Sentaurus Device evaluates a PMI model for each mesh vertex. The method `Compute_r()` computes the recombination rate for a given vertex. According to the parameter list, the recombination rate can depend on the following variables:

* t: Lattice temperature

* n: Electron density

* p: Hole density

39: Physical Model Interface
Introduction to the Physical Model Interface

*   nie: Effective intrinsic density

*   f: Absolute value of electric field

The result of the function is stored in the parameter r:

```cpp
void Auger_Recombination::
Compute_r (const double t, const double n, const double p,
           const double nie, const double f, double& r)
{ r = C * (n + p) * (n*p - nie*nie);
  if (r < 0.0) {
    r = 0.0;
  }
}
```

Besides Compute_r(), you must implement other methods to compute the partial derivatives of the recombination rate with respect to the input variables t, n, p, nie, and f.

The implementation of Compute_drdn() to compute the value of ∂R/∂n is:

```cpp
void Auger_Recombination::
Compute_drdn (const double t, const double n, const double p,
const double nie, const double f, double& drdn)
{ double r = C * (n + p) * (n*p - nie*nie);
  if (r < 0.0) {
    drdn = 0.0;
  } else {
    drdn = C * ((n*p - nie*nie) + (n + p) * p);
  }
}
```

Finally, you must provide a virtual constructor function, which allocates a variable of the new class:

```cpp
extern "C"
PMI_Recombination* new_PMI_Recombination (const PMI_Environment& env)
{ return new Auger_Recombination (env);
}
```

**NOTE** This function must have C linkage and exactly the same name as declared in the header file PMIModels.h.

## Simplified C++ Interface

PMI models that utilize the simplified C++ interface are referred to as *simplified PMI models*, and they need to implement essentially only one function that computes the numeric value of the quantity of interest at the actual vertex of the simulation mesh. Derivatives of the quantity with respect to input quantities can be extracted automatically.

Introduction to the Physical Model Interface

The following C++ types provide the appropriate interface:

*   Simplified PMI models use a special numeric data type `pmi_float` (see Numeric Data Type pmi_float).

*   Simplified PMI models are derived from the `PMI_Vertex_Common_Base` class, providing an interface at the scope of the PMI model (see Support at Model Scope on page 1195).

*   The main function of a simplified PMI model is called `compute` and has the form:

```cpp
void compute ( const Input& input, Output& output )
```

where `Input` is a class derived from the `PMI_Vertex_Input_Base` class, providing runtime support at the compute scope (see Support at Compute Scope on page 1197).

## Numeric Data Type pmi_float

The simplified interface is based on the data type `pmi_float`, which behaves similarly to a `double` and supports all of the usual arithmetic operations:

*   Assignment:

```cpp
pmi_float x = 2;
pmi_float y (x);
```

*   Unary operators:

```cpp
+x; -y;
```

*   Binary operators:

```cpp
x + y; x - y; x * y; x / y;
```

*   Comparisons:

```cpp
x == y; x != y; x < y; x <= y; x > y; x >= y;
```

*   Mathematical functions:

```cpp
abs(x); acos(x); acosh(x); asin(x); asinh(x); atan(x); atanh(x);
atan2(y,x); cos(x); cosh(x); erf(x); erfc(x); exp(x); expm1(x); hypot(x,y);
isinf(x); isnan(x); ldexp(x,exp); log(x); log1p(x); log10(x); pow(x,y);
pow_int(x,n); sin(x); sinh(x); sqrt(x); tan(x); tanh(x);
```

*   Output:

```cpp
std::cout << x;
```

The following static function returns the accuracy of the floating-point arithmetic:

```cpp
pmi_e_precision pmi_float::get_precision ()
```

The result is expressed as an enumeration type:

```cpp
enum pmi_e_precision {
  pmi_c_np, // normal precision (double): -ExtendedPrecision
  pmi_c_xp, // extended precision (long double): ExtendedPrecision
```

Introduction to the Physical Model Interface

```cpp
   pmi_c_dd, // double-double: ExtendedPrecision(128)
   pmi_c_qd, // quad-double: ExtendedPrecision(256)
   pmi_c_mp  // arbitrary precision: ExtendedPrecision(Digits=...)
 };
```

Because the class `pmi_float` supports automatic differentiation, it must store both the value of a variable and the gradient vector of the derivatives with respect to the independent variables. The following methods are available to read the value of a variable, the size of its gradient vector, and the components of the gradient vector:

```cpp
 template <class des_t_float> des_t_float get_value ();
 size_t size_gradient ();
 template <class des_t_float> des_t_float get_gradient (size_t i);
```

Additional methods are available to set the value of a variable or its gradient:

```cpp
 template <class des_t_float> void set_value (const des_t_float a);
 template <class des_t_float> void set_gradient (size_t i,
                                                  const des_t_float a);
```

**NOTE** These methods for reading and writing the value and the gradient of a variable are not necessary for most models. They might be useful in cases where automatic differentiation yields incorrect results.

## Pseudo-Implementation of a Simplified PMI Model

Compared to the standard C++ interface, the simplified C++ interface only requires the implementation of a single subroutine to evaluate the model. As in Example: Implementing Auger Recombination as New PMI Model on page 1168, this section discusses how Auger recombination can be implemented as a PMI model.

The header file `PMI.h` defines the following base class for recombination models:

```cpp
 class PMI_Recombination_Base : public PMI_Vertex_Base {

 public:
   class Input : public PMI_Vertex_Input_Base {
   public:
     pmi_float t;     // lattice temperature
     pmi_float n;     // electron density
     pmi_float p;     // hole density
     pmi_float nie;   // effective intrinsic density
     pmi_float f;     // absolute value of electric field
   };

   class Output {
   public:
     pmi_float r; // recombination rate
```

Introduction to the Physical Model Interface

```cpp
    };

    PMI_Recombination_Base (const PMI_Environment& env);
    virtual ~PMI_Recombination_Base ();

    virtual void compute (const Input& input, Output& output) = 0;
};
```

To implement a user model, you must first declare a derived class:

```cpp
#include "PMI.h"

class Auger_Recombination : public PMI_Recombination_Base {

private:
    double C;

public:
    Auger_Recombination (const PMI_Environment& env);
    ~Auger_Recombination ();

    virtual void compute (const Input& input, Output& output);
};
```

In the constructor, the variable C is initialized from the parameter file:

```cpp
Auger_Recombination::
Auger_Recombination (const PMI_Environment& env) :
    PMI_Recombination_Base (env)

{ C = InitParameter ("C", 1e-30);
}
```

The constructor is called for each region of the device to ensure that regionwise parameters are handled correctly.

Next, the actual Compute function must be implemented. It relies on the auxiliary classes Input and Output to read the input variables, and to store the recombination rate:

```cpp
void Auger_Recombination::
compute (const Input& input, Output& output)

{ output.r = C * (input.n + input.p) *
                 (input.n*input.p - input.nie*input.nie);
  if (output.r < 0.0) {
    output.r = 0.0;
  }
}
```

Introduction to the Physical Model Interface

Finally, a virtual constructor must be supplied to allocate instances of the class `Auger_Recombination`:

```cpp
extern "C"
PMI_Recombination_Base* new_PMI_Recombination_Base
  (const PMI_Environment& env)

{ return new Auger_Recombination (env);
}
```

> **NOTE** This function must have C linkage and exactly the same name as declared in the header file `PMI.h`.

It is possible to implement a model using both the standard and simplified interfaces within the same file. In this case, Sentaurus Device selects the version based on the floating-point precision:

*   The standard interface is selected for normal precision (64 bits), which ensures a performance similar to built-in models.

*   The simplified interface is selected for extended precision floating-point arithmetic. No loss of accuracy occurs when the PMI model is invoked.

> **NOTE** The simplified interface is ideally suited for prototyping a new model. No derivatives need to be implemented, which accelerates the development cycle. After a model has been validated, you can convert it easily into the standard interface for performance-critical applications.

As the simplified interface calculates the derivatives for you, it is easy to overlook cases where the expressions themselves are well defined, but their derivatives are not. Assume, for example, that your model computes $\sqrt{n - n_0}$, and you have ensured that $n - n_0$ cannot become negative. This is not enough because, when $n = n_0$, the derivative $1 / 2 \sqrt{n - n_0}$ becomes infinite.

> **NOTE** Ensure that not only the expressions you use, but also their derivatives are always valid.

## Nonlocal Interface

With the nonlocal interface model, values are computed based on nonlocal values of the input variables. For example, the generation–recombination rate in a vertex might depend on the carrier densities observed in a remote vertex.

A nonlocal interface provides more flexibility but, in turn, requires additional functionality in the user PMI code. You must implement separate C++ functions for the following purposes:

*   *Dependencies*: The variables on which the model depends must be declared, for example, electrostatic potential or carrier densities.

Introduction to the Physical Model Interface

*   *Structure of the Jacobian matrices*: For each input variable, the structure (stencil) of the corresponding Jacobian matrix must be declared. For example:

    model value in vertex 17 depends on:
    electrostatic potential in vertex 22
    electron density in vertex 55
    model value in vertex 18 depends on:
    hole density in vertex 35
    lattice temperature in vertex 44

*   *Model values and their derivatives*: The code must evaluate the model values and their derivatives with respect to all dependencies.

*   *Update of Jacobian matrices*: Optionally, the PMI can require an update in the structure of the Jacobian matrices. This can be useful if the model does not have purely geometric dependencies, but depends on the values of the solution as well. In this case, Sentaurus Device calls the PMI to request the updated structures of the Jacobian matrices.

Nonlocal PMIs are available with both the data type `double` (see Standard C++ Interface on page 1168) and the data type `pmi_float` (see Simplified C++ Interface on page 1171). However, the data type `pmi_float` is used only to support extended precision floating-point arithmetic. It is not used for the purpose of automatic differentiation.

## Jacobian Matrix

Sentaurus Device provides the classes `des_jacobian` (standard C++ interface) and `sdevice_jacobian` (simplified C++ interface) to represent Jacobian matrices. These classes are used to:

*   Define the structure of the Jacobian matrices, that is, the dependencies of the model values on the input variables

*   Store the derivatives of the model values with respect to the input variables

The size of a Jacobian matrix depends on the location of the model and the location of the input variable. The number of rows is determined by the location of the model. For example, the number of rows for a vertex-based model is given by the number of mesh vertices.

The supported locations are given by the type `des_data::des_location` (for the standard C++ interface):

```cpp
typedef
   enum { vertex, edge, element, rivertex, element_vertex } des_location;
```

and by the type `sdevice_data::sdevice_location` (for the simplified C++ interface):

```cpp
typedef
   enum { vertex, edge, element, rivertex, element_vertex } sdevice_location;
```

39: Physical Model Interface
Introduction to the Physical Model Interface

Similarly, the number of columns of a Jacobian matrix is determined by the location of the input variable. For example, the number of columns for an edge-based input variable is given by the number of mesh edges.

For a scalar model depending on a scalar input variable, each Jacobian entry is also a simple scalar. However, Sentaurus Device also supports the general case where the model value, or the input variable, or both are vector quantities. In this case, each entry in the Jacobian matrix becomes a small dense matrix of size number-of-inner-rows multiplied by number-of-inner-columns. The number of inner rows is given by the number of model values (1 for a scalar or the mesh dimension for vectors). Similarly, the number of inner columns is determined by the number of variable values (1 for a scalar or the mesh dimension for vectors).

The class `des_jacobian` provides the following methods:

```cpp
des_jacobian (int rows, int cols, int inner_rows, int inner_cols);

int size_rows () const;
int size_cols () const;
int size_inner_rows () const;
int size_inner_cols () const;
int size_matrix () const;

void define_element (int row, int col);
double* element (int row, int col);

des_jacobian_iterator begin ();
des_jacobian_iterator end ();
des_jacobian_iterator lower_bound (int row, int col);
des_jacobian_iterator upper_bound (int row, int col);

void set (double value);
```

> **NOTE** The class `sdevice_jacobian` for the simplified C++ interface provides the same methods, except that the data type `pmi_float` is used instead of `double`.

The constructor creates a new empty Jacobian matrix with the given dimensions.

The methods `size_rows()` and `size_cols()` return the number of rows and columns, respectively. Similarly, the methods `size_inner_rows()` and `size_inner_cols()` return the number of inner rows and inner columns, respectively. The method `size_matrix()` returns the number of nonzero elements in the Jacobian.

Use the method `define_element()` to define the location of a nonzero matrix element. The value of the nonzero entry remains unspecified at this point. However, the required storage is allocated.

Introduction to the Physical Model Interface

The method `element()` returns a pointer to an entry of the Jacobian matrix. A `NULL` pointer is returned for a nonexistent entry. The pointer defines the beginning of a dense matrix of size number-of-inner-rows multiplied by number-of-inner-columns. The entries in this matrix are stored in row-major order (C style). This means that the derivative of the *i*-th component of the result with respect to the *j*-th component of the input variable is stored in the location:

```
element() + i * size_inner_cols() + j
```

The functions `begin()` and `end()` return iterators to traverse the nonzero elements of the Jacobian matrix. A typical loop would be:

```cpp
des_jacobian J;
for (des_jacobian_iterator it = J.begin(); it != J.end(); it++) {
  int row = it.row();
  int col = it.col();
  double* value = it.val();
  // process element (row,col)
}
```

The functions `lower_bound()` and `upper_bound()` provide a way to quickly find a range of nonzero elements. The function `lower_bound()` returns an iterator to the first nonzero element not less than (row,col) in row-major order. Similarly, `upper_bound()` returns an iterator to the first nonzero element greater than (row,col) in row-major order. Both functions can return `end()` to indicate a nonexistent element.

The following code fragment visits all nonzero elements in row 25:

```cpp
des_jacobian J;
des_jacobian_iterator it_begin = J.lower_bound (25, 0);
des_jacobian_iterator it_end = J.lower_bound (26, 0);
for (des_jacobian_iterator it = it_begin; it != it_end; it++) {
  int row = it.row();
  int col = it.col();
  double* value = it.val();
  // process element (row,col)
}
```

The method `set()` can be used to initialize all matrix elements with a given value.

## Example: Point-to-Point Tunneling

For a nonlocal generation–recombination model, consider a simple point-to-point tunneling model between two vertices *v*<sub>1</sub> and *v*<sub>2</sub>. The model compares the electron and hole quasi-Fermi potentials in these two vertices. If Φ<sub>*n*, 1</sub> < Φ<sub>*p*, 2</sub>, then the tunneling rate *r* is computed as:

$$ r = Ae^{-B(E_{v, 2} - E_{c, 1})^2} \frac{\Delta}{1 + \Delta} $$ (1314)

**39: Physical Model Interface**
Introduction to the Physical Model Interface

where $E_C$ is the conduction band energy, $E_V$ is the valence band energy, and $\Delta = \Phi_{p, 2} - \Phi_{n, 1}$. Nonlocal transport is modeled by using the tunneling rate $r$ as an electron recombination rate in vertex 1 and a hole recombination rate in vertex 2.

Similarly, if $\Phi_{p, 1} > \Phi_{n, 2}$, then the tunneling rate $r$ is computed as:

$$ r = Ae^{-B(E_{C, 2} - E_{V, 1})^2} \frac{\Delta}{1 + \Delta} $$ (1315)

where $\Delta = \Phi_{p, 1} - \Phi_{n, 2}$. In this case, $r$ is used as a hole recombination rate in vertex 1 and as an electron recombination rate in vertex 2.

In the header file `PMIModels.h`, the following base class is defined for nonlocal generation–recombination models:

```cpp
class PMI_NonLocal_Recombination : public PMI_Device_Interface {

public:
  class Input {
  public:
    const des_region* region;        // all vertices belong to this region
    const std::vector<int>& vertices; // list of vertices
  };

  class Output {
  public:
    std::vector<double>& elec;       // nonlocal recombination rates (electrons)
    std::vector<double>& hole;       // nonlocal recombination rates (holes)
    des_id_to_jacobian_map& J_elec;  // derivatives (electrons)
    des_id_to_jacobian_map& J_hole;  // derivatives (holes)
  };

  PMI_NonLocal_Recombination (const PMI_Device_Environment& env);
  virtual ~PMI_NonLocal_Recombination ();

  virtual void
    DefineDependencies (std::vector<des_data::des_id>& dependencies) = 0;

  virtual void DefineJacobians (des_id_to_jacobian_map& J_elec,
                                des_id_to_jacobian_map& J_hole) = 0;

  virtual void Compute_parallel (const Input& input, Output& output) = 0;

  virtual bool NeedNewEdges () { return false; }
};
```

Introduction to the Physical Model Interface

To implement the point-to-point tunneling model, you must declare a derived class:

```cpp
#include "PMIModels.h"

class P2P_Recombination : public PMI_NonLocal_Recombination {

private:
    double A, B;                // model parameters
    int v1, v2;                 // vertex 1, vertex 2
    double measure1, measure2;  // semiconductor node measures for vertex 1 and 2

public:
    P2P_Recombination (const PMI_Device_Environment& env);

    void DefineDependencies (std::vector<des_data::des_id>& dependencies);
    void DefineJacobians (des_id_to_jacobian_map& J_elec,
                          des_id_to_jacobian_map& J_hole);
    void Compute_parallel (const PMI_NonLocal_Recombination::Input& input,
                           PMI_NonLocal_Recombination::Output& output);
    bool NeedNewEdges ();
};
```

The constructor of the derived class reads the model parameters and computes the semiconductor node measures for the two vertices v<sub>1</sub> and v<sub>2</sub>:

```cpp
P2P_Recombination::
P2P_Recombination (const PMI_Device_Environment& env) :
    PMI_NonLocal_Recombination (env)
{ A = InitParameter ("A", 1e25);
  B = InitParameter ("B", 50);
  v1 = InitParameter ("v1", 0);
  v2 = InitParameter ("v2", 1);

  const des_mesh* mesh = Mesh ();
  des_data* data = Data ();
  const double*const* measure = data->ReadMeasure ();

  // semiconductor node measure for vertex 1
  measure1 = 0;
  des_vertex* vertex1 = mesh->vertex (v1);
  for (size_t eli = 0; eli < vertex1->size_element (); eli++) {
      des_element* el = vertex1->element (eli);
      if (el->bulk ()->material () == "Silicon") {
          for (size_t vi = 0; vi < el->size_vertex (); vi++) {
              des_vertex* v = el->vertex (vi);
              if (v == vertex1) {
                  measure1 += measure [el->index()] [vi];
              }
          }
      }
  }
}
```

**39: Physical Model Interface**
Introduction to the Physical Model Interface

```cpp
    }

    // semiconductor node measure for vertex 2
    measure2 = 0;
    des_vertex* vertex2 = mesh->vertex (v2);
    for (size_t eli = 0; eli < vertex2->size_element (); eli++) {
        des_element* el = vertex2->element (eli);
        if (el->bulk ()->material () == "Silicon") {
            for (size_t vi = 0; vi < el->size_vertex (); vi++) {
                des_vertex* v = el->vertex (vi);
                if (v == vertex2) {
                    measure2 += measure [el->index()] [vi];
                }
            }
        }
    }
}
```

The `InitParameter()` method for reading a parameter is documented in Runtime Support for Vertex-Based PMI Models on page 1194. Similarly, the functions for accessing the device mesh are discussed in Runtime Support for Mesh-Based PMI Models on page 1203.

The semiconductor node measures are used later in the `Compute_parallel()` method. They are necessary to ensure current conservation for arbitrary meshes.

The method `DefineDependencies()` defines the variables that will be read later when `Compute_parallel()` is invoked:

```cpp
void P2P_Recombination::
DefineDependencies (std::vector<des_data::des_id>& dependencies)
{ dependencies.push_back (des_data::des_id (des_data::scalar,
                                            des_data::vertex,
                                            "eQuasiFermiPotential"));
  dependencies.push_back (des_data::des_id (des_data::scalar,
                                            des_data::vertex,
                                            "hQuasiFermiPotential"));
  dependencies.push_back (des_data::des_id (des_data::scalar,
                                            des_data::vertex,
                                            "ConductionBandEnergy"));
  dependencies.push_back (des_data::des_id (des_data::scalar,
                                            des_data::vertex,
                                            "ValenceBandEnergy"));
}
```

Introduction to the Physical Model Interface

The tables in Appendix F on page 1479 list the variables that are available to all mesh-based PMIs. However, the following restrictions must be observed with regard to nonlocal models:

*   Constant fields such as doping concentration, mole fraction concentrations, stress fields, and PMI user fields can be used without restrictions. No dependencies need to be defined in `DefineDependencies()`, and no derivatives need to be computed.

*   Nonlocal PMIs can use only certain solution-dependent fields. Table 185 lists the subset of variables that are supported.

Table 185 Solution-dependent data available to nonlocal PMI models

| Data name | Type | Location | Description |
| --- | --- | --- | --- |
| BandGap | scalar | vertex | Intrinsic band gap $E_g$ |
| BandgapNarrowing | scalar | vertex | Bandgap narrowing $E_{bgn}$ |
| ConductionBandEnergy | scalar | element_vertex | Conduction band energy $E_C$ |
| vertex |  |  |  |
| eDensity | scalar | vertex | Electron density $n$ |
| eEffectiveStateDensity | scalar | vertex | Conduction band density-of-states (DOS) $N_C$ |
| EffectiveIntrinsicDensity | scalar | vertex | Effective intrinsic density $n_{i, \text{eff}}$ |
| ElectricField | scalar | element | Electric field $F$ |
| vertex |  |  |  |
| vector | element |  |  |
| vertex |  |  |  |
| ElectronAffinity | scalar | vertex | Electron affinity $\chi$ |
| ElectrostaticPotential | scalar | vertex | Electrostatic potential $\phi$ |
| eQuasiFermiPotential | scalar | vertex | Electron quasi-Fermi potential $\Phi_n$ |
| eRelativeEffectiveMass | scalar | vertex | Electron DOS mass $m_n$ |
| eTemperature | scalar | vertex | Electron temperature $T_n$ |
| hDensity | scalar | vertex | Hole density $p$ |
| hEffectiveStateDensity | scalar | vertex | Valence band DOS $N_V$ |
| hQuasiFermiPotential | scalar | vertex | Hole quasi-Fermi potential $\Phi_p$ |
| hRelativeEffectiveMass | scalar | vertex | Hole DOS mass $m_p$ |
| hTemperature | scalar | vertex | Hole temperature $T_p$ |

39: Physical Model Interface
Introduction to the Physical Model Interface

Table 185 Solution-dependent data available to nonlocal PMI models (Continued)

| Data name | Type | Location | Description |
| --- | --- | --- | --- |
| InsulatorElectricField | scalar | vertex | Electric field $F$ on insulator |
| vector |  |  |  |
| IntrinsicDensity | scalar | vertex | Intrinsic density $n_i$ |
| LatticeTemperature | scalar | vertex | Lattice temperature $T$ |
| SemiconductorElectricField | scalar | vertex | Electric field $F$ on semiconductor |
| vector |  |  |  |
| SemiconductorGradValencebandEnergy | scalar | element | Gradient of valence band energy $\nabla E_V$ |
| vector |  |  |  |
| ValenceBandEnergy | scalar | element_vertex | Valence band energy $E_V$ |
| vertex |  |  |  |

The method `DefineJacobians()` must perform the following operations:

* Allocate all Jacobian matrices with the correct dimensions (see Jacobian Matrix on page 1176).

* Define the nonzero elements in all Jacobian matrices. All nonzero derivatives that will be computed later in the method `Compute_parallel()` must be defined at this point. The method `Compute_parallel()` cannot allocate additional nonzero entries.

For the point-to-point tunneling model, the method `DefineJacobians()` would be:

```cpp
void P2P_Recombination::
DefineJacobians (des_id_to_jacobian_map& J_elec,
                 des_id_to_jacobian_map& J_hole)
{ const des_mesh* mesh = Mesh ();
  const int n_vertices = mesh->size_vertex ();

  // allocate Jacobians
  des_jacobian*& J_elec_eQF = J_elec [des_data::des_id
              (des_data::scalar, des_data::vertex, "eQuasiFermiPotential")];
  des_jacobian*& J_elec_hQF = J_elec [des_data::des_id
              (des_data::scalar, des_data::vertex, "hQuasiFermiPotential")];
  des_jacobian*& J_elec_EC = J_elec [des_data::des_id
              (des_data::scalar, des_data::vertex, "ConductionBandEnergy")];
  des_jacobian*& J_elec_EV = J_elec [des_data::des_id
              (des_data::scalar, des_data::vertex, "ValenceBandEnergy")];

  des_jacobian*& J_hole_eQF = J_hole [des_data::des_id
              (des_data::scalar, des_data::vertex, "eQuasiFermiPotential")];
  des_jacobian*& J_hole_hQF = J_hole [des_data::des_id
```

Introduction to the Physical Model Interface

```cpp
        (des_data::scalar, des_data::vertex, "hQuasiFermiPotential")];
des_jacobian*& J_hole_EC = J_hole [des_data::des_id
        (des_data::scalar, des_data::vertex, "ConductionBandEnergy")];
des_jacobian*& J_hole_EV = J_hole [des_data::des_id
        (des_data::scalar, des_data::vertex, "ValenceBandEnergy")];

J_elec_eQF = new des_jacobian (n_vertices, n_vertices, 1, 1);
J_elec_hQF = new des_jacobian (n_vertices, n_vertices, 1, 1);
J_elec_EC  = new des_jacobian (n_vertices, n_vertices, 1, 1);
J_elec_EV  = new des_jacobian (n_vertices, n_vertices, 1, 1);

J_hole_eQF = new des_jacobian (n_vertices, n_vertices, 1, 1);
J_hole_hQF = new des_jacobian (n_vertices, n_vertices, 1, 1);
J_hole_EC  = new des_jacobian (n_vertices, n_vertices, 1, 1);
J_hole_EV  = new des_jacobian (n_vertices, n_vertices, 1, 1);

// define nonzero entries in Jacobians
J_elec_eQF->define_element (v1, v1);
J_elec_eQF->define_element (v2, v2);

J_elec_hQF->define_element (v1, v2);
J_elec_hQF->define_element (v2, v1);

J_elec_EC->define_element (v1, v1);
J_elec_EC->define_element (v2, v2);

J_elec_EV->define_element (v1, v2);
J_elec_EV->define_element (v2, v1);

J_hole_eQF->define_element (v1, v2);
J_hole_eQF->define_element (v2, v1);

J_hole_hQF->define_element (v1, v1);
J_hole_hQF->define_element (v2, v2);

J_hole_EC->define_element (v1, v2);
J_hole_EC->define_element (v2, v1);

J_hole_EV->define_element (v1, v1);
J_hole_EV->define_element (v2, v2);
}
```

The method `Compute_parallel()` computes the electron and hole recombination rates and their derivatives. It can be called during the parallel assembly in Sentaurus Device. Therefore, it must be implemented in a thread-safe manner. During each call, only the model values and their derivatives for the vertices appearing in the vector `Input::vertices` must be computed.

1184

39: Physical Model Interface
Introduction to the Physical Model Interface

The recombination rates are multiplied by the semiconductor node measure of the source vertex. This ensures current conservation for arbitrary meshes.

```cpp
void P2P_Recombination::
Compute_parallel (const PMI_NonLocal_Recombination::Input& input,
PMI_NonLocal_Recombination::Output& output)
{ des_data* data = Data ();

  const double* eQF =
    data->ReadScalar (des_data::vertex, "eQuasiFermiPotential");
  const double* hQF =
    data->ReadScalar (des_data::vertex, "hQuasiFermiPotential");
  const double* EC =
    data->ReadScalar (des_data::vertex, "ConductionBandEnergy");
  const double* EV =
    data->ReadScalar (des_data::vertex, "ValenceBandEnergy");

  des_jacobian* J_elec_eQF = output.J_elec [des_data::des_id
    (des_data::scalar, des_data::vertex, "eQuasiFermiPotential")];
  des_jacobian* J_elec_hQF = output.J_elec [des_data::des_id
    (des_data::scalar, des_data::vertex, "hQuasiFermiPotential")];
  des_jacobian* J_elec_EC = output.J_elec [des_data::des_id
    (des_data::scalar, des_data::vertex, "ConductionBandEnergy")];
  des_jacobian* J_elec_EV = output.J_elec [des_data::des_id
    (des_data::scalar, des_data::vertex, "ValenceBandEnergy")];

  des_jacobian* J_hole_eQF = output.J_hole [des_data::des_id
    (des_data::scalar, des_data::vertex, "eQuasiFermiPotential")];
  des_jacobian* J_hole_hQF = output.J_hole [des_data::des_id
    (des_data::scalar, des_data::vertex, "hQuasiFermiPotential")];
  des_jacobian* J_hole_EC = output.J_hole [des_data::des_id
    (des_data::scalar, des_data::vertex, "ConductionBandEnergy")];
  des_jacobian* J_hole_EV = output.J_hole [des_data::des_id
    (des_data::scalar, des_data::vertex, "ValenceBandEnergy")];

  // compute electron and hole recombination for vertices in input domain
  for (size_t vi = 0; vi < input.vertices.size (); vi++) {
    const int v = input.vertices [vi];
    if (v == v1 || v == v2) {
      const int v_other = (v == v1) ? v2 : v1;
      const double weight = (v == v1) ? measure2 : measure1;

      if (eQF [v] < hQF [v_other]) {
        double delta = hQF [v_other] - eQF [v]; // delta > 0
        double rate = A * exp (-B * (EV [v_other] - EC [v]) *
                                    (EV [v_other] - EC [v])) *
                        delta / (1 + delta);
        double elec = weight * rate;
```

Introduction to the Physical Model Interface

```cpp
        // electron recombination
        output.elec [v] += elec;

        // derivatives
        double deriv_QF = elec / (delta * (1 + delta));
        double deriv_ECEV = 2 * elec * B * (EV [v_other] - EC [v]);
        *J_elec_eQF->element (v, v) -= deriv_QF;
        *J_elec_hQF->element (v, v_other) += deriv_QF;
        *J_elec_EC->element (v, v) += deriv_ECEV;
        *J_elec_EV->element (v, v_other) -= deriv_ECEV;
    }

    if (hQF [v] > eQF [v_other]) {
        double delta = hQF [v] - eQF [v_other]; // delta > 0
        double rate = A * exp (-B * (EC [v_other] - EV [v]) *
                                    (EC [v_other] - EV [v])) *
                      delta / (1 + delta);
        double hole = weight * rate;

        // hole recombination
        output.hole [v] += hole;

        // derivatives
        double deriv_QF = hole / (delta * (1 + delta));
        double deriv_ECEV = 2 * hole * B * (EC [v_other] - EV [v]);
        *J_hole_eQF->element (v, v_other) -= deriv_QF;
        *J_hole_hQF->element (v, v) += deriv_QF;
        *J_hole_EC->element (v, v_other) -= deriv_ECEV;
        *J_hole_EV->element (v, v) += deriv_ECEV;
    }
}
```

In this example, the dependencies of the model do not change as a function of the solution. Therefore, the method `NeedNewEdges()` simply returns false:

```cpp
bool P2P_Recombination::
NeedNewEdges ()
{ return false; // nonlocal edges do not depend on solution
}
```

Finally, you must provide a virtual constructor function that allocates a variable of the new class:

```cpp
extern "C"
PMI_NonLocal_Recombination*
  new_PMI_NonLocal_Recombination (const PMI_Device_Environment& env)
```

1186

Introduction to the Physical Model Interface

```cpp
{ return new P2P_Recombination (env);
}
```

**NOTE** This function must have C linkage and exactly the same name as declared in the header file `PMIModels.h`.

The example in this section uses the data type `double` according to the standard C++ interface defined in the header file `PMIModels.h`. Alternatively, the simplified C++ interface defined in the header file `PMI.h` uses the data type `pmi_float` to support extended-precision floating-point arithmetic.

You can implement a nonlocal model using both the standard and simplified interfaces in the same file. In this case, Sentaurus Device selects the version based on the floating-point precision:

* The standard interface is selected for normal precision (64 bits). This ensures a performance similar to built-in models.

* The simplified interface is selected for extended-precision floating-point arithmetic. No loss of accuracy occurs when the PMI model is invoked.

## Shared Object Code

Sentaurus Device assumes that the shared object code corresponding to a PMI model can be found in the file `modelname.so.arch`. The base name of this file must be identical to the name of the PMI model. The extension `.arch` depends on the hardware architecture.

The script `cmi`, which is also a part of the CMI, can be used to produce the shared object files (see Compact Models User Guide, Runtime Support on page 154).

## Command File of Sentaurus Device

To load PMI models into Sentaurus Device, the `PMIPath` search path must be defined in the `File` section of the command file. The value of `PMIPath` consists of a sequence of directories. For example:

```
File { PMIPath = ". /home/joe/lib /home/mary/sdevice/lib" }
```

For each PMI model that appears in the `Physics` section, the given directories are searched for a corresponding shared object file `modelname.so.arch`.

The PMI in Sentaurus Device provides access to mesh-based scalar fields specified by you. These fields must be defined on the device grid in a separate TDR (`.tdr`) data file. Up to 300 datasets (`PMIUserField0`, ..., `PMIUserField299`) can be defined.

Introduction to the Physical Model Interface

Sentaurus Device reads the user-defined fields if the corresponding file name is given in the command file:

```
File { PMIUserFields = "fields" }
```

You activate a PMI model in the Physics section of the command file by specifying the name of the PMI model in the appropriate part of the Physics section. Examples for different types of PMI models are:

*   Generation–recombination models:

```
Physics { Recombination (pmi_model_name ...) }
```

*   Avalanche generation:

```
Physics { Recombination (Avalanche (pmi_model_name ...)) }
```

*   Mobility models:

```
Physics {
 Mobility (
  DopingDependence (pmi_model_name)
  Enormal (pmi_model_name)
  ToCurrentEnormal (pmi_model_name)
  HighFieldSaturation (pmi_model_name driving_force)
 )
}
```

A PMI model name can only consist of alphanumeric characters and underscores (_). The first character must be either a letter or an underscore. A PMI model name can also be quoted as "model_name" to avoid conflicts with Sentaurus Device keywords.

All PMI models can be specified regionwise or materialwise. For example:

```
Physics (region = "Region.1") { ... }

Physics (material = "AlGaAs") { ... }
```

PMI models also recognize parameters in the command file. Usually, command file parameters are listed in parentheses after the model name. For example:

```
Physics {
 Recombination (pmi_model_name (a = 1
                                 b = "string"
                                 c = (1.2 3.4 5.6 7.8)
                                 d = ("red" "blue" "green")))
}
```

For certain models, the syntax differs from the previous example, and this is noted in the documentation (see Appendix G on page 1507).

39: Physical Model Interface
Introduction to the Physical Model Interface

**NOTE** PMI model parameters also can be specified in the parameter file (see Parameter File of Sentaurus Device on page 1189). Parameters in the command file take precedence over parameters in the parameter file.

Certain values of PMI models can be plotted in the `Plot` section of the command file. The following identifiers are recognized:

*   Generation–recombination models:

```
Plot {
  PMIRecombination
  PMIeNonLocalRecombination PMIhNonLocalRecombination
}
```

*   User-defined fields:

```
Plot { PMIUserField0 PMIUserField1 ... PMIUserField299 }
```

*   Piezoelectric polarization:

```
Plot { PE_Polarization/vector PE_Charge }
```

*   Metal conductivity (see Metal Resistivity on page 1395):

```
Plot { MetalConductivity }
```

The current plot PMI can be used to add entries to the current plot file:

```
CurrentPlot { pmi_CurrentPlot }
```

# Parameter File of Sentaurus Device

For each PMI model, a corresponding section with the same name can appear in the parameter file:

```
PMI_model_name {
  par₁ = value
  par₂ = value
  ...
}
```

**NOTE** Parameter names consist only of alphanumeric characters and underscores (\_). The first character must be either a letter or an underscore.

Parameters can be numbers, or strings, or arrays of numbers or strings:

```
PMI_model_name {
  a = 1
  b = "string"
```

Introduction to the Physical Model Interface

```
  c = (1.2 3.4 5.6 7.8)
  d = ("red" "blue" "green")
}
```

**NOTE** Arrays must consist of either numbers or strings only. Mixed arrays containing both numbers and strings are not supported. An empty array, such as `c=()`, is considered a numeric array of size 0.

Parameters can be specified regionwise and materialwise:

```
Region = "Region.1" {
  PMI_model_name {
    ...
  }
}
Material = "AlGaAs" {
  PMI_model_name {
    ...
  }
}
```

You can use the method `ReadParameter()` to obtain the value of a parameter given its name. This method returns a pointer to a variable of type `PMIBaseParam`:

```cpp
const PMIBaseParam* p = ReadParameter ("name of parameter");
```

A NULL pointer indicates that the parameter has not been defined in the parameter file. Otherwise, the method `PMIBaseParam::ValueType()` returns the value type (`PMIBaseParam::real` or `PMIBaseParam::string`) of the parameter. Similarly, the method `PMIBaseParam::DataType()` returns the data type (`PMIBaseParam::scalar` or `PMIBaseParam::vector`) of the parameter. In the case of an array parameter, the size of the array can be obtained by:

```cpp
PMIBaseParam::size()
```

The size of scalar parameters is always 1.

Depending on the type of a parameter, its value can be accessed through an assignment statement:

```cpp
double a = *p;              // real, scalar
double b = (*p) [index];    // real, vector
const char* c = *p;         // string, scalar
const char* d = (*p) [index]; // string, vector
```

An error occurs if the type of a parameter is incompatible with the left-hand side in the assignment statement.

**39: Physical Model Interface**

Introduction to the Physical Model Interface

In the case of a real scalar parameter, the method `InitParameter()` checks whether the parameter has been specified in the parameter file:

```cpp
double value = InitParameter ("pi", 3.14159);
```

If the parameter has been specified, then the given value is taken. Otherwise, the default value is used.

An alternative version of `InitParameter()` is available for vector-valued parameters:

```cpp
std::vector<double> v;
v.push_back (-1);          // default value
v.push_back (-2);          // default value
InitParameter ("vec", v);
```

If the parameter `vec` is found in the parameter file, then the vector `v` is redefined with the new values. Otherwise, the existing default values in `v` are left unchanged.

Variants of these two methods are also available for string parameters:

```cpp
const char* value = InitStringParameter ("scalar string", "default value");
std::vector<const char*> s;
InitStringParameter ("vector string parameter", s);
```

> **NOTE** PMI model parameters also can be specified in the command file (see Command File of Sentaurus Device on page 1187). Parameters in the command file take precedence over parameters in the parameter file.

# Parallelization

During a parallel simulation, Sentaurus Device can invoke a PMI model concurrently from different threads. Therefore, the computational functions must be implemented in a thread-safe manner.

The following rules guarantee a thread-safe PMI:

* Do not use global variables.

* Class variables are only modified in the constructor and destructor. Class variables can be read in the computational functions, but they must not be modified.

* Within the computational functions, all temporary variables are allocated as either automatic variables or dynamic variables with the help of the `new` and `delete` operators.

Introduction to the Physical Model Interface

## Thread-Local Storage

The thread-local storage template class `PMI_TLS` provides a mechanism to store data per thread. This can be useful to optimize the runtime performance of a PMI. Consider an example where a large data structure is allocated and deallocated with each compute call:

```cpp
class Recombination : public PMI_Recombination_Base {
public:
  ...
  void compute (const Input& input, Output& output)
  {
    BigData data;
    data.initialize ();
    // compute output
  }
};
```

With the help of the template class `PMI_TLS`, a copy of `BigData` is allocated for each thread on demand:

```cpp
class Recombination : public PMI_Recombination_Base {
private:
  PMI_TLS<BigData> Data;

public:
  ...
  void compute (const Input& input, Output& output)
  {
    bool exists;
    BigData& data = Data.local (exists);
    if (!exists) {
      data.initialize ();
    }
    // compute output
  }
};
```

The function call `Data.local(exists)` creates a new instance of `BigData` for each thread if it does not exist already. The argument `exists` is used to check whether data has been freshly allocated. In this case, data is initialized. Otherwise, it was already initialized in a previous `compute()` call.

The template class `PMI_TLS` is declared as follows:

```cpp
template <typename T> class PMI_TLS {
public:
  T& local (bool& exists);
  T& local ();
```

**39: Physical Model Interface**
Introduction to the Physical Model Interface

```cpp
  size_t size () const;
  T& operator [] (size_t index);
};
```

Both variants of the method `local()` return a reference to a thread-local element. The optional argument `exists` indicates whether the element has been newly allocated (`false`) or was already present (`true`).

The function `size()` returns the number of allocated elements. You can use the array access operator `[]` to iterate over the elements of the container.

**NOTE** The array access operator `[]` should only be used in a sequential section of the code. For example, it can be used in the destructor of the PMI.

# Debugging Physical Model Interfaces

Print statements represent the simplest approach for debugging a PMI. They can be inserted anywhere in the code to print the values of a variable. For example:

```cpp
void Auger_Recombination::
compute (const Input& input, Output& output)

{ output.r = C * (input.n + input.p) *
              (input.n*input.p - input.nie*input.nie);
  if (output.r < 0.0) {
    output.r = 0.0;
  }
  std::cout << "n   = " << input.n << std::endl;
  std::cout << "p   = " << input.p << std::endl;
  std::cout << "nie = " << input.nie << std::endl;
  std::cout << "r   = " << output.r << std::endl;
}
```

You also can use a debugger to catch errors in a PMI subroutine. The following instructions apply to `gdb`, the GNU debugger. The same approach also can be adjusted to work with other debuggers:

1. Compile the PMI source code in debug mode by using the `-g` option:

```bash
cmi -g pmi_Auger.C
```

2. Determine the name of the Sentaurus Device binary. The command:

```bash
sdevice -@ldd
```

should produce output similar to the following:

```bash
path to executable: /usr/sentaurus/tcad/S-2021.06/linux64/bin
```

Introduction to the Physical Model Interface

```
executable: sdevice-32.0.1098

/usr/sentaurus/tcad/S-2021.06/linux64/bin/sdevice-32.0.1098:
  ELF 64-bit LSB executable, x86-64, version 1 (GNU/Linux), dynamically
  linked (uses shared libs), for GNU/Linux 2.6.18, stripped
```

In this example, `/usr/sentaurus/tcad/S-2021.06/linux64/bin/sdevice-32.0.1098` is the name of the Sentaurus Device binary.

3. Start the debugger `gdb` on the Sentaurus Device binary:

```
gdb /usr/sentaurus/tcad/S-2021.06/linux64/bin/sdevice-32.0.1098
```

4. Verify the setting of the environment variables:

```
show environment
```

In particular, the variables `STROOT` and `STRELEASE` must be defined properly. If necessary, use the following `gdb` command to define these variables:

```
set environment STROOT /usr/sentaurus
set environment STRELEASE S-2021.06
```

5. You cannot define a break point in the PMI code until the corresponding shared object file has been loaded. Therefore, run your simulation:

```
run pp1_des.cmd
```

Watch for messages regarding the loading of shared object files. All the shared object files for PMIs are loaded at the very beginning, usually within seconds of starting Sentaurus Device. Afterwards, use the shortcut keys Ctrl+C to interrupt the simulation.

6. Define a break point in the PMI source code. For example:

```
break pmi_Auger.C:100
```

This command inserts a break point on line 100 in the `pmi_Auger.C` file.

7. After defining all required break points, resume the simulation with the command:

```
continue
```

The debugger will now stop whenever the control flow reaches a break point, and all the standard `gdb` commands are available for debugging.

# Runtime Support for Vertex-Based PMI Models

Inside vertex-based PMI models, you can access several functions described here. Essentially, they are split into two groups, namely, functions that are valid at the scope of the PMI model and functions that are valid only within the scope of `compute` functions.

39: Physical Model Interface

Introduction to the Physical Model Interface

# Support at Model Scope

A standard vertex-based PMI is derived from the base class `PMI_Vertex_Interface`; whereas, a simplified vertex-based PMI is derived from the base class `PMI_Vertex_Base`. Both base classes are derived from the `PMI_Vertex_Common_Base` class and provide the following shared functionality:

```cpp
const char* Name () const;
const char* Filename () const;
const char* ReadRegionName () const;
const char* ReadRegionMaterial () const;
des_materialgroup ReadRegionMaterialGroup () const;

const char* ReadDeviceName () const;

const PMIBaseParam* ReadParameter (const char* name
                               [, const char* modelName]) const;
double InitParameter (const char* name, double defaultvalue
               [, const char* modelName]) const;
void InitParameter (const char* name, std::vector<double>& value
               [, const char* modelName]) const;
const char* InitStringParameter (const char* name,
                               const char* defaultvalue
                               [, const char* modelName]) const;
void InitStringParameter (const char* name,
                std::vector<const char*>& value
                [, const char* modelName]) const;
void double InitModelParameter (const char* name,
               const char* modelName,
               double defaultvalue);
void double InitOptoModelParameter(const char* name, double defaultvalue);

int ReadDimension () const;
void ReadReferenceCoordinates (double ref [3][3]) const;

size_t NumberOfMSConfigStates (const std::string& msconfig_name) const;
const std::string& MSConfigStateName (const std::string& msconfig_name,
                                     size_t state_index) const;
des_loginfo* LogData () const;
```

The method `Name()` returns the name of the PMI model as specified in the command file. Similarly, `Filename()` returns the name of the corresponding shared object file.

For the current region, call `ReadRegionName()` to determine its name, `ReadRegionMaterial()` to return the name of the region material, and `ReadRegionMaterialGroup()` to find the material group.

Introduction to the Physical Model Interface

The possible values for the material group are:

```
PMI_Vertex_Common_Base::conductor
PMI_Vertex_Common_Base::insulator
PMI_Vertex_Common_Base::semiconductor
PMI_Vertex_Common_Base::unknown
```

ReadDeviceName() returns the name of the device.

The methods ReadParameter(), InitParameter(), and InitStringParameter() read the value of a parameter from the parameter file or command file (see Parameter File of Sentaurus Device on page 1189 and Command File of Sentaurus Device on page 1187). In these methods, modelName is an optional argument that allows the value of a parameter to be read from a different PMI model.

The method InitModelParameter() allows PMI access to any built-in Sentaurus Device mole-fraction or constant parameters. modelName specifies the built-in model and name is the parameter within the specified model. When no valid model name or parameter name is found, the provided defaultvalue is returned instead. InitModelParameter is available only in the Compute function not in the PMI constructor. Similarly, the InitOptoModelParameter() method gives the PMI access to built-in numeric optoelectronic parameters. In this case, name is the full path to the parameter. ReadDimension() returns the dimension of the problem.

> **NOTE** The InitModelParameter() and InitOptoModelParameter() methods only support access to scalar parameters. You cannot access a specific component of a vector entry such as Physics/Optics/OpticalGeneration/TimeDependence/WaveTime.

The method ReadReferenceCoordinates() provides access to the reference coordinate system. It will return the identity matrix:

$$ \text{ref} = \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \end{bmatrix} \eqno(1316) $$

in the case of the unified coordinate system (UCS). Otherwise, another coordinate system matrix is returned.

Multistate configuration–dependent models can call the NumberOfMSConfigStates() and MSConfigStateName() methods. They return the number of states and the name of a state, respectively.

The function LogData() returns the des_loginfo class, which can be used to print messages from PMI functions to the log file (see Runtime Support to Write PMI Output to Log File on page 1216).

39: Physical Model Interface

Introduction to the Physical Model Interface

## Reaction–Diffusion Species Interface (Model Scope)

The interface to reaction–diffusion (RD) species is the same for both standard and simplified PMI models, as it is provided in the common base class `PMI_Vertex_Common_Base`.

The interface provides the following functions:

*   `size_t RDSpecies_size()` returns the number of RD species defined for the actual device. Note that not all of these species need to be defined in the actual device region.

*   `void get_RDSpecies_name (size_t isp, std::string& spname)` returns the name of the species with device index `isp`.

*   `bool RDSpecies_is_defined (size_t isp)` returns true if the species with device index `isp` is defined in the actual region.

For simplified PMI models, the values for RD species concentrations can be extracted in the compute function from the `Input` interface (see Reaction–Diffusion Species Interface (Compute Scope) on page 1201 on page 1201)).

> **NOTE** Standard PMI models do not have such an interface, that is, accessing RD species concentrations is not supported in this interface. However, within all PMI models, you can read such values using the `ReadScalar(const char*)` function.

## Support at Compute Scope

The following interface functions depend on the local vertex where a model is evaluated. They are not available in the constructor of the PMI, but should only be called in the `Compute` function. In the case of the standard interface, these functions are a part of the base class `PMI_Vertex_Interface`; whereas, the simplified interface provides them through the base class `PMI_Vertex_Input_Base`:

```cpp
void ReadCoordinate (double& x, double& y, double& z) const;
void ReadNearestInterfaceNormal (double& nx, double& ny, double& nz) const;
double ReadDistanceFromSemiconductorInsulatorInterface() const;
double ReadDistanceFromSemiSemiInterface() const;
double ReadDistanceFromHighkInsulator() const;
int ReadNearestInterfaceOrientation() const;

double ReadLayerThickness () const;
double ReadLayerThicknessField () const;

double ReadTime () const;
double ReadTransientStepSize () const;
PMI_StepType ReadTransientStepType () const;

double ReadxMoleFraction () const;
```

Introduction to the Physical Model Interface

```cpp
double ReadyMoleFraction () const;

double ReadDoping (PMI_DopingSpecies species) const;
double ReadDoping (const char* SpeciesName) const;

double ReadDielectricConstant() const;
double ReadSemiconductorDielectricConstant() const;

int ReadDopingWell () const;

int IsUserFieldDefined (PMI_UserFieldIndex index) const;
double ReadUserField (PMI_UserFieldIndex index) const;
void WriteUserField (PMI_UserFieldIndex index, double value) const;

double ReadStress (PMI_StressIndex index) const;

bool ReadMSCOccupations (const std::string& msc_name, double* values) const;

double ReadeSHEDistribution (double energy) const;
double ReadhSHEDistribution (double energy) const;
double ReadeSHETotalDOS (double energy) const;
double ReadhSHETotalDOS (double energy) const;
double ReadeSHETotalGSV (double energy) const;
double ReadhSHETotalGSV (double energy) const;
```

**NOTE** The support functions for the simplified interface use the data type `pmi_float`; whereas, the support functions for the standard interface use the data type `double`. However, their functionality is identical, and only the `double` version is documented.

The function `ReadCoordinate()` provides the coordinates of the current vertex [$\mu$m].

The function `ReadNearestInterfaceNormal()` provides the components of a unit vector in the direction of the nearest interface normal.

`ReadDistanceFromSemiconductorInsulatorInterface()` returns the distance of the current vertex to the nearest semiconductor–insulator interface (in $\mu$m) if the current vertex is in a semiconductor region; otherwise, the function returns minus that distance.

`ReadDistanceFromSemiSemiInterface()` returns the distance of the current vertex to the nearest semiconductor–semiconductor interface (in $\mu$m). If no semiconductor–semiconductor interface is found in the structure, then the function returns a value < 0.

`ReadDistanceFromHighkInsulator()` returns the distance of the current vertex to the nearest high-k insulator (in $\mu$m). If no high-k insulator is found in the structure, then the function returns a value < 0.

Introduction to the Physical Model Interface

`ReadNearestInterfaceOrientation()` returns the auto-orientation framework orientation (as a three-digit integer) that is closest to the actual orientation at the nearest interface vertex (see Auto-Orientation Framework on page 38).

`ReadLayerThickness()` returns the value of the `LayerThickness` array [$\mu$m] for the current vertex (see Extracting Layer Thickness on page 333).

`ReadLayerThicknessField()` returns the value of the `LayerThicknessField` array [$\mu$m] for the current vertex (see Extracting Layer Thickness on page 333).

The functions `ReadTime()` and `ReadTransientStepSize()` return the simulation time and the current step size during a transient simulation [s]. `ReadTransientStepType()` provides access to the actual transient step type.

The enumeration type `PMI_StepType` is defined for identification:

```cpp
enum PMI_StepType {
  PMI_UndefStepType = 0,
  PMI_TR = 1,
  PMI_BDF = 2,
  PMI_BE = 3
}
```

The methods `ReadxMoleFraction()` and `ReadyMoleFraction()` return the x– and y–mole fractions, respectively.

The methods `ReadDoping(species)` and `ReadDoping(SpeciesName)` return the doping profiles for the current vertex [cm<sup>–3</sup>]. The string `SpeciesName` is the same as in the file `datexcodes.txt` (see Specifying Doping Species on page 12). The enumeration type `PMI_DopingSpecies` is used to select the doping species, the incomplete ionization doping species, and their derivatives:

```cpp
enum PMI_DopingSpecies {
  // Acceptors
  PMI_BoronActive,             // active Boron concentration
  PMI_BoronChemical,           // chemical Boron concentration
  PMI_AluminumActive,          // active Aluminum concentration
  PMI_AluminumChemical,        // chemical Aluminum concentration
  PMI_IndiumActive,            // active Indium concentration
  PMI_IndiumChemical,          // chemical Indium concentration
  PMI_PDopantActive,           // active PDopant concentration
  PMI_PDopantChemical,         // chemical PDopant concentration
  PMI_Acceptor,                // total acceptor concentration

  // incomplete ionization entries
  PMI_AcceptorMinus,           // total incomplete ionization acceptor concentration
  PMI_AcceptorMinusPer_hDensity,
```

Introduction to the Physical Model Interface

```cpp
    PMI_AcceptorMinusPerT,

    // Donors
    PMI_PhosphorusActive,       // active Phosphorus concentration
    PMI_PhosphorusChemical,     // chemical Phosphorus concentration
    PMI_ArsenicActive,          // active Arsenic concentration
    PMI_ArsenicChemical,        // chemical Arsenic concentration
    PMI_AntimonyActive,         // active Antimony concentration
    PMI_AntimonyChemical,       // chemical Antimony concentration
    PMI_NitrogenActive,         // active Nitrogen concentration
    PMI_NitrogenChemical,       // chemical Nitrogen concentration
    PMI_NDopantActive,          // active NDopant concentration
    PMI_NDopantChemical,        // chemical NDopant concentration
    PMI_Donor,                  // total donor concentration

    // incomplete ionization entries
    PMI_DonorPlus,              // total incomplete ionization donor concentration
    PMI_DonorPlusPer_eDensity,
    PMI_DonorPlusPerT

    // additional species
    PMI_Carbon,
    PMI_CarbonChemical          // chemical Carbon concentration
};
```

**NOTE** The species `PMI_Acceptor` and `PMI_Donor` are always defined. The remaining entries are only defined if they occur in the simulated device. The incomplete ionization entries are only accessible if the option `IncompleteIonization` is activated (see Chapter 13 on page 293).

The `ReadDielectricConstant` and `ReadSemiconductorDielectricConstant` methods return the dielectric constant for the current vertex. The second method accounts for only the dielectric constant in semiconductor.

The `ReadDopingWell()` method returns the index of the doping well for the current vertex (see Initial Guess for Electrostatic Potential and Quasi-Fermi Potentials in Doping Wells on page 184).

The method `IsUserFieldDefined()` checks whether a user-defined field has been specified. The enumeration type `PMI_UserFieldIndex` selects the required field:

```cpp
enum PMI_UserFieldIndex {
    PMI_UserField0, PMI_UserField1, ..., PMI_UserField99
};
```

If a specific user-field is defined, then the method `ReadUserField()` reads its value for the current vertex. For time-dependent user fields, this is the value written in the last successful

39: Physical Model Interface

Introduction to the Physical Model Interface

time step. `WriteUserField()` allows the modification of the value of a specific user-field for the current vertex. It writes to an auxiliary field. After a transient time step is finished, this auxiliary field becomes the field accessible with `ReadUserField()`.

The method `ReadStress()` returns the value of one of the following stress components:

```cpp
enum PMI_StressIndex {
  PMI_StressXX, PMI_StressYY, PMI_StressZZ,
  PMI_StressYZ, PMI_StressXZ, PMI_StressXY
};
```

**Reaction–Diffusion Species Interface (Compute Scope)**

For simplified PMI models, the class `PMI_Vertex_Input_Base` provides an interface for the extraction of RD species concentrations. Accessing the species concentrations through this interface supports the automatic derivative computations of the model quantity with respect to the species concentrations. For standard PMI models, such an interface is not supported.

If the interface is enabled for the actual PMI model, then the following function is available:

*   `bool RDSpecies_supported()` accesses the actual `Input` class support to RD species and their concentrations. If there is no support, then the other functions cannot be used. Most of the models do not support this interface.

If the `RDSpecies_supported()` function returns true, then you can use additional functions:

*   `size_t RDSpecies_size()` returns the number of RD species defined for the actual device. Note that not all of these species can be defined in the actual region.

*   `void get_RDSpecies_name (size_t isp, std::string& spname)` returns the name of the species with device index `isp`.

*   `bool RDSpecies_is_defined (size_t isp)` returns true if the species with device index `isp` is defined in the actual region.

*   `pmi_float RDSpecies_concentration (size_t isp)` returns the value of the concentration of the RD species with device index `isp`.

**Experimental Functions**

Vertex-based PMI models also have access to the following runtime functions:

```cpp
double ReadScalar (const char* name) const;
void ReadVector (const char* name, double vector [3]) const;
```

These functions can be called in `Compute` and provide access to scalar and vector data of Sentaurus Device. See Table 190 on page 1480 and Table 191 on page 1502 for an overview of available data.

Introduction to the Physical Model Interface

**NOTE** This is an experimental feature. It is provided as is, without warranty of any kind. In particular, you should be aware of the following limitations:

* Whenever you access additional data in Sentaurus Device, you introduce new model dependencies. However, Sentaurus Device cannot take into account the corresponding derivatives. Therefore, the convergence of the Newton solver might be affected.

* You might introduce cyclic dependencies, which will result in an infinite loop.

# Runtime Support for Vertex-Based Multistate Configuration–Dependent Models

The base class `PMI_MSC_Vertex_Interface` provides the same support as `PMI_Vertex_Interface`, plus additional functions needed by models that depend on a multistate configuration (see Chapter 18 on page 527):

```cpp
class PMI_MSC_Vertex_Interface : public PMI_Vertex_Interface
{
public:
    PMI_MSC_Vertex_Interface(const PMI_Environment&,
        const std::string& msconfig_name,
        int model_index,
        const std::string& model_string);

    const std::string& msconfig_name () const;
    size_t nb_states () const;
    std::string& state ( size_t index ) const;
    int model_index () const;
    const std::string& model_string () const;
    virtual void init_parameter (){};
};
```

**NOTE** In the case of the simplified interface, the base class `PMI_MSC_Vertex_Base` is used instead. However, it provides the same functionality as the base class `PMI_MSC_Vertex_Interface` and, therefore, it is not documented separately.

The constructor argument `msconfig_name` determines the name of the multistate configuration on which the model depends, and the constructor arguments `model_index` and `model_string` are an integer and a string that you can evaluate in your model. You call the constructor `PMI_MSC_Vertex_Interface` only indirectly using constructors of base classes of multistate configuration–dependent PMIs.

39: Physical Model Interface

Introduction to the Physical Model Interface

The function `nb_states` returns the number of states in the selected multistate configuration, `state` returns the name of a particular state, and `msconfig_name`, `model_index`, and `model_string` return the arguments of the constructor of the same name.

The function `init_parameter` is always called before the parameters are changed. It allows you to keep model-internal data up-to-date in cases such as ramping of parameters.

# Runtime Support for Mesh-Based PMI Models

A standard mesh-based PMI is derived from the base class `PMI_Device_Interface`; whereas, a simplified mesh-based PMI is derived from the base class `PMI_Device_Base`. Both base classes provide the following shared functionality:

```cpp
const char* Name () const;

const PMIBaseParam* ReadParameter (const char* name
                               [, const char* modelName]) const;
double InitParameter (const char* name, double defaultvalue
                     [, const char* modelName]) const;
void InitParameter (const char* name, std::vector<double>& value
                    [, const char* modelName]) const;
const char* InitStringParameter (const char* name,
                               const char* defaultvalue
                               [, const char* modelName]) const;
void InitStringParameter (const char* name,
                         std::vector<const char*>& value
                         [, const char* modelName]) const;

const des_mesh* Mesh () const;
des_data* Data () const;
des_loginfo* LogData () const;
```

The method `Name()` returns the name of the PMI model as specified in the command file. The methods `ReadParameter()`, `InitParameter()`, and `InitStringParameter()` read the value of a parameter from the parameter file or command file (see Parameter File of Sentaurus Device on page 1189 and Command File of Sentaurus Device on page 1187). In these methods, `modelName` is an optional argument that allows the value of a parameter to be read from a different PMI model.

**NOTE** Parameters for a mesh-based PMI must appear in the global parameter section in the parameter file. Regionwise or materialwise parameters are not supported.

The methods `Mesh()` and `Data()` provide access to the mesh and data of Sentaurus Device (see Device Mesh on page 1205 and Device Data on page 1211).

Introduction to the Physical Model Interface

> **NOTE** For the standard interface, the method `Data()` returns a variable of type `des_data`. For the simplified interface, it returns a variable of type `device_data`. The type `des_data` is based on the data type `double`, and `sdevice_data` uses the data type `pmi_float`. Otherwise, their functionality is identical.

The following interface functions should only be called in the `Compute` function, but not in the constructor. The standard interface provides them as members of the base class `PMI_Device_Interface`; whereas, the simplified interface provides them as members of the base class `PMI_Device_Input_Base`:

```cpp
double ReadTime () const;
double ReadTransientStepSize () const;
PMI_StepType ReadTransientStepType () const;
double ReadLayerThickness (int vertex) const;
double ReadLayerThicknessField (int vertex) const;
```

> **NOTE** The support functions for the simplified interface use the data type `pmi_float`; whereas, the support functions for the standard interface use the data type `double`. However, their functionality is identical, and only the `double` version is documented.

The functions `ReadTime()` and `ReadTransientStepSize()` return the simulation time and the current step size during a transient simulation [s]. `ReadTransientStepType()` provides access to the actual transient step type. The enumeration type `PMI_StepType` is defined for identification:

```cpp
enum PMI_StepType {
  PMI_UndefStepType = 0,
  PMI_TR = 1,
  PMI_BDF = 2,
  PMI_BE = 3
}
```

The functions `ReadLayerThickness()` and `ReadLayerThicknessField()` return the corresponding values `LayerThickness` and `LayerThicknessField` (see Extracting Layer Thickness on page 333).

The function `LogData()` returns the `des_loginfo` class, which can be used to print messages from PMI functions to the log file (see Runtime Support to Write PMI Output to Log File on page 1216).

39: Physical Model Interface
Introduction to the Physical Model Interface

# Device Mesh

A device mesh of Sentaurus Device consists of a number of regions. A region is either a contact region consisting of a list of contact vertices or a bulk region consisting of a list of elements. An element is described by a list of vertices.

## Vertex

In the file `PMIModels.h`, the class `des_vertex` is declared as follows:

```cpp
class des_vertex {

public:
  size_t index () const;
  size_t element_vertex_index (const des_element* element) const;

  const double* coord () const;
  double coord (size_t i) const;

  bool equal_coord (des_vertex* v) const;

  size_t size_edge () const;
  des_edge* edge (size_t i) const;

  size_t size_element () const;
  des_element* element (size_t i) const;

  size_t size_region () const;
  des_region* region (size_t i) const;

  size_t size_regioninterface () const;
  des_regioninterface* regioninterface (size_t i) const;
};
```

The value of `index()` can be used as an index for vertex-based data (see Device Data on page 1211). Similarly, the value of `element_vertex_index()` can be used as an index for element-vertex-based data.

The location of a vertex [$\mu$m] is given by its coordinates `coord()`. The two versions of the `coord()` function return the coordinates either as a vector or as individual components. You should use the function `equal_coord()` to check whether two vertices have the same coordinates. For example, Sentaurus Device duplicates vertices along heterointerfaces. Consequently, two vertices with different indices can share the same coordinates.

`size_edge()` returns the number of edges connected to a vertex. The method `edge()` can be used to retrieve the *i*-th edge.

Introduction to the Physical Model Interface

`size_region()` returns the number of regions containing a vertex. The method `region()` can be used to retrieve the $i$-th region.

`size_regioninterface()` reports how many region interfaces a vertex belongs to. The $i$-th region interface is returned by the method `regioninterface()`.

Figure 95 shows the numbering of vertices and edges for all element types.

Diagram showing vertex and edge numbering for various geometric element types: Point (vertex 0), Line (vertices 0, 1; edge e0), Tetrahedron (vertices 0, 1, 2, 3; edges e0-e5), Triangle (vertices 0, 1, 2; edges e0-e2), Rectangle (vertices 0, 1, 2, 3; edges e0-e3), Prism (vertices 0-5; edges e0-e8), Pyramid (vertices 0-4; edges e0-e7), Tetrabrick (vertices 1-6; edges e0-e11), and Cuboid (vertices 0-7; edges e0-e11).

Figure 95 Vertex and edge numbering

**39: Physical Model Interface**
Introduction to the Physical Model Interface

## Edge

In the file `PMIModels.h`, the class `des_edge` is declared as follows:

```cpp
 class des_edge {

 public:
    size_t index () const;

    des_vertex* start () const;
    des_vertex* end () const;

    size_t size_element () const;
    des_element* element (size_t i) const;

    size_t size_region () const;
    des_region* region (size_t i) const;
 };
```

You can use the value of `index()` as an index for edge-based data (see Device Data on page 1211).

`start()` and `end()` return the first and second vertex connected to the edge, respectively.

`size_element()` returns the number of elements connected to an edge. The method `element()` can be used to retrieve the *i*-th element.

`size_region()` returns the number of regions containing an edge. The method `region()` can be used to retrieve the *i*-th region.

## Element

In the file `PMIModels.h`, the class `des_element` is declared as follows:

```cpp
 class des_element {

 public:
    typedef enum { point, line, triangle, rectangle, tetrahedron,
                 pyramid, prism, cuboid, tetrabrick } des_type;

    size_t index () const;

    des_type type () const;

    size_t size_vertex () const;
    des_vertex* vertex (size_t i) const;

    size_t size_edge () const;
```

Introduction to the Physical Model Interface

```cpp
    des_edge* edge (size_t i) const;

    des_bulk* bulk () const;

    size_t element_vertex_offset () const;
  };
```

You can use the value of `index()` as an index for element-based data (see Device Data on page 1211). Similarly, `element_vertex_offset()` returns the start index for element-vertex-based data in this element.

`type()` returns the type of an element (point, line, triangle, rectangle, tetrahedron, pyramid, prism, cuboid, or tetrabrick). An element is mainly described by its vertices. `size_vertex()` returns the number of vertices in an element, and the method `vertex()` can be used to retrieve the *i*-th vertex. `size_edge()` returns the number of edges of an element. The method `edge()` can be used to retrieve the *i*-th edge. The method `bulk()` returns the bulk region containing the element.

**Region**

In the file `PMIModels.h`, the base class `des_region` is declared as follows:

```cpp
  class des_region {

  public:
    typedef enum { bulk, contact } des_type;

    virtual des_type type () const = 0;

    std::string name () const;

    size_t size_vertex () const;
    des_vertex* vertex (size_t i) const;

    size_t size_edge () const;
    des_edge* edge (size_t i) const;
  };
```

A mesh of Sentaurus Device consists of two types of region: bulk regions and contacts. The virtual method `type()` returns the type of a region. The name of a region is returned by `name()`. `size_vertex()` returns the number of vertices in a region. The method `vertex()` can be used to retrieve the *i*-th vertex. `size_edge()` returns the number of edges in a region. The method `edge()` can be used to retrieve the *i*-th edge.

39: Physical Model Interface

Introduction to the Physical Model Interface

The class `des_bulk` is derived from `des_region`:

```cpp
class des_bulk : public des_region {

public:
     des_type type () const;

     std::string material () const;

     size_t size_element () const;
     des_element* element (size_t i) const;

     size_t size_regioninterface () const;
     des_regioninterface* regioninterface (size_t i) const;
};
```

`material()` returns the name of the material in a bulk region. `size_element()` returns the number of elements in a region. The method `element()` can be used to retrieve the *i*-th element. `size_regioninterface()` reports how many region interfaces are connected to this bulk region. The *i*-th region interface can then be retrieved by the method `regioninterface()`.

Similarly, the class `des_contact` is also derived from `des_region`:

```cpp
class des_contact : public des_region {

public:
     des_type type () const;
};
```

## Region Interface

A region interface separates two bulk regions. It is described by the following class:

```cpp
class des_regioninterface {

public:
     size_t index () const;

     des_bulk* bulk1 () const;
     des_bulk* bulk2 () const;

     bool is_heterointerface () const;

     size_t size_vertex () const;
     des_vertex* vertex (size_t i) const;
     size_t index (size_t local_vertex_index) const;
};
```

Introduction to the Physical Model Interface

The value of `index()` is used to access the surface measure array (see Device Data on page 1211).

The two bulk regions connected to a region interface are returned by `bulk1()` and `bulk2()`.

Use `is_heterointerface()` to determine if double points exist for this interface. For a heterointerface, each vertex belongs to either region 1 or region 2, but not both. For a regular interface, each vertex belongs to both region 1 and region 2.

The number of vertices contained in a region interface is returned by the method `size_vertex()`. The *i*-th vertex can be obtained by invoking `vertex()`. The method `index(size_t local_vertex_index)` is used to obtain the correct index for interface-based data (see Device Data on page 1211).

## Mesh

In the file `PMIModels.h`, the class `des_mesh` is declared as follows:

```cpp
class des_mesh {

public:
  int dim () const;
  void ref_coordinates (double ref [3][3]) const;
  double ref_coordinates (int i, int j) const;

  size_t size_vertex () const;
  size_t size_element_vertex () const;
  des_vertex* vertex (size_t i) const;

  size_t size_edge () const;
  des_edge* edge (size_t i) const;

  size_t size_element () const;
  des_element* element (size_t i) const;
  void find_elements (double x, double y, double z,
                   std::vector<des_element*>& elements) const;

  size_t size_region () const;
  des_region* region (size_t i) const;

  size_t size_regioninterface () const;
  des_regioninterface* regioninterface (size_t i) const;
};
```

The dimension of the mesh is given by `dim()`. The possible values are 1, 2, and 3. The two `ref_coordinates()` methods provide access to the reference coordinate system, either to the entire matrix or individual components of the matrix.

## Introduction to the Physical Model Interface

They will return the identity matrix:

$$ \text{ref} = \begin{bmatrix} 1 & 0 & 0 \\ 0 & 1 & 0 \\ 0 & 0 & 1 \end{bmatrix} \tag{1317} $$

in the case of the unified coordinate system. Otherwise, another coordinate system matrix will be returned.

`size_vertex()` returns the number of vertices in the mesh. Similarly, the function `size_element_vertex()` returns the total number of element vertices in the mesh. The method `vertex()` can be used to retrieve the $i$-th vertex. `size_edge()` returns the number of edges in the mesh. The method `edge()` can be used to retrieve the $i$-th edge. `size_element()` returns the number of elements in the mesh. The method `element()` can be used to retrieve the $i$-th element.

For a given point with coordinates (x, y, z) in units of [$\mu$m], the method `find_elements()` computes a list of elements that contain this point.

`size_region()` returns the number of regions in the mesh. The method `region()` can be used to retrieve the $i$-th region. There are `size_regioninterface()` region interfaces in the mesh, and the $i$-th interface is returned by invoking `regioninterface()`.

## Device Data

The class `des_data` provides the following functionality:

```cpp
typedef enum { vertex, edge, element, rivertex, element_vertex } des_location;

const double*const* ReadCoefficient ();
const double*const* ReadMeasure ();
const double*const* ReadSurfaceMeasure ();
const double*const* ReadContactMeasure ();

const double* ReadScalar (des_location location, std::string name,
                           bool update=false);
const double*const* ReadVector (des_location location, std::string name,
                                      bool update=false);
void WriteScalar (des_location location, std::string name,
             const double* newvalue);

const double*const* ReadGradient (des_location location, std::string name,
                                       bool update=false);
const double* ReadFlux (des_location location, std::string name,
                           bool update=false);

size_t NumberOfMSCStates (const std::string& msc_name) const;
bool ReadMSCStateName (const std::string& msc_name, size_t state_index,
```

Introduction to the Physical Model Interface

```cpp
                std::string& state_name) const;
 bool ReadMSCOccupations (const std::string& msc_name,
                         const des_region* region,
                         double*const* values) const;

 double ReadeSHEDistribution (des_bulk* r, des_vertex* v, double energy) const;
 double ReadhSHEDistribution (des_bulk* r, des_vertex* v, double energy) const;
 double ReadeSHETotalDOS (des_bulk* r, double energy) const;
 double ReadhSHETotalDOS (des_bulk* r, double energy) const;
 double ReadeSHETotalGSV (des_bulk* r, double energy) const;
 double ReadhSHETotalGSV (des_bulk* r, double energy) const;

 double interpolate (des_element* element,
                const std::vector<double>& vertex_values,
                double x, double y, double z,
                des_interpolation interpolation = linear,
                double arsinhfactor = 1) const;
 double ReadRTNTrapRate (const std::string& trapName, des_bulk* r, size_t ce,
                size_t q, bool& status) const;
 double ReadRTNTrapOccupation(const std::string& trapName, des_bulk* r, bool&
                         status) const;
 std::vector<std::string> ReadRTNTrapNames(des_bulk* r) const;
 void SetRTNTrapOccupation(const std::string& trapName, des_bulk* r, double
                         value, bool& status) const;
```

**NOTE** In the case of the simplified interface, the class `sdevice_data` provides the same methods, but uses the data type `pmi_float` instead of `double`. Otherwise, the functionality is identical.

The methods `ReadCoefficient()` and `ReadMeasure()` return the box method coefficients κ<sub>ij</sub> and measure μ<sub>ij</sub> used in Sentaurus Device (see Discretization on page 1133).

The `ReadCoefficient()` method returns a two-dimensional array. The two indices are the element index and the local edge number. The units are μm<sup>-1</sup> in one dimension, 1 in two dimensions, and μm in three dimensions.

The following code fragment reads the coefficients for all element edges:

```cpp
 const des_mesh* mesh = Mesh();
 des_data* data = Data();
 const double*const* coeff = data->ReadCoefficient();
 for (size_t eli = 0; eli < mesh->size_element(); eli++) {
  des_element* el = mesh->element(eli);
  for (size_t ei = 0; ei < el->size_edge(); ei++) {
   des_edge* e = el->edge(ei);
   const double c = coeff[el->index()][ei];
  }
 }
```

## Introduction to the Physical Model Interface

**NOTE** The values $\kappa_{ij}$ returned by `ReadCoefficient()` are element–edge coefficients. The edge coefficients $\kappa_i$ can be obtained by adding the contributions from all elements connected to an edge $i$.

The `ReadMeasure()` method returns a two-dimensional array. The two indices are the element index and the local vertex number. The units are $\mu$m in one dimension, $\mu$m<sup>2</sup> in two dimensions, and $\mu$m<sup>3</sup> in three dimensions.

The following code fragment reads the measures for all element vertices:

```cpp
const des_mesh* mesh = Mesh();
des_data* data = Data();
const double*const* measure = data->ReadMeasure();
for (size_t eli = 0; eli < mesh->size_element(); eli++) {
    des_element* el = mesh->element(eli);
    for (size_t vi = 0; vi < el->size_vertex(); vi++) {
        des_vertex* v = el->vertex(vi);
        const double m = measure[el->index()][vi];
    }
}
```

**NOTE** The values $\mu_{ij}$ returned by `ReadMeasure()` are element–vertex measures. The node measures $\mu_i$ can be obtained by adding the contributions from all elements connected to a vertex $i$.

The method `ReadSurfaceMeasure()` provides the surface measure associated with region interface vertices (edge length [$\mu$m] in two dimensions and surface area [$\mu$m<sup>2</sup>] in three dimensions). The two indices are the region interface index and the local vertex number.

The method `ReadContactMeasure()` provides the contact measure associated with contact vertices (edge length [cm] in two dimensions and contact area [cm<sup>2</sup>] in three dimensions). The two indices are the contact index and the local vertex number.

By default, the PMI *read* functions use a caching mechanism to access internal data entries (for performance reasons). The cache is updated after computing the initial values for the Newton process and after convergence of Newton iterations. This means that, during Newton iterations, the read functions return unchanged arrays. The `ReadScalar()`, `ReadVector()`, `ReadGradient()`, and `ReadFlux()` methods have an additional parameter `update` (default is `false`). If `update=true`, then these methods update array values for each call to that function. The standard call of these methods (`update=false`) is a good solution for postprocessing PMI functions (see Current Plot File on page 1404). The `update=false` call of these methods is necessary for PMI models that are used during the Newton process (see Preprocessing for Newton Iterations and Newton Step Control on page 1411).

The methods `ReadScalar()`, `ReadVector()`, and `WriteScalar()` provide access to the data of Sentaurus Device. The values can be located on vertices, edges, elements, or region interfaces.

Introduction to the Physical Model Interface

See Table 190 on page 1480 and Table 191 on page 1502 for an overview of available scalar and vector data.

`ReadScalar()` returns a read-only one-dimensional array. Use the `index()` method in the classes `des_vertex`, `des_edge`, or `des_element` to access the array elements. The proper addressing of region interface datasets is shown in the code fragment below.

`ReadVector()` returns a read-only two-dimensional array. The first index selects the dimension (0, 1, 2) and the second index is used in the same way as for scalar data.

`WriteScalar()` writes back a one-dimensional array. The organization of the array is the same as for the arrays obtained with `ReadScalar()`. You must ensure that the size of the array is sufficient to hold all required entries.

`ReadGradient()` returns a 2D array that contains, for each vertex, the gradient of a chosen variable. Thereby, the first index selects the partial derivative:

$$ [0] = \left( \frac{\partial}{\partial x} \right), [1] = \left( \frac{\partial}{\partial y} \right), [2] = \left( \frac{\partial}{\partial z} \right) $$ (1318)

The second index identifies the vertex. The actual implementation of `ReadGradient()` works for vertex-based datasets only.

`ReadFlux()` returns an array that contains, for each vertex, the surface integral of the gradient of a chosen variable taken over the boundary of the box divided by the box volume. The actual implementation of `ReadFlux()` works for vertex-based datasets only.

The following code fragment traverses all region interfaces and reads the surface measure and a dataset for each region interface vertex:

```cpp
const des_mesh* mesh = Mesh();
des_data* data = Data();
const double*const* surface = data->ReadSurfaceMeasure();
const double* hot_elec = data->ReadScalar(des_data::rivertex,
                                           "HotElectronInj");
for (size_t rii = 0; rii < mesh->size_regioninterface(); rii++) {
  des_regioninterface* ri = mesh->regioninterface(rii);
  for (size_t vi = 0; vi < ri->size_vertex(); vi++) {
    des_vertex* v = ri->vertex(vi);
    const double sm = surface[ri->index()][vi];
    const double he = hot_elec[ri->index(vi)];
  }
}
```

**39: Physical Model Interface**
Introduction to the Physical Model Interface

The following code fragment traverses all contacts and reads the contact measure for each contact vertex:

```cpp
const des_mesh* mesh = Mesh();
des_data* data = Data();
const double*const* contact_measure = data->ReadContactMeasure();
for (size_t ri = 0; ri < mesh->size_region(); ri++) {
    des_region* r = mesh->region(ri);
    if (r->type() == des_region::contact) {
        for (size_t vi = 0; vi < r->size_vertex(); vi++) {
            const double m = contact_measure[ri][vi];
        }
    }
}
```

The method `interpolate()` can be called to interpolate a vertex-based field within an element. The location of the interpolation is given by the coordinates (x, y, z) in units of [$\mu$m]. The field values $v_i$ on the element vertices must be supplied in the vector `vertex_values`.

The following code fragment shows the proper usage:

```cpp
std::vector<double> vertex_values;
double x = 1.0; // interpolation location
double y = 1.0;
double z = 1.0;

for (size_t vi = 0; vi < element->size_vertex (); vi++) {
    des_vertex* v = element->vertex (vi);
    double vertex_value = 1.0; // value of field on vertex v
    vertex_values.push_back (vertex_value);
}
double result = data->interpolate (element, vertex_values, x, y, z,
                                   des_data::arsinh, 10.0);
```

The following interpolation modes are supported:

```cpp
des_data::linear
des_data::logarithmic
des_data::arsinh
```

Depending on the interpolation mode, the interpolated value $v$ is given by:

*   linear: $v = \sum_i w_i v_i$
*   logarithmic: $v = e^{\sum_i w_i \log v_i}$
*   arsinh: $v = \frac{1}{f} \sinh (\sum_i w_i \text{asinh}(f v_i))$

Introduction to the Physical Model Interface

Sentaurus Device determines the weights $w_i$ based on the distance of the point (x, y, z) from the vertices of the element. The weights are nonnegative and add up to 1.

The methods `ReadRTNTrapNames()`, `ReadRTNTrapRate()`, and `ReadRTNTrapOccupation()` are access functions to read the trap names, trap capture and emission rates, and trap occupation of random telegraph noise (RTN) traps. The method `SetRTNTrapOccupation()` can be used to set the occupation of RTN traps.

The following code shows the proper usage:

```cpp
des_region* r = Mesh()->region(0);
des_bulk* b = dynamic_cast<des_bulk*>(r);
// read RTN trap names
std::vector<std::string> trapNames = Data()->ReadRTNTrapNames(b);
for ( auto nn:trapNames ) {
  // read RTN trap occupation
  bool status = false;
  pmi_float trapOccupation = Data()->ReadRTNTrapOccupation(nn,b,status);
  // read electron emission rate to conduction band
  pmi_float rec = Data()->ReadRTNTrapRate(nn,b,1,0,status);
  // read electron emission rate to valence band
  pmi_float rev = Data()->ReadRTNTrapRate(nn,b,1,1,status);
  // read electron capture rate from conduction band
  pmi_float rcc = Data()->ReadRTNTrapRate(nn,b,0,0,status);
  // read electron capture rate from valence band
  pmi_float rcv = Data()->ReadRTNTrapRate(nn,b,0,1,status);
  // set RTN trap occupation
  Data()->SetRTNTrapOccupation(nn,b,1.0,status);
}
```

## Runtime Support to Write PMI Output to Log File

The `PMIModels.h` file contains the `des_loginfo` class, which can be used to print messages from PMI functions to the log file:

```cpp
class des_loginfo {

  FILE* GetLogFileToWriteOutput();

  void PMIPrint(const char *format, ...);
}
```

The method `GetLogFileToWriteOutput()` returns a pointer to the log file, and the method `PMIPrint()` writes the message to the log file. The `PMIPrint()` method internally calls the `GetLogFileToWriteOutput()` method to retrieve log file information. This class can be accessed from both vertex-based and mesh-based PMIs.

1216

39: Physical Model Interface
Generation–Recombination

The following code fragment uses the `des_loginfo` class to print an integer to the log file:

```
des_loginfo* LogInfo = LogData();
LogInfo->PMIPrint(" This writes an integer value to Log File %d \n", integer);
```

# Generation–Recombination

This section presents the following PMIs:

* Avalanche Generation

* Generation–Recombination

* Lifetimes

* Nonlocal Generation–Recombination

* Tunneling Parameters

# Avalanche Generation

The generation rate due to impact ionization can be expressed as:

$$ G^{||} = \alpha_n n v_n + \alpha_p p v_p $$ (1319)

where $\alpha_n$ and $\alpha_p$ are the ionization coefficients for electrons and holes, respectively (compare with Eq. 424, p. 434). The PMI allows you to redefine the calculation of $\alpha_n$ and $\alpha_p$.

## Dependencies

The ionization coefficients $\alpha_n$ and $\alpha_p$ can depend on the following variables:

| F | Driving force [ Vcm⁻¹ ] |
| --- | --- |
| t | Lattice temperature [K] |
| bg | Band gap [eV] |
| ct | Carrier temperature [K] |
| currentWoMob[3] | Current without mobility [ cm⁻⁴ AVs ] |

The parameter `ct` represents the electron temperature during the calculation of $\alpha_n$ and the hole temperature during the calculation of $\alpha_p$.

Generation–Recombination

The parameter `currentWoMob` can be used to compute anisotropic avalanche generation. Only the first $d$ components of the vector `currentWoMob` are defined, where $d$ is equal to the dimension of the problem. It is recommended that only the direction of the vector `currentWoMob` is taken into account, but not its magnitude.

The PMI model must compute the following results:

`alpha` Ionization coefficient [ cm<sup>-1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

| dalphadF | Derivative of alpha with respect to F [ V⁻¹ ] |
| --- | --- |
| dalphadt | Derivative of alpha with respect to t [ cm⁻¹K⁻¹ ] |
| dalphadbg | Derivative of alpha with respect to bg [ cm⁻¹eV⁻¹ ] |
| dalphadct | Derivative of alpha with respect to ct [ cm⁻¹K⁻¹ ] |
| dalphadcurrentWoMob[3] | Derivative of alpha with respect to currentWoMob [ cm³A⁻¹V⁻¹s⁻¹ ] |

Only the first $d$ components of the vector `dalphadcurrentWoMob` need to be computed.

## Standard C++ Interface

Different driving forces for avalanche generation can be selected in the command file. The enumeration type `PMI_AvalancheDrivingForce`, defined in `PMIModels.h`, is used to reflect your selection:

```cpp
enum PMI_AvalancheDrivingForce {
  PMI_AvalancheElectricField,
  PMI_AvalancheParallelElectricField,
  PMI_AvalancheGradQuasiFermi,
  PMI_AvalancheCarrierTemperatureCanali
};
```

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Avalanche : public PMI_Vertex_Interface {

private:
  const PMI_AvalancheDrivingForce drivingForce;

public:
  PMI_Avalanche (const PMI_Environment& env,
                 const PMI_AvalancheDrivingForce force);
  virtual ~PMI_Avalanche ();
```

39: Physical Model Interface

Generation–Recombination

```cpp
        PMI_AvalancheDrivingForce AvalancheDrivingForce () const
         { return drivingForce; }

        virtual void Compute_alpha
         (const double F, const double t, const double bg,
          const double ct, const double currentWoMob[3], double& alpha) = 0;

        virtual void Compute_dalphadF
         (const double F, const double t, const double bg,
          const double ct, const double currentWoMob[3], double& dalphadF) = 0;

        virtual void Compute_dalphadt
         (const double F, const double t, const double bg,
          const double ct, const double currentWoMob[3], double& dalphadt) = 0;

        virtual void Compute_dalphadbg
         (const double F, const double t, const double bg,
          const double ct, const double currentWoMob[3], double& dalphadbg) = 0;

        virtual void Compute_dalphadct
         (const double F, const double t, const double bg,
          const double ct, const double currentWoMob[3], double& dalphadct) = 0;

        virtual void Compute_dalphadcurrentWoMob
         (const double F, const double t, const double bg,
          const double ct, const double currentWoMob[3],
          double dalphadcurrentWoMob[3]) = 0;
     };
```

Two virtual constructors are required for the calculation of the ionization coefficients $\alpha_n$ and $\alpha_p$ :

```cpp
     typedef PMI_Avalanche* new_PMI_Avalanche_func
        (const PMI_Environment& env, const PMI_AvalancheDrivingForce force);
     extern "C" new_PMI_Avalanche_func new_PMI_e_Avalanche;
     extern "C" new_PMI_Avalanche_func new_PMI_h_Avalanche;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
     class PMI_Avalanche_Base : public PMI_Vertex_Base {

     public:
         class Input : public PMI_Vertex_Input_Base {
         public:
          pmi_float F;                // driving force
```

Generation–Recombination

```cpp
    pmi_float t;                  // lattice temperature
    pmi_float bg;                 // band gap
    pmi_float ct;                 // carrier temperature
    pmi_float currentWoMob[3];    // current density (without mobility)
  };

  class Output {
  public:
    pmi_float alpha;              // ionization coefficient
  };

  PMI_Avalanche_Base (const PMI_Environment& env,
                      const PMI_AvalancheDrivingForce force);
  virtual ~PMI_Avalanche_Base ();

  PMI_AvalancheDrivingForce AvalancheDrivingForce () const;

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Avalanche_Base* new_PMI_Avalanche_Base_func
  (const PMI_Environment& env, const PMI_AvalancheDrivingForce force);
extern "C" new_PMI_Avalanche_Base_func new_PMI_e_Avalanche_Base;
extern "C" new_PMI_Avalanche_Base_func new_PMI_h_Avalanche_Base;
```

## Example: Okuto Avalanche Generation

Okuto and Crowell propose the following expression for the ionization coefficient $\alpha$:

$$ \alpha(F) = a[1 + c(T - T_0)] F \exp \left[ - \left( \frac{b[1 + d(T - T_0)]}{F} \right)^2 \right] $$ (1320)

This built-in model is discussed in Okuto–Crowell Model on page 445 and its implementation as a PMI model is:

```cpp
#include "PMIModels.h"

class Okuto_Avalanche : public PMI_Avalanche {

protected:
  const double T0;
  double a, b, c, d;

public:
  Okuto_Avalanche (const PMI_Environment& env,
                   const PMI_AvalancheDrivingForce force);
```

39: Physical Model Interface
Generation–Recombination

```cpp
~Okuto_Avalanche ();

void Compute_alpha
  (const double F, const double t, const double bg,
   const double ct, const double currentWoMob[3], double& alpha);

void Compute_dalphadF
  (const double F, const double t, const double bg,
   const double ct, const double currentWoMob[3], double& dalphadF);

void Compute_dalphadt
  (const double F, const double t, const double bg,
   const double ct, const double currentWoMob[3], double& dalphadt);

void Compute_dalphadbg
  (const double F, const double t, const double bg,
   const double ct, const double currentWoMob[3], double& dalphadbg);

void Compute_dalphadct
  (const double F, const double t, const double bg,
   const double ct, const double currentWoMob[3], double& dalphadct);

void Compute_dalphadcurrentWoMob
  (const double F, const double t, const double bg,
   const double ct, const double currentWoMob[3], double
dalphadcurrentWoMob[3]);
};

Okuto_Avalanche::
Okuto_Avalanche (const PMI_Environment& env,
                 const PMI_AvalancheDrivingForce force) :
  PMI_Avalanche (env, force),
  T0 (300.0)
{
}

Okuto_Avalanche::
~Okuto_Avalanche ()
{
}

void Okuto_Avalanche::
Compute_alpha (const double F, const double t, const double bg,
               const double ct, const double currentWoMob[3], double& alpha)
{ const double aa = a * (1.0 + c * (t - T0));
  const double bb = b * (1.0 + d * (t - T0)) / F;
  alpha = aa * F * exp (-bb*bb);
}
```

Generation–Recombination

```cpp
}

void Okuto_Avalanche::
Compute_dalphadF (const double F, const double t, const double bg,
                  const double ct, const double currentWoMob[3], double&
dalphadF)
{ const double aa = a * (1.0 + c * (t - T0));
  const double bb = b * (1.0 + d * (t - T0)) / F;
  const double alpha = aa * F * exp (-bb*bb);
  dalphadF = (alpha / F) * (1.0 + 2.0*bb*bb);
}

void Okuto_Avalanche::
Compute_dalphadt (const double F, const double t, const double bg,
                  const double ct, const double currentWoMob[3], double&
dalphadt)
{ const double aa = a * (1.0 + c * (t - T0));
  const double bb = b * (1.0 + d * (t - T0)) / F;
  const double tmp = F * exp (-bb*bb);
  dalphadt = tmp * (a * c - 2.0 * aa * bb * b * d / F);
}

void Okuto_Avalanche::
Compute_dalphadbg (const double F, const double t, const double bg,
                   const double ct, const double currentWoMob[3], double&
dalphadbg)
{ dalphadbg = 0.0;
}

void Okuto_Avalanche::
Compute_dalphadct (const double F, const double t, const double bg,
                   const double ct, const double currentWoMob[3], double&
dalphadct)
{ dalphadct = 0.0;
}

void Okuto_Avalanche::
Compute_dalphadcurrentWoMob (const double F, const double t, const double bg,
                             const double ct, const double currentWoMob[3],
                             double dalphadcurrentWoMob[3])
{ const int dim = ReadDimension ();
  for (int k = 0; k < dim; k++) {
    dalphadcurrentWoMob [k] = 0.0;
  }
}

class Okuto_e_Avalanche : public Okuto_Avalanche {
```

Generation–Recombination

```cpp
public:
 Okuto_e_Avalanche (const PMI_Environment& env,
                   const PMI_AvalancheDrivingForce force);

 ~Okuto_e_Avalanche () {}
};

Okuto_e_Avalanche::
Okuto_e_Avalanche (const PMI_Environment& env,
          const PMI_AvalancheDrivingForce force) :
 Okuto_Avalanche (env, force)
{ // default values
 a = InitParameter ("a_e", 0.426);
 b = InitParameter ("b_e", 4.81e5);
 c = InitParameter ("c_e", 3.05e-4);
 d = InitParameter ("d_e", 6.86e-4);
}

class Okuto_h_Avalanche : public Okuto_Avalanche {

public:
 Okuto_h_Avalanche (const PMI_Environment& env,
                   const PMI_AvalancheDrivingForce force);

 ~Okuto_h_Avalanche () {}
};

Okuto_h_Avalanche::
Okuto_h_Avalanche (const PMI_Environment& env,
          const PMI_AvalancheDrivingForce force) :
 Okuto_Avalanche (env, force)
{ // default values
 a = InitParameter ("a_h", 0.243);
 b = InitParameter ("b_h", 6.53e+5);
 c = InitParameter ("c_h", 5.35e-4);
 d = InitParameter ("d_h", 5.67e-4);
}

extern "C"
PMI_Avalanche* new_PMI_e_Avalanche
 (const PMI_Environment& env, const PMI_AvalancheDrivingForce force)
{ return new Okuto_e_Avalanche (env, force);
}
```

Generation–Recombination

```cpp
extern "C"
PMI_Avalanche* new_PMI_h_Avalanche
 (const PMI_Environment& env, const PMI_AvalancheDrivingForce force)
{ return new Okuto_h_Avalanche (env, force);
}
```

# Generation–Recombination

The recombination rate $R_{\text{net}}$ appears in the electron and hole continuity equations (see Eq. 57, p. 189).

## Dependencies

The recombination rate $R_{\text{net}}$ can depend on these variables:

| `t` | Lattice temperature [ K ] |
| --- | --- |
| `n` | Electron density [ cm−3 ] |
| `p` | Hole density [ cm−3 ] |
| `nie` | Effective intrinsic density [ cm−3 ] |
| `f` | Absolute value of electric field [ Vcm−1 ] |

The PMI model must compute the following results:

| `r` | Generation–recombination rate [ cm−3s−1 ] |
| --- | --- |

In the case of the standard interface, the following derivatives must be computed as well:

| `drdt` | Derivative of `r` with respect to `t` [ cm−3s−1K−1 ] |
| --- | --- |
| `drdn` | Derivative of `r` with respect to `n` [ s−1 ] |
| `drdp` | Derivative of `r` with respect to `p` [ s−1 ] |
| `drdnie` | Derivative of `r` with respect to `nie` [ s−1 ] |
| `drdf` | Derivative of `r` with respect to `f` [ cm−2s−1V−1 ] |

39: Physical Model Interface
Generation–Recombination

# Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Recombination : public PMI_Vertex_Interface {

public:
     PMI_Recombination (const PMI_Environment& env);
     virtual ~PMI_Recombination ();
     virtual useCorrectedDensities() {return false;}

     virtual void Compute_r
      (const double t, const double n, const double p,
      const double nie, const double f, double& r) = 0;

     virtual void Compute_drdt
      (const double t, const double n, const double p,
          const double nie, const double f, double& drdt) = 0;

     virtual void Compute_drdn
      (const double t, const double n, const double p,
          const double nie, const double f, double& drdn) = 0;

     virtual void Compute_drdp
      (const double t, const double n, const double p,
          const double nie, const double f, double& drdp) = 0;

     virtual void Compute_drdnie
      (const double t, const double n, const double p,
      const double nie, const double f, double& drdnie) = 0;
     virtual void Compute_drdf
      (const double t, const double n, const double p,
      const double nie, const double f, double& drdf) = 0;
};
```

The prototype for the virtual constructor is:

```cpp
typedef PMI_Recombination* new_PMI_Recombination_func
      (const PMI_Environment& env);
extern "C" new_PMI_Recombination_func new_PMI_Recombination;
```

By default, Sentaurus Device assumes that a PMI generation–recombination model depends on the electric field. However, you can implement the optional function `PMI_Recombination_ElectricField()` to indicate whether the model depends on the electric field.

Generation–Recombination

By default, the generation–recombination PMI passes uncorrected carrier and intrinsic densities regardless of quantum corrections or Fermi statistics activation in the Sentaurus Device command file.

To force Sentaurus Device to pass the corrected carrier and intrinsic densities to the generation–recombination PMI, the virtual function `useCorrectedDensity()` in the PMI must return `true`. For visualization purposes, two new data entries are available:

*   `QCEffectiveIntrinsicDensity` is an improved version of `EffectiveIntrinsicDensity` and contains corrections due to Fermi statistics and quantization effects.

*   `QCEffectiveBandgap` is the `EffectiveBandgap` with extra narrowing due to the quantum potentials and all the effects implemented through the quantum-potential framework.

If the model does not depend on the electric field (return value of 0), then the method `Compute_drdf()` is not called, and the matrix assembly in Sentaurus Device works more efficiently:

```cpp
typedef int PMI_Recombination_ElectricField_func ();
extern "C"
PMI_Recombination_ElectricField_func PMI_Recombination_ElectricField;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_Recombination_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;     // lattice temperature
    pmi_float n;     // electron density
    pmi_float p;     // hole density
    pmi_float nie;   // effective intrinsic density
    pmi_float f;     // absolute value of electric field
  };

  class Output {
  public:
    pmi_float r;     // recombination rate
  };

  PMI_Recombination_Base (const PMI_Environment& env);
  virtual ~PMI_Recombination_Base ();
  virtual useCorrectedDensities() {return false;}
```

39: Physical Model Interface

Generation–Recombination

```cpp
    virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Recombination_Base* new_PMI_Recombination_Base_func
    (const PMI_Environment& env);
extern "C" new_PMI_Recombination_Base_func new_PMI_Recombination_Base;
```

The optional function `PMI_Recombination_ElectricField()` is recognized as well, as in the case of the standard interface.

# Example: Auger Recombination

See Standard C++ Interface on page 1168 and Simplified C++ Interface on page 1171.

# Lifetimes

This PMI provides access to the electron and hole lifetimes, τ<sub>n</sub> and τ<sub>p</sub>, in the SRH recombination (see Eq. 280, p. 356) and the coupled defect level (CDL) recombination (see Eq. 400, p. 425).

In the command file, the names of the lifetime models are given as arguments to the `SRH` or `CDL` keywords:

```
Physics { Recombination (SRH (pmi_model_name)) }
```

or:

```
Physics { Recombination (CDL (pmi_model_name)) }
```

**NOTE** A PMI model overrides all other keywords in an `SRH` or a `CDL` statement.

# Dependencies

A PMI lifetime model can depend on the variable:

`t` Lattice temperature [K]

It must compute the following results:

`tau` Lifetime τ [s]

Generation–Recombination

In the case of the standard interface, the following derivative must be computed as well:

dtaudt Derivative of $\tau$ with respect to lattice temperature [ sK<sup>−1</sup> ]

## Standard C++ Interface

The enumeration type `PMI_LifetimeModel` describes where the PMI lifetime is used:

```cpp
enum PMI_LifetimeModel {
  PMI_SRH,
  PMI_CDL1,
  PMI_CDL2
};
```

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Lifetime : public PMI_Vertex_Interface {

private:
  const PMI_LifetimeModel lifetimeModel;

public:
  PMI_Lifetime (const PMI_Environment& env,
                const PMI_LifetimeModel model);

  virtual ~PMI_Lifetime ();

  PMI_LifetimeModel LifetimeModel () const { return lifetimeModel; }

  virtual void Compute_tau
    (const double t, double& tau) = 0;

  virtual void Compute_dtaudt
    (const double t, double& dtaudt) = 0;
};
```

Two virtual constructors must be implemented for electron and hole lifetimes:

```cpp
typedef PMI_Lifetime* new_PMI_Lifetime_func
  (const PMI_Environment& env, const PMI_LifetimeModel model);
extern "C" new_PMI_Lifetime_func new_PMI_e_Lifetime;
extern "C" new_PMI_Lifetime_func new_PMI_h_Lifetime;
```

39: Physical Model Interface
Generation–Recombination

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_Lifetime_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;  // lattice temperature
  };

  class Output {
  public:
    pmi_float tau;  // lifetime
  };

  PMI_Lifetime_Base (const PMI_Environment& env,
                     const PMI_LifetimeModel model);
  virtual ~PMI_Lifetime_Base ();

  PMI_LifetimeModel LifetimeModel () const;

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Lifetime_Base* new_PMI_Lifetime_Base_func
  (const PMI_Environment& env, const PMI_LifetimeModel model);
extern "C" new_PMI_Lifetime_Base_func new_PMI_e_Lifetime_Base;
extern "C" new_PMI_Lifetime_Base_func new_PMI_h_Lifetime_Base;
```

## Example: Doping- and Temperature-Dependent Lifetimes

The following example combines doping-dependent lifetimes (Scharfetter) and temperature dependence (power law):

$$ \tau = \left( \tau_{\min} + \frac{\tau_{\max} - \tau_{\min}}{1 + \left( \frac{N_{A,0} + N_{D,0}}{N_{\text{ref}}} \right)^{\gamma}} \right) \left( \frac{T}{300 \text{ K}} \right)^{\alpha} $$ (1321)

1229

Generation–Recombination

```cpp
#include "PMIModels.h"

class Scharfetter_Lifetime : public PMI_Lifetime {

protected:
  const double T0;
  double taumin, taumax, Nref, gamma, Talpha;

public:
  Scharfetter_Lifetime (const PMI_Environment& env,
                        const PMI_LifetimeModel model);

  ~Scharfetter_Lifetime ();
  void Compute_tau
    (const double t, double& tau);

  void Compute_dtaudt
    (const double t, double& dtaudt);

};

Scharfetter_Lifetime::
Scharfetter_Lifetime (const PMI_Environment& env,
                      const PMI_LifetimeModel model) :
  PMI_Lifetime (env, model),
  T0 (300.0)
{
}

Scharfetter_Lifetime::
~Scharfetter_Lifetime ()
{
}

void Scharfetter_Lifetime::
Compute_tau (const double t, double& tau)
{ const double Ni = ReadDoping (PMI_Acceptor) + ReadDoping (PMI_Donor);
  tau = taumin + (taumax - taumin) / (1.0 + pow (Ni/Nref, gamma));
  tau *= pow (t/T0, Talpha);
}

void Scharfetter_Lifetime::
Compute_dtaudt (const double t, double& dtaudt)
{ const double Ni = ReadDoping (PMI_Acceptor) + ReadDoping (PMI_Donor);
  dtaudt = taumin + (taumax - taumin) / (1.0 + pow (Ni/Nref, gamma));
  dtaudt *= (Talpha/T0) * pow (t/T0, Talpha-1.0);
}
```

Generation–Recombination

```cpp
class Scharfetter_e_Lifetime : public Scharfetter_Lifetime {

public:
  Scharfetter_e_Lifetime (const PMI_Environment& env,
                         const PMI_LifetimeModel model);

  ~Scharfetter_e_Lifetime () {}

};
Scharfetter_e_Lifetime::
Scharfetter_e_Lifetime (const PMI_Environment& env,
                        const PMI_LifetimeModel model) :
  Scharfetter_Lifetime (env, model)
{ taumin = InitParameter ("taumin_e", 0.0);
  taumax = InitParameter ("taumax_e", 1.0e-5);
  Nref = InitParameter ("Nref_e", 1.0e16);
  gamma = InitParameter ("gamma_e", 1.0);
  Talpha = InitParameter ("Talpha_e", -1.5);
}

class Scharfetter_h_Lifetime : public Scharfetter_Lifetime {

public:
  Scharfetter_h_Lifetime (const PMI_Environment& env,
                         const PMI_LifetimeModel model);

  ~Scharfetter_h_Lifetime () {}

};

Scharfetter_h_Lifetime::
Scharfetter_h_Lifetime (const PMI_Environment& env,
                        const PMI_LifetimeModel model) :
  Scharfetter_Lifetime (env, model)

{ taumin = InitParameter ("taumin_h", 0.0);
  taumax = InitParameter ("taumax_h", 3.0e-6);
  Nref = InitParameter ("Nref_h", 1.0e16);
  gamma = InitParameter ("gamma_h", 1.0);
  Talpha = InitParameter ("Talpha_h", -1.5);
}

extern "C"
PMI_Lifetime* new_PMI_e_Lifetime
  (const PMI_Environment& env, const PMI_LifetimeModel model)
{ return new Scharfetter_e_Lifetime (env, model);
}
```

Generation–Recombination

```cpp
extern "C"
PMI_Lifetime* new_PMI_h_Lifetime
 (const PMI_Environment& env, const PMI_LifetimeModel model)
{ return new Scharfetter_h_Lifetime (env, model);
}
```

# Nonlocal Generation–Recombination

The nonlocal generation–recombination model computes individual electron and hole recombination rates in Eq. 57, p. 189. The name of the PMI model must appear as a recombination model within the `Physics` section of the command file:

```
Physics { Recombination (pmi_model_name) }
```

The computed electron and hole recombination rates also can be plotted in the `Plot` section:

```
Plot {
   PMIeNonLocalRecombination
   PMIhNonLocalRecombination
}
```

## Dependencies

Nonlocal Interface on page 1175 discusses the supported dependencies of nonlocal models. The actual dependencies must be defined with the method `DefineDependencies()`, and the Jacobian matrices must be defined with the method `DefineJacobians()`.

The method `Compute_parallel()` must compute the following results for the vertices defined in the `input` argument:

| `elec` | Vector of electron recombination rates [ cm–3 s–1 ] |
| --- | --- |
| `hole` | Vector of hole recombination rates [ cm–3 s–1 ] |
| `J_elec` | Map of electron Jacobian matrices |
| `J_hole` | Map of hole Jacobian matrices |

39: Physical Model Interface
Generation–Recombination

# Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_NonLocal_Recombination : public PMI_Device_Interface {

public:
  class Input {
  public:
    const des_region* region;               // all vertices belong to this region
    const std::vector<int>& vertices; // list of vertices
  };

  class Output {
  public:
    std::vector<double>& elec; // nonlocal recombination rates (electrons)
    std::vector<double>& hole; // nonlocal recombination rates (holes)
    des_id_to_jacobian_map& J_elec; // derivatives (electrons)
    des_id_to_jacobian_map& J_hole; // derivatives (holes)
  };

  PMI_NonLocal_Recombination (const PMI_Device_Environment& env);
  virtual ~PMI_NonLocal_Recombination ();

  virtual void DefineDependencies
    (std::vector<des_data::des_id>& dependencies) = 0;

  virtual void DefineJacobians (des_id_to_jacobian_map& J_elec,
                                  des_id_to_jacobian_map& J_hole) = 0;

  virtual void Compute_parallel (const Input& input, Output& output) = 0;

  virtual bool NeedNewEdges () { return false; }
};
```

The prototype for the virtual constructor is:

```cpp
typedef PMI_NonLocal_Recombination* new_PMI_NonLocal_Recombination_func
  (const PMI_Device_Environment& env);
extern "C" new_PMI_NonLocal_Recombination_func new_PMI_NonLocal_Recombination;
```

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_NonLocal_Recombination_Base : public PMI_Device_Base {

public:
  class Input : public PMI_Device_Input_Base {
```

Generation–Recombination

```cpp
    public:
      const des_region* region;           // all vertices belong to this region
      const std::vector<int>& vertices; // list of vertices
    };

    class Output {
    public:
      std::vector<pmi_float>& elec;
                                    // nonlocal recombination rates (electrons)
      std::vector<pmi_float>& hole; // nonlocal recombination rates (holes)
      sdevice_id_to_jacobian_map& J_elec; // derivatives (electrons)
      sdevice_id_to_jacobian_map& J_hole; // derivatives (holes)
    };

    PMI_NonLocal_Recombination_Base (const PMI_Device_Environment& env);
    virtual ~PMI_NonLocal_Recombination_Base ();

    virtual void DefineDependencies
      (std::vector<sdevice_data::sdevice_id>& dependencies) = 0;

    virtual void DefineJacobians (sdevice_id_to_jacobian_map& J_elec,
                                    sdevice_id_to_jacobian_map& J_hole) = 0;

    virtual void Compute_parallel (const Input& input, Output& output) = 0;

    virtual bool NeedNewEdges () { return false; }
  };
```

The prototype for the virtual constructor is given as:

```cpp
  typedef PMI_NonLocal_Recombination_Base*
    new_PMI_NonLocal_Recombination_Base_func
      (const PMI_Device_Environment& env);
  extern "C" new_PMI_NonLocal_Recombination_Base_func
    new_PMI_NonLocal_Recombination_Base;
```

## Example: Point-to-Point Tunneling

This example is presented in Example: Point-to-Point Tunneling on page 1178.

## Tunneling Parameters

For the dynamic nonlocal path band-to-band tunneling model, the conduction and valence band offset energies and the electron and hole tunneling masses can be computed using a PMI (see Dynamic Nonlocal Path Band-to-Band Tunneling Model on page 475).

Generation–Recombination

The syntax in the command file is:

```
Band2Band (
  Model=NonlocalPath(PMIModel=pmi_model_name)
)
```

You select the default tunneling parameters by omitting the `PMIModel` keyword:

```
Band2Band (
  Model=NonlocalPath
)
```

## Dependencies

The tunneling parameters can depend on:

t Lattice temperature [K]

The PMI model must compute:

DcPath Conduction band offset energy [eV]

DvPath Valence band offset energy [eV]

m<sub>c</sub> Electron tunneling mass [$m_0$]

m<sub>v</sub> Hole tunneling mass [$m_0$]

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_DNPBTBT_Base : public PMI_Vertex_Base {
public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    Input (const PMI_DNPBTBT_Base* base, const int vertex);

    pmi_float t;   // lattice temperature
  };

  class Output {
  public:
    pmi_float Dcpath; // conduction band offset energy
    pmi_float Dvpath; // valence band offset energy
    pmi_float m_c;    // electron tunneling mass
```

Generation–Recombination

```cpp
    pmi_float m_v;    // hole tunneling mass
  };

  PMI_DNPBTBT_Base (const PMI_Environment& env);
  virtual ~PMI_DNPBTBT_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_DNPBTBT_Base* new_PMI_DNPBTBT_Base_func
extern "C" new_PMI_DNPBTBT_Base_func new_PMI_DNPBTBT_Base;
```

## Example: Constant Tunneling Parameters

A simple constant tunneling parameters model can be implemented as follows:

```cpp
#include "PMI.h"

class BTBTParameter : public PMI_DNPBTBT_Base {
friend class PMI_Device_Base;
public:
  BTBTParameter (const PMI_Environment& env);
  ~BTBTParameter ();

  void compute (const Input& input, Output& output);
};

BTBTParameter::
BTBTParameter (const PMI_Environment& env) :
  PMI_DNPBTBT_Base (env)
{
}

BTBTParameter::
~BTBTParameter ()
{
}

void BTBTParameter::
compute (const Input& input, Output& output)
{
  output.m_c = 0.3;
  output.m_v = 0.4;
  output.Dcpath = 0.02;
  output.Dvpath = 0.01;
}
```

39: Physical Model Interface

Mobility

```cpp
extern "C"
PMI_DNPBTBT_Base* new_PMI_DNPBTBT_Base (const PMI_Environment& env)
{return new BTBTParameter (env);
}
```

# Mobility

Sentaurus Device supports different types of PMI mobility model:

* Doping-dependent mobility

* Mobility degradation at interfaces

* High-field saturation

PMI and built-in models can be used simultaneously. See Chapter 15 on page 341 for details about how the contributions of different models are combined. PMI mobility models support anisotropic calculations and can be evaluated along different crystallographic axes. The following enumeration type determines the axis:

```cpp
enum PMI_AnisotropyType {
  PMI_Isotropic,
  PMI_Anisotropic
};
```

The default is isotropic mobility. If anisotropic mobilities are activated in the command file, then the PMI mobility classes are also instantiated in the anisotropic direction.

This section presents the following PMIs:

* Doping-Dependent Mobility

* Fitting Parameter for Ballistic Mobility

* High-Field Saturation

* High-Field Saturation With Two Driving Forces

* Mobility Degradation at Interfaces

## Doping-Dependent Mobility

A doping-dependent PMI model must account for both the constant mobility and doping-dependent mobility models discussed in Mobility due to Phonon Scattering on page 342 and Doping-Dependent Mobility Degradation on page 342.

39: Physical Model Interface

Mobility

## Dependencies

The constant mobility and doping-dependent mobility $\mu_{dop}$ can depend on the following variables:

*   t Lattice temperature [K]
*   n Electron density [ cm<sup>–3</sup> ]
*   p Hole density [ cm<sup>–3</sup> ]

The PMI model must compute the following results:

*   m Mobility $\mu_{dop}$ [ cm<sup>2</sup> V<sup>–1</sup> s<sup>–1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

*   dmdn Derivative of $\mu_{dop}$ with respect to n [ cm<sup>5</sup> V<sup>–1</sup> s<sup>–1</sup> ]
*   dmdp Derivative of $\mu_{dop}$ with respect to p [ cm<sup>5</sup> V<sup>–1</sup> s<sup>–1</sup> ]
*   dmdt Derivative of $\mu_{dop}$ with respect to t [ cm<sup>2</sup> V<sup>–1</sup> s<sup>–1</sup> K<sup>–1</sup> ]

In most cases, it is not necessary to compute the derivatives with respect to the dopant concentrations.

However, to model random dopant fluctuations (see Random Dopant Fluctuations on page 737), the PMI model must override the functions that compute the following values:

*   dmdNa Derivative of $\mu_{dop}$ with respect to the acceptor concentration [ cm<sup>5</sup> V<sup>–1</sup> s<sup>–1</sup> ]
*   dmdNd Derivative of $\mu_{dop}$ with respect to the donor concentration [ cm<sup>5</sup> V<sup>–1</sup> s<sup>–1</sup> ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_DopingDepMobility : public PMI_Vertex_Interface {

private:
  const PMI_AnisotropyType anisoType;

public:
  PMI_DopingDepMobility (const PMI_Environment& env,
                         const PMI_AnisotropyType anisotype);
```

39: Physical Model Interface

Mobility

```cpp
virtual ~PMI_DopingDepMobility ();

PMI_AnisotropyType AnisotropyType () const { return anisoType; }

virtual void Compute_m
  (const double n, const double p,
   const double t, double& m) = 0;

virtual void Compute_dmdn
  (const double n, const double p,
   const double t, double& dmdn) = 0;

virtual void Compute_dmdp
  (const double n, const double p,
   const double t, double& dmdp) = 0;

virtual void Compute_dmdt
  (const double n, const double p,
   const double t, double& dmdt) = 0;

virtual void Compute_dmdNa
  (const double n, const double p,
   const double t, double& dmdNa);

virtual void Compute_dmdNd
  (const double n, const double p,
   const double t, double& dmdNd);
};
```

Two virtual constructors are required for electron and hole mobilities:

```cpp
typedef PMI_DopingDepMobility* new_PMI_DopingDepMobility_func
  (const PMI_Environment& env, const PMI_AnisotropyType anisotype);
extern "C" new_PMI_DopingDepMobility_func new_PMI_DopingDep_e_Mobility;
extern "C" new_PMI_DopingDepMobility_func new_PMI_DopingDep_h_Mobility;
```

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_DopingDepMobility_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float n;        // electron density
    pmi_float p;        // hole density
    pmi_float t;        // lattice temperature
```

Mobility

```cpp
      pmi_float acceptor; // total acceptor concentration
      pmi_float donor;    // total donor concentration
   };

   class Output {
   public:
      pmi_float m;        // doping-dependent mobility
   };

   PMI_DopingDepMobility_Base (const PMI_Environment& env,
                               const PMI_AnisotropyType anisotype);
   virtual ~PMI_DopingDepMobility_Base ();

   PMI_AnisotropyType AnisotropyType () const;

   virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_DopingDepMobility_Base* new_PMI_DopingDepMobility_Base_func
   (const PMI_Environment& env, const PMI_AnisotropyType anisotype);
extern "C" new_PMI_DopingDepMobility_Base_func
   new_PMI_DopingDep_e_Mobility_Base;
extern "C" new_PMI_DopingDepMobility_Base_func
   new_PMI_DopingDep_h_Mobility_Base;
```

## Example: Masetti Doping-Dependent Mobility

The built-in Masetti model (see Masetti Model on page 344) can also be implemented as a PMI model:

```cpp
#include "PMIModels.h"

class Masetti_DopingDepMobility : public PMI_DopingDepMobility {
protected:
   const double T0;
   double mumax, Exponent, mumin1, mumin2, mu1, Pc, Cr, Cs, alpha, beta;

public:
   Masetti_DopingDepMobility (const PMI_Environment& env,
                              const PMI_AnisotropyType anisotype);
   ~Masetti_DopingDepMobility () {}

   void Compute_m
      (const double n, const double p,
       const double t, double& m);
```

39: Physical Model Interface

Mobility

```cpp
    void Compute_dmdn
      (const double n, const double p,
       const double t, double& dmdn);

    void Compute_dmdp
      (const double n, const double p,
       const double t, double& dmdp);

    void Compute_dmdt
      (const double n, const double p,
       const double t, double& dmdt);
};

Masetti_DopingDepMobility::
Masetti_DopingDepMobility (const PMI_Environment& env,
                           const PMI_AnisotropyType anisotype) :
  PMI_DopingDepMobility (env, anisotype),
  T0 (300.0)
{
}

void Masetti_DopingDepMobility::
Compute_m (const double n, const double p,
           const double t, double& m)
{ const double mu_const = mumax * pow (t/T0, -Exponent);
  const double Ni = Max (ReadDoping (PMI_Donor) +
                         ReadDoping (PMI_Acceptor), 1.0);
  m = mumin1 * exp (-Pc / Ni) +
    (mu_const - mumin2) / (1.0 + pow (Ni / Cr, alpha)) -
    mu1 / (1.0 + pow (Cs / Ni, beta));
}

void Masetti_DopingDepMobility::
Compute_dmdn (const double n, const double p,
              const double t, double& dmdn)
{ dmdn = 0.0;
}

void Masetti_DopingDepMobility::
Compute_dmdp (const double n, const double p,
              const double t, double& dmdp)
{ dmdp = 0.0;
}

void Masetti_DopingDepMobility::
Compute_dmdt (const double n, const double p,
              const double t, double& dmdt)
```

1241

Mobility

```cpp
{ const double Ni = Max (ReadDoping (PMI_Donor) +
                   ReadDoping (PMI_Acceptor), 1.0);
 dmdt = mumax * (-Exponent/T0) * pow (t/T0, -Exponent - 1.0) /
       (1.0 + pow (Ni / Cr, alpha));
}

class Masetti_e_DopingDepMobility : public Masetti_DopingDepMobility {
public:
 Masetti_e_DopingDepMobility (const PMI_Environment& env,
                             const PMI_AnisotropyType anisotype);
 ~Masetti_e_DopingDepMobility () {}
};

Masetti_e_DopingDepMobility::
Masetti_e_DopingDepMobility (const PMI_Environment& env,
                   const PMI_AnisotropyType anisotype) :
 Masetti_DopingDepMobility (env, anisotype)

{ // default values
 mumax = InitParameter ("mumax_e", 1417.0);
 Exponent = InitParameter ("Exponent_e", 2.5);
 mumin1 = InitParameter ("mumin1_e", 52.2);
 mumin2 = InitParameter ("mumin2_e", 52.2);
 mu1 = InitParameter ("mu1_e", 43.4);
 Pc = InitParameter ("Pc_e", 0.0);
 Cr = InitParameter ("Cr_e", 9.68e16);
 Cs = InitParameter ("Cs_e", 3.43e20);
 alpha = InitParameter ("alpha_e", 0.680);
 beta = InitParameter ("beta_e", 2.0);
}

class Masetti_h_DopingDepMobility : public Masetti_DopingDepMobility {
public:
 Masetti_h_DopingDepMobility (const PMI_Environment& env,
                             const PMI_AnisotropyType anisotype);
 ~Masetti_h_DopingDepMobility () {}
};

Masetti_h_DopingDepMobility::
Masetti_h_DopingDepMobility (const PMI_Environment& env,
                   const PMI_AnisotropyType anisotype) :
 Masetti_DopingDepMobility (env, anisotype)

{ // default values
 mumax = InitParameter ("mumax_h", 470.5);
 Exponent = InitParameter ("Exponent_h", 2.2);
 mumin1 = InitParameter ("mumin1_h", 44.9);
 mumin2 = InitParameter ("mumin2_h", 0.0);
```

39: Physical Model Interface

Mobility

```cpp
     mu1 = InitParameter ("mu1_h", 29.0);
     Pc = InitParameter ("Pc_h", 9.23e16);
     Cr = InitParameter ("Cr_h", 2.23e17);
     Cs = InitParameter ("Cs_h", 6.10e20);
     alpha = InitParameter ("alpha_h", 0.719);
     beta = InitParameter ("beta_h", 2.0);
    }

    extern "C"
    PMI_DopingDepMobility* new_PMI_DopingDep_e_Mobility
     (const PMI_Environment& env, const PMI_AnisotropyType anisotype)
    { return new Masetti_e_DopingDepMobility (env, anisotype);
    }

    extern "C"
    PMI_DopingDepMobility* new_PMI_DopingDep_h_Mobility
     (const PMI_Environment& env, const PMI_AnisotropyType anisotype)
    { return new Masetti_h_DopingDepMobility (env, anisotype);
    }
```

# Fitting Parameter for Ballistic Mobility

The fitting parameter $k_{300}$ that is accessible in the `BalMob` parameter set can be stress dependent and can be recalculated by any variables within the PMI model of Mobility Stress Factor on page 1339.

The name of a parameter $k_{300}$ PMI model is specified as a `BalMob` option in the command file. It should be specified as a `Factor` option as well:

```
Physics {
  Mobility (pmi_parameterk_model_name)
  Piezo (
    Model (
      Mobility (
        Factor (
          pmi_parameterk_model_name
          pmi_stress_model_name
          [ChannelDirection=<n>]
          [AutoOrientation | ParameterSetName="<psname>"]
        )
      )
    )
  )
}
```

39: Physical Model Interface

Mobility

## Dependencies

A ballistic mobility PMI model can depend on any global variables declared in the mobility stress factor PMI model with the keyword `extern`.

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_EXTERNAL PMI_ParameterK : public PMI_Vertex_Interface {
public:
  PMI_ParameterK (const PMI_Environment& env);

  virtual ~PMI_ParameterK ();

  // methods to be implemented by user
  virtual void compute
    (double& parameter_k, int q) = 0;
};
```

One virtual constructor is required for these ballistic mobility factors:

```cpp
typedef PMI_ParameterK* new_PMI_ParameterK_func
  (const PMI_Environment& env);
extern "C" PMI_ParameterK_func new_PMI_ParameterK;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_ParameterK_Base : public PMI_Vertex_Base {
public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    Input (const PMI_ParameterK_Base* ParameterK_base, const int32_t vertex);
    //pmi_float t1; // lattice temperature for material1
  };
  class Output {
  public:
    pmi_float parameter_k; // Schottky resistance
  };
  PMI_ParameterK_Base (const PMI_Environment& env);
  virtual ~PMI_ParameterK_Base ();
  virtual void compute (const Input& input1, Output& output) = 0;
};
```

 39: Physical Model Interface
Mobility

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_ParameterK_Base* new_PMI_ParameterK_Base_func
  (const PMI_Environment& env);
extern "C" PMI_ParameterK_Base_func
  new_PMI_ParameterK_Base;
```

## Example: Ballistic Mobility

This example illustrates the implementation of the `pmi_KVM_paraK` (see Effective Stress Model on page 939) using the standard C++ interface.

A variable, for example, `stress_k` should be declared in the `pmi_EffectiveStressModel` as a global variable:

```cpp
double stress_k;
```

Then, the example of the `pmi_KVM_paraK` can be created:

```cpp
#include "PMI.h"
#include "PMIModels.h"

extern double stress_k;
class PMIK: public PMI_ParameterK {
private:

public:
  PMIK(const PMI_Environment& env);
  ~PMIK();
  void compute(double& parameter_k, int q);
};

// constructor
PMIK::PMIK(const PMI_Environment& env):PMI_ParameterK(env) {
}

// destructor
PMIK::~PMIK() {
  // nothing to do here (nothing allocated)
}

void PMIK::compute(double& parameter_k, int q) {
  double stress[6];
  stress[0] = 1.e-6*ReadStress(PMI_StressXX);
  stress[1] = 1.e-6*ReadStress(PMI_StressYY);
  stress[2] = 1.e-6*ReadStress(PMI_StressZZ);
  stress[3] = 1.e-6*ReadStress(PMI_StressYZ);
  stress[4] = 1.e-6*ReadStress(PMI_StressXZ);
```

Mobility

```cpp
    stress[5] = 1.e-6*ReadStress(PMI_StressXY);
    double xModelFraction = ReadxMoleFraction();
    double DFSII = ReadDistanceFromSemiconductorInsulatorInterface();
    double x, y, z;
    ReadCoordinate (x, y, z);
    parameter_k = stress_k*xModelFraction;
    return;
}

extern "C" PMI_ParameterK* new_PMI_ParameterK( const PMI_Environment& env) {
    return new PMIK(env);
}
```

# High-Field Saturation

The high-field saturation model computes the final mobility μ as a function of the low-field mobility μ<sub>low</sub> and the driving force F<sub>hfs</sub> (see High-Field Saturation Models on page 387).

## Dependencies

The mobility μ computed by a high-field mobility model can depend on the following variables:

| `pot` | Electrostatic potential [V] |
| --- | --- |
| `t` | Lattice temperature [K] |
| `n` | Electron density [cm−3] |
| `p` | Hole density [cm−3] |
| `ct` | Carrier temperature [K] |
| `mulow` | Low-field mobility μlow [cm2V−1s−1] |
| `F` | Driving force [Vcm−1] |

> **NOTE** The carrier temperature `ct` represents the electron temperature during the evaluation of the model for electrons, and the hole temperature during the evaluation of the model for holes. The parameter `ct` is only defined for hydrodynamic simulations. Otherwise, the value of `ct` = 0 is used.

39: Physical Model Interface

Mobility

The PMI model must compute the following results:

mu Mobility μ [cm<sup>2</sup>V<sup>-1</sup>s<sup>-1</sup>]

In the case of the standard interface, the following derivatives must be computed as well:

dmudpot Derivative of μ with respect to pot [cm<sup>2</sup>V<sup>-2</sup>s<sup>-1</sup>]
dmudn Derivative of μ with respect to n [cm<sup>5</sup>V<sup>-1</sup>s<sup>-1</sup>]
dmudp Derivative of μ with respect to p [cm<sup>5</sup>V<sup>-1</sup>s<sup>-1</sup>]
dmudt Derivative of μ with respect to t [cm<sup>2</sup>V<sup>-1</sup>s<sup>-1</sup>K<sup>-1</sup>]
dmudct Derivative of μ with respect to ct [cm<sup>2</sup>V<sup>-1</sup>s<sup>-1</sup>K<sup>-1</sup>]
dmudmulow Derivative of μ with respect to mulow (1)
dmudF Derivative of μ with respect to F [cm<sup>3</sup>V<sup>-2</sup>s<sup>-1</sup>]

In most cases, it is not necessary to compute the derivatives with respect to the dopant concentrations. However, to model random dopant fluctuations (see Random Dopant Fluctuations on page 737), the PMI model must override the functions that compute the following values:

dmudNa Derivative of μ with respect to the acceptor concentration [cm<sup>5</sup>V<sup>-1</sup>s<sup>-1</sup>]
dmudNd Derivative of μ with respect to the donor concentration [cm<sup>5</sup>V<sup>-1</sup>s<sup>-1</sup>]

## Standard C++ Interface

The enumeration type `PMI_HighFieldDrivingForce` describes the driving force as specified in the command file:

```cpp
enum PMI_HighFieldDrivingForce {
  PMI_HighFieldParallelElectricField,
  PMI_HighFieldParallelToInterfaceElectricField,
  PMI_HighFieldGradQuasiFermi
};
```

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_HighFieldMobility : public PMI_Vertex_Interface {

private:
 const PMI_HighFieldDrivingForce drivingForce;
 const PMI_AnisotropyType anisoType;
```

Mobility

```cpp
public:
  PMI_HighFieldMobility (const PMI_Environment& env,
                         const PMI_HighFieldDrivingForce force,
                         const PMI_AnisotropyType anisotype);

  virtual ~PMI_HighFieldMobility ();

  PMI_HighFieldDrivingForce HighFieldDrivingForce () const;
  PMI_AnisotropyType AnisotropyType () const;

  virtual void Compute_mu
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& mu) = 0;

  virtual void Compute_dmudpot
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& dmudpot) = 0;

  virtual void Compute_dmudn
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& dmudn) = 0;

  virtual void Compute_dmudp
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& dmudp) = 0;

  virtual void Compute_dmudt
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& dmudt) = 0;

  virtual void Compute_dmudct
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& dmudct) = 0;

  virtual void Compute_dmudmulow
  (const double pot, const double n,
   const double p, const double t, const double ct,
   const double mulow, const double F, double& dmudmulow) = 0;

  virtual void Compute_dmudF
  (const double pot, const double n,
```

39: Physical Model Interface

Mobility

```cpp
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudF) = 0;

    virtual void Compute_dmudNa
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudNa);

    virtual void Compute_dmudNd
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudNd);
};
```

Two virtual constructors are required for electron and hole mobilities:

```cpp
typedef PMI_HighFieldMobility* new_PMI_HighFieldMobility_func
  (const PMI_Environment& env, const PMI_HighFieldDrivingForce force,
  const PMI_AnisotropyType anisotype);
extern "C" new_PMI_HighFieldMobility_func new_PMI_HighField_e_Mobility;
extern "C" new_PMI_HighFieldMobility_func new_PMI_HighField_h_Mobility;
```

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_HighFieldMobility_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float pot;      // electrostatic potential
    pmi_float n;        // electron density
    pmi_float p;        // hole density
    pmi_float t;        // lattice temperature
    pmi_float ct;       // carrier temperature
    pmi_float mulow;    // low field mobility
    pmi_float F;        // driving force
    pmi_float acceptor; // total acceptor concentration
    pmi_float donor;    // total donor concentration
  };

  class Output {
  public:
    pmi_float mu;       // mobility
  };

  PMI_HighFieldMobility_Base (const PMI_Environment& env,
```

Mobility

```cpp
                                       const PMI_HighFieldDrivingForce force,
                                       const PMI_AnisotropyType anisotype);
   virtual ~PMI_HighFieldMobility_Base ();

   PMI_HighFieldDrivingForce HighFieldDrivingForce () const;
   PMI_AnisotropyType AnisotropyType () const;

   virtual void compute (const Input& input, Output& output) = 0;
 };
```

The prototype for the virtual constructor is given as:

```cpp
 typedef PMI_HighFieldMobility_Base* new_PMI_HighFieldMobility_Base_func
   (const PMI_Environment& env, const PMI_HighFieldDrivingForce force,
        const PMI_AnisotropyType anisotype);
 extern "C" new_PMI_HighFieldMobility_Base_func
   new_PMI_HighField_e_Mobility_Base;
 extern "C" new_PMI_HighFieldMobility_Base_func
   new_PMI_HighField_h_Mobility_Base;
```

## Example: Canali High-Field Saturation

This example presents the PMI implementation of the Canali model:

$$ \mu = \frac{\mu_{\text{low}}}{\left[ 1 + \left( \frac{\mu_{\text{low}} F_{\text{hfs}}}{v_{\text{sat}}} \right)^\beta \right]^{1/\beta}} $$ (1322)

where $\beta = \beta_0 \left( \frac{T}{T_0} \right)^{\beta_{\text{exp}}}$ and $v_{\text{sat}} = v_{\text{sat}0} \left( \frac{T}{T_0} \right)^{v_{\text{sat,exp}}}$.

The built-in Canali model is discussed in Extended Canali Model on page 388.

```cpp
 #include "PMIModels.h"

 class Canali_HighFieldMobility : public PMI_HighFieldMobility {

 private:
  double beta, vsat, Fabs, val, valb, valb1, valb11b;
  void Compute_internal (const double t, const double mulow,
                                       const double F);

 protected:
  const double T0;
  double beta0, betaexp, vsat0, vsatexp;

 public:
  Canali_HighFieldMobility (const PMI_Environment& env,
                                       const PMI_HighFieldDrivingForce force,
```

39: Physical Model Interface

Mobility

```cpp
                           const PMI_AnisotropyType anisotype);

     ~Canali_HighFieldMobility ();

     void Compute_mu
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F,
      double& mu);

     void Compute_dmudpot
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudpot);

     void Compute_dmudn
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudn);

     void Compute_dmudp
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudp);

     void Compute_dmudt
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudt);

     void Compute_dmudct
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudct);

     void Compute_dmudmulow
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudmulow);

     void Compute_dmudF
      (const double pot, const double n,
      const double p, const double t, const double ct,
      const double mulow, const double F, double& dmudF);
    };

    void Canali_HighFieldMobility::
    Compute_internal (const double t, const double mulow, const double F)
```

Mobility

```cpp
{ beta = beta0 * pow (t/T0, betaexp);
  vsat = vsat0 * pow (t/T0, -vsatexp);
  Fabs = fabs (F);
  val = mulow * Fabs / vsat;
  valb = pow (val, beta);
  valb1 = 1.0 + valb;
  valb11b = pow (valb1, 1.0/beta);
}

Canali_HighFieldMobility::
Canali_HighFieldMobility (const PMI_Environment& env,
                          const PMI_HighFieldDrivingForce force,
                          const PMI_AnisotropyType anisotype) :
 PMI_HighFieldMobility (env, force, anisotype),
 T0 (300.0)
{
}

Canali_HighFieldMobility::
~Canali_HighFieldMobility ()
{
}

void Canali_HighFieldMobility::
Compute_mu (const double pot, const double n,
            const double p, const double t, const double ct,
            const double mulow, const double F, double& mu)
{ Compute_internal (t, mulow, F);
  mu = mulow / valb11b;
}

void Canali_HighFieldMobility::
Compute_dmudpot (const double pot, const double n,
                 const double p, const double t, const double ct,
                 const double mulow, const double F, double& dmudpot)
{ dmudpot = 0.0;
}

void Canali_HighFieldMobility::
Compute_dmudn (const double pot, const double n,
               const double p, const double t, const double ct,
               const double mulow, const double F, double& dmudn)
{ dmudn = 0.0;
}

void Canali_HighFieldMobility::
Compute_dmudp (const double pot, const double n,
```

39: Physical Model Interface

Mobility

```cpp
                   const double p, const double t, const double ct,
                   const double mulow, const double F, double& dmudp)
{ dmudp = 0.0;
}

void Canali_HighFieldMobility::
Compute_dmudt (const double pot, const double n,
               const double p, const double t, const double ct,
               const double mulow, const double F, double& dmudt)
{ Compute_internal (t, mulow, F);
  const double mu = mulow / valb11b;
  const double dmudbeta = mu * (log (valb1) / (beta*beta) -
                                valb * log (val) / (beta * valb1));
  const double dmudvsat = (mu * valb) / (valb1 * vsat);
  const double dbetadt = beta * betaexp / t;
  const double dvsatdt = -vsat * vsatexp / t;
  dmudt = dmudbeta * dbetadt + dmudvsat * dvsatdt;
}

void Canali_HighFieldMobility::
Compute_dmudct (const double pot, const double n,
                const double p, const double t, const double ct,
                const double mulow, const double F, double& dmudct)
{ dmudct = 0.0;
}

void Canali_HighFieldMobility::
Compute_dmudmulow (const double pot, const double n,
                   const double p, const double t, const double ct,
                   const double mulow, const double F, double& dmudmulow)
{ Compute_internal (t, mulow, F);
  dmudmulow = 1.0 / (valb1 * valb11b);
}

void Canali_HighFieldMobility::
Compute_dmudF (const double pot, const double n,
               const double p, const double t, const double ct,
               const double mulow, const double F, double& dmudF)
{ Compute_internal (t, mulow, F);
  const double mu = mulow / valb11b;
  const double signF = (F >= 0.0) ? 1.0 : -1.0;
  dmudF = -mu * pow (mulow/vsat, beta) * pow (Fabs, beta-1.0) *
        signF / valb1;
}

class Canali_e_HighFieldMobility : public Canali_HighFieldMobility {
public:
  Canali_e_HighFieldMobility (const PMI_Environment& env,
```

Mobility

```cpp
                            const PMI_HighFieldDrivingForce force,
                            const PMI_AnisotropyType anisotype);

 ~Canali_e_HighFieldMobility () {}
};

Canali_e_HighFieldMobility::
Canali_e_HighFieldMobility (const PMI_Environment& env,
                   const PMI_HighFieldDrivingForce force,
                   const PMI_AnisotropyType anisotype) :
 Canali_HighFieldMobility (env, force, anisotype)
{ // default values
 beta0 = InitParameter ("beta0_e", 1.109);
 betaexp = InitParameter ("betaexp_e", 0.66);
 vsat0 = InitParameter ("vsat0_e", 1.07e7);
 vsatexp = InitParameter ("vsatexp_e", 0.87);
}

class Canali_h_HighFieldMobility : public Canali_HighFieldMobility {
public:
 Canali_h_HighFieldMobility (const PMI_Environment& env,
                            const PMI_HighFieldDrivingForce force,
                            const PMI_AnisotropyType anisotype);

 ~Canali_h_HighFieldMobility () {}
};

Canali_h_HighFieldMobility::
Canali_h_HighFieldMobility (const PMI_Environment& env,
                   const PMI_HighFieldDrivingForce force,
                   const PMI_AnisotropyType anisotype) :
 Canali_HighFieldMobility (env, force, anisotype)
{ // default values
 beta0 = InitParameter ("beta0_h", 1.213);
 betaexp = InitParameter ("betaexp_h", 0.17);
 vsat0 = InitParameter ("vsat0_h", 8.37e6);
 vsatexp = InitParameter ("vsatexp_h", 0.52);
}

extern "C"
PMI_HighFieldMobility* new_PMI_HighField_e_Mobility
 (const PMI_Environment& env, const PMI_HighFieldDrivingForce force,
  const PMI_AnisotropyType anisotype)
{ return new Canali_e_HighFieldMobility (env, force, anisotype);
}

extern "C"
PMI_HighFieldMobility* new_PMI_HighField_h_Mobility
```

39: Physical Model Interface
Mobility

```cpp
(const PMI_Environment& env, const PMI_HighFieldDrivingForce force,
 const PMI_AnisotropyType anisotype)
{ return new Canali_h_HighFieldMobility (env, force, anisotype);
}
```

# High-Field Saturation With Two Driving Forces

This PMI allows you to compute the final mobility $\mu$ as a function of the low-field mobility $\mu_{low}$ and two driving fields (see High-Field Saturation Models on page 387). One field is the gradient of the quasi-Fermi energy; the other is derived from the electric field (see Driving Force Models on page 395).

## Command File

The model is specified using `PMIModel` as an option to `HighFieldSaturation`, `eHighFieldSaturation`, or `hHighFieldSaturation`. The name of the model must be provided with the `Name` parameter of `PMIModel`. Optionally, an index and a string can be specified, which will be passed to and interpreted by the model:

```
eMobility(
   HighFieldSaturation(
     PMIModel (
          Name = <string>
          Index = <int>
          String = <string>)
     EparallelToInterface | Eparallel | ElectricField)
)
```

## Dependencies

The high-field mobility can depend on the following variables:

| mulow | Low-field mobility $\mu_{low}$ [ cm²V⁻¹s⁻¹ ] |
| --- | --- |
| n | Electron density [ cm⁻³ ] |
| p | Hole density [ cm⁻³ ] |
| T | Lattice temperature [ K ] |
| cT | Carrier temperature [ K ] |
| Epar | Modulus of electric field driving force [ Vcm⁻¹ ] |
| gradQF | Modulus of gradient of the quasi-Fermi energy [ eVcm⁻¹ ] |

39: Physical Model Interface

Mobility

| `EprodQF` | Scalar product of electric field driving force and gradient of quasi-Fermi energy [ eVVcm–2 ] |
| --- | --- |
| `Na0` | Acceptor concentration [ cm–3 ] |
| `Nd0` | Donor concentration [ cm–3 ] |

The electric field used to obtain `Epar` is determined by `EparallelToInterface`, `Eparallel`, or `ElectricField` as for other high-field mobility models (see Driving Force Models on page 395). With `EparallelToInterface`, the electric field used to compute `EprodQF` is the projection of the electric field parallel to the interface; otherwise, the full electric field is used to obtain `EprodQF`.

The PMI model must compute the following results:

| `val` | High-field mobility $\mu$ [ cm2V–1s–1 ] |
| --- | --- |

In the case of the standard interface, the following derivatives must be computed as well:

| `dval_dmulow` | Derivative of $\mu$ with respect to `mulow` [ 1 ] |
| --- | --- |
| `dval_dn` | Derivative of $\mu$ with respect to `n` [ cm5V–1s–1 ] |
| `dval_dp` | Derivative of $\mu$ with respect to `p` [ cm5V–1s–1 ] |
| `dval_dT` | Derivative of $\mu$ with respect to `T` [ cm2V–1s–1K–1 ] |
| `dval_dcT` | Derivative of $\mu$ with respect to `cT` [ cm2V–1s–1K–1 ] |
| `dval_dEpar` | Derivative of $\mu$ with respect to `Epar` [ cm3V–2s–1 ] |
| `dval_dgradQF` | Derivative of $\mu$ with respect to `gradQF` [ cm3eV–1V–1s–1 ] |
| `dval_dEprodQF` | Derivative of $\mu$ with respect to `EprodQF` [ cm4eV–1V–2s–1 ] |
| `dval_dNa0` | Derivative of $\mu$ with respect to `Na0` [ cm5V–1s–1 ] |
| `dval_dNd0` | Derivative of $\mu$ with respect to `Nd0` [ cm5V–1s–1 ] |

# Standard C++ Interface

The PMI base class is declared in `PMIModels.h` as:

```cpp
class PMI_HighFieldMobility2 : public PMI_Vertex_Interface {

public:
      // the input data coming from the simulator
      class idata {
```

39: Physical Model Interface

Mobility

```cpp
    public:
      double mulow() const;       // low-field mobility
      double n() const;           // electron density
      double p() const;           // hole density
      double T() const;           // lattice temperature
      double cT() const;          // carrier temperature
      double Epar() const;        // parallel electric field
      double gradQF() const;      // gradient of quasi-Fermi energy
      double EprodQF() const;     // product gradient QF and electric field
      double Na0() const;         // acceptor concentration
      double Nd0() const;         // donor concentration
    };

    // the results computed by the PMI
    class odata {
    public:
      double& val();              // mobility
      double& dval_dmulow();      // derivative wrt. low-field mobility
      double& dval_dn();          // wrt. electron density
      double& dval_dp();          // wrt. hole density
      double& dval_dT();          // wrt. lattice temperature
      double& dval_dcT();         // wrt. carrier temperature
      double& dval_dEpar();       // wrt. parallel electric field
      double& dval_dgradQF();     // wrt. gradient of quasi-Fermi energy
      double& dval_dEprodQF();    // wrt. product gradient QF and field
      double& dval_dNa0();        // wrt. acceptor concentration
      double& dval_dNd0();        // wrt. donor concentration
    };

    // constructor and destructor
    PMI_HighFieldMobility2(const PMI_Environment& env,
                              const int model_index,
                              const std::string& model_string,
                              const PMI_AnisotropyType anisotype);
    virtual ~PMI_HighFieldMobility2();

    PMI_AnisotropyType AnisotropyType () const;

    // compute value and derivatives
    virtual void compute(const idata* id, odata* od) = 0;
  };
```

The `Compute` function receives its input from `id`. It returns the results using `od` by assignment using the member functions of `od`. The framework initializes the values of the derivatives to zero, so you only have to compute derivatives for variables the PMI actually uses.

Mobility

The following virtual constructor must be implemented:

```cpp
typedef PMI_HighFieldMobility2* new_PMI_HighFieldMobility2_func
  (const PMI_Environment& env,
   int model_index,
   const std::string& model_string,
   const PMI_AnisotropyType anisotype);
extern "C" new_PMI_HighFieldMobility2_func new_PMI_HighFieldMobility2;
```

## Simplified C++ Interface

The following base class is declared in `PMI.h`:

```cpp
class PMI_HighFieldMobility2_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    Input (const PMI_HighFieldMobility2_Base* highfieldmobility2_base,
         const int vertex);
    pmi_float mulow;    // low-field mobility
    pmi_float n;        // electron density
    pmi_float p;        // hole density
    pmi_float T;        // lattice temperature
    pmi_float cT;       // carrier temperature
    pmi_float Epar;     // parallel electric field
    pmi_float gradQF;   // gradient of quasi-Fermi energy
    pmi_float EprodQF;  // product gradient QF and electric field
    pmi_float Na0;      // acceptor concentration
    pmi_float Nd0;      // donor concentration
  };

  class Output {
  public:
    pmi_float val;      // mobility
  };

  PMI_HighFieldMobility2_Base (const PMI_Environment& env,
                              const int model_index,
                              const std::string& model_string,
                              const PMI_AnisotropyType anisotype);
  virtual ~PMI_HighFieldMobility2_Base ();

  int model_index () const;
  const std::string& model_string () const;
  PMI_AnisotropyType AnisotropyType () const;
```

39: Physical Model Interface
Mobility

```cpp
      virtual void compute (const Input& input, Output& output) = 0;
    };
```

The following virtual constructor is provided:

```cpp
    typedef PMI_HighFieldMobility2_Base* new_PMI_HighFieldMobility2_Base_func
      (const PMI_Environment& env, const int model_index,
      const std::string& model_string, const PMI_AnisotropyType anisotype);
    extern "C"
    new_PMI_HighFieldMobility2_Base_func new_PMI_HighField_Mobility2_Base;
```

# Mobility Degradation at Interfaces

Sentaurus Device uses Mathiessen’s rule:

$$ \frac{1}{\mu} = \frac{1}{\mu_{\text{dop}}} + \frac{1}{\mu_{\text{enormal}}} \text{ (1323)} $$

to combine the constant and doping-dependent mobility $\mu_{\text{dop}}$, and the surface contribution $\mu_{\text{enormal}}$ (see Mobility Degradation at Interfaces on page 357). To express no mobility degradation, for example, in the bulk of a device, it is necessary to set $\mu_{\text{enormal}} = \infty$. To avoid numeric difficulties, the PMI requires the calculation of the inverse mobility $1/\mu_{\text{enormal}}$ instead of $\mu_{\text{enormal}}$.

As an additional precaution, Sentaurus Device does not evaluate the PMI model if the normal electric field $F_{\perp}$ is less than EnormMinimum, where EnormMinimum is a parameter that can be specified in the `PMI_model_name` section of the parameter file. By default, EnormMinimum = 1 V/cm is used.

## Dependencies

The mobility degradation at interfaces can depend on the following variables:

* **dist**: Distance to nearest interface [cm]
* **pot**: Electrostatic potential [V]
* **enorm**: Normal electric field [ Vcm<sup>–1</sup> ]
* **t**: Lattice temperature [K]
* **n**: Electron density [ cm<sup>–3</sup> ]
* **p**: Hole density [ cm<sup>–3</sup> ]
* **ct**: Carrier temperature [K]

Mobility

**NOTE** If Sentaurus Device cannot determine the distance to the nearest interface, then the value of dist = 10<sup>10</sup> is used.

The carrier temperature `ct` represents the electron temperature during the evaluation of the model for electrons, and the hole temperature during the evaluation of the model for holes. The parameter `ct` is only defined for hydrodynamic simulations. Otherwise, the value of `ct` = 0 is used.

The PMI model must compute the following results:

`muinv` Inverse of mobility $1/\mu_{\text{enormal}}$ [ cm<sup>-2</sup>Vs ]

In the case of the standard interface, the following derivatives must be computed as well:

`dmuinvdpot` Derivative of $1/\mu_{\text{enormal}}$ with respect to `pot` [ cm<sup>-2</sup>s ]
`dmuinvdenorm` Derivative of $1/\mu_{\text{enormal}}$ with respect to `enorm` [ cm<sup>-1</sup>s ]
`dmuinvdn` Derivative of $1/\mu_{\text{enormal}}$ with respect to `n` [ cmVs ]
`dmuinvdp` Derivative of $1/\mu_{\text{enormal}}$ with respect to `p` [ cmVs ]
`dmuinvdt` Derivative of $1/\mu_{\text{enormal}}$ with respect to `t` [ cm<sup>-2</sup>VsK<sup>-1</sup> ]
`dmuinvdct` Derivative of $1/\mu_{\text{enormal}}$ with respect to `ct` [ cm<sup>-2</sup>VsK<sup>-1</sup> ]

In most cases, it is not necessary to compute the derivatives with respect to the dopant concentrations. However, to model random dopant fluctuations (see Random Dopant Fluctuations on page 737), the PMI model must override the functions that compute the following values:

`dmuinvdNa` Derivative of $1/\mu_{\text{enormal}}$ with respect to the acceptor concentration [ cmVs ]
`dmuinvdNd` Derivative of $1/\mu_{\text{enormal}}$ with respect to the donor concentration [ cmVs ]

## Standard C++ Interface

The enumeration type `PMI_EnormalType` describes the type of the normal electric field $F_{\perp}$:

```cpp
enum PMI_EnormalType {
  PMI_EnormalToCurrent,
  PMI_EnormalToInterface
};
```

39: Physical Model Interface

Mobility

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_EnormalMobility : public PMI_Vertex_Interface {

public:
 PMI_EnormalMobility (const PMI_Environment& env,
       const PMI_EnormalType type,
       const PMI_AnisotropyType anisotype);

 virtual ~PMI_EnormalMobility ();

 PMI_EnormalType EnormalType () const;
 PMI_AnisotropyType AnisotropyType () const;

 virtual void Compute_muinv
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& muinv) = 0;

 virtual void Compute_dmuinvdpot
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& dmuinvdpot) = 0;

 virtual void Compute_dmuinvdenorm
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& dmuinvdenorm) = 0;

 virtual void Compute_dmuinvdn
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& dmuinvdn) = 0;

 virtual void Compute_dmuinvdp
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& dmuinvdp) = 0;

 virtual void Compute_dmuinvdt
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& dmuinvdt) = 0;

 virtual void Compute_dmuinvdct
 (const double dist, const double pot,
  const double enorm, const double n, const double p,
  const double t, const double ct, double& dmuinvdct) = 0;
```

Mobility

```cpp
    virtual void Compute_dmuinvdNa
      (const double dist, const double pot,
       const double enorm, const double n, const double p,
       const double t, const double ct, double& dmuinvdNa);

    virtual void Compute_dmuinvdNd
      (const double dist, const double pot,
       const double enorm, const double n, const double p,
       const double t, const double ct, double& dmuinvdNd);
};
```

Two virtual constructors are required for electron and hole mobilities:

```cpp
typedef PMI_EnormalMobility* new_PMI_EnormalMobility_func
  (const PMI_Environment& env, const PMI_EnormalType type,
   const PMI_AnisotropyType anisotype);
extern "C" new_PMI_EnormalMobility_func new_PMI_Enormal_e_Mobility;
extern "C" new_PMI_EnormalMobility_func new_PMI_Enormal_h_Mobility;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_EnormalMobility_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float dist;     // distance to nearest interface
    pmi_float pot;      // electrostatic potential
    pmi_float enorm;    // normal electric field
    pmi_float n;        // electron density
    pmi_float p;        // hole density
    pmi_float t;        // lattice temperature
    pmi_float ct;       // carrier temperature
    pmi_float acceptor; // total acceptor concentration
    pmi_float donor;    // total donor concentration
  };

  class Output {
  public:
    pmi_float muinv;    // inverse of mobility degradation
  };

  PMI_EnormalMobility_Base (const PMI_Environment& env,
                        const PMI_EnormalType type,
                        const PMI_AnisotropyType anisotype);
  virtual ~PMI_EnormalMobility_Base ();
```

39: Physical Model Interface

Mobility

```cpp
    PMI_EnormalType EnormalType () const;
    PMI_AnisotropyType AnisotropyType () const;

    virtual void compute (const Input& input, Output& output) = 0;
  };
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_EnormalMobility_Base* new_PMI_EnormalMobility_Base_func
  (const PMI_Environment& env, const PMI_EnormalType type,
  const PMI_AnisotropyType anisotype);
extern "C" new_PMI_EnormalMobility_Base_func new_PMI_Enormal_e_Mobility_Base;
extern "C" new_PMI_EnormalMobility_Base_func new_PMI_Enormal_h_Mobility_Base;
```

# Example: Lombardi Mobility Degradation

This example illustrates the implementation of a slightly simplified Lombardi model (see Mobility Degradation at Interfaces on page 357) using the PMI. The contribution due to acoustic phonon-scattering has the form:

$$ \mu_{ac} = \frac{B}{F_{\perp}} + \frac{CN_{i}^{\lambda}}{F_{\perp}^{1/3}(T/T_{0})} $$ (1324)

where $T_{0} = 300\text{ K}$.

The contribution due to surface roughness scattering is given by:

$$ \mu_{sr} = \left( \frac{F_{\perp}^{2}}{\delta} + \frac{F_{\perp}^{3}}{\eta} \right)^{-1} $$ (1325)

The mobilities $\mu_{ac}$ and $\mu_{sr}$ are combined according to Mathiessen’s rule with an additional damping factor:

$$ \frac{1}{\mu_{enormal}} = e^{-\frac{l}{l_{crit}}} \cdot \left( \frac{1}{\mu_{ac}} + \frac{1}{\mu_{sr}} \right) $$ (1326)

where $l$ is the distance to the nearest semiconductor–insulator interface point:

```cpp
#include "PMIModels.h"

class Lombardi_EnormalMobility : public PMI_EnormalMobility {

protected:
  const double T0;
  double B, C, lambda, delta, eta, l_crit;
```

Mobility

```cpp
public:
  Lombardi_EnormalMobility (const PMI_Environment& env,
                            const PMI_EnormalType type,
                            const PMI_AnisotropyType anisotype);

  ~Lombardi_EnormalMobility ();

  void Compute_muinv
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& muinv);

  void Compute_dmuinvdpot
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& dmuinvdpot);

  void Compute_dmuinvdenorm
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& dmuinvdenorm);

  void Compute_dmuinvdn
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& dmuinvdn);

  void Compute_dmuinvdp
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& dmuinvdp);

  void Compute_dmuinvdt
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& dmuinvdt);

  void Compute_dmuinvdct
    (const double dist, const double pot,
    const double enorm, const double n, const double p,
    const double t, const double ct, double& dmuinvdct);
};

Lombardi_EnormalMobility::
Lombardi_EnormalMobility (const PMI_Environment& env,
                          const PMI_EnormalType type,
```

39: Physical Model Interface

Mobility

```cpp
                          const PMI_AnisotropyType anisotype) :
PMI_EnormalMobility (env, type, anisotype),
T0 (300.0)
{
}

Lombardi_EnormalMobility::
~Lombardi_EnormalMobility ()
{
}

void Lombardi_EnormalMobility::
Compute_muinv (const double dist, const double pot,
               const double enorm, const double n, const double p,
               const double t, const double ct, double& muinv)
{ const double Ni = ReadDoping (PMI_Donor) + ReadDoping (PMI_Acceptor);
  const double denom_ac_inv =
  B + pow (enorm, 2.0/3.0) * C * pow (Ni, lambda) * T0 / t;
  const double mu_ac_inv = enorm / denom_ac_inv;
  const double mu_sr_inv = enorm * enorm / delta + pow (enorm, 3.0) / eta;
  const double damping = exp (-dist/l_crit);
  muinv = damping * (mu_ac_inv + mu_sr_inv);
}

void Lombardi_EnormalMobility::
Compute_dmuinvdpot (const double dist, const double pot,
                    const double enorm, const double n, const double p,
                    const double t, const double ct, double& dmuinvdpot)
{ dmuinvdpot = 0.0;
}

void Lombardi_EnormalMobility::
Compute_dmuinvdenorm (const double dist, const double pot,
                      const double enorm, const double n, const double p,
                      const double t, const double ct, double& dmuinvdenorm)
{ const double Ni = ReadDoping (PMI_Donor) + ReadDoping (PMI_Acceptor);
  const double denom_ac_inv =
  B + pow (enorm, 2.0/3.0) * C * pow (Ni, lambda) * T0 / t;
  const double dmu_ac_inv_denorm =
  (2.0 * B + denom_ac_inv) / (3.0 * denom_ac_inv * denom_ac_inv);
  const double mu_sr_inv_denorm =
  2.0 * enorm / delta + 3.0 * enorm * enorm / eta;
  const double damping = exp (-dist/l_crit);
  dmuinvdenorm = damping * (dmu_ac_inv_denorm + mu_sr_inv_denorm);
}

void Lombardi_EnormalMobility::
Compute_dmuinvdn (const double dist, const double pot,
```

Mobility

```cpp
                  const double enorm, const double n, const double p,
                  const double t, const double ct, double& dmuinvdn)
{ dmuinvdn = 0.0;
}

void Lombardi_EnormalMobility::
Compute_dmuinvdp (const double dist, const double pot,
                  const double enorm, const double n, const double p,
                  const double t, const double ct, double& dmuinvdp)
{ dmuinvdp = 0.0;
}

void Lombardi_EnormalMobility::
Compute_dmuinvdt (const double dist, const double pot,
                  const double enorm, const double n, const double p,
                  const double t, const double ct, double& dmuinvdt)
{ const double Ni = ReadDoping (PMI_Donor) + ReadDoping (PMI_Acceptor);
  const double factor = pow (enorm, 2.0/3.0) * C * pow (Ni, lambda) * T0;
  const double denom_ac_inv = B + factor / t;
  const double dmu_ac_inv_dt =
   enorm * factor / (denom_ac_inv * denom_ac_inv * t * t);
  const double damping = exp (-dist/l_crit);
  dmuinvdt = damping * dmu_ac_inv_dt;
}

void Lombardi_EnormalMobility::
Compute_dmuinvdct (const double dist, const double pot,
                   const double enorm, const double n, const double p,
                   const double t, const double ct, double& dmuinvdct)
{ dmuinvdct = 0.0;
}

class Lombardi_e_EnormalMobility : public Lombardi_EnormalMobility {
public:
 Lombardi_e_EnormalMobility (const PMI_Environment& env,
                             const PMI_EnormalType type,
                             const PMI_AnisotropyType anisotype);

 ~Lombardi_e_EnormalMobility () {}
};

Lombardi_e_EnormalMobility::
Lombardi_e_EnormalMobility (const PMI_Environment& env,
                    const PMI_EnormalType type,
                    const PMI_AnisotropyType anisotype) :
 Lombardi_EnormalMobility (env, type, anisotype)
{ // default values
 B = InitParameter ("B_e", 4.750e7);
```

39: Physical Model Interface

Mobility

```cpp
 C = InitParameter ("C_e", 580.0);
 lambda = InitParameter ("lambda_e", 0.125);
 delta = InitParameter ("delta_e", 5.82e14);
 eta = InitParameter ("eta_e", 5.82e30);
 l_crit = InitParameter ("l_crit_e", 1.0e-6);
}

class Lombardi_h_EnormalMobility : public Lombardi_EnormalMobility {
public:
 Lombardi_h_EnormalMobility (const PMI_Environment& env,
                            const PMI_EnormalType type,
                            const PMI_AnisotropyType anisotype);

 ~Lombardi_h_EnormalMobility () {}
};

Lombardi_h_EnormalMobility::
Lombardi_h_EnormalMobility (const PMI_Environment& env,
                   const PMI_EnormalType type,
                   const PMI_AnisotropyType anisotype) :
 Lombardi_EnormalMobility (env, type, anisotype)
{ // default values
 B = InitParameter ("B_h", 9.925e6);
 C = InitParameter ("C_h", 2947.0);
 lambda = InitParameter ("lambda_h", 0.0317);
 delta = InitParameter ("delta_h", 2.0546e14);
 eta = InitParameter ("eta_h", 2.0546e30);
 l_crit = InitParameter ("l_crit_h", 1.0e-6);
}

extern "C"
PMI_EnormalMobility* new_PMI_Enormal_e_Mobility
 (const PMI_Environment& env, const PMI_EnormalType type,
  const PMI_AnisotropyType anisotype)
{ return new Lombardi_e_EnormalMobility (env, type, anisotype);
}

extern "C"
PMI_EnormalMobility* new_PMI_Enormal_h_Mobility
 (const PMI_Environment& env, const PMI_EnormalType type,
  const PMI_AnisotropyType anisotype)
{ return new Lombardi_h_EnormalMobility (env, type, anisotype);
}
```

39: Physical Model Interface

Semiconductor Band Structure

# Semiconductor Band Structure

This section presents the following PMIs:

*   Apparent Band-Edge Shift

*   Band Gap

*   Bandgap Narrowing

*   Effective Mass

*   Electron Affinity

## Apparent Band-Edge Shift

The apparent band-edge shift $\Lambda_{PMI}$ is a quantity similar to bandgap narrowing. In contrast to bandgap narrowing, the apparent band-edge shift can depend on the solution variables (electron and hole densities, lattice temperature, and electric field). Conversely, the apparent band-edge shift does not take effect in all situations where a real band-edge shift takes effect (this is why the band-edge shift is called *apparent*).

Implementationwise, the apparent band-edge shift is an extension of the density gradient model (see Density Gradient Model on page 316). For the PMI model, this implies:

*   Sentaurus Device applies the apparent band-edge shift $\Lambda_{PMI}$ everywhere where it applies quantization corrections.

*   By default, the apparent band-edge shift that Sentaurus Device computes is not equal to $\Lambda_{PMI}$, but contains contributions from quantization. To remove them, set $\gamma = 0$ (see Density Gradient Model on page 316).

*   Apart from a specification in the `Physics` section, it is necessary to specify additional equations in the `Solve` section (see Using the Density Gradient Model on page 318).

To select a model to compute $\Lambda_{PMI}$, specify its name using the `LocalModel` keyword (see Table 293 on page 1594). The same models for $\Lambda_{PMI}$ can be used for the shift of the conduction and valence bands. A positive value of $\Lambda_{PMI}$ means that the band shifts outwards, away from midgap (therefore, the band gap widens).

### Dependencies

The apparent band-edge shift $\Lambda_{PMI}$ can depend on:

n Electron density [ cm<sup>–3</sup> ]

39: Physical Model Interface
Semiconductor Band Structure

```
p        Hole density [ cm⁻³ ]
t        Lattice temperature [ K ]
F        Absolute value of the electric field [ Vcm⁻¹ ]
```

The PMI model must compute the following values:

```
shift    Apparent band-edge shift ΛPMI [ eV ]
```

In the case of the standard interface, the following derivatives must be computed as well:

```
dshiftdn  Derivative of ΛPMI with respect to n [ eVcm³ ]
dshiftdp  Derivative of ΛPMI with respect to p [ eVcm³ ]
dshiftdt  Derivative of ΛPMI with respect to t [ eVK⁻¹ ]
dshiftdf  Derivative of ΛPMI with respect to f [ eVcmV⁻¹ ]
```

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_ApparentBandEdgeShift : public PMI_Vertex_Interface {

public:
 PMI_ApparentBandEdgeShift (const PMI_Environment& env);
 virtual ~PMI_ApparentBandEdgeShift ();

 virtual void Compute_shift
 (const double n, const double p,
  const double t, const double f,
  double& shift) = 0;

 virtual void Compute_dshiftdn
 (const double n, const double p,
  const double t, const double f,
  double& dshiftdn) = 0;

 virtual void Compute_dshiftdp
 (const double n, const double p,
  const double t, const double f,
  double& dshiftdp) = 0;

 virtual void Compute_dshiftdt
```

1269

Semiconductor Band Structure

```cpp
      (const double n, const double p,
       const double t, const double f,
       double& dshiftdt) = 0;

    virtual void Compute_dshiftdf
      (const double n, const double p,
       const double t, const double f,
       double& dshiftdf) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_ApparentBandEdgeShift* new_PMI_ApparentBandEdgeShift_func
  (const PMI_Environment& env);
extern "C" new_PMI_ApparentBandEdgeShift_func new_PMI_ApparentBandEdgeShift;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_ApparentBandEdgeShift_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
     pmi_float n; // electron density
     pmi_float p; // hole density
     pmi_float t; // lattice temperature
     pmi_float f; // absolute value of electric field
  };

  class Output {
  public:
     pmi_float shift; // apparent band-edge shift
  };

  PMI_ApparentBandEdgeShift_Base (const PMI_Environment& env);
  virtual ~PMI_ApparentBandEdgeShift_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_ApparentBandEdgeShift_Base*
  new_PMI_ApparentBandEdgeShift_Base_func (const PMI_Environment& env);
extern "C" new_PMI_ApparentBandEdgeShift_Base_func
  new_PMI_ApparentBandEdgeShift_Base;
```

39: Physical Model Interface
Semiconductor Band Structure

# Band Gap

Sentaurus Device provides a PMI to compute the energy band gap $E_g$ in a semiconductor. It can be specified in the `Physics` section of the command file. For example:

```
Physics {
  EffectiveIntrinsicDensity (
    BandGap (pmi_model_name)
  )
}
```

The default bandgap model in Sentaurus Device is selected explicitly by the keyword `Default`:

```
Physics {
  EffectiveIntrinsicDensity (
    BandGap (Default)
  )
}
```

## Dependencies

The band gap $E_g$ can depend on:

t Lattice temperature [K]

The PMI model must compute the following results:

bg Band gap $E_g$ [eV]

In the case of the standard interface, the following derivatives must be computed as well:

dbgdt Derivative of `bg` with respect to `t` [eVK<sup>-1</sup>]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_BandGap : public PMI_Vertex_Interface {

public:
  PMI_BandGap (const PMI_Environment& env);
  virtual ~PMI_BandGap ();
```

Semiconductor Band Structure

```cpp
    virtual void Compute_bg
      (const double t, double& bg) = 0;

    virtual void Compute_dbgdt
      (const double t, double& dbgdt) = 0;
  };
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_BandGap* new_PMI_BandGap_func (const PMI_Environment& env);
extern "C" new_PMI_BandGap_func new_PMI_BandGap;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_BandGap_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;    // lattice temperature
  };

  class Output {
  public:
    pmi_float bg;   // band gap
  };

  PMI_BandGap_Base (const PMI_Environment& env);
  virtual ~PMI_BandGap_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_BandGap_Base* new_PMI_BandGap_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_BandGap_Base_func new_PMI_BandGap_Base;
```

## Example: Default Temperature Dependence

Sentaurus Device uses the following default bandgap model:

$$ E_g(t) = E_g(0) - \frac{\alpha t^2}{t + \beta} $$ (1327)

39: Physical Model Interface

Semiconductor Band Structure

$E_g(0)$ denotes the band gap at 0 K.

```cpp
#include "PMIModels.h"

class Default_BandGap : public PMI_BandGap {

private:
  double Eg0, alpha, beta;

public:
  Default_BandGap (const PMI_Environment& env);

  ~Default_BandGap ();

  void Compute_bg (const double t, double& bg);

  void Compute_dbgdt (const double t, double& dbgdt);
};

Default_BandGap::
Default_BandGap (const PMI_Environment& env) :
  PMI_BandGap (env)
{ Eg0 = InitParameter ("Eg0", 1.16964);
  alpha = InitParameter ("alpha", 4.73e-4);
  beta = InitParameter ("beta", 636);
}

Default_BandGap::
~Default_BandGap ()
{
}

void Default_BandGap::
Compute_bg (const double t, double& bg)
{ bg = Eg0 - alpha * t * t / (t + beta);
}

void Default_BandGap::
Compute_dbgdt (const double t, double& dbgdt)
{ dbgdt = - alpha * t * (t + 2.0 * beta) / ((t + beta) * (t + beta));
}

extern "C"
PMI_BandGap* new_PMI_BandGap
  (const PMI_Environment& env)
{ return new Default_BandGap (env);
}
```

Semiconductor Band Structure

---

# Bandgap Narrowing

Sentaurus Device provides a PMI to compute bandgap narrowing (see Band Gap and Electron Affinity on page 259). A user model is activated with the keyword `EffectiveIntrinsicDensity` in the Physics section of the command file:

```
Physics {
      EffectiveIntrinsicDensity (pmi_model_name)
}
```

## Dependencies

A PMI bandgap narrowing model has no explicit dependencies. However, it can depend on doping concentrations through the runtime support.

The PMI model must compute:

`bgn` Bandgap narrowing $\Delta E_g^0$ [eV]

In most cases, it is not necessary to compute the derivatives with respect to the dopant concentrations. However, to model dopant fluctuations (see Chapter 23 on page 729), in the standard interface the PMI model must override the functions that compute the following values:

`dbgndNa` Derivative of $\Delta E_g^0$ with respect to the acceptor concentration [ cm<sup>3</sup> eV ]
`dbgndNd` Derivative of $\Delta E_g^0$ with respect to the donor concentration [ cm<sup>3</sup> eV ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_BandGapNarrowing : public PMI_Vertex_Interface {
public:
      PMI_BandGapNarrowing (const PMI_Environment& env);
      virtual ~PMI_BandGapNarrowing ();
      virtual void Compute_bgn (double& bgn) = 0;
      virtual void Compute_dbgndNa (double& dbgndNa);
      virtual void Compute_dbgndNd (double& dbgndNd);
};
```

39: Physical Model Interface
Semiconductor Band Structure

The following virtual constructor must be implemented:

```cpp
typedef PMI_BandGapNarrowing* new_PMI_BandGapNarrowing_func
  (const PMI_Environment& env);
extern "C" new_PMI_BandGapNarrowing_func new_PMI_BandGapNarrowing;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_BandGapNarrowing_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float acceptor; // total acceptor concentration
    pmi_float donor;    // total donor concentration
  };

  class Output {
  public:
    pmi_float bgn;      // bandgap narrowing
  };

  PMI_BandGapNarrowing_Base (const PMI_Environment& env);
  virtual ~PMI_BandGapNarrowing_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_BandGapNarrowing_Base* new_PMI_BandGapNarrowing_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_BandGapNarrowing_Base_func new_PMI_BandGapNarrowing_Base;
```

## Example: Bennett–Wilson Bandgap Narrowing

The default bandgap narrowing model in Sentaurus Device (Bennett–Wilson) is given by:

$$ \Delta E_g^0 = \begin{cases} E_{ref} \left[ \ln \frac{N_{tot}}{N_{ref}} \right]^2, & N_{tot} > N_{ref}, \\ 0, & N_{tot} \le N_{ref}. \end{cases} \eqno(1328) $$

See Band Gap and Electron Affinity on page 259.

Semiconductor Band Structure

This model can be implemented as a PMI model as follows:

```cpp
#include "PMIModels.h"

class Bennett_BandGapNarrowing : public PMI_BandGapNarrowing {

private:
  double Ebgn, Nref;

public:
  Bennett_BandGapNarrowing (const PMI_Environment& env);

  ~Bennett_BandGapNarrowing ();

  void Compute_bgn (double& bgn);
};

Bennett_BandGapNarrowing::
Bennett_BandGapNarrowing (const PMI_Environment& env) :
  PMI_BandGapNarrowing (env)
{ Ebgn = InitParameter ("Ebgn", 6.84e-3);
  Nref = InitParameter ("Nref", 3.162e18);
}

Bennett_BandGapNarrowing::
~Bennett_BandGapNarrowing ()
{
}

void Bennett_BandGapNarrowing::
Compute_bgn (double& bgn)
{ const double Na = ReadDoping (PMI_Acceptor);
  const double Nd = ReadDoping (PMI_Donor);
  const double Ni = Na + Nd;
  if (Ni > Nref) {
    const double tmp = log (Ni / Nref);
    bgn = Ebgn * tmp * tmp;
  } else {
    bgn = 0.0;
  }
}

extern "C"
PMI_BandGapNarrowing* new_PMI_BandGapNarrowing
  (const PMI_Environment& env)
{ return new Bennett_BandGapNarrowing (env);
}
```

39: Physical Model Interface
Semiconductor Band Structure

# Effective Mass

Sentaurus Device provides a PMI to compute the effective mass of electrons and holes. The effective mass is always expressed as a multiple of the electron mass in vacuum. The name of the PMI model must appear in the `Physics` section of the command file:

```
Physics { EffectiveMass (pmi_model_name) }
```

## Dependencies

The relative effective mass can depend on the following variables:

* `t` Lattice temperature [K]
* `bg` Band gap [eV]

The PMI model must compute the following results:

* `m` Relative effective mass (1)

In the case of the standard interface, the following derivatives must be computed as well:

* `dmdt` Derivative of `m` with respect to `t` [K<sup>-1</sup>]
* `dmdbg` Derivative of `m` with respect to `bg` [eV<sup>-1</sup>]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_EffectiveMass : public PMI_Vertex_Interface {

public:
  PMI_EffectiveMass (const PMI_Environment& env);
  virtual ~PMI_EffectiveMass ();

  virtual void Compute_m
    (const double t, const double bg, double& m) = 0;

  virtual void Compute_dmdt
    (const double t, const double bg, double& dmdt) = 0;

  virtual void Compute_dmdbg
```

Semiconductor Band Structure

```cpp
    (const double t, const double bg, double& dmdbg) = 0;
};
```

Two virtual constructors are necessary to compute the effective mass of electrons and holes:

```cpp
typedef PMI_EffectiveMass* new_PMI_EffectiveMass_func
    (const PMI_Environment& env);
extern "C" new_PMI_EffectiveMass_func new_PMI_e_EffectiveMass;
extern "C" new_PMI_EffectiveMass_func new_PMI_h_EffectiveMass;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_EffectiveMass_Base : public PMI_Vertex_Base {

public:
    class Input : public PMI_Vertex_Input_Base {
    public:
        pmi_float t;    // lattice temperature
        pmi_float bg;   // band gap
    };

    class Output {
    public:
        pmi_float m;    // effective mass
    };

    PMI_EffectiveMass_Base (const PMI_Environment& env);
    virtual ~PMI_EffectiveMass_Base ();

    virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_EffectiveMass_Base* new_PMI_EffectiveMass_Base_func
    (const PMI_Environment& env);
extern "C" new_PMI_EffectiveMass_Base_func new_PMI_e_EffectiveMass_Base;
extern "C" new_PMI_EffectiveMass_Base_func new_PMI_h_EffectiveMass_Base;
```

## Example: Linear Effective Mass

A simple, linear effective mass model is given by:

$$ m = m_{300} + \frac{dm}{dt}(t - 300) $$ (1329)

39: Physical Model Interface

Semiconductor Band Structure

$m_{300}$ denotes the mass at 300 K . It can be implemented as follows:

```cpp
#include "PMIModels.h"

class Linear_EffectiveMass : public PMI_EffectiveMass {

protected:
    double mass_300, dmass_dt;

public:
    Linear_EffectiveMass (const PMI_Environment& env);

    ~Linear_EffectiveMass ();

    void Compute_m (const double t, const double bg, double& m);

    void Compute_dmdt (const double t, const double bg, double& dmdt);

    void Compute_dmdbg (const double t, const double bg, double& dmdbg);
};

Linear_EffectiveMass::
Linear_EffectiveMass (const PMI_Environment& env) :
    PMI_EffectiveMass (env)
{
}

Linear_EffectiveMass::
~Linear_EffectiveMass ()
{
}

void Linear_EffectiveMass::
Compute_m (const double t, const double bg, double& m)
{ m = mass_300 + dmass_dt * (t - 300.0);
}

void Linear_EffectiveMass::
Compute_dmdt (const double t, const double bg, double& dmdt)
{ dmdt = dmass_dt;
}

void Linear_EffectiveMass::
Compute_dmdbg (const double t, const double bg, double& dmdbg)
{ dmdbg = 0.0;
}

class Linear_e_EffectiveMass : public Linear_EffectiveMass {
```

Semiconductor Band Structure

```cpp
  public:
    Linear_e_EffectiveMass (const PMI_Environment& env);

    ~Linear_e_EffectiveMass () {}

};

Linear_e_EffectiveMass::
Linear_e_EffectiveMass (const PMI_Environment& env) :
  Linear_EffectiveMass (env)
{ mass_300 = InitParameter ("mass_e_300", 1.09);
  dmass_dt = InitParameter ("dmass_e_dt", 1.6e-4);
}

class Linear_h_EffectiveMass : public Linear_EffectiveMass {

public:
  Linear_h_EffectiveMass (const PMI_Environment& env);

  ~Linear_h_EffectiveMass () {}

};

Linear_h_EffectiveMass::
Linear_h_EffectiveMass (const PMI_Environment& env) :
  Linear_EffectiveMass (env)
{ mass_300 = InitParameter ("mass_h_300", 1.15);
  dmass_dt = InitParameter ("dmass_h_dt", 9.2e-4);
}

extern "C"
PMI_EffectiveMass* new_PMI_e_EffectiveMass
  (const PMI_Environment& env)
{ return new Linear_e_EffectiveMass (env);
}

extern "C"
PMI_EffectiveMass* new_PMI_h_EffectiveMass
  (const PMI_Environment& env)
{ return new Linear_h_EffectiveMass (env);
}
```

39: Physical Model Interface

Semiconductor Band Structure

# Electron Affinity

The electron affinity $\chi$, that is, the energy separation between the conduction band and vacuum level, can be specified by using a PMI. The syntax in the command file is:

```
Physics { Affinity (pmi_model_name) }
```

The default affinity model in Sentaurus Device can be selected explicitly by the keyword Default:

```
Physics { Affinity (Default) }
```

## Dependencies

The electron affinity $\chi$ can depend on:

`t` Lattice temperature [K]

The PMI model must compute:

`affinity` Electron affinity $\chi$ [eV]

In the case of the standard interface, the following derivative must be computed as well:

`affinitydt` Derivative of `affinity` with respect to `t` [eVK<sup>-1</sup>]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Affinity : public PMI_Vertex_Interface {

public:
  PMI_Affinity (const PMI_Environment& env);
  virtual ~PMI_Affinity ();

  virtual void Compute_affinity
    (const double t, double& affinity) = 0;

  virtual void Compute_daffinitydt
    (const double t, double& daffinitydt) = 0;
};
```

Semiconductor Band Structure

The prototype for the virtual constructor is:

```cpp
typedef PMI_Affinity* new_PMI_Affinity_func
  (const PMI_Environment& env);
extern "C" new_PMI_Affinity_func new_PMI_Affinity;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_Affinity_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t; // lattice temperature
  };

  class Output {
  public:
    pmi_float affinity; // electron affinity
  };

  PMI_Affinity_Base (const PMI_Environment& env);
  virtual ~PMI_Affinity_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Affinity_Base* new_PMI_Affinity_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_Affinity_Base_func new_PMI_Affinity_Base;
```

## Example: Default Temperature Dependence

By default, Sentaurus Device uses this formula to compute $\chi$:

$$ \chi(t) = \chi(0) + 0.5 \frac{\alpha t^2}{t + \beta} \tag{1330} $$

$\chi(0)$ denotes the affinity at 0 K.

**39: Physical Model Interface**
Semiconductor Band Structure

```cpp
#include "PMIModels.h"

class Default_Affinity : public PMI_Affinity {

private:
  double Affinity0, alpha, beta;

public:
  Default_Affinity (const PMI_Environment& env);

  ~Default_Affinity ();

  void Compute_affinity (const double t, double& affinity);

  void Compute_daffinitydt (const double t, double& daffinitydt);

};

Default_Affinity::
Default_Affinity (const PMI_Environment& env) :
  PMI_Affinity (env)
{ Affinity0 = InitParameter ("Affinity0", 4.05);
  alpha = InitParameter ("alpha", 4.73e-4);
  beta = InitParameter ("beta", 636);
}

Default_Affinity::
~Default_Affinity ()
{
}

void Default_Affinity::
Compute_affinity (const double t, double& affinity)
{ affinity = Affinity0 + 0.5 * alpha * t * t / (t + beta);
}

void Default_Affinity::
Compute_daffinitydt (const double t, double& daffinitydt)
{ daffinitydt = 0.5 * alpha * t * (t + 2.0 * beta) /
                  ((t + beta) * (t + beta));
}
extern "C"
PMI_Affinity* new_PMI_Affinity
  (const PMI_Environment& env)
{ return new Default_Affinity (env);
}
```

39: Physical Model Interface
Phase and State Transitions

---

# Phase and State Transitions

This section presents the following PMIs:

*   Multistate Configuration–Dependent Apparent Band-Edge Shift

*   Multistate Configuration–Dependent Bulk Mobility

*   Multistate Configuration–Dependent Heat Capacity

*   Multistate Configuration–Dependent Thermal Conductivity

---

# Multistate Configuration–Dependent Apparent Band-Edge Shift

The multistate configuration (MSC)–dependent, apparent band-edge shift model is a variant of the apparent band-edge shift model (see Apparent Band-Edge Shift on page 1268). Besides dependencies on the solution variables, electron and hole densities, lattice temperature, and carrier temperatures, it allows dependencies on all state occupation rates of an arbitrary reference MSC defined by `MSConfig`. The remarks made for the apparent band-edge shift in connection with the density gradient model are valid here as well.

The model can be selected as arguments of the keywords `eBandEdgeShift`, `hBandEdgeShift`, and `BandEdgeShift` (see Apparent Band-Edge Shift on page 537) in the `MSConfig` specification. The optional model index parameter allows you to implement, in the same model, several variants that can be accessed from the command file.

## Dependencies

The MSC apparent band-edge shift $\Lambda_{\text{PMI}}$ can depend on:

```
n       Electron density [ cm⁻³ ]
p       Hole density [ cm⁻³ ]
t       Lattice temperature [ K ]
ct      Carrier temperature [ K ]
s       Vector of state occupation rates of the reference MSC [ 1 ]
```

The PMI model must compute the following values if the dependency is used:

```
shift   Apparent band-edge shift Λ_PMI [ eV ]
```

39: Physical Model Interface
Phase and State Transitions

In the case of the standard interface, the following derivatives must be computed as well:

`dshiftdn` Derivative of $\Lambda_{PMI}$ with respect to n [ eVcm$^{3}$ ]
`dshiftdp` Derivative of $\Lambda_{PMI}$ with respect to p [ eVcm$^{3}$ ]
`dshiftdt` Derivative of $\Lambda_{PMI}$ with respect to t [ eVK$^{-1}$ ]
`dshiftdf` Derivative of $\Lambda_{PMI}$ with respect to ct [ eVK$^{-1}$ ]
`dshiftds` Derivative of $\Lambda_{PMI}$ with respect to s [ eV ]

## Additional Functionality

The PMI model provides additional functionality.

## Using Dependencies

You can use the function `set_dependency_used` to switch on or off the dependencies of this model explicitly (the default is on). For used dependencies, the function computing the corresponding derivative must be provided; for unused dependencies, the functions are not called.

## Updating Actual Status

Before calling the computation functions (`compute_val` and `compute_dval_dX`), the simulator passes the actual values of the dependencies to the model using `set_actual_status`. The model parameters are updated by `init_parameter` before the actual status is updated.

## Standard C++ Interface

The following base class (here, only an extract) is declared in the file `PMIModels.h`:

```cpp
class PMI_MSC_ApparentBandEdgeShift : public PMI_MSC_Vertex_Interface {
public:
  enum e_var { var_n, var_p, var_T, var_eT, var_hT, var_s, var_undefined };

  class input_data {
  public:
    input_data ();
    ~input_data ();
    double& val ( e_var var, size_t ind );
    double val ( e_var var, size_t ind ) const;
  };
};
```

Phase and State Transitions

```cpp
 public:
  PMI_MSC_ApparentBandEdgeShift (const PMI_Environment& env,
   const std::string& msconfig_name, int model_index = 0);
  virtual ~PMI_MSC_ApparentBandEdgeShift ();

 // get names of MSConfig and its states
  const std::string& msconfig_name () const;
  size_t nb_states () const;
  const std::string& state ( size_t index ) const;

  virtual void set_actual_status (
   const PMI_MSC_ApparentBandEdgeShift::input_data& id );

 // compute value and derivatives
  virtual void compute_val ( double& val );
  virtual void compute_dval_dn ( double& val );
  virtual void compute_dval_dp ( double& val );
  virtual void compute_dval_dT ( double& val );
  virtual void compute_dval_deT ( double& val );
  virtual void compute_dval_dhT ( double& val );
  virtual void compute_dval_ds ( std::vector<double>& val );

 // support ramping of parameters
  virtual void init_parameter ();

 // handle dependencies
  void set_dependency_used (
   PMI_MSC_ApparentBandEdgeShift::e_var var, bool flag );
  bool dependency_used ( PMI_MSC_ApparentBandEdgeShift::e_var var ) const;
 };
```

The following virtual constructor must be implemented:

```cpp
 typedef PMI_MSC_ApparentBandEdgeShift* new_PMI_MSC_ApparentBandEdgeShift_func
   (const PMI_Environment& env,
   const std::string& msconfig_name,
   int model_index);
 extern "C" new_PMI_ApparentBandEdgeShift_func
   new_PMI_MSC_ApparentBandEdgeShift;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
 class PMI_MSC_ApparentBandEdgeShift_Base : public PMI_MSC_Vertex_Base {

 public:
   class Input : public PMI_Vertex_Input_Base {
```

39: Physical Model Interface

Phase and State Transitions

```cpp
      public:
        pmi_float n;     // electron density
        pmi_float p;     // hole density
        pmi_float T;     // lattice temperature
        pmi_float eT;    // electron temperature
        pmi_float hT;    // hole temperature
        std::vector<pmi_float> s; // phase fraction
      };

      class Output {
      public:
        pmi_float val; // apparent band-edge shift
      };

      PMI_MSC_ApparentBandEdgeShift_Base (const PMI_Environment& env,
                                        const std::string& msconfig_name,
                                        const int model_index);
      virtual ~PMI_MSC_ApparentBandEdgeShift_Base ();

      virtual void compute (const Input& input, Output& output) = 0;
    };
```

The prototype for the virtual constructor is given as:

```cpp
    typedef PMI_MSC_ApparentBandEdgeShift_Base*
      new_PMI_MSC_ApparentBandEdgeShift_Base_func
        (const PMI_Environment& env, const std::string& msconfig_name,
        const int model_index);
    extern "C" new_PMI_MSC_ApparentBandEdgeShift_Base_func
      new_PMI_MSC_ApparentBandEdgeShift_Base;
```

# Multistate Configuration–Dependent Bulk Mobility

This PMI allows you to implement multistate configuration (MSC)–dependent bulk mobility models.

## Command File

To activate a PMI of this type, as an option to eMobility, hMobility, or Mobility in the Physics section, specify:

```
    DopingDependence (
      PMIModel (
        Name = <string>
        MSConfig = <string>
        Index = <int>
```

Phase and State Transitions

```
        String = <string>
    )
)
```

The options of `PMIModel` are described in Command File on page 1293.

## Dependencies

The mobility can depend on the variables:

*   **n**: Electron density [ cm<sup>−3</sup> ]
*   **p**: Hole density [ cm<sup>−3</sup> ]
*   **T**: Lattice temperature [ K ]
*   **eT**: Electron temperature [ K ]
*   **hT**: Hole temperature [ K ]
*   **s**: Multistate configuration occupation probabilities [ 1 ]

The model must compute the following quantities:

*   **val**: Mobility μ<sub>dop</sub> [ cm<sup>2</sup>V<sup>−1</sup>s<sup>−1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

*   **dval_dn**: Derivative with respect to electron density [ cm<sup>5</sup>V<sup>−1</sup>s<sup>−1</sup> ]
*   **dval_dp**: Derivative with respect to hole density [ cm<sup>5</sup>V<sup>−1</sup>s<sup>−1</sup> ]
*   **dval_dT**: Derivative with respect to lattice temperature [ cm<sup>2</sup>V<sup>−1</sup>s<sup>−1</sup>K<sup>−1</sup> ]
*   **dval_deT**: Derivative with respect to electron temperature [ cm<sup>2</sup>V<sup>−1</sup>s<sup>−1</sup>K<sup>−1</sup> ]
*   **dval_dhT**: Derivative with respect to hole temperature [ cm<sup>2</sup>V<sup>−1</sup>s<sup>−1</sup>K<sup>−1</sup> ]
*   **dval_ds**: Derivative with respect to multistate configuration occupation probabilities [ cm<sup>2</sup>V<sup>−1</sup>s<sup>−1</sup> ]

39: Physical Model Interface
Phase and State Transitions

# Standard C++ Interface

The PMI offers a base class that presents the following interface:

```cpp
class PMI_MSC_Mobility : public PMI_MSC_Vertex_Interface
{
public:
  PMI_MSC_Mobility (const PMI_Environment& env,
    const std::string& msconfig_name,
    const int model_index,
    const std::string& model_string,
    const PMI_AnisotropyType aniso);
  // otherwise, see Standard C++ Interface on page 1294
};
```

Apart from the name of the base class and the constructor, the explanations in Standard C++ Interface on page 1294 apply here as well.

The following virtual constructor must be implemented:

```cpp
typedef PMI_MSC_Mobility* new_PMI_MSC_Mobility_func
  (const PMI_Environment& env, const std::string& msconfig_name,
  int model_index, const std::string& model_string,
  const PMI_AnisotropyType anisotype);
extern "C" new_PMI_MSC_Mobility_func new_PMI_MSC_Mobility;
```

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_MSC_Mobility_Base : public PMI_MSC_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    const pmi_float& n () const;        // electron density
    const pmi_float& p () const;        // hole density
    const pmi_float& T () const;        // lattice temperature
    const pmi_float& eT () const;       // electron temperature
    const pmi_float& hT () const;       // hole temperature
    const pmi_float& s (size_t ind) const; // phase fraction
  };

  class Output {
  public:
    pmi_float& val ();   // mobility
  };
};
```

Phase and State Transitions

```cpp
    PMI_MSC_Mobility_Base (const PMI_Environment& env,
                           const std::string& msconfig_name,
                           const int model_index,
                           const std::string& model_string,
                           const PMI_AnisotropyType anisotype);
    virtual ~PMI_MSC_Mobility_Base ();

    PMI_AnisotropyType AnisotropyType () const;

    virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_MSC_Mobility_Base* new_PMI_MSC_Mobility_Base_func
    (const PMI_Environment& env, const std::string& msconfig_name,
     const int model_index, const std::string& model_string,
     const PMI_AnisotropyType anisotype);
extern "C" new_PMI_MSC_Mobility_Base_func new_PMI_MSC_Mobility_Base;
```

# Multistate Configuration–Dependent Heat Capacity

This PMI computes the lattice heat capacity and allows it to depend on a multistate configuration (see Chapter 18 on page 527).

## Command File

To activate a PMI of this type, in the `Physics` section, specify:

```
HeatCapacity(
  PMIModel (
    Name = <string>
    MSConfig = <string>
    Index = <int>
    String = <string>
  )
)
```

The options of `PMIModel` are described in Command File on page 1293.

39: Physical Model Interface
Phase and State Transitions

# Dependencies

The heat capacity can depend on the variables:

*   n Electron density [ cm<sup>–3</sup> ]
*   p Hole density [ cm<sup>–3</sup> ]
*   T Lattice temperature [ K ]
*   eT Electron temperature [ K ]
*   hT Hole temperature [ K ]
*   s Multistate configuration occupation probabilities [ 1 ]

The model must compute the following quantities:

*   val Heat capacity [ Jcm<sup>–3</sup>K<sup>–1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

*   dval_dn Derivative with respect to electron density [ JK<sup>–1</sup> ]
*   dval_dp Derivative with respect to hole density [ JK<sup>–1</sup> ]
*   dval_dT Derivative with respect to lattice temperature [ Jcm<sup>–3</sup>K<sup>–2</sup> ]
*   dval_deT Derivative with respect to electron temperature [ Jcm<sup>–3</sup>K<sup>–2</sup> ]
*   dval_dhT Derivative with respect to hole temperature [ Jcm<sup>–3</sup>K<sup>–2</sup> ]
*   dval_ds Derivative with respect to multistate configuration occupation probabilities [ Jcm<sup>–3</sup>K<sup>–1</sup> ]

# Standard C++ Interface

The PMI offers a base class that presents the following interface:

```cpp
class PMI_MSC_HeatCapacity : public PMI_MSC_Vertex_Interface
{
public:
  PMI_MSC_HeatCapacity (const PMI_Environment& env,
    const std::string& msconfig_name,
    const int model_index,
```

Phase and State Transitions

```cpp
    const std::string& model_string);
  // otherwise, see Standard C++ Interface on page 1294
};
```

Apart from the base class name and the constructor, the explanations in Standard C++ Interface on page 1294 apply here as well.

The following virtual constructor must be implemented:

```cpp
typedef PMI_MSC_HeatCapacity* new_PMI_MSC_HeatCapacity_func
  (const PMI_Environment& env, const std::string& msconfig_name,
  int model_index, const std::string& model_string);
extern "C" new_PMI_MSC_HeatCapacity_func new_PMI_MSC_HeatCapacity;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_MSC_HeatCapacity_Base : public PMI_MSC_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    const pmi_float& n () const;  // electron density
    const pmi_float& p () const;  // hole density
    const pmi_float& T () const;  // lattice temperature
    const pmi_float& eT () const; // electron temperature
    const pmi_float& hT () const; // hole temperature
    const pmi_float& s (size_t ind) const; // phase fraction
  };

  class Output {
  public:
    Output (NS_PMI_MSC::odata* odata);

    pmi_float& val ();  // heat capacity
  };

  PMI_MSC_HeatCapacity_Base (const PMI_Environment& env,
                               const std::string& msconfig_name,
                               const int model_index,
                               const std::string& model_string);
  virtual ~PMI_MSC_HeatCapacity_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

39: Physical Model Interface
Phase and State Transitions

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_MSC_Mobility_Base* new_PMI_MSC_Mobility_Base_func
  (const PMI_Environment& env, const std::string& msconfig_name,
   const int model_index, const std::string& model_string,
   const PMI_AnisotropyType anisotype);
extern "C" new_PMI_MSC_HeatCapacity_Base_func new_PMI_MSC_HeatCapacity_Base;
```

# Multistate Configuration–Dependent Thermal Conductivity

This PMI provides access to the lattice thermal conductivity $\kappa$ in Eq. 71, p. 200 and allows it to depend on a multistate configuration (see Chapter 18 on page 527).

## Command File

To activate a PMI of this type, in the `Physics` section, specify:

```
ThermalConductivity(
  PMIModel (
    Name = <string>
    MSConfig = <string>
    Index = <int>
    String = <string>
  )
)
```

Here, `Name` is the name of the PMI model; its specification is mandatory. `MSConfig` selects the name of the multistate configuration. `MSConfig` defaults to an empty string, which means the model does not depend on any multistate configuration. `Index` and `String` are optional; they determine the arguments `model_index` and `model_string` that are passed to the virtual constructor (see below); the interpretation of those arguments is up to the PMI model. `Index` defaults to zero, and `String` defaults to the empty string.

## Dependencies

The thermal conductivity can depend on the variables:

* n Electron density [ cm<sup>–3</sup> ]
* p Hole density [ cm<sup>–3</sup> ]
* T Lattice temperature [ K ]

Phase and State Transitions

eT Electron temperature [ K ]

hT Hole temperature [ K ]

s Multistate configuration occupation probabilities [ 1 ]

The model must compute the following quantities:

val Thermal conductivity [ Wcm<sup>-1</sup>K<sup>-1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

dval_dn Derivative with respect to electron density [ Wcm<sup>2</sup>K<sup>-1</sup> ]

dval_dp Derivative with respect to hole density [ Wcm<sup>2</sup>K<sup>-1</sup> ]

dval_dT Derivative with respect to lattice temperature [ Wcm<sup>-1</sup>K<sup>-2</sup> ]

dval_deT Derivative with respect to electron temperature [ Wcm<sup>-1</sup>K<sup>-2</sup> ]

dval_dhT Derivative with respect to hole temperature [ Wcm<sup>-1</sup>K<sup>-2</sup> ]

dval_ds Derivative with respect to multistate configuration occupation probabilities [ Wcm<sup>-1</sup>K<sup>-1</sup> ]

## Standard C++ Interface

The PMI offers a base class that presents the following interface:

```cpp
class PMI_MSC_ThermalConductivity : public PMI_MSC_Vertex_Interface
{
public:
  class idata {
  public:
    double n () const;
    double p () const;
    double T () const;
    double eT () const;
    double hT () const;
    double s (size_t ind) const;
  };

  class odata {
  public:
    double& val ();
    double& dval_dn ();
    double& dval_dp ();
```

39: Physical Model Interface

Phase and State Transitions

```cpp
        double& dval_dT ();
        double& dval_deT ();
        double& dval_dhT ();
        double& dval_ds ( size_t ind );
      };

      PMI_MSC_ThermalConductivity(const PMI_Environment& env,
        const std::string& msconfig_name,
        const int model_index,
        const std::string& model_string,
        const PMI_AnisotropyType anisotype);
      virtual ~PMI_MSC_ThermalConductivity ();

      PMI_AnisotropyType AnisotropyType () const;

      virtual void compute
        (const idata* id,
        odata* od ) = 0;
    };
```

The Compute function receives its input from `id`. It returns the results using `od` by assignment using the member functions of `od`. The PMI framework initializes the values of the derivatives to zero, so you do not have to do anything for derivatives with respect to the variables on which your model does not depend.

The following virtual constructor must be implemented:

```cpp
typedef PMI_MSC_ThermalConductivity* new_PMI_MSC_ThermalConductivity_func
  (const PMI_Environment& env, const std::string& msconfig_name,
  int model_index, const std::string& model_string,
  const PMI_AnisotropyType anisotype);
extern "C" new_PMI_MSC_ThermalConductivity_func
  new_PMI_MSC_ThermalConductivity;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_MSC_ThermalConductivity_Base : public PMI_MSC_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    const pmi_float& n () const;   // electron density
    const pmi_float& p () const;   // hole density
    const pmi_float& T () const;   // lattice temperature
    const pmi_float& eT () const; // electron temperature
    const pmi_float& hT () const; // hole temperature
```

Thermal Properties and Heat

```cpp
    const pmi_float& s (size_t ind) const; // phase fraction
  };

  class Output {
  public:
    pmi_float& val (); // thermal conductivity
  };

  PMI_MSC_ThermalConductivity_Base (const PMI_Environment& env,
                                    const std::string& msconfig_name,
                                    const int model_index,
                                    const std::string& model_string,
                                    const PMI_AnisotropyType anisotype);
  virtual ~PMI_MSC_ThermalConductivity_Base ();

  PMI_AnisotropyType AnisotropyType () const;

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_MSC_ThermalConductivity_Base*
  new_PMI_MSC_ThermalConductivity_Base_func
    (const PMI_Environment& env, const std::string& msconfig_name,
    const int model_index, const std::string& model_string,
    const PMI_AnisotropyType anisotype);
extern "C" new_PMI_MSC_ThermalConductivity_Base_func
  new_PMI_MSC_ThermalConductivity_Base;
```

# Thermal Properties and Heat

This section presents the following PMIs:

*   Distributed Thermal Resistance

*   Heat Capacity

*   Heat Generation Rate

*   Metal Thermoelectric Power

*   Thermal Conductivity

*   Thermoelectric Power

39: Physical Model Interface
Thermal Properties and Heat

# Distributed Thermal Resistance

For the distributed thermal resistance model, you can specify your own resistance model by using some physical variables at the two sides of the interface (see Boundary Conditions for Lattice Temperature on page 235). The syntax in the command file is:

```
Physics(MaterialInterface = "Silicon/Aluminum") {
  DistrThermalResist = DTResistPMI(pmi_model_name)
}
```

## Dependencies

The distributed thermal resistance model can depend on the following variables:

| T1 | Lattice temperature for material 1 [K] |
| --- | --- |
| T2 | Lattice temperature for material 2 [K] |
| Tn1 | Electron temperature for material 1 [K] |
| Tn2 | Electron temperature for material 2 [K] |
| Tp1 | Hole temperature for material 1 [K] |
| Tp2 | Hole temperature for material 2 [K] |
| N1 | Electron density for material 1 [cm-3] |
| N2 | Electron density for material 2 [cm-3] |
| P1 | Hole density for material 1 [cm-3] |
| P2 | Hole density for material 2 [cm-3] |

By default, you can control the material or region order by specifying `MaterialInterface` or `RegionInterface` in the `Physics` section. The material or region that is specified first uses the PMI variable labeled with 1 (T1, N1, P1, Tn1, and Tp1), and the second material or region of the interface uses the PMI variable set labeled with 2 (T2, N2, P2, Tn2, and Tp2). Taking the previous example, at the `Silicon/Aluminum` region interface, the PMI variable set 1 refers to the `Silicon` region, and set 2 refers to the `Aluminum` region. In addition, you can set the reference material or region with the keyword `reference`. For example:

```
Physics(MaterialInterface = "Silicon/Aluminum") {
  DistrThermalResist = DTResistPMI(
    pmi_model_name
    reference = Aluminum
```

Thermal Properties and Heat

```cpp
    )
}
```

Here, the keyword `reference` forces the PMI variable set 1 for `Aluminum` regions and set 2 for `Silicon` regions, thereby overwriting the order specified with `MaterialInterface`.

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_DistrThermalResist_Base : public PMI_Vertex_Base {
public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    Input (const PMI_DistrThermalResist_Base* DistrThermResist_base,
    const int vertex);
    pmi_float t1;  // lattice temperature for material1
    pmi_float tn1; // electron temperature for material1
    pmi_float tp1; // hole temperature for material1
    pmi_float n1;  // electron density for material1
    pmi_float p1;  // hole density for material1
    pmi_float t2;  // lattice temperature for material2
    pmi_float tn2; // electron temperature for material2
    pmi_float tp2; // hole temperature for material2
    pmi_float n2;  // electron density for material2
    pmi_float p2;  // hole density for material2
  };
  class Output {
  public:
    pmi_float resist; // Schottky resistance
  };
  PMI_DistrThermalResist_Base (const PMI_Environment& env);
  virtual ~PMI_DistrThermalResist_Base ();
  virtual void compute (const Input& input1, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_DistrThermalResist_Base* new_PMI_DistrThermalResist_Base_func
  (const PMI_Environment& env);
extern "C" PMI_DistrThermalResist_Base* new_PMI_DistrThermalResist_Base
  (const PMI_Environment& env) {
     return new DTRPMI(env);
}
```

 39: Physical Model Interface
Thermal Properties and Heat

# Example: Electron Density Dependence

A simple electron density–dependent model can be implemented as follows:

```cpp
#include "PMI.h"

class DTRPMI: public PMI_DistrThermalResist_Base {
private:

public:
  DTRPMI(const PMI_Environment& env);
  ~DTRPMI();
  void compute(const Input& input1, Output& output);
};

// constructor
DTRPMI::DTRPMI(const PMI_Environment& env):PMI_DistrThermalResist_Base(env) {
}

// destructor
DTRPMI::~DTRPMI() {
  // nothing to do here (nothing allocated)
}

void DTRPMI::compute(const Input& input1, Output& output) {
  pmi_float T1  = input1.t1;
  pmi_float Tn1 = input1.tn1;
  pmi_float Tp1 = input1.tp1;
  pmi_float N1  = input1.n1;
  pmi_float P1  = input1.p1;
  pmi_float T2  = input1.t2;
  pmi_float Tn2 = input1.tn2;
  pmi_float Tp2 = input1.tp2;
  pmi_float N2  = input1.n2;
  pmi_float P2  = input1.p2;
//output the distributed thermal resistance. Users can modify this part.
  output.resist = 1e-17*(N1);
}

extern "C" PMI_DistrThermalResist_Base* new_PMI_DistrThermalResist_Base
  (const PMI_Environment& env) {
  return new DTRPMI(env);
}
```

Thermal Properties and Heat

# Heat Capacity

The model for lattice heat capacity in Eq. 71, p. 200 can be specified in the `Physics` section of the command file. The following two possibilities are available:

```
Physics {
  HeatCapacity (
    constant
    pmi_model_name
  )
}
```

These entries have the following meaning:

**constant** Use constant heat capacity (default)
**pmi_model_name** Call a PMI model to compute the heat capacity

## Dependencies

The heat capacity $c_L$ can depend on the variable:

t Lattice temperature [K]

The PMI model must compute the following results:

c Heat capacity $c_L$ [ JK<sup>-1</sup>cm<sup>-3</sup> ]

In the case of the standard interface, the following derivative must be computed as well:

dcdt Derivative of $c_L$ with respect to t [ JK<sup>-2</sup>cm<sup>-3</sup> ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_HeatCapacity : public PMI_Vertex_Interface {

public:
  PMI_HeatCapacity (const PMI_Environment& env);

  virtual ~PMI_HeatCapacity ();
```

39: Physical Model Interface

Thermal Properties and Heat

```cpp
      virtual void Compute_c
        (const double t, double& c) = 0;

      virtual void Compute_dcdt
        (const double t, double& dcdt) = 0
    };
```

The following virtual constructor must be implemented:

```cpp
    typedef PMI_HeatCapacity* new_PMI_HeatCapacity_func
      (const PMI_Environment& env);
    extern "C" new_PMI_HeatCapacity_func new_PMI_HeatCapacity;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
    class PMI_HeatCapacity_Base : public PMI_Vertex_Base {

    public:
      class Input : public PMI_Vertex_Input_Base {
      public:
        pmi_float t;   // lattice temperature
      };

      class Output {
      public:
        pmi_float c;   // heat capacity
      };

      PMI_HeatCapacity_Base (const PMI_Environment& env);
      virtual ~PMI_HeatCapacity_Base ();

      virtual void compute (const Input& input, Output& output) = 0;
    };
```

The prototype for the virtual constructor is given as:

```cpp
    typedef PMI_HeatCapacity_Base* new_PMI_HeatCapacity_Base_func
      (const PMI_Environment& env);
    extern "C" new_PMI_HeatCapacity_Base_func new_PMI_HeatCapacity_Base;
```

Thermal Properties and Heat

## Example: Constant Heat Capacity

The following C++ code implements constant heat capacity:

```cpp
#include "PMIModels.h"

class Constant_HeatCapacity : public PMI_HeatCapacity {
private:
  double cv;

public:
  Constant_HeatCapacity (const PMI_Environment& env);
  ~Constant_HeatCapacity ();

  void Compute_c
    (const double t, double& c);

  void Compute_dcdt
    (const double t, double& dcdt);
};

Constant_HeatCapacity::
Constant_HeatCapacity (const PMI_Environment& env) :
  PMI_HeatCapacity (env)
{ // default values
  cv = InitParameter ("cv", 1.63);
}

Constant_HeatCapacity::
~Constant_HeatCapacity ()
{
}

void Constant_HeatCapacity::
Compute_c (const double t, double& c)
{ c = cv;
}

void Constant_HeatCapacity::
Compute_dcdt (const double t, double& dcdt)
{ dcdt = 0.0;
}

extern "C"
PMI_HeatCapacity* new_PMI_HeatCapacity
    (const PMI_Environment& env)
{ return new Constant_HeatCapacity (env);
}
```

39: Physical Model Interface

Thermal Properties and Heat

# Heat Generation Rate

The total heat generation rate is the term on the right-hand side of Eq. 72, p. 201. You can specify an additional term `pmi_Heat` for a given material or region:

```
Total_Heat = existing_Heat + pmi_Heat
```

The name of the PMI must be specified in the new subsection `HeatSource(pmi_model)` in the `Physics` section of the command file as follows:

```
Physics (Material = "Silicon") {
  HeatSource (pmi_Heat_Si)
}
```

To plot the `pmi_Heat` values, specify the keyword `pmiHeat` in the `Plot` section of the command file.

## Dependencies

The heat generation depends on the variables:

*   **n**: Electron density [ cm<sup>–3</sup> ]
*   **p**: Hole density [ cm<sup>–3</sup> ]
*   **t**: Lattice temperature [K]
*   **f**: Electric field vector [ Vcm<sup>–1</sup> ]
*   **g**: Gradient temperature [ Kcm<sup>–1</sup> ]

The PMI model must compute the following results:

*   **Heat**: Heat generation rate [ Wcm<sup>–3</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

*   `dHeat_dn`: Derivative of Heat with respect to n [ W ]
*   `dHeat_dp`: Derivative of Heat with respect to p [ W ]
*   `dHeat_dt`: Derivative of Heat with respect to t [ Wcm<sup>–3</sup>K<sup>–1</sup> ]
*   `dHeat_df`: Derivative of Heat with respect to each component f [ Wcm<sup>–2</sup>V<sup>–1</sup> ]
*   `dHeat_dg`: Derivative of Heat with respect to each component g [ Wcm<sup>–2</sup>K<sup>–1</sup> ]

Thermal Properties and Heat

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Heat_Generation : public PMI_Vertex_Interface {

public:
  PMI_Heat_Generation (const PMI_Environment& env);
  virtual ~PMI_Heat_Generation ();

  // methods to be implemented by user
  virtual void Compute_Heat
    (const double n,             // electron density
     const double p,             // hole density
     const double t,             // lattice temperature
     const double f[3],          // electric field vector
     const double g[3],          // gradient of temperature
     double& heat) = 0;          // heat generation rate

  virtual void Compute_dHeat_dn
    (const double n,             // electron density
     const double p,             // hole density
     const double t,             // lattice temperature
     const double f[3],          // electric field vector
     const double g[3],          // gradient of temperature
     double& dHeat_dn) = 0;      // derivative of heat with respect to n

  virtual void Compute_dHeat_dp
    (const double n,             // electron density
     const double p,             // hole density
     const double t,             // lattice temperature
     const double f[3],          // electric field vector
     const double g[3],          // gradient of temperature
     double& dHeat_dp) = 0;      // derivative of heat with respect to p

  virtual void Compute_dHeat_dt
    (const double n,             // electron density
     const double p,             // hole density
     const double t,             // lattice temperature
     const double f[3],          // electric field vector
     const double g[3],          // gradient of temperature
     double& dHeat_dt) = 0;      // derivative of heat with respect to t

  virtual void Compute_dHeat_df
    (const double n,             // electron density
     const double p,             // hole density
     const double t,             // lattice temperature
     const double f[3],          // electric field vector
```

Thermal Properties and Heat

```cpp
        const double g[3],           // gradient of temperature
        double dHeat_df[3]) = 0;     // derivative of heat with respect to f

      virtual void Compute_dHeat_dg
      (const double n,               // electron density
        const double p,              // hole density
        const double t,              // lattice temperature
        const double f[3],           // electric field vector
        const double g[3],           // gradient of temperature
        double dHeat_dg[3]) = 0;     // derivative of heat with respect to g
    };
```

The following virtual constructor must be implemented:

```cpp
    typedef PMI_Heat_Generation* new_PMI_Heat_Generation_func
      (const PMI_Environment& env);
    extern "C" new_PMI_Heat_Generation_func new_PMI_HeatGeneration;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
    class PMI_HeatGeneration_Base : public PMI_Vertex_Base {

    public:
      class Input : public PMI_Vertex_Input_Base {
      public:
       pmi_float n;         // electron density
       pmi_float p;         // hole density
       pmi_float t;         // lattice temperature
       pmi_float f[3];      // electric field vector
       pmi_float g[3];      // gradient of temperature
      };

      class Output {
      public:
       pmi_float heat; // heat generation rate
      };

      PMI_HeatGeneration_Base (const PMI_Environment& env);
      virtual ~PMI_HeatGeneration_Base ();

      virtual void compute (const Input& input, Output& output) = 0;

    };
```

Thermal Properties and Heat

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_HeatGenerationFunction_Base*
  new_PMI_HeatGenerationFunction_Base_func
       (const PMI_Environment& env);
extern "C" new_PMI_HeatGenerationFunction_Base_func
  new_PMI_HeatGenerationFunction_Base;
```

## Example: Dependency on Electric Field and Gradient of Temperature

In the following example, heat generation has a linear dependency on the electric field and the gradient of temperature:

```cpp
// Heat = kappa*(E,gratT)*1[1/V]
//     where
//     E - electric field vector,
//     gradT - gradient of temperature.
//
// The 1D equation
//     -div(kappa*grad(T(x))) = Heat, 0 <= x <= L
//      T(0) = T0,
//      T(L) = T1,
// has the exact solution:
//      T(x) = (T1-T0)*(exp(-E*x)-1)/(exp(-E*L)-1) + T0

class HeatGeneration : public PMI_HeatGeneration_Base
{
private:
  double kappa;

public:
  HeatGeneration (const PMI_Environment& env);
  ~HeatGeneration ();
  void compute (const Input& input, Output& output);
};

HeatGeneration::HeatGeneration (const PMI_Environment& env) :
  PMI_HeatGeneration_Base (env)
{
  kappa = InitParameter("kappa", 0.01); // [W/(K*cm)]
}

HeatGeneration::~HeatGeneration () {}

void HeatGeneration::compute (const Input& input, Output& output)
{
  const pmi_float (&f)[3] = input.f;
  const pmi_float (&g)[3] = input.g;
```

Thermal Properties and Heat

```cpp
    output.heat = kappa*(f[0]*g[0] + f[1]*g[1] + f[2]*g[2]);
}

extern "C"
PMI_HeatGeneration_Base* new_PMI_HeatGeneration_Base
 (const PMI_Environment& env)
{ return new HeatGeneration (env);}
```

# Metal Thermoelectric Power

The metal thermoelectric power $P$ in metals can be defined by a PMI (see Thermoelectric Power on page 981).

The name of the PMI can be specified regionwise, materialwise, or globally in the `Physics` section of the command file as follows:

```
Physics(Material="Copper") {
  MetalTEPower(pmi_model)
}
```

## Dependencies

The metal thermoelectric power can depend on the following variables:

```
t       Lattice temperature [K]
qf      Quasi-Fermi potential [V]
f       Electric field vector [ Vcm–1 ]
```

The PMI model must compute the following result:

```
power   Thermoelectric power [ VK–1 ]
```

In the case of the standard interface, the following derivatives must be computed as well:

```
dpowerdt    Derivative of power with respect to t [ VK–2 ]
dpowerdqf   Derivative of power with respect to qf [ K–1 ]
dpowerdf    Derivative of power with respect to each component of f [ cmK–1 ], a vector
            with up to three entries
```

Thermal Properties and Heat

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_MetalThermoElectricPower : public PMI_Vertex_Interface {

public:
  PMI_MetalThermoElectricPower(const PMI_Environment& env);
  virtual ~MetalPMI_ThermoElectricPower ();

  virtual void Compute_power(
    const double t,         // lattice temperature
    const double qf,        // quasi-Fermi potential
    const double f[3]       // electric field vector
    double& power);         // thermoelectric power

  virtual void Compute_dpowerdt(
    const double t,         // lattice temperature
    const double qf,        // quasi-Fermi potential
    const double f[3]       // electric field vector
    double& dpowerdt);      // derivative of thermoelectric power
                            // with respect to lattice temperature

  virtual void Compute_dpowerdqf(
    const double t,         // lattice temperature
    const double qf,        // quasi-Fermi potential
    const double f[3]       // electric field vector
    double& dpowerdqf);     // derivative of thermoelectric power
                            // with respect to quasi-Fermi potential

  virtual void Compute_dpowerdf(
    const double t,         // lattice temperature
    const double qf,        // quasi-Fermi potential
    const double f[3]       // electric field vector
    double& dpowerdf[3]);   // derivative of thermoelectric power
                            // with respect to electric field
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_MetalThermoElectricPower* new_PMI_MetalThermoElectricPower_func
  (const PMI_Environment& env);
extern "C" new_PMI_MetalThermoElectricPower_func
                                 new_PMI_MetalThermoElectricPower;
```

39: Physical Model Interface

Thermal Properties and Heat

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_MetalThermoElectricPower_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;        // lattice temperature
    pmi_float qf;       // quasi-Fermi potential
    pmi_float f[3];     // electric field vector
  };

  class Output {
  public:
    pmi_float power;    // thermoelectric power
  };

  PMI_MetalThermoElectricPower_Base (const PMI_Environment& env);
  virtual ~PMI_MetalThermoElectricPower_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
extern "C"
PMI_MetalThermoElectricPower_Base* new_PMI_MetalThermoElectricPower_Base
(const PMI_Environment& env);
```

# Example: Linear Field Dependency of Metal TEP

The following C++ code implements a metal TEP PMI depending linearly on two of the electric field components:

```cpp
#include "PMIModels.h"

namespace {
  // Boltzmann constant in J/K
  double kB = 1.380662e-23;
  // electron charge in C
  double e0 = 1.602192e-19;
}

class MetalThermoElectricPower : public PMI_MetalThermoElectricPower
{
  private:
```

1309

Thermal Properties and Heat

```cpp
    double alpha, beta;

public:
    MetalThermoElectricPower(const PMI_Environment& env);
    ~MetalThermoElectricPower ();

    void Compute_power
        (const double t,          // lattice temperature
         const double qf,         // quasi-Fermi potential
         const double f[3],       // electric field vector
         double& power);          // thermoelectric power

    void Compute_dpowerdt
        (const double t,          // lattice temperature
         const double qf,         // quasi-Fermi potential
         const double f[3],       // electric field vector
         double& dpowerdt);       // derivative of thermoelectric power
                                  // with respect to lattice temperature

    void Compute_dpowerdqf
        (const double t,          // lattice temperature
         const double qf,         // quasi-Fermi potential
         const double f[3],       // electric field vector
         double& dpowerdqf);      // derivative of thermoelectric power
                                  // with respect to quasi-Fermi potential

    void Compute_dpowerdf
        (const double t,          // lattice temperature
         const double qf,         // quasi-Fermi potential
         const double f[3],       // electric field vector
         double dpowerdf[3]);     // derivative of thermoelectric power
                                  // with respect to electric field
};

MetalThermoElectricPower::
MetalThermoElectricPower (const PMI_Environment& env) :
  PMI_MetalThermoElectricPower (env)
{
  // default values
  alpha = InitParameter("alpha",1);
  beta = InitParameter("beta",1e-2);
}

MetalThermoElectricPower::
~MetalThermoElectricPower ()
{
}
```

Thermal Properties and Heat

```cpp
void MetalThermoElectricPower::
Compute_power (const double t, const double qf, const double f[3],
               double& power)
{
 power = 1e-6 * 1e-2 * (f[0] + f[1]);
}

void MetalThermoElectricPower::
Compute_dpowerdt (const double t, const double qf, const double f[3],
                  double& dpowerdt)
{
 dpowerdt = 0;
}

void MetalThermoElectricPower::
Compute_dpowerdqf (const double t, const double qf, const double f[3],
                   double& dpowerdqf)
{
 dpowerdqf = 0;
}

void MetalThermoElectricPower::
Compute_dpowerdf (const double t, const double qf, const double f[3],
                  double dpowerdf[3])
{
 dpowerdf[0] = 1e-6 * 1e-2;
 dpowerdf[1] = 1e-6 * 1e-2;
 dpowerdf[2] = 0;
}

extern "C"
PMI_MetalThermoElectricPower* new_PMI_MetalThermoElectricPower
 (const PMI_Environment& env)
{
 return new MetalThermoElectricPower(env);
}
```

# Thermal Conductivity

The PMI provides access to the lattice thermal conductivity $\kappa$ in Eq. 71, p. 200. To activate it, in the `Physics` section of the command file, specify:

```
Physics {
 ThermalConductivity ( <string> )
}
```

where the string is the name of the PMI model.

Thermal Properties and Heat

The PMI supports anisotropic thermal conductivity, and the model can be evaluated along different crystallographic axes. The enumeration type `PMI_AnisotropyType` as defined in Mobility on page 1237 determines the axis. The default is isotropic thermal conductivity. If anisotropic thermal conductivity is activated in the command file, then the PMI class `PMI_ThermalConductivity` is also instantiated in the anisotropic direction.

## Dependencies

The thermal conductivity κ can depend on the variable:

`t` Lattice temperature [K]

The PMI model must compute the following results:

`kappa` Thermal conductivity κ [ Wcm<sup>–1</sup>K<sup>–1</sup> ]

In the case of the standard interface, the following derivative must be computed as well:

`dkappadt` derivative of κ with respect to t [ Wcm<sup>–1</sup>K<sup>–2</sup> ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_ThermalConductivity : public PMI_Vertex_Interface {

public:
  PMI_ThermalConductivity (const PMI_Environment& env,
                     const PMI_AnisotropyType anisotype);

  virtual ~PMI_ThermalConductivity ();

  PMI_AnisotropyType AnisotropyType () const { return anisoType; }

  virtual void Compute_kappa
  (const double t, double& kappa) = 0;

  virtual void Compute_dkappadt
  (const double t, double& dkappadt) = 0;
};
```

39: Physical Model Interface

Thermal Properties and Heat

The following virtual constructor must be implemented:

```cpp
typedef PMI_ThermalConductivity* new_PMI_ThermalConductivity_func
  (const PMI_Environment& env, const PMI_AnisotropyType anisotype);
extern "C" new_PMI_ThermalConductivity_func
  new_PMI_ThermalConductivity;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_ThermalConductivity_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;    // lattice temperature
  };

  class Output {
  public:
    pmi_float kappa;  // thermal conductivity
  };

  PMI_ThermalConductivity_Base (const PMI_Environment& env,
                                const PMI_AnisotropyType anisotype);

  virtual ~PMI_ThermalConductivity_Base ();

  PMI_AnisotropyType AnisotropyType () const;

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_ThermalConductivity_Base* new_PMI_ThermalConductivity_Base_func
  (const PMI_Environment& env, const PMI_AnisotropyType anisotype);
extern "C" new_PMI_ThermalConductivity_Base_func
  new_PMI_ThermalConductivity_Base;
```

## Example: Temperature-Dependent Thermal Conductivity

The following C++ code implements the temperature-dependent thermal conductivity:

$$ \kappa(T) = \frac{1}{a + bT + cT^2} $$ <sup>(1331)</sup>

Thermal Properties and Heat

as given in Eq. 1079, p. 969.

```cpp
#include "PMIModels.h"

class TempDep_ThermalConductivity : public PMI_ThermalConductivity {
private:
  double a, b, c;

public:
  TempDep_ThermalConductivity (const PMI_Environment& env, const
PMI_AnisotropyType anisotype);
  ~TempDep_ThermalConductivity ();

  void Compute_kappa
    (const double t, double& kappa);

  void Compute_dkappadt
    (const double t, double& dkappadt);
};

TempDep_ThermalConductivity::
TempDep_ThermalConductivity (const PMI_Environment& env, const
PMI_AnisotropyType anisotype) :
  PMI_ThermalConductivity (env, anisotype)
{ // default values
  a = InitParameter ("a", 0.03);
  b = InitParameter ("b", 1.56e-03);
  c = InitParameter ("c", 1.65e-06);
}

TempDep_ThermalConductivity::
~TempDep_ThermalConductivity ()
{
}

void TempDep_ThermalConductivity::
Compute_kappa (const double t, double& kappa)
{ kappa = 1.0 / (a + b*t + c*t*t);
}

void TempDep_ThermalConductivity::
Compute_dkappadt (const double t, double& dkappadt)
{ const double kappa = 1.0 / (a + b*t + c*t*t);
  dkappadt = -kappa * kappa * (b + 2.0*c*t);
}

extern "C"
PMI_ThermalConductivity* new_PMI_ThermalConductivity
```

39: Physical Model Interface

Thermal Properties and Heat

```cpp
(const PMI_Environment& env, const PMI_AnisotropyType anisotype)
{ return new TempDep_ThermalConductivity (env, anisotype);
}
```

# Example: Thin-Layer Thermal Conductivity

In this example, thermal conductivity depends on the doping and thickness of layers. In this case, the external LayerThickness command (see Extracting Layer Thickness on page 333) must be specified in the command file:

```
Physics (Material="Silicon") {
   LayerThickness(<parameters>)      # external command for thickness extraction
   ThermalConductivity (ThinLayerKappa)
}
```

The following C++ code implements the thin-layer doping-dependent thermal conductivity (see `$STROOT/tcad/$STRELEASE/lib/sdevice/src/pmi_ThinLayerKappa/ThinLayerKappa.C`):

$$ \kappa = \kappa_0 \cdot \kappa_d(d) \cdot \kappa_h(h) $$ (1332)

where:

*   $\kappa_0$ is a constant value [Wcm<sup>-1</sup>K<sup>-1</sup>].

*   $d$ is Doping/ScaleDoping (unitless doping).

*   $h$ is LayerThickness/ScaleThickness (unitless layer thickness).

*   $\kappa_d(d) = (a_2(d - d_0)^2 + a_1(d - d_0) + a_0) \cdot \exp(\alpha(d - d_0))$.

*   $\kappa_h(h) = (b_2(h - h_0)^2 + b_1(h - h_0) + b_0) \cdot \exp(\beta(h - h_0))$.

```cpp
#include <math.h>
#include "PMI.h"

class ThinLayer_ThermalConductivity : public PMI_ThermalConductivity_Base
{
private:
   double kappa0;                                 // [W/(K*cm)]
   double ScaleDoping;                            // [cm-3]
   double ScaleThickness;                         // [um]
   double d0, a0, a1, a2, alpha;                  // [1]
   double h0, b0, b1, b2, beta;                   // [1]

public:
   ThinLayer_ThermalConductivity (const PMI_Environment& env,
                                  const PMI_AnisotropyType anisotype);
   ~ThinLayer_ThermalConductivity ();
```

Thermal Properties and Heat

```cpp
    void compute (const Input& input, Output& output);
};

ThinLayer_ThermalConductivity::
ThinLayer_ThermalConductivity (const PMI_Environment& env,
                               const PMI_AnisotropyType anisotype) :
    PMI_ThermalConductivity_Base (env, anisotype)
{ // default values
    kappa0 = InitParameter("kappa0", 1.);             // [W/(K*cm)]

    ScaleDoping = InitParameter("ScaleDoping", 1.e+18);   // [cm-3]
    d0     = InitParameter("d0", 1.);       // [1]
    a0     = InitParameter("a0", 1.);       // [1]
    a1     = InitParameter("a1", 0.);       // [1]
    a2     = InitParameter("a2", 0.);       // [1]
    alpha  = InitParameter("alpha", 0.);     // [1]

    ScaleThickness = InitParameter("ScaleThickness", 1.e-3); // [um] = 1 nm
    h0     = InitParameter("h0", 1.);       // [1]
    b0     = InitParameter("b0", 1.);       // [1]
    b1     = InitParameter("b1", 0.);       // [1]
    b2     = InitParameter("b2", 0.);       // [1]
    beta   = InitParameter("beta", 0.);     // [1]
}

ThinLayer_ThermalConductivity::
~ThinLayer_ThermalConductivity ()
{}

void ThinLayer_ThermalConductivity::
compute (const Input& input, Output& output)
{
    const double h  = input.ReadLayerThickness()/ScaleThickness;
    pmi_float Nd = input.ReadDoping(PMI_Donor);
    pmi_float Na = input.ReadDoping(PMI_Acceptor);
    pmi_float d  = (Nd - Na)/ScaleDoping;

    pmi_float kd = (a2*(d-d0)*(d-d0) + a1*(d-d0) + a0)*exp(alpha*(d-d0));
    pmi_float kh = (b2*(h-h0)*(h-h0) + b1*(h-h0) + b0)*exp(beta*(h-h0));

    pmi_float kappa = kappa0*kd*kh;

    output.kappa = kappa; //  [W/(K*cm)]
}

extern "C"
PMI_ThermalConductivity_Base* new_PMI_ThermalConductivity_Base
    (const PMI_Environment& env, const PMI_AnisotropyType anisotype)
```

Thermal Properties and Heat

```cpp
{ return new ThinLayer_ThermalConductivity (env, anisotype);
}
```

The following example is a parameter file for the formula $\kappa = (2d^2 + d + 1) \cdot \exp(0.1 \cdot h)$:

```
Material = "Silicon" {

  ThinLayerKappa {
    kappa0 = 1     # [W/(K*cm)]

    ScaleDoping = 1.e+18   # [cm-3]
    d0     = 0     # [1]
    a0     = 1     # [1]
    a1     = 1     # [1]
    a2     = 2     # [1]
    alpha  = 0     # [1]

    ScaleThickness = 1.e-3 # [um] = 1 nm
    h0     = 0     # [1]
    b0     = 1     # [1]
    b1     = 0     # [1]
    b2     = 0     # [1]
    beta   = 0.1   # [1]
  }
}
```

# Thermoelectric Power

The thermoelectric powers $P_n$ and $P_p$ in semiconductors can be defined by a PMI (see Thermoelectric Power on page 981).

The name of the PMI can be specified regionwise, materialwise, or globally in the `Physics` section of the command file as follows:

```
Physics(Material="Silicon") { TEPower(pmi_model) }
```

## Dependencies

The semiconductor TEPs can depend on the following variables:

```
t        Lattice temperature [K]
dens     Carrier density [cm-3]
```

Thermal Properties and Heat

The PMI model must compute the following results:

`power` Thermoelectric power [ VK<sup>-1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

`dpowerdt` Derivative of power with respect to t [ VK<sup>-2</sup> ]
`dpowerddens` Derivative of power with respect to dens [ VK<sup>-1</sup>cm<sup>-3</sup> ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_ThermoElectricPower : public PMI_Vertex_Interface {

public:
  PMI_ThermoElectricPower(const PMI_Environment& env);
  virtual ~PMI_ThermoElectricPower ();

  virtual void Compute_power(
    const double t,        // lattice temperature
    const double dens,     // carrier density
    double& power);        // thermoelectric power

  virtual void Compute_dpowerdt(
    const double t,        // lattice temperature
    const double dens,     // carrier density
    double& dpowerdt);     // derivative of thermoelectric power
                           // with respect to lattice temperature

  virtual void Compute_dpowerddens(
    const double t,        // lattice temperature
    const double dens,     // carrier density
    double& dpowerddens);  // derivative of thermoelectric power
                           // with respect to carrier density
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_ThermoElectricPower* new_PMI_ThermoElectricPower_func
  (const PMI_Environment& env);
extern "C" new_PMI_ThermoElectricPower_func new_PMI_e_ThermoElectricPower;
extern "C" new_PMI_ThermoElectricPower_func new_PMI_h_ThermoElectricPower;
```

39: Physical Model Interface
Thermal Properties and Heat

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_ThermoElectricPower_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;        // lattice temperature
    pmi_float dens;     // carrier density
  };

  class Output {
  public:
    pmi_float power; // thermoelectric power
  };

  PMI_ThermoElectricPower_Base (const PMI_Environment& env);
  virtual ~PMI_ThermoElectricPower_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
extern "C"
PMI_ThermoElectricPower_Base* new_PMI_ThermoElectricPower_Base
  (const PMI_Environment& env);
```

# Example: Analytic TEP

The following C++ code implements an analytic TEP model (see Thermoelectric Power on page 981):

```cpp
#include "PMIModels.h"

namespace {
 // pi
 double pi = 3.141592654;
 // electron mass in kg
 double m0 = 9.109534e-31;
 // Planck’s constant in J*s
 double h_planck = 6.626176e-34;
 // Boltzmann constant in J/K
 double kB = 1.380662e-23;
 // electron charge in C
 double e0 = 1.602192e-19;
```

Thermal Properties and Heat

```cpp
  double pow_1_5 (double x) {
    return (x==1) ? 1 : x * sqrt (x);
  }

  double Compute_NB_By3_2 (double m_r) {
    double val = 2 * pow_1_5(2 * pi * (kB/h_planck) * (m0/h_planck)) / 1e6;
    val *= pow_1_5(m_r);
    return val;
  }
}

class AnalyticalTEP_ThermoElectricPower : public PMI_ThermoElectricPower
{
  protected:
    double k_c, s_c;
    // relative effective mass
    double m_r;
    int sign;

  public:
    AnalyticalTEP_ThermoElectricPower(const PMI_Environment& env);
    ~AnalyticalTEP_ThermoElectricPower ();

    void Compute_power
    (const double t,            // lattice temperature
     const double dens,         // carrier density
     double& power);            // thermoelectric power

    void Compute_dpowerdt
    (const double t,            // lattice temperature
     const double dens,         // carrier density
     double& dpowerdt);         // derivative of thermoelectric power
                                // with respect to lattice temperature

    void Compute_dpowerddens
    (const double t,            // lattice temperature
     const double dens,         // carrier density
     double& dpowerddens);      // derivative of thermoelectric power
                                // with respect to carrier density
};

AnalyticalTEP_ThermoElectricPower::
AnalyticalTEP_ThermoElectricPower (const PMI_Environment& env) :
  PMI_ThermoElectricPower (env)
{
}
```

Thermal Properties and Heat

```cpp
AnalyticalTEP_ThermoElectricPower::
~AnalyticalTEP_ThermoElectricPower ()
{
}

void AnalyticalTEP_ThermoElectricPower::
Compute_power (const double t, const double dens, double& power)
{
  double NB = Compute_NB_By3_2(m_r) * pow_1_5(t);
  if(sign < 0)
    power = k_c * (log(dens/NB) + s_c - 2.5);
  else
    power = k_c * (log(NB/dens) - s_c + 2.5);
  power *= (kB/e0);
}

void AnalyticalTEP_ThermoElectricPower::
Compute_dpowerdt (const double t, const double dens, double& dpowerdt)
{
  dpowerdt = sign * (kB/e0) * k_c * 1.5 / t;
}

void AnalyticalTEP_ThermoElectricPower::
Compute_dpowerddens (const double t, const double dens, double& dpowerddens)
{
  dpowerddens = -sign * (kB/e0) * k_c / dens;
}

class AnalyticalTEP_e_ThermoElectricPower :
public AnalyticalTEP_ThermoElectricPower
{
  public:
    AnalyticalTEP_e_ThermoElectricPower(const PMI_Environment& env);
    ~AnalyticalTEP_e_ThermoElectricPower () {}
};

AnalyticalTEP_e_ThermoElectricPower::
AnalyticalTEP_e_ThermoElectricPower(const PMI_Environment& env) :
AnalyticalTEP_ThermoElectricPower(env) {
  // default values
  k_c = InitParameter("k_c_e", 1);
  s_c = InitParameter("s_c_e", 1);
  m_r = InitParameter("m_r_e", 1);
  sign = -1;
}

class AnalyticalTEP_h_ThermoElectricPower :
public AnalyticalTEP_ThermoElectricPower
```

Optics

```cpp
{
  public:
    AnalyticalTEP_h_ThermoElectricPower(const PMI_Environment& env);
    ~AnalyticalTEP_h_ThermoElectricPower () {}
};

AnalyticalTEP_h_ThermoElectricPower::
AnalyticalTEP_h_ThermoElectricPower(const PMI_Environment& env) :
AnalyticalTEP_ThermoElectricPower(env) {
  // default values
  k_c = InitParameter("k_c_h", 1);
  s_c = InitParameter("s_c_h", 1);
  m_r = InitParameter("m_r_h", 1);
  sign = 1;
}

extern "C"
PMI_ThermoElectricPower* new_PMI_e_ThermoElectricPower
  (const PMI_Environment& env)
{
  return new AnalyticalTEP_e_ThermoElectricPower(env);
}

extern "C"
PMI_ThermoElectricPower* new_PMI_h_ThermoElectricPower
  (const PMI_Environment& env)
{
  return new AnalyticalTEP_h_ThermoElectricPower(env);
}
```

# Optics

This section presents the following PMIs:

*   Complex Refractive Index Model Interface

*   Optical Quantum Yield

*   Special Contact PMI for Raytracing

## Complex Refractive Index Model Interface

The complex refractive index model interface (CRIMI) allows the addition of new complex refractive index models as a function of almost any internally available variable. These models must be implemented as C++ functions, and Sentaurus Device loads the functions at runtime

39: Physical Model Interface

Optics

using the dynamic loader. No access to the Sentaurus Device source code is necessary. The concept is similar to that of the PMI; however, it is not limited to Sentaurus Device.

The generated shared object containing the model implementation can be used together with Sentaurus Device Electromagnetic Wave Solver (see Sentaurus™ Device Electromagnetic Wave Solver User Guide, Complex Refractive Index Model Interface on page 34) and Sentaurus Mesh (see Sentaurus™ Mesh User Guide, Computing Cell Size Automatically (EMW Applications) on page 125).

Three main steps are required for integrating user-defined models:

1.  A C++ class implementing the complex refractive index model must be written.

2.  A shared object must be created that can be loaded at runtime.

3.  The model must be activated in the command file.

These steps are described in the following sections in more detail.

## C++ Application Programming Interface

For each complex refractive index model, two C++ subroutines must be implemented: one to compute the refractive index and one to compute the extinction coefficient. More specifically, a C++ class must be implemented that is derived from a base class declared in the header file `CRIModels.h`. In addition, you must provide a virtual constructor function, which allocates an instance of the derived class, and a virtual destructor function, which deallocates it.

The public interface of the base class from which a model-specific class must be derived is declared in the header file `CRIModels.h` as:

```cpp
class CRI_Model : public CRI_Model_Interface {
public:
  CRI_Model(const CRI_Environment& env);
  virtual ~CRI_Model();
  //definition of complex refractive index
  struct ComplexRefractiveIndexConstituentsReal {
    double n0;
    double dn_lambda;
    double dn_temp;
    double dn_carr;
    double dn_gain;
  };

  struct ComplexRefractiveIndexConstituentsImag {
    double k0;
    double dk_lambda;
    double dk_carr;
```

39: Physical Model Interface

Optics

```cpp
    };

    //methods to be implemented by user

    //definition of complex refractive index in terms of its constituents
    virtual void Compute_n(ComplexRefractiveIndexConstituentsReal& data);
    virtual void Compute_k(ComplexRefractiveIndexConstituentsImag& data);

    //direct definition of complex refractive index
    virtual void Compute_n(double& n) = 0;
    virtual void Compute_k(double& k) = 0;
};
```

The CRIMI provides a *basic interface* where only the actual value of the refractive index and the extinction coefficient can be overridden as well as an *advanced interface*. In the advanced interface, the total values are computed automatically from its constituents, and it has the advantage that the user-specified constituents can be visualized instead of its default values. If carrier dependency is modeled with a CRIMI and quantum yield or temperature or both should be consistent, the advanced interface must be used. If a CRIMI is used in a thermal simulation where free carrier absorption plays a role, using the advanced interface is mandatory. For details, see Quantum Yield Models on page 603.

The arguments of the `Compute` functions indicate that they are passed as references to the respective functions. They carry the values corresponding to the model specification in the `ComplexRefractiveIndex` section in the command file. When implementing a user-defined complex refractive index model, the values for `n` and `k` (in the case of the basic interface) or the members of struct `ComplexRefractiveIndexConstituentsReal` and struct `ComplexRefractiveIndexConstituentsImag` must be overwritten in the function body. Otherwise, the original values remain unchanged, which can be useful if, for example, only a new model for either the real or the imaginary part of the complex refractive index must be implemented or if only a specific constituent needs to be modified.

Often, a complex refractive index model is based on several material-specific parameters. For each region or material, these parameters can be defined in special sections of the parameter file that carry the model name as given in the command file. The parameters are best initialized in the constructor as it is called once for every region.

For this purpose, the member function called `InitParameter` is used, which has two arguments. The first argument is the name of the parameter as listed in the parameter file, and the second argument is its default value. The latter is used if no value is assigned to the parameter for a particular region or material. The supported value types for user-defined parameters are integer, floating-point number, and string.

39: Physical Model Interface

Optics

The following example shows how to initialize a parameter called Gamma in the constructor:

```cpp
Constant_CRI_Model::Constant_CRI_Model(const CRI_Environment& env) :
CRI_Model(env) {
  Gamma = InitParameter("Gamma", 1.5);
}
```

where Gamma was declared as a data member of type double in the class Constant_CRI_Model.

In addition to the implementation of the two class member functions Compute_n and Compute_k, the virtual constructor function and the virtual destructor function must be defined as:

```cpp
extern "C" {

  opto_n_cri::CRI_Model*
  new_CRI_Model(const opto_n_cri::CRI_Environment& env)
  {
    return new opto_n_cri::Constant_CRI_Model(env);
  }

  void
  delete_CRI_Model(opto_n_cri::CRI_Model* cri_model)
  {
    delete cri_model;
  }

}
```

In these sample functions, it is assumed that the name of the user-provided derived class is Constant_CRI_Model.

## Runtime Support

The base class of CRI_Model is derived from another class called CRI_Model_Interface, which adds several functions that extend the possibilities for defining new complex refractive index models. Among them are functions that query basic properties of the model such as its name, for which region and material it is called and which models have been specified in the command file.

Another group of functions allows you to read the values of the most common variables on which the complex refractive index depends, namely, wavelength, carrier densities, and temperature as well as the default values for the various contributions to the complex refractive index. For most models, this set of functions should be sufficient.

For advanced models, it might be necessary to have access to additional internal variables to model the dependencies correctly. To this end, three interface functions are available that allow

39: Physical Model Interface

Optics

you to query, to register, and to read the internal variables available. A specific variable can only be read in the `Compute` functions if it has been registered in the constructor. The internal name of the corresponding variable can be obtained from the function `GetAvailableVariables`, which returns a vector of strings containing the names of all supported variables.

The remaining functions offer support for mole fraction–dependent models and for direct access of the `NumericalTables` defined in the parameter file.

The signatures of the runtime support functions discussed here can be found in the header file `CRIModels.h` and are briefly described below. Corresponding type declarations are contained in the header file `ExportedTypes.h` in the same installation directory. These header files are located in `$STROOT/tcad/$STRELEASE/lib/opto/include/`.

General utility functions:

*   `std::string Name() const`: Returns the name of CRIModel as specified in the command file.

*   `std::string ReadRegionName() const`: Returns the name of the region to which the vertex belongs.

*   `std::string ReadMaterialName() const`: Returns the name of the material to which the vertex belongs.

*   `bool WithModel(ComplexRefractiveIndexModelType model) const`: Returns true if model is activated for the region to which the vertex belongs; otherwise, `false`. For each model, a corresponding specification in the `ComplexRefractiveIndex` section of the command file exists (see Using Complex Refractive Index on page 643).

Functions for reading the values of the most common variables on which the complex refractive index depends:

*   `double ReadWavelength() const`: Returns wavelength in [μm]

*   `double ReadTemperature() const`: Returns temperature in [K]

*   `double Read_eDensity() const`: Returns electron density in [cm<sup>-3</sup>]

*   `double Read_hDensity() const`: Returns hole density in [cm<sup>-3</sup>]

*   `double ReadQW_eDensity() const`: Returns quantum-well electron density corresponding to the bound states of the well in [cm<sup>-3</sup>]

*   `double ReadQW_hDensity() const`: Returns quantum-well hole density corresponding to the bound states of the well in [cm<sup>-3</sup>]

39: Physical Model Interface

Optics

Functions for accessing additional internal variables to model the dependencies correctly:

*   `const std::vector<std::string>& GetAvailableVariables() const`: Returns a vector of strings containing all internal variable names.

*   `void RegisterVariableToRead(std::string variable_name)`: Use variable name string from previous call to `GetAvailableVariables()` to register a variable for reading in the function body of the `Compute` functions. This is performed typically in the constructor.

*   `double ReadVariableValue(std::string variable_name) const`: Returns current value of variable selected by specifying variable name string from previous call to `GetAvailableVariables()` as argument.

The following C++ code sample shows the use of the functions for accessing additional internal variables:

```cpp
Constant_CRI_Model::Constant_CRI_Model(const CRI_Environment& env) :
CRI_Model(env) {
  // print out available variables
  const std::vector<std::string>& variables = GetAvailableVariables();
  std::cout << "Available variables: ";
  for(size_t i=0;i<variables.size();++i){
     std::cout << variables[i] << " ";
  }std::cout << std::endl;

  RegisterVariableToRead("my_dn");
}
void Constant_CRI_Model::Compute_n(double& n) {
  double my_dataset_val = ReadVariableValue("my_dn");
  n = Read_n();
  n += my_dataset_val;
}
```

In this code sample, the dataset `my_dn` is registered in the constructor as a readable variable and, in the `Compute` function, its value is added to the default refractive index given by the specified models such as `WavelengthDep` in the `ComplexRefractiveIndex` section. The `for` loop in the constructor is optional and allows you to query the exact names of the datasets, which are needed as arguments to the `ReadVariableValue` function.

Functions for reading the real and imaginary parts of the complex refractive index as well as its corresponding constituents computed according to the command file and parameter file specification:

*   `double Read_n() const`: Returns the real part of the complex refractive index

*   `double Read_k() const`: Returns the imaginary part of the complex refractive index

*   `double Read_n0() const`: Returns the base refractive index given in Eq. 689, p. 640

Optics

* `double Read_k0() const`: Returns the base extinction coefficient given in Eq. 690, p. 640

* `double Read_d_n_lambda() const`: Returns the change in refractive index due to its wavelength dependency

* `double Read_d_k_lambda() const`: Returns the change in extinction coefficient due to its wavelength dependency

* `double Read_d_n_temp() const`: Returns the change in refractive index due to its temperature dependency

* `double Read_d_n_carr() const`: Returns the change in refractive index due to its carrier dependency

* `double Read_d_k_carr() const`: Returns the change in extinction coefficient due to its carrier dependency

* `double Read_d_n_gain() const`: Returns the change in extinction coefficient due to its gain dependency

Functions for retrieving information about mole fraction–dependent models and for direct access of the NumericalTables defined in the parameter file:

* `int ReadNumberOfMoleFractionIntervals() const`: Returns the number of mole-fraction intervals defined in the `ComplexRefractiveIndex` section of the parameter file.

* `double ReadxMoleFractionUpperLimit(int interval) const`: Returns upper limit of x-mole fraction interval specified as an argument.

* `double ReadNumericalTableValue_n(int interval=0) const`: Returns the refractive index for the current wavelength and the mole-fraction interval specified as an argument.

* `double ReadNumericalTableValue_k(int interval=0) const`: Returns the extinction coefficient for the current wavelength and the mole-fraction interval specified as an argument.

* `NumericalTable<double>* ReadNumericalTable(int interval=0) const`: Returns the numeric table for the mole-fraction interval specified as an argument. This function can be useful if a custom table interpolation algorithm must be implemented.

## Shared Object Code

Sentaurus Device assumes that the shared object code corresponding to a CRI model can be found in the file `modelname.so.arch`. The base name of this file must be identical to the name of the CRI model. The extension `.arch` depends on the hardware architecture.

You can use the script `cmi`, which is also a part of the CMI (see Compact Models User Guide, Chapter 4 on page 129), to produce shared object files (see Compact Models User Guide, Runtime Support on page 154).

39: Physical Model Interface

Optics

## Command File of Sentaurus Device

To load CRI models into Sentaurus Device, the `PMIPath` search path must be defined in the `File` section of the command file. The value of `PMIPath` consists of a sequence of directories. For example:

```
File {
  PMIPath = ". /home/joe/lib /home/mary/sdevice/lib"
}
```

For each CRI model, which appears in the `ComplexRefractiveIndex` section, the given directories are searched for a corresponding shared object file `modelname.so.arch`.

A CRI model can be activated in the `ComplexRefractiveIndex` section of the command file by specifying the name of the model as shown in the following example:

```
Physics {
  Optics (
    ComplexRefractiveIndex (
      CRIModel (Name = "modelname")
    )
  )
}
```

A CRI model name can only consist of alphanumeric characters and underscores (_). The first character must be either a letter or an underscore. All the CRI models can be specified regionwise or materialwise:

```
Physics (region = "Region.1") { ... }
Physics (material = "SiO2") { ... }
```

when using the unified interface for optical generation computation in Sentaurus Device; otherwise, only global specification is supported.

## Optical Quantum Yield

The quantum yield factors η<sub>G</sub>, η<sub>T<sub>Eg</sub></sub>, and η<sub>T<sub>0</sub></sub> defined by Eq. 676, p. 605 can be accessed through a PMI.

In the command file, the PMI is specified in the `QuantumYield` section as follows:

```
Physics {
  Optics (
    OpticalGeneration (
      QuantumYield (
```

Optics

```
            ...
            pmiModel = "<pmi_model_name>"
         )
      )
   )
}
```

## Dependencies

The quantum yield factors η<sub>G</sub>, η<sub>T<sub>Eg</sub></sub>, and η<sub>T<sub>0</sub></sub> can depend on the variables:

**n** Electron density [ cm<sup>–3</sup> ]
**p** Hole density [ cm<sup>–3</sup> ]
**T** Lattice temperature [ K ]
**bg** Bandgap energy E<sub>g</sub> [eV]
**bg_eff** Effective bandgap energy (includes bandgap narrowing) E<sub>g,eff</sub> [eV]
**wavelength** Wavelength of incident light λ [ μm ]
**cplxRefIndex** Refractive index
**cplxExtCoeff** Extinction coefficient
**n_0** Base refractive index
**k_0** Base extinction coefficient
**d_n_lambda** Wavelength-dependent part of refractive index
**d_k_lambda** Wavelength-dependent part of extinction coefficient
**d_n_temp** Temperature-dependent part of refractive index
**d_n_carr** Carrier-dependent part of refractive index
**d_k_carr** Carrier-dependent part of extinction coefficient
**d_n_gain** Gain-dependent part of refractive index

The PMI model must compute the following results:

**eta_G** Quantum yield
**eta_T_Eg** Thermalization yield (band gap)
**eta_T0** Thermalization yield (vacuum)

39: Physical Model Interface
Optics

# Standard C++ Interface

The following base class (public interface) is declared in the file `PMIModels.h`:

```cpp
class PMI_OpticalQuantumYield : public PMI_Vertex_Interface
{
public:
  // the input data coming from the simulator
  class idata {
  public:
    idata(const void*);
    double n() const;
    double p() const;
    double T() const;
    double bg() const;
    double bg_eff() const;
    double wavelength() const;
    double cplxRefIndex() const;
    double cplxExtCoeff() const;
    double n_0() const;
    double k_0() const;
    double d_n_lambda() const;
    double d_k_lambda() const;
    double d_n_temp() const;
    double d_n_carr() const;
    double d_k_carr() const;
    double d_n_gain() const;
  };

  // the results computed by the PMI
  class odata {
  public:
    odata(void*);
    double& eta_G();
    double& eta_T_Eg();
    double& eta_T0();
  };

  // constructor and destructor
  PMI_OpticalQuantumYield(const PMI_Environment& env);
  virtual ~PMI_OpticalQuantumYield();

  // compute value and derivatives
  virtual void compute(const idata* id, odata* od ) = 0;
};
```

39: Physical Model Interface

Optics

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_OpticalQuantumYield* new_PMI_OpticalQuantumYield_func
  (const PMI_Environment& env);
extern "C" new_PMI_OpticalQuantumYield_func new_PMI_OpticalQuantumYield;
```

## Simplified C++ Interface

The following base class (public interface) is declared in the file `PMI.h`:

```cpp
class PMI_OpticalQuantumYield_Base : public PMI_Vertex_Base {
public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    Input (const PMI_OpticalQuantumYield_Base* opticalquantumyield_base,
    const int vertex);
    pmi_float n;
    pmi_float p;
    pmi_float T;
    pmi_float bg;
    pmi_float bg_eff;
    pmi_float wavelength;
    pmi_float cplxRefIndex;
    pmi_float cplxExtCoeff;
    pmi_float n_0;
    pmi_float k_0;
    pmi_float d_n_lambda;
    pmi_float d_k_lambda;
    pmi_float d_n_temp;
    pmi_float d_n_carr;
    pmi_float d_k_carr;
    pmi_float d_n_gain;
  };

  class Output {
  public:
    pmi_float eta_G;
    pmi_float eta_T_Eg;
    pmi_float eta_T0;
  };

  PMI_OpticalQuantumYield_Base (const PMI_Environment& env);
  virtual ~PMI_OpticalQuantumYield_Base ();
  virtual void compute (const Input& input, Output& output) = 0;
};
```

 39: Physical Model Interface

Optics

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_OpticalQuantumYield_Base* new_PMI_OpticalQuantumYield_Base_func
    (const PMI_Environment& env);
extern "C" new_PMI_OpticalQuantumYield_Base_func
new_PMI_OpticalQuantumYield_Base;
```

# Special Contact PMI for Raytracing

The PMI for raytracing allows you to access and change the parameters of a ray at special contacts. These contacts are drawn in the same manner as electrodes and thermodes (see Boundary Condition for Raytracing on page 660). The raytrace PMI is specified in the RayTraceBC section of the command file:

```
RayTraceBC {...
  { Name = "pmi_contact"
    PMIModel = "pmi_modelname"
  }
}
```

The name of "pmi_contact" must match the contact name in the device. Any ray that hits this special contact invokes a call to this PMI. This raytrace PMI works only with the raytracer (see Raytracer on page 648) and the complex refractive index model (see Complex Refractive Index Model on page 640).

**NOTE** When using multithreading of the raytracer, you must carefully design the PMI code to be thread safe. This means that global variables should not be used since multiple threads might change the global variables at the same time, leading to confusion in the user PMI code at runtime.

## Dependencies

The raytrace PMI depends on the following variables:

| wavelength | Wavelength [cm] |
| --- | --- |
| incident_angle | Incident angle [radian] |
| *incident_dirvec | Direction vector of incident ray |
| *polarvec | Polarization vector of incident ray |
| *normalvec | Normal vector to surface of impingement from region 1 to region 2 |

Optics

| *intersectpoint | Intersection position vector [ cm ] |
| --- | --- |
| *region1_name | Name of region 1 (string) |
| *region2_name | Name of region 2 (string) |
| n1_real | Real part of refractive index 1 |
| n1_imag | Imaginary part of refractive index 1 |
| n2_real | Real part of refractive index 2 |
| n2_imag | Imaginary part of refractive index 2 |
| reflected_angle | Reflected angle [radian] |
| transmitted_angle | Transmitted angle [radian] |
| *reflected_dirvec | Direction vector of reflected ray |
| *transmitted_dirvec | Direction vector of transmitted ray |
| *reflected_startposition | Starting position vector of reflected ray [ cm ] |
| *transmitted_startposition | Starting position vector of transmitted ray [ cm ] |
| R_TE | Power TE reflection coefficient |
| T_TE | Power TE transmission coefficient |
| R_TM | Power TM reflection coefficient |
| T_TM | Power TM transmission coefficient |

To obtain the rate intensity (units of s<sup>-1</sup>) carried by the ray, you need to compute the square of the length of `*polarvec`. This rate intensity includes all previous absorptions sustained by the ray when it traversed absorptive regions of the device, and it can be used directly to compute the amount of optical generation (with units of s<sup>-1</sup>). However, for raytracing used in LED simulations, the square of the length of `*polarvec` gives only a relative intensity value because the polarization vector of the head ray of the raytree is initialized to a length of 1.0.

If the reflection or transmission coefficients are equal to zero, then no reflected or transmitted rays are created in the raytracing process.

With this PMI model, you can change the following variables:

| reflected_angle | Reflected angle [radian] |
| --- | --- |
| transmitted_angle | Transmitted angle [radian] |

39: Physical Model Interface

Optics

| *reflected_dirvec | Direction vector of reflected ray |
| --- | --- |
| *transmitted_dirvec | Direction vector of transmitted ray |
| *reflected_startposition | Starting position vector of reflected ray [ cm ] |
| *transmitted_startposition | Starting position vector of transmitted ray [ cm ] |
| R_TE | Power TE reflection coefficient |
| T_TE | Power TE transmission coefficient |
| R_TM | Power TM reflection coefficient |
| T_TM | Power TM transmission coefficient |

If you want to change the direction vector, angle, or position vector of the reflected or transmitted ray, then the respective flags must be set to `TRUE`:

* `is_reflectedangle_changed`
* `is_reflecteddirvec_changed`
* `is_transmittedangle_changed`
* `is_transmitteddirvec_changed`
* `is_reflected_new_startposition`
* `is_transmitted_new_startposition`

However, no flags are needed if you want to change the power reflection or transmission coefficients.

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_RayTraceBoundary : public PMI_Vertex_Interface {
public:
    PMI_RayTraceBoundary (const PMI_Environment& env);
    virtual ~PMI_RayTraceBoundary();

    // methods to be implemented by user
    virtual void Compute_BoundaryParameters
        (// Non-changeable quantities
        const double wavelength,              // wavelength [cm]
        const double incident_angle,          // incident angle
        const double* incident_dirvec,        // dir vector of incident ray
        const double* polarvec,               // polar vec of incident ray
        const double* normalvec,              // normal to impingement
        const double* intersectpoint,         // intersection point
```

Optics

```cpp
    const char* region1_name,               // name of region 1
    const char* region2_name,               // name of region 2
    const double n1_real,                   // real part of refr index 1
    const double n1_imag,                   // imag part of refr index 1
    const double n2_real,                   // real part of refr index 2
    const double n2_imag,                   // imag part of refr index 2
    // User changeable quantities
    bool& is_reflectedangle_changed,        // is refl angle changed?
    bool& is_reflecteddirvec_changed,       // is reflected dir changed?
    bool& is_transmittedangle_changed,      // is transm angle changed?
    bool& is_transmitteddirvec_changed,     // is transm dir changed?
    bool& is_reflected_new_startposition,   // is refl pos changed?
    bool& is_transmitted_new_startposition, // is transm pos changed?
    double& reflected_angle,                // reflected angle
    double& transmitted_angle,              // transmitted angle
    double* reflected_dirvec,               // dir vec of reflected ray
    double* transmitted_dirvec,             // dir vec of transmitted ray
    double* reflected_startposition,        // start pos of reflected ray
    double* transmitted_startposition,      // start pos of transm ray
    double& R_TE,                           // power TE reflection coeff.
    double& T_TE,                           // power TE transmission coeff.
    double& R_TM,                           // power TM reflection coeff.
    double& T_TM                            // power TM transmission coeff.
    ) = 0;

  // Auxiliary functions for users
  void ReadComplexRefractiveIndex(std::string location_name,
    double wavelength,   // in microns
    double& n,
    double& k,
    PMI_RayTraceBoundary::LocationType location_type =
    PMI_RayTraceBoundary::Material);
  private:
  const PMI_Environment* thisenv;
};
```

An internal auxiliary function called `ReadComplexRefractiveIndex(...)` allows you to compute the complex refractive index of any material or region at a particular wavelength. The constraint is that, if a requested material does not exist in the device structure, then it must at least be defined in the parameter file. The complex refractive index specification (for example, wavelength dependency for the real part or imaginary part or both) is taken from the command file. For materials that do not exist in the device structure, the specification from the default Physics section is used unless it is explicitly given in a corresponding separate material Physics section.

39: Physical Model Interface
Optics

# Example: Assessing and Modifying a Ray

The following example shows how to access the information about a ray that intersects the special raytrace PMI contact, and how you can change the information of the ray:

```cpp
class Dummy_RayTraceBoundary : public PMI_RayTraceBoundary {
private:
  // short ind_field; // field index for optical generation
  //       double shape; // transient curve shape
  //       double G1, G2, G3, T1, T2, T3, T4; // const for shapes
  int count;
  double d1;
public:
  Dummy_RayTraceBoundary (const PMI_Environment& env);
  ~Dummy_RayTraceBoundary ();

  void Compute_BoundaryParameters
   (const double wavelength,               // wavelength [cm]
   const double incident_angle,            // incident angle
   const double* incident_dirvec,          // dir vec of incident ray
   const double* polarvec,                 // polar vec of incident ray
   const double* normalvec,                // normal to impingement
   const double* intersectpoint,           // intersection point
   const char* region1_name,               // name of region 1
   const char* region2_name,               // name of region 2
   const double n1_real,                   // real part of refr index 1
   const double n1_imag,                   // imag part of refr index 1
   const double n2_real,                   // real part of refr index 2
   const double n2_imag,                   // imag part of refr index 2
   // User changeable quantities
   bool& is_reflectedangle_changed,        // is refl angle changed?
   bool& is_reflecteddirvec_changed,       // is refl dir changed?
   bool& is_transmittedangle_changed,      // is transm angle changed?
   bool& is_transmitteddirvec_changed,     // is transm dir changed?
   bool& is_reflected_new_startposition,   // is refl pos changed?
   bool& is_transmitted_new_startposition, // is transm pos changed?
   double& reflected_angle,                // reflected angle
   double& transmitted_angle,              // transmitted angle
   double* reflected_dirvec,               // dir vec of reflected ray
   double* transmitted_dirvec,             // dir vec of transmitted ray
   double* reflected_startposition,        // start pos of reflected ray
   double* transmitted_startposition,      // start pos of transm ray
   double& R_TE,                           // power TE reflection coeff.
   double& T_TE,                           // power TE transmission coeff.
   double& R_TM,                           // power TM reflection coeff.
   double& T_TM                            // power TM transmission coeff.
   );
};
```

Optics

```cpp
Dummy_RayTraceBoundary::
Dummy_RayTraceBoundary (const PMI_Environment& env) :
 PMI_RayTraceBoundary (env)
{
 printf("PMI: initializing ray trace PMI\n");
}

Dummy_RayTraceBoundary::
~Dummy_RayTraceBoundary ()
{
}

void Dummy_RayTraceBoundary::
Compute_BoundaryParameters (
  const double wavelength,
  const double incident_angle,
  const double* incident_dirvec,
  const double* polarvec,
  const double* normalvec,
  const double* intersectpoint,
  const char* region1_name,
  const char* region2_name,
  const double n1_real,
  const double n1_imag,
  const double n2_real,
  const double n2_imag,
  // User changeable quantities
  bool& is_reflectedangle_changed,
  bool& is_reflecteddirvec_changed,
  bool& is_transmittedangle_changed,
  bool& is_transmitteddirvec_changed,
  bool& is_reflected_new_startposition,
  bool& is_transmitted_new_startposition,
  double& reflected_angle,
  double& transmitted_angle,
  double* reflected_dirvec,
  double* transmitted_dirvec,
  double* reflected_startposition,
  double* transmitted_startposition,
  double& R_TE,
  double& T_TE,
  double& R_TM,
  double& T_TM
)
{
 // Ray goes from region 1 to region 2.
 // PMI contact is the interface between regions 1 and 2.
```

39: Physical Model Interface
Mechanical Stress

```c
    printf("Region 1: Name=%s, Refractive Index = %e + i%e\n",
      region1_name, n1_real, n1_imag);
    printf("Angles: Incident=%lf, Reflected=%lf, Transmitted=%lf\n",
      incident_angle, reflected_angle, transmitted_angle);
    printf("Wavelength = %e [cm]\n", wavelength);
    printf("Incident Ray Direction=(%e,%e,%e)\n",
      incident_dirvec[0], incident_dirvec[1], incident_dirvec[2]);
    printf("Power Coefficients: R_TE=%e, T_TE=%e, R_TM=%e, T_TM=%e\n",
      R_TE, T_TE, R_TM, T_TM);

    // For example, change reflected direction to (1,2,3)
    is_reflecteddirvec_changed = TRUE;
    reflected_dirvec[0] = 1.0;
    reflected_dirvec[1] = 2.0;
    reflected_dirvec[2] = 3.0;
  }
  extern "C" {
    PMI_RayTraceBoundary* new_PMI_RayTraceBoundary (const PMI_Environment& env)
    { return new Dummy_RayTraceBoundary (env);
    }
  }
}
```

# Mechanical Stress

This section presents the following PMIs:

*   Mobility Stress Factor

*   Piezoelectric Polarization

*   Piezoresistive Coefficients

*   Stress

## Mobility Stress Factor

Stress-dependent isotropic mobility enhancement factors can be computed by a mobility stress factor PMI. These factors are applied to total low-field mobility or mobility components as described in Isotropic Factor Models on page 937.

1339

Mechanical Stress

The name of a mobility stress factor PMI model is specified as a `Factor` option in the command file (see Using Isotropic Factor Models on page 938):

```
Physics {
  Piezo (
    Model (
      Mobility (
        Factor (
          pmi_model_name
          [ChannelDirection=<n>]
          [AutoOrientation | ParameterSetName="<psname>"]
        )
      )
    )
  )
}
```

If specified, then the `Factor` options `ChannelDirection=<n>`, `AutoOrientation`, and `ParameterSetName="<psname>"` are passed as parameters to the mobility stress factor PMI model (`AutoOrientation` is passed as `AutoOrientation=1`).

## Dependencies

A mobility stress factor PMI model can depend on the following variable:

`enorm` Normal electric field [ Vcm<sup>–1</sup> ]

The PMI model must compute the following result:

`mobilitystressfactor` Stress-dependent mobility enhancement factor [1]

In the case of the standard interface, the following derivative must be computed as well:

`dmobilitystressfactordenorm` Derivative of the mobility stress factor with respect to $E_{\text{normal}}$ [ cmV<sup>–1</sup> ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_MobilityStressFactor : public PMI_Vertex_Interface {

public:
  PMI_MobilityStressFactor (const PMI_Environment& env);
```

39: Physical Model Interface

Mechanical Stress

```cpp
    virtual ~PMI_MobilityStressFactor ();

    virtual void Compute_mobilitystressfactor
      (const double enorm, double& mobilitystressfactor,
      double& dmobilitystressfactordenorm) = 0;
};
```

Two virtual constructors are required for electron and hole mobility factors:

```cpp
typedef PMI_MobilityStressFactor* new_PMI_MobilityStressFactor_func
  (const PMI_Environment& env);
extern "C" new_PMI_MobilityStressFactor_func new_PMI_e_MobilityStressFactor;
extern "C" new_PMI_MobilityStressFactor_func new_PMI_h_MobilityStressFactor;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_MobilityStressFactor_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float enorm; // normal to interface electric field
  };

  class Output {
  public:
    pmi_float mobilitystressfactor; // mobility enhancement stress factor
  };
  PMI_MobilityStressFactor_Base (const PMI_Environment& env);
  virtual ~PMI_MobilityStressFactor_Base ();
  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_MobilityStressFactor_Base* new_PMI_MobilityStressFactor_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_MobilityStressFactor_Base_func
  new_PMI_e_MobilityStressFactor_Base;
extern "C" new_PMI_MobilityStressFactor_Base_func
  new_PMI_h_MobilityStressFactor_Base;
```

Mechanical Stress

## Example: Effective Stress

This example illustrates the implementation of the EffectiveStressModel (see Effective Stress Model on page 939) using the standard C++ interface:

```cpp
#include "PMI.h"
#include <cmath>

class pmi_EffectiveStressModel : public PMI_MobilityStressFactor {

protected:
  int cd, dim;
  double alpha1,alpha2,alpha3,beta11,beta12,beta13,beta22,beta23,beta33;
  double mu0,a10,a11,a12,a20,a21,a22,s00,s01,s02,t0,t1,t2,F0;

public:
  pmi_EffectiveStressModel (const PMI_Environment& env);
  ~pmi_EffectiveStressModel ();
  void Compute_mobilitystressfactor (const double enorm,
                                     double& mobilitystressfactor,
                                     double& dmobilitystressfactordenorm);
};

pmi_EffectiveStressModel::
pmi_EffectiveStressModel (const PMI_Environment& env) :
  PMI_MobilityStressFactor (env)
{
}

pmi_EffectiveStressModel::
~pmi_EffectiveStressModel ()
{
}

void pmi_EffectiveStressModel::
Compute_mobilitystressfactor (const double enorm,
                              double& mobilitystressfactor,
                              double& dmobilitystressfactordenorm)
{
  // Get stress components and convert to MPa.
  double stress[6];
  stress[0] = 1.e-6*ReadStress(PMI_StressXX);
  stress[1] = 1.e-6*ReadStress(PMI_StressYY);
  stress[2] = 1.e-6*ReadStress(PMI_StressZZ);
  stress[3] = 1.e-6*ReadStress(PMI_StressYZ);
  stress[4] = 1.e-6*ReadStress(PMI_StressXZ);
  stress[5] = 1.e-6*ReadStress(PMI_StressXY);

  // Get the diagonal stresses used in the calculation.
```

39: Physical Model Interface
Mechanical Stress

```cpp
double S11 = 0.0, S22 = 0.0, S33 = 0.0;

// 1D cases and 2D cases where cd != 2.
if (dim == 1 || (dim == 2 && cd <2)) {
  const int nd = (cd == 0) ? 1 : 0;
  const int pd = 3-cd-nd;
  S11 = stress[cd];
  S22 = stress[nd];
  S33 = stress[pd];
}

// Otherwise, do a stress transformation to get the stress components.
else {
  // Normal direction vector.
  double norm[3];
  ReadNearestInterfaceNormal(norm[0], norm[1], norm[2]);
  norm[cd] = 0.0;
  if (norm[0] == 0. && norm[1] == 0. && norm[2] == 0.0) {
    if (cd == 0) norm[1] = 1.0;
    else norm[0] = 1.0;
  }
  else {
    const double mag=sqrt(norm[0]*norm[0]+norm[1]*norm[1]+norm[2]*norm[2]);
    norm[0] /= mag; norm[1] /= mag; norm[2] /= mag;
  }

  // Channel direction vector.
  double chan[3] = {0.0};
  chan[cd] = 1.0;

  // In-plane direction vector.
  double plan[3];
  plan[0] = chan[1]*norm[2] - chan[2]*norm[1];
  plan[1] = chan[2]*norm[0] - chan[0]*norm[2];
  plan[2] = chan[0]*norm[1] - chan[1]*norm[0];

  // Rotation matrix.
  double a[3][3];
  a[0][0]=chan[0]; a[0][1]=chan[1]; a[0][2]=chan[2];
  a[1][0]=norm[0]; a[1][1]=norm[1]; a[1][2]=norm[2];
  a[2][0]=plan[0]; a[2][1]=plan[1]; a[2][2]=plan[2];

  // Get the diagonal components of the transformed stress tensor.
  double SD[3][3];
  SD[0][0] = stress[0]; SD[1][1] = stress[1]; SD[2][2] = stress[2];
  SD[0][1] = SD[1][0] = stress[5];
  SD[0][2] = SD[2][0] = stress[4];
  SD[1][2] = SD[2][1] = stress[3];
```

Mechanical Stress

```cpp
  // Channel direction.
  S11 = SD[cd][cd];

  // Normal direction.
  for (int i=0; i<3; ++i) {
    for (int j=0; j<3; ++j) {
      S22 += a[1][i]*a[1][j]*SD[i][j];
    }
  }

  // In-plane direction.
  for (int i=0; i<3; ++i) {
    for (int j=0; j<3; ++j) {
      S33 += a[2][i]*a[2][j]*SD[i][j];
    }
  }
}

// Effective stress.
const double Seff = alpha1*S11 + alpha2*S22 + alpha3*S33
  + beta11*S11*S11 + beta12*S11*S22 + beta13*S11*S33
  + beta22*S22*S22 + beta23*S22*S33 + beta33*S33*S33;

// Convert field to MV/cm.
const double F = 1.e-6*enorm;

// Get the stress factor.
const double FF = (F < F0) ? F : F0;
const double F2 = FF*FF;
const double A1 = a10 + a11*FF + a12*F2;
const double A2 = a20 + a21*FF + a22*F2;
const double S0 = s00 + s01*FF + s02*F2;
const double t  =  t0 +  t1*F +  t2*F*F;
const double sarg = (Seff - S0)/t;
const double expsarg = exp(sarg);
const double expsargp1 = 1. + expsarg;
mobilitystressfactor = ((A1-A2)/expsargp1 + A2)/mu0;

// Derivative wrt enorm.
const double dA1dF = (F < F0) ? a11 + 2.*a12*F : 0.0;
const double dA2dF = (F < F0) ? a21 + 2.*a22*F : 0.0;
const double dS0dF = (F < F0) ? s01 + 2.*s02*F : 0.0;
const double dtdF  =  t1 + 2.*t2*F;
const double dsfdF = (dA1dF + expsarg*dA2dF + (A1-A2)*expsarg*
    (dS0dF + sarg*dtdF)/(t*expsargp1))/(mu0*expsargp1);
dmobilitystressfactordenorm = 1.e-6*dsfdF;
}
```

39: Physical Model Interface

Mechanical Stress

```cpp
class pmi_e_EffectiveStressModel : public pmi_EffectiveStressModel {
public:
 pmi_e_EffectiveStressModel (const PMI_Environment& env);
 ~pmi_e_EffectiveStressModel () {}
};

pmi_e_EffectiveStressModel::
pmi_e_EffectiveStressModel (const PMI_Environment& env)
 : pmi_EffectiveStressModel (env)
{
 // Get channel direction and dimension.
 const double dchannelDirection = InitParameter("ChannelDirection", 1.0);
 cd = (dchannelDirection == 2.0) ? 1 : ((dchannelDirection == 3.0) ? 2 : 0);
 dim = ReadDimension();

 alpha1 = InitParameter ("alpha1_e",  1.0);
 alpha2 = InitParameter ("alpha2_e", -1.7);
 alpha3 = InitParameter ("alpha3_e",  0.7);
 beta11 = InitParameter ("beta11_e",  0.0);
 beta12 = InitParameter ("beta12_e",  0.0);
 beta13 = InitParameter ("beta13_e",  0.0);
 beta22 = InitParameter ("beta22_e",  0.0);
 beta23 = InitParameter ("beta23_e",  0.0);
 beta33 = InitParameter ("beta33_e",  0.0);
 mu0 = InitParameter ("mu0_e",     810.0);
 a10 = InitParameter ("a10_e",     565.0);
 a11 = InitParameter ("a11_e",     -81.0);
 a12 = InitParameter ("a12_e",     -44.0);
 a20 = InitParameter ("a20_e", 2028.0);
 a21 = InitParameter ("a21_e", -1992.0);
 a22 = InitParameter ("a22_e",     920.0);
 s00 = InitParameter ("s00_e", 1334.0);
 s01 = InitParameter ("s01_e", -2646.0);
 s02 = InitParameter ("s02_e",     875.0);
 t0 = InitParameter ("t0_e" ,     882.0);
 t1 = InitParameter ("t1_e" ,     -987.0);
 t2 = InitParameter ("t2_e" ,     604.0);
 F0 = InitParameter ("F0_e" ,     1.e10);
}

class pmi_h_EffectiveStressModel : public pmi_EffectiveStressModel {
public:
 pmi_h_EffectiveStressModel (const PMI_Environment& env);
 ~pmi_h_EffectiveStressModel () {}
};

pmi_h_EffectiveStressModel::
```

Mechanical Stress

```cpp
pmi_h_EffectiveStressModel (const PMI_Environment& env)
 : pmi_EffectiveStressModel (env)
{
 // Get channel direction and dimension.
 const double dchannelDirection = InitParameter("ChannelDirection", 1.0);
 cd = (dchannelDirection == 2.0) ? 1 : ((dchannelDirection == 3.0) ? 2 : 0);
 dim = ReadDimension();

 alpha1 = InitParameter ("alpha1_h",  1.0);
 alpha2 = InitParameter ("alpha2_h", -0.4);
 alpha3 = InitParameter ("alpha3_h", -0.6);
 beta11 = InitParameter ("beta11_h",  0.0);
 beta12 = InitParameter ("beta12_h",  0.0);
 beta13 = InitParameter ("beta13_h", -0.00004);
 beta22 = InitParameter ("beta22_h",  0.00006);
 beta23 = InitParameter ("beta23_h", -0.00018);
 beta33 = InitParameter ("beta33_h",  0.00011);
 mu0 = InitParameter ("mu0_h",     212.0);
 a10 = InitParameter ("a10_h", 2460.0);
 a11 = InitParameter ("a11_h",       0.0);
 a12 = InitParameter ("a12_h",       0.0);
 a20 = InitParameter ("a20_h",      42.0);
 a21 = InitParameter ("a21_h",       0.0);
 a22 = InitParameter ("a22_h",       0.0);
 s00 = InitParameter ("s00_h", -1338.0);
 s01 = InitParameter ("s01_h",       0.0);
 s02 = InitParameter ("s02_h",       0.0);
 t0 = InitParameter ("t0_h" ,      524.0);
 t1 = InitParameter ("t1_h" ,       0.0);
 t2 = InitParameter ("t2_h" ,       0.0);
 F0 = InitParameter ("F0_h" ,      1.e10);
}

extern "C"
PMI_MobilityStressFactor* new_PMI_e_MobilityStressFactor
 (const PMI_Environment& env)
{ return new pmi_e_EffectiveStressModel (env);
}

extern "C"
PMI_MobilityStressFactor* new_PMI_h_MobilityStressFactor
 (const PMI_Environment& env)
{ return new pmi_h_EffectiveStressModel (env);
}
```

39: Physical Model Interface
Mechanical Stress

# Piezoelectric Polarization

The effects of piezoelectric polarization can be modeled by adding the divergence of the piezoelectric polarization vector as an additional charge term:

$$ q_{\text{PE}} = -\nabla P_{\text{PE}} \tag{1333} $$

to the right-hand side of the Poisson equation (see Eq. 37, p. 179):

$$ \nabla \varepsilon \cdot \nabla \phi = -q(p - n + N_{\text{D}} - N_{\text{A}}) - q_{\text{PE}} \tag{1334} $$

The quantity $P_{\text{PE}}$ denotes the piezoelectric polarization vector, which can be defined by a PMI. The built-in models for piezoelectric polarization are discussed in Dependency of Saturation Velocity on Stress on page 946.

The name of the PMI is specified in the `Physics` section of the command file as follows:

```
Physics {
    Piezoelectric_Polarization (pmi_polarization)
}
```

The piezoelectric polarization vector and the piezoelectric charge can be plotted by:

```
Plot {
    PE_Polarization/vector
    PE_Charge
}
```

Sentaurus Device assumes that the piezoelectric polarization vector $P_{\text{PE}}$ is zero outside of the device. This boundary condition might lead to an unexpectedly large charge density if $P_{\text{PE}}$ has a nonzero component orthogonal to the boundary (discontinuity in $\nabla P_{\text{PE}}$).

## Dependencies

The piezoelectric polarization model does not have explicit dependencies. However, it can use the runtime support. In particular, it has access to the stress fields.

The model must compute:

`pol` Piezoelectric polarization vector [ Ccm<sup>-2</sup> ]

The resulting vector `pol` has the dimension 3. However, only the first *dim* components need to be defined, where *dim* is equal to the dimension of the problem.

Mechanical Stress

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Polarization : public PMI_Vertex_Interface {

public:
  PMI_Polarization (const PMI_Environment& env);
  virtual ~PMI_Polarization ();

  virtual void Compute_pol
    (double pol [3]) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Polarization* new_PMI_Polarization_func
  (const PMI_Environment& env);
extern "C" new_PMI_Polarization_func new_PMI_Polarization;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_Polarization_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
  };

  class Output {
  public:
    pmi_float pol [3]; // piezoelectric polarization
  };

  PMI_Polarization_Base (const PMI_Environment& env);
  virtual ~PMI_Polarization_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Polarization_Base* new_PMI_Polarization_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_Polarization_Base_func new_PMI_Polarization_Base;
```

39: Physical Model Interface
Mechanical Stress

# Example: Gaussian Polarization

In this example, the piezoelectric polarization vector $P_{\text{PE}}$ has a simple Gaussian shape in the x-direction:

```cpp
#include "PMIModels.h"

class Gauss_Polarization : public PMI_Polarization {
private:
  double x0, c, a;

public:
  Gauss_Polarization (const PMI_Environment& env);
  ~Gauss_Polarization ();

  void Compute_pol (double pol [3]);
};

Gauss_Polarization::
Gauss_Polarization (const PMI_Environment& env) :
  PMI_Polarization (env)
{ x0 = InitParameter ("x0", 0.0);
  c = InitParameter ("c", 1.0);
  a = InitParameter ("a", 1e-5);
}

Gauss_Polarization::
~Gauss_Polarization ()
{
}

void Gauss_Polarization::
Compute_pol (double pol [3])
{ double x, y, z;
  ReadCoordinate (x, y, z);
  pol [0] = a * exp (-c * (x-x0) * (x-x0));
  pol [1] = 0.0;
  pol [2] = 0.0;
}

extern "C"
PMI_Polarization* new_PMI_Polarization
  (const PMI_Environment& env)
{ return new Gauss_Polarization (env);
}
```

Mechanical Stress

# Piezoresistive Coefficients

Sentaurus Device provides a PMI for implementing the dependencies of the piezoresistive prefactors over the normal electric field (see Enormal- and MoleFraction-Dependent Piezo Coefficients on page 931).

It is activated in the `Piezo` section of the command file, in the `Tensor` subsection:

```
Physics {
  ...
  Piezo(
    Model(Mobility(Tensor("pmi_model")))
  )
}
```

## Dependencies

The piezoresistive prefactors ePij and hPij can depend on the following variable:

`Enormal` Normal to interface semiconductor–dielectric electric field [ Vcm<sup>-1</sup> ]

The PMI model must compute the following results:

`p11, p12, p44` Piezoresistive prefactors [1]

In the case of the standard interface, the following derivatives must be computed as well:

`dp11, dp12, dp44` Derivatives of pij with respect to Enormal [ V<sup>-1</sup>cm ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_PiezoresistanceFactor : public PMI_Vertex_Interface {

public:
  PMI_PiezoresistanceFactor (const PMI_Environment& env);
  virtual ~PMI_PiezoresistanceFactor ();

  virtual void Compute_Pij(const double Enormal,
    double& p11, double& p12, double& p44) = 0;

  virtual void Compute_DerPij(const double Enormal,
```

39: Physical Model Interface
Mechanical Stress

```cpp
      double& dp11, double& dp12, double& dp44) = 0;
};
```

Two virtual constructors are required for the calculation of the piezoresistive prefactors.

```cpp
typedef PMI_PiezoresistanceFactor* new_PMI_PiezoresistanceFactor_func
  (const PMI_Environment& env);
extern "C" new_PMI_PiezoresistanceFactor_func new_PMI_ePiezoresistanceFactor;
extern "C" new_PMI_PiezoresistanceFactor_func new_PMI_hPiezoresistanceFactor;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_PiezoresistanceFactor_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float Enormal; // normal to interface electric field
  };

  class Output {
  public:
    pmi_float p11; // piezoresistive prefactor
    pmi_float p12; // piezoresistive prefactor
    pmi_float p44; // piezoresistive prefactor
  };

  PMI_PiezoresistanceFactor_Base (const PMI_Environment& env);
  virtual ~PMI_PiezoresistanceFactor_Base ();

  virtual bool IsPrefactor () = 0;

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_PiezoresistanceFactor_Base*
  new_PMI_PiezoresistanceFactor_Base_func (const PMI_Environment& env);
extern "C" new_PMI_PiezoresistanceFactor_Base_func
  new_PMI_ePiezoresistanceFactor_Base;
extern "C" new_PMI_PiezoresistanceFactor_Base_func
  new_PMI_hPiezoresistanceFactor_Base;
```

Mechanical Stress

---

## Stress

Sentaurus Device supports a PMI for mechanical stress (see Chapter 31 on page 885). The name of the PMI model must appear in the `Piezo` section of the command file:

```
Physics {
  Piezo ( Stress = pmi_model_name )
}
```

## Dependencies

A PMI stress model has no explicit dependencies. However, it can depend on doping concentrations and mole fractions through the runtime support.

The PMI model must compute the following results:

```
stress_xx  XX component of stress tensor [Pa]
stress_yy  YY component of stress tensor [Pa]
stress_zz  ZZ component of stress tensor [Pa]
stress_yz  YZ component of stress tensor [Pa]
stress_xz  XZ component of stress tensor [Pa]
stress_xy  XY component of stress tensor [Pa]
```

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_Stress : public PMI_Vertex_Interface {

public:
  PMI_Stress (const PMI_Environment& env);
  virtual ~PMI_Stress ();

  virtual void Compute_StressXX
    (double& stress_xx) = 0;

  virtual void Compute_StressYY
    (double& stress_yy) = 0;

  virtual void Compute_StressZZ
    (double& stress_zz) = 0;
```

39: Physical Model Interface

Mechanical Stress

```cpp
    virtual void Compute_StressYZ
      (double& stress_yz) = 0;

    virtual void Compute_StressXZ
      (double& stress_xz) = 0;

    virtual void Compute_StressXY
      (double& stress_xy) = 0;
  };
```

The prototype for the virtual constructor is given as:

```cpp
  typedef PMI_Stress* new_PMI_Stress_func
    (const PMI_Environment& env);
  extern "C" new_PMI_Stress_func new_PMI_Stress;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
  class PMI_Stress_Base : public PMI_Vertex_Base {

  public:
    class Input : public PMI_Vertex_Input_Base {
    public:
    };

    class Output {
    public:
      pmi_float stress_xx; // xx component of stress
      pmi_float stress_yy; // yy component of stress
      pmi_float stress_zz; // zz component of stress
      pmi_float stress_yz; // yz component of stress
      pmi_float stress_xz; // xz component of stress
      pmi_float stress_xy; // xy component of stress
    };

    PMI_Stress_Base (const PMI_Environment& env);
    virtual ~PMI_Stress_Base ();

    virtual void compute (const Input& input, Output& output) = 0;
  };
```

Mechanical Stress

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_Stress_Base* new_PMI_Stress_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_Stress_Base_func new_PMI_Stress_Base;
```

## Example: Constant Stress

The following code returns constant values for the stress tensor:

```cpp
#include "PMIModels.h"

class Constant_Stress : public PMI_Stress {

private:
  double xx, yy, zz, yz, xz, xy;

public:
  Constant_Stress (const PMI_Environment& env);

  ~Constant_Stress ();

  void Compute_StressXX (double& stress_xx);
  void Compute_StressYY (double& stress_yy);
  void Compute_StressZZ (double& stress_zz);
  void Compute_StressYZ (double& stress_yz);
  void Compute_StressXZ (double& stress_xz);
  void Compute_StressXY (double& stress_xy);

};

Constant_Stress::
Constant_Stress (const PMI_Environment& env) :
  PMI_Stress (env)
{ xx = InitParameter ("xx", 100);
  yy = InitParameter ("yy", -4e9);
  zz = InitParameter ("zz", 300);
  yz = InitParameter ("yz", 400);
  xz = InitParameter ("xz", 500);
  xy = InitParameter ("xy", 600);
}

Constant_Stress::
~Constant_Stress ()
{
}

void Constant_Stress::
```

39: Physical Model Interface

Traps and Fixed Charges

```cpp
Compute_StressXX (double& stress_xx)
{ stress_xx = xx;
}

void Constant_Stress::
Compute_StressYY (double& stress_yy)
{ stress_yy = yy;
}

void Constant_Stress::
Compute_StressZZ (double& stress_zz)
{ stress_zz = zz;
}

void Constant_Stress::
Compute_StressYZ (double& stress_yz)
{ stress_yz = yz;
}

void Constant_Stress::
Compute_StressXZ (double& stress_xz)
{ stress_xz = xz;
}

void Constant_Stress::
Compute_StressXY (double& stress_xy)
{ stress_xy = xy;
}

extern "C"
PMI_Stress* new_PMI_Stress (const PMI_Environment& env)
{ return new Constant_Stress (env);
}
```

# Traps and Fixed Charges

This section presents the following PMIs:

* Trap Capture and Emission Rates

* Trap Energy Shift

Traps and Fixed Charges

# Trap Capture and Emission Rates

This PMI model can be used to define either capture and emission rates for traps (see $c_C^n$, $c_V^p$, $e_C^n$, and $e_V^p$ in Trap Occupation Dynamics on page 499) or the transitions between states of multistate configurations (see Specifying Multistate Configurations on page 529). The model is an arbitrary function of $n$, $p$, $T$, $T_n$, $T_p$, and $F$.

## Traps

In the command file, specify the model with the `CBRate` and `VBRate` options to `Traps`.

For example:

```
Traps((CBRate=("modelX",17) VBRate="modelY") ... )
```

uses the user-specified model `modelX` to compute $c_C^n$ and $e_C^n$ (see Local Capture and Emission Rates on page 501), and `modelY` to compute $c_V^p$ and $e_V^p$. The 17 is passed as the second argument to the virtual constructor for `modelX`; `modelY` is passed as a default value of 0 instead. The interpretation of these integers is left to the user-specified models. They allow you to select among different parameters or model variants, without having to reimplement the full model for each different choice of parameters or each minor model variation.

## Multistate Configurations

The present model is used for transitions of multistate configurations by the keyword `CEModel` (see Specifying Multistate Configurations on page 529). For example:

```
MSConfig { ...
  Transition ( Name="t1" To = "c" From="a" CEModel ("modelX" 5) )
}
```

where 5 is the optional model index parameter that defaults to 0.

## Dependencies

The capture and emission rates can depend on the variables:

| n | Electron density [ cm–3 ] |
| --- | --- |
| p | Hole density [ cm–3 ] |
| t | Lattice temperature [ K ] |
| tn | Electron temperature [ K ] |

39: Physical Model Interface
Traps and Fixed Charges

tp Hole temperature [ K ]

f Electric field [ Vcm<sup>–1</sup> ]

The PMI model must compute the following results (note that the carrier type that is captured and emitted is determined by the band to which the model is applied):

capture Capture rate [ s<sup>–1</sup> ]

emission Emission rate [ s<sup>–1</sup> ]

In the case of the standard interface, the following derivatives must be computed as well:

dcapturedn Derivative of capture rate with respect to n [ s<sup>–1</sup>cm<sup>3</sup> ]
demissiondn Derivative of emission rate with respect to n [ s<sup>–1</sup>cm<sup>3</sup> ]
dcapturedp Derivative of capture rate with respect to p [ s<sup>–1</sup>cm<sup>3</sup> ]
demissiondp Derivative of emission rate with respect to p [ s<sup>–1</sup>cm<sup>3</sup> ]
dcapturedt Derivative of capture rate with respect to t [ s<sup>–1</sup>K<sup>–1</sup> ]
demissiondt Derivative of emission rate with respect to t [ s<sup>–1</sup>K<sup>–1</sup> ]
dcapturedtn Derivative of capture rate with respect to tn [ s<sup>–1</sup>K<sup>–1</sup> ]
demissiondtn Derivative of emission rate with respect to tn [ s<sup>–1</sup>K<sup>–1</sup> ]
dcapturedtp Derivative of capture rate with respect to tp [ s<sup>–1</sup>K<sup>–1</sup> ]

demissiondtp Derivative of emission rate with respect to tp [ s<sup>–1</sup>K<sup>–1</sup> ]

dcapturedf Derivative of capture rate with respect to f [ s<sup>–1</sup>V<sup>–1</sup>cm ]
demissiondf Derivative of emission rate with respect to f [ s<sup>–1</sup>V<sup>–1</sup>cm ]

## Standard C++ Interface

The following base class is declared in `PMIModels.h`:

```cpp
class PMI_TrapCaptureEmission : public PMI_Vertex_Interface {
public:
  PMI_TrapCaptureEmission(const PMI_Environment& env);
  virtual ~PMI_TrapCaptureEmission();

  virtual void Compute_rates
    (const double n, const double p, const double t,
```

Traps and Fixed Charges

```cpp
      const double tn, const double tp, const double f,
      double& capture, double& emission) = 0;

  virtual void Compute_dratesdn
      (const double n, const double p, const double t,
      const double tn, const double tp, const double f,
      double& dcapturedn, double& demissiondn) = 0;

  virtual void Compute_dratesdp
      (const double n, const double p, const double t,
      const double tn, const double tp, const double f,
      double& dcapturedp, double& demissiondp) = 0;

  virtual void Compute_dratesdt
      (const double n, const double p, const double t,
      const double tn, const double tp, const double f,
      double& dcapturedt, double& demissiondt) = 0;

  virtual void Compute_dratesdtn
      (const double n, const double p, const double t,
      const double tn, const double tp, const double f,
      double& dcapturedtn, double& demissiondtn) = 0;

  virtual void Compute_dratesdtp
      (const double n, const double p, const double t,
      const double tn, const double tp, const double f,
      double& dcapturedtp, double& demissiondtp) = 0;

  virtual void Compute_dratesdf
      (const double n, const double p, const double t,
      const double tn, const double tp, const double f,
      double& dcapturedf, double& demissiondf) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_TrapCaptureEmission* new_PMI_TrapCaptureEmission_func
    (const PMI_Environment& env, int id);
extern "C" new_PMI_TrapCaptureEmission_func new_PMI_TrapCaptureEmission;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_TrapCaptureEmission_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
```

39: Physical Model Interface

Traps and Fixed Charges

```cpp
    public:
      pmi_float n;     // electron density
      pmi_float p;     // hole density
      pmi_float t;     // lattice temperature
      pmi_float tn;    // electron temperature
      pmi_float tp;    // hole temperature
      pmi_float f;     // absolute value of electric field
      pmi_float nc;    // lattice effective state density for electrons
      pmi_float nv;    // lattice effective state density for holes
      pmi_float egeff; // effective band gap
    };

    class Output {
    public:
      pmi_float capture;  // capture rate
      pmi_float emission; // emission rate
    };

    PMI_TrapCaptureEmission_Base (const PMI_Environment& env);
    virtual ~PMI_TrapCaptureEmission_Base ();

    virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_TrapCaptureEmission_Base* new_PMI_TrapCaptureEmission_Base_func
   (const PMI_Environment& env, int id);
extern "C" new_PMI_TrapCaptureEmission_Base_func
   new_PMI_TrapCaptureEmission_Base;
```

## Example: Arrhenius Law

The model has the structure of the Arrhenius law. It depends on the temperature.

Table 186 Model parameters

| Symbol | Parameter name | Default | Unit | Description |
| --- | --- | --- | --- | --- |
| δE | DeltaE | 0. | eV | Energy difference |
| g | g | 1. | 1 | Degeneracy factor |
| r0 | r0 | 1. | s–1 | Maximal transition rate |
| Eact | Eact | 0. | eV | Activation energy |

Traps and Fixed Charges

Let $\delta E$ and $E_{\text{act}}$ be the energy difference and activation energy. The capture and emission rates are given by:

$$ c = r_0 \exp(-E_{\text{act}} / kT) $$ (1335)

$$ e = r_0 g \exp(-(E_{\text{act}} + \delta E) / kT) $$ (1336)

The model is shipped with Sentaurus Device. A more flexible and general way to specify Arrhenius law transitions is provided by the transition model `pmi_ce_msc` (see Arrhenius Law (Formula=0) on page 533).

## Trap Energy Shift

The present PMI determines a shift $E_{\text{shift}}$ of trap energies that depends on the electric field and the lattice temperature at the location of the vertex or at a position given with `ReferencePoint` (see Energetic and Spatial Distribution of Traps on page 490).

## Command File

The energy shift model is specified by `EnergyShift=<model name>` or `EnergyShift=(<model name>, <int>)` as an option to `Traps` in the `Physics` section. The optional integer defaults to zero and is passed as the argument `id` to the virtual constructor of the PMI (see below). The interpretation of `id` is dependent on the user-specified model.

## Dependencies

The trap energy shift can depend on the variables:

* **f**: Electric field vector [ Vcm<sup>-1</sup> ], a vector with up to three components, for the field in the x-, y-, and z-direction

* **t**: Lattice temperature [ K ]

The PMI model must compute the following results:

* **shift**: Energy shift [ eV ]

39: Physical Model Interface
Traps and Fixed Charges

In the case of the standard interface, the following derivatives must be computed as well:

`dshiftdf` Derivative of energy shift with respect to each component of f [ eVcmV<sup>-1</sup> ], a vector with up to three entries

`dshiftdt` Derivative of energy shift with respect to t [ eVK<sup>-1</sup> ]

## Standard C++ Interface

The following base class is declared in PMIModels.h:

```cpp
class PMI_TrapEnergyShift : public PMI_Vertex_Interface {

public:
  PMI_TrapEnergyShift(const PMI_Environment& env);
  virtual ~PMI_TrapEnergyShift();

  virtual void Compute_shift(
    const double f[3], const double t, double& shift) = 0;
  virtual void Compute_dshiftdf(
    const double f[3], const double t, double df[3]) = 0;
  virtual void Compute_dshiftdt(
    const double f[3], const double t, double& dt) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_TrapEnergyShift* new_PMI_TrapEnergyShift_func
  (const PMI_Environment& env, int id);
extern "C" new_PMI_TrapEnergyShift_func new_PMI_TrapEnergyShift;
```

## Simplified C++ Interface

The following base class is declared in the file PMI.h:

```cpp
class PMI_TrapEnergyShift_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float f[3]; // electric field vector
    pmi_float t;   // lattice temperature
  };

  class Output {
  public:
    pmi_float shift; // trap energy shift
```

Degradation

```cpp
  };

  PMI_TrapEnergyShift_Base (const PMI_Environment& env);
  virtual ~PMI_TrapEnergyShift_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_TrapEnergyShift_Base* new_PMI_TrapEnergyShift_Base_func
  (const PMI_Environment& env, int id);
extern "C" new_PMI_TrapEnergyShift_Base_func new_PMI_TrapEnergyShift_Base;
```

# Degradation

This section presents the following PMIs:

*   Diffusivity

*   eNMP Transition Rates

## Diffusivity

The diffusivity $D_i \exp(-E_{di} / (kT))$ and the prefactor of the thermal diffusion term $\alpha_{td}$ can be defined by a PMI (see Hydrogen Transport on page 555).

The name of the PMI can be specified regionwise, materialwise, or globally in the `Physics` section of the command file as follows:

```
Physics ( Material = "Oxide" ) {
  HydrogenDiffusion(
    HydrogenAtom (
      Diffusivity = pmi_model
      Alpha = pmi_otherModel
    )
    ...
  )
}
```

39: Physical Model Interface

Degradation

## Dependencies

The diffusivity and the prefactor of the thermal diffusion term can depend on the following variables:

f Modulus of electric field [ Vcm<sup>–1</sup> ]

h Density of hydrogen species (atom, molecule, ion) [ cm<sup>–3</sup> ]

t Lattice temperature [K]

The PMI model must compute the following result:

d Diffusivity $D_i \exp(-E_{di} / (kT))$ [ cm<sup>2</sup>s<sup>–1</sup> ] (PMI model for `Diffusivity`) or prefactor of thermal diffusion term $\alpha_{td}$ [1] (PMI model for `Alpha`)

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_HydrogenDiffusivity_Base : public PMI_Vertex_Base {
public:
  const PMI_HydrogenType hydrogen_type;
  class Input : public PMI_Vertex_Input_Base {
  public:
    Input (const PMI_HydrogenDiffusivity_Base* hydrogendiffusivity_base,
           const int vertex);
    pmi_float h; // density of hydrogen atoms, molecules, or ions
                 // (depending on type) [/cm^3]
    pmi_float t; // lattice temperature [K]
    pmi_float f; // absolute value of electric field [V/cm]
  };

  class Output {
  public:
    pmi_float d; // diffusivity [cm^2*s^-1] or prefactor of the thermal
                 // diffusion term [1]
  };

  PMI_HydrogenDiffusivity_Base (const PMI_Environment& env, const
    PMI_HydrogenType type);
  virtual ~PMI_HydrogenDiffusivity_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
}
```

Degradation

The following virtual constructor must be implemented:

```cpp
extern "C"
PMI_HydrogenDiffusivity_Base* new_PMI_HydrogenDiffusivity_Base
(const PMI_Environment& env, const PMI_HydrogenType type);
```

## Example: Field-Dependent Hydrogen Diffusivity

The following C++ code implements a field-dependent hydrogen diffusivity:

```cpp
#include "PMIModels.h"

class pmi_HydrogenDiffusivity : public PMI_HydrogenDiffusivity_Base {
  private:
    double d0; // [cm^2*s^-1]
    double f0; // [eV]
    double fe; // [1]
    double ed; // [eV]

  public:
    pmi_HydrogenDiffusivity (const PMI_Environment& env,
    const PMI_HydrogenType type);
    ~pmi_HydrogenDiffusivity ();

    void compute (const Input& input, Output& output);
};

pmi_HydrogenDiffusivity::
pmi_HydrogenDiffusivity (const PMI_Environment& env,
  const PMI_HydrogenType type) :
PMI_HydrogenDiffusivity_Base (env, type)
{
  // for hydrogen atom
  double d0_a = InitParameter ("d0_a", 1.0e-5);
  double f0_a = InitParameter ("f0_a", 1.0e-5);
  double fe_a = InitParameter ("fe_a", 0.5);
  double ed_a = InitParameter ("ed_a", 0.5);

  // for hydrogen molecule
  double d0_m = InitParameter ("d0_m", 1.0e-5);
  double f0_m = InitParameter ("f0_m", 1.0e-5);
  double fe_m = InitParameter ("fe_m", 0.5);
  double ed_m = InitParameter ("ed_m", 0.5);

  // for hydrogen ion
  double d0_i = InitParameter ("d0_i", 1.0e-5);
  double f0_i = InitParameter ("f0_i", 1.0e-5);
  double fe_i = InitParameter ("fe_i", 0.5);
  double ed_i = InitParameter ("ed_i", 0.5);
```

39: Physical Model Interface

Degradation

```cpp
  if (hydrogen_type == PMI_HydrogenAtom)
  {
    d0 = d0_a;
    f0 = f0_a;
    fe = fe_a;
    ed = ed_a;
  }
  else if(hydrogen_type == PMI_HydrogenMolecule)
  {
    d0 = d0_m;
    f0 = f0_m;
    fe = fe_m;
    ed = ed_m;
  }
  else if(hydrogen_type == PMI_HydrogenIon)
  {
    d0 = d0_i;
    f0 = f0_i;
    fe = fe_i;
    ed = ed_i;
  }
  else
  {
    std::cout << "unexpected hydrogen type!\n";
    exit(-1);
  }
}
pmi_HydrogenDiffusivity::
~pmi_HydrogenDiffusivity ()
{
}

void pmi_HydrogenDiffusivity::
compute (const Input& input, Output& output)
{
  pmi_float kt = 0.0258519952664849131 * (input.t/300.0); // [eV]
  // field-induced activation energy lowering
  pmi_float ea = ed - f0*pow(input.f, fe); // ed - f0*(f/(1[V/cm])^fe

  // set activation energy equal to zero if it is negative
  if(ea<0.0) ea = 0.0;
  ea /= kt;

  output.d = d0*exp(-ea);
}

extern "C"
```

Degradation

```cpp
PMI_HydrogenDiffusivity_Base* new_PMI_HydrogenDiffusivity_Base
(const PMI_Environment& env, const PMI_HydrogenType type)
{
 return new pmi_HydrogenDiffusivity (env, type);
}
```

## eNMP Transition Rates

Transition rates used in the extended nonradiative multiphonon (eNMP) model can be computed by an eNMP transition rates PMI model. The computed transition rates are used in the solution of the eNMP model rate equations (see eNMP Model Description on page 569).

To use a PMI for calculating the transition rates, specify the PMI model name as an option to `eNMP` in the `Physics` section of the command file:

```
Physics (MaterialInterface | RegionInterface = "<name1>/<name2>") {
  eNMP (
    pmi_model_name [StateCharge=<1 or -1>] ...
  )
}
```

The eNMP model requires the calculation of eight transition rates occurring between four states. For the built-in eNMP model, the metastable states are designated with primes (that is, 1' and 2'). To simplify the naming of the transition rates for the PMI, the following definitions are made:

* state 3 = state 1'
* state 4 = state 2'

In addition, when a PMI model is used to calculate the transition rates, the sign of the charge states can be specified with the `StateCharge` parameter in the command file. By default, the charge states are assumed to be positive (`StateCharge` > 0). To designate that the charge states are negative, specify `StateCharge` < 0.

With these definitions, the transition rates that must be calculated by the PMI model are shown in Figure 96 on page 1367.

39: Physical Model Interface
Degradation

State diagram for the eNMP transition rates PMI

Figure 96 State diagram for the eNMP transition rates PMI

## Distinction Between Electron and Hole Transitions

For transitions involving a change in charge ($1 \leftrightarrow 4$ and $2 \leftrightarrow 3$), the PMI requires a distinction between transitions that involve holes (hole capture and hole emission) and electrons (electron capture and electron emission). This distinction is necessary so that Sentaurus Device correctly accounts for changes in carrier recombination when the eNMP model is used.

The component of a transition rate involving holes is designated with an "h" suffix, and an "e" suffix designates the electron component:

$$ k_{14} = k_{14h} + k_{14e} \text{ (1337)} $$

$$ k_{41} = k_{41h} + k_{41e} \text{ (1338)} $$

$$ k_{23} = k_{23h} + k_{23e} \text{ (1339)} $$

$$ k_{32} = k_{32h} + k_{32e} \text{ (1340)} $$

The transition rate components have the meanings shown in Table 187 depending on StateCharge.

Table 187 Definition of eNMP transition rate depending on StateCharge

| Rates | StateCharge > 0 | StateCharge < 0 |
| --- | --- | --- |
| k14h , k32h | Hole capture | Hole emission |
| k14e , k32e | Electron emission | Electron capture |
| k41h , k23h | Hole emission | Hole capture |
| k41e , k23e | Electron capture | Electron emission |

Degradation

It is not required to compute both electron and hole transition components in the PMI. For example, the built-in eNMP model includes only hole transitions, and electron transitions are ignored.

## Transition Rates for All Sample Defects

Since the eNMP model uses a random sampling technique to obtain the average behavior of multiple defects, the eNMP transition rates PMI model must calculate transition rates for all of the sample defects at each vertex. For this purpose, the following parameters are passed automatically to the eNMP transition rates PMI and can be accessed using the runtime support function `InitParameter()`:

```cpp
NumberOfSamples = InitParameter("NumberOfSamples", 1000);
NumberOfVertices = InitParameter("NumberOfVertices", 1);
```

The `NumberOfSamples` keyword represents the value specified in the eNMP section of the command file. The `NumberOfVertices` keyword represents the number of interface vertices at the interface where the eNMP model is being used.

## Parameter Randomization

Since transition rates must be obtained for all of the sample defects, it is likely that some model parameters will need to be randomized (either using a uniform distribution or a Gaussian distribution). In this case, the randomized parameter values should be obtained and stored in the constructor of the eNMP transition rates PMI for all `NumberOfSamples` defects *and* for all `NumberOfVertices` interface vertices. Therefore, a total of `NumberOfSamples` $\times$ `NumberOfVertices` values should be obtained for each parameter to be randomized. The requirement to obtain randomized parameter values for all interface vertices in the PMI constructor is to ensure that each vertex uses *different* `NumberOfSamples` values for each randomized parameter.

The eNMP transition rates PMI includes two member functions to assist in randomizing parameter values:

*   `double UnifRanNum(int &idum)` – returns a random number between 0 and 1, exclusive of the endpoints.

*   `double GausRanNum(int &idum)` – returns a random number that follows a normal distribution with zero mean and unit variance.

These functions must be initialized with `idum < 0` and, thereafter, `idum` must not be changed during the sequence. For example, the following code fragment shows how two parameters can be randomized and stored for later use:

```cpp
std::vector<double> Eti;
std::vector<double> xti;
```

Degradation

```cpp
...
NumberOfSamples = InitParameter("NumberOfSamples", 1000);
NumberOfVertices = InitParameter("NumberOfVertices", 1);
double Et0    = InitParameter("Et", -0.5);
double Etsig = InitParameter("Etsig", 0.1);
double xtmin = InitParameter("xtmin", 0.0);
double xtmax = InitParameter("xtmax", 0.0);
...
int idum = -1;
for (int i = 0; i < NumberOfSamples*NumberOfVertices; ++i) {
     double Et = Et0 + Etsig*GausRanNum(idum);
     double xt = xtmin + (xtmax - xtmin)*UnifRanNum(idum);
     ...
     Eti.push_back(Et);
     xti.push_back(xt);
     ...
}
```

## Dependencies

The eNMP transition rates PMI can depend on the interface values of the following variables:

* **n**: Electron density [ cm<sup>−3</sup> ]
* **p**: Hole density [ cm<sup>−3</sup> ]
* **Nc**: Conduction band density-of-states [ cm<sup>−3</sup> ]
* **Nv**: Valence band density-of-states [ cm<sup>−3</sup> ]
* **Eg**: Band gap [eV]
* **T**: Lattice temperature [K]
* **F**: Magnitude of insulator electric field [ V cm<sup>−1</sup> ]

The PMI model must compute the following results:

* k[0]<sub>i</sub> = (k<sub>14h</sub>)<sub>i</sub> Hole component of transition rates from state 1 to state 4 [ s<sup>−1</sup> ]
* k[1]<sub>i</sub> = (k<sub>14e</sub>)<sub>i</sub> Electron component of transition rates from state 1 to state 4 [ s<sup>−1</sup> ]
* k[2]<sub>i</sub> = (k<sub>41h</sub>)<sub>i</sub> Hole component of transition rates from state 4 to state 1 [ s<sup>−1</sup> ]
* k[3]<sub>i</sub> = (k<sub>41e</sub>)<sub>i</sub> Electron component of transition rates from state 4 to state 1 [ s<sup>−1</sup> ]
* k[4]<sub>i</sub> = (k<sub>23h</sub>)<sub>i</sub> Hole component of transition rates from state 2 to state 3 [ s<sup>−1</sup> ]

Degradation

$k[5]_i = (k_{23e})_i$ Electron component of transition rates from state 2 to state 3 $[s^{-1}]$

$k[6]_i = (k_{32h})_i$ Hole component of transition rates from state 3 to state 2 $[s^{-1}]$

$k[7]_i = (k_{32e})_i$ Electron component of transition rates from state 3 to state 2 $[s^{-1}]$

$k[8]_i = (k_{13})_i$ Transition rates from state 1 to state 3 $[s^{-1}]$

$k[9]_i = (k_{31})_i$ Transition rates from state 3 to state 1 $[s^{-1}]$

$k[10]_i = (k_{24})_i$ Transition rates from state 2 to state 4 $[s^{-1}]$

$k[11]_i = (k_{42})_i$ Transition rates from state 4 to state 2 $[s^{-1}]$

**NOTE** The subscript $i$ in the above transition rates is shorthand that indicates that the transition rate must be computed for all `NumberOfSamples` sample defects at the interface vertex. For example:

$$k[0]_i \rightarrow k[0]_0, k[0]_1, k[0]_2, ..., k[0]_{\text{NumberOfSamples} - 1} \text{ (1341)}$$

In the case of the standard PMI interface, the following derivatives must also be computed:

`dkdn[0]`$_i$, `dkdn[1]`$_i$, ..., `dkdn[11]`$_i$ Derivatives of all transition rates with respect to n $[cm^3 s^{-1}]$

`dkdp[0]`$_i$, `dkdp[1]`$_i$, ..., `dkdp[11]`$_i$ Derivatives of all transition rates with respect to p $[cm^3 s^{-1}]$

`dkdNc[0]`$_i$, `dkdNc[1]`$_i$, ..., `dkdNc[11]`$_i$ Derivatives of all transition rates with respect to Nc $[cm^3 s^{-1}]$

`dkdNv[0]`$_i$, `dkdNv[1]`$_i$, ..., `dkdNv[11]`$_i$ Derivatives of all transition rates with respect to Nv $[cm^3 s^{-1}]$

`dkdEg[0]`$_i$, `dkdEg[1]`$_i$, ..., `dkdEg[11]`$_i$ Derivatives of all transition rates with respect to Eg $[eV^{-1} s^{-1}]$

`dkdT[0]`$_i$, `dkdT[1]`$_i$, ..., `dkdT[11]`$_i$ Derivatives of all transition rates with respect to T $[K^{-1} s^{-1}]$

`dkdF[0]`$_i$, `dkdF[1]`$_i$, ..., `dkdF[11]`$_i$ Derivatives of all transition rates with respect to F $[cm V^{-1} s^{-1}]$

**NOTE** Similar to the transition rates, the subscript $i$ in the above derivatives is shorthand that indicates that the derivatives must be computed for all `NumberOfSamples` sample defects at the interface vertex. For example:

$$\text{dkdn}[0]_i \rightarrow \text{dkdn}[0]_0, \text{dkdn}[0]_1, \text{dkdn}[0]_2, ..., \text{dkdn}[0]_{\text{NumberOfSamples} - 1} \text{ (1342)}$$

The derivative array indices correspond to the array indices for the transition rates. For example:

$$\text{dkdn}[0]_i = \frac{d(k_{14h})_i}{dn}, \text{dkdn}[1]_i = \frac{d(k_{14e})_i}{dn}, ... \text{ (1343)}$$

39: Physical Model Interface
Degradation

# Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_eNMPTransitionRates : public PMI_Vertex_Interface {

public:
    class Input {
    public:
        double n;      // electron density
        double p;      // hole density
        double Nc;     // conduction-band effective density-of-states
        double Nv;     // valence-band effective density-of-states
        double Eg;     // bandgap
        double T;      // lattice temperature
        double F;      // insulator electric field
        int vindex;    // vertex index (0 <= vindex <= NumberOfVertices - 1)
    };

    class Output {
    public:
        std::vector<double> k[12];      // transition rates
        std::vector<double> dkdn[12];   // derivatives wrt electron density
        std::vector<double> dkdp[12];   // derivatives wrt hole density
        std::vector<double> dkdNc[12];  // derivatives wrt to conduction band DOS
        std::vector<double> dkdNv[12];  // derivatives wrt to valence band DOS
        std::vector<double> dkdEg[12];  // derivatives wrt bandgap
        std::vector<double> dkdT[12];   // derivatives wrt lattice temperature
        std::vector<double> dkdF[12];   // derivatives wrt insulator electric
        field
    };

    PMI_eNMPTransitionRates (const PMI_Environment& env);

    virtual ~PMI_eNMPTransitionRates ();

    // method to be implemented by user
    virtual void compute(const Input& input, Output& output) = 0;

    // random number generators
    double UnifRanNum (int &idum);
    double GausRanNum (int &idum);
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_eNMPTransitionRates*
    new_PMI_eNMPTransitionRates_func (const PMI_Environment& env);
extern "C" new_PMI_eNMPTransitionRates_func new_PMI_eNMPTransitionRates;
```

Degradation

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
 class PMI_eNMPTransitionRates_Base : public PMI_Vertex_Base {

 public:
   class Input : public PMI_Vertex_Input_Base {
   public:
     Input (const PMI_eNMPTransitionRates_Base* enmprates_base, const int
     vertex);
     pmi_float n;  // electron density
     pmi_float p;  // hole density
     pmi_float Nc; // conduction-band effective density-of-states
     pmi_float Nv; // valence-band effective density-of-states
     pmi_float Eg; // bandgap
     pmi_float T;  // lattice temperature
     pmi_float F;  // insulator electric field
     int vindex;   // vertex index (0 ≤ vindex ≤ NumberOfVertices - 1)
   };

   class Output {
   public:
     std::vector<pmi_float> k[12]; // transition rates
   };

   PMI_eNMPTransitionRates_Base (const PMI_Environment& env);

   virtual ~PMI_eNMPTransitionRates_Base ();

   virtual void compute(const Input& input, Output& output) = 0;

   // random number generators
   double UnifRanNum (int &idum);
   double GausRanNum (int &idum);
 };
```

The prototype for the virtual constructor is given as:

```cpp
 typedef PMI_eNMPTransitionRates_Base*
   new_PMI_eNMPTransitionRates_Base_func
     (const PMI_Environment& env);
 extern "C" new_PMI_eNMPTransitionRates_Base_func
   new_PMI_eNMPTransitionRates_Base;
```

39: Physical Model Interface
Degradation

# Example: eNMP Model Transition Rates

This example illustrates the implementation of the eNMP model transition rates using the standard C++ interface:

```cpp
#include "PMI.h"
#include <cmath>
#include <vector>

// Implementation of transitions rates for the eNMP model.

class eNMPRates : public PMI_eNMPTransitionRates {

protected:
    int NumberOfSamples, NumberOfVertices;
    double Xsec, Vth, x0, nu0;
    std::vector<double> Eti;
    std::vector<double> Etpi;
    std::vector<double> Ri;
    std::vector<double> Rpi;
    std::vector<double> ESi; Model
    std::vector<double> ESpi;
    std::vector<double> ET2pi;
    std::vector<double> Elpli;
    std::vector<double> E2p2i;
    std::vector<double> xti;

public:
    eNMPRates (const PMI_Environment& env);
    ~eNMPRates ();
    void compute (const Input& input, Output& output);
};

eNMPRates::
eNMPRates (const PMI_Environment& env) : PMI_eNMPTransitionRates (env)
{
    NumberOfSamples = InitParameter ("NumberOfSamples", 1000); // 1
    NumberOfVertices = InitParameter ("NumberOfVertices", 1); // 1
    Xsec = InitParameter ("Xsec", 1.0e-15); // cm^2
    Vth  = InitParameter ("Vth" , 1.2e+07); // cm/s
    x0   = InitParameter ("x0"  ,      0.5); // A
    nu0  = InitParameter ("nu0" , 1.0e+13); // s^-1

    double Et0   = InitParameter ("Et"  , -0.5); // eV
    double Etp0  = InitParameter ("Etp" ,  0.5); // eV
    double R0    = InitParameter ("R"   ,  0.6); // 1
    double Rp0   = InitParameter ("Rp"  ,  0.6); // 1
    double ES0   = InitParameter ("ES"  ,  1.0); // eV
```

1373

Degradation

```cpp
    double ESp0   = InitParameter ("ESp"  , 1.0); // eV
    double ET2p0  = InitParameter ("ET2p" , 0.5); // eV
    double E1p10  = InitParameter ("E1p1" , 1.0); // eV
    double E2p20  = InitParameter ("E2p2" , 0.5); // eV
    double xtmin  = InitParameter ("xtmin", 0.0); // A

    double Etsig   = InitParameter ("Etsig" , 0.1); // eV
    double Etpsig  = InitParameter ("Etpsig", 0.1); // eV
    double Rsig    = InitParameter ("Rsig"  , 0.1); // 1
    double Rpsig   = InitParameter ("Rpsig" , 0.1); // 1
    double ESsig   = InitParameter ("ESsig" , 0.1); // eV
    double ESpsig  = InitParameter ("ESpsig", 0.1); // eV
    double ET2psig = InitParameter ("ET2psig", 0.1); // eV
    double E1p1sig = InitParameter ("E1p1sig", 0.1); // eV
    double E2p2sig = InitParameter ("E2p2sig", 0.1); // eV
    double xtmax   = InitParameter ("xtmax" , 0.0); // A

    int idum = -1;
    for (int i = 0; i < NumberOfSamples*NumberOfVertices; ++i) {
      double Et   = Et0   + Etsig  *GausRanNum(idum);
      double Etp  = Etp0  + Etpsig *GausRanNum(idum);
      double R    = R0    + Rsig   *GausRanNum(idum);
      double Rp   = Rp0   + Rpsig  *GausRanNum(idum);
      double ES   = ES0   + ESsig  *GausRanNum(idum);
      double ESp  = ESp0  + ESpsig *GausRanNum(idum);
      double ET2p = ET2p0 + ET2psig*GausRanNum(idum);
      double E1p1 = E1p10 + E1p1sig*GausRanNum(idum);
      double E2p2 = E2p20 + E2p2sig*GausRanNum(idum);
      double xt = xtmin + (xtmax - xtmin)*UnifRanNum(idum);
      if (R    < 1.0e-10) R   = 1.0e-10;
      if (Rp   < 1.0e-10) Rp  = 1.0e-10;
      if (ES   < 1.0e-10) ES  = 1.0e-10;
      if (ESp  < 1.0e-10) ESp = 1.0e-10;
      Eti.push_back(Et);
      Etpi.push_back(Etp);
      Ri.push_back(R);
      Rpi.push_back(Rp);
      ESi.push_back(ES);
      ESpi.push_back(ESp);
      ET2pi.push_back(ET2p);
      E1p1i.push_back(E1p1);
      E2p2i.push_back(E2p2);
      xti.push_back(xt);
    }
  }

eNMPRates::
~eNMPRates ()
```

39: Physical Model Interface

Degradation

```cpp
{
}

void eNMPRates::
compute (const Input& input, Output& output)
{
  // Compute NBTI transition rates .
  // The order of transition rates and derivatives are:
  // k14h, k14e, k41h, k41e (k14 = k14h + k14e; k41 = k41h + k41e)
  // k23h, k23e, k32h, k32e (k23 = k23h + k23e; k32 = k32h + k32e)
  // k13, k31, k24, k42

  // Get the input variables.
  const double n  = input.n;  // cm^-3
  const double p  = input.p;  // cm^-3
  const double Nc = input.Nc; // cm^-3
  const double Nv = input.Nv; // cm^-3
  const double Eg = input.Eg; // // eV
  const double T  = input.T;  // // K
  const double F  = input.F;  // // V/cm (this is always |F|)
  const double kT = 8.617331e-5*T;  // kT in eV
  const int vindex = input.vindex;

  // Initialize the output variables.
  for (int i = 0; i < 12; ++i) {
    output.k[i].resize(NumberOfSamples, 0.0);
    output.dkdn[i].resize(NumberOfSamples, 0.0);
    output.dkdp[i].resize(NumberOfSamples, 0.0);
    output.dkdNc[i].resize(NumberOfSamples, 0.0);
    output.dkdNv[i].resize(NumberOfSamples, 0.0);
    output.dkdEg[i].resize(NumberOfSamples, 0.0);
    output.dkdT[i].resize(NumberOfSamples, 0.0);
    output.dkdF[i].resize(NumberOfSamples, 0.0);
  }

  // Calculate the rates for each sample.
  for (int is = 0; is < NumberOfSamples; ++is) {
    int ii = is + vindex*NumberOfSamples;
    const double Et = Eti[ii];
    const double Etp = Etpi[ii];
    const double R = Ri[ii];
    const double Rp = Rpi[ii];
    const double ES = ESi[ii];
    const double ESp = ESpi[ii];
    const double ET2p = ET2pi[ii];
    const double E1p1 = E1p1i[ii];
    const double E2p2 = E2p2i[ii];
    const double xt = xti[ii];
```

Degradation

```cpp
const double sigma = Xsec * exp(-xt/x0);
const double xtcm = xt*1.0e-8;
const double R1p1 = R  + 1.0;
const double R3p1 = Rp + 1.0;
const double R1fac = R1p1*sqrt(R1p1)*sigma*Vth;
const double R3fac = R3p1*sqrt(R3p1)*sigma*Vth;

// Trap energies relative to valence band.
const double Etv  = Et  + xtcm * F;
const double Etpv = Etp + xtcm * F;

// Get transition energies and derivatives.
const double E14 = (ES/R1p1 - R*(Etv - ET2p))/R1p1;
const double E41 = E14 + Etv - ET2p;
const double E32 = (ESp/R3p1 - Rp*Etpv)/R3p1;
const double E23 = E32 + Etpv;
const double dE14dF = -R/R1p1*xtcm;
const double dE41dF = dE14dF + xtcm;
const double dE32dF = -Rp/R3p1*xtcm;
const double dE23dF = dE32dF + xtcm;
const double E13 = E1p1 + Etp - Et;
const double E31 = E1p1;
const double E24 = E2p2 + ET2p;
const double E42 = E2p2;

// Get transition rates and derivatives.
const double k14 = R1fac*p*exp(-E14/kT);
const double dk14dp = k14/p;
const double dk14dT = k14*(E14/kT)/T;
const double dk14dF = k14*(-dE14dF/kT);
const double k41 = R1fac*Nv*exp(-E41/kT);
const double dk41dNv = k41/Nv;
const double dk41dT = k41*(E41/kT)/T;
const double dk41dF = k41*(-dE41dF/kT);
const double k23 = R3fac*Nv*exp(-E23/kT);
const double dk23dNv = k23/Nv;
const double dk23dT = k23*(E23/kT)/T;
const double dk23dF = k23*(-dE23dF/kT);
const double k32 = R3fac*p*exp(-E32/kT);
const double dk32dp = k32/p;
const double dk32dT = k32*(E32/kT)/T;
const double dk32dF = k32*(-dE32dF/kT);
const double k13 = nu0*exp(-E13/kT);
const double dk13dT = k13*(E13/kT)/T;
const double k31 = nu0*exp(-E31/kT);
const double dk31dT = k31*(E31/kT)/T;
const double k24 = nu0*exp(-E24/kT);
const double dk24dT = k24*(E24/kT)/T;
```

**39: Physical Model Interface**

Ferroelectrics and Ferromagnetics

```cpp
      const double k42 = nu0*exp(-E42/kT);
      const double dk42dT = k42*(E42/kT)/T;

      // Fill the output variables.
      output.k[0][is]=k14;
      output.dkdp[0][is]=dk14dp;
      output.dkdT[0][is]=dk14dT;
      output.dkdF[0][is]=dk14dF;
      output.k[2][is]=k41;
      output.dkdNv[2][is]=dk41dNv;
      output.dkdT[2][is]=dk41dT;
      output.dkdF[2][is]=dk41dF;
      output.k[4][is]=k23;
      output.dkdNv[4][is]=dk23dNv;
      output.dkdT[4][is]=dk23dT;
      output.dkdF[4][is]=dk23dF;
      output.k[6][is]=k32;
      output.dkdp[6][is]=dk32dp;
      output.dkdT[6][is]=dk32dT;
      output.dkdF[6][is]=dk32dF;
      output.k[8][is]=k13;
      output.dkdT[8][is]=dk13dT;
      output.k[9][is]=k31;
      output.dkdT[9][is]=dk31dT;
      output.k[10][is]=k24;
      output.dkdT[10][is]=dk24dT;
      output.k[11][is]=k42;
      output.dkdT[11][is]=dk42dT;
     }
    }

    extern "C"
    PMI_eNMPTransitionRates*
     new_PMI_eNMPTransitionRates (const PMI_Environment& env)
    { return new eNMPRates (env);
    }
```

# Ferroelectrics and Ferromagnetics

This section presents the following PMIs:

*   Ferroelectrics Hysteresis

*   Ferroelectrics

*   Ferromagnetism and Spin Transport

Ferroelectrics and Ferromagnetics

## Ferroelectrics Hysteresis

The ferroelectrics model, introduced in Ferroelectrics Model on page 858, can be extended by defining the auxiliary polarization, $P_{\text{aux}}$ in Eq. 943, p. 858, as a general algebraic function of the auxiliary electric field $F_{\text{aux}}$:

$$ P_{\text{aux}} = c \cdot P_s \cdot f(F_{\text{aux}} \pm F_c) + P_{\text{off}} \qquad (1344) $$

where $P_s$ is the saturation polarization of the material, $F_c$ is the coercive field, and the function $f$ serves as the shape function of the hysteresis. The PMI in Sentaurus Device allows you to redefine the calculation of $f$. $P_{\text{off}}$ and $c$ in Eq. 1344 result from the polarization history of the material (see the discussion in Ferroelectrics Model on page 858). This PMI also provides access to the relaxation times for the auxiliary field $\tau_E$ (see Eq. 942, p. 858) and for the polarization $\tau_P$ (see Eq. 945, p. 858), used in transient simulations.

In the command file, the name of the ferroelectrics model is given as an argument to the `Polarization` keyword. The following example activates the ferroelectric model `pmi_model_name` in region "R.Ferro":

```
Physics (Region="R.Ferro") {
   Polarization(pmi_model_name)
}
```

The materialwise specification of PMI models is also possible.

## Dependencies

A PMI ferroelectric hysteresis model can depend on the variable:

f      Component of electric field vector [ Vcm<sup>–1</sup> ]

It can be used to compute the following results:

shapE    Polarization shape function $f$ [1]

tauE    Relaxation time for the auxiliary field $\tau_E$ [s]

tauP    Relaxation time for the polarization $\tau_P$ [s]

Ferroelectrics and Ferromagnetics

Besides the calculation of the model output values, the following partial derivatives with respect to the input electric field variable f must be computed as well:

`dshapEdf` Derivative of $f$ with respect to f [ V<sup>-1</sup> cm ]
`dtauEdf` Derivative of $\tau_E$ with respect to f [ sV<sup>-1</sup> cm ]
`dtauPdf` Derivative of $\tau_P$ with respect to f [ sV<sup>-1</sup> cm ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_FerroPolarization : public PMI_Vertex_Common_Base {
public:
 PMI_FerroPolarization (const PMI_Environment& env); virtual
 ~PMI_FerroPolarization ();

 double ReadPolarizationParameter(char const* name, int i);

 virtual bool Use_shapE() { return false; }

 virtual void Compute_shapE
 (const int i,   const double f,            double& shapE);
 virtual void Compute_dshapEdf
 (const int i,   const double f,            double& dshapEdf);
 virtual bool Use_tauE() { return false; }

 virtual void Compute_tauE
 (const int i,   const double f,            double& tauE);
 virtual void Compute_dtauEdf
 (const int i,   const double f,            double& dtauEdf);
 virtual bool Use_tauP() { return false; }

 virtual void Compute_tauP
 (const int i,   const double f,            double& tauP);
 virtual void Compute_dtauPdf
 (const int i,   const double f,            double& dtauPdf);};
```

The prototype for the virtual constructor is:

```cpp
typedef PMI_FerroPolarization* new_PMI_FerroPolarization_func
 (const PMI_Environment& env);Extern "C" new new_PMI_FerroPolarization_func
 new_PMI_FerroPolarization
```

By default, functions computing the results of a PMI ferroelectric hysteresis model and its derivatives are not invoked. To force Sentaurus Device to use the result computed with the

Ferroelectrics and Ferromagnetics

`Compute_result` method, a designated `Use_result` function in the PMI must return `true`. In this case, a corresponding function `Compute_dresultdf` calculating the partial derivative of the result with respect to the electric field variable `f` is also used and must be implemented.

During a Newton iteration, Sentaurus Device computes the PMI model results and derivatives, which are declared as used for each mesh element. The functions `Compute_result` and `Compute_dresultdf` are evaluated along the main axes of the mesh coordinate system as indicated by the input argument `i`. This integer variable can take values from 0 to $d$, where $d$ is equal to the dimension of the problem. The input variable `f` is the component of the electric field vector along the $i$-th axis of the mesh. The output variables are used to evaluate a PMI model along the corresponding axis.

## Ferroelectrics

Higher order terms of polarization can be included through the PMI interface, which solves the following equation:

$$LK2 = \sum_{i} a_i P^i$$ (1345)

where $P$ is the polarization, $i$ is the power, and $a_i$ is the corresponding coefficient. Eq. 1345 is added to the built-in Ginzburg–Landau–Khalatnikov equation, Eq. 948, p. 861.

You set `PMIModel` in the `FEPolarization` statement to activate the PMI as follows:

```
Physics (Region="FE1") {
  FEPolarization (
    direction="x" PMIModel=FE_pmi(power=(7,9,13...) coeff=(a7,a9,a13...))
  )
}
```

The input parameters are two vectors:

* The `power` vector contains the powers that are used.

* The `coeff` are the corresponding coefficients for those powers as defined in Eq. 1345.

> **NOTE** This PMI feature can be used only with the default version of the solver (see Default on page 865).

The following is an example of the PMI:

```cpp
#include <vector>
#include <assert.h>
#include "PMI.h"

class FE_pmi: public PMI_FEPolarization_Base {
```

39: Physical Model Interface
Ferroelectrics and Ferromagnetics

```cpp
    private:
      // user parameters
      std::vector<double > power, coeff;

    public:
      FE_pmi(const PMI_Environment& env);
      ~FE_pmi();
      void compute(const Input& input, Output& output);
    };

    FE_pmi::FE_pmi(const PMI_Environment& env):PMI_FEPolarization_Base(env) {
      InitParameter ("power", power);
      InitParameter ("coeff", coeff);
    }

    FE_pmi::~FE_pmi() {
      power.clear();
      coeff.clear();
    }

    void FE_pmi::compute(const Input& input, Output& output) {
      const pmi_float& p = input.p;
      pmi_float lk=0.;
      assert(power.size()==coeff.size());
      if(power.size()>0) {
        for(size_t i=0;i<power.size(); ++i) {
          lk += coeff[i]*pow(p,power[i]);
        }
      }
      output.LKPol = lk;
    }

    extern "C" PMI_FEPolarization_Base* new_PMI_FEPolarization_Base(
      const PMI_Environment& env) {
      return new FE_pmi(env);
    }
```

# Ferromagnetism and Spin Transport

The following PMI models for ferromagnetism and spin transport are supported:

*   User-Defined Interlayer Exchange Coupling

*   User-Defined Bulk or Interface Contributions to the Effective Magnetic Field

*   User-Defined Magnetostatic Potential Calculation

Ferroelectrics and Ferromagnetics

All PMI models for ferromagnetism and spin transport are based on the simplified C++ interface.

## User-Defined Interlayer Exchange Coupling

Interfaces of ferromagnetic regions separated by thin paramagnetic layers lead to an interlayer coupling energy density $U_{\text{interlayer}}$ [[5]]([5]). As usual, the derivative of this energy density with respect to the local magnetization contributes to the effective magnetic field of the LLG equation. In contrast to Eq. 955, p. 876, $U_{\text{interlayer}}$ in this case is a surface energy density, not a volume energy density. The resulting effective magnetic field contribution has units of A rather than A/m; with the observation that (J/T)/m<sup>2</sup> = A, this is seen to correspond simply to a surface density of magnetic dipoles.

The theory of interlayer exchange is well developed (for example, [[6]]([6])). It explains why interlayer exchange oscillates between ferromagnetic and anti-ferromagnetic behavior as a function of the paramagnetic spacer thickness, and it establishes a clear link between oscillation periods present in this thickness dependency and *critical spanning vectors* of the Fermi surface of the spacer material. Despite this, the quantitative prediction of the interaction remains difficult even in ideal thin film stacks. Structural non-idealities (such as surface roughness) can cause additional complexity such as the emergence of bi-quadratic terms in the coupling energy, which favor orthogonal alignment of the magnetization directions in the ferromagnetic regions. Therefore, the most appropriate functional form for describing the coupling strength might depend on the particular use case. For this reason, it was decided to provide a generic infrastructure for assembling interlayer exchange contributions into the LLG equation, but to leave the choice of the particular expression to assemble on the *interlayer exchange edges* to users.

## Syntax of Command File and Parameter File

An interlayer exchange PMI is activated for a particular interface by adding the following line to the corresponding interface `Physics` section of the command file:

```
Magnetism(InterlayerExchange(PMImodel=<name>))
```

If the PMI model uses named model parameters (for example, by calling `InitParameter()`), then the parameters are read from the interface-specific section of the parameter file.

## Base Class for Interlayer Exchange PMIs

PMI models for the interlayer exchange terms of the LLG equation are derived from the base class `PMI_LLGInterlayerExchange_Base`, which has the following definition:

```cpp
//! Base-class for interlayer exchange terms the LLG equation
class PMI_LLGInterlayerExchange_Base : public PMI_Device_Base {
public:
```

39: Physical Model Interface

Ferroelectrics and Ferromagnetics

```cpp
class Input : public PMI_Device_Input_Base {
public:
    //! Constructor
    Input(const PMI_Device_Base*);
    pmi_float m_loc[3]; ///< magnetization dir. at the local end of the edge
    pmi_float m_rem[3]; ///< magnetization dir. at the remote end of the edge
    pmi_float length;   ///< the length of the interlayer exchange edge [m]
};
class Output {
public:
    Output(const PMI_Device_Base *base);

    //! Derivative of surface energy density w.r.t. to local magnetization
    pmi_float dU_by_dmloc[3];
};

PMI_LLGInterlayerExchange_Base (const PMI_Device_Environment& env);
virtual ~PMI_LLGInterlayerExchange_Base ();
virtual void compute (const Input& input, Output& output) = 0;
};
```

The PMI implementer must provide the function:

`compute(const Input& input, Output& output)`

Here, `compute()` is called once for each interlayer exchange edge, and the `input` object contains the magnetization directions at the local and remote ends of the edge (as Cartesian unit vectors) as well as the layer thickness (in meter).

The function writes the gradient of the interlayer-exchange energy density with respect to the local magnetization direction into the `dU_by_dmloc` field of the output object (unit: J/m<sup>2</sup>).

## Example: ILE Model With a Simple Oscillatory Thickness Dependency

This model implements an interlayer exchange (ILE) surface energy density of the form $U_{\text{interlayer}} = J_1(t) \vec{m}_{\text{loc}} \cdot \vec{m}_{\text{rem}}$.

For the thickness-dependent coupling strength $J_1(t)$, a phase-shifted sine function with a $t^{-2}$ envelope is assumed:

$$J_1(t) = J_0 \sin \left( \frac{2\pi t}{\Lambda} + \delta \right) / t^2 \tag{1346}$$

Here, $t$ (in Å) is the spacer thickness, and $\Lambda$ (in Å) is the oscillation period. Instead of the rather inconvenient parameters $J_0$ and $\delta$, users are expected to supply the coupling strength $J_{\text{max}}$ (in mJ/m<sup>2</sup>) at the first anti-ferromagnetic peak of $J_1(t)$ and the thickness $t_{\text{max}}$ (in Å) at which this maximum occurs.

Ferroelectrics and Ferromagnetics

## Implementation of the Simple Interlayer Exchange PMI

To implement the simple interlayer exchange PMI model, you must declare a derived class:

```cpp
#include "PMI.h"
#include <cmath>

class InterlayerExchange_sinD_over_D2 : public PMI_LLGInterlayerExchange_Base
{
public:
  InterlayerExchange_sinD_over_D2(const PMI_Device_Environment &env);
  void compute(const Input &input, Output &output);

  // Auxiliary function for thickness dependence of coupling strength
  inline pmi_float func(const pmi_float &x, const pmi_float &shift) {
    return sin(x + shift) / (x * x);
  }
private:
  double Jmax;       ///< Coupling strength at first AF peak [mJ/m^2]
  double tmax;       ///< Position of first peak [Aangstroem]
  double Lambda;     ///< Period of oscillation [Aangstroem]
  pmi_float delta;   ///< Phase shift to move first AF peak to tmax
  pmi_float scale;   ///< Scaling factor to scale first AF peak to Jmax
};
```

The constructor of the derived class reads the model parameters from the `.par` file and determines the phase shift and the prefactor in $J_1(t)$ from $J_{\text{max}}$ and $t_{\text{max}}$.

```cpp
InterlayerExchange_sinD_over_D2::
InterlayerExchange_sinD_over_D2(const PMI_Device_Environment &env)
: PMI_LLGInterlayerExchange_Base(env)
{
  Jmax   = InitParameter("Jmax", 0.0);   // unit: [mJ/m^2]
  Lambda = InitParameter("Lambda", 0.0); // unit: [Aangstroem]
  tmax   = InitParameter("tmax", 0.0);   // unit: [Aangstroem]

  // adjust delta and scale to position the first peak at (tmax, Jmax)
  pmi_float tmax_scaled = tmax * 2 * M_PI / Lambda;
  delta = M_PI - tmax_scaled + atan(0.5 * tmax_scaled);
  scale = 1.0 / func(tmax_scaled, delta);
}
```

The `compute()` function computes $\vec{\nabla}_{m_{\text{loc}}} U_{\text{interlayer}} = J_1(t) \vec{m}_{\text{rem}}$ for a single interlayer exchange edge (note the unit conversion factors):

```cpp
compute(const Input &input, Output &output) {
  pmi_float scaled_distance = 1e10 * input.length * 2*M_PI / Lambda;
  pmi_float f = -1e-3 * scale * Jmax * func(scaled_distance, delta);
  output.dU_by_dmloc[0] = f * input.m_rem[0];
```

Ferroelectrics and Ferromagnetics

```cpp
      output.dU_by_dmloc[1] = f * input.m_rem[1];
      output.dU_by_dmloc[2] = f * input.m_rem[2];
     }
```

Finally, you must provide a so-called virtual constructor function that allocates a variable of the new class:

```cpp
     extern "C"
     PMI_LLGInterlayerExchange_Base*
     new_PMI_LLGInterlayerExchange_Base(const PMI_Device_Environment& env) {
      return new InterlayerExchange_sinD_over_D2(env);
     }
```

**NOTE** This function must have C linkage and exactly the same name as declared in the `PMI.h` header file.

If `Magnetism(InterlayerExchange)` is specified in the `.cmd` file without providing a PMI model name, then Sentaurus Device loads an implementation of the above model as the default ILE model. For the purpose of reading parameters from the `.par` file, the model name `InterlayerExchange` is used.

# User-Defined Bulk or Interface Contributions to the Effective Magnetic Field

The base class `PMI_LLGHeff_Base` has been provided for assembling extra generic contributions to the effective magnetic field in bulk regions (unit: A/m) or on interfaces (unit: A).

## Syntax of Command File and Parameter File

PMIs for generic bulk or interface $\vec{H}_{\text{eff}}$ contributions are activated by adding the following line to the corresponding region or interface `Physics` sections of the command file:

```
LLG(HEff("<name1>" ["<name2>" ...]))
```

Contributions from all selected models are added during assembly.

Model parameters (if any) are taken from the appropriate region-specific or interface-specific sections of the `.par` file.

Ferroelectrics and Ferromagnetics

## Base Class for Generic Bulk or Interface for Effective Magnetic Field PMIs

PMI models for generic bulk or interface $\vec{H}_{\text{eff}}$ contributions are derived from the base class `PMI_LLGHeff_Base`:

```cpp
//! Base-class for local contributions to H_eff in the LLG equation
class PMI_LLGHeff_Base : public PMI_Device_Base {
public:
  class Input : public PMI_Device_Input_Base {
  public:
    //! Constructor
    Input(const PMI_Device_Base*);
    //! Location types for PMI_LLGHeff_Base
    enum locT {
      UNDEFINED_LOCATION, ///< Nothing (only used as initial value)
      DOMAIN_INTERFACE,   ///< Subset of a mesh interface (METIS domain)
      MESH_INTERFACE,     ///< Full mesh interface
      DOMAIN_BULK,        ///< Subset of a mesh bulk region (METIS domain)
      BULK                ///< Full mesh bulk region
    };
    locT locationType;    ///< Specifies how to interpret the vertex list
    int interfaceIndex;   ///< Mesh interface index (or -1 if called for bulk)

    //! Bulk region index; valid both during bulk and interface assembly.
    /**
     * For interface terms, this can be used to distinguish between
     * interior and exterior normal vectors: if \a regionIndex is equal to
     * region1 of the mesh interface, the vector returned by
     * ReadAveragedNormalVectorAtInterfaceVertex points away from region
     * \a regionIndex; otherwise it points into region \a regionIndex.
     */
    int regionIndex;

    //! \a vertexList is only used for DOMAIN_INTERFACE and DOMAIN_BULK
    /**
     * \a locationType determines how bulk vertex indices for assembly are
     * obtained:
     *
     * DOMAIN_INTERFACE:
     *   Mesh()->regioninterface((interfaceIndex)
     *     ->vertex([vertexList[i]])->index()
     *   i = 0, ..., vertexList->size()-1
     * MESH_INTERFACE:
     *   Mesh()->regioninterface(interfaceIndex)->vertex(i)->index()
     *   i = 0, ..., Mesh()->regioninterface(locationIndex)->size_vertex()-1
     * DOMAIN_BULK:
     *   Mesh()->region(locationIndex)->vertex(vertexList[i])->index()
     *   i = 0, ..., vertexList->size()-1
```

39: Physical Model Interface

Ferroelectrics and Ferromagnetics

```cpp
        * BULK:
        *     Mesh()->region(locationIndex)->vertex(i)->index()
        *     i = 0, ..., Mesh()->region(locationIndex)->size_vertex()-1
        */
        const std::vector<int> *vertexList;
}; //end of class PMI_LLGHeffBase::Input

class Output {
public:
        Output(const PMI_Device_Base *base);
        sdevice_pmi_float_vector Hx; // x-component of Heff at each vertex
        sdevice_pmi_float_vector Hy; // y-component of Heff at each vertex
        sdevice_pmi_float_vector Hz; // z-component of Heff at each vertex
};

PMI_LLGHeff_Base (const PMI_Device_Environment& env);
virtual ~PMI_LLGHeff_Base ();
virtual void compute (const Input& input, Output& output) = 0;

//! Get averaged normal vector for interface vertex
/**
 * @param[in] i - interface index
 * @param[in] v - interface vertex index on \a i
 * @returns pointer to the coordinates of the normal vector
 */
const double *
        ReadAveragedNormalVectorAtInterfaceVertex(int i, int v);
//! Read SaturationMagnetization for region ri
double ReadSaturationMagnetization(int ri);
};
```

The PMI implementer must provide the function:

`compute(const Input& input, Output& output)`

This function is called once per parallel (bulk or interface) domain of the device, and the `compute()` function is expected to provide values for the Hx, Hy, and Hz fields of the output object at each global vertex in the current domain.

## Example: Exchange Bias

Typical anisotropy models do not distinguish between $\vec{m}$ and $-\vec{m}$. Interfaces between ferromagnetic and anti-ferromagnetic layers, however, might break the symmetry between parallel and anti-parallel alignment of the magnetization directions on either side of the interface.

Ferroelectrics and Ferromagnetics

This effect is known as *exchange bias*, which can be described by an interface contribution to $\vec{H}_{\text{eff}}$ of the form $I_{\text{bias}} \vec{d}_{\text{bias}}$, where:

*   $I_{\text{bias}}$ (`I_bias` in the `.par` file) describes the strength of the exchange bias (unit: A, corresponding to an interface density of magnetic dipoles as discussed above).

*   $\vec{d}_{\text{bias}}$ (`biasDir` in the `.par` file) is the bias direction.

Positive values of $I_{\text{bias}}$ correspond to the case that favors alignment of the magnetization at the surface of the ferromagnetic layer parallel to $\vec{d}_{\text{bias}}$.

## Implementation of the Exchange Bias PMI

To implement the exchange bias model, you must declare a derived class:

```cpp
#include <PMI.h>
#include <cmath>
class PMI_ExchangeBias : public PMI_LLGHeff_Base {
public:
   PMI_ExchangeBias(const PMI_Device_Environment& env);
   void computeForInterfaceVertex(int ii, int ivi,
                                   PMI_LLGHeff_Base::Output &out);
   void compute(const PMI_LLGHeff_Base::Input &in,
               PMI_LLGHeff_Base::Output &out);
private:
   std::vector<double> biasDir; ///< direction of the bias field (normalized)
   double Ibias; ///< J/T / m^2 = A (surface density of magnetic dipoles)
};
```

The constructor of the derived class reads the model parameters from the `.par` file:

```cpp
PMI_ExchangeBias::PMI_ExchangeBias(const PMI_Device_Environment& env)
: PMI_LLGHeff_Base(env), biasDir(3)
{
   Ibias = InitParameter("I_bias", 0.0);
   InitParameter("biasDir", biasDir);
   if (biasDir.size() != 3) {
       printf("PMI model ExchangeBias --- biasDir must be a 3D vector!\n");
       exit(1);
   }
   // convert biasDir to unit vector
   double length = std::sqrt(biasDir[0] * biasDir[0] +
                                   biasDir[1] * biasDir[1] +
                                   biasDir[2] * biasDir[2]);
   if (length == 0) {
       printf("PMI model ExchangeBias --- "
               "biasDir must be a non-zero 3D vector!\n");
       exit(1);
   }
```

39: Physical Model Interface

Ferroelectrics and Ferromagnetics

```cpp
          biasDir[0] /= length;
          biasDir[1] /= length;
          biasDir[2] /= length;
     }
```

During model evaluation, Sentaurus Device calls the `compute()` function. Exchange bias is an interface effect. Therefore, `in.locationType` must refer to an interface; other location types are rejected:

```cpp
void PMI_ExchangeBias::compute(const PMI_LLGHeff_Base::Input &in,
                               PMI_LLGHeff_Base::Output &out)
{
    switch(in.locationType) {
    case PMI_LLGHeff_Base::Input::DOMAIN_INTERFACE:
      if (!in.vertexList) {
        printf("PMI_ExchangeBias on DOMAIN_INTERFACE needs a vertexList!\n");
        exit(1);
      }
      for (int i = 0; i < in.vertexList->size(); i++) {
        computeForInterfaceVertex(in.interfaceIndex, (*in.vertexList)[i], out);
      }
      break;
    case PMI_LLGHeff_Base::Input::MESH_INTERFACE:
      {
        size_t n = Mesh()->regioninterface(in.interfaceIndex)->size_vertex();
        for (size_t i = 0; i < n; i++) {
             computeForInterfaceVertex(in.interfaceIndex, i, out);
        }
      }
      break;
    default:
      printf("PMI_ExchangeBias does not support locationType=%d\n",
             in.locationType);
      exit(1);
    }
}
```

The calculation for each selected interface vertex is performed by the function `computeForInterfaceVertex(ii, vi, &out)`, where `ii` denotes the index of the current mesh interface, and `vi` is the vertex index relative to this interface. The `out` object provides storage for the resulting effective magnetic field:

```cpp
void PMI_ExchangeBias::computeForInterfaceVertex(int ii, int ivi,
                                                 PMI_LLGHeff_Base::Output &out)
{
     const des_mesh *mesh = Mesh();
     const des_regioninterface* interface = Mesh()->regioninterface(ii);
     size_t bulk_vi = interface->vertex(ivi)->index();
```

Ferroelectrics and Ferromagnetics

```cpp
        // Unit of surface effective magnetic field: A (not A/m as in bulk)
        out.Hx[bulk_vi] = Ibias * biasDir[0];
        out.Hy[bulk_vi] = Ibias * biasDir[1];
        out.Hz[bulk_vi] = Ibias * biasDir[2];
    }
```

Finally, you must provide a so-called virtual constructor function, which allocates a variable of the new class:

```cpp
extern "C"
PMI_LLGHeff_Base* new_PMI_LLGHeff_Base(const PMI_Device_Environment& env) {
    return new PMI_ExchangeBias(env);
}
```

**NOTE** This function must have C linkage and exactly the same name as declared in the `PMI.h` header file.

This model is included in the installation of Sentaurus Device under the PMI model name ExchangeBias, which corresponds to the C++ file name ExchangeBias.C.

**Example: Interface Anisotropy**

Frequently, an interface between a ferromagnetic material and adjacent materials gives rise to a contribution to the energy density of the magnetic system that favors perpendicular alignment of the magnetization over in-plane alignment. The interface anisotropy model describes this effect in terms of a surface energy density proportional to the square of the scalar product of the magnetization direction $\vec{m}$ and the surface normal direction $\vec{n}$. The resulting effective magnetic field contribution takes the form $-I_{aniso}\vec{n}(\vec{n} \cdot \vec{m})$ (unit: A, corresponding to an interface density of magnetic dipoles as discussed above). Positive values of $I_{aniso}$ favor an out-of-plane magnetization direction; negative values favor in-plane magnetization.

The interface anisotropy model can describe the transition from in-plane magnetic alignment in magnetic thin films of moderate thickness to perpendicular magnetic alignment in very thin films. For positive $I_{aniso}$ (`I_aniso` in the `.par` file, unit: A), there is competition between an effective bulk anisotropy term due to the geometry, which favors in-plane magnetic alignment, and the interface anisotropy, which favors out-of-plane alignment. With decreasing film thickness, the relative importance of the interface term grows. For very thin films, the interface term dominates, resulting in perpendicular magnetic alignment.

**Implementation of the Interface Anisotropy PMI**

Like the exchange bias model, the interface anisotropy model is derived from `PMI_LLGHeff_Base`:

```cpp
#include <PMI.h>
#include <cmath>
```

39: Physical Model Interface

Ferroelectrics and Ferromagnetics

```cpp
class PMI_InterfaceAnisotropy : public PMI_LLGHeff_Base {
public:
  PMI_InterfaceAnisotropy(const PMI_Device_Environment& env);
  void computeForInterfaceVertex(int ii, int ivi,
                                 PMI_LLGHeff_Base::Output &out);
  void compute(const PMI_LLGHeff_Base::Input &in,
               PMI_LLGHeff_Base::Output &out);
private:
  double I_aniso;      ///< J/T/m^2 = A (surface density of magnetic dipoles)
  const pmi_float* mx; ///< x-component of magnetization direction
  const pmi_float* my; ///< y-component of magnetization direction
  const pmi_float* mz; ///< z-component of magnetization direction
};
```

Again, the constructor reads the model parameter:

```cpp
PMI_InterfaceAnisotropy::
PMI_InterfaceAnisotropy(const PMI_Device_Environment& env)
: PMI_LLGHeff_Base(env)
{ I_aniso = InitParameter("I_aniso", 0.0); }
```

For the most part, the compute() function of the interface anisotropy model is identical to that of the exchange bias model. However, there is one important difference: The effective field of the interface anisotropy model depends on the magnetization density.

Therefore, the compute() function of PMI_InterfaceAnisotropy must read the magnetization data:

```cpp
void PMI_InterfaceAnisotropy::compute(const PMI_LLGHeff_Base::Input &in,
                                      PMI_LLGHeff_Base::Output &out)
{
  sdevice_data *data = Data();
  mx = data->ReadScalar(sdevice_data::vertex, "MagnetizationDir_x");
  my = data->ReadScalar(sdevice_data::vertex, "MagnetizationDir_y");
  mz = data->ReadScalar(sdevice_data::vertex, "MagnetizationDir_z");
  switch(in.locationType) {
    ... THE REST OF THE FUNCTION AS IN PMI_ExchangeBias ...
  }
}
```

The computeForInterfaceVertex() function handles the calculation of the scalar product between the surface normal vector and the magnetization direction. Note how the components of the magnetization vector m[] are set from the mx, my, and mz components. This provides the correct (local) derivatives of the effective field contribution to the LLG equation:

```cpp
void
PMI_InterfaceAnisotropy::
```

Ferroelectrics and Ferromagnetics

```cpp
computeForInterfaceVertex(int ii, int ivi, PMI_LLGHeff_Base::Output &out)
{
  const des_mesh *mesh = Mesh();
  const des_regioninterface* interface = Mesh()->regioninterface(ii);
  size_t bulk_vi = interface->vertex(ivi)->index();
  const double *n = ReadAveragedNormalVectorAtInterfaceVertex(ii, ivi);

  pmi_float m[3];
  m[0] = pmi_float(mx[bulk_vi].get_value<double>(), 3, 0);
  m[1] = pmi_float(my[bulk_vi].get_value<double>(), 3, 1);
  m[2] = pmi_float(mz[bulk_vi].get_value<double>(), 3, 2);

  pmi_float dot_prod = n[0] * m[0] + n[1] * m[1] + n[2] * m[2];

  // Unit of surface effective magnetic field: A (not A/m as in bulk)
  out.Hx[bulk_vi] = -I_aniso * dot_prod * n[0];
  out.Hy[bulk_vi] = -I_aniso * dot_prod * n[1];
  out.Hz[bulk_vi] = -I_aniso * dot_prod * n[2];
}
```

The implementation is completed by the definition of the virtual constructor:

```cpp
extern "C"
PMI_LLGHeff_Base* new_PMI_LLGHeff_Base(const PMI_Device_Environment& env) {
  return new PMI_InterfaceAnisotropy(env);
}
```

**NOTE** This model is included in the installation of Sentaurus Device under the PMI model name `InterfaceAnisotropy`.

## Example: Local Demagnetizing Field

This model implements a local expression for the demagnetizing field in terms of a diagonal demagnetizing tensor $\underline{\text{N}} = \text{diag}(N_x, N_y, N_z) : \vec{H}_{\text{eff, demag}} = -\underline{\text{N}}\vec{M} = -M_{\text{sat}}\underline{\text{N}}\vec{m}$.

## Implementation of the Local Demagnetizing Field PMI

The model is derived from the base class `PMI_LLGHeff_Base`:

```cpp
#include <PMI.h>
class LocalDemagnetizingField : public PMI_LLGHeff_Base {
public:
  LocalDemagnetizingField(const PMI_Device_Environment& env);
  void computeForBulkVertex(int ri, int vi, PMI_LLGHeff_Base::Output &out);
  void compute(const PMI_LLGHeff_Base::Input &in,
               PMI_LLGHeff_Base::Output &out);
private:
  const pmi_float* mx; ///< x-component of magnetization direction
```

Ferroelectrics and Ferromagnetics

```cpp
  const pmi_float* my; ///< y-component of magnetization direction
  const pmi_float* mz; ///< z-component of magnetization direction
  double Nx; /// demagnetizing factor along x-axis
  double Ny; /// demagnetizing factor along y-axis
  double Nz; /// demagnetizing factor along z-axis
};
```

As usual, the constructor of the derived class reads the model parameters from the .par file:

```cpp
LocalDemagnetizingField::
LocalDemagnetizingField(const PMI_Device_Environment& env)
: PMI_LLGHeff_Base(env)
{
  Nx = InitParameter("Nx", 0.0);
  Ny = InitParameter("Ny", 0.0);
  Nz = InitParameter("Nz", 0.0);
}
```

In contrast to the exchange bias model and the interface anisotropy model, the local demagnetizing field model implements a bulk contribution to the effective magnetic field. Consequently, the `compute()` function now requires `in.locationType` to refer to a bulk region or domain:

```cpp
void LocalDemagnetizingField::compute(const PMI_LLGHeff_Base::Input &in,
                                      PMI_LLGHeff_Base::Output &out)
{
  // Get magnetization direction
  sdevice_data *data = Data();
  mx = data->ReadScalar(sdevice_data::vertex, "MagnetizationDir_x");
  my = data->ReadScalar(sdevice_data::vertex, "MagnetizationDir_y");
  mz = data->ReadScalar(sdevice_data::vertex, "MagnetizationDir_z");

  switch(in.locationType) {
  case PMI_LLGHeff_Base::Input::DOMAIN_BULK:
    if (!in.vertexList) {
      printf("LocalDemagnetizingField on DOMAIN_BULK needs a vertexList!\n");
      exit(1);
    }
    for (size_t i = 0; i < (*in.vertexList).size(); i++) {
      computeForBulkVertex(in.regionIndex, (*in.vertexList)[i], out);
    }
    break;
  default:
    printf("LocalDemagnetizingField does not support locationType=%d\n",
           in.locationType);
    exit(1);
  }
}
```

Ferroelectrics and Ferromagnetics

The evaluation of the effective magnetic field contribution at each bulk node is handled by the `computeForBulkVertex(ri, vi, &out)` function. The argument `ri` is the region index, and the argument `vi` is the global vertex index of the evaluation point. The region index is needed to query the saturation magnetization:

```cpp
void
LocalDemagnetizingField::computeForBulkVertex(int ri, int vi,
                                                     PMI_LLGHeff_Base::Output &out)
{
 pmi_float m[3];
 m[0] = pmi_float(mx[vi].get_value<double>(), 3, 0);
 m[1] = pmi_float(my[vi].get_value<double>(), 3, 1);
 m[2] = pmi_float(mz[vi].get_value<double>(), 3, 2);

 double Msat = ReadSaturationMagnetization(ri);

 // Effective magnetic field A/m
 out.Hx[vi] = -Nx * Msat * m[0];
 out.Hy[vi] = -Ny * Msat * m[1];
 out.Hz[vi] = -Nz * Msat * m[2];
}
```

Finally, the virtual constructor must be defined:

```cpp
extern "C"
PMI_LLGHeff_Base* new_PMI_LLGHeff_Base(const PMI_Device_Environment& env) {
 return new LocalDemagnetizingField(env);
}
```

**NOTE** This model is included in the installation of Sentaurus Device under the PMI model name `LocalDemagnetizingField`.

# User-Defined Magnetostatic Potential Calculation

For the special case of an effective magnetic field contribution that can be written as the gradient of a magnetostatic potential, $\vec{H}_{\text{longitudinal}} = -\vec{\nabla}\varphi_{\text{max}}$, you can reuse the base class `PMI_LLGHeff_Base` to calculate a magnetostatic potential instead of a magnetic field (see Base Class for Generic Bulk or Interface for Effective Magnetic Field PMIs on page 1386).

In this mode of operation, the `compute()` function does not populate the fields of the `output` object with magnetic field values. Instead, it prepares an array containing the magnetostatic potential for each vertex (unit: $\mu\text{m} \cdot \text{A/m}$) and uses this to set the value of the `MagnetostaticPotential` field by calling the `sdevice_data::WriteScalar()` function.

39: Physical Model Interface

Electrical Resistivity

The resulting magnetostatic potential and the corresponding magnetic field can be plotted like other fields in Sentaurus Device:

```
Plot {
  MagnetostaticPotential
  LongitudinalMagneticField/Element/Vector
}
```

**Syntax of Command File and Parameter File**

This special mode is activated by adding the following statement to the global `Physics` section of the command file:

```
Magnetism(MagnetostaticPotentialPMI=<name>)
```

Parameters (if any) are read from the global section of the `.par` file, and the `locationType` in the `input` object is set to zero. Instead of being called in parallel for each parallel domain of the device, for the magnetostatic potential calculation, there is only one global call for the entire device. User-defined parallelization, for example, using OpenMP, can be used to accelerate this call.

# Electrical Resistivity

This section presents the following PMIs:

*   Metal Resistivity

*   Schottky Resistance

## Metal Resistivity

The metal resistivity $\rho = 1/\sigma$ can be defined by a PMI (see Transport in Metals on page 249).

The name of the PMI must be specified in the `Physics` section of the command file as follows:

```
Physics { MetalResistivity (pmi_model) }
```

The simplified interface PMI_MetalResistivity_Base supports the diffusion-reaction species interface (see Reaction–Diffusion Species Interface (Compute Scope) on page 1201 on page 1201)).

Electrical Resistivity

## Dependencies

The metal resistivity depends on the variables:

*   `t` Lattice temperature [K]
*   `f` Absolute value of the electric field [ Vcm<sup>–1</sup> ]

The PMI model must compute the following result:

*   `Resist` Metal resistivity [ $\Omega$ cm ]

In the case of the standard interface, the following derivatives must be computed as well:

*   `dResistdt` Derivative of `Resist` with respect to t [ $\Omega$ K<sup>–1</sup> cm ]
*   `dResistdf` Derivative of `Resist` with respect to f [ $\Omega$ V<sup>–1</sup> cm<sup>2</sup> ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class MetalResistivity : public PMI_MetalResistivity {

public:
  MetalResistivity (const PMI_Environment& env);
  virtual ~MetalResistivity ();

  virtual void Compute_Resist
    (const double t,    // lattice temperature
    const double f,     // absolute value of electric field
    double& Resist);    // metal resistivity

  virtual void Compute_dResistdt
    (const double t,    // lattice temperature
    const double f,     // absolute value of electric field
    double& dResistdt); // derivative of metal resistivity
                        // with respect to lattice temperature

  virtual void Compute_dResistdf
    (const double t,    // lattice temperature
    const double f,     // absolute value of electric field
    double& dResistdf); // derivative of metal resistivity
                        // with respect to electric field
};
```

39: Physical Model Interface

Electrical Resistivity

The following virtual constructor must be implemented:

```cpp
typedef PMI_MetalResistivity* new_PMI_MetalResistivity_func
  (const PMI_Environment& env);
extern "C" new_PMI_MetalResistivity_func new_PMI_MetalResistivity;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_MetalResistivity_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t;     // lattice temperature
    pmi_float f;     // absolute value of the electric field
  };

  class Output {
  public:
    pmi_float Resist; // metal resistivity
  };

  PMI_MetalResistivity_Base (const PMI_Environment& env);
  virtual ~PMI_MetalResistivity_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
extern "C"
PMI_MetalResistivity_Base* new_PMI_MetalResistivity_Base
  (const PMI_Environment& env);
```

## Example: Linear Metal Resistivity

The following C++ code implements linear metal resistivity:

```cpp
#include "PMIModels.h"

class MetalResistivity : public PMI_MetalResistivity
{
  private:
    double R0, AlphaT;

  public:
```

Electrical Resistivity

```cpp
    MetalResistivity (const PMI_Environment& env);
    ~MetalResistivity ();

    void Compute_Resist
        (const double t,     // lattice temperature
        const double f,      // absolute value of electric field
        double& Resist);     // metal resistivity

    void Compute_dResistdt
        (const double t,     // lattice temperature
        const double f,      // absolute value of electric field
        double& dResistdt); // derivative of metal resistivity
                             // with respect to lattice temperature

    void Compute_dResistdf
        (const double t,     // lattice temperature
        const double f,      // absolute value of electric field
        double& dResistdf); // derivative of metal resistivity
                             // with respect to electric field
};

MetalResistivity::
MetalResistivity (const PMI_Environment& env) :
  PMI_MetalResistivity (env)
{ // Gold values
  R0     = InitParameter ("R0",     2.0400e-06); // [ohm*cm]
  AlphaT = InitParameter ("AlphaT", 4.0000e-03); // [1/K]
}

MetalResistivity::
~MetalResistivity ()
{}

void MetalResistivity::
Compute_Resist (const double t, const double f, double& Resist)
{
  Resist = R0*( 1 + AlphaT*( t - 273 ) );
}

void MetalResistivity::
Compute_dResistdt (const double t, const double f, double& dResistdt)
{
  dResistdt = R0*AlphaT;
}

void MetalResistivity::
Compute_dResistdf (const double t, const double f, double& dResistdf)
{
```

39: Physical Model Interface

Electrical Resistivity

```cpp
    dResistdf = 0;
}

extern "C"
PMI_MetalResistivity* new_PMI_MetalResistivity
    (const PMI_Environment& env)
{
    return new MetalResistivity(env);
}
```

# Schottky Resistance

The Schottky resistance model (see Resistive Contacts on page 223 and Resistive Interfaces on page 229) emulates the behavior of a Schottky contact or interface. The Schottky resistance PMI allows users to define the contact- or interface-distributed Schottky resistance as an arbitrary function of lattice temperature, electron temperature, hole temperature, electron affinity, band gap, bandgap narrowing, conduction-band effective density-of-states, valence-band effective density-of-states, and effective intrinsic density.

The name of the PMI can be specified interface-wise or electrode-wise in the `Physics` section of the command file as follows:

```
Physics ( Electrode = "top2" ) {
    DistResist=SchottkyResist(pmi_schottkyresist1)
}

Physics(RegionInterface="r1/r5") {
    DistResist=SchottkyResist(pmi_schottkyresist2)
}
```

## Dependencies

The Schottky resistance $R_d$ can depend on the following variables:

$$ R_d = R_d(T, T_n, T_p, \chi, E_g, E_{bgn}, N_C, N_V, n_{i, \text{eff}}) $$ (1347)

where:

*   $T$ is the lattice temperature [K].

*   $T_n, T_p$ are the carrier temperatures [K].

*   $\chi$ is the electron affinity [eV].

*   $E_g$ is the band gap [eV].

*   $E_{bgn}$ is the bandgap narrowing [eV].

Electrical Resistivity

*   $N_C, N_V$ are the conduction band and the valence band density-of-states [ cm<sup>−3</sup> ].

*   $n_{i, \text{eff}}$ is the effective intrinsic density [ cm<sup>−3</sup> ].

The PMI model must compute the following result:

$$ \text{Rd} \quad [\Omega \text{cm}^2] $$

In the case of the standard interface, the following derivatives must be computed as well:

`dRd_dT` Derivative of Rd with respect to $T$ [ $\Omega \text{cm}^2 \text{K}^{-1}$ ]
`dRd_dTn` Derivative of Rd with respect to $T_n$ [ $\Omega \text{cm}^2 \text{K}^{-1}$ ]
`dRd_dTp` Derivative of Rd with respect to $T_p$ [ $\Omega \text{cm}^2 \text{K}^{-1}$ ]
`dRd_dChi` Derivative of Rd with respect to $\chi$ [ $\Omega \text{cm}^2 \text{eV}^{-1}$ ]
`dRd_dEg` Derivative of Rd with respect to $E_g$ [ $\Omega \text{cm}^2 \text{eV}^{-1}$ ]
`dRd_dEbgn` Derivative of Rd with respect to $E_{bgn}$ [ $\Omega \text{cm}^2 \text{eV}^{-1}$ ]
`dRd_dNc` Derivative of Rd with respect to $N_C$ [ $\Omega \text{cm}^{-1} \text{eV}^{-1}$ ]
`dRd_dNv` Derivative of Rd with respect to $N_V$ [ $\Omega \text{cm}^{-1} \text{eV}^{-1}$ ]
`dRd_dnieff` Derivative of Rd with respect to $n_{i, \text{eff}}$ [ $\Omega \text{cm}^{-1} \text{eV}^{-1}$ ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_SchottkyResistanc : public PMI_Vertex_Interface {
public:
    class Input {
    public:
        double t; // lattice temperature
        double tn; // electron temperature
        double tp; // hole temperature
        double affin; // electron affinity
        double Eg; // bandgap
        double Ebgn; // bandgap narrowing
        double nc; // conduction-band effective density of states
        double nv; // valence-band effective density of states
        double nie; // effective intrinsic density
    };

    class Output {
```

39: Physical Model Interface

Electrical Resistivity

```cpp
        public:
          double resist; // Schottky resistance
          double dresistdt; // temperature derivative
          double dresistdtn; // electron temperature derivative
          double dresistdtp; // hole temperature derivative
          double dresistdaffin; // electron affinity derivative
          double dresistdEg; // bandgap derivative
          double dresistdEbgn; // bandgap narrowing derivative
          double dresistdnc; // conduction-band effective state dens derivative
          double dresistdnv; // valence-band effective state dens derivative
          double dresistdnie; // intrinsic carrier density derivative
      };

      PMI_SchottkyResistance (const PMI_Environment& env);
      virtual ~PMI_SchottkyResistance ();

      virtual void compute(const Input& input, Output& output) = 0;
    };
```

The following virtual constructor must be implemented:

```cpp
virtual extern "C"
PMI_SchottkyResistance* new_PMI_SchottkyResistance(const PMI_Environment& env)
```

# Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_SchottkyResistance_Base : public PMI_Vertex_Base {
  public:
    class Input : public PMI_Vertex_Input_Base {
    public:
      Input (const PMI_SchottkyResistance_Base* schottkyresist_base,
             const int vertex);
      pmi_float t;  // lattice temperature
      pmi_float tn; // electron temperature
      pmi_float tp; // hole temperature
      pmi_float affin; // electron affinity
      pmi_float Eg; // bandgap
      pmi_float Ebgn; // bandgap narrowing
      pmi_float nc; // conduction-band effective density of states
      pmi_float nv; // valence-band effective density of states
      pmi_float nie; // effective intrinsic density
    };
    class Output {
      public:
        pmi_float resist; // Schottky resistance
    };
};
```

Electrical Resistivity

```cpp
  PMI_SchottkyResistance_Base (const PMI_Environment& env);

  virtual ~PMI_SchottkyResistance_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
extern "C"
PMI_SchottkyResistance_Base* new_PMI_SchottkyResistance_Base(const
PMI_Environment& env);
```

## Example: Built-in Schottky Resistance

The following C++ code reimplements the built-in Schottky resistance model (simplified C++ interface):

```cpp
#include <math.h>
#include "PMI.h"

class Builtin_SchottkyResistance: public PMI_SchottkyResistance_Base {
private:
  pmi_float ComputeSchottkyResistance(const Input& input);

public:
  Builtin_SchottkyResistance(const PMI_Environment& env);
  ~Builtin_SchottkyResistance();
  void compute(const Input& input, Output& output);
};

Builtin_SchottkyResistance::
Builtin_SchottkyResistance(const PMI_Environment& env) :
          PMI_SchottkyResistance_Base (env) {}

Builtin_SchottkyResistance::
~Builtin_SchottkyResistance() {}

pmi_float Builtin_SchottkyResistance::
ComputeSchottkyResistance(const Input& input) {
  // Planck's constant divided by 2pi in J*s
  const double h_bar = 1.05458866419688266838371913965e-34;
  // Epsilon 0 in As/Vcm
  const double eps0 = 8.8542e-14;
  // electron charge in C
  const double e0 = 1.602192e-19;
  // electron mass in kg
```

39: Physical Model Interface

Electrical Resistivity

```cpp
const double m0 = 9.109534e-31;
// Boltzmann constant in J/K
const double kB = 1.380662e-23;

pmi_float tempDEV = 300; // K
pmi_float kT = kB*tempDEV/e0; // energy in eV

pmi_float dop = input.ReadDoping(PMI_Donor) -
                input.ReadDoping(PMI_Acceptor);
pmi_float epsSEM = input.InitModelParameter("epsilon", "Epsilon", 1);
pmi_float N = (dop > 0) ? dop : -dop;

double rinf = 0;
double PhiB = 0;
double M = 0;

if(dop > 0) { // q = -1
 rinf = input.InitModelParameter("Rinf_e","SchottkyResistance",
                                  2.4000e-09);
 PhiB = input.InitModelParameter("PhiB_e", "SchottkyResistance", 0.6);
 M = input.InitModelParameter("mt_e", "SchottkyResistance", 0.19);
} else { // q = 1
 rinf = input.InitModelParameter("Rinf_h", "SchottkyResistance",
                                  5.2000e-09);
 PhiB = input.InitModelParameter("PhiB_h", "SchottkyResistance", 0.51);
 M = input.InitModelParameter("mt_h", "SchottkyResistance", 0.16);
}

pmi_float Rinf = rinf*300/tempDEV;
pmi_float E00 = h_bar/2.0*100.0*sqrt(N/eps0/epsSEM/M/m0); // eV

pmi_float E0 = 0;
if(E00 < kT/100)
 E0 = kT;
else if(E00 > kT*100)
 E0 = E00;
else
 E0 = E00*cosh(E00/kT)/sinh(E00/kT);

return Rinf*exp(PhiB/E0);
}

void Builtin_SchottkyResistance::
compute(const Input& input, Output& output) {
 output.resist = ComputeSchottkyResistance(input);
}
```

Simulation Controls

```cpp
extern "C"
PMI_SchottkyResistance_Base* new_PMI_SchottkyResistance_Base(
 const PMI_Environment& env) {
 return new Builtin_SchottkyResistance(env);
}
```

# Simulation Controls

This section presents the following PMIs:

*   Current Plot File

*   Postprocessing for Transient Simulations

*   Preprocessing for Newton Iterations and Newton Step Control

## Current Plot File

The current plot PMI allows user-computed entries to be added to the current plot file. It is specified in the `CurrentPlot` section of the command file. For example:

```
CurrentPlot { pmi_CurrentPlot }
```

The interface has access to the device mesh and device data (see Runtime Support for Mesh-Based PMI Models on page 1203).

See Current Plot File on page 1458 for a Tcl-based alternative to the current plot PMI.

## Structure of Current Plot File

A current plot file consists of a header section and a data section. For each function, the structure can be described as follows:

```
dataset name
function name
value₀
value₁
...
```

A dataset name denotes a dataset. For example:

```
time
Tmin
```

39: Physical Model Interface

Simulation Controls

If a dataset corresponds to a region or contact, then it is customary to add the region or contact name:

```
gate Charge
```

The function name describes the function. For example:

```
ElectrostaticPotential
Temperature
```

Afterwards, a function value is added to the current plot file for each plot time point.

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_CurrentPlot : public PMI_Device_Interface {

public:
    PMI_CurrentPlot (const PMI_Device_Environment& env);
    virtual ~PMI_CurrentPlot ();

    virtual void Compute_Dataset_Names
        (des_string_vector& dataset) = 0;

    virtual void Compute_Function_Names
        (des_string_vector& function) = 0;

    virtual void Compute_Plot_Values
        (des_double_vector& value) = 0;
};
```

The `Compute_Dataset_Names()` and `Compute_Function_Names()` methods generate the header in the current plot file (see Structure of Current Plot File on page 1404). The method `Compute_Plot_Values()` is called for each plot time point to compute the plot values. Use the `push_back()` function to add values to the arrays `dataset`, `function`, or `value`.

> **NOTE** These three methods must always compute the same number of values. Otherwise, an inconsistent current plot file will be generated.

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_CurrentPlot* new_PMI_CurrentPlot_func
    (const PMI_Device_Environment& env);
extern "C" new_PMI_CurrentPlot_func new_PMI_CurrentPlot;
```

Simulation Controls

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_CurrentPlot_Base : public PMI_Device_Base {

public:
  class Input : public PMI_Device_Input_Base {
  public:
  };

  class Output_Header {
  public:
    des_string_vector dataset;  // array of dataset names
    des_string_vector function; // array of function names
  };

  class Output_Body {
  public:
    sdevice_pmi_float_vector value; // array of plot values
  };

  PMI_CurrentPlot_Base (const PMI_Device_Environment& env);
  virtual ~PMI_CurrentPlot_Base ();

  virtual void compute_header (Output_Header& output) = 0;
  virtual void compute_body (const Input& input, Output_Body& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_CurrentPlot_Base* new_PMI_CurrentPlot_Base_func
  (const PMI_Device_Environment& env);
extern "C" new_PMI_CurrentPlot_Base_func new_PMI_CurrentPlot_Base;
```

## Example: Average Electrostatic Potential

The following example computes regionwise averages for the electrostatic potential. This is the same functionality as provided by the built-in current plot command (see Tracking Additional Data in the Current File on page 116):

```cpp
class CurrentPlot : public PMI_CurrentPlot {
private:
  typedef std::vector<des_bulk*> des_bulk_vector;

  const des_mesh* mesh;    // device mesh
  des_bulk_vector regions; // list of semiconductor bulk regions
  double scale;            // scaling factor
```

39: Physical Model Interface
Simulation Controls

```cpp
public:
  CurrentPlot (const PMI_Device_Environment& env);
  ~CurrentPlot ();

  void Compute_Dataset_Names (des_string_vector& dataset);
  void Compute_Function_Names (des_string_vector& function);
  void Compute_Plot_Values (des_double_vector& value);
};

CurrentPlot::
CurrentPlot (const PMI_Device_Environment& env) :
  PMI_CurrentPlot (env)
{ mesh = Mesh ();
  // determine regions to process
  for (size_t ri = 0; ri < mesh->size_region (); ri++) {
    des_region* r = mesh->region (ri);
    if (r->type () == des_region::bulk) {
      des_bulk* b = dynamic_cast <des_bulk*> (r);
      if (b->material () != "Oxide") {
        // we found a semiconductor bulk region
        regions.push_back (b);
      }
    }
  }
}

// read parameters
scale = InitParameter ("scale", 0.0);
}

CurrentPlot::
~CurrentPlot ()
{
}

void CurrentPlot::
Compute_Dataset_Names (des_string_vector& dataset)
{ for (size_t ri = 0; ri < regions.size (); ri++) {
    des_bulk* b = regions [ri];
    std::string name = "Average_";
    name += b->name ();
    name += "ElectrostaticPotential";
    dataset.push_back (name);
  }
}

void CurrentPlot::
```

1407

Simulation Controls

```cpp
Compute_Function_Names (des_string_vector& function)
{ for (size_t ri = 0; ri < regions.size (); ri++) {
    function.push_back ("ElectrostaticPotential");
  }
}

void CurrentPlot::
Compute_Plot_Values (des_double_vector& value)
{ des_data* data = Data ();
  const double*const* measure = data->ReadMeasure ();
  const double* pot = data->ReadScalar (des_data::vertex,
                                        "ElectrostaticPotential");
  for (size_t ri = 0; ri < regions.size (); ri++) {
    des_bulk* b = regions [ri];

    double sum_pot = 0.0;
    double sum_measure = 0.0;

    for (size_t ei = 0; ei < b->size_element (); ei++) {
      des_element* e = b->element (ei);
      for (size_t vi = 0; vi < e->size_vertex (); vi++) {
        des_vertex* v = e->vertex (vi);
        const double m = measure [e->index ()][vi];
        const double p = pot [v->index ()];
        sum_pot += m * p;
        sum_measure += m;
      }
    }

    value.push_back (scale * (sum_pot / sum_measure));
  }
}

extern "C" {
PMI_CurrentPlot* new_PMI_CurrentPlot (const PMI_Device_Environment& env)
{ return new CurrentPlot (env);
}
}
```

# Postprocessing for Transient Simulations

The postprocess PMI allows you to post-compute data during a transient simulation. The PMI is called after a transient time step has succeeded. It is specified in the Math section of the command file.

39: Physical Model Interface

Simulation Controls

For example:

```
Math {
  PostProcess ( Transient = "pmi_postprocess" )
}
```

The interface provides access to the device mesh and device data (see Runtime Support for Mesh-Based PMI Models on page 1203).

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_PostProcess : public PMI_Device_Interface {

public:
  PMI_PostProcess (const PMI_Device_Environment& env);
  virtual ~PMI_PostProcess ();

  virtual void Compute_PostProcess () = 0;
}
```

The method `Compute_PostProcess()` is called after the transient time step has successfully completed.

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_PostProcess_Base : public PMI_Device_Base {

public:
  class Input : public PMI_Device_Input_Base {
  public:
  };

  class Output {
  public:
  };

  PMI_PostProcess_Base (const PMI_Device_Environment& env);
  virtual ~PMI_PostProcess_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

Simulation Controls

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_PostProcess_Base* new_PMI_PostProcess_Base_func
  (const PMI_Device_Environment& env);
extern "C" new_PMI_PostProcess_Base_func new_PMI_PostProcess_Base;
```

The method `compute()` is called after the transient time step has successfully completed.

## Example: Postprocess User-Field

The following code modifies the user-field depending on the current temperature change and transient step size after the transient time step has succeeded:

```cpp
#include "PMIModels.h"

class PostProcess : public PMI_PostProcess {

private:
  const des_mesh* mesh;

public:
  PostProcess (const PMI_Device_Environment& env);
  ~PostProcess ();
  void Compute_PostProcess ();
};

PostProcess::
PostProcess (const PMI_Device_Environment& env) :
  PMI_PostProcess (env)
{
  mesh = Mesh();
}

PostProcess::
~PostProcess ()
{
}

void PostProcess::
Compute_PostProcess ()
{
  des_data* data = Data();

  const double* T = data->ReadScalar(des_data::vertex,
    "LatticeTemperature");
  const double* T0 = data->ReadScalar(des_data::vertex, "PMIUserField0");

  double* delta_T = new double [mesh->size_vertex ()];
```

39: Physical Model Interface

Simulation Controls

```cpp
    for (int vi=0; vi<mesh->size_vertex (); vi++) {
     delta_T[vi] = (T[vi]-T0[vi])/ReadTransientStepSize();
    }
    data->WriteScalar(des_data::vertex, "PMIUserField0", T);
    data->WriteScalar(des_data::vertex, "PMIUserField1", delta_T);
    if (delta_T!=NULL) { delete [] delta_T; }
   }
```

# Preprocessing for Newton Iterations and Newton Step Control

The Newton step PMI allows you to precompute data during Newton iterations (using a nonlinear solver). This PMI is called after each Newton iteration. The interface provides access to the device mesh and device data (see Runtime Support for Mesh-Based PMI Models on page 1203). This PMI is specified in the Coupled section (subsection PMI_NewtonStep) of the command file. For example:

```
Coupled( PMI_NewtonStep( pmiNewtonStep(<parameter_list>) ) )
 { Poisson Electron Hole }
```

Here, pmiNewtonStep is the name of the PMI model. Different Coupled sections can use different PMI models. For example:

```
Solve {
 # "pmi_Newton1" is name the first PMI function
 Coupled( PMI_NewtonStep(pmi_Newton1) )
 { Poisson electron hole }

 Transient (
  InitialTime = 0.0 Finaltime = 1.0
  InitialStep = 0.01 MaxStep = 0.1 MinStep = 1.0e-06
 ) {# "pmi_Newton2" is name the second PMI function
  Coupled( PMI_NewtonStep( PMI_NewtonStep(pmi_Newton2(parameter_list)) ) )
  { Poisson Electron Hole Temperature }
 }

 Quasistationary (
  InitialStep=0.1 MaxStep=0.5 MinStep=0.001
  Increment=1.3
  Goal {name="drain" Voltage=0.6}
 )
 {# same PMI function
  Coupled( PMI_NewtonStep(pmi_Newton2(parameter_list)...) )
  { poisson electron hole }
 }
}
```

39: Physical Model Interface

Simulation Controls

# Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_NewtonStep : public PMI_Device_Interface
{
protected:
  PMI_Newton::Info *info;

public:
  PMI_NewtonStep (const PMI_Device_Environment& env, PMI_Newton::Info *i=0);
  virtual ~PMI_NewtonStep ();
  PMI_Newton::Info* getNewtonInfo() {
    return info;
  }

  // methods to be implemented by user
  virtual PMI_Result Compute (char* err_msg) = 0;
};
```

The method `Compute()` is called after each Newton iteration. The enumerator `PMI_Result` is defined in the file `PMIModels.h`:

```cpp
enum PMI_Result {
  PMI_NextStep = 0,
  PMI_Converged = 1,
  PMI_Diverged = 2,
  PMI_Undefined
};
```

## Function PMI_Newton::GetLogFile() and Class PMI_Newton::Info

The `PMIModels.h` file contains the function `FILE* PMI_Newton::GetLogFile()`. It returns a pointer to the log file and, therefore, the PMI function can print messages to the log file. See the relevant files of the following example:

```
$STROOT/tcad/$STRELEASE/lib/sdevice/src/pmi_NewtonStep
```

The `PMI_Newton::Info` class is an interface class between Sentaurus Device and `PMI_NewtonStep`, and it contains information about the Newton process. The function `getNewtonInfo()` returns the corresponding pointer. The important functions of this class are as follows (see Standard C++ Interface on page 1412):

*   `IsTrans()`, `IsQstat()`, and `IsContin()` return a value equal to true if the `Coupled` statement is a subsection of the corresponding section: `Transient`, `Quasistationary`, or `Continuation`.

*   `InitialStep()`, `MaxStep()`, `MinStep()`, `Decrement()`, `Increment()`, `InitialTime()`, `FinalTime()`, and `MaxIters()` return the corresponding values as in the command file.

39: Physical Model Interface

Simulation Controls

*   `UsedIters()`, `RHS()`, `NewtonStep()`, `Error()`, `TimeFrom()`, and `TimeTo()` return the corresponding values as in the log file.

*   `std::vector<std::string> pdeName` contains the PDE name as in the log file.

*   `ChangeTimeTo(double t)` performs PMI time-step control (see Flow of Computation on page 1414).

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_NewtonStep_Base : public PMI_Device_Base
{
protected:
  PMI_Newton::Info *info;

public:
  class Input : public PMI_Device_Input_Base {
  public:
    Input (const PMI_NewtonStep_Base* newtonstep_base);
  };

  class Output {
  public:
    char err_msg[256];
  };

  PMI_NewtonStep_Base(
    const PMI_Device_Environment& env, PMI_Newton::Info *i=0);
    virtual ~PMI_NewtonStep_Base ();

  PMI_Newton::Info* getNewtonInfo() {
    return info;
  }

  virtual PMI_Result compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_NewtonStep_Base* new_PMI_NewtonStep_Base_func
  (const PMI_Device_Environment& env, PMI_Newton::Info *i);
extern "C" new_PMI_NewtonStep_Base_func new_PMI_NewtonStep_Base;
```

The method `compute()` is called after each Newton iteration.

Simulation Controls

## Flow of Computation

The following example shows the Quasistationary command (see previous example):

```
Starting solve of next problem:
Quasistationary (
    Initial step in t: 0.1, Minimum step in t: 0.001, Maximum step in t: 0.5,
    ...
) { Coupled ( PMI_NewtonStep(pmi_Newton2(parameter_list)) )
    { Poisson Electron Hole }
}
    // call constructor PMI_NewtonStep
    PMI_NewtonStep *pmi_Newton = new PMI_NewtonStep (. . .)
    bool Is_pmiConverged = false, Is_pmiDiverged = false;

Computing step from t=0.4 to t=0.5
// for this case PMI_Newton::Info functions return the following values:
// TimeFrom()==0.4 and TimeTo()==0.5
Iteration  |Rhs|         |step|         error
---------------------------------------------------------------
0           3.89e+08
1           1.21e+07     1.25e-03     3.12e+02
      ...
m           6.62e+06     3.36e-05     5.85e+00
     int pmiResult = pmi_Newton->Compute();
     if( pmiResult != pmiNextStep){
       if(pmiResult == PMI_Converged) Is_pmiConverged = true;
       if(pmiResult == PMI_Diverged) Is_pmiDinverged = true;
     }
     if(Is_sdeviceDiverged || Is_pmiDiverged) {
        // If pmiResult==PMI_Diverged, then user have to use
        // function ChangeTimeTo(new_t) (new_t <= TimeTo())
        // In this case sdevice reduces the time step.
        // It is PMI time step control
        goto Iteration#0;  // sdevice decrease step
     } else if(Is_sdeviceConverged && Is_pmiConverged) {
       goto Finish;
     } else {
       goto NextNewtonStep
     }
    ...
Finished, because...
Error smaller than 1 ( 7.3461E-02 ) and Is_pmiConverged == true
    // call destructor ~PMI_NewtonStep
```

39: Physical Model Interface
Various

# Various

This section presents the following PMIs:

*   Dielectric Permittivity

*   Energy Relaxation Times

*   Gamma Factor for Density Gradient Model

*   Heavy Ion Spatial Distribution

*   Hot-Carrier Injection

*   Incomplete Ionization

*   Space Factor

## Dielectric Permittivity

This PMI provides access to the dielectric permittivity $\epsilon$ in Eq. 37, p. 179. To activate it, in the Physics section of the command file, specify:

```
Physics { DielectricConstant (<string>) }
```

where `<string>` is the name of the PMI model.

The PMI supports anisotropic dielectric permittivity, and the model can be evaluated along different crystallographic axes. The enumeration type `PMI_AnisotropyType` determines the axis. The default is isotropic dielectric permittivity.

If anisotropic dielectric permittivity is activated in the command file, then the PMI class `PMI_DielectricConstant` is also instantiated in the anisotropic direction.

## Dependencies

The dielectric permittivity can depend on the variable:

`t` Lattice temperature [K]

The PMI model must compute the following results:

`epsilon` Dielectric permittivity $\epsilon$ relative to $\epsilon_0$ [1]

Various

In the case of the standard interface, the following derivative must be computed as well:

`depsilondt` Derivative of $\epsilon$ relative to t [1/K]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_DielectricConstant : public PMI_Vertex_Interface {
public:
  PMI_DielectricConstant (const PMI_Environment& env, const
    PMI_AnisotropyType anisotype);
  virtual ~PMI_DielectricConstant ();
  PMI_AnisotropyType AnisotropyType () const { return anisoType; }
  virtual void Compute_epsilon (const double t, double& epsilon) = 0;
  virtual void Compute_depsilondt (const double t, double& depsilondt) = 0;
};
```

The following virtual constructor must be implemented:

```cpp
typedef PMI_DielectricConstant* new_PMI_DielectricConstant_func (const
  PMI_Environment& env, const PMI_AnisotropyType anisotype);
extern "C" new_PMI_DielectricConstant_func new_PMI_DielectricConstant;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_DielectricConstant_Base : public PMI_Vertex_Base {
public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float t; // lattice temperature
  };

  class Output {
  public:
    pmi_float epsilon; // dielectric permittivity
  };

  PMI_DielectricConstant_Base (const PMI_Environment& env, const
    PMI_AnisotropyType anisotype);
  virtual ~PMI_DielectricConstant_Base ();
  PMI_AnisotropyType AnisotropyType () const;
```

39: Physical Model Interface

Various

```cpp
    virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_DielectricConstant_Base* new_PMI_DielectricConstant_Base_func
  (const PMI_Environment& env, const PMI_AnisotropyType anisotype);
extern "C" new_PMI_DielectricConstant_Base_func
  new_PMI_DielectricConstant_Base;
```

## Example: Temperature-Dependent Dielectric Permittivity

The following C++ code implements the temperature-dependent dielectric permittivity:

$$ \varepsilon(T) = \text{eps0} + \text{eps1} \cdot \tanh \left( \frac{T - T_c}{T0} \right) $$ (1348)

```cpp
#include "PMIModels.h"
class TempDep_Dielectric : public PMI_DielectricConstant {

private:
  double eps0, eps1, Tc, T0;
public:
  TempDep_Dielectric (const PMI_Environment& env, const PMI_AnisotropyType
  anisotype);
  ~TempDep_Dielectric ();
  void Compute_epsilon (const double t, double& epsilon);
  void Compute_depsilondt (const double t, double& depsilondt);
};

TempDep_Dielectric::TempDep_Dielectric (const PMI_Environment& env,
  const PMI_AnisotropyType anisotype) : PMI_DielectricConstant (env,
  anisotype)
{ // default values
  eps0 = InitParameter ("eps0", 11.7);
  eps1 = InitParameter ("eps1", 0.0);
  Tc = InitParameter ("Tc", 300.0);
  T0 = InitParameter ("T0", 300.0);
}

TempDep_Dielectric::~TempDep_Dielectric() {}

void TempDep_Dielectric::Compute_epsilon (const double t, double& epsilon)
{ epsilon = eps0+eps1*tanh((t-Tc)/T0);
}

void TempDep_Dielectric::Compute_depsilondt (const double t, double&
  depsilondt)
```

Various

```cpp
{ const double th = tanh((t-Tc/T0);
  depsilondt = eps1/T0*(1.0-th*th);
}

extern "C"
PMI_DielectricConstant* new_PMI_DielectricConstant (const PMI_Environment&
  env, const PMI_AnisotropyType anisotype)
{ return new TempDep_Dielectric (env, anisotype);
}
```

# Energy Relaxation Times

The model for the energy relaxation times $\tau$ in Eq. 86, p. 205 and Eq. 87, p. 205 can be specified in the `Physics` section of the command file. The four available possibilities are:

```
Physics {
  EnergyRelaxationTimes (
    formula
    constant
    irrational
    pmi_model_name
  )
}
```

These entries have the following meaning:

* `formula`: Use the value of `formula` in the parameter file (default)
* `constant`: Use constant energy relaxation times (`formula=1`)
* `irrational`: Use the ratio of two irrational polynomials (`formula=2`)
* `pmi_model_name`: Call a PMI model to compute the energy relaxation times

## Dependencies

The energy relaxation time $\tau$ can depend on the variable:

* `ct`: Carrier temperature [K]

> **NOTE** The parameter `ct` represents the electron temperature during the calculation of $\tau_n$ and the hole temperature during the calculation of $\tau_p$.

39: Physical Model Interface

Various

The PMI model must compute the following results:

`tau` Energy relaxation time $\tau$ [s]

In the case of the standard interface, the following derivative must be computed as well:

`dtaudct` Derivative of $\tau$ with respect to ct [sK<sup>-1</sup>]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_EnergyRelaxationTime : public PMI_Vertex_Interface {

public:
  PMI_EnergyRelaxationTime (const PMI_Environment& env);

  virtual ~PMI_EnergyRelaxationTime ();

  virtual void Compute_tau
    (const double ct, double& tau) = 0;

  virtual void Compute_dtaudct
    (const double ct, double& dtaudct) = 0;
};
```

The following two virtual constructors must be implemented for electron and hole energy relaxation times:

```cpp
typedef PMI_EnergyRelaxationTime* new_PMI_EnergyRelaxationTime_func
  (const PMI_Environment& env);
extern "C" new_PMI_EnergyRelaxationTime_func new_PMI_e_EnergyRelaxationTime;
extern "C" new_PMI_EnergyRelaxationTime_func new_PMI_h_EnergyRelaxationTime;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_EnergyRelaxationTime_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float ct; // carrier temperature
  };
```

Various

```cpp
  class Output {
  public:
    pmi_float tau;  // energy relaxation time
  };

  PMI_EnergyRelaxationTime_Base (const PMI_Environment& env);
  virtual ~PMI_EnergyRelaxationTime_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_EnergyRelaxationTime_Base* new_PMI_EnergyRelaxationTime_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_EnergyRelaxationTime_Base_func
  new_PMI_e_EnergyRelaxationTime_Base;
extern "C" new_PMI_EnergyRelaxationTime_Base_func
  new_PMI_h_EnergyRelaxationTime_Base;
```

## Example: Constant Energy Relaxation Times

The following C++ code implements constant energy relaxation times:

```cpp
#include "PMIModels.h"

class Const_EnergyRelaxationTime : public PMI_EnergyRelaxationTime {

protected:
  double tau_const;

public:
  Const_EnergyRelaxationTime (const PMI_Environment& env);

  ~Const_EnergyRelaxationTime ();

  void Compute_tau
    (const double ct, double& tau);

  void Compute_dtaudct
    (const double ct, double& dtaudct);

};

Const_EnergyRelaxationTime::
Const_EnergyRelaxationTime (const PMI_Environment& env) :
  PMI_EnergyRelaxationTime (env)
{
```

39: Physical Model Interface
Various

```cpp
}

Const_EnergyRelaxationTime::
~Const_EnergyRelaxationTime ()
{
}

void Const_EnergyRelaxationTime::
Compute_tau (const double ct, double& tau)
{ tau = tau_const;
}

void Const_EnergyRelaxationTime::
Compute_dtaudct (const double ct, double& dtaudct)
{ dtaudct = 0.0;
}

class Const_e_EnergyRelaxationTime : public Const_EnergyRelaxationTime {

public:
  Const_e_EnergyRelaxationTime (const PMI_Environment& env);

  ~Const_e_EnergyRelaxationTime () {}

};

Const_e_EnergyRelaxationTime::
Const_e_EnergyRelaxationTime (const PMI_Environment& env) :
  Const_EnergyRelaxationTime (env)
{ tau_const = InitParameter ("tau_const_e", 0.3e-12);
}

class Const_h_EnergyRelaxationTime : public Const_EnergyRelaxationTime {

public:
  Const_h_EnergyRelaxationTime (const PMI_Environment& env);

  ~Const_h_EnergyRelaxationTime () {}

};

Const_h_EnergyRelaxationTime::
Const_h_EnergyRelaxationTime (const PMI_Environment& env) :
  Const_EnergyRelaxationTime (env)

{ tau_const = InitParameter ("tau_const_h", 0.25e-12);
}
```

Various

```cpp
extern "C"
PMI_EnergyRelaxationTime* new_PMI_e_EnergyRelaxationTime
 (const PMI_Environment& env)
{ return new Const_e_EnergyRelaxationTime (env);
}

extern "C"
PMI_EnergyRelaxationTime* new_PMI_h_EnergyRelaxationTime
 (const PMI_Environment& env)
{ return new Const_h_EnergyRelaxationTime (env);
}
```

# Gamma Factor for Density Gradient Model

The density gradient model (see Density Gradient Model on page 316) contains the fit factor:

$$ \gamma = \gamma_0 \cdot \gamma_{pmi} $$ (1349)

where $\gamma_0$ is the solution-independent value, and $\gamma_{pmi}$ is dependent on the solution [4].

The name of the PMI can be specified regionwise, materialwise, or globally in the `Physics` section of the command file as follows:

```
Physics ( Material = "Silicon" ) {
   eQuantumPotential( Gamma(name=pmi_eGamma -EffectiveMass)
   hQuantumPotential( Gamma(name=pmi_hGamma)
}
```

This model has the optional flag `EffectiveMass` (default) or `-EffectiveMass`. If the option `-EffectiveMass` is activated, then the DOS mass that is used as the prefactor of the density gradient equation is replaced with the free electron mass (only in the quantum potential model).

## Dependencies

The $\gamma_{pmi}$ can depend on the following variables:

$$ \gamma_{pmi} = \gamma_{pmi}(c, T_c, E_{normal}, h) $$ (1350)

where:

* $c = n, p$ is the carrier density [cm<sup>-3</sup>] for the `eQuantumPotential` model and the `hQuantumPotential` models.

* $T_c$ is the carrier temperature [K].

39: Physical Model Interface

Various

*   $E_{\text{normal}}$ is the electric field perpendicular to the interface [ $\text{Vcm}^{-1}$ ].

*   $h$ is the layer thickness [ $\mu\text{m}$ ].

The PMI model must compute the following result:

`Gamma` [unitless]

In the case of the standard interface, the following derivatives must be computed as well:

`dGamma_dc` Derivative of Gamma with respect to n, p [ $\text{cm}^3$ ]
`dGamma_dt` Derivative of Gamma with respect to $T_c$ [ $\text{K}^{-1}$ ]
`dGamma_df` Derivative of Gamma with respect to $E_{\text{per}}$ [ $\text{cmV}^{-1}$ ]
`dGamma_dh` Derivative of Gamma with respect to h [ $\text{cmV}^{-1}$ ]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_QDDGamma : public PMI_Vertex_Interface {

public:
 PMI_QDDGamma(const PMI_Environment& env);
 virtual ~PMI_QDDGamma ();

 virtual void Compute_gamma(
  const double c,                 // carrier density
  const double t,                 // carrier temperature
  const double f,                 // Enormal to interface
  const double h,                 // layer thickness
  double& gamma) = 0;             // gamma

 virtual void Compute_dgamma_dc
     (const double c,              // carrier density
      const double t,              // carrier temperature
      const double f,              // Enormal to interface
      const double h,              // layer thickness
      double& dgammadc) = 0;       // derivative of gamma with respect to
                                   // carrier density

 virtual void Compute_dgamma_dt
     (const double c,              // carrier density
      const double t,              // carrier temperature
      const double f,              // Enormal to interface
      const double h,              // layer thickness
```

Various

```cpp
       double& dgammadt) = 0;       // derivative with respect to carrier
                                    // temperature

  virtual void Compute_dgamma_df
      (const double c,              // carrier density
       const double t,              // carrier temperature
       const double f,              // Enormal to interface
       const double h,              // layer thickness
       double& dgammadf) = 0;       // derivative with respect to Enormal to
                                    // interface

    virtual void Compute_dgamma_dh
      (const double c,              // carrier density
       const double t,              // carrier temperature
       const double f,              // Enormal to interface
       const double h,              // layer thickness
       double& dgammadh) = 0;       // derivative with respect to layer thickness
  };
```

The following virtual constructor must be implemented:

```cpp
 typedef PMI_QDDGamma* new_PMI_QDDGamma_func
  (const PMI_Environment& env);
 extern "C" new_PMI_QDDGamma_func   new_PMI_QDDGamma;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
 class PMI_MSC_QDDGamma_Base : public PMI_MSC_Vertex_Base {
  public:
    class Input : public PMI_Vertex_Input_Base {
    public:
      Input (const PMI_MSC_QDDGamma_Base* msc_qddgamma_base,
           const int vertex);

      pmi_float n;     // electron density
      pmi_float p;     // hole density
      pmi_float T;     // lattice temperature
      pmi_float eT;    // electron temperature
      pmi_float hT;    // hole temperature
      std::vector<pmi_float> s;     // phase fraction
    };
  class Output {
    public:
      pmi_float val;   // solution-dependent gamma value
    };
  };
```

39: Physical Model Interface

Various

```cpp
    PMI_MSC_QDDGamma_Base (const PMI_Environment& env,
                             const std::string& msconfig_name,
                             const int model_index);

    virtual ~PMI_MSC_QDDGamma_Base ();

    virtual void compute (const Input& input, Output& output) = 0;

};
```

The following virtual constructor must be implemented:

```cpp
extern "C"
PMI_QDDGamma_Base* new_PMI_QDDGamma_Base (const PMI_Environment& env);
```

## Example: Solution-Dependent Gamma Factor

The following C++ code implements a solution-dependent Gamma factor (simplified C++ interface):

```cpp
#include <math.h>
#include "PMI.h"

//   gamma = gxy*gc*gt*gf*gh
//   where:
//     gxy = g0 + ax*x/x0 + ay*y/y0;
//     gc = exp(xc/(1+xc));     xc = Sqr(log(c/c0))
//     gt = exp(xt);            xt = (t-300)/cT0
//     gf = 1 + af*xf*xf;       xf = (f-f1)/f0
//     gh = 1 + ah*(xh - 1);    xh = h/h0

class eQDDGamma : public PMI_QDDGamma_Base{
private:
  //   see above
  double g0, x0, y0, ax, ay;
  double c0, cT0;
  double h0, ah;
  double f0, f1, af;

  int formula;
  enum {is_c=1, is_t=2, is_f=4, is_h=8};

public:
  eQDDGamma (const PMI_Environment& env);
  ~eQDDGamma ();
  void compute (const Input& input, Output& output);
};
```

Various

```cpp
eQDDGamma::
eQDDGamma (const PMI_Environment& env) :
  PMI_QDDGamma_Base (env)
{
  g0 = InitParameter("g0", 1.);        //  [1]
  c0 = InitParameter("c0", 1e10);      //  [cm-3]
 cT0 = InitParameter("cT0", 300.);     //  [K]
  x0 = InitParameter("x0", 1.);        //  [um]
  ax = InitParameter("ax", 0.);        //  [1]
  y0 = InitParameter("y0", 1.);        //  [um]
  ay = InitParameter("ay", 0.);        //  [1]
  h0 = InitParameter("h0", 1.);        //  [um]
  ah = InitParameter("ah", 0.);        //  [1]
  f0 = InitParameter("f0", 1e7);       //  [V/cm]
  f1 = InitParameter("f1", 1e7);       //  [V/cm]
  af = InitParameter("af", 0.);        //  [1]

 formula = InitParameter("formula", 0);  //   [1]
 if(formula < 0)  formula = 0;
 if(formula > 15) formula = 15;

}
eQDDGamma::~eQDDGamma (){}

void eQDDGamma::
compute (const Input& input, Output& output)
{
  const pmi_float& c = input.c; // carrier density
  const pmi_float& t = input.t; // carrier temperature
  const pmi_float& f = input.f; // Enormal to interface
  const pmi_float& h = input.h; // layer thickness

  double x, y, z;
  input.ReadCoordinate (x, y, z);
  pmi_float gxy = g0 + ax*x/x0 + ay*y/y0;

  pmi_float gc = 1.;
  pmi_float gt = 1.;
  pmi_float gf = 1.;
  pmi_float gh = 1.;

  if(formula & is_c) {
   const pmi_float n  = (c < 1e-4 ? 1e-4 : c);
   const pmi_float xc = log(n/c0)*log(n/c0);
   gc = exp(xc/(1.+xc));
  }
  if(formula & is_t) {
   const pmi_float xt = (t-300)/cT0;
```

39: Physical Model Interface

Various

```cpp
      gt = exp(xt);
    }
    if(formula & is_f) {
      const pmi_float xf = (f - f1)/f0;
      gf = 1. + af*xf*xf;
    }
    if(formula & is_h) {
      const pmi_float xh = h/h0;
      gh = 1. + ah*(xh - 1.);
    }

    output.gamma = gxy*gc*gt*gf*gh;
  }

  extern "C"
  PMI_QDDGamma_Base* new_PMI_QDDGamma_Base
    (const PMI_Environment& env)
  {
    return new eQDDGamma(env);}
```

# Heavy Ion Spatial Distribution

The spatial distribution function $R(w, l, E)$ can be defined by a PMI (see Carrier Generation by Heavy Ions on page 722).

The name of the PMI must be specified in the `Physics` section of the command file as follows:

```
  Physics {
    HeavyIon(
      SpatialShape = PMI_shape_name
    )
  }
```

or:

```
  Physics {
    HeavyIon(
      SpatialShape = PMI_shape_name(Energy = value)  # [eV]
    )
  }
```

Various

## Dependencies

The spatial distribution function $R(w, l, E)$ depends on the following variables:

*   $w$ Radius defined as the perpendicular distance from the track [cm]
*   $l$ Coordinate along the track [cm]
*   $E$ Energy of heavy ion [eV]

The PMI model must compute the following result:

*   $R$ The value of the spatial distribution $R(w, l, E)$ [1]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_SpatialDistributionFunction: public PMI_Vertex_Interface {
// * The spatial distribution function:
// *
// *     R(w,l,E)
// *
// * where
// *     - l is the coordinate along the particle path [um];
// *     - w is radial coordinate orthogonal to l [um];
// *     - E is energy of heavy ion [eV];

public:
  PMI_SpatialDistributionFunction (const PMI_Environment& env,
                                   const char* IonType);

  virtual ~PMI_SpatialDistributionFunction ();

// user-defined name of heavy ion (see Using the Alpha Particle Model on
page 721)
const char* GetHeavyIonType () const;

// methods to be implemented by user
  virtual void Compute_R (double& R, const double w, const double l = -1.,
                          const double E = -1.) = 0;

};
```

39: Physical Model Interface

Various

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_SpatialDistributionFunction*
  new_PMI_SpatialDistributionFunction_func
    (const PMI_Environment& env, const char* HeavyIonName);
new_PMI_SpatialDistributionFunction_func new_PMI_SpatialDistributionFunction;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_SpatialDistributionFunction_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
  public:
    pmi_float w;  // radius (perpendicular distance from track)
    pmi_float l;  // coordinate along track
    pmi_float E;  // energy of heavy ion
  };

  class Output {
  public:
    pmi_float R;  // spatial distribution
  };

  PMI_SpatialDistributionFunction_Base (const PMI_Environment& env,
                                        const char* name);
  virtual ~PMI_SpatialDistributionFunction_Base ();

  const char* GetHeavyIonType () const;

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_SpatialDistributionFunction_Base*
  new_PMI_SpatialDistributionFunction_Base_func
    (const PMI_Environment& env, const char* HeavyIonName);
extern "C" new_PMI_SpatialDistributionFunction_Base_func
  new_PMI_SpatialDistributionFunction_Base;
```

39: Physical Model Interface

Various

# Example: Gaussian Spatial Distribution Function

The built-in Gaussian spatial distribution function (see Carrier Generation by Heavy Ions on page 722) can also be implemented as a PMI model:

```cpp
#include "PMIModels.h"

class Gaussian_SpatialDistributionFunction : public
PMI_SpatialDistributionFunction {

public:
  Gaussian_SpatialDistributionFunction (const PMI_Environment& env,
  const char* HeavyIonName);
  ~Gaussian_SpatialDistributionFunction ();

  void Compute_R
  (double& R, const double w, const double l, const double E);
};

Gaussian_SpatialDistributionFunction::
Gaussian_SpatialDistributionFunction (const PMI_Environment& env, const char*
HeavyIonName) :
  PMI_SpatialDistributionFunction (env, HeavyIonName)
{}

Gaussian_SpatialDistributionFunction::
~Gaussian_SpatialDistributionFunction ()
{}

void Gaussian_SpatialDistributionFunction::
Compute_R(double& R, const double w, const double l, const double E)
{
  // the unit w,l is [cm]
  // the unit E is [eV] (in this implementation not used)
  // R(w,l,E) = exp( -(w/wt(l))^2 )

  double wt = 1.e-4; // scaling factor 1um = 1.e-4cm
  double x = w/wt;

  R = exp(-x*x);

}

extern "C"
PMI_SpatialDistributionFunction* new_PMI_SpatialDistributionFunction
 (const PMI_Environment& env, const char* HeavyIonName)
{
 return new Gaussian_SpatialDistributionFunction (env, HeavyIonName);
}
```

39: Physical Model Interface
Various

# Hot-Carrier Injection

Sentaurus Device provides a PMI for implementing hot-carrier injection models and computing the injection currents defined by the model. It is activated in the Physics interface section of the command file, `GateCurrent` subsection:

```
Physics(MaterialInterface="Silicon/Oxide"){
  GateCurrent( PMI_model(electron) )
}
```

The model can be used for both carrier types with either `PMI_model(electron hole)` or `PMI_model()`. The interface has access to the device mesh and device data (see Runtime Support for Vertex-Based Multistate Configuration–Dependent Models on page 1202).

## Dependencies

A hot-carrier PMI model has no explicit dependencies. However, it can depend on any field at runtime using the access to device data. The model must compute:

**gCurr** Vector of region/interface arrays with hot-carrier injection current densities; each region/interface array consists of the current density in each vertex of a region interface.

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_HotCarrierInjection : public PMI_Device_Interface {

protected:
  const PMI_CarrierType cType;

public:
  PMI_HotCarrierInjection (const PMI_Device_Environment& env,
         const PMI_CarrierType cType);
  virtual ~PMI_HotCarrierInjection ();

  virtual void Compute_gCurr
         (const des_regioninterface_vector& regioninterfaces,
                            // region interfaces associated with the model
         des_array_vector& gCurr) = 0; // gate injection current in each vertex
                                      // of specified region interfaces
};
```

Various

Two virtual constructors are required for electron and hole hot injection:

```cpp
typedef PMI_HotCarrierInjection* new_PMI_HotCarrierInjection_func
  (const PMI_Device_Environment& env, const PMI_CarrierType carType);
extern "C" new_PMI_HotCarrierInjection_func new_PMI_e_HotCarrierInjection;
extern "C" new_PMI_HotCarrierInjection_func new_PMI_h_HotCarrierInjection;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_HotCarrierInjection_Base : public PMI_Device_Base {

public:
  class Input : public PMI_Device_Input_Base {
  public:
    des_regioninterface_vector regioninterfaces; // region interfaces
                                                 // associated with model
                                                 // name
  };

  class Output {
  public:
    sdevice_array_vector gCurr; // gate injection current in each vertex
                                // of specified region interfaces
  };

  PMI_HotCarrierInjection_Base (const PMI_Device_Environment& env);
  virtual ~PMI_HotCarrierInjection_Base ();

  virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_HotCarrierInjection_Base* new_PMI_HotCarrierInjection_Base_func
  (const PMI_Device_Environment& env);
extern "C" new_PMI_HotCarrierInjection_Base_func
  new_PMI_e_HotCarrierInjection_Base;
extern "C" new_PMI_HotCarrierInjection_Base_func
  new_PMI_h_HotCarrierInjection_Base;
```

39: Physical Model Interface
Various

# Example: Lucky Hot-Carrier Injection

The following example reimplements the built-in lucky injection model for electrons using the hot-carrier injection PMI:

```cpp
#include <math.h>
#include "PMIModels.h"

class PMI_LuckyModel : public PMI_HotCarrierInjection {
private:
  const des_mesh* mesh;  //device mesh
  des_data* data;  //device data
  const double*const* measure;
  const double*const* surface_measure;
public:
  PMI_LuckyModel(const PMI_Device_Environment& env,
                 const PMI_CarrierType carType);
  ~PMI_LuckyModel();
  void Compute_gCurr(const des_regioninterface_vector& regioninterfaces,
                     des_array_vector& gCurr);
};

PMI_LuckyModel::
PMI_LuckyModel(const PMI_Device_Environment& env,
        const PMI_CarrierType carType) :
  PMI_HotCarrierInjection(env, carType)
{
  mesh = Mesh();
  data = Data();
  measure = data->ReadMeasure();
  surface_measure = data->ReadSurfaceMeasure();
}

PMI_LuckyModel::
~PMI_LuckyModel()
{
}

void PMI_LuckyModel::
Compute_gCurr(const des_regioninterface_vector& regioninterfaces,
        des_array_vector& gCurr)
{
  //compute current for each des_regioninterface associated with model
  for(int inter=0; inter < regioninterfaces.size(); inter++) {
    for(int k=0; k < regioninterfaces.at(inter)->size_vertex(); k++)
      gCurr[inter][k] = 0.0;

    des_regioninterface* ri = regioninterfaces.at(inter);
```

Various

```cpp
    des_bulk* b1 = ri->bulk1();
    des_bulk* b2 = ri->bulk2();

    //recognize regioninterface or regioninterface category
    if(((b1->material() == "Silicon") && (b2->material() == "Oxide")) ||
       ((b1->material() == "Oxide") && (b2->material() == "Silicon"))) {

        des_bulk* semReg;
        des_bulk* insReg;
        if((b1->material() == "Silicon") && (b2->material() == "Oxide")) {
            semReg = b1;
            insReg = b2;
        }
        if((b2->material() == "Silicon") && (b1->material() == "Oxide")) {
            semReg = b2;
            insReg = b1;
        }

        //read region interface constants
        double eLambd = 8.9000e-07;//eLsem
        double eLambdR = 6.2000e-06;//eLsemR
        double eOxLambd = 3.2000e-07;//eLins
        double eBarrierHeight = 3.1;//eBar0
        double eAlfa = 2.6000e-04;//eBL12
        double eBeta = 3.0000e-05;//eBL23

        //read DataEntries used in computation
        const double* pot =
            data->ReadScalar(des_data::vertex, "ElectrostaticPotential");
        const double* OxField =
            data->ReadScalar(des_data::vertex, "InsulatorElectricField");
        const double* Epsilon =
            data->ReadScalar(des_data::element, "DielectricConstant");
        const double* eCurrent = NULL;
        const double* eField = NULL;
        if(cType == PMI_Electron) {
            eCurrent = data->ReadScalar(des_data::vertex, "eCurrentDensity");
            eField = data->ReadScalar(des_data::vertex, "eEparallel");
        }

        //integrate over the corresponding semiconductor region
        for(size_t vi = 0; vi < semReg->size_vertex(); vi++) {
            des_vertex* rv = semReg->vertex(vi);

            //find the nearest interface vertex
            //(distance to interface)
            des_vertex* NearestInterVertex;
            int NearestInterVertexRIind;
```

39: Physical Model Interface
Various

```cpp
double NearestDistance = 1.0e50;
for(size_t k=0; k < ri->size_vertex(); k++) {
  des_vertex* interVert = ri->vertex(k);
  bool isSemiconductor = false;
  for(size_t i = 0; i < interVert->size_region(); i++) {
    des_bulk* b = dynamic_cast<des_bulk*>(interVert->region(i));
    if(b->material() == "Silicon") {
      isSemiconductor = true;
    }
  }
  if(isSemiconductor) {
    double dist = 0.0;
    for(int kk=0; kk < mesh->dim(); kk++)
      dist += (interVert->coord()[kk] - rv->coord()[kk])*
      (interVert->coord()[kk] - rv->coord()[kk]);
    dist = sqrt(dist);
    if(dist < NearestDistance) {
      NearestDistance = dist;
      NearestInterVertex = interVert;
      NearestInterVertexRIind = k;
    }
  }
}//nearest interface vertex

//find the nearest gate contact vertex
//(distance from NearestIntVertex to gate contact)
des_vertex* NearestContVertex;
double NearestContDistance = 1.0e50;
for(size_t k=0; k < insReg->size_vertex(); k++) {
  des_vertex* vins = insReg->vertex(k);
  if(vins->size_region() > 1) {
    for(size_t vvr = 0; vvr < vins->size_region(); vvr++) {
      des_region* rr = vins->region(vvr);
      if(rr->type() == des_region::contact) {
        //contact vertex
        double dist = 0.0;
        for(int kk=0; kk < mesh->dim(); kk++)
          dist += (vins->coord()[kk] - NearestInterVertex->coord()[kk])*
          (vins->coord()[kk] - NearestInterVertex->coord()[kk]);
        dist = sqrt(dist);
        if(dist < NearestContDistance) {
          NearestContDistance = dist;
          NearestContVertex = vins;
        }
      }//contact vertex
    }
  }
}//nearest gate contact vertex
```

1435

Various

```cpp
//coordinates and distances are in um
//transform to cm
double OxThickn = NearestContDistance*1.0e-4;
double DistToSurf = NearestDistance*1.0e-4;

double xEps[3] = {0.0, 0.0, 0.0};
for(int k = 0; k < mesh->dim(); k++)
    xEps[k] = 0.5*(NearestInterVertex->coord()[k]
                + NearestContVertex->coord()[k]);
des_element* xEl;
//find the oxide element
for(size_t ei = 0; ei < insReg->size_element(); ei++) {
    des_element* e = insReg->element(ei);
    for(size_t evi = 0; evi < e->size_vertex(); evi++) {
        double minCoord[3] = {1.0e50, 1.0e50, 1.0e50};
        double maxCoord[3] = {-1.0e50, -1.0e50, -1.0e50};
        des_vertex* ev = e->vertex(evi);
        for(int i = 0; i < mesh->dim(); i++) {
            if(ev->coord()[i] < minCoord[i])
                minCoord[i] = ev->coord()[i];
            if(ev->coord()[i] > maxCoord[i])
                maxCoord[i] = ev->coord()[i];
        }
        for(int i = 0; i < mesh->dim(); i++) {
            if( (xEps[i] >= minCoord[i]) && (xEps[i] >= minCoord[i]) ) {
                xEl = e;
            }
        }
    }
}
double OxConst = Epsilon[xEl->index()];
double OxImage0 = 1.6e-19/16/3.1452/8.85e-14/OxConst;

//for electrons
if(cType == PMI_Electron) {
    double eCur = 0.0;
    double eOxField = pot[NearestContVertex->index()]
        -pot[NearestInterVertex->index()];
    eOxField = eOxField > 0
        ? OxField[NearestInterVertex->index()]
        : -OxField[NearestInterVertex->index()];
    double barrier;
    if(pot[NearestInterVertex->index()]
        < pot[NearestContVertex->index()])
        barrier = eBarrierHeight
            - eAlfa*sqrt(fabs(eOxField))
            - eBeta*pow(fabs(eOxField),2.0/3.0);
```

39: Physical Model Interface
Various

```cpp
else
  barrier = eBarrierHeight
    + (pot[NearestInterVertex->index()] -
       pot[NearestContVertex->index()])
    - eAlfa*sqrt(fabs(eOxField))
    - eBeta*pow(fabs(eOxField),2.0/3.0);
if(barrier < 0) barrier = 0.0;
double eBarrierLoc = barrier;
double p1 = 0.0;
double eEnergy = eField[rv->index()]*eLambd;
if(eEnergy > 1.0e-30) {
  p1 = 0.25;
  if (eBarrierLoc > 1.0e-30)
    p1 = 0.25*eEnergy/eBarrierLoc*exp(-eBarrierLoc/eEnergy);
}
double p2 = exp(-DistToSurf/eLambd);
double eDistFromSurf = 1.0e30;
if (eOxField > 1.0e-30) eDistFromSurf = sqrt(OxImage0/eOxField);
double p3 = exp(-eDistFromSurf/eOxLambd);

//find the node measure
double node_measure = 0.0;
for(size_t ei = 0; ei < rv->size_element(); ei++) {
  des_element* e = rv->element(ei);
  des_bulk* bulk = e->bulk();
  if(bulk->material() == "Silicon") {
    for(size_t evi = 0; evi < e->size_vertex(); evi++) {
      des_vertex* ev = e->vertex(evi);
      if(ev->index() == rv->index()) {
        node_measure += measure[e->index()][evi];
      }
    }
  }//semiconductor element
}//node measure

//convert measure in cm^dim
node_measure = node_measure*pow(1.0e-4,mesh->dim());

eCur = eCurrent[rv->index()]*p1*p2*p3*node_measure/eLambdR;
double risurface =
  surface_measure[ri->index()][NearestInterVertexRIind];
//convert to cm^(dim-1)
risurface = risurface*pow(1.0e-4,(mesh->dim()-1));
gCurr[inter][NearestInterVertexRIind] += eCur/risurface;
}

//for holes
if(cType == PMI_Hole) {
```

1437

Various

```cpp
      }
    }//end integration on semiconductor region
  }//end model implementation
}//end loop over "PMI_HotCarrierInjection" model regioninterfaces
}

extern "C" {
  PMI_HotCarrierInjection* new_PMI_e_HotCarrierInjection
            (const PMI_Device_Environment& env, const PMI_CarrierType carType)
  {
    return new PMI_LuckyModel(env, carType);
  }
}

extern "C" {
  PMI_HotCarrierInjection* new_PMI_h_HotCarrierInjection
            (const PMI_Device_Environment& env, const PMI_CarrierType carType)
  {
    return new PMI_LuckyModel(env, carType);
  }
}
```

## Incomplete Ionization

The ionization factors $G_{\text{D}}(T)$ and $G_{\text{A}}(T)$ (see Incomplete Ionization Model on page 294) can be defined by a PMI.

The name of the PMI should be specified in the `Physics` section of the command file as follows:

```
Physics {
  IncompleteIonization( Model( PMI_model_name("Species_name1
    Species_name2 ...") ) )
}
```

In addition, it is possible to have a PMI for each species separately:

```
Physics {
  IncompleteIonization(
    Model(
      PMI_model_name1("Species_name1")
      PMI_model_name2("Species_name2")
    )
  )
}
```

**39: Physical Model Interface**
Various

The species PMI parameters should be defined in the parameter file (see Parameter File of Sentaurus Device on page 1189).

## Dependencies

The ionization factors $G_D(T)$ and $G_A(T)$ can depend on the variable:

t Lattice temperature [K]

The PMI model must compute the following results:

g Ionization factor $G(T)$

In the case of the standard interface, the following derivative must be computed as well:

dgdt Derivative of $G(T)$ with respect to T

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
enum PMI_SpeciesType {
  PMI_acceptor,
  PMI_donor
};

class PMI_DistributionFunction : public PMI_Vertex_Interface {

private:
  const PMI_SpeciesType speciesType;
  const char* speciesName;

public:
  PMI_DistributionFunction (const PMI_Environment& env,
                            const char* name
                            const PMI_SpeciesType type = PMI_acceptor);

  virtual ~PMI_DistributionFunction ();

  PMI_SpeciesType SpeciesType () const { return speciesType; }
  const char* SpeciesName () const { return speciesName; }

  // read parameter from Sentaurus Device parameter file
  // (override for PMI_Vertex_Interface::ReadParameter)
```

Various

```cpp
  const PMIBaseParam* ReadParameter (const char* name) const;

  // initialize parameter from Sentaurus Device parameter file or from default
  // value (override for PMI_Vertex_Interface::InitParameter)
  double InitParameter (const char* name, double defaultvalue) const;

  virtual void Compute_g
   (const double T,         // lattice temperature
    double& g) = 0;         // g = G(T)

  virtual void Compute_dgdt
   (const double T,         // lattice temperature
     double& dgdt) = 0;     // dgdt = G’(T)

 };
```

The prototype for the virtual constructor is given as:

```cpp
 typedef PMI_DistributionFunction* new_PMI_DistributionFunction_func
   (const PMI_Environment& env);
 extern "C" new_PMI_DistributionFunction_func new_PMI_DistributionFunction;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
 class PMI_DistributionFunction_Base : public PMI_Vertex_Base {

 public:
   class Input : public PMI_Vertex_Input_Base {
   public:
     pmi_float t; // lattice temperature
   };

   class Output {
   public:
     pmi_float g; // ionization factor
   };

   PMI_DistributionFunction_Base (const PMI_Environment& env,
                                const char* name,
                                const PMI_SpeciesType type = PMI_acceptor);
   virtual ~PMI_DistributionFunction_Base ();

   PMI_SpeciesType SpeciesType () const;
   const char* SpeciesName () const;

   const PMIBaseParam* ReadParameter (const char* name) const;
```

39: Physical Model Interface
Various

```cpp
    double InitParameter (const char* name, double defaultvalue) const;

    virtual void compute (const Input& input, Output& output) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_DistributionFunction_Base* new_PMI_DistributionFunction_Base_func
    (const PMI_Environment& env, const char* name, const PMI_SpeciesType type);
extern "C" new_PMI_DistributionFunction_Base_func
    new_PMI_DistributionFunction_Base;
```

# Example: Matsuura Incomplete Ionization

The following C++ code implements the Matsuura model [1] for dopant Al in SiC material:

$$ G_A(T) = 4 \exp \left( \frac{\Delta E_A - E_{ex}}{kT} \right) \cdot \left( g_1 + \sum_{r=2} g_r \exp \left( \frac{\Delta E_r - \Delta E_A}{kT} \right) \right) $$ (1351)

where $g_1$ is the ground-state degeneracy factor, $g_r$ is the $(r - 1)$-th excited state degeneracy factor, and $\Delta E_r$ is the difference in energy between the $(r - 1)$-th excited state level and $E_V$. $\Delta E_r$ is given by the hydrogenic dopant model [2]:

$$ \Delta E_r = 13.6 \cdot \frac{m^*}{m_0 \cdot \varepsilon_s^2} \cdot \frac{1}{r^2} \quad \text{[eV]} $$ (1352)

where $m^*$ is the hole effective mass in SiC, and $\varepsilon_s$ is the dielectric constant of SiC.

The acceptor level is described as [2]:

$$ \Delta E_A = \Delta E_1 + E_{CCC} $$ (1353)

where $E_{CCC}$ is the energy induced due to central cell corrections.

The ensemble average $E_{ex}$ of the ground and excited state levels of the acceptor is given by [3]:

$$ E_{ex} = \frac{\sum_{r=2} (\Delta E_A - \Delta E_r) g_r \exp \left( - \frac{\Delta E_A - \Delta E_r}{kT} \right)}{g_1 + \sum_{r=2} g_r \exp \left( - \frac{\Delta E_A - \Delta E_r}{kT} \right)} $$ (1354)

Various

The Matsuura model can be implemented as follows:

```cpp
class Matsuura_DistributionFunction : public PMI_DistributionFunction {

protected:
  const double kB_300; // Boltzmann constant * 300   [eV]
  int   nb_item;       // number of item in sum
  double *gr, *dEr;
  double Eex, dEA, Eccc;

public:
  Matsuura_DistributionFunction (const PMI_Environment& env,
                                 const char* name,
                                 const PMI_SpeciesType type = PMI_acceptor);

  ~Matsuura_DistributionFunction ();

  void Compute_g
  (const double T,      // lattice temperature
   double& g);          // g = G(T)

  void Compute_dgdt
  (const double T,      // lattice temperature
   double& dgdt);       // dgdt = G'(T)

  double Compute_Eex(double T);// compute Eex(T) Eq. 1354, p. 1441
  double Compute_dEexdT(double T);// compute dEex/dT

};

Matsuura_DistributionFunction::
Matsuura_DistributionFunction (const PMI_Environment& env,
                               const char* name,
                               const PMI_SpeciesType type) :
  PMI_DistributionFunction (env, name, type),
  kB_300(1.380662e-23*300./1.602192e-19), // kB*T0/e0 = 0.02585199527 [eV]
  Eex(0.)
{
  nb_item = InitParameter ("NumberOfItem", 1);
  Eccc    = InitParameter ("Eccc", 0);

  if(nb_item < 1) {
    printf("ERROR; PMI model Matsuura_DistributionFunction: parameter NumberOfItem < 1 \n");
    exit(1);
  }
  gr = new double[nb_item];
  dEr = new double[nb_item];
```

39: Physical Model Interface
Various

```cpp
 char str_r[6], name_gr[6];

 int r;
 for(r=0; r<nb_item; ++r) {
  name_gr[0] = 'g'; name_gr[1] = '\0';
  sprintf(str_r, "%d\0", r+1);
  strcat(name_gr, str_r);
  const PMIBaseParam* par = ReadParameter(name_gr);
  if(!par) {
    printf("ERROR; PMI model Matsuura_DistributionFunction: cannot read
parameter %s \n", name_gr);
    gr[r] = 2;
  } else
    gr[r] = *par;
 }

 const PMIBaseParam* par = ReadParameter("dE1");
 if(!par) {
 // dE[r] = 13.6 * m_eff/m0/eps/eps/r/r
  Compute_dEr(nb_item, dEr);
 } else {
  char name_dEr[6];
  for(r=0; r<nb_item; ++r) {
    strcpy(name_dEr, "dE");
    sprintf(str_r, "%d\0", r+1);
    strcat(name_dEr, str_r);
    const PMIBaseParam* par = ReadParameter(name_dEr);
    if(!par) {
       printf("ERROR; PMI model Matsuura_DistributionFunction: cannot read
parameter %s \n", name_dEr);
       exit(1);
    }
    dEr[r] = *par;
  }
 }
 dEA = dEr[0] + Eccc;
}

Matsuura_DistributionFunction::
~Matsuura_DistributionFunction ()
{
 delete[] gr;
 delete[] dEr;
}

void Matsuura_DistributionFunction::Compute_g
  (const double T,               // lattice temperature
```

Various

```cpp
      double& g)                        // g = G(T)
{
  const double kT = kB_300*T/300;

  Eex = Compute_Eex(T);
  g = gr[0];

  for(int r=1; r<nb_item; ++r) {
    double delta = dEA - dEr[r];
    g += gr[r]*exp( -delta/kT );
  }
  g *= 4.*exp( (dEA-Eex)/kT );
}

void Matsuura_DistributionFunction::Compute_dgdt
    (const double T,       // lattice temperature
    double& dgdt)          // dgdt = G’(T)
{
  const double kT = kB_300*T/300;

  Eex = Compute_Eex(T);
  double s1, s2 = gr[0], s3, s4 = 0., delta, tmp;

  for(int r=1; r<nb_item; ++r) {
    delta = dEA - dEr[r];
    tmp   = gr[r]*exp( -delta/kT );
    s2    += tmp;
    s4    += tmp*delta/kT/T;                // s4 = ds2/dT
  }

  delta = dEA - Eex;
  s1 = 4.*exp( delta/kT );
  double dEex_dT = Compute_dEexdT(T);
  s3 = s1*( -dEex_dT/kT - delta/kT/T );     // s3 = ds1/dT

  dgdt = s3*s2 + s1*s4;          // dgdt = d(s1*s2)/dT

  return;
}

// Eex is given by Eq. 1354, p. 1441
double Matsuura_DistributionFunction::Compute_Eex(double T)
{
  const double kT = kB_300*T/300;

  double s1 = 0., s2 = gr[0];

  for(int r=1; r<nb_item; ++r) {
```

Various

```cpp
    double delta = dEA - dEr[r];
    double tmp   = gr[r]*exp( -delta/kT );
    s1 += delta*tmp;
    s2 += tmp;
  }

  return s1/s2;

}

double Matsuura_DistributionFunction::Compute_dEexdT(double T)
{
  const double kT = kB_300*T/300;

  double s1 = 0., s2 = gr[0], s3 = 0., s4 = 0.;

  for(int r=1; r<nb_item; ++r) {
    double delta = dEA - dEr[r];
    double tmp   = gr[r]*exp( -delta/kT );
    s1 += delta*tmp;
    s2 += tmp;
    s3 += delta*tmp*delta/kT/T;  // s3 = ds1/dT
    s4 += tmp*delta/kT/T;        // s4 = ds2/dT
  }

  return (s3*s2 - s1*s4)/s2/s2;

}

extern "C"
PMI_DistributionFunction* new_PMI_DistributionFunction
  (const PMI_Environment& env,
   const char* name,
   const PMI_SpeciesType type)
{
  return new Matsuura_DistributionFunction (env, name, type);
}

void Compute_dEr(int nb_item, double* dEr)
{
  // dEr is given by Eq. 1352, p. 1441

  // data from file: 6H-SiC.par
  const double epsilon = 9.66;                  // dielectric constant
  const double mh      = 1;                     // hole effective mass in SiC

  const double E0 = 13.6*mh/epsilon/epsilon;
```

Various

```cpp
    for(int r=1; r<=nb_item; ++r) {
      dEr[r-1] = E0/r/r;
    }
  }
}
```

# Space Factor

The space distribution of the metal workfunction (see Metal Workfunction on page 252), traps (see Energetic and Spatial Distribution of Traps on page 490), the bond concentration (see Using the Trap Degradation Model on page 549), the extended nonradiative multiphonon (eNMP) model precursor concentration (see Using the eNMP Model on page 572), and piezoresistance enhancement factors (see SFactor Dataset or PMI Model on page 943) can be computed by a space factor PMI. The name of the PMI is specified in the appropriate `Physics` section as follows:

```
    Physics (Material | Region = "<name>") {
      MetalWorkfunction (SFactor=pmi_model_name ...)
    }
```

or:

```
    Physics { Traps (SFactor=pmi_model_name ...) }
```

or:

```
    Physics { Traps (BondConcSFactor=pmi_model_name ...) }
```

or:

```
    Physics (MaterialInterface | RegionInterface = "<name1>/<name2>"){
      eNMP (SFactor=pmi_model_name ...)
    }
```

or:

```
    Physics {
      Piezo (
        Model (
          Mobility (
            Factor (
              SFactor=pmi_model_name
              [ChannelDirection=<n>]
              [AutoOrientation | ParameterSetName="<psname>"]
            )
          )
        )
      )
    }
```

39: Physical Model Interface

Various

```cpp
  )
}
```

In the last specification, the `Factor` options `ChannelDirection=<n>`, `AutoOrientation`, and `ParameterSetName="<psname>"`, if specified, are passed as parameters to the space factor PMI model (`AutoOrientation` is passed as `AutoOrientation=1`).

**NOTE** The name of the PMI model must not coincide with the name of an internal field of Sentaurus Device. Otherwise, Sentaurus Device takes the value of the internal field as the space factor.

## Dependencies

A PMI space factor model has no explicit dependencies. The model must compute:

`spacefactor` Space factor (1) or [cm<sup>-3</sup>]

## Standard C++ Interface

The following base class is declared in the file `PMIModels.h`:

```cpp
class PMI_SpaceFactor : public PMI_Vertex_Interface {

public:
  PMI_SpaceFactor (const PMI_Environment& env);
  virtual ~PMI_SpaceFactor ();

  virtual void Compute_spacefactor
    (double& spacefactor) = 0;
};
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_SpaceFactor* new_PMI_SpaceFactor_func
  (const PMI_Environment& env);
extern "C" new_PMI_SpaceFactor_func new_PMI_SpaceFactor;
```

## Simplified C++ Interface

The following base class is declared in the file `PMI.h`:

```cpp
class PMI_SpaceFactor_Base : public PMI_Vertex_Base {

public:
  class Input : public PMI_Vertex_Input_Base {
```

Various

```cpp
    public:
    };

    class Output {
    public:
      pmi_float spacefactor; // space factor
    };

    PMI_SpaceFactor_Base (const PMI_Environment& env);
    virtual ~PMI_SpaceFactor_Base ();

    virtual void compute (const Input& input, Output& output) = 0;
  };
```

The prototype for the virtual constructor is given as:

```cpp
typedef PMI_SpaceFactor_Base* new_PMI_SpaceFactor_Base_func
  (const PMI_Environment& env);
extern "C" new_PMI_SpaceFactor_Base_func new_PMI_SpaceFactor_Base;
```

## Example: PMI User Field as Space Factor

The following code reads the space factor from a PMI user field:

```cpp
#include "PMIModels.h"

class pmi_spacefactor : public PMI_SpaceFactor {

public:
 pmi_spacefactor (const PMI_Environment& env);
 ~pmi_spacefactor ();

 void Compute_spacefactor (double& spacefactor);
};

pmi_spacefactor::
pmi_spacefactor (const PMI_Environment& env) :
 PMI_SpaceFactor (env)
{
}

pmi_spacefactor::
~pmi_spacefactor ()
{
}

void pmi_spacefactor::
Compute_spacefactor (double& spacefactor)
```

39: Physical Model Interface

References

```cpp
{ spacefactor = ReadUserField (PMI_UserField1);
}

extern "C"
PMI_SpaceFactor* new_PMI_SpaceFactor
 (const PMI_Environment& env)
{ return new pmi_spacefactor (env);
}
```

# References

[1] H. Matsuura, “Influence of Excited States of Deep Acceptors on Hole Concentration in SiC,” in *International Conference on Silicon Carbide and Related Materials (ICSCRM)*, Tsukuba, Japan, pp. 679–682, October 2001.

[2] P. Y. Yu and M. Cardona, *Fundamentals of Semiconductors: Physics and Materials Properties*, Berlin: Springer, 2nd ed., 1999.

[3] K. F. Brennan, *The Physics of Semiconductors: With applications to optoelectronic devices*, Cambridge: Cambridge University Press, 1999.

[4] M. G. Ancona, “Density-gradient theory: a macroscopic approach to quantum confinement and tunneling in semiconductor devices,” *Journal of Computational Electronics*, vol. 10, no. 1–2, pp. 65–97, 2011.

[5] P. Bruno, “Interlayer Exchange Interactions in Magnetic Multilayers,” *Magnetism: Molecules to Materials III*, J. S. Miller and M. Drillon (eds.), Wiley-VCH: Weinheim, pp. 329–353, 2002.

[6] M. D. Stiles, “Interlayer Exchange Coupling,” *Ultrathin Magnetic Structures III: Fundamentals of Nanomagnetism*, J. A. C. Bland and B. Heinrich (eds.), Springer: Berlin, pp. 99–142, 2005.

## References

