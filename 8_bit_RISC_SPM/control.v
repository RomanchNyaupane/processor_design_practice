module control_unit(
    in_clk, in_rst, reg_rd_en, reg_wr_en, pc_rd_en, pc_wr_en, pc_cnt, pc_dir,
    ir_rd_en, ir_wr_en, mux_1_sel, reg_y_wr_en, mem_rd_en, mem_wr_en, z_flag_in,
    mux_2_sel, addr_wr_en, tsb_1_en, tsb_2_en, instr
);

input wire in_clk, in_rst;
input wire [7:0] instr;
input wire z_flag_in;

output reg pc_rd_en, pc_wr_en, pc_cnt, pc_dir, ir_rd_en, ir_wr_en, reg_y_wr_en;
output reg mem_rd_en, mem_wr_en;
output reg [3:0] reg_rd_en, reg_wr_en;

output wire [1:0] mux_2_sel;
output wire [2:0] mux_1_sel;
output reg tsb_1_en, tsb_2_en, addr_wr_en;


wire [3:0] opcode;
wire [1:0] src_reg, dst_reg;


parameter s1 = 4'd1; //idle
parameter s2 = 4'd2; //fetch 1
parameter s3 = 4'd3; //fetch 2
parameter s4 = 4'd4; //decode
parameter s5 = 4'd5; //execute cycle 1
parameter s6 = 4'd6; //rd cycle 1
parameter s7 = 4'd7;
parameter s8 = 4'd8;
parameter s9 = 4'd9;
parameter s10 = 4'd10;
parameter s11 = 4'd11;
parameter s12 = 4'd12;

reg [3:0] state, next_state;
reg sel_alu, sel_bus_1, sel_bus_2;

assign opcode = instr[7:4];
assign src_reg = instr[3:2];
assign dst_reg = instr[1:0];

/*
opcode list                 state list
    0000 - nop                  s1, s2, s3, s4, s5, s6, s7, s8
    0001 - add              
    0010 - sub              
    0011 - and              
    0100 - not              
    0101 - rd               
    0110 - wr               
    0111 - br               
    1000 - brz              

*/
assign mux_1_sel = reg_rd_en[0] ? 0 :
                   reg_rd_en[1] ? 1 :
                   reg_rd_en[2] ? 2 :
                   reg_rd_en[3] ? 3 :
                   pc_rd_en     ? 4 :
                   3'b1xx;
assign mux_2_sel = sel_alu? 0 : sel_bus_1? 1 : mem_rd_en? 2 : 2'b1x;

always @ ( posedge in_clk) begin
    if (in_rst) state <= s1; else state <= next_state;
