module dmem(
    input wire clk,
    input wire [15:0] adr,
    output wire [15:0] rdat,
    input wire we,
    input wire [15:0] wdat
);
    reg [15:0] mem [0:65535];
    assign rdat = mem[adr];
    always @(posedge clk) begin
        if (we) mem[adr] <= wdat;
    end
endmodule
