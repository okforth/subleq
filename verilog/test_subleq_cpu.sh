#!/bin/bash

iverilog -o simulation tb_subleq_cpu.v subleq_cpu.v memory.v
vvp simulation
