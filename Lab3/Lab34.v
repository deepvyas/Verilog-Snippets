module jkff(Q,j,k,clk);
    input j,k,clk;
    output Q;
    reg Q;
    
    always @(posedge clk)
    begin
        Q<= (j&~Q)|(~k&Q);
    end
endmodule


module counter(count,clk);
    parameter n=4;
    input clk;
    output [n-1:0] count;
    wire [n-1:0] count;
    wire mid2,mid3;
    
    
    jkff f1(count[0],1,1,clk);
    jkff f2(count[1],count[0],count[0],clk);
    and a1(mid2,count[0],count[1]);
    jkff f3(count[2],mid2,mid2,clk);
    and a2(mid3,count[2],mid2);
    jkff f4(count[3],mid3,mid3,clk);
    
endmodule