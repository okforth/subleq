#!/usr/bin/env tclsh

# read file
set name [lindex $argv 0]
set input [open $name r]
set data [read $input]
close $input

# store a dictionary of labels
set address 0
foreach word $data {
	if {$word eq "next"} {
		incr address
		lappend pass1 $address
		continue;
	}
	set flag [regexp {^[A-Za-z]+[0-9]*:$} $word]
	if $flag {
		set name [string range $word 0 end-1]
		set labels($name) $address
		continue;
	}
	lappend pass1 $word
	incr address
}

# convert references to the labels its address values
foreach word $pass1 {
	set flag [regexp {^[A-Za-z]+[0-9]*$} $word]
	if $flag {
		set address $labels($word)
		lappend pass2 $address
		continue;
	}
	lappend pass2 $word
}

# convert string literals
foreach word $pass2 {
	set flag [regexp {^'\S'$} $word]
	if $flag {
		set char [string index $word 1]
		set value [scan $char %c]
		lappend pass3 $value
		continue;
	}
	lappend pass3 $word
}

set data $pass3

# write parsed assembly content to file
set name [file rootname [lindex $argv 0]]
set output [open "$name.num" w]
foreach word $data {puts $output $word} ;# REMOVE NONEWLINE?
close $output

puts "Assembled decimal file"

# convert parsed assembly to binary and hexadecimal formats
source to-bin.tcl ;# for C virtual machine
source to-hex.tcl ;# for Verilog simulation
