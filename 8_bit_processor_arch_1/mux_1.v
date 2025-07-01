// the mux will not be using clock. it will be purely combinational logic
// 8-bit Processor Architecture - Multiplexer Module
// This module implements a 2-to-1 multiplexer that selects between two 16-bit
// inputs based on a select signal. The output is a 16-bit value.

module mux1(
    input wire [15:0] mux_input1, //input1 is connected to 2s complement output
    input wire [15:0] mux_input2, //input 2 is connected to reg2
    input wire mux_select, // 0 for input1, 1 for input2
    output wire [15:0] mux_output
    );

always @(*) begin
    if (!mux_select) begin
        mux_output = mux_input1; // Select input1
    end else begin
        mux_output = mux_input2; // Select input2
    end

end
endmodule