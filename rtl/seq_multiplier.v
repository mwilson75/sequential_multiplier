module seq_multiplier(
    input clk,
    input reset,
    input load,
    input enable,
    input [3:0] factor1,
    input [3:0] factor2,
    output [7:0] product
);
parameter BIT_DEPTH = 4;
reg [BIT_DEPTH*2-1:0] accumulator;
wire [BIT_DEPTH-1:0] Q;
wire [BIT_DEPTH-1:0] accum_factor_sum;
wire [BIT_DEPTH-1:0] adder_out;
reg carry;
reg [$clog2(BIT_DEPTH-1):0] counter = '0;

full_adder inst(.a(accumulator[7:4]),.b(factor1),.cin(1'b0),.sum(adder_out),.cout(carry));

always @(posedge clk) begin
    if(reset ) begin
        accumulator <= '0;
        counter <= '0;
    end
    else if(load ) begin
        accumulator <= {{BIT_DEPTH{1'b0}},factor2};
        counter <= '0;
    end
    else if (enable) begin
        accumulator <= {carry,accum_factor_sum,Q[3:1]};
        counter <= counter + 1;    
    end
end

assign Q = accumulator[3:0];
assign accum_factor_sum = (Q[0] == 1'b1) ? adder_out : accumulator[7:4];
assign product = (counter == BIT_DEPTH) ? accumulator : '0;

endmodule 