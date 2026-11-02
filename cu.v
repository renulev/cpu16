module cu(
	input wire clk,
	input wire rst,
	input wire zero,
	input wire [3:0] op,
	input wire [3:0] rd,
	input wire [3:0] rs,
	input wire [3:0] rt,
	output wire halted,
	output wire irwe,
	output wire pcinc,
	output wire pcload,
	output wire marwe,
	output wire rfwe,
	output wire dmemwe,
	output wire asel,
	output wire pcsel,
	output wire wsel,
	output wire mdsel,
	output wire [3:0] raa,
	output wire [3:0] rab,
	output wire [3:0] aluop,
	output wire [2:0] bsel
);
	localparam [2:0] FETCH  = 3'd0;
	localparam [2:0] DECODE = 3'd1;
	localparam [2:0] EXEC   = 3'd2;
	localparam [2:0] MEM    = 3'd3;
	localparam [2:0] WB     = 3'd4;
	localparam [2:0] HALT   = 3'd5;

	localparam [3:0] OP_NOP  = 4'h0;
	localparam [3:0] OP_ADD  = 4'h1;
	localparam [3:0] OP_SUB  = 4'h2;
	localparam [3:0] OP_AND  = 4'h3;
	localparam [3:0] OP_OR   = 4'h4;
	localparam [3:0] OP_ALUX = 4'h5;
	localparam [3:0] OP_ADDI = 4'h6;
	localparam [3:0] OP_LDI  = 4'h7;
	localparam [3:0] OP_LUI  = 4'h8;
	localparam [3:0] OP_LD   = 4'h9;
	localparam [3:0] OP_ST   = 4'hA;
	localparam [3:0] OP_BZ   = 4'hB;
	localparam [3:0] OP_BNZ  = 4'hC;
	localparam [3:0] OP_JMP  = 4'hD;
	localparam [3:0] OP_JAL  = 4'hE;
	localparam [3:0] OP_HLT  = 4'hF;

	reg [2:0] state;

	always @(posedge clk) begin
		if (rst) begin
			state <= FETCH;
		end else begin
			case (state)
				FETCH:  state <= DECODE;
				DECODE: begin
					if (op == OP_NOP) state <= FETCH;
					else if (op == OP_HLT) state <= HALT;
					else state <= EXEC;
				end
				EXEC: begin
					if (op == OP_BZ || op == OP_BNZ || op == OP_JMP || op == OP_JAL) state <= FETCH;
					else if (op == OP_LD || op == OP_ST) state <= MEM;
					else state <= WB;
				end
				MEM: begin
					if (op == OP_LD) state <= WB;
					else state <= FETCH;
				end
				WB:     state <= FETCH;
				HALT:   state <= HALT;
				default: state <= FETCH;
			endcase
		end
	end

	wire br = (op == OP_BZ && zero) || (op == OP_BNZ && !zero) || op == OP_JMP || op == OP_JAL;
	wire ldst = (op == OP_LD || op == OP_ST);

	assign halted = (state == HALT);
	assign irwe   = (state == FETCH);
	assign pcinc  = (state == FETCH);
	assign pcload = (state == EXEC) && br;
	assign marwe  = (state == EXEC) && ldst;
	assign rfwe   = (state == WB) || ((state == EXEC) && (op == OP_JAL));
	assign dmemwe = (state == MEM) && (op == OP_ST);

	assign asel  = (op == OP_JAL) || br;
	assign pcsel = (op == OP_JAL) || (op == OP_JMP);
	assign wsel  = (op == OP_LD);
	assign mdsel = (op == OP_LUI);

	assign raa = (op == OP_JAL || br) ? rd : rs;
	assign rab = (op == OP_ST) ? rd : ((op == OP_ADDI || op == OP_LDI || op == OP_LUI || ldst) ? rs : rt);

	assign aluop = (op == OP_ADD || op == OP_ADDI || ldst) ? 4'h0 :
	               (op == OP_SUB)                          ? 4'h1 :
	               (op == OP_AND)                          ? 4'h2 :
	               (op == OP_OR)                           ? 4'h3 :
	               (op == OP_ALUX)                         ? rt :
	               (op == OP_LDI)                          ? 4'hA :
	               (op == OP_LUI)                          ? 4'h6 : 4'h0;

	assign bsel = (op == OP_ADDI) ? 3'd1 :
	              (op == OP_LDI)  ? 3'd2 :
	              (op == OP_LUI)  ? 3'd3 :
	              (op == OP_ST)   ? 3'd4 : 3'd0;
endmodule
