#!/bin/bash

iverilog -o run_subleq_cpu tb_tt_subleq_cpu.v tt_subleq_cpu.v tt_memory.v
vvp run_subleq_cpu
