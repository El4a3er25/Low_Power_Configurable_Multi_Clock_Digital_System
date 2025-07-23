`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2024 03:27:45 PM
// Design Name: 
// Module Name: TX_FSM
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


module TX_FSM(
    input clk , reset,
    input D_Valid,
    input PAR_En,
    input ser_Dn,
    output reg [1:0] mux_sel,
    output reg busy,
    output reg ser_en
    );
    
   localparam IDEL=3'b000 ,start= 3'b001,Data_tr= 3'b010 ,PAR =3'b011 , stop =3'b100;
    
    reg [3:0] current_state, next_state;
    
    always @(posedge clk , negedge reset)
     begin
        if (!reset)
          begin
                //busy <= 1'b0;
                current_state <= IDEL;
          end
       else
         begin
                //busy <= busy;
                current_state <= next_state;
         end
     end 
     
     always @(*)
     begin
	 
        case(current_state)
          IDEL: begin
                   ser_en = 1'b0;
                  mux_sel = 2'b01;
                   busy = 1'b0;          
                  if (D_Valid)
                    begin 
                       next_state = start;                      
                    end
                  else
                      next_state = IDEL;
                end 
                   
           start: begin                      
                      ser_en = 1'b1;
                      mux_sel = 2'b00;
                      busy = 1'b1;
                      next_state = Data_tr;                   
                 end 
                 
          Data_tr: begin
		     ser_en = 1'b1;
                     mux_sel = 2'b10;
                     busy = 1'b1;
                    if (ser_Dn)
                     begin
                       if(PAR_En)
                         next_state = PAR;
                       else
                         next_state = stop;
                     end                    
                   else                 
                    begin  next_state = Data_tr;  end                                    
                   end
                   
          PAR: begin
                 ser_en = 1'b0;
                 mux_sel = 2'b11;
                 busy = 1'b1;
                 next_state = stop;                               
               end
               
         stop: begin
                 ser_en = 1'b0;
                 mux_sel = 2'b01;
                 busy = 1'b1;
                 next_state = IDEL;                 
             end
             
          default: begin
                     ser_en = 1'b0;
                     mux_sel = 2'b01;
                     busy = 1'b0;
                     next_state = IDEL;                     
                   end
        endcase
     end
endmodule
