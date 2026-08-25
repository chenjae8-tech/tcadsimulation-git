# CHAPTER 6 Electrical and Thermal Contacts

*This chapter describes how to define contacts in Sentaurus Structure Editor.*

## Overview

Contacts are interfacial regions where subsequent TCAD tools, such as Sentaurus Device, apply electrical, thermal, or other boundary conditions. They correspond to physical contacts in the real device. Contacts are edges in two dimensions and faces in three dimensions. The contact edges and faces are part of the geometry.

Before an edge or a face can be assigned to a contact, the contact itself must be declared and activated first.

There are distinct methods to assign edges or faces to contacts. You can either use an explicit edge or face list, or select a region. In the latter case, all boundary edges or boundary faces will be assigned to the contact.

Contacts are respected by all geometry-modifying operations. For example:

*   Contacts are maintained or updated as needed in transformations (scaling, translation, rotation, and reflection).

*   Two-dimensional contact edges are transformed to 3D contact faces in operations such as extrusion and sweeping.

*   Three-dimensional contact faces are reduced to 2D contact edges in operations such as slicing.

A contact can consist of several disjoint edges or faces.

Sentaurus™ Structure Editor User Guide

<page_number>183</page_number>

S-2021.06

6: Electrical and Thermal Contacts

Defining and Activating a Contact

# Defining and Activating a Contact

To define and activate a contact:

1. Choose **Contacts** > **Contact Sets**.

The Contact Sets dialog box is displayed.

Screenshot of the Contact Sets dialog box in Sentaurus Structure Editor

2. Enter a contact name.

3. Edit the color and line thickness for drawing the 2D contact edges if required.

4. Select the pattern to mark 3D contact faces if required.

5. Click **Set** to complete the contact declaration.

The new contact name is displayed the Defined Contact Sets list.

6. Select the newly defined contact from the Defined Contact Sets list, and click **Activate**.

The active contact is now displayed in the Contact list in the main window of Sentaurus Structure Editor.

An already defined contact can be activated directly by selecting it from the Contact list of the main window.

The corresponding Scheme command is:

```scheme
(sdegeo:define-contact-set contact-name edge-thickness
  (color:rgb red green blue) pattern)
```

### For example:

```scheme
(sdegeo:define-contact-set "substrate" 4 (color:rgb 1 0 0) "##")
(sdegeo:set-current-contact-set "substrate")
```

<page_number>

184
</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**6: Electrical and Thermal Contacts**

Deleting a Contact

The contact edge color is defined using three values, each ranging from 0 to 1. These values give the relative intensity of the three basic colors: red, green, and blue. For example:

*   red=`(color:rgb 1 0 0)`
*   green=`(color:rgb 0 1 0)`
*   blue=`(color:rgb 0 0 1)`
*   yellow=`(color:rgb 1 1 0)`
*   cyan=`(color:rgb 0 1 1)`
*   purple=`(color:rgb 1 0 1)`
*   gray=`(color:rgb 0.5 0.5 0.5)`

# Deleting a Contact

To delete a contact definition:

1.  Choose **Contacts** > **Contact Sets**.

2.  Click the respective contact in the Defined Contact Sets list.

3.  Click **Delete**.

The corresponding Scheme command is:

```scheme
(sdegeo:delete-contact-set contact-name)
```

# Assigning Edges or Faces to a Contact

To assign edges (2D) or faces (3D) to the currently active contact:

1.  Click the **Select** button (see Table 7 on page 12).

2.  From the Selection Level list, select **Select Edge** (for 2D) or **Select Face** (for 3D).

3.  Select an edge (or a face) and hold the Shift key to select additional edges (or faces), or drag a box around a set of edges (or faces).

4.  Choose **Contacts** > **Set Contact**.

> This command checks the type of the selected entities. If only edges are selected, it assigns a 2D contact to the selected entities (same as choosing **Contacts** > **Set Edges**). If only faces are selected (and the faces belong to 3D bodies), it assigns a 3D contact to the selected entities (same as choosing **Contacts** > **Set Faces**).

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>185</page_number>

