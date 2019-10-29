/* 32 x 32 register file implementation */

module regfile (

/**** inputs *****************************************************************/

	input [0:0 ] clk,		/* clock */
	input [0:0 ] rst,		/* reset */
	input [0:0 ] we,		/* write enable */
	input [4:0 ] readaddr1,		/* read address 1 */
	input [4:0 ] readaddr2,		/* read address 2 */
	input [4:0 ] writeaddr,		/* write address */
	input [31:0] writedata,		/* write data */

/**** outputs ****************************************************************/

	output logic [31:0] readdata1,	/* read data 1 */
	output logic [31:0] readdata2		/* read data 2 */
);


	/* your code here */
	logic [31:0] registers [31:0];
	
always_ff @(posedge clk) begin
        
        if (rst) begin
        
        end
        if(we) begin
                // write data to specified register
              	registers[writeaddr] <= writedata;
        end
end 
assign readdata1 = (readaddr1 == writeaddr  && we) ? writedata : registers[readaddr1];
assign readdata2 = (readaddr2 == writeaddr  && we) ? writedata : registers[readaddr2];


//assign readdata1 = registers[readaddr1];
//assign readdata2 = registers[readaddr2];


endmodule
