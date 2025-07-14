// this is new version of memory i am implementing with 8 bit input and 8 bit output with 16 bit address

module memory_2(mem_data_in, mem_addr_in, mem_data_out, mem_rd_en, mem_wr_en, mem_clk, mem_rst);
    input wire [7:0] mem_data_in;
    input wire [15:0] mem_addr_in;
    input wire mem_rd_en, mem_wr_en, mem_clk, mem_rst;

    output reg[7:0] mem_data_out;
    reg [7:0] memory [0:4096];


            
    always @(posedge mem_clk) begin
    memory[0] <= 8'b00000000;
            memory[0] <= 8'b00000110;
            memory[1] <= 8'b00000111;
            memory[2] <= 8'b00000000;

            memory[6] <= 8'b01000111;
            memory[7] <= 8'b10001110;
            
        if (mem_rst) begin
            mem_data_out <= 8'b0;
        end else begin
            if(mem_rd_en) begin
                mem_data_out <= memory [mem_addr_in];
            end
            if(mem_wr_en) begin
                memory[mem_addr_in] <= mem_data_in;
            end
        end
    end
endmodule