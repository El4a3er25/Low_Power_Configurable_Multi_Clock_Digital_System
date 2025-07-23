`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 06:42:53 PM
// Design Name: 
// Module Name: TOP_UART_RX
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


module TOP_UART_RX(
      input        clk , reset,
      input        RX_IN,
      input        PAR_TYP , PAR_EN,
      input  [5:0] prescale,
      output       data_valid,
      output [7:0] P_DATA,
      output       stp_err , par_err 
    );
    wire [5:0] edge_count ;
    wire [3:0] bit_count; 
    wire str_glitch;
    wire sample_en;
    wire count_en;
    wire par_chk_en, strt_chk_en , stp_chk_en , deser_en;
    wire sample_bit;
     
  FSM DUT1 (
      .clk(clk),                
      .reset(reset),            
      .RX_IN(RX_IN),            
      .edge_count(edge_count),  
      .bit_count(bit_count),
      .prescale(prescale),    
      .PAR_EN(PAR_EN),          
      .par_err(par_err),        
      .stp_err(stp_err),        
      .str_glitch(str_glitch),  
      .sample_en(sample_en),    
      .count_en(count_en),      
      .par_chk_en(par_chk_en),  
      .strt_chk_en(strt_chk_en),
      .stp_chk_en(stp_chk_en),  
      .deser_en(deser_en),      
      .data_valid(data_valid)                    
  );
  
  edge_bit_counter DUT2 (
         .clk(clk),
         .reset(reset),         
         .prescale(prescale),      
         .count_en(count_en),            
         .bit_count(bit_count),
         .edge_count(edge_count)
  );
  
  data_sampling DUT3 (
          .clk(clk),         
          .reset(reset),
          .RX_IN(RX_IN),           
          .prescale(prescale),  
          .edge_count(edge_count),
          .sample_en(sample_en),      
          .sample_bit(sample_bit)  
  );
  
  deserializer DUt4 (
          .clk(clk),         
          .reset(reset),
          .deser_en(deser_en),       
          .sample_bit(sample_bit),      
          .P_DATA(P_DATA),
          .bit_count(bit_count)         
  );
  
  parity_check DUT5 (
          .PAR_TYP(PAR_TYP) , 
          .par_chk_en(par_chk_en),
          .sample_bit(sample_bit),          
          .P_DATA(P_DATA),        
          .par_err(par_err)         
  );
  
  Stop_check DUT6 (
          .stp_chk_en(stp_chk_en),
          .sample_bit(sample_bit), 
          .stp_err(stp_err)    
  );
  
  Start_check DUT7 (
          .strt_chk_en(strt_chk_en),
          .sample_bit(sample_bit), 
          .str_glitch(str_glitch) 
  );
  
endmodule
