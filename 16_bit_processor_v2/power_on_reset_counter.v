// this module will drive the reset signal to high for first four clock cycles at start.
// after that, it will drive the reset signal to low.

//there will be reset mux. it will have two inputs: one from this module and one from the control unit.
//the porc_select line of the mux will be from this module. once count of 4 is reached, the porc_select line will be low and the reset signal will be low.
//after that, the control unit can drive the reset signal high or low as needed.


module power_on_reset_counter(porc_clk, porc_rst_out, porc_sel_out);
    input porc_clk; // main clock signal
    output reg porc_sel_out;
    output reg porc_rst_out; // reset signal 
    reg [1:0] reset_counter = 2'b0; // 2-bit counter to count the fiporc_rst four clock cycles 
    reg count = 1'b1; 
    always @(posedge porc_clk) begin
        if(count == 1) begin
        reset_counter <= reset_counter + 2'b01;
            porc_rst_out <= 1;
            porc_sel_out <= 1;
        end
        if(reset_counter == 2'b01) begin
            count <= 0;
            porc_rst_out <= 0;
            porc_sel_out <= 0;
        end
        
    end
endmodule


