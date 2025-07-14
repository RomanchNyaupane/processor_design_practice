/*
    instruction memory data output order of connection:
                                                                           tri
       a_reg  tri b_reg  alu  tri  in_cn    in_rg mx mar mem      pc       mem
    |rd,wr,shi|en|rd,wr|su,sta|en|rd,wr,dir|rd,wr|sl|rd|rd,wr|wr,rd,dir,cnt|en|rst|word_op
                            msb  ----->  lsb
*/
module instruction_memory(instr_mem_addr_in, instr_mem_data_out);
    input wire[15:0] instr_mem_addr_in; //8 bit address input from IR //8 bit counter input from instruction counter
    //output reg[31:0] instr_mem_data_out = 32'b00000000010000001000100000000000; //32 bit instruction output
    output reg[31:0] instr_mem_data_out;
    reg[31:0] instruction_memory[0:100]; // 4096 x 16-bit memory
    
    always @(*) begin
        // Read instruction from memory based on address input
        // only 26 bits are used. so leave 6bits at last as 0
        // fetch microcode - 00000000010000001000100000000000
        // decode microcode - 00000000010001000100001101000000
        // execute microcode - 00000000010010101000001001000000
    //instruction_memory[0] <= 32'b00000000010000001000100000000000;
    //instruction_memory[1] <= 32'b00000000010001000100001101000000;
//        instr_mem_data_out = instruction_memory[instr_mem_addr_in];
        //for main instructions
        case (instr_mem_addr_in[15:8])
            8'b0000: begin        //memory address 0 --LDA
                        case (instr_mem_addr_in[7:0])
                            8'b0000: instr_mem_data_out <= 32'b00000000010000001000100000001010;       //instruction counter address 0
                            8'b0001: instr_mem_data_out <= 32'b00000000010000000100001100001010;       //instruction counter address 1
                            8'b0010: instr_mem_data_out <= 32'b00000000010001000100000100001010;       //instruction counter address 2
                            8'b0011: instr_mem_data_out <= 32'b00000000010010101000000000001010;       //instruction counter address 3
                            
                            8'b0100: instr_mem_data_out <= 32'b00000000010000000100000100001010;       //instruction counter address 4--LDA
                            8'b0101: instr_mem_data_out <= 32'b01000000010000000100000101001010;       //instruction counter address 5--LDA
                            default: instr_mem_data_out <= 32'b00000000000000000000000000000000;
                        endcase
                    end 
            8'b0001: begin       //memory address 1
                        case (instr_mem_addr_in[7:0])
                            8'b0000: instr_mem_data_out <= 32'b00000000010000001000100000001010;       //instruction counter address 0
                            8'b0001: instr_mem_data_out <= 32'b00000000010000000100001100001010;       //instruction counter address 1
                            8'b0010: instr_mem_data_out <= 32'b00000000010001000100000100001010;       //instruction counter address 2
                            8'b0011: instr_mem_data_out <= 32'b00000000010010101000000000001010;       //instruction counter address 3
                            
                            8'b0100: instr_mem_data_out <= 32'b00000000010000000100000000001010;       //instruction counter address 4--LDB
                            8'b0101: instr_mem_data_out <= 32'b00000100010000000100000101001010;       //instruction counter address 5--LDB
                            default: instr_mem_data_out <= 32'b00000000000000000000000000000000;       //instruction counter address 4
                        endcase
                     end
            8'b0010:  begin       //memory address 2
                        case (instr_mem_addr_in[7:0])
                            8'b0000: instr_mem_data_out <= 32'b00000000010000001000100000001010;       //instruction counter address 0
                            8'b0001: instr_mem_data_out <= 32'b00000000010000000100001100001010;       //instruction counter address 1
                            8'b0010: instr_mem_data_out <= 32'b00000000010001000100000100001010;       //instruction counter address 2
                            8'b0011: instr_mem_data_out <= 32'b00000000010010101000000000001010;       //instruction counter address 3
                            
                            8'b0100: instr_mem_data_out <= 32'b10001000010000000000000001001010;       //instruction counter address 3--ADD
                            default: instr_mem_data_out <= 32'b00000000000000000000000000000000;
                        endcase
                     end
        endcase
        //for micro instructions

    end
endmodule