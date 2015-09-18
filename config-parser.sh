# function to parse the ini style configuration file
config_parser () {
	local iniFile="$1";
	local tmpFile=$( mktemp /tmp/`basename $iniFile`.XXXXXX );
	local intLines;
	local binSED=$( which sed );

	# copy the ini file to the temporary location
	cp $iniFile $tmpFile;

	# remove tabs or spaces around the =
	$binSED -i -e 's/[ 	]*=[ 	]*/=/g' $tmpFile;

	# transform section labels into function declaration
	$binSED -i -e 's/\[\([A-Za-z0-9_]*\)\]/config.section.\1() \{/g' $tmpFile;
	$binSED -i -e 's/config\.section\./\}\'$'\nconfig\.section\./g' $tmpFile;

	# remove first line
	$binSED -i -e '1d' $tmpFile;

	# add the last brace
	echo -e "\n}" >> $tmpFile;

	# now load the file
	source $tmpFile;

	# clean up
	rm -f $tmpFile;
}
