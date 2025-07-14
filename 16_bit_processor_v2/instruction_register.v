module instruction_register(
    input wire [15:0] IR_in,
    input wire IR_rd_en,
    input wire IR_wr_en,
    input wire IR_clk,
    input wire IR_rst,
    output reg [15:0] IR_out
);

    reg [15:0] instruction_register;
    
    always @(posedge IR_clk or posedge IR_rst) begin
        if (IR_rst) begin
            instruction_register <= 16'b0;
        end else if (IR_wr_en) begin
            instruction_register <= IR_in; // write instruction value
        end
    end
    
    // Combinational output when read enable is asserted
    always @(*) begin
        if (IR_rd_en)
            IR_out = instruction_register;
        else
            IR_out[15:8] = instruction_register[15:8];  // the upper 8 bits drive the upper 8 bits of control module address which contains main instruction. the lower bits contain microinstructions.
    end
endmodule