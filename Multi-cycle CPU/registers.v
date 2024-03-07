module Registers(
    input clk,rst
    input RegWr,
    input [4:0] ReadReg1,
    input [4:0] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);

reg [31:0] registers [1:31];
integer i;

assign ReadData1 = (ReadReg1 == 0) ? 0 : registers[ReadReg1];
assign ReadData2 = (ReadReg2 == 0) ? 0 : registers[ReadReg2];

always @(negedge clk or negedge rst) begin
    if(rst==0)begin
        for(i = 1; i <= 31; i=i+1) begin
            registers[i] <= 0;
        end
    end
    if(RegWr)
        registers[WriteReg]<=WriteData;
end

endmodule