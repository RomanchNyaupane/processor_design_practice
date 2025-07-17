module reg_y(reg_y_in, reg_y_out, reg_y_clk, reg_y_rst, reg_y_wr_en);
    input wire [7:0] reg_y_in;
    input wire reg_y_clk, reg_y_rst, reg_y_wr_en;

    output reg [7:0] reg_y_out;
    reg [7:0] reg_y;

    always @(posedge reg_y_clk or posedge reg_y_rst) begin
        if (reg_y_rst) begin
            reg_y <= 8'b0;
        end else begin
            if (reg_y_wr_en) reg_y <= reg_y_in; // Write input to register if write enable is high
    end
    end

    always @(*) begin
        reg_y_out = reg_y; // Output the current value of the register
    end

endmodule