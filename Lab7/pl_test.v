module enc_test;
    reg [7:0] inp;
    wire [2:0] outp;
    encoder enc(outp,inp);
    
    initial
    begin
        $monitor($time,"inp=%b|outp=%b",inp,outp);
    end
    
    initial
    begin
        #20 inp=8'b00000001;
        #20 inp=8'b00000010;
        #20 inp=8'b00000100;
        #20 inp=8'b00001000;
        #20 inp=8'b00100000;
        #20 inp=8'b01000000;
        #20 inp=8'b10000000;
    end
endmodule



module parity_test;
    reg [3:0] inp;
    wire outp;
    
    parity_gen pg(outp,inp);
    
    initial 
       $monitor("inp=%b|outp=%b",inp,outp);
    initial
    begin
         inp= 4'b0000;
    #10 inp= 4'b1111;
    #10 inp= 4'b1011;
    end
endmodule

module pipeline_test;
    reg reset,clk;
    reg [3:0] A,B;
    reg [7:0] inp_code;
    wire parity;
    wire [2:0] enc_out;
    wire [3:0] alu_out;
    
    Pipeline pl(parity,alu_out,enc_out,clk,A,B,inp_code,reset);
    always @(clk)
      #5 clk<=~clk;
    
    initial
       $monitor($time,"A=%b|B=%b|inp_code=%b|clk=%b||alu_out=%b|enc_out=%b|parity=%b",A,B,inp_code,clk,alu_out,enc_out,parity);  
    initial
       begin
           clk=1'b1;
           reset = 1'b0;
           #10 reset=1'b1;
           #10 A=4'b0001;
               B=4'b1010;
               inp_code= 8'b00000001;
           #10 A=4'b0010;
               B=4'b1010; 
               inp_code= 8'b00010000;
           #10 A=4'b0100;
               B=4'b1010; 
              inp_code= 8'b01000000;
           #10 $finish;
       end
endmodule