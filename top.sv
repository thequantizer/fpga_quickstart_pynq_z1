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
    input wire reset_btn,
    output logic [3:0] led
);

    //initalize bit to 0
    (* mark_debug = "true" *) bit btn_pressed;
    bit reset;
    initial reset = 1'b0;

    //debounce module will pulse every time a button is pressed
    debounce #(.DEBOUNCE_COUNT_THRESHOLD(300)) debounce_reset(
        //input
        .reset(1'b0),
        .sysclk(sysclk),
        .btn(reset_btn),
        //output
        .btn_pressed(reset));
    debounce #(.DEBOUNCE_COUNT_THRESHOLD(300)) debounce_btn(
        //input
        .reset(reset),
        .sysclk(sysclk),
        .btn(btn),
        //output
        .btn_pressed(btn_pressed));

    logic [3:0] count = '0;

    always @(posedge btn_pressed or posedge reset) begin
        if(reset) begin
            count <= '0;
        end
        else begin
            count <= count + 1;
        end
    end

    always @(posedge sysclk or posedge reset) begin
        if(reset) begin
            led <= '0;
        end
        else begin
            led[0] <= count[0];
            led[1] <= count[1];
            led[2] <= count[2];
            led[3] <= count[3];
        end
    end
endmodule
