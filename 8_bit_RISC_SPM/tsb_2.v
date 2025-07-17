// this module is a tristate buffer connected to mux_2

module tsb_2(tsb_2_in, tsb_2_out, tsb_2_out_en);
    input wire [7:0] tsb_2_in;
    output wire [7:0] tsb_2_out;
    input wire tsb_2_out_en;

    assign tsb_2_out = tsb_2_out_en ? tsb_2_in : 8'bZ;
endmodule