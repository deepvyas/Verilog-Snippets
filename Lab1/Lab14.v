module mux_beh_model(f,s,a,b);
    output f;
    input s,a,b;
    reg f;
    
    always @(s or a or b)
       if(s==1)
          f=a;
       else
          f=b;
endmodule
          