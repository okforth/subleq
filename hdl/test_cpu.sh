#!/bin/bash

iverilog -o simulation tb_cpu.v cpu.v
vvp simulation
