Current pipelines:

1. Maxprojection*: For generating max projected tiff from .nd2 file.
2. SpecQuant*: For measurement of the distance between each DNA-FISH foci and the edge of its closest nuclear speckle.
3. SpecQuant*Mask: Same as 2., just adding another step to call the positively transfected cell.
4. SpeckleSPEC: Measure size and shape of nuclear speckles. 

########################################################################
Upgrade v2.4 03/30/2023:


Minor adjustment, now including filtering of nucleus based on number of child object (DNA-FISH foci or speckle number).


########################################################################

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

