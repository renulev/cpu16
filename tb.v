module tb;
    reg clk = 0;
    reg rst = 1;
    wire halted;
    top dut(.clk(clk), .rst(rst), .halted(halted));
    always #5 clk = ~clk;
    initial begin
        #12 rst = 0;
        wait (halted);
        #10 $finish;
    end
endmodule
