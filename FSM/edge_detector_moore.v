module edge_detector_moore(
	input 		clk, rstb,
	input 		strobe,
	output reg 	p1
);

localparam [1:0] 	ZERO = 2'b00,
					EDGE = 2'b01,
					ONE = 2'b10;

reg [1:0] state_reg, state_next;

always @(posedge clk or negedge rstb) begin
	if (~rstb) 	state_reg <= 0;
	else 		state_reg <= state_next;
end

always @* begin
	state_next = state_reg;
	p1 = 1'b0;
	case (state_reg)
		ZERO: if (strobe) state_next = EDGE;
		EDGE: begin
			p1 = 1'b1;
			state_next = strobe ? ONE : ZERO;
		end
		ONE: if (~strobe) state_next = ZERO;
		default: state_next = ZERO;
	endcase
end

endmodule