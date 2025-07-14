module memory (
    input wire [7:0] mem_addr,
    input wire [15:0] mem_data_in,
    input wire mem_rd_en,
    input wire mem_wr_en,
    input wire mem_clk,
    input wire mem_rst,
    input wire mem_addr_valid,
    input wire word_op,              // 0 = byte, 1 = word
    output reg [15:0] mem_data_out
);

    // 256 x 8-bit memory
    reg [7:0] memory [0:255];

    wire [7:0] address_upper = mem_addr;
    wire [7:0] address_lower = mem_addr + 1;

    //Synchronous write
    always @(posedge mem_clk) begin
        if (mem_rst) begin
            // Optional partial initialization — do only a few bytes
            memory[0] <= 8'b00000000;
            memory[1] <= 8'b00000110;
            memory[2] <= 8'b00000001;
            memory[3] <= 8'b00001000;
            memory[4] <= 8'b00000010;
            memory[6] <= 8'b10110011;
            memory[7] <= 8'b01000111;
            memory[8] <= 8'b11011000;
            memory[9] <= 8'b10001110;
        end else if (mem_wr_en && mem_addr_valid) begin
            if (word_op) begin
                memory[address_upper] <= mem_data_in[15:8];  // MSB
                memory[address_lower] <= mem_data_in[7:0];   // LSB
            end else begin
                memory[address_upper] <= mem_data_in[7:0];   // Byte operation
            end
        end
    end

    // Combinational read
    always @(*) begin
        if (mem_rd_en && mem_addr_valid) begin
            if (word_op) begin
                mem_data_out = {memory[address_upper], memory[address_lower]};
            end else begin
                mem_data_out = {8'hXX, memory[address_upper]};  // Only LSB valid
            end
        end else begin
            mem_data_out = 16'h0000;
        end
    end

endmodule
