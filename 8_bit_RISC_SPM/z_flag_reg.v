//this register holds the zero flag of ALU output
//actually it is just a flipflop
module z_flag_reg(z_flag_clk, z_flag_rst, z_flag_in, z_flag_out);
    input z_flag_clk, z_flag_rst, z_flag_in;
    output reg z_flag_out;

    always @(posedge z_flag_clk or posedge z_flag_rst) begin
        if (z_flag_rst) begin
            z_flag_out <= 1'b0; // Reset the zero flag to 0
        end else begin
            z_flag_out <= z_flag_in; // Update the zero flag with the input
        end
    end
endmodule