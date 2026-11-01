module top(
    input wire clk,
    input wire rst,
    output wire halted
);
    wire [15:0] pcq, irq, marq, imemrdat, dmemrdat, rdata, rdatb, y;
    wire [3:0] op, rd, rs, rt, raa, rab, aluop;
    wire [2:0] bsel;
    wire irwe, pcinc, pcload, marwe, rfwe, dmemwe, asel, pcsel, wsel, mdsel;
    wire zero = (rdata == 16'b0);

    // operand muxes
    wire [15:0] a = asel ? pcq : rdata;
    reg  [15:0] b;
    always @* case (bsel)
        1:       b = {{12{rt[3]}}, rt};
        2:       b = {8'b0, irq[7:0]};
        3:       b = {{8{irq[7]}}, irq[7:0]};
        4:       b = {{4{irq[11]}}, irq[11:0]};
        default: b = rdatb;
    endcase

    cu  cu0(clk, rst, zero, op, rd, rs, rt, halted, irwe, pcinc, pcload, marwe,
            rfwe, dmemwe, asel, pcsel, wsel, mdsel, raa, rab, aluop, bsel);

    pc  pc0(clk, rst, pcinc, pcload, pcsel ? rdatb : y, pcq);
    imem im0(pcq, imemrdat);
    ir  ir0(clk, rst, irwe, imemrdat, irq, op, rd, rs, rt);
    alu alu0(a, b, aluop, y);
    mar mar0(clk, rst, marwe, mdsel ? {irq[7:0], rdata[7:0]} : y, marq);
    rf  rf0(clk, rst, raa, rdata, rab, rdatb, rfwe, rd, wsel ? dmemrdat : marq);
    dmem dm0(clk, marq, dmemrdat, dmemwe, rdatb);
endmodule