// this module is used to store memory address
module addr_reg(addr_in, addr_out, addr_clk, addr_rst, addr_wr_en);
    input [7:0] addr_in;
    input addr_clk, addr_rst, addr_wr_en;
    output reg [7:0] addr_out;

    reg [7:0] addr;
    always @(posedge addr_clk or posedge addr_rst) begin
        if (addr_rst) begin
            addr <= 8'b0; // Reset the address register to 0
        end else begin
            if (addr_wr_en) addr <= addr_in; // Write input to address register if write enable is high
        end
    end
    always @(*) begin
        addr_out = addr; // Output the current value of the address register
    end
endmodule
