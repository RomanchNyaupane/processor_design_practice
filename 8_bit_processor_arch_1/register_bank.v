module register_bank (
    input wire reg_clk,
    input wire reg_rst,

    input wire [7:0] reg_data_in,
    input wire [7:0] reg_result_in,
    output reg [7:0] reg_data_out1 = 8'b0,
    output reg [7:0] reg_data_out2 = 8'b0,


    input wire reg_selector, // // use dependent. on read, selects (reg0, reg1) or reg2. on write, selects reg0 or reg1
    input wire reg_write_enable,
    input wire reg_read_enable
);

reg[7:0] reg0 = 8'b0; //data1
reg[7:0] reg1 = 8'b0; //data2
reg[7:0] reg2 = 8'b0; //result

always @ (posedge reg_clk) begin
    if (reg_rst) begin
        reg0 <= 8'b0;
        reg1 <= 8'b0;
        reg2 <= 8'b0;
    end
    else begin
        reg2 <= reg_result_in;
        if (reg_write_enable) begin
        
            if (reg_selector == 0) begin
                reg0 <= reg_data_in;
            end 
            else begin
                reg1 <= reg_data_in;
            end
        end
        if (reg_read_enable == 1) begin
            if (reg_selector == 0) begin
                reg_data_out1 <= reg0;
                reg_data_out2 <= reg1;
            end 
            else begin
                reg_data_out2 <= reg2;
            end
            
        end
    end
end
endmodule