module top_system (
    input  wire       sys_clk,       // Fast on-board clock (e.g., 50 MHz)
    input  wire       rst_n,         // Active-low system reset
    input  wire       clk_sw,        // Manual clock-simulating toggle switch
    input  wire       gpio_pwr_ok,   // External breadboard GPIO power monitor
    input  wire [3:0] sw_in,         // 4-bit binary input switches
    output reg  [3:0] result_out     // 4-bit accumulated & shifted output
);

    // Internal datapath wires
    wire [4:0] added_val;
    wire [3:0] shifted_val;
    wire [3:0] restored_val;

    // Synchronizers for safe double-edge switch detection & power-restore pulse
    reg [2:0] clk_sw_sync;
    reg [2:0] pwr_ok_sync;

    // 1. Add current stored value + 4-bit switch input
    adder_unit u_add (
        .current_val (result_out),
        .sw_in       (sw_in),
        .sum_out     (added_val)
    );

    // 2. Shift 5-bit sum right by 1 to divide by 2
    shifter_unit u_shift (
        .sum_in      (added_val),
        .shifted_out (shifted_val)
    );

    // 3. Asynchronously capture current 4-bit value when breadboard pin drops
    retention_store u_store (
        .rst_n       (rst_n),
        .gpio_pwr_ok (gpio_pwr_ok),
        .live_data   (result_out),
        .saved_data  (restored_val)
    );

    // Synchronize external asynchronous inputs
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_sw_sync <= 3'b000;
            pwr_ok_sync <= 3'b111;
        end else begin
            clk_sw_sync <= {clk_sw_sync[1:0], clk_sw};
            pwr_ok_sync <= {pwr_ok_sync[1:0], gpio_pwr_ok};
        end
    end

    // Edge detectors
    wire sw_any_edge   = clk_sw_sync[2] ^ clk_sw_sync[1];   // Both rising & falling flips
    wire pwr_rise_edge = ~pwr_ok_sync[2] & pwr_ok_sync[1];  // Power restored pulse
    wire pwr_is_ok     = pwr_ok_sync[1];

    // Main 4-bit state register
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            result_out <= 4'b0000;
        end else if (!pwr_is_ok) begin
            // Drive 0 while simulated chip voltage is low
            result_out <= 4'b0000;
        end else if (pwr_rise_edge) begin
            // Restore saved 4-bit value when breadboard voltage returns
            result_out <= restored_val;
        end else if (sw_any_edge) begin
            // Update with (result_out + sw_in) >> 1 on every flip of clk_sw
            result_out <= shifted_val;
        end
    end

endmodule