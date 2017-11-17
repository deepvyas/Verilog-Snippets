module dm_cache(data,h_m,address,data_mem,r_w);
  input [31:0] address;
  output h_m;
  output [31:0] data;
  input [31:0] data_mem;
  input r_w;
  reg [31:0] data;
  reg h_m;
  reg [31:0] mem [2**15-1:0];
  reg [14:0] tag_ram [2**15-1:0];
  //reg [7:0] valid;
  integer i;
  initial
   begin
      for(i=0;i<32;i=i+1)
      begin:init
         mem[i] =32'hABADDEED;
	 tag_ram[i] = 32'h00000000;
      end
      mem[32'h00000000] = 32'hCAFEBABE;
      tag_ram[32'h00000000] = 32'h00000000;
   end

  always @(r_w or address)
  begin
  if(r_w==0)
  begin
    /*Read cache here*/
    if(tag_ram[address[16:2]] == address[31:17])
    begin
     data= mem[address[16:2]];
     h_m=1'b0;
    end
    else
    begin
     h_m=1;
    end
  end
  else
  begin
    /*Write cache here*/
  end
  end
endmodule