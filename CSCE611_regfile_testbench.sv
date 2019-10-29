module CSCE611_regfile_testbench;
logic clk, start, push, pop;
logic [3:0] KEY;
logic [15:0] val,top,next;
logic [7:0] counter;
//logic [31:0] i;
logic rst;
logic [1:0] mode;
// expected vals
logic [15:0] top_e,next_e;
logic [7:0] counter_e;
logic [15:0] top_e1,next_e1;
logic [7:0] counter_e1;
logic [31:0] i,error;
logic [67:0] vectors [999:0];
logic [67:0] rpnvectors [999:0];
logic [67:0] current;
logic [2:0] delay;
initial begin
KEY = 0;
pop = 0;
push = 0;
mode = 0;
val = 0;
top_e = 0;
next_e = 0;
counter_e = 0;
top_e1 = 0;
next_e1 = 0;
counter_e1 = 0;
delay = 0;
rst=1;
#1;
rst = 0;
#1;
end
	rpncalc rpn(clk,rst,mode,KEY,val,top,next,counter);
	stack stk (clk,rst,push,pop,val,top,next,counter);
	initial begin
	//$readmemh("vectors.dat",vectors);
	$readmemh("stackVectors.dat", vectors);
	i = 32'b0;
	error = 32'b0;
	// 17 hex digits
	current = 68'b0;
	$display("Begin stackVectors.dat");
	for(i=0; i<20;i=i+1)begin
		current = vectors[i];
		rst = current[64];
		push = current[60];
		pop = current[56];
		val = current[55:40];
		top_e = current[39:24];
		next_e= current[23:8];
		counter_e = current[7:0];
		#2;
		if (top == top_e && next == next_e && counter == counter_e)begin
			$display("pass: %d",i); 
		end
		if (top !== top_e||next !== next_e || counter != counter_e) begin
			$display("Error: inputs = %h", val);
			$display("  outputs = top: %h (%h expected) next: %h (%h expected) counter: %h (%h expected) ",top ,top_e, next, next_e, counter, counter_e);
			// increment error counter
			error = error + 32'b1;
		end
		
	end
	$display("Reached end of stackVectors.dat");
	//$stop();
	// gap between vectors
        #80;
	$readmemh("vectors.dat",rpnvectors);
	i = 32'b0;
	error = 32'b0;
	// 17 hex digits
	current = 68'b0;
	$display("Begin vectors.dat (tests rpncalc.sv)");
	for(i=0; i<50;i=i+1)begin

		current = rpnvectors[i];
		rst = current[64];
		delay = current[67:65];
		mode = current[61:60];
		KEY = current[59:56];
		val = current[55:40];
		top_e = current[39:24];
		next_e= current[23:8];
		counter_e = current[7:0];
		#2;
		// add extra delay for rpn add 
		if (delay == 3'b111) begin
		#4;
		end
		if (top == top_e1 && next == next_e1 && counter == counter_e1)begin
			$display("pass: %d",i); 
		end
		if (top !== top_e1||next !== next_e1 || counter != counter_e1) begin
			$display("Error: inputs = %h", val);
			$display("  outputs = top: %h (%h expected) next: %h (%h expected) counter: %h (%h expected) ",top ,top_e, next, next_e, counter, counter_e);
			// increment error counter
			error = error + 32'b1;
		end
		// delay after 
	end // for
	$display("Reached end of vectors.dat");
	$stop();
	
end // initial begin

// clock every 1 time interval
always begin 
clk = 1'b1; #1;
clk = 1'b0; #1;
end


endmodule
