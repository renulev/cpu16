module cu(
    input wire clk,
    input wire rst,
    input wire [3:0] op,
    input wire eq,
    output reg pcinc,
    output reg pcload,
    output reg pcjmp,
    output reg irwe,
    output reg marwe,
    output reg rfwe,
    output reg dmemwe,
    output wire aluimm,
    output wire swsel,
    output wire memtoreg,
    output reg [3:0] aluop,
    output wire hlt
);
    localparam FETCH = 3'd0, DECODE = 3'd1, EXEC = 3'd2, MEM = 3'd3, WB = 3'd4, HALT = 3'd5;
    localparam ADD = 4'h1, SUB = 4'h2, AND = 4'h3, OR = 4'h4, ADDI = 4'h5,
               LW = 4'h6, SW = 4'h7, BEQ = 4'h8, JMP = 4'h9, HLT = 4'hA;

    reg [2:0] state;

    always @(posedge clk) begin
        if (rst) state <= FETCH;
        else case (state)
            FETCH: state <= DECODE;
            DECODE: state <= EXEC;
            EXEC: case (op)
                ADD, SUB, AND, OR, ADDI: state <= WB;
                LW, SW: state <= MEM;
                HLT: state <= HALT;
                default: state <= FETCH;
            endcase
            MEM: state <= (op == LW) ? WB : FETCH;
            WB: state <= FETCH;
            HALT: state <= HALT;
            default: state <= FETCH;
        endcase
    end

    assign aluimm = (op == ADDI) || (op == LW) || (op == SW);
    assign swsel = (op == SW);
    assign memtoreg = (op == LW);
    assign hlt = (state == HALT);

    always @(*) begin
        pcinc = 0;
        pcload = 0;
        pcjmp = 0;
        irwe = 0;
        marwe = 0;
        rfwe = 0;
        dmemwe = 0;
        aluop = 4'h0;

        case (op)
            ADD, SUB, AND, OR: aluop = op;
            ADDI, LW, SW: aluop = ADD;
        endcase

        case (state)
            FETCH: begin
                irwe = 1;
                pcinc = 1;
            end
            EXEC: case (op)
                LW, SW: marwe = 1;
                BEQ: pcload = eq;
                JMP: begin
                    pcload = 1;
                    pcjmp = 1;
                end
            endcase
            MEM: dmemwe = (op == SW);
            WB: rfwe = 1;
        endcase
    end
endmodule
