module shifter_unit (
    input  wire [4:0] sum_in,        // 5-bit sum from adder_unit
    output wire [3:0] shifted_out    // 4-bit result (max 30 / 2 = 15)
);
    assign shifted_out = sum_in >> 1;
endmodule