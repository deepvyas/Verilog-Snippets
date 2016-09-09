module two_to_1mux(f,a,b,s);
    output f;
    input a,b,s;
    wire c,d,e;
    
    not n1(e,s);
    and a1(c,a,s);
    and a2(d,b,e);
    or  o1(f,c,d);
endmodule
