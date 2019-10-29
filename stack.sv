module stack(
input [0:0] clk,rst,push,pop,
input [15:0] val,
output logic [15:0] top,next,
output logic [7:0] counter
);
count stackcounter(clk,rst,push,pop,counter);
logic[4:0] cnt;
logic[4:0] readaddr2;
logic[4:0] readaddr1;
assign cnt = counter[4:0];
// next
assign readaddr2 = cnt - 5'b10;
//head
assign readaddr1 = cnt- 5'b1;
regfile registerMod(clk,rst,push,readaddr1,readaddr2,cnt,{16'b0,val},top,next);
/* notes val<- writedata
top <- readdata1, next<-readdata2
readaddr1,2 <- ptr
writeaddr <-head
write to head remove from head

*/

endmodule
