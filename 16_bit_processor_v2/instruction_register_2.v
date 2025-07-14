// this module stores address which is obtained from second fetch cycle of instruction fetch
module instruction_register_2(
    input wire [7:0] IR_2_in,
    input wire IR_2_rd_en,
    input wire IR_2_wr_en,
    input wire IR_2_clk,
    input wire IR_2_rst,
    output reg [7:0] IR_2_out
);

    reg [7:0] instruction_register_2;
    
    always @(posedge IR_2_clk or posedge IR_2_rst) begin
        if (IR_2_rst) begin
            instruction_register_2 <= 8'b0;
        end else if (IR_2_wr_en) begin
            instruction_register_2 <= IR_2_in; // write instruction value
        end
    end
    
    // Combinational output when read enable is asserted
    always @(*) begin
        if (IR_2_rd_en)
            IR_2_out = instruction_register_2;
        else
            IR_2_out = 8'b0;
    end
endmodule