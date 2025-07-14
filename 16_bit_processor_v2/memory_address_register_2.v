module memory_address_register_2 (MAR_in, MAR_out, MAR_rd_en, MAR_wr_en, MAR_clk, MAR_rst);
    input wire[15:0] MAR_in;
    input MAR_rd_en, MAR_wr_en, MAR_clk, MAR_rst;

    output reg[15:0] MAR_out;

    reg[15:0] memory_address_register;
    always @(posedge MAR_clk)
        if (MAR_rst)
            memory_address_register <= 16'b0;
        else begin
            if (MAR_wr_en) memory_address_register <= MAR_in + 16'b1; // write new address value
        end
        
     always @(*) 
        MAR_out <= memory_address_register;
endmodule

/*
the always block executes all statements once. during that one execution, the main register gets value of input(thus instant seeming updating of register at write enable) but the output register still gets updated with old value of the main register. so at output, nothing seems to change.
until at next always block execution, the output register gets updated with the new value of the main register. so it seems like the output register is not getting updated at write enable, but it actually is. it just takes one clock cycle to reflect the change.
*/ 