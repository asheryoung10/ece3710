# Simple CPU Architecture Overview

![CPU Module Diagram](Assets/modules.svg)

This diagram illustrates the main modules of a simple CPU design and their interconnections. Below is an explanation of each module's role and interface signals.

---

## Modules and Their Functions

### 1. **program_counter**
- **Inputs:** `clk`, `rst`, `we`, `pc_next`
- **Output:** `pc_curr`
- **Description:** Holds the current instruction address. On `we` (write enable), updates to `pc_next` value on clock edge. Provides the current program counter (`pc_curr`) to fetch instructions sequentially or jump to a new address.

### 2. **instruction_memory**
- **Input:** `addr` (program counter)
- **Output:** `instr`
- **Description:** Read-only memory storing the instructions. Outputs the instruction (`instr`) located at the address provided by the program counter.

### 3. **instruction_register**
- **Inputs:** `clk`, `rst`, `we`, `instr_in`
- **Output:** `instr_out`
- **Description:** Latches the current instruction from instruction memory at each clock cycle when `we` (write enable) is active, holding it stable for decoding and execution.

### 4. **register_file**
- **Inputs:** `clk`, `rst`, `raddr_a`, `raddr_b`, `waddr`, `wdata`, `we`
- **Outputs:** `rdata_a`, `rdata_b`
- **Description:** Contains the CPU’s general-purpose registers. Supports two simultaneous reads (`raddr_a`, `raddr_b`) and one write (`waddr`, `wdata`) per clock cycle, controlled by the write enable signal `we`.

### 5. **alu**
- **Inputs:** `Rsrc_Imm`, `Rdest`, `Opcode`
- **Outputs:** `Result`, `Flags`
- **Description:** Performs arithmetic and logic operations based on the `Opcode` using operands from the source (`Rsrc_Imm`) and destination (`Rdest`). Outputs the operation result and status flags (carry, zero, negative, overflow, etc.).

### 6. **program_flags**
- **Inputs:** `clk`, `rst`, `we`, `f_in`, `l_in`, `c_in`, `n_in`, `z_in`
- **Outputs:** `f`, `l`, `c`, `n`, `z`
- **Description:** Stores the status flags updated by the ALU after each instruction. Flags include overflow (`f`), lower/borrow (`l`), carry (`c`), negative (`n`), and zero (`z`). Flags are updated on write enable `we`.

### 7. **data_memory**
- **Inputs:** `clk`, `rst`, `we`, `addr`, `wdata`
- **Output:** `rdata`
- **Description:** Provides read/write access to the CPU's data memory. On `we`, writes `wdata` to the specified `addr`. Outputs data from the addressed memory location.

---

## Overview

This modular CPU design separates concerns into discrete components for clarity and scalability:

- The **program_counter** and **instruction_memory** manage instruction sequencing and fetching.
- The **instruction_register** holds the fetched instruction for decoding and execution.
- The **register_file** and **alu** perform data processing and computation.
- The **program_flags** module tracks CPU state via flags.
- The **data_memory** allows the CPU to read and write data during execution.

The control unit (not shown) orchestrates these components by generating control signals based on the current instruction.

---

## Usage

Use this diagram and module descriptions as a reference when navigating the CPU source files or when expanding functionality such as adding new instructions or improving the control unit.

---

*Diagram generated as part of the CPU design project.*

