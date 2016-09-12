module test_8bit;	
    reg [7:0] x,y;
    reg z;
    wire [7:0] sum;
    wire cout;
    bit8_FA fa(sum,cout,x,y,z);
    initial
    begin
    $monitor($time,"in1=%b,in2=%b,sum=%b,cout=%b",x,y,sum,cout);
    end
    initial
    begin
        #0 x=8'h00;y=8'hAA;z=1'b0;
        #3 x=8'h01;y=8'hAA;z=1'b0;
        #3 x=8'h02;y=8'hAA;z=1'b0;
        #3 x=8'h0A;y=8'hAA;z=1'b0;
   end
endmodule

module test_32bit;
    reg [31:0] x,y;
    reg z;
    wire [31:0] sum;
    wire cout;
    
    
    bit32_FA fa(sum,cout,x,y,z);
    
    initial
    begin
    $monitor($time,"in1=%b,in2=%b,sum=%b,cout=%b",x,y,sum,cout);
    end
    
    
    initial
    begin
        #0 x=32'h0000;y=32'hAAAA;z=1'b0;
        #3 x=32'h0001;y=32'hAAAA;z=1'b0;
        #3 x=32'h0002;y=32'hAAAA;z=1'b0;
        #3 x=32'h000A;y=32'hAAAA;z=1'b0;
   end
  endmodule
