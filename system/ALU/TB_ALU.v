`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2024 03:01:54 AM
// Design Name: 
// Module Name: TB_ALU
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


module TB_ALU();

      reg [15:0] a_tb,b_tb;
      reg  [3:0] alu_fun_tb;
      reg clk_tb;
      wire [16:0] alu_out_tb;
      wire Arith_flag_tb , Logic_flag_tb , CMP_flag_tb ,Shift_flag_tb;
      
      ALU DUT (
                .a(a_tb),
                .b(b_tb),
                .alu_fun(alu_fun_tb),
                .clk(clk_tb),
                .alu_out(alu_out_tb),
                .Arith_flag(Arith_flag_tb),
                .Logic_flag(Logic_flag_tb),
                .CMP_flag(CMP_flag_tb), 
                .Shift_flag(Shift_flag_tb)
                 );
       always #5 clk_tb =~clk_tb;
       
       initial 
       begin
           clk_tb =0; a_tb=15 ; b_tb=10; alu_fun_tb =0;
           #10 $display ("test case 1");
           if(alu_out_tb == 25)
           $display ("test case 1 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 1 is failed with out =%0d at simulation time =",alu_out_tb,$time);
          
          alu_fun_tb = 1;
          #10 $display ("test case 2");
          if(alu_out_tb == 5)
           $display ("test case 2 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 2 is failed with out =%0d at simulation time =",alu_out_tb,$time);
                    
          alu_fun_tb = 2;
           #10 $display ("test case 3");
           if(alu_out_tb == 150)
           $display ("test case 3 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 3 is failed with out =%0d at simulation time =",alu_out_tb,$time);
           
           alu_fun_tb = 3;
            #10 $display ("test case 4");
            if(alu_out_tb == 1)
            $display ("test case 4 is passed with out =%0d at simulation time =",alu_out_tb,$time);
            else
            $display ("test case 4 is failed with out =%0d at simulation time =",alu_out_tb,$time);
            
            alu_fun_tb = 4;
             #10 $display ("test case 5");
            if(alu_out_tb == 10)
             $display ("test case 5 is passed with out =%0d at simulation time =",alu_out_tb,$time);
             else
             $display ("test case 5 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 5;
           #10 $display ("test case 6");
           if(alu_out_tb == 15)
           $display ("test case 6 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 6 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 6;
           #10 $display ("test case 7");
           if(alu_out_tb == 131061)
           $display ("test case 7 is passed with out =%0d at simulation time =%0t",alu_out_tb,$time);
           else
           $display ("test case 7 is failed with out =%0d at simulation time =%0t",alu_out_tb,$time);

alu_fun_tb = 7;
           #10 $display ("test case 8");
           if(alu_out_tb == 131056)
           $display ("test case 8 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 8 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 8;
           #10 $display ("test case 9");
           if(alu_out_tb == 5)
           $display ("test case 9 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 9 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 9;
           #10 $display ("test case 10");
           if(alu_out_tb == 131066)
           $display ("test case 10 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 10 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 10;
           #10 $display ("test case 11");
           if(alu_out_tb == 0)
           $display ("test case 11 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 11 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 11;
           #10 $display ("test case 12");
           if(alu_out_tb == 2)
           $display ("test case 12 is passed with out =%0d at simulation time =",alu_out_tb,$time);
           else
           $display ("test case 12 is failed with out =%0d at simulation time =",alu_out_tb,$time);
 
 alu_fun_tb = 12;
           #10 $display ("test case 13");
            if(alu_out_tb == 0)
            $display ("test case 13 is passed with out =%0d at simulation time =",alu_out_tb,$time);
            else
            $display ("test case 13 is failed with out =%0d at simulation time =",alu_out_tb,$time);
alu_fun_tb = 13;
           #10 $display ("test case 14");
           if(alu_out_tb == 7)
          $display ("test case 14 is passed with out =%0d at simulation time =",alu_out_tb,$time);
          else
          $display ("test case 14 is failed with out =%0d at simulation time =",alu_out_tb,$time);
alu_fun_tb = 14;
          #10 $display ("test case 15");
           if(alu_out_tb == 30)
           $display ("test case 15 is passed with out =%0d at simulation time =",alu_out_tb,$time);
          else
          $display ("test case 15 is failed with out =%0d at simulation time =",alu_out_tb,$time);

alu_fun_tb = 15;
          #10 $display ("test case 16");
           if(alu_out_tb == 0)
           $display ("test case 16 is passed with out =%0d at simulation time =",alu_out_tb,$time);
          else
          $display ("test case 16 is failed with out =%0d at simulation time =",alu_out_tb,$time);
#10 $stop;                                                                                                                                                                                                                                                                                                                                                                                                                                                  
       end          
endmodule
