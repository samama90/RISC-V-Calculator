# RISC-V Calculator

A menu-driven calculator developed in **RISC-V Assembly Language** using the **RARS Simulator**. The calculator supports basic arithmetic operations, power calculation, square root computation, result history tracking, and robust error handling.

## Features

### Arithmetic Operations
- Addition
- Subtraction
- Multiplication
- Division
- Modulus

### Advanced Operations
- Power (`x^n`)
- Integer Square Root

### Extra Functionality
- Store and display the last 5 calculation results
- Reuse the previous result as the first operand
- Circular history buffer implementation
- Menu-driven user interface

### Error Handling
- Division by zero detection
- Negative exponent validation
- Negative square root validation
- Integer overflow detection for:
  - Addition
  - Subtraction
  - Multiplication
  - Power

---

## Technologies Used

- RISC-V Assembly Language
- RARS (RISC-V Assembler and Runtime Simulator)

---

## Program Menu

```text
+==================================+
|    ** RISC-V CALCULATOR **       |
|        COAL   |   RARS           |
+==================================+
|  [1] Addition                    |
|  [2] Subtraction                 |
|  [3] Multiplication              |
|  [4] Division                    |
|  [5] Modulus                     |
|  [6] Power                       |
|  [7] Square Root                 |
|  [8] Show History                |
|  [9] Exit                        |
+==================================+
```

---

## Project Highlights

### Previous Result Reuse
After a successful calculation, the program allows the user to reuse the previous result as the first operand in the next operation.

Example:

```text
Previous Result = 25
Use previous result? (1 = Yes, 0 = No): 1
Enter second number: 5
Result = 30
```

### Calculation History
The calculator stores the last five results using a circular buffer.

Example:

```text
Last 5 Results:
30
15
200
8
64
```

### Overflow Detection
The program checks for integer overflow in critical arithmetic operations and prevents incorrect results.

Example:

```text
Error: Integer overflow occurred!
```

---

## How to Run

### Using RARS

1. Download and open RARS.
2. Open `calculator.asm`.
3. Click **Assemble**.
4. Click **Run**.
5. Use the menu to perform calculations.

---

## File Structure

```text
RISC-V-Calculator/
│
├── calculator.asm
├── README.md
└── screenshots/
    ├── menu.png
    ├── operation_example.png
    └── history_example.png
```

---

## Sample Execution

```text
Enter your choice: 1
Enter first number: 10
Enter second number: 20

Result = 30
```

```text
Enter your choice: 4
Enter first number: 10
Enter second number: 0

Division by zero is not allowed!
```

---

## Concepts Demonstrated

- RISC-V instruction set
- Branching and control flow
- Procedures and function calls
- Register management
- Memory operations
- Circular buffer implementation
- Input/Output using RARS system calls
- Error handling techniques
- Overflow detection logic

---

## Educational Purpose

This project was developed as part of a Computer Organization and Assembly Language (COAL) learning exercise to strengthen understanding of low-level programming concepts using the RISC-V architecture.

---

## Future Improvements

- Floating-point calculations
- Scientific calculator functions
- Expression evaluation
- Improved square root algorithm
- Persistent history storage
- Enhanced user interface

---

## Author

**Samama Ahmed**

Computer Organization & Assembly Language (COAL)

---

## License

This project is licensed under the MIT License.
