module bcd_gray_gate(inp,out);
    output [0:7] out;
    input [0:7] inp;
    
    wire [0:7] out;
    
    and a1(out[0],inp[0],1);
    xor x1(out[1],inp[1],inp[0]);
    xor x2(out[2],inp[2],inp[1]);
    xor x3(out[3],inp[3],inp[2]);
    xor x4(out[4],inp[4],inp[3]);
    xor x5(out[5],inp[5],inp[4]);
    xor x6(out[6],inp[6],inp[5]);
    xor x7(out[7],inp[7],inp[6]);
endmodule
