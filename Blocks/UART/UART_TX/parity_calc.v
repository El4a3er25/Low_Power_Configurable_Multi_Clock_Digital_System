`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2024 02:28:36 AM
// Design Name: 
// Module Name: parity_calc
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


module parity_calc(
        input       clk , reset,
        input [7:0] p_data,
        input       D_valid,
        input       busy,
        input       par_type,
        output reg  par_bit  
    );
    reg [7:0] Register;
   // wire check ;    
   // assign check =  ^ p_data;
    localparam even = 1'b0 , odd = 1'b1;
 
  always @(posedge clk , negedge reset)
    begin
        if (!reset)
        begin
          Register <= 8'd0;
       end
        else if (D_valid && !busy)
         Register <= p_data;
    end
    
    always @(posedge clk , negedge reset)
           begin
           if (!reset)
                   par_bit <= 1'b0;
           else begin
              case (par_type) 
                 even: begin
                         par_bit <= ^Register;            
                       end
                       
                odd: begin
                      par_bit <= ~^Register;
                     end
                     
             //  default:   par_bit <=1'b0;      
               endcase 
               end
           end    
   /* always @(*)
    begin
       if (!D_valid)
           par_bit = 0;
       else if (par_type) //odd_parity
         begin
            if (check) //odd_one's
              par_bit = 1'b0;
            else
              par_bit = 1'b1;
         end
       else //even_parity
            if (check) //odd_one's
               par_bit = 1'b1;
            else
               par_bit = 1'b0;         
         
    end*/
    
  /*  always @(posedge clk , negedge reset)
    begin
      //check <= ^ p_data;
      if (!reset)
        par_bit <= 1'b0;
      else if (!D_valid)
           par_bit <= 1'b0;
       else
       case (par_type) 
          even: begin 
            if (check) //odd_one's
              par_bit <= 1'b1;
            else
              par_bit <= 1'b0;
              end
              
         odd: begin
            if (check) //odd_one's
               par_bit <= 1'b0;
            else
               par_bit <= 1'b1;
              end 
         default:   par_bit <=1'b0;      
        endcase 
    end  */
  
endmodule
