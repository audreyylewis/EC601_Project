module add (
    input [4:0] sw0,
    input [4:0] mem0,
    output reg [4:0] temp
);
assign temp <= (mem0 + sw0);
end
    