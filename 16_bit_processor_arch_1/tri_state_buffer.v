module tri_state_buffer(tsb_in, tsb_out, tsb_en);
    input wire[15:0] tsb_in;
    output reg[15:0] tsb_out;
    input wire tsb_en;

    always @(*) begin
        tsb_out = tsb_en ? tsb_in : 16'bz; //when enabled, output the input else output high impedance
    end
endmodule