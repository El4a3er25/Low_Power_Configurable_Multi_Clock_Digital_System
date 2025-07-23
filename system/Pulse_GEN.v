`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2024 12:04:55 AM
// Design Name: 
// Module Name: Pulse_GEN
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


module Pulse_GEN(
        input      UART_CLK, i_rst ,
        input      LVL_SIG,
        output reg PULSE_SIG
    );
    
    reg enable_FF;
    wire enable_pluse ;
    
    always @(posedge UART_CLK , negedge i_rst)
     begin
      if (!i_rst)
       begin
        enable_FF <= 1'b0;
        PULSE_SIG <= 1'b0;
       end
      else begin
        enable_FF <= LVL_SIG;
        PULSE_SIG <= enable_pluse;
         end
     end
     
  assign enable_pluse = LVL_SIG &~enable_FF ;
  
endmodule
