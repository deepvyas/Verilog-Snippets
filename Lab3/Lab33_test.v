module shift_test;
    parameter n=4;
    reg en,in,clk;
    wire [n-1:0] Q;
    
    shiftreg shrg(Q,en,in,clk);
    
    initial begin
        clk=0;
    end
       
    always
    #2 clk=~clk;
    
    
    initial
       $monitor($time,"en=%b|in=%b|Q=%b\n",en,in,Q);
    
    initial
    begin
        in=0;en=0;
        #4 in=1;en=1;
        #4 in=1;en=0;
        #4 in=0;en=1;
        #5 $finish;
    end
endmodule
