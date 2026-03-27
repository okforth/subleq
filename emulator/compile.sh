#!/bin/bash

gcc emulator.c -o vm
./vm main.bin
