/*
mux1 contains 5 inputs
input 0: register r0 out
input 1: register r1 out
input 2: register r2 out
input 3: register r3 out
input 4: program counter out
*/
module mux_1(mux_1_in1, mux_1_in2, mux_1_in3, mux_1_in4, mux_1_in5, mux_1_sel, mux_1_out);
    input [7:0] mux_1_in1, mux_1_in2, mux_1_in3, mux_1_in4, mux_1_in5;
    input [2:0] mux_1_sel;

    output reg[7:0] mux_1_out;

    always @(*) begin
        case(mux_1_sel)
            3'b000: mux_1_out = mux_1_in1;
            3'b001: mux_1_out = mux_1_in2;
            3'b010: mux_1_out = mux_1_in3;
            3'b011: mux_1_out = mux_1_in4;
            3'b100: mux_1_out = mux_1_in5;
            default: mux_1_out = 8'b0;
        
        endcase
    end

endmodule