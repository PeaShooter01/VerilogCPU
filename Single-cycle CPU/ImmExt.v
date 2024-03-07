module ImmExt(
    input [15:0] in,
    input ExtSel,
    output reg [31:0] out
);

always @(*) begin
    if(ExtSel) begin
        if(in[15]==0)
            out[31:16]<=0;
        else
            out[31:16]<=16'hFFFF;
    end
    else
        out[31:16]<=0;
    out[15:0]<=in;
end
endmodule