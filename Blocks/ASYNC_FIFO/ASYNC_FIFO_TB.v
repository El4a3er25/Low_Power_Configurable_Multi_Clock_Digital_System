`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 06:40:29 PM
// Design Name: 
// Module Name: ASYNC_FIFO_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ASYNC_FIFO_TB ();

   parameter  WIDTH = 8 , 
              ADDR  = 4 ,
              DEPTH = 16 ;

   reg              i_wclk , i_wrst_n , i_winc;
   reg              i_rclk , i_rrst_n , i_rinc;
   reg  [WIDTH-1:0] i_WR_Data;                 
   wire             o_wfull ;                 
   wire             o_rempty;                 
   wire [WIDTH-1:0] o_RD_Data;
     
     TOP_ASYNC_FIFO #(.DEPTH(DEPTH), .WIDTH(WIDTH), .ADDR(ADDR)) 
      TOP_ASYNC_FIFO_U (
        .i_wclk(i_wclk) , 
        .i_wrst_n(i_wrst_n) , 
        .i_winc(i_winc),  
        .i_rclk(i_rclk), 
        .i_rrst_n(i_rrst_n) , 
        .i_rinc(i_rinc),  
        .i_WR_Data(i_WR_Data),                   
        .o_wfull(o_wfull),                    
        .o_rempty(o_rempty),                    
        .o_RD_Data(o_RD_Data)                   
     );         
     
////////////////////////// clock generation ////////////////////////////
   always #5     i_wclk = ~i_wclk;
   always #12.5  i_rclk = ~i_rclk;
   
   //////////////////////// initial statment //////////////////////////
   integer i ;
   initial 
    begin
      initialize ();
      reset ();
      for (i = 0; i <16 ; i = i+1)
       begin
         @(posedge i_wclk)
         i_WR_Data = $random & 8'hff ;       
         i_winc = 1'b1;
         @(posedge i_wclk)
         i_winc = 1'b0;
       end
      #20;
       @(posedge i_rclk)
       i_rinc = 1'b1;    
       repeat(17) @(posedge i_rclk);
       i_rinc = 1'b0;
       @(posedge i_rclk) 
//      i_WR_Data = 8'b1000_0011;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1000_0110;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1000_0000;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1000_0100;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk) 
//      i_winc = 1'b0;
//      //////////////////////////////
//      //////////////////////////////
//      //////////////////////////////
    
//      i_WR_Data = 8'b0000_0011;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b0000_0110;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b0000_1001;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1000_0101;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      ////////////////////////
//      ////////////////////////
//      ////////////////////////
//       i_WR_Data = 8'b1001_0011;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1001_0110;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1001_0000;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1001_0100;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      //////////////////////////////
//      //////////////////////////////
//      //////////////////////////////
//      i_WR_Data = 8'b0001_0011;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b0001_0110;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b0001_1001;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;
//      i_WR_Data = 8'b1001_0101;
//      @(negedge i_wclk)
//      i_winc = 1'b1;
//      @(negedge i_wclk)
//      i_winc = 1'b0;

      $stop;
    end
////////////////////////////// initialization ///////////////////////
    task initialize ();
     begin
       i_wclk    = 1'b0;
       i_rclk    = 1'b0;
       i_winc    = 1'b0;
       i_rinc    = 1'b0;
       i_WR_Data = 8'b1000_0011;
     end
    endtask     
   
///////////////////////////// reseting /////////////////////////////
   task reset ();
    begin
      i_wrst_n = 1'b0;
      i_rrst_n = 1'b0;
      #3
      i_wrst_n = 1'b1;
      i_rrst_n = 1'b1;
    end
   endtask   
   
   ///////////////////////// operation /////////////////////////
   
  /////////////// Write Operation ////////////
   task WR_OP (
     input [WIDTH-1:0] Data 
   );
   parameter WIDTH = 8;  
    begin
          i_WR_Data = Data ;
          @(negedge i_wclk)
          i_winc    = 1'b1;  
          @(negedge i_wclk)
          i_winc    = 1'b0;  
    end
   endtask   
  /////////////// Read Operation ////////////
   task RD_OP (
     input incre
   );  
    begin
     if(o_rempty == 1'b0)
       @(negedge i_rclk);
         i_rinc = incre;    
    end
   endtask   
   //////////////////////// Check //////////////////////
   task check (
     input [WIDTH-1:0] expect_out ,
     input [2:0] NO_case
     //input [ADDR-1:0] addr
   );
   parameter WIDTH = 8  ;
    begin
      if (o_RD_Data == expect_out)
       begin
         $display ("case %d is passed with o_RD_Data = %b" ,NO_case, o_RD_Data);
       end
      else
        $display ("case %d is failed with o_RD_Data = %b" ,NO_case, o_RD_Data);
    end
    endtask
    
endmodule
