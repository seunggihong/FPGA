module sp_ram_sync_read
#(
	parameter N = 8,
	W = 2
) (
	input 			clk,
	input			we,
	input 	[W-1:0] addr,
	input 	[N-1:0] din,
	output 	[N-1:0] dout
);

reg [N-1:0] ram[2**W-1:0];
reg [W-1:0] addr_reg;

always @(posedge clk) begin
	if (we)
		ram[addr] <= din;
	addr_reg <= addr;
end

assign dout = ram[addr_reg];

endmodule