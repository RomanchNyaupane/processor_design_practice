//synchronous write and combinational read
module memory(mem_in, mem_out, mem_addr, mem_clk, mem_rst, mem_wr_en, mem_rd_en);
    input wire [7:0] mem_in, mem_addr;
    input wire mem_rd_en, mem_wr_en, mem_clk, mem_rst;

    output reg [7:0] mem_out;

    reg [7:0] memory [0:255];
    always @(posedge mem_clk or posedge mem_rst) begin
        memory[0] <= 8'b01010000;
        memory[1] <= 8'b00001010;
        memory[2] <= 8'b01010001;
        memory[3] <= 8'b00001011;
        memory[4] <= 8'b00010001;
        memory[5] <= 8'b01100100;
        memory[6] <= 8'b00001110;
        memory[10] <= 8'b00110011;
        memory[11] <= 8'b01011100;
        
        if(mem_rst) begin
            mem_out <= 8'b0;
        end else begin
            if(mem_wr_en) memory[mem_addr] <= mem_in;
        end
    end
    
    always @(*) begin
        if(mem_rd_en) mem_out = memory[mem_addr];
        else mem_out = 8'b0;
    end
// comment this is important
endmodule