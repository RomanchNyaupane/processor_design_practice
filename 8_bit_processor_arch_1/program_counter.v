module program_counter(
    input wire count_main_incr,
    input wire count_main_decr,
    input wire count_main_out_en,

    input wire count_main_rst,
    input wire count_main_clk,

    output reg [2:0] count_main_out
); 

reg [2:0] count_value;

always @ (posedge count_main_clk) begin
    if (count_main_rst == 1) begin

        count_value <= 3'b000;

    end else begin
        if (count_main_incr && count_value < 3'b111) begin
            count_value <= count_value + 1;
        end else if (count_main_decr && count_value > 3'b000) begin
            count_value <= count_value - 1;
        end
        if (count_main_decr) begin
            count_value <= count_value - 1;
        end

        if (count_main_out_en) begin
            count_main_out <= count_value;
        end else begin
            // Retain the previous value of count_main_out when count_main_out_en is low
            count_main_out <= 0;
        end
end

end

endmodule