module mux_data_model(f,a,b,s);
    output f;
    input a,b,s;
    
    assign f = s?a:b;
endmodule
