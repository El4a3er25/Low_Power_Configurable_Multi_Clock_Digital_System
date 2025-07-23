`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
module FINAL_SYS_TB_1();

        reg  i_REF_CLK    ,
             i_UART_CLK   ,
             i_RST        ,
             RX_IN        ;
             
        wire TX_OUT       ,
             o_PAR_ERR    ,
             o_framing_ERR;
        
     parameter WIDTH_REG = 8 , stages =2 ,
               fun = 4 , DEPTH_REG = 16 ,
               ADDR = 4 , 
               REF_CLK = 10 , UART_CLK = 271.267 , TX_CLK = 8680.55;
     
     
    FINAL_SYS  #(.WIDTH_REG(WIDTH_REG) ,.stages(stages),.fun(fun) ,.DEPTH_REG(DEPTH_REG),.ADDR(ADDR))
    U_FINAL_SYS (
           .i_REF_CLK (i_REF_CLK)  ,   
           .i_UART_CLK(i_UART_CLK)  ,  
           .i_RST(i_RST)  ,       
           .RX_IN(RX_IN)  ,       
           .TX_OUT (TX_OUT)   ,      
           .o_PAR_ERR(o_PAR_ERR)  ,   
           .o_framing_ERR(o_framing_ERR)
      );     
                             
   reg i_TX_CLK;                                          
             
 always begin #(REF_CLK / 2)   i_REF_CLK = ~i_REF_CLK; end
 always begin #(UART_CLK / 2)  i_UART_CLK =~i_UART_CLK; end
 always begin #(TX_CLK / 2)  i_TX_CLK =~i_TX_CLK;     end
 
 initial begin
   initialize ();
   reset ();
 //////// case 1: WRITE DATA IN REGISTER //////////////
//   SEND_FRAME (8'haa);
//   SEND_FRAME (8'd4);
//   SEND_FRAME (8'h55); 
 WRITE(8'd4 ,8'h55);
 CHECK_WRITE (8'd4 ,8'h55);
 
 ///////// case 2: READ DATA FROM REGISTER //////////// 
//   SEND_FRAME (8'hbb);
//   SEND_FRAME (8'd4); 
 READ(8'd4); 
 CHECK_READ(8'd4);
 
 //////////// case 3: ALU OPERATION WITH Operand ///////
//   SEND_FRAME (8'hcc);
//   SEND_FRAME (8'd20);
//   SEND_FRAME (8'd10);
//   SEND_FRAME (8'd1);
ALU_W_OP (8'd20 , 8'd10 , 8'd2);
CHECK_ALU (8'd2);

  /////////// case 4: ALU OPERATION WITHOUT Operand ///////  
//  SEND_FRAME (8'hdd);
//  SEND_FRAME (8'd2);
ALU_WO_OP (8'd1);
CHECK_ALU (8'd1);
 end
 
 task initialize ();
  begin
      i_TX_CLK   = 1'b0;
      i_REF_CLK  = 1'b0;
      i_UART_CLK = 1'b0;
      RX_IN      = 1'b1; 
  end
  endtask
 
 task reset ();
  begin
    i_RST = 1'b0;
    #(REF_CLK)
    i_RST = 1'b1;
  end
 endtask  
 /////////////////////////////////////////
 task SEND_FRAME (
   input [WIDTH_REG-1:0] data 
 );
 integer i ;
  begin 
     @(posedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK)     ////// start bit 
      RX_IN = 1'b0;
      
     for (i=0 ; i< WIDTH_REG ; i=i+1)
      begin
        @(posedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK) 
          RX_IN = data[i] ;
      end
 //////////// PARITY ///////////     
    if (U_FINAL_SYS.U_REG_File.REG2[0])
     begin
       @(posedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK)      /////// parity bit  
         case(U_FINAL_SYS.U_REG_File.REG2[1])      
            1'b0: RX_IN = ^data; 
            1'b1: RX_IN = ~^data;       
         endcase
      end
        
    @(posedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK)      //////// stop bit
       RX_IN = 1'b1;   
  end
 endtask 
 //////////////// write operation ///////////////
   task WRITE (
       input [ADDR-1:0] addr ,
       input [WIDTH_REG-1:0] data
     );
    begin
       SEND_FRAME (8'haa);
       SEND_FRAME (addr);
       SEND_FRAME (data);
    end
   endtask
  //////////////// read operation ///////////////
  task READ (
       input [ADDR-1:0] addr 
     );
   begin
      SEND_FRAME (8'hbb);
      SEND_FRAME (addr); 
   end
  endtask
  //////////////// ALU operation /////////////// 
  ////// operation with operand
  task ALU_W_OP (
      input [WIDTH_REG-1:0] OP_A,
      input [WIDTH_REG-1:0] OP_B,
      input [fun-1:0] func
    );
   begin
       SEND_FRAME (8'hcc);
       SEND_FRAME (OP_A);
       SEND_FRAME (OP_B);
       SEND_FRAME (func);
   end
   endtask
   ////// operation without operand
   task ALU_WO_OP (
       input [fun-1:0] func
     );
    begin
        SEND_FRAME (8'hdd);
        SEND_FRAME (func);
    end
    endtask
 //////////////////////////////// check result //////////////////////////////////
 //////////////// check write operation result
  task CHECK_WRITE (
         input [ADDR-1:0] addr ,   
         input [WIDTH_REG-1:0] data
      );
   begin
     @(posedge U_FINAL_SYS.U_REG_File.i_wr_en)
      repeat(2) @(posedge i_REF_CLK);
         if (U_FINAL_SYS.U_REG_File.Memory[addr] == data)
          $display ("Write Operation is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",
            U_FINAL_SYS.U_REG_File.REG2[0],U_FINAL_SYS.U_REG_File.REG2[1],U_FINAL_SYS.U_REG_File.REG2[7:2]);
         else
          $display("Write Operation is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",
              U_FINAL_SYS.U_REG_File.REG2[0],U_FINAL_SYS.U_REG_File.REG2[1],U_FINAL_SYS.U_REG_File.REG2[7:2]);
       
   end
  endtask
 //////////////// check read operation result 
  task CHECK_READ (
      input [ADDR-1:0] addr
    );
  integer i ;
  reg [10:0] expected_out;
  reg [10:0] real_out;
  reg parity;
   begin
      @(posedge U_FINAL_SYS.U_TOP_UART.o_BUSY)
        for(i=0 ; i < 11 ; i=i+1)
         begin
           @(negedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK);
             real_out[i] = TX_OUT;
         end
      
      if (U_FINAL_SYS.U_REG_File.REG2[0])  
       begin
         case (U_FINAL_SYS.U_REG_File.REG2[1])
            1'b0: parity = ^U_FINAL_SYS.U_REG_File.Memory[addr] ;
            1'b1: parity = ~^U_FINAL_SYS.U_REG_File.Memory[addr] ;
         endcase
       end 
      else 
        begin parity = 1'b1 ; end
     
       if (U_FINAL_SYS.U_REG_File.REG2[0])  
        begin  
           expected_out ={1'b1 ,parity ,U_FINAL_SYS.U_REG_File.Memory[addr],1'b0 };
        end
//       else begin
//          expected_out ={1'b1 ,1'b1 ,U_FINAL_SYS.U_REG_File.Memory[addr],1'b0 };
//       end
     
       if(real_out == expected_out)
        $display("Read Operation  is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",
                   U_FINAL_SYS.U_REG_File.REG2[0],U_FINAL_SYS.U_REG_File.REG2[1],U_FINAL_SYS.U_REG_File.REG2[7:2]);
       else           
        $display ("Read Operation  is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d ",
                   U_FINAL_SYS.U_REG_File.REG2[0],U_FINAL_SYS.U_REG_File.REG2[1],U_FINAL_SYS.U_REG_File.REG2[7:2]);
   end
  endtask 

  //////////////// check ALU operation result 
 task CHECK_ALU (
         input [fun-1:0] func
     );
   reg [10:0] frame_0 ,frame_1;
   reg [10:0] expected_F_0 , expected_F_1;
   reg [2*WIDTH_REG-1:0] ALU_OUT_RESULT ;
   reg parity_0;
   reg parity_1;
   integer i;
   
  begin
     //generated frame_0
        @(posedge U_FINAL_SYS.U_TOP_UART.o_BUSY)
         for(i=0 ; i < 11 ; i=i+1)
          begin
            @(negedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK);
              frame_0[i] = TX_OUT;
          end
     //generated frame_1      
       @(posedge U_FINAL_SYS.U_TOP_UART.o_BUSY)       
        for(i=0 ; i < 11 ; i=i+1)                     
         begin                                        
           @(negedge U_FINAL_SYS.U_TOP_UART.i_TX_CLK);
             frame_1[i] = TX_OUT;                     
         end 
     	//calculate ALU Output  	
          case (func) 
       4'b0000: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0] + U_FINAL_SYS.U_REG_File.REG1;
                end
       4'b0001: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0] - U_FINAL_SYS.U_REG_File.Memory[1];
                end
       4'b0010: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0] * U_FINAL_SYS.U_REG_File.Memory[1];
                end
       4'b0011: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0] / U_FINAL_SYS.U_REG_File.Memory[1];
                end
       4'b0100: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0] & U_FINAL_SYS.U_REG_File.Memory[1];
                end
       4'b0101: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0] | U_FINAL_SYS.U_REG_File.Memory[1];
                end
       4'b0110: begin
                 ALU_OUT_RESULT = ~ (U_FINAL_SYS.U_REG_File.Memory[0] & U_FINAL_SYS.U_REG_File.Memory[1]);
                end
       4'b0111: begin
                 ALU_OUT_RESULT = ~ (U_FINAL_SYS.U_REG_File.Memory[0] | U_FINAL_SYS.U_REG_File.Memory[1]);
                end     
       4'b1000: begin
                 ALU_OUT_RESULT =  (U_FINAL_SYS.U_REG_File.Memory[0] ^ U_FINAL_SYS.U_REG_File.Memory[1]);
                end
       4'b1001: begin
                 ALU_OUT_RESULT = ~ (U_FINAL_SYS.U_REG_File.Memory[0] ^ U_FINAL_SYS.U_REG_File.Memory[1]);
                end           
       4'b1010: begin
                if (U_FINAL_SYS.U_REG_File.Memory[0] == U_FINAL_SYS.U_REG_File.Memory[1])
                   ALU_OUT_RESULT = 'b1;
                else
                   ALU_OUT_RESULT = 'b0;
                end
       4'b1011: begin
                 if (U_FINAL_SYS.U_REG_File.Memory[0] > U_FINAL_SYS.U_REG_File.Memory[1])
                   ALU_OUT_RESULT = 'b10;
                 else
                   ALU_OUT_RESULT = 'b0;
                end 
       4'b1100: begin
                 if (U_FINAL_SYS.U_REG_File.Memory[0] < U_FINAL_SYS.U_REG_File.Memory[1])
                   ALU_OUT_RESULT = 'b11;
                 else
                   ALU_OUT_RESULT = 'b0;
                end     
       4'b1101: begin
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0]>>1;
                end
       4'b1110: begin 
                 ALU_OUT_RESULT = U_FINAL_SYS.U_REG_File.Memory[0]<<1;
                end
       4'b1111: begin
                 ALU_OUT_RESULT = 'b0;
                end
       endcase  
       
       if (U_FINAL_SYS.U_REG_File.REG2[0])  
        begin
          case (U_FINAL_SYS.U_REG_File.REG2[1])
             1'b0: parity_0 = ^ALU_OUT_RESULT[WIDTH_REG-1:0] ;
             1'b1: parity_0 = ~^ALU_OUT_RESULT[WIDTH_REG-1:0] ;
          endcase
        end 
       else 
         begin parity_0 = 1'b1 ; end
         
    if (U_FINAL_SYS.U_REG_File.REG2[0])  
   begin  
      expected_F_0 ={1'b1 ,parity_0 ,ALU_OUT_RESULT[WIDTH_REG-1:0], 1'b0 };
   end
  else begin
     expected_F_0 ={1'b1 ,1'b1 ,ALU_OUT_RESULT[WIDTH_REG-1:0], 1'b0 };
  end
  ///////////////////// frame 2 //////////////////////////       
                                         
                                                        
        if (U_FINAL_SYS.U_REG_File.REG2[0])             
         begin                                          
           case (U_FINAL_SYS.U_REG_File.REG2[1])        
              1'b0: parity_1 = ^ALU_OUT_RESULT[2*WIDTH_REG-1:WIDTH_REG] ;            
              1'b1: parity_1 = ~^ALU_OUT_RESULT[2*WIDTH_REG-1:WIDTH_REG] ;           
           endcase                                      
         end                                            
        else                                            
          begin parity_1 = 1'b1 ; end 
          
    if (U_FINAL_SYS.U_REG_File.REG2[0])                
     begin                                               
        expected_F_1 ={1'b1 ,parity_1 ,ALU_OUT_RESULT[2*WIDTH_REG-1:WIDTH_REG], 1'b0 };
     end                                                 
    else begin                                           
       expected_F_1 ={1'b1 ,1'b1 ,ALU_OUT_RESULT[2*WIDTH_REG-1:WIDTH_REG], 1'b0 };   
    end                                                       
      if(frame_0 == expected_F_0 &&  frame_1 == expected_F_1)
       $display("ALU Operation   is succeeded with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d  ",
                  U_FINAL_SYS.U_REG_File.REG2[0],U_FINAL_SYS.U_REG_File.REG2[1],U_FINAL_SYS.U_REG_File.REG2[7:2]);
      else           
       $display ("ALU Operation   is failed with configurations PARITY_ENABLE=%d PARITY_TYPE=%d  PRESCALE=%d ",
                  U_FINAL_SYS.U_REG_File.REG2[0],U_FINAL_SYS.U_REG_File.REG2[1],U_FINAL_SYS.U_REG_File.REG2[7:2]);                           
  end
  endtask 
    
endmodule
