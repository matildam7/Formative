#!/bin/bash
#checking that all accelerometer files have the same header line
#run from formative directory
#run bash code/03_data_processing.sh
#----------------------------------------------------------------------------------------------------------------
#checking that all accelerometer files have the right number of columns on each row of each file
awk 'FNR == 2' data/original/accel/accel-*.txt | sort -u
#there are the right number of columns on each row of each file
awk -F, '{print NF}' data/original/BMX_D.csv | sort -nu #each line has 28 columns
awk -F'\t' 'FNR > 1 {seen[NF] = 1} END {for (n in seen) print n}' data/original/accel/accel-*.txt
#some participants have 3 columns (appropriate number) but others have 3

#find the number of lines in files with 3 columns 
awk -F'\t' 'FNR > 1 && NF == 3 {print FILENAME}' data/original/accel/accel-*.txt | sort -u 
# 2 files with participants 31268 and 34974 have only 3 columns

#view line numbers for these files
wc -l data/original/accel/accel-31268.txt data/original/accel/accel-34974.txt
#31268 has 10092 lines
#34974 has 10097 lines

#work out how many lines there should be in the files
wc -l data/original/accel/accel-*.txt | grep -v total | awk '{print $1}' | sort -n | uniq -c
#identify that the extra lines just have na
awk 'FNR > 10082' data/original/accel/accel-31268.txt data/original/accel/accel-34974.txt | sort -u

#clean the files and move them to derived folder
for file in data/original/accel/accel-*.txt 
do 
awk -F'\t' 'FNR == 1 || NF == 8' $file > data/derived/accel/`basename $file`
done

#check number of files is correct
ls data/derived/accel/ | wc -l

#getting the file names for accelerometer ids
ls data/derived/accel | grep -Eo '[0-9]+' > data/derived/accel_ids.txt

#getting ids with bmi data 
awk -F, 'NR > 1 && $12 != "NA" {print $2}' data/original/BMX_D.csv > data/derived/bmi_ids.txt

#getting all ids 
awk -F, 'NR > 1 {print $2}' data/original/BMX_D.csv > data/derived/all_ids.txt