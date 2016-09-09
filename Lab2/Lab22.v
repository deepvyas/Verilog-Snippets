module DECODER(d,x,y,z);
    input x,y,z;
    output [7:0] d;
    
    wire x0,y0,z0;
    
    not not_x(x0,x);
    not not_y(y0,y);
    not not_z(z0,z);
    
    and a1(d[0],x0,y0,z0);
    and a2(d[1],x0,y0,z);
    and a3(d[2],x0,y,z0);
    and a4(d[3],x0,y,z);
    and a5(d[4],x,y0,z0);
    and a6(d[5],x,y0,z);
    and a7(d[6],x,y,z0);
    and a8(d[7],x,y,z);
    
endmodule

module FADDER(s,c,x,y,z);
    input x,y,z;
    output s,c;
    wire [7:0] d;
    
    DECODER(d,x,y,z);
    
    assign s = d[1]|d[2]|d[4]|d[7];
    assign c = d[3]|d[5]|d[6]|d[7];
endmodule
            
