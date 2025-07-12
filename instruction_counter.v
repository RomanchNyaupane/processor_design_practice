module instruction_counter(IC_in, IC_out, IC_rd_en, IC_wr_en, IC_clk, IC_rst, IC_count_dir,);
    input wire[7:0] IC_in;
    input IC_rd_en, IC_wr_en, IC_clk, IC_rst, IC_count_dir; // count_dir: 0 for increment, 1 for decrement
    output reg[7:0] IC_out = 8'b0;

    reg[7:0] instruction_counter;
    always @(posedge IC_clk) begin
        if (IC_rst) begin
            instruction_counter <= 8'b0;
            IC_out = 8'b0;
        end else begin
            if (IC_wr_en) instruction_counter <= IC_in; // write instruction count value
            if (IC_rd_en) IC_out <= instruction_counter; // read instruction count value
            if(!IC_count_dir)
                instruction_counter <= instruction_counter + 1; // increment
            else
                instruction_counter <= instruction_counter - 1; // decrement
        end
    end
endmodule