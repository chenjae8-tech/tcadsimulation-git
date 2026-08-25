CHAPTER 9

# Working With Scheme and Scheme Extensions

*This chapter discusses working with Scheme and Scheme extensions in Sentaurus Structure Editor.*

## Scheme Data Types

The Scheme scripting language is used in Sentaurus Structure Editor and the process emulation module of Sentaurus Structure Editor (Procem).

Table 38 lists the data types that can be used as arguments when calling the Scheme functions in Sentaurus Structure Editor.

Table 38 Data types for Scheme functions related to Sentaurus Structure Editor

<table>
  <thead>
    <tr>
        <th>Data type</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>BOOLEAN</td>
        <td>A native Scheme data type having either the value #t (true) or #f (false). It represents a logical or Boolean value.</td>
    </tr>
    <tr>
        <td>DATEXMAT</td>
        <td>A STRING type variable, containing a valid material name, as defined in the `datexcodes.txt` file. "Silicon" and "Oxide" are valid DATEXMAT variables.</td>
    </tr>
    <tr>
        <td>ELIST</td>
        <td>An ACIS entity list.</td>
    </tr>
    <tr>
        <td>ENTITY</td>
        <td>An ACIS entity.</td>
    </tr>
    <tr>
        <td>GVECTOR</td>
        <td>A GVECTOR entity is an ACIS entity. It contains the keyword `gvector` and it is a composition of three real numbers representing the x-, y-, and z-components of a 3D vector. For example, `(define g1 (gvector 1 0 0))` defines a GVECTOR called g1. `gvector` is an ACIS-defined Scheme data type, used to represent a vector with magnitude and direction. It is called `gvector` only to differentiate it from the inherent Scheme data type `vector`, which represents an array.</td>
    </tr>
    <tr>
        <td>INTEGER</td>
        <td>A Scheme data type containing a single integer value.</td>
    </tr>
    <tr>
        <td>PLIST</td>
        <td>A polygon list: `(list POLYGON POLYGON ... POLYGON)`.</td>
    </tr>
    <tr>
        <td>POLARITY</td>
        <td>Either "light" or "dark".</td>
    </tr>
    <tr>
        <td>POLYGON</td>
        <td>A position list: `(list POSITION POSITION ... POSITION)`.</td>
    </tr>
    <tr>
        <td>POSITION</td>
        <td>A POSITION entity is an ACIS entity. It contains the keyword `position` and three real numbers. For example, `(position 0 0 0)` or `(position -3 -3.1 -3.14)` are valid POSITION entities. `(define p1 (position a b c))` defines a Scheme object p1 that holds a POSITION entity. The x-coordinate of p1 is equal to a, the y-coordinate is equal to b, and the z-coordinate is equal to c.</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>263</page_number>

# 9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

Table 38 Data types for Scheme functions related to Sentaurus Structure Editor

<table>
  <thead>
    <tr>
        <th>Data type</th>
        <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>REAL</td>
        <td>A Scheme data type containing a single real or double value.</td>
    </tr>
    <tr>
        <td>STRING</td>
        <td>A Scheme object containing a text string. A string is enclosed in braces or starts with the character '. Two examples of a string are "this_is_a_valid_string" and 'this_is_also_fine.</td>
    </tr>
    <tr>
        <td>VARIABLE</td>
        <td>A Scheme variable.</td>
    </tr>
  </tbody>
</table>

# Basic Scheme Programming for Users of Sentaurus Structure Editor

Sentaurus Structure Editor uses Scheme, or more precisely, the Elk extension of Scheme. Scheme is a LISP-like programming language that differs significantly from most of the commonly used programming languages. The effective use of Sentaurus Structure Editor (except the GUI layer) requires a working knowledge of Scheme. In addition to the information given in this manuals, there are many resources for learning Scheme, including:

