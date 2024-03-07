module InsMem(
    input [31:0] addr,
    output [31:0] out
);

reg [31:0] mem [0:128]; 

initial begin
    $readmemb("./inst.txt", mem);
end

assign out<=mem[addr];

endmodule