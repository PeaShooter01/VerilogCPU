module IR(
    input clk,IRWr,
    input [31:0] in,
    output reg [31:0] out
);

always @(negedge clk) begin
    if(IRWr) out <= in;
    else out <= out;
end

endmodule