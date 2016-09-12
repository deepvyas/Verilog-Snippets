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

module fsm_test;
reg rst,clk,inp;
    wire outp;
    reg [15:0] seq;
    integer i;
    
    FSM fsm(outp,inp,clk,rst);
    
    initial
    begin
       clk=0;
       rst=1;
       seq = 16'b1011_0110_1101_1011;
       #5 rst=0;
       
       for(i=0;i<=15;i=i+1)
       begin
          inp = seq[i];
          #2 clk=1;
          #2 clk=0;
          $display("State= ",fsm.state,"|Input=",inp,"|outp=",outp);
      end
      testing;
  end
  
  task testing;
     for(i=0;i<=15;i=i+1)
     begin
        inp = $random%2;
        #2 clk=1;
        #2 clk=0;
        $display("State= ",fsm.state,"|Input=",inp,"|outp=",outp);
    end
  endtask
endmodule