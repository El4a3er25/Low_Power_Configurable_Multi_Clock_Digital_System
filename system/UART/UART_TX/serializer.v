`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module serializer(
     input       clk , reset,
     input       ser_en,
     input [7:0] p_data,
     input       busy,
     input       D_Valid,
     output reg  ser_data,
     output reg  ser_Dn
    );
    
    reg [2:0] counter;
    reg [7:0] register;
    
    always @(posedge clk , negedge reset)
    begin
        if(!reset)
         begin
            ser_data <=1'b0;
            ser_Dn <= 1'b0; 
            register <= 8'd0;
            counter <= 3'b000;
         end
         
       else if (D_Valid && !busy)
         begin
                register <= p_data;
         end
       else if (ser_en)                                 
         begin
               // for(i=0; i>8 ; i=i+1)             
                //  begin  
                     ser_data <= register[counter];     // ser_data <= register[i]; 
                     
                      counter <= counter +1;     
               //      register <= register >> 1;   
                 //  if (i == 7)
                    ser_Dn <= (counter == 7)? 1'b1:1'b0;
         end
            else begin
               ser_data <=1'b0;
                ser_Dn <= 1'b0;
                 counter <= 0;                                  
                  end       
    end    
endmodule
