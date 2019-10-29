
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module CSCE611_lab_regfile(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,

	//////////// LED //////////
	output		     [8:0]		LEDG,
	output		    [17:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		    [17:0]		SW,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,
	output		     [6:0]		HEX6,
	output		     [6:0]		HEX7
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
//input rpn
logic [1:0] mode;
logic [15:0] val;
logic rst = 0;
// output wires
logic [15:0] top;
logic [15:0] next;
logic [7:0] counter;
// top hex output wires
logic [4:0] hexdriver0,hexdriver1,hexdriver2,hexdriver3;
// next hex output wires
logic [4:0] hexdriver4,hexdriver5,hexdriver6,hexdriver7;
assign  mode = SW[17:16];
assign val = SW[15:0]; 
assign hexdriver0 = top[3:0];
assign hexdriver1 = top[7:4];
assign hexdriver2 = top[11:8];
assign hexdriver3 = top[15:12];
// next
assign hexdriver4 = next[3:0];
assign hexdriver5 = next[7:4];
assign hexdriver6 = next[11:8];
assign hexdriver7 = next[15:12];
// leds
assign LEDG[7:0] = counter;
// need to instantiate rpn
// mode[1:0] from sw17 and sw18
// key [3:0] active low buttons
// val [15:0] 16bit val from sw15...sw0
// top [15:0] output rpn to be displayed on hex3...hex0   top of stack
// next [15:0] output rpn to be displayed on hex7...hex4  next in line
// counter [7:0] counter val to show on LEDG. shows number of elements in the stack led7 most sig


//=======================================================
//  Structural coding
//=======================================================
//logic push = 1;
//val = 16'hffff;
//logic pop =0;
rpncalc rpnTest(CLOCK_50,rst,mode,KEY,val,top,next,counter);
//stack(CLOCK_50,rst,push,pop,val,top,next,counter);
// top
hexdriver hex0(hexdriver0,HEX0);
hexdriver hex1(hexdriver1,HEX1);
hexdriver hex2(hexdriver2,HEX2);
hexdriver hex3(hexdriver3,HEX3);
// next
hexdriver hex4(hexdriver4,HEX4);
hexdriver hex5(hexdriver5,HEX5);
hexdriver hex6(hexdriver6,HEX6);
hexdriver hex7(hexdriver7,HEX7);

endmodule
