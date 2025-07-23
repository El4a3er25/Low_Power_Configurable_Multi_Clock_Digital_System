`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////// 
//////////////////////////////////////////////////////////////////////////////////

module CLK_DIV(
        input        i_clk_ref,
        input        i_rst_n,
        input        i_clk_en,
        input  [7:0] i_div_ratio,
        output       o_div_clk
    );
   
 reg [7:0] counter ;
 reg       flag ;
 reg       o_div_clk_C;
 wire      is_odd;
 wire      CLK_EN;
 
 assign is_odd = i_div_ratio[0];
 assign CLK_EN = i_clk_en && (i_div_ratio != 8'd0) && (i_div_ratio != 8'd1);
 assign o_div_clk = (CLK_EN)? o_div_clk_C : i_clk_ref ;
 
 /*always @(posedge i_clk_ref , negedge i_rst_n)
 begin
   if (!i_rst_n)
    begin                
      o_div_clk_C <= 1'b0;
      flag        <= 1'b0;
      counter     <= 8'd1;
    end
   else if (CLK_EN) 
    begin
       if ((counter == i_div_ratio >> 1) && !is_odd ) ///even conition
        begin
           o_div_clk_C <= !o_div_clk_C;
           counter <= 8'd1;
        end
       else if ( ((counter == i_div_ratio >> 1) && !flag) || ((counter == (i_div_ratio >> 1)+1) && flag) ) 
        begin
           o_div_clk_C <= !o_div_clk_C;
           flag <= !flag;
           counter <= 8'd1;
        end
       else begin
          o_div_clk_C <= o_div_clk_C;       
          counter <= counter + 1; //// problem
          end
    end
    else begin
      o_div_clk_C <= o_div_clk_C; end
 end */
 
 always @(posedge i_clk_ref , negedge i_rst_n)
  begin
    if (!i_rst_n)
     begin                
       o_div_clk_C <= 1'b0;
       flag        <= 1'b0;
       counter     <= 8'd1;
     end
     else begin 
        if (i_clk_en && (i_div_ratio != 8'd0) && (i_div_ratio != 8'd1))
          begin
            if ((counter == i_div_ratio >> 1) && !is_odd ) ///even conition
              begin
                o_div_clk_C <= !o_div_clk_C;
                counter <= 8'd1;
              end
             else if ( ((counter == i_div_ratio >> 1) && !flag) || ((counter == (i_div_ratio >> 1)+1) && flag) ) 
               begin                                                                  ///odd conition
                 o_div_clk_C <= !o_div_clk_C;
                 flag <= !flag;
                 counter <= 8'd1;
               end
            else begin       
               counter <= counter + 1; 
               end
            end
       end
  end 
endmodule
