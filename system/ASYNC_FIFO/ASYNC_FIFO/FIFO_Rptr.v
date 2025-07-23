`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
//////////////////////////////////////////////////////////////////////////////////
module FIFO_Rptr #(parameter ADDR = 4) (
        input                 i_rclk ,i_rrst_n ,
        input                 i_rinc,
        input      [ADDR:0]   i_w2r,
        output reg            o_rempty,
        output     [ADDR-1:0] o_raddr,
        output reg [ADDR:0]   o_rptr_gray
    );
    
    reg  [ADDR:0] o_rptr_bn;
    wire [ADDR:0] rgraynext;
    wire [ADDR:0] rbinnext;
    wire          rempty_val;
    integer i;
  
  assign o_raddr = o_rptr_bn[ADDR-1:0];  
  
  always @(posedge i_rclk , negedge i_rrst_n)
  begin
    if (!i_rrst_n)
     begin
       o_rptr_bn   <= 'd0;
       o_rptr_gray <= 'd0;
       o_rempty    <= 1'b1;
      end
     else
      begin
        o_rptr_bn   <= rbinnext;
        o_rptr_gray <= rgraynext ;
        o_rempty    <= rempty_val;
      end
  end
    
   assign rgraynext = (rbinnext >> 1) ^ rbinnext; 
   assign rbinnext = o_rptr_bn + (i_rinc & ~o_rempty);
  assign rempty_val = (rgraynext == i_w2r)? 1'b1:1'b0;
  
endmodule