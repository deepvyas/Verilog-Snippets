module testadder;
    reg x,y,z;
    wire s,c;
    
    FADDER(s,c,x,y,z);
    initial
    begin
       $monitor(,$time,"x=%b,y=%b,z=%b|s=%b,c=%b",x,y,z,s,c);
   end
   
   initial
   begin
       #0 x=1'b0;y=1'b0;z=1'b0;
       #4 x=1'b1;y=1'b0;z=1'b0;
       #4 x=1'b0;y=1'b1;z=1'b0;
       #4 x=1'b1;y=1'b1;z=1'b0;
       #4 x=1'b0;y=1'b0;z=1'b1;
       #4 x=1'b1;y=1'b0;z=1'b1;
       #4 x=1'b0;y=1'b1;z=1'b1;
       #4 x=1'b1;y=1'b1;z=1'b1;
   end
endmodule