# 6: Electrical and Thermal Contacts

Assigning a Region Boundary to a Contact

Alternatively, right-click anywhere and choose **Contacts**. From the submenu, select an already defined contact to assign all selected edges or faces to this contact, or select **Contact Sets** to assign the edges or faces to a new contact. Define and activate this contact as described in Defining and Activating a Contact on page 184.

5. Choose **Contacts** > **Set Edges** (for 2D) or **Contacts** > **Set Faces** (for 3D).

After closing the Contact Sets dialog box, all selected edges or faces are assigned to the newly defined contact.

For example, for 2D structures, the corresponding Scheme commands are:

```scheme
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0)
  "Silicon" "region_1")
(sdegeo:set-contact (find-edge-id (position 0.5 0.0 0)) "cont")
```

For example, for 3D structures, the corresponding Scheme commands are:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1.0)
  "Silicon" "region_1")
(sdegeo:set-contact (find-face-id (position 0.5 0.5 1.0)) "cont")
```

---

# Assigning a Region Boundary to a Contact

To assign all region boundary edges (2D) or all region boundary faces (3D) to the currently active contact:

1. Click the **Select** button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Body**.

3. Select a body and hold the Shift key to select additional bodies, or drag a box around a set of bodies.

4. Choose **Contacts** > **Set Region Boundary Edges**.
   Choose **Contacts** > **Set Region Boundary Faces**.

The corresponding Scheme command is:

```scheme
(sdegeo:set-contact entity | entity-list
      [contact-name ["remove"] ["imprint" BOOLEAN]])
```

Specifying the `"remove"` option deletes the region and converts its boundaries into a contact. If you specify `"imprint" #f`, the 3D contact is not assigned to the touching faces. The default behavior is `"imprint" #t`, in which case, the 3D contact is imprinted to the touching neighbor faces.

<page_number>186</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

6: Electrical and Thermal Contacts

Removing Edges or Faces From a Contact

For example, for 2D structures, the corresponding Scheme commands are:

```scheme
(sde:clear)
(sdegeo:create-rectangle (position 0.0 0.0 0) (position 1.0 1.0 0)
 "Silicon" "region_1")
(sdegeo:set-default-boolean "ABA")
(define VIA (sdegeo:create-rectangle
 (position 0.25 0.75 0) (position 0.75 1.5 0) "Metal" "region_2"))
(sdegeo:set-contact VIA "cont" "remove")
```

For example, for 3D structures, the corresponding Scheme commands are:

```scheme
(sde:clear)
(sdegeo:create-cuboid (position 0.0 0.0 0.0) (position 1.0 1.0 1.0)
 "Silicon" "region_1")
(sdegeo:set-default-boolean "ABA")
(define VIA (sdegeo:create-cuboid
 (position 0.25 0.25 0.75) (position 0.75 0.75 1.5) "Metal" "region_2"))
(sdegeo:set-contact VIA "cont" "remove")
```

You can use the `sdegeo:set-contact` function to assign contacts to geometric edges or faces depending on model dimensionality. In three dimensions, this function attaches the "3d-contact" attributes and the no merge attributes to the specified faces.

# Removing Edges or Faces From a Contact

The procedures to remove edges or faces from a contact are similar to the procedures to assign edges or faces to a contact (see Assigning Edges or Faces to a Contact on page 185 and Assigning a Region Boundary to a Contact on page 186). After selecting the edges, faces, or bodies, select the respective option by choosing **Contacts > Unset**.

The corresponding Scheme commands are:

```scheme
(sdegeo:delete-contact-boundary-edges [body | body-list])
(sdegeo:delete-contact-boundary-faces [body | body-list])
(sdegeo:delete-contact-edges [edge | edge-list])
(sdegeo:delete-contact-faces [face | face-list])
```

