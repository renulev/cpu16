module mem(
	input wire clk,
	input wire [15:0] adr,
	input wire [15:0] wdat,
	input wire we,
	output wire [15:0] rdat
);
	reg [15:0] mem [0:65535];

	assign rdat = mem[adr];

	always @(posedge clk) begin
		if (we) begin
			mem[adr] <= wdat;
		end
	end

	initial $readmemh("program.hex", mem);
endmodule
