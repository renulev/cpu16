module top(
	input wire clk,
	input wire rst,
	output wire halted
);
	wire [3:0] op;
	wire [3:0] rd;
	wire [3:0] rs;
	wire [3:0] rt;
	wire zero;

	wire irwe;
	wire pcinc;
	wire pcload;
	wire marwe;
	wire rfwe;
	wire dmemwe;
	wire asel;
	wire pcsel;
	wire wsel;
	wire mdsel;
	wire [3:0] raa;
	wire [3:0] rab;
	wire [3:0] aluop;
	wire [2:0] bsel;

	dp dp0(
		.clk(clk),
		.rst(rst),
		.irwe(irwe),
		.pcinc(pcinc),
		.pcload(pcload),
		.marwe(marwe),
		.rfwe(rfwe),
		.dmemwe(dmemwe),
		.asel(asel),
		.pcsel(pcsel),
		.wsel(wsel),
		.mdsel(mdsel),
		.raa(raa),
		.rab(rab),
		.aluop(aluop),
		.bsel(bsel),
		.op(op),
		.rd(rd),
		.rs(rs),
		.rt(rt),
		.zero(zero)
	);

	cu cu0(
		.clk(clk),
		.rst(rst),
		.zero(zero),
		.op(op),
		.rd(rd),
		.rs(rs),
		.rt(rt),
		.halted(halted),
		.irwe(irwe),
		.pcinc(pcinc),
		.pcload(pcload),
		.marwe(marwe),
		.rfwe(rfwe),
		.dmemwe(dmemwe),
		.asel(asel),
		.pcsel(pcsel),
		.wsel(wsel),
		.mdsel(mdsel),
		.raa(raa),
		.rab(rab),
		.aluop(aluop),
		.bsel(bsel)
	);
endmodule
