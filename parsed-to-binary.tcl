#!/usr/bin/env tclsh

# read parsed.asm file
set input [open parsed.asm r]
set data [read $input]
close $input

# convert decimal to binary format, write to out.bin
set output [open out.bin wb]
foreach word $data { puts -nonewline $output [binary format S $word] }
close $output
