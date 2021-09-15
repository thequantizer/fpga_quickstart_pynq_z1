`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2021 01:10:35 AM
// Design Name: 
// Module Name: debounce
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


module debounce
    #(
    //debounce counter paramater that is defaulted to 255 if not set by calling module
    parameter DEBOUNCE_COUNT_THRESHOLD = 255
)
    (
    input wire reset,
    input wire sysclk,
    input wire btn,
    //this will pulse every time the button is pressed after debouncing
    output bit btn_pressed = '0
);

    //ASYNC_REG = "TRUE" tells Vivado that these registers are used for syncronization
    //and should be placed as close together as possible
    //mark_debug = "true" markes the signal for debugging via Integrated Logic Analyzer (ILA)
    //reg 0 and 1 are for meta stability (reg 1 is first reg where meta stability should no longer be a problem)
    //reg 1 and 2 are for edge detection
    (* ASYNC_REG = "TRUE", mark_debug = "true" *) logic [2:0] button_sync;
    //assign all bits to 0 with '0
    //clog2 determinse the number of bits needed to hold the paramaterized debounce counter and subtract 1 for the 0 offset of the a
    (* mark_debug = "true" *) bit [$clog2(DEBOUNCE_COUNT_THRESHOLD)-1:0] debounce_counter = '0;
    (* mark_debug = "true" *) bit debounce_counter_en = '0;

    //this will generate a pulse when the button is pressed. One pulse per button press
    //it is syncronizing the async button signal to the clock then detecting the edge
    always @(posedge sysclk or posedge reset) begin
        if(reset) begin
            btn_pressed <= '0;
            button_sync <= '0;
            debounce_counter <= '0;
            debounce_counter_en <= '0;
        end
        else begin
            //turn off button down pulse if previous iteration detected a button press
            btn_pressed <= '0;
            // adds values into the three stage synchronizer
            // button_sync is shfited left 1 time then OR'ed with btn
            // to place btn value on the end of the register
            button_sync <= (button_sync << 1) | btn;
            //enable the debounce counter on a rising edge of a button press
            if ( button_sync[2:1] == 2'b01) begin
                debounce_counter_en <= '1;
            end
            //if button_sync reg 1 == 0 than the button is not pressed
            //disable the counter
            else if (button_sync[1] == 1'b0) begin
                debounce_counter_en <= '0;
            end

            //this runs onece per clock so it will wait until the button has been
            //pressed long enough to turn the btn_pressed signal to true
            if (debounce_counter_en) begin
                debounce_counter <= debounce_counter + 1'b1;
                if (debounce_counter == DEBOUNCE_COUNT_THRESHOLD) begin
                    //reset counter enable var
                    debounce_counter_en <= '0;
                    //reset debounce_counter
                    debounce_counter <= '0;
                    //create btn_pressed pulse 
                    btn_pressed <= '1;
                end
            end
        end
    end
endmodule
