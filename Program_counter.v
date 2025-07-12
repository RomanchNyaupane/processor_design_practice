// the program counter can be loaded in runtime. there are two types of such loading used.
// in one type of loading, the program counter is loaded with a new value from the data bus. this is for jump instructions.
// in the other type of loading, the program counter is loaded with the value from instruction register. this is for immedite
// branching in a single instruction cycle

module program_counter(count_in, count_out, count_rd_en, count_wr_en, count_clk, count_rst, count_dir, count); //count is for instruction to increase count or decrease count based on direction
input wire[7:0] count_in;
input count_clk, count_rst, count_wr_en, count_rd_en, count_dir, count; // count_dir: 0 for increment, 1 for decrement

output reg[7:0] count_out = 8'b0;

reg[7:0] program_counter;

always @ (posedge count_clk)
    if(count_rst)
        program_counter <= 8'b0;
        //count_out <= 8'b0;
        else begin
            if(count_wr_en) program_counter <= count_in; // write new count value
            if(count_rd_en) count_out <= program_counter; // read current count value
            if (count) begin
                if(!count_dir)
                    program_counter <= program_counter + 8'b00000001; // increment
                else
                    program_counter <= program_counter - 8'b00000001; // decrement
            end
        end
endmodule