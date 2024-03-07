module CU(
    input clk,rst,ZF,SF,
    input [5:0] opcode,
    input [5:0] funct,
    output reg PCWr, ALUSrcA, ALUSrcB, DataSrc, RegWr, WrDataSrc, MemRd, MemWr, IRWr, ExtSel,
    output reg [1:0] PCSrc,
    output reg [1:0] RegDst,
    output reg [3:0] ALUCtrl
);
reg [2:0] state;
/*
PCWr:是否写PC
ALUSrcA:ALU操作数a的来源，0为寄存器Rs(Inst[25:21])，1为{27'd0,immediate[10:6]}
ALUSrcB:ALU操作数b的来源，0为寄存器Rt(Inst[20:16])，1为扩展后的立即数(扩展后的Inst[15:0])
DataSrc:写入BUS的内容来源,0为ALU运算结果，1为内存读取结果
RegWr:是否写寄存器
WrDataSrc:写入寄存器的内容，0为下一条指令的地址，1为BUS上的数据
MemRd:是否读内存
MemWr:是否写内存
IRWr:是否写IR
ExtSel:立即数扩展的类型，0为零扩展，1为符号扩展
PCSrc:下一条指令的地址，00为下一条指令，01为根据立即数Jump，10为为寄存器Rs(Inst[25:21])，11为{currentInsAddr[31:28], currentIns[25:0], 2'b00}
RegDst:要写入的寄存器号，00为31号寄存器，01为Rt(Inst[20:16]),10为Rd(Inst[15:11])，11为高阻态
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
always @(posedge clk or negedge rst) begin
    if(rst==0) begin
        state <= 3'b000;
        PCWr <= 1;
        IRWr <= 1;
    end
    else begin
        case(state)
            3'b000: state <= 3'b001;
            3'b001: begin
                //branch instructions
                if(opcode==6'b000100 || opcode==6'b000101 || opcode==6'b000001 || opcode==6'b000110 || opcode==6'b000111) state <= 3'b101;
                //memory operations
                else if(opcode==6'b101011 || opcode==6'b100011) state <= 3'b010;
                //jump instructions
                else if(opcode==6'b000010 || (opcode==6'b000000 && funct==6'b001000) || opcode==6'b000011)
                    state <= 3'b000;
                else state <= 3'b110;
            end
            3'b110: state <= 3'b111;
            3'b010: state <= 3'b011;
            3'b011: begin
                //lw
                if(opcode==6'b100011) state <= 3'b100;
                //sw
                else state <= 3'b000;
            end
            3'b111, 3'b101, 3'b100: state <= 3'b000;
        endcase
    end
end

always @(state or opcode or zero or sign) begin
    case(opcode)
        6'b000000: begin //r-r instructions
            case(funct)
                6'b100000: //add
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100100;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b100001: //addu
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100101;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b100010: //sub
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100110;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b100100: //and
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100000;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b100101: //or
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100001;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b100111: //nor
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100011;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b000000: //sll
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b10010000100010;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b000010: //srl
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b10010000100111;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b000100: //sllv
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100010;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b000110: //srlv
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000100111;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b101010: //slt
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000101001;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b101011: //sltu
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000101000;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b100110: //xor
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010000101010;
                    case(state)
                        3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                        3'b111: {IRWr, MemRd, RegWr} = 4'b101;
                    endcase
                6'b111001: //jr
                    {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'00010010000100;
                    {IRWr, MemRd, RegWr} = 4'b100;
            endcase
        end
        6'b001000: begin //addi
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010100010100;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b001001: begin //addiu
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010100010100;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b001100:begin //andi
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010000010000;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b001101:begin //ori
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010000010001;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b001110:begin //xori
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010000011010;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b001010:begin //slti
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010100011001;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b001011:begin //sltiu
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010100011000;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b110: {IRWr, MemRd, RegWr} = 4'b100;
                3'b111: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b101011:begin //sw
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01010100000000;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b010: {IRWr, MemRd, RegWr} = 4'b100;
                3'b011: {IRWr, MemRd, RegWr} = 4'b110;
            endcase
        end
        6'b100011:begin //lw
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b01111100010000;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b100;
                3'b010: {IRWr, MemRd, RegWr} = 4'b100;
                3'b011: {IRWr, MemRd, RegWr} = 4'b100;
                3'b100: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
        6'b000100:begin //beq
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, RegDst, ALUCtrl} <= 12'b000101000110;
            PCSrc<=(ZF==1)? 2'b01 : 2'b00;
            {IRWr, MemRd, RegWr} = 4'b100;
        end
        6'b000101:begin //bne
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, RegDst, ALUCtrl} <= 12'b000101000110;
            PCSrc<=(ZF==0)? 2'b01 : 2'b00;
            {IRWr, MemRd, RegWr} = 4'b100;
        end
        6'b000001:begin //bltz
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, RegDst, ALUCtrl} <= 12'b000101000100;
            PCSrc<=(SF==1)? 2'b01 : 2'b00;
            {IRWr, MemRd, RegWr} = 4'b100;
        end
        6'b000111:begin //bgtz
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, RegDst, ALUCtrl} <= 12'b000101000100;
            PCSrc<=(SF==0 && ZF==0)? 2'b01 : 2'b00;
            {IRWr, MemRd, RegWr} = 4'b100;
        end
        6'b000110:begin //blez
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, RegDst, ALUCtrl} <= 12'b000101000100;
            PCSrc<=(SF==1 || ZF==0)? 2'b01 : 2'b00;
            {IRWr, MemRd, RegWr} = 4'b100;
        end
        6'b000010:begin //j
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00010011000100;
            {IRWr, MemRd, RegWr} = 4'b100;
        end
        6'b000011:begin //jal
            {ALUSrcA, ALUSrcB, DataSrc, WrDataSrc, MemRd, ExtSel, PCSrc, RegDst, ALUCtrl} <= 14'b00000011000100;
            case(state)
                3'b000: {IRWr, MemRd, RegWr} = 4'b100;
                3'b001: {IRWr, MemRd, RegWr} = 4'b101;
            endcase
        end
    endcase
end

always @(negedge clk) begin
    case(state)
        3'b111, 3'b101, 3'b100: PCWr <= 1;
        3'b011: PCWr <= (opcode==6'b101011 ? 1 : 0); // sw
        3'b001: PCWr <= (opcode==6'b000010||opcode==6'b000011||(opcode==6'b000000&&funct==6'b001000)? 1 : 0); // j, jal, jr
        default: PCWr <= 0;
    endcase
end

endmodule