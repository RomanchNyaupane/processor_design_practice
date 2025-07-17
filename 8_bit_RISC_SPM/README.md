# 8-bit Reduced Instruction Set Computer Stored Program Machine
The architecture is taken from chapter 7 Advanced Digital Design with Verilog written by Michael D. Cilleti.\
It consists of two 8 bit data bus, 4 registers, 8 bit wide memory (with 8 bit addressing scheme). The control\
scheme is state machine based. The opcode format is shown below.\
<img width="570" height="129" alt="image" src="https://github.com/user-attachments/assets/11a39101-11e3-42f0-b76c-d5ae91101236" />

The instruction are of two types : 1 byte and 2 byte instructions
1 byte instructions contains opcode only and no address preceeds it. The insturction like ADD, SUB, NOT, AND are 1 byte instructions. \
2 byte instructions contain opcode along with address predeeding it. The read, write and branch instructions use 2 byte instructions. \
## Example program
The following data is written in memory before starting the system.\
  | address | data(binary)|
  |  0      | 01010000    | --> LDR0 - Load contents of memory location( which is byte at address 1) in register R0
  |  1      | 00001010    | --> memory location which holds value to be loaded at R0
  |  2      | 01010001    | --> LDR1 - Load contents of memory location( which is byte at address 3) in register R1
  |  3      | 00001011    | --> memory location which holds value to be loaded at R1
  |  4      | 00010001    | --> ADD - add contents of Register 00(R0) and Register 01(R1) and store the result at register 01(R1)
  |  5      | 01100100    | --> WR - Write contents of Register 01(R1) at memory location at address 6
  |  6      | 00001110    | --> memory location to write contents of R1
  |  7      |             |
  |  8      |             |
  |  9      |             |
  |  10     | 00110011    |  -->value to be loaded by LDR0 instruction
  |  11     | 01011100    |  -->value to be loaded by LDR1 instruction
  |  12     |             |  -->location where WR is supposed to write data

