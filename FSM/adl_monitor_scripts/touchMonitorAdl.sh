monDir="/opt/FSM/monitor/"

# Get a list of files that was received witin the specified time. 
# Loop through the files and echo the file name into corresponding monitored adl file
find /opt/FSM/adl_files -maxdepth 1 -mmin -2 -type f | sort | cut -d '/' -f 5 | while read filename;
do
	station="$(echo $filename | cut -d '_' -f 1)"
	if [ -e $monDir$station ]
	then
		echo $filename > $monDir$station
	fi
done 
