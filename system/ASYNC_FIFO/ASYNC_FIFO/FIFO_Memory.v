`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module FIFO_Memory #(parameter DEPTH = 16 ,WIDTH = 8 , ADDR = 4)(
        input                  i_wclk,i_wrst_n,
        input                  i_wclken,
        input      [ADDR-1:0]  i_waddr, i_raddr,
        input      [WIDTH-1:0] i_WR_Data , 
        output     [WIDTH-1:0] o_RD_Data         
    );
   reg [WIDTH-1:0] Memory [DEPTH-1:0] ; 
   integer i;
   
   always @(posedge i_wclk, negedge i_wrst_n)
    begin
     if (!i_wrst_n)
      begin
        for (i=0 ; i<DEPTH ; i=i+1)
         begin
           Memory[i] <= {WIDTH{1'b0}};
         end
      end
      else if (i_wclken)
       begin
         Memory[i_waddr] <= i_WR_Data;
       end
    end
   
   assign o_RD_Data = Memory[i_raddr]; 
   
endmodule
