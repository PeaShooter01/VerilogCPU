module MUX32bit_2in
(
    input sel,
    input [31:0] in0,
    input [31:0] in1,
    output reg [31:0] out
);

always @(*) begin
    out<=sel? in1:in0;
end

endmodule