# function to parse the ini style configuration file
function config_parser () {
	local iniFile="$1";
	local tmpFile=$( mktemp /tmp/`basename $iniFile`.XXXXXX );
	# create a tmpFiles mask, so we may delete multiple files at once
	local tmpFiles="${tmpFile%%??????}*";
	local intLines;
	local binSED=$( which sed );

	# clean up all remaining, specific tmpFiles before the run - then
	# newly created file will be kept for debugging purposes
	rm -f $tmpFiles;

	# copy the ini file to the temporary location
	cp $iniFile $tmpFile;

	# remove tabs or spaces around the =
	$binSED -i -e 's/[ \t]*=[ \t]*/=/g' $tmpFile;

	# transform section labels into function declaration
	$binSED -i -e 's/\[\([A-Za-z0-9_]*\)\]/config.section.\1() \{/g' $tmpFile;
	$binSED -i -e 's/config\.section\./\}\'$'\nconfig\.section\./g' $tmpFile;
	# add the reset call: reset some variables to defaults
	$binSED -i -e 's/\(\) {/ {\nreset;/g' $tmpFile;
	# remove the reset call from the reset function itself
	$binSED -i -e '/config\.section\.reset\(\)/{n;N;d}' $tmpFile;

	# remove first line
	#$binSED -i -e '1d' $tmpFile;
	# replace the first line withe the definition for the reset command, this will be called by all
	# function definied out of the iniFile sections, except for the "[reset]" section (if one exists)
	# to use this functionality, there has to be a section "[reset]" in the iniFile, where all default
	# values must be defined. Every section call will at first call the "reset;" command, so variables
	# used in several sections must only be defined, if they have other values as the section specific one.
	# If no "[reset]" section exists, the command quits the function without error messages
	$binSED -i -e '1 s/^.*$/function reset\(\) { config\.section\.reset 2\> \/dev\/null \|\| return 1; }\n/g' $tmpFile;
	
	# add the last brace
	echo -e "\n}" >> $tmpFile;

	# now load the file
	source $tmpFile;

	# clean up
	#rm -f $tmpFile;
}
