module mar(
    input wire clk,
    input wire rst,
    input wire we,
    input wire [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 16'b0;
        else if (we) q <= d;
    end
endmodule