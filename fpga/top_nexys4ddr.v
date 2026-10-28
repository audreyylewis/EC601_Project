// Board wrapper for the Digilent Nexys 4 DDR
//Code taken from https://github.com/ddsva1/bu-ec551-proj1
// Connects the generated modules circuit_sop and circuit_pos
// to the board.
//
//   sw[15:0]   -> circuit inputs in[15:0]
//   led[7:0]   <- circuit_sop outputs out[7:0]
//   led[15:8]  <- circuit_pos outputs out[7:0]
//
// The SOP and POS circuits implement the same function, so led[j] and led[j+8]
// should always match.

module top(
   input [15:0] sw,
   output [15:0] led
);
   circuit_sop sop(.in(sw), .out(led[7:0]));
   circuit_pos pos(.in(sw), .out(led[15:8]));
endmodule
