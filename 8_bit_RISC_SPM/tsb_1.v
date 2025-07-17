// this module is a tristate buffer connected to mux_2

module tsb_1(tsb_1_in, tsb_1_out, tsb_1_out_en);
    input wire [7:0] tsb_1_in;
    output wire [7:0] tsb_1_out;
    input wire tsb_1_out_en;

    assign tsb_1_out = tsb_1_out_en ? tsb_1_in : 8'bZ;
endmodule