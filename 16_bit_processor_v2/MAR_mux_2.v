// input1 is connected to program counter output, input2 is connected to lower byte data bus, input3 is connected to lower byte of instruction register output
// the output is connected to MAR register input 
module MAR_mux_2 (address_input1, address_input2, address_mux_select, address_mux_output);
input wire [15:0] address_input1, address_input2; // 8-bit inputs
input wire address_mux_select; // 2-bit select signal to choose input
output reg [15:0] address_mux_output; // 8-bit output
always @(*) begin
    case (address_mux_select)
        1'b0: address_mux_output = address_input1; // Select input1(PC output)
        1'b1: address_mux_output = address_input2; // Select input2(lower data bus)
        default: address_mux_output = 16'b0;
    endcase
end
endmodule
