`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module INT_CLK_DIV_TB();

    reg  i_clk_ref;
    reg  i_rst_n;
    reg  i_clk_en;
    reg  [7:0] i_div_ratio;
    wire o_div_clk;
      
 parameter CLK_PER = 271.267;
      
   CLK_DIV DUT (
        .i_clk_ref(i_clk_ref),
        .i_rst_n(i_rst_n),
        .i_clk_en(i_clk_en),
        .i_div_ratio(i_div_ratio),
        .o_div_clk(o_div_clk)
   );  
   
   always #(CLK_PER/2)  i_clk_ref = ~i_clk_ref;
   
  initial 
   begin
      initilaliz;
      reset;
      operation(1'b1 ,8'd32);            /////////even ratio//////////
      repeat(68) @(negedge i_clk_ref);  
      operation(1'b1 ,8'd5);            /////////odd ratio //////////
      repeat(15) @(negedge i_clk_ref);
      operation(1'b1 ,8'd4);           /////////even Diviion //////////
      repeat(8) @(negedge i_clk_ref);
      operation(1'b0 ,8'd4);           ///////// NO Division ///////////
   end     
   
  task initilaliz ();
   begin
     i_clk_ref   = 1'b0;
     i_clk_en    = 1'b1;
     i_div_ratio = 8'd32;    
   end
   endtask      
   
  task reset();
  begin
    i_rst_n = 1'b0;   
    #18
    i_rst_n = 1'b1;
  end
  endtask
  
 task operation(
    input enable,
    input [7:0] ratio
 );
  begin
     @(negedge i_clk_ref)
     i_clk_en    = enable;
     i_div_ratio = ratio;
  end 
  endtask
  
endmodule