As an alternative to the above procedures:

1. Click the **Select** button (see Table 7 on page 12).

2. From the Selection Level list, select **Select Edge** (2D) or **Select Face** (3D).

Sentaurus™ Structure Editor User Guide

S-2021.06

<page_number>187</page_number>

# 6: Electrical and Thermal Contacts

Creating Edges or Faces for Use in Contacts

3. Select an edge (or a face) and hold the Shift key to select additional edges (or faces), or drag a box around a set of edges (or faces).

4. Right-click anywhere and choose **Contacts**. From the submenu, view the list of contact sets. A check mark shows which contact sets have already been placed at the selected entity or entities.

5. Deselect the required contact to unset the selected edges or faces as that contact set.

---

# Creating Edges or Faces for Use in Contacts

Only an entire edge or face can be assigned to a contact. If the contact should cover only part of an edge or a face, the edge or face must be split explicitly.

In two dimensions, a convenient way to accomplish this task is to add vertices (see Adding a Vertex on page 50).

For example, the following Scheme commands create a rectangle, split one of its edges into three segments by inserting two new vertices, and assign the contact "`cont1`" to the side edge segments (see Figure 108):

```scheme
(sdegeo:create-rectangle (position 0 0 0) (position 1 1 0) "Silicon"
 "region_1")
(sdegeo:insert-vertex (position 0.3 0.0 0.0))
(sdegeo:insert-vertex (position 0.7 0.0 0.0))
(sdegeo:set-contact (find-edge-id (position 0.15 0 0)) "cont1")
(sdegeo:set-contact (find-edge-id (position 0.85 0 0)) "cont2")
```

Diagram showing an original edge of a rectangle on the left and the same edge split into three segments by added vertices on the right.

Figure 108 Adding contacts to 2D edge segments

<page_number>188</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

# 6: Electrical and Thermal Contacts
## Creating Edges or Faces for Use in Contacts

In three dimensions, Sentaurus Structure Editor provides dedicated functions to imprint a shape on a surface to split existing faces.

To split faces in three dimensions by imprinting a rectangle:

1. Choose **Contacts > Imprint Rectangle**.

2. Drag to draw the diagonal of the rectangle in the view window.

To split faces in three dimensions by imprinting a polygon:

1. Choose **Contacts > Imprint Polygon**.

2. Click at each vertex of the polygon in the view window. To finish drawing the polygon, click the middle mouse button. (Press both buttons when using a two-button mouse.)

The polygon is closed automatically.

To split faces in three dimensions by imprinting a circle:

1. Choose **Contacts > Imprint Circle**.

2. Drag to draw the radius of the circle in the view window.

The corresponding Scheme commands are:

```scheme
(sdegeo:imprint-rectangular-wire position position)
(sdegeo:imprint-polygonal-wire position-list)
(sdegeo:imprint-circular-wire position radius)
```

For example:

```scheme
(sdegeo:create-cuboid (position 0.0 0.0 -1.0) (position 3.0 1.0 0.0)
  "Silicon" "region_1"))
(define RECT (sdegeo:imprint-rectangular-wire
  (position 0.2 0.2 0) (position 0.8 0.8 0)))
(define POLY (sdegeo:imprint-polygonal-wire (list (position 1.2 0.2 0)
  (position 1.8 0.2 0) (position 1.8 0.8 0) (position 1.5 0.8 0)
  (position 1.5 0.5 0) (position 1.2 0.5 0) (position 1.2 0.2 0))))
(define CIRC (sdegeo:imprint-circular-wire (position 2.5 0.5 0) 0.3))
```

The imprint commands return a list containing the newly generated faces. This list can be used in `sdegeo:set-contact`. After the new faces are created, the contact generation procedure is the same as that discussed in Assigning Edges or Faces to a Contact on page 185.

When used from the GUI, the imprint commands place the rectangle, polygon, or circle, in the current work plane. Change the work plane as discussed in Work Planes on page 117 to place imprint shapes on a general face.

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>189</page_number>

