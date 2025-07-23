`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module SYS_CTRL #(parameter WIDTH_REG = 8 , fun = 4 , ADDR = 4) (
    input                      i_Ref_clk,
    input                      i_rst,
    input [WIDTH_REG-1:0]      i_Rd_D_REG,
    input                      i_Vid_Rd, i_Vid_ALU, i_Vid_D_Sync ,
    input [(WIDTH_REG*2)-1:0]  i_ALU_out ,
    input                      i_FIFO_Full,
    input  [WIDTH_REG-1:0]     i_sync_P_Data,
    
    output reg                 o_wr_en , o_rd_en ,
    output reg [ADDR-1:0]      o_adder ,
    output reg [WIDTH_REG-1:0] o_Wr_D_REG ,
    output reg [fun-1:0]       o_fun,
    output reg                 o_ALU_EN,
    output reg                 o_WR_INC ,
    output reg [WIDTH_REG-1:0] o_WR_D_FIFO,
    output reg                 o_Gate_EN ,
    output reg                 o_Div_EN                               
    );
    
    reg [ADDR-1:0] KEEP_ADDR ;
    
//    localparam [3:0] IDEL             = 4'd0,
//                     RF_Wr_Addr_fra_1 = 4'd1,
//                     RF_Wr_Data_fra_2 = 4'd2,
//                     RF_Rd_Addr_fra_1 = 4'd3,
//                     REG_FIFO_OUT     = 4'd4,
//                     OPR_A_fra_1      = 4'd5,
//                     ALU_FUN_fra_1    = 4'd6,                    
//                     OPR_B_fra_2      = 4'd7,
//                     ALU_FIFO_OUT_1   = 4'd8,
//                     ALU_FIFO_OUT_2   = 4'd9,
//                     W_inc_LOW        = 4'd10,
//                     ALU_FUN_fra_3    = 4'd11;                
//    reg [3:0] C_State , N_State ;
   
   typedef enum {
           IDEL,            
           RF_Wr_Addr_fra_1 ,
           RF_Wr_Data_fra_2 ,
           RF_Rd_Addr_fra_1 ,
           REG_FIFO_OUT     ,
           OPR_A_fra_1      ,
           ALU_FUN_fra_1    ,
           OPR_B_fra_2      ,
           ALU_FIFO_OUT_1   ,
           W_inc_LOW       ,
           ALU_FIFO_OUT_2   ,
           ALU_FUN_fra_3  } state_;
          
   state_  C_State, N_State;
               
 always @(posedge i_Ref_clk , negedge i_rst)
  begin
    if(!i_rst) 
       begin C_State <= IDEL ;    end   
    else  
     begin   C_State <=  N_State; end      
  end
  
  always @(*)
   begin
     o_Div_EN    = 1'b1;
     o_wr_en     = 1'b0;
     o_rd_en     = 1'b0;
     o_adder     =  'd0;
     o_Wr_D_REG  =  'd0;
     o_fun       = 4'd0;
     o_ALU_EN    = 1'd0;   
     o_WR_INC    = 1'd0;  
     o_WR_D_FIFO =  'd0;
     o_Gate_EN   = 1'b0; 
     /////////////////////////////////////////////
     case(C_State)
        IDEL: begin
               if (i_Vid_D_Sync)
                begin
                  case(i_sync_P_Data)
                    8'haa:   N_State = RF_Wr_Addr_fra_1;
                    8'hbb:   N_State = RF_Rd_Addr_fra_1;
                    8'hcc:   N_State = OPR_A_fra_1;
                    8'hdd:   N_State = ALU_FUN_fra_1;
                    default: N_State = IDEL;
                  endcase
                end
               else begin N_State = IDEL; end
              end
      ////////////////////////////////////////////////////        
        RF_Wr_Addr_fra_1: begin
                  if (i_Vid_D_Sync)
                   begin
                     N_State = RF_Wr_Data_fra_2;
                     o_adder = i_sync_P_Data[ADDR-1:0];  
                   end
                  else begin
                     N_State = RF_Wr_Addr_fra_1;
                     o_adder = 'd0;    
                     end            
                    end
    //////////////////////////////////////////////////////////                
        RF_Wr_Data_fra_2: begin
             o_adder = KEEP_ADDR;
                  if (i_Vid_D_Sync)
                   begin                  
                    N_State = IDEL;
                    o_wr_en = 1'b1;
                    o_Wr_D_REG  = i_sync_P_Data;
                   end
                 else begin
                    N_State = RF_Wr_Data_fra_2;
//                    o_wr_en = 1'b0;
//                    o_Wr_D_REG  = 'd0;
                   end
                 end
     ///////////////////////////////////////////////////////////            
        RF_Rd_Addr_fra_1: begin
                 if (i_Vid_D_Sync)
                  begin           
                   N_State = REG_FIFO_OUT;
                   o_adder = i_sync_P_Data[ADDR-1:0];
                  end
                else begin
                   N_State = RF_Rd_Addr_fra_1;
                   o_adder = 'd0;
                  end
                end
  /////////////////////////////////////////////////////////////              
        REG_FIFO_OUT: begin
                o_adder = KEEP_ADDR;
                o_rd_en = 1'b1; 
                   if (i_Vid_Rd)
                    begin
                      o_WR_D_FIFO = i_Rd_D_REG;
                       if(i_FIFO_Full)                       
                         begin 
                           o_WR_INC = 1'b0; 
                           N_State = REG_FIFO_OUT; 
                           o_WR_D_FIFO = i_Rd_D_REG;
                         end
                         
                       else begin o_WR_INC = 1'b1; N_State = IDEL; end
                    end
                  else begin
                    N_State = REG_FIFO_OUT;
                    end
                 end
  ////////////////////////////////////////////////////////////////////               
       OPR_A_fra_1: begin
                  if (i_Vid_D_Sync)
                   begin        
                      o_wr_en    = 1'b1;
                      o_adder    = 'd0;
                      o_Wr_D_REG = i_sync_P_Data;                      
                      N_State    = OPR_B_fra_2;                      
                   end
                 else begin
                     N_State = OPR_A_fra_1;
                   end
               end
    //////////////////////////////////////////////////////////           
       OPR_B_fra_2: begin               
                  if (i_Vid_D_Sync)                
                  begin 
                     o_Gate_EN  = 1'b1;                          
                     o_wr_en    = 1'b1;           
                     o_adder    = 'd1;            
                     o_Wr_D_REG = i_sync_P_Data;  
                      N_State = ALU_FUN_fra_3;   
                  end                             
                else begin                        
                    N_State = OPR_B_fra_2;        
                  end                             
                end
  //////////////////////////////////////////////////////              
       ALU_FUN_fra_3: begin    
               o_Gate_EN  = 1'b1;          
                 if (i_Vid_D_Sync)
                   begin 
                     o_ALU_EN = 1'b1; 
                     o_fun    = i_sync_P_Data;           
                     N_State  = ALU_FIFO_OUT_1;
                   end
                 else begin                   
//                   o_ALU_EN = 1'b0;          
//                   o_fun    = 'd0; 
                     N_State  = ALU_FUN_fra_3;                    
                   end 
               end
  ///////////////////////////////////////////////////////////             
       ALU_FIFO_OUT_1: begin
             o_fun = i_sync_P_Data;
             o_Gate_EN  = 1'b1;
             o_ALU_EN = 1'b1;
               if (i_Vid_ALU)
                 begin  
                   o_WR_D_FIFO = i_ALU_out[7:0];  
                     if (!i_FIFO_Full)
                      begin
                        o_WR_INC = 1'b1 ; 
                        N_State = W_inc_LOW; ///o_WR_D_FIFO = i_ALU_out;
                      end 
                     else begin
                         o_WR_INC = 1'b0 ;
                         N_State = ALU_FIFO_OUT_1;
                         o_WR_D_FIFO = i_ALU_out[7:0];
                       end 
                    end
                 else begin
                      N_State = ALU_FIFO_OUT_1;
                      o_WR_D_FIFO = 'd0;
                     end                                        
               end
 /////////////////////////////////////////////////////////////////              
       W_inc_LOW: begin 
                  o_fun = i_sync_P_Data;
                  o_Gate_EN  = 1'b1;
                  o_ALU_EN = 1'b1;
                  o_WR_INC = 1'b0 ;
                  o_WR_D_FIFO = i_ALU_out[15:8];
                  N_State = ALU_FIFO_OUT_2;
               end
 ///////////////////////////////////////////////////////////////////////////      
       ALU_FIFO_OUT_2: begin
              o_fun = i_sync_P_Data;
              o_Gate_EN = 1'b1;
              o_ALU_EN  = 1'b1; 
              o_WR_D_FIFO = i_ALU_out[15:8];  
                      if (!i_FIFO_Full)
                       begin
                         o_WR_INC = 1'b1 ; 
                         N_State = IDEL; ///o_WR_D_FIFO = i_ALU_out;
                       end 
                      else begin
                          o_WR_INC    = 1'b0 ;
                          N_State     = ALU_FIFO_OUT_2;
                          o_WR_D_FIFO = i_ALU_out[15:8];
                        end                                                            
                  end
    ///////////////////////////////////////////////////////////////////   
       ALU_FUN_fra_1: begin 
                 o_Gate_EN = 1'b1;                           
                  if (i_Vid_D_Sync)         
                    begin 
                      //o_Gate_EN = 1'b1; 
                      o_ALU_EN = 1'b1;                  
                      o_fun    = i_sync_P_Data;
                      N_State  = ALU_FIFO_OUT_1; 
                    end     
                  else begin
                     N_State = ALU_FUN_fra_1;
                    end                   
               end
 ///////////////////////////////////////////////////////////////////////           
        default: begin 
                  N_State = IDEL;
                  o_Div_EN    = 1'b1;
                  o_wr_en     = 1'b0;
                  o_rd_en     = 1'b0;
                  o_adder     =  'd0;
                  o_Wr_D_REG  =  'd0;
                  o_fun       = 4'd0;
                  o_ALU_EN    = 1'd0;
                  o_WR_INC    = 1'd0;
                  o_WR_D_FIFO =  'd0;
                  o_Gate_EN   = 1'b0;
                 end
      endcase
   end
  
  always @(posedge i_Ref_clk , negedge i_rst)
   begin
     if(!i_rst)
      begin
       KEEP_ADDR <= 'd0;
      end
    else begin
        KEEP_ADDR <= o_adder;
     end
   end 
  
//  reg winc_pulse ; 
//  always @(posedge i_Ref_clk , negedge i_rst)
//     begin
//       if(!i_rst)
//        begin
//         winc_pulse <= 1'd0;
//        end
//      else if (C_State == ALU_FIFO_OUT_1 && N_State == ALU_FIFO_OUT_2) begin
//          winc_pulse <= 1'b0;
//       end
//      else winc_pulse <= 1'b1;
//     end
 
//   always @(posedge i_Ref_clk , negedge i_rst)
//        begin
//          if(!i_rst)
//           begin
//            o_WR_INC <= 1'd0;
//           end
//         else begin
//         if (winc_pulse == 1'b0) begin
//             o_WR_INC <= 1'b0;
//          end
//          end
//        end     
endmodule
