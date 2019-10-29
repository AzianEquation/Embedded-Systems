/* RPN calculator module implementation */

module rpncalc (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [1:0 ] mode,		/* mode from SW17 and SW16 */
	input [3:0 ] key,		/* value from KEYs */

					/* Remember that the 2 bit mode and
					 * 4 bit key value are used to
					 * uniquely identify one of 16
					 * operations. Also keep in mind that
					 * they keys are onehot (i.e. only one
					 * key is pressed at a time -- if
					 * more than one key is pressed at a
					 * time, the behavior is undefined
					 * (i.e. you may choose your own
					 * behavior). */

	input [15:0] val,		/* 16 bit value from SW15...SW0 */

/**** outputs ****************************************************************/

	output logic [15:0] top,		/* 16 bit value at the top of the
					 * stack, to be shown on HEX3...HEX0 */

	output logic [15:0] next,		/* 16 bit value second-to-top in the
					 * stack, to be shown on HEX7...HEX4 */

	output logic [7:0] counter		/* counter value to show on LEDG */

);

// enum states
typedef enum logic [2:0] {s0,s1,s2,s3,s4} statetype;
statetype state, nextstate;
// initialize the stack
logic zero, push, pop;
logic [15:0] stackVal;
logic [31:0] hi, lo;
logic [31:0] lo_dly,lo_dly2, lo_dly_top;
stack mystack(clk,rst,push,pop,stackVal,top,next,counter);
// state update on clock edge
always_ff @(negedge clk,posedge rst) begin
	
	if (rst) state <= s0;
	else begin
	
	state = nextstate;
	end
	
	case(state)
		s0:begin
			push<=0;
			pop<=0;
		end
		s1:begin
			// pop,pop,push
			lo_dly = lo;
			push<=0;
			pop =1;
			#1;
			lo_dly2 = lo_dly;
			#2;
			// push lo_dly2
			stackVal = lo_dly2;
			push<=1;
			pop<=0;
			#2
			push<=0;
		end
		// reverse state
		s2:begin
			// pop top,pop (next),push, push
			// capture top
			lo_dly = top;
			push<=0;
			pop =1;
			#1;
			// save top 
			lo_dly2 = lo_dly;
			// capture next (new top)
			lo_dly_top = top;
			#2;
			// push original top
			stackVal = lo_dly2;
			push<=1;
			pop<=0;
			#1
			// push original next;
			stackVal = lo_dly_top;
			push<=1;
			pop<=0;
			#2
			push<=0;
			
		end
		// push state (single)
		s3:begin
			push<=1;
			stackVal<= val;
			pop<=0;	
			#1;
			push<=0;	
		end
		// pop state (single)
		s4:begin
			
			push<=0;
			pop<=1;
			#1;
			pop<=0;
		end
		// idle
		default: begin
			push<=0;
			pop<=0;
			//#2;
		end
	endcase
	
end // ff

logic [5:0] operation;
logic [3:0] op;
logic [4:0] shamt;
assign shamt = top[4:0];
// combinational logic to determine next state
always_comb begin
	operation = {mode,key};
	case (operation)
	// push
	6'b000111: begin
	op = 4'b1111;
	nextstate = s3;
	end
	// pop
	6'b001011: begin
	op = 4'b1111;
	nextstate = s4;
	end
	// add
	6'b001101: begin 
	op = 4'b0100;
	nextstate =s1;
	
	end
	6'b001110: begin
	op = 4'b0101; // sub
	nextstate = s1;
	end
	6'b010111: begin
	op = 4'b0111; // unsigned product
	nextstate =s1;
	end
	6'b011011: begin
	op = 4'b1000; // shift left
	nextstate =s1;
	end
	6'b011101: begin
	op = 4'b1001; // logical shift right
	nextstate =s1;
	end
	6'b011110: begin
	op = 4'b1100; // if a < b  ****
	nextstate =s1;
	end
	6'b100111: begin
	op = 4'b0000; // &
	nextstate =s1;
	end
	6'b101011: begin
	op = 4'b0001; // |
	nextstate =s1;
	end
	6'b101101: begin
	op = 4'b0010; // ~|
	nextstate =s1;
	end
	6'b101110: begin
	op = 4'b0011; // bitwise xor
	nextstate =s1;
	end
	// reverse
	6'b110111: 
	nextstate = s2;
	default: begin
	op = 4'bxxxx; // don't care
	nextstate = s0; // idle
	end
	endcase
end


// using alu
alu myalu({16'b0,top},{16'b0,next}, op, shamt, hi,lo, zero);
// instantiate the stack

endmodule
