module FULLADDER(s,c,x,y,z);
    input x,y,z;
    output s,c;
    reg s,c;
    
    always @(x or y or z)
       {s,c} = x+y+z;
   endmodule

module ADDERSUB(c,overflow,out,A,B,sub);
    input [3:0] A,B;
    input sub;
    output c,overflow;
    output [3:0] out;
    
    wire c1,c2,c3;
    wire [3:0] b_use;
    
    xor x1(b_use[0],B[0],sub);
    xor x2(b_use[1],B[1],sub);
    xor x3(b_use[2],B[2],sub);
    xor x4(b_use[3],B[3],sub);
        
    FULLADDER f1(out[0],c1,A[0],B[0],sub);
    FULLADDER f2(out[1],c2,A[1],B[1],c1);
    FULLADDER f3(out[2],c3,A[2],B[2],c2);
    FULLADDER f4(out[3],c,A[3],B[3],c3);
    
    xor(overflow,c3,c);
endmodule    
