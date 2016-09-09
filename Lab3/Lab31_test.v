module dff_test;
    reg d,clock,clear;
    wire q;
    
    dff_sync_clear df(q,d,clear,clock);
    
    always @(posedge clock)
    begin
       $display("d=%b|clock=%b|clear=%b|q=%b\n",d,clock,clear,q);
   end
   
   
   initial begin
      forever begin
          clock=0;
          #5
          clock=1;
          #5
          clock=0;
      end
   end
   
   initial begin
       d=0;clear=1;
       #4
       d=1;clear=0;
       #50
       d=1;clear=1;
       #20
       d=0;clear=0;
   end
endmodule
   
