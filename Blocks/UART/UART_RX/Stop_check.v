`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 06:32:07 PM
// Design Name: 
// Module Name: Stop_check
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


module Stop_check(
     input stp_chk_en, 
     input sample_bit,
     output reg stp_err
    );
    always @(*)
    begin
        if (stp_chk_en)
         begin stp_err <= (sample_bit == 1'b1)? 1'b0 : 1'b1; end
        else
          begin  stp_err <= 1'b0 ; end
    end 
    
endmodule
