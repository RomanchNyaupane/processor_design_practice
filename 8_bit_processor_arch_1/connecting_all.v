`include "ALU.v"
`include "complement_2s.v"
`include "instruction_decoder.v"
`include "instruction_counter.v"
`include "instruction_memory.v"
`include "mux_1.v"
`include "register_bank.v"
`include "instr_mem_out_demux.v"
`include "program_counter.v"


module processor_8_bit(
    input wire main_clk
);

//nop wires
wire nop_1 ;
wire nop_2;
wire nop_3;
wire nop_4;

wire reset;

//declarations for register bank
wire reg_sel; //select line
wire reg_wr_en;
wire reg_rd_en;

// declarations for ALU
wire [7:0] alu_reg_bank_1;
wire [7:0] alu_reg_bank_2;
wire [7:0] alu_result;
wire [2:0] alu_opcode;
wire alu_read_en;

//declarations for 2s complement block
wire compl_en;
wire [7:0] compl_in;
wire [7:0] compl_out;
wire compl_carry;

//declarations for the mux_1
//wire [7:0] mux_input2;
//wire mux_select;
//wire [7:0] mux_output;

//declaratios for the program counter
wire count_incr;
wire count_decr;
wire count_out_en;
wire [2:0] prog_count_out;

//declarations for the instruction counter
wire [2:0] instr_count_out;
wire demux_sel_line ;
assign demux_sel_line = instr_count_out[0];

//declarations for the instruction memory
wire [5:0] instr_mem_addr = {prog_count_out, instr_count_out};
wire [7:0] instr_mem_data; //the data here means both operand and the opcode


//declarations for instruction memory output demux
wire [7:0] instr_mem_out_demux_data;
wire [7:0] instr_mem_out_demux_opcode;
//wire instr_mem_out_demux_sel; //the select line is connected to lowest bit of the instruction counter

//declarations for the instruction decoder
wire [1:0] decode_input_1 = instr_mem_out_demux_opcode[7:6];
wire [1:0] decode_input_2 = instr_mem_out_demux_opcode[5:4];
wire [1:0] decode_input_3 = instr_mem_out_demux_opcode[3:2];
wire [1:0] decode_input_4 = instr_mem_out_demux_opcode[1:0];


wire [3:0] decode_output_1;
wire [3:0] decode_output_2;
wire [3:0] decode_output_3;
wire [3:0] decode_output_4;

//declarations for control signals
assign reset = decode_output_1[3];
assign count_incr = decode_output_1[2];
assign alu_read_en = decode_output_1[1];
assign nop_1 = decode_output_1[0];


assign reg_wr_en = decode_output_2[3];
assign compl_en = decode_output_2[2];
assign alu_opcode[0] = decode_output_2[1];
assign nop_2 = decode_output_2[0];

assign count_out_en = decode_output_3[3];
assign alu_opcode[1] = decode_output_3[2];
assign reg_rd_en = decode_output_3[1];
assign nop_3 = decode_output_3[0];

assign reg_sel = decode_output_4[3];
assign count_decr = decode_output_4[2];
assign alu_opcode[2] = decode_output_4[1];
assign nop_4 = decode_output_4[0];

//assign reset = decode_output_1[0];

ALU ALU_instance(
    .ALU_clk( main_clk ),
    .ALU_rst( reset ),
    .ALU_input1( alu_reg_bank_1 ),
    .ALU_input2( alu_reg_bank_2 ),
    .ALU_operation( alu_opcode ),
    .ALU_read_enable( alu_read_en ),
    .ALU_result( alu_result ),
    .ALU_complement_carry( compl_carry ),
    .ALU_flags()
);

register_bank bank_instance(
    .reg_data_in( instr_mem_out_demux_data ),
    .reg_result_in( alu_result ),
    .reg_data_out1( compl_in ),
    .reg_data_out2( alu_reg_bank_2 ),
    .reg_selector( reg_sel ),
    .reg_write_enable( reg_wr_en ),
    .reg_read_enable( reg_rd_en ),
    .reg_clk( main_clk ),
    .reg_rst( reset )
);

complement_2s compl_instance(
    .complement_input( compl_in ),
    .complement_output( compl_out ),
    .complement_clk( main_clk ),
    .complement_rst( reset ),
    .complement_carry( compl_carry ),
    .complement_enable( compl_en )
);

mux_1 mux_1_instance(
    .mux_input1( 8'b0 ),
    .mux_input2( compl_out ), //to directly insert data from control unit
    .mux_select( 1'b1 ), //not yet decided
    .mux_output( alu_reg_bank_1 ),
    .mux_clk( main_clk )
);

program_counter prog_cnt_instance(
    .count_main_incr( count_incr ),
    .count_main_decr( count_decr ),
    .count_main_out_en( count_out_en ),
    .count_main_rst( reset ),
    .count_main_clk( main_clk ),
    .count_main_out( prog_count_out )
);

instruction_counter instr_cnt_instance(
    .count_instr_rst( reset ),
    .count_instr_clk( main_clk ),
    //.count_instr_out( instr_count_out )
    .count_value( instr_count_out )
);

instruction_memory instr_mem_instance(
    .instr_mem_addr( instr_mem_addr ), //concatenation of program counter and instruction counter for address
    .instr_mem_data( instr_mem_data ),
    .instr_mem_clk( main_clk )
);

instr_mem_out_demux demux_instance(
    .instr_mem_out_demux_input( instr_mem_data ),
    .instr_mem_out_demux_output_opcode( instr_mem_out_demux_opcode ),
    .instr_mem_out_demux_output_data( instr_mem_out_demux_data ),
    .instr_mem_out_demux_select( demux_sel_line ),
    .instr_mem_out_demux_clk( main_clk ),
    .instr_mem_out_demux_rst( reset )
);

instruction_decoder decode_instance_1(
    .decoder_input(decode_input_1),
    .decoder_output(decode_output_1)
);
instruction_decoder decode_instance_2(
    .decoder_input(decode_input_2),
    .decoder_output(decode_output_2)
);
instruction_decoder decode_instance_3(
    .decoder_input(decode_input_3),
    .decoder_output(decode_output_3)
);
instruction_decoder decode_instance_4(
    .decoder_input(decode_input_4),
    .decoder_output(decode_output_4)
);


endmodule