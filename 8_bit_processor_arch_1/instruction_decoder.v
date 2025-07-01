// the instruction decoder is implemented using four 2-4 decoders.
// therefore the opcode is 8 bits wide and control signal is 16 bits wide.
// In each decoder, there is a no-operation (nop) pin which is not connected to any module.
// This design choice ensures that one pin of the decoder, which is always high for any given input,
// does not unintentionally trigger other modules or cause unwanted behavior in the circuit.
// The nop pin effectively acts as a safe default state for unused outputs.
// because one pin of a decoder is always high for any given input and this should not cause triggering of other pins


// There are four decoders and they are ordered as decoder1 to decoder4. Their inputs are in order of MSB to LSB - 2 MSB bits are for decoder 1 and last
// 2 bits at LSB for decoder 4.
/*
Output pins of decoder and their connection. 1st pin is highest pin (1000) and 4th pin is lowest pin (0001).
decoder 1: pin1: rst
           pin2: incr
           pin3: nop
           pin4: rd_en_alu

decoder 2: pin1: wr_en
           pin2: compl_en
           pin3: opcode1(alu)
           pin4: nop

decoder 3: pin1: out_en
           pin2: opcode2(alu)
           pin3: rd_en_reg_bank
           pin4: nop

decoder 4: pin1: sel
           pin2: decr
           pin3: opcode3(alu)
           pin4: nop


*/

module instruction_decoder(
    input wire [1:0] decoder_input,
    output reg [3:0] decoder_output = 4'b0000 // Initialize
);
always @(*) begin
    case(decoder_input)
        2'b00: decoder_output = 4'b0001; 
        2'b01: decoder_output = 4'b0010;
        2'b10: decoder_output = 4'b0100;
        2'b11: decoder_output = 4'b1000;
        //default: decoder_output = 4'b0000; // Safety net
    endcase
end
endmodule