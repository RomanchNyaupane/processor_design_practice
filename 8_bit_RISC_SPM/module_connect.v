`include "ALU.v";
`include "mux_1.v";
`include "mux_2.v";
`include "reg_y.v";
`include "memory.v";
`include "regx.v";
`include "pc.v";
`include "ir.v";
`include "control.v";
`include "tsb_1.v";
`include "tsb_2.v";

module module_connect( main_clk, main_rst );
input wire main_clk, main_rst;


//data paths - only output port names of modules will be used as datapath variables
wire [7:0] dp_bus_1, dp_bus_2;
wire [7:0] dp_mar_out, dp_pc_out, dp_ir_out;
wire [7:0] dp_reg_y_out, dp_alu_out, dp_mux_2_out, dp_mux_1_out, dp_memory_out;
wire dp_alu_z_flag_out, dp_z_flag_out; //zero flag outputs from ALU and z_flag_reg
wire [31:0] dp_reg_bank_out;



//control lines - only output name of controller will be used as control variables
wire ctrl_reg_y_wr_en, ctrl_alu_carry, ctrl_mem_wr_en, ctrl_mem_rd_en;
wire ctrl_mar_wr_en, ctrl_tsb_2_out_en, ctrl_tsb_1_out_en, ctrl_ir_wr_en, ctrl_ir_rd_ens;
wire [1:0] ctrl_mux_2_sel, ctrl_alu_opcode;
wire [2:0] ctrl_mux_1_sel;
wire [3:0] ctrl_reg_bank_rd_en, ctrl_reg_bank_wr_en;
wire ctrl_pc_dir, ctrl_pc_rd_en, ctrl_pc_wr_en, ctrl_pc_cnt;


control_unit ctrl_inst(
    main_clk, main_rst, ctrl_reg_bank_rd_en, ctrl_reg_bank_wr_en, ctrl_pc_rd_en, ctrl_pc_wr_en, ctrl_pc_cnt, ctrl_pc_dir,
    ctrl_ir_rd_en, ctrl_ir_wr_en, ctrl_mux_1_sel, ctrl_reg_y_wr_en, ctrl_mem_rd_en, ctrl_mem_wr_en, dp_alu_z_flag_out,
    ctrl_mux_2_sel, ctrl_mar_wr_en, ctrl_tsb_1_out_en, ctrl_tsb_2_out_en, dp_ir_out
);

ALU alu_inst(
    .ALU_in1(dp_reg_y_out),
    .ALU_in2(dp_bus_1),
    .ALU_out(dp_alu_out),
    .ALU_zero(dp_alu_z_flag_out),
    .ALU_opcode( dp_ir_out[6:4] )                 // remaining
);

reg_y reg_y_inst(
    .reg_y_in(dp_bus_2),
    .reg_y_out(dp_reg_y_out),
    .reg_y_clk(main_clk),
    .reg_y_rst(main_rst),
    .reg_y_wr_en(ctrl_reg_y_wr_en)
);

mux_2 mux_2_inst(
    .mux_2_in0(dp_alu_out),
    .mux_2_in1(dp_bus_1),
    .mux_2_in2(dp_memory_out),
    .mux_2_sel(ctrl_mux_2_sel),
    .mux_2_out(dp_mux_2_out)
);

memory mem_inst(
    .mem_in(dp_bus_1), 
    .mem_out(dp_memory_out), 
    .mem_addr(dp_mar_out), 
    .mem_clk(main_clk), 
    .mem_rst(main_rst), 
    .mem_wr_en(ctrl_mem_wr_en), 
    .mem_rd_en(ctrl_mem_rd_en)
);

addr_reg mar_inst(
    .addr_in(dp_bus_2),
    .addr_out(dp_mar_out),
    .addr_clk(main_clk),
    .addr_rst(main_rst),
    .addr_wr_en(ctrl_mar_wr_en)
);

tsb_1 tsb_1_inst(
    .tsb_1_in(dp_mux_1_out),
    .tsb_1_out(dp_bus_1),
    .tsb_1_out_en(ctrl_tsb_1_out_en)
);

tsb_2 tsb_2_inst(
    .tsb_2_in(dp_mux_2_out),
    .tsb_2_out(dp_bus_2),
    .tsb_2_out_en(ctrl_tsb_2_out_en)
);

mux_1 mux_1_inst(
    .mux_1_in1(dp_reg_bank_out[7:0]),
    .mux_1_in2(dp_reg_bank_out[15:8]),
    .mux_1_in3(dp_reg_bank_out[23:16]),
    .mux_1_in4(dp_reg_bank_out[31:24]),
    .mux_1_in5(dp_pc_out),
    .mux_1_sel(ctrl_mux_1_sel),
    .mux_1_out(dp_mux_1_out)
);
register_bank regsiter_bank_inst(
    .reg_in(dp_bus_2),
    .reg_out(dp_reg_bank_out),
    .reg_rd_en(ctrl_reg_bank_rd_en),
    .reg_wr_en(ctrl_reg_bank_wr_en),
    .reg_clk(main_clk),
    .reg_rst(main_rst)
);

program_counter pc_inst(
    .pc_in(dp_bus_2),
    .pc_out(dp_pc_out),
    .pc_clk(main_clk),
    .pc_rst(main_rst),
    .pc_dir(ctrl_pc_dir),
    .pc_count(ctrl_pc_cnt),
    .pc_rd_en(ctrl_pc_rd_en),
    .pc_wr_en(ctrl_pc_wr_en)
);

instr_reg ir_inst(
    .ir_in(dp_bus_2),
    .ir_out(dp_ir_out),
    .ir_rd_en(ctrl_ir_rd_en),
    .ir_wr_en(ctrl_ir_wr_en),
    .ir_clk(main_clk),
    .ir_rst(main_rst)
);


endmodule