module d_latch
# (
    parameter N = 8
) (
    input               c,
    input       [N-1:0] d,
    output reg  [N-1:0] q
);

always @* begin
    if (c)  q = d;
    else    q = q;
end

endmodule