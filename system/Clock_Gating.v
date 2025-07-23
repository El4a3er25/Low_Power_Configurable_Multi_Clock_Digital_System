`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2024 11:00:28 PM
// Design Name: 
// Module Name: Clock_Gating
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clock_Gating(
        input       i_Ref_clk,
        input       i_Gate_EN ,
        output wire gated_clk
    );
    
    reg out_latch ;
     
  always @(i_Ref_clk or i_Gate_EN)
  begin
    if (!i_Ref_clk)
      out_latch <= i_Gate_EN ;
  end
  
  assign gated_clk = out_latch & i_Ref_clk;
  
endmodule
