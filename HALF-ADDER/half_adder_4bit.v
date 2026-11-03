`timescale 1ns / 1ps

module half_adder_4bit (
    input [3:0] A,
    input [3:0] B,
    output [3:0] Sum,
    output Cout
);

    // The concatenation {Cout, Sum} creates a 5-bit vector 
    // to capture the overflow bit from the 4-bit addition
    assign {Cout, Sum} = A + B;

endmodule
