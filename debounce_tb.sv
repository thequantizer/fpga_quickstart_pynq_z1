`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/13/2021 02:19:10 AM
// Design Name: 
// Module Name: debounce_tb
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

`define assert_equals(expected, actual) \
        if(expected == actual) $info("passed:%s:%0d",`__FILE__, `__LINE__); \
        else begin $error("%s:%0d\nFAILED: expected(%0d) actual(%0d)", `__FILE__, `__LINE__, expected, actual); $stop; end       
            
module debounce_tb(
);
    localparam HALF_CLK_CYCLE = 10;
    
    //input 
    bit sim_clk = 1'b0;
    bit btn = 1'b0;
    bit rst = 1'b0;
    int unsigned btn_press_count = '0;
    int unsigned btn_press_count_long = '0;
    
    //output
    wire btn_pressed;
    wire btn_pressed_long;

    debounce uut_debounce(
        //inputs
        .reset(rst),
        .sysclk(sim_clk),
        .btn(btn),
        //outputs
        .btn_pressed(btn_pressed)
    );
    
    debounce #(.DEBOUNCE_COUNT_THRESHOLD(1000)) uut_debounce_long(
        //inputs
        .reset(rst),
        .sysclk(sim_clk),
        .btn(btn),
        //outputs
        .btn_pressed(btn_pressed_long)
    );
    
    always #HALF_CLK_CYCLE sim_clk = ~sim_clk;

    task reset_ckt();
        rst = 1'b1;
        #(HALF_CLK_CYCLE*4);
        rst = 1'b0;
        btn = 1'b0;
        btn_press_count = '0;
        btn_press_count_long = '0;
        #(HALF_CLK_CYCLE*4);
    endtask
    
    always @(posedge btn_pressed) begin
        btn_press_count = btn_press_count + 1;
    end

    always @(posedge btn_pressed_long) begin
        btn_press_count_long = btn_press_count_long + 1;
    end

    initial begin
        $printtimescale(debounce_tb);
        //**********Test default debounce timer**********//
        reset_ckt();
        `assert_equals(0, btn_press_count);
        
        bounce_press();
        `assert_equals(1, btn_press_count);
        
        bounce_press_long();
        `assert_equals(2, btn_press_count);
        
        bounce_press_long();
        `assert_equals(3, btn_press_count);
        
        //**********Test longer debounc timer**********//
        reset_ckt();
        `assert_equals(0, btn_press_count_long);
        
        bounce_press();
        `assert_equals(0, btn_press_count_long);
        
        bounce_press_long();
        `assert_equals(1, btn_press_count_long);
        
        bounce_press_long();
        `assert_equals(2, btn_press_count_long);
        
        bounce_press_long();
        `assert_equals(3, btn_press_count_long);
        $stop;
    end
    
    task bounce_press();
        btn = 0;
        #3;
        btn =1;
        #7;
        btn = 0;
        #7;
        btn = 1;
        #15;
        btn = 0;
        #7;
        btn = 1;
        #27;
        btn = 0;
        #7;
        btn = 1;
        #15;
        btn = 0;
        #7;
        btn = 1;
        #6000;
        btn= 0;
        #3000;
    endtask
    
    task bounce_press_long();
        btn = 0;
        #3;
        btn =1;
        #7;
        btn = 0;
        #7;
        btn = 1;
        #15;
        btn = 0;
        #7;
        btn = 1;
        #27;
        btn = 0;
        #7;
        btn = 1;
        #15;
        btn = 0;
        #7;
        btn = 1;
        #20000;
        btn= 0;
        #3000;
    endtask
    
   
endmodule 
