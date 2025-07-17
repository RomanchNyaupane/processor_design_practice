// this is register bank module
module register(reg_in, reg_out, reg_rd_en, reg_wr_en, reg_rst, reg_clk);
input wire [7:0] reg_in;
input wire reg_rd_en, reg_wr_en, reg_rst, reg_clk;

output reg [7:0] reg_out;

reg [7:0] register;

always @(posedge reg_clk or posedge reg_rst) begin
    if (reg_rst) register <= 8'b0;
    else begin
        if(reg_wr_en) register <= reg_in;
    end
end

always @(*) begin
    if(reg_rd_en) reg_out = register;
    else reg_out = 8'b0;
end

endmodule


//register0 out- mux1 input 1
//register1 out- mux1 input 2
//register2 out- mux1 input 3
//register3 out- mux1 input 4
module register_bank(reg_in, reg_out, reg_rd_en, reg_wr_en, reg_rst, reg_clk);
    input wire [7:0] reg_in;
    input wire [3:0] reg_rd_en, reg_wr_en;
    input wire reg_clk, reg_rst;
    output wire [31:0] reg_out;

    genvar i;
    generate for (i=0; i<4; i=i+1) begin :reg_bank 
        register regsiter_bank_inst(
            .reg_in(reg_in),
            .reg_out(reg_out[i*8 +7 : i*8 ]),
            .reg_rd_en(reg_rd_en[i]),
            .reg_wr_en(reg_wr_en[i]),
            .reg_clk(reg_clk),
            .reg_rst(reg_rst)

        );
    end
    endgenerate
endmodule