module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    output  logic [7:0] data_out
);

    // Define our states
    typedef enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8} states;
    states current_state, next_state;

    // State registers
    always_ff @(posedge clk, posedge rst)
        if (rst)    current_state <= S0;
        else        current_state <= next_state;

    // next state logic
    always_comb begin
        next_state = current_state;     // default: stay in the same state
        if (en)
            case (current_state)
                S0:     next_state = S1;
                S1:     next_state = S2;
                S2:     next_state = S3;
                S3:     next_state = S4;
                S4:     next_state = S5;
                S5:     next_state = S6;
                S6:     next_state = S7;
                S7:     next_state = S8;
                S8:     next_state = S0;
                default: next_state = S0;
            endcase
    end

    // Output logic
    always_comb
        case (current_state)
            S0:     data_out = 8'b0000_0000;
            S1:     data_out = 8'b0000_0001;
            S2:     data_out = 8'b0000_0011;
            S3:     data_out = 8'b0000_0111;
            S4:     data_out = 8'b0000_1111;
            S5:     data_out = 8'b0001_1111;
            S6:     data_out = 8'b0011_1111;
            S7:     data_out = 8'b0111_1111;
            S8:     data_out = 8'b1111_1111;
            default: data_out = 8'b0000_0000;
        endcase

endmodule
