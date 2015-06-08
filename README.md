config-parser
=============

Configuration (ini style) parser in Bash


About
-----

This script is freely inspired by [bash ini parser](http://ajdiaz.wordpress.com/2008/02/09/bash-ini-parser/) from ajdiaz.
It's a fast way to parse an ini-style configuration file and to load the variables in your main script.


License
-------

This script is under the MIT License. See LICENSE file.

Dependencies
------------

config-parser.sh uses `sed` to parse the ini file.


Usage
-----

Just include config-parser.sh in your code, and then call it:

	# parse the configuration file
	config_parser "/path/to/config/file.ini";
	# load <my_section> from the ini file
	config.section.<my_section>;


INI File example
----------------

	[dev]
	foo="bar";
	foofoo="foo";
	foofoofoo="$foofoo $foo";

	[prod]
	foo="foo";
	foofoo="bar";
	foofoofoo="$foofoo $foo";

If we run the following code against this example:

	source config-parser.sh;  # Either include the content of the file in your script, or source it for command line testing.
	config_parser "example.ini";
	config.section.dev;
	echo "$foofoofoo";
	config.section.prod;
	echo "$foofoofoo";

We'll get this output:

	foo bar
	bar foo
