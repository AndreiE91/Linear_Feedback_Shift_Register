# Linear Feedback Shift Register

## Table of Contents:

1. [Project Specification](#project-specification)
2. [Black Box](#black-box)
3. [Detailed Schematic](#detailed-schematic)
4. [Control and Extend Signal Assignments](#control-and-extend-signal-assignments)
5. [VHDL Code](#vhdl-code)
6. [7-Segment Implementation](#7-segment-implementation)
7. [Simulated Behavior Results](#simulated-behavior-results)
8. [User Manual](#user-manual)
9. [Future Developments](#future-developments)
10. [Bibliography](#bibliography)

## 1. Project Specification:

Implement linear feedback counters (LFSR) based on the documentation in "Designing Numerical Systems Using FPGA Technology" by S. Nedevschi, Z. Baruch, and O. Cret (available at UTCN Library). The project involves implementing LFSR with input parameters for the counting loop length and the selection of 4-bit or 5-bit variants.

## 2. Black Box:

The device features 8 inputs including Clock, Reset, selection for 4-bit or 5-bit variant, and a 5-bit bus for the counting loop's length. Outputs include a 5-bit bus representing the current LFSR value.

## 3. Detailed Schematic:

The circuit consists of a shift register with additional logic to accommodate 4-bit and 5-bit variants, along with dynamic loop length for the LFSR counter. XNOR gates are strategically placed based on the variant and current state.

## 4. Control and Extend Signal Assignments:

The "Control" signal corresponds to gate 'C' and "Extend" to gate 'B' in the documentation. Signal assignment is based on specific states of the counter for each desired loop length.

## 5. VHDL Code:

The VHDL code represents the black box entity with variant indicating 4-bit or 5-bit mode. Internal signals are initialized with corresponding logic, clock and reset functions are implemented, and the register is shifted accordingly.

## 6. 7-Segment Implementation:

In addition to the main functionality, a 7-segment display is implemented for better visualization of the binary values. A frequency divider is used to control the LED frequency, and a MUX decodes the binary input for segment representation.

## 7. Simulated Behavior Results:

Simulated behavior results include testing all possible circuit counting loops, starting from different variants and loop lengths, with correct behavior indicated by checkmark symbols.

## 8. User Manual:

The user manual explains the operation starting from the reset state, setting the variant and loop length, and starting the circuit. Clock pulses generate pseudo-random values with each loop length.

## 9. Future Developments:

Potential future developments include expanding the project beyond 5 bits, exploring applications in cryptography, and optimizing loop length computation for higher bit counts.

## 10. Bibliography:

The project is based on the documentation provided in "Designing Numerical Systems Using FPGA Technology" by S. Nedevschi, Z. Baruch, and O. Cret, specifically Chapter 4.
