`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module FINAL_SYS 
     #(parameter WIDTH_REG = 8 , stages =2 ,fun = 4 , DEPTH_REG = 16 ,ADDR = 4) (
     
        input  i_REF_CLK,
        input  i_UART_CLK,
        input  i_RST,
        input  RX_IN,
        output TX_OUT,
        output o_PAR_ERR,
        output o_framing_ERR
    );
    
    wire                 i_RX_CLK;
    wire                 i_TX_CLK;
    wire                 SYNC_RST_1;
    wire                 SYNC_RST_2;
    wire [7:0]           i_div_ratio;
    wire                 o_RX_Vid ;
    wire [WIDTH_REG-1:0] i_Rd_D_REG;
    wire                 i_Vid_Rd , i_Vid_ALU , i_Vid_D_Sync;
    wire [15:0]          i_ALU_out; 
    wire                 i_FIFO_Full;
    wire [WIDTH_REG-1:0] i_sync_P_Data;
    wire [WIDTH_REG-1:0] i_ASYNC_FIFO_D;
    wire [WIDTH_REG-1:0] o_RX_Data;
    wire [ADDR-1:0]      i_adder ;
    wire                 i_wr_en ,  i_rd_en ;
    wire [WIDTH_REG-1:0] i_Wr_D_REG ;
    wire                 o_Div_EN ;
    wire [WIDTH_REG-1:0] REG0, REG1, REG2, REG3 ;
    wire                 i_rinc;
    wire                 i_winc;
    wire [WIDTH_REG-1:0] i_WR_Data;
    wire                 i_F_EMPITY;
    wire                 i_Gate_EN;
    wire                 gated_clk;
    wire [fun-1:0]       alu_fun;
    wire                 i_ALU_EN;
    wire                 LVL_SIG;

////////////////////////////////////////////////////////////////////// 

    RST_Sync #(.stages(stages)) U_RST_Sync_1 (
        .i_clk(i_REF_CLK) ,   
        .i_rst(i_RST),    
        .o_Sync_rst(SYNC_RST_1)
     );
    
      RST_Sync #(.stages(stages)) U_RST_Sync_2 (  
         .i_clk(i_UART_CLK) ,                     
         .i_rst(i_RST),                          
         .o_Sync_rst(SYNC_RST_2)                 
      );                                         
      
    CLK_DIV U_CLK_DIV_1 (
         .i_clk_ref(i_UART_CLK),  
         .i_rst_n(SYNC_RST_2),    
         .i_clk_en(o_Div_EN) ,   
         .i_div_ratio(i_div_ratio) , 
         .o_div_clk(i_RX_CLK)     
    );
    
    CLK_DIV U_CLK_DIV_2 (       
         .i_clk_ref(i_UART_CLK),
         .i_rst_n(SYNC_RST_2),  
         .i_clk_en(o_Div_EN) ,  
         .i_div_ratio(REG3) ,       
         .o_div_clk(i_TX_CLK)   
    );                          
    
    DIV_MUX U_DIV_MUX (
        .pre_sel (REG2[7:2]),   
        .o_div_ratio(i_div_ratio)
    );     
    
  TOP_UART #(.WIDTH_REG(WIDTH_REG)) U_TOP_UART (
        .i_RX_CLK(i_RX_CLK) , 
        .i_TX_CLK(i_TX_CLK),
        .i_sync_rst_2(SYNC_RST_2),       
        .i_RX_IN(RX_IN),            
        .i_ASYNC_FIFO_D(i_ASYNC_FIFO_D),     
        .i_F_EMPITY(i_F_EMPITY),         
        .i_UART_Config(REG2) ,                               
        .o_TX_OUT(TX_OUT),           
        .o_BUSY(LVL_SIG),             
        .o_RX_Data(o_RX_Data) ,         
        .o_RX_Vid(o_RX_Vid),           
        .o_PAR_ERR(o_PAR_ERR),          
        .o_framing_ERR(o_framing_ERR)       
  );
  
  Data_Sync #(.WIDTH(WIDTH_REG) ,.stages(stages)) U_Data_Sync (
        .clk(i_REF_CLK) ,
        .rst(SYNC_RST_1)  ,
        .async_bus(o_RX_Data) ,
        .bus_en(o_RX_Vid)  ,
        .en_pulse(i_Vid_D_Sync)  ,
        .sync_bus(i_sync_P_Data)   
  );
  
  SYS_CTRL #(.WIDTH_REG(WIDTH_REG) ,.fun(fun) ,.ADDR(ADDR)) U_SYS_CTRL(
       .i_Ref_clk(i_REF_CLK),                         
       .i_rst(SYNC_RST_1),                             
       .i_Rd_D_REG(i_Rd_D_REG),                        
       .i_Vid_Rd(i_Vid_Rd), 
       .i_Vid_ALU(i_Vid_ALU), 
       .i_Vid_D_Sync(i_Vid_D_Sync) ,
       .i_ALU_out(i_ALU_out) ,                        
       .i_FIFO_Full(i_FIFO_Full),                       
       .i_sync_P_Data(i_sync_P_Data), 
                                                             
       .o_wr_en(i_wr_en) , 
       .o_rd_en(i_rd_en) ,                
       .o_adder(i_adder) ,                          
       .o_Wr_D_REG(i_Wr_D_REG) ,                       
       .o_fun(alu_fun),                             
       .o_ALU_EN(i_ALU_EN),                          
       .o_WR_INC(i_winc) ,                         
       .o_WR_D_FIFO(i_WR_Data),                       
       .o_Gate_EN(i_Gate_EN) ,                        
       .o_Div_EN(o_Div_EN)                           
  );
  
  REG_File #(.WIDTH_REG(WIDTH_REG) ,.DEPTH_REG(DEPTH_REG), .ADDR(ADDR)) U_REG_File(
       .i_Ref_clk(i_REF_CLK) ,
       .i_rst(SYNC_RST_1) ,
       .i_adder(i_adder) ,
       .i_wr_en(i_wr_en) ,
       .i_rd_en(i_rd_en) ,
       .i_Wr_D_REG(i_Wr_D_REG) ,
       
       .o_Rd_D_REG(i_Rd_D_REG) ,
       .o_Vid_Rd(i_Vid_Rd) ,
       .REG0(REG0), 
       .REG1(REG1), 
       .REG2(REG2), 
       .REG3(REG3) 
  );
  
  TOP_ASYNC_FIFO #(.WIDTH(WIDTH_REG) ,.DEPTH(DEPTH_REG), .N(stages), .ADDR(ADDR))
   U_FIFO (
        .i_wclk(i_REF_CLK), 
        .i_wrst_n(SYNC_RST_1) ,
        .i_winc(i_winc),
        .i_rclk(i_TX_CLK),
        .i_rrst_n(SYNC_RST_2) ,
        .i_rinc(i_rinc),
        .i_WR_Data(i_WR_Data),                 
        .o_wfull(i_FIFO_Full) ,                  
        .o_rempty(i_F_EMPITY) ,                  
        .o_RD_Data(i_ASYNC_FIFO_D)                 
  );
  ALU U_ALU (
       .i_Ref_clk(gated_clk), 
       .i_rst(SYNC_RST_1) ,
       .i_ALU_EN(i_ALU_EN) ,
       .OP_A(REG0) ,
       .OP_B(REG1),
       .alu_fun(alu_fun),
       .alu_out(i_ALU_out),
       .o_Vid_ALU(i_Vid_ALU)         
     );
     
  Clock_Gating U_CG (
      .i_Ref_clk(i_REF_CLK)  , 
      .i_Gate_EN(i_Gate_EN)  ,
      .gated_clk(gated_clk)  
  );  
  
  Pulse_GEN U_Pulse_GEN(
      .UART_CLK (i_TX_CLK) , 
      .i_rst (SYNC_RST_2) ,
      .LVL_SIG(LVL_SIG) ,         
      .PULSE_SIG(i_rinc)        
  ); 
  
endmodule
