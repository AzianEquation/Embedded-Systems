In order to text the given code run the command
$./csce611.sh simulate
This will run the provided scripts and launch ModelSim which analyzes our top
level module CSCE_611_regfile_testbench.sv
The testbench contains two sets of tests. The first tests the stack.sv module
the second tests the rpncalc.sv module. Both will execute with a delay after the first testbench. the rpncalc.sv testbench starts around ~100ns in the window
To run on the board
$./csce611.sh compile && ./csce611.sh program

