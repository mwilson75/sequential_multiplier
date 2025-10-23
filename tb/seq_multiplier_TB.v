module seq_multiplier_TB();
parameter BIT_LEN = 4;
reg [BIT_LEN*2-1:0] product;
reg [BIT_LEN-1:0] a, b;
reg clk = '0;

seq_multiplyer UUT
(
    .clk(clk),
    .factor1(a),
    .factor2(b),
    .product(product)
);

always #1 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");$dumpvars;
    
    #2
    a = 0;
    b = 0;
    assert(product == '0);

    #2
    a = 1;
    b = 1;
    assert(product == (BIT_LEN*2)'h1);

    
    $finish;
end

endmodule