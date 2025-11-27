# Booth Radix-16 Multiplier (VHDL)

This project implements a **signed Booth Radix-16 multiplier** in VHDL, including a control unit (CU), an operational unit (OU), and a complete top-level design.  
The project also includes a ModelSim testbench for functional verification.

## Overview

The Booth Radix-16 algorithm is an efficient method for performing signed multiplication.  
It reduces the number of partial products by grouping bits into 4-bit blocks and applying Booth encoding, resulting in faster multiplication and improved performance compared to lower-radix variants.

This repository contains:

- **Operational Unit (OU)** – performs the arithmetic operations according to the Booth encoding.
- **Control Unit (CU)** – generates the control signals for each iteration.
- **Top-Level Entity** – integrates CU and OU into a complete multiplier.
- **Testbench** – used to simulate and verify the design in ModelSim.

## Features

- Signed multiplication using **Booth Radix-16**
- Modular architecture (CU + OU + top module)
- Clean and readable VHDL code
- Functional simulation using **ModelSim**
- Includes full testbench for verification
- Suitable for FPGA or academic digital design projects

## File Structure

