#include "Vf1_fsm.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "vbuddy.cpp"

int main(int argc, char **argv, char **env){
    int i;
    int clk;

    Verilated::commandArgs(argc,argv);
    //init top verilog instance
    Vf1_fsm* top = new Vf1_fsm;
    //init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("f1_fsm.vcd");

    if (vbdOpen()!=1) return(-1);
    vbdHeader("Lab 3");

    //initilise simulation inputs
    top->clk = 1;
    top->rst = 0;
    vbdSetMode(1);
    top->en = vbdFlag();

    //the simulation loop
    for (i = 0; i < 100000 ; i++){
        //dump the variables into VCD file and toggle clock
        for (clk = 0; clk < 2; clk++){
            tfp->dump(2*i + clk);
            top->clk = !top->clk;
            top->eval();
        }
        vbdBar(top->data_out & 0xFF);
        if (Verilated::gotFinish() || (vbdGetkey()=='q')) exit(0);

        top->rst = i < 2 ;
        top->en = vbdFlag();
        vbdCycle(i);
    }
    vbdClose();
    tfp->close();
    exit(0);
}