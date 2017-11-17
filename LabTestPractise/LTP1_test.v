module dm_cache_tb;
  reg [31:0] address,data_mem;
  reg r_w,clk;
  wire [31:0] data;
  wire h_m;
  dm_cache dm(data,h_m,address,,r_w);
  
  initial
  begin
    $monitor($time," data=%h|h_m=%b|address=%h|r_w=%b",data,h_m,address,r_w);
  end
  
  initial
  begin
  r_w=0;
  #5 address=32'h00000000;
  #5 address= 32'h0000000F;
  #5 address = 32'h10000021;
  $finish;
  end
endmodule