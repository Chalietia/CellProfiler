#!/bin/bash

# Running CellProfiler in Docker
# This script runs CellProfiler in a Docker container for each folder containing TIFF files.
# The paths in the file list should be relative to the Docker-mounted input folder (/input).

# Define the main directories
# maxpHome: Path to the directory where the input folders (with TIFF files) are located.
# resultHome: Path to the directory where the output will be saved.
# pipe: Path to the CellProfiler pipeline (.cppipe file).
maxpHome=$(echo "PathToFolder")
resultHome=$(echo "PathToFolder")
pipe=$(echo "PathToFolder/test.cppipe")

# Loop through all subdirectories in the maxpHome directory
# This will loop over each folder containing TIFF images.
for d in */
  do
  # Extract the folder name (basename) to use it for naming outputs.
  name=$(basename $d)
  echo "Processing folder: $name"
  echo "Results will be saved in: $resultHome/$d"

  # Change to the current subdirectory to access the TIFF files.
  cd $d

  # Create a file_list.txt that contains paths to all TIFF files relative to the Docker-mounted /input folder.
  # Each line in file_list.txt will look like: /input/filename.tiff
  # This file will be passed to CellProfiler so it knows which images to process.
  for file in *.tiff; do
        echo "/input/$file" >> file_list.txt
  done

  # Run the CellProfiler Docker container
  # -v "$maxpHome/$d":/input: Mount the current subdirectory as the Docker /input folder.
  # -v "$resultHome/$d":/output: Mount the corresponding result folder to the Docker /output folder.
  # -v "$pipe":/pipeline.cppipe: Mount the CellProfiler pipeline file into the container.
  # -v "$maxpHome/$d/file_list.txt":/filelist.txt: Mount the file_list.txt into the Docker container.
  # The CellProfiler command processes the input images based on the paths in /filelist.txt.
  docker run -it --rm \
  -v "$maxpHome/$d":/input \
  -v "$resultHome/$d":/output \
  -v "$pipe":/pipeline.cppipe \
  -v "$maxpHome/$d/file_list.txt":/filelist.txt \
  cellprofiler/cellprofiler:4.2.1 \
  -c -r -i /input -o /output -p /pipeline.cppipe --file-list /filelist.txt --conserve-memory=true

  # After running CellProfiler, change to the results directory and rename all output files.
  # This renaming adds the folder name as a prefix to each output file.
  cd "$resultHome/$d"
  for f in *.txt
  do
    mv "$f" "$name"_"$f"
  done

  # Return to the maxpHome directory to process the next folder.
  cd "$maxpHome"
done
