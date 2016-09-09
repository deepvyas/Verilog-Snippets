module mealy_test;
    reg rst,clk,inp;
    wire outp;
    
    reg [15:0] seq;
    integer i;
    
    mealy ml(outp,clk,rst,inp);
    
    initial
    begin
       clk=0;
       rst=1;
       seq = 16'b0101_0111_0111_0010;
       #5 rst=0;
       
       for(i=0;i<=15;i=i+1)
       begin
          inp = seq[i];
          #2 clk=1;
          #2 clk=0;
          $display("State= ",ml.state,"|Input=",inp,"|outp=",outp);
      end
      testing;
  end
  
  task testing;
     for(i=0;i<=15;i=i+1)
     begin
        inp = $random%2;
        #2 clk=1;
        #2 clk=0;
        $display("State= ",ml.state,"|Input=",inp,"|outp=",outp);
    end
  endtask
endmodule
            
