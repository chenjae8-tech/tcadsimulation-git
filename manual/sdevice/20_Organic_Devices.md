# CHAPTER 20 Organic Devices

*This chapter describes the organic models available in Sentaurus Device.*

The electrical conduction process in organic materials is different from crystal lattice semiconductors. However, similar concepts in semiconductor transport theory can be used in treating the conduction process in organic materials.

## Introduction to Organic Device Simulation

An organic material or semiconductor is formed from molecule chains, and the primary transport of carriers (electrons and holes) is through a *hopping* process. The lowest unoccupied molecular orbital (LUMO) and highest occupied molecular orbital (HOMO) energy levels in organic materials are analogous to the conduction and valence bands, respectively. In addition, excitons need to be considered since these bound electron–hole pairs contribute to the distribution of electron and hole populations. Traps are also central to organic transport, and these need to be taken into account appropriately.

Therefore, a combination of semiconductor models and organic physics models is required to model reasonably the physical transport processes of organic devices within the framework of Sentaurus Device. The following models are needed in a typical organic device simulation:

*   The Poole–Frenkel mobility model is used to model the hopping transport of the carriers (electrons and holes). This model is dependent on electric field and temperature. It is common for electrons to have two orders of magnitude higher mobility than holes (see Poole–Frenkel Mobility (Organic Material Mobility) on page 409).

*   Organic–organic heterointerface physics requires special treatment for the ballistic transport of carriers and bulk excitons across heterointerfaces with energy barriers (see Gaussian Transport Across Organic Heterointerfaces on page 822).

*   Gaussian density-of-states (DOS) approximates the effective DOS for electrons and holes in disordered organic materials and semiconductors (see Gaussian Density-of-States for Organic Semiconductors on page 276).

*   The traps model must be initialized with the appropriate capture cross sections and densities (see Chapter 17 on page 489).

*   The Langevin bimolecular recombination model is used to model the recombination process of carriers and the generation process of singlet excitons (see Bimolecular Recombination Model on page 484).

References

*   A singlet exciton equation is introduced to model the diffusion process, the generation from bimolecular recombination, the loss from decay, and the optical emissions of singlet excitons. Only Frenkel excitons (electron–hole pairs existing on the same molecule) participate in the optical process in organic materials (see Singlet Exciton Equation on page 245).

The organic device simulator is based on the work of Kozłowski [[1]](reference_1), and other useful papers are available [[2]](reference_2)–[[10]](reference_10).

Table 114 lists acronyms that describe organic device layers and transport mechanisms.

Table 114 Commonly used acronyms for organic transport

| Acronym | Definition |
| --- | --- |
| EBL | Electron blocking layer |
| EML | Emission layer |
| ETL | Electron transport layer |
| HOMO | Highest occupied molecular orbital |
| HTL | Hole transport layer |
| LUMO | Lowest unoccupied molecular orbital |
| SCL | Space charge limited |
| TCL | Trapped charge limited |
| TSL | Thermally stimulated luminescence |

# References

[1] F. Kozłowski, *Numerical simulation and optimisation of organic light emitting diodes and photovoltaic cells*, PhD thesis, Technische Universität Dresden, Germany, 2005.

[2] S.-H. Chang *et al.*, “Numerical simulation of optical and electronic properties for multilayer organic light-emitting diodes and its application in engineering education,” in *Proceedings of SPIE, Light-Emitting Diodes: Research, Manufacturing, and Applications X*, vol. 6134, pp. 26-1–26-10, 2006.

[3] P. E. Burrows *et al.*, “Relationship between electroluminescence and current transport in organic heterojunction light-emitting devices,” *Journal of Applied Physics*, vol. 79, no. 10, pp. 7991–8006, 1996.

[4] M. Hoffmann and Z. G. Soos, “Optical absorption spectra of the Holstein molecular crystal for weak and intermediate electronic coupling,” *Physical Review B*, vol. 66, no. 2, p. 024305, 2002.

**20: Organic Devices**
References

[5] J. Staudigel *et al.*, “A quantitative numerical model of multilayer vapor-deposited organic light emitting diodes,” *Journal of Applied Physics*, vol. 86, no. 7, pp. 3895–3910, 1999.

[6] E. Tutiš *et al.*, “Numerical model for organic light-emitting diodes,” *Journal of Applied Physics*, vol. 89, no. 1, pp. 430–439, 2001.

[7] B. Ruhstaller *et al.*, “Simulating Electronic and Optical Processes in Multilayer Organic Light-Emitting Devices,” *IEEE Journal of Selected Topics in Quantum Electronics*, vol. 9, no. 3, pp. 723–731, 2003.

[8] B. Ruhstaller *et al.*, “Transient and steady-state behavior of space charges in multilayer organic light-emitting diodes,” *Journal of Applied Physics*, vol. 89, no. 8, pp. 4575–4586, 2001.

[9] A. B. Walker, A. Kambili, and S. J. Martin, “Electrical transport modelling in organic electroluminescent devices,” *Journal of Physics: Condensed Matter*, vol. 14, no. 42, pp. 9825–9876, 2002.

[10] S. Odermatt, N. Ketter, and B. Witzigmann, “Luminescence and absorption analysis of undoped organic materials,” *Applied Physics Letters*, vol. 90, p. 221107, May 2007.

## References

