//This is the instruction register
module instr_reg(ir_in, ir_out, ir_rd_en, ir_wr_en, ir_rst, ir_clk);
input wire [7:0] ir_in;
input wire ir_rd_en, ir_wr_en, ir_rst, ir_clk;

output reg[7:0] ir_out;

reg[7:0] instruction_register;

always @ (posedge ir_clk or posedge ir_rst) begin
    if(ir_rst) begin
        instruction_register <= 8'b0;
    end else begin
        if(ir_wr_en) instruction_register <= ir_in;
    end

end

always @(*) begin
    if(ir_rd_en)
        ir_out = instruction_register;
        else ir_out[7:4] = instruction_register[7:4];    // they correspond to address of a instruction in instruction memory. this should not change when the program is running, even when rd_en is running
end

endmodule