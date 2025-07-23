`timescale 1ns / 1ps

module SYS_CTRL_TB();

parameter WIDTH_REG = 8 , fun = 4 ;

        reg                   i_Ref_clk;                             
        reg                   i_rst;                                 
        reg  [WIDTH_REG-1:0]  i_Rd_D_REG;                            
        reg                   i_Vid_Rd, i_Vid_ALU, i_Vid_D_Sync;    
        reg  [15:0]           i_ALU_out;                             
        reg                   i_FIFO_Full;                           
        reg   [WIDTH_REG-1:0] i_sync_P_Data;                         
                                                                          
        wire                  o_wr_en , o_rd_en ;                    
        wire [WIDTH_REG-1:0]  o_adder ;                              
        wire [WIDTH_REG-1:0]  o_Wr_D_REG ;                           
        wire [fun-1:0]        o_fun;                                 
        wire                  o_ALU_EN;                              
        wire                  o_WR_INC ;                             
        wire [WIDTH_REG-1:0]  o_WR_D_FIFO;                           
        wire                  o_Gate_EN ;                            
        wire                  o_Div_EN  ;
   
        
    SYS_CTRL #(.WIDTH_REG(WIDTH_REG) , .fun(fun)) U_SYS_CTRL (
        .i_Ref_clk(i_Ref_clk),                        
        .i_rst(i_rst),                            
        .i_Rd_D_REG(i_Rd_D_REG),                       
        .i_Vid_Rd(i_Vid_Rd), 
        .i_Vid_ALU(i_Vid_ALU),
        .i_Vid_D_Sync(i_Vid_D_Sync),
        .i_ALU_out(i_ALU_out),                        
        .i_FIFO_Full(i_FIFO_Full),                      
        .i_sync_P_Data(i_sync_P_Data),                    
                                          
        .o_wr_en(o_wr_en) , 
        .o_rd_en(o_rd_en) ,               
        .o_adder(o_adder) ,                         
        .o_Wr_D_REG(o_Wr_D_REG) ,                      
        .o_fun(o_fun),                            
        .o_ALU_EN(o_ALU_EN),                         
        .o_WR_INC(o_WR_INC) ,                        
        .o_WR_D_FIFO(o_WR_D_FIFO),                      
        .o_Gate_EN(o_Gate_EN) ,                       
        .o_Div_EN(o_Div_EN)                        
    );
    
   always #5  i_Ref_clk = ~i_Ref_clk;
   
 initial 
  begin
     initialize ();
     reset ();
////////////// writing ////////////////////     
     @(posedge i_Ref_clk)
      i_Vid_D_Sync = 1'b1;
      i_sync_P_Data = 8'haa;
     @(posedge i_Ref_clk)
      i_Vid_D_Sync = 1'b0;
     @(posedge i_Ref_clk)
      i_Vid_D_Sync = 1'b1;
      i_sync_P_Data = 8'd4;
      @(posedge i_Ref_clk)
       i_Vid_D_Sync = 1'b0;
     @(posedge i_Ref_clk)
      i_Vid_D_Sync = 1'b1;
      i_sync_P_Data = 8'b1101_1001;
     @(posedge i_Ref_clk)
      i_Vid_D_Sync = 1'b0; 
  /////////////////////////////////////
      @(posedge i_Ref_clk)
       i_Vid_D_Sync = 1'b1;
       i_sync_P_Data = 8'hcc ;
      @(posedge i_Ref_clk)
       i_Vid_D_Sync = 1'b0;
      @(posedge i_Ref_clk)
        i_Vid_D_Sync = 1'b1;
        i_sync_P_Data = 8'd12 ;
       @(posedge i_Ref_clk)
        i_Vid_D_Sync = 1'b0;  
     @(posedge i_Ref_clk)
         i_Vid_D_Sync = 1'b1;
         i_sync_P_Data = 8'd10 ;
      @(posedge i_Ref_clk)
         i_Vid_D_Sync = 1'b0; 
      @(posedge i_Ref_clk)
         i_Vid_D_Sync = 1'b1;
         i_sync_P_Data = 8'd14 ; 
      @(posedge i_Ref_clk)
         i_Vid_D_Sync = 1'b0;
       @(posedge i_Ref_clk)
          i_Vid_ALU = 1'b1;
          i_ALU_out = 16'b1111_1011_0000_1101; 
          i_FIFO_Full = 1'b0;                 
  end 
  
  task initialize ();
   begin
     i_Ref_clk = 1'b0;                                                   
     i_Rd_D_REG ='d0;                       
     i_Vid_Rd = 1'b0;
     i_Vid_ALU = 1'b0; 
     i_Vid_D_Sync = 1'b0;
     i_ALU_out = 'd0;                        
     i_FIFO_Full = 1'b0;                      
     i_sync_P_Data = 'd0;                    
   end
   endtask
   
      task reset ();
    begin
      i_rst = 1'b0;
      #3
      i_rst = 1'b1;
    end
   endtask 
                          
endmodule