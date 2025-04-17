# MIPS Floating Point Decoder — IEEE 754 vs. TNS Format

This MIPS assembly program accepts a **32-bit hex-encoded number** and decodes it based on the user’s choice of encoding: the **standard IEEE 754 floating-point format**, or a custom **TNS (Two's Complement Notation System)** format. It prints the **sign**, **mantissa**, **exponent**, and **approximate decimal value** of the float.

> Project by Brendan Grant, April 2021, for CS 2400.

---

## What It Does

- Asks the user to choose between **IEEE 754** or **TNS**.
- Loads a hardcoded 32-bit word from `.data` (editable).
- Decodes the **sign**, **exponent**, and **mantissa**.
- Reconstructs and prints the **decimal equivalent** using floating-point arithmetic.
- Uses **bitmasking**, **logical shifts**, and **custom float math** routines.

---

## Format Logic

### IEEE 754:
- Sign: 1 bit
- Exponent: 8 bits (biased by 127)
- Mantissa: 23 bits

### TNS Format:
- Sign: 1 bit
- Exponent: 9 bits (biased by 256)
- Mantissa: 22 bits (left-shifted to match IEEE style)

---

## Key Sections

```asm
main            # Prompts user and branches to IEEE or TNS decoder
findMant        # Converts mantissa into float via bit-by-bit summation
expCalc         # Applies exponent (positive or negative) to scale mantissa
printResult     # Displays mantissa, exponent, sign, and final decimal

**
```

### Technical Highlights
- Uses l.s, mul.s, div.s for floating-point operations.
- Reconstructs fractions using 1/(2^n) summation based on mantissa bits.
- Applies sign via float multiplication ($f0 * $f3).
- Results printed using syscalls for both strings and floats.

### Example Input
- You can modify the .word under hex: in .data to test different values:
```
hex: .word 0x41640000    # 14.25 IEEE
     .word 0x64000103    # 14.25 TNS
     .word 0x3b5844d0    # ~0.0033 IEEE
     .word 0xde86010e    # -28483 TNS
