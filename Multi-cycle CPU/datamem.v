module DataMem(
    input clk,
    input [31:0] addr,
    input [31:0] data,
    input MemRd,
    input MemWr,
    output [31:0] out
);

reg [7:0] mem [0:128]; 

assign out[31:24]<=(MemRd==1) ? mem[addr] : 8'bz;
assign out[23:16]<=(MemRd==1) ? mem[addr+1] : 8'bz;
assign out[15:8]<=(MemRd==1) ? mem[addr+2] : 8'bz;
assign out[7:0]<=(MemRd==1) ? mem[addr+3] : 8'bz;

always@(negedge clk) begin
    if(MemWr) begin
        mem[addr]<=data[31:24];
        mem[addr+1]<=data[23:16];
        mem[addr+2]<=data[15:8];
        mem[addr+3]<=data[7:0];
    end
end

endmodule