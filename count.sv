module count (input clk,rst,up,down,output logic [7:0] cnt);

always_ff @(posedge clk) begin
	if (rst) cnt <= 0;
	else if (up) cnt <= cnt+8'b1;
	else if (down) cnt <= cnt-8'b1;
end
endmodule 
