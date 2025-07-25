`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module Data_Sync #(parameter WIDTH = 8 , stages = 2) (
        input                  clk ,rst  ,
        input      [WIDTH-1:0] async_bus ,
        input                  bus_en    ,
        output reg             en_pulse  ,
        output reg [WIDTH-1:0] sync_bus
    );
    reg [stages-1:0] sync_reg ;
    reg q_FF1;
    reg MUI_FF ; 
    ///////////////// Multi Flip Flop //////////////////
 always @(posedge clk , negedge rst)
 begin
    if (!rst)
     begin
          sync_reg <= 'd0; 
//        MUI_FF   <= 1'd0;
//        q_FF1     <= 1'b0;
     end
   else
     begin
       //{MUI_FF ,q_FF1} <= {q_FF1 ,bus_en} ; 
       sync_reg <= {sync_reg[stages-2:0] , bus_en};
     end
 end
 
 ///////////////////////// pluse Generator //////////////////////
 reg enable_FF ;
 wire AND ;
 always @ (posedge clk , negedge rst)
 begin
    if (!rst) begin enable_FF <= 1'b0;   end
     else     begin enable_FF <= sync_reg[stages-1]; end     
 end
 
 assign AND = ~enable_FF & sync_reg[stages-1];              
 
  always @ (posedge clk , negedge rst)
 begin
    if (!rst) begin  en_pulse <= 1'b0;  end  
    else      begin  en_pulse <= AND;  end  
 end
 
 ////////////////////// synchronous bus output //////////////////
 always @(posedge clk , negedge rst)
 begin
    if (!rst) 
      sync_bus <= 'd0 ;
    else if (AND)
     sync_bus <= async_bus;
 end
 
endmodule
