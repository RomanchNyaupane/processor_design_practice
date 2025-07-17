/*
    input 0: alu out
    input 1: bus 1 (or out of mux 1)
    input 2: data memory out
*/
module mux_2(mux_2_in0, mux_2_in1, mux_2_in2, mux_2_sel, mux_2_out);
    input [7:0] mux_2_in0, mux_2_in1, mux_2_in2;
    input [1:0] mux_2_sel;
    output reg [7:0] mux_2_out;

    always @(*) begin
        case (mux_2_sel)
            2'b00: mux_2_out = mux_2_in0; // alu out
            2'b01: mux_2_out = mux_2_in1; // bus 1
            2'b10: mux_2_out = mux_2_in2; // memory out
            default: mux_2_out = 8'b0;
        endcase
    end
endmodule