`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 11:53:30 AM
// Design Name: 
// Module Name: edge_bit_counter
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


module edge_bit_counter(
   input clk , reset,
   input [5:0] prescale,
   input count_en,
   output reg [3:0] bit_count,
   output reg [5:0] edge_count 
    );
  
/*  reg done;
  localparam pre_8 = 3'b111 , pre_16 = 4'b1111,
              pre_32 = 5'b11111;*/
    
/*  always @(posedge clk , negedge clk)
  begin
     if(!reset) 
      begin
         bit_count  <= 4'd0;
         edge_count <= 6'd0;
      end
     else if (count_en)
     begin
        case(prescale)
         pre_8: begin                 
                  if(edge_count == 6'd8)
                   begin
                    //done <= 1'b1;
                    edge_count <= 6'd0;                     
                    bit_count  <= (bit_count == 11)? 4'd0 : (bit_count+1);
                   end
                  else  begin                   
                    edge_count <= edge_count + 1; end
                end                
         pre_16: begin 
                  if(edge_count == 15)
                   begin
                    bit_count <= bit_count + 1;
                    edge_count <= 5'd0;
                     if (bit_count == 10) 
                      begin bit_count <= 4'd0; end                   
                   end
                  else
                    edge_count <= edge_count + 1;                  
                 end
         
         pre_32: begin
                  if(edge_count == 31)
                    begin
                     bit_count <= bit_count + 1;
                     edge_count <= 5'd0;
                      if (bit_count == 10) 
                       begin bit_count <= 4'd0; end                     
                    end
                   else
                     edge_count <= edge_count + 1;                 
                 end
                 
         default: begin
                    bit_count  <= 4'd0;
                    edge_count <= 6'd0;
                  end
        endcase
     end    
     
     else begin
           bit_count  <= 4'd0;
           edge_count <= 6'd0;
        end
  end*/
  
 always @(posedge clk , negedge reset)
    begin
       if(!reset)
        begin
           bit_count  <= 4'd0;
           edge_count <= 6'd0;
        end
       else if (count_en)
       begin
         if (edge_count == (prescale-1))
          begin
               edge_count <= 6'd0;
               bit_count  <= bit_count+1;             
          end
          else begin 
             edge_count <= edge_count+1;
             bit_count <= bit_count; 
             end
        end
        else begin
           bit_count  <= 4'd0;
           edge_count <= 6'd0;
          end
     end
     
endmodule
