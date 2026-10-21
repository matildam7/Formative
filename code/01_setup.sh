#!/bin/bash
#Before running, download the datasets from blackboard
#Run when working directory is formative
#To run:
# bash code/01_setup.sh
#-----------------------------------------------------------
#makes results directory and doesn't produce error message if directory already exists:
mkdir -p results 
#makes code directory
mkdir -p code
#makes data directory with original and derived directories within it
mkdir -p data/original data/derived/accel
#---------------------------------------------
#move the zip data and BMX data into the data/original folder
data_download_location=$@ #type directory path that data has downloaded into followed by accel.zip and BMX_D.csv after bash code/01_setup.sh
mv "$data_download_location" data/original/
#unzip the accelerometer data
unzip data/original/accel.zip 
#move the unzipped accel data back to data/original and then remove the zip folder  
mv accel data/original/
rm data/original/accel.zip