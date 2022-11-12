Upgrade v1.2 11/12/2022:
Updated to speckQuant, now using morph instead of cellprofiler's MeasureObjectNeighbors function.
This makes it possible to measure distance from DNA-FISH foci to the edge of speckle.

A foci-foci distance comparison made this pipeline vs. rajlabimagetool (https://github.com/arjunrajlaboratory/rajlabimagetools) is shown below:
With an R=0.81
![alt text](https://github.com/Chalietia/CellProfiler/blob/main/misc/Screen%20Shot%202022-11-12%20at%202.46.56%20PM.png)
########################################################################
Fociquant 5/9/2022:

Updated pipeline for DNA/RNA foci quantification. Performs better than previous version.


########################################################################
Upgrade v1.2 2/14/2022:

Adjusted export to include paired background intensity measurements, speckle & nuclear size/shape.
I use the following bash code to loop through input folders. Note the file-list will need absolute path, one file per row.

```
for d in */
do
echo $d
echo /Users/ruofany/Desktop/11182021cocl2timepoint/result/"$d"
cd $d
#create a file list
realpath *.tiff > file_list.txt
#run
cellprofiler -c -r -p /Users/ruofany/OneDrive/seqseq/cellprofilerpipeline/TSQuant_RYAuto_v1.2_1.cppipe -i /Users/ruofany/Desktop/11182021cocl2timepoint/maxp/"$d" -o /Users/ruofany/Desktop/11182021cocl2timepoint/result/"$d" --file-list=./file_list.txt --conserve-memory=true
#change filename for post processing
    for f in *.txt
    do
    mv "$f" "$name_$f"
    done
cd /Users/ruofany/Desktop/11182021cocl2timepoint/maxp
done


```


########################################################################

Upgrade v1.1 2/9/2022:

Adjusted some settings for our new scope, should deal better with noisy background.

    An example of comparison between semi-manual (With Raj lab imagetool) and this automatic pipeline is shown below:
    Measurement is distance between transcription site and closest nuclear speckle in four different conditions. 
    Left being manual analysis and right being auto. 

![alt text](https://github.com/Chalietia/CellProfiler/blob/main/misc/Screen%20Shot%202022-02-10%20at%2010.23.32%20AM.png)



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

5. Things get tricky if no FISH spot is present, may need to manual edit object in that case. 
