`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module TOP_UART_TX(
       input       clk , reset ,
       input [7:0] p_data,
       input       D_Valid,
       input       par_type , PAR_En,
       output      TX_out , busy
    );
    
    wire ser_Dn;
    wire [1:0] mux_sel;
    wire ser_en;
    wire par_bit;
    wire ser_data;
    
    TX_FSM INS0 (
        .clk(clk),
        .reset(reset),
        .D_Valid(D_Valid),
        .PAR_En(PAR_En),
        .ser_Dn(ser_Dn),
        .mux_sel(mux_sel),
        .busy(busy),
        .ser_en(ser_en)
    );
    
    parity_calc INS1 (
          .p_data(p_data),
          .D_valid(D_Valid),
          .busy(busy),
          .par_type(par_type),
          .par_bit(par_bit), 
          .clk(clk),
          .reset(reset)      
    );
    
    serializer INS2 (
         .clk(clk) , 
         .reset(reset),
         .ser_en(ser_en),
         .p_data(p_data), 
         .D_Valid(D_Valid),
         .busy(busy),
         .ser_data(ser_data),
         .ser_Dn(ser_Dn)        
    );
    
    MUX INS3 (
      .mux_sel(mux_sel), 
      .ser_data(ser_data), 
      .par_bit(par_bit),
      .TX_out(TX_out)       
    );
endmodule
