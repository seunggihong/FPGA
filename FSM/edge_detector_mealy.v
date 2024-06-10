module edge_detector_mealy(
	input 	clk, rstb,
	input 	strobe,
	output 	reg p2
);

localparam 	ZERO = 1'b0,
			ONE = 1'b1;

reg state_reg, state_next;

always @(posedge clk or negedge rstb) begin
	if (~rstb) state_reg <= 0;
	else state_reg <= state_next;
end

always @* begin
	state_next = state_reg;
	p2 = 1'b0;
	case (state_reg)
		ZERO: if (strobe) begin
			state_next = ONE;
			p2 = 1'b1;
		end
		ONE: if (~strobe) state_next = ZERO;
		default: state_next = ZERO;
	endcase
end

endmodule