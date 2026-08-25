# CHAPTER 11 Miscellaneous Utilities

*This chapter outlines additional features that are available in Sentaurus Structure Editor.*

# Background Image Loader

Sentaurus Structure Editor supports the creation of device geometries by digitizing images, for example, transmission electron micrographs (TEMs). These images can be loaded as a background image into the view window. Table 40 lists the relevant Scheme extensions.

**NOTE** This feature is accessible only using Scheme commands in the command-line window.

The image loader supports only images in the older GIF format, GIF87a. Most current graphic programs use the GIF format GIF89a. To check the format version of a GIF file, look at the first line of the file using, for example, the UNIX command:

```bash
> head --lines=1 filename.gif
```

The first six characters are either GIF87a or GIF89a. If the GIF file is in GIF89 format, use an older graphics utility program such as xv 3.10a (a shareware program written by John Bradley) to convert the GIF file to GIF87a.

Table 40 Scheme extensions for manipulating background image

<table>
  <thead>
    <tr>
        <th>Scheme extension</th>
        <th>Definition</th>
        <th>Arguments</th>
    </tr>
  </thead>
  <tbody>
    <tr>
        <td>(sde:create-bg-image filename<br/>h-size v-size)</td>
        <td>Loads an image file (in GIF format).</td>
        <td>filename: STRING<br/>h-size: horizontal size, REAL<br/>v-size: vertical size, REAL</td>
    </tr>
    <tr>
        <td>(sde:show-bg-image)</td>
        <td>Shows the image.</td>
        <td>None</td>
    </tr>
    <tr>
        <td>(sde:hide-bg-image)</td>
        <td>Hides the image.</td>
        <td>None</td>
    </tr>
    <tr>
        <td>(sde:delete-bg-image)</td>
        <td>Removes the image from memory.</td>
        <td>None</td>
    </tr>
    <tr>
        <td>(sde:bg-image-transparency value)</td>
        <td>Sets the transparency of the image (0-1).</td>
        <td>transparency value, REAL (0-1)</td>
    </tr>
  </tbody>
</table>

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>289</page_number>

# 11: Miscellaneous Utilities

User-Defined Dialog Boxes

To convert an image from the GIF89a format to GIF87a format:

1. Open the GIF89a file in a graphics program.

2. Start xv, and grab the opened GIF89a image with xv.

3. Save the image in GIF format.
   xv will save the captured image using the older GIF87a format.

To load an image into Sentaurus Structure Editor and scale it to 0.2 μm × 0.2 μm :

```
(sde:create-bg-image "TEM.gif" 0.2 0.2)
(sde:show-bg-image)
```

To digitize a region of the device structure, follow the procedure for creating arbitrary polygons (see Drawing Polygons on page 47).

***

# User-Defined Dialog Boxes

User-defined dialog boxes can be created to assist with the generation of parametric devices. This feature is accessible only from Scheme.

This feature can be used to create a convenient central template library for company-wide use. Users of this central template library would only need to enter the necessary parameters in the custom dialog box and the structure is created automatically.

To create a user-defined dialog box, first declare the dialog box, using `sde:create-dialog`. Then, input fields, which will serve as the argument list of the associated Scheme function, must be defined using `sde:dialog-add-input`. An optional bitmap icon can also added to the dialog box, using `sde:dialog-add-pixmap`.

**NOTE** Only bitmaps in BMP format are supported.

The **OK** button of the dialog box can be attached to execute an already defined Scheme script using the `sde:dialog-ok-command` command. The dialog box can be displayed using `sde:dialog-show` and can be removed from memory using `sde:dialog-delete`.

The following Scheme commands can be used to create user-defined dialog boxes:

```
(define dialog-id (sde:create-dialog dialog-label))
(sde:dialog-add-input dialog-id varname labeltext inputtype [defaultvalue])
(sde:dialog-add-pixmap dialog-id bmpfilename)
(sde:dialog-ok-command dialog-id schemefnname argument-list)
(sde:dialog-show dialog-id)
(sde:dialog-delete dialog-id)
```

<page_number>290</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

11: Miscellaneous Utilities
User-Defined Dialog Boxes

Detailed syntax descriptions of these commands can be found in Appendix A on page 295.

To create and launch a user-defined dialog box:

1. Define a Scheme function that the dialog box will execute when the **OK** button is clicked.

2. Define the dialog box, create a bitmap image that shows all the necessary parameters, and add the bitmap image and the necessary parameters to the dialog box.

3. Launch the dialog box.

# Example: Defining a Dialog Box

The following example illustrates how to define and use a dialog box.

## Step 1: Define a Scheme Function That the Dialog Box Executes

