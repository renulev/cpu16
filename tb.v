`timescale 1ns/1ps

module tb;
    reg clk;
    reg rst;

    top top(
        .clk(clk),
        .rst(rst)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0, tb);
        rst = 1;
        repeat (2) @(posedge clk);
        #1 rst = 0;
        wait (top.hlt);
        $display("halted at t=%0t, r1 = %0d, dmem[0] = %0d", $time, top.rf.regs[1], top.dmem.mem[0]);
        $finish;
    end

    initial begin
        #1000000;
        $display("timeout");
        $finish;
    end

    always @(posedge clk) begin
        if (!rst && top.cu.state == 3'd4 && top.rd == 4'd1) begin
            #1 $display("t=%0t r1 = %0d", $time, top.rf.regs[1]);
        end
    end
endmodule
