module seq_multiplier_TB();
localparam BIT_WIDTH = 4;
localparam CLK_RATE = 1;
// allow enough clock cycles for the sequential multiplier
// product to be calculated.
localparam  WAIT_AFTER_LOAD = BIT_WIDTH * CLK_RATE * 2;
// ensure `load` is held high for at least one clock rising edge
localparam WAIT_FOR_LOAD= CLK_RATE * 2;  
reg [BIT_WIDTH*2-1:0] product; 
reg [BIT_WIDTH-1:0] factor1, factor2;
reg clk = '0, reset = '1; 
reg enable = '0, load = '0;

  seq_multiplier #(.BIT_WIDTH(BIT_WIDTH)) UUT
(
    .clk(clk),
    .reset(reset),
    .load(load),
    .enable(enable),
    .factor1(factor1),
    .factor2(factor2),
    .product(product)
);

always #CLK_RATE clk = ~clk;

initial begin
    $dumpfile("dump.vcd");$dumpvars;
    
    #10
    reset = '0;
    #2;
    @(posedge clk);
    factor1= 2;
    factor2= 1;
    #1
    load = '1;
    enable = '1;
    // make sure that load is set high for entire clock cycle
    #WAIT_FOR_LOAD; 
    load = '0;
    #WAIT_AFTER_LOAD
    assert(product == factor1 * factor2);
    #1;

    @(posedge clk);
    factor1= 2;
    factor2= 2;
    #2;
    load = '1;
    #WAIT_FOR_LOAD
    load = '0;
    #WAIT_AFTER_LOAD
    assert(product == factor1 * factor2);
    #1
    factor1= '1;
    factor2= '1;
    #1
    load = '1;
    #WAIT_FOR_LOAD
    load = '0;
    #WAIT_AFTER_LOAD
    assert(product == factor1 * factor2);



    #10
    
    $finish;
end

endmodule