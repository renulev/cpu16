module alu(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] op,
    output wire [15:0] y
);
    localparam [3:0] ADD   = 4'h0;
    localparam [3:0] SUB   = 4'h1;
    localparam [3:0] AND   = 4'h2;
    localparam [3:0] OR    = 4'h3;
    localparam [3:0] XOR   = 4'h4;
    localparam [3:0] NOT   = 4'h5;
    localparam [3:0] SHL   = 4'h6;
    localparam [3:0] SHR   = 4'h7;
    localparam [3:0] SAR   = 4'h8;
    localparam [3:0] PASSA = 4'h9;
    localparam [3:0] PASSB = 4'hA;
    localparam [3:0] SLT   = 4'hB;
    localparam [3:0] SLTU  = 4'hC;
    localparam [3:0] EQ    = 4'hD;
    localparam [3:0] INC   = 4'hE;
    localparam [3:0] NEG   = 4'hF;

    localparam [15:0] ZERO = 16'd0;
    localparam [15:0] ONE  = 16'd1;

    reg [15:0] r;
    assign y = r;

    always @* begin
        case (op)
            ADD:     r = a + b;
            SUB:     r = a - b;
            AND:     r = a & b;
            OR:      r = a | b;
            XOR:     r = a ^ b;
            NOT:     r = ~a;
            SHL:     r = a << b[3:0];
            SHR:     r = a >> b[3:0];
            SAR:     r = $signed(a) >>> b[3:0];
            PASSA:   r = a;
            PASSB:   r = b;
            SLT:     r = ($signed(a) < $signed(b)) ? ONE : ZERO;
            SLTU:    r = (a < b) ? ONE : ZERO;
            EQ:      r = (a == b) ? ONE : ZERO;
            INC:     r = a + ONE;
            NEG:     r = -a;
            default: r = ZERO;
        endcase
    end
endmodule
