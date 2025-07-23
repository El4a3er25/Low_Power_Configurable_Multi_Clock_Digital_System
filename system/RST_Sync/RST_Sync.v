`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
//////////////////////////////////////////////////////////////////////////////////

module RST_Sync #(parameter stages = 2 ) (
        input      i_clk ,
        input      i_rst,
        output reg o_Sync_rst
    );
    reg [stages-1:0] register ;
    
  always @(posedge i_clk , negedge i_rst)  
   begin
      if(!i_rst)
       begin
          register   <= 'd0;
       end
      else
       begin
          register <= {register[stages-2:0], 1'b1};
       end
   end
  
  always @(*)
   begin
     o_Sync_rst = register[stages-1];
   end
   
endmodule
