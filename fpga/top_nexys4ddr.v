// Board wrapper for the Digilent Nexys 4 DDR
//Code taken from https://github.com/ddsva1/bu-ec551-proj1
// Connects the sensor-imitation to the board 
// to the board.
//
//   sw[15:0]   -> circuit inputs in[15:0]
//   led[15:0]   <- circuit outputs out[15:0]
//


module top(
   input [15:0] sw,
   output [15:0] led
);
   mockmed(sw[15:0], led[15:0]);
endmodule
