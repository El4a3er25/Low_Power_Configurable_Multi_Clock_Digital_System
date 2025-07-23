`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2024 03:31:15 AM
// Design Name: 
// Module Name: MUX
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


module MUX(
  input [1:0] mux_sel,
  input  ser_data , par_bit,
  output reg TX_out 
  
    );
    localparam start_bit = 1'b0 , stop_bit = 1'b1;
    
    always @(*)
    begin
       case (mux_sel)
          2'b00: TX_out = start_bit;
          2'b01: TX_out = stop_bit;
          2'b10: TX_out = ser_data;
          2'b11: TX_out = par_bit;
          default: TX_out = 1'b1;
       endcase       
    end
    
endmodule
