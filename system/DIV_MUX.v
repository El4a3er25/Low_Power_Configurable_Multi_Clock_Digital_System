`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module DIV_MUX(
      input      [5:0] pre_sel,
      output reg [7:0] o_div_ratio 
    );
    
  always@(*)
   begin
      case (pre_sel)
       6'd8 :   o_div_ratio = 8'd4;
       6'd16:   o_div_ratio = 8'd2;
       6'd32:   o_div_ratio = 8'd1;
       default: o_div_ratio = 8'd1;
      endcase
   end  
endmodule
