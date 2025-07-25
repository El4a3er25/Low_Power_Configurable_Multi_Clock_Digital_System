`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 06:37:39 PM
// Design Name: 
// Module Name: Start_check
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


module Start_check(
      input strt_chk_en,
      input sample_bit,
      output reg str_glitch
    );
    always @(*)
    begin
        if (strt_chk_en)
         begin str_glitch <= (sample_bit == 1'b0)? 1'b0 : 1'b1; end
        else
          begin  str_glitch <= 1'b0 ; end
    end  
 
  
endmodule
