#!/usr/bin/env tclsh

# fetch input filename
set name [file rootname [lindex $argv 0]]

# read parsed file
set input [open "$name.num" r]
set data [read $input]
close $input

# convert decimal to raw binary format
set output [open "$name.bin" wb]
foreach word $data { puts -nonewline $output [binary format S $word] }
close $output

puts "Assembled raw binary file"
