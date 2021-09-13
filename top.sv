`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2021 12:40:56 AM
// Design Name: 
// Module Name: top
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


module top(
    input wire sysclk, 
    input wire btn,
    input wire reset,
    output logic [3:0] led
    );
    
    //initalize bit to 0
    (* mark_debug = "true" *) bit btn_pressed;
    
    //debounce module will pulse every time a button is pressed
    debounce #(.DEBOUNCE_COUNT_THRESHOLD(300)) debounce_mod(.*);
    
    logic [3:0] count = '0;
        
    always @(posedge btn_pressed or posedge reset) begin
        if(reset) begin
            count = '0;
        end 
        else begin
        count = count + 1;
        end
    end
    
    always @(posedge sysclk or posedge reset) begin
        if(reset) begin
            led = '0;
        end 
        else begin
            led[0] <= count[0];
            led[1] <= count[1];
            led[2] <= count[2];
            led[3] <= count[3];
        end
    end
endmodule
