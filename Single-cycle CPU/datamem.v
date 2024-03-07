module DataMem(
    input clk,
    input [31:0] addr,
    input [31:0] data,
    input MemRd,
    input MemWr,
    output reg [31:0] out
);

reg [7:0] mem [0:128]; 

always@(*) begin
    if(MemRd) begin
        out[31:24]<=mem[addr];
        out[23:16]<=mem[addr+1];
        out[15:8]<=mem[addr+2];
        out[7:0]<=mem[addr+3];
    end
end

always@(negedge clk) begin
    if(MemWr) begin
        mem[addr]<=data[31:24];
        mem[addr+1]<=data[23:16];
        mem[addr+2]<=data[15:8];
        mem[addr+3]<=data[7:0];
    end
end

endmodule