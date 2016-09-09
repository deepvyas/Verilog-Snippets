module bcd_gray(out,inp);
    output [7:0] out;
    input [7:0] inp;
    assign out[0] = inp[0];
    genvar index;
    for(index=1;index<=7;index=index+1)
       begin
          assign out[index] = (inp[index]^inp[index-1]);
       end
endmodule