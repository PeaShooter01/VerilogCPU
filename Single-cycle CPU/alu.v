module ALU(
    input [3:0] ALUCtrl,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] out,
    output ZF,
    output SF
);

assign ZF=(out==0) ? 1'b1:1'b0;
assign SF=out[31];

always @(*) begin
    case(ALUCtrl)
        4'b0100:out=a+b;
        4'b0110:out=a-b;
        4'b0101:out=a+b;
        4'b0000:out=a&b;
        4'b0001:out=a|b;
        4'b0011:out=~(a|b);
        4'b0010:out=b<<a;
        4'b0111:out=b>>a;
        4'b1000:out=(a<b) ? 1:0;
        4'b1001:begin
            if(a[31]==b[31] && a < b)
                out=1;
            else if(a[31]==1 && b[31]==0)
                out=1;
            else
                out=0;
        end
        4'b1010:out=a^b;
        default:$display("ALU:Unknown ALUCtrl.");
    endcase
end

endmodule