module d_ff
# (
    parameter N = 8
) (
    input               clk,
    input       [N-1:0] d,
    output reg  [N-1:0] q
)

always @(posedge clk) begin
    q <= d;
end

endmodule