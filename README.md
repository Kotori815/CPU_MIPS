# CPU_MIPS

Course project for UM-SJTU JI Ve370 Introduction to Computer Organization. Written in 2019-FA, uploaded in 2020SU.

Implemented with Verilog. Supports MIPS instructions including 

- The memory-reference instructions load word (`lw`) and store word (`sw`)
- The arithmetic-logical instructions add, `addi`, `sub`, `and`, `andi`, or, and `slt`
- The jumping instructions branch equal (`beq`), branch not equal (`bne`), and jump (`j`)

 Offer both single-cycle and pipeline models. 

<img src="pic\image-20200708180302892.png" alt="image-20200708180302892" style="zoom:80%;" />

<img src="pic\image-20200708180538973.png" alt="image-20200708180538973" style="zoom:80%;" />

Include a `Demo.txt` file as demo instructions to run on the CPU. Can be demonstrated on the FPGA board.
