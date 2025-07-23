`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
//////////////////////////////////////////////////////////////////////////////////

module REG_File #(parameter WIDTH_REG = 8 , DEPTH_REG = 16, ADDR = 4) (
        input                      i_Ref_clk              ,
        input                      i_rst                  ,
        input      [ADDR-1:0]      i_adder                ,
        input                      i_wr_en                ,
        input                      i_rd_en                ,
        input      [WIDTH_REG-1:0] i_Wr_D_REG             ,
        output reg [WIDTH_REG-1:0] o_Rd_D_REG             ,
        output reg                 o_Vid_Rd               ,
        output     [WIDTH_REG-1:0] REG0, REG1, REG2, REG3 
    );
    
    reg [WIDTH_REG-1:0] Memory [DEPTH_REG-1:0] ;
    integer i;
  always @(posedge i_Ref_clk , negedge i_rst)
  begin
    if(!i_rst)
       begin
          o_Vid_Rd <= 1'b0;
          o_Rd_D_REG <= 'd0;
               for (i=0 ; i<DEPTH_REG ; i = i+1)
                begin
                 if  (i == 0)
                   Memory[i] <= 'd5;
                 else if (i == 1)
                   Memory[i] <= 'd10;
                 else if (i == 2)
                   Memory[i] <= 'b100_000_0_1;
                 else if (i == 3)
                   Memory[i] <= 'd32;
                 else 
                   Memory[i] <= 'd0;
                end
              end
        else if (i_wr_en && !i_rd_en) begin
             Memory[i_adder] <= i_Wr_D_REG;
        end
        else if (!i_wr_en && i_rd_en) begin
            o_Rd_D_REG <= Memory[i_adder];
            o_Vid_Rd   <= 1'b1;
          end
        else
          o_Vid_Rd   <= 1'b0;
  end
  
  assign REG0 = Memory[0] ,
         REG1 = Memory[1] ,
         REG2 = Memory[2] ,
         REG3 = Memory[3] ;
                 
endmodule
