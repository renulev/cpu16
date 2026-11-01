module ir(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [15:0] d,
    output reg [15:0] q,
    output wire [3:0] op,
    output wire [3:0] rd,
    output wire [3:0] rs,
    output wire [3:0] rt
);
    assign op = q[15:12];
    assign rd = q[11:8];
    assign rs = q[7:4];
    assign rt = q[3:0];
    always @(posedge clk) begin
        if (rst) q <= 16'b0;
        else if (we) q <= d;
    end
endmodule
