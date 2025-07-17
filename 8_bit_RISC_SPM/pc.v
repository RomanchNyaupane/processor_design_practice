// pc_dir: 0 - count up, 1 - count down
// pc_count: 0 - dont count, 1 - increase or decrease count based on direction pc_dir

module program_counter(pc_in, pc_out, pc_rd_en, pc_wr_en, pc_dir, pc_count, pc_clk, pc_rst);
input wire [7:0] pc_in;
input wire pc_rd_en, pc_wr_en, pc_dir, pc_count, pc_clk, pc_rst;
output reg[7:0] pc_out;

reg [7:0] program_counter;
always @ (posedge pc_clk or posedge pc_rst) begin
    if(pc_rst) program_counter <= 8'b0;
    else begin
        if(pc_wr_en) program_counter <= pc_in;
        if(!pc_dir) begin
            if(pc_count) begin
                program_counter <= program_counter + 8'b1;
            end 
        end else program_counter <= program_counter - 8'b1;
    end

end

always @ (*) begin
    if(pc_rd_en) pc_out = program_counter;
    else
    pc_out= 8'b0;
end

endmodule