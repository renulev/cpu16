module rf(
    input wire clk,
    input wire rst,
    input wire [3:0] radra,
    output wire [15:0] rdata,
    input wire [3:0] radrb,
    output wire [15:0] rdatb,
    input wire we,
    input wire [3:0] wadr,
    input wire[15:0] wdat
);
    reg [15:0] regs [15:0];
    assign rdata = regs[radra];
    assign rdatb = regs[radrb];
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 16; i = i + 1) regs[i] <= 16'b0;
        end else if (we) begin
            regs[wadr] <= wdat;
        end
    end
endmodule
