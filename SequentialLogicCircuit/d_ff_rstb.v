module d_ff_rstb
# (
    parameter N = 8
) (
    input               clk,
	input				rstb,
    input       [N-1:0] d,
    output reg  [N-1:0] q
)

always @(posedge clk or negedge rstb) begin
    if (~rstb) 	q <= 0;
	else		q <= d;
end

endmodule