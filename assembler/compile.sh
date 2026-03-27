#!/bin/bash

./assembler.tcl main.asm
cp main.bin ../emulator
cp main.hex ../verilog