6: Electrical and Thermal Contacts

Protecting Contacts

# Protecting Contacts

If contacts are assigned to edges and faces using any of the sdegeo contact assignment commands, these contacts are protected.

The 2D boundary simplification commands do not remove or merge contact edges, and also the 3D boundary regularization command `sde:bool-regularise` does not merge coplanar contact faces with adjoining faces.

If an application defines the edge or face contacts directly, by attaching the `"2d-contact"` or `"3d-contact"` attributes to the contact edges or faces, these contacts are not protected. In this case, the `(protect-all-contacts)` command can be used to add the necessary *no merge* attribute to the contact edges or faces.

# Examples of Contact Assignments

These examples illustrate how to create different 2D and 3D contacts.

## Creating Different 2D Contacts

Create the device geometry:

```scheme
(sdegeo:create-rectangle (position -1.0 0.0 0) (position 1.0 1.0 0)
 "Silicon" "R.Substrate")
(sdegeo:create-rectangle (position -0.4 0.0 0) (position 0.4 -0.05 0)
 "Oxide" "R.Gox")
(sdegeo:create-rectangle (position -0.4 -0.05 0) (position 0.4 -0.5 0)
 "Nitride" "R.Spacer")
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-rectangle (position -0.2 -0.05 0) (position 0.2 -0.5 0)
 "PolySi" "R.Poly")
(define TMP (sdegeo:create-ellipse (position -1.0 0.0 0) (position -0.5 0.00 0)
 0.2 "Silicide" "R.Silicide"))
(sdegeo:delete-region TMP)
```

Assign an existing edge to the `"substrate"` contact:

```scheme
(sdegeo:set-contact (find-edge-id (position 0.0 1.0 0)) "substrate")
```

<page_number>190</page_number>

Sentaurus™ Structure Editor User Guide
S-2021.06

**6: Electrical and Thermal Contacts**
Examples of Contact Assignments

Split an edge and assign part of the original edge to the "drain" contact:

```scheme
(sdegeo:insert-vertex (position 0.5 0.0 0))
(sdegeo:set-contact (find-edge-id (position 0.75 0.0 0)) "drain")
```

Assign all region boundary edges to the "gate" contact and remove the region:

```scheme
(sdegeo:set-contact (find-body-id (position 0 -0.275 0)) "gate" "remove")
```

Assign edges along a complex topology to the "source" contact as follows.

In the Old Replaces New (BAB) overlap resolution mode (see Overlap Behavior on page 44), a dummy body is created that includes all boundary edges, which should be assigned to the "source" contact. Then, the region boundary edges of this dummy body are assigned to the "source" contact, and the dummy body itself is removed:

```scheme
(sdegeo:set-default-boolean "BAB")
(define DUMMY (sdegeo:create-rectangle (position -1.0 -0.3 0)
  (position -0.45 0.2 0) "Aluminum" "R.Dummy"))
(sdegeo:set-contact DUMMY "source" "remove")
```

Initial device geometry structure with contacts

Device geometry immediately before deleting the dummy body

Figure 109 Two-dimensional contact creation example: (*left*) initial device geometry structure with “substrate” (red), “drain” (green), “gate” (blue), and “source” (purple) contacts; and (*right*) immediately before deleting the dummy body used to create the “source” contact

# Creating Different 3D Contacts

Create the device geometry:

```scheme
(sdegeo:create-cuboid (position -1.0 0.0 0.0) (position 1.0 1.0 -1.0)
  "Silicon" "R.Substrate")
(sdegeo:create-cuboid (position -0.4 0.0 0.0) (position 0.4 1.0 0.05)
  "Oxide" "R.Gox")
(sdegeo:create-cuboid (position -0.4 0.0 0.05) (position 0.4 1.0 0.5)
  "Nitride" "R.Spacer")
```

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>191</page_number>

# 6: Electrical and Thermal Contacts

