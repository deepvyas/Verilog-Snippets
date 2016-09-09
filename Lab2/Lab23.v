module signf(neg,A);
    output neg;
    reg neg;
    input [3:0] A;
    
    always @(A)
       if(A[3]==1)
          begin
              neg=1;
          end
          else
             neg=0;
endmodule

module comparator(signA,signB,altb,agtb,aeqb,A,B);
    output altb,agtb,aeqb,signA,signB;
    input [3:0] A,B;
    reg altb,agtb,aeqb;
    
    signf s1(signA,A);
    signf s2(signB,B);
    
    always @(A or B or signA or signB)
       if(signA==1 && signB==0)
          begin 
             altb=1;
             agtb=0;
             aeqb=0;
         end
       else if(signB==1&&signA==0)
          begin
              agtb=1;
              altb=0;
              aeqb=0;
          end
        else if(A>B)
           begin
               agtb =1;
               altb=0;
               aeqb=0;
           end
        else if(A==B)
           begin
               aeqb=1;
               agtb=0;
               altb=0;
           end
        else
           begin
               altb=1;
               agtb=0;
               aeqb =0;
           end
endmodule
