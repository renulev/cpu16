module dp(
	input wire clk,
	input wire rst,

	input wire irwe,
	input wire pcinc,
	input wire pcload,
	input wire marwe,
	input wire rfwe,
	input wire dmemwe,
	input wire asel,
	input wire pcsel,
	input wire wsel,
	input wire mdsel,
	input wire [3:0] raa,
	input wire [3:0] rab,
	input wire [3:0] aluop,
	input wire [2:0] bsel,

	output wire [3:0] op,
	output wire [3:0] rd,
	output wire [3:0] rs,
	output wire [3:0] rt,
	output wire zero
);
	wire [15:0] pcq;
	wire [15:0] mem_rdat;
	wire [15:0] irq;
	wire [15:0] rdata;
	wire [15:0] rdatb;
	wire [15:0] marq;
	wire [15:0] a;
	wire [15:0] b;
	wire [15:0] y;

	wire [15:0] imm_sign_4 = {{12{rt[3]}}, rt};
	wire [15:0] imm_zero_8 = {8'b0, rs, rt};
	wire [15:0] imm_sign_8 = {{8{rs[3]}}, rs, rt};
	wire [15:0] imm_sign_12 = {{4{rd[3]}}, rd, rs, rt};

	wire [15:0] b_mux = (bsel == 3'd1) ? imm_sign_4 :
						(bsel == 3'd2) ? imm_zero_8 :
						(bsel == 3'd3) ? imm_sign_8 :
						(bsel == 3'd4) ? imm_sign_12 : rdatb;

	assign a = asel ? pcq : rdata;
	assign b = b_mux;

	wire [15:0] pc_d = pcsel ? y : rdata;
	wire [15:0] mar_d = mdsel ? {rdata[7:0], rs, rt} : y;
	wire [15:0] rf_wdat = wsel ? mem_rdat : mar_d;
	wire [15:0] mem_adr = irwe ? pcq : marq;

	assign zero = (rdata == 16'b0);

	pc pc0(
		.clk(clk),
		.rst(rst),
		.inc(pcinc),
		.load(pcload),
		.d(pc_d),
		.q(pcq)
	);

	mem mem0(
		.clk(clk),
		.adr(mem_adr),
		.wdat(rdatb),
		.we(dmemwe),
		.rdat(mem_rdat)
	);

	ir ir0(
		.clk(clk),
		.rst(rst),
		.we(irwe),
		.d(mem_rdat),
		.q(irq),
		.op(op),
		.rd(rd),
		.rs(rs),
		.rt(rt)
	);

	rf rf0(
		.clk(clk),
		.rst(rst),
		.radra(raa),
		.rdata(rdata),
		.radrb(rab),
		.rdatb(rdatb),
		.we(rfwe),
		.wadr(rd),
		.wdat(rf_wdat)
	);

	alu alu0(
		.a(a),
		.b(b),
		.op(aluop),
		.y(y)
	);

	mar mar0(
		.clk(clk),
		.rst(rst),
		.we(marwe),
		.d(mar_d),
		.q(marq)
	);
endmodule
