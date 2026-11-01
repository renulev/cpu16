module alu(
    input wire [15:0] a,
    input wire [15:0] b,
    input wire [3:0] op,
    output reg [15:0] y
);
    always @(*) begin
        case (op)
            4'h1: y = a + b;
            4'h2: y = a - b;
            4'h3: y = a & b;
            4'h4: y = a | b;
            4'h5: y = a ^ b;
            default: y = 16'b0;
        endcase
    end
endmodule
