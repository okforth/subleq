#!/bin/bash

iverilog tb_memory.v memory.v -o run_memory
./run_memory
