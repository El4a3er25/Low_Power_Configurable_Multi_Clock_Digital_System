`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module TOP_UART #(parameter WIDTH_REG = 8) (
        input                  i_RX_CLK , i_TX_CLK,
        input                  i_sync_rst_2,
        input                  i_RX_IN,
        input  [WIDTH_REG-1:0] i_ASYNC_FIFO_D,
        input                  i_F_EMPITY,
        input  [WIDTH_REG-1:0] i_UART_Config ,
        
        output                 o_TX_OUT,
        output                 o_BUSY,
        output [WIDTH_REG-1:0] o_RX_Data ,
        output                 o_RX_Vid,
        output                 o_PAR_ERR,
        output                 o_framing_ERR
    );
    
  TOP_UART_RX U_UART_RX (
         .clk(i_RX_CLK) ,
         .reset(i_sync_rst_2),      
         .RX_IN(i_RX_IN),            
         .PAR_TYP(i_UART_Config[1]) ,
         .PAR_EN(i_UART_Config[0]), 
         .prescale(i_UART_Config[7:2]),         
         .data_valid(o_RX_Vid),       
         .P_DATA(o_RX_Data),           
         .stp_err(o_framing_ERR) ,
         .par_err(o_PAR_ERR) 
     );  
     
  TOP_UART_TX U_UART_TX (
        .clk(i_TX_CLK) ,
        .reset(i_sync_rst_2) ,     
        .p_data(i_ASYNC_FIFO_D),           
        .D_Valid(~i_F_EMPITY),          
        .par_type(i_UART_Config[1]) ,
        .PAR_En(i_UART_Config[0]),
        .busy(o_BUSY) ,
        .TX_out(o_TX_OUT) 
             
  );
endmodule
