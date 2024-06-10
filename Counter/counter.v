module counter(
	input clk, rstb,
	output reg [3:0] q
);

reg [3:0] q_reg, q_next;

always @(posedge clk or negedge rstb)
	if (~rstb)
		q_reg <= 0;
	else
		q_reg <= q_next;

always @*
	if (q_reg == 0)
		q_next = 0;
	else
		q_next = q_reg + 1;

assign q = q_reg

endmodule