`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 01:56:24 PM
// Design Name: 
// Module Name: data_sampling
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


module data_sampling(
        input clk , reset,
        input RX_IN,
        input [5:0] prescale,
        input [5:0] edge_count,
        input sample_en ,
        output reg sample_bit
    );
    
    reg [2:0] register ;
  localparam pre_8 = 4'd8 , pre_16 = 5'd16,
                pre_32 = 6'd32;
    
  always @(posedge clk , negedge reset)
  begin
      if(!reset)
       begin
        sample_bit <= 1'b0;
        register   <= 3'd0;
       end
      else if (sample_en)
       begin
          case(prescale)
           pre_8:begin
                  case(edge_count)
                   6'd3: register[0] <= RX_IN;
                   6'd4: register[1] <= RX_IN;
                   6'd5: register[2] <= RX_IN;
                   endcase
                   if ((register[0] == register[1]) || (register[0] == register[2]) ||
                        (register[0] == register[1]== register[2]))
                     sample_bit <= register[0];
                   else if ((register[1] == register[2]))
                     sample_bit <= register[1];
                   else sample_bit <= 1'b0;
                 end
           
           pre_16:begin
                  case(edge_count)
                    6'd7: register[0] <= RX_IN;
                    6'd8: register[1] <= RX_IN;
                    6'd9: register[2] <= RX_IN;
                    endcase
                    if ((register[0] == register[1]) || (register[0] == register[2]) ||
                         (register[0] == register[1]== register[2]))
                      sample_bit <= register[0];
                    else if ((register[1] == register[2]))
                      sample_bit <= register[1];
                    else sample_bit <= 1'b0;
                  end 
                  
          pre_32:begin
              case(edge_count)
                6'd15: register[0] <= RX_IN;
                6'd16: register[1] <= RX_IN;
                6'd17: register[2] <= RX_IN;
                endcase
                if ((register[0] == register[1]) || (register[0] == register[2]) ||
                     (register[0] == register[1]== register[2]))
                  sample_bit <= register[0];
                else if ((register[1] == register[2]))
                  sample_bit <= register[1];
                else sample_bit <= 1'b0;
              end 
         default: begin
                    register   <= 3'd0;
                    sample_bit <= 1'b0;
                  end        
          endcase
       end
     else begin
            register   <= 3'd0;
            sample_bit <= 1'b0;
          end       
  end   
   
endmodule