Examples of Contact Assignments

```scheme
(sdegeo:set-default-boolean "ABA")
(sdegeo:create-cuboid (position -0.2 0.0 0.05) (position 0.2 1.0 0.5)
 "PolySi" "R.Poly")
(sdegeo:create-cuboid (position -1.0 0.5 0.0) (position 1.0 1.0 -0.5)
 "Oxide" "R.STI")
(sdegeo:set-default-boolean "ABA")
(define TMP (sdegeo:create-sphere (position -0.75 0.25 0.0) 0.2
 "Silicide" "R.Silicide"))
(sdegeo:delete-region TMP)
```

Assign an existing face to the "substrate" contact:

```scheme
(sdegeo:set-contact (find-face-id (position 0.0 0.5 -1.0)) "substrate")
```

Imprint a rectangle on a face in the base work plane, and assign the new face to the "drain" contact:

```scheme
(define DRAINFACE (sdegeo:imprint-rectangular-wire
 (position 0.5 0.45 0) (position 0.95 0.05 0)))
(sdegeo:set-contact DRAINFACE "drain")
```

Imprint a rectangle on a face in a custom work plane ("Sidewall"), and assign the new face to the "thermode" contact:

```scheme
(sdegeo:define-work-plane "Sidewall" (position -1 1 -1) (position -1 0 -1)
 (position -1 1 0))
(sdegeo:set-active-work-plane "Sidewall")
(define THERMFACE (sdegeo:imprint-rectangular-wire
(position 0.05 0.05 0) (position 0.95 0.45 0)))
(sdegeo:set-active-work-plane "base")
(sdegeo:set-contact THERMFACE "thermode")
```

Imprint a polygon on a general face using exploited 3D coordinates, and add the new face to the "thermode" contact:

```scheme
(define THERMFACE_2 (sdegeo:imprint-polygonal-wire (list
 (position 1.0 0.05 -0.95) (position 1.0 0.95 -0.95)
 (position 1.0 0.95 -0.55) (position 1.0 0.45 -0.55)
 (position 1.0 0.45 -0.05) (position 1.0 0.05 -0.05)
 (position 1.0 0.05 -0.95))))
(sdegeo:set-contact THERMFACE_2 "thermode")
```

Assign all region boundary faces to the "gate" contact and remove the region:

```scheme
(sdegeo:set-contact (find-body-id (position 0.0 0.5 0.3)) "gate" "remove")
```

Assign faces along a complex topology to the "source" contact as follows.

<page_number>192</page_number>

Sentaurus™ Structure Editor User Guide

S-2021.06

**6: Electrical and Thermal Contacts**
Examples of Contact Assignments

In the Old Replaces New (BAB) overlap resolution mode (see Overlap Behavior on page 44), a dummy body is created that includes all boundary faces, which should be assigned to the `"source"` contact.

Then, the region boundary faces of this dummy body are assigned to the `"source"` contact, and the dummy body itself is removed:

```scheme
(sdegeo:set-default-boolean "BAB")
(define DUMMY (sdegeo:create-cuboid (position -1.0 0.05 -0.3)
  (position -0.45 0.45 0.1) "Aluminum" "R.Dummy"))
(sdegeo:set-contact DUMMY "source" "remove")
```

initial device geometry

structure top view with “drain”, “gate”, and “source” contacts

structure bottom view with “thermode” and “substrate” contacts

Figure 110 Three-dimensional contact creation example: (*left*) initial device geometry, (*middle*) structure top view with “drain”, “gate”, and “source” contacts, and (*right*) structure bottom view with “thermode” and “substrate” contacts

Sentaurus™ Structure Editor User Guide
S-2021.06

<page_number>193</page_number>

# 6: Electrical and Thermal Contacts

## Examples of Contact Assignments

<page_number>194</page_number> Sentaurus™ Structure Editor User Guide

Sentaurus™ Structure Editor User Guide
S-2021.06

