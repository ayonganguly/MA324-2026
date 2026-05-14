#!/bin/bash
# Start row in the csv file (students list)
StartRow=2
# End row in the csv file (students list)
EndRow=81
# Number of pages in each question cum answer script
# nopages=24

# Name of the csv file (students list) along with relative path with respect to current directory
datafile=./Admin/MA324.csv
# Name of the scanned document (pdf file) along with relative path with respect to current directory
inputfile=./Exams/ES-PART-B-MasterAnswerScripts.pdf
# Name of the directory (along with relative path with respect to current
# directory) where splitted files will be saved. 
outputdir=./Exams/ES-PART-B-graded/
splitappend=ESB

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
pwd
if [ ! -d "$outputdir" ]; then
   mkdir $outputdir;
fi; 
index=1
count=0
re='^[0-9]+$'
while IFS="," read -r roll name mark nopages
do
   if [[ $mark =~ $re ]];
   then
      count=$(( $count + 1 ))
      echo "Roll number: $roll (Booklet number: $count), Name: $name"
      pdftk $inputfile cat $index-$(( $index + $nopages - 1 )) output $outputdir/$splitappend-$roll.pdf
      index=$(( $index + $nopages ))
   fi
done < <(cut -d "," -f 1,2,6,8 $datafile | head -n $EndRow | tail -n $(( $EndRow - $StartRow + 1 )))

# In line 32: Please change 'Q1_' to any other thing that you want to prefix the
# file names.
# In line 35: after -f please mention the column number in csv file from
# which roll name and marks will be read.
