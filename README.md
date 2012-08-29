config-parser
=============

Configuration (ini style) parser in Bash


Usage
-----
Just include config-parser.sh in your code, and then call it:

`# parse the configuration file`
`config_parse "/path/to/config/file.ini";`

`# load <my_section> from the ini file`
`config.section.<my_section>;`