module tb32reg;
    reg [31:0] d;
    reg clk,reset;
    wire [31:0] q;
    
    reg_32bit R(q,d,clk,reset);
    
    always @(clk)
    #5 clk<=~clk;
    
    initial
    begin
    $monitor($time,"d =%h,q=%h,reset=%b",d,q,reset);
    end

    initial
    begin
        clk=1'b1;
        reset = 1'b0;
        #20 reset = 1'b1;
        #20 d= 32'hAFAFAFAF;
        #200 $finish;
    end
endmodule

module tbmux;
    reg [31:0] q1,q2,q3,q4;
    reg [1:0] reg_no;
    wire [31:0] regData;
    
    mux4_1 m1(regData,q1,q2,q3,q4,reg_no);
    
    initial
    begin
        $monitor($time,"regData=%h,reg_no=%h",regData,reg_no);
    end
    
    initial
    begin
        q1= 32'hAAAAAAAA;
        q2 =32'hBBBBBBBB;
        q3= 32'hCCCCCCCC;
        q4= 32'hDDDDDDDD;
        
        reg_no = 2'b00;
        #20 reg_no=2'b01;
        #20 reg_no=2'b10;
        #20 reg_no=2'b11;
        #200 $finish;
    end
endmodule


module tbRegfile;
   reg clk,reset,RegWrite;
   reg [1:0] ReadReg1,ReadReg2,WriteReg;
   reg [31:0] WriteData;
   
   wire [31:0] ReadData1,ReadData2;
   
   RegFile rf(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
   
   always @(clk)
      #5 clk<=~clk;
    
   initial
    begin
    $monitor($time,"WriteData=%h|ReadReg1=%b|ReadReg2=%b|WriteReg=%b|RegWrite=%b|ReadData1=%h|ReadData2=%h|reset=%b",WriteData,ReadReg1,ReadReg2,WriteReg,RegWrite,ReadData1,ReadData2,reset);
    end
    
    initial
    begin
       clk=1'b1;
       reset=1'b0;
       RegWrite = 1'b0;
       WriteData = 32'hABADDEED;
       #20 reset=1'b1;
       #20 WriteReg=2'b00;
       RegWrite=1'b1;
       #20 WriteReg=2'b01;
       WriteData = 32'hCAFEBABE;
       #20 RegWrite=1'b0;
       #20 ReadReg1 = 2'b00;ReadReg2=2'b01;
       #200 $finish;
    end
endmodule

module regModtb;
    wire [31:0] Regdata1,Regdata2;
    reg [31:0] op_code;
    reg [31:0] WriteData;
    reg clk,RegWrite;
    RegModule rmod(Regdata1,Regdata2,op_code,RegWrite,WriteData,clk);
    
    
    initial
    begin
    $monitor($time,"WriteData=%h|Regdata1=%h|Regdata2=%h|RegWrite=%b,op_code=%b",WriteData,Regdata1,Regdata2,RegWrite,op_code);
    end
    
    always @(clk)
      #5 clk<=~clk;
    
    initial
    begin
       clk=1'b1;
       RegWrite = 1'b0;
       WriteData = 32'hABADDEED;
       #20 op_code= 32'b00000000000000010000100000000000;
       RegWrite=1'b1;
       #20 op_code= 32'b00000000000000100001000000000000;
       WriteData = 32'hCAFEBABE;
       #20 RegWrite=1'b0;
       #200 $finish;
    end
endmodule

module SCDP_tb;
	reg [31:0] PC;
	reg reset,clk;
	wire [31:0] ALU_out;
	SCDP scdp(ALU_out,PC,reset,clk);


	//always @(clk)
      	//#5 clk<=~clk;
    
	initial
	begin
		$monitor($time,"ALU_out=%h|PC=%h|reset=%b|clk=%b",ALU_out,PC,reset,clk);
	end

	initial
	begin
		reset=1'b0;
		#20 reset=1'b1;
		clk=1'b0;
		#20 clk=1'b1;
		PC = 32'h00000000;
		$finish;
	end
endmodule