module intg_tb;
reg [3:0] x;
reg clk, reset;
wire [12:0] y;
intg lol(x,y,reset,clk);
initial begin clk = 1'b0; #100 $finish; end
always begin #5 clk = ~clk; end
initial begin
	//$dumpfile("dump.vcd");
	//$dumpvars;
	reset = 1;
  	#10 reset = 0;
  	#5 x = 10;
	#10 x = 5;
	#10 x = 12;
	#10 x = 1;
end
endmodule