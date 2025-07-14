// in1 is connected to A register output, in2 is connected to B register output
// alu_out is connected to A register input

// alu_status_out_en triggers of output of alu status register to A_register
module ALU(ALU_in1, ALU_in2, ALU_out, ALU_sub_en, ALU_status_out_en);
    input wire[15:0] ALU_in1, ALU_in2;
    input wire ALU_sub_en, ALU_status_out_en;
    output wire[15:0] ALU_out;

    wire [16:0] alu_result; //16th bit is carry. 0th to 15th are sum or difference bits
    reg [3:0] alu_status;

    //assign ALU_out  = ALU_sub_en ? (ALU_in1 - ALU_in2) : ALU_in1 + ALU_in2;  <--dont use because this methods prevents reading of status register
    assign alu_result = ALU_sub_en ? (ALU_in1 - ALU_in2) : (ALU_in1 + ALU_in2);
    assign ALU_out = ALU_status_out_en ? alu_status : alu_result[15:0];
    always @(*) begin           //the always block is a procedural block. so usage blocking and non blocking assignments should be focused during assignment
            /*alu_status[0] <= (alu_result === 16'h0000);
            alu_status[1] <= (alu_result === 16'hFFFF);
            alu_status[2] <= alu_result[16];
            alu_status[3] <= ^alu_result[15:0];*/

            alu_status[0] = (alu_result == 16'h0000); // zero flag
            alu_status[1] = (alu_result == 16'hFFFF); // 1 flag
            alu_status[2] = alu_result[16]; // carry flag
            alu_status[3] = ^alu_result[15:0]; //parity flag. 1 for odd parity, 0 for even parity
    end
    // WARNING: Non-blocking assignments (<=) used in a combinational always block.
// In actual FPGA hardware, synthesis tools may interpret this incorrectly or unpredictably:
// - Synthesis tools do not simulate delta cycles; they must map the logic to real gates and wires.
// - Non-blocking assignments imply register-like behavior, which may cause synthesis tools to infer
//   latches or ignore the intent of immediate logic propagation.
// - As a result, alu_status bits may not reflect the correct alu_result values instantly, causing functional mismatches.
// - Even if it synthesizes, the output may glitch, lag, or remain stuck due to improper hardware mapping.
// RECOMMENDATION: Use blocking assignments (=) inside always @(*) blocks to ensure correct combinational behavior, immediate
// signal propagation, and synthesis consistency.
endmodule