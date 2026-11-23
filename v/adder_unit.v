module adder_unit (
    input  wire [3:0] current_val,   // Current 4-bit value from output register
    input  wire [3:0] sw_in,         // 4-bit binary input from switches (0..15)
    output wire [4:0] sum_out        // 5-bit sum (max 15 + 15 = 30)
);
    assign sum_out = current_val + sw_in;
endmodule
