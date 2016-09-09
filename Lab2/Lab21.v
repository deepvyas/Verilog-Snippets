module mux4_to_1(out,in,sel);
    output out;
    input  [3:0] in;
    input [1:0] sel;
    
    wire n0,n1,a0,a1,a2,a3;
    
    not not0(n0,sel[0]);
    not not1(n1,sel[1]);
    
    and and0(a0,in[0],n1,n0);
    and and1(a1,in[1],n1,sel[0]);
    and and2(a2,in[2],sel[1],n0);
    and and3(a3,in[3],sel[0],sel[1]);
    
    or or1(out,a0,a1,a2,a3);
endmodule

module mux16_to_1(out,in,sel);
    output out;
    input [15:0] in;
    input [3:0] sel;
    
    wire [3:0] middle;
    
    mux4_to_1 mux1(middle[0],in[3:0],sel[1:0]);
    mux4_to_1 mux2(middle[1],in[7:4],sel[1:0]);
    mux4_to_1 mux3(middle[2],in[11:8],sel[1:0]);
    mux4_to_1 mux4(middle[3],in[15:12],sel[1:0]);
    mux4_to_1 mux5(out,middle[3:0],sel[3:2]);    
endmodule
     
