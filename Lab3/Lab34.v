//=========================Exercise=========================================

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

// ==================================================================

module FSM(y,x,clk,rst);
    output y;
    reg y;
    input x,clk,rst;
    reg [2:0] state;
    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            state<=3'b000;
            y<=1'b0;                
        end
        else
        begin
            case(state)
                3'b000:
                begin
                    if(x)
                    begin
                        state<=3'b001;
                        y<=0;                
                    end
                    else 
                    begin
                        state<=3'b000;
                        y<=0;                
                    end            
                end
                3'b001:
                begin
                    if(x)
                    begin
                        state<=3'b001;
                        y<=0;                
                    end
                    else 
                    begin
                        state<=3'b010;
                        y<=0;                
                    end            
                end
                3'b010:
                begin
                    if(x)
                    begin
                        state<=3'b011;
                        y<=0;                
                    end
                    else 
                    begin
                        state<=3'b000;
                        y<=0;                
                    end            
                end
                3'b011:
                begin
                    if(x)
                    begin
                        state<=3'b100;
                        y<=0;                
                    end
                    else 
                    begin
                        state<=3'b010;
                        y<=0;                
                    end            
                end

                3'b100:
                begin
                    if(x)
                    begin
                        state<=3'b001;
                        y<=0;                
                    end
                    else 
                    begin
                        state<=3'b010;
                        y<=1;                
                    end            
                end
                default:
                begin
                    state<=3'b000;
                    y<=0;
                end
            endcase
        end
    end
endmodule