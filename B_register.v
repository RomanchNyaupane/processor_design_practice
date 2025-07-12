module B_register(B_reg_in, B_reg_out, B_reg_rd_en,
                  B_reg_wr_en, B_reg_clk, B_reg_rst);
input wire[15:0] B_reg_in;
output reg[15:0] B_reg_out;

input B_reg_rd_en, B_reg_wr_en, B_reg_clk, B_reg_rst;

reg[15:0] B_register = 16'b0;
always @(posedge B_reg_clk) begin
    if(B_reg_rst)
        B_register <= 16'b0;
    else begin
        if(B_reg_rd_en) B_reg_out <= B_register;
        if(B_reg_wr_en) B_register <= B_reg_in;
    end
end
endmodule