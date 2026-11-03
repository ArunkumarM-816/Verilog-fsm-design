module tb_D_flip_flop;

    reg clk;
    reg d;
    wire q;

    D_flip_flop uut (
        .clk(clk),
        .d(d),
        .q(q)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        d = 0;
        #10;

        d = 1;
        #10;

        d = 0;
        #10;

        d = 1;
        #10;

        $finish;
    end

endmodule