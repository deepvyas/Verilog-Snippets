module mux_16_to_1(in,sel,out);
input [143:0] in;
input [3:0] sel;
output [8:0] out;
reg [8:0] out;
always @ (in,sel) begin
if (sel == 0)  begin out = 25*0; end
	else if(sel == 1) begin out = 25*1; end
	else if(sel == 2) begin out = 25*2; end
	else if(sel == 3) begin out = 25*3; end
	else if(sel == 4) begin out = 25*4; end
	else if(sel == 5) begin out = 25*5; end
	else if(sel == 6) begin out = 25*6; end
	else if(sel == 7) begin out = 25*7; end
	else if(sel == 8) begin out = 25*8; end
	else if(sel == 9) begin out = 25*9; end
	else if(sel == 10) begin out = 25*10; end
	else if(sel == 11) begin out = 25*11; end
	else if(sel == 12) begin out = 25*12; end
	else if(sel == 13) begin out = 25*13; end
	else if(sel == 14) begin out = 25*14; end
	else if(sel == 15) begin out = 25*15; end
end
endmodule

module adder_register(in, res, acc_rst1, acc_rst2,clk);
input [8:0] in;
input acc_rst1, acc_rst2, clk;
output [12:0] res;
reg [12:0] res;
always @ (posedge acc_rst2 or negedge acc_rst2) begin
	res = 0;
end

always @ (posedge clk) begin
	if (acc_rst1 == 1) begin res = res+in; end
end
endmodule

module d_ff(d,clk,reset,q,q1);
input d,clk,reset;
output q,q1;
reg q,q1;
always @ (posedge clk) begin
	if(reset) begin q <= 1; q1 <= 0; end
	else begin
		q = d;
		q1 = ~q;
	end
end
endmodule

module acc_rst(clk, reset, acc_rst1, acc_rst2);
input clk, reset;
output acc_rst1, acc_rst2;
wire [3:0] q;
wire [3:0] q1;
d_ff ff0(q1[0],clk,reset,q[0],q1[0]);
d_ff ff1(q1[1],q[0],reset,q[1],q1[1]);
d_ff ff2(q1[2],q[1],reset,q[2],q1[2]);
d_ff ff3(q1[3],q[2],reset,q[3],q1[3]);
reg acc_rst1, acc_rst2;
always @ (q[2],q[3]) begin
	acc_rst1 = q[2];
	acc_rst2 = q[3];
end
endmodule


module intg(x, y, reset, clk);
input [3:0] x;
input reset, clk;
output [12:0] y;
reg [143:0] in;
wire [8:0] mux_out;
wire acc_rst1, acc_rst2;
mux_16_to_1 mux(in,x,mux_out);
acc_rst gen_acc_rst(clk,reset,acc_rst1, acc_rst2);
adder_register ar(mux_out,y,acc_rst1, acc_rst2,clk);
endmodule