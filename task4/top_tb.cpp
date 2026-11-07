#include "Vtop.h"
#include "verilated.h"
#include "verilated_vcd_c.h"

#include "../vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env)
{
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges
    int last_data_out = 0x01; // previous value of data out 
    bool timing = false; // shows that I'm currently timing 
    int time_elapsed = 0;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtop *top = new Vtop;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("top.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("T4 : REACT");

    // initialize simulation inputs
    vbdSetMode(1);
    top->clk = 1;
    top->rst = 1;
    top->press = vbdFlag();
    top->N = 64;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        // Display toggle NeoPixel
        vbdBar(top->data_out & 0xFF);

        if((last_data_out == 0xff)&&(top->data_out == 0x00)){
            vbdInitWatch();
            timing = true;
        }

        while(timing){
            if(top->press = vbdFlag()){
                time_elapsed = vbdElapsed();
                timing = false;
                vbdHeader((std::to_string(time_elapsed) + " ms").c_str());
                // thinking of using vbdheader(time_elapsed)
                // but time elapsed is an integer need to temp show as string
            }
        }
        
        // set up input signals of testbench
        top->rst = (simcyc < 2); // assert reset for 1st cycle
        top->N = 64;
        top->press = vbdFlag();
        last_data_out = top->data_out;


        if (Verilated::gotFinish() || vbdGetkey() == 'q')
            exit(0);
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}
