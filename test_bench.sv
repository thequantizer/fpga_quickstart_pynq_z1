`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2021 03:56:03 AM
// Design Name: 
// Module Name: test_bench
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
            
module test_bench(
);
    localparam HALF_CLK_CYCLE = 10;
    
    //input 
    bit sim_clk = '0;
    logic [3:0] btn;
    bit rst = '0;

    //output
    wire [3:0] led;

    top uut_top(
        .sysclk(sim_clk),
        .btn(btn[0]),
        .led(led),
        .reset(rst)
    );
    
    always #HALF_CLK_CYCLE sim_clk = ~sim_clk;

    task reset_ckt();
        rst = 1'b1;
        #(HALF_CLK_CYCLE*4);
        rst = 1'b0;
        btn = '0;
        #(HALF_CLK_CYCLE*4);
    endtask
    
    // Stimulus
    initial begin
        $printtimescale(test_bench);
        reset_ckt();
        
        `assert_equals(0, uut_top.led);
        
        bounce_press();
        `assert_equals(1, uut_top.led);
        
        bounce_press();
        `assert_equals(2, uut_top.led);
        
        bounce_press();
        `assert_equals(3, uut_top.led);
        
        bounce_press();
        `assert_equals(4, uut_top.led);
        
        bounce_press();
        `assert_equals(5, uut_top.led);
        
        bounce_press();
        `assert_equals(6, uut_top.led);
        
        bounce_press();
        `assert_equals(7, uut_top.led);
        
        bounce_press();
        `assert_equals(8, uut_top.led);
        
        bounce_press();
        `assert_equals(9, uut_top.led);
        
        bounce_press();
        `assert_equals(10, uut_top.led);
        
        bounce_press();
        `assert_equals(11, uut_top.led);
        
        bounce_press();
        `assert_equals(12, uut_top.led);
        
        bounce_press();
        `assert_equals(13, uut_top.led);
        
        bounce_press();
        `assert_equals(14, uut_top.led);
        
        bounce_press();
        `assert_equals(15, uut_top.led);
        
        bounce_press();
        `assert_equals(0, uut_top.led);
        
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
    
    
endmodule 
