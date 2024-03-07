module CU(
    input [5:0] opcode,
    input [5:0] funct,
    input ZF,
    input SF,
    output reg ALUSrcA,
    output reg ALUSrcB,
    output reg DataSrc,
    output reg RegWr,
    output reg MemRd,
    output reg MemWr,
    output reg RegDst,
    output reg ExtSel,
    output reg [1:0] PCSrc,
    output reg [3:0] ALUCtrl
);
/*
ALUSrcA:ALU操作数a的来源，0为寄存器Rs(Inst[25:21])，1为{27'd0,immediate[10:6]}
ALUSrcB:ALU操作数b的来源，0为寄存器Rt(Inst[20:16])，1为扩展后的立即数(扩展后的Inst[15:0])
DataSrc:写入寄存器的内容来源,0为ALU运算结果，1为内存读取结果
RegWr:是否写入寄存器，0为否，1为是
MemRd:是否读取内存，0为否，1为是
MemWr:是否写内存，0为否，1为是
RegDst:要写入的寄存器号，0为Rt(Inst[20:16]),1为Rd(Inst[15:11])
ExtSel:立即数扩展的类型，0为零扩展，1为符号扩展
PCSrc:下一条指令的地址，00为下一条指令，01为根据立即数Jump，10为{currentInsAddr[31:28], 2'b00，currentIns[25:0]}，11为继续当前指令
ALUCtrl:ALU执行的运算:
    0100:add
    0110:sub
    0101:addu
    0000:and
    0001:or
    0011:nor
    0010:sll
    0111:srl
    1000:sltu
    1001:slt
    1010:xor
*/
always @(*) begin
    case(opcode)
        6'b000000:begin //R-R类型
            case(funct)
                6'b100000:begin //add
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000100;
                end
                6'b100001:begin //addu
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000101;
                end
                6'b100010:begin //sub
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000110;
                end
                6'b100100:begin //and
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000000;
                end
                6'b100101:begin //or
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000001;
                end
                6'b100111:begin //nor
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000011;
                end
                6'b000000:begin //sll
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b10010010;
                    {PCSrc,ALUCtrl} <= 6'b000010;
                end
                6'b000010:begin //srl
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b10010010;
                    {PCSrc,ALUCtrl} <= 6'b000111;
                end
                6'b000100:begin //sllv
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000010;
                end
                6'b000110:begin //srlv
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b000111;
                end
                6'b101010:begin //slt
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b001001;
                end
                6'b101011:begin //sltu
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b001000;
                end
                6'b100110:begin //xor
                    {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00010010;
                    {PCSrc,ALUCtrl} <= 6'b001010;
                end
                default:$display("CU:Unknown Funct.");
            endcase
        end
        6'b001000:begin //addi
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010001;
            {PCSrc,ALUCtrl} <= 6'b000100;
        end
        6'b001001:begin //addiu
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010001;
            {PCSrc,ALUCtrl} <= 6'b000100;
        end
        6'b001100:begin //andi
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010000;
            {PCSrc,ALUCtrl} <= 6'b000000;
        end
        6'b001101:begin //ori
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010000;
            {PCSrc,ALUCtrl} <= 6'b000001;
        end
        6'b001010:begin //slti
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010001;
            {PCSrc,ALUCtrl} <= 6'b001001;
        end
        6'b001011:begin //sltiu
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010001;
            {PCSrc,ALUCtrl} <= 6'b001000;
        end
        6'b001110:begin //xori
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01010001;
            {PCSrc,ALUCtrl} <= 6'b001010;
        end
        6'b100011:begin //lw
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01111001;
            {PCSrc,ALUCtrl} <= 6'b000100;
        end
        6'b101011:begin //sw
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b01000101;
            {PCSrc,ALUCtrl} <= 6'b000100;
        end
        6'b000100:begin //beq
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00000001;
            PCSrc<=(ZF==1) ? 2'b01:2'b00;
            ALUCtrl<=4'b0110;
        end
        6'b000101:begin //bne
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00000001;
            PCSrc<=(ZF==0) ? 2'b01:2'b00;
            ALUCtrl<=4'b0110;
        end
        6'b000001:begin //bltz
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00000001;
            PCSrc<=(SF==1) ? 2'b01:2'b00;
            ALUCtrl<=4'b0100;
        end
        6'b000111:begin //bgtz
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00000001;
            PCSrc<=(SF==0 && ZF==0) ? 2'b01:2'b00;
            ALUCtrl<=4'b0100;
        end
        6'b000110:begin //blez
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00000001;
            PCSrc<=(SF==1 || ZF==0) ? 2'b01:2'b00;
            ALUCtrl<=4'b0100;
        end
        6'b000010:begin //j
            {ALUSrcA, ALUSrcB, DataSrc, RegWr, MemRd, MemWr, RegDst, ExtSel} <= 8'b00000000;
            {PCSrc,ALUCtrl} <= 6'b100100;
        end
        default:$display("CU:Unknown Opcode.");
    endcase
end

endmodule