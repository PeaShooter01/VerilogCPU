module MUX5bit_4in
(
    input [1:0] sel,
    input [4:0] in0,
    input [4:0] in1,
    input [4:0] in2,
    input [4:0] in3,
    output reg [4:0] out
);

always @(*) begin
    case(sel)
        2'b00: out <= in0;
        2'b01: out <= in1;
        2'b10: out <= in2;
        2'b11: out <= in3;
        default:out <= 0;
    endcase
end

endmodule