* *R5RS, The Revised Report on the Algorithmic Language Scheme*
  The report is available from [https://schemers.org/Documents/Standards/R5RS/HTML/](https://schemers.org/Documents/Standards/R5RS/HTML/).

* R. K. Dybvig, *The Scheme Programming Language*, Cambridge, Massachusetts: MIT Press, 3<sup>rd</sup> ed., 2003.

* D. P. Friedman and M. Felleisen, *The Little Schemer*, Cambridge, Massachusetts: MIT Press, 4<sup>th</sup> ed., 1996.

* D. P. Friedman and M. Felleisen, *The Seasoned Schemer*, Cambridge, Massachusetts: MIT Press, 1996.

* [https://www.scheme.com](https://www.scheme.com) (website of a Scheme dialect, Chez Scheme)

* [https://schemers.org/](https://schemers.org/) (website of Scheme-related topics)

In the following sections, the Scheme commands that are most commonly used in a Sentaurus Structure Editor script are introduced.

## Basic Scheme Syntax

A Scheme command is enclosed in parentheses (white spaces are allowed):

`(Scheme command)`

<page_number>264</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

All text in a line after a semicolon is treated as a comment:

```scheme
; This is a comment
(Scheme command)    ; This is also a comment
```

A Scheme command can extend over several lines, or several Scheme commands can be placed on a single line. A given Scheme command is identified by the outermost matching parentheses pair:

```scheme
(beginning of Scheme command
 continuation of the same Scheme command
 end of the Scheme command)

(first Scheme command) (second Scheme command) (...)
```

# Defining Simple Variables and Data Types

Integers and floating-point numbers are treated as numbers. To declare and define a numeric variable:

```scheme
(define i 3)
(define pi 3.141593)
```

Strings are enclosed in double quotation marks. To declare and define a string:

```scheme
(define W "Hello World")
```

Characters are preceded by #\\. To declare and define a character:

```scheme
(define CHAR #\a)
```

Use the variable name to reference a variable:

```scheme
i       ;-> 3
pi      ;-> 3.141593
W       ;-> "Hello World"
CHAR    ;-> #\a
```

Update an existing variable with `set!`:

```scheme
(define j 1)
(set! j (+ j 1))
j ;-> 2
```

Sentaurus™ Structure Editor User Guide

<page_number>265</page_number>

S-2021.06

# 9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

**NOTE** Use `define` when a variable is introduced for the first time. Use `set!` to assign a new value to an existing variable.

The `define` command creates a local variable (lexical scoping). For example, a variable defined in a specific function is not visible in another function or in the main program. Different procedures can have their own private variables defined using the same variable name. The `set!` command does not alter the scope of already defined variables, while redefining a preexisting variable might alter its scope. Scheme variables need not be deleted explicitly. An automatic garbage collector will remove all Scheme variables when they go out of scope. Memory allocation or deallocation is performed automatically by Scheme.

Do not use the Scheme keyword `length` as a user-defined variable.

Scheme is case sensitive.

## Printing Text to Standard Output

Use the `display` command to write to standard output. Use `newline` to create a line break:

```scheme
(display "The value of i is ")  (display i)  (newline)
(display "The value of pi is ") (display pi) (newline)
(display "The string W contains >") (display W) (display "<") (newline)

;-> The value of i is 3
;-> The value of pi is 3.141593
;-> The string W contains >Hello World<
```

## String Operations

To automatically generate identifiers, for example, region names, certain string operations are useful.

To define a string:

```scheme
(define TEXTSTRING "This is a string")
```

To determine the length of a string:

```scheme
(define STRINGLENGTH (string-length TEXTSTRING))
STRINGLENGTH ;-> 16
```

<page_number>266</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

To retrieve the k-th character of a string:

```scheme
(define k 5)
(define kthCHARACTER (string-ref TEXTSTRING k))
kthCHARACTER ;-> #\i
```

**NOTE** The index counter starts from 0.

To retrieve substrings:

```scheme
(define iStart 10)
(define iEnd 16)
(define SUBSTRING (substring TEXTSTRING iStart iEnd))
SUBSTRING ;-> "string"
```

To concatenate two strings:

```scheme
(define RNAME "Region.")
(define QUALIFIER "Substrate")
(define REGIONNAME (string-append RNAME QUALIFIER))
REGIONNAME ;-> "Region.Substrate"
```

To convert a number (index) to a string:

```scheme
(define RNAME "Region.")
(define INDEX 3)
(define REGIONNAME (string-append RNAME (number->string INDEX)))
REGIONNAME ;-> "Region.3"
```

# Lists

Some Sentaurus Structure Editor commands accept lists as arguments. Lists can also be useful in device parameterization. To define a list:

```scheme
(define ABCList (list #\a #\b #\c #\d #\e)) ; List of characters
(define NUMList (list 1 2 3 4 5 6))         ; List of numbers
(define MIXList (list #\a 2 3.1415 "TCL"))  ; Mixed list
(define EMPTYList (list))                   ; Empty list
```

**NOTE** Declare an empty list first if you want to append to it, for example, in a do loop.

To reference a list as a whole, use the list name:

```scheme
ABCList   ;-> (#\a #\b #\c #\d #\e)
NUMList   ;-> (1 2 3 4 5)
MIXList   ;-> (#\a 2 3.1415 "TCL")
EMPTYList ;-> ()
```

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>267</page_number>

# 9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

To determine the number of elements in a list:

```scheme
(define NumberOfElements (length ABCList))
NumberOfElements ;-> 5
```

To append an element to a list:

```scheme
(define NewElement #\f)
(define ABCPlusList (append ABCList (list NewElement)))
ABCPlusList ;-> (#\a #\b #\c #\d #\e #\f)
```

To concatenate two lists:

```scheme
(define CombinedList (append ABCList NUMList))
CombinedList ;-> (#\a #\b #\c #\d #\e 1 2 3 4 5 6)
```

To reverse a list:

```scheme
(define ReverseList (reverse NUMList))
ReverseList ;-> (6 5 4 3 2 1)
```

To reference the first element of a list:

```scheme
(define FirstElement (car ABCList))
FirstElement ;-> #\a
```

or:

```scheme
(define FirstElement (list-ref ABCList 0))
```

To reference all but the first element of a list:

```scheme
(define RestOfList (cdr ABCList))
RestOfList ;-> (#\b #\c #\d #\e)
```

To reference the k-th element in a list:

```scheme
(define k 3)
(define kthElement (list-ref ABCList k))
kthElement ;-> #\d
```

**NOTE** The numbering of list elements starts at 0.

To reference a sublist containing all but the first k elements, use:

```scheme
(define k 3)
(define kRestOfList (list-tail ABCList k))
kRestOfList ;-> (#\d #\e)
```

<page_number>268</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

# Arithmetic Expressions

Some of the most useful arithmetic operators are:

*   Addition, subtraction, multiplication, and division: `+`, `-`, `*`, `/`

*   Trigonometric and related functions: `sin`, `cos`, `tan`, `asin`, `acos`, `atan`

*   Exponential and related functions: `exp`, `log`, `sqrt`

*   Raising a to the power of b: `expt a b`

*   Rounding functions: `floor`, `ceiling`, `truncate`, `round`

*   Maximum and minimum: `max`, `min`: `(max x1 x2 ...)`, `(min x1 x2 ...)`

*   Other math functions defined in Sentaurus Structure Editor: `erf`, `erfc`

    (These functions are not part of the standard Scheme language; they are defined locally in Sentaurus Structure Editor.)

Scheme uses the so-called polish-reverse notation for arithmetic expressions:

To define the variable `j` and assign it to i+5:

```scheme
(define j (+ i 5))
j ;-> 8
```

To set the variable `myangle` to `sin(PI/2)`:

```scheme
(define myangle (sin (/ PI 2)))
myangle ;-> 1.0
```

To set the variable `x` to `xo + R*cos(2*PI*fi/360)`:

```scheme
(define xo 1)
(define R 0.2)
(define fi 30)
(define x (+ xo (* R (cos (/ (* 2 PI fi) 360)))))
x ;-> 1.17320508075689
```

# Boolean Operations

True and false constants are denoted by `#t` and `#f`, respectively. Use `not` to invert a Boolean:

```scheme
(not #t) ;-> #f
```

Sentaurus™ Structure Editor User Guide

S-2021.06
<page_number>

269
</page_number>

# 9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

Numeric comparators are =, >, >=, <, <=, for example:

```scheme
(=  1 2) ;-> #f
(>  1 2) ;-> #f
(>= 1 2) ;-> #f
(<  1 2) ;-> #t
(<= 1 2) ;-> #t
```

Use the `equal?` operator to test if two variables are equal:

```scheme
(define a 1)
(define b "hello")
(equal? a b) ;-> #f

(set! b 1)
(equal? a b) ;->#t
```

To test two strings, you can also use `string=?`:

```scheme
(define a "HELLO")
(define b "hello")
(string=? a b) ;-> #f
```

The `equal?` operator can also be used to test ACIS entities:

```scheme
(define a (position 0 0 0))
(define b (position 0 0 0))
(equal? a b) ;-> #t

(set! b (position 1 0 0))
(equal? a b) ;-> #f
```

## If Blocks

To create a simple If block:

```scheme
(define val 0)
(if (= val 0)
  (begin
    (display "val is zero") (newline)
  )
) ;-> "val is zero"
```

To create an If-Else block:

```scheme
(define val -1)
(if (< val 0)                   ; Test
  (begin                        ; Execute if condition is true
    (display "val is negative") (newline)
```

<page_number>270</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

```scheme
 )
 (begin                      ; Execute if condition is false
   (display "val is positive") (newline)
 )
) ;-> "val is negative"
```

To create an If-Elseif block:

```scheme
(define val -1)
(cond
 ((= val 0)                  ; First test
   (begin                    ; Execute if first condition is true
      (display "val is zero") (newline)
   )
 )
 ((> val 0)                  ; Elseif test
   (begin                    ; Execute second condition is true
      (display "val is positive") (newline)
   )
 )(else
   (begin                    ; Execute if none of the conditions are true
      (display "val is negative") (newline)
   )
 )
)) ;-> "val is negative"
```

**NOTE** To *comment out* a large block of comments in a script, enclose the block in a trivial If block:

```scheme
(if #f (begin
      <commands to be "commented out">
))
```

# Simple Do Loops

In this example, a simple Do loop is used to create a stack of five silicon squares:

```scheme
(sde:clear)
(define L 1)      ; Side length of first square
(define Y 0)      ; Bottom Y coordinate of current square
(do ( (i 0 (+ i 1)) ) ; i: Counter name; 0: initial value; (+ i 1): incrementer
 ( (= i 5) )      ; End Tester
 (begin           ; Body of loop
  (define REGION (string-append "region." (number->string i)))
  (sdegeo:create-rectangle
   (position (* -0.5 L)   Y     0.0)
   (position (* 0.5 L) (+ Y L) 0.0) "Silicon" REGION)
  (set! Y (+ Y L))
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>271</page_number>

# 9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

```scheme
      (set! L (* 0.75 L))
    )
  )
```

**NOTE** Scheme Do loops are more flexible than Do loops in most other languages. This example illustrates a basic setup.

---

## For Each Loops

In a For Each loop, an action is taken for each element in a list. In the following example, the For Each loop steps through the lists MATERIALS, WIDTHS, and HEIGHTS, and creates a rectangle for each list element:

```scheme
(sde:clear)
(define MATERIALS (list "GaAs" "AlGaAs" "AlAs" "InAlAs" "InAs" "InAsP" "InP"))
(define WIDTHS    (list 2.0    1.7      1.5    1.3      1.1    1.0     0.5))
(define HEIGHTS   (list 1.0    0.25     0.1    0.25     0.3    0.45    1.0))
(define Y 0)

(for-each
  (lambda (MATERIAL WIDTH HEIGHT)      ; Names of local variables
    (begin                             ; Body of the loop
      (define REGION (string-append "region." MATERIAL))
      (sdegeo:create-rectangle
              (position 0             Y        0.0)
              (position WIDTH (+ Y HEIGHT) 0.0) MATERIAL REGION)
      (set! Y (+ Y HEIGHT))
    )
  ) MATERIALS WIDTHS HEIGHTS           ; Lists
)
```

---

## Procedures

Procedures can be implemented to reuse common code sections or to structure your scripts. The following example creates a ‘Unit Cell’ structure consisting of a slab of silicon with a shallow trench isolation (STI)– like oxide trench at the side. The procedure takes the coordinate of the lower-left corner as an argument:

```scheme
(sde:clear)
(define CreateUnitCell                 ; Name of procedure
  (lambda (Xo Yo)                      ; Argument list
    (begin                             ; Body of procedure
      (sdegeo:set-default-boolean "ABA")
      (define SiREGION (string-append "R.Silicon."
```

<page_number>272</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

9: Working With Scheme and Scheme Extensions

Basic Scheme Programming for Users of Sentaurus Structure Editor

```scheme
      (number->string Xo) "." (number->string Yo)))
    (define OxREGION (string-append "R.Oxide."
      (number->string Xo) "." (number->string Yo)))
    (sdegeo:create-rectangle
      (position Xo Yo 0.0)
      (position (+ Xo 1.0) (+ Yo 1.0) 0.0) "Silicon" SiREGION)
    (sdegeo:create-rectangle
      (position Xo Yo 0.0)
      (position (+ Xo 0.25) (+ Yo 0.75) 0.0) "Oxide" OxREGION)
   )
  )
 )
```

Now, a row of these unit cells can be created by calling the procedure for different arguments:

```scheme
(CreateUnitCell 1 1) ; Procedure calls
(CreateUnitCell 2 1)
(CreateUnitCell 3 1)
```

The next example shows a procedure, which returns a value. The variable containing the value of interest is simply referenced in the last statement of the procedure:

```scheme
(define convert-degree-to-radians
  (lambda (DEG)
    (define pi (acos -1.0))
    (define RAD (* DEG (/ PI 180.0)))
    RAD
  )
)

(define DEG 90)
(define RAD (convert-degree-to-radians 90))
RAD ;-> 1.5707963267949
```

Scheme procedures, or any other code segments, can be saved in a library file, for example, `util.scm` and loaded into a Scheme script with:

```scheme
(load "util.scm")
```

# System Calls

To call an external UNIX or TCAD Sentaurus utility:

```scheme
(system:command "<Unix command string>")
```

For example, to remove the temporary file `test_bnd.tdr`, use:

```scheme
(system:command "rm -f test_bnd.tdr")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>273</page_number>

**9: Working With Scheme and Scheme Extensions**

Basic Scheme Programming for Users of Sentaurus Structure Editor

---

# Error Signaling to Sentaurus Workbench

If the command `system:command` is used in a Sentaurus Structure Editor script and you want to signal the status of the executed command back to Sentaurus Workbench, use the following solution:

```scheme
(define res (system:command "Mycommand ..."))
(if (not (equal? res 0))
  (begin
    (sde:error "Mycommand failed ...")
  )
)
```

If `system:command` returns an error (anything else than 0), Sentaurus Workbench will pick up the error signal, and the executed node will be shown as red.

<page_number>274</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

