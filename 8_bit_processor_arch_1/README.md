8-Bit Processor Architecture – Verilog Implementation

This project implements a custom 8-bit processor architecture using Verilog HDL. It features a basic design with a minimalistic instruction set, program counter,
instruction/data memory, ALU, and control logic using decoders. The processor operates with a 6-bit instruction address and works on alternating instruction and
data execution with a simple decoder based control.

Instruction/Data Memory
Memory stores both instructions and data. addressing is done using a 6-bit address, where:
        Upper 3 bits come from the Program Counter
        Lower 3 bits come from the Instruction Counter

Rather than using the Program Counter and Instruction Counter merely to separate data and opcodes, the design treats these two counters as nested instruction flow
controllers. Together, they form a 6-bit address line to the unified instruction/data memory (64-address space). The purpose is to break complex operations into
multi-cycle instruction sequences. Using only a single Program Counter would require tightly packing complex instructions into a single step or managing sub-operations
through additional combinational logic.

With the current design:
    Instruction Counter acts like a stepper inside each instruction group (micro-operations).
    Program Counter handles high-level instruction sequencing.

  Memory Address = {PC[2:0], IC[2:0]} → total 6 bits
  This setup gives:
    8 slots per Program Counter step (IC range 0–7)
    8 blocks total (PC range 0–7)

So, each Program Counter value represents a micro-program block of 8 bytes (one PC cycle = one 8-byte micro-program), and the Instruction Counter iterates through each micro-instruction
step within that block.

Instruction/Data Fetching
    Each 8-bit instruction is split:
        Opcode (from IC) → passed to control decoders
        Operand/data (from PC) → passed to register bank or ALU

The selector logic toggles between fetching the opcode and the operand alternately every clock cycle.
