module imem(
    input wire [15:0] radr,
    output wire [15:0] rdat
);
    reg [15:0] mem [0:65535];
    assign rdat = mem[radr];
    initial $readmemh("program.hex", mem);
endmodule
