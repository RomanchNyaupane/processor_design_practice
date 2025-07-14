//This module is A_register or accumulator register. this module stores alu results and perform shifting operations

module A_register(A_reg_in, A_reg_out, A_reg_rd_en, A_reg_wr_en, A_reg_shift,A_reg_clk, A_reg_rst);    
                               //rd_en to read data from register
                               //wr_en to write data to register, reg_shift to perform shifting operation
input wire[15:0] A_reg_in;
input wire A_reg_rd_en, A_reg_wr_en, A_reg_clk, A_reg_shift, A_reg_rst;

output reg[15:0] A_reg_out;

reg[4:0] shift_value;   //stores direcrion and amount of shifting. required when performing shifting operation
                        //reg[4] for direction, reg[3:0] for amount of shifting
                        //reg[4] = 0 for right shift, reg[4] = 1 for left shift
reg[15:0] A_register;

always @ (posedge A_reg_clk) begin
    if (A_reg_rst) begin
        A_register <= 16'b0;
    end else begin
        if (A_reg_wr_en) A_register <= A_reg_in;
        if (A_reg_rd_en) A_reg_out <= A_register;
        if (A_reg_shift && A_reg_wr_en) begin
            shift_value <= A_reg_in[4:0]; // Assuming A_reg_in[4:0] contains the shift value
            if (shift_value[4]) begin
                A_register <= A_register >> shift_value;// Right shift
            end else begin
                A_register <= A_register << shift_value;
            end
        end
    end
end
endmodule