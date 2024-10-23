#!/bin/bash

#Running CP in conda.

# Activate the Python environment with CellProfiler installed
conda activate py3.8

# Set the path to Java (required by CellProfiler or some other dependency)
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-16.0.2.jdk

# Define the main directories
# maxpHome: Path to the directory where the input folders (with TIFF files) are located.
# resultHome: Path to the directory where the output will be saved.
# pipe: Path to the CellProfiler pipeline (.cppipe file).
maxpHome=$(echo "PathToFolder")
resultHome=$(echo "PathToFolder")
pipe=$(echo "PathToFolder/.cppipe")

# Loop through all subdirectories in the maxpHome directory
# Each subdirectory corresponds to a specific dataset (e.g., containing TIFF images)
for d in */
    do
    # Extract the folder name to use it for naming outputs
    name=$(basename $d)
    echo "Processing folder: $name"
    echo "Results will be saved in: $resultHome/$d"
    
    # Change to the current subdirectory to access the TIFF files
    cd $d

    # Generate a file_list.txt that contains absolute paths to all TIFF files
    # realpath: Converts relative paths to absolute paths
    realpath *.tiff > file_list.txt

    # Run CellProfiler
    # -i: Specify the input folder containing the images (absolute path)
    # -o: Specify the output folder where results will be saved (absolute path)
    # --file-list: Provide the file list with the absolute paths of the TIFF files to process
    cellprofiler -c -r -p $pipe -i "$maxpHome/$d" -o "$resultHome/$d" --file-list=./file_list.txt --conserve-memory=true

    # After running CellProfiler, change to the result directory and rename all output files
    # This renaming adds the folder name as a prefix to each output file for easier identification
    cd "$resultHome/$d"
    for f in *.txt
    do
        mv "$f" "$name"_"$f"
    done

    # Return to the maxpHome directory to process the next folder
    cd "$maxpHome"
done
