`timescale 1ns / 1ps

module door(
    input UP_max,
    input activate,
    input DN_max,
    input clk,
    input rst,
    output reg UP_m,
    output reg DN_m
    );
    
    parameter state_reg_width= 3;
    parameter [state_reg_width-1:0] idle = 3'b001,
                                    Mv_dn= 3'b010,
                                    Mv_up= 3'b100;
   reg [state_reg_width -1 : 0] curr_state , next_state ;
   
   always @(posedge clk or negedge rst) begin 
    if(!rst) curr_state <= idle;
    else curr_state <= next_state;
   end
   
   always @(*) begin
    UP_m=0;
    DN_m=0;
    case(curr_state)
    idle:
        begin
            UP_m=0;
            DN_m=0;
            if((activate==1) && (DN_max==1) && (UP_max==0))  next_state = Mv_up; 
            else if(activate && !DN_max && UP_max)  next_state = Mv_dn;
            else next_state = idle;
        end
    Mv_dn:
        begin
            UP_m=0;
            DN_m=1;
            if(DN_max) next_state = idle;
            else next_state = Mv_dn;           
        end
    Mv_up:
        begin
            UP_m=1;
            DN_m=0;
            if(UP_max) next_state = idle;
            else next_state = Mv_up;        
        end
    default: next_state = idle;
    endcase       
   end
                                    
endmodule
