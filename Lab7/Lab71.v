module encoder(outp,inp);
    input [7:0] inp;
    output [2:0] outp;
    reg [2:0] outp;
    integer i;
    always @(inp)
    begin
        for(i=0;i<8;i=i+1)
        begin
           if(inp[i]==1)
            begin
                outp = i;
            end
        end
      end
endmodule

module ALU(outp,A,B,opcode);
    input [2:0] opcode;
    input [3:0] A,B;
    output [3:0] outp;
    reg [3:0] outp;
    /*
     *  ctrl = 3'b000 : add
     *  ctrl = 3'b001 : sub
     *  ctrl = 3'b010 : xor
     *  ctrl = 3'b011 : or
     *  ctrl = 3'b100 : and
     *  ctrl = 3'b101 : nor
     *  ctrl = 3'b110 : nand
     *  ctrl = 3'b111 : xnor
    */
    always @(opcode or A or B)
    begin
        case(opcode)
            3'b000:
            begin
                outp = A+B;
            end
            3'b001:
            begin
                outp = A-B;
            end
            3'b010:
            begin
                outp = A^B;
            end
            3'b011:
            begin
                outp = A|B;
            end
            3'b100:
            begin
                outp = A&B;
            end
            3'b101:
            begin
                outp = ~(A|B);
            end
            3'b110:
            begin
                outp = ~(A&B);
            end
            3'b111:
            begin
                outp = ~(A^B);
            end
        endcase
    end
endmodule

module parity_gen(outp,inp);
    input [3:0] inp;
    output outp;
    assign outp = ~(inp[0]^inp[1]^inp[2]^inp[3]);
endmodule

module d_ff(outp,clk,inp,reset);
    input reset,inp,clk;
    output outp;
    reg outp;
    always @(posedge clk or negedge reset)
    begin
        if(!reset)
           outp<=1'b0;
        else
           outp<=inp;
    end
endmodule

module reg_4bit(outp,clk,inp,reset);
    input [3:0] inp;
    input clk;
    output [3:0] outp;
    input reset;
    
    generate
      genvar i;
      for(i=0;i<4;i=i+1)
      begin: reg_loop
         d_ff flp(outp[i],clk,inp[i],reset);
      end
    endgenerate
endmodule

module Pipeline(parity,alu_out,enc_out,clk,A,B,inp_code,reset);
    input reset,clk;
    input [3:0] A,B;
    input [7:0] inp_code;
    output parity;
    output [3:0] alu_out;
    output [2:0] enc_out;
    wire [3:0] aluinp1,aluinp2,parity_inp;
    wire [3:0] op_code;
    reg_4bit alusrc1(aluinp1,clk,A,reset);
    reg_4bit alusrc2(aluinp2,clk,B,reset);
    encoder enc(enc_out,inp_code);
    reg_4bit oc_reg(op_code,clk,{1'b0,enc_out},reset);
    ALU alu(alu_out,aluinp1,aluinp2,op_code[2:0]);
    reg_4bit alu_outp(parity_inp,clk,alu_out,reset);
    parity_gen pg(parity,parity_inp);
endmodule