module instruction_counter(
    
    //input wire count_instr_out_en,

    input wire count_instr_rst,
    input wire count_instr_clk,

    output reg [2:0] count_instr_out
); 

reg [3:0] count_value;

always @ (posedge count_instr_clk) begin
    if (count_instr_rst == 1) begin

        count_value <= 3'b000;

    end else begin
        if (count_value < 4'b0111) begin
            count_value <= count_value + 1;
        end else if (count_value == 4'b1000) begin
            count_value <= 4'b0000;
        end

end

end
endmodule