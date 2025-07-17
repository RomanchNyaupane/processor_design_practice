/*
8 bit alu with 4 operations
opcode : 00 - add: in1 +in2
opcode : 01 - sub: in1-in2
opcode : 10 - and: in1 & in2
opcode : 11 - not: ~in2
*/

module ALU(ALU_in1, ALU_in2, ALU_opcode, ALU_out, ALU_zero);
    input [7:0] ALU_in1, ALU_in2;
    input [2:0] ALU_opcode;
    output reg [7:0] ALU_out;
    output reg ALU_zero;

    reg [8:0] ALU_result; // 9 bits to accommodate carry for addition and subtraction
    always @(*) begin
        case (ALU_opcode)
            3'b001: ALU_result = ALU_in1 + ALU_in2; // add
            3'b010: ALU_result = ALU_in1 - ALU_in2; // sub
            3'b011: ALU_result = ALU_in1 & ALU_in2; // and
            3'b100: ALU_result = ~ALU_in2; // not
            3'b101: ALU_result = 9'b0;       //nop
            default: ALU_result = 9'b0; // default case
        endcase

        // Assign the lower 8 bits to the output
        ALU_out = ALU_result[7:0];
        ALU_zero = (ALU_out == 0); // Zero flag

    end

endmodule