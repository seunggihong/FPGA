module modm_counter_2
#(
	parameter M = 10,
	parameter N = $clog2(M)
) (
	input 			clk, rstb,
	output 	[N-1:0] q,
	output 			max_tick
);

reg [N-1:0] state_reg;
wire [N-1:0] state_next, state_inc;

always @(posedge clk or negedge rstb) begin
	if (~rstb) state_reg <= 0;
	else state_reg <= state_next;
end

assign q = state_reg;
assign max_tick = (state_inc == M) ? 1'b1 : 1'b0;

assign state_inc = state_reg+1;
assign state_next = max_tick ? 0 : state_inc;

endmodule