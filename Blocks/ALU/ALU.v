`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

module ALU #(parameter WIDTH = 8 , fun = 4) (
          input                  i_Ref_clk, i_rst ,
          input                  i_ALU_EN         ,
          input      [WIDTH-1:0] OP_A , OP_B      ,
          input      [fun-1:0]   alu_fun          ,
          output reg [15:0]      alu_out          ,
          output reg             o_Vid_ALU 
    );
    
    always @(posedge i_Ref_clk , negedge i_rst)
    begin
      if (!i_rst)
       begin
          alu_out <= 16'd0;
          o_Vid_ALU <= 1'b0;
       end
       else if (i_ALU_EN) begin
        o_Vid_ALU <= 1'b1; 
          case(alu_fun)
          4'b0000: begin
                    alu_out <= OP_A + OP_B;
                    end
          4'b0001: begin
                      alu_out <= OP_A - OP_B;
                    end
           4'b0010: begin
                       alu_out <= OP_A * OP_B;  
                     end
            4'b0011: begin
                       alu_out <= OP_A/OP_B;
                     end 
            4'b0100: begin
                       alu_out <= OP_A&OP_B;
                      end 
            4'b0101: begin
                       alu_out <= OP_A|OP_B;
                      end 
            4'b0110: begin
                      alu_out <= ~(OP_A&OP_B);
                     end
            4'b0111: begin
                       alu_out <= ~(OP_A|OP_B);
                      end  
            4'b1000: begin
                        alu_out <= OP_A^OP_B;
                      end 
            4'b1001: begin
                        alu_out <= OP_A~^OP_B;
                      end
            4'b1010: begin
                        alu_out <= (OP_A==OP_B)? 1:0;
                      end
           4'b1011: begin
                        alu_out <= (OP_A>OP_B)? 16'd2:0;
                      end
            4'b1100: begin
                        alu_out <= (OP_A<OP_B)? 16'd3:0;
                      end
            4'b1101: begin
                        alu_out <= OP_A>>1;
                      end
            4'b1110: begin
                        alu_out <= OP_A<<1;
                      end
            default: begin
                        alu_out <= 16'd0;
                      end        
          endcase
       end
     else begin
           o_Vid_ALU <= 1'b0;
        end
    end
    
endmodule
