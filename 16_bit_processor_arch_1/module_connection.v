`include "instruction_counter.v"
`include "instruction_memory.v"
`include "MAR_mux.v"
`include "memory_address_register.v"
`include "A_register.v"
`include "B_register.v"
`include "ALU.v"
`include "instruction_register.v"
`include "memory.v"
`include "Program_counter.v"
`include "tri_state_buffer.v"
`include "power_on_reset_counter.v"
`include "power_on_reset_mux.v"

//dp stands for data path
//ctrl stands for control signals

/*
    instruction memory data output order of connection:
                                                                                          tri
       a_reg    tri   b_reg   alu   tri    in_cn    in_rg  mx  mar     mem      pc        mem
    |rd,wr,shi| en | rd,wr |su,sta| en  |rd,wr,dir| rd,wr |sl| rd  | rd,wr |wr,rd,dir,cnt| en | rst | word_op
                            msb  ----->  lsb
*/

module module_connect(main_clk);
    input main_clk;
    
    wire main_reset;  //reset signal from control unit
    wire power_on_reset; //reset signal from power on reset counter
    wire master_reset; //reset signal after power on reset mux

    //control - byte access or word access - this signal is connected to memory
    wire ctrl_word_op; // 0 for byte access, 1 for word access

    //porc counter and mux
    wire porc_sel;

    // control signal outputs
    //a_register
    wire ctrl_a_reg_rd_en, ctrl_a_reg_wr_en, ctrl_a_reg_shift;
    wire ctrl_a_reg_bus_out_en; // enable for tristate buffer output from A register to bus
    //alu
    wire ctrl_alu_sub_en, ctrl_alu_status_out_en;
    wire ctrl_alu_bus_out_en; // enable for tristate buffer output from alu to bus
    //b_register
    wire ctrl_b_reg_rd_en, ctrl_b_reg_wr_en;

    //instruction counter
    wire ctrl_ic_rd_en, ctrl_ic_wr_en, ctrl_ic_count_dir;
    //instruction register
    wire ctrl_ir_rd_en, ctrl_ir_wr_en;
    //MAR_mux
    wire[1:0]  ctrl_mar_mux_sel;
    //MAR
    wire ctrl_mar_wr_en;
    //memory
    wire ctrl_mem_rd_en, ctrl_mem_wr_en, ctrl_mem_bus_out_en, ctrl_mem_addr_valid;
    //Program counter
    wire ctrl_count_wr_en, ctrl_count_rd_en, ctrl_count_dir, ctrl_count;


    // control signals
    wire [0:31] control_signals;
    assign ctrl_a_reg_rd_en = control_signals[0]; //A register read enable
    assign ctrl_a_reg_wr_en = control_signals[1]; //A register write enable
    assign ctrl_a_reg_shift = control_signals[2]; //A register shift enable
    assign ctrl_a_reg_bus_out_en = control_signals[3]; //A register bus output enable(tristate buffer output enable)

    assign ctrl_b_reg_rd_en = control_signals[4]; //B register read enable
    assign ctrl_b_reg_wr_en = control_signals[5]; //B register write enable

    assign ctrl_alu_sub_en = control_signals[6]; //ALU subtract enable
    assign ctrl_alu_status_out_en = control_signals[7]; //ALU status output enable
    assign ctrl_alu_bus_out_en = control_signals[8]; //ALU bus output enable(tristate buffer output enable)

    assign ctrl_ic_rd_en = control_signals[9]; //Instruction counter read enable
    assign ctrl_ic_wr_en = control_signals[10]; //Instruction counter write enable
    assign ctrl_ic_count_dir = control_signals[11]; //Instruction counter count direction (0 for increment, 1 for decrement)

    assign ctrl_ir_rd_en = control_signals[12]; //Instruction register read enable
    assign ctrl_ir_wr_en = control_signals[13]; //Instruction register write enable

    assign ctrl_mar_mux_sel = control_signals[14:15]; //MAR mux select lines (2 bits)

    assign ctrl_mar_wr_en = control_signals[16]; //MAR write enable

    assign ctrl_mem_rd_en = control_signals[17]; //Memory read enable
    assign ctrl_mem_wr_en = control_signals[18]; //Memory write enable
    assign ctrl_mem_addr_valid = 1;

    assign ctrl_count_wr_en = control_signals[19]; //Program counter write enable
    assign ctrl_count_rd_en = control_signals[20]; //Program counter read enable
    assign ctrl_count_dir = control_signals[21]; //Program counter count direction (0 for increment, 1 for decrement)
    assign ctrl_count = control_signals[22]; //Program counter count signal (0 for increment, 1 for decrement)

    assign ctrl_mem_bus_out_en = control_signals[23]; //Memory bus output enable(tristate buffer output enable)

    assign main_reset = control_signals[24]; //Main reset signal
    assign ctrl_word_op = control_signals[25]; //Word operation signal (0 for byte access, 1 for word access)
    assign ctrl_ic_rst = control_signals[26]; //Instruction counter reset

    //data paths - alu and registers
    wire [15:0] dp_a_reg_out, dp_b_reg_out; //outputs from A and B registers. they are connected to alu inputs and to tristate buffer
    wire [15:0] dp_alu_out; //output of alu connected to tristate for bus.

    //data paths - instruction register
    wire [15:0] dp_ir_out; //output of instruction register
    wire [7:0] dp_ir_out_upper_byte, dp_ir_out_lower_byte; //upper and lower byte of instruction register output
    //assign dp_ir_upper_byte = dp_ir_out[15:8]; //upper byte of instruction register output
    assign dp_ir_out_lower_byte = dp_ir_out[7:0]; //lower byte of instruction register

    //data paths - mar mux
    wire [7:0] dp_mar_mux_out; //output of MAR mux, connected to MAR input

    //data paths - program counter
    wire [7:0] dp_pc_out; //output of program counter, connected to MAR mux input1

    //data path - memory
    wire [15:0] dp_memory_out; //memory data-, connected to busline by tristate buffer
    wire [15:0] dp_memory_in;
    wire [7:0] dp_memory_addr; //input address to memory, 
    
    //data path - instruction counter
    wire [7:0] dp_ic_out; //output of instruction counter, connected to control unit
    wire ctrl_ic_rst;
    wire ic_rst;
    assign ic_rst = master_reset | ctrl_ic_rst;
    //wire [7:0] dp_ic_in; //input to instruction counter, connected to lower busline

    //data path - bus line
    wire [15:0] dp_bus_line;
    assign dp_lower_bus_line = dp_bus_line[7:0]; //lower byte of bus line
    assign dp_upper_bus_line = dp_bus_line[15:8]; //upper byte of

    //data path - instruction memory
    wire[15:0] dp_instr_mem_addr;
    //assign dp_instr_mem_addr = {dp_ir_upper_byte, dp_ic_out};
    assign dp_instr_mem_addr = { dp_ir_out[15:8],  dp_ic_out };
    
    
    power_on_reset_counter PORC_instance(
        .porc_clk( main_clk ),
        .porc_rst_out( power_on_reset ),
        .porc_sel_out( porc_sel )
        
    );
    power_on_reset_mux POR_mux_instance(
        .input1( power_on_reset ),
        .input2( main_reset ),      //main reset is not implemented yet
        .input_sel( porc_sel ),
        .output1( master_reset )     
    );

    tri_state_buffer buffer_A_reg(
        .tsb_in( dp_a_reg_out ),
        .tsb_out( dp_bus_line ),
        .tsb_en( ctrl_a_reg_bus_out_en )
    );

    A_register a_register_instance(
        .A_reg_clk( main_clk ),
        .A_reg_rst( master_reset ),
        .A_reg_in( dp_bus_line ),
        .A_reg_out( dp_a_reg_out ),
        .A_reg_rd_en( ctrl_a_reg_rd_en ),
        .A_reg_wr_en( ctrl_a_reg_wr_en ),
        .A_reg_shift( ctrl_a_reg_shift )
    );

    B_register b_register_instance(
        .B_reg_clk( main_clk ),
        .B_reg_rst( master_reset ),
        .B_reg_in( dp_bus_line ),
        .B_reg_out( dp_b_reg_out ),
        .B_reg_rd_en( ctrl_b_reg_rd_en ),
        .B_reg_wr_en( ctrl_b_reg_wr_en )
    );

    tri_state_buffer buffer_ALU(
        .tsb_in( dp_alu_out ),
        .tsb_out( dp_bus_line ),
        .tsb_en( ctrl_alu_bus_out_en )
    );

    ALU alu_instance(
        .ALU_sub_en( ctrl_alu_sub_en ),
        .ALU_status_out_en( ctrl_alu_status_out_en ),
        .ALU_in1( dp_a_reg_out ),
        .ALU_in2( dp_b_reg_out ),
        .ALU_out( dp_alu_out )
    );

    instruction_counter IC_instance(
        .IC_clk( main_clk ),
        .IC_rst( ic_rst ),
        .IC_rd_en( ctrl_ic_rd_en ),
        .IC_wr_en( ctrl_ic_wr_en ),
        .IC_in( dp_ir_out_lower_byte ),
        .IC_out( dp_ic_out ),       //remaining to connect
        .IC_count_dir( ctrl_ic_count_dir )
    );
    
    instruction_register IR_instance(
        .IR_clk( main_clk ),
        .IR_rst( master_reset ),
        .IR_rd_en( ctrl_ir_rd_en ),
        .IR_wr_en( ctrl_ir_wr_en ),
        .IR_out( dp_ir_out ),
        .IR_in( dp_bus_line )
    );

    MAR_mux marmux_instance(
        .MAR_mux_input1( dp_pc_out ),   //at sel = 00
        .MAR_mux_input2( dp_lower_bus_line), //at sel = 01
        .MAR_mux_input3( dp_ir_out_lower_byte ), //at sel = 10
        .MAR_mux_output( dp_mar_mux_out ),
        .MAR_mux_select( ctrl_mar_mux_sel )
    );

    memory_address_register MAR_instance(
        .MAR_clk( main_clk ),
        .MAR_rst( master_reset ),
        .MAR_wr_en( ctrl_mar_wr_en ),
        .MAR_in( dp_mar_mux_out ),
        .MAR_out( dp_memory_addr ) 
    );

    tri_state_buffer memory(
        .tsb_in( dp_memory_out ),
        .tsb_out( dp_bus_line ),
        .tsb_en( ctrl_mem_bus_out_en )
    );

    memory memory_instance(
        .mem_clk( main_clk ),
        .mem_rst( master_reset ),
        .mem_rd_en( ctrl_mem_rd_en ),
        .mem_wr_en( ctrl_mem_wr_en ),
        .mem_addr( dp_memory_addr ),
        .mem_addr_valid( ctrl_mem_addr_valid ),
        .mem_data_in( dp_bus_line ),
        .mem_data_out( dp_memory_out ),
        .word_op( ctrl_word_op )
    );

    program_counter PC_instance(
        .count_clk( main_clk ),
        .count_rst( master_reset ),
        .count_wr_en( ctrl_count_wr_en ),
        .count_rd_en( ctrl_count_rd_en ),
        .count_dir( ctrl_count_dir ),
        .count_out( dp_pc_out ),
        .count( ctrl_count ),       //increase or decrease the count based on direction
        .count_in( dp_lower_bus_line)
    );

    instruction_memory instr_mem_inst(
        .instr_mem_addr_in( dp_instr_mem_addr ),
        .instr_mem_data_out( control_signals )
    );
endmodule