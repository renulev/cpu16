module cu(
    input wire clk, rst, zero,
    input wire [3:0] op, rd, rs, rt,
    output wire halted, irwe, pcinc, pcload, marwe, rfwe, dmemwe,
    output wire asel, pcsel, wsel, mdsel,
    output wire [3:0] raa, rab, aluop,
    output wire [2:0] bsel
);
    localparam [2:0] FETCH = 0, DECODE = 1, EXEC = 2, MEM = 3, WB = 4, HALT = 5;
    localparam [3:0] NOP = 0, SUB = 2, AND = 3, OR = 4, ALUX = 5, ADDI = 6, LDI = 7,
                     LUI = 8, LD = 9, ST = 10, BZ = 11, BNZ = 12, JMP = 13, JAL = 14, HLT = 15;

    reg [2:0] state;
    wire br   = (op == BZ || op == BNZ || op == JMP);
    wire ldst = (op == LD || op == ST);

    always @(posedge clk) begin
        if (rst) state <= FETCH;
        else case (state)
            FETCH:   state <= DECODE;
            DECODE:  state <= (op == NOP) ? FETCH : (op == HLT) ? HALT : EXEC;
            EXEC:    state <= br ? FETCH : ldst ? MEM : WB;
            MEM:     state <= (op == LD) ? WB : FETCH;
            WB:      state <= FETCH;
            default: state <= HALT;
        endcase
    end

    assign halted = (state == HALT);
    assign irwe   = (state == FETCH);
    assign pcinc  = (state == FETCH);
    assign marwe  = (state == EXEC) && !br;
    assign pcload = (state == EXEC) && (op == JMP || op == JAL ||
                    (op == BZ && zero) || (op == BNZ && !zero));
    assign dmemwe = (state == MEM) && (op == ST);
    assign rfwe   = (state == WB);

    assign asel   = br || op == JAL;
    assign pcsel  = (op == JAL);
    assign wsel   = (op == LD);
    assign mdsel  = (op == LUI);

    assign raa = (op == ALUX || op == LUI || op == BZ || op == BNZ) ? rd : rs;
    assign rab = (op == ST) ? rd : (op == ALUX || op == JAL) ? rs : rt;

    assign bsel = (op == ADDI || ldst) ? 1 : (op == LDI) ? 2 :
                  (op == BZ || op == BNZ) ? 3 : (op == JMP) ? 4 : 0;

    assign aluop = (op == SUB) ? 1 : (op == AND) ? 2 : (op == OR) ? 3 :
                   (op == ALUX) ? rt : (op == LDI) ? 4'hA : (op == JAL) ? 4'h9 : 0;
endmodule
