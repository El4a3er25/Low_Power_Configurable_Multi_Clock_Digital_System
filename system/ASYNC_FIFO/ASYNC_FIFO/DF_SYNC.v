`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module DF_SYNC # (parameter N = 2 , ADDR = 4) (
        input                 i_clk, i_rst_n,
        input      [ADDR:0]   i_ptr,
        output reg [ADDR:0]   o_SYNC 
    );    
   reg [N-1:0] register [ADDR:0];   
   integer i ;
   reg [ADDR:0] q1_ptr;
   
always @(posedge i_clk , negedge i_rst_n) 
 begin
    if (!i_rst_n)
     begin
        o_SYNC <= 'd0;
         for (i=0 ; i <ADDR+1 ; i=i+1)
           begin register[i] <= 'd0;  end    
     end
   else
     begin
      for (i =0 ; i< ADDR+1 ; i=i+1) 
       //begin {o_SYNC[i] ,register[i]} <= {register[i][N-1:0] ,i_ptr[i]};  end
       begin register[i] <= {register[i][N-2:0] ,i_ptr[i]};  end       
     end
 end 
 
 always @(*) 
  begin
     for (i=0 ; i<ADDR+1 ; i=i+1)
      begin
         o_SYNC[i] = register[i][N-1];
      end
  end
  
//  always @(posedge i_clk , negedge i_rst_n) 
//   begin
//      if (!i_rst_n)
//       begin 
//        q1_ptr <= 'd0;
//        o_SYNC <= 'd0;
//       end
//     else begin
//        {o_SYNC , q1_ptr} <= {q1_ptr , i_ptr};
//         end
//   end
   
endmodule
