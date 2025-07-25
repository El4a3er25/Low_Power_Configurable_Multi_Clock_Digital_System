`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 04:43:10 PM
// Design Name: 
// Module Name: deserializer
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


module deserializer(
        input clk ,reset,
        input deser_en ,
        input [3:0] bit_count,
        input sample_bit,
        output reg [7:0] P_DATA
    );
    //reg [2:0] counter;
    
//    always @(posedge clk , negedge reset)
//    begin
//       if(!reset)
//        begin
//         P_DATA  <= 8'b1111_1111;
//         //counter <= 3'd0;
//        end
//       else if (deser_en)
//        begin
//        if (bit_count != 4'd0)
//          begin P_DATA[bit_count-1] <= sample_bit; end
//          //counter <= counter + 1;
//        end
       
  /*     else begin
              P_DATA <= P_DATA;
             //counter <= 3'd0; 
           end*/ 
   // end
        always @(posedge clk , negedge reset)
   begin
      if(!reset)
       begin
        P_DATA  <= 8'b1111_1111;
        //counter <= 3'd0;
       end
      else 
       begin
          if (deser_en) begin
           if (bit_count != 4'd0)
              begin P_DATA[bit_count-1] <= sample_bit; end
         //counter <= counter + 1;
          end
       end
    end
endmodule
