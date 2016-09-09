module dff_sync_clear(q,d,clear,clock);
    output q;
    input d,clear,clock;
    reg q;
    
    always @(posedge clock)
    begin
        if(!clear)
           q<=1'b0;
        else
           q<=d;
       end
endmodule
           
module dff_async_clear(q,d,clear,clock);
    output q;
    input d,clear,clock;
    reg q;
    
    always @(posedge clock or negedge clear)
    begin
        if(!clear)
           q<=1'b0;
        else
           q<=d;
       end
endmodule