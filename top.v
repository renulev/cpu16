module top(
    input wire clk,
    input wire rst
);
    wire [15:0] pcq;
    wire [15:0] pcd;
    wire [15:0] instr;
    wire [15:0] irq;
    wire [15:0] marq;
    wire [15:0] ra;
    wire [15:0] rb;
    wire [15:0] aluy;
    wire [15:0] dmrdat;
    wire [3:0] op;
    wire [3:0] rd;
    wire [3:0] rs;
    wire [3:0] rt;
    wire [3:0] aluop;
    wire pcinc;
    wire pcload;
    wire pcjmp;
    wire irwe;
    wire marwe;
    wire rfwe;
    wire dmemwe;
    wire aluimm;
    wire swsel;
    wire memtoreg;
    wire eq;
    wire hlt;

    wire [15:0] imm = {12'b0, rt};
    wire [15:0] boff = {{12{rd[3]}}, rd};

    assign pcd = pcjmp ? {4'b0, irq[11:0]} : pcq + boff;
    assign eq = (ra == rb);

    pc pc(
        .clk(clk),
        .rst(rst),
        .inc(pcinc),
        .load(pcload),
        .d(pcd),
        .q(pcq)
    );

    imem imem(
        .radr(pcq),
        .rdat(instr)
    );

    ir ir(
        .clk(clk),
        .rst(rst),
        .we(irwe),
        .d(instr),
        .q(irq),
        .op(op),
        .rd(rd),
        .rs(rs),
        .rt(rt)
    );

    rf rf(
        .clk(clk),
        .rst(rst),
        .radra(rs),
        .rdata(ra),
        .radrb(swsel ? rd : rt),
        .rdatb(rb),
        .we(rfwe),
        .wadr(rd),
        .wdat(memtoreg ? dmrdat : aluy)
    );

    alu alu(
        .a(ra),
        .b(aluimm ? imm : rb),
        .op(aluop),
        .y(aluy)
    );

    mar mar(
        .clk(clk),
        .rst(rst),
        .we(marwe),
        .d(aluy),
        .q(marq)
    );

    dmem dmem(
        .clk(clk),
        .adr(marq),
        .rdat(dmrdat),
        .we(dmemwe),
        .wdat(rb)
    );

    cu cu(
        .clk(clk),
        .rst(rst),
        .op(op),
        .eq(eq),
        .pcinc(pcinc),
        .pcload(pcload),
        .pcjmp(pcjmp),
        .irwe(irwe),
        .marwe(marwe),
        .rfwe(rfwe),
        .dmemwe(dmemwe),
        .aluimm(aluimm),
        .swsel(swsel),
        .memtoreg(memtoreg),
        .aluop(aluop),
        .hlt(hlt)
    );
endmodule
