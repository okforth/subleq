#!/usr/bin/env tclsh

# fetch input filename
set name [file rootname [lindex $argv 0]]

# read parsed.asm file
set input [open "$name.num" r]
set data [read $input]
close $input

# convert decimal to hex format for Verilog
set output [open "$name.hex" wb]
foreach word $data {
	# "string range" is used to handle signed 16-bit values
	set line [string range [format %04X $word] end-3 end]
	puts $output $line
}
close $output

puts "Assembled hex file"
