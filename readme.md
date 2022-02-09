########################################################################

TSSquant ver1.0 made by Ruofan Yu, Berger lab, Upenn. 02/08/2022 

########################################################################

a few things before start:

1. make maxprojection with corresponding maxProjection pipeline (from .nd2) and use output figures as input of this pipeline. Check maxP photos to make sure they're not out of focus etc. 

2. The pipeline is: call nucleus, subtract bkg-enhance-gaussian-call intron spot, enhance-gaussian-call exon, overlap intron/exon-manual filter to call TSS, calculate intensity of intron/corresponding nucleus median intensity, enhance and call speckle, caculate distance.

3. Useful info is stored in **CYcoloc(distance, intensity), Nuclei(background intensity for normalization), speckleFinal (speckle morphology)

4. The results will need post-processing as follow: 

    For manual pipeline: (distance-1px)*distancePerPixel (0.11nm/px in the examples) to calculate distance Relate per nucleus intensity in nuclei.txt output to TSS to calculate normalized intensity.
    
    For auto pipeline:distance * distancePerPixel.
    
    I remove data with larger than 2nm distance to speckle, as these are mostly junk.
