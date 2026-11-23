module retention_store (
    input  wire       rst_n,         // Active-low master reset
    input  wire       gpio_pwr_ok,   // Breadboard GPIO (1 = OK, 0 = Low Voltage)
    input  wire [3:0] live_data,     // Current 4-bit value to save when power drops
    output reg  [3:0] saved_data     // Retained 4-bit value loaded when power returns
);
    // Triggers directly on the falling edge of gpio_pwr_ok for zero-cycle latency
    always @(negedge gpio_pwr_ok or negedge rst_n) begin
        if (!rst_n) begin
            saved_data <= 4'b0000;
        end else begin
            saved_data <= live_data;
        end
    end
endmodule