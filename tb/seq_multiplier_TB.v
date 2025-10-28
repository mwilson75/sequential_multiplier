module seq_multiplier_TB();
parameter BIT_LEN = 4;
reg [BIT_LEN*2-1:0] product;
reg [BIT_LEN-1:0] a, b;
reg clk = '0, reset = '1;
reg enable = '0, load = '0;

seq_multiplier UUT
(
    .clk(clk),
    .reset(reset),
    .load(load),
    .enable(enable),
    .factor1(a),
    .factor2(b),
    .product(product)
);

always #1 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");$dumpvars;
    
    #10
    reset = '0;
    #2;
    @(posedge clk);
    a = 2;
    b = 1;
    #1
    load = '1;
    enable = '1;
    #2;
    load = '0;
    #8
    assert(product == 8'h2);
    #1;

    @(posedge clk);
    a = 2;
    b = 2;
    #2;
    load = '1;
    #1 
    load = '0;
    #8
    assert(product == 8'h2);
    #1
    a = 15;
    b = 15;
    #1
    load = '1;
    #2
    load = '0;
    #8
    assert(product == 8'd225);



    #10
    
    $finish;
end

endmodule