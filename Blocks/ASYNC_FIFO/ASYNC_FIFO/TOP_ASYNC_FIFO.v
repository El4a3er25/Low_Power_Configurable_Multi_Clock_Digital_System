`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module TOP_ASYNC_FIFO #(parameter DEPTH = 16 , WIDTH = 8 , ADDR = 4 , N = 2) (
        input              i_wclk , i_wrst_n , i_winc,
        input              i_rclk , i_rrst_n , i_rinc,
        input  [WIDTH-1:0] i_WR_Data,
        output             o_wfull , 
        output             o_rempty,
        output [WIDTH-1:0] o_RD_Data
    );
  wire [ADDR-1:0] o_waddr;
  wire [ADDR-1:0] o_raddr;
  wire [ADDR:0] i_r2w;
  wire [ADDR:0] i_w2r;
  wire [ADDR:0] o_wptr_gray;
  wire [ADDR:0] o_rptr_gray;
  
  FIFO_Memory #(.DEPTH(DEPTH), .WIDTH(WIDTH), .ADDR(ADDR)) 
        FIFO_Memory_U0 (
            .i_wclk(i_wclk),
            .i_wrst_n(i_wrst_n),           
            .i_wclken(i_winc & !o_wfull),         
            .i_waddr(o_waddr), 
            .i_raddr(o_raddr), 
            .i_WR_Data(i_WR_Data) ,       
            .o_RD_Data(o_RD_Data)         
  );
  
  FIFO_Wptr # (.ADDR(ADDR)) FIFO_Wptr_U1 (
        .i_wclk(i_wclk) ,
        .i_wrst_n(i_wrst_n) ,
        .i_winc(i_winc),           
        .i_r2w(i_r2w),            
        .o_wfull(o_wfull),          
        .o_waddr(o_waddr),          
        .o_wptr_gray(o_wptr_gray)       
  );
  
  FIFO_Rptr # (.ADDR(ADDR)) FIFO_Rptr_U2 (
        .i_rclk(i_rclk) ,
        .i_rrst_n(i_rrst_n) ,
        .i_rinc(i_rinc),           
        .i_w2r(i_w2r),            
        .o_rempty(o_rempty),         
        .o_raddr(o_raddr),          
        .o_rptr_gray(o_rptr_gray)       
  );
  
  DF_SYNC # (.N(N) , .ADDR(ADDR)) DF_SYNC_W (
        .i_clk(i_wclk), 
        .i_rst_n(i_wrst_n), 
        .i_ptr(o_rptr_gray),           
        .o_SYNC(i_r2w)            
    );
  
    DF_SYNC # (.N(N), .ADDR(ADDR)) DF_SYNC_R (
        .i_clk(i_rclk), 
        .i_rst_n(i_rrst_n), 
        .i_ptr(o_wptr_gray),           
        .o_SYNC(i_w2r)            
  ); 
endmodule
