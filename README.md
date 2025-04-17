# MIPS-TNS-IEEE754: Floating-Point Format Decoder

This educational project is a **MIPS assembly program** designed to **parse and interpret 32-bit floating-point numbers** encoded in either:
- **IEEE 754 format** (the industry standard for floating-point math), or
- **TNS format** (Two's Complement Notation System, non-standard for floats but useful for contrast).

## Features

- Accepts 32-bit **hexadecimal input** via console.
- Extracts and prints:
  - **Sign bit**
  - **Exponent field** and actual exponent
  - **Mantissa (fraction)** field
- Displays a human-readable interpretation:
  - Format type (IEEE 754 or TNS)
  - Decimal approximation of the original binary float

## How It Works

- Uses **bitwise masking and shifting** to isolate sign, exponent, and mantissa bits.
- **Reconstructs fractional values** using custom routines that simulate floating-point multiplication.
- Determines which format to apply based on value characteristics.
- **Handles edge cases** like zero, NaN, and infinity (for IEEE 754).

## Requirements

- MIPS simulator (e.g., MARS or QtSPIM)
- Ability to input hexadecimal values via syscall prompt

## Educational Value

This program demonstrates:
- Mastery of **low-level binary math**
- Understanding of **floating-point representation**
- Skills in **manual bitfield parsing and binary-decimal conversion**
- Comparison between **standardized and custom encoding schemes**

Ideal for students learning:
- Computer organization
- Digital logic
- Assembly programming
- Floating-point standards

## License

MIT License

