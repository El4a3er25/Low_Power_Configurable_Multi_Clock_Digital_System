`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module FSM(
        input            clk , reset,
        input            RX_IN,
        input      [5:0] edge_count ,
        input      [3:0] bit_count,
        input      [5:0] prescale,
        input            PAR_EN , par_err,
        input            stp_err, str_glitch,
        output reg       sample_en , count_en,
        output reg       par_chk_en , strt_chk_en , stp_chk_en,
        output reg       deser_en , data_valid
    ); 
    
localparam IDEL = 3'b000 , START = 3'b001 , DATA = 3'b010 
         , PARITY = 3'b011 , STOP = 3'b100; 
 
reg          sample_en_C , count_en_C;                 
reg         par_chk_en_C , strt_chk_en_C , stp_chk_en_C;
reg         deser_en_C , data_valid_C;                         
reg [2:0] C_state , N_state ;
wire final_edge;
always @(posedge clk , negedge reset)
begin
   if (!reset)
    begin
       C_state  <= IDEL;
    end
  else
    begin
       C_state  <= N_state;
    end
end

   always @(posedge clk , negedge reset)
     begin
       if (!reset)
        begin
          sample_en  = 1'b0;
         count_en    = 1'b0;                 
         par_chk_en  = 1'b0; 
         strt_chk_en = 1'b0; 
         stp_chk_en  = 1'b0;
         deser_en    = 1'b0; 
         data_valid  = 1'b0;               
        end 
       else
        begin
            sample_en  = sample_en_C  ;
            count_en    =count_en_C   ;
            par_chk_en  =par_chk_en_C ;
            strt_chk_en =strt_chk_en_C;
            stp_chk_en  =stp_chk_en_C ;
            deser_en    =deser_en_C   ;
            data_valid  =data_valid_C ;
        end 
     end 
     
assign final_edge = (edge_count == prescale-'b1)? 1'b1 :1'b0; 

always @(*)
begin
      sample_en_C   = 1'b0;
      count_en_C    = 1'b0;
      par_chk_en_C  = 1'b0;
      strt_chk_en_C = 1'b0;
      stp_chk_en_C  = 1'b0;
      deser_en_C    = 1'b0;
      data_valid_C  = 1'b0;
    case(C_state)
      IDEL : begin
              if (RX_IN)
                begin
                  N_state = IDEL;
                end 
              else begin 
                 N_state = START; 
                 sample_en_C   = 1'b1;
                 count_en_C    = 1'b1;
              end
             end
             
      START: begin
               strt_chk_en_C = 1'b1;
               sample_en_C   = 1'b1;
               count_en_C    = 1'b1;
              if (bit_count == 4'd0 && final_edge && str_glitch == 1'b0)
               begin
                N_state = DATA;
                strt_chk_en_C = 1'b0;
               end
             else if (bit_count == 4'd0 && final_edge && str_glitch == 1'b1)
               begin
                N_state = IDEL;                                     
                  end
             else
                N_state = START;
             end
             
      DATA: begin
             deser_en_C    = 1'b1;
             count_en_C    = 1'b1;
             sample_en_C   = 1'b1; 
             if(bit_count == 4'd8 &&final_edge && PAR_EN)            
               begin
                N_state = PARITY; 
               end
              else if (bit_count == 4'd8 &&final_edge && !PAR_EN) 
              begin  N_state = STOP;  end  
              
              else begin  N_state = DATA; end         
            end 
            
      PARITY: begin
               par_chk_en_C  = 1'b1;
               count_en_C    = 1'b1;
               sample_en_C   = 1'b1;
                if(bit_count == 4'd9 && final_edge && !par_err)
                 begin                 
                      N_state = STOP;
                     end
                   else if(bit_count == 4'd9 && final_edge && par_err) begin
                        N_state = IDEL;
                        par_chk_en_C  = 1'b0;
                        count_en_C    = 1'b0;
                        sample_en_C   = 1'b0;
                        end  
               else begin
                  N_state = PARITY;
                 end                
              end
      
      STOP:begin
            stp_chk_en_C  = 1'b1;
            count_en_C    = 1'b1;
            sample_en_C   = 1'b1;
             if(PAR_EN)
              begin
                if(bit_count == 4'd10 && final_edge &&!stp_err)
                 begin
	            data_valid_C  = 1'b1;
                    count_en_C    = 1'b0;
                    sample_en_C   = 1'b0;
                    stp_chk_en_C  = 1'b0;
                    N_state = IDEL;
//                  if(RX_IN)
//                   begin N_state = IDEL; end
//                  else begin N_state = IDEL; end
                    
                   end  
                 else if(bit_count == 4'd10 && final_edge && stp_err)
                    begin
                       N_state = IDEL;
                       count_en_C    = 1'b0;
                       sample_en_C   = 1'b0;
                       stp_chk_en_C  = 1'b0; 
                    end
               else begin
                 N_state = STOP;
                  end 
              end
              else begin
                 if(bit_count == 4'd9 && final_edge && !stp_err)
               begin
                    data_valid_C  = 1'b1;
                    count_en_C    = 1'b0;
                    sample_en_C   = 1'b0;
                    stp_chk_en_C  = 1'b0;
                    N_state = IDEL;
//                  if(RX_IN)
//                   begin N_state = IDEL; end
//                  else begin N_state = IDEL; end
                 end  
				 
               else if(bit_count == 4'd9 && final_edge && stp_err)
                  begin
                     N_state = IDEL;
                     count_en_C    = 1'b0;
                     sample_en_C   = 1'b0;
                     stp_chk_en_C  = 1'b0;  
                  end
             else begin
               N_state = STOP;
                end                   
                 end                               
         end    
         
      default: begin
                N_state = IDEL;
                sample_en_C   = 1'b0;
                count_en_C    = 1'b0;
                par_chk_en_C  = 1'b0;
                strt_chk_en_C = 1'b0;
                stp_chk_en_C  = 1'b0;
                deser_en_C    = 1'b0;
                data_valid_C  = 1'b0;
               end           
    endcase
end

endmodule
