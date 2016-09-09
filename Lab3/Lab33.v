module shiftreg(Q,en,in,clk);
    parameter n=4;
    input en,in,clk;
    output [n-1:0] Q;
    reg [n-1:0] Q;
    
    initial
    Q = 4'b1010;
    always @(posedge clk)
       begin
            if(en)
               Q = {in,Q[n-1:1]};
           end
endmodule

module shiftreg2(Q,en,in,clk);
    parameter n=4;
    input en,in,clk;
    output [n-1:0] Q;
    reg [n-1:0] Q;
    
    initial
    Q = 4'b1010;
    always @(posedge clk)
       begin
           if(en)
           begin
               Q[0]<=Q[1];
               Q[1]<=Q[2];
               Q[2]<=Q[3];
               Q[3]<=in;
           end
       end
endmodule
       
