module main(
    input clk,rst,
    output [31:0] currentInsAddr, nextInsAddr,currentIns,ALURes
);
wire ZF,SF;
wire [5:0] opcode;
wire [5:0] funct;
wire PCWr, ALUSrcA, ALUSrcB, DataSrc, RegWr, WrDataSrc, MemRd, MemWr, IRWr, ExtSel;
wire [1:0] PCSrc;
wire [1:0] RegDst;
wire [3:0] ALUCtrl;
wire [4:0] Rs,Rt,Rd;
wire [15:0] Imm;
wire [31:0] IDataOut;
wire [4:0] WriteReg;
wire [31:0] WriteData;
wire [31:0] Data1,Data2,ALUa,ALUb,extendedImm,ADRout,BDRout,ALUResDRout,DataBusOld,DataBus,nextIns0,nextIns1,nextIns2,MemData;

assign opcode=currentIns[31:26];
assign funct = currentIns[5:0];
assign Rs = currentIns[25:21];
assign Rt = currentIns[20:16];
assign Rd = currentIns[15:11];
assign Imm = currentIns[15:0];
assign nextIns0 = currentInsAddr+1;
assign nextIns1 = nextIns0 + extendedImm;
assign nextIns2 = {currentInsAddr[31:28], currentIns[25:0], 2'b00};

CU CU(
    .clk(clk),.rst(rst),.ZF(ZF),.SF(SF),
    .opcode(opcode),
    .funct(funct),
    .PCWr(PCWr), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .DataSrc(DataSrc), .RegWr(RegWr), .WrDataSrc(WrDataSrc), .MemRd(MemRd), .MemWr(MemWr), .IRWr(IRWr), .ExtSel(ExtSel),
    .PCSrc(PCSrc),
    .RegDst(RegDst),
    .ALUCtrl(ALUCtrl)
);
DFF PC(
    .clk(clk),.rst(rst),.Wr(PCWr),
    .d(nextInsAddr),
    .out(currentInsAddr)
);
InsMem InsMem(
    .addr(currentInsAddr),
    .out(IDataOut)
);
Registers Registers(
    .clk(clk),.rst(rst),
    .RegWr(RegWr),
    .ReadReg1(Rs),
    .ReadReg2(Rt),
    .WriteReg(WriteReg),
    .WriteData(WriteData),
    .ReadData1(Data1),
    .ReadData2(Data2)
);
ALU ALU(
    .ALUCtrl(ALUCtrl),
    .a(ALUa),
    .b(ALUb),
    .out(ALURes),
    .ZF(ZF),
    .SF(SF)
);
DataMem DataMem(
    .clk(clk),
    .addr(ALURes),
    .data(Data2),
    .MemRd(MemRd),
    .MemWr(MemWr),
    .out(MemData)
);
ImmExt ImmExt(
    .in(Imm),
    .ExtSel(ExtSel),
    .out(extendedImm)
);
IR IR(
    .clk(clk),.IRWr(IRWr),
    .in(IDataOut),
    .out(currentIns)
);
DFF ADR(
    .clk(clk),.rst(rst),.Wr(1'b1),
    .d(Data1),
    .out(ADRout)
);
DFF BDR(
    .clk(clk),.rst(rst),.Wr(1'b1),
    .d(Data2),
    .out(BDRout)
);
DFF ALUResDR(
    .clk(clk),.rst(rst),.Wr(1'b1),
    .d(ALURes),
    .out(ALUResDRout)
);
DFF DBDR(
    .clk(clk),.rst(rst),.Wr(1'b1),
    .d(DataBusOld),
    .out(DataBus)
);
MUX32bit_4in nextInsAddrMux(
    .sel(PCSrc),
    .in0(nextIns0),
    .in1(nextIns1),
    .in2(Data1),
    .in3(nextIns2),
    .out(nextInsAddr)
);
MUX5bit_4in WriteRegMux(
    .sel(RegDst),
    .in0(5'd31),
    .in1(Rt),
    .in2(Rd),
    .in3(5'bzzzzz),
    .out(WriteReg)
);
MUX32bit_2in WriteDataMux(
    .sel(WrDataSrc),
    .in0(nextIns0),
    .in1(DataBus),
    .out(WriteData)
);
MUX32bit_2in ALUaMux(
    .sel(ALUSrcA),
    .in0(ADRout),
    .in1({27'd0,Imm[10:6]}),
    .out(ALUa)
);
MUX32bit_2in ALUbMux(
    .sel(ALUSrcB),
    .in0(BDRout),
    .in1(extendedImm),
    .out(ALUb)
);
MUX32bit_2in DBDRMux(
    .sel(DataSrc),
    .in0(ALURes),
    .in1(MemData),
    .out(DataBusOld)
);
endmodule