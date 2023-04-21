# RadialQuant
MATLAB code for registering a set of transverse bone cross-sections and evaluating the density of various histomorphometric features in radial image segments.

This repository and the code within it is intended for academic research purposes. For the original publication, please see (coming soon).

This code was specifically designed for use on thresholded, binary masks derived from confocal microscopy images of bone histology. For instructions on how to generate this histology, images, and the masks, please see the following protocols io sites:
1. Histology & Images (https://www.protocols.io/view/spatial-mapping-and-contextualization-of-axon-subt-36wgq4nnkvk5/v1)
2. Masks (coming soon)

This repository contains 3 MATLAB files, meant to be used in the following order:

RadialQuantRegister: This code registers all histomorphometric feature masks to a single fixed image pre-selected by the user.
RadialQuantPrimary: This code determines the center of the bone. The amount of bone (or periosteum, depending on which you use) in each radial segment is collected in countPixels and is expressed in pixel units.
RadialQuantSecondary: This code determines the amount of a particular feature (i.e. periosteal area, axon length, bone surface, etc.) in each radial segment. The amount is collected in countPixels and is expressed in pixel units.
