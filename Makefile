SRC = alu.v cu.v dmem.v imem.v ir.v mar.v pc.v rf.v top.v
TB = tb.v
OUT = cpu16.vvp

all: $(OUT)

$(OUT): $(SRC) $(TB)
	iverilog -g2012 -o $(OUT) $(SRC) $(TB)

run: $(OUT)
	vvp $(OUT)

interactive: $(OUT)
	vvp -s $(OUT)

clean:
	rm -f $(OUT) *.vcd

.PHONY: all run interactive clean