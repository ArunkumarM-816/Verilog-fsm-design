
`timescale 1ns/1ps

module tb_atm_controller;

    reg clk;
    reg reset;

    reg card_inserted;
    reg pin_entered;
    reg pin_valid;

    reg balance_req;
    reg balance_done;

    reg withdraw_req;
    reg amount_entered;
    reg funds_available;

    reg dispense_done;
    reg return_menu;
    reg end_transaction;

    wire enter_pin;
    wire show_menu;
    wire show_balance;
    wire dispense_cash;
    wire insufficient_funds;
    wire invalid_pin;
    wire transaction_done;
    wire eject_card;

    // Device under test
    atm_controller uut (
        .clk(clk),
        .reset(reset),

        .card_inserted(card_inserted),
        .pin_entered(pin_entered),
        .pin_valid(pin_valid),

        .balance_req(balance_req),
        .balance_done(balance_done),

        .withdraw_req(withdraw_req),
        .amount_entered(amount_entered),
        .funds_available(funds_available),

        .dispense_done(dispense_done),
        .return_menu(return_menu),
        .end_transaction(end_transaction),

        .enter_pin(enter_pin),
        .show_menu(show_menu),
        .show_balance(show_balance),
        .dispense_cash(dispense_cash),
        .insufficient_funds(insufficient_funds),
        .invalid_pin(invalid_pin),
        .transaction_done(transaction_done),
        .eject_card(eject_card)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin

        // Initialize inputs
        clk = 0;
        reset = 1;

        card_inserted = 0;
        pin_entered = 0;
        pin_valid = 0;

        balance_req = 0;
        balance_done = 0;

        withdraw_req = 0;
        amount_entered = 0;
        funds_available = 0;

        dispense_done = 0;
        return_menu = 0;
        end_transaction = 0;

        // Reset
        #12;
        reset = 0;

        // Insert ATM card
        @(negedge clk);
        card_inserted = 1;
        @(negedge clk);
        card_inserted = 0;

        // Enter correct PIN
        pin_valid = 1;
        pin_entered = 1;
        @(negedge clk);
        pin_entered = 0;

        // Balance enquiry
        @(negedge clk);
        balance_req = 1;
        @(negedge clk);
        balance_req = 0;

        @(negedge clk);
        balance_done = 1;
        @(negedge clk);
        balance_done = 0;

        // Return to menu
        @(negedge clk);
        end_transaction = 0;

        // Note: Balance completion goes to DONE.
        // End this transaction and re-enter the card.
        end_transaction = 1;
        @(negedge clk);
        end_transaction = 0;

        // Insert card again for withdrawal
        card_inserted = 1;
        @(negedge clk);
        card_inserted = 0;

        // Enter correct PIN
        pin_entered = 1;
        @(negedge clk);
        pin_entered = 0;

        // Select withdrawal
        withdraw_req = 1;
        @(negedge clk);
        withdraw_req = 0;

        // Enter amount and check funds
        funds_available = 1;
        amount_entered = 1;
        @(negedge clk);
        amount_entered = 0;

        // Dispense cash
        dispense_done = 1;
        @(negedge clk);
        dispense_done = 0;

        // Check transaction completion
        @(negedge clk);
        if (transaction_done && eject_card)
            $display("TEST PASSED: ATM transaction completed!");
        else
            $display("TEST FAILED!");

        end_transaction = 1;
        @(negedge clk);
        end_transaction = 0;

        #10;
        $finish;

    end

    // Display simulation information
    initial begin
        $monitor(
            "Time=%0t | State=%b | PIN=%b | Menu=%b | Balance=%b | Cash=%b | Insufficient=%b | Done=%b | Eject=%b",
            $time, uut.state, enter_pin, show_menu,
            show_balance, dispense_cash,
            insufficient_funds, transaction_done,
            eject_card
        );
    end

endmodule
