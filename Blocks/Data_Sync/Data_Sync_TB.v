`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2024 11:34:33 AM
// Design Name: 
// Module Name: Data_Sync_TB
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


module Data_Sync_TB();

     parameter WIDTH = 8 , stages = 2 , TPERIOD = 20;
     
       reg               clk ,rst  ;
       reg   [WIDTH-1:0] async_bus ;
       reg               bus_en    ;
       wire              en_pulse  ;
       wire  [WIDTH-1:0] sync_bus  ;
  
  integer i;
       
    Data_Sync  #(.WIDTH(WIDTH) , .stages(stages)) U_Data_Sync (
        .clk(clk) ,
        .rst(rst)  ,
        .async_bus(async_bus) ,
        .bus_en(bus_en)    ,
        .en_pulse(en_pulse)  ,
        .sync_bus(sync_bus)   
    );
              
   always #10 clk = ~clk ;
   
  initial begin
    initialization ();
    reset ();
    
    async_bus = $random & 8'hff;
    bus_en = 1'b1;
    //repeat(3) @(negedge clk);
     #(3*TPERIOD);
    for (i=0 ; i<16 ; i=i+1)
     begin          
           bus_en = 1'b0;
           //repeat(1) @(negedge clk);
            #(TPERIOD);
           async_bus = $random & 8'hff;
           bus_en = 1'b1;
           #(3*TPERIOD);
     end
     $stop;
  end
  
  task initialization ();
   begin
     clk = 1'b0;
     bus_en = 1'b1;
     async_bus = 'b1110_1100;
   end
  endtask
  
  task reset ();
   begin
      rst = 1'b0;
      #5
      rst = 1'b1;
   end
   endtask       
   
//   task op (
//     input [WIDTH-1:0] data, 
//     input enable
//   );    
//   parameter WIDTH = 8 ;
//    begin
//       async_bus = data;
//       bus_en = 1'b0;
//       repeat(3) @(negedge clk);
//       bus_en = enable;
       
//    end  
//  endtask
  
endmodule
