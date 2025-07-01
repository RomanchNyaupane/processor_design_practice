module ALU(
    input wire ALU_clk,
    input wire ALU_rst,
    input wire [7:0] ALU_input1,
    input wire [7:0] ALU_input2,

    input wire [2:0] ALU_operation, //Add, sub, and, or, nand, nor, xor, xnor
    input wire ALU_read_enable,
    input wire ALU_complement_carry, // Carry from the 2's complement operation

    
    output reg [7:0] ALU_result = 8'b0,
    output reg [7:0] ALU_flags = 8'b0
);

reg [7:0] ALU_input1_reg = 8'b0;
reg [7:0] ALU_input2_reg = 8'b0;
reg [8:0] ALU_result_reg = 8'b0;
reg [7:0] ALU_status_flag = 8'b0;

/*
status flags: bit 0 to bit 7
bit 0 - carry flag
bit 1 - all zeros flag (result register contains all zeros)
bit 2 - all ones flag (result register contains all ones)
bit 3 - parity flag (1 means even number of ones in result, 0 means odd number of ones in the result)
bit 4 - bit 4 - complement carry flag (1 means carry from the 2's complement operation, 0 means no carry)

*/

always @ (*) begin

if (ALU_rst == 1) begin
    ALU_result_reg <= 0;
    ALU_status_flag <= 0;
end
else begin
    ALU_input1_reg <= ALU_input1;
    ALU_input2_reg <= ALU_input2;
    case ({ALU_clk, ALU_operation})
        000 : ALU_result_reg <= ALU_input1_reg + ALU_input2_reg; //add
        001 : ALU_result_reg <= ALU_input1_reg & ALU_input2_reg; //and
        010 : ALU_result_reg <= ALU_input1_reg | ALU_input2_reg; //or
        011 : ALU_result_reg <= ~(ALU_input1_reg & ALU_input2_reg); //nand
        100 : ALU_result_reg <= ~(ALU_input1_reg | ALU_input2_reg); //nor
        101 : ALU_result_reg <= ALU_input1_reg ^ ALU_input2_reg; //xor
        110 : ALU_result_reg <= ~(ALU_input1_reg ^ ALU_input2_reg); //xnor
        111 : ALU_result_reg <= ALU_input1_reg + ALU_input2_reg; //sub
        default: ALU_result_reg <= ALU_input1_reg + ALU_input2_reg; //add as default operation
    endcase
        if (ALU_result_reg[8] == 1) begin
            ALU_status_flag[0] <= 1;
        end else begin
            ALU_status_flag[0] <= 0; //carry flag
        end
        if (ALU_result_reg == 0) begin
            ALU_status_flag[1] <= 1; //all zeros flag
        end else begin
            ALU_status_flag[1] <= 0;
        end
        if (ALU_result_reg == 8'hFF) begin
            ALU_status_flag[2] <= 1; //all ones flag
        end else begin
            ALU_status_flag[2] <= 0;
        end

        // Calculate parity flag
        ALU_status_flag[3] <= (((((((ALU_result_reg[0] ^ ALU_result_reg[1]) ^ ALU_result_reg[2]) ^ ALU_result_reg[3]) ^ALU_result_reg[4]) ^
                                  ALU_result_reg[5]) ^ ALU_result_reg[6]) ^ ALU_result_reg[7]);
        if (ALU_read_enable == 1) begin
            ALU_result <= ALU_result_reg[7:0];
        end
        if (ALU_complement_carry == 1) begin
            ALU_status_flag[4] <= 1'b1; // Add carry from the 2's complement operation
        end
end
end
endmodule