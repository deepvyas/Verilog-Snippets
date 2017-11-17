module rotator(clk,enable,numno,numrotated);
	input clk,enable;
	input [3:0] numno;
	output [3:0] numrotated;
	reg [3:0] numrotated;
	integer clk_count=1'b1;
	always @(posedge clk)
	begin
		if(enable==1)
		begin
			clk_count=~clk_count;
			if(clk_count==1)
			begin
				numrotated = {numno[0],numno[1],numno[3:2]};
			end
		end
	end
endmodule

module multiplier(op1,op2,product);
	input [3:0] op1,op2;
	output [3:0] product;
	reg [7:0] product;
	integer i;
	reg [3:0] c,a,m,q;
	always @(op1 or op2)
	begin
		c = 4'b0000;
		a= 4'b0000;
		m= op1;
		q=op2;
		for(i=4;i>0;i=i-1)
		begin
			if(q[0]==1)
			begin
				{c,a} = a+m;
			end
			q =q>>1;
			q[3] = a[0];
			q[4] = a[1];
			a = a>>1;
			a[3] =c[0];
			a[4] = c[1];
		end
		product = {a,q};
	end
endmodule


module test_rotator;
	reg [3:0] numno;
	reg enable,clk;
	wire [3:0] numrotated;
	rotator rt(clk,enable,numno,numrotated);
	initial
	begin
		$monitor($time,"numno=%b|numrotated=%b|clk=%b",numno,numrotated,clk);
	end
	always @(clk)
	begin
		#2 clk<=~clk;
	end
	initial
	begin
		#0 clk=0;enable=0;
		#0 numno=4'b1010;
		#4 enable=1;
		#8 enable=0;
		#2 numno=4'b1100;
		#2 enable=1;
		#8 enable=0;
		$stop;
	end
endmodule

module multiplier_tb;
	reg [3:0] op1,op2;
	wire [7:0] prod;
	multiplier mul(op1,op2,prod);
	initial
	begin
		$monitor($time,"op1=%d|op2=%d|prod=%d",op1,op2,prod);
	end
	initial
	begin
		op1=4'b1000;op2=4'b0010;
		#5 op1=4'b0100;op2=4'b0010;
		#5 op1=4'b1111;op2=4'b1111;
		#5 op1=4'b0100;op2=4'b0000;
		#5 op1=4'b0101;op2=4'b0011;
		$stop;
	end
endmodule

module decoder(decoded,sel);
	input [3:0] sel;
	output [15:0] decoded;
	reg [15:0] decoded;
	
	always  @(sel)
	begin
		case(sel)
			4'h0:decoded=16'h0001;
			4'h1:decoded=16'h0002;
			4'h2:decoded=16'h0004;
			4'h3:decoded=16'h0008;
			4'h4:decoded=16'h0010;
			4'h5:decoded=16'h0020;
			4'h6:decoded=16'h0040;
			4'h7:decoded=16'h0080;
			4'h8:decoded=16'h0100;
			4'h9:decoded=16'h0200;
			4'hA:decoded=16'h0400;
			4'hB:decoded=16'h0800;
			4'hC:decoded=16'h1000;
			4'hD:decoded=16'h2000;
			4'hE:decoded=16'h4000;
			4'hF:decoded=16'h8000;
		endcase
	end
endmodule

module memory(we,datatowrite,regsel,readdata);
	input we;
	input [7:0] datatowrite;
	input [3:0] regsel;
	output [7:0] readdata;
	reg [7:0] readdata;
	reg [7:0] mem [15:0];
	
	always @(regsel or we)
	begin
		if(we==1)
		begin
			mem[regsel] = datatowrite;
		end
		readdata = mem[regsel];
	end
endmodule

module memory_tb;
	reg we;
	reg [7:0] datatowrite;
	wire [7:0] readdata;
	reg [3:0] regsel;
	memory mem(we,datatowrite,regsel,readdata);
	initial
	begin
		$monitor($time,"we=%b,datatowrite=%d,regsel=%d,readdata=%d",we,datatowrite,regsel,readdata);
	end
	initial
	begin
		we=0;regsel=4'b0101;
		datatowrite = 7'b0000001;
		#5 we=1;
		#5 we=0;
		#5 regsel=4'b1111;
		datatowrite = 7'b0001001;
		#5 we=1;
		#5 we=0;
		$stop;
	end
endmodule
