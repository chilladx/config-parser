# function to parse the ini style configuration file
config_parser () {
	local iniFile="$1";
	local tmpFile=$( mktemp /tmp/`basename $0`.XXXXXX );
	local intLines;
	local binSED=$( which sed );

	# copy the ini file to the temporary location
	cp $iniFile $tmpFile;

	# remove tabs or spaces around the =
	$binSED -i -e 's/[ \t]*=[ \t]*/=/g' $tmpFile;

	# transform section labels into function declaration
	$binSED -i -e 's/\[\([A-Za-z0-9]*\)\]/config.section.\1() \{/g' $tmpFile;
	$binSED -i -e 's/config\.section\./\}\'$'\nconfig\.section\./g' $tmpFile;

	# remove first line
	intLines=$( wc -l $tmpFile | awk '{ print $1}' );
	let "intLines=$intLines - 1";
	tail -n $intLines $tmpFile > $tmpFile-2;
	mv $tmpFile-2 $tmpFile;

	# add the last brace
	echo -e "\n}" >> $tmpFile;

	# now load the file
	source $iniFile;

	# clean up
	cat $tmpFile;
	rm -f $tmpFile;
}
