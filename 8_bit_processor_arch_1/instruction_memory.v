// The upper three bit of address is connected to program counter and lower three bit of address is connected to instruction counter
module instruction_memory (
    input wire [5:0] instr_mem_addr,
    output reg[7:0] instr_mem_data = 0'b0,
    
    input wire instr_mem_clk
);
reg [7:0] instr_mem[0:100];
always @(*) begin
    // Initialize instruction memory with some example instructions
    instr_mem[0] = 8'b11001101; // data -d:205, -h:cd
    instr_mem[1] = 8'b00110011; // opcode -d:51, -h:33
    instr_mem[2] = 8'b01100011; // data -d:99, -h:63
    instr_mem[3] = 8'b00110000; // opcode -d:48, -h:30
    instr_mem[4] = 8'b11111111; // dummy data -d:256 -h:ff
    instr_mem[5] = 8'b00000100; // opcode -d:192 -h:c0
    instr_mem[6] = 8'b11111111; // dummy data
    instr_mem[7] = 8'b11000000; // opcode
    /*instr_mem[8] = 8'b00001001; // data
    instr_mem[9] = 8'b00001010; // opcode*/
    case ({instr_mem_addr})
        6'b000000: instr_mem_data <= instr_mem[0];
        6'b000001: instr_mem_data <= instr_mem[1];
        6'b000010: instr_mem_data <= instr_mem[2];
        6'b000011: instr_mem_data <= instr_mem[3];
        6'b000100: instr_mem_data <= instr_mem[4];
        6'b000101: instr_mem_data <= instr_mem[5];
        6'b000110: instr_mem_data <= instr_mem[6];
        6'b000111: instr_mem_data <= instr_mem[7];
        
        // Add more cases as needed for the rest of the instructions
        default: instr_mem_data <= 8'b00000000; // Default case
    endcase
end
endmodule