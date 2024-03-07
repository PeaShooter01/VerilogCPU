module InsMem(
    input [31:0] addr,
    output reg [31:0] out
);

reg [31:0] mem [0:128]; 

initial begin
    $readmemb("./inst.txt", mem);
end

always@(*) begin   
    out<=mem[addr];
end

endmodule