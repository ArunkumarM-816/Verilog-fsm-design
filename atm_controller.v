
module atm_controller (
    input wire clk,
    input wire reset,

    input wire card_inserted,
    input wire pin_entered,
    input wire pin_valid,

    input wire balance_req,
    input wire balance_done,

    input wire withdraw_req,
    input wire amount_entered,
    input wire funds_available,

    input wire dispense_done,
    input wire return_menu,
    input wire end_transaction,

    output reg enter_pin,
    output reg show_menu,
    output reg show_balance,
    output reg dispense_cash,
    output reg insufficient_funds,
    output reg invalid_pin,
    output reg transaction_done,
    output reg eject_card
);

    // FSM state encoding
    parameter IDLE        = 4'b0000,
              PIN         = 4'b0001,
              MENU        = 4'b0010,
              BALANCE     = 4'b0011,
              WITHDRAW    = 4'b0100,
              DISPENSE    = 4'b0101,
              INSUFFICIENT= 4'b0110,
              DONE        = 4'b0111,
              INVALID_PIN = 4'b1000;

    reg [3:0] state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;

        case (state)

            IDLE:
                if (card_inserted)
                    next_state = PIN;

            PIN:
                if (pin_entered) begin
                    if (pin_valid)
                        next_state = MENU;
                    else
                        next_state = INVALID_PIN;
                end

            MENU: begin
                if (balance_req)
                    next_state = BALANCE;
                else if (withdraw_req)
                    next_state = WITHDRAW;
            end

            BALANCE:
                if (balance_done)
                    next_state = DONE;

            WITHDRAW:
                if (amount_entered) begin
                    if (funds_available)
                        next_state = DISPENSE;
                    else
                        next_state = INSUFFICIENT;
                end

            DISPENSE:
                if (dispense_done)
                    next_state = DONE;

            INSUFFICIENT:
                if (return_menu)
                    next_state = MENU;

            DONE:
                if (end_transaction)
                    next_state = IDLE;

            INVALID_PIN:
                if (end_transaction)
                    next_state = IDLE;

            default:
                next_state = IDLE;

        endcase
    end

    // Moore output logic
    always @(*) begin

        enter_pin         = 1'b0;
        show_menu         = 1'b0;
        show_balance      = 1'b0;
        dispense_cash     = 1'b0;
        insufficient_funds= 1'b0;
        invalid_pin       = 1'b0;
        transaction_done  = 1'b0;
        eject_card        = 1'b0;

        case (state)

            PIN:
                enter_pin = 1'b1;

            MENU:
                show_menu = 1'b1;

            BALANCE:
                show_balance = 1'b1;

            DISPENSE:
                dispense_cash = 1'b1;

            INSUFFICIENT:
                insufficient_funds = 1'b1;

            DONE: begin
                transaction_done = 1'b1;
                eject_card = 1'b1;
            end

            INVALID_PIN: begin
                invalid_pin = 1'b1;
                eject_card = 1'b1;
            end

            default: ;

        endcase
    end

endmodule
