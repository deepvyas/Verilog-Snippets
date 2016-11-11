module PC(q,data,clk,reset);
    output [4:0] q;
    input [4:0] data;
    input clk,reset;
    
    generate
       genvar i;
       for(i=0;i<5;i=i+1)
       begin:pc_loop
          d_ff df(q[i],data[i],clk,reset);
      end
  endgenerate
endmodule

module InstructionMemory(ReadData1,ReadReg1);
   output [31:0] ReadData1;
   input [4:0] ReadReg1;
   reg [31:0] file [31:0];
   reg [31:0] ReadData1;
   integer i;
   initial
   begin
      for(i=0;i<32;i=i+1)
      begin:init
         file[i] =32'h00000000;
      end
   end
   
   always @(ReadReg1)
   begin
       ReadData1 = file[ReadReg1];
   end
endmodule

module signExtend(se_out,inp);
    output [31:0] se_out;
    input [15:0] inp;
    reg [31:0] se_out;
    always @(inp)
    begin
        se_out = { {16{inp[15]}},inp[15:0]};
    end
endmodule


module shiftl2(Q,in);
   input [31:0] in;
   output[31:0] Q;
   reg [31:0] Q;
   parameter n=31;
   always @(in)
   begin
       Q = { in[n-2:0],2'b00};
   end
endmodule
/*
module jump_addr(out,jmp_offset,pc_val);
    input [25:0] jmp_offset;
    input [4:0] pc_val;
    output [31:0] out;
    reg [31:0] out;
    
    always @(jmp_offset or pc_val)
    begin
        out = {pc_val,jmp_offset,2'b00};
    end
endmodule
*/
module mux2to1(out,sel,in1,in2);
    output out;
    input in1,in2,sel;
    
    wire not_sel,w1,w2;
    
    not n1(not_sel,sel);
    and a1(w1,in2,sel);
    and a2(w2,in1,not_sel);
    or  o1(out,w1,w2);
endmodule

module bit8_2to1mux(out,sel,in1,in2);
    output [7:0] out;
    input [7:0] in1,in2;
    input sel;
    
    generate
       genvar j;
       for(j=0;j<8;j=j+1)
          begin:mux_loop
             mux2to1 m1(out[j],sel,in1[j],in2[j]);
          end
    endgenerate
endmodule


module bit32_2to1mux(out,sel,in1,in2);
    output [31:0] out;
    input [31:0] in1,in2;
    input sel;
    
    generate
       genvar j;
       for(j=0;j<4;j=j+1)
          begin:mux_loop
             bit8_2to1mux m1(out[j*8 +7:j*8],sel,in1[j*8 +7:j*8],in2[j*8 +7:j*8]);
         end
     endgenerate
 endmodule
 
/*module RegModule(Regdata1,Regdata2,op_code,RegWrite,WriteData,clk);
    input [31:0] op_code;
    output [31:0] Regdata1,Regdata2;
    reg [4:0] rs,rt,rd;
    input RegWrite;
    input [31:0] WriteData;
    input clk;
    always @(op_code)
    begin
        rs = op_code[25:21];
        rt = op_code[20:16];
        rd = op_code[15:11];
    end
     RegFile32 rf(clk,reset,rs,rt,WriteData,rd,RegWrite,Regdata1,Regdata2);
endmodule
*/ 

module SCDP(ALU_out,PC,reset,clk);
    /* TODO : Controls*/
    /* Variables start*/
    output [31:0] ALU_out;
    input [31:0] PC;
    input clk,reset;
    wire pc_out;
    wire [31:0] op_code;
    wire [15:0] op_offset;
    reg [4:0] rs,rt,rd;
    reg [5:0] Op;
    wire [31:0] Regdata1,Regdata2;
    wire[31:0] aluout;
    wire cout;
    wire [31:0] alusrc2;
    wire [31:0] se_out;
    wire [31:0] branch_off;
    wire [4:0] pcaddr;
    reg [31:0] PCint;
    initial
    begin
        PCint = 0;
    end
    
    always @(posedge clk)
    begin
        PCint = PCint+1;
    end
    /*Variables end*/
    /*Control Signals*/
    wire RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2;
    wire binv;
    wire [1:0] ALUop;
    wire [2:0] aluop;
    assign ALUop = {ALUOp1,ALUOp2};
    assign binv = aluop[2];
    /*Control Signals end*/
    /* Modules*/
    InstructionMemory im(op_code,PCint[4:0]);
    always @(op_code)
    begin
        rs = op_code[25:21];
        rt = op_code[20:16];
        rd = op_code[15:11];
        Op = op_code[31:26];
    end
    /*Write Data and Write Reg mux left*/
    RegFile32 rf(clk,reset,rs,rt,ALU_out,rd,RegWrite,Regdata1,Regdata2);
    Andarray controlunit(RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
    ALUControl alucontrolunit(aluop,ALUop,op_code[5:0]);
    signExtend se(se_out,op_code[15:0]);
    shiftl2 shiftleft(branch_off,se_out);
    bit32_2to1mux mux1(alusrc2,ALUSrc,Regdata2,branch_off);
    alu ALU(ALU_out,cout,Regdata1,alusrc2,binv,binv,aluop[1:0]);
endmodule