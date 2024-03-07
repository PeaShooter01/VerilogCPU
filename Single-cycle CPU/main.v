module main(
    input clk,
    output [31:0] currentInsAddr,
    output [31:0] nextInsAddr,
    output [31:0] currentIns,
    output [31:0] ALUres
);
wire ALUSrcA;
wire ALUSrcB;
wire DataSrc;
wire RegWr;
wire MemRd;
wire MemWr;
wire RegDst;
wire ExtSel;
wire [1:0] PCSrc;
wire [5:0] opcode;
wire [5:0] funct;
wire [3:0] ALUCtrl;
wire ZF;
wire SF;
wire [31:0] ALUa;
wire [31:0] ALUb;
wire [31:0] Data1;
wire [31:0] Data2;
wire [31:0] MemData;
wire [31:0] WriteData;
wire [31:0] nextIns0;
wire [31:0] nextIns1;
wire [31:0] nextIns2;
wire [4:0] WriteReg;
wire [4:0] Rs;
wire [4:0] Rt;
wire [4:0] Rd;
wire [15:0] Imm;
wire [31:0] extendedImm;

assign opcode = currentIns[31:26];
assign Rs = currentIns[25:21];
assign Rt = currentIns[20:16];
assign Rd = currentIns[15:11];
assign funct = currentIns[5:0];
assign Imm = currentIns[15:0];
assign nextIns0 = currentInsAddr+1;
assign nextIns1 = nextIns0 + extendedImm;
assign nextIns2 = {currentInsAddr[31:28], 2'b00, currentIns[25:0]};

CU CU(
    .opcode(opcode),
    .funct(funct),
    .ZF(ZF),
    .SF(SF),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .DataSrc(DataSrc),
    .RegWr(RegWr),
    .MemRd(MemRd),
    .MemWr(MemWr),
    .RegDst(RegDst),
    .ExtSel(ExtSel),
    .PCSrc(PCSrc),
    .ALUCtrl(ALUCtrl)
);
InsMem InsMem(
    .addr(currentInsAddr),
    .out(currentIns)
);
PC PC(
    .clk(clk),
    .d(nextInsAddr),
    .out(currentInsAddr)
);
ALU ALU(
    .ALUCtrl(ALUCtrl),
    .a(ALUa),
    .b(ALUb),
    .out(ALUres),
    .ZF(ZF),
    .SF(SF)
);
DataMem DataMem(
    .clk(clk),
    .addr(ALUres),
    .data(Data2),
    .MemRd(MemRd),
    .MemWr(MemWr),
    .out(MemData)
);
Registers Registers(
    .clk(clk),
    .RegWr(RegWr),
    .ReadReg1(Rs),
    .ReadReg2(Rt),
    .WriteReg(WriteReg),
    .WriteData(WriteData),
    .ReadData1(Data1),
    .ReadData2(Data2)
);
ImmExt ImmExt(
    .in(Imm),
    .ExtSel(ExtSel),
    .out(extendedImm)
);
MUX32bit_4in nextInsAddrMux(
    .sel(PCSrc),
    .in0(nextIns0),
    .in1(nextIns1),
    .in2(nextIns2),
    .in3(currentInsAddr),
    .out(nextInsAddr)
);
MUX5bit_2in  WriteRegMux(
    .sel(RegDst),
    .in0(Rt),
    .in1(Rd),
    .out(WriteReg)
);
MUX32bit_2in WriteDataMux(
    .sel(DataSrc),
    .in0(ALUres),
    .in1(MemData),
    .out(WriteData)
);
MUX32bit_2in ALUaMux(
    .sel(ALUSrcA),
    .in0(Data1),
    .in1({27'd0,Imm[10:6]}),
    .out(ALUa)
);
MUX32bit_2in ALUbMux(
    .sel(ALUSrcB),
    .in0(Data2),
    .in1(extendedImm),
    .out(ALUb)
);
endmodule