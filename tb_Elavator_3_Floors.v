`timescale 1ns / 1ps

module tb_Elevator_3_Floors;
    reg clk;
    reg reset;
    reg req_1, req_2, req_3;
    wire [1:0] current_floor;
    wire door_open;

    Elevator_3_Floors uut (
        .clk(clk),
        .reset(reset),
        .req_1(req_1),
        .req_2(req_2),
        .req_3(req_3),
        .current_floor(current_floor),
        .door_open(door_open)
    );

    // 100 MHz Clock
    always #5 clk = ~clk;

    initial begin
        // Initialize at Floor 1
        clk = 0; reset = 1;
        req_1 = 0; req_2 = 0; req_3 = 0;
        
        #10 reset = 0;
        
        // Test Case 1: Call elevator to Floor 3
        // It should transition: Floor 1 -> Floor 2 -> Floor 3
        req_3 = 1;
        #10 req_3 = 0; // Release button
        
        #40; // Wait for it to travel and open doors
        
        // Test Case 2: Call elevator back to Floor 1
        // It should transition: Floor 3 -> Floor 2 -> Floor 1
        req_1 = 1;
        #10 req_1 = 0; // Release button
        
        #40;
        
        $finish;
    end
endmodule