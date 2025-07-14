// The output of instruction memory is diverted into opcode register data register.
// The selection line of this mux is connected to the lower bit of the instruction counter(not program counter).
// This design choice is considered because it makes it possible to transfer data and transfer opcode from memory one after another.

module instr_mem_out_demux(
    input wire [7:0] instr_mem_out_demux_input,
    output reg [7:0] instr_mem_out_demux_output_opcode = 8'b0,
    output reg [7:0] instr_mem_out_demux_output_data = 8'b0,

    input wire instr_mem_out_demux_select,
    input wire instr_mem_out_demux_rst,
    input wire instr_mem_out_demux_clk
);

always @(posedge instr_mem_out_demux_clk) begin
    if (instr_mem_out_demux_rst) begin

        instr_mem_out_demux_output_opcode = 8'b00000000;
        instr_mem_out_demux_output_data = 8'b00000000;

    end else begin
        if(instr_mem_out_demux_select) begin
            instr_mem_out_demux_output_opcode = instr_mem_out_demux_input;
        end
        else begin
            instr_mem_out_demux_output_data = instr_mem_out_demux_input;
        end
    end

end

endmodule