end
always @ (state or opcode or src_reg or dst_reg or z_flag_in) begin
    reg_rd_en = 0; reg_wr_en = 0;  pc_rd_en = 0;  pc_wr_en = 0;  pc_cnt = 0;
    pc_dir = 0; ir_rd_en = 0;  ir_wr_en = 0;  reg_y_wr_en = 0; 
    mem_rd_en = 0;  mem_wr_en = 0; addr_wr_en = 0;
    tsb_1_en = 1; tsb_2_en = 1;

    sel_bus_1 = 0; sel_bus_2 = 0; sel_alu = 0;
    case(state)
        s1: next_state = s2;
        s2: begin
                pc_rd_en = 1;
                addr_wr_en = 1;
                sel_bus_1 = 1;
                tsb_1_en = 1;
                tsb_2_en = 1;
                next_state = s3;
            end
        s3: begin
                ir_wr_en = 1;
                mem_rd_en = 1;
                tsb_2_en = 1;
                pc_cnt = 1;
                next_state = s4;
            end
        s4: begin 
                ir_rd_en = 1;
                case(opcode) 
                    4'b0000: next_state = s2;           //np
                    4'b0001, 4'b0010, 4'b0011: begin    //add, sub, and
                        reg_y_wr_en = 1;
                        sel_bus_1 = 1;
                        next_state = s5;
                        case(dst_reg) 
                            2'b00: reg_rd_en[0] = 1;
                            2'b01: reg_rd_en[1] = 1;
                            2'b10: reg_rd_en[2] = 1;
                            2'b11: reg_rd_en[3] = 1;
                            default: reg_rd_en = 0;
                        endcase
                    end
                    4'b0100: begin //not

                        case (src_reg) 
                            2'b00: reg_rd_en[0] = 1;
                            2'b01: reg_rd_en[1] = 1;
                            2'b10: reg_rd_en[2] = 1;
                            2'b11: reg_rd_en[3] = 1;
                            default: reg_rd_en = 0;
                        
                        endcase
                        sel_alu = 1;
                        next_state = s2;
                        
                        case (dst_reg) 
                            2'b00: reg_wr_en[0] = 1;
                            2'b01: reg_wr_en[1] = 1;
                            2'b10: reg_wr_en[2] = 1;
                            2'b11: reg_wr_en[3] = 1;
                            default: reg_wr_en = 0;
                        
                        endcase
                    end
                    4'b0101: begin     //rd
                        pc_rd_en = 1;
                        sel_bus_1 = 1;
                        addr_wr_en = 1;
                        next_state = s6;   //to next part of read operation
                    end
                    4'b0110: begin     //wr
                        pc_rd_en = 1;
                        sel_bus_1 = 1;
                        addr_wr_en = 1;
                        next_state = s8;     //to next part of write operation
                    end 
                    4'b0111: begin     //branch instruction. 2 byte instruction. jump to another address
                        pc_rd_en = 1;
                        sel_bus_1 = 1;
                        addr_wr_en = 1;
                        next_state = s10;
                    end
                    4'b1000: if(z_flag_in) begin     //branch at zero
                        pc_rd_en = 1;
                        sel_bus_1 = 1;
                        addr_wr_en = 1;
                        next_state = s10;
                    end else begin
                        pc_cnt = 1;
                        next_state = s2;
                    end
                    default: next_state = s12;   //halt is default case
                
                endcase
            end
        s5: begin           //execution phase of add, sub, and operations
                sel_alu = 1;
                tsb_1_en = 1;
                tsb_2_en = 1;
                next_state = s2;        //change state after execution complete
                case (src_reg) 
                2'b00: reg_rd_en[0] = 1; 
                2'b01: reg_rd_en[1] = 1; 
                2'b10: reg_rd_en[2] = 1; 
                2'b11: reg_rd_en[3] = 1; 
                default: reg_rd_en = 0;
                endcase
                
                case (dst_reg) 
                2'b00: reg_wr_en[0] = 1;
                2'b01: reg_wr_en[1] = 1;
                2'b10: reg_wr_en[2] = 1;
                2'b11: reg_wr_en[3] = 1;
                default: reg_wr_en[0] = 0;
                endcase
                
            end
        s6: begin           //next part of read operation
                mem_rd_en = 1;
                pc_cnt = 1;
                next_state = s7;        
                addr_wr_en = 1;
            end
        s7: begin           //final part of read operation
                mem_rd_en = 1;
                next_state = s2;
                case (dst_reg) 
                    2'b00: reg_wr_en[0] = 1;
                    2'b01: reg_wr_en[1] = 1;
                    2'b10: reg_wr_en[2] = 1;
                    2'b11: reg_wr_en[3] = 1;
                    default: reg_wr_en = 0;
                
                endcase
            end
        s8: begin   //next part of write operation
                mem_rd_en = 1;
                pc_cnt = 1;
                addr_wr_en = 1;
                next_state = s9;
                
            end
        s9: begin //final part of write operation
                mem_wr_en = 1;
                next_state = s2;
                case(src_reg) 
                    2'b00: reg_rd_en[0] = 1;
                    2'b01: reg_rd_en[1] = 1;
                    2'b10: reg_rd_en[2] = 1;
                    2'b11: reg_rd_en[3] = 1;
                    default: reg_rd_en = 0;
                
                endcase
            end    
            
        s10: begin   // next part of branch operation. fetching address to jump
                mem_rd_en = 1;  //gives data which contains address of location to jump
                addr_wr_en = 1;
                next_state = s9;
            end
        s11: begin //final part of branch instruction - loading the address to jump
                mem_rd_en = 1;
                pc_wr_en = 1;
                next_state = s2;
            end
        s12: next_state = s12; //halt instruction
        default: next_state = s1;
    endcase

end

endmodule