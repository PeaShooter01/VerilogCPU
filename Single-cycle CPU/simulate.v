module simulate;
    reg clk;
    wire [31:0] currentInsAddr;
    wire [31:0] nextInsAddr;
    wire [31:0] currentIns;
    wire [31:0] ALUres;
    main main(
        .clk(clk),
        .currentInsAddr(currentInsAddr),
        .nextInsAddr(nextInsAddr),
        .currentIns(currentIns),
        .ALUres(ALUres)
    );

    always #50 clk = ~clk;

    initial begin
        clk = 1;
    end
endmodule