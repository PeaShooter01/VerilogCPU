module PC(
    input clk,
    input [31:0] d,
    output reg [31:0] out
);

initial begin
    out<=0;
end

always @(posedge clk) begin
    out<=d;
end

endmodule