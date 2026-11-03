`timescale 1ns / 1ps

module Elevator_3_Floors(
    input clk,
    input reset,
    input req_1, // Button for Floor 1
    input req_2, // Button for Floor 2
    input req_3, // Button for Floor 3
    output reg [1:0] current_floor,
    output reg door_open
);

    // Define state parameters for readability
    parameter FLOOR_1 = 2'd1;
    parameter FLOOR_2 = 2'd2;
    parameter FLOOR_3 = 2'd3;

    always @(posedge clk) begin
        if (reset) begin
            current_floor <= FLOOR_1;
            door_open <= 1'b1;
        end else begin
            // Default behavior: keep doors closed while making decisions
            door_open <= 1'b0; 

            case (current_floor)
                FLOOR_1: begin
                    if (req_1) begin
                        door_open <= 1'b1; // Open door if already here
                    end else if (req_2 || req_3) begin
                        current_floor <= FLOOR_2; // Move up one floor
                    end
                end
                
                FLOOR_2: begin
                    if (req_2) begin
                        door_open <= 1'b1; // Open door if already here
                    end else if (req_3) begin
                        current_floor <= FLOOR_3; // Keep moving up
                    end else if (req_1) begin
                        current_floor <= FLOOR_1; // Move down
                    end
                end
                
                FLOOR_3: begin
                    if (req_3) begin
                        door_open <= 1'b1; // Open door if already here
                    end else if (req_2 || req_1) begin
                        current_floor <= FLOOR_2; // Move down one floor
                    end
                end
                
                default: current_floor <= FLOOR_1;
            endcase
        end
    end

endmodule