# Project Description

This project implements a simple 16-bit processor architecture in Verilog. The processor is designed to execute basic instructions and demonstrates fundamental concepts of computer architecture, including instruction fetch, decode, and execution cycles.

## Features

- 16-bit wide data and address buses
- Basic instruction set including load, store, and arithmetic operations
- Memory-mapped program and data storage
- Modular Verilog design for easy understanding and extensibility

## RAM Architecture

The processor uses an 8-bit wide RAM for both program and data storage. To support both byte and word operations, a control signal called `word_op` is used:

- **Byte Operation (`word_op = 0`):** Data is read from or written to a single 8-bit memory address.
- **Word Operation (`word_op = 1`):** Data is read from or written to two consecutive 8-bit memory addresses, combining them to form a 16-bit word.


## Example Programs

The project includes example programs demonstrating the use of the `LDA`, `LDB`, and `ADD` instructions. These instructions are written in binary and loaded into memory as follows:

- **LDA (Load Accumulator A):** Loads a value from memory into register A.
- **LDB (Load Accumulator B):** Loads a value from memory into register B.
- **ADD:** Adds the values in registers A and B, storing the result back in register A.

### Example Program in Binary (Memory Layout)

| Address | Instruction (Binary) | Description         |
|---------|---------------------|---------------------|
| 0x00    | 00000000 | LDA                 |
| 0x01    | 00000110 |                     |
| 0x02    | 00000001 | LDB                 |
| 0x03    | 00001000 |                     |
| 0x04    | 00000010 | ADD                 |

| 0x06    | 10110011 | A reg value(16 bit) |
| 0x07    | 01000111 |                     |
| 0x08    | 11011000 | B reg value(16 bit) |
| 0x06    | 10001110 |                     |



This setup allows you to observe how the processor fetches instructions, loads data into registers, and performs arithmetic operations.

## Getting Started

1. Clone the repository.
2. Review the Verilog source files.
3. Load the example program into memory.
4. Simulate the processor to observe instruction execution.