```scheme
(define create-3d-mosfet
  (lambda (Lsub Wsub Hsti Wsti Toxi Lgat)
    (define Hsil 1.0) (define Hpol 0.3)
    (define Xgat1 (* 0.5 (- Lsub Lgat)))
    (define Xgat2 (* 0.5 (+ Lsub Lgat)))
    (sdegeo:create-cuboid (position 0.0 0.0 0.0) (position Lsub Wsub Hsil)
      "Silicon" "R.Substrate")
    (sdegeo:set-default-boolean "ABA")
    (sdegeo:create-cuboid (position 0.0 (- Wsub Wsti) (- Hsil Hsti))
      (position Lsub Wsub Hsil) "Oxide" "R.STI")
    (sdegeo:create-cuboid (position Xgat1 0.0 Hsil)
      (position Xgat2 Wsub (+ Hsil Toxi)) "Oxide" "R.Gox")
    (sdegeo:create-cuboid (position Xgat1 0.0 (+ Hsil Toxi))
      (position Xgat2 Wsub (+ Hsil Hpol)) "PolySilicon" "R.Poly")
  )
)
```

## Step 2: Define and Configure the Dialog Box

```scheme
(define mos-3d-dialog (sde:create-dialog "Simple 3D MOSFET"))
(sde:dialog-add-pixmap mos-3d-dialog "MOS3D.bmp")
(sde:dialog-add-input mos-3d-dialog "Lsub" "Substrate Length: Lsub="
  "real" 1.2)
(sde:dialog-add-input mos-3d-dialog "Wsub" "Substrate Width: Wsub="
  "real" 0.8)
(sde:dialog-add-input mos-3d-dialog "Hsti"
  "Trench Height (<1.0): Hsti= " "real" 0.5)
(sde:dialog-add-input mos-3d-dialog "Wsti"
  "Trench Width (<Wsub): Wsti= " "real" 0.3)
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>291</page_number>

# 11: Miscellaneous Utilities

Starting Sentaurus Structure Editor With User-Defined Variables

```
(sde:dialog-add-input mos-3d-dialog "Toxi" "Oxide Thickness: Toxi="
 "real" 0.02)
(sde:dialog-add-input mos-3d-dialog "Lgat" "Gate Length (<Lsub): Lgat="
 "real" 0.4)
(sde:dialog-ok-command mos-3d-dialog "create-3d-mosfet" "Lsub Wsub Hsti Wsti
 Toxi Lgat")
```

## Step 3: Launch the Dialog Box

```
(sde:dialog-show mos-3d-dialog)
```

Figure 124 shows the dialog box that was defined and created in Step 2, and launched in Step 3.

Screenshot of a user-defined dialog box titled "Simple 3D MOSFET" showing input fields for Substrate Length, Substrate Width, Trench Height, Trench Width, Oxide Thickness, and Gate Length, alongside a 3D diagram of the MOSFET structure with labeled dimensions.

Figure 124 User-defined dialog box

***

# Starting Sentaurus Structure Editor With User-Defined Variables

Scheme variables can be specified at the command line. When Sentaurus Structure Editor is launched, these variables are accessible from the Scheme command-line window (or in batch mode, the variables are defined for script execution). In this way, a Scheme script can be started in such a way that the argument variables are passed to the script from the command line.

The syntax is:

`-var varName=varValue`

<page_number>292</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

11: Miscellaneous Utilities
User-Defined GUI Interactions

Neither varName nor varValue can contain any space characters (that is, the varName=varValue construct should be seen as one argument). varValue can be either a string or number. For example:

```
> sde -l cmdinputdemo.scm -e -var mw=10 -var mh=5
```

where cmdinputdemo.scm is defined as:

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0 0 0) (position mw mh 0)
  "Silicon" "region_1")
(sdeio:save-tdr-bnd (get-body-list) "testarginput.tdr")
```

# User-Defined GUI Interactions

This section discusses user-defined GUI interactions.

## Dialog Boxes for Obtaining Values

The following functions can be used to interact with the GUI and to receive user input:

```scheme
(sde:gui-get-integer entry-field-label default-integer title)
(sde:gui-get-real entry-field-label default-real title)
(sde:gui-get-string entry-field-label default-string title)
```

For example, to display a custom dialog box with the title **CMOS** and a field **Total Width**, which expects a real number that defaults to 10:

```scheme
(define Wtot (sde:gui-get-real "Total Width" 10 "CMOS"))
```

The entered value is stored here in the Scheme variable Wtot.

## GUI Actions for Obtaining Positions

Simple support functions are also provided to perform interactive model manipulation.

To select a position from the view window:

```scheme
(define MyPosition (sde:pick-point-on-wp))
```

After this Scheme command is given, move the mouse in the view window and click the position of interest. The resulting position is stored here in the Scheme variable MyPosition.

Sentaurus™ Structure Editor User Guide
S-2021.06
<page_number>

293
</page_number>

# 11: Miscellaneous Utilities

User-Defined GUI Interactions

To select a pair of positions from the view window:

```
(define MyPositionPair (sde:pick-two-points-on-wp))
```

After this Scheme command is given, move the mouse in the view window to the first point of interest, drag to the second point of interest and release the left mouse button. The resulting list of two position is stored here in the Scheme variable MyPositionPair.

## Message Boxes

To post a message box:

```
(sde:post-message message)
```

For example:

```
(sde:post-message "This is a message\n from SDE")
```

The dialog box has an **OK** button that must be clicked to continue. No new-line character is needed. Multiple lines must be separated by `"\n"`.

<page_number>294</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

