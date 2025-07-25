`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 05:43:03 PM
// Design Name: 
// Module Name: parity_check
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


module parity_check(
     input       PAR_TYP , par_chk_en,
     input       sample_bit,
     input [7:0] P_DATA,
     output reg  par_err
    );
    
    reg parity ;
    
    localparam odd = 1'b1 , even = 1'b0;
    
  always @(*)
  begin
     if (par_chk_en)
      begin
        case(PAR_TYP)
          odd : parity = ~^P_DATA;
          even: parity = ^P_DATA;
          default: parity = 1'b0;
        endcase     
        if (sample_bit != parity)
          begin par_err = 1'b1; end        
        else begin par_err = 1'b0; end
      end
     else
        par_err = 1'b0;
  end
  
endmodule
