module seq_multiplier #(parameter BIT_WIDTH = 4)
(
    input clk,
    input reset,
    input load,
    input enable,
    input [BIT_WIDTH-1:0] factor1,
    input [BIT_WIDTH-1:0] factor2,
    output [2*BIT_WIDTH-1:0] product
);
reg [BIT_WIDTH*2-1:0] accumulator;
wire [BIT_WIDTH-1:0] Q;
wire [BIT_WIDTH-1:0] accum_factor_sum;
wire [BIT_WIDTH-1:0] adder_out;
reg carry;
reg [$clog2(BIT_WIDTH-1):0] counter = '0;

full_adder #(.BIT_WIDTH(BIT_WIDTH) inst
(
    .a(accumulator[2*BIT_WIDTH-1:BIT_WIDTH]),
    .b(factor1),
    .cin(1'b0),
    .sum(adder_out),
    .cout(carry)
);

always @(posedge clk) begin
    if(reset ) begin
        accumulator <= '0;
        counter <= '0;
    end
    else if(load ) begin
        accumulator <= {{BIT_WIDTH{1'b0}},factor2};
        counter <= '0;
    end
    else if (enable) begin
        accumulator <= {carry,accum_factor_sum,Q[BIT_WIDTH-1:1]};
        counter <= counter + 1;    
    end
end

assign Q = accumulator[BIT_WIDTH-1:0];
assign accum_factor_sum = (Q[0] == 1'b1) ? adder_out : accumulator[2*BIT_WIDTH-1:BIT_WIDTH];
assign product = (counter == BIT_WIDTH) ? accumulator : '0;

endmodule 