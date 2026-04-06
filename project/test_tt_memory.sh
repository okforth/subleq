#!/bin/bash

iverilog -o run_memory tb_tt_memory.v tt_memory.v
vvp run_memory
