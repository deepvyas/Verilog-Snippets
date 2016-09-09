`timescale 1ns/1ps

module not_and(c,a,b);
    output c;
    input a,b;
    wire d;
    
    and a1(d,a,b);
    not out(c,d);
endmodule
