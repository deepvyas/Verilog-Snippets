module Entries_16(product,X);
	input [3:0] X;
	output [8:0] product;
	reg [8:0] pre_comp [15:0];
	integer i;
	initial
	begin
	for(i=0;i<16;i=i+1)
	begin
		pre_comp[i] = 25*i;
	end
	end
	assign product = pre_comp[X];
endmodule

module d_ff(q,d,clk,reset);
	input clk,reset,d;
	output q;
	reg q;
	always @(posedge clk or negedge reset)
	begin
		if(!reset)
		begin
			q<=1'b1;
		end
		else
		begin
			q<=d;
		end
	end
endmodule

module ACC_RST(freq_8,freq_16,clk,reset);
	input clk,reset;
	output freq_8,freq_16;
	wire freq_2,freq_4;
	d_ff d1(freq_2,~freq_2,clk,reset);
	d_ff d2(freq_4,~freq_4,freq_2,reset);
	d_ff d3(freq_8,~freq_8,freq_4,reset);
	d_ff d4(freq_16,~freq_16,freq_8,reset);
endmodule

module Adder(sum,prod,acc_reg);
	input [12:0] prod;
	input [12:0] acc_reg;
	output [12:0] sum;
	assign sum = prod+acc_reg;
endmodule

module Acc(Y,add_inp,clk,Acc_reset1,Acc_reset2);
	input Acc_reset1,Acc_reset2,clk;
	input [12:0] add_inp;
	output [12:0] Y;
	reg [12:0] Y;
	
	initial
	begin
		Y=13'b0;
	end
	always @(posedge clk)
	begin
		if(Acc_reset1==1)
		begin
			Y<=add_inp;
		end
		else
			@(posedge Acc_reset2  or negedge Acc_reset2) Y<=13'b0000000000000;
	end
endmodule

module INTG(Y,X,clk,reset,sum,Acc_reset1,Acc_reset2,product);
	input [3:0] X;
	input clk,reset;
	output [12:0] Y;
	output [8:0] product;
	output [12:0] sum;
	output Acc_reset1,Acc_reset2;	
	Entries_16 ent_16(product,X);
	ACC_RST acc_rst(Acc_reset1,Acc_reset2,clk,reset);
	Acc acc_reg(Y,sum,clk,Acc_reset1,Acc_reset2);
	Adder addr(sum,{4'b0000,product},Y);
endmodule


module TestBench;
	reg clk,reset;
	reg [3:0] X;
	wire [12:0] Y;
	wire [12:0] sum;
	wire Acc_reset1,Acc_reset2;
	wire [8:0] product;
	INTG intg(Y,X,clk,reset,sum,Acc_reset1,Acc_reset2,product);
	always @(clk)
	#1 clk<=~clk;
	
	initial
	begin
		$monitor($time," X=%b|Y=%b|clk=%b|reset=%b|sum=%b|Acc_rst1=%b|Adcc_rst2=%b|product=%b",X,Y,clk,reset,sum,Acc_reset1,Acc_reset2,product);
	end
	
	initial
	begin
		reset = 1'b1;
		#1 reset=1'b0;
		#1 reset=1'b1;
		#2 X= 10;
		clk=1'b0;
		#2 X =5;
		#2 X =12;
		#2 X =1;
		#2 X =13;
		#2 X =7;
		#2 X =9;
		#2 X =2;
		#2 X =11;
		#2 X =5;
		#2 X =4;
		#2 X =2;
		$stop;
	end
endmodule
module TestBench_ent16;
	reg [3:0] X;
	wire [8:0] prod;
	Entries_16 ent_16(prod,X);
	initial
	begin
		$monitor($time," X=%b|prod=%b",X,prod);
	end
	
	initial
	begin
		X = 4'd13;
		#2 X=4'd7;
		#2 X=4'd9;
		#2 X=4'd2;
	end
endmodule
