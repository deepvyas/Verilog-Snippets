module d_ff(q,d,clk,reset);
    output q;
    input d,clk,reset;
    reg q;
    always @(posedge clk or negedge reset)
    begin
        if(!reset)
           q<=1'b0;
        else
           q<=d;
    end
endmodule

module reg_32bit(q,d,clk,reset);
    output [31:0] q;
    input [31:0] d;
    input clk,reset;
    
    generate
       genvar j;
       for(j=0;j<32;j=j+1)
       begin:reg_loop
          d_ff df(q[j],d[j],clk,reset);
      end
  endgenerate
endmodule


module mux4_1(regData,q1,q2,q3,q4,reg_no);
   output [31:0] regData;
   input [31:0] q1,q2,q3,q4;
   input [1:0] reg_no;
   wire a0,a1,a2,a3;
   reg [31:0] regData;
   always @(reg_no)
   begin
      case(reg_no)
          2'b00:
             begin
             regData = q1;
             end
          2'b01:
             begin
             regData = q2;
             end
          2'b10:
             begin
             regData = q3;
             end
          2'b11:
             begin
             regData = q4;
             end
     endcase
   end
endmodule 

module decoder2_4(register,reg_no);
   output [3:0] register;
   input [1:0] reg_no;
   wire not0,not1;
   
   not n1(not0,reg_no[0]);
   not n2(not1,reg_no[1]);
   
   and a1 (register[0],not1,not0);
   and a2 (register[1],not1,reg_no[0]);
   and a3 (register[2],reg_no[1],not0);
   and a4 (register[3],reg_no[1],reg_no[0]);
endmodule


module RegFile(clk,reset,ReadReg1,ReadReg2,WriteData,WriteReg,RegWrite,ReadData1,ReadData2);
    input clk,reset,RegWrite;
    input [1:0] ReadReg1,ReadReg2,WriteReg;
    input [31:0] WriteData;
    output [31:0] ReadData1,ReadData2;
    wire [3:0] decoder_out;
    wire [3:0] clock_gates;
    wire [31:0] reg_out[3:0];
    decoder2_4 decoder(decoder_out,WriteReg);
    
    and gate0(clock_gates[0],clk,RegWrite,decoder_out[0]);
    and gate1(clock_gates[1],clk,RegWrite,decoder_out[1]);
    and gate2(clock_gates[2],clk,RegWrite,decoder_out[2]);
    and gate3(clock_gates[3],clk,RegWrite,decoder_out[3]);
    
    
    reg_32bit reg0(reg_out[0],WriteData,clock_gates[0],reset);
    reg_32bit reg1(reg_out[1],WriteData,clock_gates[1],reset);
    reg_32bit reg2(reg_out[2],WriteData,clock_gates[2],reset);
    reg_32bit reg3(reg_out[3],WriteData,clock_gates[3],reset);
    
    
    mux4_1 mux1(ReadData1,reg_out[0],reg_out[1],reg_out[2],reg_out[3],ReadReg1);
    mux4_1 mux2(ReadData2,reg_out[0],reg_out[1],reg_out[2],reg_out[3],ReadReg2);
endmodule

// Extension to 32-registers coming soon!!!