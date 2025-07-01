//the input of this module is connected to output of reg1
//the output of this module is connected to mux_1 input1
module complement_2s(
    input wire [7:0] complement_input,
    output reg [7:0] complement_output = 8'b0,
    input wire complement_clk,
    input wire complement_rst,
    output reg complement_carry = 1'b0,   //for status flag in ALU
    input wire complement_enable // Enable signal for the complement operation - 1 for enable, 0 for disable
);

reg [8:0] complement_result; //result can be 17 bits

always @(*) begin
    if (complement_rst == 1) begin
        complement_result <= 0; //Synchronous reset
    end
    else begin
        complement_result <= (~complement_input) + 1; // 2's complement operation
        if (complement_enable == 1) begin
            complement_output <= complement_result[7:0]; // Output the result if enabled
        end
        else begin
            complement_output <= complement_input; // Pass through input if not enabled
        end
        if (complement_result[8] == 1 & complement_enable == 1) begin
            complement_carry <= 1; // Set carry flag if the 17th bit is set
            // This indicates an overflow in the 2's complement operation in ALU status register
        end else begin
        complement_carry <= 0;
        end
    end
end
endmodule