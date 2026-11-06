module lfsr_7(
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [6:0] data_out
);

logic [6:0] sreg;

always_ff @(posedge clk, posedge rst) begin
    if (rst)
        sreg <= {6'b0,1'b1};
    else if (en)
        sreg <= {sreg[5:0], sreg[6] ^ sreg[2]};
end

assign data_out = sreg;

endmodule
