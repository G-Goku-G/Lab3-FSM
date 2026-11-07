module top #(
    parameter WIDTH = 8
)(
  // interface signals
  input  logic              clk,        // clock 
  input  logic              rst,        // reset
  input  logic              en,         // enable signal
  input  logic [WIDTH-1:0]  N,     	    // clock divided by N+1
  output logic  		    tick,        // tick output
  output logic [7:0]        data_out    // output for light
);

f1_fsm fsm(
    .rst(rst),
    .en(tick),
    .clk(clk),
    .data_out(data_out)
);

clktick #(.WIDTH(WIDTH)) ctik(
    .clk(clk),
    .rst(rst),
    .en(en),
    .N(N),
    .tick(tick)
);

endmodule
