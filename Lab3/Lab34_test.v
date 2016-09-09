module jkff_test;
    reg j,k,clk;
    wire q;
    
    jkff jf(q,j,k,clk);
    
    
    initial begin
       clk=0;
   end
   
   always
      #1 clk=~clk;
      
    initial
    $monitor($time,"j=%b,k=%b,q=%b",j,k,q);
    
    initial
    begin
        j=0;k=0;
        #4 j=0;k=0;
        #2 j=1;k=0;
        #2 j=0;k=1;
        #2 j=1;k=1;
    end
endmodule
