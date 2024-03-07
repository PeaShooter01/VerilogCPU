module DFF(
    input clk,rst,Wr
    input [31:0] d,
    output reg [31:0] out
);

initial begin
    out<=0;
end

always @(posedge clk or negedge rst) begin
    if(rst==0) out<=0;
    else begin
        if(Wr==1)out<=d;
        else out<=out;
    end
end

endmodule