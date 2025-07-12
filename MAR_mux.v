// input1 is connected to program counter output, input2 is connected to lower byte data bus, input3 is connected to lower byte of instruction register output
// the output is connected to MAR register input 
module MAR_mux(MAR_mux_input1, MAR_mux_input2, MAR_mux_input3, MAR_mux_select, MAR_mux_output);
input wire [7:0] MAR_mux_input1, MAR_mux_input2, MAR_mux_input3; // 8-bit inputs
input wire [1:0] MAR_mux_select; // 2-bit select signal to choose input
output reg [7:0] MAR_mux_output; // 8-bit output
always @(*) begin
    case (MAR_mux_select)
        2'b00: MAR_mux_output = MAR_mux_input1; // Select input1(PC output)
        2'b01: MAR_mux_output = MAR_mux_input2; // Select input2(lower data bus)
        2'b10: MAR_mux_output = MAR_mux_input3; // Select input3(IR lower output)
        default: MAR_mux_output = 8'b0;
    endcase
end
endmodule