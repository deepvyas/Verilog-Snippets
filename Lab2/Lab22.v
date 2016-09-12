module DECODER(d,x,y,z);
    input x,y,z;
    output [7:0] d;
    
    wire x0,y0,z0;
    
    not not_x(x0,x);
    not not_y(y0,y);
    not not_z(z0,z);
    
    and a1(d[0],x0,y0,z0);
    and a2(d[1],x0,y0,z);
    and a3(d[2],x0,y,z0);
    and a4(d[3],x0,y,z);
    and a5(d[4],x,y0,z0);
    and a6(d[5],x,y0,z);
    and a7(d[6],x,y,z0);
    and a8(d[7],x,y,z);
    
endmodule

module FADDER(s,c,x,y,z);
    input x,y,z;
    output s,c;
    wire [7:0] d;
    
    DECODER d1(d,x,y,z);
    
    assign s = d[1]|d[2]|d[4]|d[7];
    assign c = d[3]|d[5]|d[6]|d[7];
endmodule

/*=========================================Exercise========================================*/            
module bit8_FA(sum,cout,in1,in2,cin);
	output [7:0] sum;
	output cout;
	input cin;
	input [7:0] in1,in2;
	wire [6:0] carry_mid;
	
	FADDER f1(sum[0],carry_mid[0],in1[0],in2[0],cin);
	
	generate
		genvar j;
		for(j=1;j<7;j=j+1)
			begin:fa_loop
				FADDER f2(sum[j],carry_mid[j],in1[j],in2[j],carry_mid[j-1]);
			end
	endgenerate
	
	FADDER f3(sum[7],cout,in1[7],in2[7],carry_mid[6]);			
endmodule

module bit32_FA(sum,cout,in1,in2,cin);
	output [31:0] sum;
	output cout;
	input [31:0] in1,in2;
	input cin;
	wire [2:0] carry_mid;

	bit8_FA f1(sum[7:0],carry_mid[0],in1[7:0],in2[7:0],cin);
	bit8_FA f2(sum[15:8],carry_mid[1],in1[15:8],in2[15:8],carry_mid[0]);
	bit8_FA f3(sum[23:16],carry_mid[2],in1[23:16],in2[23:16],carry_mid[1]);
	bit8_FA f4(sum[31:24],cout,in1[31:24],in2[31:24],carry_mid[2]);
endmodule