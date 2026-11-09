module shift (
    input [4:0] temp,
    output [3:0] newmem
);
assign newmem <= temp >> 1;
end
    