`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module FIFO_Wptr #(parameter ADDR = 4) (
        input                 i_wclk ,i_wrst_n ,
        input                 i_winc,
        input      [ADDR:0]   i_r2w,
        output reg            o_wfull,
        output     [ADDR-1:0] o_waddr,
        output reg [ADDR:0] o_wptr_gray
    );
    reg [ADDR:0] o_wptr_bn;
    reg [ADDR:0] wgraynext;   
    wire [ADDR:0] wbinnext;
    wire          wfull_val;    
    integer i;
    
    assign  o_waddr = o_wptr_bn [ADDR-1:0];
    
    always @(posedge i_wclk , negedge i_wrst_n)
    begin
      if (!i_wrst_n)
       begin
         o_wptr_bn <= 'd0; 
         o_wptr_gray <= 'd0;
       end
      else 
       begin
           o_wptr_bn  <= wbinnext ;
           o_wptr_gray <= wgraynext;
       end
    end
    
  assign wbinnext = o_wptr_bn + (i_winc & !o_wfull);
  //assign wgraynext = (wbinnext >> 1) ^ wbinnext;
 //////////////////// FULL Flag condition ////////////////
    always @(posedge i_wclk , negedge i_wrst_n)
    begin
     if (!i_wrst_n)      
      o_wfull <= 1'b0;
     else
      o_wfull <= wfull_val;
    end
   assign wfull_val = ((wgraynext[ADDR] != i_r2w[ADDR]) && 
                     (wgraynext[ADDR-1] != i_r2w[ADDR-1]) &&
                     (wgraynext[ADDR-2:0] == i_r2w[ADDR-2:0]))? 1'b1:1'b0;
 //////// Gray conversion block /////////////   
    always @(*)
    begin
          wgraynext[ADDR] = wbinnext[ADDR];
           for (i= ADDR-1 ; i >= 0 ; i=i-1)           
             begin wgraynext[i] = wbinnext[i+1] ^ wbinnext[i]; end
          end
//  always @(posedge i_wclk ,negedge i_wrst_n)
//       begin
//         if(!i_wrst_n)
//           o_wptr_gray <= 'd0;
//         else
//           o_wptr_gray <= wgraynext;
//       end
endmodule