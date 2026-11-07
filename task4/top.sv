module top #(
    DELAY_WIDTH = 7,
    CLK_WIDTH = 8
)(
  // interface signals
  input  logic                  clk,        // clock 
  input  logic                  rst,        // reset
  input  logic [CLK_WIDTH-1:0]  N,     	    // clock divided by N+1
  input  logic                  press,      // pressing of encoder
  output logic [7:0]            data_out    // output for light
);

logic                   cmd_delay;
logic                   cmd_seq;
logic                   tick;
logic                   mux;
logic                   time_out;
logic [DELAY_WIDTH-1:0] k;

assign mux = cmd_seq ? tick : time_out;

f1_fsm myf1_fsm(
    .rst(rst),
    .en(mux),
    .trigger(press),
    .clk(clk),
    .data_out(data_out),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay)
);

clktick #(.WIDTH(CLK_WIDTH)) myclktick(
    .clk(clk),
    .rst(rst),
    .en(cmd_seq),
    .N(N),
    .tick(tick)
);

lfsr myifsr(
    .clk(clk),
    .rst(rst),
    .data_out(k)
);

delay #(.WIDTH(DELAY_WIDTH)) mydelay(
    .n(k),
    .clk(clk),
    .trigger(cmd_delay),
    .rst(rst),
    .time_out(time_out)
);

endmodule
