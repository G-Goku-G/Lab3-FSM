#!/bin/bash

# cleanup
rm -rf obj_dir
rm -f *.vcd

# Translate Verilog -> C++ including testbench
verilator   -Wall --trace \
            -cc lfsr_7.sv \
            --exe verify_7.cpp \
            --prefix "Vdut" \
            -o Vdut \
            -CFLAGS "-std=c++17 -isystem $(brew --prefix googletest)/include" \
            -LDFLAGS "-L$(brew --prefix googletest)/lib -lgtest -lgtest_main -lpthread" \

# Build C++ project with automatically generated Makefile
make -j -C obj_dir/ -f Vdut.mk

# Run executable simulation file
./obj_dir/Vdut
