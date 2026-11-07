module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    input   logic       trigger,
    output  logic       cmd_seq,
    output  logic       cmd_delay,
    output  logic [7:0] data_out
);

    // Define our states
    typedef enum logic [3:0] {S0,S1,S2,S3,S4,S5,S6,S7,S8} states;
    states current_state, next_state;

    // State registers
    always_ff @(posedge clk) begin
        if (rst)    current_state <= S0;
        else        current_state <= next_state;
    end

    // next state logic
    always_comb begin
        next_state = current_state;

        case (current_state)
            S0:      if (trigger) next_state = S1;
            S1:      if (en)      next_state = S2;
            S2:      if (en)      next_state = S3;
            S3:      if (en)      next_state = S4;
            S4:      if (en)      next_state = S5;
            S5:      if (en)      next_state = S6;
            S6:      if (en)      next_state = S7;
            S7:      if (en)      next_state = S8;
            S8:      if (en)      next_state = S0;
            default:              next_state = S0;
        endcase
    end

    // Output logic
    always_comb begin
        case (current_state)
            S0:      data_out = 8'b0000_0000;
            S1:      data_out = 8'b0000_0001;
            S2:      data_out = 8'b0000_0011;
            S3:      data_out = 8'b0000_0111;
            S4:      data_out = 8'b0000_1111;
            S5:      data_out = 8'b0001_1111;
            S6:      data_out = 8'b0011_1111;
            S7:      data_out = 8'b0111_1111;
            S8:      data_out = 8'b1111_1111;
            default: data_out = 8'b0000_0000;
        endcase

        case (current_state)
            S0:      cmd_seq = 1'b0;
            S1:      cmd_seq = 1'b1;
            S2:      cmd_seq = 1'b1;
            S3:      cmd_seq = 1'b1;
            S4:      cmd_seq = 1'b1;
            S5:      cmd_seq = 1'b1;
            S6:      cmd_seq = 1'b1;
            S7:      cmd_seq = 1'b1;
            S8:      cmd_seq = 1'b0;
            default: cmd_seq = 1'b0;
        endcase
    end

    // cmd_delay logic
    always_comb begin
        case (current_state)
            S0:      cmd_delay = 1'b0;
            S1:      cmd_delay = 1'b0;
            S2:      cmd_delay = 1'b0;
            S3:      cmd_delay = 1'b0;
            S4:      cmd_delay = 1'b0;
            S5:      cmd_delay = 1'b0;
            S6:      cmd_delay = 1'b0;
            S7:      cmd_delay = en;
            S8:      cmd_delay = 1'b0;
            default: cmd_delay = 1'b0;
        endcase
    end

endmodule
