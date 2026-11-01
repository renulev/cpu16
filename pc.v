module pc(
    input wire clk,
    input wire rst,
    input wire inc,
    input wire load,
    input wire [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst) q <= 16'b0;
        else if (load) q <= d;
        else if (inc) q <= q + 16'b1;
    end
endmodule
