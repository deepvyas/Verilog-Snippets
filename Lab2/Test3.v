module comptest;
    reg [3:0] A,B;
    wire altb,agtb,aeqb,signa,signb;
    
    initial
    begin
        A = 4'b0000;
        B = 4'b0000;
    end
    
    initial
    begin
       #1 A=-8;B=-5;
       #1 A=2; B=7;
       #1 A=5; B=-1;
   end
   
   comparator c1(signA,signB,altb,agtb,aeqb,A,B);
   
   initial
   begin
      $monitor($time,"A=%b, B=%b AgrB=%b, AeqB=%b, AltB=%b",A,B,agtb,aeqb,altb);
   end

   initial
   begin
      #5 $finish;
   end
endmodule