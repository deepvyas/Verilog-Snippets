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
 
module mux4to1(out,sel,in1,in2,in3,in4);
      output out;
      input [1:0] sel;
      input in1,in2,in3,in4;
      
      wire mo1,mo2,temp1,temp2,sel1_not;
      not n1 (sel1_not,sel[1]);
      mux2to1 mux1(mo1,sel[0],in1,in2);
      mux2to1 mux2(mo2,sel[0],in3,in4);
      
      and a1(temp1,sel1_not,mo1);
      and a2(temp2,sel[1],mo2);
      
      or o1(out,temp1,temp2);
endmodule 
 
module bit32_4to1mux(out,sel,in1,in2,in3,in4);
    output [31:0] out;
    input [1:0] sel;
    input [31:0] in1,in2,in3,in4;
    
    generate
       genvar j;
       for(j=0;j<32;j=j+1)
          begin:mux_loop
             mux4to1 m1(out[j],sel,in1[j],in2[j],in3[j],in4[j]);
         end
     endgenerate
endmodule

 module bit32_and(out,in1,in2);
     output [31:0] out;
     input [31:0] in1,in2;
     
     assign {out} = in1&in2;
 endmodule
 
 module bit32_or(out,in1,in2);
     output [31:0] out;
     input [31:0] in1,in2;
     
     assign {out} = in1|in2;
 endmodule
 
 
 module FA_adder(cout,sum,in1,in2,cin);
     output cout;
     output [31:0] sum;
     input [31:0] in1,in2;
     input cin;
     
     assign {cout,sum} = in1+in2+cin;
     
 endmodule
 
 module alu(result,cout,a,b,cin,binv,op);
     output cout;
     output [31:0] result;
     input [31:0] a,b;
     input cin,binv;
     input [1:0] op;
      
     wire [31:0] bnot;
     wire [31:0] mux_out;
     wire [31:0] aw,ow,sumw;
     
     assign bnot = ~b;
     bit32_2to1mux muxin(mux_out,binv,b,bnot);
     bit32_and an1(aw,a,mux_out);
     bit32_or o1(ow,a,mux_out);
     FA_adder fa(cout,sumw,a,mux_out,binv);
     
     bit32_4to1mux outm(result,op,aw,ow,sumw,);
     
 endmodule


module Andarray(RegDst,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2,Op);
   input [5:0] Op;
   output RegDst,ALUSrc,MemtoReg, RegWrite, MemRead, MemWrite,Branch,ALUOp1,ALUOp2;
   wire Rformat, lw,sw,beq;
   
   assign Rformat = (~Op[0])& (~Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
   assign lw = (Op[0])& (Op[1])& (~Op[2])& (~Op[3])& (~Op[4])& (Op[5]);   
   assign sw = (Op[0])& (Op[1])& (~Op[2])& (Op[3])& (~Op[4])& (Op[5]);       
   assign beq = (~Op[0])& (~Op[1])& (Op[2])& (~Op[3])& (~Op[4])& (~Op[5]);
   
   assign RegDst = Rformat;
   assign MemtoReg = lw;
   assign MemRead = lw;
   assign MemWrite = sw;
   assign Branch  = beq;
   assign ALUOp1 = Rformat;
   assign ALUOp2 = beq;
   assign ALUSrc = lw|sw;
   assign RegWrite = Rformat|lw;
 endmodule      
    

module ALUControl(op,ALUOp,funct);
    output [2:0] op;
    input [1:0] ALUOp;
    input [5:0] funct;
    
    assign op[0] = (funct[0]|funct[3]) & ALUOp[1];
    assign op[1] = (~funct[2])|(~ALUOp[1]);
    assign op[2] = (funct[1] &ALUOp[1]) | ALUOp[0];
    
endmodule