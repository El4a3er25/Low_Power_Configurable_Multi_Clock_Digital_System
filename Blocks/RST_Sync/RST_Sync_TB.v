`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2024 05:18:14 PM
// Design Name: 
// Module Name: RST_Sync_TB
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


module RST_Sync_TB();

  parameter stages = 2 ,
            period = 20;
  
      reg i_clk ;        
      reg i_rst ;         
      wire o_Sync_rst;
      
    RST_Sync #(.stages(stages)) U_RST_Sync (
       .i_clk(i_clk) ,         
       .i_rst(i_rst),          
       .o_Sync_rst(o_Sync_rst) 
    );
    
  always #10 i_clk =~i_clk;
 
 initial 
  begin
    i_clk = 1'b0;
    i_rst = 1'b0;
    #(2*period);
    i_rst = 1'b1;
    #(2*period);
    i_rst = 1'b0;
    #(2*period);
    i_rst = 1'b1;
    #(4*period);
    $stop;
  end
    
endmodule
