module tb_mux;
    reg [31:0] in1,in2;
    wire [31:0] out;
    reg sel;
    bit32_2to1mux mux1(out,sel,in1,in2);
    
    initial
    begin
        $monitor($time,"out = %b,sel=%b",out,sel);
        in1 = 32'b10101010101010101010101010101010;
        in2 = 32'b01010101010101010101010101010101;
        sel = 1'b0;
        #100 sel=1'b1;
        #100 sel=1'b0;
        #100 $finish;
    end
endmodule

module tb32bitand;
    reg [31:0] in1,in2;
    wire [31:0] out;
    
    bit32_and a1(out,in1,in2);
    
    initial
    begin
        $monitor($time,"out=%b",out);
    end
    
    initial
    begin
        in1 = 32'hA5A5;
        in2 = 32'h5A5A;
        
        #100 in1 = 32'h 5A5A;
        #400 $finish;
    end
endmodule

module tb_fadder;
    reg [31:0] x,y;
    reg z;
    wire [31:0] sum;
    wire cout;
    
    
    FA_adder fa(cout,sum,x,y,z);
    
    initial
    begin
    $monitor($time,"in1=%b,in2=%b,sum=%b,cout=%b",x,y,sum,cout);
    end
    
    
    initial
    begin
        #0 x=32'h0000;y=32'hAAAA;z=32'b0;
        #3 x=32'h0001;y=32'hAAAA;z=32'b0;
        #3 x=32'h0002;y=32'hAAAA;z=32'b0;
        #3 x=32'h000A;y=32'hAAAA;z=32'b0;
   end
  endmodule
 
 
module tbALU();
reg Binvert, Carryin;
reg [1:0] Operation;
reg [31:0] a,b;
wire [31:0] Result;
wire CarryOut;
alu alu1(Result,CarryOut,a,b,Carryin,Binvert,Operation);
initial
begin
    $monitor($time,"result=%b|cout=%b|op=%b",Result,CarryOut,Operation);
end

initial
begin
a=32'ha5a5a5a5;
b=32'h5a5a5a5a;
Operation=2'b00;
Binvert=1'b0;
Carryin=1'b0; //must perform AND resulting in zero
#100 Operation=2'b01; //OR
#100 Operation=2'b10; //ADD
#100 Binvert=1'b1;//SUB
#200 $finish;
end
endmodule