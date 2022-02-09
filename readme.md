########################################################################

TSSquant ver1.0 made by Ruofan Yu, Berger lab, Upenn. 02/08/2022 

########################################################################

a few things before start:

make maxprojection with corresponding maxProjection pipeline (from .nd2) and use output figures as input of this pipeline. Check maxP photos to make sure they're not out of focus etc. 

The pipeline is: call nucleus, subtract bkg-enhance-gaussian-call intron spot, enhance-gaussian-call exon, overlap intron/exon-manual filter to call TSS, calculate intensity of intron/corresponding nucleus median intensity, enhance and call speckle, caculate distance.

Useful info is stored in **CYcoloc(distance, intensity), Nuclei(background intensity for normalization), speckleFinal (speckle morphology)

the results will need post-processing as follow: (distance-1px)*distancePerPixel to calculate distance Relate per nucleus intensity in nuclei.txt output to TSS to calculate normalized intensity.
