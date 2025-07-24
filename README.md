# Low_Power_Configurable_Multi_Clock_Digital_System


## 📋 Table of Contents

1. [Overview](#overview)
2. [Block Diagram](#Block-Diagram) 
3. [System Architecture](#system-architecture)
4. [Supported ALU Operations](#Supported-ALU-Operationss)
5. [Register File Details](#Register-File-Details)
6. [UART Communication Protocol](#uart-communication-protocol)
7. [System Specifications](#System-Specificationss)
8. [Testbench Operation Sequence](#Testbench-Operation-Sequence)
13. [License](#license)

---    
##  Overview

RTL to GDS Implementation of Low_Power_Configurable_Multi_Clock_Digital_System which is responsible for receiving commands through UART receiver to do different system functions such as register file reading/writing or doing some processing using ALU block and send results as well as asynchronous FIFO to avoid data loss in different domains through UART transmitter communication protocol.

---
## Block Diagram
![block](https://i.ibb.co/pjm6pDmx/system.png)
---
##  System Architecture

The system consists of **10 main blocks** grouped across **two clock domains**:

### 🔹 Clock Domain 1 (REF_CLK - 50 MHz)

- **RegFile**
- **ALU**
- **Clock Gating**
- **SYS_CTRL**

### 🔹 Clock Domain 2 (UART_CLK - 3.6864 MHz)

- **UART_TX**
- **UART_RX**
- **PULSE_GEN**
- **Clock Divider**

### 🔹 Synchronizers (for crossing clock domains)

- **RST Synchronizer**
- **Data Synchronizer**
- **ASYNC FIFO**

---

##  Supported ALU Operations

- Arithmetic: `ADD`, `SUB`, `MUL`, `DIV`
- Logic: `AND`, `OR`, `NAND`, `NOR`, `XOR`, `XNOR`
- Comparisons: `A = B`, `A > B`
- Shifting: `A << 1`, `A >> 1`

---

##  Register File Details

- 16 registers (addresses from `0x0` to `0x15`)
- Registers `0x0` to `0x3` are reserved for system configuration and ALU operands
  - `REG0` → ALU Operand A
  - `REG1` → ALU Operand B
  - `REG2` → UART config: Parity Enable, Parity Type, Prescaler
  - `REG3` → Clock Divider Ratio

---

##  UART Communication Protocol

###  Supported Commands

| Command Type              | Frames | Description                         |
|--------------------------|--------|-------------------------------------|
| `0xAA` - RegFile Write   |   3    | Address + Data                      |
| `0xBB` - RegFile Read    |   2    | Address                             |
| `0xCC` - ALU w/ Operands |   4    | Operand A, Operand B, ALU Fun       |
| `0xDD` - ALU w/o Operands|   2    | ALU Fun                             |

---

##  System Specifications

- `REF_CLK` Frequency: **50 MHz**
- `UART_CLK` Frequency: **3.6864 MHz**
- Clock Divider: **Always Enabled**
- Frame communication format: **8-bit parallel per frame**

---

##  Testbench Operation Sequence

1. Initial system configuration via RegFile writes to `0x2`, `0x3`
2. Master sends commands (RegFile / ALU)
3. Commands are received via `UART_RX` → processed by `SYS_CTRL`
4. Results sent to master via `UART_TX`
5. RegFile address space:
   - Reserved: `0x0` to `0x3`
   - User operations: `0x4` to `0x15`

---


