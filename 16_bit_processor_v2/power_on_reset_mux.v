
module power_on_reset_mux(input1, input2, input_sel, output1);
    input wire input1, input2; // input1 is from power_on_reset_counter, input2 is from control unit
    input wire input_sel; // select line
    output reg output1; // output reset signal

    always @(*) begin
        if (input_sel) begin
            output1 = input1; // if sel is high, output is from power_on_reset_counter
        end else begin
            output1 = input2; // if sel is low, output is from control unit
        end
    end
endmodule