module MUX5bit_2in
(
    input sel,
    input [4:0] in0,
    input [4:0] in1,
    output reg [4:0] out
);

always @(*) begin
    out<=sel? in1:in0;
end

endmodule