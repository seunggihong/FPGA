module sp_ram_async_read
#(
	parameter 	N = 8,
				W = 2
) (
	input 			clk,
	input 			we,
	input 	[W-1:0] addr,
	input 	[N-1:0] din,
	output 	[N-1:0] dout
);

reg [N-1:0] ram[2**W-1:0];

always @(posedge clk) begin
	if (we)
		ram[addr] <= din;
end

assign dout = ram[addr];

endmodule