#!/bin/bash

# ---------------------------------------------------------------
# plotdata.sh
# Version - 0.1
# ---------------------------------------------------------------
# This is a script to plot data from a data file using gnuplot
# For example, you have data files with format 
#
# 	#BlockSize IOPS Throughput CPU_Utilization Completion_Time
# 	.5  150.895217    73.679167 13.375000 6.627115
#	 1  132.336950   129.231667 13.750000 7.556469
#
# You can get a nice graph comparing CPU utilization by calling -
#		plotdata.sh 4 "CPU Utilization" hdd.dat ssd.dat
#
# Todo list:
#	1. Add option for output filename
#	2. Add option for titles in x axis
#	3. Add option for output file format
#
# ---------------------------------------------------------------

function usage() {
	echo "Usage: $(basename $0) <column> <ylabel> <filenames> ..."
	echo "Example: $(basename $0) 4 \"CPU Utilization\" perf*.dat"
}

if [ $# -lt 3 ]; then
	usage
	exit
fi

data_col=$1;shift
data_label=$1;shift
data_files="$@"
for f in $data_files
do
	bnames="$(basename $f| sed 's/\.[^.]*$//') $bnames"
done

gnuplot <<-GNU_EOF
reset
set terminal png enhanced font helvetica 10
set style line 1 lt 1 lw 2 pt 3 ps 0.5
set grid ytics lc rgb "#bbbbbb" lw 1 lt 0
set grid xtics lc rgb "#bbbbbb" lw 1 lt 0
set output "output.png"
set style data  lines
set xlabel "Block Size"
set ylabel "$data_label"
files = "$data_files"
titles = "$bnames"

plot for [i=1:words(files)] word(files,i) using $data_col:xticlabel(1) title word(titles,i) lw 2
GNU_EOF
