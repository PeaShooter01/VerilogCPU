module Registers(
    input clk,
    input RegWr,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
);

reg [31:0] registers [1:31];
integer i;

initial begin
    for(i = 1; i <= 31; i=i+1) begin
        registers[i] <= 0;
    end
end

always @(*) begin
    if(ReadReg1)
        ReadData1<=registers[ReadReg1];
    else
        ReadData1<=0;
    if(ReadReg2)
        ReadData2<=registers[ReadReg2];
    else
        ReadData2<=0;
end

always @(negedge clk) begin
    if(RegWr)
        registers[WriteReg]<=WriteData;
end

endmodule