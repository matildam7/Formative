#!/bin/bash
#run from formative directory
#run  bash code/02_data_explore.sh 
#------------------------------------------------------------------------------------------------------
#see what type of files the data are
file data/original/BMX_D.csv
file data/original/accel/accel-32330.txt 
#view the start of the data
head -n 3 data/original/BMX_D.csv
head -n 3 data/original/accel/accel-31268.txt
#view column names, tr swaps commas for new lines (\n)
head -n 1 data/original/BMX_D.csv | tr ',' '\n'
head -n 1 data/original/accel/accel-31268.txt | tr '\t' '\n'
head -n 2 data/original/accel/accel-31268.txt | tr '\t' '\n'

#count number of columns 
head -n 1 data/original/BMX_D.csv | awk -F, '{print NF}'
#How many participants have body measure data:
tail -n +2 data/original/BMX_D.csv | wc -l #counts lines starting from line 2 (skips header) 
#How many participants have accelerometer data:
ls data/original/accel/ | wc -l #counts total number of files (participants) in accel directory