module mockmed (
    input sw[15:0],
    output led[15:0]
);

//stores state internally to direct what gets saved when
reg [2:0] state = 2'b00;

//sw[15]: step through switch
//sw[14]: temporary low voltage simulation
//sw[13]: acknowledge voltage drop

always @ (sw[15], sw[14] sw[13]) begin
    if (sw[14] == 1'b1) begin
        state = 2'b11;
        panic();
    end else begin
        if (state == 2'b11) begin
            if (sw[13] == 1'b1):
                led[15] = 1'b0;
                mem = load();
                state = 2'b00;
        case (state) begin
            2'b00: add()
            2'b01: shift()
            2'b10: store()
    end
end

endmodule